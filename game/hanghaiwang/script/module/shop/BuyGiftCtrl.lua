-- FileName: BuyGiftCtrl.lua
-- Author:zhangjunwu
-- Date: 2014-05-12
-- Purpose: 购买礼包界面
--[[TODO List]]

module("BuyGiftCtrl", package.seeall)

-- UI控件引用变量 --
local m_giftData 					= nil
local m_i18nString 					=  gi18nString


-- 模块局部变量 --
require "script/module/shop/BuyGiftView"
require "script/module/shop/ShopGiftView"
require "script/module/public/ShowNotice"
require "script/module/main/PlayerPanel"
-- 初始化
local function init()
	m_giftData = nil
end
function destroy(...)
	package.loaded["BuyGiftCtrl"] = nil
end

function moduleName()
	return "BuyGiftCtrl"
end

local fnBuyVipGiftDelegate= nil

-- 购买VIP礼包
function buyVipGift( vipLevel)
	require "script/model/user/UserModel"
	if(UserModel.getVipLevel() < vipLevel) then
		ShowNotice.showShellInfo("vip等级不够，不能购买!")
		return
	end

	local function requestFunc( cbFlag, dictData, bRet )
		logger:debug(cbFlag)
		logger:debug(dictData)
		logger:debug(bRet)
		if(bRet) then

			setVipGiftPurchased(vipLevel)

			require "script/model/user/UserModel"
			--require "script/ui/shop/GiftService"
			--刷新礼包列表
			--ShopGiftView.refreshListView()
			VipGiftCtrl.refreshLay("sale")
			--刷新公共信息面板
			updateInfoBar() -- 新信息条统一更新方法

			local costGoldNUmber = -tonumber(m_giftData.newPrice)
			UserModel.addGoldNumber(costGoldNUmber)

			ShowNotice.showShellInfo(m_i18nString(1343))
			logger:debug("dddddddd")
			LayerManager:removeLayout()

			-- 获取当前商店的信息
			function shopInfoCallback( cbFlag, dictData, bRet )
				if(bRet == nil)then
					logger:debug("shopInfoCallback is nil")
					return
				end

				m_tbCurShopCacheInfo = dictData.ret

				DataCache.setShopCache(m_tbCurShopCacheInfo)
				-- menghao 购买后处理商店小红点
				MainShopView.updateTipGift()
			end
			--
			RequestCenter.shop_getShopInfo(shopInfoCallback, nil)

		end
	end
	local args = CCArray:create()
	args:addObject(CCInteger:create(vipLevel))
	Network.rpc(requestFunc, "shop.buyVipGift", "shop.buyVipGift", args, true)
end

--设置礼包已购买
function setVipGiftPurchased( vipLevel )
	require "script/model/DataCache"
	DataCache.setBuyedVipGift(vipLevel+1)
end

--
function create(giftData)
	init()
	m_giftData = giftData
	local tbEvents = {}
	--确定按钮
	tbEvents.onSure = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onSure")
			--确定事件
			AudioHelper.playCommonEffect()
			require "script/module/public/ItemUtil"
			if(ItemUtil.isPropBagFull(true) == true)then
				--ShowNotice.showShellInfo(m_i18nString(1704))
				--LayerManager:removeLayout()
				return
			end

			if(tonumber(giftData.newPrice) <= UserModel.getGoldNumber()) then

				buyVipGift(giftData.level)

			else
				--金币不足
				--ShowNotice.showShellInfo(m_i18nString(1342))
				LayerManager:removeLayout()

				local noGoldAlert = UIHelper.createNoGoldAlertDlg()
				LayerManager.addLayout(noGoldAlert)

			end

		end
	end
	--取消按钮
	tbEvents.onCancle = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onCancle")
			AudioHelper.playCloseEffect()
			LayerManager:removeLayout()
		end
	end
	--取消按钮
	tbEvents.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onBack")
			AudioHelper.playCloseEffect()
			LayerManager:removeLayout()
		end
	end
	logger:debug("dddd")
	local layMain = BuyGiftView.create( tbEvents , giftData)
	return layMain
end
