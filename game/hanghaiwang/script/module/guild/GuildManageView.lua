-- FileName: GuildManageView.lua
-- Author: huxiaozhou
-- Date: 2014-09-16
-- Purpose: function description of module
--[[TODO List]]
-- 点击管理弹出的二级管理显示界面

module("GuildManageView", package.seeall)
require "script/module/guildCopy/GuildCopyModel"

-- UI控件引用变量 --
local m_mainWidget
-- 模块局部变量 --
local json = "ui/union_manage.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent

local tbColor = { ccc3(0x4d,0xec,0x15),ccc3(0xee,0x16,0) }  --插队开关 开，关


local function init(...)

end

function destroy(...)
	package.loaded["GuildManageView"] = nil
end

function moduleName()
    return "GuildManageView"
end

local function loadUI( )
	local i18nTFD_TITLE = m_fnGetWidget(m_mainWidget, "TFD_TITLE") -- 管理
	-- i18nTFD_TITLE:setText(m_i18n[3570])

	local BTN_CLOSE = m_fnGetWidget(m_mainWidget,"BTN_CLOSE") --关闭按钮
	local BTN_ANNOUNCE = m_fnGetWidget(m_mainWidget, "BTN_ANNOUNCE") -- 联盟宣言
	local BTN_PASSWORD = m_fnGetWidget(m_mainWidget, "BTN_PASSWORD") -- 联盟密码
	local BTN_VERIFY = m_fnGetWidget(m_mainWidget, "BTN_VERIFY") -- 成员审核
	local BTN_DISSOLVE = m_fnGetWidget(m_mainWidget, "BTN_DISSOLVE") -- 解散联盟
	local BTN_FLAG = m_fnGetWidget(m_mainWidget, "BTN_FLAG") --修改海贼旗

	local BTN_DISTRIBUTE = m_fnGetWidget(m_mainWidget, "BTN_DISTRIBUTE") --分配战利品
	BTN_DISTRIBUTE.TFD_DISTRIBUTE:setText(m_i18n[3592])
	local BTN_QUEUE = m_fnGetWidget(m_mainWidget, "BTN_QUEUE") --允许插队：开

	local state = GuildCopyModel.getJumpSwitch()
	BTN_QUEUE.TFD_QUEUE:setText(m_i18n[3590])
	BTN_QUEUE.TFD_OPEN:setText(state==1 and m_i18n[4102] or m_i18n[4103])
	BTN_QUEUE.TFD_OPEN:setColor( state==1 and tbColor[1] or tbColor[2])
	UIHelper.labelShadow(BTN_QUEUE.TFD_OPEN)

	BTN_ANNOUNCE.TFD_ANNOUNCE:setText(m_i18n[3505])
	BTN_PASSWORD.TFD_PASSWORD:setText(m_i18n[3534])
	BTN_VERIFY.TFD_VERIFY:setText(m_i18n[3530])
	BTN_DISSOLVE.TFD_DISSOLVE:setText(m_i18n[3531])
	BTN_FLAG.TFD_FLAG:setText(m_i18n[3692])

	UIHelper.labelShadow(BTN_DISTRIBUTE.TFD_DISTRIBUTE)
	UIHelper.labelShadow(BTN_QUEUE.TFD_QUEUE)
	UIHelper.labelShadow(BTN_ANNOUNCE.TFD_ANNOUNCE)
	UIHelper.labelShadow(BTN_PASSWORD.TFD_PASSWORD)
	UIHelper.labelShadow(BTN_VERIFY.TFD_VERIFY)
	UIHelper.labelShadow(BTN_DISSOLVE.TFD_DISSOLVE)
	UIHelper.labelShadow(BTN_FLAG.TFD_FLAG)

	BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)
	BTN_ANNOUNCE:addTouchEventListener(m_tbEvent.fnAnnounce)
	BTN_PASSWORD:addTouchEventListener(m_tbEvent.fnPassword)
	BTN_VERIFY:addTouchEventListener(m_tbEvent.fnVerify)

	BTN_DISSOLVE:addTouchEventListener(m_tbEvent.fnDissolve)
	BTN_FLAG:addTouchEventListener(m_tbEvent.fnChangeLogo)
	BTN_DISTRIBUTE:addTouchEventListener(m_tbEvent.fnDistribution)

	BTN_QUEUE:addTouchEventListener(m_tbEvent.fnTurnQueneSwitch)

end

 function refreashButton( ... )
	local BTN_QUEUE = m_fnGetWidget(m_mainWidget, "BTN_QUEUE") --允许插队：开
	local state = GuildCopyModel.getJumpSwitch()
	BTN_QUEUE.TFD_OPEN:setText(state==1 and m_i18n[4102] or m_i18n[4103])
	BTN_QUEUE.TFD_OPEN:setColor(state==1 and tbColor[1] or tbColor[2])
 end


function create(tbEvent)
	m_tbEvent = tbEvent
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	loadUI()
	return m_mainWidget
end
