-- FileName: treaRefineCostCtrl.lua
-- Author: menghao
-- Date: 2014-12-12
-- Purpose: 宝物精炼消耗预览ctrl


module("treaRefineCostCtrl", package.seeall)


require "script/module/treasure/treaRefineCostView"


-- UI控件引用变量 --


-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["treaRefineCostCtrl"] = nil
end


function moduleName()
	return "treaRefineCostCtrl"
end


function create( tbAllCostInfo , itemID, evolveLv)
	local layMain = treaRefineCostView.create( tbAllCostInfo, itemID, evolveLv)
	LayerManager.addLayout(layMain)
	treaRefineCostView.adjustLsv(evolveLv)
end

