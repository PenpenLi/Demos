-- FileName: BuyBoxTip.lua
-- Author: zhangjunwu
-- Date: 2014-08-27
-- Purpose: 购买箱子的确认提示框
--[[TODO List]]

module("BuyBoxTip", package.seeall)
require "script/module/wonderfulActivity/buyBox/BuyBoxCtrl"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName --读取UI组件方法
local mi18n = gi18n
local m_i18nString = gi18nString
local m_boyboxMainUi = nil
local function init(...)
	m_boyboxMainUi= nil
end

function destroy(...)
	package.loaded["BuyBoxTip"] = nil
end

function moduleName()
	return "BuyBoxTip"
end


--[[desc:功能简介
    -- arg1: tbinfo = {spentGold = 2，
    -- 				boxNum = 2,
    -- 				keyNum = 2
    -- 				BoxTid = 5,
    -- 				KeyTid = 7,	}
    return: 是否有返回值，返回值说明  
—]]
function create(tbInfo)
	init()
	local mainWidget = g_fnLoadUI("ui/activity_box_tip.json")
	m_boyboxMainUi = mainWidget
	local btnClose = m_fnGetWidget(mainWidget,"BTN_CLOSE")
	btnClose:addTouchEventListener(tbInfo.onBack) --注册按钮事件

	local btnCancle = m_fnGetWidget(mainWidget,"BTN_CANCEL")
	btnCancle:addTouchEventListener(tbInfo.onBack) --注册按钮事件
	UIHelper.titleShadow(btnCancle,m_i18nString(1325))

	local btnSure = m_fnGetWidget(mainWidget,"BTN_CONFIRM")
	btnSure:addTouchEventListener(tbInfo.onSure) --注册按钮事件

	--"您的材料不足，需要购买",  2015-910-9 TFD_TIPS修改为“您的钥匙不足“
	local TFD_TIPS = m_fnGetWidget(mainWidget,"TFD_TIPS")
	TFD_TIPS:setText(m_i18nString(4017))

	local TFD_BUYBTN = m_fnGetWidget(mainWidget,"TFD_BUYBTN")
	TFD_BUYBTN:setText(m_i18nString(1435))
	UIHelper.labelShadow(TFD_BUYBTN)

	local tfd_buy = m_fnGetWidget(mainWidget,"tfd_buy")
	tfd_buy:setText(m_i18nString(4018))
	
	-- "今日还可购买
	local tfd_canbuy1 = m_fnGetWidget(mainWidget,"tfd_canbuy1")
	tfd_canbuy1:setText(m_i18nString(4005))


	-- 个
	local tfd_canbuy2 = m_fnGetWidget(mainWidget,"tfd_canbuy2")
	tfd_canbuy2:setText(m_i18nString(1422))
	
	--花费的金币
	local TFD_SPEND_TOTAL = m_fnGetWidget(mainWidget,"TFD_SPEND_TOTAL")
	TFD_SPEND_TOTAL:setText(tostring(tbInfo.spentGold))


	--需要购买的钥匙个数
	logger:debug(tbInfo)
	local TFD_NEED_KEY = m_fnGetWidget(mainWidget,"TFD_NEED_KEY")
	local keyNum = tbInfo.keyNum
	if(tbInfo.keyNum <= 0 ) then
		keyNum = 0
	end

	 TFD_NEED_KEY:setText("X" .. (keyNum))

	-- --钥匙的图片
	local IMG_KEY = m_fnGetWidget(mainWidget,"IMG_KEY")
	local imgKey = tbInfo.imageKey
	IMG_KEY:loadTexture(imgKey)


	-- --今日还可以购买的次数的父节点
	local lay_fit = m_fnGetWidget(mainWidget,"lay_fit")
	--是否限购
	local bBuyLimit =BuyBoxCtrl.isLimitBy()
	logger:debug(bBuyLimit)

	if(bBuyLimit == true) then
		--宝箱名字
		local TFD_CANBUY_NAME = m_fnGetWidget(lay_fit,"TFD_CANBUY_NAME")

		local boxName = BuyBoxData.getItemNameBy(tbInfo.KeyTid)
		TFD_CANBUY_NAME:setText(boxName)

		local maxLimitNum = BuyBoxCtrl.getBuyTimesBy()
		logger:debug(maxLimitNum)
		if(maxLimitNum < 0 ) then
			maxLimitNum = 0
		end

		--宝箱还可以购买的次数
		local TFD_CANBUY_NUM = m_fnGetWidget(lay_fit,"TFD_CANBUY_NUM")
		TFD_CANBUY_NUM:setText(tostring(maxLimitNum))
		-- UIHelper.labelNewStroke(TFD_CANBUY_NUM,ccc3(0x2a, 0x06, 0x04))
	else
		lay_fit:setEnabled(false)
	end

	UIHelper.registExitAndEnterCall(
		m_boyboxMainUi, 
		function ( ... )
			m_boyboxMainUi = nil
			logger:debug("registExitrCall BuyBoxTip")
		end,
		function (...)
			logger:debug("registEnterCall BuyBoxTip")
		end
	)


	return mainWidget
end

function resetBuyBoxTip( )
	if(m_boyboxMainUi) then
		-- 购买宝箱的网络后端回调
		local nGoldTotole = BuyBoxCtrl.getTotlePrice()

		local maxLimitNum = BuyBoxCtrl.getBuyTimesBy()
		if(maxLimitNum < 0 ) then
			maxLimitNum = 0
		end

		--宝箱还可以购买的次数
		local TFD_CANBUY_NUM = m_fnGetWidget(m_boyboxMainUi,"TFD_CANBUY_NUM")
		TFD_CANBUY_NUM:setText(tostring(maxLimitNum))

		--花费的金币
		local TFD_SPEND_TOTAL = m_fnGetWidget(m_boyboxMainUi,"TFD_SPEND_TOTAL")
		TFD_SPEND_TOTAL:setText(tostring(nGoldTotole))
	else
		logger:debug("m_boyboxMainUi Tip confirm m_mainWidget  not running")
	end
end
