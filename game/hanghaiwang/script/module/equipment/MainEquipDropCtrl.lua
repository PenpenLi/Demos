-- FileName: MainEquipDropCtrl.lua
-- Author: wangming
-- Date: 2014-12-07
-- Purpose: 装备掉落模块
--[[TODO List]]

module("MainEquipDropCtrl", package.seeall)
require "script/module/equipment/MainEquipDropView"
-- UI控件引用变量 --

-- 模块局部变量 --
local equipmentInfo 

local function init(...)

end

function destroy(...)
	package.loaded["MainEquipDropCtrl"] = nil
end

function moduleName()
    return "MainEquipDropCtrl"
end

function create(equipmentInfos,returnInfo)
   equipmentInfo = equipmentInfos

    local  layBg  =   MainEquipDropView.create(equipmentInfo,returnInfo)
     LayerManager.addLayout(layBg)
  
end