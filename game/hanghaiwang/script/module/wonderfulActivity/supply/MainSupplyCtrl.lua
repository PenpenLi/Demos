-- FileName: MainSupplyCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-29
-- Purpose: function description of module
-- 吃烧鸡控制模块
--[[TODO List]]

module("MainSupplyCtrl", package.seeall)

require "script/module/wonderfulActivity/supply/MainSupplyView"
require "script/network/RequestCenter"
require "script/module/wonderfulActivity/MainWonderfulActCtrl"
require "script/module/wonderfulActivity/supply/SupplyModel"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local function init(...)

end

function destroy(...)
	package.loaded["MainSupplyCtrl"] = nil
end

function moduleName()
    return "MainSupplyCtrl"
end

-- 吃按钮的网络回调函数
function supplyExecutionCb(cbFlag, dictData, bRet)
	if (dictData.err == "ok") then
		MainSupplyView.addCokeAnimation()
		UserModel.addEnergyValue(tonumber(dictData.ret))
		ShowNotice.showShellInfo(gi18n[3001]) -- "成功获得50点体力",
		SupplyModel.setSupplyTime(TimeUtil.getSvrTimeByOffset())
		MainSupplyView.updateUI()
		WonderfulActModel.tbBtnActList.supply:setVisible(false)
	end
end


-- 按钮按钮时间的回调函数
function doEat( )
	-- do
	-- 	MainSupplyView.addCokeAnimation()
	-- 	return 
	-- end
	local _isOnTime = SupplyModel.isOnTime()
	if( _isOnTime== false ) then
		-- ShowNotice.showShellInfo("吃烧鸡时间已过")
		ShowNotice.showShellInfo(m_i18n[3003])
		return
	end
	RequestCenter.supply_supplyExecution(supplyExecutionCb)	
end

-- 获得获得上次领取的时间
function getSupplyInfo(cbFlag, dictData, bRet )
	if (dictData.err == "ok") then
		print_t(dictData.ret)
		SupplyModel.setSupplyTime(dictData.ret) 
		createView()
    end
end

function create( )
	RequestCenter.supply_getSupplyInfo(getSupplyInfo)
end


function createView(  )
	local tbBtnEvent = {}
	-- 按钮 吃烧鸡按钮
	tbBtnEvent.onPower = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onPower")
			doEat()
		end
	end
	local supplyView = MainSupplyView.create(tbBtnEvent)
	MainWonderfulActCtrl.addLayChild(supplyView)
end