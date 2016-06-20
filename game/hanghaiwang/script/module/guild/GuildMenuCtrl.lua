-- FileName: GuildMenuCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-09-19
-- Purpose: function description of module
--[[TODO List]]

module("GuildMenuCtrl", package.seeall)
require "script/module/guild/GuildMenuView"
require "script/module/guild/GuildManageCtrl"
require "script/module/guild/dynamic/GuildDynamicListCtrl"
require "script/module/guild/message/MainMessageCtrl"

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["GuildMenuCtrl"] = nil
end

function moduleName()
	return "GuildMenuCtrl"
end

function update( ... )
	GuildMenuView.loadUI()
end

function create(...)
	local tbEvents = {}
	-- 管理
	tbEvents.fnManager = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect()
			logger:debug("fnManager")
			GuildManageCtrl.create()
		end
	end

	-- 成员
	tbEvents.fnMember = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect()
			logger:debug("fnMember")
			if (LayerManager.curModuleName() ~= "GuildMemberView") then
				require "script/module/guild/GuildMemberCtrl"
				GuildMemberCtrl.create()
			end
		end
	end

	--  聊天
	tbEvents.fnChat = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect()
			logger:debug("fnChat")
			require "script/module/chat/ChatCtrl"
			local layChat = ChatCtrl.create(3)
		end
	end

	-- 动态
	tbEvents.fnDynamic = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect()
			logger:debug("fnDynamic")
			GuildDynamicListCtrl.create()
		end
	end
	-- 留言板
	tbEvents.fnLeaveMessage= function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect()
			logger:debug("fnLeaveMessage")
			MainMessageCtrl.create()
		end
	end

	local menu = GuildMenuView.create(tbEvents)
	return menu
end
