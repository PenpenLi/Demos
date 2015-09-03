require "zoo.config.TileMetaData"
require "zoo.config.TileConfig"

require "zoo.gamePlay.GamePlayConfig"
require "zoo.gamePlay.config.MaydayConfig"
require "zoo.animation.TileBottleBlocker"

GameItemData = class()

GameItemType = table.const
{
	kNone = 0,				--空
	kAnimal = 1,			--动物--包括豆荚
	kSnow = 2,				--雪块
	kCoin = 4,				--银币
	kCrystal = 5,			--水晶--随机变化动物信息
	kGift = 6,				--礼盒
	kIngredient = 7,		--豆荚
	kVenom = 8,				--毒液
	kRoost = 9, 			--鸡窝
	kBalloon = 10,          --气球
	kDigGround = 11,        --挖地地块
	kDigJewel = 12,         --挖地宝石块
	kAddMove = 13, 			--加步数的动物
	kPoisonBottle = 14,     --毒液瓶 -- ps.就是章鱼
	kBigMonster = 15,       --巨型怪物
	kBigMonsterFrosting = 16, --大怪物的雪块
	kBlackCuteBall = 17,        --黑色毛球
	kMimosa  = 18,          ---含羞草
	kSnail   = 19,          --蜗牛
	kBoss = 20,             --四格boss，无尽劳动节模式，可换皮
	kRabbit = 21,           --兔子
	kMagicLamp = 22,		-- 神灯
	kSuperBlocker = 23, 	-- 无敌障碍
	kHoneyBottle = 24,      --蜂蜜罐子
	kAddTime	= 25,		--加时间的动物
	kQuestionMark = 26,     --问号
	kMagicStone = 27, 		-- 魔法石
	kGoldZongZi = 28,       --金粽子，类似kDigJewel，自带一层云
	kBottleBlocker = 29,    --瓶子妖精障碍
}

GameItemStatusType = table.const
{
	kNone = 0,				--正常状态-无需处理
	kIsMatch = 1,			--被Match的状态-----》冰层减少，周围一些Match响应的物体进行响应
	kIsSpecialCover = 2,	--被特效扫描到了
	-- kIsMatchCover = 3,		--同时被Match以及被扫描到,已废弃
	kIsFalling = 4,			--开始掉落
	kJustStop = 5,
	kItemHalfStable = 6,	--半稳定状态
	kWaitBomb = 7,			--等待爆炸的状态，只能爆炸，不能掉落
	kDestroy = 8,			--销毁过程,从开始爆破到彻底消失
}

GameItemFurballType = table.const
{
	kNone = 0,
	kGrey = 1,				--灰色毛球
	kBrown = 2,				--褐色毛球
}

GameItemRabbitState = table.const
{
	kNone = 0,            --无
	kSpawn = 1,           --刚生成
	kNoTarget = 2,        --消除不加目标
	kSuper = 3,
}

IngredientShowType = table.const
{
	kIngredient = 0,  --金豆荚
	kAcorn      = 1,  --橡果
}
function GameItemData:ctor()
	------------------------
	----添加属性请修改 ------copy()函数
	------------------------
	self.isUsed = true 				--是否可用,地形上有没有这个格子
	self.ItemType = 0				--Item的类型
	self.showType = 0               --item的显示类型，同样的种类有可能显示不同，比如金豆荚和橡果
	self.ItemStatus = 0				--状态
	self.ItemColorType = 0			--Item的颜色类型		--0为随机
	self.ItemSpecialType = 0		--Item特殊类型
	self.furballLevel = 0			--毛球等级
	self.furballType = 0
	self.isBrownFurballUnstable = false --褐色毛球不稳定状态(颤抖)
	
	self.isBlock = false			--是block
	self.snowLevel = 0				--雪花层数
	self.cageLevel = 0				--牢笼的层数
	self.venomLevel = 0				--毒液等级
	self.roostLevel = 0				--鸡窝等级
	self.digGroundLevel = 0
	self.digJewelLevel = 0
	self.digGoldZongZiLevel = 0     --金粽子层数
	self.honeyLevel = 0				--蜂蜜等级

	self.x = 0
	self.y = 0
	self.w = GamePlayConfig_Tile_Width
	self.h = GamePlayConfig_Tile_Height

	self.isNeedUpdate = false
	self.isEmpty = true
	self.isItemLock = false				--Item被锁定，引爆的特效，在覆盖别人之后，再覆盖回来不会被再次引爆

	self.gotoPos = nil					--正在前往某个位置
	self.comePos = nil					--正在从某个位置引来一个物体
	self.itemSpeed = 0
	self.itemPosAdd = IntCoord:create(0, 0)
	self.ClippingPosAdd = IntCoord:create(0, 0)
	self.EnterClippingPosAdd = IntCoord:create(0, 0)
	self.dataReach = true				--数据到达（+不是Falling）才能参加Match消除计算--数据到达才能参加特效Cover计算
	self.bombRes = nil					--爆炸来源
	self.isProduct = false  			--正在生产----不参与鸟的爆炸
	self.lightUpBombMatchPosList = nil	--消除冰块时，对于特效禽兽，将引爆该特效的match信息存入这个数组
	self.hasGivenScore = false
	self.balloonFrom = 0
	self.isFromProductBalloon = false  	--标志位 用来防止新生成的气球步数减一
	self.numAddMove = 0
	self.digBlockCanbeDelete = true    	--地块，宝石块是否可以被消除
	self.isReverseSide = false
	self.reverseCount = 3

	self.bigMonsterFrostingType = 0    
	self.bigMonsterFrostingStrength = 0

	self.blackCuteStrength = 0			--黑色毛球血量
	self.lastInjuredStep = 0

	self.mimosaDirection = 0 			--0=no direction 1 = left 2 = right 3 = up 4 = down
	self.mimosaLevel = 0 
	self.mimosaHoldGrid = {}
	self.beEffectByMimosa = false

	self.snailRoadType = nil
	self.isSnail = false

	self.bossLevel = 0
	self.bossHp = nil
	self.rabbitState = 0
	self.rabbitLevel = 0

	self.forbiddenLevel = 0

	self.lampLevel = 0
	self.honeyBottleLevel = 0
	self.addTime = 0

	self.isProductByBossDie = false
	self.questionMarkProduct = 0

	self.magicStoneDir = 0
	self.magicStoneLevel = 0
	self.magicStoneActiveTimes = 0
	self.magicStoneLocked = false

	self.bottleLevel = 0
	self.bottleState = BottleBlockerState.Waiting
end

function GameItemData:dispose()
end

function GameItemData:create()
	local v = GameItemData.new()
	return v
end

function GameItemData:resetDatas()
	self.isUsed = false 				--是否可用,地形上有没有这个格子
	self.ItemType = 0				--Item的类型
	self.showType = 0               --item的显示类型，同样的种类有可能显示不同，比如金豆荚和橡果
	self.ItemStatus = 0				--状态
	self.ItemColorType = 0			--Item的颜色类型		--0为随机
	self.ItemSpecialType = 0		--Item特殊类型
	self.furballLevel = 0			--毛球等级
	self.furballType = 0
	self.isBrownFurballUnstable = false --褐色毛球不稳定状态(颤抖)
	
	self.isBlock = false			--是block
	self.snowLevel = 0				--雪花层数
	self.cageLevel = 0				--牢笼的层数
	self.venomLevel = 0				--毒液等级
	self.roostLevel = 0				--鸡窝等级
	self.digGroundLevel = 0
	self.digJewelLevel = 0
	self.digGoldZongZiLevel = 1
	self.honeyLevel = 0				--蜂蜜等级

	self.isNeedUpdate = false
	self.isEmpty = true
	self.isItemLock = false				--Item被锁定，引爆的特效，在覆盖别人之后，再覆盖回来不会被再次引爆

	self.gotoPos = nil					--正在前往某个位置
	self.comePos = nil					--正在从某个位置引来一个物体
	self.itemSpeed = 0
	self.itemPosAdd = IntCoord:create(0, 0)
	self.ClippingPosAdd = IntCoord:create(0, 0)
	self.EnterClippingPosAdd = IntCoord:create(0, 0)
	self.dataReach = true				--数据到达（+不是Falling）才能参加Match消除计算--数据到达才能参加特效Cover计算
	self.bombRes = nil					--爆炸来源
	self.isProduct = false  			--正在生产----不参与鸟的爆炸
	self.lightUpBombMatchPosList = nil	--消除冰块时，对于特效禽兽，将引爆该特效的match信息存入这个数组
	self.hasGivenScore = false
	self.balloonFrom = 0
	self.isFromProductBalloon = false  	--标志位 用来防止新生成的气球步数减一
	self.numAddMove = 0
	self.digBlockCanbeDelete = true    	--地块，宝石块是否可以被消除
	self.isReverseSide = false
	self.reverseCount = 3

	self.bigMonsterFrostingType = 0    
	self.bigMonsterFrostingStrength = 0

	self.blackCuteStrength = 0			--黑色毛球血量
	self.lastInjuredStep = 0

	self.mimosaDirection = 0 			--0=no direction 1 = left 2 = right 3 = up 4 = down
	self.mimosaLevel = 0 
	self.mimosaHoldGrid = {}
	self.beEffectByMimosa = false

	self.snailRoadType = nil
	self.isSnail = false

	self.bossLevel = 0
	self.bossHp = nil
	self.rabbitState = 0
	self.rabbitLevel = 0

	self.forbiddenLevel = 0

	self.lampLevel = 0
	self.honeyBottleLevel = 0
	self.addTime = 0

	self.isProductByBossDie = false
	self.questionMarkProduct = 0

	self.magicStoneDir = 0
	self.magicStoneLevel = 0
	self.magicStoneActiveTimes = 0
	self.magicStoneLocked = false

	self.bottleLevel = 0
	self.bottleState = BottleBlockerState.Waiting
end

function GameItemData.copyDatasFrom(toData, fromData )
	if type(fromData) ~= "table" then return end
	
	toData.isUsed 		= fromData.isUsed
	toData.ItemType 		= fromData.ItemType
	toData.ItemStatus 	= fromData.ItemStatus
	toData.ItemColorType = fromData.ItemColorType	
	toData.ItemSpecialType = fromData.ItemSpecialType
	toData.furballLevel 	= fromData.furballLevel
	toData.furballType   = fromData.furballType
	toData.isBrownFurballUnstable = fromData.isBrownFurballUnstable
	
	toData.isBlock 		 = fromData.isBlock
	toData.snowLevel 	 = fromData.snowLevel
	toData.cageLevel 	 = fromData.cageLevel
	toData.venomLevel 	 = fromData.venomLevel
	toData.roostLevel 	 = fromData.roostLevel
	toData.digGroundLevel = fromData.digGroundLevel
	toData.digJewelLevel  = fromData.digJewelLevel
	toData.digGoldZongZiLevel = fromData.digGoldZongZiLevel
	toData.balloonFrom    = fromData.balloonFrom
	toData.isFromProductBalloon = fromData.isFromProductBalloon
	toData.numAddMove	 = fromData.numAddMove
	toData.isReverseSide  = fromData.isReverseSide
	toData.reverseCount   = fromData.reverseCount

	toData.isNeedUpdate = fromData.isNeedUpdate
	toData.isEmpty = fromData.isEmpty
	toData.isItemLock = fromData.isItemLock

	toData.gotoPos = fromData.gotoPos
	toData.comePos = fromData.comePos
	toData.itemSpeed = fromData.itemSpeed
	toData.itemPosAdd = IntCoord:clone(fromData.itemPosAdd)
	toData.ClippingPosAdd = fromData.ClippingPosAdd
	toData.dataReach = fromData.dataReach
	toData.bombRes = fromData.bombRes
	toData.isProduct = fromData.isProduct
	toData.lightUpBombMatchPosList = fromData.lightUpBombMatchPosList
	toData.hasGivenScore =  fromData.hasGivenScore
	toData.digBlockCanbeDelete = fromData.digBlockCanbeDelete
	toData.bigMonsterFrostingType = fromData.bigMonsterFrostingType
	toData.bigMonsterFrostingStrength = fromData.bigMonsterFrostingStrength

	toData.blackCuteStrength = fromData.blackCuteStrength
	toData.lastInjuredStep = fromData.lastInjuredStep
	
	toData.mimosaDirection = fromData.mimosaDirection
	toData.mimosaLevel = fromData.mimosaLevel
	toData.mimosaHoldGrid = table.clone(fromData.mimosaHoldGrid)
	toData.beEffectByMimosa = fromData.beEffectByMimosa

	toData.snailRoadType = fromData.snailRoadType
	toData.isSnail = fromData.isSnail

	--------------- Mayday Boss Levels -----------
	toData.bossLevel = fromData.bossLevel 
	toData.blood = fromData.blood
	toData.maxBlood = fromData.maxBlood
	toData.moves = fromData.moves
	toData.maxMoves = fromData.maxMoves
	toData.animal_num = fromData.animal_num
	toData.drop_sapphire = fromData.drop_sapphire
	toData.speicial_hit_blood = fromData.speicial_hit_blood
	toData.hitCounter = fromData.hitCounter
	
	toData.rabbitState = fromData.rabbitState
	toData.rabbitLevel = fromData.rabbitLevel

	-- 章鱼冰道具
	toData.forbiddenLevel = fromData.forbiddenLevel

	-- 神灯
	toData.lampLevel = fromData.lampLevel

	--蜂蜜罐子等级
	toData.honeyBottleLevel = fromData.honeyBottleLevel
	toData.honeyLevel  = fromData.honeyLevel

	--增加时间
	toData.addTime = fromData.addTime

	-- 魔法石属性
	toData.magicStoneDir = fromData.magicStoneDir
	toData.magicStoneLevel = fromData.magicStoneLevel
	toData.magicStoneActiveTimes = fromData.magicStoneActiveTimes
	toData.magicStoneLocked = fromData.magicStoneLocked

	toData.isProductByBossDie = fromData.isProductByBossDie
	toData.questionMarkProduct = fromData.questionMarkProduct
	toData.showType = fromData.showType

	toData.bottleLevel = fromData.bottleLevel
	toData.bottleState = fromData.bottleState
end

function GameItemData:copy()
	local v = GameItemData.new()

	v.x = self.x
	v.y = self.y
	v.w = self.w
	v.h = self.h

	v:copyDatasFrom(self)
	return v
end

function GameItemData:initByConfig( tileDef )
	-- body
	self.x = tileDef.x
	self.y = tileDef.y

	if tileDef:hasProperty(TileConst.kEmpty) then self.isUsed = false else self.isUsed = true end

	if tileDef:hasProperty(TileConst.kNone) then self.isEmpty = true end

	if tileDef:hasProperty(TileConst.kAddMove) then self.ItemType = GameItemType.kAddMove self.isEmpty = false  
	elseif tileDef:hasProperty(TileConst.kGoldZongZi) then self.digGoldZongZiLevel = 1 self.ItemType = GameItemType.kGoldZongZi self.isBlock = true self.isEmpty = false self.isZongZiEnable = false
	elseif tileDef:hasProperty(TileConst.kBottleBlocker) then self.ItemType = GameItemType.kBottleBlocker self.isBlock = true self.isEmpty = false self.bottleLevel = tileDef:getCrossStrengthValue() self.bottleState = BottleBlockerState.Waiting
	elseif tileDef:hasProperty(TileConst.kAddTime) then self.ItemType = GameItemType.kAddTime self.isEmpty = false  --TODO
	elseif tileDef:hasProperty(TileConst.kQuestionMark) then self.ItemType = GameItemType.kQuestionMark self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kAnimal) then self.ItemType = GameItemType.kAnimal self.isEmpty=false
	elseif tileDef:hasProperty(TileConst.kCrystal) then self.ItemType = GameItemType.kCrystal self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kMagicLamp) then self.ItemType = GameItemType.kMagicLamp self.isEmpty = false self.lampLevel = 1 self.isBlock = true
	elseif tileDef:hasProperty(TileConst.kHoneyBottle) then self.ItemType = GameItemType.kHoneyBottle self.isEmpty = false self.honeyBottleLevel = 1 self.isBlock = false
	elseif tileDef:hasProperty(TileConst.kGift) then self.ItemType = GameItemType.kGift self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kFrosting) then self.ItemType = GameItemType.kSnow self.isBlock = true self.isEmpty=false	--判断类型
	elseif tileDef:hasProperty(TileConst.kFrosting1) then self.snowLevel = 1 self.ItemType = GameItemType.kSnow self.isBlock = true	self.isEmpty=false --雪花类型
	elseif tileDef:hasProperty(TileConst.kFrosting2) then self.snowLevel = 2 self.ItemType = GameItemType.kSnow self.isBlock = true self.isEmpty=false
	elseif tileDef:hasProperty(TileConst.kFrosting3) then self.snowLevel = 3 self.ItemType = GameItemType.kSnow self.isBlock = true self.isEmpty=false
	elseif tileDef:hasProperty(TileConst.kFrosting4) then self.snowLevel = 4 self.ItemType = GameItemType.kSnow self.isBlock = true self.isEmpty=false
	elseif tileDef:hasProperty(TileConst.kFrosting5) then self.snowLevel = 5 self.ItemType = GameItemType.kSnow self.isBlock = true self.isEmpty=false
	elseif tileDef:hasProperty(TileConst.kPoison) then self.ItemType = GameItemType.kVenom self.isBlock = true self.venomLevel = 1 self.isEmpty=false	
	elseif tileDef:hasProperty(TileConst.kDigGround_1) then self.digGroundLevel = 1 self.ItemType = GameItemType.kDigGround self.isBlock = true self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kDigGround_2) then self.digGroundLevel = 2 self.ItemType = GameItemType.kDigGround self.isBlock = true self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kDigGround_3) then self.digGroundLevel = 3	self.ItemType = GameItemType.kDigGround self.isBlock = true self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kDigJewel_1) then self.digJewelLevel = 1 self.ItemType = GameItemType.kDigJewel self.isBlock = true self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kDigJewel_2) then self.digJewelLevel = 2 self.ItemType = GameItemType.kDigJewel self.isBlock = true self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kDigJewel_3) then self.digJewelLevel = 3 self.ItemType = GameItemType.kDigJewel self.isBlock = true self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kDigJewel_1_blue) then self.digJewelLevel = 1 self.ItemType = GameItemType.kDigJewel self.isBlock = true self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kDigJewel_2_blue) then self.digJewelLevel = 2 self.ItemType = GameItemType.kDigJewel self.isBlock = true self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kDigJewel_3_blue) then self.digJewelLevel = 3 self.ItemType = GameItemType.kDigJewel self.isBlock = true self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kRoost) then self.ItemType = GameItemType.kRoost self.isBlock = true self.roostLevel = 1 self.isEmpty = false 
	elseif tileDef:hasProperty(TileConst.kPoisonBottle) then self.ItemType = GameItemType.kPoisonBottle self.forbiddenLevel = 0 self.isBlock = true  self.isEmpty = false   --默认毒液瓶
	elseif tileDef:hasProperty(TileConst.kBigMonster) then self.ItemType = GameItemType.kBigMonster self.isBlock = true self.bigMonsterFrostingType = 1 self.isEmpty = false self.bigMonsterFrostingStrength = 1
	elseif tileDef:hasProperty(TileConst.kBigMonsterFrosting1) then self.ItemType = GameItemType.kBigMonsterFrosting self.isBlock = true self.bigMonsterFrostingType = 1 self.isEmpty = false self.bigMonsterFrostingStrength = 1
	elseif tileDef:hasProperty(TileConst.kBigMonsterFrosting2) then self.ItemType = GameItemType.kBigMonsterFrosting self.isBlock = true self.bigMonsterFrostingType = 2 self.isEmpty = false self.bigMonsterFrostingStrength = 1
	elseif tileDef:hasProperty(TileConst.kBigMonsterFrosting3) then self.ItemType = GameItemType.kBigMonsterFrosting self.isBlock = true self.bigMonsterFrostingType = 3 self.isEmpty = false self.bigMonsterFrostingStrength = 1
	elseif tileDef:hasProperty(TileConst.kBigMonsterFrosting4) then self.ItemType = GameItemType.kBigMonsterFrosting self.isBlock = true self.bigMonsterFrostingType = 4 self.isEmpty = false self.bigMonsterFrostingStrength = 1
	elseif tileDef:hasProperty(TileConst.kMimosaLeft) then self.ItemType = GameItemType.kMimosa self.mimosaDirection = 1 self.isBlock = true self.isEmpty = false self.mimosaLevel = 1
	elseif tileDef:hasProperty(TileConst.kMimosaRight) then self.ItemType = GameItemType.kMimosa self.mimosaDirection = 2 self.isBlock = true self.isEmpty = false self.mimosaLevel = 1
	elseif tileDef:hasProperty(TileConst.kMimosaUp) then self.ItemType = GameItemType.kMimosa self.mimosaDirection = 3 self.isBlock = true self.isEmpty = false self.mimosaLevel = 1
	elseif tileDef:hasProperty(TileConst.kMimosaDown) then self.ItemType = GameItemType.kMimosa self.mimosaDirection = 4 self.isBlock = true self.isEmpty = false self.mimosaLevel = 1
	elseif tileDef:hasProperty(TileConst.kSnail) then  self.isBlock = true self.isEmpty = false self.isSnail = true
	elseif tileDef:hasProperty(TileConst.kMayDayBlocker1) then self:initMaydayBoss(1)
	elseif tileDef:hasProperty(TileConst.kMayDayBlocker2) then self:initMaydayBoss(2)
	elseif tileDef:hasProperty(TileConst.kMayDayBlocker3) then self:initMaydayBoss(3)
	elseif tileDef:hasProperty(TileConst.kMayDayBlocker4) then self:initMaydayBoss(4)
	elseif tileDef:hasProperty(TileConst.kMaydayBlockerEmpty) then self.ItemType = GameItemType.kBoss self.bossLevel = 0 self.isBlock = true self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kCoin) then self.ItemType = GameItemType.kCoin self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kBlackCute) then self.ItemType = GameItemType.kBlackCuteBall self.isEmpty = false self.blackCuteStrength = 2
	elseif tileDef:hasProperty(TileConst.kFudge) then self.ItemType = GameItemType.kIngredient self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kBalloon) then self.ItemType = GameItemType.kBalloon self.isEmpty = false
	elseif tileDef:hasProperty(TileConst.kSuperBlocker) then self.ItemType = GameItemType.kSuperBlocker self.isEmpty = false self.isBlock = true 
	end

	if tileDef:hasProperty(TileConst.kGreyCute) then self.furballLevel = 1 self.furballType = GameItemFurballType.kGrey self.isEmpty=false							--毛球类型
	elseif tileDef:hasProperty(TileConst.kBrownCute) then self.furballLevel = 1 self.furballType = GameItemFurballType.kBrown self.isEmpty=false
	end

	if tileDef:hasProperty(TileConst.kLock) then self.cageLevel = 1 self.isBlock = true self.isEmpty=false		--牢笼类型
	end

	if tileDef:hasProperty(TileConst.kHoney) then self.honeyLevel = 1 self.isBlock = true end

	local hasMagicStoneProperty, magicStoneDir = tileDef:hasMagicStoneProperty()
	if hasMagicStoneProperty then -- 魔法石
		self.ItemType = GameItemType.kMagicStone
		self.magicStoneDir = magicStoneDir
		self.magicStoneLevel = TileMagicStoneConst.kInitLevel
		self.isBlock = true
		self.isEmpty=false
	end

	if tileDef:hasProperty(TileConst.kTileBlocker2) then self.isReverseSide = true end
end

function GameItemData:initByAnimalDef(animalDef)--animal的相关初始数据
	if self:isColorful() then
		self.ItemColorType = AnimalTypeConfig.getType(animalDef)
	end
	if self.ItemType == GameItemType.kAnimal then
		self.ItemSpecialType = AnimalTypeConfig.getSpecial(animalDef)
	end
end

function GameItemData:initBalloonConfig( balloonFrom )
	if self.ItemType == GameItemType.kBalloon then
		self.balloonFrom = balloonFrom
	end
end

function GameItemData:initAddMoveConfig(baseAddMove)
	if self.ItemType == GameItemType.kAddMove then
		self.numAddMove = baseAddMove or 5
	end
end

function GameItemData:initAddTimeConfig(baseAddTime)
	if self.ItemType == GameItemType.kAddTime then
		self.addTime = baseAddTime
	end
end

function GameItemData:initSnailRoadType( gameboardData )
	-- body
	if self.isSnail then 
		self.snailRoadType = gameboardData.snailRoadType
	end
end

function GameItemData:changeItemType(colortype, specialtype)
	self.ItemColorType = colortype
	self.ItemSpecialType = specialtype
end

function GameItemData:changeToVenom()
	self.ItemType = GameItemType.kVenom
	self.isBlock = true
	self.venomLevel = 1
	self.ItemColorType = 0
	self.ItemSpecialType = 0
	self.isEmpty = false
end

function GameItemData:changeToDigGround( digGroundLevel )
	-- body
	digGroundLevel = digGroundLevel or 1
	self.ItemType = GameItemType.kDigGround
	self.isBlock = true
	self.digGroundLevel = digGroundLevel
	self.ItemColorType = 0
	self.ItemSpecialType = 0
	self.isEmpty = false
end

function GameItemData:changeToSnail( snailRoadType )
	-- body
	self.ItemType = GameItemType.kNone
	self.ItemColorType = 0
	self.ItemSpecialType = 0
	self.isEmpty = false
	self.snailRoadType = snailRoadType
	self.isSnail = true
	self.isNeedUpdate = true
end

function GameItemData:changeToRabbit( colortype, level )
	self:cleanAnimalLikeData()
	self.isBlock = false
	self.ItemColorType = colortype
	self.rabbitLevel = level
	self.ItemType = GameItemType.kRabbit
	self.isEmpty = false
end

function GameItemData:changeToIngredient( ... )
	-- body
	self.ItemType = GameItemType.kIngredient
	self.isBlock = false
	self.ItemColorType = 0
	self.ItemSpecialType = 0
	self.isEmpty = false
end

-----为Item增加新状态
function GameItemData:AddItemStatus(itemStatus)
	if self.ItemStatus == GameItemStatusType.kNone then
		self.ItemStatus = itemStatus
	elseif self.ItemStatus == GameItemStatusType.kIsMatch then
		if itemStatus == GameItemStatusType.kDestroy then
			self.ItemStatus = GameItemStatusType.kDestroy
		end
	elseif self.ItemStatus == GameItemStatusType.kIsSpecialCover then
		if itemStatus == GameItemStatusType.kDestroy then
			self.ItemStatus = GameItemStatusType.kDestroy
		end
	elseif self.ItemStatus == GameItemStatusType.kItemHalfStable
		or self.ItemStatus == GameItemStatusType.kIsFalling
		or self.ItemStatus == GameItemStatusType.kJustStop then
		if itemStatus == GameItemStatusType.kIsMatch 
			or itemStatus == GameItemStatusType.kIsSpecialCover 
			or itemStatus == GameItemStatusType.kDestroy
			then
			self.ItemStatus = itemStatus
		end
		if (self.ItemStatus == GameItemStatusType.kIsFalling and itemStatus == GameItemStatusType.kJustStop)
			or (self.ItemStatus == GameItemStatusType.kIsFalling and itemStatus == GameItemStatusType.kItemHalfStable)
			or (self.ItemStatus == GameItemStatusType.kJustStop and itemStatus == GameItemStatusType.kItemHalfStable) then
			self.ItemStatus = itemStatus
		end
	end
end

-- 是否可以参与三消匹配，但不一定被消除(比如神灯)
function GameItemData:canBeCoverByMatch()
	if not self:isColorful() then return false end
	if not self.isUsed then return false end
	if not self:isAvailable() then return false end
	if self.isEmpty then return false end
	if self:hasFurball() then return false end

	if self.ItemStatus == GameItemStatusType.kNone
	or self.ItemStatus == GameItemStatusType.kItemHalfStable then
		return true
	end
	
	return false
end

-- 是否可以影响该物体下的冰块/流沙
function GameItemData:canEffectLightUp()
	if (not self.isBlock or self.ItemType == GameItemType.kMagicLamp)
		and not self.isEmpty
		and not self:hasFurball()
		and not self:hasLock()
		and self:isAvailable()
		and self.isUsed
		and self.ItemType ~= GameItemType.kBlackCuteBall
		and self.ItemType ~= GameItemType.kHoneyBottle
		and self.ItemType ~= GameItemType.kBottleBlocker
		then
		return true
	end
	return false
end

-- 是否会引起四周冰柱被消除,仅在matchCover时
function GameItemData:canEffectChains()
	if self.ItemType == GameItemType.kBottleBlocker then
		return false
	end
	return true
end

-- 是否可以在三消匹配中被消除,前置判断是canBeCoverByMatch,此处不需重复过滤
function GameItemData:canBeEliminateByMatch()
	if self:hasLock() then return false end
	if self.ItemType == GameItemType.kMagicLamp then return false end
	if self.ItemType == GameItemType.kBottleBlocker then return false end
	if self.ItemType == GameItemType.kQuestionMark then return false end

	return true
end

-- 是否可以在三消匹配中参与特效合成,前置判断是canBeCoverByMatch,此处不需重复过滤
function GameItemData:canBeMixToSpecialByMatch()
	if self.ItemType == GameItemType.kMagicLamp then return false end
	if self.ItemType == GameItemType.kBottleBlocker then return false end
	if self.ItemType == GameItemType.kQuestionMark then return false end
	return true
end

-- 是否可以被普通特效(不包含魔力鸟、魔力鸟+魔力鸟)直接消除
function GameItemData:canBeEliminateBySpecial()
	if (self.ItemType == GameItemType.kAnimal 		-----动物
		or self.ItemType == GameItemType.kCrystal
		or self.ItemType == GameItemType.kGift 
		or self.ItemType == GameItemType.kCoin
		or self.ItemType == GameItemType.kBalloon 
		or self.ItemType == GameItemType.kAddMove
		or self.ItemType == GameItemType.kAddTime
		or self.ItemType == GameItemType.kRabbit)
		and not self.isEmpty and not self:hasFurball() and not self:hasLock() and self:isAvailable() 
		then
		return true
	end
	return false
end

-----可以被鸟和动物交换的特效影响并且直接消除
function GameItemData:canBeEliminateByBirdAnimal()
	if (self.ItemType == GameItemType.kAnimal 		----类型
		or self.ItemType == GameItemType.kCrystal
		or self.ItemType == GameItemType.kGift
		or self.ItemType == GameItemType.kBalloon
		or self.ItemType == GameItemType.kAddMove
		or self.ItemType == GameItemType.kAddTime
		or self.ItemType == GameItemType.kRabbit)
		and not self:hasFurball() and not self:hasLock()
		and self.isProduct == false 				------不是生产状态/通道通过状态
		and self:isAvailable()
		then
		return true
	end
	return false
end

-----可以被鸟和动物交换的特效影响，但不一定直接消除item，有可能影响了item上的牢笼、毛球等
function GameItemData:canBeCoverByBirdAnimal()
	if self.isEmpty == true or not self:isAvailable() then 
		return false
	end
	if (self.ItemType == GameItemType.kAnimal and self.ItemSpecialType ~= AnimalTypeConfig.kColor)
		or self.ItemType == GameItemType.kCrystal
		or self.ItemType == GameItemType.kGift
		or self.ItemType == GameItemType.kBalloon
		or self.ItemType == GameItemType.kAddMove
		or self.ItemType == GameItemType.kAddTime
		or self.ItemType == GameItemType.kRabbit
		or self.ItemType == GameItemType.kMagicLamp
		or self.ItemType == GameItemType.kBottleBlocker
		or self.ItemType == GameItemType.kQuestionMark
		then														
		return true
	end
	return false
end

function GameItemData:canBecomeSpecialBySwapColorSpecial( )
	-- body
	if (self.ItemType == GameItemType.kAnimal
		or self.ItemType == GameItemType.kGift
		or self.ItemType == GameItemType.kCrystal
		or self.ItemType == GameItemType.kBalloon 
		or self.ItemType == GameItemType.kAddMove
		or self.ItemType == GameItemType.kAddTime
		or self.ItemType == GameItemType.kRabbit
		)
		and self:isAvailable()
		then
		return true
	end
	return false
end

function GameItemData:isItemCanBeCoverByBirdBrid()
	if not self:isAvailable() then return false end
	if self.ItemType == GameItemType.kAnimal
		or self.ItemType == GameItemType.kGift
		or self.ItemType == GameItemType.kCrystal
		or self.ItemType == GameItemType.kCoin
		or self.ItemType == GameItemType.kBalloon
		or self.ItemType == GameItemType.kAddMove
		or self.ItemType == GameItemType.kAddTime
		or self.ItemType == GameItemType.kBlackCuteBall
		or self.ItemType == GameItemType.kRabbit
		or self.ItemType == GameItemType.kQuestionMark
		then
		return true
	end
	return false
end

function GameItemData:isBlockerCanBeCoverByBirdBrid()
	if self.isReverseSide then return false end
	if self.ItemType == GameItemType.kSnow 
		or self.ItemType == GameItemType.kVenom
		or self.ItemType == GameItemType.kDigGround
		or self.ItemType == GameItemType.kDigJewel
		or self.ItemType == GameItemType.kGoldZongZi
		or self.ItemType == GameItemType.kBottleBlocker
		or self.ItemType == GameItemType.kRoost
		or self.bigMonsterFrostingType > 0 
		or self.ItemType == GameItemType.kMimosa 
		or self.beEffectByMimosa
		or self.bossLevel > 0
		or self.ItemType == GameItemType.kMagicLamp
		or self.ItemType == GameItemType.kHoneyBottle
		or self.ItemType == GameItemType.kMagicStone
		then
		return true
	end

	return false
end

function GameItemData:isItemCanBeEliminateByBridBird()
	if (self.ItemType == GameItemType.kAnimal
		or self.ItemType == GameItemType.kGift
		or self.ItemType == GameItemType.kCrystal
		or self.ItemType == GameItemType.kBalloon 
		or self.ItemType == GameItemType.kAddMove
		or self.ItemType == GameItemType.kAddTime
		or self.ItemType == GameItemType.kRabbit
		)
		and not self:hasLock() 
		and not self:hasFurball()
		and self:isAvailable()
		then
		return true
	end
	return false
end

function GameItemData:canBeEffectByHammer()
	if self.ItemType == GameItemType.kNone 
		or self.ItemType == GameItemType.kIngredient
		or self.ItemType == GameItemType.kPoisonBottle
		or (self.bigMonsterFrostingType > 0 and self.bigMonsterFrostingStrength <= 0)
		or self.isReverseSide
		or self.isSnail
		or self.ItemType == GameItemType.kSuperBlocker then
		return false
	end
	return true
end

function GameItemData:isQuestionMarkcanBeDestroy()
	-- body
	if self:hasFurball() or self:hasLock() or not self:isAvailable() then
		return false
	end
	return true
end

----从另一份数据，获取游戏物件信息---类似动物之类的信息---
function GameItemData:getAnimalLikeDataFrom(data)
	--!!!!!!!!
	self.isNeedUpdate = true
	--!!!!!!!!
	self.isEmpty = data.isEmpty
	self.ItemType = data.ItemType
	self.showType = data.showType
	self.ItemStatus = data.ItemStatus
	self.ItemColorType = data.ItemColorType
	self.ItemSpecialType = data.ItemSpecialType
	self.furballLevel = data.furballLevel
	self.furballType = data.furballType
	self.isBrownFurballUnstable = data.isBrownFurballUnstable
	self.itemSpeed = data.itemSpeed
	self.itemPosAdd = IntCoord:clone(data.itemPosAdd)
	self.bombRes = data.bombRes
	self.isItemLock = data.isItemLock
	self.lightUpBombMatchPosList = data.lightUpBombMatchPosList
	self.hasGivenScore = data.hasGivenScore
	self.balloonFrom = data.balloonFrom
	self.isFromProductBalloon = data.isFromProductBalloon
	self.numAddMove = data.numAddMove
	self.digJewelLevel = data.digJewelLevel
	self.digGroundLevel = data.digGroundLevel
	self.isReverseSide = data.isReverseSide
	self.bigMonsterFrostingType = data.bigMonsterFrostingType
	self.bigMonsterFrostingStrength = data.bigMonsterFrostingStrength
	self.blackCuteStrength = data.blackCuteStrength
	self.lastInjuredStep = data.lastInjuredStep
	self.bossLevel = data.bossLevel
	self.blood = data.blood
	self.maxBlood= data.maxBlood
	self.moves = data.moves
	self.maxMoves = data.moves
	self.animal_num = data.animal_num
	self.drop_sapphire = data.drop_sapphire
	self.speicial_hit_blood = data.speicial_hit_blood
	self.rabbitState = data.rabbitState
	self.rabbitLevel = data.rabbitLevel
	self.lampLevel = data.lampLevel
	self.roostLevel = data.roostLevel
	self.cageLevel = data.cageLevel
	self.snowLevel = data.snowLevel
	self.venomLevel = data.venomLevel
	self.forbiddenLevel = data.forbiddenLevel
	self.honeyBottleLevel = data.honeyBottleLevel
	self.honeyLevel = data.honeyLevel
	self.addTime = data.addTime
	self.isProductByBossDie = data.isProductByBossDie
	self.questionMarkProduct = data.questionMarkProduct
	-- 魔法石属性
	self.magicStoneLevel = data.magicStoneLevel
	self.magicStoneDir = data.magicStoneDir
	self.magicStoneActiveTimes = data.magicStoneActiveTimes
	self.magicStoneLocked = data.magicStoneLocked

	self.bottleLevel = data.bottleLevel
	self.bottleState = data.bottleState
end

function GameItemData:cleanAnimalLikeData()
	self.isEmpty = true
	self.ItemType = GameItemType.kNone
	self.ItemStatus = GameItemStatusType.kNone
	self.ItemColorType = 0
	self.ItemSpecialType = 0
	self.furballLevel = 0
	self.furballType = GameItemFurballType.kNone
	self.isBrownFurballUnstable = false
	self.itemSpeed = 0
	self.itemPosAdd = IntCoord:create(0,0)
	self.bombRes = nil
	self.isItemLock = false
	self.isNeedUpdate = true
	self.lightUpBombMatchPosList = nil
	self.hasGivenScore = false
	self.balloonFrom = 0
	self.isFromProductBalloon = false
	self.numAddMove = 0
	self.digJewelLevel = 0
	self.digGroundLevel = 0
	self.isReverseSide = false
	self.bigMonsterFrostingType = 0    
	self.bigMonsterFrostingStrength = 0
	self.blackCuteStrength = 0
	self.lastInjuredStep = 0
	self.bossLevel = 0
	self.blood = 0
	self.maxBlood= 0
	self.moves = 0
	self.maxMoves = 0
	self.animal_num = 0
	self.drop_sapphire = 0
	self.speicial_hit_blood = 0
	self.rabbitState = 0
	self.rabbitLevel = 0
	self.lampLevel = 0
	self.roostLevel = 0
	self.cageLevel = 0
	self.snowLevel = 0
	self.venomLevel = 0
	self.forbiddenLevel = 0
	self.honeyBottleLevel = 0
	self.honeyLevel = 0
	self.addTime = 0
	self.isProductByBossDie = false
	self.questionMarkProduct = 0
	self.digBlockCanbeDelete = true
	-- 魔法石属性
	self.magicStoneLevel = 0
	self.magicStoneDir = 0
	self.magicStoneActiveTimes = 0
	self.magicStoneLocked = false
	self.showType = 0
	self.bottleLevel = 0
	self.bottleState = BottleBlockerState.Waiting
end

function GameItemData:isPermanentBlocker()
	local ret = false
	if self.ItemType == GameItemType.kRoost -- 鸡窝
		or self.ItemType == GameItemType.kMimosa -- 含羞草
		or self.ItemType == GameItemType.kSuperBlocker -- 无敌障碍
		or self.ItemType == GameItemType.kPoisonBottle -- 章鱼
		then 
		ret = true
	end
	return ret
end

function GameItemData:checkBlock()
	local oldBlock = self.isBlock;
	self.isBlock = false;

	if self.snowLevel > 0 
		or self.cageLevel > 0
		or self.venomLevel > 0
		or self.ItemType == GameItemType.kRoost
		or self.digJewelLevel > 0 
		or self.digGroundLevel > 0
		or self.digGoldZongZiLevel > 0
		or self.bottleLevel > 0
		or self.ItemType == GameItemType.kPoisonBottle
		or not self:isAvailable()
		or self.ItemType == GameItemType.kBigMonsterFrosting
		or self.ItemType == GameItemType.kBigMonster
		or self.ItemType == GameItemType.kMimosa
		or self.snailTarget 
		or self.isSnail
		or self.ItemType == GameItemType.kBoss
		or self.ItemType == GameItemType.kMagicLamp 
		or self.ItemType == GameItemType.kSuperBlocker
		or self.honeyLevel > 0
		or self.ItemType == GameItemType.kMagicStone
		then 
		self.isBlock = true 
		self.isUsed = true 
	end

	if self.isBlock == false then  ----雪块 毒液 挖地地块 挖地宝石块 不再是block
		if self.ItemType == GameItemType.kSnow
			or self.ItemType == GameItemType.kVenom
			or self.ItemType == GameItemType.kDigGround
			or self.ItemType == GameItemType.kDigJewel
			or self.ItemType == GameItemType.kGoldZongZi
			or self.ItemType == GameItemType.kBottleBlocker
		then
			self.ItemType = GameItemType.kNone
			self.ItemStatus = GameItemStatusType.kNone
			self.isEmpty = true 
		end

	end

	if oldBlock ~= self.isBlock then
		return true; ----数据变化
	end
	return false;
end

----可以被计入连击数量
function GameItemData:canBeComboNum()
	if self.ItemType == GameItemType.kAnimal then						----小动物
		if self.ItemSpecialType == 0 then
			return true;
		end
	end
	return false;
end

function GameItemData:canBeComboNumCrystal()
	if self.oldItemType == GameItemType.kCrystal 
		or self.ItemType == GameItemType.kCrystal then
		return true
	end
	return false
end

function GameItemData:canBeComboNumBalloon( ... )
	-- body
	if  self.ItemType == GameItemType.kBalloon then 
		if self.ItemSpecialType == 0 then
			return true;
		end
	end
	return false
end

function GameItemData:canBeComboNumRabbit()
	if self.ItemType == GameItemType.kRabbit then
		return true
	end
	return false
end

------初始化的时候变成豆荚
function GameItemData:canBeChangeToIngredient()
	if self.ItemType == GameItemType.kAnimal then
		if self.ItemSpecialType == 0 then
			--print("canBeComboNum true")
			return true;
		end
	end
end

function GameItemData:canBeEffectByUFO()
	if self.ItemType == GameItemType.kIngredient or 
	   self.ItemType == GameItemType.kRabbit then
		return true
	else
		return false
	end
end

function GameItemData:changeRabbitState(state)
	self.rabbitState = state
end

function GameItemData:hasFurball()
	return self.furballLevel > 0
end

function GameItemData:addFurball(furballType)
	self.furballLevel = 1
	self.furballType = furballType
end

function GameItemData:removeFurball()
	self.furballLevel = 0
	self.furballType = GameItemFurballType.kNone
	self.isBrownFurballUnstable = false
end

function GameItemData:hasLock()
	return self.cageLevel ~= 0 or self.honeyLevel ~= 0
end

--是否参与mathch， falling
--item被翻转或者置灰
function GameItemData:isAvailable()
	-- body
	if self.isReverseSide 
		or self.beEffectByMimosa then
		
		return false
	end
	return true
end

--是否是有颜色可参与匹配的物体类型
function GameItemData:isColorful()
	if self.ItemType == GameItemType.kAnimal
		or self.ItemType == GameItemType.kCrystal
		or self.ItemType == GameItemType.kGift
		or self.ItemType == GameItemType.kBalloon
		or self.ItemType == GameItemType.kAddMove
		or self.ItemType == GameItemType.kAddTime
		or self.ItemType == GameItemType.kRabbit
		or self.ItemType == GameItemType.kMagicLamp
		or self.ItemType == GameItemType.kQuestionMark
		or self.ItemType == GameItemType.kBottleBlocker
		then
		return true
	end
	return false
end

-- 是否可以交换移动
function GameItemData:canBeSwap()
	if self.isUsed
		and (not self.isBlock or self.ItemType == GameItemType.kMagicLamp)
		and not self.isEmpty
		and not self:hasFurball()
		and not self:hasLock()
		and self:isAvailable()
		and self.ItemType ~= GameItemType.kBlackCuteBall
		and self.ItemStatus == GameItemStatusType.kNone --稳定状态的东西，才能移动
		then
		return true
	end
	return false
end

--鸡窝升级
function GameItemData:roostUpgrade()
	if self.ItemType == GameItemType.kRoost then
		if self.roostLevel < 4 then
			self.roostLevel = self.roostLevel + 1
		end
	end
end

function GameItemData:roostReset()
	if self.ItemType == GameItemType.kRoost then
		if self.roostLevel == 4 then
			self.roostLevel = 1
		end
	end
end

function GameItemData:initMaydayBoss(level)
	self.ItemType = GameItemType.kBoss 
	self.bossLevel = level
	self.isBlock = true 
	self.isEmpty = false 
	self.maxBlood = BossConfig[level].blood 
	self.blood = self.maxBlood
	self.moves = BossConfig[level].moves
	self.maxMoves = self.moves
	self.animal_num = BossConfig[level].animal_num
	self.drop_sapphire = BossConfig[level].drop_sapphire
	self.speicial_hit_blood = BossConfig[level].specialHitBlood
	self.hitCounter = 0
end

function GameItemData:canInfectByHoneyBottle( ... )
	-- body
	if not self:isAvailable() or self:hasLock() then return false end
	if self:hasFurball() then return false end

	if self.ItemType == GameItemType.kAnimal and self.ItemSpecialType ~= AnimalTypeConfig.kColor 
		or self.ItemType == GameItemType.kCrystal
		or self.ItemType == GameItemType.kMagicLamp
		--or self.ItemType == GameItemType.kBottleBlocker
		or self.ItemType == GameItemType.kQuestionMark then
		return true
	end
	return false
end

function GameItemData:changToSpecial( changeItem, changeColor )
	-- body
	self.ItemType = GameItemType.kAnimal
	self.ItemSpecialType = AnimalTypeConfig.getSpecial(changeItem)
	self.ItemColorType = changeColor
end

function GameItemData:changToFallingItems( changeItem,changeColor, addMoveBase )
	-- body
	local tile = changeItem + 1
	if tile == TileConst.kGreyCute then self.ItemType = GameItemType.kAnimal self.furballLevel = 1 self.furballType = GameItemFurballType.kGrey self.ItemColorType = changeColor
	elseif tile == TileConst.kBrownCute then self.ItemType = GameItemType.kAnimal self.furballLevel = 1 self.furballType = GameItemFurballType.kBrown self.ItemColorType = changeColor
	elseif tile == TileConst.kBlackCute then self.ItemType = GameItemType.kBlackCuteBall self.isEmpty = false self.blackCuteStrength = 2 self.ItemColorType = 0
	elseif tile == TileConst.kCoin then self.ItemType = GameItemType.kCoin self.ItemColorType = 0
	elseif tile == TileConst.kCrystal then self.ItemType = GameItemType.kCrystal self.ItemColorType = changeColor
	elseif tile == TileConst.kAddMove then self.ItemType = GameItemType.kAddMove self.numAddMove = addMoveBase self.ItemColorType = changeColor
	end
end

function GameItemData:changToCannotFallingItems( changeItem )
	-- body
	self.ItemColorType = 0
	local tile = changeItem + 1
	if tile == TileConst.kPoison then self.ItemType = GameItemType.kVenom  self.venomLevel = 1 
	elseif tile == TileConst.kPoisonBottle then self.ItemType = GameItemType.kPoisonBottle self.forbiddenLevel = 0
	elseif tile == TileConst.kDigJewel_1_blue then self.digJewelLevel = 1 self.ItemType = GameItemType.kDigJewel 
	elseif tile == TileConst.kDigJewel_2_blue then self.digJewelLevel = 2 self.ItemType = GameItemType.kDigJewel
	elseif tile == TileConst.kDigJewel_3_blue then self.digJewelLevel = 3 self.ItemType = GameItemType.kDigJewel
	end
end

function GameItemData:changeItemFromQuestionMark( changeType, changeItem, changeColor, addMoveBase)
	-- body
	if changeType == UncertainCfgConst.kCanFalling then
		self:changToFallingItems(changeItem, changeColor, addMoveBase)
	elseif changeType == UncertainCfgConst.kCannotFalling then
		self:changToCannotFallingItems(changeItem)
	elseif changeType == UncertainCfgConst.kSpecial then
		self:changToSpecial(changeItem, changeColor)
	elseif changeType == UncertainCfgConst.kProps then
		self.ItemType = GameItemType.kAnimal
	end
end

function GameItemData:canMagicStoneBeActive()
	if self.ItemType ~= GameItemType.kMagicStone then return false end
	return not self.magicStoneLocked and self.magicStoneActiveTimes < 3
end

function GameItemData:initUnlockAreaDropDownModeInfo( ... )
	-- body
	if self.ItemType == GameItemType.kIngredient then
		self.showType = IngredientShowType.kAcorn
	end
end

function GameItemData:isBigMonsterEffectPrior1( ... )
	-- body
	if not self:isAvailable() then return false end

	if 	self.honeyLevel > 0 
		or self.snowLevel > 0 then 
		return true
	else
		return false
	end
end

function GameItemData:isBigMonsterEffectPrior2( ... )
	-- body
	if not self:isAvailable() then return false end

	if self.venomLevel > 0 
		or self.ItemType == GameItemType.kCoin
		or self:hasFurball()
		or self.ItemType == GameItemType.kBlackCuteBall
		or self.cageLevel > 0 
		or self.ItemType == GameItemType.kDigGround
		or self.mimosaLevel > 0 
		or self.ItemType == GameItemType.kMimosa
		or self.ItemType == GameItemType.kHoneyBottle
		or self.ItemType == GameItemType.kMagicLamp
		or self.ItemType == GameItemType.kBottleBlocker
		or self.ItemType == GameItemType.kRoost
		or self.ItemType == GameItemType.kMagicStone
		then
		return true
	else
		return false
	end
end

function GameItemData:isBigMonsterEffectPrior3( ... )
	-- body
	if not self:isAvailable()  then
			return false
	end

	if self.ItemType == GameItemType.kAnimal 
		or (self.bigMonsterFrostingStrength and self.bigMonsterFrostingStrength > 0)
		then
		return true
	end

	return false
end