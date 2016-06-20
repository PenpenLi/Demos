-- FileName: ShowGetCtrl.lua
-- Author: menghao
-- Date: 2014-11-15
-- Purpose: 获取到宝物或者宝物碎片显示ctrl
--[[TODO List]]


module("ShowGetCtrl", package.seeall)


require "script/module/grabTreasure/ShowGetView"


-- UI控件引用变量 --


-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["ShowGetCtrl"] = nil
end


function moduleName()
	return "ShowGetCtrl"
end


function create( itemID, itemName, call )
	local layMain = ShowGetView.create( itemID, itemName, call )
	return layMain
end

