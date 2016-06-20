-- FileName: GrabEnemyListCtrl.lua
-- Author: menghao
-- Date: 2015-04-10
-- Purpose: 夺宝仇人列表ctrl


module("GrabEnemyListCtrl", package.seeall)


-- UI控件引用变量 --


-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["GrabEnemyListCtrl"] = nil
end


function moduleName()
	return "GrabEnemyListCtrl"
end


local function onBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		MainGrabTreasureCtrl.create()
	end
end


function create(...)
	TreasureService.getSeizerInfo(function ( ... )
		require "script/module/grabTreasure/GrabEnemyListView"
		local layMain = GrabEnemyListView.create(onBack)
		LayerManager.changeModule(layMain, GrabEnemyListCtrl.moduleName(), {1, 3}, true)
		PlayerPanel.addForGrab()
	end)
end

