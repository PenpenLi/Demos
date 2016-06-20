-- FileName: GrowthFundTabView.lua
-- Author: Xufei
-- Date: 2015-08-12
-- Purpose: 页签
--[[TODO List]]

GrowthFundTabView = class("GrowthFundTabView")
-- UI控件引用变量 --
local _layMain

-- 模块局部变量 --
local _i18n = gi18n

function GrowthFundTabView:dealWithI18n()
	UIHelper.titleShadow(_layMain.BTN_GROWTH_FUND, _i18n[6405])
	UIHelper.titleShadow(_layMain.BTN_ALL_PEOPLE, _i18n[6406])
end

function GrowthFundTabView:destroy()
	package.loaded["GrowthFundTabView"] = nil
end

function GrowthFundTabView:moduleName()
    return "GrowthFundTabView"
end

function GrowthFundTabView:ctor()
	self.layMain = g_fnLoadUI("ui/activity_fund_yeqian.json")
end

function GrowthFundTabView:create(createTag)
	_layMain = self.layMain
	self:dealWithI18n()
	_layMain.BTN_RECHARGE:addTouchEventListener(function (sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
				require "script/module/IAP/IAPCtrl"
				LayerManager.addLayout(IAPCtrl.create())
		end 
	end)

	if (createTag == 1) then
		_layMain.BTN_GROWTH_FUND:setFocused(true)
		_layMain.BTN_ALL_PEOPLE:setFocused(false)
		_layMain.BTN_GROWTH_FUND:setTouchEnabled(false)
		_layMain.BTN_ALL_PEOPLE:setTouchEnabled(true)

		_layMain.BTN_ALL_PEOPLE:addTouchEventListener(function (sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				_layMain.BTN_ALL_PEOPLE:setFocused(true)
				GrowthFundCtrl.create(2)
			end
		end)
	end

	if (createTag == 2) then
		_layMain.BTN_GROWTH_FUND:setFocused(false)
		_layMain.BTN_ALL_PEOPLE:setFocused(true)
		_layMain.BTN_GROWTH_FUND:setTouchEnabled(true)
		_layMain.BTN_ALL_PEOPLE:setTouchEnabled(false)

		_layMain.BTN_GROWTH_FUND:addTouchEventListener(function (sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				GrowthFundCtrl.create(1)
			end
		end)
	end

	_layMain.IMG_FUND_TIP:setVisible(GrowthFundModel.getUnprizedNumByTime() ~= 0)
	_layMain.IMG_ALL_PEOPLE:setVisible(EveryoneWelfareModel.getNumStillCanReceive()>0)

	return _layMain
end
