-- FileName: VipData.lua
-- Author: huxiaozhou
-- Date: 2015-07-08
-- Purpose: 准备显示vip 礼包特权的数据
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("VipData", package.seeall)
require "db/DB_Vip"
require "db/DB_Vip_desc"
require "script/module/shop/ShopGiftData"
require "script/module/public/PublicInfoCtrl"

local m_i18n = gi18n

-- 获取对应的vip数据
function getVipData( vipLevel )
	local tVipData = {}
	tVipData.tDesc = getVipDesc(vipLevel)
	tVipData.hasGift = getHasVipGift(vipLevel)
	tVipData.gifts = getVipGiftData(vipLevel)
	tVipData.vipLevel = vipLevel
	return tVipData
end

-- 获取是否已经达到最大vip等级
function getIsMaxVipLevel(vipLevel)
	local bMaxLevel = false

	if(vipLevel >= table.count(DB_Vip.Vip)) then -- 判断是否达到最大vip等级
		bMaxLevel = true
	else
		bMaxLevel = false
	end
	return bMaxLevel
end

-- 获取是否包括vip 礼包
function getHasVipGift( vipLevel )
	local vip_gift_ids = nil
	if(vipLevel <= table.count(DB_Vip.Vip)) then
		vip_gift_ids = DB_Vip.getDataById(vipLevel).vip_gift_ids
	end
	if vip_gift_ids then
		return true
	end
	return false
end

-- 获取对应vip等级的礼包
function getVipGiftData(vipLevel)
	if not getHasVipGift(vipLevel) then
		return {}
	end
	local vipData = DB_Vip.getDataById(vipLevel)
	local tbShowItems = RewardUtil.parseRewards(vipData.vip_gift_ids)
	return tbShowItems
end

function getVipDesc(vipLevel)
	local tDesc = DB_Vip_desc.getDataById(vipLevel)
	return tDesc
end

