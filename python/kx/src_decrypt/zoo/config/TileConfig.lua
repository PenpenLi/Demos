------------------------------------------------------------------------------------
-- 地格类型
------------------------------------------------------------------------------------
local bit = require("bit")

TileConst = table.const
{
	kEmpty = 1,
	kAnimal = 2,
	kLight1 = 3,
	kLight2 = 4,	--两层冰
	kCannon = 5,	--生成口
	kBlocker = 6,	--障碍
	kFrosting = 7,	--冰霜
	kLock = 8,		--牢笼
	kFudge = 9,		--
	kCollector = 10,--收集口
	kPortal = 11,
	kPortalEnter = 12,--入口
	kPortalExit = 13,--出口
	kCoin = 14,
	kChamelleon = 15,--
	
	kLicoriceSquare = 17,
	kPepper = 18,
	kFrosting1 =  19,
	kFrosting2 =  20,
	kFrosting3 =  21,
	kFrosting4 =  22,
	kFrosting5 =  23,
	
	kWall = 25,		--墙
	kWallUp = 26,
	kWallDown = 27,
	kWallLeft = 28,
	kWallRight = 29,
	kLight3 = 30,
	kDigGround = 31,	--
	kGreyCute = 32,		--毛球
	kBrownCute = 33,	--
	kBlackCute = 34,	--黑色毛球
	kCrystal = 35,		--水晶
	kGift = 36,			--礼物

	kPoison = 37,		--毒液
	kNone = 38,			--空格子
	kCannonAnimal = 39,	--动物生成掉落口
	kCannonIngredient = 40,--原料掉落口
	kCannonBlock= 41,	--障碍生成掉落口
	kAddMove = 42, 		--增加步数的动物
	kDigGround_1 = 43,   ---挖地地块--多层
	kDigGround_2 = 44,
	kDigGround_3 = 45,
	kDigJewel_1 = 46,    --挖地-宝石块--多层
	kDigJewel_2 = 47,
	kDigJewel_3 = 48,

	kRoost = 49, 		--鸡窝
	kBalloon = 50, --气球
	kRabbitProducer = 51, --兔子生成口

	kPoisonBottle = 52, --毒液瓶
	kTileBlocker = 53,  --翻转地格
	kTileBlocker2 = 54, --2号翻转地格

	kBigMonster = 58,   --占四格的巨型怪物
	kBigMonsterFrosting1 = 59,
	kBigMonsterFrosting2 = 60,
	kBigMonsterFrosting3 = 61,
	kBigMonsterFrosting4 = 62,
					
	kMimosaLeft = 63,        -----含羞草
	kMimosaRight = 64,
	kMimosaUp = 65,
	kMimosaDown = 66,
	kMimosaLeaf = 67,

	--活动相关 四格boss 无尽劳动节模式
	kMayDayBlocker1 = 68,
	kMayDayBlocker2 = 69,
	kMayDayBlocker3 = 70,
	kMayDayBlocker4 = 71,
	--活动相关 无尽劳动模式 类似宝石
	kDigJewel_1_blue = 72,
	kDigJewel_2_blue = 73,
	kDigJewel_3_blue = 74,

	kMaydayBlockerEmpty = 75,

	kSnailSpawn = 76, 	--蜗牛生成口
	kSnail = 77,      	--蜗牛
	kSnailCollect = 78, --蜗牛收集口
	
	kTransmission = 80,  ---传送带
	kMagicLamp = 84, -- 神灯（别名：独眼、增益性障碍）
	kSuperBlocker = 87,	-- 无敌障碍
	kHoneyBottle = 88,  --蜂蜜罐子
	kHoney = 89,        --蜂蜜
	kAddTime	= 90, 	--增加时间的动物
	kMagicTile = 91,	-- 万圣节魔法地格
	kSand = 92, 	-- 流沙
	-----------------------------------------------这里开始地图使用新的数据结构
	kQuestionMark = 93,  --问号
	-- 冰柱 94~118
	kChain1 = 94,
	kChain1_Up = 95,
	kChain1_Right = 96,
	kChain1_Down = 97,
	kChain1_Left = 98,
	kChain2 = 99,
	kChain2_Up = 100,
	kChain2_Right = 101,
	kChain2_Down = 102,
	kChain2_Left = 103,
	kChain3 = 104,
	kChain3_Up = 105,
	kChain3_Right = 106,
	kChain3_Down = 107,
	kChain3_Left = 108,
	kChain4 = 109,
	kChain4_Up = 110,
	kChain4_Right = 111,
	kChain4_Down = 112,
	kChain4_Left = 113,
	kChain5 = 114,
	kChain5_Up = 115,
	kChain5_Right = 116,
	kChain5_Down = 117,
	kChain5_Left = 118,
	-- 魔法石 PC:firefly
	kMagicStone_Up = 119,
	kMagicStone_Right = 120,
	kMagicStone_Down = 121,
	kMagicStone_Left = 122,

	kHoney_Sub_Select = 123,   ---蜂蜜优先级的第二选择
	kCannonCoin = 124,
	kCannonCrystallBall = 125,
	kCannonBalloon = 126,
	kCannonHoneyBottle = 127,
	kCannonGreyCuteBall = 128,
	kCannonBrownCuteBall = 129,
	kCnanonBlackCuteBall = 130,

	kMaxTile = 140,		--
	kInvalid = -1,		--
}

------------------------------------------------------------------------------------
-- 墙的方向定义
------------------------------------------------------------------------------------
DirConfig = table.const
{
	kUp = 1,
	kDown = 2,
	kLeft = 3,
	kRight = 4
}

---------------------------------
-- 冰柱方向定义
---------------------------------
ChainDirConfig = table.const {
	kUp = 1,
	kRight = 2,
	kDown = 3,
	kLeft = 4,
}

-------------------------------
-- 魔法石方向定义
-------------------------------
MagicStoneDirConfig = table.const {
	kUp = 1,
	kRight = 2,
	kDown = 3,
	kLeft = 4,
}

------------------------------------------------------------------------------------
-- 动物类型
------------------------------------------------------------------------------------
AnimalTypeConfig = table.const 
{
    kNone = 30,
	kRandom = 0, 
	kBlue = 1, 
	kGreen = 2, 
	kOrange = 3, 
	kPurple = 4, 
	kRed = 5, 
	kYellow = 6,
	kLine = 7,
	kColumn = 8,
	kWrap = 9,
	kColor = 10,
	
	fRandom = 0x0,		
	fBlue = 0x2, 		
	fGreen = 0x4, 		
	fOrange = 0x8, 		
	fPurple = 0x10, 
	fRed = 0x20, 
	fYellow = 0x40,
	fLine = 0x80,
	fColumn = 0x100,
	fWrap = 0x200,
	fColor = 0x400,
}

RouteConst = table.const{
	kUp = 1, 
	kDown = 2, 
	kLeft = 3,
	kRight = 4,

	kSimple = 5, 
	kOverLap = 6,
	kCross = 7,

	kMaxTile = 8,		--
	kInvalid = -1,		--
}

---问号障碍可以生成的类型
UncertainCfgConst = table.const{
	kCanFalling = 1,      ------可以掉落的
	kCannotFalling = 2,   ------不能掉落
	kSpecial = 3,         ------特效
	kProps = 4,         	  ------道具
}

function AnimalTypeConfig.getType(value)
	if value == 0 then return 0 end

	local color = 0

	if bit.band(value, AnimalTypeConfig.fBlue) ~= 0 then color = AnimalTypeConfig.kBlue
	elseif bit.band(value, AnimalTypeConfig.fGreen) ~= 0 then color = AnimalTypeConfig.kGreen
	elseif bit.band(value, AnimalTypeConfig.fOrange) ~= 0 then color = AnimalTypeConfig.kOrange
	elseif bit.band(value, AnimalTypeConfig.fPurple) ~= 0 then color = AnimalTypeConfig.kPurple
	elseif bit.band(value, AnimalTypeConfig.fRed) ~= 0 then color = AnimalTypeConfig.kRed
	elseif bit.band(value, AnimalTypeConfig.fYellow) ~= 0 then color = AnimalTypeConfig.kYellow
	else color = AnimalTypeConfig.kRandom end

	return color
end

function AnimalTypeConfig.getSpecial(value)
	if value == 0 then return 0 end

	local special = 0
	if bit.band(value, AnimalTypeConfig.fLine) ~= 0 then special = AnimalTypeConfig.kLine
	elseif bit.band(value, AnimalTypeConfig.fColumn) ~= 0 then special = AnimalTypeConfig.kColumn
	elseif bit.band(value, AnimalTypeConfig.fWrap) ~= 0 then special = AnimalTypeConfig.kWrap
	elseif bit.band(value, AnimalTypeConfig.fColor) ~= 0 then special = AnimalTypeConfig.kColor end
	
	return special
end

------------------------------------------------------------------------------------
-- 动物特殊类型定义
------------------------------------------------------------------------------------
-- SpecialType = table.const 
-- {
-- 	kNone = 0x0,
-- 	kCoin = 0x2,
-- 	kWrap = 0x4,
-- 	kLine = 0x8,
-- 	kColor = 0x10,
-- 	kColumn = 0x20,
-- 	kDropDownIngredient = 0x40,
-- 	kLicoriceSquare = 0x80,
-- 	kChamelleon = 0x100,
-- 	kCrystalBall = 0x200,
-- 	kGift = 0x400
-- }

-- function SpecialType.isWrap(value) return value == SpecialType.kWrap end
-- function SpecialType.isColor(value) return value == SpecialType.kColor end
-- function SpecialType.isLine(value) return value == SpecialType.kLine end
-- function SpecialType.isColumn(value) return value == SpecialType.kColumn end
-- function SpecialType.isStripe(value) return SpecialType.isLine(value) or SpecialType.isColumn(value) end
-- function SpecialType.isDropDownIngredient(value) return value == SpecialType.kDropDownIngredient end
-- function SpecialType.isLicoriceSquare(value) return value == SpecialType.kLicoriceSquare end
-- function SpecialType.isCoin(value) return value == SpecialType.kCoin end
-- function SpecialType.isChameleon(value) return value == SpecialType.kChameleon end
-- function SpecialType.isLicoriceSquareOrDropDown(value) return SpecialType.isDropDownIngredient(value) or SpecialType.isLicoriceSquare(value) end
-- function SpecialType.isCrystalBall(value) return value == SpecialType.kCrystalBall end
-- function SpecialType.isGift(value) return value == SpecialType.kGift end
-- function SpecialType.isNormalCandy(value) return value == SpecialType.kNone end
-- function SpecialType.translateToTileFlag(value)
-- 	if table.indexOf({SpecialType.kNone, SpecialType.kWrap, SpecialType.kLine, SpecialType.kColor, SpecialType.kColumn}, value) then
-- 		return TileConst.kAnimal
-- 	elseif value == SpecialType.kCoin then
-- 		return TileConst.kCoin
-- 	elseif value == SpecialType.kLicoriceSquare then
-- 		return TileConst.kLicoriceSquare
-- 	elseif value ==  SpecialType.kChameleon then
-- 		return TileConst.kChamelleon
-- 	elseif value == SpecialType.kCrystalBall then
-- 		return TileConst.kCrystal
-- 	elseif value == SpecialType.kGift then
-- 		return TileConst.kGift
-- 	end
	
-- 	return TileConst.kEmpty
-- end

------------------------------------------------------------------------------------
-- 深度
------------------------------------------------------------------------------------
ItemViewDepth = table.const {kBackground = 0, kLightUp = 1, kAnimal = 2, kCuteBall = 3, kBlock = 4, kLock = 5, kWall = 6, kEffect = 7}

------------------------------------------------------------------------------------
-- 动物图像映射配置
------------------------------------------------------------------------------------

ItemViewBridge = table.const
{
	kYellow = 0,
	kYellowH = 1,
	kYellowV = 2,
	kYellowW = 3,
	kGreen = 4,
	kGreenH = 5,
	kGreenV = 6,
	kGreenW = 7,
	kOrange = 8,
	kOrangeH = 9,

	kOrangeV = 10,
	kOrangeW = 11,
	kPurple = 12,
	kPurpleH = 13,
	kPurpleV = 14,
	kPurpleW = 15,
	kBlue = 16,
	kBlueH = 17,
	kBlueV = 18,
	kBlueW = 19,
	kRed = 20,
	kRedH = 21,
	kRedV = 22,
	kRedW = 23,
	kColor = 24,
	kHazelnut = 25,
	kCherry = 26,
	kBackground = 27,
	kLight1 = 28,
	kLight2 = 29,
	kLight3 = 30,
	kLock = 31,
	kFrosting = 39,
	kCoin = 40
}

function ItemViewBridge:getGiftItemViewByColor(color)
	local value = 0

	if color == AnimalTypeConfig.kBlue then value = 46
	elseif color == AnimalTypeConfig.kGreen then value = 49
	elseif color == AnimalTypeConfig.kOrange then value = 47
	elseif color == AnimalTypeConfig.kPurple then value = 45
	elseif color == AnimalTypeConfig.kRed then value = 44
	elseif color == AnimalTypeConfig.kYellow then value = 48
	end

	return value
end

function ItemViewBridge:getBlockerViewByStrength(value)
	return 31 + value
end

function ItemViewBridge:getWallViewByDir(dir)
	return 39 - math.ceil(dir / 2)
end

function ItemViewBridge:getCuteBallViewByType(value)
	if value == CuteBallType.kGrey then return 41
	elseif value == CuteBallType.kBrown then return 43
	elseif value == CuteBallType.kBlack then return 42
	end
end

function ItemViewBridge:getCrystalBall(color)
	if color == AnimalTypeConfig.kBlue then value = 50
	elseif color == AnimalTypeConfig.kGreen then value = 53
	elseif color == AnimalTypeConfig.kOrange then value = 52
	elseif color == AnimalTypeConfig.kPurple then value = 55
	elseif color == AnimalTypeConfig.kRed then value = 51
	elseif color == AnimalTypeConfig.kYellow then value = 54
	end
	return value
end

function ItemViewBridge:getFrameName(value)
	return string.format("animal_item_1%04d", value)
end

------------------------------------------------------------------------------------
-- 毛球定义
------------------------------------------------------------------------------------
CuteBallType = {kNone = -1, kGrey = 1, kBrown = 2, kBlack = 3}
		
function CuteBallType.tileToCuteBallType(tile)
	if tile:hasProperty(TileConst.kGreyCute) then
		return CuteBallType.kGrey
	elseif tile:hasProperty(TileConst.kBrownCute) then
		return CuteBallType.kBrown
	elseif tile:hasProperty(TileConst.kBlackCute) then
		return CuteBallType.kBlack
	else
		return CuteBallType.kNone
	end
end