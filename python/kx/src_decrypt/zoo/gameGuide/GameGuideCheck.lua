require "zoo.gameGuide.GameGuideData"

GameGuideCheck = class()

function GameGuideCheck:verifyGuideConditions(guides)
	local checkList = {}
	for k, v in pairs(guides) do
		checkList = {}
		if #v.appear <= 0 then
			assert(false, "Empty appear list! index: "..tostring(k))
			debug.debug()
			return
		end
		for i, v in ipairs(v.appear) do
			if not v.type then
				assert(false, "Appear condition without type! index: "..tostring(k))
				debug.debug()
				return
			end
			if checkList[v.type] == true then
				assert(false, "Repeat appear condition in Guides! index: "..tostring(k))
				debug.debug()
				return
			end
			if type(self[v.type]) ~= "function" then
				assert(false, "Unsupported appear type by GameGuide! index/type: "..
					tostring(index)..'/'..tostring(v.type))
				debug.debug()
				return
			end
			checkList[v.type] = true
		end
		checkList = {}
		for i, v in ipairs(v.appear) do
			if not v.type then
				assert(false, "Disappear condition without type! index: "..tostring(k))
				debug.debug()
				return
			end
			if checkList[v.type] == true then
				assert(false, "Repeat disappear condition in Guides! index: "..tostring(k))
				debug.debug()
				return
			end
			if type(self[v.type]) ~= "function" then
				assert(false, "Unsupported disappear type by GameGuide! index/type: "..
					tostring(index)..'/'..tostring(v.type))
				debug.debug()
				return
			end
			checkList[v.type] = true
		end
	end
end

function GameGuideCheck:checkAppear(guide, paras, index)
	for i, v in ipairs(guide.appear) do
		if type(self[v.type]) == "function" then
			if not self[v.type](self, index, v, paras) then
				return false
			end
		else
			assert(false, "Unsupported appear type by GameGuide! index/type: "..
				tostring(index)..'/'..tostring(v.type))
		end
	end
	return true
end

function GameGuideCheck:checkDisappear(guide, paras, index)
	for i, v in ipairs(guide.disappear) do
		if type(self[v.type]) == "function" then
			if self[v.type](self, index, v, paras) then
				return true
			end
		else
			assert(false, "Unsupported disappear type by GameGuide! index/type: "..
				tostring(index)..'/'..tostring(v.type))
		end
	end
	return false
end

function GameGuideCheck:checkFixedAppears(guide, list, paras, index)
	local checkList = {}
	for i, v in ipairs(list) do
		checkList[v.type] = {condition = v.condition, force = v.force, check = false}
	end

	for i, v in ipairs(guide.appear) do
		if checkList[v.type] then
			checkList[v.type].check = true
			if type(self[v.type]) == "function" then
				if not self[v.type](self, index, checkList[v.type].condition or v, paras) then
					return false
				end
			else
				assert(false, "Unsupported disappear type by GameGuide! index/type: "..
					tostring(index)..'/'..v.type)
			end
		end
	end

	for k, v in pairs(checkList) do
		if not v.check and v.force then
			return false
		end
	end

	return true
end

function GameGuideCheck:noPopup(index, condition, paras)
	return GameGuideData:sharedInstance():getPopups() <= 0
end

function GameGuideCheck:scene(index, condition, paras)
	local data = GameGuideData:sharedInstance()
	if condition.scene ~= data:getScene() then return false end
	if condition.scene == "game" then
		if type(condition.para) == "number" and condition.para ~= data:getLevelId() then return false end
		if type(condition.para) == "table" and not table.exist(condition.para, data:getLevelId()) then return false end
	end
	return true
end

function GameGuideCheck:topLevel(index, condition, paras)
	local topLevelId = UserManager:getInstance().user:getTopLevelId()
	return topLevelId == condition.para
end

-- actWin.para is now used as levelId@startGamePanel only.
function GameGuideCheck:popup(index, condition, paras)
	local data = GameGuideData:sharedInstance()
	if data:getPopups() == 0 or not paras or not paras.actWin then return false end
	if condition.popup and condition.popup ~= paras.actWin.panelName then return false end
	if condition.para and condition.para ~= paras.actWin.levelId then return false end
	return true
end

function GameGuideCheck:popdown(index, condition, paras)
	return paras and paras.actWin and paras.actWin.panelName == condition.popdown
end

function GameGuideCheck:numMoves(index, condition, paras)
	return GameGuideData:sharedInstance():getNumMoves() == condition.para
end

function GameGuideCheck:staticBoard(index, condition, paras)
	return GameGuideData:sharedInstance():getGameStable()
end

function GameGuideCheck:onceOnly(index, condition, paras)
	return not GameGuideData:sharedInstance():containInGuidedIndex(index)
end

function GameGuideCheck:onceLevel(index, condition, paras)
	return not GameGuideData:sharedInstance():containInGuideInLevel(index)
end

function GameGuideCheck:getItem(index, condition, paras)
	return paras and condition.item == paras.item
end

function GameGuideCheck:curLevelGuided(index, condition, paras)
	for k, v in ipairs(condition.guide) do
		if not GameGuideData:sharedInstance():getCurLevelGuide(v) then return false end
	end
	return true
end

function GameGuideCheck:button(index, condition, paras)
	return GameGuideData:sharedInstance():containInHomeSceneButton(condition.button)
end

function GameGuideCheck:halloweenBoss(index, condition, paras)
	return GameGuideData:sharedInstance():containInGameFlags("halloweenBossFirstComeout")
end

function GameGuideCheck:goldZongzi(index, condition, paras)
	return GameGuideData:sharedInstance():containInGameFlags("goldZongziAppear")
end

function GameGuideCheck:waitSignal(index, condition, paras)
	return GameGuideData:sharedInstance():containInGameFlags(condition.name) == condition.value
end

function GameGuideCheck:swap(index, condition, paras)
	local para1, para2 = paras[1], paras[2]
	if not condition.from or not condition.to then return true end
	if type(para1) ~= "table" or type(para1.x) ~= "number" or type(para1.y) ~= "number" or
		type(para2) ~= "table" or type(para2.x) ~= "number" or type(para2.y) ~= "number" then
		return false
	end
	return (para1.x == condition.from.x and para1.y == condition.from.y and
		para2.x == condition.to.x and para2.y == condition.to.y) or
		(para2.x == condition.from.x and para2.y == condition.from.y and
		para1.x == condition.to.x and para1.y == condition.to.y)
end

function GameGuideCheck:topPassedLevel(index, condition, paras)
	local level = 0
	for k, v in ipairs(UserManager:getInstance():getScoreRef()) do
		if v.star > 0 and v.levelId < 10000 and level < v.levelId then level = v.levelId end
	end
	return condition.para == level
end

function GameGuideCheck:hasGuide(index, condition, paras)
	for i, v in ipairs(condition.guideArray) do
		if not GameGuideData:sharedInstance():containInGuidedIndex(v) then
			return false
		end
	end
	return true
end