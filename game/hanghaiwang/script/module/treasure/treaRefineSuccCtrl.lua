-- FileName: treaRefineSuccCtrl.lua
-- Author: menghao
-- Date: 2014-12-12
-- Purpose: 精炼成功界面ctrl


module("treaRefineSuccCtrl", package.seeall)


require "script/module/treasure/treaRefineSuccView"


-- UI控件引用变量 --


-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["treaRefineSuccCtrl"] = nil
end


function moduleName()
	return "treaRefineSuccCtrl"
end


function create(tbTreaInfo)
	logger:debug({treaRefineSuccCtrl = tbTreaInfo})
	local layMain = treaRefineSuccView.create(tbTreaInfo)
	LayerManager.addLayoutNoScale(layMain)
end

