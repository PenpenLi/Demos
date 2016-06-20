-- FileName: ArenaMRankCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-09
-- Purpose: 竞技场的排行控制模块
--[[TODO List]]



module ("ArenaRankCtrl",package.seeall)

require "script/module/arena/ArenaRankView"

local function init(...)

end

function destroy(...)
	package.loaded["ArenaRankCtrl"] = nil
end

function moduleName()
    return "ArenaRankCtrl"
end

function create()
	local tbBtnEvent = {}
	-- 阵容按钮
	tbBtnEvent.onFormation 	= function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onFormation:".. sender:getTag())
			AudioHelper.playCommonEffect()
			-------------------add by zhaoqiangjun 201405241106--------------------
			require "script/module/formation/FormationCtrl"
			FormationCtrl.loadFormationWithUid(sender:getTag())
    		-------------------------------------------------------------------------
		end
	end
	-- 幸运排名按钮
	tbBtnEvent.onLuckRank = function( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/arena/ArenaLuckCtrl"
			ArenaLuckCtrl.create()
		end	
	end

	local arenaRankInfo = ArenaRankView.create(tbBtnEvent)
	return arenaRankInfo
end