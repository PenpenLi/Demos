require "zoo.config.TileMetaData"
require "zoo.config.SnailConfigData"
require "zoo.data.LevelMapManager"


-----------------------------------------------------------------------------
-- include 
-----------------------------------------------------------------------------

AnimalGameMode = 
{
	kClassic = "Classic", 
	kClassicMoves = "Classic moves",
    kOrder = "Order",
	kLightUp = "Light up",
	kDropDown = "Drop down",
	kDigTime = "DigTime",
	kDigMove = "DigMove",
	kDigMoveEndless = "DigMoveEndless",
	kMaydayEndless = "MaydayEndless",
	kRabbitWeekly = "RabbitWeekly",
	kSeaOrder = "seaOrder",
	kHalloween = "halloween",
}

local DependingAssetsTypeNameMap = 
{
	[TileConst.kCoin]        = {"flash/coin.plist"},
	[TileConst.kPoison]      = {"flash/venom.plist"},
	[TileConst.kPoisonBottle] = {"flash/venom.plist", "flash/PoisonBottle.plist","flash/octopusForbidden.plist"},
	[TileConst.kGreyCute]    = {"flash/ball_grey.plist"},
	[TileConst.kBrownCute]   = {"flash/ball_brown.plist", "flash/ball_grey.plist"},
	[TileConst.kRoost]       = {"flash/roost.plist"},
	[TileConst.kBalloon]     = {"flash/balloon.plist"},
	-- [TileConst.kDigGround_1] = {"flash/dig_block.plist"},
	-- [TileConst.kDigGround_2] = {"flash/dig_block.plist"},
	-- [TileConst.kDigGround_3] = {"flash/dig_block.plist"},
	-- [TileConst.kDigJewel_1]  = {"flash/dig_block.plist"},
	-- [TileConst.kDigJewel_2]  = {"flash/dig_block.plist"},
	-- [TileConst.kDigJewel_3]  = {"flash/dig_block.plist"},
	[TileConst.kAddMove]	 = {"flash/add_move.plist"},
	[TileConst.kTileBlocker] = {"flash/TileBlocker.plist"},
	[TileConst.kTileBlocker2] = {"flash/TileBlocker.plist"},
	[TileConst.kBigMonster]  = {"flash/big_monster.plist"},
	[TileConst.kBlackCute]   = {"flash/ball_black.plist"},
	[TileConst.kMimosaLeft]  = {"flash/mimosa.plist"},
	[TileConst.kMimosaRight]  = {"flash/mimosa.plist"},
	[TileConst.kMimosaUp]  = {"flash/mimosa.plist"},
	[TileConst.kMimosaDown]  = {"flash/mimosa.plist"},
	[TileConst.kSnailSpawn] ={"flash/snail.plist"},
	[TileConst.kSnail] ={"flash/snail.plist"},
	[TileConst.kSnailCollect] ={"flash/snail.plist"},
	[TileConst.kMayDayBlocker1] = {"flash/boss_turkey.plist"},
	[TileConst.kMayDayBlocker2] = {"flash/boss_turkey.plist"},
	[TileConst.kMayDayBlocker3] = {"flash/boss_turkey.plist"},
	[TileConst.kMayDayBlocker4] = {"flash/boss_turkey.plist"},
	[TileConst.kRabbitProducer] = {"flash/rabbit.plist","flash/scenes/gamePlaySceneUI/rabbitModeText.plist"},
	[TileConst.kMagicLamp] = {"flash/magic_lamp.plist"},
	[TileConst.kHoneyBottle] = {"flash/honey_bottle.plist"},
	[TileConst.kAddTime]	 = {"flash/add_time.plist"},
	[TileConst.kMagicTile]	 = {"flash/magic_tile.plist"},
	-- [TileConst.kSand]	 = {"flash/sand_idle_clean.plist", "flash/sand_move.plist"},
}
-----------------------------------------------------------------------------
-- base map config vo [LevelConfig]
-----------------------------------------------------------------------------
LevelConfig = class()

function LevelConfig:ctor()
	self.tileMap = TileMetaData:getEmptyArray()		--地图信息
	self.animalMap = nil							--动物信息
	self.gameMode = ""								--游戏模式
	self.numberOfColors = 6							--颜色数量
	self.scoreTargets = {10000, 20000, 30000}		--1\2\3星目标
	self.randomSeed = 0								--随机种子
	self.portals = nil								--
	self.level = 1 									--等级
	self.props = nil								--
	self.ingamePropTypes = nil						--
	self.dropRules = nil							--掉落规则
    self.moveLimit = 0								--移动限制

    --经典玩法------时间到则结束
	self.timeLimit = -1								--时间限制
	--指定物品消除指定次数
	self.orderMap = {}								--消除指定动物指定数量的列表
	--掉落型游戏方式
	self.ingredients = {}							--原料信息
	self.numIngredientsOnScreen = 1 				--屏幕上已有原料数量
	self.ingredientSpawnDensity = 15 				--原料再生密度？？？
	--时间限制型挖掘--步数限制型挖掘
	self.digTileMap = {}							--挖掘地图信息
	self.layerAmount = 0							--挖掘层数？？？
	self.clearTargetLayers = 5 						--目标层数--达到挖掘目标层数 胜利

	self.balloonFrom = 0                          --气球起始剩余步数
	self.addMoveBase = 0                         -- 气球爆炸增加的步数

	self.hasDropDownUFO = false                     --是否有UFO

	self.rabbitInitNum = 0							-- 初始兔子数
	self.honeys = 0                
end

function LevelConfig:loadConfig(level, config)
	self.level = level 							--等级
	self.gameMode = config.gameModeName				--游戏模式
	self.numberOfColors = config.numberOfColours	--颜色数量

	self.tileMap = TileMetaData:convertArrayFromBitToTile(config.tileMap)	--将配置的数据赋值给tilemap。地形信息

	if config.snailCfg then
		self.snailInitNum = config.snailCfg.initNum
		self.snailMoveToAdd = config.snailCfg.moveToAdd
		self.routeRawData = SnailConfigData:convertArrayFromBitToTile(config.snailCfg.routeRawData)
	end
	self.scoreTargets = config.scoreTargets;		--分数目标
	self.randomSeed = config.randomSeed				--随机种子----服务器将随机种子发给客户端--
	self.portals = config.portals or {}				--
	self.animalMap = config.specialAnimalMap		--特殊的动物地图
	self.props = config.props 						--
	self.ingamePropTypes = config.ingamePropsType	--
	self.dropRules = config.dropRules 				--
    self.moveLimit = config.moveLimit 				--移动步数限制
	self.timeLimit = config.timeLimit				--时间限制
	self.replaceColorMaxNum = config.replaceColorMaxNum
	self.addMoveBase = config.addMoveBase
	self.balloonFrom = config.balloonFrom
	self.hasDropDownUFO = config.hasDropDownUFO     --是否有UFO
	self.pm25 = config.pm25
	self.trans = config.trans 
	self.seaAnimalMap = config.seaAnimalMap
	self.seaFlagMap = config.seaFlagMap

	self.rabbitInitNum = config.rabbitInitNum   	-- 初始兔子数量
	self.honeys = config.honeys                     -- 蜂蜜罐转化为蜂蜜的数量
	if self.timeLimit == nil then 
		self.timeLimit = 0;
	end
	self.addTime = config.addTime or 5 --时间关每个单位增加时间

    if self.gameMode == AnimalGameMode.kClassic then				--经典玩法--时间到则结束
	elseif self.gameMode == AnimalGameMode.kOrder or self.gameMode == AnimalGameMode.kSeaOrder then				--指定物品消除指定次数
		self.orderMap = config.orderList 			
	elseif self.gameMode == AnimalGameMode.kDropDown then 			--下落型玩法
		self.ingredients = config.ingredients
		self.numIngredientsOnScreen = config.numIngredientsOnScreen
		self.ingredientSpawnDensity = config.ingredientSpawnDensity
	elseif self.gameMode == AnimalGameMode.kDigTime then			--时间限制型挖掘
		self.digTileMap = TileMetaData:convertArrayFromBitToTile(config.digTileMap or {})
		self.layerAmount = 0						--挖掘层数
		self.clearTargetLayers = config.clearTargetLayers	--目标层数--达到挖掘目标层数 胜利
	elseif self.gameMode == AnimalGameMode.kDigMove then			--步数限制型挖掘
		self.digTileMap = TileMetaData:convertArrayFromBitToTile(config.digTileMap or {})
		self.layerAmount = 0						--挖掘层数
		self.clearTargetLayers = config.clearTargetLayers	--目标层数--达到挖掘目标层数 胜利
	elseif self.gameMode == AnimalGameMode.kDigMoveEndless then
		self.digTileMap = TileMetaData:convertArrayFromBitToTile(config.digTileMap or {})
		self.clearTargetLayers = config.clearTargetLayers
		self.layerAmount = 0
	elseif self.gameMode == AnimalGameMode.kMaydayEndless or self.gameMode == AnimalGameMode.kHalloween then
		self.digTileMap = TileMetaData:convertArrayFromBitToTile(config.digTileMap or {})
		self.clearTargetLayers = config.clearTargetLayers
		self.layerAmount = 0
	end
end

function LevelConfig:dispose()
	self.timeLimit = nil
	self.digTileMap = nil
	self.layerAmount = nil
	self.clearTargetLayers = nil
	self.ingredients = nil
	self.numIngredientsOnScreen = nil
	self.ingredientSpawnDensity = nil
end

function LevelConfig:create(id, config)
	local lc = LevelConfig.new()
	lc:loadConfig(id, config.gameData)
	return lc
end

function LevelConfig:getDropRules()					--获取掉落规则
	local ret = {}
	for k,v in ipairs(self.dropRules) do
		table.insert(ret, v:clone())
	end
	return ret
end

--关卡依赖的特殊素材诸如毛球、毒液、气球等,不包含普通动物或特效
function LevelConfig:getDependingSpecialAssetsList()
	local resNameMap = {}

	local function calculateTileNeedAssets(tileMap)
		for r = 1, #tileMap do
			for c = 1, #tileMap[r] do
				local tile = tileMap[r][c]
				for type, resList in pairs(DependingAssetsTypeNameMap) do
					if tile:hasProperty(type) then
						for k,v in pairs(resList) do 
							resNameMap[v] = true
						end
						
					end
				end
			end
		end
	end

	calculateTileNeedAssets(self.tileMap)
	
	----------掉落素材
	for k,v in pairs(self.dropRules) do
		if v.itemID == TileConst.kBalloon - 1 then 
			for res_index , res in pairs(DependingAssetsTypeNameMap[TileConst.kBalloon]) do 
				resNameMap[res] = true
			end
			
		elseif v.itemID == TileConst.kCoin - 1 then 
			for res_index, res in pairs(DependingAssetsTypeNameMap[TileConst.kCoin]) do 
				resNameMap[res] = true
			end
		elseif v.itemID == TileConst.kBlackCute -1 then 
			for res_index, res in pairs(DependingAssetsTypeNameMap[TileConst.kBlackCute]) do 
				resNameMap[res] = true
			end
		end
	end

	--传送带
	if self.trans then
		resNameMap["flash/transmission.plist"] = true
	end

	--ufo素材
	if self.hasDropDownUFO then
		-- debug.debug() 
		resNameMap["flash/UFO.plist"] = true
	end

	--挖地关卡需要加载挖地云块素材，并且需要遍历digTileMap中的item类型信息
	-- if self.pm25 > 0 then
	-- 	resNameMap["flash/dig_block.plist"] = true
	-- end

	if self.gameMode == AnimalGameMode.kDigMove or self.gameMode == AnimalGameMode.kDigTime then
		calculateTileNeedAssets(self.digTileMap)
	elseif self.gameMode == AnimalGameMode.kDigMoveEndless or self.gameMode == AnimalGameMode.kMaydayEndless
	or self.gameMode == AnimalGameMode.kHalloween  
	 then
	 	if self.gameMode == AnimalGameMode.kHalloween  then
	 		resNameMap["flash/xmas_boss.plist"] = true
	 	end
		resNameMap["flash/add_move.plist"] = true
		calculateTileNeedAssets(self.digTileMap)
	elseif self.gameMode == AnimalGameMode.kRabbitWeekly then
		-- TODO
		resNameMap["flash/UFO.plist"] = true
	elseif self.gameMode == AnimalGameMode.kSeaOrder then
		resNameMap["flash/sea_animal.plist"] = true
	end
	
	local result = {}
	for resName, v in pairs(resNameMap) do
		table.insert(result, resName)
	end

	return result
end

-----------------------------------------------------------------------------
-- sharedLevelData
-----------------------------------------------------------------------------

LevelDataManager = class()

function LevelDataManager:ctor()	
	self.levelDatas = {}
end

function LevelDataManager:getAllLevels()
    return table.keys(self.levelDatas)
end

-- 获取解析过后的关卡配置 LevelConfig
function LevelDataManager:getLevelConfigByID(id)
	if not self.levelDatas[id] then
		local levelMeta = LevelMapManager.getInstance():getMeta(id)
		self.levelDatas[id] = LevelConfig:create(id, levelMeta)
	end

	assert(self.levelDatas[id])
	return self.levelDatas[id]
end

local ldm__ = nil

function LevelDataManager.sharedLevelData()
	if not ldm__ then
		ldm__ = LevelDataManager.new()
	end
	return ldm__
end
