-- FileName: GuildCreateView.lua
-- Author: huxiaozhou
-- Date: 2014-09-15
-- Purpose: function description of module
--[[TODO List]]
-- 创建军团 界面

module("GuildCreateView", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
-- 模块局部变量 --
local json = "ui/union_create.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent
local m_nameBox

local function init(...)

end

function destroy(...)
	package.loaded["GuildCreateView"] = nil
end

function moduleName()
    return "GuildCreateView"
end

function updateUI( ... )
	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
	BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)
	local BTN_GOLD = m_fnGetWidget(m_mainWidget, "BTN_GOLD")
	local BTN_BELLY = m_fnGetWidget(m_mainWidget, "BTN_BELLY")
	 --是否金币创建, 0银币, 1金币, 默认0银币
	BTN_GOLD:addTouchEventListener(m_tbEvent.fnGold)
	BTN_BELLY:addTouchEventListener(m_tbEvent.fnSilver)
	-- UIHelper.titleShadow(BTN_GOLD,m_i18n[3523])
	-- UIHelper.titleShadow(BTN_BELLY,m_i18n[3524])

	UIHelper.labelShadowWithText(m_mainWidget.TFD_GOLD_CREATE, m_i18n[3523])
	UIHelper.labelShadowWithText(m_mainWidget.TFD_BELLY_CREATE, m_i18n[3524])

	local TFD_GOLD = m_fnGetWidget(m_mainWidget, "TFD_GOLD") -- 金币
	local TFD_SILVER = m_fnGetWidget(m_mainWidget, "TFD_SILVER") -- 贝利
	-- TFD_GOLD:setStringValue(GuildUtil.getCreateNeedGold())
	-- TFD_SILVER:setStringValue(GuildUtil.getCreateNeedSilver())
	
	UIHelper.labelShadowWithText(TFD_GOLD, GuildUtil.getCreateNeedGold())
	UIHelper.labelShadowWithText(TFD_SILVER, GuildUtil.getCreateNeedSilver())

	local tfd_title = m_fnGetWidget(m_mainWidget, "tfd_title")
	tfd_title:setText(m_i18n[3521])

	local IMG_TYPE = m_fnGetWidget(m_mainWidget, "IMG_TYPE") -- 可输入框的背景
	local size = IMG_TYPE:getSize()
	m_nameBox = UIHelper.createEditBox(CCSizeMake(size.width-6, size.height), "images/base/potential/input_name_bg1.png", false)

	m_nameBox:setAnchorPoint(ccp(0.5, 0.5))

	m_nameBox:setPlaceholderFontColor(ccc3( 0xba, 0x9d, 0x4f))
	m_nameBox:setMaxLength(20)
	m_nameBox:setPlaceHolder(m_i18n[3522])
	m_nameBox:setReturnType(kKeyboardReturnTypeDone)
	m_nameBox:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	m_nameBox:setFontColor(ccc3( 0x57, 0x1e, 0x01))
	IMG_TYPE:addNode(m_nameBox)

	local btnChoose = m_fnGetWidget(m_mainWidget, "BTN_CHANGE") --更换按钮
	UIHelper.titleShadow(btnChoose, m_i18n[1638])
	btnChoose:addTouchEventListener(m_tbEvent.fnChooseIcon)
	GuildDataModel.setGuildIconId(1)
	updateIcon(1)
end

function updateIcon( iconId )
	local IMG_FLAG = m_fnGetWidget(m_mainWidget, "IMG_FLAG") -- 联盟icon
	local tfd_flag = m_fnGetWidget(m_mainWidget, "tfd_flag") -- 联盟icon 名字
	local sIconPath = "images/union/flag/"
	local tbIcon = GuildUtil.getLogoDataById(iconId)
	local imgPath = sIconPath .. tbIcon.img
	IMG_FLAG:loadTexture(imgPath)
end

function getNameBoxText(  )
	return m_nameBox:getText()
end

function create(tbEvent)
	m_tbEvent = tbEvent
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	updateUI()
	return m_mainWidget
end
