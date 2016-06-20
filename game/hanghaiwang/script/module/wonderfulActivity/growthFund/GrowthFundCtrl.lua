-- FileName: GrowthFundCtrl.lua
-- Author: LvNanchun and XuFei
-- Date: 2015-06-17
-- Purpose: 成长基金控制模块
--[[TODO List]]

module("GrowthFundCtrl", package.seeall)
require "script/module/wonderfulActivity/growthFund/GrowthFundView"
require "script/module/wonderfulActivity/growthFund/EveryoneWelfareView"
-- UI控件引用变量 --
local _instanceGrowthView = nil
local _instanceWelfareView = nil
-- 模块局部变量 --

function destroy(...)
	_instanceGrowthView = nil
	--_instanceWelfareView =nil
	package.loaded["GrowthFundCtrl"] = nil
end

function moduleName()
    return "GrowthFundCtrl"
end

function refreshWelfareView( ... )
	createWelfareView()
end



function createGrowthView( ... )
	if (_instanceGrowthView == nil) then 	
		_instanceGrowthView = GrowthFundView:new()
		MainWonderfulActCtrl.addLayChild(_instanceGrowthView:create())
		GrowthFundView:scrollGrowthFund()
	end
end

function createWelfareView( ... )
	if (_instanceWelfareView == nil) then
		local _instanceWelfareView = EveryoneWelfareView:new()
		_instanceWelfareView:create()
	end
end

-- modified by Xufei 2015-08-11
function create( initTag )
	if ( initTag == 1 ) then
		if (GrowthFundModel.isGotBackEnd()) then
			createGrowthView()
		else
			function growInfoCallback( cbFlag, dictData, bRet )
				if (bRet) then
					logger:debug("GrowthFundCtrl getData from houduan.")

					require "script/module/wonderfulActivity/growthFund/GrowthFundModel"
					GrowthFundModel.setGrowthInfo(dictData.ret)

					createGrowthView()
				end
			end
			RequestCenter.growUp_getInfo(growInfoCallback)
		end
	elseif( initTag == 2 ) then						-- added by Xufei 2015-08-11
		--if (EveryoneWelfareModel.isGotBackEnd()) then
		--	createWelfareView()
		--else
			function everyoneWelfareCallback( cbFlag, dictData, bRet )
				if (bRet) then
					logger:debug("Got EveryoneWelfare Data!")

					require "script/module/wonderfulActivity/growthFund/EveryoneWelfareModel"
					EveryoneWelfareModel.setBackendInfo(dictData.ret)

					createWelfareView()
				end
			end
			RequestCenter.growUp_getInfo(everyoneWelfareCallback)
		--end
	end
end

