-- FileName: SkyPieaRankPreRewadCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-01-09
-- Purpose: 奖励预览控制器
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("SkyPieaRankPreRewadCtrl", package.seeall)
require "script/module/SkyPiea/SkyPieaRank/SkyPieaRankPreRewadView"
-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["SkyPieaRankPreRewadCtrl"] = nil
end

function moduleName()
	return "SkyPieaRankPreRewadCtrl"
end

--[[
	@desc: 获取要绑定的function
    @return: tb  type: table
—]]
function getBtnBindingFuctions(  )
	local tbEvent = {}

	-- 关闭按钮事件
	tbEvent.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onClose")
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	-- 确定按钮事件
	tbEvent.onConfirm = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onConfirm")
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	return tbEvent
end


function create()
	local tbEvent = getBtnBindingFuctions()
	local view = SkyPieaRankPreRewadView.create(tbEvent)
	if view then
		LayerManager.addLayoutNoScale(view)
	end
end
