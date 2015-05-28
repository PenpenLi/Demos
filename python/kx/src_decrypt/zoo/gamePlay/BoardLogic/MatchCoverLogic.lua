
------Match对地图的影响-----------
require "zoo.gamePlay.BoardLogic.ScoreCountLogic"

MatchCoverLogic = class{}


function MatchCoverLogic:resetEffectHalpMap(mainLogic)
	mainLogic.EffectHelpMap = nil;
	mainLogic.EffectHelpMap = {}
	for r = 1, #mainLogic.boardmap do
		mainLogic.EffectHelpMap[r] = {}
		for c = 1,#mainLogic.boardmap do
			mainLogic.EffectHelpMap[r][c] = 0
		end
	end
end

function MatchCoverLogic:MatchCoverAtPos(mainLogic, r, c, sId)
	if MatchCoverLogic:canBeEffectByMatchAt(mainLogic, r, c) then
		mainLogic.EffectHelpMap[r][c] = 1;
	end
	
	MatchCoverLogic:tryEffectByMatchAround(mainLogic, r-1, c);
	MatchCoverLogic:tryEffectByMatchAround(mainLogic, r, c-1);
	MatchCoverLogic:tryEffectByMatchAround(mainLogic, r, c+1);
	MatchCoverLogic:tryEffectByMatchAround(mainLogic, r+1, c);
end

----可以被此处的Match影响到---
function MatchCoverLogic:canBeEffectByMatchAt(mainLogic, r, c, sId)
	if r<=0 or r>#mainLogic.boardmap or c<=0 or c>#mainLogic.boardmap[r] then return false end;

	local item = mainLogic.gameItemMap[r][c];
	local board = mainLogic.boardmap[r][c];

	if (board.iceLevel > 0) then
		return true;
	end
	return false;
end

function MatchCoverLogic:tryEffectByMatchAround(mainLogic, r, c, sId)
	if MatchCoverLogic:canBeEffectByMatchAround(mainLogic, r, c)
		and mainLogic.EffectHelpMap[r][c] == 0
		then
		mainLogic.EffectHelpMap[r][c] = 2
	end;
end
----可以被周围的Match影响到----
function MatchCoverLogic:canBeEffectByMatchAround(mainLogic, r, c, sId)
	if r<=0 or r>#mainLogic.boardmap or c<=0 or c>#mainLogic.boardmap[r] then return false end

	local item = mainLogic.gameItemMap[r][c];
	local board = mainLogic.boardmap[r][c];

	return false
end

-----通过Match辅助图来标注影响图
function MatchCoverLogic:signEffectByMatchHelpMap(mainLogic)
	MatchCoverLogic:resetEffectHalpMap(mainLogic);

	mainLogic.comboHelpDataSet = {}
	mainLogic.comboHelpList = {}		----消除的id列表
	mainLogic.comboHelpNumCountList = {}
	mainLogic.comboHelpNumCountCrystalList = {}
	mainLogic.comboSumBombScore = {}
	mainLogic.comboHelpLightUpList = {}
	mainLogic.comboHelpNumCountBalloonList = {}
	mainLogic.comboHelpNumCountRabbitList = {}
	mainLogic.comboHelpNumCountSandList = {}
	local pcount = 0					----有几组消除
	local firstOneList = {}

	for r = 1, #mainLogic.swapHelpMap do 
		for c = 1, #mainLogic.swapHelpMap[r] do
			local spd = mainLogic.swapHelpMap[r][c]		----消除号id
			if (spd < 0) then spd = -spd end 				----消除号为负数的id，和正数的绝对值相等的id属于一个集合,0表示没有响应

			if spd > 0 then
				mainLogic.gameItemMap[r][c].hasGivenScore = true
				mainLogic.EffectHelpMap[r][c] = -1 			----计算
				--------辅助计算分数
				if (mainLogic.comboHelpDataSet[spd] == nil or mainLogic.comboHelpDataSet[spd] == 0)		----还没有被计入过，开始首次统计
					then
					-------连击计数增加
					pcount = pcount + 1
					mainLogic.comboHelpList[pcount] = spd;
					mainLogic.comboHelpDataSet[spd] = pcount;
					firstOneList[spd] = IntCoord:create(r,c);														----集合中的第一个物体，以他为基础显示获取的分数
				end
				----某次连击的小动物数量增加
				if mainLogic.gameItemMap[r][c]:canBeComboNum() then
					if (mainLogic.comboHelpNumCountList[spd] == nil ) then mainLogic.comboHelpNumCountList[spd] = 0 end;
					mainLogic.comboHelpNumCountList[spd] = mainLogic.comboHelpNumCountList[spd] + 1;
				end
				----某次连击的水晶球数量增加
				if mainLogic.gameItemMap[r][c]:canBeComboNumCrystal() then
					mainLogic.gameItemMap[r][c].oldItemType = nil
					if (mainLogic.comboHelpNumCountCrystalList[spd] == nil ) then mainLogic.comboHelpNumCountCrystalList[spd] = 0 end;
					mainLogic.comboHelpNumCountCrystalList[spd] = mainLogic.comboHelpNumCountCrystalList[spd] + 1;
				end
				if mainLogic.gameItemMap[r][c]:canBeComboNumBalloon() then 
					if (mainLogic.comboHelpNumCountBalloonList[spd] == nil ) then mainLogic.comboHelpNumCountBalloonList[spd] = 0 end;
					mainLogic.comboHelpNumCountBalloonList[spd] = mainLogic.comboHelpNumCountBalloonList[spd] + 1;
				end

				if mainLogic.gameItemMap[r][c]:canBeComboNumRabbit() then
					if (mainLogic.comboHelpNumCountRabbitList[spd] == nil ) then mainLogic.comboHelpNumCountRabbitList[spd] = 0 end;
					mainLogic.comboHelpNumCountRabbitList[spd] = mainLogic.comboHelpNumCountRabbitList[spd] + 1;
				end

				----统计爆炸的分数
				if mainLogic.comboSumBombScore[spd] == nil then mainLogic.comboSumBombScore[spd] = 0 end;
				if (mainLogic.swapHelpMap[r][c] > 0 ) then
					-----炸掉的部分，计算爆炸得分
					mainLogic.comboSumBombScore[spd] = mainLogic.comboSumBombScore[spd] + ScoreCountLogic:getScoreWithItemBomb(mainLogic.gameItemMap[r][c])
				end
				
				if mainLogic.comboHelpLightUpList[spd] == nil then mainLogic.comboHelpLightUpList[spd] = 0 end
				if MatchCoverLogic:doEffectToLightUp(mainLogic, r, c) then
					mainLogic.comboHelpLightUpList[spd] = mainLogic.comboHelpLightUpList[spd] + 1
				end

				if MatchCoverLogic:doEffectSandAtPos(mainLogic, r, c) then
					local sandCount = mainLogic.comboHelpNumCountSandList[spd] or 0
					mainLogic.comboHelpNumCountSandList[spd] = sandCount + 1
				end

				SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
			elseif spd == 0 then
				MatchCoverLogic:trySignAtByAround(mainLogic, r, c)
			end
		end
	end

	for k,v in pairs(mainLogic.comboHelpList) do
		local spd = v
		local productSpecialType = mainLogic.swapHelpList[spd]		----合成的新的小动物的特效类型
		local numCount = mainLogic.comboHelpNumCountList[spd] 		----消除的小动物的数量
		local numCountCrystal = mainLogic.comboHelpNumCountCrystalList[spd] 		----消除的小动物的数量
		local numCountBalloon = mainLogic.comboHelpNumCountBalloonList[spd]
		local numCountRabbit = mainLogic.comboHelpNumCountRabbitList[spd]
		local bombScore = mainLogic.comboSumBombScore[spd]			----消除的小动物爆炸统计分数
		local lightCount = mainLogic.comboHelpLightUpList[spd]
		local numSand = mainLogic.comboHelpNumCountSandList[spd]
		local pos = firstOneList[spd]								----消除的小动物首个位置

		if numCount == nil then numCount = 0; end;
		if bombScore == nil then bombScore = 0; end;
		if numCountCrystal == nil then numCountCrystal = 0; end;
		if numCountBalloon == nil then numCountBalloon = 0 end
		if numCountRabbit == nil then numCountRabbit = 0 end
		numSand = numSand or 0

		if pos then
			local comboScale = ScoreCountLogic:getComboWithCount(mainLogic, k)
			local scoreTotal = ScoreCountLogic:getScoreWithSpecialTypeCombine(productSpecialType) 								----特效加分
				+ comboScale * numCount * GamePlayConfig_Score_MatchDeleted_Base 			----连击次数*小动物个数*一个小动物10分
				+ comboScale * lightCount * GamePlayConfig_Score_MatchAt_Ice
				+ numCountCrystal * GamePlayConfig_Score_MatchDeleted_Crystal 													----水晶个数*一个水晶分数
				+ bombScore 																									----爆炸加分
				+ numCountBalloon * GamePlayConfig_Score_Balloon
				+ numCountRabbit * GamePlayConfig_Score_Rabbit
				+ numSand * GamePlayConfig_Score_Sand_Clean

			ScoreCountLogic:addScoreToTotal(mainLogic, scoreTotal)     ----一整次消除所得分数
			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				pos,				
				nil,				
				1)
			ScoreAction.addInt = scoreTotal;
			ScoreAction.addInt2 = 3;
			mainLogic:addGameAction(ScoreAction)
		end
	end
end

-----帮助标注---
function MatchCoverLogic:trySignAtByAround(mainLogic, r, c)
	local addset = {}
	local item = nil
	if r - 1 > 0 then 
		item = mainLogic.gameItemMap[r - 1][c]
		if not item:hasLock() and not mainLogic:hasChainInNeighbors(r, c, r-1, c) then
			addset[math.abs(mainLogic.swapHelpMap[r-1][c]) + 1] = true 
		end
	end
	if r + 1 <= #mainLogic.swapHelpMap then 
		item = mainLogic.gameItemMap[r + 1][c]
		if not item:hasLock() and not mainLogic:hasChainInNeighbors(r, c, r+1, c) then
			addset[math.abs(mainLogic.swapHelpMap[r+1][c]) + 1] = true 
		end
	end
	if c - 1 > 0 then 
		item = mainLogic.gameItemMap[r][c - 1]
		if not item:hasLock() and not mainLogic:hasChainInNeighbors(r, c, r, c-1) then
			addset[math.abs(mainLogic.swapHelpMap[r][c-1]) + 1] = true 
		end
	end
	if c + 1 <= #mainLogic.swapHelpMap[r] then 
		item = mainLogic.gameItemMap[r][c + 1]
		if not item:hasLock() and not mainLogic:hasChainInNeighbors(r, c, r, c+1) then
			addset[math.abs(mainLogic.swapHelpMap[r][c+1]) + 1] = true 
		end
	end

	local count = 0
	for k,v in pairs(addset) do
		if k > 1 and v == true then count = count + 1 end
	end

	----周围match了count次
	mainLogic.EffectHelpMap[r][c] = count
end

function MatchCoverLogic:doEffectToLightUp(mainLogic, r, c)
	if r<=0 or r>#mainLogic.boardmap or c<=0 or c>#mainLogic.boardmap[r] then return false end

	local item = mainLogic.gameItemMap[r][c]
	local board = mainLogic.boardmap[r][c]
	------2.冰层变化------
	if not item:hasLock() and board.iceLevel > 0 then
		----1-1.数据变化
		board.iceLevel = board.iceLevel - 1;

		----1-3.播放特效
		local IceAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemMatchAt_IceDec,
			IntCoord:create(r,c),				
			nil,				
			GamePlayConfig_MaxAction_time)
		mainLogic:addDestroyAction(IceAction)
		board.isNeedUpdate = true
		item.isNeedUpdate = true

		if mainLogic.PlayUIDelegate and mainLogic.gameMode:is(LightUpMode) then
			local pos_t = mainLogic:getGameItemPosInView(r,c);
			local ice_left_count = mainLogic.gameMode:checkAllLightCount()
			mainLogic.PlayUIDelegate:setTargetNumber(0, 0, ice_left_count, pos_t)
		end
		return true
	end

	return false
end

function MatchCoverLogic:doEffectSandAtPos(mainLogic, r, c)
	if not mainLogic:isPosValid(r, c) then return false end
	local board = mainLogic.boardmap[r][c]
	local item = mainLogic.gameItemMap[r][c]

	if not item:hasLock() and board.sandLevel > 0 then
		board.sandLevel = board.sandLevel - 1
		local sandCleanAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_Sand_Clean,
			IntCoord:create(r,c),				
			nil,				
			GamePlayConfig_MaxAction_time)
		mainLogic:addDestroyAction(sandCleanAction)
		mainLogic:tryDoOrderList(r, c, GameItemOrderType.kOthers, GameItemOrderType_Others.kSand, 1)
		return true
	end
	return false
end

function MatchCoverLogic:doEffectChainsAtPosWithDirs(mainLogic, r, c, breakDirs)
	if not mainLogic:isPosValid(r, c) or #breakDirs < 1 then return false end

	local board = mainLogic.boardmap[r][c]
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
	if not notEmpty then return false end

	mainLogic.boardView.baseMap[r][c]:playChainBreakAnim(breakLevels, nil)

	if hasChainBreaked then
		mainLogic:setChainBreaked()
		mainLogic.gameMode:afterChainBreaked(r, c)
	end

	board.isNeedUpdate = true
	return true
end

-- 消除被match的格子及其四周响应方向上的冰柱，同一个matchData的不可相互消除
function MatchCoverLogic:doEffectChainsAtPos(mainLogic, r, c)
	if not mainLogic:isPosValid(r, c) then return false end
	local board = mainLogic.boardmap[r][c]
	local item = mainLogic.gameItemMap[r][c]

	local ret = false
	local breakDirs = {ChainDirConfig.kUp, ChainDirConfig.kDown, ChainDirConfig.kLeft, ChainDirConfig.kRight}
	if self:doEffectChainsAtPosWithDirs(mainLogic, r, c, breakDirs) then
		ret = true
	end

	if r - 1 > 0 and not mainLogic:isTheSameMatchData(r, c, r-1, c) then 
		if self:doEffectChainsAtPosWithDirs(mainLogic, r-1, c, {ChainDirConfig.kDown}) then
			ret = true
		end
	end
	if r + 1 <= #mainLogic.swapHelpMap and not mainLogic:isTheSameMatchData(r, c, r+1, c) then 
		if self:doEffectChainsAtPosWithDirs(mainLogic, r+1, c, {ChainDirConfig.kUp}) then
			ret = true
		end
	end
	if c - 1 > 0 and not mainLogic:isTheSameMatchData(r, c, r, c-1) then 
		if self:doEffectChainsAtPosWithDirs(mainLogic, r, c-1, {ChainDirConfig.kRight}) then
			ret = true
		end
	end
	if c + 1 <= #mainLogic.swapHelpMap[r] and not mainLogic:isTheSameMatchData(r, c, r, c+1) then 
		if self:doEffectChainsAtPosWithDirs(mainLogic, r, c+1, {ChainDirConfig.kLeft}) then
			ret = true
		end
	end
	return ret
end

--------响应match的变化-------
function MatchCoverLogic:doEffectByMatchHelpMap(mainLogic)
	----1.检测match对棋盘的变化
	for r=1,#mainLogic.EffectHelpMap do
		for c=1,#mainLogic.EffectHelpMap[r] do
			local spd = mainLogic.swapHelpMap[r][c];		----消除号id
			if (spd < 0) then spd = -spd; end
			local comboCount = mainLogic.comboHelpDataSet[spd];

			if mainLogic.EffectHelpMap[r][c] == -1 then 		----当前位置发生match
				MatchCoverLogic:doEffectAtByMatchAt(mainLogic, r, c, comboCount)
			elseif mainLogic.EffectHelpMap[r][c] > 0 then		----当前位置周围有n次match
				MatchCoverLogic:doEffectAtByMatchAround(mainLogic, r, c, comboCount)
			end
		end
	end

	if #mainLogic.comboHelpList > 0 then
		ScoreCountLogic:addCombo(mainLogic, #mainLogic.comboHelpList);
	end
end

----------------------此处Match消除，引起相应变化---------
function MatchCoverLogic:doEffectAtByMatchAt(mainLogic, r, c, comboCount)
	if r<=0 or r>#mainLogic.boardmap or c<=0 or c>#mainLogic.boardmap[r] then return false end;

	local item = mainLogic.gameItemMap[r][c];
	local board = mainLogic.boardmap[r][c];

	------1.牢笼--------
	if item.cageLevel > 0 then
		----1-1.数据变化
		item.cageLevel = item.cageLevel - 1
		mainLogic:checkItemBlock(r,c)
		
		----1-2.分数统计
		ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_MatchAt_Lock);
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r,c),				
			nil,
			1)
		ScoreAction.addInt = GamePlayConfig_Score_MatchAt_Lock;
		mainLogic:addGameAction(ScoreAction);

		----1-3.播放特效
		local LockAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemMatchAt_LockDec,
			IntCoord:create(r,c),				
			nil,				
			1)
		mainLogic:addDestroyAction(LockAction)
		return
	elseif item.honeyLevel > 0 then
		GameExtandPlayLogic:honeyDestroy( mainLogic, r, c, 1 )
		return
	end

	if item.ItemType == GameItemType.kMagicLamp and item.lampLevel > 0 and item:isAvailable() then
		local action = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_Magic_Lamp_Charging,
                        IntCoord:create(r, c),
                        nil,
                        GamePlayConfig_MaxAction_time
                    )
		action.count = 1
	    mainLogic:addDestroyAction(action)
	elseif item.ItemType == GameItemType.kQuestionMark and item:isQuestionMarkcanBeDestroy() then
		GameExtandPlayLogic:questionMarkBomb( mainLogic, r, c )
	end

	self:doEffectChainsAtPos(mainLogic, r, c)
end


function MatchCoverLogic:doEffectAtByMatchAround(mainLogic, r, c, comboCount)
	if r<=0 or r>#mainLogic.boardmap or c<=0 or c>#mainLogic.boardmap[r] then return false end;

	local item = mainLogic.gameItemMap[r][c];
	local board = mainLogic.boardmap[r][c];
	local count = mainLogic.EffectHelpMap[r][c];
	local t_count = count
	
	if not item:isAvailable() then return  end

	--蜂蜜------------------
	if item.honeyLevel > 0 then
		GameExtandPlayLogic:honeyDestroy( mainLogic, r, c, 1 )
	end

	----1.检测雪花消除----
	if (item.snowLevel > 0 and t_count > 0) then
		----1-1.数据变化
		local f_count = 1;
		if item.snowLevel >= t_count then
			item.snowLevel = item.snowLevel - t_count;
			f_count = t_count;
			t_count = 0;
		else
			t_count = t_count - item.snowLevel;
			f_count = item.snowLevel;
			item.snowLevel = 0;
		end
		if item.snowLevel == 0 then
			SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
			item:AddItemStatus(GameItemStatusType.kDestroy)
			mainLogic:tryDoOrderList(r,c,GameItemOrderType.kSpecialTarget, GameItemOrderType_ST.kSnowFlower, 1) -------记录消除
		end
		
		----1-2.分数统计
		ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_MatchBy_Snow * f_count);
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r,c),				
			nil,				
			1)
		ScoreAction.addInt = GamePlayConfig_Score_MatchBy_Snow * f_count;
		mainLogic:addGameAction(ScoreAction);

		----1-3.播放特效
		local SnowAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemMatchAt_SnowDec,
			IntCoord:create(r,c),				
			nil,				
			GamePlayConfig_GameItemSnowDeleteAction_CD)
		SnowAction.addInt = item.snowLevel + 1;
		mainLogic:addDestroyAction(SnowAction)
	elseif item.venomLevel > 0 then
		item.venomLevel = item.venomLevel - 1
		item:AddItemStatus(GameItemStatusType.kDestroy)
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
		ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_MatchBy_Snow)
		mainLogic:tryDoOrderList(r, c, GameItemOrderType.kSpecialTarget, GameItemOrderType_ST.kVenom, 1)
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r, c),
			nil,
			1)
		ScoreAction.addInt = GamePlayConfig_Score_MatchBy_Snow
		mainLogic:addGameAction(ScoreAction)

		local VenomAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemMatchAt_VenowDec,
			IntCoord:create(r, c),
			nil,
			GamePlayConfig_GameItemBlockerDeleteAction_CD)
		mainLogic:addDestroyAction(VenomAction)
	elseif item.furballLevel > 0 
		and (item.ItemStatus == GameItemStatusType.kNone 
		or item.ItemStatus == GameItemStatusType.kItemHalfStable)
		then
		if item.furballType == GameItemFurballType.kGrey then
			item.furballLevel = 0
			item.furballType = GameItemFurballType.kNone
			ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_Furball)

			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r, c),
				nil,
				1)
			ScoreAction.addInt = GamePlayConfig_Score_Furball
			mainLogic:addGameAction(ScoreAction)

			local FurballAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Furball_Grey_Destroy,
				IntCoord:create(r, c),
				nil,
				GamePlayConfig_GameItemGreyFurballDeleteAction_CD)
			mainLogic:addDestroyAction(FurballAction)
			mainLogic:tryDoOrderList(r, c, GameItemOrderType.kSpecialTarget, GameItemOrderType_ST.kGreyCuteBall, 1)
		elseif item.furballType == GameItemFurballType.kBrown and not item.isBrownFurballUnstable then
			local FurballAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Furball_Brown_Shield,
				IntCoord:create(r, c),
				nil,
				1)
			mainLogic:addGameAction(FurballAction)
		end
	elseif item.ItemType == GameItemType.kBlackCuteBall and (item.ItemStatus == GameItemStatusType.kNone 
		or item.ItemStatus == GameItemStatusType.kItemHalfStable) then
	--add score action
		if item.blackCuteStrength > 0 then 
			item.blackCuteStrength = item.blackCuteStrength - t_count
			if item.blackCuteStrength <= 0 then 
				item.blackCuteStrength = 0
				item:AddItemStatus(GameItemStatusType.kDestroy)
				SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
			end
			
			ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_MatchAt_BlackCuteBall)
			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r, c),
				nil,
				1)
			ScoreAction.addInt = GamePlayConfig_Score_MatchAt_BlackCuteBall
			mainLogic:addGameAction(ScoreAction)
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
	elseif item.ItemType == GameItemType.kCoin 
		and (item.ItemStatus == GameItemStatusType.kNone 
		or item.ItemStatus == GameItemStatusType.kItemHalfStable)
		then
		item:AddItemStatus(GameItemStatusType.kDestroy)
		ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_MatchBy_Snow)

		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r, c),
			nil,
			1)
		ScoreAction.addInt = GamePlayConfig_Score_MatchBy_Snow
		mainLogic:addGameAction(ScoreAction)

		local CoinAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemDeletedByMatch,
			IntCoord:create(r, c),
			nil,
			GamePlayConfig_GameItemAnimalDeleteAction_CD)
		mainLogic:addDestroyAction(CoinAction)		
	elseif item.ItemType == GameItemType.kRoost 
		and (item.ItemStatus == GameItemStatusType.kNone or item.ItemStatus == GameItemStatusType.kItemHalfStable)
		then
		local originRoostLevel = item.roostLevel

		for i = 1, t_count do
			item:roostUpgrade()
		end

		local times = item.roostLevel - originRoostLevel
		if times > 0 then
			local scoreTotal = times * GamePlayConfig_Score_Roost
			ScoreCountLogic:addScoreToTotal(mainLogic, scoreTotal)

			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r, c),
				nil,
				1)
			ScoreAction.addInt = scoreTotal
			mainLogic:addGameAction(ScoreAction)

			local UpgradeAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Roost_Upgrade,
				IntCoord:create(r, c),
				nil,
				1)
			UpgradeAction.addInt = times
			mainLogic:addDestroyAction(UpgradeAction)
		end
	elseif item.digGroundLevel > 0 and item.digBlockCanbeDelete == true  then
		item.digBlockCanbeDelete = false
		GameExtandPlayLogic:decreaseDigGround(mainLogic, r, c)
	elseif item.digJewelLevel > 0 and item.digBlockCanbeDelete == true  then
		item.digBlockCanbeDelete = false
		GameExtandPlayLogic:decreaseDigJewel(mainLogic, r, c)
	elseif item.bigMonsterFrostingType > 0 then 
		--add score
		local addScore = GamePlayConfig_Score_MatchBy_Snow
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r, c),
			nil,
			1)
		ScoreAction.addInt = addScore
		mainLogic:addGameAction(ScoreAction)
		--dec ice
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
	elseif item.ItemType == GameItemType.kBoss then
		GameExtandPlayLogic:MaydayBossLoseBlood(mainLogic, r, c, true)
	elseif  item.honeyBottleLevel > 0 and item.honeyBottleLevel <= 3 then
		GameExtandPlayLogic:increaseHoneyBottle(mainLogic, r, c, t_count, scoreScale)
	elseif item.ItemType == GameItemType.kMagicStone and item:canMagicStoneBeActive() then
		local stoneActiveAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_Magic_Stone_Active,
			IntCoord:create(r, c),
			nil,
			1)

		stoneActiveAction.magicStoneLevel = item.magicStoneLevel

		if item.magicStoneLevel < TileMagicStoneConst.kMaxLevel then -- levelUp
			item.magicStoneLevel = item.magicStoneLevel + 1
			if item.magicStoneLevel == TileMagicStoneConst.kMaxLevel then -- 收集目标
				mainLogic:tryDoOrderList(r, c, GameItemOrderType.kOthers, GameItemOrderType_Others.kMagicStone, 1)
			end
		else
			item.magicStoneActiveTimes = item.magicStoneActiveTimes + 1
			item.magicStoneLocked = true
			stoneActiveAction.targetPos = GameExtandPlayLogic:calcMagicStoneEffectPositions(mainLogic, r, c)
		end
		mainLogic:addDestroyAction(stoneActiveAction)
	end
end