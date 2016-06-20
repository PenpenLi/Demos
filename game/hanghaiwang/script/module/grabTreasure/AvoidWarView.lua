-- FileName: AvoidWarView.lua
-- Author: menghao
-- Date: 2014-5-11
-- Purpose: 夺宝免战弹出框view


module("AvoidWarView", package.seeall)


-- UI控件引用变量 --
local m_UIMain
local m_btnClose
local m_btnAvoidWar
local m_btnGold
local m_labnAviodTip


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnAddStroke = UIHelper.labelAddStroke
local mi18n = gi18n


local function init(...)

end


function destroy(...)
	package.loaded["AvoidWarView"] = nil
end


function moduleName()
	return "AvoidWarView"
end


function create(tbInfo)
	m_UIMain = g_fnLoadUI("ui/grab_avoid_war.json")

	-- 获取控件
	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	m_btnAvoidWar = m_fnGetWidget(m_UIMain, "BTN_AVOID_WAR")
	m_btnGold = m_fnGetWidget(m_UIMain, "BTN_GOLD")
	m_labnAviodTip = m_fnGetWidget(m_UIMain, "LABN_AVOID_TIP")

	-- 国际化文本
	local i18nTitle = m_fnGetWidget(m_UIMain, "tfd_title")
	local i18nCost = m_fnGetWidget(m_UIMain, "tfd_cost")
	local i18nAvoidCard = m_fnGetWidget(m_UIMain, "tfd_avoid_card")
	local i18nGold = m_fnGetWidget(m_UIMain, "tfd_gold")
	local i18nAvoidCardCost = m_fnGetWidget(m_UIMain, "tfd_avoid_card_cost")
	local i18nAvoidCardCostTxt = m_fnGetWidget(m_UIMain, "TFD_AVOID+CARD_COST_TXT")
	local i18nGoldCost = m_fnGetWidget(m_UIMain, "tfd_gold_cost")
	local i18nGoldTxt = m_fnGetWidget(m_UIMain, "TFD_GOLD_COST_TXT")
	local i18nNotice = m_fnGetWidget(m_UIMain, "tfd_grab_avoid_war_txt")

	m_fnAddStroke(i18nTitle, mi18n[2429])
	m_fnAddStroke(i18nCost, mi18n[1405])
	m_fnAddStroke(i18nAvoidCard, mi18n[2423])
	m_fnAddStroke(i18nGold, gi18nString(2424, 20))
	m_fnAddStroke(i18nAvoidCardCost, mi18n[1405])
	m_fnAddStroke(i18nAvoidCardCostTxt, mi18n[2425])
	m_fnAddStroke(i18nGoldCost, mi18n[1405])
	m_fnAddStroke(i18nGoldTxt, mi18n[2426])
	m_fnAddStroke(i18nNotice, mi18n[2422])

	-- 控件初始化
	m_btnClose:addTouchEventListener(tbInfo.onClose)
	m_btnAvoidWar:addTouchEventListener(tbInfo.onAvoidWar)
	m_btnGold:addTouchEventListener(tbInfo.onGold)

	m_labnAviodTip:setStringValue(tostring(tbInfo.itemAvoidNum))

	return m_UIMain
end

