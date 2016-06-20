-- FileName: RecoverPreShowCtrl.lua
-- Author:zhangjunwu
-- Date: 2014-9-29
-- Purpose: 分解物回收预览界面
--[[TODO List]]

module("RecoverPreShowCtrl", package.seeall)

-- UI控件引用变量 --
require "script/module/resolve/RecoverPreShowView"
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["RecoverPreShowCtrl"] = nil
end
--释放资源
function destruct( ... )

end

function moduleName()
	return "RecoverPreShowCtrl"
end

--[[desc:功能简介
    return: 是否有返回值，返回值说明  
—]]
function create(tbListData,tabType )
	m_tArgsOfModule = tbListData
	local tbOnTouch = {}
	--确认按钮
	tbOnTouch.onSure = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onSure")
			AudioHelper.playCommonEffect()
			MainRecoveryCtrl.setShowState(0)
			MainRecoveryCtrl.beginToResolve()
			LayerManager.removeLayout()
		end
	end
	--返回按钮
	tbOnTouch.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onBack")
			AudioHelper.playBackEffect()
			LayerManager.removeLayout()
		end
	end

	local layMain = RecoverPreShowView.create(tbOnTouch ,tbListData,tabType)
	m_curPage = tabType
	LayerManager.addLayout(layMain)
	return layMain
end

