-- FileName: ChangePasswordView.lua
-- Author: huxiaozhou
-- Date: 2014-09-16
-- Purpose: function description of module
--[[TODO List]]

module("ChangePasswordView", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
local m_IMG_TYPE_ORIGIN
local m_IMG_TYPE_NEW
local m_IMG_TYPE_CONFIRM

-- 模块局部变量 --
local json = "ui/union_change_password.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent

local m_originCodeBox
local m_newCodeBox
local m_confirmCodeBox

local function init(...)

end

function loadUI( ... )
	-- local i18nTFD_TITLE = m_fnGetWidget(m_mainWidget, "TFD_TITLE") -- 联盟密码
	-- i18nTFD_TITLE:setText(m_i18n[3534])

	local TFD_ORIGIN_PASSWORD = m_fnGetWidget(m_mainWidget, "TFD_ORIGIN_PASSWORD") --联盟初始密码为：123456
	TFD_ORIGIN_PASSWORD:setText(m_i18n[3535] .. "123456")

	local i18ntfd_origin =  m_fnGetWidget(m_mainWidget, "tfd_origin") -- 原密码
	i18ntfd_origin:setText(m_i18n[3536])
	local i18ntfd_new =  m_fnGetWidget(m_mainWidget, "tfd_new") -- 新密码
	i18ntfd_new:setText(m_i18n[3537])
	local i18ntfd_confirm =  m_fnGetWidget(m_mainWidget, "tfd_confirm") -- 确认密码
	i18ntfd_confirm:setText(m_i18n[3538])

	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE") --关闭按钮

	local BTN_CONFIRM = m_fnGetWidget(m_mainWidget, "BTN_CONFIRM") -- 确定按钮
	local BTN_CANCEL = m_fnGetWidget(m_mainWidget, "BTN_CANCEL") -- 取消按钮
	BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)
	BTN_CANCEL:addTouchEventListener(m_tbEvent.fnCancel)
	BTN_CONFIRM:addTouchEventListener(m_tbEvent.fnConfirm)

	UIHelper.titleShadow(BTN_CONFIRM, m_i18n[1324])
	UIHelper.titleShadow(BTN_CANCEL, m_i18n[1325])


	local IMG_TYPE_ORIGIN = m_fnGetWidget(m_mainWidget, "IMG_TYPE_ORIGIN") -- 原密码输入框背景
	local IMG_TYPE_NEW = m_fnGetWidget(m_mainWidget, "IMG_TYPE_NEW") -- 新密码输入框背景
	local IMG_TYPE_CONFIRM = m_fnGetWidget(m_mainWidget, "IMG_TYPE_CONFIRM") -- 确认密码输入框背景


	local sizeOrigin = IMG_TYPE_ORIGIN:getSize()
	m_originCodeBox = UIHelper.createEditBox(CCSizeMake(sizeOrigin.width, sizeOrigin.height), "images/base/potential/input_name_bg1.png", false)
	-- m_originCodeBox:setPlaceHolder("请输入原密码")
	-- m_originCodeBox:setPlaceHolder("Please enter password")

	m_originCodeBox:setAnchorPoint(ccp(0.5, 0.5))
	m_originCodeBox:setMaxLength(8)
	m_originCodeBox:setReturnType(kKeyboardReturnTypeDone)
	m_originCodeBox:setInputFlag (kEditBoxInputFlagPassword)
	m_originCodeBox:setFontColor(ccc3( 0x82, 0x56, 0x00 ))
	IMG_TYPE_ORIGIN:addNode(m_originCodeBox)

	local sizeNew = IMG_TYPE_NEW:getSize()
	m_newCodeBox = UIHelper.createEditBox(CCSizeMake(sizeOrigin.width, sizeOrigin.height), "images/base/potential/input_name_bg1.png", false)
	-- m_newCodeBox:setPlaceHolder("请输新密码4-6位")
	-- m_newCodeBox:setPlaceHolder(m_i18n[3539])
	m_newCodeBox:setAnchorPoint(ccp(0.5, 0.5))
	m_newCodeBox:setMaxLength(8)
	m_newCodeBox:setReturnType(kKeyboardReturnTypeDone)
	m_newCodeBox:setInputFlag (kEditBoxInputFlagPassword)
	m_newCodeBox:setFontColor(ccc3( 0x82, 0x56, 0x00 ))
	IMG_TYPE_NEW:addNode(m_newCodeBox)

	local sizeConfirm = IMG_TYPE_CONFIRM:getSize()
	m_confirmCodeBox = UIHelper.createEditBox(CCSizeMake(sizeConfirm.width, sizeConfirm.height), "images/base/potential/input_name_bg1.png", false)
	-- m_confirmCodeBox:setPlaceHolder(m_i18n[3539])
	m_confirmCodeBox:setAnchorPoint(ccp(0.5, 0.5))
	m_confirmCodeBox:setMaxLength(8)
	m_confirmCodeBox:setReturnType(kKeyboardReturnTypeDone)
	m_confirmCodeBox:setInputFlag (kEditBoxInputFlagPassword)
	m_confirmCodeBox:setFontColor(ccc3( 0x82, 0x56, 0x00 ))
	IMG_TYPE_CONFIRM:addNode(m_confirmCodeBox)

end

function getCodeBoxText( ... )
	local tbCode = {}
	tbCode.origin = m_originCodeBox:getText()
	tbCode.new = m_newCodeBox:getText()
	tbCode.confirm = m_confirmCodeBox:getText()
	return tbCode
end


function destroy(...)
	package.loaded["ChangePasswordView"] = nil
end

function moduleName()
    return "ChangePasswordView"
end

function create(tbEvent)
	init()
	m_tbEvent = tbEvent
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	loadUI()
	return m_mainWidget
end
