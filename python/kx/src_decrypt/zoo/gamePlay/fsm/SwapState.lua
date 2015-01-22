require "zoo.gamePlay.fsm.GameState"

SwapState = class(GameState)

function SwapState:create(context)
	local v = SwapState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	return v
end

function SwapState:onEnter()
	print(">>>>>>>>>>>>>>>>>swap state enter")
	self.nextState = nil
end

function SwapState:onExit()
	print("<<<<<<<<<<<<<<<<<swap state exit")
	self.nextState = nil
end

function SwapState:update(dt)
	self:runSwapAction()
end

function SwapState:checkTransition()
	return self.nextState
end

function SwapState:runSwapAction()
	for k,v in pairs(self.mainLogic.swapActionList) do
		self:runSwapActionLogic(self.mainLogic, v, k)
		self:runSwapActionView(self.mainLogic.boardView, v)
	end
end

function SwapState:runSwapActionLogic(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then 		---running阶段，自动扣时间，到时间了，进入Death阶段
		if theAction.actionDuring < 0 then 
			theAction.actionStatus = GameActionStatus.kWaitingForDeath
		else
			theAction.actionDuring = theAction.actionDuring - 1
		end
	end

	if theAction.actionType == GameBoardActionType.kStartTrySwapItem then 							----交换动作
		if theAction.actionStatus == GameActionStatus.kWaitingForDeath then 						----结束状态
			local r1 = theAction.ItemPos1.x
			local c1 = theAction.ItemPos1.y
			local r2 = theAction.ItemPos2.x
			local c2 = theAction.ItemPos2.y
			local swapSucces = mainLogic:SwapedItemAndMatch(r1,c1,r2,c2, true)
			if swapSucces then 			---转换成功
				-- 重放代码记录
				if not mainLogic.replaying then
					-- table.insert(mainLogic.replaySteps, {x1 = r1, x2 = r2, y1 = c1, y2 = c2})
					mainLogic:addReplayStep({x1 = r1, x2 = r2, y1 = c1, y2 = c2})
				end
				theAction.addInfo = "success"
				mainLogic.swapActionList[actid] = nil
				mainLogic:setNeedCheckFalling()
				self.nextState = self.context.fallingMatchState
			else
				----转换失败
				local swapActionFailed = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameBoardAction,
					GameBoardActionType.kStartTrySwapItemFailed,
					theAction.ItemPos1,
					theAction.ItemPos2,
					GamePlayConfig_SwapAction_Failed_CD					----失败动画时间
				)
				mainLogic.swapActionList[actid] = swapActionFailed
			end
		end
	elseif theAction.actionType == GameBoardActionType.kStartTrySwapItemFailed then
		if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
			mainLogic.swapActionList[actid] = nil	----删除反转换需求
			self.nextState = self.context.waitingState
		end
	elseif theAction.actionType == GameBoardActionType.kStartTrySwapItem_fun then
		if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
			local swapActionFailed = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameBoardAction,
				GameBoardActionType.kStartTrySwapItemFailed,
				theAction.ItemPos1,
				theAction.ItemPos2,
				GamePlayConfig_SwapAction_Fun_Failed_CD					----失败动画时间
			)
			mainLogic.swapActionList[actid] = swapActionFailed
		end
	end
end

function SwapState:runSwapActionView(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		if theAction.actionType == GameBoardActionType.kStartTrySwapItem then 
			SwapState:runSwapItemAction(boardView, theAction)
			theAction.actionStatus = GameActionStatus.kRunning
		elseif theAction.actionType == GameBoardActionType.kStartTrySwapItemFailed then
			SwapState:runSwapItemFailedAction(boardView, theAction)
			theAction.actionStatus = GameActionStatus.kRunning
		elseif theAction.actionType == GameBoardActionType.kStartTrySwapItem_fun then
			theAction.actionStatus = GameActionStatus.kRunning
			SwapState:runSwapItemActionFun(boardView, theAction)
		end
	elseif theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		if theAction.actionType == GameBoardActionType.kStartTrySwapItem then 
			SwapState:runSwapItemActionComplete(boardView, theAction)
		end
	end
end

function SwapState:getItemPosition(itemPos)
	local x = (itemPos.y - 0.5 ) * GamePlayConfig_Tile_Width
	local y = (GamePlayConfig_Max_Item_Y - itemPos.x - 0.5 ) * GamePlayConfig_Tile_Height
	return ccp(x,y)
end

function SwapState:getActionTime(CDCount)
	return 1.0 / GamePlayConfig_Action_FPS * CDCount
end

function SwapState:runSwapItemAction(boardView, theAction)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local sprite1 = boardView.baseMap[r1][c1]:getGameItemSprite()
	local sprite2 = boardView.baseMap[r2][c2]:getGameItemSprite()
	if sprite1 == nil or sprite2 == nil then
		print("SwapState:runSwapItemAction sprite1 == nil or sprite2 == nil, it is a error!!!")
		return false
	end

	local position1 = SwapState:getItemPosition(theAction.ItemPos1)
	local position2 = SwapState:getItemPosition(theAction.ItemPos2)

	local MoveToAction1 = CCMoveTo:create(SwapState:getActionTime(GamePlayConfig_SwapAction_CD), position2)
	local MoveToAction2 = CCMoveTo:create(SwapState:getActionTime(GamePlayConfig_SwapAction_CD), position1)
	
	sprite1:runAction(MoveToAction1)
	sprite2:runAction(MoveToAction2)
end

function SwapState:runSwapItemActionComplete(boardView, theAction)
	if theAction.addInfo ~= "success" then
		return
	end
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y
	local item1 = boardView.baseMap[r1][c1]
	local item2 = boardView.baseMap[r2][c2]

	local tempSprite = nil
	local tempType = 0
	if item2.itemSprite[ItemSpriteType.kItem] then
		tempType = ItemSpriteType.kItem
		tempSprite = item2.itemSprite[ItemSpriteType.kItem]
		item2.itemSprite[ItemSpriteType.kItem] = nil
	elseif item2.itemSprite[ItemSpriteType.kItemShow] then
		tempType = ItemSpriteType.kItemShow
		tempSprite = item2.itemSprite[ItemSpriteType.kItemShow]
		item2.itemSprite[ItemSpriteType.kItemShow] = nil
	end

	if (item1.itemSprite[ItemSpriteType.kItem]) then
		item2.itemSprite[ItemSpriteType.kItem] = item1.itemSprite[ItemSpriteType.kItem]
		item1.itemSprite[ItemSpriteType.kItem] = nil
	elseif (item1.itemSprite[ItemSpriteType.kItemShow]) then
		item2.itemSprite[ItemSpriteType.kItemShow] = item1.itemSprite[ItemSpriteType.kItemShow]
		item1.itemSprite[ItemSpriteType.kItemShow] = nil
	end
	item1.itemSprite[tempType] = tempSprite

	local tempItemType = item1.oldData.ItemType
	local tempItemColorType = item1.oldData.ItemColorType
	local tempSpecialType = item1.oldData.ItemSpecialType
	local tempShowType = item1.itemShowType
	local tempIsBlock = item1.oldData.isBlock

	item1.oldData.ItemType = item2.oldData.ItemType
	item1.oldData.ItemColorType = item2.oldData.ItemColorType
	item1.oldData.ItemSpecialType = item2.oldData.ItemSpecialType
	item1.itemShowType = item2.itemShowType
	item1.oldData.isBlock = item2.oldData.isBlock

	item2.oldData.ItemType = tempItemType
	item2.oldData.ItemColorType = tempItemColorType
	item2.oldData.ItemSpecialType = tempSpecialType
	item2.itemShowType = tempShowType
	item2.oldData.isBlock = tempIsBlock
end

function SwapState:runSwapItemFailedAction(boardView, theAction)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local sprite1 = boardView.baseMap[r1][c1]:getGameItemSprite()
	local sprite2 = boardView.baseMap[r2][c2]:getGameItemSprite()
	if sprite1 == nil or sprite2 == nil then
		print("SwapState:runSwapItemFailedAction sprite1 == nil or sprite2 == nil, it is a error!!!")
		return false
	end

	local position1 = SwapState:getItemPosition(theAction.ItemPos1)
	local position2 = SwapState:getItemPosition(theAction.ItemPos2)
	local time = theAction.actionDuring

	local MoveToAction1 = CCMoveTo:create(SwapState:getActionTime(time), position1)
	local MoveToAction2 = CCMoveTo:create(SwapState:getActionTime(time), position2)
	
	sprite1:runAction(MoveToAction1)
	sprite2:runAction(MoveToAction2)
end

function SwapState:runSwapItemActionFun(boardView, theAction)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local sprite1 = boardView.baseMap[r1][c1]:getGameItemSprite()
	local sprite2 = boardView.baseMap[r2][c2]:getGameItemSprite()
	if sprite1 == nil or sprite2 == nil then
		return false
	end

	local position1 = SwapState:getItemPosition(theAction.ItemPos1)
	local position2 = SwapState:getItemPosition(theAction.ItemPos2)

	local posmid = ccp((position1.x + position2.x)/2, (position1.y + position2.y)/2);

	local posmid1 = ccp((position1.x + posmid.x)/2, (position1.y + posmid.y)/2);
	local posmid2 = ccp((posmid.x + position2.x)/2, (posmid.y + position2.y)/2);


	local MoveToAction1 = CCMoveTo:create(SwapState:getActionTime(GamePlayConfig_SwapAction_Fun_CD), posmid1)
	local MoveToAction2 = CCMoveTo:create(SwapState:getActionTime(GamePlayConfig_SwapAction_Fun_CD), posmid2)
	
	sprite1:runAction(MoveToAction1)
	sprite2:runAction(MoveToAction2)
end
