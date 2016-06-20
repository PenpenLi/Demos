-- FileName: VipGiftModel.lua
-- Author: lvnanchun
-- Date: 2015-08-12
-- Purpose: vip礼包业务逻辑
--[[TODO List]]

module("VipGiftModel", package.seeall)
require "db/DB_Vipsalary"
require "db/DB_Vip"
require "db/DB_Item_direct"

-- UI variable --

-- module local variable --
local DB_Vipsalary = DB_Vipsalary
local DB_Vip = DB_Vip
local DB_Item_direct = DB_Item_direct
local _tbBtnState = {}
local _bRedPoint = false
local _bSaleRedPoint = false
local _tbSaleDbInfo = {}
local _vipLevel
local _bWeekRedPoint = true
-- 是否vip等级上升了
local _bVipUp = false

local function init(...)

end

function destroy(...)
    package.loaded["VipGiftModel"] = nil
end

function moduleName()
    return "VipGiftModel"
end

function create(...)

end

function setWeekRedPointTrue( bWeekRedPoint )
	_bWeekRedPoint = bWeekRedPoint
end

function setVipUp( bVipUp )
	_bVipUp = bVipUp
end

function getVipUp(  )
	return _bVipUp
end

--[[desc:传入按钮状态的table
    arg1: 按钮状态table
    return: 无
—]]
function setBtnState( tbBtnState )
	_tbBtnState = tbBtnState
end

--[[desc:传出按钮状态的table
    arg1: 无
    return: 按钮状态table
—]]
function getBtnState( )
	return _tbBtnState
end

--[[desc:将每日礼包红点记录设置为看不见
    arg1: 无
    return: 无
—]]
function setRedPointFalse()
	_tbBtnState.bonus = 1
end

--[[desc:zhangjunwu 获取vip表里 vip礼包配到多少级
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getVipGiftCount( ... )
	local giftCount = 0
	for i=1,table.count(DB_Vip.Vip)do
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
	return giftCount
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getVipLevelMaxNum(  )
	local vip1 = DB_Vip.getDataById(1).level
	return tonumber(vip1) + table.count(DB_Vip.Vip) - 1, tonumber(vip1)
end

--[[desc:根据当前vip等级获取日常福利的奖励
    arg1: 无
    return: 日常福利奖励的table
—]]
function getDayRewards( )
	local nVip = UserModel.getVipLevel()

	local tbReward = {}
	tbReward.cur = {}
	tbReward.next = {}
	tbReward.dlg = {}
	local tbReward1 = DB_Vipsalary.getDataById(nVip)
	local tbReward2 = {}
	if (nVip < 15) then
		tbReward2 = DB_Vipsalary.getDataById(nVip + 1)
	end

	if (tbReward1.reward) then
		local strReward = tbReward1.reward
		local tbStrReward = RewardUtil.parseRewards(strReward)
		table.hcopy( tbStrReward , tbReward.cur )
		tbReward.dlg = strReward
	end

	if (tbReward2.reward) then
		local strReward = tbReward2.reward
		local tbStrReward = RewardUtil.parseRewards(strReward)
		table.hcopy( tbStrReward , tbReward.next )
	end

	return tbReward
end

--[[desc:获取下一等级vip需要的充值的金币数目
    arg1: 无
    return: 下一等级vip需要的充值的金币数目
—]]
function getCoinsNeed( )
	local nTotalCoins = tonumber(IAPData.getChargeGoldNum())
	local nVip = UserModel.getVipLevel()

	local coinNumNow = tonumber(DB_Vip.getDataById(nVip).rechargeValue)
	local coinNumNext = tonumber(DB_Vip.getDataById(nVip + 1).rechargeValue)

	if (nTotalCoins >= coinNumNow) then
		return (coinNumNext - nTotalCoins)
	else
		return (coinNumNext - coinNumNow)
	end
end

--[[desc:根据vip数获取周礼包的奖励
    arg1: vip数
    return: 周礼包奖励的table 
—]]
function getOneWeekCellInfo( nVip )
	local dbReward = DB_Vip.getDataById(nVip)

	local tbReward = string.split(dbReward.vip_week_gift_ids , '|')
	local strReward = dbReward.vip_week_goods
	local level = dbReward.level

	require "script/module/public/RewardUtil"
	tbReward.tbReward = RewardUtil.getItemsDataByStr(strReward)
	tbReward.reward = RewardUtil.parseRewardsByTb(tbReward.tbReward)
	tbReward.level = dbReward.level

	logger:debug({vipReward = tbReward.reward})
	logger:debug({tbReward = tbReward})

	return tbReward
end

--[[desc:根据vip数获取超值礼包的信息
    arg1: vip等级
    return: 超值礼包的信息
—]]
function getSaleCellInfo( nVip )
	local cellInfo = {}
	local strReward = DB_Vip.getDataById(nVip).vip_gift_ids
	local strPrice = DB_Vip.getDataById(nVip).vip_gift_price
	local tbReward = RewardUtil.parseRewards(strReward)
	local tbPrice = string.split(strPrice, "|")
	cellInfo.itemInfo = tbReward
	cellInfo.oldPrice = tonumber(tbPrice[1])
	cellInfo.nowPrice = tonumber(tbPrice[2])
	cellInfo.itemStr = strReward

	return cellInfo
end

--[[desc:礼包是否已经购买
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getVipGiftPurchased( vipLevel )
	local shopCache = DataCache.getShopCache()
	local vipGiftInfo = shopCache.va_shop.vip_gift
	logger:debug({vipGiftInfo = vipGiftInfo})
	return tonumber(vipGiftInfo[tostring(vipLevel)]) == 1
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getSaleListInfo( vipLevel )
	local nVip = UserModel.getVipLevel()
	local nMaxGiftLevel = getVipLevelMaxNum()
	local nMax = (nVip + 3) > nMaxGiftLevel and nMaxGiftLevel or (nVip + 3)
	local tbListInfo = {}
	local tbBought = {}
	for i = 1, nMax do
		local tbData
		-- 缓存会导致icon图标被autorelease后再被调用报错
--		if (_tbSaleDbInfo[i]) then
--			tbData = _tbSaleDbInfo[i]
--		else
			tbData = getSaleCellInfo(i) 
			tbData.isReach = i <= nVip
			tbData.vipLevel = i
			_tbSaleDbInfo[i] = tbData
--		end

		tbData.isBought = getVipGiftPurchased(i)
		if (tbData.isBought) then
			tbBought[#tbBought + 1] = tbData
		else
			tbListInfo[#tbListInfo + 1] = tbData
		end
	end

	for i,v in ipairs(tbBought) do
		tbListInfo[#tbListInfo + 1] = v
	end

	logger:debug({tbListInfo = tbListInfo})

	return tbListInfo
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function setSaleDbIndex( vipLevel )
	_vipLevel = vipLevel
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getSaleDbInfo( vipLevel )
	return _tbSaleDbInfo[vipLevel or _vipLevel]
end

--[[desc:获取超值礼包的红点状态
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getSaleRedPoint()
	if (not SwitchModel.getSwitchOpenState(ksSwitchShop)) then
		return false
	end

	local nVip = UserModel.getVipLevel()
	_bSaleRedPoint = false

	for i = 1, nVip do
		if not (getVipGiftPurchased(i)) then
			_bSaleRedPoint = true
			break
		end
	end

	return _bSaleRedPoint
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getWeekRedPoint(  )
	if (_bWeekRedPoint) then
		-- for i = 1, nVip do
		-- 	if (not table.include( _tbBtnState.gift , {tostring(i)})) then
		-- 		return true
		-- 	end
		-- end
		if (_bVipUp or table.isEmpty(_tbBtnState.gift)) then
			return true
		end

		return false
	else
		return false
	end
end

--[[desc:获取红点是否可见
    arg1: 无
    return: boolen表示红点是否可见
—]]
function getRedPoint()
	_bRedPoint = false

	if (_tbBtnState.bonus) then
		if (tonumber(_tbBtnState.bonus) ~= 1) then
			_bRedPoint = true
		end 
	end

	if (SwitchModel.getSwitchOpenState(ksSwitchShop)) then
		if (not _bRedPoint and getSaleRedPoint()) then
			_bRedPoint = true
		end
	end

	if (not _bRedPoint and getWeekRedPoint()) then
		_bRedPoint = true
	end

	return _bRedPoint
end

function resetWeek(  )
	_tbBtnState.bonus = 0
	_tbBtnState.gift = {}
	_bWeekRedPoint = true
end

function resetDay(  )
	_tbBtnState.bonus = 0
end


