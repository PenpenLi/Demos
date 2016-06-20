-- FileName: MainShopView.lua
-- Author:zhangjunwu
-- Date: 2014-04-00
-- Purpose: j酒馆
--[[TODO List]]

module ("MainShopView", package.seeall)

--引用的json文件。
local m_jsonforShop 		= "ui/shop_menu.json"

--UI控件变量
local m_widgetRoot       	= nil

local m_btnTavern    		= nil	--招募
local m_btnGift				= nil	--礼物
local m_btnProps       		= nil	--道具
local m_btnCharge       	= nil 	--充值
local m_layList 			= nil  	--存放listView的父容器

-- menghao
local m_imgTipTavern
local m_tfdTipTavern
local m_imgTipGift
local m_tfdTipGift

local m_imgSmallBG
local m_imgBG
local m_layEasyInfo
local m_imgChain
local m_titleColor = nil
--

-- 模块局部变量 --
local m_fnGetWidget  				= g_fnGetWidgetByName
local m_i18nString 					=  gi18nString

local m_tbCurShopCacheInfo 	= nil	-- 商城的信息
-- UI控件引用变量 --
function destroy(...)
	package.loaded["MainShopView"] = nil
end

-- 初始化
local function init()
	m_widgetRoot       		= nil
	m_btnTavern    			= nil
	m_btnGift				= nil
	m_btnProps       		= nil
	m_btnCharge       		= nil

end
--模块名
function moduleName()
	return "MainShopView"
end

function setAllTabClick( ... )
	logger:debug(m_titleColor)
	-- m_btnCharge:setFocused(false)
	m_titleColor = ccc3(0xbf, 0x93, 0x67)
	m_btnCharge:setTitleColor(m_titleColor)

	m_btnGift:setFocused(false)
	m_btnGift:setTitleColor(m_titleColor)

	m_btnProps:setFocused(false)
	m_btnProps:setTitleColor(m_titleColor)

	m_btnTavern:setFocused(false)
	m_btnTavern:setTitleColor(m_titleColor)

	m_btnTavern:setTouchEnabled(true)
	m_btnGift:setTouchEnabled(true)
	m_btnProps:setTouchEnabled(true)
	m_btnCharge:setTouchEnabled(true)
end

--添加酒馆界面
function addTavernPage()
	m_layList:removeChildByTag(100,true)

	performWithDelay(m_layList,function ( ... )
			TimeUtil.timeStart("Tavern.create")
			require "script/module/shop/Tavern"
			TimeUtil.timeEnd("Tavern.create")
			local tavernWidget = Tavern.create()
			m_layList:addChild(tavernWidget,0,100)
	end , 0.01)

end
--添加道具界面
function addPropsPage()
	m_layList:removeChildByTag(100,true)
	local propsWidget = Props.create()
	m_layList:addChild(propsWidget,0,100)
end
--添加礼包界面
function addGiftPage()
	m_layList:removeChildByTag(100,true)
	local giftWidget = ShopGiftCtrl.create()
	m_layList:addChild(giftWidget,0,100)
end

-- 获取当前商店的信息
function shopInfoCallback( cbFlag, dictData, bRet )
	if(bRet == nil)then
		logger:debug("shopInfoCallback is nil")
		return
	end
	m_tbCurShopCacheInfo = dictData.ret

	DataCache.setShopCache(m_tbCurShopCacheInfo)
end
-- create
function create(tbBtnEvent,tabIndex)
	TimeUtil.timeStart("start shop ready")
	-- init()
	m_widgetRoot = g_fnLoadUI(m_jsonforShop)
	m_widgetRoot:setSize(g_winSize)
	-- return m_widgetRoot
	m_tbCurShopCacheInfo = DataCache.getShopCache()
	if(m_tbCurShopCacheInfo == nil) then
		logger:debug("m_tbCurShopCacheInfo is nil")
		RequestCenter.shop_getShopInfo(shopInfoCallback, nil)
	else
		--获取酒馆，道具，礼包 ，充值按钮添
		m_btnTavern = m_fnGetWidget(m_widgetRoot, "BTN_SHOP_TAVERN_TAB")
		m_btnProps = m_fnGetWidget(m_widgetRoot, "BTN_SHOP_ITEM_TAB")
		m_btnGift = m_fnGetWidget(m_widgetRoot, "BTN_SHOP_GIFT_TAB" )
		m_btnCharge = m_fnGetWidget(m_widgetRoot, "BTN_SHOP_RECHARGE")

		m_imgTipTavern = m_fnGetWidget(m_widgetRoot, "IMG_TIPS_TAVERN")
		m_tfdTipTavern = m_fnGetWidget(m_widgetRoot, "LABN_TIPS_TAVERN")
		m_imgTipGift = m_fnGetWidget(m_widgetRoot, "IMG_TIPS_GIFT")
		m_tfdTipGift = m_fnGetWidget(m_widgetRoot, "LABN_TIPS_GIFT")

		m_imgBG = m_fnGetWidget(m_widgetRoot, "img_bg")
		m_imgSmallBG = m_fnGetWidget(m_widgetRoot, "img_small_bg")
		m_layEasyInfo = m_fnGetWidget(m_widgetRoot, "lay_easy_info")
		m_imgChain = m_fnGetWidget(m_widgetRoot, "img_chain")

		-- UIHelper.titleShadow(m_btnTavern, m_i18nString(1401))
		-- UIHelper.titleShadow(m_btnProps, m_i18nString(1402))
		-- UIHelper.titleShadow(m_btnGift, m_i18nString(1403))
		m_titleColor =m_btnTavern:getTitleColor()
		m_btnTavern:setTitleText(m_i18nString(1401))
		m_btnProps:setTitleText(m_i18nString(1402))
		m_btnGift:setTitleText(m_i18nString(1403))
		-- m_btnCharge:setTitleText(m_i18nString(1401))

		--列表父容器
		m_layList = m_fnGetWidget(m_widgetRoot,"lay_main")

		-- 酒馆，道具，礼包 ，充值按钮添加点击回调方法
		m_btnProps:addTouchEventListener(tbBtnEvent.onProps)
		m_btnGift:addTouchEventListener(tbBtnEvent.onGifts)
		m_btnCharge:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				-- zhangqi, 2015-03-02, 弹出接渠道SDK测试用的充值面板
				-- require "script/module/shop/RechargeView"
				-- local dlg = RechargeView:new()
				-- dlg:create()
				-- ShowNotice.showShellInfo("充值暂未开放") -- 封测包临时给充值按钮添加未开启提示
				require "script/module/IAP/IAPCtrl"
				LayerManager.addLayout(IAPCtrl.create())
			end
		end)
		m_btnTavern:addTouchEventListener(tbBtnEvent.onTavern)


		TimeUtil.timeStart("shop ready")
		--默认为酒馆为初始被选中状态

		-- addPropsPage()
		if(tabIndex == 1) then
			MainShopCtrl.setTabFocused(m_btnTavern)
			addTavernPage()
		elseif(tabIndex == 2) then
			MainShopCtrl.setTabFocused(m_btnProps)
			addPropsPage()

			-- 快捷出售界面
			require("script/module/rapidSale/RapidSaleCtrl")
			RapidSaleCtrl.create()

			
		elseif(tabIndex == 3) then
			MainShopCtrl.setTabFocused(m_btnGift)
			addGiftPage()
		else
			MainShopCtrl.setTabFocused(m_btnTavern)
			addTavernPage()
		end


		m_btnGift:setEnabled(false)
		TimeUtil.timeEnd("shop ready")
		-- menghao 小红点
		updateTipTavern()
		updateTipGift()

		-- 图片适配
		m_imgBG:setScale(g_fScaleX)
		m_imgSmallBG:setScale(g_fScaleX)
		m_layEasyInfo:setScale(g_fScaleX)
		m_imgChain:setScale(g_fScaleX)
		--
	end

	TimeUtil.timeEnd("start shop ready")

	return m_widgetRoot
end


-- menghao 检查更新招募小红点状态
function updateTipTavern( ... )
	if (DataCache.getRecuitFreeNum() == 0) then
		m_imgTipTavern:setEnabled(false)
	else
		m_imgTipTavern:setEnabled(true)
		m_tfdTipTavern:setStringValue(DataCache.getRecuitFreeNum())
	end
	-- MainScene.updateShopTip()
end


function updateTipGift( ... )
	-- logger:debug(DataCache.getCanReceiveVipNUm())
	-- if (DataCache.getCanReceiveVipNUm() == 0) then
	-- 	m_imgTipGift:setEnabled(false)
	-- else
	-- 	m_imgTipGift:setEnabled(true)
	-- 	m_tfdTipGift:setStringValue(DataCache.getCanReceiveVipNUm())
	-- end
	-- MainScene.updateShopTip()
end


