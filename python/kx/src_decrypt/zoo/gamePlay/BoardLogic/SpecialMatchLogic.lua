require "zoo.gamePlay.BoardLogic.BombItemLogic"
---------
-----特效交换逻辑
SpecialMatchLogic = class{}

function SpecialMatchLogic:MatchBirdBird(mainLogic, r1,c1,r2,c2)
	local item1 = mainLogic.gameItemMap[r1][c1]
	local item2 = mainLogic.gameItemMap[r2][c2]
	local color2 = item2.ItemColorType

	local ColorAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemSpecial_ColorColor ,
		IntCoord:create(r2,c2), 			----交换之后的魔力鸟1位置
		IntCoord:create(r1,c1),				----交换之后的魔力鸟2位置
		GamePlayConfig_SpecialBomb_BirdBird_Time1
		)
	ColorAction.addInfo = "Pass"
	ColorAction.addInt = color2 ----需要引爆的颜色
	ColorAction.addInt2 = 5
	mainLogic:addDestructionPlanAction(ColorAction)
	mainLogic:tryDoOrderList(r1,c1,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kColor)
	mainLogic:tryDoOrderList(r2,c2,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kColor)
	mainLogic:tryDoOrderList(r1,c1,GameItemOrderType.kSpecialSwap, GameItemOrderType_SS.kColorColor)
end

----鸟和区域特效交换
function SpecialMatchLogic:BirdWrapSwapBomb(mainLogic, r1, c1, r2, c2)
	local item1 = mainLogic.gameItemMap[r1][c1]		----鸟
	local item2 = mainLogic.gameItemMap[r2][c2]		----颜色
	local color2 = item2.ItemColorType

	local ColorAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemSpecial_ColorWrap ,
		IntCoord:create(r2,c2), 			----交换之后的魔力鸟位置
		IntCoord:create(r1,c1),				----交换之后的普通物品位置
		GamePlayConfig_SpecialBomb_BirdLine_Time1
		)
	ColorAction.addInfo = "Pass"
	ColorAction.addInt = color2 ----需要引爆的颜色
	ColorAction.addInt2 = 4.5
	mainLogic:addDestructionPlanAction(ColorAction)
	mainLogic:tryDoOrderList(r2,c2,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kColor)
	mainLogic:tryDoOrderList(r1,c1,GameItemOrderType.kSpecialSwap, GameItemOrderType_SS.kColorWrap)
	GamePlayMusicPlayer:playEffect(GameMusicType.kSwapColorLine)
end

----鸟和直线特效交换
function SpecialMatchLogic:BirdLineSwapBomb(mainLogic, r1, c1, r2, c2)
	local item1 = mainLogic.gameItemMap[r1][c1]		----鸟
	local item2 = mainLogic.gameItemMap[r2][c2]		----颜色
	local color2 = item2.ItemColorType
	
	local ColorAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemSpecial_ColorLine ,
		IntCoord:create(r2,c2), 			----交换之后的魔力鸟位置
		IntCoord:create(r1,c1),				----交换之后的普通物品位置
		GamePlayConfig_SpecialBomb_BirdLine_Time1
		)
	ColorAction.addInfo = "Pass"
	ColorAction.addInt = color2 ----需要引爆的颜色
	ColorAction.addInt2 = 4
	mainLogic:addDestructionPlanAction(ColorAction)
	mainLogic:tryDoOrderList(r2,c2,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kColor)
	mainLogic:tryDoOrderList(r1,c1,GameItemOrderType.kSpecialSwap, GameItemOrderType_SS.kColorLine)
	GamePlayMusicPlayer:playEffect(GameMusicType.kSwapColorLine)
end

----鸟和颜色交换
function SpecialMatchLogic:BirdColorSwapBomb(mainLogic, r1, c1, r2, c2)
	local item1 = mainLogic.gameItemMap[r1][c1]		----鸟
	local item2 = mainLogic.gameItemMap[r2][c2]		----颜色

	if item2.ItemType == GameItemType.kMagicLamp and item2.lampLevel > 0 and item2:isAvailable() then
		local chargeAction = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_Magic_Lamp_Charging,
                        IntCoord:create(r1, c1),  ----!!!:交换之后的普通物品位置
                        nil,
                        GamePlayConfig_MaxAction_time
                    )
		chargeAction.count = 4
	    mainLogic:addDestroyAction(chargeAction)
	end
	local color2 = item2.ItemColorType
	
	local ColorAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemSpecial_Color ,
		IntCoord:create(r2,c2), 			----交换之后的魔力鸟位置
		IntCoord:create(r1,c1),				----交换之后的普通物品位置
		GamePlayConfig_SpecialBomb_BirdAnimal_Time1
		)
	ColorAction.addInfo = "Pass"
	ColorAction.addInt = color2 ----需要引爆的颜色
	ColorAction.addInt2 = 2.5
	mainLogic:addDestructionPlanAction(ColorAction)
	mainLogic:tryDoOrderList(r1,c1,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kColor)
	GamePlayMusicPlayer:playEffect(GameMusicType.kEliminateColor)
end

-----直线特效交换爆炸
function SpecialMatchLogic:LineLineSwapBomb(mainLogic, r1, c1, r2, c2)
	local item1 = mainLogic.gameItemMap[r1][c1]
	local item2 = mainLogic.gameItemMap[r2][c2]
	local sp1 = item1.ItemSpecialType
	local sp2 = item2.ItemSpecialType

	-----1.计算分数
	ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_Swap_LineLine);
	local ScoreAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemScore_Get,
		IntCoord:create(r1,c1),				
		nil,				
		1)
	ScoreAction.addInt = GamePlayConfig_Score_Swap_LineLine;
	mainLogic:addGameAction(ScoreAction);
	GamePlayMusicPlayer:playEffect(GameMusicType.kSwapLineLine)

	-----2.引爆其他部分
	BombItemLogic:BombItemToChange(mainLogic, r1, c1, sp2, 1, 3, true)
	BombItemLogic:BombItemToChange(mainLogic, r2, c2, sp1, 1, 3, true)
	mainLogic:tryDoOrderList(r1,c1,GameItemOrderType.kSpecialSwap, GameItemOrderType_SS.kLineLine)
end

function SpecialMatchLogic:WrapLineSwapBomb(mainLogic, r1, c1, r2, c2)
	local item1 = mainLogic.gameItemMap[r1][c1]
	local item2 = mainLogic.gameItemMap[r2][c2]
	local sp1 = item1.ItemSpecialType
	local sp2 = item2.ItemSpecialType

	-----1.计算分数
	ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_Swap_LineWrap);
	local ScoreAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemScore_Get,
		IntCoord:create(r1,c1),				
		nil,				
		1)
	ScoreAction.addInt = GamePlayConfig_Score_Swap_LineWrap;
	mainLogic:addGameAction(ScoreAction);

	mainLogic:tryDoOrderList(r2,c2,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kLine)
	mainLogic:tryDoOrderList(r1,c1,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kWrap)
	mainLogic:tryDoOrderList(r1,c1,GameItemOrderType.kSpecialSwap, GameItemOrderType_SS.kWrapLine)
	-----2.引爆其他部分
	if sp2 == AnimalTypeConfig.kLine then
		if c2 == c1 - 1 then ------左
			BombItemLogic:BombItemToChange(mainLogic, r1 + 1, c1, sp2, 2, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1 - 1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1 - 2, c1, sp2, 2, 3.5, true)
		elseif c2 == c1 + 1 then -----右
			BombItemLogic:BombItemToChange(mainLogic, r1 + 2, c1, sp2, 2, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1 + 1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1 - 1, c1, sp2, 2, 3.5, true)
		elseif r2 == r1 - 1 then -----上
			BombItemLogic:BombItemToChange(mainLogic, r1 + 1, c1, sp2, 2, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1 - 1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1 - 2, c1, sp2, 2, 3.5, true)
		elseif r2 == r1 + 1 then -----下
			BombItemLogic:BombItemToChange(mainLogic, r1 + 2, c1, sp2, 2, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1 + 1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1 - 1, c1, sp2, 2, 3.5, true)
		end
	elseif sp2 == AnimalTypeConfig.kColumn then
		if c2 == c1 - 1 then ------左
			BombItemLogic:BombItemToChange(mainLogic, r1, c2 - 1, sp2, 2, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c2, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1 + 1, sp2, 2, 3.5, true)
		elseif c2 == c1 + 1 then -----右
			BombItemLogic:BombItemToChange(mainLogic, r1, c1 - 1, sp2, 2, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c2, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c2 + 1, sp2, 2, 3.5, true)
		elseif r2 == r1 - 1 then -----上
			BombItemLogic:BombItemToChange(mainLogic, r1, c1 - 1, sp2, 2, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1, sp2, 0, 3.5)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1 + 1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1 + 2, sp2, 2, 3.5, true)
		elseif r2 == r1 + 1 then -----下
			BombItemLogic:BombItemToChange(mainLogic, r1, c1 - 2, sp2, 2, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1 - 1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1, sp2, 0, 3.5, true)
			BombItemLogic:BombItemToChange(mainLogic, r1, c1 + 1, sp2, 2, 3.5, true)
		end
	end
	item1.isItemLock = true
	item2.isItemLock = true
	GamePlayMusicPlayer:playEffect(GameMusicType.kSwapWrapLine)
end

--------两个区域特效交换爆炸--------
function SpecialMatchLogic:WrapWrapSwapBomb(mainLogic, r1, c1, r2, c2)
	local item1 = mainLogic.gameItemMap[r1][c1]
	local item2 = mainLogic.gameItemMap[r2][c2]

	-----1.计算分数
	ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_Swap_WrapWrap);
	local ScoreAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemScore_Get,
		IntCoord:create(r1,c1),				
		nil,				
		1)
	ScoreAction.addInt = GamePlayConfig_Score_Swap_WrapWrap;
	mainLogic:addGameAction(ScoreAction);
	mainLogic:tryDoOrderList(r1,c1,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kWrap)
	mainLogic:tryDoOrderList(r2,c2,GameItemOrderType.kSpecialBomb, GameItemOrderType_SB.kWrap)
	mainLogic:tryDoOrderList(r1,c1,GameItemOrderType.kSpecialSwap, GameItemOrderType_SS.kWrapWrap)

	-----2.锁上 不会再次爆炸
	item1.isItemLock = true;
	item2.isItemLock = true;

	-----3.引爆其他部分
	local WrapWrapAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemSpecial_WrapWrap,
		IntCoord:create(r1, c1),
		IntCoord:create(r2, c2),
		GamePlayConfig_SpecialBomb_WrapWrap)
	mainLogic:addDestructionPlanAction(WrapWrapAction)
end