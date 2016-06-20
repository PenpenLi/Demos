-- FileName: ShopGiftView.lua
-- Author:zhangjunwu
-- Date: 2014-04-00
-- Purpose: 礼包列表界面
--[[TODO List]]

module("ShopGiftView", package.seeall)
require "script/module/shop/ShopGiftData"
require "script/module/public/ItemButton"

-- UI控件引用变量 --
-- 模块局部变量 --
local m_fnGetWidget     			= g_fnGetWidgetByName
local m_i18nString 					=  gi18nString

local m_LSV_View = nil              --礼包List的panel

local  m_giftsPackageInfo 			= nil
local m_jsonforGift 				= "ui/shop_vip_gift.json"
--local m_jsonforGift = "bag_item_test.json"

local m_itemFromLSV = nil
local layCellItem
-- 模块局部变量 --
local m_tbEvent = {}
local function init(...)

end

function destroy(...)
	package.loaded["ShopGiftView"] = nil
end

function moduleName()
	return "ShopGiftView"
end
function loadCell( cell,_tbData,tag)
	-- logger:debug(_tbData)

	local tfd_shop_vip_gift_title_vip_desc  = m_fnGetWidget(cell,"tfd_shop_vip_gift_title_vip_desc")
	tfd_shop_vip_gift_title_vip_desc:setText(m_i18nString(1461))
	-- UIHelper.labelNewStroke(tfd_shop_vip_gift_title_vip_desc)

	local tfd_shop_item_price_now  = m_fnGetWidget(cell,"tfd_shop_item_price_now")
	tfd_shop_item_price_now:setText(m_i18nString(1471))

	local TFD_VIP_BUY  = m_fnGetWidget(cell,"TFD_VIP_BUY")
	TFD_VIP_BUY:setText(m_i18nString(1472,_tbData.level))

	local LAY_VIPLEVEL = m_fnGetWidget(cell,"TFD_SHOP_VIP_GIFT_TITLE_VIP") 	-- vip等级
	--LAY_VIPLEVEL:setStringValue(_tbData.level)
	LAY_VIPLEVEL:setText(_tbData.level)
	-- UIHelper.labelNewStroke(LAY_VIPLEVEL)

	local i18nTFD_OLDPRICE = m_fnGetWidget(cell ,"tfd_shop_item_price_ago")
	--i18nTFD_OLDPRICE:setText(m_i18nString())

	local TFD_OLDPRICE = m_fnGetWidget(cell ,"TFD_SHOP_VIP_GIFT_AGO_PRICE") 	--旧价格
	TFD_OLDPRICE:setText(_tbData.oldPrice)

	local TFD_NEWPRICE = m_fnGetWidget(cell ,"TFD_SHOP_VIP_GIFT_NOW_PRICE")		--新价格
	TFD_NEWPRICE:setText(tostring(_tbData.newPrice))

	local TFD_DES = m_fnGetWidget(cell ,"TFD_SHOP_VIP_GIFT_INTRODUCTION")		--描述
	TFD_DES:setText(_tbData.desc)


	local vipBtn ,iteminfo = ItemUtil.createBtnByTemplateId(_tbData.id,m_tbEvent.onBtnIcon)					--icon
	vipBtn:setTag(_tbData.id)
	local LAY_BTNBG = m_fnGetWidget(cell,"BTN_SHOP_VIP_GIFT_ICON_BG")
	LAY_BTNBG:addChild(vipBtn)
	--vipBtn:addTouchEventListener(m_tbEvent.onBtnIcon)

	local i18n_BTN_BUY_VIP = m_fnGetWidget(cell,"BTN_SHOP_ITEM_BUY")			--购买按钮
	-- i18n_BTN_BUY_VIP:setTitleText(m_i18nString(1435))
	UIHelper.titleShadow(i18n_BTN_BUY_VIP,m_i18nString(1435))
	i18n_BTN_BUY_VIP:setTag(_tbData.id)
	i18n_BTN_BUY_VIP:addTouchEventListener(m_tbEvent.onBtnBuy)

	local bBougt = ShopGiftData.getVipGiftPurchased(_tbData.level)				--是否已经被购买
	if(bBougt == true) then
		i18n_BTN_BUY_VIP:setBright(false)
		i18n_BTN_BUY_VIP:setTouchEnabled(false)
		--i18n_BTN_BUY_VIP:setTitleText(m_i18nString(1452))
		UIHelper.titleShadow(i18n_BTN_BUY_VIP,m_i18nString(1452))
	else

		if(UserModel.getVipLevel() >= _tbData.level) then
			--按钮特效
			local tbParams = {
				filePath = "images/effect/button_small/button_small.ExportJson",
				animationName = "button_small",
			}

			i18n_BTN_BUY_VIP:removeNodeByTag(100)
			local effectNode = UIHelper.createArmatureNode(tbParams)
			i18n_BTN_BUY_VIP:addNode(effectNode,12222222,100)
		end

	end
end




-- 更新每个cell
function updateCellByIdex( lsv, idx)
	local _tbData = m_giftsPackageInfo[idx+1]
	local cell = lsv:getItem(idx)


	local tfd_shop_vip_gift_title_vip_desc  = m_fnGetWidget(cell,"tfd_shop_vip_gift_title_vip_desc")
	tfd_shop_vip_gift_title_vip_desc:setText(m_i18nString(1461))
	-- UIHelper.labelNewStroke(tfd_shop_vip_gift_title_vip_desc)

	local tfd_shop_item_price_now  = m_fnGetWidget(cell,"tfd_shop_item_price_now")
	tfd_shop_item_price_now:setText(m_i18nString(1471))

	local TFD_VIP_BUY  = m_fnGetWidget(cell,"TFD_VIP_BUY")
	TFD_VIP_BUY:setText(m_i18nString(1472,_tbData.level))

	local LAY_VIPLEVEL = m_fnGetWidget(cell,"TFD_SHOP_VIP_GIFT_TITLE_VIP") 	-- vip等级
	--LAY_VIPLEVEL:setStringValue(_tbData.level)
	LAY_VIPLEVEL:setText(_tbData.level)
	-- UIHelper.labelNewStroke(LAY_VIPLEVEL)

	local i18nTFD_OLDPRICE = m_fnGetWidget(cell ,"tfd_shop_item_price_ago")
	--i18nTFD_OLDPRICE:setText(m_i18nString())

	local TFD_OLDPRICE = m_fnGetWidget(cell ,"TFD_SHOP_VIP_GIFT_AGO_PRICE") 	--旧价格
	TFD_OLDPRICE:setText(_tbData.oldPrice)

	local TFD_NEWPRICE = m_fnGetWidget(cell ,"TFD_SHOP_VIP_GIFT_NOW_PRICE")		--新价格
	TFD_NEWPRICE:setText(tostring(_tbData.newPrice))

	local TFD_DES = m_fnGetWidget(cell ,"TFD_SHOP_VIP_GIFT_INTRODUCTION")		--描述
	TFD_DES:setText(_tbData.desc)


	local vipBtn ,iteminfo = ItemUtil.createBtnByTemplateId(_tbData.id,m_tbEvent.onBtnIcon)					--icon
	vipBtn:setTag(_tbData.id)
	local LAY_BTNBG = m_fnGetWidget(cell,"BTN_SHOP_VIP_GIFT_ICON_BG")
	LAY_BTNBG:removeAllChildrenWithCleanup(true)
	LAY_BTNBG:addChild(vipBtn)
	--vipBtn:addTouchEventListener(m_tbEvent.onBtnIcon)

	local i18n_BTN_BUY_VIP = m_fnGetWidget(cell,"BTN_SHOP_ITEM_BUY")			--购买按钮
	-- i18n_BTN_BUY_VIP:setTitleText(m_i18nString(1435))
	UIHelper.titleShadow(i18n_BTN_BUY_VIP,m_i18nString(1435))
	i18n_BTN_BUY_VIP:setTag(_tbData.id)
	i18n_BTN_BUY_VIP:addTouchEventListener(m_tbEvent.onBtnBuy)

	local bBougt = ShopGiftData.getVipGiftPurchased(_tbData.level)				--是否已经被购买
	i18n_BTN_BUY_VIP:setBright(true)
	i18n_BTN_BUY_VIP:setTouchEnabled(true)
	i18n_BTN_BUY_VIP:removeNodeByTag(100)
	if(bBougt == true) then
		i18n_BTN_BUY_VIP:setBright(false)
		i18n_BTN_BUY_VIP:setTouchEnabled(false)
		--i18n_BTN_BUY_VIP:setTitleText(m_i18nString(1452))
		UIHelper.titleShadow(i18n_BTN_BUY_VIP,m_i18nString(1452))
	else
		if(UserModel.getVipLevel() >= _tbData.level) then
			--按钮特效
			local tbParams = {
				filePath = "images/effect/button_small/button_small.ExportJson",
				animationName = "button_small",
			}

			i18n_BTN_BUY_VIP:removeNodeByTag(100)
			local effectNode = UIHelper.createArmatureNode(tbParams)
			i18n_BTN_BUY_VIP:addNode(effectNode,12222222,100)
		end

	end

end


function refreshListView( ... )
	m_giftsPackageInfo  = ShopGiftData.getGiftsPackageInfo()

	-- UIHelper.initListViewCell(m_LSV_View)
	UIHelper.reloadListView(m_LSV_View,#m_giftsPackageInfo,updateCellByIdex)
end

function create(tbBtnEvent,tbGiftData)

	m_tbEvent = tbBtnEvent

	m_giftsMainLay= g_fnLoadUI(m_jsonforGift)
	m_giftsMainLay:setSize(g_winSize)

	m_LSV_View = m_fnGetWidget(m_giftsMainLay,"LSV_SHOP_VIP_GIFT") --listview
	-- m_LSV_View:setSize(CCSizeMake(m_LSV_View:getSize().width*g_fScaleX,m_LSV_View:getSize().height*g_fScaleX))
	m_giftsPackageInfo = tbGiftData
	logger:debug(m_giftsPackageInfo)

	require "script/module/public/UIHelper"

	local lay_shop_vip_gift_bg = m_fnGetWidget(m_LSV_View,"lay_shop_vip_gift_bg")

	lay_shop_vip_gift_bg:setSize(CCSizeMake(lay_shop_vip_gift_bg:getSize().width*g_fScaleX,lay_shop_vip_gift_bg:getSize().height*g_fScaleX))
	local bg = m_fnGetWidget(lay_shop_vip_gift_bg,"img_shop_vip_gift_top_bg")
	bg:setScale(g_fScaleX)


	UIHelper.initListViewCell(m_LSV_View)
	UIHelper.reloadListView(m_LSV_View,#tbGiftData,updateCellByIdex,nil,true)

	-- UIHelper.initListView(m_LSV_View)
	-- refreshListView()

	return m_giftsMainLay
end
