-- FileName: ChanglageSelectHardView.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("ChanglageSelectHardView", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName

local function init(...)

end

function destroy(...)
	package.loaded["ChanglageSelectHardView"] = nil
end

function moduleName()
    return "ChanglageSelectHardView"
end
function create(...)
	local mainLayout = g_fnLoadUI("ui/acopy_choose.json")
	-- mainLayout.BTN_CLOSE:setTitleText("ok了")
	-- mainLayout.img_title:setOpacity(100)
	return mainLayout
end
