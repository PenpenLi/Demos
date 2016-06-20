-- FileName: ShipActivateView.lua
-- Author: LvNanchun
-- Date: 2015-10-21
-- Purpose: function description of module
--[[TODO List]]

ShipActivateView = class("ShipActivateView")

-- UI variable --

-- module local variable --

function ShipActivateView:moduleName()
    return "ShipActivateView"
end

function ShipActivateView:ctor(...)
	_layMain = g_fnLoadUI("ui/ship_succeed.json")
end

function ShipActivateView:create( tbActivate , fnResetView )
	logger:debug({tbActivate = tbActivate})

	_layMain.TFD_BEFORE_HP:setText(tbActivate.pre[1])
	_layMain.TFD_AFTER_HP:setText(tbActivate.now[1])
	_layMain.TFD_AFTER_HP:setColor(tbActivate.color[1])
	_layMain.TFD_BEFORE_PHY_ATTACK:setText(tbActivate.pre[2])
	_layMain.TFD_AFTER_PHY_ATTACK:setText(tbActivate.now[2])
	_layMain.TFD_AFTER_PHY_ATTACK:setColor(tbActivate.color[2])
	_layMain.TFD_BEFORE_MAGIC_ATTACK:setText(tbActivate.pre[3])
	_layMain.TFD_AFTER_MAGIC_ATTACK:setText(tbActivate.now[3])
	_layMain.TFD_AFTER_MAGIC_ATTACK:setColor(tbActivate.color[3])
	_layMain.TFD_BEFORE_PHY_DENFEND:setText(tbActivate.pre[4])
	_layMain.TFD_AFTER_PHY_DENFEND:setText(tbActivate.now[4])
	_layMain.TFD_AFTER_PHY_DENFEND:setColor(tbActivate.color[4])
	_layMain.TFD_BEFORE_MAGIC_DENFEND:setText(tbActivate.pre[5])
	_layMain.TFD_AFTER_MAGIC_DENFEND:setText(tbActivate.now[5])
	_layMain.TFD_AFTER_MAGIC_DENFEND:setColor(tbActivate.color[5])

	_layMain:setTouchEnabled(true)
	_layMain:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			LayerManager.removeLayout()
			fnResetView()
		end
	end)

	return _layMain
end

