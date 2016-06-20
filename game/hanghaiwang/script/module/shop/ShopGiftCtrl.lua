-- FileName: ShopGiftCtrl.lua
-- Author:zhangjunwu
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("ShopGiftCtrl", package.seeall)
require "script/module/shop/ShopGiftView"
require "script/module/shop/BuyGiftCtrl"
require "script/module/shop/GiftItemCtrl"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_tbGiftData = nil
local function init(...)

end

function destroy(...)
	package.loaded["ShopGiftCtrl"] = nil
end

function moduleName()
	return "ShopGiftCtrl"
end

function getGiftDataById( id )
	for i, v in ipairs(m_tbGiftData or {}) do
		logger:debug(v)
		if(tostring(id) == v.id) then
			return v
		end
	end
	return nil
end

function create(...)
	local tbBtnEvent = {}
	--购买按钮
	tbBtnEvent.onBtnBuy = function ( sender, eventType  )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onBtnBuy clicked")
			AudioHelper.playCommonEffect()
			local vipId = sender:getTag()			--礼包id
			local giftData = getGiftDataById(vipId)	--礼包数据
			logger:debug(giftData)
			LayerManager.addLayout(BuyGiftCtrl.create(giftData))
		end
	end
	--礼包btn
	tbBtnEvent.onBtnIcon = function ( sender, eventType  )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onBtnIcon clicked")
			AudioHelper.playCommonEffect()
			local vipId = sender:getTag()				--礼包id
			local giftData = getGiftDataById(vipId)		--礼包数据
			local giftRewardData = ShopGiftData.getGiftRewardInfo(vipId)	--礼包奖励数据
			local vipLevel = giftData.level
			logger:debug(giftData)
			LayerManager.addLayout(GiftItemCtrl.create(giftRewardData,vipLevel))
		end
	end
	m_tbGiftData  = ShopGiftData.getGiftsPackageInfo()

	local layMain = ShopGiftView.create( tbBtnEvent, m_tbGiftData)
	return layMain
end
