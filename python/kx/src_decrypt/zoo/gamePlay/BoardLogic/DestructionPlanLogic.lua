DestructionPlanLogic = class()

function DestructionPlanLogic:update(mainLogic)
	local count = 0
	for k,v in pairs(mainLogic.destructionPlanList) do
		count = count + 1
		DestructionPlanLogic:runLogicAction(mainLogic, v, k)
		DestructionPlanLogic:runViewAction(mainLogic.boardView, v)
	end
	return count > 0
end

function DestructionPlanLogic:runLogicAction(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then 		---running阶段，自动扣时间，到时间了，进入Death阶段
		if theAction.actionDuring < 0 then 
			theAction.actionStatus = GameActionStatus.kWaitingForDeath
		else
			theAction.actionDuring = theAction.actionDuring - 1
			DestructionPlanLogic:runningGameItemAction(mainLogic, theAction, actid)
		end
	-- elseif theAction.actionStatus == GameActionStatus.kWaitingForStart then
		-- theAction.actionStatus = GameActionStatus.kRunning
	elseif theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		mainLogic:resetSpecialEffectList(actid)  --- 特效生命周期中对同一个障碍(boss)的作用只有一次的保护标志位重置
		mainLogic.destructionPlanList[actid] = nil
	end
end

function DestructionPlanLogic:runViewAction(boardView, theAction)
	if theAction.actionType == GameItemActionType.kItemSpecial_Line then 			----横排消除
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestructionPlanLogic:runGameItemActionBombSpecialLine(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItemSpecial_Column then 			----竖排消除
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestructionPlanLogic:runGameItemActionBombSpecialColumn(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItemSpecial_Wrap then 			----区域消除
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestructionPlanLogic:runGameItemActionBombSpecialWrap(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItemSpecial_WrapWrap then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestructionPlanLogic:runGameItemActionBombSpecialWrapWrap(boardView, theAction)
		end			
	elseif theAction.actionType == GameItemActionType.kItemSpecial_Color then 			----魔力鸟
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestructionPlanLogic:runGameItemActionBombSpecialColor(boardView, theAction)
		end
		if theAction.addInfo == "Over" then
			DestructionPlanLogic:runGameItemActionBombSpecialColor_End(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorLine then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestructionPlanLogic:runGameItemActionBombBirdLine(boardView, theAction)				----鸟和直线交换之后
		end
		if theAction.addInfo == "BombTime" then
			DestructionPlanLogic:runGameItemActionBombBirdLine_End(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorLine_flying then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestructionPlanLogic:runGameItemActionBombBirdLineFlying(boardView, theAction)		----鸟和直线交换之后，飞出的特效
		end
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorWrap then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestructionPlanLogic:runGameItemActionBombBirdLine(boardView, theAction)				----鸟和(区域)交换之后
		end
		if theAction.addInfo == "BombTime" then
			DestructionPlanLogic:runGameItemActionBombBirdLine_End(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorWrap_flying then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestructionPlanLogic:runGameItemActionBombBirdLineFlying(boardView, theAction)		----鸟和(区域)交换之后，飞出的特效
		end
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorColor then
		if theAction.actionStatus == GameActionStatus.kWaitingForStart then
			DestructionPlanLogic:runGameItemActionBombBirdBird(boardView, theAction)				----鸟鸟交换之后
		end
		if theAction.addInfo == "BombAll" then
			DestructionPlanLogic:runGameItemActionBirdBirdExplode(boardView, theAction)
		elseif theAction.addInfo == "CleanAll" then
			DestructionPlanLogic:runGameItemActionBombBirdBird_End(boardView, theAction)
		end
	elseif theAction.actionType == GameItemActionType.kItem_Snail_Move then
		DestructionPlanLogic:runGameItemActionSnailMove(boardView, theAction)
	end
end

function DestructionPlanLogic:runningGameItemAction(mainLogic, theAction, actid)

	if theAction.actionType == GameItemActionType.kItemSpecial_Line then 
		DestructionPlanLogic:runingGameItemSpecialBombLineAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_Column then 
		DestructionPlanLogic:runingGameItemSpecialBombColumnAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_Wrap then 
		DestructionPlanLogic:runingGameItemSpecialBombWrapAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_WrapWrap then
		DestructionPlanLogic:runingGameItemSpecialBombWrapWrapAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_Color then 						----鸟和普通动物交换、爆炸
		DestructionPlanLogic:runingGameItemSpecialBombColorAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorLine then 					----鸟和直线特效交换----
		DestructionPlanLogic:runingGameItemSpecialBombColorLineAction(mainLogic, theAction, actid, AnimalTypeConfig.kLine)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorLine_flying then 			----鸟和直线交换之后，飞行的小鸟----
		DestructionPlanLogic:runingGameItemSpecialBombColorLineAction_flying(mainLogic, theAction, actid, AnimalTypeConfig.kLine)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorWrap then 					----鸟和直线特效交换----
		DestructionPlanLogic:runingGameItemSpecialBombColorLineAction(mainLogic, theAction, actid, AnimalTypeConfig.kWrap)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorWrap_flying then 			----鸟和直线交换之后，飞行的小鸟----
		DestructionPlanLogic:runingGameItemSpecialBombColorLineAction_flying(mainLogic, theAction, actid, AnimalTypeConfig.kWrap)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_ColorColor then 					----鸟鸟消除
		DestructionPlanLogic:runingGameItemSpecialBombColorColorAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Snail_Move then
		DestructionPlanLogic:runningGameItemActionSnailMove(mainLogic, theAction, actid)
	end
end

function DestructionPlanLogic:runGameItemActionSnailMove(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		theAction.addInfo ="moveStart"
		theAction.addInt = 30
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]
		item:playSnailInShellAnimation(theAction.direction)
	elseif theAction.addInfo == "moving" then
		theAction.addInfo = ""
		local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
		local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
		local item1 = boardView.baseMap[r1][c1]
		local item2 = boardView.baseMap[r2][c2]
		if item2.itemSprite[ItemSpriteType.kSnailMove] ~= nil then
			theAction.addInfo = "moving"
		else
			item2.itemSprite[ItemSpriteType.kSnailMove] = item1.itemSprite[ItemSpriteType.kSnailMove]
			item1.itemSprite[ItemSpriteType.kSnailMove] = nil
			local rotation 
			if c2 - c1 == 1 then rotation = 0 
			elseif c2 - c1 == -1 then rotation = 180
			elseif r2 - r1 == 1 then rotation = 90
			elseif r2 - r1 == -1 then rotation = -90 end
			theAction.addInfo = "moveEnd"
			theAction.addInt = 12
			item2:playSnailMovingAnimation(rotation)
		end

		
	elseif theAction.addInfo == "disappear" then
		theAction.addInfo = ""
		local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
		local item2 = boardView.baseMap[r2][c2]
		theAction.addInfo = "over"
		theAction.addInt = 40
		item2:playSnailDisappearAnimation()
	elseif theAction.addInfo == "normal" then
		theAction.addInfo = ""
		local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
		local item2 = boardView.baseMap[r2][c2]
		theAction.addInfo = "over"
		theAction.addInt = 30
		item2:playSnailOutShellAnimation(theAction.direction)
	end

end

function DestructionPlanLogic:runningGameItemActionSnailMove(mainLogic, theAction, actid)
	-- body
	if theAction.addInt > 1 then 
		theAction.addInt = theAction.addInt - 1
		return 
	end
	
	if theAction.addInfo == "moveStart" then
		local list = theAction.moveList
		
		if #list > 0 then
			local pos = table.remove(list, 1)
			theAction.ItemPos1 = theAction.ItemPos2 or theAction.ItemPos1
			theAction.ItemPos2 = pos
			theAction.addInfo = "moving"
		else
			local r, c = theAction.ItemPos2.x, theAction.ItemPos2.y
			local board = mainLogic.boardmap[r][c]
			if board.isSnailCollect then
				theAction.addInfo = "disappear"
			else
				theAction.addInfo = "normal"
				theAction.direction = board.snailRoadType
			end

		end
	elseif theAction.addInfo == "moveEnd" then
		theAction.addInfo = "moveStart"
		local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item1 = mainLogic.gameItemMap[r1][c1]
		local board1 = mainLogic.boardmap[r1][c1]
		SnailLogic:resetSnailRoadAtPos( mainLogic, r1, c1 )

		if item1.isSnail then 
			item1:cleanAnimalLikeData()
			-- item1.isBlock = false
			item1.isSnail = false
		end

		if board1.snailTargetCount > 0 then 
			board1.snailTargetCount = board1.snailTargetCount - 1
		end

		if board1.snailTargetCount > 0 then 
			item1.snailTarget = true
		else
			item1.snailTarget = false
		end

		mainLogic:checkItemBlock(r1, c1)

		local r, c = theAction.ItemPos2.x, theAction.ItemPos2.y
		local item2 = mainLogic.gameItemMap[r][c]
		local board2 = mainLogic.boardmap[r][c]

		board2.snailTargetCount = board2.snailTargetCount + 1
		item2.snailTarget = true
		SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, 1)
		BombItemLogic:tryCoverByBomb(mainLogic, r, c, true, 1)
		SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3)
		mainLogic:checkItemBlock(r, c)
	elseif theAction.addInfo == "over" then
		local r, c = theAction.ItemPos2.x, theAction.ItemPos2.y
		local board = mainLogic.boardmap[r][c]
		local itemdata = mainLogic.gameItemMap[r][c]
		if board.isSnailCollect then
			board.snailTargetCount = board.snailTargetCount - 1
			if  board.snailTargetCount > 0 then 
				itemdata.snailTarget = true 
			else
				itemdata.snailTarget = false
			end

			ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_Collect_Snail)

			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r, c),
				nil,
				1)
			ScoreAction.addInt = GamePlayConfig_Score_Collect_Snail
			mainLogic:addGameAction(ScoreAction)

			mainLogic:tryDoOrderList(r,c,GameItemOrderType.kSpecialTarget, GameItemOrderType_ST.kSnail, 1)
		else
			itemdata:changeToSnail(board.snailRoadType)
		end
		SnailLogic:resetSnailRoadAtPos( mainLogic, r, c )
		mainLogic:checkItemBlock(r, c)
		if theAction.completeCallback then
			theAction.completeCallback()
		end

		mainLogic.destructionPlanList[actid] = nil
	end
end

function DestructionPlanLogic:getActionTime(CDCount)
	return 1.0 / GamePlayConfig_Action_FPS * CDCount
end

function DestructionPlanLogic:runingGameItemSpecialBombWrapWrapAction(mainLogic, theAction, actid)
	local function getRectBombPos(length, r, c)
		local result = {}
		local rowOffset = r - math.floor(length / 2) - 1
		local colOffset = c - math.floor(length / 2)

		for i = 1, length do
			for j = math.abs(i - 1 - math.floor(length / 2)), length - 1 - math.abs(i - 1 - math.floor(length / 2)) do
				local p = { c = j + colOffset, r = i + rowOffset }
				table.insert(result, p)
			end
		end

		return result
	end

	if theAction.actionDuring == 1 then
		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y

		local r2 = theAction.ItemPos2.x
		local c2 = theAction.ItemPos2.y

		local scoreScale = 4
		local mergePos = {}
		local pos1Rect = getRectBombPos(9, r1, c1)
		local pos2Rect = getRectBombPos(9, r2, c2)

		for i,v in ipairs(pos1Rect) do
			mergePos[v.c .. "_" .. v.r] = v
		end
		for i,v in ipairs(pos2Rect) do
			mergePos[v.c .. "_" .. v.r] = v
		end

		for k,v in pairs(mergePos) do
			if v.r >= 1 and v.r <= #mainLogic.boardmap
				and v.c >= 1 and v.c <= #mainLogic.boardmap[v.r] 
				then
				SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, v.r, v.c, scoreScale)
				BombItemLogic:tryCoverByBomb(mainLogic, v.r, v.c, true, scoreScale)
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, v.r, v.c, 3, scoreScale, actid)
			end
		end
		GamePlayMusicPlayer:playEffect(GameMusicType.kSwapWrapWrap);
	end
end

function DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, r, c, lightUpMatchPosList)
	if lightUpMatchPosList then
		for i,v in ipairs(lightUpMatchPosList) do
			if v.r == r and v.c == c then
				return true
			end
		end
	end
	return false
end

function DestructionPlanLogic:getItemPosition(itemPos)
	local x = (itemPos.y - 0.5 ) * GamePlayConfig_Tile_Width
	local y = (GamePlayConfig_Max_Item_Y - itemPos.x - 0.5 ) * GamePlayConfig_Tile_Height
	return ccp(x,y)
end

----直线（横线）消除特效的执行中逻辑
----一点点展开
function DestructionPlanLogic:runingGameItemSpecialBombLineAction(mainLogic, theAction, actid)
	if theAction.addInfo == "over" then
		return
	end

	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local scoreScale = theAction.addInt2

	if theAction.addInt == 0 then
		local item = mainLogic.gameItemMap[r1][c1]
		if item.ItemStatus == GameItemStatusType.kWaitBomb then item.ItemStatus = GameItemStatusType.kNone end
		theAction.lightUpBombMatchPosList = item.lightUpBombMatchPosList
		theAction.extendOffset = 0

		if not DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, r1, c1, theAction.lightUpBombMatchPosList) then
			SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r1, c1, scoreScale)
		end
		BombItemLogic:tryCoverByBomb(mainLogic, r1, c1, true, 0, true)----加过分数的---
		SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r1, c1, 1, nil, actid) ----原点---
	end

	theAction.addInt = theAction.addInt + 1

	local addCD = GamePlayConfig_SpecialBomb_Line_Add_CD
	if addCD <= 0 then addCD = 1 end
	local maxRange = math.floor(theAction.addInt / addCD)

	if c1 - theAction.extendOffset <= 0 and c1 + theAction.extendOffset > #mainLogic.gameItemMap[r1] then
		theAction.addInfo = "over"
		return
	end

	local offset = theAction.extendOffset + 1
	local output = "destroy items "

	while offset <= maxRange do
		c2 = c1 - offset
		c3 = c1 + offset

		output = output .. string.format("(%d, %d) ", r1, c2) .. string.format("(%d, %d)", r1, c3)

		if theAction.addInfo ~= "left" then
			if c1 ~= c2 and mainLogic:isPosValid(r1, c2) and mainLogic.gameItemMap[r1][c2].dataReach then
				if not DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, r1, c2, theAction.lightUpBombMatchPosList) then
					SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r1, c2, scoreScale)
				end
				local s1 = BombItemLogic:tryCoverByBomb(mainLogic, r1, c2, false, scoreScale)  		----左边
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r1, c2, 1, scoreScale, actid)
				if s1 == 2 then   ----遇到银币
					if theAction.addInfo == "" then
						theAction.addInfo = "left"			----左部终止
					elseif theAction.addInfo == "right" then
						theAction.addInfo = "over"			----全部终止
						return
					end
				end
			end
		end

		if theAction.addInfo ~= "right" then
			if c1 ~= c3 and mainLogic:isPosValid(r1, c3) and mainLogic.gameItemMap[r1][c3].dataReach then
				if not DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, r1, c3, theAction.lightUpBombMatchPosList) then
					SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r1, c3, scoreScale)
				end
				local s2 = BombItemLogic:tryCoverByBomb(mainLogic, r1, c3, false, scoreScale) 			----右边
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r1, c3, 1, scoreScale, actid)
				if s2 == 2 then 
					if theAction.addInfo == "" then
						theAction.addInfo = "right"
					elseif theAction.addInfo == "left" then
						theAction.addInfo = "over"
						return
					end
				end
			end
		end

		theAction.extendOffset = offset
		offset = offset + 1
	end
	-- print(output)
end

----直线（竖排）消除特效执行中逻辑
function DestructionPlanLogic:runingGameItemSpecialBombColumnAction(mainLogic, theAction, actid)
	if theAction.addInfo == "over" then
		return 
	end
	----执行一次就over----
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local scoreScale = theAction.addInt2
	local item = mainLogic.gameItemMap[r1][c1]

	theAction.addInfo = "over"
	theAction.lightUpBombMatchPosList = item.lightUpBombMatchPosList

	if item.ItemStatus == GameItemStatusType.kWaitBomb then item.ItemStatus = GameItemStatusType.kNone end
	if not DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, r1, c1, theAction.lightUpBombMatchPosList) then
		SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r1, c1, 2)
	end
	BombItemLogic:tryCoverByBomb(mainLogic, r1, c1, true, 0, true)----加过分数的---
	SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r1, c1, 2, nil, actid) ----原点---

	for i=r1 + 1, #mainLogic.gameItemMap do
		if not DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, i, c1, theAction.lightUpBombMatchPosList) then
			SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, i, c1, scoreScale)
		end
		local s1 = BombItemLogic:tryCoverByBomb(mainLogic, i, c1, true, scoreScale, true) 		----空中的也炸掉
		SpecialCoverLogic:SpecialCoverAtPos(mainLogic, i, c1, 2, scoreScale, actid)
		if s1 == 2 then break end----遇到银币
	end

	for i=r1 - 1, 0, -1 do
		if not DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, i, c1, theAction.lightUpBombMatchPosList) then
			SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, i, c1, scoreScale)
		end
		local s1 = BombItemLogic:tryCoverByBomb(mainLogic, i, c1, true, scoreScale, true) 		----空中的也炸掉
		SpecialCoverLogic:SpecialCoverAtPos(mainLogic, i, c1, 2, scoreScale, actid )
		if s1 == 2 then break end----遇到银币
	end
end

function DestructionPlanLogic:runingGameItemSpecialBombWrapAction(mainLogic, theAction, actid)
	local function getRectBombPos(length, r, c)
		local result = {}
		local rowOffset = r - math.floor(length / 2) - 1
		local colOffset = c - math.floor(length / 2)

		for i = 1, length do
			for j = math.abs(i - 1 - math.floor(length / 2)), length - 1 - math.abs(i - 1 - math.floor(length / 2)) do
				local p = { c = j + colOffset, r = i + rowOffset }
				table.insert(result, p)
			end
		end

		return result
	end

	if theAction.addInfo == "over" then
		return 
	end

	----执行一次就over----
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local item = mainLogic.gameItemMap[r1][c1]
	local scoreScale = theAction.addInt2
	theAction.addInfo = "over"
	theAction.lightUpBombMatchPosList = item.lightUpBombMatchPosList

	if item.ItemStatus == GameItemStatusType.kWaitBomb then 
		item.ItemStatus = GameItemStatusType.kNone 
	end

	local bombPosList = getRectBombPos(5, r1, c1)

	for k,v in ipairs(bombPosList) do
		if mainLogic:isPosValid(v.r, v.c) and mainLogic.gameItemMap[v.r][v.c].dataReach then
			if not DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, v.r, v.c, theAction.lightUpBombMatchPosList) then
				SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, v.r, v.c, scoreScale)
			end
			if v.r == r1 and v.c == c1 then
				BombItemLogic:tryCoverByBomb(mainLogic, v.r, v.c, true, 0, true)
			else
				BombItemLogic:tryCoverByBomb(mainLogic, v.r, v.c, true, scoreScale)
			end
			SpecialCoverLogic:SpecialCoverAtPos(mainLogic, v.r, v.c, 3, scoreScale, actid)
		end
	end
end

--------鸟和某个颜色动物交换引起的爆炸
function DestructionPlanLogic:runingGameItemSpecialBombColorAction(mainLogic, theAction, actid)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local item1 = mainLogic.gameItemMap[r1][c1]

	if theAction.addInfo == "" or theAction.addInfo == "Pass" then
		theAction.addInfo = "start"
		-----进入开始阶段----鸟消失动画-------------按照特效消除的方式消失而不是Match
		----1.分数
		if item1.ItemStatus == GameItemStatusType.kWaitBomb then item1.ItemStatus = GameItemStatusType.kNone end
		local addScore = GamePlayConfig_Score_Swap_ColorAnimal
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r1,c1),				
			nil,				
			1)
		ScoreAction.addInt = addScore
		mainLogic:addGameAction(ScoreAction)

		-----2.动画
		item1:AddItemStatus(GameItemStatusType.kDestroy)
		local CoverAction =	GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemCoverBySpecial_Color,
			IntCoord:create(r1,c1),
			nil,
			GamePlayConfig_SpecialBomb_BirdAnimal_Time1)
		CoverAction.addInfo = "kAnimal"
		mainLogic:addDestroyAction(CoverAction)
		mainLogic.gameItemMap[r1][c1].gotoPos = nil
		mainLogic.gameItemMap[r1][c1].comePos = nil
		mainLogic.gameItemMap[r1][c1].isEmpty = false

		----特效影响-----
		local scoreScale = theAction.addInt2
		SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r1, c1, scoreScale)
		SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r1, c1, 3, nil, actid)
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r1, c1 )
		return
	elseif theAction.addInfo == "start" then
		theAction.addInfo = "waiting"
		-----进入等待阶段----鸟正在播放动画-----
		return
	elseif theAction.addInfo == "waiting" then
		-----等待鸟动画完毕，进入爆炸阶段-----
		if theAction.actionDuring <= GamePlayConfig_SpecialBomb_BirdAnimal_Time3 then
			theAction.addInfo = "shake"

			local color = theAction.addInt
			if color == 0 then
				color = mainLogic:getBirdEliminateColor()
				theAction.addInt = color
			end
			local posList = mainLogic:getPosListOfColor(color)
			for k,v in pairs(posList) do
				local itemBomb = mainLogic.gameItemMap[v.x][v.y]
				if itemBomb:canBeCoverByBirdAnimal() 
					and itemBomb.ItemType == GameItemType.kAnimal
					and itemBomb.ItemSpecialType == 0 
					and not itemBomb:hasFurball() 
					and not itemBomb:hasLock() 
					and (itemBomb.ItemStatus == GameItemStatusType.kItemHalfStable 
						or itemBomb.ItemStatus == GameItemStatusType.kNone) 
					then
					local ShakeAction = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemShakeBySpecialColor,
						IntCoord:create(v.x, v.y),
						nil,
						GamePlayConfig_SpecialBomb_BirdAnimal_Shake_Time)
					mainLogic:addGameAction(ShakeAction)
				end
			end
		end
	elseif theAction.addInfo == "shake" then
		if theAction.actionDuring <= GamePlayConfig_SpecialBomb_BirdAnimal_Time2 then
			theAction.addInfo = "bomb"
		end
	elseif theAction.addInfo == "bomb" then
		-----等着结束的阶段-----
		theAction.addInfo = "nothing"
	end

	if theAction.addInfo == "nothing" and theAction.actionDuring == 1 then ----最后一帧
		theAction.addInfo = "Over"
	end

	if theAction.addInfo == "bomb" then
		local color = theAction.addInt
		if color == 0 then
			------消掉目前颜色最多的-----
			color = mainLogic:getBirdEliminateColor()
		end
		----被引爆---
		local posList = mainLogic:getPosListOfColor(color)
		for k,v in pairs(posList) do
			local itemBomb = mainLogic.gameItemMap[v.x][v.y]
			if itemBomb:canBeCoverByBirdAnimal() then 			----可以被消除的东西
				local scoreScale = theAction.addInt2
				SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, v.x, v.y, scoreScale)
				BombItemLogic:tryCoverByBird(mainLogic, v.x, v.y, r1, c1, scoreScale)
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, v.x, v.y, 3, scoreScale, actid) 	----被鸟引爆----
			end
		end
	end
end

----鸟和直线特效交换----
function DestructionPlanLogic:runingGameItemSpecialBombColorLineAction(mainLogic, theAction, actid, sptype)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y
	local item1 = mainLogic.gameItemMap[r1][c1] 		----魔力鸟
	local item2 = mainLogic.gameItemMap[r2][c2]		----直线特效
	local color = theAction.addInt
	local scoreScale = theAction.addInt2

	if theAction.addInfo == "" or theAction.addInfo == "Pass" then
		theAction.addInfo = "start"
		-----进入开始阶段----鸟消失动画-------------按照特效消除的方式消失而不是Match
		----1.1分数
		local sp2 = item2.ItemSpecialType
		local addScore = GamePlayConfig_Score_Swap_ColorLine
		if sp2 == AnimalTypeConfig.kWrap then addScore = GamePlayConfig_Score_Swap_ColorWrap end
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r1,c1),				
			nil,				
			1)
		ScoreAction.addInt = addScore
		mainLogic:addGameAction(ScoreAction)
		----1.2动画效果
		item1:AddItemStatus(GameItemStatusType.kDestroy)
		local CoverAction =	GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemCoverBySpecial_Color,
			IntCoord:create(r1,c1),
			nil,
			GamePlayConfig_SpecialBomb_BirdLine_Time2 + GamePlayConfig_SpecialBomb_BirdLine_Time4)
		CoverAction.addInfo = "kAnimal"
		mainLogic:addDestroyAction(CoverAction)
		mainLogic.gameItemMap[r1][c1].gotoPos = nil
		mainLogic.gameItemMap[r1][c1].comePos = nil
		SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r1, c1, 3)
		return
	elseif theAction.addInfo == "start" then
		theAction.addInfo = "waiting1" 		----第一次等待
	elseif theAction.addInfo == "waiting1" then
		if theAction.actionDuring == GamePlayConfig_SpecialBomb_BirdLine_Time1 - GamePlayConfig_SpecialBomb_BirdLine_Time2 then
			------开始飞行------
			theAction.addInfo = "flyingBird"
			------飞行及标记------
			BombItemLogic:setSignOfBombResWithBirdFlying(mainLogic, r1, c1, color, sptype) 			----全部变成直线特效----(区域)
			item2.bombRes = IntCoord:create(r1, c1)
		end
	elseif theAction.addInfo == "flyingBird" then
		theAction.addInfo = "waiting2"			----飞行等待
	elseif theAction.addInfo == "waiting2" then
		if theAction.actionDuring == GamePlayConfig_SpecialBomb_BirdLine_Time1 - GamePlayConfig_SpecialBomb_BirdLine_Time4 then
			------进入引爆时间-----
			theAction.addInfo = "BombTime"
		end
	elseif theAction.addInfo == "BombTime" then
		----挨个引爆----直到没有可以引爆的为止，进入结束状态-----
		local xtime = GamePlayConfig_SpecialBomb_BirdLine_Time1 - theAction.actionDuring - GamePlayConfig_SpecialBomb_BirdLine_Time4 		----已经经过的时间
		if xtime > 0 and xtime % math.ceil(GamePlayConfig_SpecialBomb_BirdLine_Time5) == 0 then ----每隔一段时间
			if (BombItemLogic:tryBombWithBombRes(mainLogic, r1, c1, 1, scoreScale)) then
				----引爆某一个
			else
				----失败了----没有可以引爆的了，----爆炸结束----
				theAction.addInfo = "Over"
			end
		end
	elseif theAction.addInfo == "Over" then
		mainLogic.destructionPlanList[actid] = nil	----删除动作------目标驱动类的动作----
	end
end

----鸟和直线特效交换----鸟向四处飞----
function DestructionPlanLogic:runingGameItemSpecialBombColorLineAction_flying(mainLogic, theAction, actid, sptype)
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y
	local color = theAction.addInt

	local item1 = mainLogic.gameItemMap[r1][c1] 		----消除动物
	local item2 = mainLogic.gameItemMap[r2][c2] 		----魔力鸟来源

	if theAction.actionDuring == 1 then  		----结束----
		if (sptype == AnimalTypeConfig.kLine or sptype == AnimalTypeConfig.kColumn) then
			GameExtandPlayLogic:itemDestroyHandler(mainLogic, r1, c1)
			item1.ItemType = GameItemType.kAnimal
			item1.ItemSpecialType = mainLogic.randFactory:rand(AnimalTypeConfig.kLine, AnimalTypeConfig.kColumn)
			item1.isNeedUpdate = true
		elseif (sptype == AnimalTypeConfig.kWrap) then
			GameExtandPlayLogic:itemDestroyHandler(mainLogic, r1, c1)
			item1.ItemType = GameItemType.kAnimal
			item1.ItemSpecialType = AnimalTypeConfig.kWrap
			item1.isNeedUpdate = true
		end
		theAction.addInfo = "Over"
	end
end

----鸟鸟交换----
function DestructionPlanLogic:runingGameItemSpecialBombColorColorAction(mainLogic, theAction, actid)
	local function getSpecialBombPosList()
		local result = {}
		for r = 1, #mainLogic.gameItemMap do
			for c = 1, #mainLogic.gameItemMap[r] do
				if (BombItemLogic:canBeBombByBirdBird(mainLogic, r, c)) 
					and (r1 ~= r or c1 ~= c) and (r2 ~= r or c2 ~= c) 
					then
					table.insert(result, mainLogic:getGameItemPosInView(r, c))
				end
			end
		end
		return result
	end

	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local item1 = mainLogic.gameItemMap[r1][c1] 		----鸟1
	local item2 = mainLogic.gameItemMap[r2][c2] 		----鸟2
	local scoreScale = theAction.addInt2

	if theAction.addInfo == "" or theAction.addInfo == "Pass" then
		theAction.addInfo = "start"
		-----进入开始阶段----鸟消失动画-------------按照特效消除的方式消失而不是Match
		----1.分数
		local addScore = GamePlayConfig_Score_Swap_ColorColor
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r1,c1),				
			nil,				
			1)
		ScoreAction.addInt = addScore
		mainLogic:addGameAction(ScoreAction)

		-----2.动画
		item1:AddItemStatus(GameItemStatusType.kDestroy)
		local CoverAction1 = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemCoverBySpecial_Color,
			IntCoord:create(r1,c1),
			nil,
			GamePlayConfig_SpecialBomb_BirdBird_Time2) ----炸掉鸟的时间
		CoverAction1.addInfo = "kAnimal"
		mainLogic:addDestroyAction(CoverAction1)
		mainLogic.gameItemMap[r1][c1].gotoPos = nil
		mainLogic.gameItemMap[r1][c1].comePos = nil
		SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r1, c1, 3)
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r1, c1 )
		item2:AddItemStatus(GameItemStatusType.kDestroy)
		local CoverAction2 = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemCoverBySpecial_Color,
			IntCoord:create(r2,c2),
			nil,
			GamePlayConfig_SpecialBomb_BirdBird_Time2) ----炸掉鸟的时间
		CoverAction2.addInfo = "kAnimal"
		mainLogic:addDestroyAction(CoverAction2)
		mainLogic.gameItemMap[r2][c2].gotoPos = nil
		mainLogic.gameItemMap[r2][c2].comePos = nil
		SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r1, c1, 3)
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r2, c2 )
		GamePlayMusicPlayer:playEffect(GameMusicType.kSwapColorColorSwap)

		return
	elseif theAction.addInfo == "start" then
		theAction.addInfo = "waiting1"
		theAction.addInt = 1
	elseif theAction.addInfo == "waiting1" then
		--------第一次等待-------
		if mainLogic:isItemAllStable()
			and mainLogic:numDestrunctionPlan() == 1 
			then
			------停止掉落了-----
			----进入下一个阶段----
			theAction.addInfo = "BombAll"
			theAction.bombList = getSpecialBombPosList()
			theAction.addInt = 1
		else
			theAction.addInt = 1----重新计时----
		end
	elseif theAction.addInfo == "BombAll" then
		if theAction.addInt >= GamePlayConfig_SpecialBomb_BirdBird_Time3 then
			theAction.addInfo = "waiting2"
			BombItemLogic:BombAll(mainLogic)--------引爆所有特效
			theAction.addInt = 1
		end
		theAction.addInt = theAction.addInt + 1
	elseif theAction.addInfo == "waiting2" then
		--------第二次等待-------
		if mainLogic:isItemAllStable()
			and mainLogic:numDestrunctionPlan() == 1 
			then
			theAction.addInfo = "shake"
		else
			theAction.addInt = 1----重新计时----
		end
	elseif theAction.addInfo == "shake" then
		if theAction.addInt == 1 then
			for r = 1, #mainLogic.gameItemMap do
				for c = 1, #mainLogic.gameItemMap[r] do
					local item = mainLogic.gameItemMap[r][c]
					if item:isItemCanBeEliminateByBridBird() then
						local ShakeAction = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItemShakeBySpecialColor,
							IntCoord:create(r, c),
							nil,
							GamePlayConfig_SpecialBomb_BirdBird_Time4)
						mainLogic:addGameAction(ShakeAction)
					end
				end
			end

		end

		theAction.addInt = theAction.addInt + 1
		if (theAction.addInt >= GamePlayConfig_SpecialBomb_BirdBird_Time4) then
			----进入下一个阶段----
			theAction.addInfo = "CleanAll"
			theAction.addInt = 0
		end
	elseif theAction.addInfo == "CleanAll" then
		theAction.addInt = theAction.addInt + 1
		if theAction.addInt >= 1 then
			local birdBirdPos = { r = theAction.ItemPos1.x, c = theAction.ItemPos1.y }
	 		BombItemLogic:tryCoverByBirdBird(mainLogic, birdBirdPos, 1, scoreScale)
			theAction.addInfo = "waiting3"

			GamePlayMusicPlayer:playEffect(GameMusicType.kSwapColorColorCleanAll)
		end
	elseif theAction.addInfo == "waiting3" then
		theAction.addInt = theAction.addInt + 1
		if (theAction.addInt >= GamePlayConfig_SpecialBomb_BirdBird_Time5) then
			----进入下一个阶段----
			theAction.addInfo = "Over"
		end
	elseif theAction.addInfo == "Over" then
		mainLogic.destructionPlanList[actid] = nil
	end
end


function DestructionPlanLogic:runGameItemActionBombSpecialLine(boardView, theAction) 		----播放横排直线爆炸特效
	theAction.actionStatus = GameActionStatus.kRunning
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local position1 = DestructionPlanLogic:getItemPosition(theAction.ItemPos1)
	local effect = CommonEffect:buildLineEffect(boardView.specialEffectBatch)
	effect:setPosition(position1)
	
	boardView.specialEffectBatch:addChild(effect)
end 

function DestructionPlanLogic:runGameItemActionBombSpecialColumn(boardView, theAction)		----播放竖排直线爆炸特效
	-- body
	theAction.actionStatus = GameActionStatus.kRunning
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local position1 = DestructionPlanLogic:getItemPosition(theAction.ItemPos1)
	local effect = CommonEffect:buildLineEffect(boardView.specialEffectBatch)
	effect:setPosition(position1)
	effect:setRotation(90)
	
	boardView.specialEffectBatch:addChild(effect)
end

function DestructionPlanLogic:runGameItemActionBombSpecialWrap(boardView, theAction)			----播放区域特效爆炸效果--（其实没有）
	theAction.actionStatus = GameActionStatus.kRunning
end

function DestructionPlanLogic:runGameItemActionBombSpecialWrapWrap(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
end

function DestructionPlanLogic:runGameItemActionBombSpecialColor(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	-----对魔力鸟播放黑洞特效-----
	local r1 = theAction.ItemPos1.x;
	local c1 = theAction.ItemPos1.y;
	local item = boardView.baseMap[r1][c1];
	item:playBridBackEffect(true, 1.3)
end

function DestructionPlanLogic:runGameItemActionBombSpecialColor_End(boardView, theAction)
	-----对魔力鸟停止黑洞特效-----
	local r1 = theAction.ItemPos1.x;
	local c1 = theAction.ItemPos1.y;
	local item = boardView.baseMap[r1][c1];
	item:playBridBackEffect(false);
end

function DestructionPlanLogic:runGameItemActionBombBirdLine(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	-----对魔力鸟播放黑洞特效-----
	local r1 = theAction.ItemPos1.x;
	local c1 = theAction.ItemPos1.y;
	local item = boardView.baseMap[r1][c1];
	item:playBridBackEffect(true, 0.75);
end

function DestructionPlanLogic:runGameItemActionBombBirdLine_End(boardView, theAction)
	-----对魔力鸟停止黑洞特效-----
	local r1 = theAction.ItemPos1.x;
	local c1 = theAction.ItemPos1.y;
	local item = boardView.baseMap[r1][c1];
	item:playBridBackEffect(false);
end

function DestructionPlanLogic:runGameItemActionBombBirdLineFlying(boardView, theAction)		----鸟和直线交换之后，飞出的特效
	theAction.actionStatus = GameActionStatus.kRunning
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local r2 = theAction.ItemPos2.x
	local c2 = theAction.ItemPos2.y

	local item1 = boardView.baseMap[r1][c1] 		----物体
	local item2 = boardView.baseMap[r2][c2]			----鸟

	-- local flyingtime = DestructionPlanLogic:getActionTime(theAction.actionDuring - theAction.addInt)
	local flyingtime = DestructionPlanLogic:getActionTime(theAction.actionDuring)
	local delaytime = DestructionPlanLogic:getActionTime(theAction.addInt)

	local fromPos = boardView.gameBoardLogic:getGameItemPosInView(r2, c2)
	local toPos = boardView.gameBoardLogic:getGameItemPosInView(r1, c1)
	item1:playFlyingBirdEffect(r2, c2, delaytime, flyingtime)
end

function DestructionPlanLogic:runGameItemActionBombBirdBird(boardView, theAction)
	theAction.actionStatus = GameActionStatus.kRunning
	-----对魔力鸟播放黑洞特效-----
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local item = boardView.baseMap[r1][c1]
	item:playBirdBirdBackEffect(true)
end

function DestructionPlanLogic:runGameItemActionBirdBirdExplode(boardView, theAction)
	if theAction.hasExplode == nil then
		theAction.hasExplode = true
		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		local item = boardView.baseMap[r1][c1]
		item:playBirdBirdExplodeEffect(true, theAction.bombList)
	end
end

function DestructionPlanLogic:runGameItemActionBombBirdBird_End(boardView, theAction)
	-----对魔力鸟停止黑洞特效-----
	local r1 = theAction.ItemPos1.x
	local c1 = theAction.ItemPos1.y
	local item = boardView.baseMap[r1][c1]
	item:playBirdBirdBackEffect(false)
end
