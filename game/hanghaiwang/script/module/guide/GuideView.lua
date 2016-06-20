-- FileName: GuideView.lua
-- Author: huxiaozhou
-- Date: 2014-06-06
-- Purpose: function description of module
--[[TODO List]]
-- 新手引导界面 可能显示不同的view layout

module("GuideView", package.seeall)


-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName


local function init(...)

end

function destroy(...)
	package.loaded["GuideView"] = nil
end

function moduleName()
    return "GuideView"
end

function create(...)

end

