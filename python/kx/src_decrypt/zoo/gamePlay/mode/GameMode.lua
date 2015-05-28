GameMode=class()

function GameMode:ctor(mainLogic)
  self.mainLogic = mainLogic
end

function GameMode:initModeSpecial(config)
end

function GameMode:update(dt)
end

function GameMode:afterSwap(r, c)
end

function GameMode:afterStable(r, c)
end

function GameMode:afterChainBreaked(r,c)
end

function GameMode:afterFail()
  self.mainLogic:setGamePlayStatus(GamePlayStatus.kFailed)
end

function GameMode:useMove()
end

function GameMode:getScoreStarLevel()
  local mainLogic = self.mainLogic
	local starlevel = 0;
	if mainLogic then
		if mainLogic.scoreTargets then
			for i = 1, #mainLogic.scoreTargets do
				if mainLogic.totalScore >= mainLogic.scoreTargets[i] then
					starlevel = i;
				else
					break;
				end
			end
		end
	end
	return starlevel;
end

function GameMode:reachEndCondition()
  return false
end

function GameMode:reachTarget()
	return self:getScoreStarLevel() > 0
end

function GameMode:canChangeMoveToStripe()
	return true
end

function GameMode:saveDataForRevert(saveRevertData)
end

function GameMode:revertDataFromBackProp()
	local mainLogic = self.mainLogic
	mainLogic.gameItemMap = mainLogic.saveRevertData.gameItemMap
	mainLogic.boardmap = mainLogic.saveRevertData.boardmap
	mainLogic.totalScore = mainLogic.saveRevertData.totalScore
	mainLogic.theCurMoves = mainLogic.saveRevertData.theCurMoves
	mainLogic.blockProductRules = mainLogic.saveRevertData.blockProductRules
	mainLogic.cachePool = mainLogic.saveRevertData.cachePool
	mainLogic.tileBlockCount = mainLogic.saveRevertData.tileBlockCount
	mainLogic.pm25count = mainLogic.saveRevertData.pm25count
	mainLogic.snailCount = mainLogic.saveRevertData.snailCount
	mainLogic.snailMoveCount = mainLogic.saveRevertData.snailMoveCount
	mainLogic.questionMarkFirstBomb = mainLogic.saveRevertData.questionMarkFirstBomb
	mainLogic.saveRevertData = nil

	FallingItemLogic:updateHelpMapByDeleteBlock(mainLogic)
end

function GameMode:revertUIFromBackProp()
	local mainLogic = self.mainLogic
	if mainLogic.PlayUIDelegate then
		mainLogic.PlayUIDelegate:setMoveOrTimeCountCallback(mainLogic.theCurMoves, false)
		mainLogic.PlayUIDelegate.scoreProgressBar:revertScoreTo(mainLogic.totalScore)
	end
end

function GameMode:onGameInit()
	local context = self
	local function setGameStart()
		context.mainLogic:setGamePlayStatus(GamePlayStatus.kNormal)
		context.mainLogic.fsm:initState()
		context.mainLogic.boardView.isPaused = false
	end

	local function playUFOFlyIntoAnimation(  )
		-- body
		context.mainLogic.PlayUIDelegate:playUFOFlyIntoAnimation(setGameStart)
	end

	local function playTargetAnimation()
		if context.mainLogic.hasDropDownUFO then
			context.mainLogic.PlayUIDelegate:playLevelTargetPanelAnim(playUFOFlyIntoAnimation) 
		else
			context.mainLogic.PlayUIDelegate:playLevelTargetPanelAnim(setGameStart)
		end
		
	end
	
	if self.mainLogic.PlayUIDelegate then
		self.mainLogic.PlayUIDelegate:playPrePropAnimation(playTargetAnimation)	
	else
		setGameStart()
	end
	self.mainLogic.boardView:animalStartTimeScale()
	self.mainLogic:stopWaitingOperation()
end

function GameMode:getFailReason()
	return self.failReason
end

function GameMode:setFailReason(failReason)
	self.failReason = failReason
end

function GameMode:getStageIndex()
    return 0
end

function GameMode:getStageMoveLimit()
	return 0
end