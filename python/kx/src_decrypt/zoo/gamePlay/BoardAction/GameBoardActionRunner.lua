require "zoo.gamePlay.BoardAction.GameBoardActionDataSet"
require "zoo.gamePlay.BoardLogic.FallingItemLogic"
require "zoo.gamePlay.BoardLogic.SpecialCoverLogic"
require "zoo.config.HalloweenBossConfig"
--用来跑游戏动作逻辑的
GameBoardActionRunner = class{}


----每次每个循环调用这里一次
function GameBoardActionRunner:runActionList(mainLogic, actByView)
	if mainLogic == nil or mainLogic.gameActionList == nil then return end
	for k,v in pairs(mainLogic.gameActionList) do
		if v.actionTarget == GameActionTargetType.kGameItemAction then
			GameBoardActionRunner:runGameItemAction(mainLogic, v, k, actByView)
		end
	end
end

function GameBoardActionRunner:runGameItemAction(mainLogic, theAction, actid, actByView)

	
	if actByView == false and theAction.actionStatus == GameActionStatus.kWaitingForStart then 		----非View驱动，纯数据的，直接进入Running状态
		theAction.actionStatus = GameActionStatus.kRunning
	end
	
	if theAction.actionStatus == GameActionStatus.kRunning then 		---running阶段，自动扣时间，到时间了，进入Death阶段
		if theAction.actionDuring < 0 then 
			theAction.actionStatus = GameActionStatus.kWaitingForDeath
		else
			theAction.actionDuring = theAction.actionDuring - 1
			GameBoardActionRunner:runningGameItemAction(mainLogic, theAction, actid, actByView)
		end
	end
-------------------------------------------------------------------------------------------------------------结束时--------------
	if theAction.actionType == GameItemActionType.kItem_Furball_Brown_Unstable then
		GameBoardActionRunner:runGameItemSpecialFurballUnstable(mainLogic, theAction, actid, actByView)
	else
		------没有特别指明的类型，当到达Death阶段的时候，进行动作删除----
		if theAction.actionStatus == GameActionStatus.kWaitingForDeath then
			mainLogic.gameActionList[actid] = nil;
		end
	end
end


function GameBoardActionRunner:runningGameItemAction(mainLogic, theAction, actid, actByView)
	-- print('run GameBoardActionRunner:runningGameItemAction')
	if theAction.actionType == GameItemActionType.kItemScore_Get then
		GameBoardActionRunner:runningGameItemScoreGet(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItemRefresh_Item_Flying then
		GameBoardActionRunner:runningGameItemRefresh_Item_Flying(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Crystal_Change then
		GameBoardActionRunner:runningGameItem_Crystal_Change(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Venom_Spread then
		GameBoardActionRunner:runningGameItem_Venom_Spread(mainLogic, theAction, actid, actByView)	
	elseif theAction.actionType == GameItemActionType.kItem_Furball_Transfer then
		GameBoardActionRunner:runningGameItem_Furball_Transfer(mainLogic, theAction, actid, actByView)		
	elseif theAction.actionType == GameItemActionType.kItem_Furball_Split then
		GameBoardActionRunner:runningGameItem_Furball_Split(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Roost_Replace then
		GameBoardActionRunner:runningGameItem_Roost_Replace(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Balloon_update then 
		GameBoardActionRunner:runningGameItem_BalloonUpdate( mainLogic, theAction, actid, actByView )
	elseif theAction.actionType == GameItemActionType.kItem_balloon_runAway then
		GameBoardActionRunner:runGameItemlogicActionBalloonRunaway(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_ItemChangeToIngredient then 
		GameBoardActionRunner:runningGameItemlogicActionChangeToIngredient( mainLogic, theAction, actid, actByView )
	elseif theAction.actionType == GameItemActionType.kItem_ItemForceToMove then 
		GameBoardActionRunner:runningGameItemLogicActionForceMoveItem( mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_TileBlocker_Update then 
		GameBoardActionRunner:runningGameItemActionTileBlockerUpdate(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Monster_Destroy_Item then
		GameBoardActionRunner:runningGameItemActionMonsterDestroyItem(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_PM25_Update then
		GameBoardActionRunner:runningGameItemActionUpdatePM25(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Black_Cute_Ball_Update then
		GameBoardActionRunner:runningGameItemActionBlackCuteBallUpdate(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Mimosa_Grow then
		GameBoardActionRunner:runningGameItemActionMimosaGrow(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Mimosa_back then
		GameBoardActionRunner:runningGameItemActionMimosaBack(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Mimosa_Ready then
		GameBoardActionRunner:runningGameItemActionMimosaReady(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Snail_Road_Bright then
		GameBoardActionRunner:runningGameItemActionSnailRoadBright(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Hedgehog_Road_State then
		GameBoardActionRunner:runningGameItemActionHedgehogRoadState(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Snail_Product then
		GameBoardActionRunner:runningGameItemActionProductSnail(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Mayday_Boss_Die then
		GameBoardActionRunner:runnningGameItemActionBossDie(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Mayday_Boss_Jump then
		GameBoardActionRunner:runnningGameItemActionBossJump(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Rabbit_Product then
		GameBoardActionRunner:runningGameItemActionProductRabbit(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Transmission then
		GameBoardActionRunner:runningGameItemActionTransmission(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kOctopus_Change_Forbidden_Level then
		GameBoardActionRunner:runningGameItemActionOctopusChangeForbiddenLevel(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Area_Destruction then
		GameBoardActionRunner:runningGameItemActionDestroyArea(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Lamp_Casting then
		GameBoardActionRunner:runningGameItemActionMagicLampCasting(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Wukong_CheckAndChangeState then
		GameBoardActionRunner:runGameItemActionWukongCheckAndChangeState(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Wukong_Gift then
		GameBoardActionRunner:runGameItemActionWukongGift(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Wukong_Reinit then
		GameBoardActionRunner:runGameItemActionWukongReinit(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Wukong_JumpToTarget then
		GameBoardActionRunner:runGameItemActionWukongJumping(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Gold_ZongZi_Explode then
		GameBoardActionRunner:runningGameItemActionGoldZongZiCasting(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Lamp_Reinit then
		GameBoardActionRunner:runningGameItemActionMagicLampReinit(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Honey_Bottle_Broken then
		GameBoardActionRunner:runningGameItemActionHoneyBottleBroken(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Tile_Hit then
		GameBoardActionRunner:runningGameItemActionMagicTileHit(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Halloween_Boss_Die then
		GameBoardActionRunner:runningGameItemActionHalloweenBossDie(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Halloween_Boss_Create then
		GameBoardActionRunner:runningGameItemActionHalloweenBossCreate(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Magic_Tile_Change then
		GameBoardActionRunner:runningGameItemActionMagicTileChange(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Halloween_Boss_Casting then
		GameBoardActionRunner:runningGameItemActionHalloweenBossCasting(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Sand_Transfer then
		GameBoardActionRunner:runningGameItemActionSandTransfer(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_mayday_boss_casting then
		GameBoardActionRunner:runningGameItemActionMaydayBossCasting(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Hedgehog_Clean_Dig_Groud then
		GameBoardActionRunner:runningGameItemActionCleanDigGround(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Hedgehog_Box_Change then
		GameBoardActionRunner:runningGameItemActionHedgehogBoxChange(mainLogic, theAction, actid, actByView)
	elseif  theAction.actionType == GameItemActionType.kItem_Hedgehog_Release_Energy then
		GameBoardActionRunner:runningGameItemActionHedgehogReleaseEnergy(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Halloween_Boss_Ready_Casting then
		GameBoardActionRunner:runningGameitemActionHalloweenBossReadyCasting(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItemSpecial_CrystalStone_Flying then
		GameBoardActionRunner:runningGameitemActionCrystalStoneFlying(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Update_Lotus then
		GameBoardActionRunner:runningGameitemActionUpdateLotus(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_SuperCute_Recover then
		GameBoardActionRunner:runningGameItemActionRecoverSuperCute(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_SuperCute_Transfer then
		GameBoardActionRunner:runningGameItemActionTransferSuperCute(mainLogic, theAction, actid, actByView)
	elseif theAction.actionType == GameItemActionType.kItem_Check_Has_Drip then
		GameBoardActionRunner:runningGameItemActionCheckHasDrip(mainLogic, theAction, actid, actByView)
	end
end

function GameBoardActionRunner:runningGameItemActionCheckHasDrip(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kRunning then

		local gameItemMap = mainLogic.gameItemMap
		local item = nil
		local dripNum = 0

		for r = 1, #gameItemMap do 
	        for c = 1, #gameItemMap[r] do

	            item = gameItemMap[r][c]
	            if item ~= nil and item.ItemType == GameItemType.kDrip 
	            	and ( item.dripState == DripState.kGrow or item.dripState == DripState.kReadyToMove ) then
	            	dripNum = dripNum + 1
	            end
	        end
		end

		if dripNum == 0 then
			if theAction.completeCallback then
				theAction.completeCallback()
			end
			mainLogic.gameActionList[actid] = nil
		end
	end
end

function GameBoardActionRunner:runningGameItemActionTransferSuperCute(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.addInfo == "over" then
			-- local fr, fc = theAction.ItemPos1.x, theAction.ItemPos1.y
			local tr, tc = theAction.ItemPos2.x, theAction.ItemPos2.y
			local item = mainLogic.gameItemMap[tr][tc]
			if item.ItemType == GameItemType.kKindMimosa or item.beEffectByMimosa == GameItemType.kKindMimosa then
				GameExtandPlayLogic:backMimosa( mainLogic, tr, tc )
			end

			if theAction.completeCallback then
				theAction.completeCallback()
			end
			mainLogic.gameActionList[actid] = nil
		end
	end
end

function GameBoardActionRunner:runningGameItemActionRecoverSuperCute(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.addInfo == "over" then
			local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y

			local item = mainLogic.gameItemMap[r][c]
			if item.ItemType == GameItemType.kKindMimosa or item.beEffectByMimosa == GameItemType.kKindMimosa then
				GameExtandPlayLogic:backMimosa( mainLogic, r, c )
			end

			if theAction.completeCallback then
				theAction.completeCallback()
			end
			mainLogic.gameActionList[actid] = nil
		end
	end
end

function GameBoardActionRunner:runningGameitemActionUpdateLotus(mainLogic, theAction, actid, actByView)
	--[[
	if theAction.actionStatus == GameActionStatus.kRunning then

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		local board = mainLogic.boardmap[r][c]
		local updateType = theAction.updateType

		if theAction.addInfo == "update" then

			theAction.viewJSQ = 0
			theAction.viewJSQTarget = 0

			if updateType == 1 then
				theAction.viewJSQTarget = 10
				mainLogic.currLotusNum = mainLogic.currLotusNum + 1
			elseif updateType == 2 then
				theAction.viewJSQTarget = 16
			else
				theAction.viewJSQTarget = 22
			end

			theAction.addInfo = "playAnimation"

		end

		if theAction.addInfo == "playing" then

			if theAction.viewJSQ == 0 then
				board.lotusLevel = board.lotusLevel + 1
				if board.lotusLevel > 3 then board.lotusLevel = 3 end
				item.lotusLevel = board.lotusLevel

				board.isNeedUpdate = true
				item.isNeedUpdate = true
				mainLogic:checkItemBlock(r, c)
			end

			theAction.viewJSQ = theAction.viewJSQ + 1
			if theAction.viewJSQ > theAction.viewJSQTarget then
				theAction.addInfo = "over"
			end
		end

		if theAction.addInfo == "over" then

			if updateType == 1 then
				local pos = mainLogic:getGameItemPosInView(r, c)
				mainLogic.PlayUIDelegate:setTargetNumber(0, 0, mainLogic.currLotusNum, pos)
			end

			if theAction.completeCallback then
				theAction.completeCallback()
			end
			mainLogic.gameActionList[actid] = nil
		end
	end
	]]

	if theAction.actionStatus == GameActionStatus.kRunning then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		local board = mainLogic.boardmap[r][c]
		local updateType = theAction.updateType

		if theAction.addInfo == "playAnimation" then
			theAction.viewJSQ = 0
			theAction.viewJSQTarget = 0

			if updateType == 1 then
				theAction.viewJSQTarget = 10
				mainLogic.currLotusNum = mainLogic.currLotusNum + 1
			elseif updateType == 2 then
				theAction.viewJSQTarget = 16
			else
				theAction.viewJSQTarget = 22
			end

			board.lotusLevel = board.lotusLevel + 1
			if board.lotusLevel > 3 then board.lotusLevel = 3 end
			item.lotusLevel = board.lotusLevel

			board.isNeedUpdate = true
			item.isNeedUpdate = true
			mainLogic:checkItemBlock(r, c)

			theAction.addInfo = "playing"
		elseif theAction.addInfo == "playing" then
			theAction.viewJSQ = theAction.viewJSQ + 1
			if theAction.viewJSQ > theAction.viewJSQTarget then
				theAction.addInfo = "over"
			end
		elseif theAction.addInfo == "over" then
			if updateType == 1 then
				local pos = mainLogic:getGameItemPosInView(r, c)
				mainLogic.PlayUIDelegate:setTargetNumber(0, 0, mainLogic.currLotusNum, ccp(0,0))
			end

			if theAction.completeCallback then
				theAction.completeCallback()
			end
			mainLogic.gameActionList[actid] = nil
		end
	end
end

function GameBoardActionRunner:runningGameItemScoreGet(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kRunning then
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameitemActionCrystalStoneFlying(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kRunning then
		if not theAction.actionTick then 
			theAction.actionTick = 1
		else
			theAction.actionTick = theAction.actionTick + 1
		end
		
		if theAction.addInfo == "over" then
			mainLogic.gameActionList[actid] = nil
		else
			local isSpecialType = theAction.addInt2 and theAction.addInt2 ~= 0
			if theAction.actionTick == GamePlayConfig_CrystalStone_Fly_Time2 then
				local r, c = theAction.ItemPos2.x, theAction.ItemPos2.y
		        local item = mainLogic.gameItemMap[r][c]
		        local sptype = theAction.addInt2
		        local targetColor = theAction.addInt1

				if not isSpecialType then
					item.ItemColorType = targetColor
					item.isNeedUpdate = true
				else
					if (sptype == AnimalTypeConfig.kLine or sptype == AnimalTypeConfig.kColumn) then
						local specialTypes = { AnimalTypeConfig.kLine, AnimalTypeConfig.kColumn }
						local targetSpecialType = specialTypes[mainLogic.randFactory:rand(1, 2)]
						item.ItemSpecialType = targetSpecialType
					elseif sptype == AnimalTypeConfig.kWrap then
						item.ItemSpecialType = AnimalTypeConfig.kWrap
					end
					item.ItemType = GameItemType.kAnimal
					item.ItemColorType = targetColor
					item.isNeedUpdate = true

					item.bombRes = IntCoord:create(r, c)
				end
			elseif not isSpecialType and theAction.actionTick == GamePlayConfig_CrystalStone_Fly_Time2 + 1 then
				local r, c = theAction.ItemPos2.x, theAction.ItemPos2.y
				mainLogic:addNeedCheckMatchPoint(r, c)
				if theAction.completeCallback then theAction.completeCallback() end
				theAction.addInfo = "over"
			elseif isSpecialType and theAction.actionTick == GamePlayConfig_CrystalStone_Fly_Time3 then
				local r, c = theAction.ItemPos2.x, theAction.ItemPos2.y
				BombItemLogic:tryBombWithBombRes(mainLogic, r, c, 1, scoreScale)
				if theAction.completeCallback then theAction.completeCallback() end
				theAction.addInfo = "over"
			end
		end
	end
end

function GameBoardActionRunner:runningGameitemActionHalloweenBossReadyCasting(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.completeCallback and type(theAction.completeCallback) == "function" then 
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionCleanDigGround(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "bomb" then
		local maxR = theAction.ItemPos1.x
		local count = 0
		if theAction.bombCount < maxR then
			local r = maxR - theAction.bombCount
			for c = 1, #mainLogic.gameItemMap[r] do 
	            local item = mainLogic.gameItemMap[r][c]
	            if item.digGroundLevel > 0 then
	                for k = 1, item.digGroundLevel do 
	                    SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 0, nil, nil, true, false) 
	                end
	                count = count + 1
	            elseif item.digJewelLevel > 0 then
	                for k = 1, item.digJewelLevel do 
	                    GameExtandPlayLogic:decreaseDigJewel(mainLogic, r, c, nil, false, false)
	                end
	                count = count + 1
	            end
	        end
			theAction.bombCount = theAction.bombCount + 1
		else
			theAction.addInfo = "over"
		end
		if count > 0 then
	    	mainLogic:setNeedCheckFalling()
		end
	elseif theAction.addInfo == "over" then
		if theAction.completeCallback then 
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionHedgehogReleaseEnergy(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "updateData" then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		item.hedgehogLevel = theAction.hedgehogLevel
		item.isNeedUpdate = true
		mainLogic.gameMode:releaseEnerge()
		theAction.addInfo = "updateTarget"
	elseif theAction.addInfo == "over" then
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end
function GameBoardActionRunner:runningGameItemActionHedgehogBoxChange(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "animationOver" then
		local addJewel = theAction.addJewelCount or 0
		if addJewel > 0 then
			mainLogic.PlayUIDelegate:setTargetNumber(0, 1, mainLogic.digJewelCount:getValue(), 
				ccp(0,0), nil, false, mainLogic.gameMode:getPercentEnerge())
		end
		theAction.addInfo = "addProp"
	elseif theAction.addInfo == "addProp" then
		if theAction.changeType == HedgehogBoxCfgConst.kProp then
			local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
			local pos = mainLogic:getGameItemPosInView(r, c)
			if mainLogic.PlayUIDelegate and theAction.changeItem then
				local activityId = 0
				local text = mainLogic.dropPropText or Localization:getInstance():getText("activity.GuoQing.getprop.tips")
				activityId = mainLogic.activityId
				mainLogic.PlayUIDelegate:addTimeProp(theAction.changeItem, 1, pos, activityId, text)
			end
		end
		theAction.addInfo = "effect"
	elseif theAction.addInfo == "effectOver" then
		if theAction.changeType == HedgehogBoxCfgConst.kAddMove  then
			for k, v in pairs(theAction.effectItem) do 
				local item = mainLogic.gameItemMap[v.r][v.c]
				item.ItemType = GameItemType.kAddMove
				item.numAddMove = mainLogic.addMoveBase or GamePlayConfig_Add_Move_Base
				item.isNeedUpdate = true
			end
		elseif theAction.changeType == HedgehogBoxCfgConst.kSpecial then
			local total = #theAction.effectItem
			local rate = math.ceil(GamePlayConfig_HedgehogAwardWrap * total
				/(GamePlayConfig_HedgehogAwardWrap + GamePlayConfig_HedgehogAwardLine))
			for k = 1, total do 
				local item_selectd = theAction.effectItem[k]
				local item = mainLogic.gameItemMap[item_selectd.r][item_selectd.c]
				if k <= rate/2 then
					item.ItemSpecialType = AnimalTypeConfig.kLine
				elseif k <= rate then
					item.ItemSpecialType = AnimalTypeConfig.kColumn
				else
					item.ItemSpecialType = AnimalTypeConfig.kWrap
				end
				item.isNeedUpdate = true 
			end
		elseif theAction.changeType == HedgehogBoxCfgConst.kJewl then
			mainLogic.digJewelCount:setValue(mainLogic.digJewelCount:getValue() + GamePlayConfig_HedgehogAwardJewel)
			if mainLogic.PlayUIDelegate then
				local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
				local pos = mainLogic:getGameItemPosInView(r, c)
				for k = 1, GamePlayConfig_HedgehogAwardJewel do 
					mainLogic.gameMode:addEnergeCount(1)
					mainLogic.PlayUIDelegate:setTargetNumber(0, 1, mainLogic.digJewelCount:getValue(), pos, nil, nil, mainLogic.gameMode:getPercentEnerge())
				end
			end
		end

		if theAction.specialItems and #theAction.specialItems > 0 then
			local total = #theAction.specialItems
			local specialTypes = {AnimalTypeConfig.kLine, AnimalTypeConfig.kColumn, AnimalTypeConfig.kWrap}
			for k = 1, total do 
				local item_selectd = theAction.specialItems[k]
				local item = mainLogic.gameItemMap[item_selectd.r][item_selectd.c]
				item.ItemSpecialType = specialTypes[mainLogic.randFactory:rand(1, #specialTypes)]
				item.isNeedUpdate = true 
			end
		end
		mainLogic.maydayBossCount = mainLogic.maydayBossCount + 1
		if mainLogic.PlayUIDelegate then
			local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
			local position = mainLogic:getGameItemPosInView(r, c)
			mainLogic.PlayUIDelegate:setTargetNumber(0, 2, mainLogic.maydayBossCount, position)
		end
		theAction.addInfo = "updateView"
	elseif theAction.addInfo == "over" then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		item:cleanAnimalLikeData()
		SnailLogic:doEffectSnailRoadAtPos(mainLogic, r, c)
		mainLogic:checkItemBlock(r,c)
		item.isNeedUpdate = true
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
		mainLogic:setNeedCheckFalling()
	end
end

function GameBoardActionRunner:runningGameItemActionHalloweenBossCasting(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'playingAnim' then
		-- print('playingAnim')
		-- print('***************** Halloween Boss Casting')

		local jewelPositions = theAction.jewelPositions
		local specialPositions = theAction.specialPositions
		local goldZongziPosition = theAction.goldZongziPosition

		local allComplete = true

		local jewelComplete = false
		for k, v in pairs(jewelPositions) do
			if v.animFinished == true and v.dataChanged == false then
				local item = mainLogic.gameItemMap[v.r][v.c]
				item.ItemType = GameItemType.kDigJewel
				item.digJewelLevel = item.digGroundLevel
				item.digGroundLevel = 0
				item.isNeedUpdate = true
				v.dataChanged = true
			end
		end

		for k, v in pairs(specialPositions) do
			if v.animFinished == true and v.dataChanged == false then
				local item = mainLogic.gameItemMap[v.r][v.c]
				local rand = mainLogic.randFactory:rand(1, 100)
				if rand < 34 then
					item.ItemSpecialType = AnimalTypeConfig.kLine
				elseif rand < 67 then
					item.ItemSpecialType = AnimalTypeConfig.kColumn
				else 
					item.ItemSpecialType = AnimalTypeConfig.kWrap
				end
				item.isNeedUpdate = true
				v.dataChanged = true
			end
		end

		if goldZongziPosition then
			-- print('goldZongziPosition')
			if goldZongziPosition.animFinished == true and goldZongziPosition.dataChanged == false then
				local item = mainLogic.gameItemMap[goldZongziPosition.r][goldZongziPosition.c]
				item.ItemType = GameItemType.kGoldZongZi
				item.digGoldZongZiLevel = 1
				item.digGroundLevel = 0
				item.digJewelLevel = 0
				item.isNeedUpdate = true
				goldZongziPosition.dataChanged = true
			end
		end

		for k, v in pairs(theAction.allDestPos) do
			-- print(v.animFinished, v.dataChanged)
			if not (v.animFinished == true and v.dataChanged == true) then
				allComplete = false
			end
		end
		if allComplete then
			-- print('allComplete')
			theAction.addInfo = 'over'
		end
	elseif theAction.addInfo == 'over' then
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionHalloweenBossCreate(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'over' then
		-- print('***************** Halloween Boss Create')
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		mainLogic:initHalloweenBoss(HalloweenBossConfig.genNewBoss())
		mainLogic.gameItemMap[r][c].isHalloweenBottle = nil
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end


function GameBoardActionRunner:runningGameItemActionHalloweenBossDie(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'over' then
		
		mainLogic:halloween2015BossDie(theAction.diePosition)
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	elseif theAction.addInfo == 'clearLine' then
		theAction.addInfo = ''
		local function finish()
			theAction.addInfo = 'over'
		end


		local pos = {}
		table.insert(pos, mainLogic:getGameItemPosInView(8.5, -0.5))
		table.insert(pos, mainLogic:getGameItemPosInView(7.8, 0.7))
		table.insert(pos, mainLogic:getGameItemPosInView(8.7, 2.2))
		table.insert(pos, mainLogic:getGameItemPosInView(8.0, 3.1))
		table.insert(pos, mainLogic:getGameItemPosInView(9.1, 4.1))
		table.insert(pos, mainLogic:getGameItemPosInView(7.7, 4.7))
		table.insert(pos, mainLogic:getGameItemPosInView(7.6, 5.6))
		table.insert(pos, mainLogic:getGameItemPosInView(8.6, 8.0))
		table.insert(pos, mainLogic:getGameItemPosInView(7.7, 8.9))

		local currDigJewelCount = mainLogic.digJewelCount:getValue()
		for k, v in pairs(pos) do
			if mainLogic.PlayUIDelegate then
				mainLogic.PlayUIDelegate:setTargetNumber(0, 1, currDigJewelCount , v)
			end
		end


		local action = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_Halloween_Boss_ClearLine,
			nil, 
			nil,
			GamePlayConfig_MaxAction_time)
		action.completeCallback = finish
		mainLogic:addDestructionPlanAction(action)
		mainLogic:setNeedCheckFalling()
	end
end

function GameBoardActionRunner:runningGameItemActionMagicTileHit(mainLogic, theAction, actid, actByView) 
	if theAction.addInfo == 'over' then

		if not theAction.bossDead then
			local item = mainLogic.boardmap[theAction.ItemPos1.x][theAction.ItemPos1.y]
			if item then
				local id = item.magicTileId
				for r = 1, #mainLogic.boardmap do
					for c = 1, #mainLogic.boardmap[r] do
						local item2 = mainLogic.boardmap[r][c]
						if item2.isMagicTileAnchor == true and item2.magicTileId == id then
							item2.isHitThisRound = true
						end
					end
				end
			end

			local bossData = mainLogic:getHalloweenBoss() 

			-- boss不在，或者boss已经死了或者boss正在播死亡动画，都算boss死了
			if bossData then
				print('QAAAAAAAAAAAAAAAAAAAAAAAA hit ', bossData.hit)
				local count = bossData.dropBellOnHit
				mainLogic.digJewelCount:setValue(mainLogic.digJewelCount:getValue() + count)
				local currDigJewelCount = mainLogic.digJewelCount:getValue()
				local currBossPos = ccp( theAction.bossPosition.x , theAction.bossPosition.y )

				local function ontimerout()
					if mainLogic.PlayUIDelegate then
						for k = 1, count do 
							if currBossPos.x == 0 and currBossPos.y == 0 then
								print('error!!!!!!!!!!!!!!!')
							end
							mainLogic.PlayUIDelegate:setTargetNumber(0, 1, currDigJewelCount , currBossPos)
						end
					end
				end

				TimerUtil.addAlarm( ontimerout , 2 , 1)
			end
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionMagicTileChange(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'over' then
		-- print('***************** Magic Tile Change')

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		if theAction.objective == 'die' then
			for i = r, r + 1 do
				for j = c, c + 2 do
					if mainLogic.boardmap[i] then
						local item = mainLogic.boardmap[i][j]
						if item then
							item.isMagicTileAnchor = false
							item.remainingHit = nil
							item.magicTileId = nil
						end
					end
				end
			end

		elseif theAction.objective == 'color' then
			-- 啥也不做
		end
		
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionHoneyBottleBroken(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "over" then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		item:cleanAnimalLikeData()
		item.isBlock = false
		-- item.isNeedUpdate = true
		mainLogic:checkItemBlock(r, c)

		for k, v in pairs(theAction.infectList) do 
			local tItem = mainLogic.gameItemMap[v.x][v.y]
			tItem.honeyLevel = 1
			mainLogic:checkItemBlock(v.x, v.y)
			tItem.isNeedUpdate = true
		end

		if theAction.completeCallback then 
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
	end
end

function GameBoardActionRunner:runningGameItemActionMagicLampReinit(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'over' then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		item.lampLevel = 1
		item.ItemColorType = theAction.color
		item.isNeedUpdate = true
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionMagicLampCasting(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'over' then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local lamp = mainLogic.gameItemMap[r][c]
		lamp.lampLevel = 0
		lamp.ItemColorType = AnimalTypeConfig.kNone

		local toItemPos = theAction.speicalItemPos
		for k, v in pairs(toItemPos) do
			local item = mainLogic.gameItemMap[v.r][v.c]
			local specialTypes = { AnimalTypeConfig.kLine, AnimalTypeConfig.kColumn }
			local targetSpecialType = specialTypes[mainLogic.randFactory:rand(1, 2)]
			item.ItemType = GameItemType.kAnimal
			item.ItemSpecialType = targetSpecialType
			item.isNeedUpdate = true
		end
		local function bombAll()
			for k, v in pairs(toItemPos) do
				SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, v.r, v.c, 1, true)  --可以作用银币
				BombItemLogic:tryCoverByBomb(mainLogic, v.r, v.c, true, 1)
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, v.r, v.c, 3) 
			end

			if theAction.completeCallback then
				theAction.completeCallback()
			end

		end
		setTimeOut(bombAll, 0.3)
		-- bombAll()
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runGameItemActionWukongCheckAndChangeState(mainLogic, theAction, actid, actByView)

	if theAction.actionStatus == GameActionStatus.kRunning then

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local monkey = mainLogic.gameItemMap[r][c]

		local function onCompleteCallback()
			if theAction.completeCallback then
				theAction.completeCallback()
			end
		end

		if theAction.addInfo == "onChangeToReadyToJumpFin" then
			--monkey.wukongIsReadyToJump = true
			monkey.wukongState = TileWukongState.kReadyToJump
			mainLogic.gameActionList[actid] = nil
			onCompleteCallback()
		elseif theAction.addInfo == "onChangeToActiveFin" then
			--monkey.wukongIsReadyToJump = false
			monkey.wukongState = TileWukongState.kOnActive
			mainLogic.gameActionList[actid] = nil
			onCompleteCallback()
		end
	end
	
end

function GameBoardActionRunner:runGameItemActionWukongGift(mainLogic, theAction, actid, actByView)

	local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
	local fromItem = mainLogic.gameItemMap[r][c]

	if theAction.addInfo == 'anim_over' then
		
		----[[
		local addStepPositions = theAction.addStepPositions
		for k, v in pairs(addStepPositions) do
			local item = mainLogic.gameItemMap[v.r][v.c]
			item.ItemType = GameItemType.kAddMove
			item:initAddMoveConfig(mainLogic.addMoveBase)
			item.isNeedUpdate = true
		end
		--]]
		----[[
		local lineAndColumnPositions = theAction.lineAndColumnPositions
		for k, v in pairs(lineAndColumnPositions) do
			local item = mainLogic.gameItemMap[v.r][v.c]
			item.ItemType = GameItemType.kAnimal
			local rand = mainLogic.randFactory:rand(1, 2)
			if rand == 1 then
				item.ItemSpecialType = AnimalTypeConfig.kLine
			else
				item.ItemSpecialType = AnimalTypeConfig.kColumn  
			end
			
			item.isNeedUpdate = true
		end

		local warpPositions = theAction.warpPositions
		for k, v in pairs(warpPositions) do
			local item = mainLogic.gameItemMap[v.r][v.c]
			item.ItemType = GameItemType.kAnimal
			item.ItemSpecialType = AnimalTypeConfig.kWrap
			item.isNeedUpdate = true
		end
		--]]

		theAction.fromItemPosition = mainLogic:getGameItemPosInView( r , c )
		
		mainLogic:addDigJewelCountWhenBossDie(10 , theAction.fromItemPosition)



		local function dropProps()
            local totalWeight = mainLogic.wukongPropConfig:getTotalWeight()
            local random = mainLogic.randFactory:rand(1, totalWeight)
            local randPropId = mainLogic.wukongPropConfig:getRandProp(random)
           	--randPropId = 10061
            if randPropId then
                if mainLogic.PlayUIDelegate then
                    local showText = mainLogic.dropPropText or ""
                    mainLogic.PlayUIDelegate:addTimeProp(randPropId, 1, theAction.fromItemPosition , mainLogic.activityId , showText)
                end
            end
        end

        local totalPlayNum = 999
        local dropPropCount = 999

        if mainLogic.dragonBoatData then
        	totalPlayNum = mainLogic.dragonBoatData.totalPlayNum
        	dropPropCount = mainLogic.dragonBoatData.dropPropCount
        end

        
        
        if dropPropCount < 20 and not mainLogic.gameMode.wukongDropProp then
        	--1,3,5,7,11,17,21,25
        	if totalPlayNum == 1 
        		or totalPlayNum == 3 
        		or totalPlayNum == 5 
        		or totalPlayNum == 7 
        		or totalPlayNum == 11 
        		or totalPlayNum == 17 
        		or totalPlayNum == 21 
        		or totalPlayNum == 25 
        		then
        		dropProps()
        		mainLogic.gameMode.wukongDropProp = true
        	elseif mainLogic.randFactory:rand(1, 10000) <= 5 then
        		dropProps()
        		mainLogic.gameMode.wukongDropProp = true
        	end
        end

        theAction.addInfo = "data_over"

	elseif theAction.addInfo == 'over' then

		fromItem.wukongState = TileWukongState.kReadyToChangeColor

		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil

	end	
end

function GameBoardActionRunner:runGameItemActionWukongReinit(mainLogic, theAction, actid, actByView)

	local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
	local item = mainLogic.gameItemMap[r][c]
	local boardmap = mainLogic.boardmap
	if theAction.addInfo == "clearTargetBorad" then
		item.wukongState = TileWukongState.kChangeColor

		local wukongTargets = theAction.wukongTargetsPosition
		for k, v in pairs(wukongTargets) do
            local board = boardmap[v.x][v.y]
            board.isWukongTarget = false
            board.isNeedUpdate = true
        end
        theAction.addInfo = "clearTargetBoradFin"

	elseif theAction.addInfo == "changeWukongColorFin" then
		item.wukongState = TileWukongState.kNormal
		item.ItemColorType = theAction.color
		item.isEmpty = false
		item.wukongProgressCurr = 0
		item.isNeedUpdate = true

		mainLogic:checkItemBlock(r, c)
		mainLogic:setNeedCheckFalling()

		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end


function GameBoardActionRunner:runGameItemActionWukongJumping(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kRunning then
		

		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local tr , tc = theAction.monkeyTargetPos.y, theAction.monkeyTargetPos.x
		local fromItem = mainLogic.gameItemMap[r][c]
		local toItem = mainLogic.gameItemMap[tr][tc]


		local function onFallToClearDone() -- 跳跃完成
			theAction.addInfo = "over"
		end

		if theAction.addInfo == "startJump" then
			toItem.wukongState = TileWukongState.kJumping

		elseif theAction.addInfo == "jumpFin" then

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
			--theAction.jumpJsq = 0
			--toItem.isBlock = true

		elseif theAction.addInfo == "over" then
			toItem.wukongState = TileWukongState.kReadyToCasting

			mainLogic.gameActionList[actid] = nil
			
			if theAction.completeCallback then
				theAction.completeCallback()
			end
		end
	end
end

function GameBoardActionRunner:runningGameItemActionGoldZongZiCasting(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'over' then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local zongzi = mainLogic.gameItemMap[r][c]

		local toItemPos = theAction.speicalItemPos

		local function bombAll()

			GameExtandPlayLogic:itemDestroyHandler(mainLogic, r, c)
			zongzi:cleanAnimalLikeData()
			mainLogic:checkItemBlock(r, c)
			mainLogic:setNeedCheckFalling()

			if theAction.completeCallback then
				theAction.completeCallback()
			end
		end

		if theAction.isWaitingForBomb then
			theAction.jsq2 = theAction.jsq2 + 1

			if theAction.jsq2 == 20 then
				bombAll()
				mainLogic.gameActionList[actid] = nil
			end
		else
			local itemNum = #toItemPos
			local wrapNum = math.ceil( itemNum / 2 )
			local lineNum = itemNum - wrapNum
			local randlist = {}
			local warplist = {}
			local randIndex = 1

			for i=1 , itemNum do
				table.insert( randlist , {id = i ,wrap = true} )
			end

			for i=1,wrapNum do  
	    		randIndex = mainLogic.randFactory:rand(1, #randlist)
	    		warplist["id"..tostring(randlist[randIndex].id)] = true
	    		table.remove( randlist , randIndex )
			end

			for k, v in pairs(toItemPos) do
				local item = mainLogic.gameItemMap[v.r][v.c]
				if item.ItemType == GameItemType.kAddMove then
	    			item:initAddMoveConfig(mainLogic.addMoveBase)

	    			mainLogic.theCurMoves = mainLogic.theCurMoves + item.numAddMove
					if mainLogic.PlayUIDelegate then
						local function callback( ... )
							mainLogic.PlayUIDelegate:setMoveOrTimeCountCallback(mainLogic.theCurMoves, false)
						end
						local pos = mainLogic:getGameItemPosInView_ForPreProp(v.r, v.c)
						local icon = TileAddMove:createAddStepIcon(item.numAddMove)
						local scene = Director:sharedDirector():getRunningScene()
						local animation = PrefixPropAnimation:createAddMoveAnimation(icon, 0, callback, nil, ccp(pos.x, pos.y + 90))
						scene:addChild(animation)
					end
	    		end
				item.ItemType = GameItemType.kAnimal

				if warplist["id"..tostring(k)] then
					item.ItemSpecialType = AnimalTypeConfig.kWrap
				else
					if tostring( mainLogic.randFactory:rand(1, 2) ) == "1" then
						item.ItemSpecialType = AnimalTypeConfig.kLine
					else
						item.ItemSpecialType = AnimalTypeConfig.kColumn
					end
				end
				item.isNeedUpdate = true
			end
		end

		if not theAction.jsq2 then
			theAction.jsq2 = 0
			theAction.isWaitingForBomb = true
		end
	end
end

function GameBoardActionRunner:runningGameItemActionDestroyArea(mainLogic, theAction, actid, actByView)
	local x, y = theAction.ItemPos1.x, theAction.ItemPos1.y
	local xEnd, yEnd = theAction.ItemPos2.x, theAction.ItemPos2.y
	for r = y, yEnd do
		for c = x, xEnd do
			SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, 1, true)  --可以作用银币
			BombItemLogic:tryCoverByBomb(mainLogic, r, c, true, 1)
			SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3) 
		end
	end

	local data = mainLogic.boardmap[y][x]
	data.seaAnimalType = nil

	local item = mainLogic.boardView.baseMap[y][x]
	item:clearSeaAnimal()

	local str = string.format(GameMusicType.kEliminate, 1)
 	GamePlayMusicPlayer:playEffect(str);
	mainLogic.gameActionList[actid] = nil
	mainLogic:setNeedCheckFalling()
end


function GameBoardActionRunner:runningGameItemActionTransmission(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == "moveOver" then
		local from_r, from_c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local to_r, to_c = theAction.ItemPos2.x, theAction.ItemPos2.y

		mainLogic.boardmap[to_r][to_c]:changeDataAfterTrans(theAction.boardData)
		mainLogic.boardmap[to_r][to_c].isNeedUpdate = false
		local gameItemdata = mainLogic.gameItemMap[to_r][to_c]
		theAction.itemData.x = gameItemdata.x
		theAction.itemData.y = gameItemdata.y
		gameItemdata = nil
		mainLogic.gameItemMap[to_r][to_c]:getAnimalLikeDataFrom(theAction.itemData)
		mainLogic.gameItemMap[to_r][to_c].isNeedUpdate = false
		theAction.boardData = mainLogic.boardmap[to_r][to_c]
		theAction.addInfo = "reInitView"
	elseif theAction.addInfo == "over" then
		local to_r, to_c = theAction.ItemPos2.x, theAction.ItemPos2.y
		mainLogic:addNeedCheckMatchPoint(to_r, to_c)
		mainLogic:checkItemBlock(to_r, to_c)
		mainLogic.gameMode:afterStable(to_r, to_c)

		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionOctopusChangeForbiddenLevel(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'over' then
		local r, c = theAction.ItemPos1.y, theAction.ItemPos1.x
		local item = mainLogic.gameItemMap[r][c]
		item.forbiddenLevel = theAction.level
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionMaydayBossCasting(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'anim_over' then
		theAction.addInfo = 'data_over'
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local targetPositions = theAction.targetPositions
		local dripPositions = theAction.dripPositions
		if not dripPositions then dripPositions = {} end
		for k, v in pairs(targetPositions) do
			local item = mainLogic.gameItemMap[v.r][v.c]

			if dripPositions[tostring(v.r) .. "_" .. tostring(v.c)] then

				item.ItemType = GameItemType.kDrip
				item.ItemColorType = AnimalTypeConfig.kDrip
				item.dripState = DripState.kNormal
				item.isNeedUpdate = true
				mainLogic:addNeedCheckMatchPoint(v.r , v.c)
				mainLogic:setNeedCheckFalling()

			else
				item.ItemType = GameItemType.kQuestionMark
				mainLogic:onProduceQuestionMark(v.r, v.c)
				item.isNeedUpdate = true
			end
			
		end
	elseif theAction.addInfo == 'over' then
		
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end	
end

function GameBoardActionRunner:runnningGameItemActionBossDie(mainLogic, theAction, actid, actByView)
	local function cleanItem(r, c)
		local item = mainLogic.gameItemMap[r][c]
		local board = mainLogic.boardmap[r][c]
		item:cleanAnimalLikeData()
		item.isBlock = false
		item.isNeedUpdate = true
		mainLogic:checkItemBlock(r, c)
	end
	if theAction.addInfo == 'over' then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		GameExtandPlayLogic:itemDestroyHandler(mainLogic, r, c)
		
		cleanItem(r, c)
		cleanItem(r + 1, c)
		cleanItem(r, c+1)
		cleanItem(r+ 1, c+1)
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
		mainLogic:setNeedCheckFalling()
		FallingItemLogic:preUpdateHelpMap(mainLogic)
	elseif theAction.addInfo == 'dropped' then
		local addMoveItems = theAction.addMoveItemPos
		local questionItems = theAction.questionItemPos
		local dripPos = theAction.dripPos
		if not dripPos then dripPos = {} end
		for k, v in pairs(addMoveItems) do
			local item = mainLogic.gameItemMap[v.r][v.c]
			item.ItemType = GameItemType.kAddMove
			item:initAddMoveConfig(mainLogic.addMoveBase)
			item.isNeedUpdate = true
		end
		for k, v in pairs(questionItems) do
			local item = mainLogic.gameItemMap[v.r][v.c]
			item.ItemType = GameItemType.kQuestionMark
			item.isProductByBossDie = true
			mainLogic:onProduceQuestionMark(v.r, v.c)
			-- item:initAddMoveConfig(mainLogic.addMoveBase)
			item.isNeedUpdate = true
		end
		for k, v in pairs(dripPos) do
			local item = mainLogic.gameItemMap[v.r][v.c]
			item.ItemType = GameItemType.kDrip
			item.ItemColorType = AnimalTypeConfig.kDrip
			item.dripState = DripState.kNormal
			item.isNeedUpdate = true
			mainLogic:addNeedCheckMatchPoint(v.r , v.c)
		end
	end
end

function GameBoardActionRunner:runnningGameItemActionBossJump(mainLogic, theAction, actid, actByView)

	local function cleanItem(r, c)
		local item = mainLogic.gameItemMap[r][c]
		local board = mainLogic.boardmap[r][c]
		item:cleanAnimalLikeData()
		item.isBlock = false
		item.isNeedUpdate = true
		mainLogic:checkItemBlock(r, c)
	end
	local function copyItem(from_r, from_c, to_r, to_c)
		mainLogic.gameItemMap[to_r][to_c] = mainLogic.gameItemMap[from_r][from_c]:copy()
		mainLogic.gameItemMap[to_r][to_c].isNeedUpdate = true
		mainLogic.gameItemMap[to_r][to_c].x = to_c
		mainLogic.gameItemMap[to_r][to_c].y = to_r
		mainLogic:checkItemBlock(to_r, to_c)
	end

	if theAction.addInfo == 'over' then
		local from_r, from_c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local to_r, to_c = theAction.ItemPos2.x, theAction.ItemPos2.y
		copyItem(from_r, from_c, to_r, to_c)
		copyItem(from_r, from_c+1, to_r, to_c+1)
		copyItem(from_r+1, from_c, to_r+1, to_c)
		copyItem(from_r+1, from_c+1, to_r+1, to_c+1)

		cleanItem(from_r, from_c)
		cleanItem(from_r + 1, from_c)
		cleanItem(from_r, from_c+1)
		cleanItem(from_r+ 1, from_c+1)

		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
		mainLogic:setNeedCheckFalling()
		FallingItemLogic:preUpdateHelpMap(mainLogic)
		-- debug.debug()
	end
end

function GameBoardActionRunner:runningGameItemActionProductRabbit(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'shifted' then
		if theAction.ItemPos2 then
			-- copy
			-- local fromPos = theAction.ItemPos1
			-- local toPos = 
			local ox = mainLogic.gameItemMap[theAction.ItemPos2.r][theAction.ItemPos2.c].x
			local oy = mainLogic.gameItemMap[theAction.ItemPos2.r][theAction.ItemPos2.c].y
			mainLogic.gameItemMap[theAction.ItemPos2.r][theAction.ItemPos2.c] = mainLogic.gameItemMap[theAction.ItemPos1.r][theAction.ItemPos1.c]:copy()
			mainLogic.gameItemMap[theAction.ItemPos2.r][theAction.ItemPos2.c].isNeedUpdate = true
			mainLogic.gameItemMap[theAction.ItemPos2.r][theAction.ItemPos2.c].x = ox
			mainLogic.gameItemMap[theAction.ItemPos2.r][theAction.ItemPos2.c].y = oy
		end
	elseif theAction.addInfo == 'over' then
		local item = mainLogic.gameItemMap[theAction.ItemPos1.r][theAction.ItemPos1.c]
		item:changeToRabbit(theAction.color, theAction.level)
		item:changeRabbitState(GameItemRabbitState.kSpawn)
		item.isNeedUpdate = true
		if theAction.completeCallback then
			theAction.completeCallback()
		end

		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionProductSnail(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "over" then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		local board = mainLogic.boardmap[r][c]
		item:changeToSnail(board.snailRoadType)
		mainLogic:checkItemBlock(r, c)
		FallingItemLogic:preUpdateHelpMap(mainLogic)
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		item.isNeedUpdate = true
		mainLogic.gameActionList[actid] = nil

	end
end

function GameBoardActionRunner:runningGameItemActionSnailRoadBright(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "over" then
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionHedgehogRoadState(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "over" then
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionMimosaReady(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "over" then
		if theAction.completeCallback then 
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end

end

function GameBoardActionRunner:runningGameItemActionMimosaGrow(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "animation_over" then
		theAction.addInfo = "effect_item"
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		local list = item.mimosaHoldGrid
		for k, v in pairs(theAction.addItem) do 
			mainLogic:checkItemBlock(v.x,v.y)
			-- table.insert(list, v)
		end
		FallingItemLogic:preUpdateHelpMap(mainLogic)
		theAction.mimosaHoldGrid = list
	elseif theAction.addInfo == "over" then
		if theAction.completeCallback then 
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end

end

function GameBoardActionRunner:runningGameItemActionMimosaBack(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "over" then
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		local list = item.mimosaHoldGrid
		for k, v in pairs(list) do 
			local item_grid = mainLogic.gameItemMap[v.x][v.y]
			item_grid.beEffectByMimosa = 0
			item_grid.mimosaDirection = 0
			mainLogic:checkItemBlock(v.x, v.y)
			mainLogic:addNeedCheckMatchPoint(v.x, v.y)
		end
		FallingItemLogic:preUpdateHelpMap(mainLogic)
		item.mimosaHoldGrid = {}
		-- item.mimosaLevel = 1
		if theAction.completeCallback then
			theAction.completeCallback()
		end

		mainLogic.gameActionList[actid] = nil
	end

end

function GameBoardActionRunner:runningGameItemActionBlackCuteBallUpdate(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "replace" then
		theAction.addInfo = "over"
		if theAction.ItemPos2 then
			local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
			local item1 = mainLogic.gameItemMap[r1][c1]

			local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
			local item2 = mainLogic.gameItemMap[r2][c2]
			item2.ItemType = GameItemType.kBlackCuteBall
			item2.isBlock = false
			item2.ItemColorType = 0
			item2.ItemSpecialType = 0
			item2.isEmpty = false
			item2.blackCuteStrength = item1.blackCuteStrength
			item2.isNeedUpdate = true
		end

	elseif theAction.addInfo == "over" then
		local r1, c1 = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item1 = mainLogic.gameItemMap[r1][c1]

		if theAction.ItemPos2 then
			item1:cleanAnimalLikeData()
		else
			item1.blackCuteStrength = item1.blackCuteStrength + 1
		end

		if theAction.completeCallback then 
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionUpdatePM25(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "over" then 
		mainLogic.gameActionList[actid] = nil

		FallingItemLogic:preUpdateHelpMap(mainLogic)
		if theAction.completeCallback then 
			theAction.completeCallback()
		end
	elseif theAction.addInfo == "replace" then
		theAction.addInfo = "replaceView"
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		local board = mainLogic.boardmap[r][c]
		if item then 
			item:changeToDigGround(1)
			item.isNeedUpdate = true
		end

		if board then 
			board.isBlock = true
		end
	end
end

function GameBoardActionRunner:runningGameItemActionMonsterDestroyItem(mainLogic, theAction, actid, actByView)
	-- body
	local function overAction( ... )
		-- body
		theAction.addInfo = ""
		mainLogic.gameActionList[actid] = nil
		if theAction.completeCallback then 
			theAction.completeCallback()
		end
		mainLogic:setNeedCheckFalling()
	end

	local function bombItem(r, c, dirs)
		-- body
		local item = mainLogic.gameItemMap[r][c]
		local boardData = mainLogic.boardmap[r][c]
		BombItemLogic:tryCoverByBomb(mainLogic, r, c, true, 1)
		SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3) 
		SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r, c, dirs) --冰柱处理
		if (boardData.iceLevel > 0 or boardData.sandLevel > 0 )  and 
		   (item.ItemType == GameItemType.kAnimal or item.ItemType == GameItemType.kCrystal) and
		   not item:hasFurball() and 
		   not item:hasLock() and 
		  item:isAvailable() then 
			SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, 1)
		end
	end

	if theAction.addInfo == "over" then
		local r_min = theAction.ItemPos1.x
		local r_max = theAction.ItemPos2.x
		local c_min = theAction.ItemPos1.y
		local c_max = theAction.ItemPos2.y

		if r_max - r_min > 3 and c_max - c_min > 3 then        ---脚踩全屏
			theAction.time_count = theAction.time_count or 0
			if theAction.time_count >= 5 then
				overAction()
			else
				local dirs = {ChainDirConfig.kUp, ChainDirConfig.kDown, ChainDirConfig.kRight, ChainDirConfig.kLeft}

				for r = 5 - theAction.time_count, 5 + theAction.time_count do 
					for c = 5 - theAction.time_count, 5 + theAction.time_count do
						if r >= 5 - theAction.time_count + 1 and 
						   r <= 5 + theAction.time_count - 1 and 
						   c >= 5 - theAction.time_count + 1 and 
						   c <= 5 + theAction.time_count - 1 then
						else
							bombItem(r, c, dirs)
						end
					end
				end
				theAction.time_count = theAction.time_count + 1
			end

		else                                                   ---3*2格子
			for r = r_min , r_max do 
				for c = c_min, c_max do 
					local dirs = {ChainDirConfig.kUp, ChainDirConfig.kDown, ChainDirConfig.kRight, ChainDirConfig.kLeft}
					if r == r_min then 
						table.remove(dirs, ChainDirConfig.kUp)
					elseif r == r_max then 
						table.remove(dirs, ChainDirConfig.kDown)
					elseif c == c_min then 
						table.remove(dirs, ChainDirConfig.kLeft)
					elseif c == c_max then 
						table.remove(dirs, ChainDirConfig.kRight)
					end
					bombItem(r, c, dirs)
				end
			end

			overAction()
		end
	end
end

function GameBoardActionRunner:runningGameItemActionTileBlockerUpdate( mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "over" then
		theAction.addInfo = nil
		mainLogic.gameActionList[actid] = nil
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		if theAction.coutDown == 0 then
			mainLogic.boardmap[r][c].isReverseSide = not mainLogic.boardmap[r][c].isReverseSide
			mainLogic.gameItemMap[r][c].isReverseSide = not mainLogic.gameItemMap[r][c].isReverseSide
			-- mainLogic.gameItemMap[r][c].isBlock = mainLogic.gameItemMap[r][c]:checkBlock() --mainLogic.boardmap[r][c].isReverseSide
			mainLogic:checkItemBlock(r,c)
			FallingItemLogic:preUpdateHelpMap(mainLogic)
			mainLogic:addNeedCheckMatchPoint(r, c)

			if mainLogic.gameItemMap[r][c]:isActiveTotems() and not mainLogic.gameItemMap[r][c].isReverseSide then
				-- 如果翻过来的是超级小金刚，检查当前棋盘上是否有已存在的超级小金刚
				mainLogic:addNewSuperTotemPos(IntCoord:create(r, c))
				mainLogic:tryBombSuperTotems()
			end
		end
		
		if theAction.completeCallback and type(theAction.completeCallback) == "function" then
			theAction.completeCallback()
		end


	end
end

function GameBoardActionRunner:runningGameItemLogicActionForceMoveItem( mainLogic, theAction, actid, actByView)
	-- body
	if theAction.addInfo == "over" then 
		theAction.addInfo = nil
		mainLogic.gameActionList[actid] = nil
		local r1, c1  = theAction.ItemPos1.x, theAction.ItemPos1.y
		
		if not theAction.isTop then 
			if theAction.isUfoLikeItem then
				local r2, c2 = theAction.ItemPos2.x, theAction.ItemPos2.y
				local data1 = mainLogic.gameItemMap[r1][c1]
				local data2 = mainLogic.gameItemMap[r2][c2]
				if not SwapItemLogic:_trySwapedMatchItem(mainLogic, r1, c1, r2, c2, true) then
					local item1Clone = data1:copy()
					local item2Clone = data2:copy()
					data2:getAnimalLikeDataFrom(item1Clone)
					data1:getAnimalLikeDataFrom(item2Clone)
					data1.isNeedUpdate = false
					data2.isNeedUpdate = false
				end 
			end

			if theAction.completeCallback and type(theAction.completeCallback) == "function" then
				theAction.completeCallback()
			end
		else
			local item = mainLogic.gameItemMap[theAction.ItemPos1.x][theAction.ItemPos1.y]
			local collect_item = {r = r1, c = c1, level = item.rabbitLevel}
			item:cleanAnimalLikeData()
			mainLogic.isUFOWin = true
			table.insert(mainLogic.UFOCollection, collect_item)
			if theAction.completeCallback then theAction.completeCallback() end
		end

	end
end

function GameBoardActionRunner:runningGameItemlogicActionChangeToIngredient( mainLogic, theAction, actid, actByView )
	-- body
	if theAction.addInfo == "over" then 
		-- debug.debug()
		theAction.addInfo = nil
		local r1, c1  = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r1][c1]
		item:changeToIngredient()
		item.isNeedUpdate = true
		if theAction.completeCallback and type(theAction.completeCallback) then
				theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

------气球更新
function GameBoardActionRunner:runningGameItem_BalloonUpdate( mainLogic, theAction, actid, actByView )
	-- body
	if theAction.actionDuring == 1 then
		if theAction.completeCallback and type(theAction.completeCallback) then 
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runGameItemlogicActionBalloonRunaway(mainLogic, theAction, actid, actByView)
	-- body
	if theAction.actionStatus == GameActionStatus.kRunning then
		if theAction.actionDuring == 1 then 
			local item = mainLogic.gameItemMap[theAction.ItemPos1.x][theAction.ItemPos1.y]
			item:cleanAnimalLikeData()
			mainLogic.gameActionList[actid] = nil
			if theAction.completeCallback and type(theAction.completeCallback) == "function" then
				theAction.completeCallback()
			end
		end
	end
end

-----水晶变化
function GameBoardActionRunner:runningGameItem_Crystal_Change(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == "over" then
		if theAction.callback and type(theAction.callback) == "function" then
			theAction.callback()
		end
		mainLogic.gameActionList[actid] = nil
		return
	end
	if theAction.actionDuring == 1 then
		theAction.addInfo = "over"
	end
end

-----毒液蔓延
function GameBoardActionRunner:runningGameItem_Venom_Spread(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == "replace" then

		theAction.addInfo = "replaceView"
		local r1 = theAction.ItemPos2.x
		local c1 = theAction.ItemPos2.y

		local targetItem = mainLogic.gameItemMap[r1] and mainLogic.gameItemMap[r1][c1]
		local targetBoard = mainLogic.boardmap[r1] and mainLogic.boardmap[r1][c1]

		if targetItem then
			targetItem:changeToVenom()
			targetItem.isNeedUpdate = true
		end
		if targetBoard then
			targetBoard.isBlock = true
		end
		FallingItemLogic:preUpdateHelpMap(mainLogic)
	elseif theAction.addInfo == "over" then
		if theAction.callback and type(theAction.callback) == "function" then
			theAction.callback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItem_Furball_Transfer(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == "over" then
		if theAction.callback and type(theAction.callback) == "function" then
			theAction.callback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end


function GameBoardActionRunner:runningGameItem_Furball_Split(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == "over" then
		
		if theAction.callback and type(theAction.callback) == "function" then
			theAction.callback()
		end
		mainLogic.gameActionList[actid] = nil
	end	

end

function GameBoardActionRunner:runningGameItem_Roost_Replace(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == "replace" then
		for i, pos in ipairs(theAction.itemList) do
			local r = pos.x
			local c = pos.y
			local changeItem = mainLogic.gameItemMap[r][c]
			changeItem.isNeedUpdate = true
		end
		theAction.addInfo = "over"
	elseif theAction.addInfo == "over" then
		if theAction.callback and type(theAction.callback) == "function" then
			theAction.callback()
		end
		mainLogic.gameActionList[actid] = nil
	end	
end

function GameBoardActionRunner:existInSpecialBombLightUpPos(r, c, lightUpMatchPosList)
	if lightUpMatchPosList then
		for i,v in ipairs(lightUpMatchPosList) do
			if v.r == r and v.c == c then
				return true
			end
		end
	end
	return false
end

function GameBoardActionRunner:runningGameItemRefresh_Item_Flying(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == "over" then

		--[[
		local r1 = theAction.ItemPos1.x
		local c1 = theAction.ItemPos1.y
		local r2 = theAction.ItemPos2.x
		local c2 = theAction.ItemPos2.y

		local data1 = boardView.gameBoardLogic.gameItemMap[r1][c1] 		----目标
		local data2 = boardView.gameBoardLogic.gameItemMap[r2][c2]		----来源

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
		]]

		if theAction.callback and type(theAction.callback) == "function" then
			theAction.callback()
		end
		mainLogic.gameActionList[actid] = nil
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

function GameBoardActionRunner:runGameItemSpecialFurballUnstable(mainLogic, theAction, actid, actByView)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		mainLogic:setNeedCheckFalling()
	elseif theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		mainLogic.gameActionList[actid] = nil
	end
end

function GameBoardActionRunner:runningGameItemActionSandTransfer(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == "over" then
		if theAction.callback and type(theAction.callback) == "function" then
			theAction.callback()
		end
		mainLogic.gameActionList[actid] = nil
	end
end