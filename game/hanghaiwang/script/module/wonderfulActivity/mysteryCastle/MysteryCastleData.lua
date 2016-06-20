-- FileName: MysteryCastleData.lua
-- Author: huxiaozhou
-- Date: 2014-05-19
-- Purpose: 神秘城堡 数据缓存
--[[TODO List]]
-- Jewel number 控制台命令


module("MysteryCastleData", package.seeall)

require "script/module/public/ItemUtil"
require "db/DB_Mystical_goods"
require "db/DB_Mystical_shop"
require "db/DB_Vip"

castleScheduleId = nil -- 定时器
-- 模块局部变量 --
local _shopInfo= {}
local shopData = DB_Mystical_shop.getDataById(1)
function  getShopInfo(  )
    return _shopInfo
end

function setShopInfo( shopInfo)
    _shopInfo = shopInfo    
end

--[[
    @des:       得到本次刷新花费的金币数量
    @return:    金币数
]]
function getRfrGoldNum( )
    local baseGold = tonumber(shopData.baseGold)
    local growGold= tonumber(shopData.growGold)*(tonumber(_shopInfo.refresh_num))
    local costGoldNum= baseGold+growGold
    return costGoldNum
end

-- 获取当前拥刷新令数量
function getItemNum()
    return ItemUtil.getCacheItemNumBy(shopData.item)
end 

-- 判断当前刷新次数是否达到最大值，true:到了， false:没有
function isRfrMax( )
    require "script/model/user/UserModel"
    local mysteryShopTimes = DB_Vip.getDataById(tonumber(UserModel.getVipLevel())).mystical_shop_time
    print("mystical_shop_time  is ,", tonumber(mysteryShopTimes))
    if( tonumber(mysteryShopTimes)>tonumber(_shopInfo.refresh_num) ) then
        return false
    end
    return true
end

-- 获得还有几次非免费刷新次数
function getLastRfrTimes( ... )
    local limitTimes = DB_Vip.getDataById(tonumber(UserModel.getVipLevel())).mystical_shop_time
    return tonumber(limitTimes-_shopInfo.refresh_num)
end


-- 获取剩余免费
function getFreeTimes( )
    return _shopInfo.sys_refresh_num
end

function setFreeTimes(  )
    _shopInfo.sys_refresh_num = _shopInfo.sys_refresh_num + 1
end

function resetSysRefreshTimes(  )
    _shopInfo.sys_refresh_time = _shopInfo.sys_refresh_time + shopData.cd
end

--[[
    @des:       得到刷新剩余时间
    @return:    time interval
]]
function getRefreshCdTime( )
    local endRfrTime = tonumber(_shopInfo.sys_refresh_time)
    local time =  shopData.cd - (TimeUtil.getSvrTimeByOffset() - endRfrTime)
    if(time > 0) then
        return time 
    else
        return 0
    end
end


-- 读取
function isMysteryNewIn( )
    if (not SwitchModel.getSwitchOpenState(ksSwitchResolve,false)) then
        return false
    end
    if( getFreeTimes()~=nil and tonumber(getFreeTimes()) > 0 ) then
        return true
    else
        return false
    end
end

--[[
    @des:       得到物品的table
    @return:    table{
        item = {
            id : DB_Mystical_goods里的id
            type = 1：物品ID 2：英雄ID
            tid : 对应物品或英雄的模板id
            num: 出售的数量
            canBuyNum: 可以购买的次数
            costNum： 花费的数值
            costType: 1：花费类型为魂玉 , 2：花费类型为金币
        }
            
    }
]]

function getGoodsListData(  )
    local items ={}
    for goodsId,canBuyNum in pairs(_shopInfo.goods_list) do 
        local item = {}
        local goodData = DB_Mystical_goods.getDataById(tonumber(goodsId))
        local goods = lua_string_split(goodData.items,"|")
        item.id = goodData.id
        item.type = tonumber(goods[1])
        item.tid = tonumber(goods[2]) 
        item.num = tonumber(goods[3])
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
    @return:    
]]
function changeCanBuyNumByid( _goodsId , value)
    for goodsId, canBuyNum  in pairs(_shopInfo.goods_list) do 
        if(tonumber(goodsId)==tonumber(_goodsId)) then
          ---  print("gooId  is  :" goodsId, "  id is : ", id)
            _shopInfo.goods_list[goodsId] = tonumber(canBuyNum) - value or 1
            break
        end
    end
end

