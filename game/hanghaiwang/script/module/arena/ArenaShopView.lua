-- FileName: ArenaShopView.lua
-- Author: huxiaozhou
-- Date: 2014-05-09
-- Purpose: 竞技场 商城显示界面
--[[TODO List]]

require "script/module/public/PublicInfoCtrl"

module ("ArenaShopView",package.seeall)
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
	package.loaded["ArenaShopView"] = nil
end

function moduleName()
    return "ArenaShopView"
end

function loaded( _layModule , tbItemData,index)
	logger:debug(tbItemData)

	--一堆控件
	local LAY_GOODS = m_fnGetWidget(_layModule, "LAY_GOODS") -- img 位置
	local TFD_NAME = m_fnGetWidget(_layModule, "TFD_NAME")   -- 物品名字
	local TFD_BUYTIMES1 = m_fnGetWidget(_layModule, "TFD_BUYTIMES1") -- 物品说明1
	local TFD_BUYTIMES2 = m_fnGetWidget(_layModule, "TFD_BUYTIMES2") -- 物品说明2
	local TFD_DESC =  m_fnGetWidget(_layModule, "TFD_DESC") -- 物品介绍
	local TFD_PRICE_NUM =  m_fnGetWidget(_layModule, "TFD_PRICE_NUM") -- 物品介绍
	local TFD_NEEDLV = m_fnGetWidget(_layModule, "TFD_NEEDLV") -- 需要的等级
	local BTN_EXCHANGE = m_fnGetWidget(_layModule, "BTN_EXCHANGE") -- 兑换按钮
	local img_cellbg = m_fnGetWidget(_layModule, "img_cellbg")
	img_cellbg:setScale(g_fScaleX)
	UIHelper.titleShadow(BTN_EXCHANGE,m_i18n[2203])
	BTN_EXCHANGE:addTouchEventListener(m_tbBtnEvent.onExChange)
	BTN_EXCHANGE:setTag(tbItemData.id)
	-- 兑换物品id
	local itemType, item_id, item_num = ArenaData.getItemData( tbItemData.items )
	local tReward = RewardUtil.parseRewards(tbItemData.items)

	local strDesc = tReward[1].dbInfo and tReward[1].dbInfo.desc or m_i18n[2276]
    tReward[1].icon:setPosition(ccp(LAY_GOODS:getContentSize().width*.5,LAY_GOODS:getContentSize().height*.5))
    LAY_GOODS:addChild(tReward[1].icon)

   	if ArenaData.getMinPosition() > tonumber(tbItemData.highest_rank) then
   		BTN_EXCHANGE:setBright(false)
   	end

    
    TFD_DESC:setText(strDesc or "")
    TFD_NAME:setText(tReward[1].name or "" )
    
	local color =  g_QulityColor[tonumber(tReward[1].quality)]
	if(color ~= nil) then
		TFD_NAME:setColor(color)
	end
	UIHelper.labelAddStroke(TFD_NAME,tReward[1].name)

	-- 限购
	local maxLimitNum =  tonumber(tbItemData.baseNum) - ArenaData.getBuyNumBy(tbItemData.id)
	if (maxLimitNum<0) then
		maxLimitNum = 0
	end
	local str = nil
	if( tonumber(tbItemData.limitType) == 1)then
		TFD_BUYTIMES2:setEnabled(false)
		str = m_i18nString(2213,maxLimitNum)
		TFD_BUYTIMES1:setText(str)
	else
		str = m_i18nString(2212,maxLimitNum)
		TFD_BUYTIMES1:setEnabled(false)
		TFD_BUYTIMES2:setText(str)
	end

	-- 价格
	local curPrice = tonumber(tbItemData.costPrestige)
	TFD_PRICE_NUM:setText(curPrice)

	local needLevel = tonumber(tbItemData.needLevel)

	local tfd_needlv_des = m_fnGetWidget(_layModule, "tfd_needlv_des") 
	if(needLevel <=0) then
		
		local IMG_LV = m_fnGetWidget(_layModule, "IMG_LV") 
		IMG_LV:removeFromParent()
		TFD_NEEDLV:removeFromParent()
		tfd_needlv_des:removeFromParent()

	else 
		tfd_needlv_des:setText(m_i18nString(2214))
		TFD_NEEDLV:setText(needLevel)
	end

	local tfd_history = m_fnGetWidget(_layModule, "tfd_history")
	tfd_history:setText(m_i18n[2257])

	local TFD_HISTORY_RANK = m_fnGetWidget(_layModule, "TFD_HISTORY_RANK")
	TFD_HISTORY_RANK:setText(tbItemData.highest_rank)
	
	-- UIHelper.labelNewStroke(tfd_history)
	-- UIHelper.labelNewStroke(TFD_HISTORY_RANK)

	local img_gold = m_fnGetWidget(_layModule, "img_gold")
	img_gold:removeFromParent()
	local TFD_PRICE_GOLD = m_fnGetWidget(_layModule, "TFD_PRICE_GOLD")
	TFD_PRICE_GOLD:removeFromParent()


end

function updateUI( )
	local img_main_bg = m_fnGetWidget(m_mainWidget, "img_bg")
	-- img_main_bg:setScale(g_fScaleX)
	-- listView
	m_LSV_MAIN = m_fnGetWidget(m_mainWidget,"LSV_MAIN")
	 -- 声望商店物品数据
	_allGoods = ArenaData.getArenaAllShopInfo()

	logger:debug(_allGoods)

	local layModule = m_fnGetWidget(m_LSV_MAIN, "LAY_MODULE")
	-- layModule:setScale(g_fScaleX)
	local tempSize = layModule:getSize()
	layModule:setSize(CCSizeMake(tempSize.width * g_fScaleX, tempSize.height * g_fScaleX))
	for index,val in ipairs(_allGoods) do
      	local itemModule = layModule:clone()

      	performWithDelayFrame(itemModule, function (  )
      		loaded(itemModule,val,index)
      	end, index)
      	
        m_LSV_MAIN:pushBackCustomItem(itemModule)

        local lay = m_fnGetWidget(itemModule, "LAY_TEST")
        UIHelper.startCellAnimation(lay, index, function ( ... )
        	logger:debug("动画播放完成了")
        end, 1)
  	end
  	m_LSV_MAIN:removeItem(0)

  	local LAY_REFRESH = m_fnGetWidget(m_mainWidget, "LAY_REFRESH")
  	LAY_REFRESH:removeFromParentAndCleanup(true)
  	local TFD_OWN = m_fnGetWidget(m_mainWidget, "TFD_OWN")
  	TFD_OWN:setText(m_i18nString(2271,ArenaData.getMinPosition()))

  	UIHelper.labelNewStroke(TFD_OWN, ccc3(0x28, 0x00, 0x00), 2)

end

function updateAfterBuy( index )
	if type(index) == "number" then
		local itemInfo = _allGoods[index]
		local cell = m_LSV_MAIN:getItem(index-1)
		local maxLimitNum =  tonumber(itemInfo.baseNum) - ArenaData.getBuyNumBy(itemInfo.id)
		local TFD_BUYTIMES1 = m_fnGetWidget(cell, "TFD_BUYTIMES1") -- 物品说明1
		local TFD_BUYTIMES2 = m_fnGetWidget(cell, "TFD_BUYTIMES2") -- 物品说明2
		local str = nil
		if( tonumber(itemInfo.limitType) == 1)then
			TFD_BUYTIMES2:setEnabled(false)
			str = m_i18nString(2213,maxLimitNum)
			TFD_BUYTIMES1:setText(str)
		else
			if maxLimitNum <= 0 then
				table.remove(_allGoods,index)
				m_LSV_MAIN:removeItem(index-1)
			else
				str = m_i18nString(2212,maxLimitNum)
				TFD_BUYTIMES1:setEnabled(false)
				TFD_BUYTIMES2:setText(str)
			end
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
