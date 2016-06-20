-- FileName: GuildCopyRankCtrl.lua
-- Author: yangna
-- Date: 2015-06-02
-- Purpose: 工会副本伤害排行 控制
--[[TODO List]]

module("GuildCopyRankCtrl", package.seeall)

require "script/module/guildCopy/GuildCopyRankView"
require "script/module/guildCopy/GCRewardQueueModel"

-- UI控件引用变量 --

-- 模块局部变量 --

local tbArgs = {}


local function init(...)

end

function destroy(...)
	package.loaded["GuildCopyRankCtrl"] = nil
end

function moduleName()
    return "GuildCopyRankCtrl"
end


tbArgs.onFormation = function ( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then 
		AudioHelper.playInfoEffect()
		require "script/module/formation/FormationCtrl"
		FormationCtrl.loadFormationWithUid(sender:getTag())
	end 
end

tbArgs.onClose = function ( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
		GuildCopyMapCtrl.setGuildType(0)  --支持云鹏获取途径
	end
end

function create(copyId)
	tbArgs.BellyData = GCRewardQueueModel.getRankBellyData(copyId)
	tbArgs.ContriData = GCRewardQueueModel.getRankContriData(copyId)
	tbArgs.tbHitData = GCRewardQueueModel.getHitRankData(copyId)

	local rankView = GuildCopyRankView.create(tbArgs)
	LayerManager.addLayout(rankView)
	GuildCopyMapCtrl.setGuildType(2)  --支持云鹏获取途径
end
