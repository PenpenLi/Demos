-- FileName: treaInfoModel.lua
-- Author:menghao
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("treaInfoModel", package.seeall)
require "db/DB_Item_treasure"
require "db/DB_Hero_break"
require "script/module/partner/HeroPublicUtil"
require "script/module/treasure/TreasureEvolveUtil"


-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local numTreaProperty = 5 --宝物属性组数量

local function init(...)

end

function destroy(...)
	package.loaded["treaInfoModel"] = nil
end

function moduleName()
	return "treaInfoModel"
end

function create(...)

end

--获取宝物类型标示图片
local function fnGetTreaLevelType( cid,star_lv )
	local tbType = {"wind", "thunder", "water", "fire"}
	if (tbType[cid] == nil) then
		tbType[cid] = "common"
		-- return "images/common/transparent.png"
	end
	return "images/hero/" .. tbType[cid] .. "/" .. tbType[cid] .. star_lv .. ".png"
end

--到背包中获取宝物数据
local function fnGetBagTreasure( id )
	local m_tbBagInfo = DataCache.getBagInfo()
	for _,v in pairs(m_tbBagInfo.treas) do
		if (tonumber(v.item_id) == tonumber(id)) then
			return v
		end
	end
end

--到已装备的宝物中获取数据
local function fnGetForTreasure( id )
	local m_tbAllTreas = ItemUtil.getTreasOnFormation() -- 先获取已装备的宝物
	for _,v in pairs(m_tbAllTreas) do
		if (tonumber(v.item_id) == tonumber(id)) then
			return v
		end
	end
end

function fnGetTreasNetData( id )
	local heroTreaInfo = fnGetForTreasure(id)
	if (heroTreaInfo) then
		return heroTreaInfo
	else
		local bagTreaInfo = fnGetBagTreasure(id)
		return bagTreaInfo
	end
end

function getTreaForgeUnclock( treaDB)
	local allExtActive 
	local extActiveArrFeild = treaDB.ext_active_arr
	if (not extActiveArrFeild) then
		return allExtActive
	end
	allExtActive = {}
	local extActiveArrTb = lua_string_split(extActiveArrFeild,",")
	for k,extActiveArr in pairs(extActiveArrTb) do
		local extActiveTb = lua_string_split(extActiveArr,"|")
		local extActive = {}
		local unLockLevel = tonumber(extActiveTb[1])
		local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(extActiveTb[2]),tonumber(extActiveTb[3]))
		extActive.baseInfo = baseInfo
		extActive.displayNum = displayNum
		extActive.realNum = realNum
		extActive.unLockLevel = unLockLevel
		table.insert(allExtActive,extActive)
	end
	return allExtActive
end

--获取宝物所有数据
function fnGetTreasAllData( id )
	local treasNetData = fnGetTreasNetData(id)    -- 从背包 和 阵容上查找宝物信息
	if (treasNetData) then
		local treasData = DB_Item_treasure.getDataById(treasNetData.item_template_id)
		treasNetData.dbData = treasData
	else                                          -- 如果没有则从DB中查找所有信息
		local treaTid = id
		local tbItemInfo = ItemUtil.getItemById(id)
		if (tbItemInfo.isTreasureFragment) then
			treaTid = tbItemInfo.treasureId
		end
		treasNetData = {}						-- 由于阵容和背包没有 所以treasNetData的值都要置为初始值
		treasNetData.dbData = {}
		treasNetData.va_item_text = {}
		treasNetData.dbData = DB_Item_treasure.getDataById(treaTid)

		treasNetData.item_template_id = id
		treasNetData.va_item_text.treasureLevel = 0
		if (treasNetData.dbData.isUpgrade == 1) then
			treasNetData.va_item_text.treasureEvolve = 0
		else
			treasNetData.va_item_text.treasureEvolve = nil
		end
		
		treasNetData.va_item_text.treasureExp = 0
	end
	return treasNetData
end

--宝物开启羁绊数量
function fnOpenFettersNum( id )
	local unionNum = 0
	local firstTable = {}
	local treasAllData = fnGetTreasAllData(id)
	if (treasAllData.dbData) then
		local treasData = treasAllData.dbData
		if treasData.union_info and (treasData.union_info ~= nil) then
			firstTable = string.split(treasData.union_info,",")

			unionNum = table.count(firstTable)
		end
	end

	return unionNum
end

--判断宝物是否开启羁绊
function fnOpenFetters( id )
	if (id) then
		if (fnOpenFettersNum(id) > 0) then
			return true
		end
	end
	return false
end

-- 根据itemId获取宝物信息
function getTreaInfoByItemId( ... )


end


-- 获取宝物在进阶到level时候的属性
function fnTbTreaEvolveInfo( tid,level,maxlel )
	if (tonumber(level) > tonumber(maxlel)) then
		return nil
	end

	local tbBasePro = {}
	require "db/DB_Affix"
	local treasData = DB_Item_treasure.getDataById(tid)

	local tbUpgradeAffix = lua_string_split(treasData.upgrade_affix, ",")
	local tbBaseArr = {}
	for i,upgradeAffix in ipairs(tbUpgradeAffix) do
		local tbAffix = {}
		local upgradeAffix = lua_string_split(upgradeAffix, "|")
		table.insert(tbAffix,upgradeAffix[1])
		local levelUpValue = tonumber(upgradeAffix[2])  * level
		table.insert(tbAffix, levelUpValue)
		table.insert(tbBaseArr,tbAffix)

	end

	for i,baseArr in ipairs(tbBaseArr) do
		local displayName,displayNum,realNum = ItemUtil.getAttrNameAndValueDisplay(tonumber(baseArr[1]),tonumber(baseArr[2]))
		local attrInfo = {}
		attrInfo.name = displayName
		attrInfo.num = displayNum
		table.insert(tbBasePro,attrInfo)
	end
	return tbBasePro

end

--获取宝物属性
function fnGetTreaProperty( tid,level )
	local tbBasePro = {}
	require "db/DB_Affix"
	local treasData = DB_Item_treasure.getDataById(tid)
	for i=1,numTreaProperty do
		local tbProperty = {}
		local proBaseTemp = treasData["base_attr" .. i]
		local proAddRowTemp = treasData["increase_attr" .. i]
		local blexpTreas = ItemUtil.isGoldOrSilverTreas(tid)
		if (proBaseTemp) then
			local proBaseArr = lua_string_split(proBaseTemp, "|")
			if (#proBaseArr == 2) then
				local baseValue = tonumber(proBaseArr[2])
				if (tonumber(level) > 0 and proAddRowTemp) then
					local proRowArr = lua_string_split(proAddRowTemp, "|")
					baseValue = baseValue + tonumber(proRowArr[2]) * tonumber(level)
				end
				local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(proBaseArr[1]),baseValue)
				tbProperty.name = baseInfo.displayName
				tbProperty.value = displayNum
				table.insert(tbBasePro,tbProperty)
			end
		else
			if (blexpTreas) then
				tbProperty.name = m_i18n[1723]
				tbProperty.value = treasData.base_exp_arr
				table.insert(tbBasePro,tbProperty)
			end

		end
	end

	

	return tbBasePro
end

-- 获取宝物的基础属性
function fnGetTreaBaseProperty( tid,level )
	-- 添加基础属性
	local tbBasePro = {}
	require "db/DB_Affix"
	local treasData = DB_Item_treasure.getDataById(tid)
	local  extActiveArrs = treasData.ext_active_arr
	if (extActiveArrs) then
		extActiveArrs = lua_string_split(extActiveArrs, ",")
		extActiveArrs = extActiveArrs[1] and {extActiveArrs[1]} or {}
		for i,v in ipairs(extActiveArrs) do
			local tbProperty = {}
			local extActiveArr = lua_string_split(v, "|")
			if (extActiveArr) then
				local unLockLevel = tonumber(extActiveArr[1])
				if (tonumber(level) >= unLockLevel) then
					local attrID = extActiveArr[2]
					local attValue = extActiveArr[3]
					local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(attrID),attValue)
					tbProperty.name = baseInfo.displayName
					tbProperty.value = displayNum
					table.insert(tbBasePro,tbProperty)
				end
			end

		end
	end
	return tbBasePro
end

--获取解锁属性
function fnGetUnlockInfo(tid) -- zhangqi, 2015-06-15
	local tbExtAct = {}
	local _, _, ext_active, _, _ = ItemUtil.getTreasAttrByTmplId(tid) -- zhangqi, 2015-06-15
	for _,v in ipairs(ext_active) do
		if (v.attId ~= nil) then
			local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(v.attId),v.num)
			table.insert(tbExtAct,{name=baseInfo.displayName,value=displayNum,openLv=v.openLv,isOpen=v.isOpen})
		end
	end
	return tbExtAct
end

--获取羁绊的增强数值
function fuGetunionProfitNums( treaUnionInfo,hid )
    local tbHeroInfo = DB_Heroes.getDataById(hid)
    local heroUnionInfo =treaUnionInfo -- DB_Union_profit.getDataById(unioninfoID)
	local unionProfitNums = string.split(heroUnionInfo.union_arribute_nums , ",") 

	local unionProfitQualitys = string.split(heroUnionInfo.quality , ",")
	local unionProfitQualityIndex
	for k,v in pairs(unionProfitQualitys) do
	    if ( tonumber(v) == tonumber(tbHeroInfo.heroQuality) ) then 
	        unionProfitQualityIndex = k
	    end
	end
	unionProfitNum = tonumber(string.split(unionProfitNums[unionProfitQualityIndex],"|")[1] or 0)/100
	return unionProfitNum
 
end

--获取羁绊属性,unionInfo参数为羁绊信息id组
function fnGetUnionInfo( unionInfo )
	local tbUnion = {}
	if (unionInfo) then
		logger:debug({fnGetUnionInfo = unionInfo})
		local unionTemp = lua_string_split(unionInfo,",")
		for i=1, #unionTemp do
			local unionHeroTemp = lua_string_split(unionTemp[i],"|")

			local tid = unionHeroTemp[1]
			local heroBreak = DB_Hero_break.Hero_break["id_" .. tid]

			if ( heroBreak ) then -- zhangqi, 2015-06-15
				if (HeroUtil.getHeroNumByHtid(heroBreak.after_id) >0 ) then
					tid = heroBreak.after_id
				end
			end

			local name = nil
			if (tonumber(tid) == 20001) then
				tid = UserModel.getAvatarHtid()
				name = UserModel.getUserName()
			end
			logger:debug({fnGetUnionInfo = unionHeroTemp})
			if (not unionHeroTemp[2] or tonumber(unionHeroTemp[2]) == 0) then
				return {}
			end
			local treaUnionInfo = DB_Union_profit.getDataById(unionHeroTemp[2])

			-- TimeUtil.timeStart("fnGetUnionInfo 2 slow") -- 2015-06-10
			local itemBtn, itemInfo = HeroUtil.createHeroIconBtnByHtid(tid)
			-- TimeUtil.timeEnd() -- 2015-06-10

			tbUnion[i] = {}
			tbUnion[i].unionProfitNum = fuGetunionProfitNums( treaUnionInfo,tid ) or 0
			tbUnion[i].unionName = treaUnionInfo.union_arribute_name
			tbUnion[i].unionDesc = treaUnionInfo.union_arribute_desc
			tbUnion[i].itemIcon = itemBtn
			tbUnion[i].heroName = itemInfo.name
			tbUnion[i].quality = itemInfo.quality

			if name then
				tbUnion[i].heroName = name
			end
			tbUnion[i].nameColor = g_QulityColor[itemInfo.quality]
		end
	end

	return tbUnion

end

--获取精炼需要数据
function fnGetEvolveInfo( id,srcType)
	local tbOInfo = {}
	local tbNInfo = {}

	local tbExcept = {g_treaInfoFrom.layFromOtherType, g_treaInfoFrom.layFromRobType, 5, 6} -- zhangqi, 2015-06-11
	if (not table.include(tbExcept, srcType)) then
		local treasNetData = fnGetTreasNetData(id)
	    if (treasNetData) then
			if (TreasureEvolveUtil.isUpgrade(id)) then
				local oldInfo = TreasureEvolveUtil.getOldAffix(id)
				local newInfo = TreasureEvolveUtil.getNewAffix(id)

				tbOInfo.lv = oldInfo.evolveLevel
				local i = 1
				local tbaffix = {}
				for k,v in pairs(oldInfo.affix) do
					tbaffix[i] = {}
					tbaffix[i].name = v.name
					tbaffix[i].value = TreasureEvolveUtil.AffixDisplayTransform(v.id, v.num)
					i = i+1
				end
				tbOInfo.tbAffix = tbaffix

				tbNInfo.lv = newInfo.evolveLevel
				i = 1
				tbaffix = {}
				for k,v in pairs(newInfo.affix) do
					tbaffix[i] = {}
					tbaffix[i].name = v.name
					tbaffix[i].value = TreasureEvolveUtil.AffixDisplayTransform(v.id, v.num)
					i = i+1
				end
				tbNInfo.tbAffix = tbaffix
			end
		end
	end

	return {tbOInfo, tbNInfo}
end


function fnGetAwakeInfo( dbData, hid)
	if ( dbData.awakeId ) then
		local awakeId
		local tbawake= string.split(dbData.awakeId,"|")


		local tbAwake = {}
		local heroId
		local tbHeroId= string.split(dbData.heroId,"|")
		if (#tbHeroId==2 ) then
			if (HeroUtil.getHeroNumByHtid( tbHeroId[2]) >0 ) then
				heroId = tbHeroId[2]
				awakeId = tbawake[2]
			else
				heroId = tbHeroId[1]
				awakeId = tbawake[1]
			end
		elseif (#tbHeroId==1) then
			heroId = tbHeroId[1]
			awakeId = tbawake[1]
		end
		local data = DB_Heroes.getDataById(heroId)

		tbAwake.heroName = data.name
		tbAwake.heroQuality = data.potential
		if (hid) then
			local htid = HeroModel.getHeroByHid(hid).htid
			tbAwake.isOpen = (tonumber(htid) == heroId)
		else
			tbAwake.isOpen = false
		end

		tbAwake.awakeDes = DB_Awake_ability.getDataById(awakeId).des

		return tbAwake
	else
		return nil
	end
end

-- zhangqi, 2015-06-11, 根据其他模块的实际需求对fnGetTreaInfo进行简化, 避免无谓的时间消耗
function getSimpleTreaInfo( id, numSrcType )
	local treaInfo = {}

	treaInfo.treaData = fnGetTreasAllData(id)
	local treaData = treaInfo.treaData
	local treaDb = treaData.dbData

	treaInfo.name = treaDb.name
	treaInfo.tid = treaData.item_template_id
	treaInfo.level = treaData.va_item_text.treasureLevel
	treaInfo.quality = treaDb.quality --星级
	treaInfo.base_score = treaDb.base_score --品级
	treaInfo.property = fnGetTreaProperty(treaDb.id,treaData.va_item_text.treasureLevel)
	treaInfo.baseProperty = fnGetTreaBaseProperty(treaDb.id,treaData.va_item_text.treasureLevel)
	treaInfo.treaEvolve = fnGetEvolveInfo(id,numSrcType)

	treaInfo.exp = treaData.va_item_text.treasureExp --  tonumber(treaData.va_item_text.treasureExp) + tonumber(treaDb.base_exp_arr)
	treaInfo.icon_big = "images/base/treas/big/" .. treaDb.icon_big
	-- treaInfo.ext_active = fnGetUnlockInfo(treaInfo.tid)

	return treaInfo
end


--获取宝物信息需要的数据
-- zhangqi, 2015-06-15, 已经用 getSimpleTreaInfo 代替，暂时注释掉
-- function fnGetTreaInfo( id,numSrcType )
-- 	local treaInfo = {}

-- 	local treaData = fnGetTreasAllData(id)
-- 	local treaDb = treaData.dbData

-- 	treaInfo.treaData = treaData
-- 	treaInfo.name = treaDb.name
-- 	treaInfo.tid = treaDb.id
-- 	treaInfo.quality = treaDb.quality --星级
-- 	treaInfo.base_score = treaDb.base_score --品级
-- 	treaInfo.icon_small = "images/base/treas/icon_small/" .. treaDb.icon_small
-- 	treaInfo.icon_big = "images/base/treas/big/" .. treaDb.icon_big
-- 	treaInfo.info = treaDb.info
-- 	treaInfo.typeIcon = fnGetTreaLevelType(treaDb.type,treaDb.quality) --类型
-- 	treaInfo.treabg = "images/item/equipinfo/card/equip_" .. treaDb.quality .. ".png"
-- 	treaInfo.isExpTreasure = treaDb.isExpTreasure

-- 	treaInfo.property = fnGetTreaProperty(treaDb.id,treaData.va_item_text.treasureLevel)
-- 	treaInfo.level = treaData.va_item_text.treasureLevel
-- 	treaInfo.exp = treaData.va_item_text.treasureExp
-- 	treaInfo.ext_active = fnGetUnlockInfo(treaInfo.tid)

-- 	treaInfo.treaEvolve = fnGetEvolveInfo(id,numSrcType)

-- 	-- TimeUtil.timeStart("fGetTreaInfo 6 slow") -- 2015-06-10
-- 	treaInfo.unionInfo = fnGetUnionInfo(treaDb.union_info)
-- 	-- TimeUtil.timeEnd() -- 2015-06-10

-- 	treaInfo.awakeInfo = fnGetAwakeInfo(treaDb, treaInfo.treaData.equip_hid)
	
-- 	return treaInfo
-- end
