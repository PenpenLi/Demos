-- FileName: AstrologyExplainCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-06-20
-- Purpose: 占卜 说明模块
--[[TODO List]]

module("AstrologyExplainCtrl", package.seeall)
require "script/module/astrology/AstrologyExplainView"
-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["AstrologyExplainCtrl"] = nil
end

function moduleName()
	return "AstrologyExplainCtrl"
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function create(...)
	init()

	local tbEventListener = {}
	--返回按钮事件回调
	tbEventListener.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onClose clicked")
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	local layMain = AstrologyExplainView.create( tbEventListener )

	return layMain
end

