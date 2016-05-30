--------特效覆盖引起的各种逻辑----------

SpecialCoverLogic = class{}

-----在某个位置引起了特效消除-----减除冰层，减除牢笼，减除雪花等等效果
-- covertype : 1: 上下影响  2：左右影响  3：四周影响
-- noCD: 为false挖地、宝石一帧内多次调用会只调用一次， 为true会多次调用
function SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, covertype, scoreScale, actId, noCD, noScore)
	-----成功消除时候会影响周围的东西
	if SpecialCoverLogic:canEffectAround(mainLogic, r, c) then
		
		if covertype == 1 then
			SpecialCoverLogic:tryEffectSpecialAround(mainLogic, r, c, r - 1, c, noScore)		--上下
			SpecialCoverLogic:tryEffectSpecialAround(mainLogic, r, c, r + 1, c, noScore)
		elseif covertype == 2 then
			SpecialCoverLogic:tryEffectSpecialAround(mainLogic, r, c, r , c - 1, noScore)		--左右
			SpecialCoverLogic:tryEffectSpecialAround(mainLogic, r, c, r , c + 1, noScore)
		elseif covertype == 3 then
			SpecialCoverLogic:tryEffectSpecialAround(mainLogic, r, c, r - 1, c, noScore)		--四方
			SpecialCoverLogic:tryEffectSpecialAround(mainLogic, r, c, r + 1, c, noScore)
			SpecialCoverLogic:tryEffectSpecialAround(mainLogic, r, c, r , c - 1, noScore)
			SpecialCoverLogic:tryEffectSpecialAround(mainLogic, r, c, r , c + 1, noScore)
		end
	end
	if SpecialCoverLogic:canBeEffectBySpecialAt(mainLogic, r, c) then
		SpecialCoverLogic:effectBlockerAt(mainLogic, r, c, scoreScale, actId, noCD, noScore)
	end
end

function SpecialCoverLogic:specialCoverChainsAroundPos(mainLogic, r, c, dirs)
	dirs = dirs or {ChainDirConfig.kUp, ChainDirConfig.kDown, ChainDirConfig.kRight, ChainDirConfig.kLeft}
	SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r, c, dirs)
	for _, v in pairs(dirs) do
		if v == ChainDirConfig.kUp then
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r-1, c, {ChainDirConfig.kDown})
		elseif v == ChainDirConfig.kDown then
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r+1, c, {ChainDirConfig.kUp})
		elseif v == ChainDirConfig.kLeft then
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r, c-1, {ChainDirConfig.kRight})
		elseif v == ChainDirConfig.kRight then
			SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r, c+1, {ChainDirConfig.kLeft})
		end
	end
end

-- centerR, centerC, radius 区域特效使用
function SpecialCoverLogic:specialCoverChainsAtPos(mainLogic, r, c, breakDirs)
	if not mainLogic:isPosValid(r, c) then
		return
	end
	breakDirs = breakDirs or {ChainDirConfig.kUp, ChainDirConfig.kDown, ChainDirConfig.kRight, ChainDirConfig.kLeft}

	local board = mainLogic.boardmap[r][c]
	-- local item = mainLogic.gameItemMap[r][c]
	local breakLevels = board:decChainsInDirections(breakDirs)
	local notEmpty = false
	local hasChainBreaked = false
	for dir, level in pairs(breakLevels) do
		if level > 0 then 
			notEmpty = true
		end
		if level == 1 then
			hasChainBreaked = true
		end
	end
	if not notEmpty then return end

	board.isNeedUpdate = true
	-- item.isNeedUpdate = true
	
	mainLogic.boardView.baseMap[r][c]:playChainBreakAnim(breakLevels, nil)

	if hasChainBreaked then
		mainLogic:setChainBreaked()
		mainLogic.gameMode:afterChainBreaked(r, c)
	end
	-- print("breakLevels:", table.tostring(breakLevels))
end

--消除冰块
function SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, scoreScale, canEffectCoin)
	if SpecialCoverLogic:canEffectLightUpAt(mainLogic, r, c, canEffectCoin) then
		SpecialCoverLogic:doEffectLightUpAtPos(mainLogic, r, c, scoreScale)
	end
	-- 流沙与冰块类似
	if SpecialCoverLogic:canEffectSandAtPos(mainLogic, r, c, false) then
		SpecialCoverLogic:doEffectSandAtPos(mainLogic, r, c)
	end
end

--消除流沙
function SpecialCoverLogic:doEffectSandAtPos(mainLogic, r, c)
	if not mainLogic:isPosValid(r, c) then 
		return false 
	end

	local board = mainLogic.boardmap[r][c]
	if board.sandLevel > 0 then
		board.sandLevel = board.sandLevel - 1
		----1-3.播放特效
		local sandCleanAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_Sand_Clean,
			IntCoord:create(r,c),				
			nil,				
			GamePlayConfig_MaxAction_time)
		mainLogic:addDestroyAction(sandCleanAction)
		mainLogic:tryDoOrderList(r, c, GameItemOrderType.kOthers, GameItemOrderType_Others.kSand, 1)

		local addScore = GamePlayConfigScore.SandClean
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)

		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r,c),				
			nil,				
			1)
		ScoreAction.addInt = addScore
		ScoreAction.addInt2 = 2
		mainLogic:addGameAction(ScoreAction)
		return true
	end
	return false
end

function SpecialCoverLogic:canEffectLightUpAt(mainLogic, r, c, canEffectCoin)
	if mainLogic.theGamePlayType ~= GamePlayType.kLightUp
		and mainLogic.theGamePlayType ~= GamePlayType.kSeaOrder then 
		return false
	end
	if not mainLogic:isPosValid(r, c) then
		return false
	end
	local board = mainLogic.boardmap[r][c];
	local item = mainLogic.gameItemMap[r][c]
	if board.iceLevel > 0 then
		if item and item:canEffectLightUp() then
			if item.ItemType == GameItemType.kCoin and not canEffectCoin then 
				return false
			else
				return true
			end
		end
	end 
	return false
end

----可以被此处的Special影响到---
function SpecialCoverLogic:canBeEffectBySpecialAt(mainLogic, r, c)
	if not mainLogic:isPosValid(r, c) then return false end

	local item = mainLogic.gameItemMap[r][c];
	if item.isReverseSide then return false end
	local board = mainLogic.boardmap[r][c];
	if item:hasLock()
		or item.snowLevel > 0
		or item.venomLevel > 0
		or board.lotusLevel > 0
		or item.ItemType == GameItemType.kRoost
		or item:hasFurball()
		or item:hasActiveSuperCuteBall()
		or item.digGroundLevel > 0
		or item.digJewelLevel > 0 
		or item.bigMonsterFrostingStrength > 0
		or item.ItemType == GameItemType.kBlackCuteBall
		or item.ItemType == GameItemType.kMimosa 
		or item.ItemType == GameItemType.kKindMimosa
		or item.beEffectByMimosa > 0
		or item.ItemType == GameItemType.kBoss
		or item.ItemType == GameItemType.kHoneyBottle
		or item.ItemType == GameItemType.kMagicLamp
		or item.ItemType == GameItemType.kWukong
		or item.ItemType == GameItemType.kBottleBlocker
		or item.ItemType == GameItemType.kMagicStone
		or item.ItemType == GameItemType.kGoldZongZi
		or item.ItemType == GameItemType.kCrystalStone
		then
		return true
	end
	return false
end

----是否可以引起周围的消除----
function SpecialCoverLogic:canEffectAround(mainLogic, r, c)
	if mainLogic.gameItemMap[r] and mainLogic.gameItemMap[r][c] then
		if mainLogic.gameItemMap[r][c]:isColorful() 
			and not mainLogic.gameItemMap[r][c]:hasLock()
			and not mainLogic.gameItemMap[r][c]:hasFurball()
			and mainLogic.gameItemMap[r][c]:isAvailable()
			and mainLogic.gameItemMap[r][c].ItemType ~= GameItemType.kBottleBlocker
			then 
			return true
		end
	end
	return false
end

function SpecialCoverLogic:tryEffectSpecialAround(mainLogic, r, c, r1, c1, noScore)
	if r1 == 9 and c1 == 3 then
		local item = mainLogic.gameItemMap[r1][c1]
	end
	if not mainLogic:isPosValid(r1, c1) then 
		return end

	if SpecialCoverLogic:canBeEffectBySpecialCoverAnimalAround(mainLogic, r, c, r1, c1) then
		SpecialCoverLogic:effectBlockerAt(mainLogic, r1, c1, 1, nil, false, noScore)
	end
end

----可以被周围的SpecialCoverAnimal<特效消除小动物>影响到----
function SpecialCoverLogic:canBeEffectBySpecialCoverAnimalAround(mainLogic, r, c, r1, c1)
	if not mainLogic:isPosValid(r1, c1) then return false end

	local item = mainLogic.gameItemMap[r1][c1]
	local board = mainLogic.boardmap[r1][c1]

	if not item:isAvailable() then return false end

	if item 
		and (item.ItemType == GameItemType.kVenom 
		or item.ItemType == GameItemType.kDigGround
		or item.ItemType == GameItemType.kDigJewel
		or item.ItemType == GameItemType.kGoldZongZi)
		-- or item.honeyLevel > 0 
		then
		if mainLogic:hasChainInNeighbors(r, c, r1, c1) then -- 两者之间有冰柱
			return false
		end
		return true
	end
	return false
end

function SpecialCoverLogic:doEffectLightUpAtPos(mainLogic, r, c, scoreScale)
	if not mainLogic:isPosValid(r, c) then 
		return false 
	end

	local item = mainLogic.gameItemMap[r][c]
	local board = mainLogic.boardmap[r][c]

	scoreScale = scoreScale or 1
	if board.iceLevel > 0 then
		----1-1.数据变化
		board.iceLevel = board.iceLevel - 1

		----1-2.分数统计
		local addScore = scoreScale * GamePlayConfigScore.MatchAtIce
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)

		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r,c),				
			nil,				
			1)
		ScoreAction.addInt = addScore
		ScoreAction.addInt2 = 2
		mainLogic:addGameAction(ScoreAction)

		----1-3.播放特效
		local IceAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemMatchAt_IceDec,
			IntCoord:create(r,c),	
			nil,	
			GamePlayConfig_MaxAction_time)
		mainLogic:addDestroyAction(IceAction)
		item.isNeedUpdate = true
		board.isNeedUpdate = true

		if mainLogic.PlayUIDelegate and mainLogic.gameMode:is(LightUpMode) then
			local pos_t = mainLogic:getGameItemPosInView(r,c);
			local ice_left_count = mainLogic.gameMode:checkAllLightCount(mainLogic)
			mainLogic.PlayUIDelegate:setTargetNumber(0, 0, ice_left_count, pos_t)
		end
	end
end

function SpecialCoverLogic:canEffectSandAtPos(mainLogic, r, c, canEffectCoin)
	if not mainLogic:isPosValid(r, c) then
		return false
	end
	local board = mainLogic.boardmap[r][c];
	local item = mainLogic.gameItemMap[r][c]
	if board.sandLevel > 0 then
		if item and item:canEffectLightUp() then
			if item.ItemType == GameItemType.kCoin and not canEffectCoin then 
				return false
			else
				return true
			end
		end
	end 
	return false
end

function SpecialCoverLogic:effectLightUpAtCrystalStone(mainLogic, r, c, scoreScale)
	if r<=0 or r>#mainLogic.boardmap or c<=0 or c>#mainLogic.boardmap[r] then return false end

	local item = mainLogic.gameItemMap[r][c]
	local board = mainLogic.boardmap[r][c]
	if item.ItemType == GameItemType.kCrystalStone and item:isCrystalStoneActive() then
		if board.iceLevel > 0 then
			SpecialCoverLogic:doEffectLightUpAtPos(mainLogic, r, c, scoreScale)
		end
		if board.sandLevel > 0 then
			SpecialCoverLogic:doEffectSandAtPos(mainLogic, r, c)
		end
	end
end

function SpecialCoverLogic:effectTotemsAt(mainLogic, r, c, scoreScale)
	local item = mainLogic.gameItemMap[r][c]
	if item and item:isAvailable() and not item:hasLock() then
		if item.ItemType == GameItemType.kTotems and item.totemsState == GameItemTotemsState.kNone then
			item.totemsState = GameItemTotemsState.kWattingActive

			scoreScale = scoreScale or 1
			GameExtandPlayLogic:addScoreToTotal(mainLogic, r, c, GamePlayConfigScore.NormalTotems * scoreScale)

			local action = GameBoardActionDataSet:createAs(
	                        GameActionTargetType.kGameItemAction,
	                        GameItemActionType.kItem_Totems_Change,
	                        IntCoord:create(r, c),
	                        nil,
	                        GamePlayConfig_MaxAction_time)
			action.isSpecialCover = true
		    mainLogic:addDestroyAction(action)
		end
	end
end

function SpecialCoverLogic:effectBlockerAt(mainLogic, r, c, scoreScale, actId, noCD, noScore)
	if r<=0 or r>#mainLogic.boardmap or c<=0 or c>#mainLogic.boardmap[r] then return false end;

	local item = mainLogic.gameItemMap[r][c];
	local board = mainLogic.boardmap[r][c];
	local hasLockOrigin = item:hasLock()

	if board.superCuteState == GameItemSuperCuteBallState.kActive and not board.superCuteInHit then
		board.superCuteInHit = true
		if not mainLogic.isInStep then
			board.superCuteAddInt = GamePlayConfig_SuperCute_InactiveRound_UseProp
		else
			board.superCuteAddInt = GamePlayConfig_SuperCute_InactiveRound_UseMove
		end
		
		local action = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_SuperCute_Inactive,
                        IntCoord:create(r, c),
                        nil,
                        GamePlayConfig_MaxAction_time)
	    mainLogic:addDestroyAction(action)
		return
	end

	if item.questionMarkProduct > 0 then  ------------从问号障碍生成，需要保护一段时间
		return 
	end

	local passLotusDecrease = false
	if item.isEmpty 
		or not item:isAvailable()
		or item.ItemType == GameItemType.kCoin 
		or item.ItemType == GameItemType.kCrystalStone 
		or item.ItemType == GameItemType.kVenom 
		or item.ItemType == GameItemType.kSnow 
		or item.ItemType == GameItemType.kBlackCuteBall
		or item.ItemType == GameItemType.kHoneyBottle
		or item.honeyLevel > 0
		or item.cageLevel > 0
		or item.beEffectByMimosa > 0
		or item.furballLevel > 0
		or board.isReverseSide
		then
		passLotusDecrease = true
	end

	scoreScale = scoreScale or 1
	------1.牢笼变化------
	if item.cageLevel > 0 then
		----1-1.数据变化
		item.cageLevel = item.cageLevel - 1

		-----1-2.分数变化
		if not noScore then
			local addScore = GamePlayConfigScore.MatchAtLock * scoreScale
			ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r,c),				
				nil,				
				1)
			ScoreAction.addInt = addScore
			mainLogic:addGameAction(ScoreAction)
		end

		----1-3.播放特效
		local LockAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemMatchAt_LockDec,
			IntCoord:create(r,c),				
			nil,				
			GamePlayConfig_GameItemSnowDeleteAction_CD)
		mainLogic:addDestroyAction(LockAction)
		-- item.isNeedUpdate = true
		-- board.isNeedUpdate = true
	elseif item.honeyLevel > 0 then
		GameExtandPlayLogic:honeyDestroy( mainLogic, r, c, scoreScale )
	end

	----2.检测雪花/毒液消除----
	if item.snowLevel > 0 then
		----1-1.数据变化
		item.snowLevel = item.snowLevel - 1
		if item.snowLevel == 0 then
			item:AddItemStatus(GameItemStatusType.kDestroy)
			SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
			mainLogic:tryDoOrderList(r, c, GameItemOrderType.kSpecialTarget, GameItemOrderType_ST.kSnowFlower, 1) -------记录消除
		end

		if not noScore then
			----1-2.分数统计
			local addScore = scoreScale * GamePlayConfigScore.MatchBySnow
			ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r,c),				
				nil,				
				1)
			ScoreAction.addInt = addScore
			mainLogic:addGameAction(ScoreAction)
		end

		----1-3.播放特效
		local SnowAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemMatchAt_SnowDec,
			IntCoord:create(r,c),				
			nil,				
			GamePlayConfig_GameItemSnowDeleteAction_CD)
		SnowAction.addInt = item.snowLevel + 1
		mainLogic:addDestroyAction(SnowAction)
	elseif item.venomLevel > 0 then
		item.venomLevel = item.venomLevel - 1
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
		mainLogic:tryDoOrderList(r, c, GameItemOrderType.kSpecialTarget, GameItemOrderType_ST.kVenom, 1) -------记录消除

		if not noScore then
			local addScore = scoreScale * GamePlayConfigScore.MatchBySnow
			ScoreCountLogic:addScoreToTotal(mainLogic, addScore)

			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r, c),
				nil,
				1)
			ScoreAction.addInt = addScore
			mainLogic:addGameAction(ScoreAction)
		end

		local VenomAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemMatchAt_VenowDec,
			IntCoord:create(r, c),
			nil,
			GamePlayConfig_GameItemBlockerDeleteAction_CD)
		mainLogic:addDestroyAction(VenomAction)
		mainLogic.gameItemMap[r][c]:AddItemStatus(GameItemStatusType.kDestroy)
	elseif item.ItemType == GameItemType.kRoost then
		local roostLevel = item.roostLevel
		item:roostUpgrade()
		local times = item.roostLevel - roostLevel
		if times > 0 then

			if not noScore then
				local scoreTotal = times * GamePlayConfigScore.Roost
				ScoreCountLogic:addScoreToTotal(mainLogic, scoreTotal)

				local ScoreAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItemScore_Get,
					IntCoord:create(r, c),
					nil,
					1)
				ScoreAction.addInt = scoreTotal
				mainLogic:addGameAction(ScoreAction)
			end
			
			local UpgradeAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Roost_Upgrade,
				IntCoord:create(r, c),
				nil,
				1)
			UpgradeAction.addInt = times
			mainLogic:addDestroyAction(UpgradeAction)
		end
	elseif item.digGroundLevel > 0 then
		if item.digBlockCanbeDelete then
			if not noCD then 
				item.digBlockCanbeDelete = false
			end
			GameExtandPlayLogic:decreaseDigGround(mainLogic, r, c,scoreScale, noScore)
		end
	elseif item.digJewelLevel > 0 then
		if item.digBlockCanbeDelete then
			if not noCD then 
				item.digBlockCanbeDelete = false
			end
			GameExtandPlayLogic:decreaseDigJewel(mainLogic, r, c, scoreScale, noScore)
		end
	elseif item.ItemType == GameItemType.kGoldZongZi and item.digGoldZongZiLevel > 0 and item.digBlockCanbeDelete == true then
		item.digBlockCanbeDelete = false
		GameExtandPlayLogic:decreaseDigGoldZongZi(mainLogic, r, c)
	elseif item.ItemType == GameItemType.kBottleBlocker and item.bottleLevel > 0 and item:isAvailable() then
		--if item.bottleState == BottleBlockerState.Waiting then
			GameExtandPlayLogic:decreaseBottleBlocker(mainLogic, r, c , scoreScale , noScore)
		--end
	elseif item.bigMonsterFrostingType > 0 then 
		if not noScore then
			local addScore = scoreScale * GamePlayConfigScore.MatchBySnow
			ScoreCountLogic:addScoreToTotal(mainLogic, addScore)

			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r, c),
				nil,
				1)
			ScoreAction.addInt = addScore
			mainLogic:addGameAction(ScoreAction)
		end

		if item.bigMonsterFrostingStrength > 0 then 
			item.bigMonsterFrostingStrength = item.bigMonsterFrostingStrength - 1
			local decAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Monster_frosting_dec,
				IntCoord:create(r, c),
				nil,
				GamePlayConfig_MonsterFrosting_Dec)
			mainLogic:addDestroyAction(decAction)
		end
	elseif item.ItemType == GameItemType.kBlackCuteBall then
		if item.blackCuteStrength > 0 then 

			item.blackCuteStrength = item.blackCuteStrength - 1
			if item.blackCuteStrength == 0 then 
				item:AddItemStatus(GameItemStatusType.kDestroy)
				SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
			end
			
			if not noScore then
				local addScore = GamePlayConfigScore.MatchAt_BlackCuteBall
				ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
				local ScoreAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItemScore_Get,
					IntCoord:create(r, c),
					nil,
					1)
				ScoreAction.addInt = addScore
				mainLogic:addGameAction(ScoreAction)
			end
			--add todo
			local duringTime = 1
			if item.blackCuteStrength == 0 then 
				duringTime = GamePlayConfig_BlackCuteBall_Destroy
			end
			
			local blackCuteAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Black_Cute_Ball_Dec,
				IntCoord:create(r, c),
				nil,
				duringTime)
			blackCuteAction.blackCuteStrength = item.blackCuteStrength
			mainLogic:addDestroyAction(blackCuteAction)
		end
	elseif item.ItemType == GameItemType.kMimosa or item.beEffectByMimosa == GameItemType.kMimosa then
		GameExtandPlayLogic:backMimosa( mainLogic, r, c )
	elseif item.ItemType == GameItemType.kKindMimosa or item.beEffectByMimosa == GameItemType.kKindMimosa then
		GameExtandPlayLogic:backMimosa( mainLogic, r, c )
	elseif item.ItemType == GameItemType.kBoss  then
		GameExtandPlayLogic:MaydayBossLoseBlood(mainLogic, r, c, false, actId)
	elseif item.honeyBottleLevel > 0 and item.honeyBottleLevel <= 3 then
		GameExtandPlayLogic:increaseHoneyBottle(mainLogic, r, c,1, scoreScale)
	elseif item.ItemType == GameItemType.kMagicLamp and item.lampLevel > 0 and not hasLockOrigin then
		local action = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_Magic_Lamp_Charging,
                        IntCoord:create(r, c),
                        nil,
                        GamePlayConfig_MaxAction_time
                    )
		action.count = 1
	    mainLogic:addDestroyAction(action)

	elseif item.ItemType == GameItemType.kWukong 
    		and item.wukongProgressCurr < item.wukongProgressTotal 
    		and ( item.wukongState == TileWukongState.kNormal or item.wukongState == TileWukongState.kOnHit )
    		and not hasLockOrigin and not mainLogic.isBonusTime then
		local action = GameBoardActionDataSet:createAs(
                    GameActionTargetType.kGameItemAction,
                    GameItemActionType.kItem_Wukong_Charging,
                    IntCoord:create(r, c),
                    nil,
                    GamePlayConfig_MaxAction_time
                )
		action.count = 3
	    mainLogic:addDestroyAction(action)

    elseif item.ItemType == GameItemType.kMagicStone and item:canMagicStoneBeActive() then
    	local stoneActiveAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_Magic_Stone_Active,
			IntCoord:create(r, c),
			nil,
			1)

		stoneActiveAction.magicStoneLevel = item.magicStoneLevel

		if item.magicStoneLevel < TileMagicStoneConst.kMaxLevel then
			item.magicStoneLevel = item.magicStoneLevel + 1
			if item.magicStoneLevel == TileMagicStoneConst.kMaxLevel then
				mainLogic:tryDoOrderList(r, c, GameItemOrderType.kOthers, GameItemOrderType_Others.kMagicStone, 1)
			end
		else
			item.magicStoneActiveTimes = item.magicStoneActiveTimes + 1
			item.magicStoneLocked = true
			stoneActiveAction.targetPos = GameExtandPlayLogic:calcMagicStoneEffectPositions(mainLogic, r, c)
		end
		mainLogic:addDestroyAction(stoneActiveAction)
	elseif item.ItemType == GameItemType.kCrystalStone and not hasLockOrigin then -- 水晶石没有被锁住
		if not item:isCrystalStoneActive() then -- 充满的水晶石被特效打到不会触发，被锤子砸时单独处理
			GameExtandPlayLogic:specialCoverInactiveCrystalStone(mainLogic, r, c, scoreScale)
		end
	end

	--毛球
	if item:hasFurball() then
		if item.furballType == GameItemFurballType.kGrey then
			item.furballLevel = 0
			item.furballType = GameItemFurballType.kNone

			local scoreAdd = GamePlayConfigScore.Furball * scoreScale

			ScoreCountLogic:addScoreToTotal(mainLogic, scoreAdd)

			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r, c),
				nil,
				1)
			ScoreAction.addInt = scoreAdd
			mainLogic:addGameAction(ScoreAction)

			local FurballAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Furball_Grey_Destroy,
				IntCoord:create(r, c),
				nil,
				GamePlayConfig_GameItemGreyFurballDeleteAction_CD)
			mainLogic:addDestroyAction(FurballAction)
			mainLogic:tryDoOrderList(r, c, GameItemOrderType.kSpecialTarget, GameItemOrderType_ST.kGreyCuteBall, 1)
		elseif item.furballType == GameItemFurballType.kBrown then
			if not item.isBrownFurballUnstable then
				item.isBrownFurballUnstable = true
				local FurballAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItem_Furball_Brown_Unstable,
					IntCoord:create(r, c),
					nil,
					1)
				mainLogic:addGameAction(FurballAction)	

				local scoreAdd = GamePlayConfigScore.Furball * scoreScale
				ScoreCountLogic:addScoreToTotal(mainLogic, scoreAdd)
				local ScoreAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItemScore_Get,
					IntCoord:create(r, c),
					nil,
					1)
				ScoreAction.addInt = scoreAdd
				mainLogic:addGameAction(ScoreAction)
				mainLogic:tryDoOrderList(r, c, GameItemOrderType.kSpecialTarget, GameItemOrderType_ST.kBrownCuteBall, 1)
			end
		end
	end

	if not passLotusDecrease and board.lotusLevel > 0 then
		GameExtandPlayLogic:decreaseLotus(mainLogic, r, c , 1 , false)
	end

end