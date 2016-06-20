-- Filename: HeroFightUtil.lua
-- Author: fang
-- Date: 2013-09-13
-- Purpose: 该文件用于: 武将战斗力计算

module("HeroFightUtil", package.seeall)

-- 0: 打开武将原始数据模块
require "script/model/hero/HeroModel"
-- 1: 打开武将属性数据表
require "db/DB_Heroes"
-- 2: 打开连携属性数据表
require "db/DB_Union_profit"
-- 3: 打开觉醒属性数据表
require "db/DB_Awake_ability"
-- 4: 打开装备属性数据表
require "db/DB_Item_arm"
-- 7: 打开宝物属性数据表
require "db/DB_Item_treasure"
-- 8: 套装数据表
require "db/DB_Suit"
-- 9: 打开恶魔果实表
require "db/DB_Item_devilfruit"
-- 10 打开专属宝物表
require "db/DB_Item_exclusive"
-- 打开判断武将是否在阵上的方法库 HeroPublicUtil
require "script/module/partner/HeroPublicUtil"

-- 天命系统

require "script/model/DataCache"
require "script/module/formation/FormationUtil"

-- zhangqi, 2015-06-17, 缓存每次调用 getAllForceValuesByHid 得到的单个伙伴的战斗力和属性值
-- 避免从阵容跳转到装备强化或更换等UI，更新战斗力后返回阵容界面时需要刷新伙伴三围属性的重复计算
local _tbFightForce = {}

-- 攻防属性计算公式
-- 计算攻防属性值方法
local m_hp=1  				-- 生命
local m_physicalAttack=2 		-- 物理攻击(deprecated)
local m_magicAttack=3			-- 法术攻击(deprecated)
local m_physicalDefend=4		-- 物理防御
local m_magicDefend=5			-- 法术防御
local m_command=6				-- 统帅
local m_strength=7			-- 武力
local m_intelligence=8		-- 智力
local m_generalAttack=9		-- 通用攻击
local m_talent_hp=10			-- 生命天赋
local m_talent_phyAtt=11		-- 物攻天赋
local m_talent_magAtt=12		-- 魔攻天赋
local m_talent_phyDef=13		-- 物防天赋
local m_talent_magDef=14		-- 魔防天赋
-- 类型属性影射表

	-- id_92 = {92, "物攻", "物攻", 3, },
	-- id_93 = {93, "魔攻", "魔攻", 3, },
	-- id_94 = {94, "物防", "物防", 3, },
	-- id_95 = {95, "魔防", "魔防", 3, },
	-- id_96 = {96, "生命", "生命", 3, },

local _attributesMap = {
	{1, 11, "hp", "baseLife", "lifePL", 96,"percentHP"},						
	{2, 12, "physical_attack", "basePhyAtt", "phyAttPL", 92,"percentPhyAtt"},
	{3, 13, "magic_attack", "baseMagAtt", "magAttPL", 93,"percentMagAtt"},
	{4, 14, "physical_defend", "basePhyDef", "phyDefPL", 94,"percentPhyDef"},	
	{5, 15, "magic_defend", "baseMagDef", "magDefPL", 95,"percentMagDef"},	
	{6, 16, "command", "XXXXXX", "XXXXXX", "XXXXXX"},
	{7, 17, "strength", "XXXXXX", "XXXXXX", "XXXXXX"},
	{8, 18, "intelligence", "XXXXXX", "XXXXXX", "XXXXXX"},
	{9, 19, "general_attack", "baseGenAtt", "genAttPL", "XXXXXX"},
	{10, 20, "talent_hp", "XXXXXX", "XXXXXX", "XXXXXX"},
	{11, 21, "talent_physical_attack", "XXXXXX", "XXXXXX", "XXXXXX"},
	{12, 22, "talent_magic_attack", "XXXXXX", "XXXXXX", "XXXXXX"},
	{13, 23, "talent_physical_defend", "XXXXXX", "XXXXXX", "XXXXXX"},
	{14, 24, "talent_magic_defend", "XXXXXX", "XXXXXX", "XXXXXX"},
}

 -- + 宠物系统(pet)提供的通用攻击基础值
 function getPetValue(tParam)
 	local nBaseValue=0
 	local nPercentValue=0

 	local tPetValue = PetUtil.getAllPetProperty()
 	local map = tParam.map
 	if map[1] == _attributesMap[1][1] then
 		nBaseValue = tPetValue.life
 	elseif map[1] == _attributesMap[4][1] then
 		nBaseValue = tPetValue.phyDef
 	elseif map[1] == _attributesMap[5][1] then
 		nBaseValue = tPetValue.magDef
 	elseif map[1] == _attributesMap[9][1] then
 		nBaseValue = tPetValue.att
 	end

 	return nBaseValue, nPercentValue
 end


-- zhangqi, 2105-06-18, 每次重新计算战斗力前清除所有战斗力缓存
function clearAllForceCache()
	_tbFightForce = nil 
	_tbFightForce = {}
end

-- yucong 
function clearForceCacheWithHid( hid )
	local sHid = tostring(hid)
	if (_tbFightForce[sHid]) then
		_tbFightForce[sHid] = nil
	end
end

-- zhangqi, 2015-06-17, 给 UserModel计算战斗力使用，每次重新计算前先清除缓存
function getAllForceValuesByHidNew( hid,resetForceParts )
	local sHid = tostring(hid)
	_tbFightForce[sHid] = getAllForceValuesByHid(hid,resetForceParts)
	return _tbFightForce[sHid]
end

function getAllForceValuesByHid(hid,resetForceParts)
	local sHid = tostring(hid)
	if (_tbFightForce[sHid]) then -- zhangqi, 2015-06-17
		return _tbFightForce[sHid]
	end

	require "script/model/hero/HeroModel"
	local hero_data = HeroModel.getHeroByHid(hid)
	_tbFightForce[sHid] = getNewAllForceValues(hero_data,resetForceParts)

	return _tbFightForce[sHid]
end

--
function getDefaultValue( ... )

	local nBaseValueTb = {}
	local nPercentValueTb = {}

	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	local nPercentHpValue = 0  
	local nPercentMagicDefendValue = 0
	local nPercentPhysicalDefendValue = 0
	local nPercentMagicAttackValue = 0
	local nPercentPhysicalAttackValue = 0



	nBaseValueTb.m_hp = nBaseHpValue
	nPercentValueTb.m_hp = nPercentHpValue

	nBaseValueTb.m_magicDefend = nBaseMagicDefendValue
	nPercentValueTb.m_magicDefend = nPercentMagicDefendValue

	nBaseValueTb.m_physicalDefend = nBasePhysicalDefendValue
	nPercentValueTb.m_physicalDefend = nPercentPhysicalDefendValue

	nBaseValueTb.m_magicAttack = nBaseMagicAttackValue
	nPercentValueTb.m_magicAttack = nPercentMagicAttackValue

	nBaseValueTb.m_physicalAttack = nBasePhysicalAttackValue
	nPercentValueTb.m_physicalAttack = nPercentPhysicalAttackValue

	return nBaseValueTb,nPercentValueTb
end



-- + 恶魔果实增加的 通用属性
function getNewDevilFruitValue( tParam )
	local nBaseValueTb = {}
	local nPercentValueTb = {}
 	local db_hero = tParam.db_hero
 	local map = tParam.map
 	local devilfruitId  = db_hero.devilfruit_id

 	function returnBaseValue( id, map,arrAttriValue)
	 	local nBaseValue=0
 		local nPercentValue=0

		if id == map[1] then
			nBaseValue = nBaseValue + tonumber(arrAttriValue)
		elseif id == map[2] then
			nPercentValue = nPercentValue + tonumber(arrAttriValue)
		end
		return nBaseValue,nPercentValue
 	end

 	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	local nPercentHpValue = 0  
	local nPercentMagicDefendValue = 0
	local nPercentPhysicalDefendValue = 0
	local nPercentMagicAttackValue = 0
	local nPercentPhysicalAttackValue = 0


 	if devilfruitId then
 		local tempStr_      = lua_string_split(devilfruitId,"|")
        local db_fruit     = DB_Item_devilfruit.getDataById(tempStr_[2])
        local db_awake     = DB_Awake_ability.getDataById(db_fruit.awake_ability_ID)
     	
     	local arrAttriIds = {}
		local arrAttriValues = {}
		
		if db_awake.attri_ids then
			arrAttriIds = string.split(db_awake.attri_ids, ",")
			arrAttriValues = string.split(db_awake.attri_values, ",")
		end
		for i=1, #arrAttriIds do
			local id = tonumber(arrAttriIds[i])
			-- 生命
			local map=_attributesMap[m_hp]
			local BaseHpValue,PercentValue = returnBaseValue( id,map,arrAttriValues[i] )
			nBaseHpValue = nBaseHpValue + BaseHpValue
			nPercentHpValue = nPercentHpValue + PercentValue

			-- 魔防
			map=_attributesMap[m_magicDefend]
			local BaseMagicDefendValue,PercentMagicDefendValue =  returnBaseValue( id,map,arrAttriValues[i] )
			nBaseMagicDefendValue = nBaseMagicDefendValue + BaseMagicDefendValue
			nPercentMagicDefendValue = nPercentMagicDefendValue + PercentMagicDefendValue
			-- 物防
			map=_attributesMap[m_physicalDefend]
			local BasePhysicalDefendValue,PercentPhysicalDefendValue =  returnBaseValue( id,map,arrAttriValues[i] )
			nBasePhysicalDefendValue = nBasePhysicalDefendValue + BasePhysicalDefendValue
			nPercentPhysicalDefendValue = nPercentPhysicalDefendValue + PercentPhysicalDefendValue
			-- 魔攻
			map=_attributesMap[m_magicAttack]
			local BaseMagicAttackValue,PercentMagicAttackValue =  returnBaseValue( id,map ,arrAttriValues[i])
			nBaseMagicAttackValue = nBaseMagicAttackValue + BaseMagicAttackValue
			nPercentMagicAttackValue = nPercentMagicAttackValue + PercentMagicAttackValue
			-- 物攻
			map=_attributesMap[m_physicalAttack]
			local BasePhysicalAttackValue ,PercentPhysicalAttackValue= returnBaseValue( id,map,arrAttriValues[i] )
			nBasePhysicalAttackValue = nBasePhysicalAttackValue + BasePhysicalAttackValue
			nPercentPhysicalAttackValue = nPercentPhysicalAttackValue + PercentPhysicalAttackValue
		end
 	end
    nBaseValueTb.m_hp = nBaseHpValue
	nPercentValueTb.m_hp = nPercentHpValue

	nBaseValueTb.m_magicDefend = nBaseMagicDefendValue
	nPercentValueTb.m_magicDefend = nPercentMagicDefendValue

	nBaseValueTb.m_physicalDefend = nBasePhysicalDefendValue
	nPercentValueTb.m_physicalDefend = nPercentPhysicalDefendValue

	nBaseValueTb.m_magicAttack = nBaseMagicAttackValue
	nPercentValueTb.m_magicAttack = nPercentMagicAttackValue

	nBaseValueTb.m_physicalAttack = nBasePhysicalAttackValue
	nPercentValueTb.m_physicalAttack = nPercentPhysicalAttackValue

	return nBaseValueTb, nPercentValueTb
end 

-- 强化大师 品级大师 ,附魔大师， 宝物强化大师， 宝物精炼大师，增加的属性
function getNewMasterValue( tParam )
	local nBaseValueTb = {}
	local nPercentValueTb = {}

 	local map = tParam.map
 	-- require "script/module/formation/MainEquipMasterCtrl"
	local tbAttr = MainEquipMasterCtrl.fnGetAttrTbByHeroInfo(tParam)

	function returnBaseValue( map, affixId,arrAttriValues)
		local nBaseValue=0
 		local nPercentValue=0
		if affixId == map[1] then
			nBaseValue = nBaseValue + tonumber(arrAttriValues[2])
		elseif affixId == map[2] then
			nPercentValue = nPercentValue + tonumber(arrAttriValues[2])
		end
		return nBaseValue,nPercentValue
	end

 	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	local nPercentHpValue = 0  
	local nPercentMagicDefendValue = 0
	local nPercentPhysicalDefendValue = 0
	local nPercentMagicAttackValue = 0
	local nPercentPhysicalAttackValue = 0

	for _, tbTemp in ipairs(tbAttr or {}) do
		for _, arrAttriValues in ipairs(tbTemp or {}) do
			local affixId = tonumber(arrAttriValues[1])
			-- 生命
			local map=_attributesMap[m_hp]
			local BaseHpValue,PercentValue = returnBaseValue( map, affixId,arrAttriValues)
			nBaseHpValue = nBaseHpValue + BaseHpValue
			nPercentHpValue = nPercentHpValue + PercentValue

			-- 魔防
			map=_attributesMap[m_magicDefend]
			local BaseMagicDefendValue,PercentMagicDefendValue = returnBaseValue( map, affixId,arrAttriValues)
			nBaseMagicDefendValue = nBaseMagicDefendValue + BaseMagicDefendValue
			nPercentMagicDefendValue = nPercentMagicDefendValue + PercentMagicDefendValue
			-- 物防
			map=_attributesMap[m_physicalDefend]
			local BasePhysicalDefendValue,PercentPhysicalDefendValue =  returnBaseValue( map, affixId,arrAttriValues)
			nBasePhysicalDefendValue = nBasePhysicalDefendValue + BasePhysicalDefendValue
			nPercentPhysicalDefendValue = nPercentPhysicalDefendValue + PercentPhysicalDefendValue
			-- 魔攻
			map=_attributesMap[m_magicAttack]
			local BaseMagicAttackValue,PercentMagicAttackValue =  returnBaseValue( map, affixId,arrAttriValues)
			nBaseMagicAttackValue = nBaseMagicAttackValue + BaseMagicAttackValue
			nPercentMagicAttackValue = nPercentMagicAttackValue + PercentMagicAttackValue
			-- 物攻
			map=_attributesMap[m_physicalAttack]
			local BasePhysicalAttackValue ,PercentPhysicalAttackValue=  returnBaseValue( map, affixId,arrAttriValues)
			nBasePhysicalAttackValue = nBasePhysicalAttackValue + BasePhysicalAttackValue
			nPercentPhysicalAttackValue = nPercentPhysicalAttackValue + PercentPhysicalAttackValue

		end
	end
	nBaseValueTb.m_hp = nBaseHpValue
	nPercentValueTb.m_hp = nPercentHpValue

	nBaseValueTb.m_magicDefend = nBaseMagicDefendValue
	nPercentValueTb.m_magicDefend = nPercentMagicDefendValue

	nBaseValueTb.m_physicalDefend = nBasePhysicalDefendValue
	nPercentValueTb.m_physicalDefend = nPercentPhysicalDefendValue

	nBaseValueTb.m_magicAttack = nBaseMagicAttackValue
	nPercentValueTb.m_magicAttack = nPercentMagicAttackValue

	nBaseValueTb.m_physicalAttack = nBasePhysicalAttackValue
	nPercentValueTb.m_physicalAttack = nPercentPhysicalAttackValue

	return nBaseValueTb, nPercentValueTb
end


-- 武将本身基础值
function getNewHeroValue(tParam)
-- 返回值，初始化为0
	local nBaseValueTb = {}
	local nPercentValueTb = {}

	local nBaseValue=0
	local nPercentValue=0
	local db_hero = tParam.db_hero
	-- 武将进阶次数
	local evolve_level = tonumber(tParam.evolve_level)
	local nHeroLevel =	tonumber(tParam.level)
-- 进阶基础值系数 advanced_base_coefficient
-- 武将基础通用攻击 base_general_attack
-- 进阶初始等级 advanced_begin_lv
-- 进阶间隔等级 advanced_interval_lv
	-- local map=tParam.map
	local function returnBaseValue( map )
		local base = 0
		if db_hero["base_"..map[3]] then
			base = db_hero["base_"..map[3]]
		end
		local grow=0
		if db_hero[map[3].."_grow"] then
			grow = db_hero[map[3].."_grow"]
		end
	
		nBaseValue = (base*(1+db_hero.advanced_base_coefficient*evolve_level/10000))
			+ grow*evolve_level/200*((db_hero.advanced_begin_lv)*2+ db_hero.advanced_interval_lv*(evolve_level-1))
			+ (nHeroLevel-1)*grow/100
		nBaseValue = math.floor(nBaseValue)

		return nBaseValue
	end 

	-- 生命
	local map = _attributesMap[m_hp]
	local nBaseValue= returnBaseValue(map)

	nBaseValueTb.m_hp = nBaseValue
	nPercentValueTb.m_hp = nPercentValue

	-- 魔防
	map=_attributesMap[m_magicDefend]
	nBaseValue= returnBaseValue(map)

	nBaseValueTb.m_magicDefend = nBaseValue
	nPercentValueTb.m_magicDefend = nPercentValue

	-- 物防
	map=_attributesMap[m_physicalDefend]
	nBaseValue= returnBaseValue(map)

	nBaseValueTb.m_physicalDefend = nBaseValue
	nPercentValueTb.m_physicalDefend = nPercentValue

	-- 魔攻
	map=_attributesMap[m_magicAttack]
	nBaseValue= returnBaseValue(map)

	nBaseValueTb.m_magicAttack = nBaseValue
	nPercentValueTb.m_magicAttack = nPercentValue

	-- 物攻
	map=_attributesMap[m_physicalAttack]
	nBaseValue= returnBaseValue(map)

	nBaseValueTb.m_physicalAttack = nBaseValue
	nPercentValueTb.m_physicalAttack = nPercentValue

	return nBaseValueTb, nPercentValueTb
end

-- 装备，连携(必须在阵上才有加成), 其它系统都有加成
-- 连携属性(union_profit)提供的"通用攻击基础值"，"通用攻击百分比"
function getNewUnionProfitValue(tParam)
    local nBaseValueTb = {}
    local nPercentValueTb = {}

    nBaseValueTb.m_hp = 0
	nPercentValueTb.m_hp = 0

	nBaseValueTb.m_magicDefend = 0
	nPercentValueTb.m_magicDefend = 0

	nBaseValueTb.m_physicalDefend = 0
	nPercentValueTb.m_physicalDefend = 0

	nBaseValueTb.m_magicAttack = 0
	nPercentValueTb.m_magicAttack = 0

	nBaseValueTb.m_physicalAttack = 0
	nPercentValueTb.m_physicalAttack = 0

	local db_hero = tParam.db_hero
	local map = tParam.map
	-- 判断是否存在连携属性，如果不存在则直接返回0
	if db_hero.link_group1 == nil then
		return nBaseValueTb, nPercentValueTb
	end
	local arrUnionIds = string.split(db_hero.link_group1, ",")

	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	local nPercentHpValue = 0  
	local nPercentMagicDefendValue = 0
	local nPercentPhysicalDefendValue = 0
	local nPercentMagicAttackValue = 0
	local nPercentPhysicalAttackValue = 0


	local function returnBaseValue( map,nums,tquality,ids,db_hero )
		local nBaseValue = 0
		local nPercentValue = 0
		local index = 1
		for i,v in ipairs(tquality or {}) do
			if tonumber(v) == tonumber(db_hero.heroQuality) then
				index = i
				break
			end
		end

		for i=1, #ids do
			if tonumber(ids[i]) == map[1] then
				local tbNums = string.split(nums[i], "|")
				nBaseValue = nBaseValue + tonumber(nums[i])
				break
			end
		end
		for i=1, #ids do
			if tonumber(ids[i]) == map[2] then
				nPercentValue = nPercentValue + tonumber(nums[i])
				break
			end
		end

		for i=1, #ids do
			if tonumber(ids[i]) == map[6] then
				local tbNums = string.split(nums[index], "|")
				nPercentValue = nPercentValue + tonumber(tbNums[i])
				break
			end
		end
		return nBaseValue,nPercentValue
	end

	for i=1, #arrUnionIds do
		local unionId = arrUnionIds[i]
		local data = DB_Union_profit.getDataById(unionId)
		-- 判断生效条件
		local bIsValid = true
		-- 判断连携物品ID组
		local card_ids = string.split(data.union_card_ids, ",")
		for i=1, #card_ids do
			local type_modelId = string.split(card_ids[i], "|")
			local eUnionType = tonumber(type_modelId[1])

			if eUnionType == 1 then -- 卡牌连携
				--TimeUtil.timeStart("getUnionProfitValue_fnGetBookHtidByModelID first slow") -- 2015-06-10
				local type_htid  = HeroPublicUtil.fnGetBookHtidByModelID(type_modelId[2])-- 根据对应的modelId 获取对应的htid
				--TimeUtil.timeEnd()
				
				-- yucong 羁绊判断修改
				-- 判断曾经拥有过的伙伴是否有可达成的
				if (not HeroPublicUtil.isHeroOnceHaveWithHtid(type_htid)) then
					bIsValid = false
					break
				end
			elseif eUnionType == 2 then -- 物品连携
				if (tParam.hid and tParam.hid ~= 0) then
					bIsValid = HeroModel.checkTreasureStatus(tParam.hid, type_modelId[2])
					if not bIsValid then
						bIsValid = HeroModel.checkEquipStatus(tParam.hid, type_modelId[2])
					end
				else
					bIsValid = false
				end
				if not bIsValid then
					break
				end
			end
		end

		bIsValid = FormationUtil.isUnionActive(unionId, tParam.hid, db_hero.id)

		-- 如果生效条件成立，则读取相应基础值和加成值百分比
		if bIsValid then
			local ids = string.split(data.union_arribute_ids, ",")
			local nums = string.split(data.union_arribute_nums, ",") -- 3000|3000,4000|4000,5000|5000,5500|5500,6000|6000,6500|6500
			local tquality = string.split(data.quality, ",")

			-- 生命
			local map=_attributesMap[m_hp]
			local BaseHpValue,PercentValue = returnBaseValue( map,nums,tquality,ids,db_hero )
			nBaseHpValue = nBaseHpValue + BaseHpValue
			nPercentHpValue = nPercentHpValue + PercentValue

			-- 魔防
			map=_attributesMap[m_magicDefend]
			local BaseMagicDefendValue,PercentMagicDefendValue =  returnBaseValue( map,nums,tquality,ids,db_hero )
			nBaseMagicDefendValue = nBaseMagicDefendValue + BaseMagicDefendValue
			nPercentMagicDefendValue = nPercentMagicDefendValue + PercentMagicDefendValue
			-- 物防
			map=_attributesMap[m_physicalDefend]
			local BasePhysicalDefendValue,PercentPhysicalDefendValue = returnBaseValue( map,nums,tquality,ids,db_hero )
			nBasePhysicalDefendValue = nBasePhysicalDefendValue + BasePhysicalDefendValue
			nPercentPhysicalDefendValue = nPercentPhysicalDefendValue + PercentPhysicalDefendValue

			-- 魔攻
			map=_attributesMap[m_magicAttack]
			local BaseMagicAttackValue,PercentMagicAttackValue =  returnBaseValue( map,nums,tquality,ids,db_hero )
			nBaseMagicAttackValue = nBaseMagicAttackValue + BaseMagicAttackValue
			nPercentMagicAttackValue = nPercentMagicAttackValue + PercentMagicAttackValue

			-- 物攻
			map=_attributesMap[m_physicalAttack]
			local BasePhysicalAttackValue ,PercentPhysicalAttackValue= returnBaseValue( map,nums,tquality,ids,db_hero )
			nBasePhysicalAttackValue = nBasePhysicalAttackValue + BasePhysicalAttackValue
			nPercentPhysicalAttackValue = nPercentPhysicalAttackValue + PercentPhysicalAttackValue

		end
	end

	-- 返回连携属性加成的基础值、百分比值
	nBaseValueTb.m_hp = nBaseHpValue
	nPercentValueTb.m_hp = nPercentHpValue

	nBaseValueTb.m_magicDefend = nBaseMagicDefendValue
	nPercentValueTb.m_magicDefend = nPercentMagicDefendValue

	nBaseValueTb.m_physicalDefend = nBasePhysicalDefendValue
	nPercentValueTb.m_physicalDefend = nPercentPhysicalDefendValue

	nBaseValueTb.m_magicAttack = nBaseMagicAttackValue
	nPercentValueTb.m_magicAttack = nPercentMagicAttackValue

	nBaseValueTb.m_physicalAttack = nBasePhysicalAttackValue
	nPercentValueTb.m_physicalAttack = nPercentPhysicalAttackValue

	return nBaseValueTb,nPercentValueTb
end

-- 装备战斗力加成
function getNewArmValue(tParam)
	local nRetValue = 0
	local nPercentValue = 0

	local nBaseValueTb = {}
	local nPercentValueTb = {}

	if (not tParam.hid or tParam.hid == 0) then
		return getDefaultValue()
	end

	local tArrHeroes = HeroModel.getAllHeroes()
	local arms = tArrHeroes[tostring(tParam.hid)].equip.arming

	local bHpArrSuitStatus={}
	local bMagicDefendArrSuitStatus={}
	local bPhysicalDefendArrSuitStatus={}
	local bMagicAttackArrSuitStatus={}
	local bPhysicalAttackArrSuitStatus={}

	local function returnArmBaseValue( map,equiqAttr,armsItem,bArrSuitStatus )
		local PercentValue = 0
		local RetValue = 0
		local equiqAttackValue = 0

		-- 装备”基础通用攻击“
		if equiqAttr[map[4]] then
			equiqAttackValue = equiqAttr[map[4]]
		end
		-- 装备等级
		local level = tonumber(armsItem.va_item_text.armReinforceLevel)
		local percent = 0
		if equiqAttr[map[5]] then
			percent = equiqAttr[map[5]]
		end

		--算战力的时候加入了附魔提供的战力
		local m_tbAttr = ItemUtil.getEquipValueByIID(armsItem.item_id)
		equiqAttackValue =  tonumber(m_tbAttr[map[3]])
		logger:debug({m_tbAttr= m_tbAttr})
		PercentValue = PercentValue + (m_tbAttr[map[7]] or 0)
		logger:debug({PercentValue = PercentValue})
		-- 套装处理
		if equiqAttr.jobLimit and equiqAttr.jobLimit>0 and bArrSuitStatus[equiqAttr.jobLimit] == nil then
			local db_suit = DB_Suit.getDataById(equiqAttr.jobLimit)

			local arrSuitItems = string.split(db_suit.suit_items, ",")

			local lock_num=1
			for i=1, #arrSuitItems do
				if armsItem.item_template_id ~= arrSuitItems[i] then

					for kk, vv in pairs(arms) do
						if vv.item_template_id == arrSuitItems[i] then
							lock_num = lock_num + 1
						end
					end
				end
			end
			for ii=2, lock_num do 
				local astAttr = db_suit["astAttr"..(ii-1)]
				if astAttr then
					local typeValues = string.split(astAttr, ",")
					for i=1, #typeValues do
						local data = string.split(typeValues[i], "|")
						local nType = tonumber(data[1])
						local nValue = tonumber(data[2])

						if map[1] == nType then
							RetValue = RetValue + nValue 
						elseif map[2] == nType then
							PercentValue = PercentValue + nValue
						end

					end
				end
			end
			bArrSuitStatus[equiqAttr.jobLimit] = true
		end
		-- 装备潜能加成值
		local armPotence = armsItem.va_item_text.armPotence
		if armPotence ~= nil then
			local base = armPotence[tostring(map[1])]
			if base ~= nil then
				RetValue = RetValue + tonumber(base)
			end
			local percent = armPotence[tostring(map[2])]
			if percent ~= nil then
				PercentValue = PercentValue + tonumber(percent)
			end
		end
		RetValue = RetValue + (equiqAttackValue or 0)

		return RetValue,PercentValue
	end 


	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	local nPercentHpValue = 0  
	local nPercentMagicDefendValue = 0
	local nPercentPhysicalDefendValue = 0
	local nPercentMagicAttackValue = 0
	local nPercentPhysicalAttackValue = 0


	for k, v in pairs(arms) do
	-- if (type(v) == "table") then
		if (not table.isEmpty(v)) then -- zhangqi, 2015-01-08, isEmpty会判断是否table类型，同时判断是否为空避免意外报错
		-- 武将装备(item_arm).基础法术攻击
		local equiqAttr = DB_Item_arm.getDataById(v.item_template_id)
		-- 生命
		local map=_attributesMap[m_hp]
		local BaseHpValue,PercentValue =  returnArmBaseValue(map,equiqAttr,v,bHpArrSuitStatus)
		nBaseHpValue = nBaseHpValue + BaseHpValue
		nPercentHpValue = nPercentHpValue + PercentValue

		-- 魔防
		map=_attributesMap[m_magicDefend]
		local BaseMagicDefendValue,PercentMagicDefendValue = returnArmBaseValue(map,equiqAttr,v,bMagicDefendArrSuitStatus)

		nBaseMagicDefendValue = nBaseMagicDefendValue + BaseMagicDefendValue
		nPercentMagicDefendValue = nPercentMagicDefendValue + PercentMagicDefendValue
		-- 物防
		map=_attributesMap[m_physicalDefend]
		local BasePhysicalDefendValue,PercentPhysicalDefendValue = returnArmBaseValue(map,equiqAttr,v,bPhysicalDefendArrSuitStatus)
		nBasePhysicalDefendValue = nBasePhysicalDefendValue + BasePhysicalDefendValue
		nPercentPhysicalDefendValue = nPercentPhysicalDefendValue + PercentPhysicalDefendValue
		-- 魔攻
		map=_attributesMap[m_magicAttack]
		local BaseMagicAttackValue,PercentMagicAttackValue = returnArmBaseValue(map,equiqAttr,v,bMagicAttackArrSuitStatus)
		nBaseMagicAttackValue = nBaseMagicAttackValue + BaseMagicAttackValue
		nPercentMagicAttackValue = nPercentMagicAttackValue + PercentMagicAttackValue
		-- 物攻
		map=_attributesMap[m_physicalAttack]
		local BasePhysicalAttackValue ,PercentPhysicalAttackValue= returnArmBaseValue(map,equiqAttr,v,bPhysicalAttackArrSuitStatus)
		nBasePhysicalAttackValue = nBasePhysicalAttackValue + BasePhysicalAttackValue
		nPercentPhysicalAttackValue = nPercentPhysicalAttackValue + PercentPhysicalAttackValue
			
		end
	end

	nBaseValueTb.m_hp = nBaseHpValue
	nPercentValueTb.m_hp = nPercentHpValue

	nBaseValueTb.m_magicDefend = nBaseMagicDefendValue
	nPercentValueTb.m_magicDefend = nPercentMagicDefendValue

	nBaseValueTb.m_physicalDefend = nBasePhysicalDefendValue
	nPercentValueTb.m_physicalDefend = nPercentPhysicalDefendValue

	nBaseValueTb.m_magicAttack = nBaseMagicAttackValue
	nPercentValueTb.m_magicAttack = nPercentMagicAttackValue

	nBaseValueTb.m_physicalAttack = nBasePhysicalAttackValue
	nPercentValueTb.m_physicalAttack = nPercentPhysicalAttackValue

	return nBaseValueTb, nPercentValueTb
	
end

-- 时装战斗力加成
function getNewDressValue(tParam)
	local nRetValue = 0
	local nPercentValue = 0

	local nBaseValueTb = {}
	local nPercentValueTb = {}

	if (not tParam.hid or tParam.hid == 0) then
		return getDefaultValue()
	end

	local tArrHeroes = HeroModel.getAllHeroes()
	local dress = tArrHeroes[tostring(tParam.hid)].equip.dress

	local function returnDressBaseValue( map,baseAffixItem )
		
		if tonumber(baseAffixItem[1]) == map[1] then
			nRetValue = nRetValue + tonumber(baseAffixItem[2])
		end
		return nRetValue
	end 


	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	for k, v in pairs(dress or {}) do
		if type(v) =="table" then
			require "db/DB_Item_dress"
			local db = DB_Item_dress.getDataById(v.item_template_id)
			if db then
				local baseAffixes = string.split(db.baseAffix, ",")
				for i=1, #baseAffixes do
					local item = string.split(baseAffixes[i], "|")
					-- 生命
					local map=_attributesMap[m_hp]
					nBaseHpValue = nBaseHpValue + returnBaseValue(map,item)
					-- 魔防
					map=_attributesMap[m_magicDefend]
					nBaseMagicDefendValue = nBaseMagicDefendValue + returnBaseValue(map,item)
					-- 物防
					map=_attributesMap[m_physicalDefend]
					nBasePhysicalDefendValue = nBasePhysicalDefendValue + returnBaseValue(map,item)
					-- 魔攻
					map=_attributesMap[m_magicAttack]
					nBaseMagicAttackValue = nBaseMagicAttackValue + returnBaseValue(map,item)
					-- 物攻
					map=_attributesMap[m_physicalAttack]
					nBasePhysicalAttackValue = nBasePhysicalAttackValue + returnBaseValue(map,item)

				end
			end
		end
	end

	nBaseValueTb.m_hp = nBaseHpValue
	nPercentValueTb.m_hp = nPercentValue

	nBaseValueTb.m_magicDefend = nBaseMagicDefendValue
	nPercentValueTb.m_magicDefend = nPercentValue

	nBaseValueTb.m_physicalDefend = nBasePhysicalDefendValue
	nPercentValueTb.m_physicalDefend = nPercentValue

	nBaseValueTb.m_magicAttack = nBaseMagicAttackValue
	nPercentValueTb.m_magicAttack = nPercentValue

	nBaseValueTb.m_physicalAttack = nBasePhysicalAttackValue
	nPercentValueTb.m_physicalAttack = nPercentValue

	return nBaseValueTb, nPercentValueTb

	
end


-- 新空岛贝系统战斗力加成
function getNewConchValue( tParam )
	local nPercentValue = 0
	local tArrHeroes = HeroModel.getAllHeroes()

	local nBaseValueTb = {}
	local nPercentValueTb = {}


	local tConch = tArrHeroes[tostring(tParam.hid)].equip.conch
	if tConch == nil then
		tConch = {}
	end

	function returnBaseValue( map ,baseItems,growItems,tConchitem)
		local nRetValue = 0
		if tonumber(baseItems[1]) == map[1] then
			nRetValue = nRetValue + tonumber(baseItems[2]) + tonumber(growItems[2]) * tonumber(tConchitem.va_item_text.level)
		end
		return nRetValue
	end

	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	for k, v in pairs(tConch) do

		if type(v) =="table" then
			require "db/DB_Item_conch"
			local db = DB_Item_conch.getDataById(v.item_template_id)
			local baseAtts = string.split(db.baseAtt, ",")
			local growAtts = string.split(db.growAtt, ",")

			for i=1, #baseAtts do
				local baseItems = string.split(baseAtts[i], "|")
				local growItems = string.split(growAtts[i], "|")

				-- 生命
				local map=_attributesMap[m_hp]
				nBaseHpValue = nBaseHpValue + returnBaseValue(map,baseItems,growItems,v)
				-- 魔防
				map=_attributesMap[m_magicDefend]
				nBaseMagicDefendValue = nBaseMagicDefendValue + returnBaseValue(map,baseItems,growItems,v)
				-- 物防
				map=_attributesMap[m_physicalDefend]
				nBasePhysicalDefendValue = nBasePhysicalDefendValue + returnBaseValue(map,baseItems,growItems,v)
				-- 魔攻
				map=_attributesMap[m_magicAttack]
				nBaseMagicAttackValue = nBaseMagicAttackValue + returnBaseValue(map,baseItems,growItems,v)
				-- 物攻
				map=_attributesMap[m_physicalAttack]
				nBasePhysicalAttackValue = nBasePhysicalAttackValue + returnBaseValue(map,baseItems,growItems,v)

			end
		end
	end

	nBaseValueTb.m_hp = nBaseHpValue
	nPercentValueTb.m_hp = nPercentValue

	nBaseValueTb.m_magicDefend = nBaseMagicDefendValue
	nPercentValueTb.m_magicDefend = nPercentValue

	nBaseValueTb.m_physicalDefend = nBasePhysicalDefendValue
	nPercentValueTb.m_physicalDefend = nPercentValue

	nBaseValueTb.m_magicAttack = nBaseMagicAttackValue
	nPercentValueTb.m_magicAttack = nPercentValue

	nBaseValueTb.m_physicalAttack = nBasePhysicalAttackValue
	nPercentValueTb.m_physicalAttack = nPercentValue

	return nBaseValueTb, nPercentValueTb
end


-- 唤醒加成
function getNewAwakeValue(tParam)
	local nBaseValueTb = {}
	local nPercentValueTb = {}
	local db_hero = tParam.db_hero
	local map = tParam.map

	local arrAwakeId = nil
	if db_hero.awake_id then
		arrAwakeId = string.split(db_hero.awake_id, ",")
	end
	local arrGrowAwakeId = nil
	if db_hero.grow_awake_id then
		arrGrowAwakeId = string.split(db_hero.grow_awake_id, ",")
	end
-- 如果存在天赋ID
	local tAwakes = {}
	if arrAwakeId then
		for i=1, #arrAwakeId do
			tAwakes[#tAwakes+1] = {}
			local awake =  tAwakes[#tAwakes]
			awake.id = arrAwakeId[i]
		end
	end
	if arrGrowAwakeId then
		for i=1, #arrGrowAwakeId do
			tAwakes[#tAwakes+1] = {}
			local awake =  tAwakes[#tAwakes]
			local levelAndId = string.split(arrGrowAwakeId[i], "|")
			local awkae_type = tonumber(levelAndId[1])
			if awkae_type == 1 then
				awake.id = tonumber(levelAndId[3])
				awake.level = tonumber(levelAndId[2])
				awake.evolve_level = 0
			elseif awkae_type == 2 then
				awake.id = tonumber(levelAndId[3])
				awake.evolve_level = tonumber(levelAndId[2])
				awake.level = 0
			end
		end
	end
	function returnBaseValue( id,map ,arrAttriValue)
		local nBaseValue=0
		local nPercentValue=0

		if id == map[1] then
			nBaseValue = nBaseValue + tonumber(arrAttriValue)
		elseif id == map[2] then
			nPercentValue = nPercentValue + tonumber(arrAttriValue)
		end

		return nBaseValue,nPercentValue
	end

	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	local nPercentHpValue = 0  
	local nPercentMagicDefendValue = 0
	local nPercentPhysicalDefendValue = 0
	local nPercentMagicAttackValue = 0
	local nPercentPhysicalAttackValue = 0

	for i=1, #tAwakes do
		local v = tAwakes[i]
		local nMaxLevel = tonumber(tParam.level)
		local evolve_level = tonumber(tParam.evolve_level)
		if nMaxLevel >= v.level and evolve_level >= v.evolve_level then
			local db_awake=DB_Awake_ability.getDataById(v.id)
			-- attri_ids, attri_values 属性为数组
			local arrAttriIds = {}
			local arrAttriValues = {}
			if db_awake.attri_ids then
				arrAttriIds = string.split(db_awake.attri_ids, ",")
				arrAttriValues = string.split(db_awake.attri_values, ",")
			end
			for i=1, #arrAttriIds do
				local id = tonumber(arrAttriIds[i])
				-- 生命
				local map=_attributesMap[m_hp]
				local BaseHpValue,PercentValue = returnBaseValue( id,map,arrAttriValues[i] )
				nBaseHpValue = nBaseHpValue + BaseHpValue
				nPercentHpValue = nPercentHpValue + PercentValue

				-- 魔防
				map=_attributesMap[m_magicDefend]
				local BaseMagicDefendValue,PercentMagicDefendValue =  returnBaseValue( id,map,arrAttriValues[i] )
				nBaseMagicDefendValue = nBaseMagicDefendValue + BaseMagicDefendValue
				nPercentMagicDefendValue = nPercentMagicDefendValue + PercentMagicDefendValue
				-- 物防
				map=_attributesMap[m_physicalDefend]
				local BasePhysicalDefendValue,PercentPhysicalDefendValue =  returnBaseValue( id,map,arrAttriValues[i] )
				nBasePhysicalDefendValue = nBasePhysicalDefendValue + BasePhysicalDefendValue
				nPercentPhysicalDefendValue = nPercentPhysicalDefendValue + PercentPhysicalDefendValue
				-- 魔攻
				map=_attributesMap[m_magicAttack]
				local BaseMagicAttackValue,PercentMagicAttackValue =  returnBaseValue( id,map,arrAttriValues[i] )
				nBaseMagicAttackValue = nBaseMagicAttackValue + BaseMagicAttackValue
				nPercentMagicAttackValue = nPercentMagicAttackValue + PercentMagicAttackValue
				-- 物攻
				map=_attributesMap[m_physicalAttack]
				local BasePhysicalAttackValue ,PercentPhysicalAttackValue=  returnBaseValue( id,map,arrAttriValues[i] )
				nBasePhysicalAttackValue = nBasePhysicalAttackValue + BasePhysicalAttackValue
				nPercentPhysicalAttackValue = nPercentPhysicalAttackValue + PercentPhysicalAttackValue
			end
		end
	end
	
	nBaseValueTb.m_hp = nBaseHpValue
	nPercentValueTb.m_hp = nPercentHpValue

	nBaseValueTb.m_magicDefend = nBaseMagicDefendValue
	nPercentValueTb.m_magicDefend = nPercentMagicDefendValue

	nBaseValueTb.m_physicalDefend = nBasePhysicalDefendValue
	nPercentValueTb.m_physicalDefend = nPercentPhysicalDefendValue

	nBaseValueTb.m_magicAttack = nBaseMagicAttackValue
	nPercentValueTb.m_magicAttack = nPercentMagicAttackValue

	nBaseValueTb.m_physicalAttack = nBasePhysicalAttackValue
	nPercentValueTb.m_physicalAttack = nPercentPhysicalAttackValue

	return nBaseValueTb, nPercentValueTb
end


-- + 宝物系统(treasure)提供的通用攻击基础值及百分比加成
--[[
zhangqi, 2015-03-09, 最新调整宝物属性加成算法
宝物提供的属性=【（基础属性+宝物强化等级*成长属性）*（1+精炼属性成长/10000*精炼等级）】+宝物强化解锁的属性+宝物精炼解锁的属性
part1 = (基础属性+宝物强化等级*成长属性)
part2 = (1+精炼属性成长*精炼等级/10000)
part3 = 宝物强化解锁的属性
part4 = 宝物精炼解锁的属性
]]
--[[
zhangqi, 2015-12-26, 饰品属性修改算法
饰品强化属性, 和以前的基础加成值部分算法一样，不用修改
显示值=饰品的基础属性+饰品强化等级×每级强化成长值

精炼属性(最多3条)
显示值=装备的精炼等级×每级精炼成长值
]]
function getNewTreasureValue(tParam)
	local nBaseValueTb = {}
	local nPercentValueTb = {}

	if not tParam.hid or tParam.hid == 0 then
		return nBaseValue, nPercentValue
	end

	local map = tParam.map
	local hero_data = HeroModel.getHeroByHid(tParam.hid)

	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	local nPercentHpValue = 0  
	local nPercentMagicDefendValue = 0
	local nPercentPhysicalDefendValue = 0
	local nPercentMagicAttackValue = 0
	local nPercentPhysicalAttackValue = 0

	function returnBaseValue( map,treasureItem )
		local db_data = DB_Item_treasure.getDataById(treasureItem.item_template_id)
		local part1, part2, part3, part4 = 0, 0, 0, 0 -- 数值属性的分步加成
		local nBaseValue = 0
		local nPercentValue = 0
		-- 宝物基础加成值 
		for i=1, 5 do
			local base = db_data["base_attr"..i]
			local typeValue = string.split(base, "|")
			local attrType = tonumber(typeValue[1])
		
			if attrType == map[1] then
			
				part1 = part1 + tonumber(typeValue[2])
				local grow = db_data["increase_attr"..i]
				local arr = string.split(grow, "|")
				part1 = part1 + tonumber(arr[2])*tonumber(treasureItem.va_item_text.treasureLevel)
			elseif attrType == map[2] then
		
				nPercentValue = nPercentValue + tonumber(typeValue[2])
				local grow = db_data["increase_attr"..i]
				local arr = string.split(grow, "|")
				nPercentValue = nPercentValue + tonumber(arr[2])*tonumber(treasureItem.va_item_text.treasureLevel)
			end
		end

		-- part2 = (1+精炼属性成长*精炼等级/10000)
		-- part2 = 1 -- 2015-12-26, 无用暂时注释
		local function parseAffix( strAffixAttr )
			local tbRet = {}
			local tbAttrs = string.split(strAffixAttr, ",")
			for i, attr in ipairs(tbAttrs) do
				local tbAffix = string.split(attr, "|")
				if (tonumber(tbAffix[1]) < 6) then
					local tbValue = {}
					tbValue.name, tbValue.num, tbValue.realNum = ItemUtil.getAtrrNameAndNum(tbAffix[1], tbAffix[2])
					tbRet[tbAffix[1]] = tbValue
				end
			end

			return tbRet
		end
		if (db_data.upgrade_affix) then -- 如果是可精炼的宝物才计算
			-- part2 = part2 + db_data.upgrade_affix * tonumber(treasureItem.va_item_text.treasureEvolve) / 10000
			part2 = 0
			local tbAffix = parseAffix(db_data.upgrade_affix)
			local affix = tbAffix[map[1] .. ""]
			if (affix) then
				part2 = part2 + affix.realNum * tonumber(treasureItem.va_item_text.treasureEvolve)
			end
		end

		-- part3 = 宝物强化解锁的属性
		-- 宝物等级解锁加成值
		local ext_active_arr = db_data.ext_active_arr
		local arrAttr = string.split(ext_active_arr, ",")
		for i=1, #arrAttr do
			local arrLevelMapValue = string.split(arrAttr[i], "|")
			local tmpMap = tonumber(arrLevelMapValue[2])
			if tonumber(treasureItem.va_item_text.treasureLevel) >= tonumber(arrLevelMapValue[1]) then
				if tmpMap == map[1] then
					part3 = part3 + tonumber(arrLevelMapValue[3])
				elseif tmpMap == map[2] then
					nPercentValue = nPercentValue + tonumber(arrLevelMapValue[3])
				end
			end
		end

		-- part4 = 宝物精炼解锁的属性，由于宝物表没有配置精炼解锁属性值，暂时不计算
		-- if v.va_item_text and v.va_item_text.treasureEvolve and tonumber(v.va_item_text.treasureEvolve) > 0 then
		-- 	require "script/module/treasure/TreasureEvolveUtil"
		-- 	local daffix = TreasureEvolveUtil.getOldAffix(v.item_id)
		-- 	if daffix and daffix.affix then
		-- 		for i=1, #daffix.affix do
		-- 			if tonumber(daffix.affix[i].id) == map[1] then
		-- 				part4 = part4 + tonumber(daffix.affix[i].num)
		-- 			elseif tonumber(daffix.affix[i].id) == map[2] then
		-- 				nPercentValue = nPercentValue + tonumber(daffix.affix[i].num)
		-- 			end
		-- 		end
		-- 	end
		-- end

		-- nBaseValue = math.floor(nBaseValue + (part1 * part2 + part3 + part4)) -- 2015-12-26
		nBaseValue = math.floor(nBaseValue + (part1 + part2 + part3 + part4))
		return nBaseValue,nPercentValue
	end

    if (hero_data) then 
		local treasure = hero_data.equip.treasure

		if (treasure and table.count(treasure) > 0) then
			for k, v in pairs(treasure) do
				if v.item_template_id then
					-- 生命
					local map=_attributesMap[m_hp]
					local BaseHpValue,PercentValue = returnBaseValue( map,v )
					nBaseHpValue = nBaseHpValue + BaseHpValue
					nPercentHpValue = nPercentHpValue + PercentValue
					-- 魔防
					map=_attributesMap[m_magicDefend]
					local BaseMagicDefendValue,PercentMagicDefendValue =  returnBaseValue( map,v )
					nBaseMagicDefendValue = nBaseMagicDefendValue + BaseMagicDefendValue
					nPercentMagicDefendValue = nPercentMagicDefendValue + PercentMagicDefendValue
					-- 物防
					map=_attributesMap[m_physicalDefend]
					local BasePhysicalDefendValue,PercentPhysicalDefendValue =  returnBaseValue( map,v )
					nBasePhysicalDefendValue = nBasePhysicalDefendValue + BasePhysicalDefendValue
					nPercentPhysicalDefendValue = nPercentPhysicalDefendValue + PercentPhysicalDefendValue

					-- 魔攻
					map=_attributesMap[m_magicAttack]
					local BaseMagicAttackValue,PercentMagicAttackValue =  returnBaseValue( map,v )
					nBaseMagicAttackValue = nBaseMagicAttackValue + BaseMagicAttackValue
					nPercentMagicAttackValue = nPercentMagicAttackValue + PercentMagicAttackValue

					-- 物攻
					map=_attributesMap[m_physicalAttack]
					local BasePhysicalAttackValue ,PercentPhysicalAttackValue= returnBaseValue( map,v )
					nBasePhysicalAttackValue = nBasePhysicalAttackValue + BasePhysicalAttackValue
					nPercentPhysicalAttackValue = nPercentPhysicalAttackValue + PercentPhysicalAttackValue

				end
			end
		end
    end

	nBaseValueTb.m_hp = nBaseHpValue
	nPercentValueTb.m_hp = nPercentHpValue

	nBaseValueTb.m_magicDefend = nBaseMagicDefendValue
	nPercentValueTb.m_magicDefend = nPercentMagicDefendValue

	nBaseValueTb.m_physicalDefend = nBasePhysicalDefendValue
	nPercentValueTb.m_physicalDefend = nPercentPhysicalDefendValue

	nBaseValueTb.m_magicAttack = nBaseMagicAttackValue
	nPercentValueTb.m_magicAttack = nPercentMagicAttackValue

	nBaseValueTb.m_physicalAttack = nBasePhysicalAttackValue
	nPercentValueTb.m_physicalAttack = nPercentPhysicalAttackValue

	return nBaseValueTb, nPercentValueTb
end


-- 专属宝物增加的属性
function getSpecialValue( tParam )
	local nPercentValue = 0
	local tArrHeroes = HeroModel.getAllHeroes()

	local nBaseValueTb = {}
	local nPercentValueTb = {}


	local tExclusive = tArrHeroes[tostring(tParam.hid)].equip.exclusive
	if tExclusive == nil then
		tExclusive = {}
	end

	function returnBaseValue( map ,baseItems,tExclusiveitem, db)
		local nRetValue = 0
		if tonumber(baseItems[1]) == map[1] then
			nRetValue = nRetValue + tonumber(baseItems[2]) 
			for i=1,tonumber(tExclusiveitem.va_item_text.exclusiveEvolve) do
				local growStr = db["increase_attr" .. i]
				local growAtts = string.split(growStr, ",")
				
				for i,v in ipairs(growAtts) do
					local growItems = string.split(v, "|")
					if tonumber(growItems[1]) == map[1] then
						nRetValue = nRetValue + growItems[2]
						logger:debug({growItems = growItems})
					end
				end
			end
			logger:debug("nRetValue = %s", nRetValue)

		end
		return nRetValue
	end

	-- 进阶能力
	function returnEvolveValue( map ,exclusiveEvolveLel,evolveAwakeTb)
		local nRetValue = 0
		local nPercentValue = 0
		for _,evolveAwake in ipairs(evolveAwakeTb) do
			local evolveTb = string.split(evolveAwake, ",")
			for i,v in ipairs(evolveTb) do
				local awakeItems = string.split(v, "|")
				if ((exclusiveEvolveLel >= tonumber(awakeItems[1]))) then
					if (tonumber(awakeItems[2]) == map[1])then
						nRetValue = nRetValue + tonumber(awakeItems[3])
					elseif (tonumber(awakeItems[2]) == map[2]) then
						nPercentValue = nPercentValue + tonumber(awakeItems[3])
					end
				end
			end

		end

		return {nRetValue,nPercentValue}
	end


	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	local nPercentHpValue = 0  
	local nPercentMagicDefendValue = 0
	local nPercentPhysicalDefendValue = 0
	local nPercentMagicAttackValue = 0
	local nPercentPhysicalAttackValue = 0

	for k, v in pairs(tExclusive) do
		if type(v) =="table" then
			local db = DB_Item_exclusive.getDataById(v.item_template_id)

			local evolveAwakeTb = {}
			for i=1,20 do
				if (not db["awaken" .. i]) then
					break
				end
				table.insert(evolveAwakeTb,db["awaken" .. i])
			end
			local exclusiveEvolveLel = tonumber(v.va_item_text.exclusiveEvolve)
			local baseAtts = string.split(db.base_attr, ",")

			for i=1, #baseAtts do
				local baseItems = string.split(baseAtts[i], "|")
				-- 生命
				local map=_attributesMap[m_hp]
				nBaseHpValue = nBaseHpValue + returnBaseValue(map,baseItems,v, db) 
				-- 魔防
				map=_attributesMap[m_magicDefend]
				nBaseMagicDefendValue = nBaseMagicDefendValue + returnBaseValue(map,baseItems,v, db)
				-- 物防
				map=_attributesMap[m_physicalDefend]
				nBasePhysicalDefendValue = nBasePhysicalDefendValue + returnBaseValue(map,baseItems,v, db)
				-- 魔攻
				map=_attributesMap[m_magicAttack]
				nBaseMagicAttackValue = nBaseMagicAttackValue + returnBaseValue(map,baseItems,v, db)
				-- 物攻
				map=_attributesMap[m_physicalAttack]
				nBasePhysicalAttackValue = nBasePhysicalAttackValue + returnBaseValue(map,baseItems,v, db)

			end
			-- 进阶解锁能力
			-- 生命
			local map=_attributesMap[m_hp]
			nBaseHpValue = nBaseHpValue +returnEvolveValue(map,exclusiveEvolveLel,evolveAwakeTb)[1]
			nPercentHpValue = nPercentValue + returnEvolveValue(map,exclusiveEvolveLel,evolveAwakeTb)[2]
			-- 魔防
			map=_attributesMap[m_magicDefend]
			nBaseMagicDefendValue = nBaseMagicDefendValue + returnEvolveValue(map,exclusiveEvolveLel,evolveAwakeTb)[1]
			nPercentMagicDefendValue = nPercentValue + returnEvolveValue(map,exclusiveEvolveLel,evolveAwakeTb)[2]
			-- 物防
			map=_attributesMap[m_physicalDefend]
			nBasePhysicalDefendValue = nBasePhysicalDefendValue +  returnEvolveValue(map,exclusiveEvolveLel,evolveAwakeTb)[1]
			nPercentPhysicalDefendValue = nPercentValue + returnEvolveValue(map,exclusiveEvolveLel,evolveAwakeTb)[2]
			-- 魔攻
			map=_attributesMap[m_magicAttack]
			nBaseMagicAttackValue = nBaseMagicAttackValue + returnEvolveValue(map,exclusiveEvolveLel,evolveAwakeTb)[1]
			nPercentMagicAttackValue = nPercentValue + returnEvolveValue(map,exclusiveEvolveLel,evolveAwakeTb)[2]
			-- 物攻
			map=_attributesMap[m_physicalAttack]
			nBasePhysicalAttackValue = nBasePhysicalAttackValue + returnEvolveValue(map,exclusiveEvolveLel,evolveAwakeTb)[1]
			nPercentPhysicalAttackValue = nPercentValue + returnEvolveValue(map,exclusiveEvolveLel,evolveAwakeTb)[2]
		end
	end

	nBaseValueTb.m_hp = nBaseHpValue 
	nPercentValueTb.m_hp = nPercentHpValue 

	nBaseValueTb.m_magicDefend = nBaseMagicDefendValue
	nPercentValueTb.m_magicDefend = nPercentMagicDefendValue

	nBaseValueTb.m_physicalDefend = nBasePhysicalDefendValue
	nPercentValueTb.m_physicalDefend = nPercentPhysicalDefendValue

	nBaseValueTb.m_magicAttack = nBaseMagicAttackValue
	nPercentValueTb.m_magicAttack = nPercentMagicAttackValue

	nBaseValueTb.m_physicalAttack = nBasePhysicalAttackValue
	nPercentValueTb.m_physicalAttack = nPercentPhysicalAttackValue

	return nBaseValueTb, nPercentValueTb
end


--[[
1"生命",
2"物攻",
3"魔攻",
4"物防",
5"魔防",
--]]
function getPartnerAwakeValue( tParam )
	local tPAwake = MainAwakeModel.getAwakeTotalAttrsByHid(tParam.hid)

	local nBaseValueTb = {}
	local nPercentValueTb = {}

	nBaseValueTb.m_hp = tPAwake[1].awakeAttrNum or 0
	nPercentValueTb.m_hp = tPAwake[1].awakeAttrPer or 0

	nBaseValueTb.m_magicDefend = tPAwake[5].awakeAttrNum or 0
	nPercentValueTb.m_magicDefend = tPAwake[5].awakeAttrPer or 0

	nBaseValueTb.m_physicalDefend = tPAwake[4].awakeAttrNum or 0
	nPercentValueTb.m_physicalDefend = tPAwake[4].awakeAttrPer or 0

	nBaseValueTb.m_magicAttack = tPAwake[3].awakeAttrNum or 0
	nPercentValueTb.m_magicAttack = tPAwake[3].awakeAttrPer or 0

	nBaseValueTb.m_physicalAttack = tPAwake[2].awakeAttrNum or 0
	nPercentValueTb.m_physicalAttack = tPAwake[2].awakeAttrPer or 0

	logger:debug({nBaseValueTb = nBaseValueTb})
	logger:debug({nPercentValueTb = nPercentValueTb})

	return nBaseValueTb, nPercentValueTb
end


FORCEVALUEPART  = {
	LEVEL = 1,             -- 等级影响战斗力
	UNION = 2,			   -- 羁绊影响战斗力
	DRESS = 3,			   -- 时装影响战斗力
	ARM = 4,               -- 装备影响战斗力
	AWAKE = 5,             -- 
	DEVILFRUIT = 6,		   -- 恶魔果实影响战斗力
	TREASURE = 7,          -- 宝物影响战斗力
	MASTER = 8,            -- 强化大师影响战斗力
	CONCH = 9,			   -- 空岛被影响战斗力
	SPECIAL = 10,		   -- 专属宝物影响战斗力
	HEROAWAKE = 11,        -- 伙伴觉醒系统增加的战斗力
}

-- tParam  目标影响的属性值 hid，宝物信息，装备信息，空岛被等等
-- resetForceParts 需要重新计算的模块
-- removeHid 需要从缓存中删除的英雄hid
-- readOnly 是否吧计算结果缓存起来  readOnly = false 则为缓存起来，因为伙伴强化需要预览，但是计算后不是该真正的属性值，不需要缓存
function getNewBaseValue(tParam,resetForceParts,removeHid,readOnly)
	local htid = tParam.htid
	local itemType = ItemUtil.getItemTypeByTid(htid)
	local isHavedHero = true
	if (itemType.isShadow or tParam.hid == 0) then
		isHavedHero = false
	end

	local _tbFightForceCache = DataCache.getFightForceInfo()
	local heroHid = tParam.hid
	local heroForceValueTb = {}

	local nRetValue = 0
	local nPercentValue = 0

	-- 基础加成
	local nBaseHpValue = 0
	local nBaseMagicDefendValue = 0
	local nBasePhysicalDefendValue = 0
	local nBaseMagicAttackValue = 0
	local nBasePhysicalAttackValue = 0

	-- 百分比加成
	local nPercentHpValue = 0  
	local nPercentMagicDefendValue = 0
	local nPercentPhysicalDefendValue = 0
	local nPercentMagicAttackValue = 0
	local nPercentPhysicalAttackValue = 0

   	local BaseValue = {}
   	local BasePersentValue = {}

   	local function numsort( v1,v2 )
   		if (tonumber(v1) > tonumber(v2)) then
   			return false
   		else
   			return true
   		end	
   	end 

   	local ForceParts = resetForceParts or {} 
   	 -- 从战斗力缓存中删除被替换的英雄
	local index = 1
	for hid,v in pairs(_tbFightForceCache) do
   		if (removeHid and (tonumber(heroHid) == tonumber(removeHid))) then   
   			table.remove(list, index)
   			break
   		end
   		index = index + 1
   	end 
   	 -- 查找战斗力缓存

   	heroForceValueTb = _tbFightForceCache[heroHid]

	local allParts = {}
	for _,v in pairs(FORCEVALUEPART) do
		table.insert(allParts,tonumber(v))
	end

	--{1,2,3,4,5,6,7,8,9}   --  1 和 2的顺序一定要放在前面 因为等级和羁绊相关紧密
	local function sortAllParts( ... )
		table.sort( ForceParts, numsort )
		table.sort( allParts, numsort )
	end

	sortAllParts()

	local tablecontain = function ( value )
		for _,v in ipairs(ForceParts) do
			if (tonumber(v) == tonumber(value)) then
				return true
			end
		end
		return false
	end
	-- 更改战斗力缓存
	local tbParts = {"level","union","dress","arm","awake","devilfruit","treasure","master","conch", "special", "heroawake"}
	local tbFightForce  ={}
	for _,v in ipairs(allParts) do
		local nRetValueTb, nPercentValueTb = {},{}
		nRetValueTb.m_hp              = 0
		nRetValueTb.m_magicDefend     = 0
		nRetValueTb.m_physicalDefend  = 0
		nRetValueTb.m_magicAttack     = 0
		nRetValueTb.m_physicalAttack  = 0

		nPercentValueTb.m_hp          = 0
		nPercentValueTb.m_magicDefend = 0
		nPercentValueTb.m_physicalDefend = 0
		nPercentValueTb.m_magicAttack = 0
		nPercentValueTb.m_physicalAttack = 0

		if ( #ForceParts~=0 and not tablecontain(v)) then
			local partname = tbParts[v]
			nRetValueTb, nPercentValueTb = heroForceValueTb[partname].base, heroForceValueTb[partname].percent
			tbFightForce[partname] = heroForceValueTb[partname]
		else
			if (v == FORCEVALUEPART.LEVEL) then   
			logger:debug("FORCEVALUEPART")                                                -- 等级影响模块
				nRetValueTb, nPercentValueTb = getNewHeroValue(tParam) 
				tbFightForce.level =  {base = nRetValueTb, percent = nPercentValueTb }
			elseif (v == FORCEVALUEPART.UNION and isHavedHero) then  
			                                                                               -- 羁绊影响模块
				nRetValueTb, nPercentValueTb = getNewUnionProfitValue(tParam) 
				tbFightForce.union =  {base =  nRetValueTb, percent = nPercentValueTb}

			elseif (v == FORCEVALUEPART.DRESS  and isHavedHero ) then                      -- 时装影响模块
				nRetValueTb, nPercentValueTb = getNewDressValue(tParam)  
				tbFightForce.dress = {base = nRetValueTb ,percent = nPercentValueTb}

			elseif (v == FORCEVALUEPART.ARM and isHavedHero) then
				nRetValueTb, nPercentValueTb = getNewArmValue(tParam)                      -- 装备影响模块
				tbFightForce.arm =  {base = nRetValueTb , percent = nPercentValueTb }

			elseif (v == FORCEVALUEPART.AWAKE and isHavedHero) then 
				nRetValueTb, nPercentValueTb = getNewAwakeValue(tParam)                    -- 觉醒影响模块
				tbFightForce.awake = {base = nRetValueTb , percent = nPercentValueTb }

			elseif (v == FORCEVALUEPART.DEVILFRUIT and isHavedHero) then
				nRetValueTb, nPercentValueTb = getNewDevilFruitValue(tParam)               -- 恶魔果实影响模块
				tbFightForce.devilfruit = {base = nRetValueTb ,percent = nPercentValueTb }

			elseif (v == FORCEVALUEPART.TREASURE and isHavedHero) then
				nRetValueTb, nPercentValueTb = getNewTreasureValue(tParam)                 -- 宝物影响模块
				tbFightForce.treasure =  {base = nRetValueTb , percent = nPercentValueTb }

			elseif (v == FORCEVALUEPART.MASTER and isHavedHero) then
				nRetValueTb, nPercentValueTb = getNewMasterValue(tParam)                   -- 强化大师影响模块
				tbFightForce.master =  {base = nRetValueTb , percent = nPercentValueTb }

			elseif (v == FORCEVALUEPART.CONCH and isHavedHero) then
				nRetValueTb, nPercentValueTb = getNewConchValue(tParam)                     -- 空岛贝影响模块
				tbFightForce.conch = {base =  nRetValueTb , percent = nPercentValueTb }
			elseif (v == FORCEVALUEPART.SPECIAL and isHavedHero) then
				nRetValueTb, nPercentValueTb = getSpecialValue(tParam)                      -- 专属宝物影响
				tbFightForce.special = {base =  nRetValueTb , percent = nPercentValueTb }
			elseif (v == FORCEVALUEPART.HEROAWAKE and isHavedHero) then                       -- 伙伴觉醒增加的战斗力
				nRetValueTb, nPercentValueTb = getPartnerAwakeValue(tParam)
				tbFightForce.heroawake = {base =  nRetValueTb , percent = nPercentValueTb }
			end
		end

		if  (v == FORCEVALUEPART.UNION) then
			nBaseHpValue = nBaseHpValue  + nRetValueTb.m_hp 
			nBaseHpValue = nBaseHpValue*(1 + nPercentValueTb.m_hp/10000)
			nBaseHpValue = math.floor(nBaseHpValue) 

			nBaseMagicDefendValue = nBaseMagicDefendValue  + nRetValueTb.m_magicDefend
			nBaseMagicDefendValue = nBaseMagicDefendValue *(1 + nPercentValueTb.m_magicDefend/10000)
			nBaseMagicDefendValue = math.floor(nBaseMagicDefendValue) 

			nBasePhysicalDefendValue = nBasePhysicalDefendValue  + nRetValueTb.m_physicalDefend
			nBasePhysicalDefendValue = nBasePhysicalDefendValue*(1 + nPercentValueTb.m_physicalDefend/10000)
			nBasePhysicalDefendValue = math.floor(nBasePhysicalDefendValue) 

			nBaseMagicAttackValue = nBaseMagicAttackValue  + nRetValueTb.m_magicAttack
			nBaseMagicAttackValue = nBaseMagicAttackValue*(1 + nPercentValueTb.m_magicAttack/10000)
			nBaseMagicAttackValue = math.floor(nBaseMagicAttackValue) 

			nBasePhysicalAttackValue = nBasePhysicalAttackValue  + nRetValueTb.m_physicalAttack
			nBasePhysicalAttackValue = nBasePhysicalAttackValue*(1 + nPercentValueTb.m_physicalAttack/10000)
			nBasePhysicalAttackValue = math.floor(nBasePhysicalAttackValue) 
		else
			nBaseHpValue = nBaseHpValue + nRetValueTb.m_hp
			nBaseMagicDefendValue = nBaseMagicDefendValue + nRetValueTb.m_magicDefend
			nBasePhysicalDefendValue = nBasePhysicalDefendValue + nRetValueTb.m_physicalDefend
			nBaseMagicAttackValue = nBaseMagicAttackValue + nRetValueTb.m_magicAttack
			nBasePhysicalAttackValue = nBasePhysicalAttackValue + nRetValueTb.m_physicalAttack

			nPercentHpValue = nPercentHpValue + nPercentValueTb.m_hp
			nPercentMagicDefendValue = nPercentMagicDefendValue + nPercentValueTb.m_magicDefend
			nPercentPhysicalDefendValue = nPercentPhysicalDefendValue + nPercentValueTb.m_physicalDefend
			nPercentMagicAttackValue = nPercentMagicAttackValue + nPercentValueTb.m_magicAttack
			nPercentPhysicalAttackValue = nPercentPhysicalAttackValue + nPercentValueTb.m_physicalAttack
		end
	end

    BaseValue.m_hp = nBaseHpValue
    BaseValue.m_magicDefend = nBaseMagicDefendValue
    BaseValue.m_physicalDefend = nBasePhysicalDefendValue
    BaseValue.m_magicAttack = nBaseMagicAttackValue
    BaseValue.m_physicalAttack = nBasePhysicalAttackValue

    BasePersentValue.m_hp = nPercentHpValue
    BasePersentValue.m_magicDefend = nPercentMagicDefendValue
    BasePersentValue.m_physicalDefend = nPercentPhysicalDefendValue
    BasePersentValue.m_magicAttack = nPercentMagicAttackValue
    BasePersentValue.m_physicalAttack = nPercentPhysicalAttackValue

    tbFightForce.BaseValue = BaseValue
    tbFightForce.BasePersentValue = BasePersentValue
    if (not readOnly) then
		_tbFightForceCache[heroHid] = tbFightForce
	end

	DataCache.setFightForceInfoInfo(_tbFightForceCache)
	return BaseValue, BasePersentValue
end

-- 武将本身天赋值
function getHeroTalentValue(tParam)
	local db_hero = tParam.db_hero
	local map=tParam.map
	local base = db_hero[""..map[3]]
	local nBaseValue = base / 10000
	return nBaseValue
end


-- 新的获取战斗力方法，把方法分开避免不需要的计算
-- ValueTb 模块部分 包含主角，伙伴，宝物，装备，羁绊，时装等等
-- removehid 替换的英雄，需要删除缓存
-- readOnly  只读不做缓存
function getNewAllForceValues(tParam,resetForceParts,removehid,readOnly)
	local nAttackValue = 0
	local nBaseValueTb 
	local nPercentValueTb 
	
	if not (tParam and tParam.htid) then
		return {}
	end

	local heroDestinyValue = { delifeTa = 0, magdefTa = 0, magattTa = 0, phyattTa = 0, phydefTa = 0, magdef = 0, magatt = 0,
								phydef = 0, phyatt = 0, delife = 0,}


	-- 修炼系统加成
	require "script/module/Train/MainTrainModel"
	MainTrainModel.refreashBaseInfo()

	heroDestinyValue.magdef = MainTrainModel.getMagDefend()
	heroDestinyValue.magatt = MainTrainModel.getMagAttack()
	heroDestinyValue.phydef = MainTrainModel.getPhyDefend() 
	heroDestinyValue.phyatt = MainTrainModel.getPhyAttack()
	heroDestinyValue.delife = MainTrainModel.getHp()

	-- 功能节点开启后才计算加成
	if (SwitchModel.getSwitchOpenState( ksSwitchMainShip , false )) then
		-- 主船系统加成
		require "script/module/ship/ShipMainModel" 
		local shipAttr = ShipMainModel.getNowAttr()
		heroDestinyValue.delife = heroDestinyValue.delife + shipAttr[1]
		heroDestinyValue.phyatt = heroDestinyValue.phyatt + shipAttr[2]
		heroDestinyValue.magatt = heroDestinyValue.magatt + shipAttr[3]
		heroDestinyValue.phydef = heroDestinyValue.phydef + shipAttr[4]
		heroDestinyValue.magdef = heroDestinyValue.magdef + shipAttr[5]
	end
	

logger:debug("战斗力")
logger:debug(heroDestinyValue)

	
	local tArgs = {}
	tArgs = table.hcopy(tParam, tArgs)
	if (ItemUtil.getItemTypeByTid(tParam.htid).isShadow) then
		local fragDB = DB_Item_hero_fragment.getDataById(tParam.htid)
		tArgs.db_hero = DB_Heroes.getDataById(tonumber(fragDB.aimItem))
	else
		tArgs.db_hero = DB_Heroes.getDataById(tParam.htid)
	end
	tArgs.speed = tArgs.db_hero.speed
	-- 判断该武将是否在阵上
	tArgs.isBusy = HeroPublicUtil.isOnFmtByHid(tParam.hid)
	local tRetValue={}
	logger:debug({resetForceParts = resetForceParts})
	logger:debug("战斗力1")
	if (resetForceParts and #resetForceParts == 1 and tonumber(resetForceParts[1]) == 0) then
		logger:debug("战斗力2")
		local _tbFightForceCache = DataCache.getFightForceInfo()
		if table.isEmpty(_tbFightForceCache[tArgs.hid]) then
			nBaseValueTb, nPercentValueTb = getNewBaseValue(tArgs,nil)
		else
			nBaseValueTb, nPercentValueTb = _tbFightForceCache[tArgs.hid].BaseValue, _tbFightForceCache[tArgs.hid].BasePersentValue
		end
	else
		logger:debug("战斗力3")
		nBaseValueTb, nPercentValueTb = getNewBaseValue(tArgs,resetForceParts,removehid,readOnly)
	end

	
	tRetValue.life = (nBaseValueTb.m_hp + heroDestinyValue.delife)* (1+nPercentValueTb.m_hp/10000)--math.floor((nBaseValue + heroDestinyValue.delife)* (1+nPercentValue/10000))
	
	tRetValue.command = 0--math.floor(nBaseValue + tDestinyValue.commandAppend)*(1+nPercentValue/10000)/100

	tRetValue.strength = 0--math.floor(nBaseValue + tDestinyValue.strengthAppend)*(1+nPercentValue/10000)/100

	tRetValue.intelligence = 0-- math.floor(nBaseValue + tDestinyValue.intelligenceAppend)*(1+nPercentValue/10000)/100

	
	tRetValue.generalAttack = 0 --math.floor(nBaseValue + tDestinyValue.generalAttackAppend)*(1+nPercentValue/10000)

	-- 法防
	tRetValue.magicDefend = math.floor((nBaseValueTb.m_magicDefend + heroDestinyValue.magdef)*(1+nPercentValueTb.m_magicDefend/10000))


	-- 物防
	tRetValue.physicalDefend = math.floor((nBaseValueTb.m_physicalDefend + heroDestinyValue.phydef)*(1+nPercentValueTb.m_physicalDefend/10000))

	-- 物攻
	tRetValue.physicalAttack = math.floor((nBaseValueTb.m_physicalAttack + heroDestinyValue.phyatt)*(1+nPercentValueTb.m_physicalAttack/10000))


	-- 法攻
	tRetValue.magicAttack = math.floor((nBaseValueTb.m_magicAttack + heroDestinyValue.magatt)*(1+nPercentValueTb.m_magicAttack/10000))

	--生命天赋
	tArgs.map = _attributesMap[m_talent_hp]
	tRetValue.talent_hp = getHeroTalentValue(tArgs) + heroDestinyValue.delifeTa/100

	--物攻天赋
	tArgs.map = _attributesMap[m_talent_phyAtt]
	tRetValue.talent_phyAtt = getHeroTalentValue(tArgs) + heroDestinyValue.phyattTa/100

	--魔攻天赋
	tArgs.map = _attributesMap[m_talent_magAtt]
	tRetValue.talent_magAtt = getHeroTalentValue(tArgs) + heroDestinyValue.magattTa/100

	--物防天赋
	tArgs.map = _attributesMap[m_talent_phyDef]
	tRetValue.talent_phyDef = getHeroTalentValue(tArgs) + heroDestinyValue.phydefTa/100

	--魔防天赋
	tArgs.map = _attributesMap[m_talent_magDef]
	tRetValue.talent_magDef = getHeroTalentValue(tArgs) + heroDestinyValue.magdefTa/100

	tRetValue.life = math.floor((tRetValue.life) * tRetValue.talent_hp)


	--速度
	tRetValue.speed = tArgs.speed
-- 计算战斗力
	tRetValue.fightForce= tRetValue.generalAttack + tRetValue.magicDefend + tRetValue.physicalDefend + tRetValue.physicalAttack + tRetValue.magicAttack
	tRetValue.fightForce=tRetValue.fightForce + tRetValue.life/10 
	local vitalSum = (tRetValue.command+tRetValue.strength+tRetValue.intelligence-3000)/100*10
	if vitalSum < 0 then
		vitalSum = 0
	end
	tRetValue.fightForce=tRetValue.fightForce+ vitalSum

	if tRetValue.fightForce < 5 then
		tRetValue.fightForce = 5
	end
	tRetValue.fightForce = tRetValue.fightForce
	tRetValue.vitalStat = tRetValue.fightForce
	tRetValue.fightForce = tRetValue.fightForce*10 -- 战斗力放大10倍
	for k, v in pairs(tRetValue) do
		if (string.find(k,"talent_")) then
			tRetValue[k] = v
		else
			tRetValue[k] = math.floor(v)
		end
	end

	return tRetValue
end
