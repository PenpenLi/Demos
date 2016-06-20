-- FileName: TreaShopData.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 宝物商店数据
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("TreaShopData", package.seeall)

require "db/DB_Exclusiveshop"
require "db/DB_Exclusivegoods"
require "db/DB_Vip"

-- 模块局部变量 --
local _shopInfo= {}
local _shopData = DB_Exclusiveshop.getDataById(1) -- 商店配置数据

-- 获取拉取的网络商店数据
function getShopInfo(  )
    return _shopInfo
end

-- 设置拉取的网络数据
function setShopInfo(shopInfo)
    _shopInfo = shopInfo    
end


-- 如果是金币刷新则计算本次金币刷新需要的金币
function getRfrGoldNum(  )
	local goldStr = _shopData.gold
	local tArr = lua_string_split(goldStr, ",")
	local rfrNum = tonumber(_shopInfo.player_refresh_num)+1
		
	for i,v in ipairs(tArr) do
		local tSubArr = lua_string_split(v, "|")
		if rfrNum < tonumber(tSubArr[1]) then
			return tonumber(lua_string_split(tArr[i-1], "|")[2])
		end
	end
	if rfrNum > tonumber(lua_string_split(tArr[#tArr], "|")[1]) then
		return tonumber(lua_string_split(tArr[#tArr], "|")[2])
	end
	return tonumber(lua_string_split(tArr[1], "|")[2])
end

-- 获取当前拥刷新令数量
function getItemNum()
    return ItemUtil.getCacheItemNumBy(_shopData.item)
end

-- 获取是否已经达到最大刷新次数
function isRfrMax(  )
    local limitTimes = DB_Vip.getDataById(tonumber(UserModel.getVipLevel())).exclusive_gold_limit
    if( tonumber(limitTimes)>tonumber(_shopInfo.player_refresh_num +_shopInfo.item_refresh_num) ) then
        return false
    end
    return true
end

function getFreeLimit( ... )
	local free_limit = DB_Vip.getDataById(tonumber(UserModel.getVipLevel())).exclusive_free_limit
	return tonumber(free_limit)
end

function getLastRfrTimes( ... )
	local limitTimes = DB_Vip.getDataById(tonumber(UserModel.getVipLevel())).exclusive_gold_limit
	return tonumber(limitTimes-_shopInfo.player_refresh_num - _shopInfo.item_refresh_num)
end


-- 获取剩余免费
function getFreeTimes( )
    return tonumber(_shopInfo.sys_refresh_num) or 0
end

function addFreeTimes()
	_shopInfo.sys_refresh_num = tonumber(_shopInfo.sys_refresh_num) + 1
end

function setRfrCdTime(  )
	_shopInfo.sys_refresh_time = _shopInfo.sys_refresh_time + _shopData.cdtime
end

--[[
    @des:       得到刷新剩余时间
    @return:    time interval
]]
function getRefreshCdTime( )
    local endRfrTime = tonumber(_shopInfo.sys_refresh_time)
    local time =  _shopData.cdtime - (TimeUtil.getSvrTimeByOffset() - endRfrTime)
    if(time > 0) then
        return time 
    else
        return 0
    end
end


-- 获得
function getGoodsListData(  )
    local items ={}
    for goodsId,canBuyNum in pairs(_shopInfo.goods_list or {}) do 
        local item = {}
        local goodData = DB_Exclusivegoods.getDataById(tonumber(goodsId))
        local goods = lua_string_split(goodData.items,"|")
        item.id = goodData.id
        item.tid = tonumber(goods[1]) 
        item.num = tonumber(goods[2])
        item.canBuyNum= tonumber(canBuyNum)
        item.costNum= tonumber(goodData.costNum)
        item.costType= tonumber(goodData.costType) 
        item.recommended = tonumber(goodData.recommended)
        table.insert(items, item)
    end
    return items
end

--[[
    @des:       修改神秘商店里canBuyNum
]]
function changeCanBuyNumByid( _goodsId , num)
    for goodsId, canBuyNum  in pairs(_shopInfo.goods_list) do 
        if(tonumber(goodsId)==tonumber(_goodsId)) then
            _shopInfo.goods_list[goodsId] = tonumber(canBuyNum) - num or 1
            break
        end
    end
end

