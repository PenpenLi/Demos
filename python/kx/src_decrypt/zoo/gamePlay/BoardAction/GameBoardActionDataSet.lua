require "zoo.gamePlay.GamePlayConfig"

--存储游戏Item的动画效果对应数据列表

GameBoardActionDataSet = class{}

GameActionTargetType = table.const	--总体动作分类
{
	kNone = 0,					--空
	kGameBoardAction = 1,		--游戏面板操作动画类型
	kGameItemAction = 2,		--游戏Item自动动画类型
	kPropsAction = 3,			--游戏道具动画类型
}

GameBoardActionType = table.const	--关卡正常操作动画细节
{
	kNone = 0,						--无动画
	kStartTrySwapItem = 1,			--尝试交换两个物体
	kStartTrySwapItemFailed = 2,	--交换两个物体失败的回弹动画
	kStartTrySwapItem_fun = 3,		--搞笑式交换（被墙挡住了）
	kStartBonusTime = 4,			--开始奖励时间
	kStartBonusTime_ItemFlying = 5,	--奖励时间的飞行特效
}

GameItemActionType = table.const	--Item自动播放动画细节
{
	kNone = 0,
	kItemDeletedByMatch = 2,		--因为match消除-----播放消除动画，同时进行相应计算
	kItemCoverBySpecial = 3,		--已废弃

	kItemSpecial_Line = 4,			--Item处发起直线特效_横排
	kItemSpecial_Column = 5,		--Item处发起直线特效_竖排
	kItemSpecial_Wrap = 6,			--区域特效爆炸
	kItemSpecial_Color = 7,			--鸟特效
	kItemSpecial_Color_ItemDeleted = 8, 	 --鸟和animal交换之后，同颜色的引起爆炸或者被吸走
	kItemSpecial_ColorLine = 9,		--鸟和直线特效交换
	kItemSpecial_ColorLine_flying = 10, 		--鸟和直线特效交换之后，飞出多个直线特效
	kItemSpecial_ColorWrap = 11,	--鸟和区域特效交换
	kItemSpecial_ColorWrap_flying = 12,			--鸟和区域特效交换,飞出多个区域特效
	kItemCoverBySpecial_Color = 13,				--鸟消除自己
	kItemSpecial_ColorColor = 14,				--鸟鸟消除
	kItemSpecial_ColorColor_ItemDeleted = 15, 	--鸟和鸟交换之后，全屏的动物被吸走
	kItemSpecial_WrapWrap = 16,		--区域+区域

	kItemShakeBySpecialColor = 17,	--鸟相关的特效中禽兽摇头晃脑

	kItemFalling_UpDown = 20,		--Item向下掉落
	kItemFalling_LeftRight = 21,		--左右掉落
	kItemFalling_Product = 22,		--生成新的Item
	kItemFalling_Pass = 23,			--穿过通道

	kItemMatchAt_IceDec = 30,		--MatchAt--> 冰层消除一层
	kItemMatchAt_LockDec = 31,		--MatchAt--> 牢笼消除一层
	kItemMatchAt_SnowDec = 32,		--MatchAt--> 雪花消除一层
	kItemMatchAt_VenowDec = 33,		--MatchAt--> 毒液消除一层

	kItemScore_Get = 40,			--获取分数特效
	kItemOrderList_Get = 41,		--完成某个Order

	kItemRefresh_Item_Flying = 50, 		 --刷新效果

	kItem_CollectIngredient = 60,	----收集食材（豆荚）

	kItem_Crystal_Change = 70, 		----水晶换色
	kItem_Venom_Spread = 71,		----毒液蔓延
	kItem_Furball_Transfer = 72, 	----毛球转移跳动
	kItem_Furball_Grey_Destroy = 73,----灰色毛球完蛋大吉
	kItem_Furball_Brown_Unstable = 74, --褐色毛球被特效打中 变为不稳定状态(颤抖)
	kItem_Furball_Split = 75,		----褐色毛球分裂
	kItem_Furball_Brown_Shield = 76,----褐色毛球护盾
	kItem_Roost_Upgrade = 77,		----鸡窝升级
	kItem_Roost_Replace = 78,		----鸡窝将原有动物替换为小鸡

	kItem_Balloon_update = 79,      --气球更新数据
	kItem_balloon_runAway = 80,     --气球飞走

	kItem_DigGroundDec = 81, --挖地地块消除一层
	kItem_DigJewleDec = 82,  --挖地宝石块消除一层

	kItem_ItemChangeToIngredient = 83, ---item变成豌豆荚
	kItem_ItemForceToMove = 84,    --强制移动到别的坐标

	kItem_TileBlocker_Update = 85,   --翻转地块更新
	kItem_Monster_frosting_dec = 86, --雪怪上的雪消除
	kItem_Monster_Jump         = 87, --雪怪消失
	kItem_Monster_Destroy_Item = 88, --因雪怪消失导致的消除
	kItem_PM25_Update          = 89, --pm2.5作用

	kItem_Black_Cute_Ball_Dec = 90,  --黑色毛球消除一层
	kItem_Black_Cute_Ball_Update = 91, --黑色毛球更新
	kItem_Mimosa_Grow = 92,            --含羞草生长
	kItem_Mimosa_back = 93,            --含羞草收回
	kItem_Mimosa_Ready = 94,           --含羞草准备生长

	kItem_Snail_Road_Bright = 95,      --蜗牛轨迹点亮
	kItem_Snail_Move = 96,             --蜗牛移动
	kItem_Snail_Product = 97,          --产生蜗牛
	kItem_Mayday_Boss_Die = 98,        -- 劳动节Boss死亡
	kItem_Mayday_Boss_Loss_Blood = 99,

	kItem_Rabbit_Product = 100,       --产生兔子
	kItem_Transmission = 101,         --传送带
	kOctopus_Change_Forbidden_Level = 102, 		-- 章鱼冰
	kItem_Area_Destruction = 103,		-- 消除一个矩形区域 用于海洋生物模式
	kItem_Magic_Lamp_Casting = 104, 	-- 神灯释放
	kItem_Magic_Lamp_Charging = 105,	-- 神灯充能
	kItem_Magic_Lamp_Reinit = 106,	-- 神灯充能
	kItem_WitchBomb = 107,
	kItem_Honey_Bottle_increase = 108,   -- 蜂蜜罐子被打
	kItem_Honey_Bottle_Broken = 109,     -- 蜂蜜罐子破碎
	kItemDestroy_HoneyDec = 110 ,        -- 蜂蜜消除
	kItem_Magic_Tile_Hit = 111,
	kItem_Halloween_Boss_Die = 112,
	kItem_Halloween_Boss_Create = 113,
	kItem_Magic_Tile_Change = 114,
	kItem_Halloween_Boss_Casting = 115,
	kItem_Sand_Clean	= 116,			-- 流沙消除
	kItem_Sand_Transfer	= 117,			-- 流沙流动
}

GamePropsActionType = table.const 	--游戏道具播放动画细节
{
	kNone = 0,
	kHammer = 1,					-- 锤子
	kSwap = 2,						-- 强制交换
	kLineBrush = 3,					-- 条纹刷子
	kBack = 4, 						-- 回退
	kOctopusForbid = 5, 			-- 章鱼冰
	kRandomBird = 6, 				-- 随机魔力鸟
	kBroom = 7,						-- 扫把
}

GameActionStatus = table.const
{
	kNone = 0,
	kWaitingForStart = 1,			--游戏模式下，将等待view--->logic的启动，保证数据和view的同步，数据验证模式下，直接开始计算
	kRunning = 2,					--动作执行中
	kWaitingForDeath = 3,			--即将结束--view-->logic侦查到此状态将走下一步，该动作自动变为下个动作或者结束
}

function GameBoardActionDataSet:ctor()
	self.actionTarget = 0;
	self.actionType = 0;		----GameBoardActionType/GameItemActionType/
	self.ItemPos1 = nil;		----动画Item参数1
	self.ItemPos2 = nil;		----动画Item参数2
	self.actid = 0;

	self.actionStatus = 0;		----动作状态
	self.actionDuring = 0;		----执行时间
	self.addInfo = "";			----辅助字符串
	self.addInt = 0;			----辅助数值
	self.addInt2 = 0;			----辅助数2
end

function GameBoardActionDataSet:dispose()
	self.ItemPos1 = nil;		----动画Item参数1
	self.ItemPos2 = nil;		----动画Item参数2
end

function GameBoardActionDataSet:create()
	local data = GameBoardActionDataSet.new()
	data:initDataSet()
	return data
end

function GameBoardActionDataSet:initDataSet()
end

function GameBoardActionDataSet:createAs(actionTarget, actionType, ItemPos1, ItemPos2, CDTime)
	local data = GameBoardActionDataSet:create()
	data.actionTarget = actionTarget
	data.actionType = actionType
	data.ItemPos1 = ItemPos1
	data.ItemPos2 = ItemPos2

	data.actionStatus = GameActionStatus.kWaitingForStart
	data.actionDuring = CDTime

	if actionType ==  GameItemActionType.kItemScore_Get then
		assert(ItemPos1)
	end
	return data
end