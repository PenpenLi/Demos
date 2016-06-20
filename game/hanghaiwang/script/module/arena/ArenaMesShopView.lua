-- FileName: ArenaMesShopView.lua
-- Author: huxiaozhou
-- Date: 2014-04-00
-- Purpose: function description of module


module("ArenaMesShopView", package.seeall)

local arena_shop_json = "ui/arena_shop.json"
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString

local m_mainWidget
local m_LSV_MAIN
local m_tbBtnEvent
local _allGoods
local function init(...)
	m_LSV_MAIN = nil
end


function destroy(...)
	package.loaded["ArenaMesShopView"] = nil
end

function moduleName()
    return "ArenaMesShopView"
end

function loaded( _layModule , tbItemData,key)
	logger:debug(tbItemData)
	--一堆控件
	local LAY_GOODS = m_fnGetWidget(_layModule, "LAY_GOODS") -- img 位置
	local TFD_NAME = m_fnGetWidget(_layModule, "TFD_NAME")   -- 物品名字
	local TFD_BUYTIMES1 = m_fnGetWidget(_layModule, "TFD_BUYTIMES1") -- 物品说明1
	local TFD_BUYTIMES2 = m_fnGetWidget(_layModule, "TFD_BUYTIMES2") -- 物品说明2
	local TFD_DESC =  m_fnGetWidget(_layModule, "TFD_DESC") -- 物品介绍
	local TFD_NEEDLV = m_fnGetWidget(_layModule, "TFD_NEEDLV") -- 需要的等级
	local BTN_EXCHANGE = m_fnGetWidget(_layModule, "BTN_EXCHANGE") -- 兑换按钮
	-- local tfd_pricename = m_fnGetWidget(_layModule, "tfd_pricename")
	local img_cellbg = m_fnGetWidget(_layModule, "img_cellbg")
	img_cellbg:setScale(g_fScaleX)
	UIHelper.titleShadow(BTN_EXCHANGE,m_i18n[2203])
	BTN_EXCHANGE:addTouchEventListener(m_tbBtnEvent.onExChange)
	BTN_EXCHANGE:setTag(key)
	-- BTN_EXCHANGE:setTitleText(m_i18nString(2203))
	-- 兑换物品id
	local itemType, item_id, item_num = ArenaData.getItemData( tbItemData.items )
 	-- 表中物品数据,物品图标
	local item_data = nil
	local iconbtn = nil
	local num_data = item_num or 1
	
	if(tonumber(itemType) == 2)then
		require "script/model/utils/HeroUtil"
		iconbtn,item_data = HeroUtil.createHeroIconBtnByHtid(item_id , nil,
			function ( sender,eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playInfoEffect()

					PublicInfoCtrl.createHeroInfoView(sender:getTag())
				end
			end, num_data)
	else
		require "script/module/public/ItemUtil"
		iconbtn,item_data = ItemUtil.createBtnByTemplateIdAndNumber(item_id , num_data, function ( sender,eventType )
																							if (eventType == TOUCH_EVENT_ENDED) then
																								AudioHelper.playInfoEffect()
																								PublicInfoCtrl.createItemInfoViewByTid(item_id,num_data)   -- 最后一个参数 设置为true 表示 进阶石，突破石 要显示成掉落
																							end
																						end)
	end

    iconbtn:setPosition(ccp(LAY_GOODS:getContentSize().width*.5,LAY_GOODS:getContentSize().height*.5))
    LAY_GOODS:addChild(iconbtn)

   
   
    
    TFD_DESC:setText(item_data.desc or "")
    TFD_NAME:setText(item_data.name)
    
	local color =  g_QulityColor[tonumber(item_data.quality)]
	if(color ~= nil) then
		TFD_NAME:setColor(color)
	end
	UIHelper.labelAddStroke(TFD_NAME,item_data.name)

	-- 限购
	-- local maxLimitNum =  tonumber(tbItemData.baseNum) - ArenaData.getBuyNumBy(tbItemData.id)
	-- if (maxLimitNum<0) then
	-- 	maxLimitNum = 0
	-- end
	local str = nil
	if( tonumber(tbItemData.limitType) == 1)then
		TFD_BUYTIMES2:setEnabled(false)
		str = m_i18nString(2213,tbItemData.canBuyNum)
		TFD_BUYTIMES1:setText(str)
	else
		str = m_i18nString(2212,tbItemData.canBuyNum)
		TFD_BUYTIMES1:setEnabled(false)
		TFD_BUYTIMES2:setText(str)
	end

	if tonumber(tbItemData.canBuyNum) == 0 then
		BTN_EXCHANGE:setBright(false)
	end
	local tfd_needlv_des = m_fnGetWidget(_layModule, "tfd_needlv_des") 

	local IMG_LV = m_fnGetWidget(_layModule, "IMG_LV") 
	IMG_LV:removeFromParent()
	TFD_NEEDLV:removeFromParent()
	tfd_needlv_des:removeFromParent()
	local tfd_history = m_fnGetWidget(_layModule, "tfd_history")
	local TFD_HISTORY_RANK = m_fnGetWidget(_layModule, "TFD_HISTORY_RANK")
	tfd_history:removeFromParent()
	TFD_HISTORY_RANK:removeFromParent()

	local TFD_PRICE_NUM =  m_fnGetWidget(_layModule, "TFD_PRICE_NUM") -- 物品介绍
	local TFD_PRICE_GOLD = m_fnGetWidget(_layModule, "TFD_PRICE_GOLD")
	if tonumber(tbItemData.costType) == 1 then
		local img_gold = m_fnGetWidget(_layModule, "img_gold")
		img_gold:removeFromParent()

		TFD_PRICE_GOLD:removeFromParent()
		TFD_PRICE_NUM:setText(tbItemData.costNum)
	elseif(tonumber(tbItemData.costType) == 2) then
		local img_prestige = m_fnGetWidget(_layModule, "img_prestige")
		img_prestige:removeFromParent()
		TFD_PRICE_NUM:removeFromParent()
		TFD_PRICE_GOLD:setText(tbItemData.costNum)

	end


end

function updateUI( )
	local img_main_bg = m_fnGetWidget(m_mainWidget, "img_bg")
	-- img_main_bg:setScale(g_fScaleX)
	-- listView
	m_LSV_MAIN = m_fnGetWidget(m_mainWidget,"LSV_MAIN")
	 -- 声望商店物品数据
	_allGoods = ArenaData.getArenaMesShopInfo()

	logger:debug(_allGoods)

	local layModule = m_fnGetWidget(m_LSV_MAIN, "LAY_MODULE")
	local tempSize = layModule:getSize()
	layModule:setSize(CCSizeMake(tempSize.width * g_fScaleX, tempSize.height * g_fScaleX))
	for key,val in pairs(_allGoods) do
      	local itemModule = layModule:clone()
      	loaded(itemModule,val,key)
      	logger:debug("key = %s", key)
        m_LSV_MAIN:pushBackCustomItem(itemModule)

        local lay = m_fnGetWidget(itemModule, "LAY_TEST")
        UIHelper.startCellAnimation(lay, key, function ( ... )
        	logger:debug("动画播放完成了")
        end, 1)
        
  	end
  	m_LSV_MAIN:removeItem(0)

  
  	updateInfo()
  	
  	local BTN_REFRESH = m_fnGetWidget(m_mainWidget, "BTN_REFRESH")
  	BTN_REFRESH:addTouchEventListener(m_tbBtnEvent.onRfrShop)
  	UIHelper.titleShadow(BTN_REFRESH, m_i18n[2255])


  	local LAY_RANK = m_fnGetWidget(m_mainWidget, "LAY_RANK")
  	LAY_RANK:removeFromParentAndCleanup(true)

  	m_mainWidget.TFD_REFRESH_INFO:setText(m_i18n[2270])
  	UIHelper.labelNewStroke(m_mainWidget.TFD_REFRESH_INFO, ccc3(0x28, 0x00, 0x00), 2)
end

function updateInfo( ... )
	local LAY_REFRESH = m_fnGetWidget(m_mainWidget, "LAY_REFRESH")

  	local LAY_GOLD = m_fnGetWidget(LAY_REFRESH, "LAY_GOLD") 
  	local tfd_gold = m_fnGetWidget(LAY_GOLD, "tfd_gold") -- 花费金币
  	local TFD_ITEM_NUM = m_fnGetWidget(LAY_GOLD, "TFD_ITEM_NUM")

  	TFD_ITEM_NUM:setText(ArenaData.getRfrGoldNum())

  	local LAY_ITEM = m_fnGetWidget(m_mainWidget, "LAY_ITEM")
  	local tfd_item = m_fnGetWidget(m_mainWidget, "tfd_item")
  	local TFD_ITEM_NUM = m_fnGetWidget(m_mainWidget, "TFD_ITEM_NUM")
  	TFD_ITEM_NUM:setText(ArenaData.getRfrItemNum())

  	if ArenaData.getRfrItemNum() > 0 then
  		LAY_ITEM:setEnabled(true)
  		LAY_GOLD:setEnabled(false)
  	else
  		LAY_ITEM:setEnabled(false)
  		LAY_GOLD:setEnabled(true)
  	end

  	
end


function updateAfterBuy( index )  	
	if type(index) == "number" then
		local _allGoods = ArenaData.getArenaMesShopInfo()
		local itemInfo = _allGoods[index]
		local cell = m_LSV_MAIN:getItem(index-1)
		local maxLimitNum =  itemInfo.canBuyNum
		local TFD_BUYTIMES1 = m_fnGetWidget(cell, "TFD_BUYTIMES1") -- 物品说明1
		local TFD_BUYTIMES2 = m_fnGetWidget(cell, "TFD_BUYTIMES2") -- 物品说明2
		local BTN_EXCHANGE = m_fnGetWidget(cell, "BTN_EXCHANGE") -- 兑换按钮
		local str = nil
		if( tonumber(itemInfo.limitType) == 1)then
			TFD_BUYTIMES2:setEnabled(false)
			str = m_i18nString(2213,maxLimitNum)
			TFD_BUYTIMES1:setText(str)
		else
			str = m_i18nString(2212,maxLimitNum)
			TFD_BUYTIMES1:setEnabled(false)
			TFD_BUYTIMES2:setText(str)
		end
		if maxLimitNum == 0 then
			BTN_EXCHANGE:setBright(false)
		end
	end
	
end


function create( tbBtnEvent )
	m_tbBtnEvent = tbBtnEvent
	m_mainWidget = g_fnLoadUI(arena_shop_json)
	m_mainWidget:setSize(g_winSize)
	updateUI()
	return m_mainWidget
end