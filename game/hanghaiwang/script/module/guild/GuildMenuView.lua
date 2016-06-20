-- FileName: GuildMenuView.lua
-- Author: huxiaozhou
-- Date: 2014-09-19
-- Purpose: function description of module
--[[TODO List]]

module("GuildMenuView", package.seeall)

local m_mainMenu
local m_lay_leader
local m_lay_member


-- 模块局部变量 --
local jsonMenu = "ui/union_menu.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent
local _guildInfo
local _sigleGuildInfo

local function init(...)
	_guildInfo = GuildDataModel.getGuildInfo()
	_sigleGuildInfo = GuildDataModel.getMineSigleGuildInfo()
end

function destroy(...)
	package.loaded["GuildMenuView"] = nil
end

function moduleName()
    return "GuildMenuView"
end

function loadUI( ... )
	m_lay_member = m_fnGetWidget(m_mainMenu, "LAY_BTNS_BACK")
	m_lay_leader = m_fnGetWidget(m_mainMenu, "LAY_BTNS_LEADER")

	if( tonumber(_sigleGuildInfo.member_type) == 1 or  tonumber(_sigleGuildInfo.member_type) == 2)then
		-- 管理
		-- 工会会长
		m_lay_leader:setEnabled(true)
		m_lay_member:setEnabled(false)
		local BTN_MANAGE1 = m_fnGetWidget(m_lay_leader , "BTN_MANAGE1") -- 管理按钮
		local BTN_MEMBERS1 = m_fnGetWidget(m_lay_leader, "BTN_MEMBERS1") -- 成员按钮
		local BTN_CHAT1 = m_fnGetWidget(m_lay_leader, "BTN_CHAT1") -- 聊天按钮
		local BTN_NEWS1 = m_fnGetWidget(m_lay_leader, "BTN_NEWS1") -- 动态按钮
		local BTN_MESSAGE1 = m_fnGetWidget(m_lay_leader, "BTN_MESSAGE1") -- 留言按钮

		BTN_MANAGE1:addTouchEventListener(m_tbEvent.fnManager)
		BTN_MEMBERS1:addTouchEventListener(m_tbEvent.fnMember)
		BTN_CHAT1:addTouchEventListener(m_tbEvent.fnChat)
		BTN_NEWS1:addTouchEventListener(m_tbEvent.fnDynamic)
		BTN_MESSAGE1:addTouchEventListener(m_tbEvent.fnLeaveMessage)
	else
			--  普通成员
		m_lay_leader:setEnabled(false)
		m_lay_member:setEnabled(true)
		local BTN_MEMBERS3 = m_fnGetWidget(m_lay_member, "BTN_MEMBERS3") -- 成员按钮
		local BTN_CHAT3 = m_fnGetWidget(m_lay_member, "BTN_CHAT3") -- 聊天按钮
		local BTN_NEWS3 = m_fnGetWidget(m_lay_member, "BTN_NEWS3") -- 动态按钮
		local BTN_MESSAGE3 = m_fnGetWidget(m_lay_member, "BTN_MESSAGE3") -- 留言按钮

		BTN_MEMBERS3:addTouchEventListener(m_tbEvent.fnMember)
		BTN_CHAT3:addTouchEventListener(m_tbEvent.fnChat)
		BTN_NEWS3:addTouchEventListener(m_tbEvent.fnDynamic)
		BTN_MESSAGE3:addTouchEventListener(m_tbEvent.fnLeaveMessage)
	end


end



local tbModuleName = {
	"CafeHouseCtrl",
	"GuildDynamicListCtrl",
	"GuildListCtrl",
	"GuildMemberView",
	"GuildHallCtrl",
	"MainGuildView",
	"MainMessageCtrl",
	"GuildShopCtrl"
}
-- 更新成员按钮红点
function updateMemBtnTip( ... )

	logger:debug("更新成员按钮红点")
	if (not m_mainMenu  ) then 
		return 
	end 

	local ret = false
	for k,v in pairs(tbModuleName) do 
		if (LayerManager.curModuleName()==v) then 
			ret = true
			break
		end 
	end 

	if (not ret) then 
		return
	end 

	if( _sigleGuildInfo and tonumber(_sigleGuildInfo.member_type) == 1 or  tonumber(_sigleGuildInfo.member_type) == 2)then
		local img_member_tip = m_fnGetWidget(m_mainMenu, "IMG_MEMBERS_TIP") -- 成员按钮红点
		if (g_redPoint.newGuildMemApply.visible) then 
			img_member_tip:removeAllNodes()
			img_member_tip:addNode(UIHelper.createRedTipAnimination())
		else 
			img_member_tip:removeAllNodes()
		end 
	end 
end

function create( tbEvent )
	init()
	m_tbEvent = tbEvent
	m_mainMenu = m_fnLoadUI(jsonMenu)
	m_mainMenu:setSize(g_winSize)
	m_mainMenu.img_bg:setScale(g_fScaleX)
	loadUI()

	local img_member_tip = m_fnGetWidget(m_mainMenu, "IMG_MEMBERS_TIP") -- 成员按钮红点
	img_member_tip:removeAllNodes()
	if((tonumber(_sigleGuildInfo.member_type) == 1 or tonumber(_sigleGuildInfo.member_type) == 2) and g_redPoint.newGuildMemApply.visible)then
		img_member_tip:addNode(UIHelper.createRedTipAnimination())
	end 

	GlobalNotify.addObserver("NEW_GUILD_MEMBER_APPLY", function ( ... )
		updateMemBtnTip()
	end, nil, "guild_menu_view")

	return m_mainMenu
end
