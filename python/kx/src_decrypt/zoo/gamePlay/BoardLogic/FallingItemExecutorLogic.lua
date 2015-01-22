
FallingItemExecutorLogic = class{}

function FallingItemExecutorLogic:update(mainLogic)
	BoardViewPass:runAllAction(mainLogic.boardView)
	local count = FallingItemExecutorLogic:runAllAction(mainLogic)
	return count > 0
end

function FallingItemExecutorLogic:runAllAction(mainLogic)
	local count = 0
	for k,v in pairs(mainLogic.fallingActionList) do
		count = count + 1
		FallingItemExecutorLogic:runViewAction(mainLogic.boardView, v)
		FallingItemExecutorLogic:runLogicAction(mainLogic, v, k)
	end
	return count
end

function FallingItemExecutorLogic:runLogicAction(mainLogic, theAction, actid)
	-- if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		-- theAction.actionStatus = GameActionStatus.kRunning
	if theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.actionDuring < 0 then 
			theAction.actionStatus = GameActionStatus.kWaitingForDeath
		else
			theAction.actionDuring = theAction.actionDuring - 1
			FallingItemExecutorLogic:runningGameItemAction(mainLogic, theAction, actid)
		end
	end
end

function FallingItemExecutorLogic:runningGameItemAction(mainLogic, theAction, actid)
	if theAction.actionType == GameItemActionType.kItemFalling_UpDown then
		FallingItemExecutorLogic:runningGameItemFallingUpDown(mainLogic,theAction,actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItemFalling_LeftRight then
		FallingItemExecutorLogic:runningGameItemFallingLeftRight(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItemFalling_Product then
		FallingItemExecutorLogic:runningGameItemFallingProduct(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItemFalling_Pass then
		FallingItemExecutorLogic:runningGameItemFallingPass(mainLogic, theAction, actid, actByView)
	end
end

function FallingItemExecutorLogic:runViewAction(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
	end
end

function FallingItemExecutorLogic:runningGameItemFallingUpDown(mainLogic, theAction, actid, actByView)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local item1 = mainLogic.gameItemMap[r1][c1] 		----上方方块
	local item2 = mainLogic.gameItemMap[r2][c2] 		----下面空位

	--------1.掉落过程中可能被干掉------
	if (item2.ItemStatus == GameItemStatusType.kIsMatch 	----被合成或者特效消除
		or item2.ItemStatus == GameItemStatusType.kIsSpecialCover
		or item2.ItemStatus == GameItemStatusType.kDestroy)
		then
		item2.gotoPos = nil
		item2.comePos = nil
		item2.isNeedUpdate = true
		item1.isNeedUpdate = true
		mainLogic.fallingActionList[actid] = nil
		return
	end

	---------2.掉落结束了---------
	if theAction.addInfo == "over" then
		if (item2.ItemStatus == GameItemStatusType.kJustStop) then
			item2:AddItemStatus(GameItemStatusType.kItemHalfStable) 			----半稳定态
			mainLogic:setNeedCheckFalling()
			item2.isNeedUpdate = true
		end
		mainLogic.fallingActionList[actid] = nil	----删除动作------目标驱动类的动作----
		return 
	end

	---------3.开始掉落---Sprite进行传递------
	if theAction.addInfo == "" then
		theAction.addInfo = "Pass"				--告诉界面进行sprite传递
		------删除原有Item数据-------
	elseif theAction.addInfo == "Pass" then
		theAction.addInfo = "Falling" 			----继续掉落
	end

	if (item2.itemSpeed == 0) then 						----初始速度
		item2.itemSpeed = GamePlayConfig_FallingSpeed_Start
	end 

	-----------4.检测撞车------减速------------
	------------4.1检测撞车---》直接撞上-------
	if (r2 + 1 <= #mainLogic.gameItemMap) then 		----范围之内
		local item3 = mainLogic.gameItemMap[r2 + 1][c2]
		if item3.isUsed then 						----使用中
			if item3.ItemStatus == GameItemStatusType.kIsFalling then 				----掉落中
				if item3.itemSpeed>0 
					and item3.comePos ~= nil
					and item3.comePos.x == r2
					and item3.comePos.y == c2
					and item2.itemSpeed > item3.itemSpeed
					and item3.itemPosAdd.y > item2.itemPosAdd.y - item2.itemSpeed --要撞车了
					then
					item2.itemSpeed = item3.itemSpeed - GamePlayConfig_FallingSpeed_Add
					if (item2.itemSpeed < 0 ) then item2.itemSpeed = 0 end
					item2.itemPosAdd.y = item3.itemPosAdd.y + item2.itemSpeed + GamePlayConfig_FallingSpeed_Add
				end
			end
		end
	end
  
	------------4.2检测撞车---》下方是一个通道,检测通道对面-------
	----------位置修正，因为下面的还没有掉下去呢.
	local board2 = mainLogic.boardmap[r2][c2]
	if board2:hasEnterPortal() then
		local r3 = board2.passExitPoint_x;
		local c3 = board2.passExitPoint_y;
		local item3 = mainLogic.gameItemMap[r3][c3]
		if item3.itemSpeed>0 
			and item3.comePos ~= nil
			and item3.comePos.x == r2
			and item3.comePos.y == c2
			and item2.itemSpeed > item3.itemSpeed
			and item3.itemPosAdd.y > item2.itemPosAdd.y - item2.itemSpeed --要撞车了
			then
			item2.itemSpeed = item3.itemSpeed - GamePlayConfig_FallingSpeed_Add
			if (item2.itemSpeed < 0 ) then item2.itemSpeed = 0 end
			item2.itemPosAdd.y = item3.itemPosAdd.y + item2.itemSpeed + GamePlayConfig_FallingSpeed_Add
		end
	end

	item2.itemSpeed = item2.itemSpeed + GamePlayConfig_FallingSpeed_Add 		----求新的速度
	if item2.itemSpeed > GamePlayConfig_FallingSpeed_Max then item2.itemSpeed = GamePlayConfig_FallingSpeed_Max end
	item2.itemPosAdd.y = item2.itemPosAdd.y - item2.itemSpeed					----求新位置

	-----5.处理使得上面的方块进入下面,本次小段掉落结束------
	if item2.itemPosAdd.y <= 0 then 
		item2.dataReach = true	 											----数据抵达，能被特效消除
		item2.gotoPos = nil
		item2.comePos = nil
		if mainLogic.gameMode:afterStable(r2, c2) then
			item2.itemPosAdd.y = 0											----位置修正
			item2.itemSpeed = 0												----速度变0
		else
			local fallType = FallingItemLogic:checkStopFallingDown(mainLogic, r2, c2)
			if fallType == 1 then 
			elseif fallType == 2 then
				item2.itemPosAdd.y = 0
				item2.itemSpeed = 0
			else
				item2.itemPosAdd.y = 0
				item2.itemSpeed = 0	
				-- item2.ItemStatus = GameItemStatusType.kJustStop					----半稳定态

				item2:AddItemStatus(GameItemStatusType.kItemHalfStable)
				mainLogic.fallingActionList[actid] = nil
			end
		end
		theAction.addInfo = "over"											----该动作结束
	elseif item2.itemPosAdd.y <= GamePlayConfig_Tile_Height / 2.0 then
		item2.dataReach = true												----可以被爆掉了
		theAction.addInfo = "halfover"
	end

	-----6.更新显示位置--------
	item1.isNeedUpdate = true
	item2.isNeedUpdate = true
end

function FallingItemExecutorLogic:runningGameItemFallingLeftRight(mainLogic, theAction, actid, actByView)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local item1 = mainLogic.gameItemMap[r1][c1] 		----上方方块
	local item2 = mainLogic.gameItemMap[r2][c2] 		----下面空位

	if (item2.ItemStatus == GameItemStatusType.kIsMatch 	----被合成或者特效消除
		or item2.ItemStatus == GameItemStatusType.kIsSpecialCover
		or item2.ItemStatus == GameItemStatusType.kDestroy)
		then
		item2.gotoPos = nil
		item2.comePos = nil
		item2.isNeedUpdate = true
		item1.isNeedUpdate = true
		mainLogic.fallingActionList[actid] = nil;
		return
	end

	if theAction.addInfo == "over" then
		if (item2.ItemStatus == GameItemStatusType.kJustStop) then
			item2:AddItemStatus(GameItemStatusType.kItemHalfStable)			----半稳定态
			mainLogic:setNeedCheckFalling()
			item2.isNeedUpdate = true;
		end
		mainLogic.fallingActionList[actid] = nil;	----删除动作------目标驱动类的动作----
		return 
	end

	if theAction.addInfo == "" then
		theAction.addInfo = "Pass"				--告诉界面进行sprite传递
	elseif theAction.addInfo == "Pass" then
		theAction.addInfo = "Falling" 			----继续掉落
	end

	item2.itemPosAdd.y = item2.itemPosAdd.y - GamePlayConfig_Falling_LeftRight_Speed_Y 					------修改位置
	item2.itemPosAdd.x = item2.itemPosAdd.x - (c1 - c2) * GamePlayConfig_Falling_LeftRight_Speed_X 		------修改位置
	
	if item2.itemPosAdd.y <= 0 then 
		item2.dataReach = true	 											----数据抵达，能被特效消除
		item2.gotoPos = nil
		item2.comePos = nil
		if mainLogic.gameMode:afterStable(r2, c2) then
			item2.itemPosAdd.y = 0											----位置修正
			item2.itemSpeed = 0												----速度变0
		else
			local fallType = FallingItemLogic:checkStopFallingDown(mainLogic, r2, c2)
			if fallType == 1 then 
			elseif fallType == 2 then
			else
				item2:AddItemStatus(GameItemStatusType.kItemHalfStable)
				mainLogic.fallingActionList[actid] = nil
			end
			item2.itemPosAdd.y = 0
			item2.itemSpeed = 0
		end
		theAction.addInfo = "over"											----该动作结束
	elseif item2.itemPosAdd.y <= GamePlayConfig_Tile_Height / 2.0 then
		item2.dataReach = true												----可以被爆掉了
		theAction.addInfo = "halfover"
	end

	-----更新显示位置--------
	item1.isNeedUpdate = true
	item2.isNeedUpdate = true
end

function FallingItemExecutorLogic:runningGameItemFallingProduct(mainLogic, theAction, actid, actByView)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local item1 = mainLogic.gameItemMap[r1][c1] 		----生成位置

	if (item1.ItemStatus == GameItemStatusType.kIsMatch 	----被合成或者特效消除
		or item1.ItemStatus == GameItemStatusType.kIsSpecialCover
		or item1.ItemStatus == GameItemStatusType.kDestroy)
		then
		item1.gotoPos = nil
		item1.comePos = nil
		item1.isNeedUpdate = true
		mainLogic.fallingActionList[actid] = nil

		local itemView1 = mainLogic.boardView.baseMap[r1][c1]
		itemView1:cleanClippingSpriteOfItem()
		return
	end

	---------结束结算----------
	if theAction.addInfo == "over" then
		if (item1.ItemStatus == GameItemStatusType.kJustStop) then
			item1:AddItemStatus(GameItemStatusType.kItemHalfStable)			----半稳定态
			item1.isNeedUpdate = true;
			mainLogic:setNeedCheckFalling()
		end
		mainLogic.fallingActionList[actid] = nil;	----删除动作------目标驱动类的动作----
		return 
	end
	
	---------位置修正--------------
	if theAction.addInfo == "Pass" then
		theAction.addInfo = "Falling"
	end

	local item2 = mainLogic:getGameItemAt(r2, c2) 		----下方方块
	if item2 ~= nil and item2.ItemStatus == GameItemStatusType.kIsFalling and item2.itemSpeed > 0 then
		item1.itemSpeed = item2.itemSpeed
	else
		if (item1.itemSpeed == 0) then 												----初始速度
			item1.itemSpeed = GamePlayConfig_FallingSpeed_Start
		end 
		item1.itemSpeed = item1.itemSpeed + GamePlayConfig_FallingSpeed_Add 		----求新的速度		
	end

	if item1.itemSpeed > GamePlayConfig_FallingSpeed_Max then item1.itemSpeed = GamePlayConfig_FallingSpeed_Max end
	item1.ClippingPosAdd.y = item1.ClippingPosAdd.y - item1.itemSpeed						----求新位置
	item1.itemPosAdd.y = item1.ClippingPosAdd.y

	-----------1.处理使得方块正式进入-------------------
	if item1.ClippingPosAdd.y <= 0 then 
		item1.dataReach = true 												----数据抵达，能被特效消除
		item1.isProduct = false
		item1.gotoPos = nil;
		item1.comePos = nil;

		----视图从clippingNode转移到正常图层
		local itemView1 = mainLogic.boardView.baseMap[r1][c1]
		itemView1:takeClippingNodeToSprite(item1)

		if mainLogic.gameMode:afterStable(r1, c1) then
			item1.ClippingPosAdd.y = 0;										----位置修正
			item1.itemPosAdd.y = 0;
			item1.itemSpeed = 0;											----速度变0
		else
			local fallType = FallingItemLogic:checkStopFallingDown(mainLogic, r1, c1)
			if fallType == 1 then 	----不能再掉落了
			elseif fallType == 2 then
				item1.itemPosAdd.y = 0											----位置修正
				item1.itemSpeed = 0												----速度变0
			else
				item1.ClippingPosAdd.y = 0;										----位置修正
				item1.itemPosAdd.y = 0;
				item1.itemSpeed = 0;											----速度变0
				-- item1:AddItemStatus(GameItemStatusType.kJustStop);				----暂停状态
				item1:AddItemStatus(GameItemStatusType.kItemHalfStable)
				mainLogic.fallingActionList[actid] = nil
			end
		end
		theAction.addInfo = "over"
	elseif item1.ClippingPosAdd.y <= GamePlayConfig_Tile_Height / 2.0 then
		item1.dataReach = true												----可以被爆掉了
		theAction.addInfo = "halfover"
	end

	item1.isNeedUpdate = true
end

--------掉落时生成新的Item
function FallingItemExecutorLogic:runningGameItemFallingPass(mainLogic, theAction, actid, actByView)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local item1 = mainLogic.gameItemMap[r1][c1] 		----上方方块
	local item2 = mainLogic.gameItemMap[r2][c2] 		----下面空位

	if (item2.ItemStatus == GameItemStatusType.kIsMatch 	----被合成或者特效消除
		or item2.ItemStatus == GameItemStatusType.kIsSpecialCover
		or item2.ItemStatus == GameItemStatusType.kDestroy)
		then
		item2.gotoPos = nil
		item2.comePos = nil
		item2.isNeedUpdate = true
		mainLogic.fallingActionList[actid] = nil

		local itemView1 = mainLogic.boardView.baseMap[r1][c1]
		local itemView2 = mainLogic.boardView.baseMap[r2][c2]
		itemView1:cleanEnterClippingSpriteOfItem()
		itemView2:cleanClippingSpriteOfItem()
		return
	end

	---------结束结算----------
	if theAction.addInfo == "over" then
		if (item2.ItemStatus == GameItemStatusType.kJustStop) then
			item2:AddItemStatus(GameItemStatusType.kItemHalfStable)			----半稳定态
			item2.isNeedUpdate = true
			mainLogic:setNeedCheckFalling()
		end
		mainLogic.fallingActionList[actid] = nil	----删除动作------目标驱动类的动作----
		return 
	end

	---------位置修正--------------

	if theAction.addInfo == "Pass" then
		theAction.addInfo = "Falling"
	end

	if (item2.itemSpeed == 0) then 						----初始速度
		item2.itemSpeed = GamePlayConfig_FallingSpeed_Start
	end 
	----------------检测撞车------减速------------
	if (r2 + 1 < #mainLogic.gameItemMap) then 		----范围之内
		local item3 = mainLogic.gameItemMap[r2 + 1][c2]
		if item3.isUsed then 						----使用中
			if item3.ItemStatus == GameItemStatusType.kIsFalling then 				----掉落中
				if item3.itemSpeed>0 
					and item3.comePos ~= nil
					and item3.comePos.x == r2
					and item3.comePos.y == c2
					and item2.itemSpeed > item3.itemSpeed
					and item3.itemPosAdd.y > item2.itemPosAdd.y - item2.itemSpeed --要撞车了
					then
					item2.itemSpeed = item3.itemSpeed - GamePlayConfig_FallingSpeed_Add
					if (item2.itemSpeed < 0 ) then item2.itemSpeed = 0 end
					item2.itemPosAdd.y = item3.itemPosAdd.y + item2.itemSpeed + GamePlayConfig_FallingSpeed_Add
				end
			end
		end
	end

	item2.itemSpeed = item2.itemSpeed + GamePlayConfig_FallingSpeed_Add 		----求新的速度
	if item2.itemSpeed > GamePlayConfig_FallingSpeed_Max then item2.itemSpeed = GamePlayConfig_FallingSpeed_Max end
	item2.ClippingPosAdd.y = item2.ClippingPosAdd.y - item2.itemSpeed			----求新位置
	item2.itemPosAdd.y = item2.ClippingPosAdd.y

	item1.EnterClippingPosAdd.y = item2.ClippingPosAdd.y - item1.h
	
	-----------1.处理使得方块正式进入-------------------
	if item2.ClippingPosAdd.y <= 0 then 
		item2.dataReach = true 											----数据抵达，能被特效消除
		item2.isProduct = false
		item2.gotoPos = nil
		item2.comePos = nil

		----视图从clippingNode转移到正常图层
		local itemView1 = mainLogic.boardView.baseMap[r1][c1]
		local itemView2 = mainLogic.boardView.baseMap[r2][c2]	
		itemView2:takeClippingNodeToSprite(item2)
		itemView1:cleanEnterClippingSpriteOfItem()
		itemView1.isNeedUpdate = true
		itemView2.isNeedUpdate = true

		if mainLogic.gameMode:afterStable(r2, c2) then
			item2.ClippingPosAdd.y = 0										----位置修正
			item2.itemPosAdd.y = 0
			item2.itemSpeed = 0												----速度变0
		else
			local fallType = FallingItemLogic:checkStopFallingDown(mainLogic, r2, c2) 
			if fallType == 1 then 
			elseif fallType == 2 then
				item2.itemPosAdd.y = 0											----位置修正
				item2.itemSpeed = 0												----速度变0
			else
				item2.ClippingPosAdd.y = 0										----位置修正
				item2.itemPosAdd.y = 0
				item2.itemSpeed = 0												----速度变0
				-- item2:AddItemStatus(GameItemStatusType.kJustStop)				----暂停状态
				item2:AddItemStatus(GameItemStatusType.kItemHalfStable)
				mainLogic.fallingActionList[actid] = nil
			end
		end
		theAction.addInfo = "over"
	elseif item2.ClippingPosAdd.y <= GamePlayConfig_Tile_Height / 2.0 then
		item2.dataReach = true												----可以被爆掉了
		theAction.addInfo = "halfover"
	end

	item1.isNeedUpdate = true
	item2.isNeedUpdate = true
end
