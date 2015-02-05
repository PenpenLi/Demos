----面板动画函数------

require "zoo.itemView.ItemView"
require "zoo.itemView.PropsView"
require "zoo.gamePlay.BoardAction.GameBoardActionDataSet"

BoardViewAction = class{}


----求一个Item的真实位置itemPos中存储的是rc，所以对应的是yx
function BoardViewAction:getItemPosition(itemPos)
	local x = (itemPos.y - 0.5 ) * GamePlayConfig_Tile_Width
	local y = (GamePlayConfig_Max_Item_Y - itemPos.x - 0.5 ) * GamePlayConfig_Tile_Height
	return ccp(x,y)
end

----CDCount多少帧
function BoardViewAction:getActionTime(CDCount)
	return 1.0 / GamePlayConfig_Action_FPS * CDCount
end

function BoardViewAction:runSwapItemAction(boardView, theAction)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local sprite1 = boardView.baseMap[r1][c1]:getGameItemSprite()
	local sprite2 = boardView.baseMap[r2][c2]:getGameItemSprite()
	if sprite1 == nil or sprite2 == nil then
		print("BoardViewAction:runSwapItemAction sprite1 == nil or sprite2 == nil, it is a error!!!")
		return false
	end

	local position1 = BoardViewAction:getItemPosition(theAction.ItemPos1)
	local position2 = BoardViewAction:getItemPosition(theAction.ItemPos2)

	local MoveToAction1 = CCMoveTo:create(BoardViewAction:getActionTime(GamePlayConfig_SwapAction_CD), position2)
	local MoveToAction2 = CCMoveTo:create(BoardViewAction:getActionTime(GamePlayConfig_SwapAction_CD), position1)
	
	sprite1:runAction(MoveToAction1)
	sprite2:runAction(MoveToAction2)
end

function BoardViewAction:runGameItemActionScoreGet(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning

	local r1 = theAction.ItemPos1.x;
	local c1 = theAction.ItemPos1.y;
	local item = boardView.baseMap[r1][c1];
	local num = theAction.addInt;
	local posType = theAction.addInt2;

	local spriteGetScore = item:playGetScoreAction(boardView, num, ccp(0,800), posType, boardView.labelBatch)
	boardView.labelBatch:addChild(spriteGetScore)

	--------传给UI界面，显示分数星星飞行特效
	if boardView.PlayUIDelegate then
		if boardView.PlayUIDelegate.scoreProgressBar then
			local pos = item:getBasePosition(item.x, item.y);
			local pos1 = boardView:getPosition();
			local pos2 = ccp(pos1.x + pos.x, pos1.y + pos.y)
			boardView.PlayUIDelegate.scoreProgressBar:addScore(num , pos2);
		end
	end
end

function BoardViewAction:runGameItemActionRefresh_Item_Flying(boardView, theAction)
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

function BoardViewAction:runGameItemActionPassRefreshItemFlying(boardView, theAction)
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

function BoardViewAction:runGameItemActionPassRefreshItemFlyingOver(boardView, theAction)
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

function BoardViewAction:runGameItemActionItemCrystalChange(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	local r1 = theAction.ItemPos1.x;
	local c1 = theAction.ItemPos1.y;

	local data1 = boardView.gameBoardLogic.gameItemMap[r1][c1]
	local item1 = boardView.baseMap[r1][c1];
	local color = theAction.addInt;

	item1:playChangeCrystalColor(color);
	if item1.oldData then
		item1.oldData.ItemColorType = color;
		data1.ItemColorType = color;
	end
end

function BoardViewAction:runGameItemActionVenomSpread(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	local originR1 = theAction.ItemPos1.x
	local originC1 = theAction.ItemPos1.y

	local targetR1 = theAction.ItemPos2.x
	local targetC1 = theAction.ItemPos2.y

	local dir = { x = targetC1 - originC1, y = targetR1 - originR1 }
	local venom = boardView.baseMap[originR1][originC1]

	local function callback( ... )
		-- body
		theAction.addInfo = "replace"

	end
	venom:playVenomSpreadEffect(dir, callback, theAction.itemType)
end

function BoardViewAction:runningGameItemActionVenomSpread( boardView, theAction )
	-- body
	if theAction.addInfo == "replaceView" then 
		theAction.addInfo = "over"
		local originR1 = theAction.ItemPos1.x
		local originC1 = theAction.ItemPos1.y
		local venom = boardView.baseMap[originR1][originC1]
		if venom then 
			local sprite = venom.itemSprite[ItemSpriteType.kNormalEffect]
			if sprite and sprite:getParent() then
				sprite:removeFromParentAndCleanup(true)
			end
			venom.itemSprite[ItemSpriteType.kNormalEffect] = nil
		end
	end
end

function BoardViewAction:runGameItemActionFurballTransfer(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	local fr = theAction.ItemPos1.x
	local fc = theAction.ItemPos1.y

	local tr = theAction.ItemPos2.x
	local tc = theAction.ItemPos2.y

	local dir = { x = tc - fc, y = tr - fr }
	local fromItem = boardView.baseMap[fr][fc]
	local function callback( ... )
		-- body
		local tr = theAction.ItemPos2.x
		local tc = theAction.ItemPos2.y
		local targetItem = boardView.baseMap[tr][tc]
		targetItem:addFurballView(theAction.addInt)
		theAction.addInfo = "add"
		
	end
	fromItem:playFurballTransferEffect(dir, callback)
end

function BoardViewAction:runningGameItemActionFurballTransfer(boardView, theAction)
	if theAction.addInfo == "add" then 
		theAction.addInfo = "over"
		local fr = theAction.ItemPos1.x
		local fc = theAction.ItemPos1.y
		local fromItem = boardView.baseMap[fr][fc]
		fromItem.itemSprite[ItemSpriteType.kSpecial]:removeFromParentAndCleanup(true)
		fromItem.itemSprite[ItemSpriteType.kSpecial] = nil

	end
end

function BoardViewAction:runGameItemActionFurballSplit(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning

	local fr = theAction.ItemPos1.x
	local fc = theAction.ItemPos1.y

	local dir = { x = 0, y = 0 }
	if theAction.ItemPos2 then
		local tr = theAction.ItemPos2.x
		local tc = theAction.ItemPos2.y

		dir = { x = tc - fc, y = tr - fr }
	end
	local function callback( ... )
		-- body
		if theAction.ItemPos2 then
			local tr = theAction.ItemPos2.x
			local tc = theAction.ItemPos2.y
			local targetItem = boardView.baseMap[tr][tc]
			targetItem:addFurballView(GameItemFurballType.kGrey)
		end
		theAction.addInfo = "add"
	end

	local fromItem = boardView.baseMap[fr][fc]
	fromItem:playFurballSplitEffect(dir, callback)
end

function BoardViewAction:runningGameItemActionFurballSplit(boardView, theAction)
	if theAction.addInfo == "add" then
		theAction.addInfo = "over"
		local fr = theAction.ItemPos1.x
		local fc = theAction.ItemPos1.y
		local fromItem = boardView.baseMap[fr][fc]
		fromItem:cleanFurballView()
		fromItem:addFurballView(GameItemFurballType.kGrey)

		-- if theAction.ItemPos2 then
		-- 	local tr = theAction.ItemPos2.x
		-- 	local tc = theAction.ItemPos2.y
		-- 	local targetItem = boardView.baseMap[tr][tc]
		-- 	targetItem:addFurballView(GameItemFurballType.kGrey)
		-- end
	end
end

function BoardViewAction:runGameItemActionFurballUnstable(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	local r = theAction.ItemPos1.x
	local c = theAction.ItemPos1.y

	local item = boardView.baseMap[r][c]
	item:playFurballUnstableEffect()
end

function BoardViewAction:runGameItemActionFurballShield(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning

	local r = theAction.ItemPos1.x
	local c = theAction.ItemPos1.y

	local item = boardView.baseMap[r][c]
	item:playFurballShieldEffect()
end

function BoardViewAction:runGameItemActionAnimalShakeBySpecialColor(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		itemView:playShakeBySpecialColorEffect()
	elseif theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.actionDuring == 1 then
			local r = theAction.ItemPos1.x
			local c = theAction.ItemPos1.y
			local itemView = boardView.baseMap[r][c]
			itemView:stopShakeBySpecialColorEffect()
		end
	end
end

function BoardViewAction:runGameItemActionRoostReplace(boardView, theAction)
	local function replaceAnimComplete()
		theAction.addInfo = "add"
	end
	theAction.actionStatus = GameActionStatus.kRunning
	local r = theAction.ItemPos1.x
	local c = theAction.ItemPos1.y
	local itemView = boardView.baseMap[r][c]
	itemView:playRoostReplaceAnimation(replaceAnimComplete)
end

function BoardViewAction:runningGameItemActionRoostReplace(boardView, theAction)
	if theAction.addInfo == "add" then
		theAction.addInfo = ""

		local function flyAnimComplete()
			theAction.addInfo = "replace"
		end

		if theAction.itemList and #theAction.itemList > 0 then
			local roostPos = IntCoord:clone(theAction.ItemPos1)

			for i, itemPos in ipairs(theAction.itemList) do
				local r = itemPos.x
				local c = itemPos.y
				local itemView = boardView.baseMap[r][c]
				itemView:playRoostReplaceFlyAnimation(roostPos, flyAnimComplete)
			end
		else
			setTimeOut(flyAnimComplete, 0.6)
		end
	end
end

function BoardViewAction:runGameItemActionBalloonUpdateNum(boardView, theAction )
	-- body
	theAction.actionStatus = GameActionStatus.kRunning
	local itemviewMap = boardView.baseMap
	itemviewMap[theAction.ItemPos1.x][theAction.ItemPos1.y]:updateBalloonStep(theAction.numberShow)
end

function BoardViewAction:runGameItemViewActionBallooRunaway(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then 
		theAction.actionStatus = GameActionStatus.kRunning
		local itemviewMap = boardView.baseMap
		itemviewMap[theAction.ItemPos1.x][theAction.ItemPos1.y]:playBalloonActionRunaway(boardView)
		GamePlayMusicPlayer:playEffect(GameMusicType.kBalloonRunaway)
		
	
	end
end
function BoardViewAction:runGameItemViewActionForceMoveItem(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then 
		theAction.actionStatus = GameActionStatus.kRunning
		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		local r2 = theAction.ItemPos2 and theAction.ItemPos2.x
		local c2 = theAction.ItemPos2 and theAction.ItemPos2.y
		local itemView = boardView.baseMap[r1][c1]
		local sprite = boardView.baseMap[r1][c1]:getGameItemSprite()

		local function completeCallback( ... )
			-- body
			theAction.addInfo = "over"
			if theAction.isTop then
			else 
				if theAction.isUfoLikeItem then 
					boardView:swapItemView(boardView.baseMap[r1][c1], boardView.baseMap[r2][c2])
				end
			end
		end

		local position = UsePropState:getItemPosition(IntCoord:create(r2,c2))
		if theAction.isTop  then 
			local function callback( ... )
				-- body
				completeCallback()
			end
			local arr = CCArray:create()
			local moveTime = 0.5
			if itemView.itemShowType == ItemSpriteItemShowType.kRabbit then
				sprite:playRunAnimation()
				arr:addObject(CCDelayTime:create(0.7))
				moveTime = 1
			else
				local action_rotation = CCRepeat:create(CCSequence:createWithTwoActions(CCRotateTo:create(0.1, -15), CCRotateTo:create(0.1, 0)), 3) 
				arr:addObject(action_rotation)
			end

			local action_move = CCEaseExponentialOut:create(CCMoveTo:create(moveTime, position)) 
			local action_scale = CCScaleTo:create(0.5, 0)
			arr:addObject(CCSpawn:createWithTwoActions(action_scale, action_move) ) 
			arr:addObject(CCCallFunc:create(callback))
			local moveToAction = CCSequence:create(arr)
			sprite:runAction(moveToAction)
		else 
			
			if theAction.isUfoLikeItem and boardView.PlayUIDelegate then
				itemView:playUpstairsAnimation(r2, c2, boardView, theAction.isShowDangerous, completeCallback)
			else
				local arr = CCArray:create()
				arr:addObject(CCDelayTime:create(0.4))
				arr:addObject(CCMoveTo:create(0.25, position))
				arr:addObject(CCCallFunc:create(completeCallback))
				local move_action = CCSequence:create(arr) 
				sprite:runAction(move_action)
			end 
		end
	end
end

function BoardViewAction:runGameItemViewActionChangeToIngredient( boardView, theAction )
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then 
		theAction.actionStatus = GameActionStatus.kRunning
		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		local itemview = boardView.baseMap[r1][c1]

		local r2 = theAction.ItemPos2.x
		local c2 = theAction.ItemPos2.y
		-- debug.debug()
		local visibleSize = CCDirector:sharedDirector():getVisibleSize()
		local fromPosition =  boardView.gameBoardLogic:getGameItemPosInView(r2, c2)
		fromPosition = ccp(fromPosition.x, visibleSize.height)
		local function callback( ... )
			-- body
			theAction.addInfo = "over"
		end 
		itemview:playChangeToIngredientAnimation(boardView, fromPosition, callback)
	else
	end
end

function BoardViewAction:runGameItemActionTileBlockerUpdate(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then 
		theAction.actionStatus = GameActionStatus.kRunning
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemview = boardView.baseMap[r][c]
		local function callback( ... )
			-- body
			theAction.addInfo = "over"
		end 
		itemview:playTileBoardUpdate(theAction.coutDown, theAction.isReverseSide, callback, boardView)
	else
	end
end

function BoardViewAction:runGameItemActionMonsterJump( boardView, theAction )
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		local function animationCallback( ... )
			-- body
			theAction.addInfo = "over"
		end
		itemView:playMonsterJumpAnimation(animationCallback)
	end
end

function BoardViewAction:runGameItemActionMonsterDestroyItem(boardView, theAction )
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		local function animationCallback( ... )
			-- body
			theAction.addInfo = "over"
		end
		itemView:playMonsterDestroyItem(boardView, animationCallback)
	end
end

function BoardViewAction:runGameItemActionPM25Update(boardView, theAction) 
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then 
		theAction.actionStatus = GameActionStatus.kRunning
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		local function animationCallback( ... )
			-- body
			theAction.addInfo = "replace"
		end
		itemView:playChangeToDigGround(boardView, animationCallback)
	elseif theAction.addInfo == "replaceView" then
		theAction.addInfo = "over"
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		local s = itemView.itemSprite[ItemSpriteType.kNormalEffect]
		if s then 
			s:removeFromParentAndCleanup(true)
			itemView.itemSprite[ItemSpriteType.kNormalEffect] = nil
			itemView.isNeedUpdate = true
		end

	end
end

function BoardViewAction:runGameItemActionBlackCuteBallUpdate(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local function animationCallback( ... )
			-- body
			theAction.addInfo = "replace"
		end

		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		local itemView1 = boardView.baseMap[r1][c1]
		if theAction.ItemPos2 then      ----jump
			local r2 = theAction.ItemPos2.x
			local c2 = theAction.ItemPos2.y
			local itemView2 = boardView.baseMap[r2][c2]
			local function itemHide( ... )
				-- body
				if itemView2 then 
					local sp = itemView2:getGameItemSprite()
					if sp then 
						-- sp:setVisible(false) 
						sp:runAction(CCSpawn:createWithTwoActions(CCEaseOut:create(CCMoveBy:create(1, ccp(0, -GamePlayConfig_Tile_Height * 7)), 1/3) , 
							CCEaseSineOut:create(CCFadeOut:create(1) )))
					end
				end

			end
			itemView1:playBlackCuteBallJumpToAnimation(r2, c2, itemHide, animationCallback)
		else                            ----addStrength
			itemView1:playBlackCuteBallDecAnimation(2, animationCallback)
		end
	end
end

function BoardViewAction:runGameItemActionMimosaGrow(boardView, theAction)
	-- body
	

	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		local function mimosa_callback( ... )
			-- body
			theAction.addInfo = "animation_over"
		end
		itemView:playMimosaGrowAnimation(mimosa_callback)
	elseif theAction.addInfo == "effect_item" then
		theAction.addInfo = ""
		local list = theAction.mimosaHoldGrid
		local time = 0 ---延迟生长，后面决定去掉延迟
		local function callback( ... )
			-- body
			theAction.addInfo = "over"
		end
		for k = 1, #list do 
			local r, c = list[k].x, list[k].y
			local itemView = boardView.baseMap[r][c]
			if k == #list then
				itemView:playMimosaEffectAnimation(theAction.direction, time * k,  callback, true)
			else
				itemView:playMimosaEffectAnimation(theAction.direction, time * k, nil, true)
			end
			
		end
	end

end

function BoardViewAction:runGameItemActionMimosaBack(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local function callback( ... )
			-- body
			theAction.addInfo = "over"
		end

		local list = theAction.mimosaHoldGrid
		local delaytime = 1
		for k = 1, #list do 
			local r, c = list[k].x, list[k].y
			local itemView = boardView.baseMap[r][c]
			local call_func = k==#list and callback or nil
			itemView:playMimosaEffectAnimation(theAction.direction, delaytime,  call_func, false)
		end

		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]

		itemView:playMimosaBackAnimation(delaytime)
	end

end

function BoardViewAction:runGameItemActionMimosaReady(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		theAction.addInfo = "over"
		local r, c = theAction.ItemPos1.x,  theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		itemView:playMimosaReadyAnimation()
	end
end

function BoardViewAction:runGameItemActionSnailRoadBright(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		theAction.addInfo = "over"
		local r, c = theAction.ItemPos1.x,  theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		itemView:playSnailRoadChangeState(true)
	end
end

function BoardViewAction:runGameItemActionProductSnail(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local function animationCallback( ... )
			-- body
			theAction.addInfo = "over"
		end
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]
		item:changToSnail(theAction.direction, animationCallback)
	end
end

function BoardViewAction:runGameItemActionMagicLampReinit(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning 
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local view = boardView.baseMap[r][c]
		local function callback()
			theAction.addInfo = 'over'
		end
		view:setMagicLampLevel(0, theAction.color, callback) 
	end 
end

function BoardViewAction:runGameItemActionMagicLampCasting(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning 
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local fromItem = boardView.baseMap[r][c]
		fromItem:setMagicLampLevel(6)
		local toItemPos = theAction.speicalItemPos
		local function actionCallback()
			if not theAction.completeCount then theAction.completeCount = 0 end
			theAction.completeCount = theAction.completeCount + 1
			if theAction.completeCount >= #toItemPos then
				theAction.addInfo = 'over'
			end
		end

		for k, v in pairs(toItemPos) do
			local item = boardView.baseMap[v.r][v.c]
			item:playChangeToLineSpecial(boardView, fromItem, direction, actionCallback)
		end
	end	
end

function BoardViewAction:runGameItemActionMaydayBossDie(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning 

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local fromItem = boardView.baseMap[r][c]
		local toItemPos = theAction.addMoveItemPos

		local function dropCallback()
			print('dropCallback')
			if not theAction.completeCount then theAction.completeCount = 0 end
			theAction.completeCount = theAction.completeCount + 1
			print('theAction.completeCount', theAction.completeCount)
			if theAction.completeCount >= #toItemPos then
				theAction.addInfo = 'dropped'
			end
		end
		for k, v in pairs(toItemPos) do 
			local item = boardView.baseMap[v.r][v.c]
			item:playMaydayBossChangeToAddMove(boardView, fromItem, dropCallback)
		end

	elseif theAction.addInfo == 'dropped' then
		theAction.addInfo = ""
		local function dieCallback()
			theAction.addInfo = 'over'
		end
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]
		item:playMaydayBossDie(self, dieCallback)
	end
end

function BoardViewAction:runGameItemActionMaydayBossJump(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning 
		local from_r, from_c = theAction.ItemPos1.x, theAction.ItemPos1.y
		
		local itemFrom = boardView.baseMap[from_r][from_c]
		
		local function jumpCallback()
			theAction.addInfo = "bossDisappered"
		end
		itemFrom:playMaydayBossDisappear(self, jumpCallback)
	elseif theAction.addInfo == "bossDisappered" then
		theAction.addInfo = ""
		local from_r, from_c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local from_data = boardView.gameBoardLogic:getItemMap()[from_r][from_c]
		local to_r, to_c = theAction.ItemPos2.x, theAction.ItemPos2.y
		local data = {x = to_c, y = to_r, w=from_data.w, h = from_data.h, blood = from_data.blood, maxBlood = from_data.maxBlood}
		local itemTo = boardView.baseMap[to_r][to_c]
		local function comeCallback()
			print('comeCallback')
			theAction.addInfo = 'over'
		end
		itemTo:playMaydayBossComeout(self, data, comeCallback)
	end
end

function BoardViewAction:runGameitemActionProductRabbit(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local function shiftCallback( ... )
			-- body
			theAction.addInfo = "shifted"
		end

		local pos = theAction.ItemPos1
		local shiftToPos = theAction.ItemPos2

		if shiftToPos then
			print('boardView.baseMap[pos.r][pos.c]', pos.r, pos.c)
			local item = boardView.baseMap[pos.r][pos.c]
			item:playBirdShiftToAnim(shiftToPos, shiftCallback)
		else
			shiftCallback()
		end
	elseif theAction.addInfo == 'shifted' then
		theAction.addInfo = ''
		local function produceCallback()
			theAction.addInfo = 'over'
		end
		local pos = theAction.ItemPos1
		local item = boardView.baseMap[pos.r][pos.c]
		local color = theAction.color
		item:changeToRabbit(color, theAction.level, produceCallback)
	end
end

function BoardViewAction:runGameitemActionTransmission(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local from_r, from_c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local to_r, to_c = theAction.ItemPos2.x, theAction.ItemPos2.y
		local item = boardView.baseMap[from_r][from_c]
		local boardData = theAction.boardData
		local itemData = theAction.itemData
		local function callback()
			theAction.addInfo = "moveOver"
		end

		if boardData.transType == TransmissionType.kEnd then
			local function getP(direction)
				local p = ccp(0, 0)
				if direction == TransmissionDirection.kRight then
					p.x = GamePlayConfig_Tile_Width
				elseif direction == TransmissionDirection.kLeft then
					p.x = -GamePlayConfig_Tile_Width
				elseif direction == TransmissionDirection.kUp then
					p.y = GamePlayConfig_Tile_Height
				else
					p.y = -GamePlayConfig_Tile_Height
				end
				return p
			end
			item:transToOut(itemData, boardData, getP(boardData.transDirect))
			local startItem = boardView.baseMap[to_r][to_c]
			startItem:transToIn(itemData, boardData, getP(theAction.toBoardDataDirect), callback)
		else
			p = ccp((to_c - from_c) * GamePlayConfig_Tile_Width, -(to_r - from_r) * GamePlayConfig_Tile_Height)
			item:transToNext(p, callback)
		end
	elseif theAction.addInfo == "reInitView" then
		theAction.addInfo = "over"
		local to_r, to_c = theAction.ItemPos2.x, theAction.ItemPos2.y
		local itemData = theAction.itemData
		local boardData = theAction.boardData
		local item = boardView.baseMap[to_r][to_c]
		item:reInitByLogic(itemData, boardData)
	end
end


function BoardViewAction:runGameItemActionOctopusChangeForbiddenLevel(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local level = theAction.level
		local r, c = theAction.ItemPos1.y, theAction.ItemPos1.x
		local item = boardView.baseMap[r][c]
		local function callback ()
			theAction.addInfo = 'over'
		end
		item:playForbiddenLevelAnimation(level, true, callback)
	end
end

function BoardViewAction:runGameitemActionHoneyBottleBroken(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]
		local count = 0
		local total  = #theAction.infectList
		local function finishcallback( ... )
			-- body
			count = count + 1
			if count >= total then
				theAction.addInfo = "over"
			end
		end

		local function brokenCallback( ... )
			-- body
			for k, v in pairs(theAction.infectList) do 
				local itemInfect = boardView.baseMap[v.x][v.y]
				itemInfect:playBeInfectAnimation(item:getBasePosition(item.x, item.y), finishcallback)
			end
		end
		brokenCallback()
		item:playHoneyBottleBroken()
	end
end

function BoardViewAction:runGameitemActionMagicTileHit(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		local function finish()
			theAction.addInfo = 'over'
		end

		local scene = Director:sharedDirector():getRunningScene()
		local boss = boardView.gameBoardLogic:getHalloweenBoss()
		if boss then
			boss.hit = boss.hit + theAction.count
		end

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local pos = boardView.gameBoardLogic:getGameItemPosInView(r, c)
		local bossTile = scene.halloweenBoss
		theAction.bossPosition = bossTile:getSpriteWorldPosition()
		if bossTile and bossTile.refCocosObj then
			bossTile:playHit(pos, nil, theAction.count == boss.specialHit)
			bossTile:setBloodPercent(boss.hit / boss.totalBlood, true)
		end
		finish()
	end
end

function BoardViewAction:runGameitemActionHalloweenBossDie(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		local scene = Director:sharedDirector():getRunningScene()
		local boss = scene.halloweenBoss 
		local function finish()	
			boss:removeFromParentAndCleanup(true)
			scene.halloweenBoss = nil
			theAction.addInfo = 'died'
		end
		if boss then
			theAction.diePosition = boss:getSpriteWorldPosition()
			boss:playDie(finish)
		else
			finish()
		end

	elseif theAction.addInfo == 'died_action' then

		theAction.addInfo = ''

		local scene = Director:sharedDirector():getRunningScene()
		local toItemPos = theAction.destPositions
		
		local diePosition = theAction.diePosition
		local fromItemPos = boardView:TouchAt(diePosition.x, diePosition.y)
		if fromItemPos.y < 1 or fromItemPos.y > 9 then fromItemPos.y = 1 end
		fromItemPos.x = 1 -- 反正boss永远在第一行
		local fromItem = boardView.baseMap[fromItemPos.x][fromItemPos.y]

		local function dropCallback()
			if not theAction.completeCount then theAction.completeCount = 0 end
			theAction.completeCount = theAction.completeCount + 1
			if theAction.completeCount >= #toItemPos then
				theAction.addInfo = 'over'
			end
		end
		for k, v in pairs(toItemPos) do 
			local item = boardView.baseMap[v.r][v.c]
			item:playMaydayBossChangeToAddMove(boardView, fromItem, dropCallback, true)
		end
	end
end

function BoardViewAction:runGameitemActionHalloweenBossComeout(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		local function finish()
			theAction.addInfo = 'over'
		end

		local scene = Director:sharedDirector():getRunningScene()
		local scaleX, scaleY = boardView:getScaleX(), boardView:getScaleY()
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y

		local sprite = TileHalloweenBoss:create()
		sprite:setBloodPercent(0, false)
		sprite:setScale(scaleX)
		sprite:setPosition(scene:convertToNodeSpace(boardView:convertToWorldSpace(ccp(0, 540))))

		scene.halloweenBoss = sprite
		local fromPos = boardView.gameBoardLogic:getGameItemPosInView(r, c)
		local toPos = ccp(boardView:convertToNodeSpace(fromPos).x, 540)
		sprite:setSpriteX(toPos.x)
		local icon = Sprite:createWithSpriteFrameName('xmas_boss_iconfly_0000')
		boardView:addChild(icon)
		icon:setPosition(boardView:convertToNodeSpace(fromPos))
		local arr = CCArray:create()
		arr:addObject(
			CCEaseSineIn:create(CCSpawn:createWithTwoActions(
				CCMoveTo:create(0.5, ccp(toPos.x, toPos.y)),
				CCFadeTo:create(0.5, 100)
			)))
		arr:addObject(CCCallFunc:create(
			function() 
				if icon and icon.refCocosObj and not icon.isDisposed then
					icon:removeFromParentAndCleanup(true) 
					icon = nil
				end
				local view = boardView.baseMap[r][c]
				if view then
					view:clearHalloweenBoss()
				end
				if sprite then
					scene:addChild(sprite)					
					sprite:playComeout(finish)
				else
					finish()
				end

			end))
		icon:runAction(CCSequence:create(arr))	
	end
end

function BoardViewAction:runGameitemActionMagicTileChange(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
	
		local function finish()
			theAction.addInfo = 'over'
		end

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		if theAction.objective == 'die' then
			local item = boardView.baseMap[r][c]
			if item then
				item:deleteMagicTile()
			end
		elseif theAction.objective == 'color' then
			local item = boardView.baseMap[r][c]
			if item then
				item:changeMagicTileColor('red')
			end
		end	

		finish()
	end
end

function BoardViewAction:runGameitemActionHalloweenBossCasting(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
	
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local fromItem = boardView.baseMap[r][c]
		local scene = Director:sharedDirector():getRunningScene()

		local function finish() 
			theAction.addInfo = 'over'
		end

		local toItemPos = {} -- theAction.destPositions
		for k, v in pairs(theAction.destPositions) do
			table.insert(toItemPos, boardView.gameBoardLogic:getGameItemPosInView(v.r, v.c))
		end
		local boss = scene.halloweenBoss
		if boss then
			boss:playCasting(toItemPos, finish)
		else 
			finish()
		end
	end
end

function BoardViewAction:runGameItemActionSandTransfer(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		local fr, fc = theAction.ItemPos1.x, theAction.ItemPos1.y
		local tr, tc = theAction.ItemPos2.x, theAction.ItemPos2.y
		-- print("runGameItemActionSandTransfer:", fr,fc,"->",tr,tc)
		local fromItem = boardView.baseMap[fr][fc]
		local toItem = boardView.baseMap[tr][tc]
		local function callback( ... )
			theAction.addInfo = "add"
			toItem:addSandView(theAction.addInt)
		end
		local direction = {dr=tr-fr, dc=tc-fc}
		fromItem:playSandMoveAnim(callback, direction)
	end
end

function BoardViewAction:runningGameItemActionSandTransfer(boardView, theAction)
	if theAction.addInfo == "add" then
		theAction.addInfo = "over"
		local fr, fc = theAction.ItemPos1.x, theAction.ItemPos1.y
		local fromItem = boardView.baseMap[fr][fc]
		fromItem.itemSprite[ItemSpriteType.kSandMove]:removeFromParentAndCleanup(true)
		fromItem.itemSprite[ItemSpriteType.kSandMove] = nil
	end
end

----播放Item动画
function BoardViewAction:runGameItemAction(boardView, theAction)
	if theAction.actionType == GameItemActionType.kItemScore_Get then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionScoreGet(boardView, theAction)	
		end
	elseif theAction.actionType == GameItemActionType.kItemRefresh_Item_Flying then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionPassRefreshItemFlying(boardView, theAction)
			BoardViewAction:runGameItemActionRefresh_Item_Flying(boardView, theAction)	
		end
		if theAction.addInfo == "over" then
			BoardViewAction:runGameItemActionPassRefreshItemFlyingOver(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_Crystal_Change then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionItemCrystalChange(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_Venom_Spread then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionVenomSpread(boardView, theAction)
		elseif theAction.actionStatus == GameActionStatus.kRunning then 
			BoardViewAction:runningGameItemActionVenomSpread(boardView,theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_Furball_Transfer then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionFurballTransfer(boardView, theAction)
		elseif theAction.actionStatus == GameActionStatus.kRunning then
			BoardViewAction:runningGameItemActionFurballTransfer(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_Furball_Split then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionFurballSplit(boardView, theAction)
		elseif theAction.actionStatus == GameActionStatus.kRunning then
			BoardViewAction:runningGameItemActionFurballSplit(boardView, theAction)
		end		
	elseif theAction.actionType == GameItemActionType.kItem_Furball_Brown_Unstable then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionFurballUnstable(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_Furball_Brown_Shield then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionFurballShield(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItemShakeBySpecialColor then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionAnimalShakeBySpecialColor(boardView, theAction)
		elseif theAction.actionStatus == GameActionStatus.kRunning then
			BoardViewAction:runGameItemActionAnimalShakeBySpecialColor(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_Roost_Replace then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionRoostReplace(boardView, theAction)
		elseif theAction.actionStatus == GameActionStatus.kRunning then
			BoardViewAction:runningGameItemActionRoostReplace(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_Balloon_update then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then 
			BoardViewAction:runGameItemActionBalloonUpdateNum(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_balloon_runAway then 
		BoardViewAction:runGameItemViewActionBallooRunaway(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_ItemChangeToIngredient then 
		BoardViewAction:runGameItemViewActionChangeToIngredient( boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_ItemForceToMove then 
		BoardViewAction:runGameItemViewActionForceMoveItem(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_TileBlocker_Update then 
		BoardViewAction:runGameItemActionTileBlockerUpdate(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Monster_Jump then
		BoardViewAction:runGameItemActionMonsterJump( boardView, theAction )
	elseif theAction.actionType == GameItemActionType.kItem_Monster_Destroy_Item then
		BoardViewAction:runGameItemActionMonsterDestroyItem(boardView, theAction )
	elseif theAction.actionType == GameItemActionType.kItem_PM25_Update then
		BoardViewAction:runGameItemActionPM25Update(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Black_Cute_Ball_Update then
		BoardViewAction:runGameItemActionBlackCuteBallUpdate(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Mimosa_Grow then
		BoardViewAction:runGameItemActionMimosaGrow(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Mimosa_back then
		BoardViewAction:runGameItemActionMimosaBack(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Mimosa_Ready then
		BoardViewAction:runGameItemActionMimosaReady(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Snail_Road_Bright then
		BoardViewAction:runGameItemActionSnailRoadBright(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Snail_Product then
		BoardViewAction:runGameItemActionProductSnail(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Mayday_Boss_Die then
		BoardViewAction:runGameItemActionMaydayBossDie(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Mayday_Boss_Jump then
		BoardViewAction:runGameItemActionMaydayBossJump(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Rabbit_Product then 
		BoardViewAction:runGameitemActionProductRabbit(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kOctopus_Change_Forbidden_Level then
		BoardViewAction:runGameItemActionOctopusChangeForbiddenLevel(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Transmission then 
		BoardViewAction:runGameitemActionTransmission(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Area_Destruction then
		theAction.actionStatus = GameActionStatus.kRunning
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Lamp_Casting then
		BoardViewAction:runGameItemActionMagicLampCasting(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Lamp_Reinit then
		BoardViewAction:runGameItemActionMagicLampReinit(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Honey_Bottle_Broken then
		BoardViewAction:runGameitemActionHoneyBottleBroken(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Tile_Hit then
		BoardViewAction:runGameitemActionMagicTileHit(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Halloween_Boss_Die then
		BoardViewAction:runGameitemActionHalloweenBossDie(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Halloween_Boss_Create then
		BoardViewAction:runGameitemActionHalloweenBossComeout(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Tile_Change then
		BoardViewAction:runGameitemActionMagicTileChange(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Halloween_Boss_Casting then
		BoardViewAction:runGameitemActionHalloweenBossCasting(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Sand_Transfer then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			BoardViewAction:runGameItemActionSandTransfer(boardView, theAction)
		elseif theAction.actionStatus == GameActionStatus.kRunning then
			BoardViewAction:runningGameItemActionSandTransfer(boardView, theAction)
		end
	end
end

function BoardViewAction:runAllAction(boardView)
	if boardView and boardView.gameBoardLogic and boardView.gameBoardLogic.gameActionList then
		local actionList = boardView.gameBoardLogic.gameActionList
		for k,v in pairs(actionList) do
			if v.actionTarget == GameActionTargetType.kGameItemAction then
				BoardViewAction:runGameItemAction(boardView, v)
			end
		end
	end
end