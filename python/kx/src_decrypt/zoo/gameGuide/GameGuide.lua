require "hecore.utils"
require "zoo.data.UserManager"
require "zoo.gameGuide.Guides"
require "zoo.gameGuide.GameGuideData"
require "zoo.gameGuide.GameGuideCheck"
require "zoo.gameGuide.GameGuideRunner"

if PublishActUtil:isGroundPublish() then return end
GameGuide = class{}

local guide = nil
function GameGuide:sharedInstance()
	if not guide then
		guide = GameGuide.new()
		if guide:init() then
			return guide
		end
		return nil
	end
	return guide
end

function GameGuide:ctor()
	GameGuideData:sharedInstance()
end

function GameGuide:init()
	local data = GameGuideData:sharedInstance()
	if __WIN32 then GameGuideCheck:verifyGuideConditions(Guides) end
	data:setGuides(Guides)
	data:setGuideSeed(GuideSeeds)
	data:readFromFile()
	return true
end

function GameGuide:currentGuideType()
	local action = GameGuideData:sharedInstance():getRunningAction()
	if not action then return nil end
	return action.type
end

-- 进入藤蔓界面
function GameGuide:onEnterWorldMap()
	local data = GameGuideData:sharedInstance()
	data:setScene("worldMap")
	data:resetLevelId()
	data:resetNumMoves()
	data:resetSkipLevel()
	data:resetGameFlags()
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 强行停止现有引导
function GameGuide:forceStopGuide()
	GameGuideData:sharedInstance():setForceStop(true)
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 尝试开始一个新引导
function GameGuide:tryStartGuide()
	GameGuideData:sharedInstance():resetForceStop()
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 弹出窗口
function GameGuide:onPopup(panel)
	local data = GameGuideData:sharedInstance()
	data:setPopups(data:getPopups() + 1)
	local para = {actWin = panel}
	self:tryEndCurrentGuide(para)
	return self:tryRunNewGuide(para)
end

-- 窗口消失
function GameGuide:onPopdown(panel)
	local data = GameGuideData:sharedInstance()
	data:setPopups(data:getPopups() - 1)
	local para = {actWin = panel}
	self:tryEndCurrentGuide(para)
	return self:tryRunNewGuide(para)
end

-- 游戏初始化
function GameGuide:onGameInit(level)
	local data = GameGuideData:sharedInstance()
	data:setScene("game")
	data:setLevelId(level)
	data:resetNumMoves()
	data:resetSkipLevel()
	data:resetGameFlags()
	data:resetGuideInLevel()
	data:resetCurLevelGuide()
	self:tryEndCurrentGuide()
	self:tryRunNewGuide()
	if self:checkHaveGuide(level) then return data:getGuideSeedByLevelId(level)
	else return 0 end
end

-- 游戏进入后动画播放结束
function GameGuide:onGameAnimOver()
	local data = GameGuideData:sharedInstance()
	data:setScene("game")
	data:setNumMoves(0)
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 进行了一次交换
function GameGuide:onGameSwap(from, to)
	local data = GameGuideData:sharedInstance()
	data:setScene("game")
	data:setGameStable(false)
	data:setNumMoves(data:getNumMoves() + 1)
	self:tryEndCurrentGuide({from, to})
	return self:tryRunNewGuide({from, to})
end

function GameGuide:onHalloweenBossFirstComeout(pos)
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("halloweenBossFirstComeout")
	local array = data:getGuideActionById(220001, 1).array[1]
	data:getGuides()[220001].action[6] = nil
	array.r = pos.r + 1
	array.c = pos.c
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:onGoldZongziAppear(pos)
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("goldZongziAppear")
	local array = data:getGuideActionById(220002, 1).array[1]
	data:getGuides()[220002].action[6] = nil
	array.r = pos.r
	array.c = pos.c
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:tryFirstQuestionMark(mainLogic)
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("firstQuestionMark")
	local row, col = 0, 0
	local found = false
	for r = #mainLogic.gameItemMap, 1, -1  do
		for c = 1, #mainLogic.gameItemMap[r] do 
			local item = mainLogic.gameItemMap[r][c]
			if item.ItemType == GameItemType.kQuestionMark then
				row = r
				col = c
				found = true
				break
			end
		end
		if found == true then break end
	end

	data:getGuideActionById(210001, 1).array[1].r = row
	data:getGuideActionById(210001, 1).array[1].c = col
	data:getGuideActionById(210001, 1).panPosY = row - data:getGuideActionById(210001, 1).offsetY
	self:tryEndCurrentGuide()
	local guide = self:tryRunNewGuide()
	data:removeFromGameFlags("firstQuestionMark")
	return guide
end

function GameGuide:onFirstShowFirework(pos)
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("firstShowFirework")
	data:getGuideActionById(210000, 1).position = pos
	self:tryEndCurrentGuide()
	local newGuide = self:tryRunNewGuide()
	data:removeFromGameFlags("firstShowFirework")
	return newGuide
end

function GameGuide:tryFirstFullFirework(pos)
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("firstFullFirework")
	data:getGuideActionById(210002, 1).position = pos
	self:tryEndCurrentGuide()
	local newGuide = self:tryRunNewGuide()
	data:removeFromGameFlags("firstFullFirework")
	return newGuide
end

function GameGuide:onShowFullFireworkTip(pos)
	local data = GameGuideData:sharedInstance()
	if not data:containInGuidedIndex(210002) then -- 将首次引导置为不可用
		data:addToGuidedIndex(210002)
		data:writeToFile()
	end

	data:addToGameFlags("showFullFireworkTip")
	self:tryEndCurrentGuide()
	local newGuide = self:tryRunNewGuide()
	data:removeFromGameFlags("showFullFireworkTip")
	return newGuide
end

-- 游戏中获得了一个道具
function GameGuide:onGetGameItem(itemType)
	local data = GameGuideData:sharedInstance()
	data:setGameStable(true)
	local para = {item = itemType}
	self:tryEndCurrentGuide(para)
	local res = self:tryRunNewGuide(para)
	return res
end

-- 游戏达到稳定状态
function GameGuide:onGameStable()
	local data = GameGuideData:sharedInstance()
	data:setScene("game")
	data:setGameStable(true)
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 离开游戏
function GameGuide:onExitGame()
	local data = GameGuideData:sharedInstance()
	data:resetScene()
	data:resetNumMoves()
	data:resetSkipLevel()
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 尝试进行一个新的引导
function GameGuide:tryRunNewGuide(paras)
	local data = GameGuideData:sharedInstance()
	if data:getRunningGuide() then return end
	data:setGuideIndex(self:getFirstGuide(paras))
	if data:getRunningGuide() then
		data:setActionIndex(1)
		GameGuideRunner:runGuide(paras)
		if not data:getRunningGuide() or not data:getGuideIndex() then return false end
		data:addToGuideInLevel(data:getGuideIndex())
		return data:getRunningAction().type ~= "clickFlower" and
			data:getRunningAction().type ~= "startPanel" and
			data:getRunningAction().type ~= "showHint"
	end
	return false
end

-- 尝试结束一个引导
function GameGuide:tryEndCurrentGuide(paras)
	local data = GameGuideData:sharedInstance()
	if not data:getRunningGuide() then return end
	if self:checkDisappear(paras) then
		local rec, success = GameGuideRunner:removeGuide(paras)
		if rec then
			if not data:containInGuidedIndex(data:getGuideIndex()) then
				data:addToGuidedIndex(data:getGuideIndex())
				DcUtil:tutorialStep(data:getGuideIndex())
				if table.size(data:getGuidedIndex()) >= table.size(data:getGuides()) then
					DcUtil:tutorialFinish()
				end
				data:writeToFile()
			end
			data:addToCurLevelGuide(data:getGuideIndex())
		end
		if success then
			data:addToCurSuccessGuide(data:getGuideIndex())
		end
		data:resetRunningGuide()
		data:resetRunningAction()
	end
end

-- 检查本关是否有可显示的引导
function GameGuide:checkHaveGuide(level)
	for k, v in pairs(GameGuideData:sharedInstance():getGuides()) do
		local list = {{type="scene", condition={scene="game", para=level}, force=true},
			{type="topLevel"},
			{type="onceOnly"},
			{type="curLevelGuided"}}
		if GameGuideCheck:checkFixedAppears(v, list, nil, k) then
			return true
		end
	end
	return false
end

-- 获取第一个符合条件的引导，否则返回空，满足所有条件才算通过。
function GameGuide:getFirstGuide(paras)
	local data = GameGuideData:sharedInstance()
	if data:getForceStop() or data:getSkipLevel() then return nil end
	for k, v in pairs(data:getGuides()) do
		if GameGuideCheck:checkAppear(v, paras, k) then
			return k
		end
	end
	return nil
end

-- 确认是否满足引导的消失条件，满足条件之一即通过
function GameGuide:checkDisappear(paras)
	local data = GameGuideData:sharedInstance()
	if data:getForceStop() then return true end
	return GameGuideCheck:checkDisappear(data:getRunningGuide(), paras, data:getGuideIndex())
end

-- 被通知一个引导结束，进入下一个引导
function GameGuide:onGuideComplete(skipLevel)
	local data = GameGuideData:sharedInstance()
	if not data:getRunningGuide() then
		data:resetRunningGuide()
		return
	end
	local rec, success = GameGuideRunner:removeGuide(paras)
	if skipLevel then
		data:resetRunningGuide()
		data:setSkipLevel(true)
		return
	end
	local action = data:incRunningAction()
	if not action then
		if rec then
			if not data:containInGuidedIndex(data:getGuideIndex()) then
				data:addToGuidedIndex(data:getGuideIndex())
				DcUtil:tutorialStep(data:getGuideIndex())
				if table.size(data:getGuidedIndex()) >= table.size(data:getGuides()) then
					DcUtil:tutorialFinish()
				end
				data:writeToFile()
			end
			data:addToCurLevelGuide(data:getGuideIndex())
		end
		if success then
			data:addToCurSuccessGuide(data:getGuideIndex())
		end
		data:resetRunningGuide()
		data:resetRunningAction()
	else
		GameGuideRunner:runGuide()
	end
end

function GameGuide:getHasCurrentGuide()
	return GameGuideData:sharedInstance():getRunningGuide() ~= nil
end