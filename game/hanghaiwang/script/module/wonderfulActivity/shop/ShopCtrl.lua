-- FileName: ShopCtrl.lua
-- Author: liweidong
-- Date: 2014-04-00
-- Purpose: 购买贝里控制器
--[[TODO List]]

module("ShopCtrl", package.seeall)

require "script/module/wonderfulActivity/shop/ShopView"
require "script/module/wonderfulActivity/buyBox/BuyBoxData"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_buytenData = nil
local m_i18n=gi18n

local function init(...)
	m_buytenData={}
end

function destroy(...)
	package.loaded["ShopCtrl"] = nil
end

function moduleName()
    return "ShopCtrl"
end

function create(...)
	init()
	createView()
end


--12点重置数据更新UI liweidong
function resetShopUI()
	ShopView.updateUI()
end
--[[desc:liweidong 购买次数判断是否为0
    arg1: nil
    return: nil
—]]
local function isHaveRemainBuyTime()
	local maxLimitNum = ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), 11)
	if(maxLimitNum > 0) then
		if(maxLimitNum-ShopUtil.getBuyNumBy(11) <=0)then
			return false
		end
	end
	return true
end
local function getMaxBuyTimes()
	local maxLimitNum = ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), 11)
	return maxLimitNum
end
local function getNextMaxBuyTimes()
	if(UserModel.getVipLevel() >= table.count(DB_Vip.Vip)-1) then
		return getMaxBuyTimes()
	else
		local maxLimitNum = ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel()+1, 11)
		return maxLimitNum
	end
end
--购买返回结果
function buySuccessCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		logger:debug("buy gold success===========")
		logger:debug(dictData)
		local m_goodsData = DB_Goods.getDataById(11)
		local getTotalBelly = 0

		local haveBuyTime=ShopUtil.getBuyNumBy(11) -- 当前购买次数
		local factor1,factor2,factor3 = ShopUtil.getBuySiliverProperty()

		for i=1,m_buytenData.times,1 do
			local getBelly=m_goodsData.buy_siliver_num+UserModel.getHeroLevel()*factor1
			getBelly = getBelly + math.min(haveBuyTime,factor3) *factor2
			getBelly=getBelly*dictData.ret.crit[i]
			getTotalBelly=getTotalBelly+getBelly
			ShopView.insertNewBuyRecord(getBelly,tonumber(dictData.ret.crit[i]))

			haveBuyTime=haveBuyTime+1
		end
		UserModel.addGoldNumber( -m_buytenData.gold)
		UserModel.addSilverNumber(getTotalBelly)
		ShowNotice.showShellInfo(gi18nString(4010, getTotalBelly))

		DataCache.addBuyNumberBy(11, m_buytenData.times)
		ShopView.updateUI()
		
	end
end
--单次购买按钮的回调函数
local function onBtnBuy1( sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	
	-- 限购次数是否已经用完
	if (not isHaveRemainBuyTime()) then
		--ShowNotice.showShellInfo("该物品的购买次数已经用完")
		local tbParams = {}
		local tbParams = {sTitle = m_i18n[4014],sUnit = m_i18n[2621],sName = m_i18n[1520],nNowBuyNum=getMaxBuyTimes(),nNextBuyNum=getNextMaxBuyTimes(),}
		local layAlert = UIHelper.createVipBoxDlg(tbParams)
		LayerManager.addLayout(layAlert)
		AudioHelper.playCommonEffect()
		return
	end

	m_buytenData.times=1
	m_buytenData.gold=ShopUtil.getSiliverPriceBy( ShopUtil.getBuyNumBy(11)+1 )

	if(m_buytenData.gold <= UserModel.getGoldNumber()) then
		local args = Network.argsHandler(11, m_buytenData.times)
		RequestCenter.shop_buyGoods(buySuccessCallback, args)
		AudioHelper.playBtnEffect("buttonbuy.mp3")
	else
		LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
		AudioHelper.playCommonEffect()
	end
	
end
--购买10次对话框确认返回
local function onConfirmBuy10( sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	
	LayerManager.removeLayout()

	if(m_buytenData.gold <= UserModel.getGoldNumber()) then
		local args = Network.argsHandler(11, m_buytenData.times)
		RequestCenter.shop_buyGoods(buySuccessCallback, args)
		AudioHelper.playBtnEffect("buttonbuy.mp3")
	else
		LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
		AudioHelper.playCommonEffect()
	end
	
end
--十次购买按钮的回调函数
local function onBtnBuy10( sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	-- AudioHelper.playCommonEffect()
	-- AudioHelper.playBtnEffect("buttonbuy.mp3")
	AudioHelper.playCommonEffect()
	-- 限购次数是否已经用完
	if (not isHaveRemainBuyTime()) then
		-- local tbParams = {}
		-- tbParams.boxTid = 11
		-- logger:debug(tbParams)
		-- local layAlert = UIHelper.createVipBoxDlg(tbParams)
		-- LayerManager.addLayout(layAlert)
		local tbParams = {}
		local tbParams = {sTitle = m_i18n[4014],sUnit = m_i18n[2621],sName = m_i18n[1520],nNowBuyNum=getMaxBuyTimes(),nNextBuyNum=getNextMaxBuyTimes(),}
		local layAlert = UIHelper.createVipBoxDlg(tbParams)
		LayerManager.addLayout(layAlert)
		return
	end
	local maxLimitNum = ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), 11)
	local canbuyLimit = maxLimitNum-ShopUtil.getBuyNumBy(11)

	m_buytenData.times=canbuyLimit>10 and 10 or canbuyLimit
	m_buytenData.gold=ShopUtil.getBuySiliverTotalPriceBy(ShopUtil.getBuyNumBy(11)+1, m_buytenData.times)
	m_buytenData.callback=onConfirmBuy10
	ShopView.showBuyBellyDialog(m_buytenData)
	
end
function createView(  )
	local tbBtnEvent = {}
	-- 按钮 吃烧鸡按钮
	tbBtnEvent.onPower1 = onBtnBuy1
	tbBtnEvent.onPower10 = onBtnBuy10
	local view = ShopView.create(tbBtnEvent)
	MainWonderfulActCtrl.addLayChild(view)
end