-- FileName: SkyPieaWinCtrl.lua
-- Author: menghao
-- Date: 2015-1-15
-- Purpose: 空岛战斗胜利面板ctrl

module("SkyPieaWinCtrl", package.seeall)


require "script/module/SkyPiea/SkyPieaBattle/SkyPieaWinView"


-- UI控件引用变量 --


-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["SkyPieaWinCtrl"] = nil
end


function moduleName()
	return "SkyPieaWinCtrl"
end


-- star_star = "25"
-- point = "750"
-- cur_base = "2"

-- uid ="25034"
-- appraisal ="SSS"
-- hpGrade = "10000"
-- point = "750"
-- star_star = "25"
-- cur_base = "2"
function create( tbInfo )
	local layMain = SkyPieaWinView.create( tbInfo )
	return layMain
end

