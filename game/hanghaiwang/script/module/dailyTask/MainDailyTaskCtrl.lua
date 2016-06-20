-- FileName: MainDailyTaskCtrl.lua
-- Author: lizy
-- Date: 2014-11-11
-- Purpose: function description of module
--[[TODO List]]

module("MainDailyTaskCtrl", package.seeall)
require "script/module/dailyTask/MainDailyTaskView"
-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["MainDailyTaskCtrl"] = nil
end

function moduleName()
    return "MainDailyTaskCtrl"
end

function create(...)
    
     return  MainDailyTaskView.create()
end
