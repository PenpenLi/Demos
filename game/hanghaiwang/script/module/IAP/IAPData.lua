-- FileName: IAPData.lua
-- Author: huxiaozhou
-- Date: 2015-07-08
-- Purpose:充值数据类
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("IAPData", package.seeall)
require "db/DB_Pay_list"
require "db/DB_Vip_card"
require "script/module/wonderfulActivity/vipcard/VipCardModel"

local _tChargeInfo= {} 
--[[
_tChargeInfo =
{
	charge_gold = int,
	charge_info	= 
	{
		chrage_id = chrage_time,
		chrage_id = chrage_time,
		chrage_id = chrage_time,
	}

}

--]]
function getChargeInfo( )
    return _tChargeInfo
end

-- 设置玩家充值信息
function setChargeInfo(chargeInfo )
    _tChargeInfo = chargeInfo
end

-- 获取已经充值的金币数
function getChargeGoldNum( )
	return _tChargeInfo.charge_gold
end

-- 设置已经充值的金币数
function setChargeGoldNum(chargeGold)
	_tChargeInfo.charge_gold = chargeGold
end

function setIAPInfo( tInfo )
	_tChargeInfo.charge_info = tInfo or {}
end

--获取充值相关信息
function getIAPInfo(  )
    return _tChargeInfo.charge_info
end

function getFirstGiftsInfo(  )
    return _tChargeInfo.first_reward_info
end

function updateFirstGiftInfo( key )
    _tChargeInfo.first_reward_info[key] = 1
end

--是否首充
function getIsFirstCharge(  )
    logger:debug("IAPData getIsFirstCharge")
    logger:debug({_tChargeInfo = _tChargeInfo})
    local tGift = FirstGiftData.getDbData()[1]
    logger:debug({tGift = tGift})
	if tonumber(getChargeGoldNum()) >= tonumber(tGift.gold2) and tonumber(getChargeGoldNum()) >= tonumber(tGift.gold3) then
        logger:debug("IAPData getIsFirstCharge")
       return false
    end
	
    logger:debug("IAPData getIsFirstCharge")
    return true
end

function getHasPayById( _id )
	local hasPay = false
	logger:debug("_id = %s", _id)
	local tCharge_info = _tChargeInfo.charge_info or {}
	for id,time in pairs(tCharge_info) do
		if tonumber(id) == tonumber(_id) then
			hasPay = true
			break
		end
	end
	logger:debug("hasPay = %s", hasPay)
	return hasPay
end


-- 得到充值相关列表商品展示列表
function getPayListData(  )
    local tPayData = {}
    if not Platform.isPlatform() then --  如果是线下 测试用
    	tPayData = DB_Pay_list.getArrDataByField("platform_type", 1)
    else
        logger:debug("Platform.getPL() = %s",Platform.getPL())
		if(Platform.getPL() == "appstore") then
	        tPayData = DB_Pay_list.getArrDataByField("platform_type", 2)
        elseif (Platform.getPL() == "yingyongbao") then
            tPayData = DB_Pay_list.getArrDataByField("platform_type", 3)
	    else
	        tPayData= DB_Pay_list.getArrDataByField("platform_type", 1)
	    end
    end
    local function keySort ( t1, t2 )
        return tonumber(t1.id) < tonumber(t2.id)
    end
    table.sort(tPayData, keySort)
    
    local tDbVipCard = DB_Vip_card.getDataById(1)
    local tPayItem = {}
    tPayItem.bVipCard = true
    tPayItem.product_id = tDbVipCard.itemId
    tPayItem.consume_money = tDbVipCard.rmb
    tPayItem.consume_grade = tDbVipCard.gold
    tPayItem.icon = "jinbi_da.png"
    tPayItem.is_show = 1
    tPayItem.is_recommend = 1
    tPayItem.continueTime = tDbVipCard.continueTime
    tPayItem.rewards = RewardUtil.getItemsDataByStr(tDbVipCard.cardReward)
    tPayItem.isBuy = not VipCardModel.bCanBuy()
    if VipCardModel.bBuyOrNot() then -- 购买过月卡
    	table.insert(tPayData, tPayItem)
    else
    	table.insert(tPayData, 1, tPayItem)
    end
    return tPayData
end

-- 处理充值的数据
function getChargeData()
   local tPayData = getPayListData()
    return tPayData
end
