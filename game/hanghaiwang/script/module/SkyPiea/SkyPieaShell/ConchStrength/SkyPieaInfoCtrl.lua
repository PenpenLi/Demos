-- FileName: SkyPieaInfoCtrl.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("SkyPieaInfoCtrl", package.seeall)
require "script/module/SkyPiea/SkyPieaShell/ConchStrength/SkyPieaInfoView"
-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["SkyPieaInfoCtrl"] = nil
end

function moduleName()
    return "SkyPieaInfoCtrl"
end
-- 阵容中展示装备信息
function createForFormation( tbEquip ,n_curPageNum)
	layEquip = SkyPieaInfoView.create(tbEquip,1)
	LayerManager.addLayout(layEquip)
end

-- 查看他人阵容中展示装备信息，tbAllUse是一个人物已穿戴的所有装备信息
function createForOtherFormation( tbEquip, tbAllUse, nlevel)
	layEquip = SkyPieaInfoView.create(tbEquip,2)
	LayerManager.addLayout(layEquip)
end

-- 装备列表中展示装备信息
function createForConch( tbEquip )
	layEquip = SkyPieaInfoView.create(tbEquip,3)
	LayerManager.addLayout(layEquip)
end
function create(...)

end
