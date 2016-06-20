-- FileName: ShopGiftData.lua
-- Author:zhangjunwu
-- Date: 2014-04-00
-- Purpose:vip礼包数据
--[[TODO List]]

module("ShopGiftData", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["ShopGiftData"] = nil
end

function moduleName()
	return "ShopGiftData"
end

function create(...)

end

local function fnCompareVipGiftByLevel(h1,h2)
	return h1.level < h2.level
end

local function fnCompareVipGiftByBought(h1,h2)
	local h1Buyed = getVipGiftPurchased(h1.level)
	local h2Buyed = getVipGiftPurchased(h2.level)

	if(h1Buyed == true  and  h2Buyed == true) then
		return fnCompareVipGiftByLevel(h1,h2)
	elseif(h1Buyed == false  and  h2Buyed == false) then
		return fnCompareVipGiftByLevel(h1,h2)
	elseif(h1Buyed == true  and  h2Buyed == false) then
		return false
	elseif(h1Buyed == false  and  h2Buyed == true) then
		return true
	end
end


function getGiftsPackageInfo( ... )
	local vip = UserModel.getVipLevel()
	logger:debug(vip)
	local giftsInfos = {}

	for i=1,vip+4 do
		logger:debug(i)
		logger:debug(table.count(DB_Vip.Vip))
		if(i > table.count(DB_Vip.Vip)) then
			break
		end
		local vipData = DB_Vip.getDataById(i)
		local giftsData  = {}
		logger:debug("getGiftsPackageInfo", i)
		logger:debug(vipData)
		logger:debug(vipData.vip_gift_ids)
		local vip_gift_ids = string.split(vipData.vip_gift_ids, "|")
		logger:debug("i is " .. i)
		logger:debug(vip_gift_ids)
		if(vipData.vip_gift_ids == nil)then
			break
		end

		logger:debug(vip_gift_ids)
		giftsData.id    = vip_gift_ids[1]
		giftsData.oldPrice  = vip_gift_ids[2]
		giftsData.newPrice  = vip_gift_ids[3]
		giftsData.level   = vipData.level

		logger:debug("giftsData.id", giftsData.id)
		--logger:debug(itemInfo)

		local itemInfo = ItemUtil.getItemById(tonumber(giftsData.id))
		giftsData.desc = itemInfo.desc
		giftsData.name = itemInfo.name
		table.insert(giftsInfos, giftsData)
		-- logger:debug("giftsData")
		-- logger:debug(giftsData)
	end
	table.sort(giftsInfos,fnCompareVipGiftByBought)
	logger:debug("giftsInfos")
	logger:debug(giftsInfos)
	return giftsInfos
end

--[[desc:zhangjunwu 获取vip表里 vip礼包配到多少级
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getVipGiftCount( ... )
	local giftCount = 0
	for i=1,table.count(DB_Vip.Vip)do
		-- logger:debug(i)
		-- logger:debug(table.count(DB_Vip.Vip))
		if(i > table.count(DB_Vip.Vip)) then
			break
		end
		local vipData = DB_Vip.getDataById(i)
		if(vipData.vip_gift_ids == nil)then
			break
		else
			giftCount = giftCount + 1
		end
	end
	logger:debug(giftCount)
	return giftCount
end

--得到礼包是否已购买
function getVipGiftPurchased( vipLevel )
	require "script/model/DataCache"
	local shopCache = DataCache.getShopCache()
	local vipGiftInfo = shopCache.va_shop.vip_gift
	if(tonumber(vipGiftInfo[tonumber(vipLevel+1)]) == 1) then
		return true
	else
		return false
	end
end

-- added by zhz
-- 获得首冲礼包的数据
-- function getFirstVipData( ... )
-- 	require "db/DB_First_gift"
-- 	local items ={}
-- 	-- 第一个为金币 , 首冲
-- 	local item = {}
-- 	item.type = "gold"
-- 	item.num = 1
-- 	item.desc = "金币3倍"
-- 	table.insert(items,item)
-- 	local itemInfo = DB_First_gift.getDataById(1)
-- 	-- item
-- 	local reward_item_ids   = string.split(itemInfo.reward_item_ids, ",")
-- 	for k ,v in pairs(reward_item_ids) do
-- 		local tempStrTable = string.split(v, "|")
-- 		local item = {}
-- 		item.tid  = tempStrTable[1]
-- 		item.num = tempStrTable[2]
-- 		item.type = "item"
-- 		logger:debug(item)
-- 		table.insert(items, item)
-- 	end
-- 	if(itemInfo.reward_coin ~= nil ) then
-- 		local item = {}
-- 		item.type = "silver"
-- 		item.num = itemInfo.reward_coin
-- 		table.insert(items,item)
-- 	end

-- 	return items

-- end


--得到礼包物品数据
function getGiftRewardInfo( itemId )
	require "script/module/public/ItemUtil"
	logger:debug(itemId)
	local itemTableInfo = ItemUtil.getItemById(tonumber(itemId))
	local awardItemIds  = string.split(itemTableInfo.award_item_id, ",")
	logger:debug("itemTableInfo.award_item_id", itemTableInfo.award_item_id)
	logger:debug(awardItemIds)
	local items = {}

	for k,v in pairs(awardItemIds) do
		local tempStrTable = string.split(v, "|")
		local item = {}
		item.tid  = tempStrTable[1]
		item.num = tempStrTable[2]
		item.type = "item"
		logger:debug(item)
		table.insert(items, item)
	end
	--"coins", "golds", "energy", "endurance",
	if(itemTableInfo.coins ~= nil) then
		local item = {}
		item.type = "silver"
		item.num  = itemTableInfo.coins
		table.insert(items, item)
	end

	if(itemTableInfo.golds ~= nil) then
		local item = {}
		item.type = "golds"
		item.num  = itemTableInfo.golds
		table.insert(items, item)
	end

	if(itemTableInfo.energy ~= nil) then
		local item = {}
		item.type = "energy"
		item.num  = itemTableInfo.energy
		table.insert(items, item)
	end
	if(itemTableInfo.endurance ~= nil) then
		local item = {}
		item.type = "endurance"
		item.num  = itemTableInfo.endurance
		table.insert(items, item)
	end

	return items
end
