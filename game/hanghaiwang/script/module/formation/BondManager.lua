-- FileName: BondManager.lua
-- Author: yucong
-- Date: 2015-07-23
-- Purpose: 羁绊管理器
--[[TODO List]]

module("BondManager", package.seeall)

require "script/module/formation/BondData"
require "db/DB_Union_profit"

BOND_OPEN = 1 	-- 已激活
BOND_REACHED = 2 	-- 可激活
BOND_NOT_REACHED = 3 -- 不可激活

BOND_MSG = {
	CB_BOND_HERO = "CB_BOND_HERO",	-- 获取英雄羁绊
	CB_BOND_FORMATION = "CB_BOND_FORMATION",	-- 获取阵容羁绊
	CB_BOND_OPEN = "CB_BOND_OPEN",	-- 激活羁绊
}

-- 获取羁绊详细
-- return: 
-- tBondInfo = {
-- 	state,	-- 状态
-- 	models,	-- 包含的伙伴 {modelId = 是否在图鉴}
-- 	type,	-- 类型 1 伙伴,2 宝物,3 装备
-- 	attrDes,-- 加成的属性描述
--	treaId,	-- 宝物Id
-- }
function getBond( bid, hid )
	local isOpen, _, __, tBondInfo = FormationUtil.isUnionActive(bid, hid)
	tBondInfo["attrDes"] = getBondAttribute(bid, HeroModel.getHtidByHid(hid))
	return tBondInfo
end

-- 获取羁绊加成描述
function getBondAttribute( bid, htid )
	local db_bondInfo = DB_Union_profit.getDataById(bid)
	local tbHeroInfo = DB_Heroes.getDataById(htid)
	-- 羁绊增强数值table
    local unionProfitNums = string.split(db_bondInfo.union_arribute_nums , ",") 
    -- 品质table
    local unionProfitQualitys = string.split(db_bondInfo.quality , ",")
    local unionProfitQualityIndex
    for k,v in pairs(unionProfitQualitys) do
        if (tonumber(v) == tonumber(tbHeroInfo.heroQuality)) then 
            unionProfitQualityIndex = k
        end
    end

    local unionProfitNum = tonumber(string.split(unionProfitNums[unionProfitQualityIndex],"|")[1] or 0)/100
    if db_bondInfo.union_arribute_desc == nil then
        db_bondInfo.union_arribute_desc = " "
    end
    return db_bondInfo.union_arribute_desc .. unionProfitNum .. "%"
end

-- 获取饰品对应伙伴的羁绊id
function getTreasureBondId( hid, treaId )
    local htid = HeroModel.getHtidByHid(hid)
    local tbHeroInfo = DB_Heroes.getDataById(htid)
    local bondInfo = tbHeroInfo.link_group1
    if bondInfo then
        local tbBondInfo = lua_string_split(bondInfo, ",")
        --logger:debug(tbBondInfo)
        for k, bid in pairs(tbBondInfo) do
            local t_union_profit = DB_Union_profit.getDataById(tonumber(bid))
            --logger:debug(t_union_profit)
            local card_ids = string.split(t_union_profit.union_card_ids, ",")
            for k1, v1 in pairs(card_ids) do
                local info = string.split(v1, "|")
                if (tonumber(info[1]) == 2 and tonumber(info[2]) == tonumber(treaId)) then
                    return t_union_profit.id
                end 
            end
        end
    end
    return nil
end

-- 获取otherHtid是否可以激活htid的羁绊，返回羁绊id，没有返回nil
function getHeroBondIdWithOther( htid, otherHtid )
    local otherModelId = HeroModel.getHeroModelId(otherHtid)
    local tbHeroInfo = DB_Heroes.getDataById(htid)
    local bondInfo = tbHeroInfo.link_group1
    if bondInfo then
        local tbBondInfo = lua_string_split(bondInfo, ",")
        --logger:debug(tbBondInfo)
        for k, bid in pairs(tbBondInfo) do
            local t_union_profit = DB_Union_profit.getDataById(tonumber(bid))
            --logger:debug(t_union_profit)
            local card_ids = string.split(t_union_profit.union_card_ids, ",")
            for k1, v1 in pairs(card_ids) do
                local info = string.split(v1, "|")
                if (tonumber(info[1]) == 1 and tonumber(info[2]) == tonumber(otherModelId)) then
                    return t_union_profit.id
                end 
            end
        end
    end
    return nil
end

-- 指定的htid是否可以激活阵容上的羁绊
-- @param otherHtid 需要判断的htid
-- @param isFragment 是否是碎片。碎片需要判断当前是否拥有这个碎片，没有返回true
function isHtidCanActiveFormation( otherHtid, isFragment )
    isFragment = isFragment or true
    TimeUtil.timeStart("isHeroCanActiveFormation")
    for k, f_hid in pairs(DataCache.getSquad() or {}) do
        if(tonumber(f_hid)>0)then
            local htid = HeroModel.getHtidByHid(f_hid)
            local unionId = getHeroBondIdWithOther(htid, otherHtid)
            if (unionId) then
                -- 羁绊没有激活并且人物没有在图鉴中
                if (not isOpen(f_hid, unionId) and not DataCache.isInHeroBook(otherHtid)) then
                    if (isFragment) then
                        return HeroModel.getHidByHtid(otherHtid) == 0
                    end
                    return true
                end
            end
        end
    end
    for k,f_hid in pairs(DataCache.getBench() or {}) do
        if(tonumber(f_hid)>0)then
            local htid = HeroModel.getHtidByHid(f_hid)
            local unionId = getHeroBondIdWithOther(htid, otherHtid)
            if (unionId and not result) then
                if (not isOpen(f_hid, unionId) and not DataCache.isInHeroBook(otherHtid)) then
                    if (isFragment) then
                        return HeroModel.getHidByHtid(otherHtid) == 0
                    end
                    return true
                end
            end
        end
    end
    TimeUtil.timeEnd("isHeroCanActiveFormation")
    return false
end

-- 指定的饰品id是否可以激活阵容上的羁绊
-- @param isFragment 是否是碎片。碎片需要判断当前是否拥有这个碎片，没有返回true
function isTreaCanActiveFormation( treaId, isFragment )
    isFragment = isFragment or true
    TimeUtil.timeStart("isTreaCanActiveFormation")
    for k, f_hid in pairs(DataCache.getSquad() or {}) do
        if(tonumber(f_hid)>0)then
            local unionId = getTreasureBondId(f_hid, treaId)
            if (unionId and not result) then
                -- 是否装备了宝物
                if (not HeroModel.checkTreasureStatus(f_hid, treaId)) then
                    if (isFragment) then
                        return TreasureEvolveUtil.getItemNumByTid(treaId) == 0
                    end
                    return true
                end
            end
        end
    end
    for k,f_hid in pairs(DataCache.getBench() or {}) do
        if(tonumber(f_hid)>0)then
            local unionId = getTreasureBondId(f_hid, treaId)
            if (unionId and not result) then
                -- 是否装备了宝物
                if (not HeroModel.checkTreasureStatus(f_hid, treaId)) then
                    if (isFragment) then
                        return TreasureEvolveUtil.getItemNumByTid(treaId) == 0
                    end
                    return true
                end
            end
        end
    end
    TimeUtil.timeEnd("isTreaCanActiveFormation")
    return false
end
-- 指定伙伴的指定羁绊是否激活
function isOpen( hid, bid, isOther )
    local htid = HeroModel.getHtidByHid(hid)
    return BondData.isBondOpen(htid, bid, isOther)
end
