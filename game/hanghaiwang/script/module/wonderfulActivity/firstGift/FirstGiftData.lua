-- FileName: FirstGiftData.lua
-- Author: huxiaozhou
-- Date: 2015-08-06
-- Purpose: 首充礼包
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("FirstGiftData", package.seeall)
require "db/DB_First_gift"

function getFirstGifts(  )
	 logger:debug("Platform.getPL() = %s",Platform.getPL())
	 local ttRewads = {}
	 local tttRewads = {}
	 local ttttRewads = {}
	 local tGifts = getDbData()
	 for i,v in ipairs(tGifts) do
	  	local tRewards = RewardUtil.parseRewards(v.reward_item_ids)
	  	table.insert(ttRewads, tRewards)
	  	local tRewards = RewardUtil.parseRewards(v.reward2)
	  	table.insert(tttRewads, tRewards)
	  	local tRewards = RewardUtil.parseRewards(v.reward3)
	  	table.insert(ttttRewads, tRewards)
	  end
	  return {ttRewads, tttRewads, ttttRewads} 
end



function getDbData( )
	local tGifts = {}
	if(Platform.getPL() == "appstore") then
        tGifts = DB_First_gift.getArrDataByField("platform_type", 2)
    elseif (Platform.getPL() == "yingyongbao") then
        tGifts = DB_First_gift.getArrDataByField("platform_type", 3)
    else
        tGifts= DB_First_gift.getArrDataByField("platform_type", 1)
    end
    return tGifts
end

local tGift = FirstGiftData.getDbData()[1]
local tKeys = {1, tGift.gold2, tGift.gold3}

local tStrRewards = {tGift.reward_item_ids, tGift.reward2, tGift.reward3}
function gettStrRewardsByIndex( index )
	return tStrRewards[index]
end
function gettRewardsByIndex( index, bSave)
	return RewardUtil.parseRewards(tStrRewards[index], bSave)
end


function getPlatformType(  )
	local platformType = 1
	if(Platform.getPL() == "appstore") then
        platformType = 2
    elseif (Platform.getPL() == "yingyongbao") then
       	platformType = 3
    else
        platformType = 1
    end
    return platformType
end


function getKeyByIndex( index )
	return tKeys[index]
end

function getFirstRewardData(  )
	return IAPData.getFirstGiftsInfo()
end

function setFirstReward( index )
	local key = getKeyByIndex(index)
	IAPData.updateFirstGiftInfo(key)
end

function getHasGetFirstGiftById( index )
	local id = getKeyByIndex(index)
	local tFirstInfo = getFirstRewardData()
	local hasGet = false
	for k,v in pairs(tFirstInfo or {}) do
		if tonumber(id) == tonumber(k) then
			hasGet = true
			break
		end
	end
	return hasGet
end

function getCanGetGiftsByIndex( index )
	local key = getKeyByIndex(index)
	local chargeGold = IAPData.getChargeGoldNum()
	if tonumber(chargeGold)>=key then
		return true
	end
	return false
end

function isShowFirstGifts( ... )
	return table.count(getFirstRewardData()) <3
end

function getHasGift( )
	local chargeGold = IAPData.getChargeGoldNum()
	for i,v in ipairs(tKeys) do
		if tonumber(chargeGold)>=tonumber(v) then
			return true
		end
	end
	return false
end

function getRedNum( ... )
	local chargeGold = IAPData.getChargeGoldNum()
	local count = 0
	for i,v in ipairs(tKeys) do
		if tonumber(chargeGold)>=tonumber(v) then
			count = count+1
		end
	end
	return count - table.count(getFirstRewardData())
end

function getShowRedPoint(  )
	return isShowFirstGifts() and getHasGift() and getRedNum()>0
end
