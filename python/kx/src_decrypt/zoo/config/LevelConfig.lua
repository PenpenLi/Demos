require "zoo.config.TileMetaData"
require "zoo.config.SnailConfigData"
require "zoo.data.LevelMapManager"
require "zoo.config.UncertainCfgMeta"
require "zoo.config.HedgehogBoxCfg"
require "zoo.config.TileMoveConfig"


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
	kTaskForUnlockArea = "Mobile Drop down",
	kHedgehogDigEndless = "HedgehogDigEndless",
	kWukongDigEndless = "MonkeyDigEndless",
}

local DependingAssetsTypeNameMap = 
{
	[TileConst.kPortalEnter]	= {"flash/link_item.plist"},
	[TileConst.kPortalExit]		= {"flash/link_item.plist"},
	[TileConst.kFrosting] 		= {"flash/mapSnow.plist"},
	[TileConst.kFrosting1]		= {"flash/mapSnow.plist"},
	[TileConst.kFrosting2]		= {"flash/mapSnow.plist"},
	[TileConst.kFrosting3]		= {"flash/mapSnow.plist"},
	[TileConst.kFrosting4]		= {"flash/mapSnow.plist"},
	[TileConst.kFrosting5]		= {"flash/mapSnow.plist"},
	[TileConst.kLock] 			= {"flash/mapLock.plist"},
	[TileConst.kCrystal]		= {"flash/crystal_anim.plist"},
	[TileConst.kLight1] 		= {"flash/mapLight.plist"},
	[TileConst.kLight2] 		= {"flash/mapLight.plist"},
	[TileConst.kLight3] 		= {"flash/mapLight.plist"},
	[TileConst.kCoin]       	= {"flash/coin.plist"},
	[TileConst.kPoison]     	= {"flash/venom.plist"},
	[TileConst.kPoisonBottle]	= {"flash/venom.plist", "flash/PoisonBottle.plist","flash/octopusForbidden.plist"},
	[TileConst.kGreyCute]		= {"flash/ball_grey.plist"},
	[TileConst.kBrownCute]		= {"flash/ball_brown.plist", "flash/ball_grey.plist"},
	[TileConst.kRoost]			= {"flash/roost.plist"},
	[TileConst.kBalloon]		= {"flash/balloon.plist"},
	[TileConst.kDigGround_1]	= {"flash/dig_block.plist"},
	[TileConst.kDigGround_2]	= {"flash/dig_block.plist"},
	[TileConst.kDigGround_3]	= {"flash/dig_block.plist"},
	[TileConst.kDigJewel_1]		= {"flash/dig_block.plist"},
	[TileConst.kDigJewel_2]		= {"flash/dig_block.plist"},
	[TileConst.kDigJewel_3]		= {"flash/dig_block.plist"},
	[TileConst.kDigJewel_1_blue]= {"flash/dig_block.plist"},
	[TileConst.kDigJewel_2_blue]= {"flash/dig_block.plist"},
	[TileConst.kDigJewel_3_blue]= {"flash/dig_block.plist"},
	[TileConst.kGoldZongZi]		= {"flash/dig_block.plist"},
	[TileConst.kSuperBlocker]	= {"flash/dig_block.plist"},
	[TileConst.kAddMove]		= {"flash/add_move.plist"},
	[TileConst.kTileBlocker]	= {"flash/TileBlocker.plist"},
	[TileConst.kTileBlocker2]	= {"flash/TileBlocker.plist"},
	[TileConst.kBigMonster]		= {"flash/big_monster.plist", "flash/big_monster_ext.plist"},
	[TileConst.kBlackCute]		= {"flash/ball_black.plist"},
	[TileConst.kMimosaLeft]		= {"flash/mimosa.plist"},
	[TileConst.kMimosaRight]	= {"flash/mimosa.plist"},
	[TileConst.kMimosaUp]		= {"flash/mimosa.plist"},
	[TileConst.kMimosaDown]		= {"flash/mimosa.plist"},
	[TileConst.kKindMimosaLeft]		= {"flash/mimosa.plist"},
	[TileConst.kKindMimosaRight]	= {"flash/mimosa.plist"},
	[TileConst.kKindMimosaUp]		= {"flash/mimosa.plist"},
	[TileConst.kKindMimosaDown]		= {"flash/mimosa.plist"},
	[TileConst.kSnailSpawn]		= {"flash/snail.plist", "flash/snail_road.plist"},
	[TileConst.kSnail]			= {"flash/snail.plist", "flash/snail_road.plist"},
	[TileConst.kSnailCollect]	= {"flash/snail.plist", "flash/snail_road.plist"},
	--[TileConst.kHedgehog]  		= {"flash/snail.plist", "flash/hedgehog.plist","flash/hedgehog_road.plist", "flash/hedgehog_target.plist", "flash/christmas_other.plist",},
	[TileConst.kHedgehog]  		= {"flash/snail.plist", "flash/hedgehog_road.plist", "flash/hedgehog_target.plist", "flash/christmas_other.plist",},
	[TileConst.kMayDayBlocker1] = {"flash/boss_mayday.plist"},
	[TileConst.kMayDayBlocker2] = {"flash/boss_mayday.plist"},
	[TileConst.kMayDayBlocker3] = {"flash/boss_mayday.plist"},
	[TileConst.kMayDayBlocker4] = {"flash/boss_mayday.plist"},
	[TileConst.kRabbitProducer] = {"flash/rabbit.plist", "flash/scenes/gamePlaySceneUI/rabbitModeText.plist"},
	[TileConst.kMagicLamp]		= {"flash/magic_lamp.plist"},
	[TileConst.kHoneyBottle]	= {"flash/honey_bottle.plist"},
	[TileConst.kHoney]			= {"flash/honey_bottle.plist"},
	[TileConst.kAddTime]		= {"flash/add_time.plist"},
	[TileConst.kMagicTile]		= {"flash/magic_tile.plist"},
	[TileConst.kSand]			= {"flash/sand_idle_clean.plist", "flash/sand_move.plist"},
	[TileConst.kQuestionMark]	= {"flash/question_mark.plist"},
	[TileConst.kChain1]			= {"flash/ice_chain.plist"},
	[TileConst.kChain1_Up]		= {"flash/ice_chain.plist"},
	[TileConst.kChain1_Right]	= {"flash/ice_chain.plist"},
	[TileConst.kChain1_Down]	= {"flash/ice_chain.plist"},
	[TileConst.kChain1_Left]	= {"flash/ice_chain.plist"},
	[TileConst.kChain2]			= {"flash/ice_chain.plist"},
	[TileConst.kChain2_Up]		= {"flash/ice_chain.plist"},
	[TileConst.kChain2_Right]	= {"flash/ice_chain.plist"},
	[TileConst.kChain2_Down]	= {"flash/ice_chain.plist"},
	[TileConst.kChain2_Left]	= {"flash/ice_chain.plist"},
	[TileConst.kChain3]			= {"flash/ice_chain.plist"},
	[TileConst.kChain3_Up]		= {"flash/ice_chain.plist"},
	[TileConst.kChain3_Right]	= {"flash/ice_chain.plist"},
	[TileConst.kChain3_Down]	= {"flash/ice_chain.plist"},
	[TileConst.kChain3_Left]	= {"flash/ice_chain.plist"},
	[TileConst.kChain4]			= {"flash/ice_chain.plist"},
	[TileConst.kChain4_Up]		= {"flash/ice_chain.plist"},
	[TileConst.kChain4_Right]	= {"flash/ice_chain.plist"},
	[TileConst.kChain4_Down]	= {"flash/ice_chain.plist"},
	[TileConst.kChain4_Left]	= {"flash/ice_chain.plist"},
	[TileConst.kChain5]			= {"flash/ice_chain.plist"},
	[TileConst.kChain5_Up]		= {"flash/ice_chain.plist"},
	[TileConst.kChain5_Right]	= {"flash/ice_chain.plist"},
	[TileConst.kChain5_Down]	= {"flash/ice_chain.plist"},
	[TileConst.kChain5_Left]	= {"flash/ice_chain.plist"},
	[TileConst.kMagicStone_Up]	= {"flash/magic_stone.plist"},
	[TileConst.kMagicStone_Right]= {"flash/magic_stone.plist"},
	[TileConst.kMagicStone_Down]= {"flash/magic_stone.plist"},
	[TileConst.kMagicStone_Left]= {"flash/magic_stone.plist"},
	[TileConst.kMoveTile]		= {"flash/map_move_tile.plist"},
	[TileConst.kBottleBlocker]		= {"flash/bottle_blocker.plist"},
	[TileConst.kCrystalStone]		= {"flash/crystal_stone.plist"},
	[TileConst.kWukong]		= {"flash/wukong.plist" },
	[TileConst.kTotems]			= {"flash/tile_totems.plist"},
	[TileConst.kLotusLevel1]			= {"flash/lotus.plist"},
	[TileConst.kLotusLevel2]			= {"flash/lotus.plist"},
	[TileConst.kLotusLevel3]			= {"flash/lotus.plist"},
	[TileConst.kSuperCute]			= {"flash/ball_super.plist"},
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
	self.addMoveBase = GamePlayConfig_Add_Move_Base   -- 气球爆炸增加的步数

	self.hasDropDownUFO = false                     --是否有UFO

	self.rabbitInitNum = 0							-- 初始兔子数
	self.honeys = 0    

	self.dropBuff = nil								-- 神奇掉落规则    
	self.tileMoveCfg = nil      					-- 移动地块配置  
	self.dropCrystalStoneTypes = nil
	self.singleDropCfg = nil						-- 独立掉落口掉落规则（颜色）{"itemId":[color1, color2, ...], ...}
end

function LevelConfig:loadConfig(level, config)
	self.level = level 							--等级
	self.gameMode = config.gameModeName				--游戏模式
	self.numberOfColors = config.numberOfColours	--颜色数量

	self.crossStrengthCfg = config.crossStrengthCfg --障碍附加参数（如妖精瓶子的等级）

	self.tileMap = TileMetaData:convertArrayFromBitToTile(config.tileMap, config.tileMap2, self.crossStrengthCfg)	--将配置的数据赋值给tilemap。地形信息
	if config.uncertainCfg1 and config.uncertainCfg2 then
		self.uncertainCfg1 = UncertainCfgMeta:create(config.uncertainCfg1)                      --boss掉血产生的问号障碍配置
		self.uncertainCfg2 = UncertainCfgMeta:create(config.uncertainCfg2)                      --boss死亡产生的问号障碍配置
	end

	if config.snailCfg and config.snailCfg.initNum and config.snailCfg.routeRawData then
		self.snailInitNum = config.snailCfg.initNum
		self.snailMoveToAdd = config.snailCfg.moveToAdd
		self.routeRawData = SnailConfigData:convertArrayFromBitToTile(config.snailCfg.routeRawData)
	end

	if config.hedgehogConfig and config.hedgehogConfig.routeRawData then
		self.snailInitNum = 1
		self.routeRawData = SnailConfigData:convertArrayFromBitToTile(config.hedgehogConfig.routeRawData)
		self.digExtendRouteData = SnailConfigData:convertArrayFromBitToTile(config.hedgehogConfig.digExtendRouteData, true)
	end

	if config.hedgehogBoxCfg then
		self.hedgehogBoxCfg = HedgehogBoxCfg:create(config.hedgehogBoxCfg)
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
	self.dropBuff = config.dropBuff
	self.tileMoveCfg = TileMoveConfig:create(config.moveTileCfg)
	self.dropCrystalStoneTypes = self:getRealColorValues(config.dropCrystalStoneTypes)
	self.singleDropCfg = self:initSingleDropConfig(config.singleDrop, config.dropCrystalStoneTypes)

	self.rabbitInitNum = config.rabbitInitNum   	-- 初始兔子数量
	self.honeys = config.honeys                     -- 蜂蜜罐转化为蜂蜜的数量
	if self.timeLimit == nil then 
		self.timeLimit = 0;
	end
	self.addTime = config.addTime or 5 --时间关每个单位增加时间
    if self.gameMode == AnimalGameMode.kClassic then				--经典玩法--时间到则结束
	elseif self.gameMode == AnimalGameMode.kOrder or self.gameMode == AnimalGameMode.kSeaOrder then				--指定物品消除指定次数
		self.orderMap = config.orderList 			
	elseif self.gameMode == AnimalGameMode.kDropDown or self.gameMode == AnimalGameMode.kTaskForUnlockArea then 			--下落型玩法
		self.ingredients = config.ingredients
		self.numIngredientsOnScreen = config.numIngredientsOnScreen
		self.ingredientSpawnDensity = config.ingredientSpawnDensity
	elseif self.gameMode == AnimalGameMode.kDigTime then			--时间限制型挖掘
		self.digTileMap = TileMetaData:convertArrayFromBitToTile(config.digTileMap or {}, config.digTileMap2)
		self.layerAmount = 0						--挖掘层数
		self.clearTargetLayers = config.clearTargetLayers	--目标层数--达到挖掘目标层数 胜利
	elseif self.gameMode == AnimalGameMode.kDigMove then			--步数限制型挖掘
		self.digTileMap = TileMetaData:convertArrayFromBitToTile(config.digTileMap or {}, config.digTileMap2)
		self.layerAmount = 0						--挖掘层数
		self.clearTargetLayers = config.clearTargetLayers	--目标层数--达到挖掘目标层数 胜利
	elseif self.gameMode == AnimalGameMode.kDigMoveEndless then
		self.digTileMap = TileMetaData:convertArrayFromBitToTile(config.digTileMap or {}, config.digTileMap2)
		self.clearTargetLayers = config.clearTargetLayers
		self.layerAmount = 0
	elseif self.gameMode == AnimalGameMode.kMaydayEndless 
		or self.gameMode == AnimalGameMode.kHalloween 
		or self.gameMode == AnimalGameMode.kWukongDigEndless then
		self.digTileMap = TileMetaData:convertArrayFromBitToTile(config.digTileMap or {}, config.digTileMap2)
		self.clearTargetLayers = config.clearTargetLayers
		self.layerAmount = 0
		if self.gameMode == AnimalGameMode.kHalloween then
			self.dragonBoatPropGen = config.dragonBoatPropGen	-- 端午关卡道具掉落配置
		end

		if self.gameMode == AnimalGameMode.kWukongDigEndless then
			self.monkeyChestConfig = config.monkeyChestConfig
		end
	elseif self.gameMode == AnimalGameMode.kHedgehogDigEndless then
		self.digTileMap = TileMetaData:convertArrayFromBitToTile(config.digTileMap or {}, config.digTileMap2)
		self.clearTargetLayers = config.clearTargetLayers
		self.layerAmount = 0
	end
end

function LevelConfig:initSingleDropConfig(singleDrop, dropCrystalStoneTypes)
	local ret = {}
	if dropCrystalStoneTypes and #dropCrystalStoneTypes > 0 then -- 将水晶石也加到统一处理
		ret[TileConst.kCrystalStone] = LevelConfig:getRealColorValues(dropCrystalStoneTypes)
	end

	if singleDrop and table.size(singleDrop) > 0 then
		for itemId, colors in pairs(singleDrop) do
			if colors and #colors > 0 then
				ret[tonumber(itemId)+1] = LevelConfig:getRealColorValues(colors)
			end
		end
	end
	return ret
end

function LevelConfig:getRealColorValues(colors)
	local ret = {}
	if colors and #colors > 0 then
		for _, v in pairs(colors) do
			local c = AnimalTypeConfig.convertIndexToColorType(v)
			if c then table.insert(ret, c) end
		end
	end
	return ret
end

function LevelConfig:isIceOrSnowOrHoneyLevel()
	if self.gameMode == AnimalGameMode.kLightUp then
		return true
	end

	if self.orderMap then
		for i,v in ipairs(self.orderMap) do
			if v.k == GameItemOrderType.kSpecialTarget.."_"..GameItemOrderType_ST.kSnowFlower or
			   v.k == GameItemOrderType.kOthers.."_"..GameItemOrderType_Others.kHoney then
			   return true
			end
		end
	end

	return false
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
				for tileProperty, resList in pairs(DependingAssetsTypeNameMap) do
					if tile:hasProperty(tileProperty) then
						for k,v in pairs(resList) do 
							resNameMap[v] = true
						end
						
					end
				end
			end
		end
	end

	calculateTileNeedAssets(self.tileMap)

	----------问号障碍需要素材
	local function calculateUncertainCfgNeedAssets( uncertainCfg )
		-- body
		if not uncertainCfg then return end
		resNameMap["flash/question_mark.plist"] = true
		for k, v in pairs(uncertainCfg.allItemList) do
			for tileProperty, resList in pairs(DependingAssetsTypeNameMap) do 
				if tileProperty == v.changeItem + 1 then 
					for k1, v1 in pairs(resList) do
						resNameMap[v1] = true
					end
				end
			end
		end
	end
	calculateUncertainCfgNeedAssets(self.uncertainCfg1)
	calculateUncertainCfgNeedAssets(self.uncertainCfg2)
	
	----------掉落素材
	for k,v in pairs(self.dropRules) do
		if DependingAssetsTypeNameMap[v.itemID + 1] then
			for _, res in pairs(DependingAssetsTypeNameMap[v.itemID + 1]) do 
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
		resNameMap["flash/ufo_rocket.plist"] = true
		-- resNameMap["flash/UFO.plist"] = true
	end

	--挖地关卡需要加载挖地云块素材，并且需要遍历digTileMap中的item类型信息
	if self.pm25 > 0 then
		resNameMap["flash/dig_block.plist"] = true
	end

	if self.gameMode == AnimalGameMode.kDigMove or self.gameMode == AnimalGameMode.kDigTime then
		calculateTileNeedAssets(self.digTileMap)
	elseif self.gameMode == AnimalGameMode.kDigMoveEndless or self.gameMode == AnimalGameMode.kMaydayEndless
	or self.gameMode == AnimalGameMode.kHalloween  or self.gameMode == AnimalGameMode.kHedgehogDigEndless
	or self.gameMode == AnimalGameMode.kWukongDigEndless
	 then
	 	if self.gameMode == AnimalGameMode.kHalloween  then
	 		-- resNameMap["flash/xmas_boss.plist"] = true
	 		-- resNameMap["flash/dragonboat_boss1.plist"] = true
	 		-- resNameMap["flash/dragonboat_boss2.plist"] = true
	 		-- resNameMap["flash/dragonboat_boss3.plist"] = true
	 		-- resNameMap["flash/qixi_boss.plist"] = true
			
			resNameMap["flash/add_five_step_ani.plist"] = true
			resNameMap["flash/dig_block.plist"] = true
			-- resNameMap["flash/halloween_2015.plist"] = true
			-- resNameMap["flash/boss_pumpkin.plist"] = true
			-- resNameMap["flash/boss_pumpkin_die.plist"] = true
			-- resNameMap["flash/boss_pumpkin_ghost_1.plist"] = true
			-- resNameMap["flash/boss_pumpkin_ghost_2.plist"] = true
			resNameMap["flash/ball_brown.plist"] = true
			resNameMap["flash/ball_grey.plist"] = true
			resNameMap["flash/venom.plist"] = true
			resNameMap["flash/mapLock.plist"] = true
			resNameMap["flash/coin.plist"] = true
			resNameMap["flash/venom.plist"] = true
			resNameMap["flash/PoisonBottle.plist"] = true
			resNameMap["flash/two_year_line_effect.plist"] = true
	 	end
	 	if self.gameMode == AnimalGameMode.kMaydayEndless  then
	 		
	 		resNameMap["flash/boss_mayday.plist"] = true
	 		resNameMap["flash/question_mark.plist"] = true
	 		-- resNameMap["flash/animation/spring_festival.plist"] = true
	 		--resNameMap["flash/animation/boss_cat_item.plist"] = true
	 		--resNameMap["flash/animation/boss_cat_item_use.plist"] = true
	 	end

	 	if self.gameMode == AnimalGameMode.kHedgehogDigEndless then
	 		resNameMap["flash/hedgehog_road.plist"] = true
	 		--FrameLoader:loadArmature("skeleton/hedgehog_V3_animation")
			resNameMap["flash/ball_brown.plist"] = true
			resNameMap["flash/ball_grey.plist"] = true
			resNameMap["flash/venom.plist"] = true
			resNameMap["flash/mapLock.plist"] = true
			resNameMap["flash/coin.plist"] = true
			resNameMap["flash/venom.plist"] = true
			resNameMap["flash/PoisonBottle.plist"] = true
	 	end
		resNameMap["flash/add_move.plist"] = true
		calculateTileNeedAssets(self.digTileMap)
	elseif self.gameMode == AnimalGameMode.kRabbitWeekly then
		-- TODO
		resNameMap["flash/ufo_rocket.plist"] = true
	elseif self.gameMode == AnimalGameMode.kSeaOrder then
		resNameMap["flash/sea_animal.plist"] = true
	end

	if self:isIceOrSnowOrHoneyLevel() then
		resNameMap["flash/animation/targetTips.plist"] = true
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

function LevelDataManager:getMainLevelTotalStar()
	if self.mainLevelTotalStar == nil then
		local starSum = 0
		local maxId = MetaManager.getInstance():getMaxNormalLevelByLevelArea()
		local minId = 1
		for levelId = minId, maxId do
			starSum = starSum + #(LevelMapManager.getInstance():getMeta(levelId).gameData.scoreTargets)
		end
		self.mainLevelTotalStar = starSum
	end
	return self.mainLevelTotalStar
end

function LevelDataManager:getHiddenLevelTotalStar()
	if self.hiddenLevelTotalStar == nil then
		local starSum = 0
		local levelIdGroup = MetaManager.getInstance():getHideAreaLevelIds()
		table.each(
			levelIdGroup,
			function (levelId)
				if levelId then
					local levelData = LevelMapManager.getInstance():getMeta(levelId)
					if levelData and levelData.gameData and levelData.gameData.scoreTargets then
						starSum = starSum + #(levelData.gameData.scoreTargets)
					end
				end
			end
		)
		self.hiddenLevelTotalStar = starSum
	end
	return self.hiddenLevelTotalStar
end

local ldm__ = nil

function LevelDataManager.sharedLevelData()
	if not ldm__ then
		ldm__ = LevelDataManager.new()
	end
	return ldm__
end
