-- FileName: ImpelLoseCtrl.lua
-- Author: LvNanchun
-- Date: 2015-09-10
-- Purpose: function description of module
--[[TODO List]]

module("ImpelLoseCtrl", package.seeall)

-- UI variable --

-- module local variable --

local function init(...)

end

function destroy(...)
    package.loaded["ImpelLoseCtrl"] = nil
end

function moduleName()
    return "ImpelLoseCtrl"
end

function create( prisonLevel )
	require "script/module/impelDown/ImpelResult/ImpelLoseView"
	local instanceView = ImpelLoseView:new()
	return instanceView:create( prisonLevel )
end

