-- FileName: SkyPieaStrenthMain.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("SkyPieaStrenthMain", package.seeall)

-- UI控件引用变量 --
local layoutMain
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["SkyPieaStrenthMain"] = nil
end

function moduleName()
    return "SkyPieaStrenthMain"
end

--更新基本信息
function updateBaseInfo()
	local haveBelly = g_fnGetWidgetByName(layoutMain, "LABN_OWN_BELLY")
	haveBelly:setStringValue(UserModel.getSilverNumber())
	
end
function create(...)
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
		local mainLayout = g_fnLoadUI("ui/conch_strengthen.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		local backBtn = g_fnGetWidgetByName(layoutMain, "BTN_CLOSE")
		backBtn:addTouchEventListener(UIHelper.onClose)

		
		updateBaseInfo()

	end
	return layoutMain
end
