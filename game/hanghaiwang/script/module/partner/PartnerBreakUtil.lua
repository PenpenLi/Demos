-- FileName: PartnerBreakUtil.lua
-- Author: sunyunpeng
-- Date: 2015-01-11
-- Purpose: 判断英雄是否可以突破
--[[TODO List]]

module("PartnerBreakUtil", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["PartnerBreakUtil"] = nil
end

function moduleName()
    return "PartnerBreakUtil"
end

function create(...)

end

-- 获取突破DB信息
function getBreakDB( htid )
	require "db/DB_Heroes"
	local db_hero = DB_Heroes.getDataById(htid)
	if(db_hero.break_id) then
		require "db/DB_Hero_break"
		local db_break = DB_Hero_break.getDataById(db_hero.break_id)
		return db_break
	end
	return nil
end

-- 检查材料是否够用
function matiarialIsFull( DBHeroBreak )
	-- 突破需要的物品ID及数量组
	local sItemNeeded = DBHeroBreak.cost_item
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

-- 通过hid检查是否可以突破
function checkPartnerCanBreakByHid( Hid )
    local heroInfo = HeroModel.getHeroByHid(Hid)
    if (not heroInfo) then
        return false
    end
    local canTrans = checkPartnerCanBreak(heroInfo.htid,heroInfo.level,heroInfo.evolve_level)
    return canTrans
end


-- 通过htid检查是否可以突破
function checkPartnerCanBreakByHTid( Htid )
	local hid = HeroModel.getHidByHtid(Htid)
    local canBreak = checkPartnerCanBreakByHid(hid)
    return canBreak
end


function checkPartnerCanBreak( htid ,level,transLel)
	local pDB_break = getBreakDB(htid)
	-- 不可突破
	if(not pDB_break) then
		return false
	end

	-- 进阶需要的英雄等级
	local need_strlv = tonumber(pDB_break.need_strlv) or 0
	if(need_strlv > tonumber(level) ) then
		return false
	end

	-- 进阶需要的进阶等级
	local need_advancelv = tonumber(pDB_break.need_advancelv) or 0
	-- 判断武将等级是否足够和进阶等级是否足够
	if( need_advancelv > tonumber(transLel)) then
		return false
	end

    -- 判断材料是否够用
    if (not matiarialIsFull(pDB_break)) then
        return false
    end

	local cost_coin = tonumber(pDB_break.cost_belly) or 0
    -- 判断玩家贝里数量是否足够
    if(tonumber(cost_coin) > UserModel.getSilverNumber()) then
        return false
    end
end
