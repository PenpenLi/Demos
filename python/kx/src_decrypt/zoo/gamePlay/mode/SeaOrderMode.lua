SeaOrderMode = class(OrderMode)

SeaAnimalType = 
{
	kPenguin 	= 1,
	kPenguin_H 	= 2,
	kSeal 		= 3,
	kSeal_V 	= 4,
	kSeaBear 	= 5,

	penguin_flag = 1,
	seal_flag = 2,
	bear_flag = 3,

}

local function isFlagBitSet(flag, bitIndex)
    if bitIndex < 1 then bitIndex = 1 end
    local mask = math.pow(2, bitIndex - 1) -- e.g.: mask: 0010

    local bit = require("bit")
    return mask == bit.band(flag, mask)
end


function SeaOrderMode:initModeSpecial(config)
	
	self.config = config
	self.allSeaAnimals = {}
	OrderMode.initModeSpecial(self, config)
	local _tileMap = config.tileMap
	  for r = 1, #_tileMap do
	    if self.mainLogic.boardmap[r] == nil then self.mainLogic.boardmap[r] = {} end        --地形
	    for c = 1, #_tileMap[r] do
	      local tileDef = _tileMap[r][c]
	      self.mainLogic.boardmap[r][c]:initLightUp(tileDef)              
	    end
	  end
	self:buildSeaAnimalMap(config)
	-- assert(self.mainLogic:areaDevidedByRope(1, 1, 2, 1) == false)
	-- assert(self.mainLogic:areaDevidedByRope(1, 1, 1, 2) == false)
	-- assert(self.mainLogic:areaDevidedByRope(1, 1, 2, 2) == true)
	-- assert(self.mainLogic:areaDevidedByRope(2, 1, 4, 2) == false)
	-- assert(self.mainLogic:areaDevidedByRope(2, 1, 4, 3) == true)
	-- assert(self.mainLogic:areaDevidedByRope(2, 1, 8, 2) == false)
	-- assert(self.mainLogic:areaDevidedByRope(4, 4, 6, 9) == false)
	-- assert(self.mainLogic:areaDevidedByRope(4, 4, 7, 9) == true)
end

function SeaOrderMode:saveDataForRevert(saveRevertData)
	saveRevertData.allSeaAnimals = table.clone(self.allSeaAnimals)
	OrderMode.saveDataForRevert(self, saveRevertData)
end

function SeaOrderMode:revertDataFromBackProp()
	self.allSeaAnimals = self.mainLogic.saveRevertData.allSeaAnimals
	print('self.allSeaAnimals', table.tostring(self.allSeaAnimals))
	OrderMode.revertDataFromBackProp(self)
end

function SeaOrderMode:revertUIFromBackProp()
	OrderMode.revertUIFromBackProp(self)
end


function SeaOrderMode:checkAllLightCount()
  local mainLogic = self.mainLogic
	local countsum = 0
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			local board1 = mainLogic.boardmap[r][c]
			if board1.isUsed == true then
				countsum = countsum + board1.iceLevel
			end
		end
	end
	--print("checkAllIngredientCount", countsum)
	--debug.debug()
	return countsum;
end

function SeaOrderMode:buildSeaAnimalMap(config)
	local mainLogic = self.mainLogic
	local seaAnimalMap = config.seaAnimalMap
	local flagMap = config.seaFlagMap

	local configgedCreatures = {}

	local configgedPenguinCount = 0
	local configgedSealCount = 0
	local configgedBearCount = 0


	-- 初始化配置死的动物
	for rowIndex, row in pairs(seaAnimalMap) do 
		for colIndex, value in pairs(row) do 
			local animal = {}

			animal.x = colIndex
			animal.y = rowIndex

			if value == SeaAnimalType.kPenguin then
				animal.type = SeaAnimalType.kPenguin
				animal.xEnd = animal.x
				animal.yEnd = animal.y + 1
				configgedPenguinCount = configgedPenguinCount + 1

			elseif value == SeaAnimalType.kPenguin_H then
				animal.type = SeaAnimalType.kPenguin_H
				animal.xEnd = animal.x + 1
				animal.yEnd = animal.y
				configgedPenguinCount = configgedPenguinCount + 1

			elseif value == SeaAnimalType.kSeal then
				animal.type = SeaAnimalType.kSeal
				animal.xEnd = animal.x + 2
				animal.yEnd = animal.y + 1
				configgedSealCount = configgedSealCount + 1

			elseif value == SeaAnimalType.kSeal_V then
				animal.type = SeaAnimalType.kSeal_V
				animal.xEnd = animal.x + 1
				animal.yEnd = animal.y + 2
				configgedSealCount = configgedSealCount + 1

			elseif value == SeaAnimalType.kSeaBear then
				animal.type = SeaAnimalType.kSeaBear
				animal.xEnd = animal.x + 2
				animal.yEnd = animal.y + 2
				configgedBearCount = configgedBearCount + 1
			end
			table.insert(configgedCreatures, animal)
		end
	end

	-- 计算一共要生成多少个动物
	local targetPenguinCount = 0
	local targetSealCount = 0
	local targetBearCount = 0
	for k, v in pairs(mainLogic.theOrderList) do 
		if v.key1 == GameItemOrderType.kSeaAnimal then
			if v.key2 == GameItemOrderType_SeaAnimal.kPenguin then
				targetPenguinCount = v.v1
			elseif v.key2 == GameItemOrderType_SeaAnimal.kSeal then
				targetSealCount = v.v1
			elseif v.key2 == GameItemOrderType_SeaAnimal.kSeaBear then
				targetBearCount = v.v1
			end
		end
	end
	-- print('bear', targetBearCount, 'seal', targetSealCount, 'penguin', targetPenguinCount)

	-- 反复尝试生成一个海洋动物的生成方案，直到成功为止
	local count = 0
	while true do 
		count = count + 1
		if count == 1000 then return end
		local penguinOk = true
		local sealOk = true
		local bearOk = true

		local occupiedPenguin = {}
		local occupiedSeal = {}
		local occupiedBear = {}

		-- 先生成熊，因为熊占用的面积最大
		while (configgedBearCount + #occupiedBear < targetBearCount) do 
			local possibleBearPos = self:getSeaAnimalPos(SeaAnimalType.bear_flag, 2, 2, configgedCreatures, occupiedBear)
			if #possibleBearPos > 0 then
				local index = mainLogic.randFactory:rand(1, #possibleBearPos)
				table.insert(occupiedBear, 
					{
						type = SeaAnimalType.kSeaBear, 
						x = possibleBearPos[index].x, 
						y = possibleBearPos[index].y,
						xEnd = possibleBearPos[index].x + 2,
						yEnd = possibleBearPos[index].y + 2,
					})
			else
				bearOk = false
				break
			end
		end

		if bearOk then
			while (configgedSealCount + #occupiedSeal < targetSealCount) do 
				local possibleSealPos = self:getSeaAnimalPos(SeaAnimalType.seal_flag, 2, 1, configgedCreatures, occupiedSeal, occupiedBear)
				local possibleVSealPos = self:getSeaAnimalPos(SeaAnimalType.seal_flag, 1, 2, configgedCreatures, occupiedSeal, occupiedBear)
				if #possibleSealPos <=0 and #possibleVSealPos <= 0 then
					sealOk = false
					break
				end

				if #possibleSealPos > 0 and #possibleVSealPos > 0 then
					if mainLogic.randFactory:rand(0, 1) > 0 then
						local index = mainLogic.randFactory:rand(1, #possibleSealPos)
						table.insert(occupiedSeal, 
							{
								type = SeaAnimalType.kSeal, 
								x = possibleSealPos[index].x, 
								y = possibleSealPos[index].y,
								xEnd = possibleSealPos[index].x + 2,
								yEnd = possibleSealPos[index].y + 1,
							})
					else
						local index = mainLogic.randFactory:rand(1, #possibleVSealPos)
						table.insert(occupiedSeal, 
							{
								type = SeaAnimalType.kSeal_V, 
								x = possibleVSealPos[index].x, 
								y = possibleVSealPos[index].y,
								xEnd = possibleVSealPos[index].x + 1,
								yEnd = possibleVSealPos[index].y + 2,
							})
					end
				elseif #possibleSealPos > 0 then
					local index = mainLogic.randFactory:rand(1, #possibleSealPos)
					table.insert(occupiedSeal, 
						{
							type = SeaAnimalType.kSeal, 
							x = possibleSealPos[index].x, 
							y = possibleSealPos[index].y,
							xEnd = possibleSealPos[index].x + 2,
							yEnd = possibleSealPos[index].y + 1,
						})
				elseif #possibleVSealPos > 0 then
					local index = mainLogic.randFactory:rand(1, #possibleVSealPos)
					table.insert(occupiedSeal, 
						{
							type = SeaAnimalType.kSeal_V, 
							x = possibleVSealPos[index].x, 
							y = possibleVSealPos[index].y,
							xEnd = possibleVSealPos[index].x + 1,
							yEnd = possibleVSealPos[index].y + 2,
						})
				end
			end
		end

		if bearOk and sealOk then
			while (configgedPenguinCount + #occupiedPenguin < targetPenguinCount) do 
				local possiblePenguinPos = self:getSeaAnimalPos(SeaAnimalType.penguin_flag, 0, 1, configgedCreatures, occupiedSeal, occupiedPenguin, occupiedBear)
				local possibleHPenguinPos = self:getSeaAnimalPos(SeaAnimalType.penguin_flag, 1, 0, configgedCreatures, occupiedSeal, occupiedPenguin, occupiedBear)

				-- print('possiblePenguinPos')
				-- print(table.tostring(possiblePenguinPos))
				-- print('possibleHPenguinPos')
				-- print(table.tostring(possibleHPenguinPos))

				if #possiblePenguinPos <=0 and #possibleHPenguinPos <= 0 then
					penguinOk = false
					break
				end

				if #possiblePenguinPos > 0 and #possibleHPenguinPos > 0 then
					if mainLogic.randFactory:rand(0, 1) > 0 then
						local index = mainLogic.randFactory:rand(1, #possiblePenguinPos)
						table.insert(occupiedPenguin, 
							{
								type = SeaAnimalType.kPenguin, 
								x = possiblePenguinPos[index].x, 
								y = possiblePenguinPos[index].y,
								xEnd = possiblePenguinPos[index].x,
								yEnd = possiblePenguinPos[index].y + 1,
							})
					else
						local index = mainLogic.randFactory:rand(1, #possibleHPenguinPos)
						table.insert(occupiedPenguin, 
							{
								type = SeaAnimalType.kPenguin_H, 
								x = possibleHPenguinPos[index].x, 
								y = possibleHPenguinPos[index].y,
								xEnd = possibleHPenguinPos[index].x + 1,
								yEnd = possibleHPenguinPos[index].y,
							})
					end
				elseif #possiblePenguinPos > 0 then
					local index = mainLogic.randFactory:rand(1, #possiblePenguinPos)
					table.insert(occupiedPenguin, 
						{
							type = SeaAnimalType.kPenguin, 
							x = possiblePenguinPos[index].x, 
							y = possiblePenguinPos[index].y,
							xEnd = possiblePenguinPos[index].x,
							yEnd = possiblePenguinPos[index].y + 1,
						})
				elseif #possibleHPenguinPos > 0 then
					local index = mainLogic.randFactory:rand(1, #possibleHPenguinPos)
					table.insert(occupiedPenguin, 
						{
							type = SeaAnimalType.kPenguin_H, 
							x = possibleHPenguinPos[index].x, 
							y = possibleHPenguinPos[index].y,
							xEnd = possibleHPenguinPos[index].x + 1,
							yEnd = possibleHPenguinPos[index].y,
						})
				end
			end
		end

		-- print('bearOk', bearOk, 'sealOk', sealOk, 'penguinOk', penguinOk)

		if bearOk and sealOk and penguinOk then
			for k, v in pairs(configgedCreatures) do
				table.insert(self.allSeaAnimals, v)
			end

			for k, v in pairs(occupiedBear) do
				table.insert(self.allSeaAnimals, v)
			end

			for k, v in pairs(occupiedSeal) do
				table.insert(self.allSeaAnimals, v)
			end

			for k, v in pairs(occupiedPenguin) do
				table.insert(self.allSeaAnimals, v)
			end

			-- print('allSeaAnimals', table.tostring(self.allSeaAnimals))
			
			break
		end
	end

	for k, v in pairs(self.allSeaAnimals) do
		local item = self.mainLogic.boardmap[v.y][v.x]
		if item then 
			item:initSeaAnimal(v.type)
		end
	end

end

function SeaOrderMode:getSeaAnimalPos(flag, xAdd, yAdd, ...)

	local result = {}
	local gameItemMap = self.mainLogic.gameItemMap
	local flagMap = self.config.seaFlagMap

	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			if flagMap[r] and flagMap[r][c] then
				local canPutFlag = self.mainLogic:isItemInTile(r, c) and not self.mainLogic:areaDevidedByRope(c, r, c + xAdd, r + yAdd)

				if canPutFlag then
					for yIndex = r, r + yAdd do
						for xIndex =c, c + xAdd do
							if xIndex > 9 or yIndex > 9 then
								canPutFlag = false
								break
							end

							if flagMap[yIndex] and flagMap[yIndex][xIndex] then
								-- if flag == SeaAnimalType.seal_flag then
								-- 	print('isFlagBitSet', flagMap[r][c], isFlagBitSet(flagMap[r][c], flag))
								-- end
								if isFlagBitSet(flagMap[yIndex][xIndex], flag) then
									for k, arg in pairs({...}) do
										if self:hasGridOccupied(xIndex, yIndex, arg) then
											canPutFlag = false
											break
										end
									end
								else
									canPutFlag = false
									break
								end
							else
								canPutFlag = false
								break
							end
							if not canPutFlag then break end
						end
						if not canPutFlag then break end
					end
				end
				if canPutFlag then
					table.insert(result, {x = c, y = r})
				end
			end
		end

	end
	return result
end

function SeaOrderMode:hasGridOccupied(x, y, occupiedAnimal)
	for k, v in pairs(occupiedAnimal) do
		if x >= v.x and x <= v.xEnd and y >= v.y and y <= v.yEnd then
			return true
		end
	end
	return false
end
