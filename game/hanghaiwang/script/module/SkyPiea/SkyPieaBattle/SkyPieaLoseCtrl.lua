-- FileName: SkyPieaLoseCtrl.lua
-- Author: menghao
-- Date: 2015-1-15
-- Purpose: 空岛战斗失败面板ctrl


module("SkyPieaLoseCtrl", package.seeall)


require "script/module/SkyPiea/SkyPieaBattle/SkyPieaLoseView"


-- UI控件引用变量 --


-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["SkyPieaLoseCtrl"] = nil
end


function moduleName()
	return "SkyPieaLoseCtrl"
end


function create(...)
	local layMain = SkyPieaLoseView.create()
	return layMain
end

