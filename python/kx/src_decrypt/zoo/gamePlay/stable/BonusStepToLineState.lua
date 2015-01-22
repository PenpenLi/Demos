
BonusStepToLineState = class(BaseStableState)

function BonusStepToLineState:dispose()
	self.mainLogic = nil
	self.boardView = nil
	self.context = nil
end

function BonusStepToLineState:create(context)
	local v = BonusStepToLineState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	v.boardView = v.mainLogic.boardView
	return v
end

function BonusStepToLineState:onEnter()
	BaseStableState.onEnter(self)

	self.nextState = nil
	self.timeCount = 0

	if self.mainLogic.gameMode:canChangeMoveToStripe() then
		BombItemLogic:initRandomAnimalChangeList(self.mainLogic)					----初始化随机列表
		self.numStepToLine = math.min(#self.mainLogic.randomAnimalHelpList, self.mainLogic.theCurMoves)
		if self.numStepToLine > 0 then
			self.hasItemToHandle = true
		else
			-- self.nextState = self.context.gameOverState
			self.nextState = self.context.halloweenBossStateInBonus
		end
	else
		-- self.nextState = self.context.gameOverState
		self.nextState = self.context.halloweenBossStateInBonus
	end
end

function BonusStepToLineState:onExit()
	BaseStableState.onExit(self)
	self.nextState = nil
end

function BonusStepToLineState:update(dt)
	if not self.hasItemToHandle then return end
	self.timeCount = self.timeCount + 1
	local mainLogic = self.mainLogic
	if self.timeCount > GamePlayConfig_BonusTime_ItemFlying_CD then
		self.timeCount = 0
		local pos = BombItemLogic:getRandomAnimalChangeToLineSpecial(mainLogic)						----随机到一个需要变成特效的东西
		if mainLogic.theCurMoves > 0 then 															----每次随机一个特效，减少一个步数
			mainLogic.theCurMoves = mainLogic.theCurMoves - 1 
			if mainLogic.PlayUIDelegate then --------调用UI界面函数显示移动步数
				mainLogic.PlayUIDelegate:setMoveOrTimeCountCallback(mainLogic.theCurMoves, true, true)
			end
		else
			pos = nil
		end
		if pos then
			local specialTypes = { AnimalTypeConfig.kLine, AnimalTypeConfig.kColumn }
			mainLogic.gameItemMap[pos.x][pos.y]:changeItemType(mainLogic.gameItemMap[pos.x][pos.y].ItemColorType, specialTypes[mainLogic.randFactory:rand(1, 2)])
			if mainLogic.PlayUIDelegate then
				local function onFlyFinish()
					mainLogic.gameItemMap[pos.x][pos.y].isNeedUpdate = true
					ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_BonusTime_Score);
					local ScoreAction = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemScore_Get,
						pos, nil, 1)
					ScoreAction.addInt = GamePlayConfig_BonusTime_Score;
					mainLogic:addGameAction(ScoreAction)

					self.numStepToLine = self.numStepToLine - 1

					if self.addInfo == "flyend" and self.numStepToLine == 0 then
						self.nextState = self.context.bonusLastBombState
						self.context:onEnter()
					end
				end
				local from = mainLogic.PlayUIDelegate.gameBoardView.moveCountPos
				local to = mainLogic:getGameItemPosInView(pos.x, pos.y)
				local star = FallingStar:create(from, to, nil, onFlyFinish, true)
				GamePlayMusicPlayer:playEffect(GameMusicType.kBonusStepToLine)
				mainLogic.PlayUIDelegate.effectLayer:addChild(star)
			end
		else
			self.addInfo = "flyend"
			if mainLogic.theCurMoves > 0 then
				if mainLogic.PlayUIDelegate then 
					mainLogic.theCurMoves = 0
					mainLogic.PlayUIDelegate:setMoveOrTimeCountCallback(0, true, true)
				end
			end
			if self.numStepToLine == 0 then
				self.nextState = self.context.bonusLastBombState
				self.context:onEnter()
			end
		end
	end
end

function BonusStepToLineState:checkTransition()
	return self.nextState
end

function BonusStepToLineState:getClassName( ... )
	-- body
	return "BonusStepToLineState"
end
