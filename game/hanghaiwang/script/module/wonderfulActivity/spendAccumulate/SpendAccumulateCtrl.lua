-- FileName: SpendAccumulateCtrl.lua
-- Author: Xufei
-- Date: 2015-06-25
-- Purpose: 消费累积 控制模块
--[[TODO List]]

module("SpendAccumulateCtrl", package.seeall)
require "script/module/wonderfulActivity/spendAccumulate/SpendAccumulateModel"
require "script/module/wonderfulActivity/spendAccumulate/SpendAccumulateView"


-- UI控件引用变量 --
local _instanceView = nil
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	_instanceView = nil
	SpendAccumulateModel.setCell(nil)
	package.loaded["SpendAccumulateCtrl"] = nil
end

function moduleName()
    return "SpendAccumulateCtrl"
end

function refreshView()
	logger:debug("refreshListView")
	if (_instanceView) then
		_instanceView:refreshListView()
	end	
end

function dealDataAndInitView()
	SpendAccumulateModel.setSpendAccData()
	if (_instanceView == nil) then
		_instanceView = SpendAccumulateView:new()
		MainWonderfulActCtrl.addLayChild(_instanceView:create())
		--_instanceView:scrollSpendAccumulate()
		SpendAccumulateModel.setHaveEntered()	
		-- 移除new
		local listCell = SpendAccumulateModel.getCell()
		if (listCell) then
			listCell:removeNodeByTag(100)
		end
		SpendAccumulateModel.setNewAniState( 1 )
	end
end

function create()
	init()
	logger:debug("create spendAccumulate")
	if (SpendAccumulateModel.isSpendInfoSentRewardNil()) then
		function getSpendAccInfoCallback( cbFlag, dictData, bRet )	
			if (bRet) then
				logger:debug("SpendAccumulateCtrl get data from backend")
				SpendAccumulateModel.setSpendAccInfo(dictData.ret)
				dealDataAndInitView()
			end
		end
		RequestCenter.spend_getInfo(getSpendAccInfoCallback)
	else
		logger:debug("SpendAccumulateCtrl already have backend data")
		dealDataAndInitView()
	end
end









