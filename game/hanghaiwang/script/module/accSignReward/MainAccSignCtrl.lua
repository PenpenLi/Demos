-- FileName: MainAccSignCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-11-25
-- Purpose: 开服礼包 控制模块
--[[TODO List]]

module("MainAccSignCtrl", package.seeall)
require "script/module/accSignReward/MainAccSignView"
require "script/module/accSignReward/AccSignModel"

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["MainAccSignCtrl"] = nil
end

function moduleName()
    return "MainAccSignCtrl"
end

function create(...)

	local accData = AccSignModel.getAllAccRewardData()

	local tbBtnEvent = {}

	-- use
	tbBtnEvent.onClose = function( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onClose")
			AudioHelper.playCloseEffect()
			-- MainAccSignView.fnFreshListView()
			-- LayerManager.removeLayout()
			-- MainShip.updateAccRewardRedPoint()
		end	
	end


	if(accData == nil) then
		function accSignInfoCallbck(cbFlag, dictData, bRet )
			if(dictData.err == "ok") then
				if(  not table.isEmpty(dictData.ret)) then
					AccSignModel.setAccSignInfo(dictData.ret)
					accData = AccSignModel.getAllAccRewardData()

					local accView = MainAccSignView.create(tbBtnEvent,accData)
					MainWonderfulActCtrl.addLayChild(accView) 


					local currentIndex = AccSignModel.getCurrentIndex()
					
					performWithDelay(accView, function ( ... )
						MainAccSignView.scrollPassGetRow(currentIndex)
					end, 0.05)
				end
			end

		end

		Network.rpc(accSignInfoCallbck, "sign.getAccInfo" , "sign.getAccInfo", nil , true)

	else

		local accView = MainAccSignView.create(tbBtnEvent,accData)
		-- LayerManager.addLayout(accView)
		MainWonderfulActCtrl.addLayChild(accView) 
		local currentIndex = AccSignModel.getCurrentIndex()
		-- MainAccSignView.scrollPassGetRow(currentIndex)
					performWithDelay(accView, function ( ... )
						MainAccSignView.scrollPassGetRow(currentIndex)
					end, 0.1)
	end
end
