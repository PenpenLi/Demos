-- FileName: PartnerBondExplainView.lua
-- Author: LvNanchun
-- Date: 2015-10-23
-- Purpose: 羁绊说明面板
--[[TODO List]]

PartnerBondExplainView = class("PartnerBondExplainView")

-- UI variable --
local _layMain

-- module local variable --
local _i18n = gi18n

function PartnerBondExplainView:moduleName()
    return "PartnerBondExplainView"
end

function PartnerBondExplainView:ctor(...)
	_layMain = g_fnLoadUI("ui/help_decompose.json")
end

function PartnerBondExplainView:create(...)
	_layMain.tfd_desc:setText(_i18n[6105])

	_layMain.BTN_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)
	return _layMain
end

