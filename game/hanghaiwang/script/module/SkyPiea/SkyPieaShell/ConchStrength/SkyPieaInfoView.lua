-- FileName: SkyPieaInfoView.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("SkyPieaInfoView", package.seeall)

-- UI控件引用变量 --
local layoutMain
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["SkyPieaInfoView"] = nil
end

function moduleName()
    return "SkyPieaInfoView"
end

function create(tbEquip,viewType)
	layoutMain = Layout:create()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
				end,
				function()
				end
			) 
		--副本标签
		local mainLayout
		if (viewType==1) then
			mainLayout = g_fnLoadUI("ui/conch_info.json")
			local confirm = g_fnGetWidgetByName(layoutMain, "BTN_CONFIRM")
			--更换
			local confirmSure = g_fnGetWidgetByName(layoutMain, "BTN_CONFIRM_SURE")
			--去升级
		else
			mainLayout = g_fnLoadUI("ui/conch_info_bag.json")
			local confirm = g_fnGetWidgetByName(layoutMain, "BTN_CONFIRM")
			--去升级
			local confirmSure = g_fnGetWidgetByName(layoutMain, "BTN_CONFIRM_SURE")
			confirmSure:addTouchEventListener(UIHelper.onClose)
			local confirm = g_fnGetWidgetByName(layoutMain, "BTN_SURE")
			confirm:addTouchEventListener(UIHelper.onClose)
			if (viewType==2) then
				confirm:setEnabled(false)
				confirmSure:setEnabled(false)
			else
				confirm:setEnabled(false)
			end
		end

		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		local backBtn = g_fnGetWidgetByName(layoutMain, "BTN_CLOSE")
		backBtn:addTouchEventListener(UIHelper.onClose)

	end
	return layoutMain
end
