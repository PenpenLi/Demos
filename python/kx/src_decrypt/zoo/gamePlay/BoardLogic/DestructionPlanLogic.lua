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
	elseif theAction.actionType == GameItemActionType.kItem_Hedgehog_Move then
		DestructionPlanLogic:runGameItemActionHedgehogMove(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Hedgehog_Crazy_Move then
		DestructionPlanLogic:runGameItemActionHedgehogCrazyMove(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Stone_Active then
		DestructionPlanLogic:runGameItemActionMagicStone(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Bottle_Destroy_Around then
		DestructionPlanLogic:runnGameItemActionBottleBlockerDestroyAround(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Rocket_Active then
		DestructionPlanLogic:runGameItemActionRocketActive(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_CrystalStone_Animal then 
		DestructionPlanLogic:runGameItemSpecialCrystalStoneAnimalAction(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_CrystalStone_Bird then 
		DestructionPlanLogic:runGameItemSpecialCrystalStoneBirdAction(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_CrystalStone_CrystalStone then 
		DestructionPlanLogic:runGameItemSpecialCrystalStoneCrystalStoneAction(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_CrystalStone_Charge then
		DestructionPlanLogic:runGameItemCrystalStoneChargeAction(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Wukong_FallToClearItem then
		DestructionPlanLogic:runGameItemActionWukongFallToClear(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Wukong_MonkeyBar then
		DestructionPlanLogic:runGameItemActionWukongMonkeyBar(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Wukong_Casting then
		DestructionPlanLogic:runGameItemActionWukongCasting(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_SuperTotems_Explode then
		DestructionPlanLogic:runGameItemSuperTotemsExplodeAction(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Halloween_Boss_ClearLine then
		DestructionPlanLogic:runGameItemActionHalloweenBossClearLine(boardView, theAction)
	elseif theAction.actionType == GameItemActionType.kItem_Drip_Casting then
		DestructionPlanLogic:runGameItemActionDripCasting(boardView, theAction)
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
	elseif theAction.actionType == GameItemActionType.kItem_Hedgehog_Move then
		DestructionPlanLogic:runningGameItemActionHedgehogMove(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Hedgehog_Crazy_Move then
		DestructionPlanLogic:runningGameItemActionHedgehogCrazyMove(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Stone_Active then
		DestructionPlanLogic:runningGameItemActionMagicStoneActive(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Bottle_Destroy_Around then
		DestructionPlanLogic:runningGameItemActionBottleBlockerDestroyAroundActive(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Rocket_Active then
		DestructionPlanLogic:runningGameItemActionRocketActive(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_CrystalStone_Animal then 
		DestructionPlanLogic:runingGameItemSpecialCrystalStoneAnimalAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_CrystalStone_Bird then 
		DestructionPlanLogic:runingGameItemSpecialCrystalStoneBirdAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_CrystalStone_CrystalStone then 
		DestructionPlanLogic:runingGameItemSpecialCrystalStoneCrystalStoneAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_CrystalStone_Charge then
		DestructionPlanLogic:runingGameItemCrystalStoneChargeAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Wukong_FallToClearItem then
		DestructionPlanLogic:runingGameItemActionWukongFallToClear(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Wukong_MonkeyBar then
		DestructionPlanLogic:runingGameItemActionWukongMonkeyBar(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Wukong_Casting then
		DestructionPlanLogic:runingGameItemActionWukongCasting(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_SuperTotems_Explode then
		DestructionPlanLogic:runingGameItemSuperTotemsExplodeAction(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Halloween_Boss_ClearLine then
		DestructionPlanLogic:runningGameItemActionHalloweenBossClearLine(mainLogic, theAction, actid)
	elseif theAction.actionType == GameItemActionType.kItem_Drip_Casting then
		DestructionPlanLogic:runningGameItemActionDripCasting(mainLogic, theAction, actid)
	end
end

function DestructionPlanLogic:runGameItemActionDripCasting(boardView, theAction)

	local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y

	local function creatFlyAnimation(count)
		if not theAction.fromPosEffs then theAction.fromPosEffs = {} end
		if not theAction.flyEffs then theAction.flyEffs = {} end

		local createEff = function ( tarindex )

			local fromPosEff = TileDrip:createEff( "dirp_eff_explode_1" )
			fromPosEff:setPosition( ccp( theAction.fromPos.x , theAction.fromPos.y ) )
			boardView:addChild( fromPosEff )

			--local actArr1 = CCArray:create()
			--fromPosEff:runAction( CCSequence:create(actArr1) )
			table.insert( theAction.fromPosEffs , fromPosEff )


			local eff = TileDrip:createEff( "drip_eff_fly" )
			eff:setPosition( ccp( theAction.fromPos.x , theAction.fromPos.y ) )
			eff.body:setPositionY(5)
			boardView:addChild( eff )

			if theAction.toPosList and theAction.toPosList[tarindex] then
				local actArr2 = CCArray:create()
				actArr2:addObject( CCEaseSineOut:create( 
					CCMoveTo:create( 0.6 , ccp(theAction.toPosList[tarindex].x , theAction.toPosList[tarindex].y)) )  )
				actArr2:addObject( CCCallFunc:create( function ()  

				end ) )
				eff:runAction( CCSequence:create(actArr2) )
			else
			end
			

			table.insert( theAction.flyEffs , eff )

		end

		for i = 1 , count do
			local delayTime = ((i - 1) * 0.2) + 0.1
			setTimeOut( function () createEff(i) end , delayTime )
		end
		
	end

	local function creatOnHitAnimation(index , toPos)

		local eff1 = theAction.fromPosEffs[index]
		if eff1 and eff1:getParent() and not eff1.isDisposed then 
			eff1:removeFromParentAndCleanup(false) 
		end
		local eff2 = theAction.flyEffs[index]
		if eff2 and eff2:getParent() and not eff2.isDisposed then 
			eff2:removeFromParentAndCleanup(false) 
		end

		if not toPos then return end

		local eff3 = TileDrip:createEff( "dirp_eff_explode_2" )
		eff3:setPosition( ccp( toPos.x , toPos.y ) )
		boardView:addChild( eff3 )

		local actArr3 = CCArray:create()
		actArr3:addObject( CCDelayTime:create( 1 )  )
		actArr3:addObject( CCCallFunc:create( function ()  
			if eff3 and eff3:getParent() and not eff3.isDisposed then eff3:removeFromParentAndCleanup(false) end
		end ) )
		eff3:runAction( CCSequence:create(actArr3) )
	end

	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		theAction.addInfo = "checkMatch"
		theAction.jsq = 0
	else
		if theAction.addInfo == "playLeaderUpgradeAndCasting" then

			theAction.jsq = theAction.jsq + 1
			
			if theAction.jsq == 1 then

				local leaderView = boardView.baseMap[r1][c1]
				leaderView.isNeedUpdate = true
				local fromPos = leaderView:getBasePosition( c1 , r1 )
				local toPosList = {}

				for ia = 1 , #theAction.castingTarget do
					local tp = leaderView:getBasePosition( theAction.castingTarget[ia].x , theAction.castingTarget[ia].y )
					tp.x = tp.x + 35
					tp.y = tp.y - 35
					table.insert( toPosList , tp )
				end
				
				theAction.fromPos = fromPos
				theAction.toPosList = toPosList

				--[[
				if theAction.targetBoss then
					local bosspos = theAction.toPosList[1]
					table.insert( theAction.toPosList , bosspos )
					table.insert( theAction.toPosList , bosspos )
					--Boss无论发射几次，都命中同一个格子
				end
				]]

			elseif theAction.jsq == 10 then
				
				if theAction.dripMatchCount == 3 then
					creatFlyAnimation( 1 , theAction.fromPos , theAction.toPosList )
				elseif theAction.dripMatchCount == 4 then
					creatFlyAnimation( 2 , theAction.fromPos , theAction.toPosList )
				elseif theAction.dripMatchCount >= 5 then
					creatFlyAnimation( 3 , theAction.fromPos , theAction.toPosList )
				else
					creatFlyAnimation( 1 , theAction.fromPos , theAction.toPosList )
				end

			elseif theAction.jsq == 15 then
				theAction.addInfo = "deleteLeader"
			elseif theAction.jsq == 30 then
				creatOnHitAnimation(1 , theAction.toPosList[1])
				--if theAction.dripMatchCount == 3 then
					theAction.addInfo = "reachTarget1"
				--end
			elseif theAction.jsq == 40 then
				creatOnHitAnimation(2 , theAction.toPosList[2])
				--if theAction.dripMatchCount == 4 then
					theAction.addInfo = "reachTarget2"
				--end
			elseif theAction.jsq == 50 then
				creatOnHitAnimation(3 , theAction.toPosList[3])
				theAction.addInfo = "reachTarget3"
			end
		elseif theAction.addInfo == "playMove" then
			theAction.jsq = theAction.jsq + 1

			local moveView = boardView.baseMap[r1][c1]
			if theAction.jsq == 1 then
				moveView.isNeedUpdate = true
			elseif theAction.jsq == 20 then
				theAction.addInfo = "deleteMacthItem"
			end
		end
	end
end

function DestructionPlanLogic:runningGameItemActionDripCasting(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then

		local r1 , c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r1][c1]

		theAction.dripMatchCount = item.dripMatchCount
		local filterMap = {}
		--theAction.dripMatchCount = 5

		local function getCastingListByKeyItem(keyItem)
			local castingList = {}
			table.insert( castingList , keyItem )
			--print("RRR   keyItemkeyItemkeyItemkeyItemkeyItemkeyItemkeyItem =  " , keyItem , keyItem.x)
			if mainLogic.gameItemMap[keyItem.y][keyItem.x + 1] then 
				table.insert( castingList , mainLogic.gameItemMap[keyItem.y][keyItem.x + 1] ) 
			end

			if mainLogic.gameItemMap[keyItem.y + 1] then
				if mainLogic.gameItemMap[keyItem.y + 1][keyItem.x + 1] then 
					table.insert( castingList , mainLogic.gameItemMap[keyItem.y + 1][keyItem.x + 1] ) 
				end
				if mainLogic.gameItemMap[keyItem.y + 1][keyItem.x] then
					table.insert( castingList , mainLogic.gameItemMap[keyItem.y + 1][keyItem.x] ) 
				end
			end
			return castingList
		end

		local function checkGrid(keyItem)
			
			local castingList = getCastingListByKeyItem(keyItem)
			local keyItemY = keyItem.y
			local hasJewelOnKeyItemY = false
			local hasCloudOnKeyItemY = false
			local hasFilterItem = false
			local checkItem = nil
			local jewel = 0
			local cloud = 0
			local available = false
			for i = 1 , #castingList do

				checkItem = castingList[i]

				if filterMap[ tostring(checkItem.x) .. "_" .. tostring(checkItem.y) ] then
					if checkItem.x ~= 2 and checkItem.x ~= 8 and checkItem.y ~= 2 and checkItem.y ~= 8 then
						hasFilterItem = true
					end
				else
					if checkItem.ItemType == GameItemType.kDigJewel then
						jewel = jewel + 1
						if checkItem.y == keyItemY then
							hasJewelOnKeyItemY = true
						end
					end
					if checkItem.ItemType == GameItemType.kDigGround then
						cloud = cloud + 1
						if checkItem.y == keyItemY then
							hasCloudOnKeyItemY = true
						end
					end

					if checkItem.x < 9 and checkItem.y < 9 then
						available = true
					end
				end
			end

			if not hasJewelOnKeyItemY and not hasCloudOnKeyItemY then
				jewel = 0
				cloud = 0
			end

			if hasFilterItem then
				jewel = 0
				cloud = 0
				available = false
			end

			return { jewel = jewel , cloud = cloud , available = available }
		end

		local function getCastingTarget( needCount )

			filterMap = {}
			filterMap[ tostring(c1) .. "_" .. tostring(r1) ] = true
			local findTarget = function ()
					--GameItemType.kBoss
				local checkItem = nil
				local bossList = {}
				local blockList = {}
				local cloudList = {}
				local jewelList = {}
				local animalList = {}
				local allList = {}



				--先算出一个target坐标，然后以此为左上点，取四格
				for r = 1, #mainLogic.gameItemMap do--屏幕最下排不用检测
	   		 		for c = 1, #mainLogic.gameItemMap[r] do--屏幕最右侧不用检测
	   		 			checkItem = mainLogic.gameItemMap[r][c]
	   		 			if checkItem and not filterMap[ tostring(checkItem.x) .. "_" .. tostring(checkItem.y) ] then
	   		 				if checkItem.ItemType == GameItemType.kBoss and checkItem.bossLevel > 0 then
	   		 					table.insert( bossList , checkItem )
	   		 				elseif checkItem.ItemType == GameItemType.kDigGround or checkItem.ItemType == GameItemType.kDigJewel then
	   		 					table.insert( blockList , checkItem )
	   		 					if checkItem.ItemType == GameItemType.kDigGround then
	   		 						table.insert( cloudList , checkItem )
	   		 					elseif checkItem.ItemType == GameItemType.kDigJewel then
	   		 						table.insert( jewelList , checkItem )
	   		 					end
	   		 				elseif checkItem.ItemType == GameItemType.kAnimal and not AnimalTypeConfig.isSpecialTypeValid(checkItem.ItemSpecialType) then
	   		 					table.insert( animalList , checkItem )
	   		 				end
	   		 				table.insert( allList , checkItem )
	   		 			end
	   		 		end
	   		 	end
	   		 	--bossList = {}
	   		 	if #bossList > 0 then
	   		 		theAction.targetBoss = true
	   		 		return bossList[1]
	   		 	elseif #blockList > 0 then
	   		 		
	   		 		local topBlockY = 9
   		 			local topBlock = {}
   		 			local topList = {}
   		 			local checkitem = nil

   		 			for i = 1 , #blockList do
   		 				if blockList[i].y < topBlockY then
   		 					topBlockY = blockList[i].y
   		 				end
   		 			end

   		 			--if topBlockY == 9 then topBlockY = 8 end
   		 			for c = 1, #mainLogic.gameItemMap[topBlockY] - 1 do

   		 				checkitem = mainLogic.gameItemMap[topBlockY][c]
   		 				--if not filterMap[ tostring(checkitem.x) .. "_" .. tostring(checkitem.y) ] then
   		 					table.insert( topList , checkitem )
   		 				--end
   		 				
   		 			end

   		 			for i = 1 , #blockList do
   		 				if blockList[i].y == topBlockY then
   		 					table.insert( topBlock , blockList[i] )
   		 				end
   		 			end

   		 			local maxJewel = 0
   		 			local maxJewelList = {}
   		 			local maxCloud = 0
   		 			local maxCloudList = {}


   		 			for i = 1 , #topList do
   		 				if maxJewel < checkGrid( topList[i] ).jewel then
   		 					maxJewel = checkGrid( topList[i] ).jewel
   		 				end
   		 			end

   		 			if maxJewel > 0 then
   		 				for i = 1 , #topList do
	   		 				if maxJewel == checkGrid( topList[i] ).jewel then
	   		 					table.insert( maxJewelList , topList[i] )
	   		 				end
	   		 			end

	   		 			for i = 1 , #maxJewelList do
   		 					if maxCloud < checkGrid( maxJewelList[i] ).cloud then
	   		 					maxCloud = checkGrid( maxJewelList[i] ).cloud
	   		 				end
	   		 			end

	   		 			for i = 1 , #maxJewelList do
	   		 				if maxCloud == checkGrid( maxJewelList[i] ).cloud then
	   		 					table.insert( maxCloudList , maxJewelList[i] )
	   		 				end
	   		 			end
   		 			else
   		 				for i = 1 , #topList do
			 				if maxCloud < checkGrid( topList[i] ).cloud then
	   		 					maxCloud = checkGrid( topList[i] ).cloud
	   		 				end
	   		 			end

	   		 			for i = 1 , #topList do
	   		 				if maxCloud == checkGrid( topList[i] ).cloud then
	   		 					table.insert( maxCloudList , topList[i] )
	   		 				end
	   		 			end
   		 			end


   		 			if maxJewel > 0 then

   		 				if #maxJewelList > 1 then

		   		 			if #maxCloudList > 1 then
		   		 				local idx = mainLogic.randFactory:rand(1, #maxCloudList)
		   		 				return maxCloudList[idx]
		   		 			else
		   		 				return maxCloudList[1]
		   		 			end

   		 				else
   		 					return maxJewelList[1]
   		 				end
   		 				
   		 			else
   		 				
   		 				if #maxCloudList > 1 then
	   		 				local idx = mainLogic.randFactory:rand(1, #maxCloudList)
	   		 				return maxCloudList[idx]
	   		 			else
	   		 				return maxCloudList[1]
	   		 			end

   		 			end
   		 			-----------------------------------------------------------------------------
   		 			--[[
	   		 		if #cloudList > 0 then
	   		 			local topCloudY = 9
	   		 			local topCloud = {}

	   		 			for i = 1 , #cloudList do
	   		 				if cloudList[i].y < topCloudY then
	   		 					topCloudY = cloudList[i].y
	   		 				end
	   		 			end

	   		 			for i = 1 , #cloudList do
	   		 				if cloudList[i].y == topCloudY then
	   		 					table.insert( topCloud , cloudList[i] )
	   		 				end
	   		 			end

	   		 			local maxJewel = 0
	   		 			local maxJewelList = {}
	   		 			for i = 1 , #topCloud do
	   		 				if maxJewel < checkGrid( topCloud[i] ).jewel then
	   		 					maxJewel = checkGrid( topCloud[i] ).jewel
	   		 				end
	   		 			end

	   		 			for i = 1 , #topCloud do
	   		 				if maxJewel == checkGrid( topCloud[i] ).jewel then
	   		 					table.insert( maxJewelList , topCloud[i] )
	   		 				end
	   		 			end

	   		 			local maxCloud = 0
	   		 			local maxCloudList = {}

	   		 			if #maxJewelList > 1 then

	   		 				for i = 1 , #maxJewelList do
	   		 					if maxCloud < checkGrid( maxJewelList[i] ).cloud then
		   		 					maxCloud = checkGrid( maxJewelList[i] ).cloud
		   		 				end
		   		 			end

		   		 			for i = 1 , #maxJewelList do
		   		 				if maxCloud == checkGrid( maxJewelList[i] ).cloud then
		   		 					table.insert( maxCloudList , maxJewelList[i] )
		   		 				end
		   		 			end

		   		 			if #maxCloudList > 1 then
		   		 				local idx = mainLogic.randFactory:rand(1, #maxCloudList)
		   		 				print("RRR  findTarget  2  return  " , maxCloudList[idx])
		   		 				return maxCloudList[idx]
		   		 			else
		   		 				print("RRR  findTarget  3  return  " , maxCloudList[1])
		   		 				return maxCloudList[1]
		   		 			end
	   		 			else
	   		 				print("RRR  findTarget  4  return  " , maxJewelList[1])
	   		 				return maxJewelList[1]
	   		 			end
	   		 		else
	   		 			local topJewelY = 9
	   		 			local topJewel = {}

	   		 			for i = 1 , #jewelList do
	   		 				if jewelList[i].y < topJewelY then
	   		 					topJewelY = jewelList[i].y
	   		 				end
	   		 			end

	   		 			for i = 1 , #jewelList do
	   		 				if jewelList[i].y == topJewelY then
	   		 					table.insert( topJewel , jewelList[i] )
	   		 				end
	   		 			end

	   		 			local maxJewel = 0
	   		 			local maxJewelList = {}
	   		 			for i = 1 , #topJewel do
	   		 				if maxJewel < checkGrid( topJewel[i] ).jewel then
	   		 					maxJewel = checkGrid( topJewel[i] ).jewel
	   		 				end
	   		 			end

	   		 			for i = 1 , #topJewel do
	   		 				if maxJewel == checkGrid( topJewel[i] ).jewel then
	   		 					table.insert( maxJewelList , topJewel[i] )
	   		 				end
	   		 			end

	   		 			if #maxJewelList > 1 then

	   		 				local idx = mainLogic.randFactory:rand(1, #maxJewelList)
	   		 				print("RRR  findTarget  5  return  " , maxJewelList[idx])
		   		 			return maxJewelList[idx]
	   		 			else
	   		 				print("RRR  findTarget  6  return  " , maxJewelList[1])
	   		 				return maxJewelList[1]
	   		 			end
	   		 		end
	   		 		]]

	   		 	elseif #animalList > 0 then
	   		 		local availableAniamlList = {}
	   		 		for i = 1 , #animalList do
	   		 			if checkGrid( animalList[i] ).available then
	   		 				table.insert( availableAniamlList , animalList[i] )
	   		 			end
	   		 		end

	   		 		if #availableAniamlList > 0 then
	   		 			local idx = mainLogic.randFactory:rand(1, #availableAniamlList)
		   		 		return availableAniamlList[idx]
	   		 		end
	   		 	elseif #allList > 0 then
	   		 		local availableAllList = {}
	   		 		for i = 1 , #allList do
	   		 			if checkGrid( allList[i] ).available then
	   		 				table.insert( availableAllList , allList[i] )
	   		 			end
	   		 		end
	   		 		local idx = mainLogic.randFactory:rand(1, #availableAllList)
		   		 	return availableAllList[idx]
	   		 	end

	   		 	print(debug.traceback())
				return nil
			end
			
			local resultList = {}
			for i = 1 , needCount do
				local rst = findTarget()
				if rst then

					
					if rst.y == 9 then
						local newrst = mainLogic.gameItemMap[8][rst.x]
						if newrst then
							rst = newrst
						else
							break
						end
					end
					
					--print("RRR  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF   rst.x " , rst.x , "   rst.y " , rst.y)
					filterMap[ tostring(rst.x) .. "_" .. tostring(rst.y) ] = true
					filterMap[ tostring(rst.x + 1) .. "_" .. tostring(rst.y) ] = true
					filterMap[ tostring(rst.x) .. "_" .. tostring(rst.y + 1) ] = true
					filterMap[ tostring(rst.x + 1) .. "_" .. tostring(rst.y + 1) ] = true
					--[[
					if rst.x - 1 ~= 1 then
						filterMap[ tostring(rst.x - 1) .. "_" .. tostring(rst.y) ] = true
						filterMap[ tostring(rst.x - 1) .. "_" .. tostring(rst.y + 1) ] = true
					end

					if rst.y - 1 ~= 1 then
						filterMap[ tostring(rst.x) .. "_" .. tostring(rst.y - 1) ] = true
						filterMap[ tostring(rst.x + 1) .. "_" .. tostring(rst.y - 1) ] = true
					end
					
					if rst.x - 1 ~= 1 and rst.y - 1 ~= 1 then
						filterMap[ tostring(rst.x - 1) .. "_" .. tostring(rst.y - 1) ] = true
					end
					
					--]]

					table.insert( resultList , rst )
				end
			end
			
			return resultList
		end

		local function reachTarget(target , tarIndex)
			local castingList = getCastingListByKeyItem(target)
			for i = 1 , #castingList do
				local castingItem = castingList[i]
				if castingItem.ItemType == GameItemType.kBoss then
					if castingItem.bossLevel > 0 then
						--BombItemLogic:tryCoverByBomb(mainLogic, castingItem.y , castingItem.x , true, 1, true, true)
						local loseBlood = 5
						if theAction.dripMatchCount == 3 then
							loseBlood = 3
						elseif theAction.dripMatchCount == 4 then
							loseBlood = 4
						elseif theAction.dripMatchCount == 5 then
							loseBlood = 5
						end
						GameExtandPlayLogic:MaydayBossLoseBlood(mainLogic, castingItem.y , castingItem.x , true , actid , loseBlood)
					end
				else
					BombItemLogic:clearItemWithoutCover(mainLogic , castingItem.y , castingItem.x)
				end
			end
		end

		if theAction.addInfo == "checkMatch" then

			if item.dripState == DripState.kGrow then
				theAction.isLeader = true
			else
				theAction.isLeader = false
			end

			theAction.leaderPos = { x = item.dripLeaderPos.x , y = item.dripLeaderPos.y }
			theAction.jsq = 0

			if theAction.isLeader then
				theAction.addInfo = "waitingForUpgrade"
			else
				theAction.addInfo = "playMove"
				item.dripState = DripState.kMove
				item.isNeedUpdate = true
			end

		elseif theAction.addInfo == "waitingForUpgrade" then

			theAction.jsq = theAction.jsq + 1
			if theAction.jsq >= 10 then
				item.dripState = DripState.kCasting
				item.isNeedUpdate = true
				theAction.addInfo = "playLeaderUpgradeAndCasting"
				theAction.jsq = 0
				
				local needTarget = 3
				if theAction.dripMatchCount == 3 then
					needTarget = 1
				elseif theAction.dripMatchCount == 4 then
					needTarget = 2
				elseif theAction.dripMatchCount == 5 then
					needTarget = 3
				end

				theAction.castingTarget = getCastingTarget(needTarget)
				needTarget = #theAction.castingTarget

				if theAction.targetBoss then
					local bossTar = theAction.castingTarget[1]
					theAction.castingTarget = {}
					for i = 1 , needTarget do
						table.insert( theAction.castingTarget , bossTar )
					end
				end

				if #theAction.castingTarget == 0 then
					item:cleanAnimalLikeData()
					item.isNeedUpdate = true
					theAction.addInfo = "over"
				end
			end
		elseif theAction.addInfo == "deleteLeader" then

			item:cleanAnimalLikeData()
			item.isNeedUpdate = true
			theAction.addInfo = "playLeaderUpgradeAndCasting"--第20帧删除发射体，在切回去继续计时

		elseif theAction.addInfo == "reachTarget1" then
			local targetItem = theAction.castingTarget[1]
			if targetItem then reachTarget( targetItem , 1 ) end

			if theAction.dripMatchCount == 3 then
				theAction.addInfo = "over"
			else
				theAction.addInfo = "playLeaderUpgradeAndCasting"
			end
			
		elseif theAction.addInfo == "reachTarget2" then
			local targetItem = theAction.castingTarget[2]
			if not theAction.targetBoss and targetItem then reachTarget( targetItem , 2 ) end

			if theAction.dripMatchCount == 4 then
				theAction.addInfo = "over"
			else
				theAction.addInfo = "playLeaderUpgradeAndCasting"
			end
		elseif theAction.addInfo == "reachTarget3" then
			local targetItem = theAction.castingTarget[3]
			if not theAction.targetBoss and targetItem then reachTarget( targetItem , 3 ) end
			theAction.addInfo = "over"
		elseif theAction.addInfo == "deleteMacthItem" then

			item:cleanAnimalLikeData()
			item.isNeedUpdate = true
			theAction.addInfo = "over"

		elseif theAction.addInfo == "over" then
			----[[
			print("RRR   DestructionPlanLogic:runningGameItemActionDripCasting   -----------   r = " , r1 , "  c = " , c1 ,  "  isLeader = " , theAction.isLeader )
			mainLogic:checkItemBlock(r1, c1)
			mainLogic:setNeedCheckFalling()
			mainLogic.destructionPlanList[actid] = nil
			if theAction.completeCallback then
				theAction.completeCallback()
			end
			--]]
		end
	end
end

function DestructionPlanLogic:runGameItemActionHalloweenBossClearLine(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		theAction.frameCount = 0
		theAction.moveCount = 0
		theAction.addInfo = 'play'
		local position1 = DestructionPlanLogic:getItemPosition({x = 9, y = 5})
		local effect = CommonEffect:buildRainbowLineEffect(boardView.rainbowBatch)
		effect:setPosition(position1)
		
		boardView.rainbowBatch:addChild(effect)

		-- local position2 = DestructionPlanLogic:getItemPosition({x = 5, y = 5})
		-- local effect2 = CommonEffect:buildRainbowLineEffect(boardView.rainbowBatch)
		-- effect2:setPosition(position2)
		-- effect2:setRotation(90)
		
		-- boardView.rainbowBatch:addChild(effect2)
	end
end

function DestructionPlanLogic:runningGameItemActionHalloweenBossClearLine(mainLogic, theAction, actid)
	if theAction.addInfo == 'play' then
		theAction.frameCount = theAction.frameCount + 1
		local function clearItem(row,col)
			local clearItem = mainLogic.gameItemMap[row][col]
			BombItemLogic:forceClearItemWithCover(mainLogic , row , col)
		end
		if theAction.frameCount >= GamePlayConfig_SpecialBomb_Line_Add_CD then
			theAction.frameCount = 0		

			local index1, index2 = 5 + theAction.moveCount, 5 - theAction.moveCount
			if index1 > 9 or index2 < 1 then
				theAction.addInfo = 'over'
			else
				if index2 == index1 and index1 == 5 then
					clearItem(9, 5)
				elseif index1 <= 9 and index2 >= 1 then
					clearItem(9, index1)
					clearItem(9, index2)
				end
				mainLogic:setNeedCheckFalling()
				theAction.moveCount = theAction.moveCount + 1
			end
		end
		if not theAction.clearedColumn then
			for i = 3, 9 do
				clearItem(i, 5)
			end
			theAction.clearedColumn = true
		end
	elseif theAction.addInfo == 'over' then
		mainLogic:setNeedCheckFalling()
		mainLogic.destructionPlanList[actid] = nil
		if theAction.completeCallback then
			theAction.completeCallback()
		end
	end
end


function DestructionPlanLogic:runGameItemSuperTotemsExplodeAction(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		theAction.actionTick = 1
		theAction.addInfo = "start"
	elseif theAction.addInfo == "startBomb" then
		local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
		local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y

		local linkToPos = IntCoord:create(r2, c2)
		local item1 = boardView.baseMap[r1][c1]
		item1:playSuperTotemsWaittingExplode(linkToPos)
		item1.isNeedUpdate = true

		local item2 = boardView.baseMap[r2][c2]
		item2:playSuperTotemsWaittingExplode()
		item2.isNeedUpdate = true
	elseif theAction.addInfo == "bombSelf" then
		local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item1 = boardView.baseMap[r1][c1]
		item1:playSuperTotemsDestoryAnimate()

		local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
		local item2 = boardView.baseMap[r2][c2]
		item2:playSuperTotemsDestoryAnimate()
	end
end

function DestructionPlanLogic:runingGameItemSuperTotemsExplodeAction(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.addInfo == "start" then
			theAction.addInfo = "waiting1"
			theAction.actionTick = 1
		elseif theAction.addInfo == "waiting1" then -- 等待小金刚变身
			if theAction.actionTick == 8 then
				theAction.addInfo = "startBomb"
			end
			theAction.actionTick = theAction.actionTick + 1
		elseif theAction.addInfo == "startBomb" then -- 播放等待爆炸动画和地格提示动画
			GameExtandPlayLogic:playTileHighlight(mainLogic, TileHighlightType.kTotems, theAction.ItemPos1, theAction.ItemPos2)
			theAction.addInfo = "waiting2"
		elseif theAction.addInfo == "waiting2" then -- 等待棋盘稳定后爆掉区域内的动物
			if mainLogic:isItemAllStable() then
				theAction.addInfo = "waiting3"
				theAction.actionTick = 1
			end
		elseif theAction.addInfo == "waiting3" then
			if theAction.actionTick == 10 then
				theAction.addInfo = "bombAll"
			end
			theAction.actionTick = theAction.actionTick + 1
		elseif theAction.addInfo == "bombAll" then
			local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
			local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y

			local fromR, toR = r1, r2
			if fromR > toR then
				fromR, toR = toR, fromR
			end
			local fromC, toC = c1, c2
			if fromC > toC then
				fromC, toC = toC, fromC
			end

			local scoreScale = GamePlayConfig_Score_SuperTotems_Scale
			for r = fromR, toR do
				for c = fromC, toC do
					if mainLogic:isPosValid(r, c) then
						if not DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, r, c, theAction.lightUpBombMatchPosList) then
							SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, scoreScale)
						end
						BombItemLogic:tryCoverByBomb(mainLogic, r, c, true, scoreScale)
						SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3, scoreScale, actid)
						local breakDirs = {}
						if r > fromR then table.insert(breakDirs, ChainDirConfig.kUp) end
						if r < toR then table.insert(breakDirs, ChainDirConfig.kDown) end
						if c > fromC then table.insert(breakDirs, ChainDirConfig.kLeft) end
						if c < toC then table.insert(breakDirs, ChainDirConfig.kRight) end
						SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r, c, breakDirs)
					end
				end
			end	
			GameExtandPlayLogic:stopTileHighlight(mainLogic, theAction.ItemPos1, theAction.ItemPos2)

			theAction.addInfo = "bombSelf"
		elseif theAction.addInfo == "bombSelf" then
			-- add scores
			local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
			local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
			GameExtandPlayLogic:addScoreToTotal(mainLogic, r1, c1, GamePlayConfigScore.SuperTotems)
			GameExtandPlayLogic:addScoreToTotal(mainLogic, r2, c2, GamePlayConfigScore.SuperTotems)
			
			theAction.addInfo = "over"
		elseif theAction.addInfo == "over" then
			local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
			local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y		
			local item1 = mainLogic.gameItemMap[r1][c1]
			item1:cleanAnimalLikeData()
			mainLogic:checkItemBlock(r1, c1)
			item1.isNeedUpdate = true

			local item2 = mainLogic.gameItemMap[r2][c2]
			item2:cleanAnimalLikeData()
			mainLogic:checkItemBlock(r2, c2)
			item2.isNeedUpdate = true

			theAction.actionStatus = GameActionStatus.kWaitingForDeath
		end
	end
end


function DestructionPlanLogic:runGameItemActionWukongCasting(boardView, theAction)

	local r , c = theAction.ItemPos1.x, theAction.ItemPos1.y
	local tr , tc = theAction.monkeyTargetPos.y, theAction.monkeyTargetPos.x
	local fromItem = boardView.baseMap[r][c]
	local targetItem = boardView.baseMap[tr][tc]
	local tarPos = IntCoord:clone(theAction.monkeyTargetPos)

	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning 
		theAction.addInfo = "start"
	else

		local function onJumpFin()
			theAction.addInfo = "jumpFin"
		end

		if theAction.addInfo == "startJump" then
			fromItem:changeWukongState( TileWukongState.kJumping )
			if theAction.noJump then
				--setTimeOut( onJumpFin , 2 )
				fromItem:playWukongJumpAnimation(tarPos , onJumpFin , true)
				--[[
				fromItem:playWukongJumpAnimation(tarPos , function () 
					fromItem:onWukongJumpFin()
					onJumpFin()
					end , true)
					]]
			else
				fromItem:playWukongJumpAnimation(tarPos , onJumpFin)
			end
			theAction.musicDelay = 0
			theAction.addInfo = "watingForMusic"
		elseif theAction.addInfo == "watingForMusic" then
			theAction.musicDelay = theAction.musicDelay + 1
			if theAction.musicDelay == 30 then
				GamePlayMusicPlayer:playEffect(GameMusicType.kWukongCasting)
			end
		elseif theAction.addInfo == "fallToClearDone" then
			
			theAction.addInfo = "playMonkeyBar"
			boardView:playMonkeyBar(tr , theAction.monkeyColorIndex)

			theAction.jsq = 0
		elseif theAction.addInfo == "doClearTopCloud" then
			theAction.jsq = theAction.jsq + 1
			if theAction.jsq >= 2 then
				theAction.jsq = 0

				if theAction.needPlayClearBlockAnimationPos and #theAction.needPlayClearBlockAnimationPos > 0 then
					for i = 1 , 1 do
						local pos = theAction.needPlayClearBlockAnimationPos[1]
						if pos then
							table.remove( theAction.needPlayClearBlockAnimationPos , 1 )
							local needClearItem = boardView.baseMap[pos.r][pos.c]

							theAction.clearBlockAnimationCount = theAction.clearBlockAnimationCount + 1
							needClearItem:playMaydayBossChangeToAddMove(boardView, targetItem, function () 
									table.insert( theAction.needClearBlockPos , pos )
									theAction.clearBlockAnimationCount = theAction.clearBlockAnimationCount - 1
								end)
						end
					end
					
				else
					if theAction.clearBlockAnimationCount <= 0 then
						if theAction.nextFrameChangeToOver then
							theAction.addInfo = "over"
						end
						theAction.nextFrameChangeToOver = true
					end
				end
			end
		end
		
	end
end

function DestructionPlanLogic:runingGameItemActionWukongCasting(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kRunning then
		
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local tr , tc = theAction.monkeyTargetPos.y, theAction.monkeyTargetPos.x
		local fromItem = mainLogic.gameItemMap[r][c]
		local toItem = mainLogic.gameItemMap[tr][tc]


		local function onFallToClearDone() -- 跳跃完成
			theAction.addInfo = "fallToClearDone"
			toItem.wukongState = TileWukongState.kReadyToCasting
		end

		if theAction.addInfo == "start" then
			toItem.wukongState = TileWukongState.kJumping  --注意这里有个坑，为什么要设置toItem的wukongState，因为要用这个属性来阻止其掉落，尽管这时toItem并不是一个wukong
			theAction.addInfo = "startJump"
			theAction.monkeyColorIndex = AnimalTypeConfig.convertColorTypeToIndex( fromItem.ItemColorType )
		elseif theAction.addInfo == "jumpFin" then
			wukongCastingCount = wukongCastingCount + 1
			toItem.wukongProgressTotal = getBaseWukongChargingTotalValue()

			if theAction.noJump then
				onFallToClearDone()
			else
				local action = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_Wukong_FallToClearItem,
                        IntCoord:create(tr, tc),
                        nil,
                        GamePlayConfig_MaxAction_time
                    )
		        action.completeCallback = onFallToClearDone
		        action.monkeyFromPos = IntCoord:create(r, c)
		        mainLogic:addDestructionPlanAction(action)
				
				mainLogic:setNeedCheckFalling()
				theAction.addInfo = "wating"
			end
			

		elseif theAction.addInfo == "playMonkeyBar" then
			theAction.jsq = theAction.jsq + 1

			if theAction.jsq >= 15 then 
				toItem.wukongState = TileWukongState.kCasting

				local function onMonekyBarDone()
					theAction.addInfo = "clearTopCloud"
					--toItem.wukongState = TileWukongState.kReadyToChangeColor
					toItem.wukongState = TileWukongState.kGift
					mainLogic:releasReplayReordPreviewBlock()
				end
				
				local action = GameBoardActionDataSet:createAs(
	                        GameActionTargetType.kGameItemAction,
	                        GameItemActionType.kItem_Wukong_MonkeyBar,
	                        IntCoord:create(tr, tc),
	                        nil,
	                        GamePlayConfig_MaxAction_time
	                    )
		        action.completeCallback = onMonekyBarDone
		        mainLogic:addDestructionPlanAction(action)

				--mainLogic:setNeedCheckFalling()
				theAction.jsq = 0
				theAction.addInfo = "wating"
			end
		elseif theAction.addInfo == "clearTopCloud" then
			local needClearBlock = {}
			for ir = 1, #mainLogic.gameItemMap do
				for ic = 1, #mainLogic.gameItemMap[ir] do
					local checkItem = mainLogic.gameItemMap[ir][ic]

					if checkItem and ir < tr and ( checkItem.ItemType == GameItemType.kDigJewel or checkItem.ItemType == GameItemType.kDigGround ) then
						table.insert( needClearBlock , {r = ir , c = ic} )
					end
				end
			end
			--[[
			local randomList = {}
			if #needClearBlock > 0 then
				local listLength = #needClearBlock
				for ia = 1 , listLength do
					local idx = mainLogic.randFactory:rand(1, #needClearBlock)
					table.insert( randomList , needClearBlock[idx] )
					table.remove( needClearBlock , idx )
				end
			end
			]]

			theAction.needPlayClearBlockAnimationPos = needClearBlock
			--theAction.needPlayClearBlockAnimationPos = randomList
			theAction.needClearBlockPos = {}
			theAction.clearBlockAnimationCount = 0
			theAction.jsq = 0
			--if not needFouceClear then
				theAction.addInfo = "doClearTopCloud"
			--end
		elseif theAction.addInfo == "doClearTopCloud" then

			for i = 1, #theAction.needClearBlockPos do
				local pos = theAction.needClearBlockPos[i]
				local needClearItem = mainLogic.gameItemMap[pos.r][pos.c]

				if needClearItem.ItemType == GameItemType.kDigJewel or needClearItem.ItemType == GameItemType.kDigGround then
					BombItemLogic:forceClearItemWithCover(mainLogic , pos.r , pos.c)
				end
			end
			theAction.needClearBlockPos = {}
		elseif theAction.addInfo == "over" then
			mainLogic:setNeedCheckFalling()
			mainLogic.destructionPlanList[actid] = nil
			
			if theAction.completeCallback then
				theAction.completeCallback()
			end
		end
	end
end

function DestructionPlanLogic:runGameItemActionWukongFallToClear(boardView, theAction)
	
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning 
		
		theAction.addInfo = "start"

		local r , c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local toItem = boardView.baseMap[r][c]
		local mr , mc = theAction.monkeyFromPos.x, theAction.monkeyFromPos.y
		local monkey = boardView.baseMap[mr][mc]
		theAction.monkey = monkey
		boardView:viberate()

	else
		if theAction.addInfo == "build" then
			
		elseif theAction.addInfo == "over" then
			theAction.monkey:onWukongJumpFin()
		end
	end
end

function DestructionPlanLogic:runingGameItemActionWukongFallToClear(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kRunning then
		

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local toItem = mainLogic.gameItemMap[r][c]
		local mr , mc = theAction.monkeyFromPos.x, theAction.monkeyFromPos.y
		local monkey = mainLogic.gameItemMap[mr][mc]

		if theAction.addInfo == "start" then
			SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, 1)
			BombItemLogic:tryCoverByBomb(mainLogic, r, c, true, 1)
			SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3)
			mainLogic:checkItemBlock(r, c)

			theAction.addInfo = "wating"
			theAction.jsq = 0

		elseif theAction.addInfo == "wating" then
			theAction.jsq = theAction.jsq + 1
			--toItem.isBlock = true
			if toItem.ItemType == GameItemType.kNone then
				theAction.addInfo = "build" 
			end
			if theAction.jsq >= 300 then
				theAction.addInfo = "build" --只是一个保险
			end
		elseif theAction.addInfo == "build" then
			toItem.ItemType = GameItemType.kWukong 
			toItem.isBlock = true 
			toItem.isEmpty = false 
			toItem.ItemColorType = monkey.ItemColorType
			toItem.wukongProgressCurr = toItem.wukongProgressTotal
			toItem.needHideMoneyBar = true
			--toItem.wukongState = TileWukongState.kReadyToChangeColor
			mainLogic:checkItemBlock(r, c)
			toItem.isNeedUpdate = true

			GameExtandPlayLogic:itemDestroyHandler(mainLogic, mr, mc)
			monkey:cleanAnimalLikeData()
			monkey.wukongState = TileWukongState.kNormal
			mainLogic:checkItemBlock(mr, mc)
			monkey.isNeedUpdate = true

			theAction.addInfo = "over" 
		elseif theAction.addInfo == "over" then
			mainLogic:setNeedCheckFalling()

			mainLogic.destructionPlanList[actid] = nil
			if theAction.completeCallback then
				theAction.completeCallback()
			end
		end
	end
end

function DestructionPlanLogic:runGameItemActionWukongMonkeyBar(boardView, theAction)
	
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning 

		theAction.addInfo = "start"

		local r , c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local monkey = boardView.baseMap[r][c]

	end
end

function DestructionPlanLogic:runingGameItemActionWukongMonkeyBar(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kRunning then

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local monkey = mainLogic.gameItemMap[r][c]
		local checkItem = nil

		if not theAction.jsq then theAction.jsq = 0 end
		if not theAction.currCol then theAction.currCol = 9 end

		local function checkItemIsEmpty(row,col)
			checkItem = nil
			if mainLogic.gameItemMap[row] then
				checkItem = mainLogic.gameItemMap[row][col]
			end

			if checkItem and not checkItem.isEmpty and checkItem.ItemType ~= GameItemType.kWukong then
				return false
			end
			return true
		end

		if theAction.addInfo == "start" then

			theAction.jsq = theAction.jsq + 1


			if theAction.jsq >= 5 then

				local dr = r
				local dc = 9
				

				local function clearItem(row,col)
					local clearItem = mainLogic.gameItemMap[row][col]
					BombItemLogic:forceClearItemWithCover(mainLogic , row , col)
				end

				

				if not checkItemIsEmpty(r , theAction.currCol) then
					clearItem(r , theAction.currCol)
				end

				if not checkItemIsEmpty(r + 1 , theAction.currCol) then
					clearItem(r + 1 , theAction.currCol)
				end

				if not checkItemIsEmpty(r - 1 , theAction.currCol) then
					clearItem(r - 1 , theAction.currCol)
				end
				
				theAction.currCol = theAction.currCol - 1
				theAction.jsq = 0

				mainLogic:setNeedCheckFalling()

				if theAction.currCol <= 0 then
					theAction.addInfo = "over"
				end
			end

			--theAction.addInfo = "over"

		elseif theAction.addInfo == "over" then

			mainLogic:setNeedCheckFalling()

			mainLogic.destructionPlanList[actid] = nil
			if theAction.completeCallback then
				theAction.completeCallback()
			end
		end
	end
end


function DestructionPlanLogic:runGameItemCrystalStoneChargeAction(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		local color = theAction.addInt1
		local totalEnergy = theAction.addInt2 or 0

		local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
		local item2 = boardView.baseMap[r2][c2]
		local energyPercent = totalEnergy / GamePlayConfig_CrystalStone_Energy

		item2:updateCrystalStoneEnergy(energyPercent, true)
		if theAction.ItemPos1 then -- 添加特效飞行动画
			item2:playCrystalStoneCharge(theAction.ItemPos1, color)
		else -- 直接播放加能量特效
			item2:playCrystalStoneChargeEffect()
		end
	end
end

function DestructionPlanLogic:runingGameItemCrystalStoneChargeAction(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then
		theAction.actionStatus = GameActionStatus.kWaitingForDeath
	end
end 

function DestructionPlanLogic:runGameItemSpecialCrystalStoneBirdAction(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		theAction.addInfo = "start"

		local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item1 = boardView.baseMap[r1][c1]
		item1:playCrystalStoneChangeToWaiting()

		local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
		local item2 = boardView.baseMap[r2][c2]
		item2:playBridBackEffect(true, 1.3)
		theAction.isPlayingBirdBackEffect = true
	else
		if theAction.addInfo == "bombSpecials" and theAction.isPlayingBirdBackEffect then
			local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
			local item2 = boardView.baseMap[r2][c2]
			item2:playBridBackEffect(false)
			theAction.isPlayingBirdBackEffect = false
		end
	end
end

function DestructionPlanLogic:runingGameItemSpecialCrystalStoneBirdAction(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then
		local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
		local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
		if theAction.addInfo == "start" then -- 炸掉魔力鸟
			local item1 = mainLogic.gameItemMap[r1][c1]
			item1.crystalStoneBombType = GameItemCrystalStoneBombType.kSpecial
			SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r1, c1 ) -- 点亮蜗牛轨迹

			local item2 = mainLogic.gameItemMap[r2][c2]
			item2:AddItemStatus(GameItemStatusType.kDestroy)
			local CoverAction2 = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemCoverBySpecial_Color,
				IntCoord:create(r2,c2),
				nil,
				GamePlayConfig_SpecialBomb_BirdBird_Time2)
			CoverAction2.addInfo = "kAnimal"
			mainLogic:addDestroyAction(CoverAction2)
			mainLogic.gameItemMap[r2][c2].gotoPos = nil
			mainLogic.gameItemMap[r2][c2].comePos = nil
			SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r2, c2, 3)
			SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r2, c2 )
			GameExtandPlayLogic:decreaseLotus( mainLogic, r2, c2 , 1 , false)

			-- 分数
			local addScore = GamePlayConfigScore.CrystalStone * 1.5
			ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r1,c1),				
				nil,				
				1)
			ScoreAction.addInt = addScore
			mainLogic:addGameAction(ScoreAction)

			theAction.addInfo = "waiting1"
		elseif theAction.addInfo == "waiting1" then
			if mainLogic:isItemAllStable()
				and mainLogic:numDestrunctionPlan() == 1 -- 只剩下自己了
				then
				------停止掉落了-----
				----进入下一个阶段----
				theAction.addInfo = "bombSpecials"
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
				theAction.bombList = result
				theAction.actionTick = 0
			end
		elseif theAction.addInfo == "bombSpecials" then
			theAction.actionTick = theAction.actionTick + 1
			if theAction.actionTick >= GamePlayConfig_SpecialBomb_CrystalStone_Bird_Time2 then
				BombItemLogic:BombAll(mainLogic)--------引爆所有特效
				theAction.addInfo = "waiting2"
				theAction.actionTick = 0
			end
		elseif theAction.addInfo == "waiting2" then
			if mainLogic:isItemAllStable()
				and mainLogic:numDestrunctionPlan() == 1
				then
				mainLogic:tryBombCrystalStones(true)
				theAction.addInfo = "bombAll"
				theAction.actionTick = 0
			end
		elseif theAction.addInfo == "bombAll" then
			theAction.actionTick = theAction.actionTick + 1
			if theAction.actionTick >= GamePlayConfig_SpecialBomb_CrystalStone_Bird_Time3 then
				BombItemLogic:bombAllByCrystalStone(mainLogic, true, 5)
				theAction.addInfo = "over"
				theAction.actionTick = 0
			end
		elseif theAction.addInfo == "over" then
			mainLogic.destructionPlanList[actid] = nil
		end
	end
end

function DestructionPlanLogic:runGameItemSpecialCrystalStoneCrystalStoneAction(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		theAction.addInfo = "start"
	end
end

function DestructionPlanLogic:runingGameItemSpecialCrystalStoneCrystalStoneAction(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.addInfo == "start" then
			theAction.addInfo = "changeColor"
			mainLogic.isCrystalStoneInHandling = true
			local itemPosList = {}
			for i = 1, #mainLogic.gameItemMap do
				for j = 1, #mainLogic.gameItemMap[i] do
					local item = mainLogic.gameItemMap[i][j]
					if item and item:canBeCoverByCrystalStone() then
						table.insert(itemPosList, IntCoord:create(i, j))
					end
				end
			end

			local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
			local item1 = mainLogic.gameItemMap[r1][c1]
			item1.crystalStoneBombType = GameItemCrystalStoneBombType.kNormal
			SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r1, c1 )

			local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
			local item2 = mainLogic.gameItemMap[r2][c2]
			item2.crystalStoneBombType = GameItemCrystalStoneBombType.kNormal
			SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r2, c2 )

			-- 分数
			local addScore = GamePlayConfigScore.CrystalStone * 2
			ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r1,c1),				
				nil,				
				1)
			ScoreAction.addInt = addScore
			mainLogic:addGameAction(ScoreAction)

			theAction.handleList = itemPosList
			theAction.handled = 0
			theAction.interval = 0
		elseif theAction.addInfo == "changeColor" then
			theAction.interval = theAction.interval + 1
			if theAction.handled >= #theAction.handleList then
				mainLogic.isCrystalStoneInHandling = false
				theAction.addInfo = "waiting"
				theAction.actionTick = 0
			elseif theAction.interval > GamePlayConfig_CrystalStone2_Handle_Interval then
				theAction.interval = 0
				local targetColor = theAction.addInt1
				local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y

				for index = theAction.handled + 1, theAction.handled + GamePlayConfig_CrystalStone2_Handle_One_Time do
					local itemPos = theAction.handleList[index]
					if itemPos then
						local action = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItemSpecial_CrystalStone_Flying,
							IntCoord:create(r1, c1),
							itemPos,
							GamePlayConfig_CrystalStone_Fly_Time1)
						action.addInt1 = targetColor
						mainLogic:addGameAction(action)

						theAction.handled = theAction.handled + 1
					else
						break
					end
				end
			end
		elseif theAction.addInfo == "waiting" then
			theAction.actionTick = theAction.actionTick + 1
			if theAction.actionTick > GamePlayConfig_SpecialBomb_CrystalStone2_Time2 then
				mainLogic:tryBombCrystalStones()
				theAction.addInfo = "over"
				theAction.actionTick = 0
			end
		elseif theAction.addInfo == "over" then
			mainLogic.destructionPlanList[actid] = nil
		end
	end
end

function DestructionPlanLogic:runGameItemSpecialCrystalStoneAnimalAction(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		theAction.addInfo = "start"
	end
end

function DestructionPlanLogic:runingGameItemSpecialCrystalStoneAnimalAction(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then
		local targetColor = theAction.addInt1
		local colorToChange = theAction.addInt2
		local sptype = theAction.addInt3 or 0

		if theAction.addInfo == "start" then
			local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
			-- 分数
			local addScore = GamePlayConfigScore.CrystalStone
			ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r,c),				
				nil,				
				1)
			ScoreAction.addInt = addScore
			mainLogic:addGameAction(ScoreAction)

			local item1 = mainLogic.gameItemMap[r][c]
			item1.crystalStoneBombType = GameItemCrystalStoneBombType.kNormal
			SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )

			local colorPosList = mainLogic:getPositionCoverByCrystalStone(targetColor, colorToChange, sptype)
			if colorPosList and #colorPosList > 0 then
				local actionNum = #colorPosList
				local function completeCallback()
					actionNum = actionNum - 1
					if actionNum <= 0 then
						local isSpecialType = sptype and sptype ~= 0
						if theAction.ItemPos2 and not isSpecialType then
							local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
							mainLogic:addNeedCheckMatchPoint(r2, c2)
						end
						theAction.addInfo = "colorChangeEnd"
					end
				end

				for _, v in pairs(colorPosList) do
					local action = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemSpecial_CrystalStone_Flying,
						IntCoord:create(r, c),
						IntCoord:create(v.x, v.y),
						GamePlayConfig_CrystalStone_Fly_Time1)
					action.addInt1 = targetColor
					action.addInt2 = sptype -- special type
					action.completeCallback = completeCallback
					mainLogic:addGameAction(action)
				end

				theAction.addInfo = "waiting"
				theAction.actionTick = 0
			else
				theAction.addInfo = "colorChangeEnd"
			end
		elseif theAction.addInfo == "waiting" then
			
		elseif theAction.addInfo == "colorChangeEnd" then
			theAction.addInfo = "explode"
		elseif theAction.addInfo == "explode" then
			mainLogic:tryBombCrystalStones()
			theAction.addInfo = "over"
		elseif theAction.addInfo == "over" then
			mainLogic.destructionPlanList[actid] = nil
		end
	end
end

function DestructionPlanLogic:runningGameItemActionRocketActive(mainLogic, theAction, actid)
	if theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.addInfo == "over" then
			mainLogic.destructionPlanList[actid] = nil
		elseif theAction.addInfo == "rocketFly" then
			local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y

			SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, GamePlayConfig_Score_Rocket_Bomb_Scale, true)
			BombItemLogic:tryCoverByBomb(mainLogic, r, c, true, GamePlayConfig_Score_Rocket_Bomb_Scale, true)
			SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 2, GamePlayConfig_Score_Rocket_Bomb_Scale, actId)
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r, c, {ChainDirConfig.kUp})

			if r > 1 then
				for tr = r-1, 1, -1 do
					local item = nil
					if mainLogic.gameItemMap[tr] then
						item = mainLogic.gameItemMap[tr][c]
					end
					if item then

						SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, tr, c, GamePlayConfig_Score_Rocket_Bomb_Scale, true)
						BombItemLogic:tryCoverByBomb(mainLogic, tr, c, true, GamePlayConfig_Score_Rocket_Bomb_Scale, true)
						SpecialCoverLogic:SpecialCoverAtPos(mainLogic, tr, c, 2, GamePlayConfig_Score_Rocket_Bomb_Scale, actId)
						SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, tr, c, {ChainDirConfig.kUp, ChainDirConfig.kDown})
					end
				end
			end
			theAction.addInfo = "over"
		end
	end
end

function DestructionPlanLogic:runGameItemActionRocketActive(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]

		local function callback()
			if theAction.isUFOExist then
				boardView.PlayUIDelegate:playUFOHitAnimation()
			end
		end
		theAction.addInfo = "rocketFly"
		local color = theAction.addInt
		item:playRocketFlyAnimation(boardView, color, theAction.ItemPos1, theAction.ItemPos2, callback)
	end
end

function DestructionPlanLogic:runningGameItemActionBottleBlockerDestroyAroundActive(mainLogic, theAction, actid)

	if theAction.actionStatus == GameActionStatus.kRunning then

		local item = mainLogic.gameItemMap[theAction.ItemPos1.x][theAction.ItemPos1.y]

		local bottleRow = item.y
		local bottleCol = item.x

		local function explodeItem(r,c)

			if r >= 1 and r <= 9 and c >= 1 and c <= 9 then
				local item = nil
				if mainLogic.gameItemMap[r] then
					item = mainLogic.gameItemMap[r][c]
				end

				if item then
					SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, 1, true)
					BombItemLogic:tryCoverByBomb(mainLogic, r, c, true, 1, true)
					SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3, 1, actId)
					--if SpecialCoverLogic:canBeEffectBySpecialAt(mainLogic, r, c) then
					--	SpecialCoverLogic:effectBlockerAt(mainLogic, r, c, 1, actid)
					--end
				end
			end
		end

		explodeItem(bottleRow + 1 , bottleCol)
		explodeItem(bottleRow - 1 , bottleCol)
		explodeItem(bottleRow     , bottleCol + 1)
		explodeItem(bottleRow     , bottleCol - 1)

		explodeItem(bottleRow     , bottleCol)
		-- 消除一层瓶子四周的冰柱
		SpecialCoverLogic:specialCoverChainsAroundPos(mainLogic, bottleRow, bottleCol, {ChainDirConfig.kUp, ChainDirConfig.kDown, ChainDirConfig.kRight, ChainDirConfig.kLeft})
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, bottleRow, bottleCol )
		
		mainLogic:checkItemBlock(bottleRow, bottleCol)
		mainLogic:setNeedCheckFalling()

		theAction.actionStatus = GameActionStatus.kWaitingForDeath

		if item.bottleActionRunningCount then item.bottleActionRunningCount = item.bottleActionRunningCount - 1 end
	end
	
end


function DestructionPlanLogic:runningGameItemActionMagicStoneActive(mainLogic, theAction, actid)
	local r = theAction.ItemPos1.x
	local c = theAction.ItemPos1.y

	if theAction.addInfo == "over" then
		if theAction.addInfo1 == "animFinish" then -- 等待动画播完
			mainLogic.destructionPlanList[actid] = nil
		end
	else
		theAction.addInt = theAction.addInt + 1
		if theAction.addInt == 16 then -- PC是16
			-- 魔法石所在格子的冰柱处理
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r, c, {ChainDirConfig.kUp, ChainDirConfig.kDown, ChainDirConfig.kRight, ChainDirConfig.kLeft})
			if theAction.targetPos then
				local item = mainLogic.gameItemMap[r][c]
				for _,v in pairs(theAction.targetPos) do
					local tr, tc = r + v.x, c + v.y
					SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, tr, tc, 1, false)  --可以作用银币
					BombItemLogic:tryCoverByBomb(mainLogic, tr, tc, true, 1)
					SpecialCoverLogic:SpecialCoverAtPos(mainLogic, tr, tc, 3) 
					-- 对消除区域冰柱的影响
					local breakChainDirs = {}
					if math.abs(v.x) + math.abs(v.y) == 1 then -- 相邻的3个格子
						breakChainDirs = {ChainDirConfig.kUp, ChainDirConfig.kDown, ChainDirConfig.kRight, ChainDirConfig.kLeft}
					else -- 不相邻的5个格子
						if v.x < 0 then table.insert(breakChainDirs, ChainDirConfig.kDown) end
						if v.x > 0 then table.insert(breakChainDirs, ChainDirConfig.kUp) end
						if v.y < 0 then table.insert(breakChainDirs, ChainDirConfig.kRight) end
						if v.y > 0 then table.insert(breakChainDirs, ChainDirConfig.kLeft) end
					end
					SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, tr, tc, breakChainDirs)
				end
			end
		elseif theAction.addInt > 33 then  -- 16*2+1，确保一个来回不会被触发
			local item = mainLogic.gameItemMap[r][c]
			item.magicStoneLocked = false

			theAction.addInfo = "over"
		end
	end
end

function DestructionPlanLogic:runnGameItemActionBottleBlockerDestroyAround(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
	end
end

function DestructionPlanLogic:runGameItemActionMagicStone(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]

		theAction.addInt = 1
		local function onAnimFinished()
			theAction.addInfo1 = "animFinish"
		end
		item:playStoneActiveAnim(theAction.magicStoneLevel, theAction.targetPos, onAnimFinished)

		if theAction.magicStoneLevel < TileMagicStoneConst.kMaxLevel then
			theAction.addInfo = "over"
		end
	end
end

function DestructionPlanLogic:runGameItemActionHedgehogCrazyMove(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		theAction.addInfo ="moveStart"
		theAction.addInt = 20
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]
		item:playHedgehogInShellAnimation(theAction.direction, nil, 2, true)
	elseif theAction.addInfo == "moving" then
		theAction.addInfo = ""
		GamePlayMusicPlayer:playEffect(GameMusicType.kHedgehogCrazyMove)
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
	elseif theAction.addInfo == "normal" then
		theAction.addInfo = ""
		local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
		local item2 = boardView.baseMap[r2][c2]
		theAction.addInfo = "over"
		theAction.addInt = 13
		item2:playHedgehogOutShellAnimation(theAction.direction, nil , 1)
	end
end

function DestructionPlanLogic:runGameItemActionHedgehogMove(boardView, theAction)
	-- body
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning
		theAction.addInfo ="moveStart"
		theAction.addInt = 10
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = boardView.baseMap[r][c]
		item:playHedgehogInShellAnimation(theAction.direction, nil, theAction.hedgehogLevel)
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
	elseif theAction.addInfo == "normal" then
		theAction.addInfo = ""
		local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
		local item2 = boardView.baseMap[r2][c2]
		theAction.addInfo = "over"
		theAction.addInt = 13
		item2:playHedgehogOutShellAnimation(theAction.direction, nil, theAction.hedgehogLevel)
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

function DestructionPlanLogic:runningGameItemActionHedgehogCrazyMove(mainLogic, theAction, actid)
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
		if item1:isHedgehog() then 
			item1:cleanAnimalLikeData()
			item1.hedgehogLevel = 0
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
		HedgehogLogic:resetHedgehogRoadAtPos( mainLogic, r, c )
		board2.snailTargetCount = board2.snailTargetCount + 1
		item2.snailTarget = true
		HedgehogLogic:cleanItem( mainLogic, r, c )
	elseif theAction.addInfo == "over" then
		local r, c = theAction.ItemPos2.x, theAction.ItemPos2.y
		local board = mainLogic.boardmap[r][c]
		local itemdata = mainLogic.gameItemMap[r][c]
		itemdata:changeToHedgehog(board.snailRoadType, theAction.hedgehogLevel)
		SnailLogic:resetSnailRoadAtPos( mainLogic, r, c )
		mainLogic:checkItemBlock(r, c)
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.isHedgehogCrazy = false
		mainLogic.destructionPlanList[actid] = nil
	end
end

function DestructionPlanLogic:runningGameItemActionHedgehogMove(mainLogic, theAction, actid)
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
			theAction.addInfo = "normal"
			theAction.direction = board.snailRoadType
		end
	elseif theAction.addInfo == "moveEnd" then
		theAction.addInfo = "moveStart"
		local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item1 = mainLogic.gameItemMap[r1][c1]
		local board1 = mainLogic.boardmap[r1][c1]
		

		if item1:isHedgehog() then 
			item1:cleanAnimalLikeData()
			item1.hedgehogLevel = 0
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
		HedgehogLogic:resetHedgehogRoadAtPos( mainLogic, r, c )

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
		itemdata:changeToHedgehog(board.snailRoadType, theAction.hedgehogLevel)
		SnailLogic:resetSnailRoadAtPos( mainLogic, r, c )
		mainLogic:checkItemBlock(r, c)
		if theAction.completeCallback then
			theAction.completeCallback()
		end

		mainLogic.destructionPlanList[actid] = nil
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

			local addScore = GamePlayConfigScore.Collect_Snail
			ScoreCountLogic:addScoreToTotal(mainLogic, addScore)

			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r, c),
				nil,
				1)
			ScoreAction.addInt = addScore
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

		local centerR = (r1 + r2) / 2
		local centerC = (c1 + c2) / 2

		for k,v in pairs(mergePos) do
			if v.r >= 1 and v.r <= #mainLogic.boardmap
				and v.c >= 1 and v.c <= #mainLogic.boardmap[v.r] 
				then
				SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, v.r, v.c, scoreScale)
				BombItemLogic:tryCoverByBomb(mainLogic, v.r, v.c, true, scoreScale)
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, v.r, v.c, 3, scoreScale, actid)
				local breakDirs = DestructionPlanLogic:calcBreakChainDirsAtPos(v.r, v.c, centerR, centerC, 4.5)
				SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, v.r, v.c, breakDirs)
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

-- 针对区域消除，计算区域内格子需要消除的冰柱
function DestructionPlanLogic:calcBreakChainDirsAtPos(r, c, centerR, centerC, radius)
	local breakDirs = {}
	local deltaR = r - centerR
	local deltaC = c - centerC
	local calcRadius = math.abs(deltaR) + math.abs(deltaC)
	if calcRadius < radius then
		breakDirs = {ChainDirConfig.kUp, ChainDirConfig.kDown, ChainDirConfig.kLeft, ChainDirConfig.kRight}
	elseif calcRadius == radius then
		if deltaR < 0 then
			table.insert(breakDirs, ChainDirConfig.kDown)
		elseif deltaR > 0 then
			table.insert(breakDirs, ChainDirConfig.kUp)
		end

		if deltaC < 0  then
			table.insert(breakDirs, ChainDirConfig.kRight)
		elseif deltaC > 0 then
			table.insert(breakDirs, ChainDirConfig.kLeft)
		end
	end
	return breakDirs
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
		SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r1, c1, {ChainDirConfig.kLeft, ChainDirConfig.kRight})
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
					SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r1, c2, {ChainDirConfig.kRight})
					if theAction.addInfo == "" then
						theAction.addInfo = "left"			----左部终止
					elseif theAction.addInfo == "right" then
						theAction.addInfo = "over"			----全部终止
						return
					end
				else
					SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r1, c2, {ChainDirConfig.kLeft, ChainDirConfig.kRight})
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
					SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r1, c3, {ChainDirConfig.kLeft})
					if theAction.addInfo == "" then
						theAction.addInfo = "right"
					elseif theAction.addInfo == "left" then
						theAction.addInfo = "over"
						return
					end
				else
					SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r1, c3, {ChainDirConfig.kLeft, ChainDirConfig.kRight})
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
	SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r1, c1, {ChainDirConfig.kUp, ChainDirConfig.kDown})

	for i=r1 + 1, #mainLogic.gameItemMap do
		if not DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, i, c1, theAction.lightUpBombMatchPosList) then
			SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, i, c1, scoreScale)
		end
		local s1 = BombItemLogic:tryCoverByBomb(mainLogic, i, c1, true, scoreScale, true) 		----空中的也炸掉
		SpecialCoverLogic:SpecialCoverAtPos(mainLogic, i, c1, 2, scoreScale, actid)
		if s1 == 2 then 
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, i, c1, {ChainDirConfig.kUp})
			break 
		else
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, i, c1, {ChainDirConfig.kUp, ChainDirConfig.kDown})
		end----遇到银币
	end

	for i=r1 - 1, 0, -1 do
		if not DestructionPlanLogic:existInSpecialBombLightUpPos(mainLogic, i, c1, theAction.lightUpBombMatchPosList) then
			SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, i, c1, scoreScale)
		end
		local s1 = BombItemLogic:tryCoverByBomb(mainLogic, i, c1, true, scoreScale, true) 		----空中的也炸掉
		SpecialCoverLogic:SpecialCoverAtPos(mainLogic, i, c1, 2, scoreScale, actid )
		if s1 == 2 then 
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, i, c1, {ChainDirConfig.kDown})
			break 
		else
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, i, c1, {ChainDirConfig.kUp, ChainDirConfig.kDown})
		end----遇到银币
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

	local centerR = r1
	local centerC = c1
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
			local breakDirs = DestructionPlanLogic:calcBreakChainDirsAtPos(v.r, v.c, centerR, centerC, 2)
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, v.r, v.c, breakDirs)
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
		local addScore = GamePlayConfigScore.SwapColorAnimal
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

		local scoreScale = theAction.addInt2
		
		if theAction.ItemPos2 then -- 跟小金刚交换
			local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y	
			local item2 = mainLogic.gameItemMap[r2][c2]
			if item2.ItemType == GameItemType.kTotems then -- 小金刚
				SpecialCoverLogic:effectTotemsAt(mainLogic, r2, c2, scoreScale)
			end
		end

		----特效影响-----
		local color = theAction.addInt
		if color == 0 then
			color = mainLogic:getBirdEliminateColor()
			theAction.addInt = color
		end
		GameExtandPlayLogic:activeAllTotemsWithColor(mainLogic, color, scoreScale)

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
					ShakeAction.theItemColor = color
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
			elseif itemBomb.beEffectByMimosa == GameItemType.kKindMimosa then
				GameExtandPlayLogic:backMimosaToRC(mainLogic, v.x, v.y)
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
		local addScore = GamePlayConfigScore.SwapColorLine
		if sp2 == AnimalTypeConfig.kWrap then addScore = GamePlayConfigScore.SwapColorWrap end
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
			local lineColumnRandList = {AnimalTypeConfig.kLine, AnimalTypeConfig.kColumn}
			local resultSpecialType = lineColumnRandList[mainLogic.randFactory:rand(1, 2)]
			GameExtandPlayLogic:itemDestroyHandler(mainLogic, r1, c1)
			item1.ItemType = GameItemType.kAnimal
			item1.ItemSpecialType = resultSpecialType
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
		local addScore = GamePlayConfigScore.SwapColorColor
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
		SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r2, c2, 3)
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
