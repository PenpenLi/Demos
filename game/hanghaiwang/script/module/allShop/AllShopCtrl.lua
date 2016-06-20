-- FileName: AllShopCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-09-06
-- Purpose: 所有商店入口整合
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("AllShopCtrl", package.seeall)

require "script/module/allShop/AllShopView"
require "script/module/allShop/AllShopData"
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["AllShopCtrl"] = nil
end

function moduleName()
    return "AllShopCtrl"
end

function create( )
	init()
	_instanceView = AllShopView:new()
	local layView = _instanceView:create()
	return layView
end
