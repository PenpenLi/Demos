DestroyItemLogic = class()

function DestroyItemLogic:update(mainLogic)
	local count1 = DestroyItemLogic:destroyDecision(mainLogic)
	local count2 = DestroyItemLogic:destroyExecutor(mainLogic)
	-- 检测blocker状态变化
	mainLogic:updateFallingAndBlockStatus()
	return count1 > 0 or count2 > 0
end

function DestroyItemLogic:destroyDecision(mainLogic)
	local count = 0
	local output = "destroy item: "
	local flag = false
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]

			if item.ItemStatus == GameItemStatusType.kIsSpecialCover 
				or item.ItemStatus == GameItemStatusType.kIsMatch
				then
				count = count + 1
				output = output .. string.format("(%d, %d) ", r, c)
				flag = true
				
				local specialType = mainLogic.gameItemMap[r][c].ItemSpecialType
				if specialType >= AnimalTypeConfig.kLine and specialType <= AnimalTypeConfig.kColor then
					BombItemLogic:BombItem(mainLogic, r, c, 1, 0)
				end

				if specialType ~= AnimalTypeConfig.kColor then
					item:AddItemStatus(GameItemStatusType.kDestroy)
					mainLogic:tryDoOrderList(r, c, GameItemOrderType.kAnimal, item.ItemColorType)
					local deletedAction = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemDeletedByMatch,
						IntCoord:create(r,c),
						nil,
						GamePlayConfig_GameItemAnimalDeleteAction_CD)

					if item.ItemType == GameItemType.kBalloon then 
						deletedAction.addInfo = "balloon"
					end

					mainLogic:addDestroyAction(deletedAction)
				end
			end
		end
	end
	if flag then
		-- print(output)
	end
	return count
end

function DestroyItemLogic:destroyExecutor(mainLogic)
	local count = 0
	for k,v in pairs(mainLogic.destroyActionList) do
		count = count + 1
		DestroyItemLogic:runLogicAction(mainLogic, v, k)
		DestroyItemLogic:runViewAction(mainLogic.boardView, v)
	end
	return count
end

function DestroyItemLogic:runLogicAction(mainLogic, theAction, actid)
	-- print('run DestroyItemLogic:runLogicAction')
	if theAction.actionStatus == GameActionStatus.kRunning then 		---running阶段，自动扣时间，到时间了，进入Death阶段
		if theAction.actionDuring < 0 then 
			theAction.actionStatus = GameActionStatus.kWaitingForDeath
		else
			theAction.actionDuring = theAction.actionDuring - 1
			DestroyItemLogic:runningGameItemAction(mainLogic, theAction, actid)
		end
	end

	if theAction.actionType == GameItemActionType.kItemDeletedByMatch then 			--被匹配消除
		DestroyItemLogic:runGameItemDeletedByMatch(mainLogic, theAction, actid)	
	elseif theAction.actionType == GameItemActionType.kItemCoverBySpecial
		or theAction.actionType == GameItemActionType.kItemCoverBySpecial_Color then 			--被特效消除
		DestroyItemLogic:runGameItemSpecialCoverAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_Color_ItemDeleted then 		----鸟和普通动物交换、爆炸---》普通物体最终被消耗掉
		DestroyItemLogic:runGameItemSpecialBombColorAction_ItemDeleted(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorColor_ItemDeleted then
		DestroyItemLogic:runGameItemSpecialBombColorColorAction_ItemDeleted(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemMatchAt_SnowDec then
		DestroyItemLogic:runGameItemSpecialSnowDec(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemMatchAt_VenowDec then
		DestroyItemLogic:runGameItemSpecialVenomDec(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Furball_Grey_Destroy then
		DestroyItemLogic:runGameItemSpecialGreyFurballDestroy(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemMatchAt_LockDec then
		DestroyItemLogic:runGameItemSpecialLockDec(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Roost_Upgrade then
		DestroyItemLogic:runGameItemRoostUpgrade(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_DigGroundDec then
		DestroyItemLogic:runGameItemDigGroundDecLogic(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_DigJewleDec then
		DestroyItemLogic:runGameItemDigJewelDecLogic(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Monster_frosting_dec then 
		DestroyItemLogic:runGameItemMonsterFrostingLogic(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Black_Cute_Ball_Dec then
		DestroyItemLogic:runGameItemBlackCuteBallDec(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Mayday_Boss_Loss_Blood then
		DestroyItemLogic:runningGameItemActionMaydayBossLossBlood(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Lamp_Charging then
		DestroyItemLogic:runningGameItemActionMagicLampCharging(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_WitchBomb then
		DestroyItemLogic:runningGameItemActionWitchBomb(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Honey_Bottle_increase then
		DestroyItemLogic:runningGameItemActionHoneyBottleIncrease(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItemDestroy_HoneyDec then
		DestroyItemLogic:runningGameItemActionHoneyDec(mainLogic, theAction, actid, actByView)
	end
end

function DestroyItemLogic:runningGameItemActionHoneyDec(mainLogic, theAction, actid, actByView)
	-- body
	if not theAction.hasMatch then
		theAction.hasMatch = true
		local r,c  = theAction.ItemPos1.x, theAction.ItemPos1.y
		mainLogic:checkItemBlock(r, c)
		mainLogic:addNeedCheckMatchPoint(r, c)
	elseif theAction.addInfo == "over" then
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runningGameItemActionWitchBomb(mainLogic, theAction, actid, actByView)

	if theAction.addInfo == 'over' then

		local interval = theAction.interval
		local intervalFrames = math.floor(interval * 60)
		theAction.frameCount = theAction.frameCount - 1
		if theAction.frameCount <= 0 and theAction.col > 0 then
			-- print('theAction.col', theAction.col)
			local c1, c2 = theAction.col, theAction.col
			local r1, r2 = theAction.rows.r1, theAction.rows.r2
			local item1 = mainLogic.gameItemMap[r1][c1]
			local item2 = mainLogic.gameItemMap[r2][c2]
			if item1 and item1.isEmpty == false then
				SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r1, c1, 1, true)  --可以作用银币
				BombItemLogic:tryCoverByBomb(mainLogic, r1, c1, true, 1)
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r1, c1, 3)
			end
			if item2 and item2.isEmpty == false then
				SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r2, c2, 1, true)  --可以作用银币
				BombItemLogic:tryCoverByBomb(mainLogic, r2, c2, true, 1)
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r2, c2, 3) 
			end
			theAction.col = theAction.col - 1
			theAction.frameCount = intervalFrames
		end
		if theAction.col <= 0 then
			-- print('action over')
			mainLogic.destroyActionList[actid] = nil
		end
	end
end

function DestroyItemLogic:runningGameItemActionHoneyBottleIncrease(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		mainLogic.destroyActionList[actid] = nil
	end

end

function DestroyItemLogic:runningGameItemActionMagicLampCharging(mainLogic, theAction, actid, actByView)
	local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
	local item = mainLogic.gameItemMap[r][c]


	-- bonus time不充能
	-- 灰色的不能充能
	if not item or item.ItemType ~= GameItemType.kMagicLamp
	or mainLogic.isBonusTime
	or item.lampLevel == 0 then
		mainLogic.destroyActionList[actid] = nil
		return
	end

	local count = theAction.count

	if item.lampLevel + count >= 5 then
		item.lampLevel = 5
	else
		item.lampLevel = item.lampLevel + count
	end

	local itemV = mainLogic.boardView.baseMap[r][c]
	itemV:setMagicLampLevel(item.lampLevel)

	-- 加上匹配检查点， 防止出现不三消的情况
	mainLogic:checkItemBlock(r,c)
	mainLogic:setNeedCheckFalling()
	mainLogic:addNeedCheckMatchPoint(r, c)
	mainLogic.destroyActionList[actid] = nil
end

function DestroyItemLogic:runningGameItemActionMaydayBossLossBlood(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == "over" then
		if theAction.completeCallback then
			theAction.completeCallback()
		end

		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runningGameItemAction(mainLogic, theAction, actid)
	if theAction.actionType == GameItemActionType.kItemSpecial_Color_ItemDeleted 
		or theAction.actionType == GameItemActionType.kItemSpecial_ColorColor_ItemDeleted then 			----鸟和普通动物交换，引起同色动物的消除
		DestroyItemLogic:runingGameItemSpecialBombColorAction_ItemDeleted(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_CollectIngredient then
		DestroyItemLogic:runningGameItem_CollectIngredient(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Mimosa_back then
		DestroyItemLogic:runningGameItemActionMimosaBack(mainLogic, theAction, actid)
	end
end

function DestroyItemLogic:runViewAction(boardView, theAction)
	if theAction.actionType == GameItemActionType.kItemDeletedByMatch then 			----Match消除
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestroyItemLogic:runGameItemDeletedByMatchAction(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItemCoverBySpecial
		or theAction.actionType == GameItemActionType.kItemCoverBySpecial_Color then  		----cover消除
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestroyItemLogic:runGameItemActionCoverBySpecial(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItemSpecial_Color_ItemDeleted 
		or theAction.actionType == GameItemActionType.kItemSpecial_ColorColor_ItemDeleted then 		----魔力鸟引起的消除
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestroyItemLogic:runGameItemActionBombSpecialColor_ItemDeleted(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_CollectIngredient then
		if theAction.addInfo == "Pass" then
			DestroyItemLogic:runGameItemActionCollectIngredient(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItemMatchAt_SnowDec then 		----产生雪块消除特效
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestroyItemLogic:runGameItemActionSnowDec(boardView, theAction)
		else
			local r1 = theAction.ItemPos1.x
			local c1 = theAction.ItemPos1.y
			if boardView.baseMap[r1][c1].itemSprite[ItemSpriteType.kSnowShow]~= nil
				and boardView.baseMap[r1][c1].itemSprite[ItemSpriteType.kSnowShow]:getParent() then ----已经被正常添加了父节点，删除特殊效果
				boardView.baseMap[r1][c1].itemSprite[ItemSpriteType.kSnowShow] = nil
			end
		end
	elseif theAction.actionType == GameItemActionType.kItemMatchAt_VenowDec then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestroyItemLogic:runGameItemActionVenomDec(boardView, theAction)
		end
	elseif theAction.actionType ==  GameItemActionType.kItem_Furball_Grey_Destroy then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestroyItemLogic:runGameItemActionGreyFurballDestroy(boardView, theAction)
		elseif theAction.actionStatus == GameActionStatus.kRunning then
			DestroyItemLogic:runningGameItemActionGreyFurballDestroy(boardView, theAction)	
		end
	elseif theAction.actionType == GameItemActionType.kItemMatchAt_LockDec then 		----产生牢笼消除特效
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestroyItemLogic:runGameItemActionLockDec(boardView, theAction)
		else
			local r1 = theAction.ItemPos1.x;
			local c1 = theAction.ItemPos1.y;
			if boardView.baseMap[r1][c1].itemSprite[ItemSpriteType.kLockShow]~= nil
				and boardView.baseMap[r1][c1].itemSprite[ItemSpriteType.kLockShow]:getParent() then ----已经被正常添加了父节点，删除特殊效果
				boardView.baseMap[r1][c1].itemSprite[ItemSpriteType.kLockShow] = nil;
			end
		end
	elseif theAction.actionType == GameItemActionType.kItem_Roost_Upgrade then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestroyItemLogic:runGameItemActionRoostUpgrade(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_DigGroundDec then
		DestroyItemLogic:runGameItemViewDigGroundDec(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_DigJewleDec then 
		DestroyItemLogic:runGameItemViewDigJewelDec(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Monster_frosting_dec then 
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestroyItemLogic:runGameItemViewMonsterFrostingDec(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_Black_Cute_Ball_Dec then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestroyItemLogic:runGameItemViewBlackCuteBallDec(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_Mimosa_back then
		DestroyItemLogic:runGameItemActionMimosaBack(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Mayday_Boss_Loss_Blood then
		DestroyItemLogic:runGameItemActionBossLossBlood(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Lamp_Charging then
		theAction.actionStatus = GameActionStatus.kRunning
	elseif theAction.actionType == GameItemActionType.kItem_WitchBomb then
		DestroyItemLogic:runGameItemActionWitchBomb(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Honey_Bottle_increase then 
		DestroyItemLogic:runGameItemActionHoneyBottleInc(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItemDestroy_HoneyDec then
		DestroyItemLogic:runGameItemActionHoneyDec(boardView, theAction)
	end
end

function DestroyItemLogic:runGameItemActionHoneyDec(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local function callback( ... )
			-- body
			theAction.addInfo = "over"
		end
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		itemView:playHoneyDec(callback)
	end
end

function DestroyItemLogic:runGameItemActionHoneyBottleInc(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		itemView:playHoneyBottleDec(theAction.addInt)
	end
end

function DestroyItemLogic:runGameItemActionWitchBomb(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning		
	
		theAction.addInfo = 'started'
		theAction.frameCount = math.ceil(theAction.startDelay * 60) -- 女巫飞到第九列的等待时间
		-- print('start', theAction.frameCount)

	elseif theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.addInfo == 'started' then
			theAction.frameCount = theAction.frameCount - 1
			if theAction.frameCount <= 0 then
				theAction.frameCount = 0 -- 爆炸立即开始
				-- print('started', theAction.frameCount)
				theAction.addInfo = "over"
			end
		end
	end
end

function DestroyItemLogic:runGameItemActionBossLossBlood(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local function callback( ... )
			-- body
			theAction.addInfo = "over"
		end

		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		itemView:updateBossBlood(theAction.addInt, true)
		itemView:playBossHit(boardView)
		callback()
	end
end

function DestroyItemLogic:runGameItemDeletedByMatch(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning and not theAction.isStarted then
		theAction.isStarted = true

		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		GameExtandPlayLogic:itemDestroyHandler(mainLogic, r1, c1)
	end

	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		local gameItem = mainLogic.gameItemMap[r1][c1]
		gameItem:cleanAnimalLikeData()
		mainLogic:setNeedCheckFalling()
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemSpecialCoverAction(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning and not theAction.isStarted then
		theAction.isStarted = true
		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		GameExtandPlayLogic:itemDestroyHandler(mainLogic, r1, c1)
	end

	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		if theAction.addInfo == "kAnimal" then
			local r1 = theAction.ItemPos1.x
			local c1 = theAction.ItemPos1.y
			local gameItem = mainLogic.gameItemMap[r1][c1]

			if (gameItem.ItemType == GameItemType.kAnimal 		-----动物
				or gameItem.ItemType == GameItemType.kCrystal
				or gameItem.ItemType == GameItemType.kGift 
				or gameItem.ItemType == GameItemType.kCoin
				or gameItem.ItemType == GameItemType.kBalloon
				or gameItem.ItemType == GameItemType.kAddMove
				or gameItem.ItemType == GameItemType.kAddTime)
				and not gameItem:hasFurball()
				then
 
				gameItem:cleanAnimalLikeData()
				mainLogic:setNeedCheckFalling()
			end
				
			mainLogic.destroyActionList[actid] = nil
		end
	end
end

function DestroyItemLogic:runGameItemSpecialBombColorAction_ItemDeleted(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		local r2 = theAction.ItemPos2.x
		local c2 = theAction.ItemPos2.y
		local gameItem = mainLogic.gameItemMap[r1][c1]
		local gameItem2 = mainLogic.gameItemMap[r2][c2]
		if r1 == r2 and c1 == c2 then
			print("Error!!! runGameItemSpecialBombColorAction_ItemDeleted deleted self")
		else
			GameExtandPlayLogic:itemDestroyHandler(mainLogic, r1, c1)
			gameItem:cleanAnimalLikeData()
			gameItem2.isEmpty = false
		end

		mainLogic:setNeedCheckFalling()
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemSpecialBombColorColorAction_ItemDeleted(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		local r2 = theAction.ItemPos2.x
		local c2 = theAction.ItemPos2.y
		local gameItem = mainLogic.gameItemMap[r1][c1]
		local gameItem2 = mainLogic.gameItemMap[r2][c2]

		GameExtandPlayLogic:itemDestroyHandler(mainLogic, r1, c1)
		gameItem:cleanAnimalLikeData()

		mainLogic:setNeedCheckFalling()
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemSpecialSnowDec(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.addInfo == "update" then
			theAction.addInfo = ""
			mainLogic.gameItemMap[theAction.ItemPos1.x][theAction.ItemPos1.y].isNeedUpdate = true
		end
	elseif theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		mainLogic.gameItemMap[theAction.ItemPos1.x][theAction.ItemPos1.y].isNeedUpdate = true
		mainLogic.boardmap[theAction.ItemPos1.x][theAction.ItemPos1.y].isNeedUpdate = true
		--雪花只有在爆完最后一层后才需要检测
		if theAction.addInt == 1 then
			mainLogic:checkItemBlock(theAction.ItemPos1.x, theAction.ItemPos1.y)
			mainLogic:setNeedCheckFalling()
		end
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemSpecialVenomDec(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		mainLogic:checkItemBlock(theAction.ItemPos1.x, theAction.ItemPos1.y)
		mainLogic.gameItemMap[theAction.ItemPos1.x][theAction.ItemPos1.y].isNeedUpdate = true
		mainLogic.boardmap[theAction.ItemPos1.x][theAction.ItemPos1.y].isNeedUpdate = true
		mainLogic:markVenomDestroyedInStep()
		mainLogic:setNeedCheckFalling()
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemSpecialGreyFurballDestroy(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then
		if not theAction.hasMatch then
			theAction.hasMatch = true
			local r = theAction.ItemPos1.x
			local c = theAction.ItemPos1.y
			local item = mainLogic.gameItemMap[r][c]
			mainLogic:addNeedCheckMatchPoint(r, c)
			mainLogic:setNeedCheckFalling()
		end
	elseif theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemSpecialLockDec(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then
		if not theAction.hasMatch then
			theAction.hasMatch = true
			local r = theAction.ItemPos1.x
			local c = theAction.ItemPos1.y
			local item = mainLogic.gameItemMap[r][c]
			mainLogic:checkItemBlock(r,c)
			mainLogic:setNeedCheckFalling()
			mainLogic:addNeedCheckMatchPoint(r, c)
		end
	elseif theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemRoostUpgrade(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runingGameItemSpecialBombColorAction_ItemDeleted(mainLogic, theAction, actid)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y
	local color = theAction.addInt

	local item1 = mainLogic.gameItemMap[r1][c1] 		----消除动物
	local item2 = mainLogic.gameItemMap[r2][c2] 		----魔力鸟来源

	if theAction.addInfo == "" then
		theAction.addInfo = "Pass"						----引起界面动画计算
	elseif theAction.addInfo == "Pass" then
		theAction.addInfo = "doing" 					----数据运算等待中----结束运算在函数runGameItemSpecialBombColorAction_ItemDeleted中
	end
end

function DestroyItemLogic:runningGameItem_CollectIngredient(mainLogic, theAction, actid)
	if theAction.addInfo == "Pass" then
		theAction.addInfo = "waiting1"
	elseif theAction.addInfo == "waiting1" then
		if theAction.actionDuring == 0 then 
			local r1 = theAction.ItemPos1.x
			local c1 = theAction.ItemPos1.y
			local item1 = mainLogic.gameItemMap[r1][c1] 		----豆荚位置
			item1:cleanAnimalLikeData()
			mainLogic:setNeedCheckFalling()
			mainLogic.destroyActionList[actid] = nil
		end
	end
end

function DestroyItemLogic:runGameItemDeletedByMatchAction(boardView, theAction) 		----animal被删除
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local itemView = boardView.baseMap[r1][c1]
	local itemSprite = itemView:getItemSprite(ItemSpriteType.kItem)
	theAction.actionStatus = GameActionStatus.kRunning
	
	if  theAction and theAction.addInfo == "balloon" then
		boardView.baseMap[r1][c1]:playBalloonBombEffect()
	else
		boardView.baseMap[r1][c1]:playAnimationAnimalDestroy()
	end
end

function DestroyItemLogic:runGameItemActionCoverBySpecial(boardView, theAction)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	theAction.actionStatus = GameActionStatus.kRunning

	if theAction.addInfo == "kAnimal" then
		boardView.baseMap[r1][c1]:playAnimationAnimalDestroy()
	elseif theAction.addInfo == "kLock" then
	elseif theAction.addInfo == "kCrystal" then 
	elseif theAction.addInfo == "kGift" then
	end
end

function DestroyItemLogic:runGameItemActionBombSpecialColor_ItemDeleted(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local position1 = DestroyItemLogic:getItemPosition(theAction.ItemPos1)
	local position2 = DestroyItemLogic:getItemPosition(theAction.ItemPos2)

	local item = boardView.baseMap[r1][c1]
	item:playAnimationAnimalDestroyByBird(position1, position2)
end

function DestroyItemLogic:runGameItemActionCollectIngredient(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y

	local item1 = boardView.baseMap[r1][c1]

	item1:playCollectIngredientAction(boardView, boardView.IngredientActionPos)
end

function DestroyItemLogic:runGameItemActionSnowDec(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	theAction.addInfo = "update"

	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local item = boardView.baseMap[r1][c1]
	item:playSnowDecEffect(theAction.addInt)
	GamePlayMusicPlayer:playEffect(GameMusicType.kSnowBreak)
end

function DestroyItemLogic:runGameItemActionVenomDec(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning

	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local item = boardView.baseMap[r1][c1]
	item:playVenomDestroyEffect()
end

function DestroyItemLogic:runGameItemActionGreyFurballDestroy(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	local r = theAction.ItemPos1.x
	local c = theAction.ItemPos1.y

	local item = boardView.baseMap[r][c]

	item:playGreyFurballDestroyEffect()
end

function DestroyItemLogic:runningGameItemActionGreyFurballDestroy(boardView, theAction)
	if theAction.actionDuring == 1 then
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]
		item:cleanFurballView()
	end
end

function DestroyItemLogic:runGameItemActionLockDec(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning

	local r1 = theAction.ItemPos1.x;
	local c1 = theAction.ItemPos1.y;
	local item = boardView.baseMap[r1][c1];
	item:playLockDecEffect();
end

function DestroyItemLogic:runGameItemActionRoostUpgrade(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning

	local r = theAction.ItemPos1.x
	local c = theAction.ItemPos1.y

	local item = boardView.baseMap[r][c]
	local times = theAction.addInt
	item:playRoostUpgradeAnimation(times)
end

function DestroyItemLogic:runGameItemDigGroundDecLogic( mainLogic,  theAction, actid)
	-- body
	if theAction.actionStatus == GameActionStatus.kRunning then 
		if theAction.actionDuring == GamePlayConfig_GameItemDigGroundDeleteAction_CD - 4 then
			local item = mainLogic.gameItemMap[theAction.ItemPos1.x][theAction.ItemPos1.y]
			if item then item.digBlockCanbeDelete = true end
		end
	end

	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		
		local item = mainLogic.gameItemMap[theAction.ItemPos1.x][theAction.ItemPos1.y]
		if item.digGroundLevel == 0 then
			item:cleanAnimalLikeData()
			mainLogic:checkItemBlock(theAction.ItemPos1.x, theAction.ItemPos1.y)
			mainLogic:setNeedCheckFalling()
		end
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemViewDigGroundDec( boardView, theAction )
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then 
		theAction.actionStatus = GameActionStatus.kRunning
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]

		item:playDigGroundDecAnimation(boardView)
	end
end

function DestroyItemLogic:runGameItemDigJewelDecLogic( mainLogic,  theAction, actid)
	-- body
	if theAction.actionStatus == GameActionStatus.kRunning then 
		if theAction.actionDuring == GamePlayConfig_GameItemDigJewelDeleteAction_CD - 4 then
			local item = mainLogic.gameItemMap[theAction.ItemPos1.x][theAction.ItemPos1.y]
			if item then item.digBlockCanbeDelete = true end
		end
	end

	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		if item.digJewelLevel == 0 then
			GameExtandPlayLogic:itemDestroyHandler(mainLogic, r, c)
			item:cleanAnimalLikeData()
			mainLogic:checkItemBlock(theAction.ItemPos1.x, theAction.ItemPos1.y)
			mainLogic:setNeedCheckFalling()
		end
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemViewDigJewelDec( boardView, theAction )
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then 
		theAction.actionStatus = GameActionStatus.kRunning
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]
		item:playDigJewelDecAnimation(boardView)
	end
end

function DestroyItemLogic:runGameItemViewMonsterFrostingDec(boardView, theAction)
	-- body
	local function animationCallback( ... )
		-- body
		theAction.actionStatus = GameActionStatus.kWaitingForDeath
	end
	theAction.actionStatus = GameActionStatus.kRunning
	local r = theAction.ItemPos1.x
	local c = theAction.ItemPos1.y
	local item = boardView.baseMap[r][c]
	item:playMonsterFrostingDec(animationCallback)

	local r_m , c_m = BigMonsterLogic:findTheMonster( boardView.gameBoardLogic, r, c )
	if r_m and c_m then
		local item_monster = boardView.baseMap[r_m][c_m]
		item_monster:playMonsterEncourageAnimation()
	end
end

function DestroyItemLogic:runGameItemMonsterFrostingLogic(mainLogic, theAction, actid)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then 
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemViewBlackCuteBallDec(boardView, theAction)
	-- body
	local function animationCallback( ... )
		-- body
		theAction.actionStatus = GameActionStatus.kWaitingForDeath
	end
	theAction.actionStatus = GameActionStatus.kRunning
	local r = theAction.ItemPos1.x
	local c = theAction.ItemPos1.y
	local item = boardView.baseMap[r][c]
	local currentStrength = theAction.blackCuteStrength
	item:playBlackCuteBallDecAnimation(currentStrength, animationCallback)
end

function DestroyItemLogic:runGameItemBlackCuteBallDec(mainLogic, theAction, actid)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForDeath then 
		local currentStrength = theAction.blackCuteStrength
		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		if currentStrength == 0 then 
			if item then 
				GameExtandPlayLogic:itemDestroyHandler(mainLogic, r, c)
				item:cleanAnimalLikeData()
				mainLogic:checkItemBlock(theAction.ItemPos1.x, theAction.ItemPos1.y)
				mainLogic:setNeedCheckFalling()
			end
		else

		end
		item.lastInjuredStep = mainLogic.realCostMove
		mainLogic.destroyActionList[actid] = nil
	end
end

function DestroyItemLogic:runGameItemActionMimosaBack(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		local function callback( ... )
			-- body
			theAction.addInfo = "over"
		end

		local list = theAction.mimosaHoldGrid
		local time = 0
		for k = 1, #list do 
			local r, c = list[k].x, list[k].y
			local itemView = boardView.baseMap[r][c]
			local call_func = k==#list and callback or nil
			itemView:playMimosaEffectAnimation(theAction.direction, time * (#list - k),  call_func, false)
		end

		local r = theAction.ItemPos1.x
		local c = theAction.ItemPos1.y
		local itemView = boardView.baseMap[r][c]
		itemView:playMimosaBackAnimation(time)
	end

end

function DestroyItemLogic:runningGameItemActionMimosaBack(mainLogic, theAction, actid)
	-- body
	if theAction.addInfo == "over" then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		local list = item.mimosaHoldGrid
		for k, v in pairs(list) do 
			local item_grid = mainLogic.gameItemMap[v.x][v.y]
			item_grid.beEffectByMimosa = false
			item_grid.mimosaDirection = 0
			mainLogic:checkItemBlock(v.x, v.y)
			mainLogic:addNeedCheckMatchPoint(v.x, v.y)
		end
		FallingItemLogic:preUpdateHelpMap(mainLogic)
		item.mimosaHoldGrid = {}
		if theAction.completeCallback then
			theAction.completeCallback()
		end

		mainLogic.destroyActionList[actid] = nil
	end

end


function DestroyItemLogic:getItemPosition(itemPos)
	local x = (itemPos.y - 0.5 ) * GamePlayConfig_Tile_Width
	local y = (GamePlayConfig_Max_Item_Y - itemPos.x - 0.5 ) * GamePlayConfig_Tile_Height
	return ccp(x,y)
end
