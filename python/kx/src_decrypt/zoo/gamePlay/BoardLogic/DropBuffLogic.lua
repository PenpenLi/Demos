DropBuffLogic = class()

local DropBuffLogicDebugMode = true

function DropBuffLogic:ctor()
	self.mainLogic = nil
	self.dropBuff = nil
	self.dropBuffEnable = false
	self.canBeTriggered = false
	self.orderColorList = {}
end

function DropBuffLogic:init(mainLogic, config)
	assert(mainLogic)

	self.mainLogic = mainLogic
	self.dropBuff = config.dropBuff
	-- 概率为浮点数时解析出来为string类型
	if self.dropBuff then
		self.dropBuff.toRate = tonumber(self.dropBuff.toRate)
	end
	self.totalWeight = 0

	self.canBeTriggered = self:checkIfCanBeTriggered(mainLogic.level)
	self:initOrderColorList(config)
end

function DropBuffLogic:initOrderColorList(config)
	if config.orderMap then
		local list = {}
        for k,v in pairs(config.orderMap) do
            local ts1 = 0
            local ts2 = 0
            local ts3 = 0
            for k2,v2 in pairs(v) do
                if k2 == "k" then
                    local thestrings = v2:split("_")
                    ts1 = tonumber(thestrings[1])
                    ts2 = tonumber(thestrings[2])
                    if ts1 == GameItemOrderType.kAnimal then
                    	table.insert(list, ts2)
                    end
                end
            end
        end
   	 	self.orderColorList = list
    end
end

function DropBuffLogic:create(mainLogic, dropBuff)
	local logic = DropBuffLogic.new()
	logic:init(mainLogic, dropBuff)
	return logic
end

function DropBuffLogic:setDropBuffEnable(isEnable)
	if self.canBeTriggered then
		print("setDropBuffEnable:", isEnable)
		self.dropBuffEnable = isEnable

		if DropBuffLogicDebugMode then
			self:updateDropBuffLabelStatus()
		end
	end
end

function DropBuffLogic:checkIfCanBeTriggered(levelId)
	if not MaintenanceManager:isEnabled("DropBuffEnable") then
		return false
	end

	if self.dropBuff and table.size(self.dropBuff) > 0 then -- 有神奇掉落规则
		local topLevelId = UserManager:getInstance().user:getTopLevelId()
		if topLevelId == levelId then -- 最高关卡
			local score = UserManager:getInstance():getUserScore( topLevelId )
			if not score or score.star < 1 then -- 尚未通过此关
				local topLevelFailCount = UserManager:getInstance().userExtend.topLevelFailCount
				if topLevelFailCount > self.dropBuff.failTriggerNum then -- 连续失败次数达到触发条件
					return true
				end	
			end
		end
	end
	return false
end

function DropBuffLogic:onGameInit(realCostMove)
	realCostMove = realCostMove or 0
	if self.canBeTriggered and realCostMove == self.dropBuff.startMove then
		self:recalcColorDropWeights()
		self:setDropBuffEnable(true)
	end
end

function DropBuffLogic:onUseMoves(realCostMove)
	if self.canBeTriggered then
		if not self.dropBuffEnable and realCostMove == self.dropBuff.startMove then
			self:recalcColorDropWeights()
			self:setDropBuffEnable(true)
		end
		if self.dropBuffEnable and realCostMove == self.dropBuff.endMove + 1 then
			self:setDropBuffEnable(false)
		end
	end
end

function DropBuffLogic:onAnimalOrderCompleted(colors)
	-- print("onAnimalOrderCompleted:", table.tostring(colors))
	if not self.dropBuffEnable or not colors or #colors < 1 then 
		return 
	end

	local dropAnimalOrder = false
	for _, color in pairs(colors) do
		if self:isColorInMapColorList(color) then
			dropAnimalOrder = true
			break
		end
	end
	if dropAnimalOrder then
		self:recalcColorDropWeights()
	end
end

-- [key = weight], return keys
function DropBuffLogic:randomWithWeights(weights, retNum)
	assert(type(weights) == "table")
	retNum = retNum or 1
	local retIndexs = {}
	if table.size(weights) <= retNum then
		for k, _ in pairs(weights) do
			table.insert(retIndexs, k)
		end
	else
		local totalWeight = 0
		for k, v in pairs(weights) do
			totalWeight = totalWeight + v
		end
		local temp = {}
		while table.size(retIndexs) < retNum do
			local random = self.mainLogic.randFactory:rand(1, totalWeight)
			for k, v in pairs(weights) do
				if not temp[k] then
					random = random - v
					if random <= 0 then
						temp[k] = true
						table.insert(retIndexs, k)
						totalWeight = totalWeight - v
						break
					end
				end
			end
		end
	end
	return retIndexs
end

-- return keys of list
function DropBuffLogic:randomFromList(list, retNum)
	assert(type(list) == "table")
	if #list < 1 then return {} end

	local listWithWeight = {}
	for k, _ in pairs(list) do
		listWithWeight[k] = 1
	end
	return self:randomWithWeights(listWithWeight, retNum)
end

function DropBuffLogic:randomColor()
	local color = nil
	if self.dropBuffEnable then
		if self.totalWeight > 0 then
			-- print("randomColor with new weights!!")
			local random = self.mainLogic.randFactory:rand(1, self.totalWeight)
			for index, v in pairs(self.dropBuffWeights) do
				random = random - v
				if random <= 0 then 
					color = self.mainLogic.mapColorList[index] 
					break
				end
			end
		end
	end
	if not color then
		-- print("randomColor with default weights!!")
		local x = self.mainLogic.randFactory:rand(1, #self.mainLogic.mapColorList)
		color = self.mainLogic.mapColorList[x]
	end

	if DropBuffLogicDebugMode then
		self:testColorStat(color)
	end

	return color
end

function DropBuffLogic:isColorInMapColorList( colorType )
	if type(colorType) ~= "number" then
		return false
	end
	for _, v in pairs(self.mainLogic.mapColorList) do
		if v == colorType then return true end
	end
	return false
end

function DropBuffLogic:getOrderData(color)
	if color and self.mainLogic.theOrderList then
		for _, v in pairs(self.mainLogic.theOrderList) do
			if v.key1 == GameItemOrderType.kAnimal and v.key2 == color then
				return v
			end
		end
	end
	return nil
end

function DropBuffLogic:randomTargetColors()
	local lastChangeRateColors = self.changeRateColors or {}
	-- 指定消除未完成的颜色
	local targetColors = {}
	local theOrderList = self.mainLogic.theOrderList or {}
	for _, color in pairs(self.orderColorList) do
		if self:isColorInMapColorList(color) then -- 过滤掉不在生成颜色中的目标颜色
			local order = self:getOrderData(color)
			if not order or (order.f1 < order.v1) then
				table.insert(targetColors, color)
			end
		end
	end

	local ret = {}
	if #targetColors > 0 then -- 还有未收集完的消除目标
		local targetColorsNotHandled = {}
		-- 优先之前随机到的颜色
		for _, color in pairs(targetColors) do
			if lastChangeRateColors[color] then 
				table.insert(ret, color)
			else
				table.insert(targetColorsNotHandled, color)
			end
		end
		-- 如果还有需要，从剩下的未完成目标中随机
		local moreColors = self.dropBuff.colorNum - table.size(ret)
		if moreColors > 0 and #targetColorsNotHandled > 0 then -- 从剩余未完成的颜色中随机
			local randIndexs = self:randomFromList(targetColorsNotHandled, moreColors)
			for _, index in pairs(randIndexs) do
				local color = targetColorsNotHandled[index]
				table.insert(ret, color)
			end
		end
	end 
	return ret
end

function DropBuffLogic:recalcColorDropWeights()
	if not self.dropBuff or table.size(self.dropBuff) < 1 then -- 没有配置dropBuff
		return 
	end

	if self.dropBuff.colorNum >= #self.mainLogic.mapColorList then -- 产品保证配置数量正确
		return
	end
	self.dropBuffWeights = {}
	local changeRateColors = {}

	if self.dropBuff.toRate >= (100 / #self.mainLogic.mapColorList) then -- 只有调高概率时优先考虑消除目标
		local randTargetColors = self:randomTargetColors()
		for _, color in pairs(randTargetColors) do
			changeRateColors[color] = true
		end
		-- print("randTargetColors:", table.tostring(randTargetColors))
	end

	-- 剩余的从其他颜色中随机
	local moreColors = self.dropBuff.colorNum - table.size(changeRateColors)
	if moreColors > 0 then
		local leftColorsWithWeight = {}
		-- 筛选出尚未随机到的颜色
		for _, v in pairs(self.mainLogic.mapColorList) do
			if not changeRateColors[v] then
				leftColorsWithWeight[v] = 1 -- weight = 1
			end
		end
		-- 从中随机n种
		local randColors = self:randomWithWeights(leftColorsWithWeight, moreColors)
		for _, v in pairs(randColors) do
			changeRateColors[v] = true
		end
	end

	-- 计算调整后的概率 out of 1000
	local weight = math.floor(self.dropBuff.toRate * 10) 
	local othersWeight = (100 - self.dropBuff.toRate * self.dropBuff.colorNum ) / (#self.mainLogic.mapColorList - self.dropBuff.colorNum) * 10
	othersWeight = math.floor(othersWeight)

	local totalWeight = 0
	for i, v in ipairs(self.mainLogic.mapColorList) do
		if changeRateColors[v] then
			table.insert(self.dropBuffWeights, weight)
			totalWeight = totalWeight + weight
		else
			table.insert(self.dropBuffWeights, othersWeight)
			totalWeight = totalWeight + othersWeight
		end
	end

	self.totalWeight = totalWeight
	self.changeRateColors = changeRateColors

	-- print("changeRateColors:", table.tostring(changeRateColors))
	-- print("mapColorList:", table.tostring(self.mainLogic.mapColorList))
	print("recalcColorDropWeights:", table.tostring(self.dropBuffWeights))

	if DropBuffLogicDebugMode then
		self:testColorStatClean()
		self:updateDropBuffAnimals(changeRateColors)
	end
end

-----------------------------------
-- 以下为调试代码
-----------------------------------

function DropBuffLogic:testColorStat(color)
	self.colorStat = self.colorStat or {}
	self.colorStat[color] = self.colorStat[color] and self.colorStat[color] + 1 or 1
	local totalCount = 0
	for c, v in pairs(self.colorStat) do
		totalCount = totalCount + v
	end

	if self.displayLayer and not self.displayLayer.isDisposed then
		for c, label in pairs(self.displayLayer.colorPercentLabels) do
			local num = self.colorStat[c] or 0
			label:setString(string.format("%.2f%%", num / totalCount * 100))
		end
		for c, label in pairs(self.displayLayer.colorNumLabels) do
			local num = self.colorStat[c] or 0
			label:setString(string.format("%d", num))
		end
	end
	-- print("--------------------------------------")
	-- for c, v in pairs(self.colorStat) do
	-- 	print(string.format("color:%2d\t%3d\t%.2f%%", c, v, v / totalCount * 100))
	-- end
	-- print("--------------------------------------")
end

function DropBuffLogic:testColorStatClean()
	self.colorStat = {}
	if self.displayLayer and not self.displayLayer.isDisposed then
		for _, v in pairs(self.displayLayer.colorPercentLabels) do
			v:setString(string.format("%.2f%%", 0))
		end
		for _, v in pairs(self.displayLayer.colorNumLabels) do
			v:setString(string.format("%d", 0))
		end
	end
end

function DropBuffLogic:updateDropBuffAnimals(colors)
	colors = colors or {}
	if self.displayLayer and not self.displayLayer.isDisposed then
		local colorsFlag = {}
		for c, _ in pairs(colors) do
			colorsFlag[c] = true
		end
		
		for k, v in pairs(self.displayLayer.colorPercentLabels) do
			if colorsFlag[k] then
				v:setColor(ccc3(255, 255, 0))
			else
				v:setColor(ccc3(255, 255, 255))
			end
		end
		for k, v in pairs(self.displayLayer.colorNumLabels) do
			if colorsFlag[k] then
				v:setColor(ccc3(255, 255, 0))
			else
				v:setColor(ccc3(255, 255, 255))
			end
		end

	end
end

function DropBuffLogic:updateDropBuffLabelStatus()
	if self.displayLayer and not self.displayLayer.isDisposed then
		if self.dropBuffEnable then
			local text = string.format("规则已生效,%d种颜色概率变为%.2f%%", self.dropBuff.colorNum, self.dropBuff.toRate)
			self.displayLayer.statusLabel:setString(text)
		else
			self.displayLayer.statusLabel:setString("规则已失效")
		end
	end
end

function DropBuffLogic:setDropStatDisplayLayer( displayLayer )
	if not displayLayer then return end
	
	local itemsName = { "horse", "frog", "bear", "cat", "fox", "chicken"}
	self.displayLayer = displayLayer
	self.displayLayer.statusLabel = TextField:create("规则尚未启用", nil, 26)
	self.displayLayer.statusLabel:setAnchorPoint(ccp(0, 1))
	self.displayLayer.statusLabel:setPosition(ccp(10, 110))
	self.displayLayer.statusLabel:setColor(ccc3(255, 255, 0))
	self.displayLayer:addChild(self.displayLayer.statusLabel)
	self.displayLayer.colorPercentLabels = {}
	self.displayLayer.colorNumLabels = {}
	local index = 0
	for _, colortype in pairs(self.mainLogic.mapColorList) do
		local char = TileCharacter:create(itemsName[colortype])
		local position = ccp(index * 110 + 60, 50)
		char:setPosition(position)
		char:setScale(0.7)
		self.displayLayer:addChild(char)

		local colorPercentLabel = TextField:create("", nil, 24)
		colorPercentLabel:setAnchorPoint(ccp(0.4, 0))
		colorPercentLabel:setPosition(ccp(position.x, position.y - 50))
		self.displayLayer:addChild(colorPercentLabel)
		self.displayLayer.colorPercentLabels[colortype] = colorPercentLabel

		local colorNumLabel = TextField:create("", nil, 24)
		colorNumLabel:setAnchorPoint(ccp(0, 0.5))
		colorNumLabel:setPosition(ccp(position.x + 30, position.y))
		self.displayLayer:addChild(colorNumLabel)
		self.displayLayer.colorNumLabels[colortype] = colorNumLabel

		index = index + 1
	end

	if self.dropBuffEnable then
		self:updateDropBuffLabelStatus()
		self:updateDropBuffAnimals(self.changeRateColors)
	end
end
