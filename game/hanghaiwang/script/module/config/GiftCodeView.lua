-- FileName: GiftCodeView.lua
-- Author: Xufei
-- Date: 2015-07-30
-- Purpose: 礼包码 视图
--[[TODO List]]

--module("GiftCodeView", package.seeall)
GiftCodeView = class("GiftCodeView")

-- UI控件引用变量 --
local _layMain
-- 模块局部变量 --
local _i18n = gi18n

function GiftCodeView:destroy()
	package.loaded["GiftCodeView"] = nil
end

function GiftCodeView:moduleName()
    return "GiftCodeView"
end

function GiftCodeView:setUIStyleAndI18n(layBase)
	layBase.TFD_INFO:setText(_i18n[6301]) --请输入您的礼包兑换码

	UIHelper.titleShadow(layBase.BTN_CHANGE, _i18n[2203]) --兑换
end

function GiftCodeView:ctor()
	_layMain = g_fnLoadUI("ui/config_gift.json")
end

function GiftCodeView:create()
	self:setUIStyleAndI18n(_layMain)


	local imgBg = _layMain.img_type
	local bgSize = imgBg:getSize()
	local tbArgs = {size = CCSizeMake(bgSize.width, bgSize.height), maxLen = 30,
		FontName = g_sFontName,  FontSize = 22,FontColor = ccc3(0x57, 0x1e, 0x01)
	}	
	local giftCodeInput = UIHelper.createEditBoxNew(tbArgs) -- 输入框
	giftCodeInput:setInputFlag(kEditBoxInputFlagSensitive)
	imgBg:addNode(giftCodeInput)


	_layMain.BTN_CHANGE:addTouchEventListener(GiftCodeCtrl.getChangeBtnEvent(giftCodeInput))

	_layMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	LayerManager.addLayout(_layMain)

	local popLayer = LayerManager.getCurrentPopLayer()
	local tp = popLayer:getTouchPriority()
	giftCodeInput:setTouchPriority(tp - 1)
end
