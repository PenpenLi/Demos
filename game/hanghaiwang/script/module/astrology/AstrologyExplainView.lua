-- FileName: AstrologyExplainView.lua
-- Author: zhangjunwu
-- Date: 2014-06-20
-- Purpose: 占卜屋说明界面
--[[TODO List]]

module("AstrologyExplainView", package.seeall)

-- UI控件引用变量 --
local m_btnClose= nil

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["AstrologyExplainView"] = nil
end

function moduleName()
	return "AstrologyExplainView"
end


function create( tbEventListener )
	local m_UIMain = g_fnLoadUI("ui/astrology_explain.json")
	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")

	m_btnClose:addTouchEventListener(tbEventListener.onClose)

	local i18nDesInfo = m_fnGetWidget(m_UIMain,"tfd_desc")
	i18nDesInfo:setText(m_i18nString(2301))

	local i18nTitle = m_fnGetWidget(m_UIMain,"TFD_DESC_TITLE")
	UIHelper.labelAddStroke(i18nTitle ,m_i18nString(2043)) --帮助说明
  
	return m_UIMain
end

