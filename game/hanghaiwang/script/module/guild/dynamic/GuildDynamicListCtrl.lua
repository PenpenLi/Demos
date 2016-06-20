-- FileName: GuildDynamicListCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-04-00
-- Purpose: 联盟动态ctrl
--[[TODO List]]

module("GuildDynamicListCtrl", package.seeall)
require "script/module/guild/dynamic/GuildDynamicListView"
-- UI控件引用变量 --

-- 模块局部变量 --
local tbEvents = {}
local m_tbGuildListInfo 			= nil	-- 军团列表缓存信息

local function init(...)
	m_tbGuildListInfo = nil
end

function destroy(...)
	package.loaded["GuildDynamicListCtrl"] = nil
end

function moduleName()
	return "GuildDynamicListCtrl"
end

function create(...)
	logger:debug("GuildDynamicListCtrl create")
	tbEvents = {}

	-- 返回按钮事件
	tbEvents.fnBack = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnBack")
			AudioHelper.playBackEffect()

			MainGuildCtrl.getGuildInfo(true)
		end
	end
	RequestCenter.guild_getDynamicList(getDynamicListCallback)
end
-- 联盟动态请求回调
function getDynamicListCallback(  cbFlag, dictData, bRet  )
	if(bRet)then
		--if(not table.isEmpty(dictData.ret))then
		-- -- 创建军团列表
		local view = GuildDynamicListView.create(tbEvents ,dictData.ret)
		view:addChild(GuildMenuCtrl.create())
		LayerManager.changeModule(view, GuildDynamicListCtrl.moduleName(), {1}, true)
		--end
	end
end

