--------------
------特效爆炸逻辑
--------------
BombItemLogic = class{}

function BombItemLogic:BombByMatch(mainLogic)
	local function getMatchPosList(matchFlag)
		local result = {}
		for r = 1, #mainLogic.swapHelpMap do
			for c = 1, #mainLogic.swapHelpMap[r] do
				if mainLogic.swapHelpMap[r][c] == matchFlag then
					table.insert(result, { r = r, c = c })
				end
			end
		end
		return result
	end

	if mainLogic.theGamePlayType == GamePlayType.kLightUp 
		or mainLogic.theGamePlayType == GamePlayType.kSeaOrder 
		then 
		for r = 1, #mainLogic.swapHelpMap do
			for c = 1, #mainLogic.swapHelpMap[r] do
				local matchFlag = mainLogic.swapHelpMap[r][c]
				if matchFlag > 0 then 		----参与了本次消除
					local item = mainLogic.gameItemMap[r][c]
					local specialType = mainLogic.gameItemMap[r][c].ItemSpecialType 	--特殊类型
					
					if specialType >= AnimalTypeConfig.kLine and specialType <= AnimalTypeConfig.kColor then
						if not item.isItemLock then
							local matchPosList = getMatchPosList(matchFlag)
							item.lightUpBombMatchPosList = matchPosList
						end
					end
				end 
			end
		end
	end
end

----返回0表示未能发生爆炸
----否则返回对应的爆炸特效种类
----scoreScale表示引爆的小动物分数的计算倍数
----isBombScore表示爆炸物品是否计算分数----0不计算[假爆炸]1计算基础分数[真爆炸]2当做再次爆炸[真爆炸]
function BombItemLogic:BombItem(mainLogic, r, c, isBombScore, scoreScale)
	----引发爆破动作，running过程中，向前推进，或者一开始就处理完毕，然后依次启动掉落或者是连锁爆炸
	if isBombScore == nil then isBombScore = 0 end;
	if scoreScale == nil then scoreScale = 0 end;
	if (scoreScale <0) then scoreScale = 0 end;

	local specialType = mainLogic.gameItemMap[r][c].ItemSpecialType 

	return BombItemLogic:BombItemToChange(mainLogic, r, c, specialType, isBombScore, scoreScale)
end


----返回0表示未能发生爆炸
----否则返回对应的爆炸特效种类
----isFromeSpecial 是否由于特效交换导致的
function BombItemLogic:BombItemToChange(mainLogic, r, c, newSpecialType, isBombScore, scoreScale, isFromSpecialMatch)
	if r <= 0 or r > #mainLogic.boardmap or c <=0 or c> #mainLogic.boardmap[r] then return 0 end
	local item = mainLogic.gameItemMap[r][c]
	if item.isItemLock then return 0 end
	if scoreScale < 0 then scoreScale = 0 end

	if newSpecialType == AnimalTypeConfig.kLine then 			
		BombItemLogic:_BombItemLine(mainLogic, r, c, isBombScore, scoreScale, isFromSpecialMatch)
		return newSpecialType;
	elseif newSpecialType == AnimalTypeConfig.kColumn then 	
		BombItemLogic:_BombItemColumn(mainLogic, r, c, isBombScore, scoreScale, isFromSpecialMatch)
		return newSpecialType
	elseif newSpecialType == AnimalTypeConfig.kWrap then
		BombItemLogic:_BombItemWrap(mainLogic, r, c, isBombScore, scoreScale, isFromSpecialMatch)
		return newSpecialType
	elseif newSpecialType == AnimalTypeConfig.kColor then
		BombItemLogic:_BombItemColor(mainLogic,r,c, isBombScore, scoreScale, isFromSpecialMatch)
		return newSpecialType
	end

	return 0
end


function BombItemLogic:_BombItemLine(mainLogic, r, c, isBombScore, scoreScale, isFromSpecialMatch)	----直线爆炸特效---排
	if (scoreScale == 0) then scoreScale = 1.5 end
	-----1.计算分数
	if isBombScore == 1 then
		local item = mainLogic.gameItemMap[r][c]
		item.bombRes = nil
		item.isItemLock = true

		if not (mainLogic.gameItemMap[r][c].hasGivenScore or isFromSpecialMatch) then
			local scoreAdd = GamePlayConfig_Score_SpecialBomb_kLine;
			ScoreCountLogic:addScoreToTotal(mainLogic, scoreAdd);
		
			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r,c),				
				nil,				
				1)
			ScoreAction.addInt = scoreAdd;
			mainLogic:addGameAction(ScoreAction);
			mainLogic.gameItemMap[r][c].hasGivenScore = true
		end
		mainLogic:tryDoOrderList(r,c,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kLine)
	end

	
	local lineAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemSpecial_Line,
		IntCoord:create(r,c),
		nil,
		GamePlayConfig_SpecialBomb_Line_Anim_CD
	)
	lineAction.addInt2 = scoreScale;
	mainLogic:addDestructionPlanAction(lineAction)

	if not isFromSpecialMatch then 
		GamePlayMusicPlayer:playEffect(GameMusicType.kEliminateLine)
	end
end

function BombItemLogic:_BombItemColumn(mainLogic, r, c, isBombScore, scoreScale, isFromSpecialMatch)	----直线爆炸特效---列
	if (scoreScale == 0) then scoreScale = 1.5 end;
	if (scoreScale <0) then scoreScale = 0 end;

	if isBombScore == 1 then
		local item = mainLogic.gameItemMap[r][c]
		item.bombRes = nil
		item.isItemLock = true

		if not (mainLogic.gameItemMap[r][c].hasGivenScore or isFromSpecialMatch) then
			local scoreAdd = GamePlayConfig_Score_SpecialBomb_kCloumn;
			ScoreCountLogic:addScoreToTotal(mainLogic, scoreAdd);
			
			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r,c),				
				nil,				
				1)
			ScoreAction.addInt = scoreAdd;
			mainLogic:addGameAction(ScoreAction);
			mainLogic.gameItemMap[r][c].hasGivenScore = true
		end
		mainLogic:tryDoOrderList(r,c,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kLine)
	end

	

	----2.确认直线特效--->开始爆炸
	local columnAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemSpecial_Column,
		IntCoord:create(r,c),
		nil,
		GamePlayConfig_SpecialBomb_Column_Anim_CD
		)
	columnAction.addInt2 = scoreScale;
	mainLogic:addDestructionPlanAction(columnAction)

	if not isFromSpecialMatch then
		GamePlayMusicPlayer:playEffect(GameMusicType.kEliminateLine);
	end
end

function BombItemLogic:_BombItemWrap(mainLogic, r, c, isBombScore, scoreScale, isFromSpecialMatch)
	if (scoreScale == 0) then scoreScale = 2.0 end;
	if (scoreScale <0) then scoreScale = 0 end;

	if isBombScore == 1 then
		local item = mainLogic.gameItemMap[r][c]
		item.bombRes = nil
		item.isItemLock = true

		if not mainLogic.gameItemMap[r][c].hasGivenScore then 
			local scoreAdd = GamePlayConfig_Score_SpecialBomb_kWrap;
			ScoreCountLogic:addScoreToTotal(mainLogic, scoreAdd);
			local ScoreAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemScore_Get,
				IntCoord:create(r,c),				
				nil,				
				1)
			ScoreAction.addInt = scoreAdd;
			mainLogic:addGameAction(ScoreAction);
			mainLogic.gameItemMap[r][c].hasGivenScore = true
		end
		mainLogic:tryDoOrderList(r,c,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kWrap)
	end

	local warpAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemSpecial_Wrap,
		IntCoord:create(r,c),
		nil,
		GamePlayConfig_SpecialBomb_Wrap
		)
	warpAction.addInt2 = scoreScale;
	mainLogic:addDestructionPlanAction(warpAction)

	if not isFromSpecialMatch then
		GamePlayMusicPlayer:playEffect(GameMusicType.kEliminateWrap);
	end
end

--------魔力鸟被炸到了------------
function BombItemLogic:_BombItemColor(mainLogic, r, c, isBombScore, scoreScale, isFromSpecialMatch)
	if (scoreScale == 0) then scoreScale = 2.5 end
	if (scoreScale <0) then scoreScale = 0 end

	local item = mainLogic.gameItemMap[r][c]
	item.bombRes = nil
	item.isItemLock = true

	local ColorAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemSpecial_Color ,
		IntCoord:create(r,c),
		nil,
		GamePlayConfig_SpecialBomb_BirdAnimal_Time1
		)
	ColorAction.addInt = 0
	ColorAction.addInt2 = scoreScale
	mainLogic:addDestructionPlanAction(ColorAction)
	mainLogic:tryDoOrderList(r,c,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kColor)

	if not isFromSpecialMatch then
		GamePlayMusicPlayer:playEffect(GameMusicType.kEliminateColor)
	end
end


----尝试被某一次特效爆炸覆盖
----返回0，超出地图范围----返回2，遇到银币，需要中断----返回1：正常消除东西
----coverFalling是否进行掉落中的东西的爆炸计算
----scoreScale分数倍率
----bombNoReach炸掉没抵达的东西
function BombItemLogic:tryCoverByBomb(mainLogic, r, c, coverFalling, scoreScale, bombNoReach, noScore)
	if r <= 0 or r > #mainLogic.boardmap or c <=0 or c> #mainLogic.boardmap[r] then return 0 end
	if mainLogic.boardmap[r][c].isUsed == false then return 0 end
	
	if bombNoReach == nil then bombNoReach = false end;
	local item = mainLogic.gameItemMap[r][c]

	if item:canBeEliminateBySpecial() then
		if item.ItemStatus == GameItemStatusType.kIsMatch
			or item.ItemStatus == GameItemStatusType.kIsSpecialCover
			then
		elseif item.ItemStatus == GameItemStatusType.kNone
			or item.ItemStatus == GameItemStatusType.kWaitBomb then
			-------普通的,可以被消除-----
			BombItemLogic:_removeGameItemBySpecialBomb(mainLogic, r, c, scoreScale, noScore)
		elseif item.ItemStatus == GameItemStatusType.kIsFalling
			or item.ItemStatus == GameItemStatusType.kJustStop
			or item.ItemStatus == GameItemStatusType.kItemHalfStable
			then 				----物体正在掉落
			if coverFalling then
				-----爆炸掉掉落中的东西-----
				if (item.dataReach or bombNoReach) then 							----数据已经抵达
					BombItemLogic:_removeGameItemBySpecialBomb(mainLogic, r, c, scoreScale, noScore)
				elseif r + 1 <= #mainLogic.gameItemMap then  			----数据未抵达，	但是可以检测下面那个物体是否还处于上方这个物体的爆炸范围内
					if BombItemLogic:isItemTypeCanBeEliminateByBird(mainLogic, r + 1, c) then 			----如果下面那个是可以爆炸覆盖的类型
						local item2 = mainLogic.gameItemMap[r + 1][c];
						if item2.ItemStatus == GameItemStatusType.kIsFalling 						----正在掉落
							and item2.dataReach == false  											----数据未达
							and item2.comePos.x == r 												----位置正确
							and item2.comePos.y == c 
							then 
							BombItemLogic:_removeGameItemBySpecialBomb(mainLogic, r + 1, c, scoreScale, noScore)
						end
					end
				end
			end
		end

		if item.ItemType == GameItemType.kCoin then
			return 2
		else
			SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
			return 1
		end
	elseif item.ItemType == GameItemType.kQuestionMark and item:isQuestionMarkcanBeDestroy() then
		GameExtandPlayLogic:questionMarkBomb( mainLogic, r, c )
	elseif item.isEmpty then 
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
	end

	return 0
end

function BombItemLogic:_removeGameItemBySpecialBomb(mainLogic, r, c, scoreScale, noScore)
	local item = mainLogic.gameItemMap[r][c]
	--特效的分数由特效爆炸逻辑计算
	if not item.hasGivenScore and item.ItemSpecialType == 0 then
		if not noScore then
			local scoreAdd = 0
			local scoreBase = ScoreCountLogic:getItemDestroyBaseScore(mainLogic.gameItemMap[r][c].ItemType)
			scoreAdd = scoreBase * scoreScale
			if scoreAdd > 0 then
				ScoreCountLogic:addScoreToTotal(mainLogic, scoreAdd);
				local ScoreAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItemScore_Get,
					IntCoord:create(r,c),	
					nil,	
					1)
				ScoreAction.addInt = scoreAdd;
				mainLogic:addGameAction(ScoreAction);
			end
		end
		item.hasGivenScore = true
	end
	item:AddItemStatus(GameItemStatusType.kIsSpecialCover)
end

----如果可以被鸟特效直接消除
function BombItemLogic:isItemTypeCanBeEliminateByBird(mainLogic, r, c)
	local item = mainLogic.gameItemMap[r][c];
	return item:canBeEliminateByBirdAnimal()
end

----被Bird的特效覆盖到----
function BombItemLogic:tryCoverByBird(mainLogic, r, c, r2, c2, scoreScale)
	----1.判断是否可以使用----
	if r <= 0 or r > #mainLogic.boardmap or c <=0 or c> #mainLogic.boardmap[r] then return 0 end
	if mainLogic.boardmap[r][c].isUsed == false then return 0 end
	----2.分类处理
	local item = mainLogic.gameItemMap[r][c]
	if BombItemLogic:isItemTypeCanBeEliminateByBird(mainLogic,r,c) then
		----第一类别
		----状态判断
		if item.ItemStatus == GameItemStatusType.kIsMatch
			or item.ItemStatus == GameItemStatusType.kIsSpecialCover
			then
			-------已经被覆盖过的，只扣除层数，显示相应动画，不显示动物爆炸的特效 -- to do 
		elseif item.ItemStatus == GameItemStatusType.kNone 
			or item.ItemStatus == GameItemStatusType.kWaitBomb
			or item.ItemStatus == GameItemStatusType.kJustStop
			or item.ItemStatus == GameItemStatusType.kItemHalfStable
			then
			-------普通的,可以被消除-------------进行消除-----
			local specialType = item.ItemSpecialType
			if specialType == AnimalTypeConfig.kLine 
				or specialType == AnimalTypeConfig.kColumn
				or specialType == AnimalTypeConfig.kWrap
				then
				item:AddItemStatus(GameItemStatusType.kIsSpecialCover)
			else
				----未发生爆炸---->>引起特效消除-----旋转进入鸟的黑洞
				----1.获得分数
				local scoreAdd = 0
				local scoreBase = 0
				if item.ItemType == GameItemType.kAnimal then
					scoreBase = 10
				elseif item.ItemType == GameItemType.kCrystal then
					scoreBase = 100
				end
				scoreAdd = scoreBase * scoreScale 

				ScoreCountLogic:addScoreToTotal(mainLogic, scoreAdd);
				local ScoreAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItemScore_Get,
					IntCoord:create(r,c),
					nil,
					1)
				ScoreAction.addInt = scoreAdd;
				mainLogic:addGameAction(ScoreAction);
				if item.ItemType == GameItemType.kAnimal then
					----2.播放动画
					local CoverAction =	GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemSpecial_Color_ItemDeleted,
						IntCoord:create(r,c),				----炸掉的东西
						IntCoord:create(r2,c2),				----飞向的位置
						GamePlayConfig_SpecialBomb_BirdAnimal_Time2) 			----炸掉的时间
					CoverAction.addInfo = "kAnimal"
					mainLogic:addDestroyAction(CoverAction)
					item:AddItemStatus(GameItemStatusType.kDestroy) 		----修改状态
				else
					item:AddItemStatus(GameItemStatusType.kIsSpecialCover) 		----修改状态
				end
				SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
				mainLogic:tryDoOrderList(r,c, GameItemOrderType.kAnimal, item.ItemColorType)
			end

		elseif item.ItemStatus == GameItemStatusType.kIsFalling then  		----物体正在掉落
			local specialType = item.ItemSpecialType
			if specialType == AnimalTypeConfig.kLine 
				or specialType == AnimalTypeConfig.kColumn
				or specialType == AnimalTypeConfig.kWrap
				then
				item:AddItemStatus(GameItemStatusType.kIsSpecialCover)
			else
				----未发生爆炸---->>引起特效消除-----旋转进入鸟的黑洞
				----1.获得分数
				local scoreBase = 0
				if item.ItemType == GameItemType.kAnimal then
					scoreBase = 10
				elseif item.ItemType == GameItemType.kCrystal then
					scoreBase = 100
				end
				local scoreAdd = 10 * scoreScale;

				ScoreCountLogic:addScoreToTotal(mainLogic, scoreAdd);
				local ScoreAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItemScore_Get,
					IntCoord:create(r,c),
					nil,
					1)
				ScoreAction.addInt = scoreAdd;
				mainLogic:addGameAction(ScoreAction);

				if item.ItemType == GameItemType.kAnimal then
				----2.播放动画
					local CoverAction =	GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemSpecial_Color_ItemDeleted,
						IntCoord:create(r,c),				----炸掉的东西
						IntCoord:create(r2,c2),				----飞向的位置
						GamePlayConfig_SpecialBomb_BirdAnimal_Time2) 			----炸掉的时间
					CoverAction.addInfo = "kAnimal"
					mainLogic:addDestroyAction(CoverAction)
					item:AddItemStatus(GameItemStatusType.kDestroy) 		----修改状态
				else
					item:AddItemStatus(GameItemStatusType.kIsSpecialCover)
				end
				item.itemSpeed = 0;
				item.isEmpty = false;
				item.dataReach = true;
				item.gotoPos = nil;
				item.comePos = nil;
				mainLogic:tryDoOrderList(r, c, GameItemOrderType.kAnimal, item.ItemColorType)
			end
		end
	elseif item.ItemType == GameItemType.kQuestionMark and item:isQuestionMarkcanBeDestroy() then
		GameExtandPlayLogic:questionMarkBomb( mainLogic, r, c )
	else
		----其他类别
	end
end

--------鸟和特效交换后，飞向各个地方新特效-----
function BombItemLogic:setSignOfBombResWithBirdFlying(mainLogic, r1, c1, theColor, newType)
	local bombRes = IntCoord:create(r1,c1)

	local PosList = mainLogic:getPosListOfColor(theColor)
	local count = #PosList

	for i,v in ipairs(PosList) do
		local r = v.x;
		local c = v.y;
		local item = mainLogic.gameItemMap[r][c]

		if item:isAvailable() and (item.ItemColorType == theColor 
			and item.ItemSpecialType ~= AnimalTypeConfig.kColor
			and BombItemLogic:isItemTypeCanBeEliminateByBird(mainLogic, r, c) 
				or item:hasLock() 
				or item:hasFurball() )
			then

			if item:hasFurball() then
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, v.x, v.y, 3)
			end

			local length = math.sqrt(math.pow(r1 - r, 2) + math.pow(c1 - c, 2))

			if (newType == AnimalTypeConfig.kLine or newType == AnimalTypeConfig.kColumn) then
				if (item.ItemSpecialType == AnimalTypeConfig.kLine or item.ItemSpecialType == AnimalTypeConfig.kColumn) then
					----如果已经是直线特效则没有飞行效果--
					item.bombRes = bombRes 											----记录来源
				else
					----开始变化----
					local FlyingAction = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemSpecial_ColorLine_flying,
						IntCoord:create(r,c),				----物体位置
						IntCoord:create(r1,c1),				----鸟的位置
						10 + math.ceil(15 * length / 11))				----总时间必须大于0.1
					FlyingAction.addInt = i										----做个延迟
					mainLogic:addDestructionPlanAction(FlyingAction)
					item.bombRes = bombRes 											----记录来源
				end
			elseif (newType == AnimalTypeConfig.kWrap) then
				if item.ItemSpecialType == AnimalTypeConfig.kWrap then
					item.bombRes = bombRes
				else
					----开始变化----
					local FlyingAction = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemSpecial_ColorWrap_flying,
						IntCoord:create(r,c),				----物体位置
						IntCoord:create(r1,c1),				----鸟的位置
						10 + math.ceil(15 * length / 11))				----总时间必须大于0.1
					FlyingAction.addInt = i										----做个延迟
					mainLogic:addDestructionPlanAction(FlyingAction)
					item.bombRes = bombRes 											----记录来源
				end
			end

			if item:hasFurball() and item.furballType == GameItemFurballType.kBrown then
				item.bombRes = nil
			else
				-- item:AddItemStatus(GameItemStatusType.kWaitBomb)
			end
		elseif item.ItemType == GameItemType.kMagicLamp and item.lampLevel > 0 and item:isAvailable() then
			local action = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_Magic_Lamp_Charging,
                        IntCoord:create(r, c),
                        nil,
                        GamePlayConfig_MaxAction_time
                    )
			action.count = 1
		    mainLogic:addDestroyAction(action)
		end
	end
end


--------挨个引爆特效--------运行一次引爆一个----
function BombItemLogic:tryBombWithBombRes(mainLogic, r1, c1, isBombScore, scoreScale)
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c];
			if item.bombRes ~= nil and item.bombRes.x == r1 and item.bombRes.y == c1 then
				if item.ItemStatus == GameItemStatusType.kNone 
					or item.ItemStatus == GameItemStatusType.kItemHalfStable 
					or item.ItemStatus == GameItemStatusType.kWaitBomb
					then
					item:AddItemStatus(GameItemStatusType.kIsSpecialCover)
				end
				return true
			end
		end
	end
	return false
end

------是否可以被引爆-----
function BombItemLogic:canBeBombByBirdBird(mainLogic, r, c)
	local item = mainLogic.gameItemMap[r][c]
	if item.ItemType == GameItemType.kAnimal
		and item.ItemSpecialType >= AnimalTypeConfig.kLine
		and item.ItemSpecialType <= AnimalTypeConfig.kColor
		and item:isAvailable()
		then
		return true
	end
	return false;
end

-------一次性引爆所有特效-----
function BombItemLogic:BombAll(mainLogic)
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			if (BombItemLogic:canBeBombByBirdBird(mainLogic, r, c)) then
				-----可以被直接引爆的情况-----
				local item = mainLogic.gameItemMap[r][c]
				if item:hasLock() then
				elseif item:hasFurball() then
					SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 1, 4)
				else
					item:AddItemStatus(GameItemStatusType.kIsSpecialCover)
				end
			end
		end
	end
end

---------一次性引爆所有带有颜色的item------------------
function BombItemLogic:bombAllColorItem(mainLogic)
	for r = 1, #mainLogic.gameItemMap do 
		for c = 1, #mainLogic.gameItemMap[r] do 
			local item = mainLogic.gameItemMap[r][c]
			if item and item:isColorful() then
				if item.ItemType == GameItemType.kRabbit then
					item:changeRabbitState(GameItemRabbitState.kNoTarget)
				end
				
				if item:hasLock() then
				elseif item:hasFurball() then
					SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 1, 4)
				else
					item:AddItemStatus(GameItemStatusType.kIsSpecialCover)
				end
			end
		end
	end
end

----统计当前可爆炸的特效
function BombItemLogic:getNumSpecialBomb(mainLogic)
	local result = 0
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			if BombItemLogic:canBeBombByBirdBird(mainLogic, r, c) then
				local item = mainLogic.gameItemMap[r][c]
				if item:hasLock() then
					result = result + 1
				elseif item:hasFurball() then
					if item.furballType == GameItemFurballType.kGrey then
						result = result + 1
					end
				else
					result = result + 1
				end
			end
		end
	end

	return result
end

-------鸟鸟交换清屏-----
function BombItemLogic:tryCoverByBirdBird(mainLogic, birdBirdPos, isBombScore, scoreScale)
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if item:isItemCanBeCoverByBirdBrid() then
				if item:isItemCanBeEliminateByBridBird() then
					----1.分数
					if scoreScale == 0 then scoreScale = 1 end
					if scoreScale < 0 then scoreScale = 0 end

					local addScore = GamePlayConfig_Score_MatchDeleted_Base * scoreScale
					if mainLogic.gameItemMap[r][c].ItemType == GameItemType.kCrystal then 	 -----水晶则消除增加100分
						addScore = GamePlayConfig_Score_MatchDeleted_Crystal * scoreScale
					elseif mainLogic.gameItemMap[r][c].ItemType == GameItemType.kBalloon then 
						addScore = GamePlayConfig_Score_Balloon * scoreScale
					elseif mainLogic.gameItemMap[r][c].ItemType == GameItemType.kRabbit then
						addScore = GamePlayConfig_Score_Rabbit * scoreScale
					end
					ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
					local ScoreAction = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemScore_Get,
						IntCoord:create(r,c),
						nil,				
						1)
					ScoreAction.addInt = addScore
					mainLogic:addGameAction(ScoreAction)

					----2.动画
					if item.ItemType == GameItemType.kAnimal then
						if item.ItemSpecialType >= AnimalTypeConfig.kLine and item.ItemSpecialType <= AnimalTypeConfig.kColor then
							item:AddItemStatus(GameItemStatusType.kIsSpecialCover)
						else
							local CoverAction = nil
							CoverAction = GameBoardActionDataSet:createAs(
								GameActionTargetType.kGameItemAction,
								GameItemActionType.kItemSpecial_ColorColor_ItemDeleted,
								IntCoord:create(r,c),
								IntCoord:create(birdBirdPos.r, birdBirdPos.c),
								GamePlayConfig_SpecialBomb_BirdBird_Time5)
							CoverAction.addInfo = "kAnimal"
							CoverAction.addInt2 = scoreScale
							mainLogic:addDestroyAction(CoverAction)

							item:AddItemStatus(GameItemStatusType.kDestroy)
							mainLogic:tryDoOrderList(r, c, GameItemOrderType.kAnimal, mainLogic.gameItemMap[r][c].ItemColorType)
						end
						mainLogic.gameItemMap[r][c].gotoPos = nil
						mainLogic.gameItemMap[r][c].comePos = nil
					else
						item:AddItemStatus(GameItemStatusType.kIsSpecialCover)
					end

					if mainLogic.gameItemMap[r][c].ItemType == GameItemType.kCrystal or mainLogic.gameItemMap[r][c].ItemType == GameItemType.kCoin then
						ProductItemLogic:shoundCome(mainLogic, mainLogic.gameItemMap[r][c].ItemType)
					end

					SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, scoreScale)
					SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
				elseif item:hasLock() then
					SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3, scoreScale)
				elseif item:hasFurball() then
					SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3, scoreScale)
				elseif item.ItemType == GameItemType.kCoin then
					local addScore = GamePlayConfig_Score_MatchDeleted_Crystal * scoreScale
					ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
					local ScoreAction = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemScore_Get,
						IntCoord:create(r,c),
						nil,				
						1)
					ScoreAction.addInt = addScore
					mainLogic:addGameAction(ScoreAction)
					item:AddItemStatus(GameItemStatusType.kIsSpecialCover)
				elseif item.ItemType == GameItemType.kBlackCuteBall then
					if item.blackCuteStrength > 0 then 

						item.blackCuteStrength = item.blackCuteStrength - 1
						if item.blackCuteStrength == 0 then 
							item:AddItemStatus(GameItemStatusType.kDestroy)
							SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
						end
						
						ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_MatchAt_BlackCuteBall * scoreScale)
						local ScoreAction = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItemScore_Get,
							IntCoord:create(r, c),
							nil,
							1)
						ScoreAction.addInt = GamePlayConfig_Score_MatchAt_BlackCuteBall * scoreScale
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
				elseif item.ItemType == GameItemType.kQuestionMark and item:isQuestionMarkcanBeDestroy() then
					GameExtandPlayLogic:questionMarkBomb( mainLogic, r, c )
				end
			elseif item:isBlockerCanBeCoverByBirdBrid() then
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 3, scoreScale)
			elseif item.isEmpty then
				SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
			else
				SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, scoreScale)
			end
		end
	end
end

-----BounsTime的时候随机引爆现有特效
function BombItemLogic:BonusTime_RandomBombOne(mainLogic, trueBomb)
	for i = 1, 3 do
		for r = 1, #mainLogic.gameItemMap do
			for c = 1, #mainLogic.gameItemMap[r] do
				local item = mainLogic.gameItemMap[r][c]
				if item.isUsed == true 
					and item.ItemType == GameItemType.kAnimal
					and item.ItemSpecialType ~= 0 
					and item:isAvailable()
					then

					if item:hasFurball() then
						SpecialCoverLogic:effectBlockerAt(mainLogic, r, c, 1)
					end

					if not item:hasFurball() or item.furballType == GameItemFurballType.kGrey then
						if i == 1 then
							if item.ItemSpecialType == AnimalTypeConfig.kWrap then
								if item.ItemStatus == GameItemStatusType.kNone and trueBomb then
									mainLogic.gameItemMap[r][c]:AddItemStatus(GameItemStatusType.kIsSpecialCover)
									mainLogic:setNeedCheckFalling()
								end
								return true
							end
						elseif i == 2 then
							if item.ItemSpecialType == AnimalTypeConfig.kColumn 
								or item.ItemSpecialType == AnimalTypeConfig.kLine then
								if item.ItemStatus == GameItemStatusType.kNone and trueBomb then
									mainLogic.gameItemMap[r][c]:AddItemStatus(GameItemStatusType.kIsSpecialCover)
									mainLogic:setNeedCheckFalling()
								end
								return true
							end
						elseif i == 3 then
							if item.ItemSpecialType == AnimalTypeConfig.kColor then
								if item.ItemStatus == GameItemStatusType.kNone and trueBomb then
									mainLogic.gameItemMap[r][c]:AddItemStatus(GameItemStatusType.kIsSpecialCover)
									mainLogic:setNeedCheckFalling()
								end
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end

function BombItemLogic:initRandomAnimalChangeList(mainLogic)
	mainLogic.randomAnimalHelpList = {}
	local counts = 0;
	for r=1,#mainLogic.gameItemMap do
		for c=1,#mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if item.ItemType == GameItemType.kAnimal 
				and item.ItemColorType > 0 
				and item.ItemSpecialType == 0 
				and not item:hasFurball() 
				and not item:hasLock()
				and item:isAvailable() then
				----普通动物
				counts = counts + 1
				mainLogic.randomAnimalHelpList[counts] = IntCoord:create(r,c)
			end
		end
	end
end

function BombItemLogic:getRandomAnimalChangeToLineSpecial(mainLogic)
	if #mainLogic.randomAnimalHelpList == 0 then
		return nil
	end

	local rid = mainLogic.randFactory:rand(1, #mainLogic.randomAnimalHelpList);
	local pos = mainLogic.randomAnimalHelpList[rid]
	local ret = IntCoord:create(pos.x, pos.y)
	table.remove(mainLogic.randomAnimalHelpList, rid)
	return ret
end

function BombItemLogic:springFestivalBombScreen(mainLogic)

	local function bombItemMultiTimes(r, c, times, bomb, special)
		for i=1, times do
			-- SpecialCoverLogic:SpecialCoverLightUpAtPos(mainLogic, r, c, 1, true)
			if bomb then
				BombItemLogic:tryCoverByBomb(mainLogic, r, c, true, 1, nil, true)
			end
			if special then
				SpecialCoverLogic:SpecialCoverAtPos(mainLogic, r, c, 0, nil, nil, true, true) 
			end
		end
	end

	local function bombJewel(mainLogic, r, c)
		local item = mainLogic.gameItemMap[r][c]
		if item.digJewelLevel > 0 then
			if item.digBlockCanbeDelete then
				GameExtandPlayLogic:decreaseDigJewel(mainLogic, r, c, nil, true, true)
			end
		end
	end

	local gameItemMap = mainLogic.gameItemMap
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			local item = gameItemMap[r][c]
			if item.ItemType == GameItemType.kDigGround then
				bombItemMultiTimes(r, c, item.digGroundLevel, false, true)
			elseif item.ItemType == GameItemType.kDigJewel then
				-- bombItemMultiTimes(r, c, item.digJewelLevel, false, true)
				for i = 1, item.digJewelLevel do
					bombJewel(mainLogic, r, c)
				end
			elseif item.ItemType == GameItemType.kBoss and item.bossLevel > 0 then
				bombItemMultiTimes(r, c, item.blood, false, true)
			else				
				bombItemMultiTimes(r, c, 1, true, true)					
			end			
		end
	end
end