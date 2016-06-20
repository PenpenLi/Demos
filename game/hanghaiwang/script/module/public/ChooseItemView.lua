-- FileName: ChooseItemView.lua
-- Author: yucong
-- Date: 2015-12-26
-- Purpose: 奖励选额列表
--[[TODO List]]

ChooseItemView = class("ChooseItemView")

require "script/module/public/GlobalNotify"

-- 模块局部变量 --
local m_i18n	= gi18n
local m_fnGetWidget = g_fnGetWidgetByName
local ChooseItemCtrl = ChooseItemCtrl

ChooseItemView._mainLayer	= nil
ChooseItemView._sGoods		= nil
ChooseItemView._type		= nil
--ChooseItemView._selectIndex	= -1

function ChooseItemView:notifications( ... )
	return {
		--[ChooseItemCtrl.MSG_BTN_PRESS]	= function (...) self:fnMSG_BTN_PRESS(...) end,
	}
end

function ChooseItemView:fnUpdate( ... )
	
end

function ChooseItemView:ctor()

end

function ChooseItemView:create( goodsStr, kType )
	self._mainLayer = g_fnLoadUI("ui/item_choose.json")
	self._sGoods = goodsStr
	self._type = kType

	-- 注册onExit()
	UIHelper.registExitAndEnterCall(self._mainLayer, function ( ... )
		for msg, func in pairs(self:notifications()) do
			GlobalNotify.removeObserver(msg, "ChooseItemView")
		end
		--GlobalScheduler.removeCallback("ChooseItemView")
		ChooseItemCtrl.destroy()
    end, function ( ... )
    	-- 开启计时器
		-- GlobalScheduler.addCallback("ChooseItemView", function ( ... )
		-- 	self:fnUpdate()
		-- end)
		self:addObserver()
    end)
    self:createFrame()

    self:reload_lsv()

	return self._mainLayer
end

function ChooseItemView:addObserver( ... )
	for msg, func in pairs(self:notifications()) do
		GlobalNotify.addObserver(msg, func, false, "ChooseItemView")
	end
end

function ChooseItemView:createFrame( ... )
	self._mainLayer.tfd_choose:setText(ChooseItemCtrl.TB_DES[self._type].DES_TITLE2)
	self._mainLayer.BTN_GET:setTitleText(ChooseItemCtrl.TB_DES[self._type].DES_BTN)
	self._mainLayer.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	self._mainLayer.BTN_GET:addTouchEventListener(ChooseItemCtrl.onBtnPress)

	self:initLsv()
end

function ChooseItemView:initLsv( ... )
	local lsv = self._mainLayer.LSV_MAIN
	UIHelper.initListView(lsv)
	lsv:addEventListenerScrollView(ChooseItemCtrl.onListView)
	lsv:setBounceEnabled(true)
	lsv:setClippingEnabled(true)
end

function ChooseItemView:reload_lsv( ... )
	self._mainLayer.LSV_MAIN:removeAllItems()
	local rewards = RewardUtil.parseRewards(self._sGoods)
	for k, reward in pairs(rewards) do
		self._mainLayer.LSV_MAIN:pushBackDefaultItem()
		local cell = self._mainLayer.LSV_MAIN:getItem(k - 1)
		local szIcon = reward.icon:getSize()
		reward.icon:setPosition(ccp(szIcon.width/2, szIcon.height/2))
		cell.LAY_PHOTO:addChild(reward.icon)
		cell.tfd_name:setText(reward.name)
		cell.tfd_name:setColor(g_QulityColor[reward.quality])
		cell.CBX_CHOOSE:addEventListenerCheckBox(ChooseItemCtrl.onCellPress)
		cell.CBX_CHOOSE:setSelectedState(false)
		--cell.CBX_CHOOSE:setTouchEnabled(true)
		cell.CBX_CHOOSE:setTag(k - 1)
	end

	UIHelper.setSliding(self._mainLayer.LSV_MAIN)
end
