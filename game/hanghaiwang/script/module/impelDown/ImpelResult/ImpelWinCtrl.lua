-- FileName: ImpelWinCtrl.lua
-- Author: LvNanchun
-- Date: 2015-09-10
-- Purpose: function description of module
--[[TODO List]]

module("ImpelWinCtrl", package.seeall)

-- UI variable --

-- module local variable --

local function init(...)

end

function destroy(...)
    package.loaded["ImpelWinCtrl"] = nil
end

function moduleName()
    return "ImpelWinCtrl"
end

function create( prisonLevel )
	require "script/module/impelDown/ImpelResult/ImpelWinView"
	local instanceView = ImpelWinView:new()
	return instanceView:create(prisonLevel)
end

