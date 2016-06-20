-- FileName: RechargeView.lua
-- Author: zhangqi
-- Date: 2015-03-02
-- Purpose: 接渠道SDK临时用测试充值的UI
--[[TODO List]]

-- module("RechargeView", package.seeall)

local m_fnGetWidget = g_fnGetWidgetByName
local tbNum = {1, 10, 60, 100, 200, 500,}

RechargeView = class("RechargeView")

-- fnUpdateName: 更名成功后刷新玩家名称的方法
function RechargeView:ctor(fnUpdateName)
	self.layMain = g_fnLoadUI("ui/chongzhilinshi.json")
end

function RechargeView:create( tbData )
	for i, num in ipairs(tbNum) do
		local btn = m_fnGetWidget(self.layMain, "BTN_" .. num)
		btn:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				logger:debug("recharge gold num: %d", num)
				require "platform/Platform"
				Platform.pay(num)
				UIHelper.closeCallback()
			end
		end)
	end

	local btnClose = m_fnGetWidget(self.layMain, "BTN_CLOSE")
	btnClose:addTouchEventListener(UIHelper.onClose)

	LayerManager.addLayout(self.layMain)
end
