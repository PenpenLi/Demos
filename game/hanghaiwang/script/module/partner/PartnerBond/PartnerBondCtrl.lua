-- FileName: PartnerBondCtrl.lua
-- Author: lvnanchun
-- Date: 2015-07-22
-- Purpose: 羁绊界面控制器
--[[TODO List]]

module("PartnerBondCtrl", package.seeall)
require "script/module/partner/PartnerBond/PartnerBondModel"
require "script/module/partner/PartnerBond/PartnerBondView"

-- UI variable --

-- module local variable --

local function init(...)

end

function destroy(...)
    package.loaded["PartnerBondCtrl"] = nil
end

function moduleName()
    return "PartnerBondCtrl"
end

function create( layPreType , heroId )
	local bondLayerInstance = PartnerBondView:new()
	return bondLayerInstance:create( layPreType , heroId )
end

