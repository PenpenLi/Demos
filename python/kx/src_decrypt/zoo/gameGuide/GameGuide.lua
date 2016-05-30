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
	data:resetCurLevelGuide()
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
	local array = data:getGuideActionById(250007, 1).array[1]
	-- data:getGuides()[250001].appear[6] = nil
	array.r = pos.r + 1
	array.c = pos.c
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:onHalloweenBossDie()
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("halloweenBossDie")
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:onHedgehogCrazy( pos )
	-- body
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("hedgehogCrazy")
	self:tryEndCurrentGuide()
	local result = self:tryRunNewGuide(pos)
	data:removeFromGameFlags("hedgehogCrazy")
	return result
end

function GameGuide:onHedgehogCrazyClick( paras)
	-- body
	local data = GameGuideData:sharedInstance()
	self:tryEndCurrentGuide({value = "click"})
end

function GameGuide:onWukongCrazy( pos )
	-- body
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("wukongCrazy")
	self:tryEndCurrentGuide()
	local result = self:tryRunNewGuide(pos)
	data:removeFromGameFlags("wukongCrazy")
	return result
end

function GameGuide:onWukongCrazyClick( paras)
	-- body
	local data = GameGuideData:sharedInstance()
	self:tryEndCurrentGuide({value = "click"})
end

function GameGuide:onWukongGuideJump( pos , flags )
	-- body
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags( flags )
	self:tryEndCurrentGuide()
	local result = self:tryRunNewGuide(pos)
	data:removeFromGameFlags( flags )
	return result
end

function GameGuide:onGoldZongziAppear(pos)
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("goldZongziAppear")
	-- local array = data:getGuideActionById(220002, 1).array[1]
	-- data:getGuides()[220002].action[6] = nil
	local array = data:getGuideActionById(250008, 1).array[1]
	array.r = pos.r
	array.c = pos.c
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:tryFirstQuestionMark(row, col)
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("firstQuestionMark")
	data:getGuideActionById(2303312, 1).array[1].r = row
	data:getGuideActionById(2303312, 1).array[1].c = col
	data:getGuideActionById(2303312, 1).panPosY = row - data:getGuideActionById(2303312, 1).offsetY
	self:tryEndCurrentGuide()
	local guide = self:tryRunNewGuide()
	data:removeFromGameFlags("firstQuestionMark")
	return guide
end

function GameGuide:onFirstShowFirework(pos)
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("firstShowFirework")
	-- data:getGuideActionById(210000, 1).position = pos
	data:getGuideActionById(2303311, 1).position = pos
	self:tryEndCurrentGuide()
	local newGuide = self:tryRunNewGuide()
	data:removeFromGameFlags("firstShowFirework")
	return newGuide
end

function GameGuide:tryFirstFullFirework(pos)
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("firstFullFirework")
	-- data:getGuideActionById(210002, 1).position = pos
	data:getGuideActionById(2303313, 1).position = pos
	self:tryEndCurrentGuide()
	local newGuide = self:tryRunNewGuide()
	data:removeFromGameFlags("firstFullFirework")
	return newGuide
end

function GameGuide:trySwapCrystalStonesGuide(pos1, pos2)
	if not pos1 or not pos2 then return end

	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("twoCrystalStones")

	local action = data:getGuideActionById(7300, 1)
	local first, second = pos1, pos2
	if pos2.x < pos1.x or pos2.y < pos1.y then
		first, second = pos2, pos1
	end
	local row = math.abs(second.x - first.x) + 1
	local col = math.abs(second.y - first.y) + 1
	action.array = {{r = first.x, c = first.y, countR = 1, countC = 1}, {r = second.x, c = second.y, countR = 1, countC = 1}}
	if col > 1 then
 		action.allow = {r = first.x, c = first.y, countR = row, countC = col}
 	elseif row > 1 then
 		action.allow = {r = second.x, c = second.y, countR = row, countC = col}
 	end
 	action.from = ccp(first.x, first.y)
 	action.to = ccp(second.x, second.y)
 	local maxR = math.max(first.x, second.x)
 	if maxR <= 5 then
	 	action.panPosY = maxR + 1
	 	action.panType = "up"
 	else
 		local minR = math.min(first.x, second.x)
	 	action.panPosY = minR - 4.5
	 	action.panType = "down"
 	end

 	local guide = data:getGuideById(7300)
 	guide.disappear = nil
 	guide.disappear = {{type = "swap", from = ccp(first.x, first.y), to = ccp(second.x, second.y)}}

	self:tryEndCurrentGuide()
	local newGuide = self:tryRunNewGuide()
	data:removeFromGameFlags("twoCrystalStones")
	return newGuide
end

function GameGuide:onShowFullFireworkTip(pos)
	local data = GameGuideData:sharedInstance()
	if not data:containInGuidedIndex(2303314) then -- 将首次引导置为不可用
		data:addToGuidedIndex(2303314)
		data:writeToFile()
	end

	data:addToGameFlags("showFullFireworkTip")
	self:tryEndCurrentGuide()
	local newGuide = self:tryRunNewGuide()
	data:removeFromGameFlags("showFullFireworkTip")
	return newGuide
end

function GameGuide:onShowForceUse(pos)
	local data = GameGuideData:sharedInstance()
	data:addToGameFlags("forceUseFullFirework")
	data:getGuideActionById(2303315, 1).position = pos
	self:tryEndCurrentGuide()
	local newGuide = self:tryRunNewGuide()
	data:removeFromGameFlags("forceUseFullFirework")
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
	local data = GameGuideData:sharedInstance()
	local scene = data:getScene()
	local levelId = data:getLevelId()
	data:setScene("game")
	data:setLevelId(level)
	for k, v in pairs(GameGuideData:sharedInstance():getGuides()) do
		local list = {{type="scene", force=true},
			{type="topLevel"},
			{type="onceOnly"},
			{type="curLevelGuided"}}
		if GameGuideCheck:checkFixedAppears(v, list, nil, k) then
			data:setScene(scene)
			data:setLevelId(levelId)
			return true
		end
	end
	data:setScene(scene)
	data:setLevelId(levelId)
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
		data:setSkipLevel(true)
	end
	local action = data:incRunningAction()
	if skipLevel or not action then
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