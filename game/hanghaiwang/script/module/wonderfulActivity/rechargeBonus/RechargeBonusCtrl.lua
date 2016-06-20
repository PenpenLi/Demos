-- FileName: RechargeBonusCtrl.lua
-- Author: Xufei
-- Date: 2015-08-20
-- Purpose: 充值红利 控制
--[[TODO List]]

module("RechargeBonusCtrl", package.seeall)

-- UI控件引用变量 --
local _instanceRechargeBonusView
-- 模块局部变量 --

local function init(...)
	_instanceRechargeBonusView = nil
end

function destroy(...)
	_instanceRechargeBonusView = nil
	RechargeBonusModel.setCell(nil)
	package.loaded["RechargeBonusCtrl"] = nil
end

function moduleName()
    return "RechargeBonusCtrl"
end

function createRechargeBonusView( ... )
	if (_instanceRechargeBonusView == nil) then
		require "script/module/wonderfulActivity/rechargeBonus/RechargeBonusView"
		_instanceRechargeBonusView = RechargeBonusView:new()

		-- 移除new
		local listCell = RechargeBonusModel.getCell()
		if (listCell) then
			listCell:removeNodeByTag(100)
		end
		RechargeBonusModel.setNewAniState( 1 )
	end
	MainWonderfulActCtrl.addLayChild(_instanceRechargeBonusView:create())
end

function create(...)
	init()
	function getRechargeBonusDataCallback( cbFlag, dictData, bRet )
		if (bRet) then
			require "script/module/wonderfulActivity/rechargeBonus/RechargeBonusModel"
			RechargeBonusModel.setBackendInfo(dictData.ret)
			createRechargeBonusView()
			RechargeBonusModel.setHasClick()
		end
	end
	RequestCenter.rechargeBonus_getInfo(getRechargeBonusDataCallback)
	-- getRechargeBonusDataCallback(1,{
	-- 	ret={
	-- 		accumRechargeDate = 3 ,
	-- 		status = {
	-- 			[1]=1,
	-- 			[2]=0,
	-- 			[3]=1,
	-- 			[4]=0,
	-- 			[5]=0,
	-- 			[6]=1,
	-- 			[7]=0,
	-- 			[8]=1
	-- 		}
	-- 	}
	-- },1)
end
