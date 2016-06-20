-- FileName: FirstGiftCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-08-06
-- Purpose: 首充活动控制器
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("FirstGiftCtrl", package.seeall)
require "script/module/wonderfulActivity/firstGift/FirstGift"
require "script/module/wonderfulActivity/firstGift/FirstGiftData"
-- UI控件引用变量 --
local _instanceView = nil
-- 模块局部变量 --

local function init(...)
	_instanceView = nil
end

function destroy(...)
	package.loaded["FirstGiftCtrl"] = nil
end

function moduleName()
    return "FirstGiftCtrl"
end

local function goIAP( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		require "script/module/IAP/IAPCtrl"
		LayerManager.addLayout(IAPCtrl.create())
	end
end

function postIAPOK(  )
	GlobalNotify.postNotify("FIRSTCHARGEOK", _instanceView)
end

function create(...)
	init()
	_instanceView = FirstGift.new()
	local view = _instanceView:create({goIAP = goIAP})
	UIHelper.registExitAndEnterCall(view, function (  )
		_instanceView = nil
		GlobalNotify.removeObserver("PUSHCHARGEOK", "PUSHCHARGEOK")
		GlobalNotify.removeObserver("FIRSTCHARGEOK", "FIRSTCHARGEOK")
	end, function (  )
		GlobalNotify.addObserver("PUSHCHARGEOK",postIAPOK, nil, "PUSHCHARGEOK")
		GlobalNotify.addObserver("FIRSTCHARGEOK", _instanceView.updateUI, nil, "FIRSTCHARGEOK")
	end)

	MainWonderfulActCtrl.addLayChild(view)
end
