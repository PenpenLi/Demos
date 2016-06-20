-- FileName: SkyPieaRankCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 空岛排行榜 控制器
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("SkyPieaRankCtrl", package.seeall)
require "script/module/SkyPiea/SkyPieaRank/SkyPieaRankView"
require "script/module/SkyPiea/SkyPieaRank/SkyPieaRankPreRewadCtrl"
local function init(...)

end

function destroy(...)
	package.loaded["SkyPieaRankCtrl"] = nil
end

function moduleName()
	return "SkyPieaRankCtrl"
end

--[[
	@desc: 获取要绑定的function
    @return: tb  type: table
—]]
function getBtnBindingFuctions(  )
	local tbEvent = {}

	-- 关闭按钮事件
	tbEvent.onClose = UIHelper.onClose

	-- 奖励预览按钮事件
	tbEvent.onPreReward = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			SkyPieaRankPreRewadCtrl.create()
		end
	end

	return tbEvent
end

local function getRankCallBack(cbFlag, dictData, bRet)
	SkyPieaModel.setRankList(dictData.ret)
	createView()
end

function create()
	RequestCenter.skyPieaGetRankList(getRankCallBack)
end

function createView(  )
	local tbEvent = getBtnBindingFuctions()
	local view = SkyPieaRankView.create(tbEvent)
	if view then
		LayerManager.addLayoutNoScale(view)
	end
end
