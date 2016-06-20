-- FileName: ImpelShopTipView.lua
-- Author: LvNanchun
-- Date: 2015-09-17
-- Purpose: function description of module
--[[TODO List]]

ImpelShopTipView = class("ImpelShopTipView")
require "script/module/impelDown/ImpelShop/ImpelShopModel"

-- UI variable --
local _layMain

-- module local variable --
local _i18n = gi18n

function ImpelShopTipView:moduleName()
    return "ImpelShopTipView"
end

function ImpelShopTipView:ctor(...)
	_layMain = g_fnLoadUI("ui/shop_buy_item.json")
end

function ImpelShopTipView:create( tipData )
	local nBuy = 1
	_layMain.BTN_SHOP_BUY_ITEM_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)
	_layMain.TFD_PLAYER_OWN_NUM:setText(_i18n[1421] .. tostring(tipData.ownNum) .. _i18n[1422])
	_layMain.lay_txt_bg.tfd_please_choose:setText(_i18n[1423])
	_layMain.lay_txt_bg.TFD_PLAYER_CHOOSE_BUY_NUM:setText(tostring(tipData.itemName))
	_layMain.lay_txt_bg.TFD_PLAYER_CHOOSE_BUY_NUM:setColor(tipData.color)
	_layMain.lay_txt_bg.tfd_choose_num:setText(_i18n[1424])

	_layMain.TFD_PLAYER_BUY_NUM:setText(tostring(nBuy))

	local itemPrice = tonumber(tipData.itemPirce)

	_layMain.BTN_PLAYER_BUY_ADDITION_TEN:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (nBuy - 10 < 1) then
				nBuy = 1
			else
				nBuy = nBuy - 10
			end
			_layMain.TFD_PLAYER_BUY_NUM:setText(tostring(nBuy))
			_layMain.lay_price.TFD_PRICE_NUM:setText(tostring(itemPrice * nBuy))
		end
	end)
	_layMain.BTN_PLAYER_BUY_ADDITION:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (nBuy - 1 < 1) then
				nBuy = 1
			else
				nBuy = nBuy - 1
			end
			_layMain.TFD_PLAYER_BUY_NUM:setText(tostring(nBuy))
			_layMain.lay_price.TFD_PRICE_NUM:setText(tostring(itemPrice * nBuy))
		end
	end)
	require "script/module/public/ShowNotice"
	_layMain.BTN_PLAYER_BUY_REDUCE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (nBuy + 1 > tonumber(tipData.maxNum)) then
				if (tipData.limitType == "num" and nBuy == tonumber(tipData.maxNum)) then
					ShowNotice.showShellInfo(_i18n[7005])
				elseif (tipData.limitType == "gold" and nBuy == tonumber(tipData.maxNum)) then
					ShowNotice.showShellInfo(_i18n[7039])
				end
				nBuy = tonumber(tipData.maxNum)
			else
				nBuy = nBuy + 1
			end
			_layMain.TFD_PLAYER_BUY_NUM:setText(tostring(nBuy))
			_layMain.lay_price.TFD_PRICE_NUM:setText(tostring(itemPrice * nBuy))
		end
	end)
	_layMain.BTN_PLAYER_BUY_REDUCE_TEN:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (nBuy + 10 > tonumber(tipData.maxNum)) then
				if (tipData.limitType == "num" and nBuy == tonumber(tipData.maxNum)) then
					ShowNotice.showShellInfo(_i18n[7005])
				elseif (tipData.limitType == "gold" and nBuy == tonumber(tipData.maxNum)) then
					ShowNotice.showShellInfo(_i18n[7039])
				end
				nBuy = tonumber(tipData.maxNum)
			else
				nBuy = nBuy + 10
			end
			_layMain.TFD_PLAYER_BUY_NUM:setText(tostring(nBuy))
			_layMain.lay_price.TFD_PRICE_NUM:setText(tostring(itemPrice * nBuy))
		end
	end)

	_layMain.lay_price_num:setVisible(false)
	_layMain.lay_max:setVisible(false)

	_layMain.lay_price.tfd_item_price:setText(_i18n[7006])
	_layMain.lay_price.img_price_prestige:setVisible(false)
	_layMain.lay_price.img_price_gold:loadTexture("ui/impel_down_coin.png")
	_layMain.lay_price.TFD_PRICE_NUM:setText(tostring(tipData.itemPirce))


	UIHelper.titleShadow(_layMain.BTN_SHOP_ITEM_BUY_SURE, _i18n[1992])
	UIHelper.titleShadow(_layMain.BTN_SHOP_ITEM_BUY_CANCEL, _i18n[1993])

	_layMain.BTN_SHOP_ITEM_BUY_SURE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("buttonbuy.mp3")
			tipData.sureCallBack(nBuy)
		end
	end)

	_layMain.BTN_SHOP_ITEM_BUY_CANCEL:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)

	return _layMain
end

