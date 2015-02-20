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
	if theAction.actionType == GameItemActionType.kItemRefresh_Item_Flying then
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
	elseif theAction.actionType == GameItemActionType.kItem_Monster_Jump then
		GameBoardActionRunner:runningGameItemActionMonsterJump(mainLogic, theAction, actid, actByView)
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
	end
end

function GameBoardActionRunner:runningGameItemActionHalloweenBossCasting(mainLogic, theAction, actid, actByView)
	if theAction.addInfo == 'over' then
		-- print('***************** Halloween Boss Casting')

		local toItemPos = theAction.destPositions
		local boss = mainLogic:getHalloweenBoss()

		for k, v in pairs(toItemPos) do
			local item = mainLogic.gameItemMap[v.r][v.c]
			if k <= boss.genBellCount then
				-- 带宝石的云块
				item:cleanAnimalLikeData()
				item.digJewelLevel = 1 
				item.ItemType = GameItemType.kDigJewel 
				item.isBlock = true 
				item.isEmpty = false 
				item.digJewelType = 3
			else 
				-- 单纯的云块
				item:cleanAnimalLikeData()
				item.digGroundLevel = 1 
				item.ItemType = GameItemType.kDigGround 
				item.isBlock = true 
				item.isEmpty = false
			end
			mainLogic:checkItemBlock(v.r,v.c)
			item.isNeedUpdate = true
		end
		theAction.addInfo = 'complete'
	elseif theAction.addInfo == 'complete' then
		if theAction.completeCallback then
			theAction.completeCallback()
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
		-- print('***************** Halloween Boss Die')
		local toItemPos = theAction.destPositions
		for k, v in pairs(toItemPos) do
			local item = mainLogic.gameItemMap[v.r][v.c]
			item.ItemType = GameItemType.kAddMove
			item:initAddMoveConfig(mainLogic.addMoveBase)
			item.isNeedUpdate = true
		end
		if theAction.completeCallback then
			theAction.completeCallback()
		end
		mainLogic.gameActionList[actid] = nil
	elseif theAction.addInfo == 'died' then
		mainLogic:halloweenBossDie(theAction.diePosition)
		theAction.addInfo = "died_action"

	end
end

function GameBoardActionRunner:runningGameItemActionMagicTileHit(mainLogic, theAction, actid, actByView) 
	if theAction.addInfo == 'over' then
		-- print('***************** Halloween Magic Tile Hit')
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
		local boss = mainLogic:getHalloweenBoss() 
		if boss then
			local count = boss.dropBellOnHit
			mainLogic.digJewelCount:setValue(mainLogic.digJewelCount:getValue() + count)
			if mainLogic.PlayUIDelegate then
				for k = 1, count do 
					mainLogic.PlayUIDelegate:setTargetNumber(0, 1, mainLogic.digJewelCount:getValue(), theAction.bossPosition)
				end
			end
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
			item.ItemSpecialType = 7 + mainLogic.randFactory:rand(0, 1)
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
		local gameItemdata = mainLogic.gameItemMap[to_r][to_c]
		theAction.itemData.x = gameItemdata.x
		theAction.itemData.y = gameItemdata.y
		gameItemdata = nil
		mainLogic.gameItemMap[to_r][to_c]:getAnimalLikeDataFrom(theAction.itemData)
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
		for k, v in pairs(targetPositions) do
			local item = mainLogic.gameItemMap[v.r][v.c]
			item.ItemType = GameItemType.kQuestionMark
			mainLogic:onProduceQuestionMark(v.r, v.c)
			item.isNeedUpdate = true
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
			item_grid.beEffectByMimosa = false
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
	if theAction.addInfo == "over" then
		theAction.addInfo = ""
		mainLogic.gameActionList[actid] = nil
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local item = mainLogic.gameItemMap[r][c]
		local boardData = mainLogic.boardmap[r][c]
		local times = theAction.times
		for k = 1, times do 
			if boardData.iceLevel > 0 and (item.ItemType == GameItemType.kAnimal 
				or item.ItemType == GameItemType.kCrystal
				or item.ItemType == GameItemType.kCoin)  then 
			else
				BombItemLogic:tryCoverByBomb(mainLogic, r, c, true, 1)
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3) 
			end
			SpecialCoverLogic:doEffectLightUpAtPos(mainLogic, r, c, 1)
		end
		if theAction.completeCallback then 
			theAction.completeCallback()
		end
	end
end

function GameBoardActionRunner:runningGameItemActionMonsterJump( mainLogic, theAction, actid, actByView )
	-- body
	if theAction.addInfo == "over" then
		theAction.addInfo = ""
		mainLogic.gameActionList[actid] = nil
		local r, c = theAction.ItemPos1.x, theAction.ItemPos1.y
		local gameItemMap = mainLogic.gameItemMap
		local itemList = {gameItemMap[r][c], gameItemMap[r][c+1], gameItemMap[r+1][c], gameItemMap[r+1][c+1]}
		for k, v in pairs(itemList) do 
			v:cleanAnimalLikeData()
			mainLogic:checkItemBlock(v.y,v.x)
		end
		FallingItemLogic:preUpdateHelpMap(mainLogic)

		if theAction.completeCallback then 
			theAction.completeCallback()
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
			mainLogic.gameItemMap[r][c].isBlock = mainLogic.gameItemMap[r][c]:checkBlock() --mainLogic.boardmap[r][c].isReverseSide
			mainLogic:checkItemBlock(r,c)
			FallingItemLogic:preUpdateHelpMap(mainLogic)
			mainLogic:addNeedCheckMatchPoint(r, c)
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