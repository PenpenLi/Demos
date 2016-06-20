-- FileName: GuildDissolveView.lua
-- Author: huxiaozhou
-- Date: 2014-09-15
-- Purpose: function description of module
--[[TODO List]]

module("GuildDissolveView", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
-- 模块局部变量 --
local json = "ui/union_dissolve.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent

local m_codeBox
local m_type
local function init(...)

end

function destroy(...)
	package.loaded["GuildDissolveView"] = nil
end

function moduleName()
    return "GuildDissolveView"
end




local function loadUI( )
	-- local i18nTFD_TITLE = m_fnGetWidget(m_mainWidget, "TFD_TITLE") -- 管理

	-- if m_type == "transfer" then
	-- 	i18nTFD_TITLE:setText(m_i18n[3616])
	-- else
	-- 	i18nTFD_TITLE:setText(m_i18n[3570])
	-- end
	local i18ntfd_info = m_fnGetWidget(m_mainWidget, "tfd_info") -- 请输入联盟密码
	i18ntfd_info:setText(m_i18n[3556])

	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE") --关闭按钮
	local BTN_CONFIRM = m_fnGetWidget(m_mainWidget, "BTN_CONFIRM") -- 确定按钮
	local BTN_CANCEL = m_fnGetWidget(m_mainWidget, "BTN_CANCEL") -- 取消按钮

	UIHelper.titleShadow(BTN_CONFIRM, m_i18n[1324])
	UIHelper.titleShadow(BTN_CANCEL, m_i18n[1325])

	BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)
	BTN_CANCEL:addTouchEventListener(m_tbEvent.fnCancel)
	BTN_CONFIRM:addTouchEventListener(m_tbEvent.fnConfirm)

	local IMG_TYPE_PASSWORD = m_fnGetWidget(m_mainWidget, "IMG_TYPE_PASSWORD") -- 输入框背景

	local size = IMG_TYPE_PASSWORD:getSize()
	m_codeBox = UIHelper.createEditBox(CCSizeMake(size.width, size.height), "images/base/potential/input_name_bg1.png", false)

	m_codeBox:setAnchorPoint(ccp(0.5, 0.5))
	m_codeBox:setMaxLength(8)
	m_codeBox:setReturnType(kKeyboardReturnTypeDone)
	m_codeBox:setInputFlag (kEditBoxInputFlagPassword)
	m_codeBox:setFontColor(ccc3(0x57, 0x1e, 0x01))
	m_codeBox:setFontSize(26)
	IMG_TYPE_PASSWORD:addNode(m_codeBox)

end

function getCodeBoxText(  )
	return m_codeBox:getText()
end


function create(tbEvent, _type)
	m_tbEvent = tbEvent
	m_type = _type
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	loadUI()
	return m_mainWidget
end