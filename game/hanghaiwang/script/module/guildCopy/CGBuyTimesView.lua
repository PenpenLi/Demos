-- FileName: CGBuyTimesView.lua
-- Author: liweidong
-- Date: 2015-06-05
-- Purpose: 购买副本攻打次数
--[[TODO List]]

module("CGBuyTimesView", package.seeall)

-- UI控件引用变量 --
local _layoutMain
-- 模块局部变量 --
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["CGBuyTimesView"] = nil
end

function moduleName()
    return "CGBuyTimesView"
end
function setUII18n(base)
	base.TFD_COPY:setText(m_i18n[5945])
end
function initUI()
	_layoutMain = g_fnLoadUI("ui/activity_buy_times.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_layoutMain=nil
			end,
			function()
			end
		) 

	setUII18n(_layoutMain)
	_layoutMain.TFD_GOLD_NUM:setText(GCItemModel.getBuyTimesGold())
	_layoutMain.LABN_VIP:setStringValue(UserModel.getVipLevel())
	_layoutMain.TFD_CANBUY_NUM:setText(GCItemModel.getBuyTimesRemainNum())

	_layoutMain.BTN_ENSURE:addTouchEventListener(
		function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				GCItemCtrl.onConfirmBuyTime()
			end
		end
		)
	_layoutMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	_layoutMain.BTN_CANCEL:addTouchEventListener(UIHelper.onClose)

	return _layoutMain
end
function create()
	return initUI()
end
