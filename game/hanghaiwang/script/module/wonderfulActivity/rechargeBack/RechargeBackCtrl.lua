-- FileName: RechargeBackCtrl.lua
-- Author: Xufei
-- Date: 2015-07-01
-- Purpose: 充值回馈 控制模块
--[[TODO List]]

module("RechargeBackCtrl", package.seeall)
require "script/module/wonderfulActivity/rechargeBack/RechargeBackModel"
require "script/module/wonderfulActivity/rechargeBack/RechargeBackView"

-- UI控件引用变量 --
local _instanceView = nil
-- 模块局部变量 --
local function init(...)

end

function destroy()
	_instanceView = nil
	RechargeBackModel.setCell(nil)
	package.loaded["RechargeBackCtrl"] = nil
end

function moduleName()
    return "RechargeBackCtrl"
end

function dealDataAndInitView()
	RechargeBackModel.setRechargeBackData()
	local tbRechargeBackData
	tbRechargeBackData = RechargeBackModel.getListViewData()
	if (_instanceView == nil) then
		_instanceView = RechargeBackView:new()
		MainWonderfulActCtrl.addLayChild(_instanceView:create(tbRechargeBackData))
		--instanceView:scrollRechargeBack()
		RechargeBackModel.setHaveEntered()
		-- 移除new
		local listCell = RechargeBackModel.getCell()
		if (listCell) then
			listCell:removeNodeByTag(100)
		end
		RechargeBackModel.setNewAniState( 1 )
	end
end

function create()
	init()
	if (RechargeBackModel.isRechargeBackinfoSentRewardNil()) then
		function getRechargeBackInfoCallback( cbFlag, dictData, bRet )	
			if (bRet) then
				logger:debug("RechargeBackCtrl get data from backend")
				RechargeBackModel.setRechargeBackInfo(dictData.ret)		
				dealDataAndInitView()
			end
		end
		RequestCenter.recharge_getInfo(getRechargeBackInfoCallback)
	else
		logger:debug("RechargeBackCtrl already have backend data")
		dealDataAndInitView()
	end
end