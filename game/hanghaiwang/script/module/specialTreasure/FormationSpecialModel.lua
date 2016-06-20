-- FileName: FormationSpecialModel.lua
-- Author: yucong
-- Date: 2015-09-16
-- Purpose: 专属宝物选择列表 数据
--[[TODO List]]

module("FormationSpecialModel", package.seeall)

require "db/DB_Item_exclusive"
require "db/DB_Item_treasure"
require "db/DB_Awake_ability"
require "db/DB_Heroes"
require "db/DB_Normal_config"
require "script/module/specialTreasure/SpecialConst"
require "script/module/partner/HeroPublicUtil"


local DB_Item_exclusive = DB_Item_exclusive
local DB_Item_treasure = DB_Item_treasure
local DB_Awake_ability = DB_Awake_ability
local DB_Heroes = DB_Heroes
local DB_Normal_config = DB_Normal_config

local _tbDataSource = {}

local _hid = 0

function setHid( hid )
	_hid = hid
end

function getHid( ... )
	return _hid
end

function getDataSource( ... )
	return _tbDataSource
end

function calcFightForce( hid )
	if (not hid) then
		return
	end
	UserModel.setInfoChanged(true)
	UserModel.updateFightValue({[hid] = {
										  HeroFightUtil.FORCEVALUEPART.SPECIAL,
										  },})  -- 更新专属宝物战斗力
end

function getAwakeLevel( htid )
	local heroInfo = DB_Heroes.getDataById(tonumber(htid))
	if (not heroInfo.treaureId) then
		return nil
	end
	return tonumber(lua_string_split(heroInfo.treaureId, "|")[3])
end

-- 指定的宝物id是否是阵上伙伴能用的宝物
function isExclusiceUsedInFormation( id )
	for k, f_hid in pairs(DataCache.getSquad() or {}) do
		if(tonumber(f_hid)>0)then
			local htid = HeroModel.getHtidByHid(f_hid)
			local exclusiveId = getHeroSpecialId(htid)
			if (exclusiveId == tonumber(id)) then
				return true
			end
		end
	end
	for k,f_hid in pairs(DataCache.getBench() or {}) do
		if(tonumber(f_hid)>0)then
			local htid = HeroModel.getHtidByHid(f_hid)
			local exclusiveId = getHeroSpecialId(htid)
			if (exclusiveId == tonumber(id)) then
				return true
			end
		end
	end
	return false
end

-- 获取伙伴的专属宝物
function getHeroSpecialId( htid )
	local heroInfo = DB_Heroes.getDataById(tonumber(htid))
	if (not heroInfo.treaureId) then
		return 0
	end
	return tonumber(lua_string_split(heroInfo.treaureId, "|")[1])
end

-- 判断背包中是否有伙伴的专属宝物
function isHaveSpecialTreasure( htid )
	return not table.isEmpty(getAllSpecialTreasureWithHtid(htid))
end

-- 获取用户拥有的专属宝物
function getAllSpecialTreasureWithHtid( htid )
	local tbTreaList = {}
	-- 指定的宝物id
	local heroInfo = DB_Heroes.getDataById(tonumber(htid))
	logger:debug("FormationSpecialModel: heroInfo.treaureId")
	logger:debug(heroInfo.treaureId)
	if (not heroInfo.treaureId) then
		return tbTreaList
	end
	local treaid = getHeroSpecialId(htid)
	--  所有英雄身上的所有宝物
	local tbAllTreasureList = {}--ItemUtil.getSpecialOnFormation() -- ItemUtil.getTreasOnFormation() -- 

	-- 加上背包里的未被装备的宝物
	-- for k, v in ipairs(DataCache.getBagInfo().excl) do -- .treas
	-- 	table.insert(tbAllTreasureList, v)
	-- end
	--Q:如果某个伙伴不在阵上，但是穿着宝物，，当打开穿戴列表时，显不显示装备与xxx?
	tbAllTreasureList = ItemUtil.getAllSpecial()
	--logger:debug("treaid:"..treaid)
	--logger:debug({tbAllTreasureList = tbAllTreasureList})
	for k, v in pairs(tbAllTreasureList) do
		if (tonumber(v.item_template_id) == treaid) then
			table.insert(tbTreaList, v)
		end
	end
	--logger:debug({tbTreaList = tbTreaList})
	return tbTreaList
end

-- 获取专属宝物穿戴状态
function getSpecTreaOnHeroStat( htid ,hid)
	local treaid = getHeroSpecialId( htid )
	-- 伙伴碎片
	if (not hid) then
		logger:debug("the hero is frag")
		return 0,treaid
	end
	-- 没有专属
	if (treaid ==  0 or not treaid) then
		logger:debug("have no SpecTrea")
		return -1 
	end
	-- 背包中是否有
	local bagHas = isHaveSpecialTreasure(htid)
	if (not bagHas) then
		logger:debug("bagHas the SpecTrea")
		return 0,treaid  
	else
		-- 是否穿戴
		local heroInfo = HeroModel.getHeroByHid(hid)
		local specTreaInfo = heroInfo.equip.exclusive[SpecialConst.SPECIAL_POS]
		local limitLel = getSpTreaRefineLimitLevel(htid)
		if (specTreaInfo and table.isEmpty(specTreaInfo) == false) then  -- 已经穿戴
			logger:debug("the SpecTrea is On The Hero")
			return 1,limitLel   -- 返回进阶限制等级     （进阶按钮）
		else
			if (not checkSpecialLevel() or not HeroPublicUtil.isBusyByHid(hid)) then
				logger:debug("the SpecTrea is Ont On The Hero,because the HeroLel is low")
				return  0,treaid    -- 等级不够 没有穿戴 （去获取）或者 不在阵上
			end
			logger:debug("choose the Trea form list")
			return 2				-- 等级够了 没有穿戴  （选择列表） 
		end
	end  

end

-- 获取玩家专属宝物进阶限制等级
function getSpTreaRefineLimitLevel(  )
	local configDb = DB_Normal_config.getDataById(1)
	local heroLimitLel = tonumber(configDb.start_upgrade_level)
	return heroLimitLel
end


function getSpecialLevel( hid )
	local data = DB_Normal_config.getDataById(1)
	return tonumber(data.equip_level)
end

function checkSpecialLevel( otherLevel )
	local level = otherLevel or UserModel.getHeroLevel()
	--logger:debug({allHeros = HeroModel.getAllHeroes()})
	if (tonumber(level) < getSpecialLevel()) then
		return false
	end
	return true
end

function isShowTip( hid )
	-- 等级没到
	if (not checkSpecialLevel()) then
		return false
	end
	-- 身上没穿背包里有 或者 身上穿着比如背包里的等级高
	if (hid == nil or hid <= 0) then
		return false
	end
	local htid = HeroModel.getHtidByHid(hid)
	local heroInfo = HeroModel.getHeroByHid(hid)
	assert(heroInfo, "hid:"..hid.."不存在")
	local treaid = getHeroSpecialId(htid)
	local tbAllSpecials = {}
	for k, v in ipairs(DataCache.getBagInfo().excl) do -- .treas
		if (tonumber(v.item_template_id) == treaid) then
			table.insert(tbAllSpecials, v)
		end
	end
	--logger:debug({tbAllSpecials = tbAllSpecials})
	if (table.isEmpty(tbAllSpecials)) then
		return false
	end
	--logger:debug(heroInfo.equip.exclusive)
	-- 1.身上没穿但是背包有
	if (table.isEmpty(heroInfo.equip.exclusive) or table.isEmpty(heroInfo.equip.exclusive[SpecialConst.SPECIAL_POS])) then
		return true
	end
	local maxLevel = 0
	for k,v in pairs(tbAllSpecials) do
		if (maxLevel < tonumber(v.va_item_text.exclusiveEvolve)) then
			maxLevel = tonumber(v.va_item_text.exclusiveEvolve)
		end
	end
	-- 2.身上穿的没有背包里的等级高(因为不能脱，所以此条件舍去 yucong)
	-- if (tonumber(heroInfo.equip.exclusive[SpecialConst.SPECIAL_POS].va_item_text.exclusiveEvolve) < maxLevel) then
	-- 	return true
	-- end
	return false
end

-- 根据是否已装备，未装备的排在前面，装备在其他伙伴身上的排在后面。
-- 根据品质，品质高的排在前面：红、橙、紫、蓝、绿、白
-- 根据进阶等级，进阶等级高的排在前面。
-- 根据品级，品级高的排在前面。
-- 根据ID，id小的排在前面。
function sortDatas( ... )
	logger:debug("FormationSpecialModel:sortDatas")

	--品级 等级 id小 排序
	local function sort( w1,w2 )
		if (tonumber(w1.nQuality) ~= tonumber(w2.nQuality)) then
			return tonumber(w1.nQuality) > tonumber(w2.nQuality)
		else
			if(tonumber(w1.sRefinNum) ~= tonumber(w2.sRefinNum)) then
				return tonumber(w1.sRefinNum) >tonumber(w2.sRefinNum)
			else
				return tonumber(w1.id) <tonumber(w2.id)
			end
		end
	end

	local tCan = {}	-- 未装备
	local tNot = {}	-- 已装备
	-- 先分解成两部分
	for k, v in pairs(_tbDataSource) do
		if (v.sOwner == "") then
			table.insert(tCan, v)
		else
			table.insert(tNot, v)
		end
	end
	-- 对两部分排序
	table.sort(tCan, sort)
	table.sort(tNot, sort)

	_tbDataSource = {}
	-- 最终合并
	function combine( tb )
		for i,val in ipairs(tb) do
			_tbDataSource[#_tbDataSource+1] = tb[i]
		end
	end
	combine(tCan)
	combine(tNot)
	--logger:debug({_tbDataSource = _tbDataSource})
end

function handleDatas( onLoad )
    local htid = HeroModel.getHeroByHid(_hid).htid
    local specailIds = MainFormationTools.getExclusiveTreaureIDs(htid)
	local tbHeroTreasures = HeroModel.getHeroByHid(_hid).equip.treasure
	-- 获取背包所有的专属宝物
	local tbAllSpecials = getAllSpecialTreasureWithHtid(htid)

	_tbDataSource = {}
	for k, v in pairs(tbAllSpecials) do
		
		-- 可装备宝物过滤规则。1、类型限制 2、不是已经装备上的 3、不能是经验宝物
		if (tonumber(v.equip_hid) ~= tonumber(_hid) and tonumber(v.itemDesc.isExpTreasure)~= 1 and tonumber(v.itemDesc.is_refine_item)~= 1) then
			local tbData = {}
			if (v.equip_hid) then 
				tbData.otherLoaded = true
				-- 获取是都在阵上
				tbData.isHeroBusy = HeroPublicUtil.isBusyByHid(v.equip_hid)
			end
			tbData.id = v.item_id
			tbData.name = v.itemDesc.name
			--tbData.sign = ItemUtil.getSignTextByItem(v.itemDesc)
			tbData.icon = { id = v.itemDesc.id, bHero = false }
			tbData.icon.onTouch = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					require "script/module/specialTreasure/SpecTreaInfoCtrl"
					local layer = SpecTreaInfoCtrl.create(tonumber(v.item_template_id), tonumber(v.va_item_text.exclusiveEvolve))
					LayerManager.addLayoutNoScale(layer)
				end
			end
			--tbData.sStrongNum = v.va_item_text.treasureLevel
			tbData.sRefinNum = v.va_item_text.exclusiveEvolve
			tbData.nQuality = tonumber(v.itemDesc.quality)
			tbData.sRank = v.itemDesc.base_score
			tbData.sOwner = ItemUtil.getOwnerByEquipId(v.equip_hid)
			tbData.equipHid = v.equip_hid
			tbData.onLoad = function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playClickArmEffect()
					logger:debug("onLoad~~~")
					onLoad(v)
				end
			end

			tbData.awakeDes = getAwakeDes(tonumber(v.item_template_id), htid)
			table.insert(_tbDataSource, tbData)
		end
	end
	-- 排序
	sortDatas()
end

-- 获取专属宝物描述
function getAwakeDes( specialId, htid )
	local des = " "
	specialId = tonumber(specialId)
	local data = DB_Item_exclusive.getDataById(specialId)--DB_Item_treasure.getDataById(specialId) --
	if (not data) then
		return des 
	end
	if (data.awakeId) then
		local tbAwakeIds = lua_string_split(data.awakeId,"|")
		local tbAwakeHeros = lua_string_split(data.heroId,"|")
		-- 默认显示第一个能力
		local awakeInfo = DB_Awake_ability.getDataById(tonumber(tbAwakeIds[1]))
		-- 判断有哪个伙伴显示哪个能力
		for k, heroId in pairs(tbAwakeHeros) do
			if (HeroModel.getHidByHtid(tonumber(heroId)) ~= 0) then
				awakeInfo = DB_Awake_ability.getDataById(tonumber(tbAwakeIds[k]))
				break
			end
		end
		des = awakeInfo.des
	else
		des = data.info
	end
	if (htid) then
		local level = getAwakeLevel(htid)
		if (level) then
			des = string.format("%s%s", des, gi18nString(6944, level))
		end
	end
	return des
end

function getSpecialInfoDatas( itemId )
	local datas = {}
	local tbAllTreasureList = ItemUtil.getSpecialOnFormation()
	local index = 1
	local isFind = false
	for k,v in pairs(tbAllTreasureList) do
		local specTreaItem = v
		specTreaItem.page = k
		table.insert(datas,specTreaItem)
		if (tonumber(v.item_id) ~= tonumber(itemId) and isFind == false) then
			index = index + 1
		else
			isFind = true
		end

	end
	--assert(isFind, "FormationSpecialModel: not find special treasure index")

	return datas, index
end

function getOtherSpecialInfoDatas( itemId, formationInfo )
	logger:debug({formationInfo = formationInfo})
	local datas = {}
	local tbAllTreasureList = getOtherSpecialOnFormation(formationInfo)
	-- logger:debug("tid:"..tid)
	logger:debug(tbAllTreasureList)
	local index = 1
	local isFind = false
	for k,v in pairs(tbAllTreasureList) do
		table.insert(datas,{tid = v.itemDesc.id, itemId = v.item_id, refineLevel = tonumber(v.va_item_text.exclusiveEvolve), hid = v.equip_hid, page = k + 1})
		if (tonumber(v.item_id) ~= tonumber(itemId) and isFind == false) then
			index = index + 1
		else
			isFind = true
		end
	end
	assert(isFind, "FormationSpecialModel: not find special treasure index")
	return datas, index
end

function getOtherSpecialOnFormation( formationInfo )
	logger:debug({formationInfo = formationInfo})
	local equipsInfo_t = {}
	if( not table.isEmpty(formationInfo))then
		for k, f_hero in pairs(formationInfo) do
			logger:debug({f_hero = f_hero})
			if( (not table.isEmpty(f_hero.heroValue)) and (not table.isEmpty(f_hero.heroValue.equipInfo.exclusive)) ) then
				for p, equipInfo in pairs(f_hero.heroValue.equipInfo.exclusive) do
					if( not table.isEmpty(equipInfo)) then
						equipInfo.itemDesc = ItemUtil.getItemById(equipInfo.item_template_id)
						equipInfo.itemDesc.desc = equipInfo.itemDesc.info
						equipInfo.equip_hid =  tonumber(f_hero.heroValue.hid)
						--table.insert(equipsInfo_t, equipInfo)
						equipsInfo_t[k] = equipInfo
					end
				end
			end
		end
	end
	return equipsInfo_t
end

local function init(...)

end

function destroy(...)
	package.loaded["FormationSpecialModel"] = nil
end

function moduleName()
    return "FormationSpecialModel"
end

function create(...)

end
