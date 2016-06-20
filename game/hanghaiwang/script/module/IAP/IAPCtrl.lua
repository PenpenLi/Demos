-- FileName: IAPCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-07-07
-- Purpose: 充值界面 和 vip 预览界面控制器
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("IAPCtrl", package.seeall)
require "script/module/IAP/IAPView"
require "script/module/IAP/IAPData"
require "script/module/IAP/VipData"
local _instanceView = nil

local function init(...)
	_instanceView = nil
	GlobalNotify.addObserver("PUSHCHARGEOK", postIAPOK, nil, "PUSHCHARGEOK")
end

function destroy(...)
	GlobalNotify.removeObserver("PUSHCHARGEOK", "PUSHCHARGEOK")
	package.loaded["IAPCtrl"] = nil
end

function moduleName()
    return "IAPCtrl"
end


-- 进行充值操作 调用SDK组提供接口
local function doIAP(sender, eventType)
	if eventType == TOUCH_EVENT_ENDED then
		logger:debug("doIAP doIAP")
		AudioHelper.playBtnEffect("buttonbuy.mp3")
		local tItem = sender.tData
		if tItem.bVipCard then
			logger:debug("Platform.MONTHLY")
			if tItem.isBuy then
				ShowNotice.showShellInfo(gi18n[5728])
				return
			end
			Platform.pay(tItem.consume_grade,Platform.MONTHLY)
		else
			logger:debug("Platform.PAYMENT")
			Platform.pay(tItem.consume_grade,Platform.PAYMENT)
		end
	end
end

function postIAPOK(  )
	GlobalNotify.postNotify("CHARGEOK", _instanceView)
end

-- 点击充值 和 查看特权 按钮
local function doChangeUI (sender, eventType)
	if eventType == TOUCH_EVENT_ENDED then
		AudioHelper.playCommonEffect()
		_instanceView:changeUI()
	end
end

local function doRight(sender, eventType)
	if eventType == TOUCH_EVENT_ENDED then
		AudioHelper.playCommonEffect()
		_instanceView:changeVipUI(1)
	end
end

local function doLeft(sender, eventType)
	if eventType == TOUCH_EVENT_ENDED then
		AudioHelper.playCommonEffect()
		_instanceView:changeVipUI(-1)
	end
end

function create(showType)
	UserModel.recordUsrOperationByCondition("IAPCtrl", 1) -- 打点记录  用户操作 2016-01-05

	init()
	logger:debug("Platform.getPid() = %s", Platform.getPid())
	_instanceView = IAPView:new()
	local tbParams = {doChangeUI = doChangeUI,doRight = doRight, doLeft = doLeft, doIAP = doIAP,showType = showType,}
	local layView = _instanceView:create(tbParams)
	UIHelper.registExitAndEnterCall(layView, function (  )
		_instanceView:release()
		_instanceView = nil
		GlobalNotify.removeObserver("CHARGEOK", "CHARGEOK")
	end, function (  )
		GlobalNotify.addObserver("CHARGEOK", _instanceView.refreshUI, nil, "CHARGEOK")
	end)

	return layView
end
