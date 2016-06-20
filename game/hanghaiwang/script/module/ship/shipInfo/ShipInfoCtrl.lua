-- FileName: ShipInfoCtrl.lua
-- Author: Xufei
-- Date: 2015-10-16
-- Purpose: 主船信息控制模块
--[[TODO List]]

module("ShipInfoCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["ShipInfoCtrl"] = nil
end

function moduleName()
    return "ShipInfoCtrl"
end

function btnEventGoStrength( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		require "script/module/ship/shipStrength/ShipStrengthCtrl"
		ShipStrengthCtrl.create(ShipInfoModel.getShipId())
	end
end

function btnEventClose( sender, eventType ) -- 确定
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		LayerManager.removeLayout()
	end
end

function btnEventBack( sender, eventType ) -- 返回
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		LayerManager.removeLayout()
	end
end

function createView()
	require "script/module/ship/shipInfo/ShipInfoView"
	local shipInfoViewInstance = ShipInfoView:new()
	local view = shipInfoViewInstance:create()
	if (view) then
		LayerManager.addLayoutNoScale(view)
	end
end

function create( shipId )
	if (shipId) then
		require "script/module/ship/shipInfo/ShipInfoModel"
		ShipInfoModel.updateShipInfoModel( shipId )
		createView()
	end
end
