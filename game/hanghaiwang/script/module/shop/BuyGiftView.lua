-- FileName: BuyGiftView.lua
-- Author:zhangjunwu
-- Date: 2014-04-00
-- Purpose: 购买礼包界面
--[[TODO List]]

module ("BuyGiftView", package.seeall)

--引用的json文件。
local m_jsonforShop 		= "ui/shop_vipgift_buy.json"

--UI控件变量
local m_widgetRoot       	= nil

-- 模块局部变量 --
local m_fnGetWidget  				= g_fnGetWidgetByName
local m_i18nString 					=  gi18nString

function destroy(...)
	package.loaded["BuyGiftView"] = nil
end

-- 初始化
local function init()

end
--模块名
function moduleName()
	return "BuyGiftView"
end
-- create
function create(tbBtnEvent,_tbData)

	logger:debug(_tbData)

	m_widgetRoot = g_fnLoadUI(m_jsonforShop)
	m_widgetRoot:setSize(g_winSize)

	--确定，取消，关闭
	local i18nBtnCancle = m_fnGetWidget(m_widgetRoot, "BTN_BUY_CANCEL")
	local i18nBtnSure = m_fnGetWidget(m_widgetRoot, "BTN_BUY_SURE")
	local btnClose = m_fnGetWidget(m_widgetRoot, "BTN_CLOSE" )

	UIHelper.titleShadow(i18nBtnSure,m_i18nString(1029))
	UIHelper.titleShadow(i18nBtnCancle,m_i18nString(1625))

	i18nBtnSure:addTouchEventListener(tbBtnEvent.onSure)
	i18nBtnCancle:addTouchEventListener(tbBtnEvent.onCancle)
	btnClose:addTouchEventListener(tbBtnEvent.onBack)

	local LAY_NAME = m_fnGetWidget(m_widgetRoot,"TFD_NAME") 	-- 标题
	--LAY_NAME:setText(_tbData.name)
	UIHelper.labelEffect(LAY_NAME,_tbData.name)

	local LAY_DES = m_fnGetWidget(m_widgetRoot ,"TFD_ITEM_DESC") --描述
	LAY_DES:setText(_tbData.desc)

	local i18nBuy = m_fnGetWidget(m_widgetRoot,"tfd_buy")		--购买
	i18nBuy:setText(m_i18nString(1435))

	local vipLevel = m_fnGetWidget(m_widgetRoot,"LABN_VIP")		--level
	vipLevel:setStringValue(_tbData.level)

	local i18nNeedCost = m_fnGetWidget(m_widgetRoot,"tfd_need_cost")		--需花费
	i18nNeedCost:setText(m_i18nString(1436))

	local layPrice = m_fnGetWidget(m_widgetRoot,"TFD_PRICE")		--价格
	-- layPrice:setText(_tbData.newPrice)
	UIHelper.labelAddStroke(layPrice,_tbData.newPrice)
	-- layPrice:setStringValue(tonumber(_tbData.newPrice))

	local vipBtn ,iteminfo = ItemUtil.createBtnByTemplateId(_tbData.id)					--icon
	local LAY_BTNBG = m_fnGetWidget(m_widgetRoot,"IMG_ITEM_ICON_BG")
	LAY_BTNBG:addChild(vipBtn)

	-- local vipBtn = ItemButton.createWithItemTempid(_tbData.id)					--icon
	-- local LAY_BTNBG = m_fnGetWidget(m_widgetRoot,"IMG_ITEM_ICON_BG")
	-- LAY_BTNBG:addChild(vipBtn)

	return m_widgetRoot
end


