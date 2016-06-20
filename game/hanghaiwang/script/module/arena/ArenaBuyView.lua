-- FileName: ArenaBuyView.lua
-- Author: huxiaozhou
-- Date: 2014-05-18
-- Purpose: 竞技场耐力不足后提示购买耐力
--[[TODO List]]

module("ArenaBuyView", package.seeall)
require "script/module/public/ItemUtil"
require "script/module/shop/ShopUtil"

local json = "ui/copy_buypower.json"
-- UI控件引用变量 --
local m_LAY_S
local m_LAY_B

local m_i18n = gi18n
local m_i18nString = gi18nString

-- 模块局部变量 --
local m_tbEvent
local m_mainWidget
local m_pillId
local m_fnGetWidget = g_fnGetWidgetByName
local m_gold = 0
local m_stamina = 0
local function init(...)

end

function destroy(...)
	package.loaded["ArenaBuyView"] = nil
end

function moduleName()
    return "ArenaBuyView"
end

function updateGold( )
	if (tonumber(m_gold) ~= 0) then
		UserModel.addGoldNumber(-m_gold)
	end
	
end

function updateStamina( )
	if(tonumber(m_stamina) ~= 0) then
		UserModel.addStaminaNumber(m_stamina)
	end
end

function updateUI(  )
	m_gold = 0
	m_stamina = 0
    local labBuy = m_fnGetWidget(m_mainWidget, "TFD_BUY") -- 2015-10-09
    UIHelper.labelShadowWithText(labBuy, m_i18n[1435])
	local tfd_tip = m_fnGetWidget(m_mainWidget, "tfd_tip")
	tfd_tip:setText(m_i18n[2233])
	local TFD_TIP_INFO = m_fnGetWidget(m_mainWidget, "TFD_TIP_INFO")

	m_LAY_S = m_fnGetWidget(m_mainWidget, "LAY_S")
    m_LAY_B = m_fnGetWidget(m_mainWidget, "LAY_B")

	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
    BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	local tfd_tili = m_fnGetWidget(m_mainWidget, "tfd_tili")
    UIHelper.labelEffect(tfd_tili,m_i18n[1359])
    
	local  hasNumberS = 0
	local cacheInfoS = ItemUtil.getCacheItemInfoBy(m_pillId-1)
    if( not table.isEmpty(cacheInfoS))then
        hasNumberS = cacheInfoS.item_num
    end
    local hasNumberS2 = 0
    local cacheInfoS2 = ItemUtil.getCacheItemInfoBy(m_pillId)
    if( not table.isEmpty(cacheInfoS2))then
        hasNumberS2 = tonumber(cacheInfoS2.item_num)
    end
    local hasNumberS3 = 0
    local cacheInfoS3 = ItemUtil.getCacheItemInfoBy(m_pillId+1)
    if( not table.isEmpty(cacheInfoS3))then
        hasNumberS3 = tonumber(cacheInfoS3.item_num)
    end
    if (tonumber(hasNumberS)>0) then
    	m_LAY_S:setEnabled(true)
    	m_LAY_B:setEnabled(false)

        TFD_TIP_INFO:setText(m_i18n[2228])
    	local LAY_POWER_S = m_fnGetWidget(m_LAY_S, "LAY_POWER_S") -- 图标容器
    	local BTN_USE_S = m_fnGetWidget(m_LAY_S, "BTN_USE_S") --使用按钮
        UIHelper.titleShadow(BTN_USE_S, m_i18nString(1375, hasNumberS)) -- 2015-10-09
        BTN_USE_S:addTouchEventListener(m_tbEvent.onUse)
        BTN_USE_S:setTag(m_pillId-1)

    	local btnIcon,tbInfo = ItemUtil.createBtnByTemplateId(m_pillId-1)
    	LAY_POWER_S:addChild(btnIcon)
    	btnIcon:setPosition(ccp(LAY_POWER_S:getContentSize().width*.5,LAY_POWER_S:getContentSize().height*.5))

        local TFD_NUM_S = m_fnGetWidget(m_LAY_S, "TFD_NUM_S") --加耐力值
    	TFD_NUM_S:setText("+" .. tbInfo.endurance)
    	m_stamina = tbInfo.endurance
    elseif (hasNumberS2>0) then
        TFD_TIP_INFO:setText(m_i18n[2228])
        m_LAY_S:setEnabled(false)
        m_LAY_B:setEnabled(true)

        local LAY_POWER_B = m_fnGetWidget(m_LAY_B, "LAY_POWER_B") -- 图标容器

        local TFD_GOLD = m_fnGetWidget(m_LAY_B, "TFD_GOLD") --购买需要的金币
        local TFD_NUM_B = m_fnGetWidget(m_LAY_B, "TFD_NUM_B") -- 使用增加的耐力

        local BTN_BUY = m_fnGetWidget(m_LAY_B, "BTN_BUY")
        BTN_BUY:addTouchEventListener(m_tbEvent.onBuy)
        BTN_BUY:setTag(2)

        local btnIcon,tbInfo = ItemUtil.createBtnByTemplateId(m_pillId)
        LAY_POWER_B:addChild(btnIcon)
        btnIcon:setPosition(ccp(LAY_POWER_B:getContentSize().width*.5,LAY_POWER_B:getContentSize().height*.5))

        UIHelper.labelEffect(TFD_NUM_B,"")
        
        UIHelper.labelEffect(TFD_GOLD,"")
        TFD_NUM_B:setText("+" .. tbInfo.endurance)
        m_stamina = tbInfo.endurance
        local  hasNumberB = 0
        local cacheInfoB = ItemUtil.getCacheItemInfoBy(m_pillId)
        if( not table.isEmpty(cacheInfoB))then
            hasNumberB = cacheInfoB.item_num
        end

        local BTN_USE_B = m_fnGetWidget(m_LAY_B, "BTN_USE_B")

        if (tonumber(hasNumberB)>0) then
            BTN_USE_B:setTouchEnabled(true)
            UIHelper.titleShadow(BTN_USE_B, m_i18nString(1375, hasNumberB)) -- 2015-10-09
        else
            UIHelper.titleShadow(BTN_USE_B, m_i18nString(1375, 0)) -- 2015-10-09
        end
        BTN_USE_B:addTouchEventListener(m_tbEvent.onUse)
        BTN_USE_B:setTag(m_pillId)

        m_gold =  ShopUtil.getNeedGoldByGoodsAndTimes(2,ShopUtil.getBuyNumBy(2)+1)
        TFD_GOLD:setText(m_gold)
    elseif (hasNumberS3>0) then
        m_LAY_S:setEnabled(true)
        m_LAY_B:setEnabled(false)

        TFD_TIP_INFO:setText(m_i18n[2228])
        local LAY_POWER_S = m_fnGetWidget(m_LAY_S, "LAY_POWER_S") -- 图标容器
        local BTN_USE_S = m_fnGetWidget(m_LAY_S, "BTN_USE_S") --使用按钮
        UIHelper.titleShadow(BTN_USE_S, m_i18nString(1375, hasNumberS3)) -- 2015-10-09
        BTN_USE_S:addTouchEventListener(m_tbEvent.onUse)
        BTN_USE_S:setTag(m_pillId+1)

        local btnIcon,tbInfo = ItemUtil.createBtnByTemplateId(m_pillId+1)
        LAY_POWER_S:addChild(btnIcon)
        btnIcon:setPosition(ccp(LAY_POWER_S:getContentSize().width*.5,LAY_POWER_S:getContentSize().height*.5))

        local TFD_NUM_S = m_fnGetWidget(m_LAY_S, "TFD_NUM_S") --加耐力值
        TFD_NUM_S:setText("+" .. tbInfo.endurance)
        m_stamina = tbInfo.endurance
    else
        TFD_TIP_INFO:setText(m_i18n[2228])
        m_LAY_S:setEnabled(false)
        m_LAY_B:setEnabled(true)

        local LAY_POWER_B = m_fnGetWidget(m_LAY_B, "LAY_POWER_B") -- 图标容器

        local TFD_GOLD = m_fnGetWidget(m_LAY_B, "TFD_GOLD") --购买需要的金币
        local TFD_NUM_B = m_fnGetWidget(m_LAY_B, "TFD_NUM_B") -- 使用增加的耐力

        local BTN_BUY = m_fnGetWidget(m_LAY_B, "BTN_BUY")
        BTN_BUY:addTouchEventListener(m_tbEvent.onBuy)
        BTN_BUY:setTag(2)

        local btnIcon,tbInfo = ItemUtil.createBtnByTemplateId(m_pillId)
        LAY_POWER_B:addChild(btnIcon)
        btnIcon:setPosition(ccp(LAY_POWER_B:getContentSize().width*.5,LAY_POWER_B:getContentSize().height*.5))

        UIHelper.labelEffect(TFD_NUM_B,"")
        
        UIHelper.labelEffect(TFD_GOLD,"")
        TFD_NUM_B:setText("+" .. tbInfo.endurance)
        m_stamina = tbInfo.endurance
        local  hasNumberB = 0
        local cacheInfoB = ItemUtil.getCacheItemInfoBy(m_pillId)
        if( not table.isEmpty(cacheInfoB))then
            hasNumberB = cacheInfoB.item_num
        end

        local BTN_USE_B = m_fnGetWidget(m_LAY_B, "BTN_USE_B")

        if (tonumber(hasNumberB)>0) then
            BTN_USE_B:setTouchEnabled(true)
            UIHelper.titleShadow(BTN_USE_B, m_i18nString(1375, hasNumberB)) -- 2015-10-09
        else
            UIHelper.titleShadow(BTN_USE_B, m_i18nString(1375, 0)) -- 2015-10-09
        end
        BTN_USE_B:addTouchEventListener(m_tbEvent.onUse)
        BTN_USE_B:setTag(m_pillId)

        m_gold =  ShopUtil.getNeedGoldByGoodsAndTimes(2,ShopUtil.getBuyNumBy(2)+1)
        TFD_GOLD:setText(m_gold)
    end
end

function create(_pillId,tbEvent)
	m_pillId = _pillId
	m_tbEvent = tbEvent
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	updateUI()
	return m_mainWidget
end

-- zhangqi, 2015-04-29, 控制耐力不足提示文字的显示
function showLackTips( bShow )
    local tfd_tip = m_fnGetWidget(m_mainWidget, "tfd_tip")
    tfd_tip:setEnabled(bShow)
end

function loadUI( ... )
    m_gold = 0
    m_stamina = 0

    local labBuy = m_fnGetWidget(m_mainWidget, "TFD_BUY") -- 2015-10-09
    UIHelper.labelShadowWithText(labBuy, m_i18n[1435])

    local tfd_tip = m_fnGetWidget(m_mainWidget, "tfd_tip")
    tfd_tip:setText(m_i18n[2244])
    local TFD_TIP_INFO = m_fnGetWidget(m_mainWidget, "TFD_TIP_INFO")

    m_LAY_S = m_fnGetWidget(m_mainWidget, "LAY_S")
    m_LAY_B = m_fnGetWidget(m_mainWidget, "LAY_B")
    m_LAY_S:setEnabled(false)
    local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
    BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
    local tfd_tili = m_fnGetWidget(m_mainWidget, "tfd_tili")
    UIHelper.labelEffect(tfd_tili, m_i18n[2245])
  
    TFD_TIP_INFO:setText(m_i18n[2246])
    m_LAY_B:setEnabled(true)

    
    local LAY_POWER_B = m_fnGetWidget(m_LAY_B, "LAY_POWER_B") -- 图标容器

    local TFD_GOLD = m_fnGetWidget(m_LAY_B, "TFD_GOLD") --购买需要的金币
    local TFD_NUM_B = m_fnGetWidget(m_LAY_B, "TFD_NUM_B") -- 使用增加的耐力

    local BTN_BUY = m_fnGetWidget(m_LAY_B, "BTN_BUY")
    BTN_BUY:addTouchEventListener(m_tbEvent.onBuy)
    BTN_BUY:setTag(15)

    local btnIcon,tbInfo = ItemUtil.createBtnByTemplateId(m_pillId)
    LAY_POWER_B:addChild(btnIcon)
    btnIcon:setPosition(ccp(LAY_POWER_B:getContentSize().width*.5,LAY_POWER_B:getContentSize().height*.5))

    UIHelper.labelEffect(TFD_NUM_B,"")
    
    UIHelper.labelEffect(TFD_GOLD,"")
    TFD_NUM_B:setText("+" .. tbInfo.add_challenge_times)
    m_stamina = tbInfo.add_challenge_times
    local  hasNumberB = 0
    local cacheInfoB = ItemUtil.getCacheItemInfoBy(m_pillId)
    if( not table.isEmpty(cacheInfoB))then
        hasNumberB = cacheInfoB.item_num
    end

    local BTN_USE_B = m_fnGetWidget(m_LAY_B, "BTN_USE_B")

    if (tonumber(hasNumberB)>0) then
        BTN_USE_B:setTouchEnabled(true)
        UIHelper.titleShadow(BTN_USE_B, m_i18nString(1375, hasNumberB)) -- 2015-10-09
    else
        UIHelper.titleShadow(BTN_USE_B, m_i18nString(1375, 0)) -- 2015-10-09
    end
    BTN_USE_B:addTouchEventListener(m_tbEvent.onUse)
    BTN_USE_B:setTag(m_pillId)

    m_gold =  ShopUtil.getNeedGoldByGoodsAndTimes(15,ShopUtil.getBuyNumBy(15)+1)
    TFD_GOLD:setText(m_gold)
    
    local TFD_VIP_STAMINA = m_fnGetWidget(m_mainWidget, "TFD_VIP_STAMINA")
    TFD_VIP_STAMINA:setText(m_i18n[2243])
end


function createBuyArenaItem( _pillId, tbEvent )
    m_pillId = _pillId
    m_tbEvent = tbEvent
    m_mainWidget = g_fnLoadUI(json)
    m_mainWidget:setSize(g_winSize)
    loadUI()
    return m_mainWidget
end