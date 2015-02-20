require "zoo.gamePlay.fsm.GameState"

UsePropState = class(GameState)

function UsePropState:create(context)
	local v = UsePropState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	return v
end

function UsePropState:onEnter()
	self.nextState = nil
	print(">>>>>>>>>>>>>>>>>use prop state enter")
end

function UsePropState:onExit()
	self.nextState = nil
	print("<<<<<<<<<<<<<<<<<use prop state exit")
end

function UsePropState:update(dt)
	self:runPropActionList(self.mainLogic)
end

function UsePropState:checkTransition()
	return self.nextState
end

function UsePropState:runPropActionList(mainLogic)
	for k, v in pairs(mainLogic.propActionList) do
		self:runGamePropsActionLogic(mainLogic, v, k)
		self:runPropsActionView(mainLogic.boardView, v)
	end
end

function UsePropState:runGamePropsActionLogic(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then 		---running阶段，自动扣时间，到时间了，进入Death阶段
		if theAction.actionDuring < 0 then
			theAction.actionStatus = GameActionStatus.kWaitingForDeath
		else
			theAction.actionDuring = theAction.actionDuring - 1
			if theAction.actionType == GameItemActionType.kItemRefresh_Item_Flying then
				self:runningGameItemRefresh_Item_Flying(mainLogic, theAction, actid)
			end
		end
	elseif theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		if theAction.actionType == GamePropsActionType.kHammer then
			self:runGamePropsHammerAction(mainLogic, theAction, actid)
		elseif theAction.actionType == GamePropsActionType.kSwap then
			self:runningGamePropSwapAction(mainLogic, theAction, actid)
		elseif theAction.actionType == GamePropsActionType.kLineBrush then
			self:runGamePropsLineBrushAction(mainLogic, theAction, actid)
		elseif theAction.actionType == GamePropsActionType.kBack then
			self:runGamePropsBackAction(mainLogic, theAction, actid)
		elseif theAction.actionType == GamePropsActionType.kOctopusForbid then
			self:runGamePropsOctopusForbidAction(mainLogic, theAction, actid)
		elseif theAction.actionType == GamePropsActionType.kRandomBird then
			self:runGamePropsRandomBirdAction(mainLogic, theAction, actid)
		elseif theAction.actionType == GamePropsActionType.kBroom then
			self:runGamePropsBroomAction(mainLogic, theAction, actid)
		elseif theAction.actionType == GamePropsActionType.kFirecracker then
			self:runGamePropsFirecrackerAction(mainLogic, theAction, actid)
		end
	end
end

function UsePropState:runGamePropsFirecrackerAction(mainLogic, theAction, actid)
	if theAction.addInfo == 'over' then
		BombItemLogic:springFestivalBombScreen(mainLogic)
		mainLogic.propActionList[actid] = nil
		mainLogic:setNeedCheckFalling()
		self.nextState = self.context.fallingMatchState
	end
end

function UsePropState:runGamePropsBroomAction(mainLogic, theAction, actid)
	if theAction.addInfo == 'over' then

		local r1, r2 = theAction.rows.r1, theAction.rows.r2
		local interval = 0.13

		local action = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_WitchBomb,
                        nil,
                        nil,
                        GamePlayConfig_MaxAction_time
                    )
		action.rows = {r1 = r1, r2 = r2}
		action.interval = interval
		action.startDelay = theAction.bombDelayTime
		action.col = 9
	    mainLogic:addDestroyAction(action)

		mainLogic.propActionList[actid] = nil
		mainLogic:setNeedCheckFalling()
		self.nextState = self.context.fallingMatchState
	end
end

function UsePropState:runGamePropsRandomBirdAction(mainLogic, theAction, actid)
	if theAction.addInfo == 'over' then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		assert(item.ItemType == GameItemType.kAnimal)
		item.ItemColorType = AnimalTypeConfig.kRandom
		item.ItemSpecialType = AnimalTypeConfig.kColor
		item.isNeedUpdate = true
		self.nextState = self.context.waitingState
		mainLogic.propActionList[actid] = nil
	end
end

function UsePropState:runGamePropsOctopusForbidAction(mainLogic, theAction, actid)
	if theAction.addInfo == 'over' then	

		local octopuses = {}
		local venoms = {}
		for r = 1, #mainLogic.gameItemMap do 
			for c = 1, #mainLogic.gameItemMap[r] do 
				local item = mainLogic.gameItemMap[r][c]
				if item and item.ItemType == GameItemType.kPoisonBottle then
					table.insert(octopuses, item)
				elseif item and item.ItemType == GameItemType.kVenom then
					table.insert(venoms, item)
				end
			end
		end

		for k, item in pairs(octopuses) do 
			item.forbiddenLevel = 3
			local r, c = item.y, item.x
			local action = GameBoardActionDataSet:createAs(
			                   GameActionTargetType.kGameItemAction,
			                   GameItemActionType.kOctopus_Change_Forbidden_Level,
			                   IntCoord:create(c, r),
			                   nil,
			                   GamePlayConfig_MaxAction_time)
			action.level = item.forbiddenLevel
			action.completeCallback = callback
	        self.mainLogic:addGameAction(action)
		end
		
		for k, item in pairs(venoms) do 
			local r, c = item.y, item.x
			SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c) 
		end

		mainLogic.propActionList[actid] = nil
		self.nextState = self.context.fallingMatchState
		mainLogic:setNeedCheckFalling()

	end
end

function UsePropState:runGamePropsHammerAction(mainLogic, theAction, actid)
	local r = theAction.ItemPos1.x
	local c = theAction.ItemPos1.y
	SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, 1, true)  --可以作用银币
	BombItemLogic:tryCoverByBomb(mainLogic, r, c, true, 1)
	SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3) 
	local str = string.format(GameMusicType.kEliminate, 1)
 	GamePlayMusicPlayer:playEffect(str);
	mainLogic.propActionList[actid] = nil
	self.nextState = self.context.fallingMatchState
	mainLogic:setNeedCheckFalling()
end

function UsePropState:runningGamePropSwapAction(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then 						----结束状态
		local r1, c1, r2, c2 = theAction.ItemPos1.x, theAction.ItemPos1.y, theAction.ItemPos2.x, theAction.ItemPos2.y
		if not SwapItemLogic:_trySwapedMatchItem(mainLogic, r1, c1, r2, c2, true) then
			local data1 = mainLogic.gameItemMap[r1][c1]
			local data2 = mainLogic.gameItemMap[r2][c2]
			local item1Clone = data1:copy()
			local item2Clone = data2:copy()
			data2:getAnimalLikeDataFrom(item1Clone)
			data1:getAnimalLikeDataFrom(item2Clone)
			if data1.ItemType == GameItemType.kMagicLamp or data2.ItemType == GameItemType.kMagicLamp then
				mainLogic:checkItemBlock(r1, c1)
				mainLogic:checkItemBlock(r2, c2)
				FallingItemLogic:preUpdateHelpMap(mainLogic)
			end
		else
			local swapInfo = { { r = r1, c = c1 }, { r = r2, c = c2 } }
			mainLogic.swapInfo = swapInfo
		end
		
		mainLogic:setNeedCheckFalling()
		self.nextState = self.context.fallingMatchState

		mainLogic.gameMode:afterSwap(r1, c1)
		mainLogic.gameMode:afterSwap(r2, c2)
		mainLogic.propActionList[actid] = nil
	end
end

function UsePropState:runGamePropsLineBrushAction(mainLogic, theAction, actid)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local animalType
	if theAction.ItemPos2.x ~= 0 then animalType = AnimalTypeConfig.kLine else animalType = AnimalTypeConfig.kColumn end
	mainLogic.gameItemMap[r1][c1]:changeItemType(mainLogic.gameItemMap[r1][c1].ItemColorType, animalType)
	mainLogic.gameItemMap[r1][c1].isNeedUpdate = true
	mainLogic.propActionList[actid] = nil
	self.nextState = self.context.waitingState
end

function UsePropState:runGamePropsBackAction(mainLogic, theAction, actid)
	mainLogic.propActionList[actid] = nil
	mainLogic.gameMode:revertUIFromBackProp(mainLogic)
	self.nextState = self.context.waitingState
end

function UsePropState:runningGameItemRefresh_Item_Flying(mainLogic, theAction, actid)
	if theAction.addInfo == "over" then
		mainLogic.propActionList[actid] = nil
		self.nextState = self.context.waitingState
	elseif theAction.addInfo == "Pass" then
		theAction.addInfo = "waiting1"
		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		local item1 = mainLogic.gameItemMap[r1][c1]
		item1.isNeedUpdate = true
	elseif theAction.addInfo == "waiting1" then
		if theAction.actionDuring == 1 then 
			theAction.addInfo = "over"
		end
	end
end

function UsePropState:runPropsActionView(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		if theAction.actionType == GamePropsActionType.kHammer then
			PropsView:playHammerAnimation(boardView, ccp(theAction.ItemPos1.x, theAction.ItemPos1.y))
			theAction.actionStatus = GameActionStatus.kRunning
		elseif theAction.actionType == GamePropsActionType.kSwap then
			self:runSwapItemAction(boardView, theAction)
			theAction.actionStatus = GameActionStatus.kRunning
		elseif theAction.actionType == GamePropsActionType.kLineBrush then
			PropsView:playLineBrushAnimation(boardView, ccp(theAction.ItemPos1.x, theAction.ItemPos1.y), theAction.ItemPos2)
			theAction.actionStatus = GameActionStatus.kRunning
		elseif theAction.actionType == GamePropsActionType.kBack then
			boardView:reInitByGameBoardLogic()
			theAction.actionStatus = GameActionStatus.kRunning
		elseif theAction.actionType == GamePropsActionType.kOctopusForbid then
			theAction.actionStatus = GameActionStatus.kRunning
			self:runGameItemActionStartOctopusForbidden(boardView, theAction)
		elseif theAction.actionType == GameItemActionType.kItemRefresh_Item_Flying then
			self:runGameItemActionPassRefreshItemFlying(boardView, theAction)
			self:runGameItemActionRefresh_Item_Flying(boardView, theAction)	
		elseif theAction.actionType == GamePropsActionType.kRandomBird then
			self:runGameItemActionRandomBird(boardView, theAction)	
		elseif theAction.actionType == GamePropsActionType.kBroom then
			self:runGameItemActionBroom(boardView, theAction)
		elseif theAction.actionType == GamePropsActionType.kFirecracker then
			self:runGameItemActionFirecracker(boardView, theAction)
		end
	else
		if theAction.actionType == GameItemActionType.kItemRefresh_Item_Flying then
			if theAction.addInfo == "over" then
				self:runGameItemActionPassRefreshItemFlyingOver(boardView, theAction)
			end
		end
	end
end

function UsePropState:runGameItemActionFirecracker(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kWaitingForDeath 
		theAction.addInfo = 'over'
	end
end

function UsePropState:runGameItemActionBroom(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		local interval = 0.13
		local r1 = theAction.rows.r1
		local bombDelayTime = PropsView:playWitchFlyingAnimation(boardView, interval, r1)
		theAction.bombDelayTime = bombDelayTime
		theAction.addInfo = 'over'
	end
end

function UsePropState:runGameItemActionRandomBird(boardView, theAction)	
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local function finishRandomBird()
			theAction.addInfo = 'over'
		end
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		setTimeOut(finishRandomBird, 0.5)
	end
end

function UsePropState:runSwapItemAction(boardView, theAction)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local sprite1 = boardView.baseMap[r1][c1]:getGameItemSprite()
	local sprite2 = boardView.baseMap[r2][c2]:getGameItemSprite()
	if sprite1 == nil or sprite2 == nil then
		print("UsePropState:runSwapItemAction sprite1 == nil or sprite2 == nil, it is a error!!!")
		return false
	end

	local position1 = UsePropState:getItemPosition(theAction.ItemPos1)
	local position2 = UsePropState:getItemPosition(theAction.ItemPos2)

	local MoveToAction1 = CCMoveTo:create(UsePropState:getActionTime(GamePlayConfig_SwapAction_CD), position2)
	local MoveToAction2 = CCMoveTo:create(UsePropState:getActionTime(GamePlayConfig_SwapAction_CD), position1)
	
	sprite1:runAction(MoveToAction1)
	sprite2:runAction(MoveToAction2)
end

function UsePropState:getItemPosition(itemPos)
	local x = (itemPos.y - 0.5 ) * GamePlayConfig_Tile_Width
	local y = (GamePlayConfig_Max_Item_Y - itemPos.x - 0.5 ) * GamePlayConfig_Tile_Height
	return ccp(x,y)
end

----CDCount多少帧
function UsePropState:getActionTime(CDCount)
	return 1.0 / GamePlayConfig_Action_FPS * CDCount
end

function UsePropState:runGameItemActionRefresh_Item_Flying(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	local r1 = theAction.ItemPos1.x;
	local c1 = theAction.ItemPos1.y;
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local item1 = boardView.baseMap[r1][c1];
	local item2 = boardView.baseMap[r2][c2];

	local pos1 = item1:getBasePosition(c1,r1)
	local pos2 = item1:getBasePosition(c2,r2)

	if item1.itemSprite[ItemSpriteType.kSpecial] ~= nil then
		local length = math.sqrt(math.pow(pos2.y - pos1.y, 2) + math.pow(pos2.x - pos1.x, 2))
		local moveAction = HeBezierTo:create(BoardViewAction:getActionTime(GamePlayConfig_Refresh_Item_Flying_Time), pos1, true, length * 0.4)

		item1.itemSprite[ItemSpriteType.kSpecial]:setPosition(pos2);
		item1.itemSprite[ItemSpriteType.kSpecial]:runAction(CCEaseSineInOut:create(moveAction));
	end
end

function UsePropState:runGameItemActionPassRefreshItemFlying(boardView, theAction)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local item1 = boardView.baseMap[r1][c1] 		----目标
	local item2 = boardView.baseMap[r2][c2]			----来源

	local data1 = boardView.gameBoardLogic.gameItemMap[r1][c1] 		----目标
	local data2 = boardView.gameBoardLogic.gameItemMap[r2][c2]		----来源

	item1:flyingSpriteIntoItem(item2)

	if item1.oldData then
		item1.isNeedUpdate = true

		item1.oldData.ItemColorType = data1.ItemColorType
		item1.oldData.ItemSpecialType = data1.ItemSpecialType
		if data1.ItemSpecialType == AnimalTypeConfig.kColor then
			item1.itemShowType = ItemSpriteItemShowType.kBird
		else
			item1.itemShowType = ItemSpriteItemShowType.kCharacter
		end 
	else 
	end
end

function UsePropState:runGameItemActionPassRefreshItemFlyingOver(boardView, theAction)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local item1 = boardView.baseMap[r1][c1] 		----目标
	local item2 = boardView.baseMap[r2][c2]			----来源

	local data1 = boardView.gameBoardLogic.gameItemMap[r1][c1] 		----目标
	local data2 = boardView.gameBoardLogic.gameItemMap[r2][c2]		----来源

	item1:flyingSpriteIntoItemEnd()
	item1.isNeedUpdate = true
end

function UsePropState:runGameItemActionStartOctopusForbidden(boardView, theAction)
	if theAction.addInfo == '' then
		theAction.addInfo = 'started'
		local mainLogic = boardView.gameBoardLogic
		local octopuses = {}
		for r = 1, #mainLogic.gameItemMap do 
			for c = 1, #mainLogic.gameItemMap[r] do 
				local item = mainLogic.gameItemMap[r][c]
				if item and item.ItemType == GameItemType.kPoisonBottle then
					table.insert(octopuses, item)
				end
			end
		end

		local count = 0

		local function callback()
			count = count + 1
			if count == #octopuses then
				theAction.addInfo = 'over'
			end
		end

		for k, v in pairs(octopuses) do 
			local fromPos = ccp(0, 0)
			local toPos = boardView.baseMap[v.y][v.x]:getBasePosition(v.x, v.y)
			local anim = PropsView:playOctopusForbidCastingAnimation(boardView, fromPos, toPos, callback)
		end
	end
end