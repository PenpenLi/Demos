-- FileName: Props.lua
-- Author: zjw
-- Date: 2014-04-24
-- Purpose: 商店tab下的道具界面
--[[TODO List]]

module("Props", package.seeall)
require "script/module/shop/ShopUtil"



-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget                 = g_fnGetWidgetByName
local m_i18nString 					= gi18nString
local m_jsonforProps                = "ui/shop_item.json"
local m_tbAllGoods                  = {}                            --道具列表数据
local m_nPropsCount                 = 0                             --道具个数
local m_lsvProps                    = nil                           --道具List的panel
local good_id                       = nil

local function init(...)
	m_tbAllGoods = {}
	good_id = nil
end

function destroy(...)
	package.loaded["Props"]          = nil
end

function moduleName()
	return "Props"
end
--创建购买界面
local function createBuyProps( ... )
	require "script/module/shop/BuyPropsCtrl"
	local tbGoodsData = DB_Goods.getDataById(tonumber(good_id))
	LayerManager.addLayout(BuyPropsCtrl.createForProps(tbGoodsData))
end
--购买按钮的回调函数
local function onBtnBuyProp( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- 音效
		good_id = sender:getTag()
		-- AudioHelper.playBtnEffect("buttonbuy.mp3")
		AudioHelper.playCommonEffect()
		require "db/DB_Goods"
		local goodsData = DB_Goods.getDataById(tonumber(good_id))

		if(goodsData.vip_needed and tonumber(goodsData.vip_needed)>tonumber(UserModel.getVipLevel())) then
			ShowNotice.showShellInfo( m_i18nString(1434) .. m_i18nString(1472,goodsData.vip_needed)) --"VIP等级不够"
			return
		end
		if(goodsData.user_lv_needed and  tonumber(goodsData.user_lv_needed)> tonumber( UserModel.getHeroLevel())) then
			ShowNotice.showShellInfo(m_i18nString(5476,goodsData.user_lv_needed))

			return
		end

		-- 是否限购
		if(ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), goodsData.id) > 0) then
			local maxLimitNum = - ShopUtil.getBuyNumBy(goodsData.id) + ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), goodsData.id)
			if(maxLimitNum<=0)then
				ShowNotice.showShellInfo(m_i18nString(4313)) --[4313] = "今日购买次数已用完，请明天再来购买吧",
				return
			end
		end
		--创建购买界面
		createBuyProps()
	end
end
--刷新道具列表
function refreshPropsListView( ... )
	m_tbAllGoods = ShopUtil.getAllShopInfo()

	--筛选道具表里的id 通过是否显示
	local tbShowGoods = {}

	for i,v in ipairs(m_tbAllGoods) do
		local goods_data = m_tbAllGoods[i]
		if(goods_data.is_show == 1)then
			table.insert(tbShowGoods,goods_data)
		end
	end

	m_nPropsCount =  table.maxn(tbShowGoods)

	m_lsvProps = nil
	m_lsvProps = m_fnGetWidget(m_propsMainLay, "LSV_SHOP_ITEM")

	local lay_shop_item_bg = m_fnGetWidget(m_lsvProps,"lay_shop_item_bg")

	-- lay_shop_item_bg:setSize(CCSizeMake(lay_shop_item_bg:getSize().width*g_fScaleX,lay_shop_item_bg:getSize().height*g_fScaleX))
	local bg = m_fnGetWidget(lay_shop_item_bg,"img_shop_item_top_bg")
	bg:setScale(g_fScaleX)

	local itemDef = m_lsvProps:getItem(0) -- 获取编辑器中的默认cell
	m_lsvProps:setItemModel(itemDef) -- 设置默认的cell
	m_lsvProps:removeAllItems() -- 初始化清空列表


	for k=1, m_nPropsCount do
		m_lsvProps:pushBackDefaultItem()
	end
	for i = 1, m_nPropsCount do
		local item = m_lsvProps:getItem(i-1)
		local goods_data = tbShowGoods[i]

		if(goods_data.is_show == 1) then

			--道具描述
			local tefIntroduction = m_fnGetWidget(item,"TFD_SHOP_ITEM_INTRODUCTION")
			tefIntroduction:setText(goods_data.desc)
			--tefIntroduction:setColor(ccc3(123,156,324))

			-- img_tip
			local img_tip = m_fnGetWidget(item,"img_tip")
			if(goods_data.recommended == 1)then
				img_tip:setEnabled(true)
			else
				img_tip:setEnabled(false)
			end
			--道具购买按钮
			local btnBuy = m_fnGetWidget(item,"BTN_SHOP_ITEM_BUY")
			btnBuy:addTouchEventListener(onBtnBuyProp)
			btnBuy:setTag(tonumber(goods_data.id))
			UIHelper.titleShadow(btnBuy,m_i18nString(1435))
			--logger:debug(goods_data.id)
			--x限购次数
			local labLimit = m_fnGetWidget(item,"TFD_SHOP_ITEM_OWN_NUM")
			local gi18nLabBuyInfo = m_fnGetWidget(item,"tfd_today_buy")
			local gi18nLabBuyUnit = m_fnGetWidget(item,"tfd_unit")

			gi18nLabBuyInfo:setText(m_i18nString(1419))
			gi18nLabBuyUnit:setText(m_i18nString(1420))
			labLimit:setText("")
			if(ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), goods_data.id) > 0) then
				local maxLimitNum = - ShopUtil.getBuyNumBy(goods_data.id) + ShopUtil.getAddBuyTimeBy(UserModel.getVipLevel(), goods_data.id)
				maxLimitNum =maxLimitNum>0 and maxLimitNum or 0
				labLimit:setText(maxLimitNum)
				-- labLimit:setColor(ccc3(0x00, 0x00, 0x00))
			else
				labLimit:setEnabled(false)
				gi18nLabBuyInfo:setEnabled(false)
				gi18nLabBuyUnit:setEnabled(false)
			end

			--道具icon
			local itemIconBg= m_fnGetWidget(item,"IMG_SHOP_ITEM_ICON_BG")
			itemIconBg:removeAllChildrenWithCleanup(true)
			--道具名称
			local iconSprite = nil
			local propsName = ""
			local labPropsName = m_fnGetWidget(item,"TFD_SHOP_ITEM_NAME")
			local curPrice = ShopUtil.getNeedGoldByGoodsAndTimes( goods_data.id, ShopUtil.getBuyNumBy(goods_data.id)+1)

			if(goods_data.item_id ~= nil )then

				local itemDesc = ItemUtil.getItemById(goods_data.item_id)
				propsName = itemDesc.name
				logger:debug(goods_data.item_id)
				iconSprite  = ItemUtil.createBtnByTemplateId(goods_data.item_id)

			elseif( goods_data.hero_id ~= nil )then
				logger:debug("prop name = %s", propsName)
				local heroDesc = HeroUtil.getHeroLocalInfoByHtid(goods_data.hero_id)
				-- 武将名称
				propsName = heroDesc.name
				iconSprite = HeroUtil.getHeroIconByHTID(goods_data.hero_id)

			end
			labPropsName:setText(propsName)
			-- UIHelper.labelEffect(labPropsName,propsName)
			-- UIHelper.labelNewStroke(labPropsName) ecd690
			-- UIHelper.labelNewStroke(labPropsName )
			-- UIHelper.labelNewStroke(labPropsName, ccc3(0xec, 0xd6, 0x90),2)
			if(iconSprite ~= nil)then
				itemIconBg:addChild(iconSprite)
			end

			--购买价格
			local labPrice = m_fnGetWidget(item,"TFD_SHOP_ITEM_PRICE_NUM")
			labPrice:setText("" .. curPrice)

		end

	end
end
--[[desc:zhangjunwu 创建一个招财符的图片

    return: imgview  
—]]
function getZhaoCaiImage()
	local ZhaoCaiImage= ImageView:create()
	ZhaoCaiImage:loadTexture("images/base/props/money.png")
	return ZhaoCaiImage
end
--[[desc:商店tab下的道具界面
    arg1: 参数说明
    return: 返回一个weiget cocostudo创建的一个node
—]]
function create()
	logger:debug("Props.create()")
	m_propsMainLay= g_fnLoadUI(m_jsonforProps)
	m_propsMainLay:setSize(g_winSize)

	local lay_shop_item_bg = m_fnGetWidget(m_propsMainLay,"lay_shop_item_bg")

	lay_shop_item_bg:setSize(CCSizeMake(lay_shop_item_bg:getSize().width*g_fScaleX,lay_shop_item_bg:getSize().height*g_fScaleX))

	refreshPropsListView()
	return m_propsMainLay
end
