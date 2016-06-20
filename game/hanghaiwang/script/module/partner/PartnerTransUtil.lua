-- FileName: PartnerTransUtil.lua
-- Author: sunyunpeng
-- Date: 2015-11-18
-- Purpose: 检查进阶红点
--[[TODO List]]

module("PartnerTransUtil", package.seeall)
require "script/module/partnerAwakening/MainAwakeModel"

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["PartnerTransUtil"] = nil
end

function moduleName()
    return "PartnerTransUtil"
end

--
function getTransid( htid ,evolveLevel)
    require "db/DB_Heroes"
    local db_hero = DB_Heroes.getDataById(htid)
    local arrTimeIds = {}
    if db_hero.advanced_id then
        local tmp = string.split(db_hero.advanced_id, ",")
        for i=1, #tmp do
            local times_transId = string.split(tmp[i], "|")
            table.insert(arrTimeIds, {times=tonumber(times_transId[1]), transId=tonumber(times_transId[2])})
        end
    end
    logger:debug({getTransNewHtid = arrTimeIds})
    local transId = nil
    if evolveLevel then
        for i=1, #arrTimeIds do
            if arrTimeIds[i].times == tonumber(evolveLevel) then
                transId = arrTimeIds[i].transId
                break
            end
        end
    end

    return transId
end

-- 检查材料是否够用
function matiarialIsFull( DBHeroTransfer )
    -- 进阶需要的物品ID及数量组
    require "db/DB_Item_normal"
    local sItemNeeded = DBHeroTransfer.need_items
    local tArrItemNeeded = string.split(sItemNeeded, ",")
    require "script/module/public/ItemUtil"

    local bag = DataCache.getRemoteBagInfo()
    local props = bag.props
    local heroFrag = bag.heroFrag

    for i,needItem in ipairs(tArrItemNeeded) do

        local tbItemInfo = string.split(needItem, "|")
        local itemID = tonumber(tbItemInfo[1])
        if #tbItemInfo < 2 then
            tbItemInfo[2] = 1
        end
        local ItemType = ItemUtil.getItemTypeByTid(itemID)
        local needCount = tonumber(tbItemInfo[2])
        local checkBag = ItemType.isNormal and props or (ItemType.isShadow and heroFrag or {}) 
    	local realCount = 0
    	for k, v in pairs( checkBag ) do
            if  (tonumber(v.item_template_id) == itemID) then
                realCount = realCount + tonumber(v.item_num)
            end
	    end
        if (realCount < needCount) then
        	return false
        end
    end
    return true
end


-- 2015-11-17 sunyunpeng 判断是否可以进阶
function checkPartnerCanTrans( htid ,level,TransLel)
	-- 判断主角等是否足够
	local transId = getTransid(htid,TransLel) 
	--  是否到最大进阶等级
	if (not transId) then
		return false
	end

	local DBHeroTransfer = DB_Hero_transfer.getDataById(transId)

    if(DBHeroTransfer.need_player_lv > tonumber(UserModel.getHeroLevel())) then
        return false
    end
    -- 判断武将等级是否足够
    local nLimitLevel = DBHeroTransfer.limit_lv

    if(tonumber(nLimitLevel) > tonumber(level)) then
        return false
    end
    -- 判断是否达到最大进阶等级

    -- 判断材料是否够用
    if (not matiarialIsFull(DBHeroTransfer)) then
        return false
    end
    -- 判断玩家贝里数量是否足够
    if(tonumber(DBHeroTransfer.cost_coin) > UserModel.getSilverNumber()) then
        return false
    end
    return true
end


-- 通过hid检查是否可以进阶
function checkPartnerCanTransByHid( Hid )
    local heroInfo = HeroModel.getHeroByHid(Hid)
    if (not heroInfo) then
        return false
    end
    local canTrans = checkPartnerCanTrans(heroInfo.htid,heroInfo.level,heroInfo.evolve_level)
    return canTrans
end


-- sunyunpeng 2015-11-17 得到是否有伙伴可以进阶
function getIsHaveHroAdvanced( ... )
	local squadInfo = DataCache.getSquad()
	for k,squadHid in pairs(squadInfo or {}) do
		if (tonumber(squadHid) > 0) then
			local squadHero = HeroModel.getHeroByHid(squadHid)
			logger:debug({getIsHaveHroAdvanced = squadHero})
            -- 线上报错 attempt to index local 'squadHero' (a nil value)
			if (squadHero and checkPartnerCanTrans(squadHero.htid,squadHero.level,squadHero.evolve_level)) then
				return true
			end
            -- 新增觉醒红点判断
            if (squadHero and MainAwakeModel.isCanAwakeByHid( squadHid )) then
                return true
            end
		end
	end

	local benchInfo = DataCache.getBench()
	for k,benchHid in pairs(benchInfo or {}) do
		if (tonumber(benchHid) > 0) then
			local benchHero = HeroModel.getHeroByHid(benchHid)
			if (benchHero and checkPartnerCanTrans(benchHero.htid,benchHero.level,benchHero.evolve_level)) then
				return true
			end
            -- 新增觉醒红点判断
            if (squadHero and MainAwakeModel.isCanAwakeByHid( benchHid )) then
                return true
            end
		end
	end

	return false
end
