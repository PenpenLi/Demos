-- FileName: PartnerPublicFull.lua 
-- Author: xianghuiZhang
-- Date: 14-05-210
-- Purpose: function description of module 

module("PartnerPublicFull", package.seeall)
require "script/GlobalVars" 


-- 初始化和析构
function init( ... )
    
end
function destroy( ... )
    
end

function moduleName()
    return "PartnerPublicFull"
end

local function onCloseSelf( ... )
    LayerManager.removeLayout()
end

local function onBtnClose( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then       
        onCloseSelf()
    end
end

local function onBtnExpand( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        require "script/module/partner/Prompt"
        Prompt.create(onCloseSelf())
    end
end

local function onBtnStrengthen( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then       
        require "script/module/partner/MainPartner"
        local layPartner = MainPartner.create()
        LayerManager.changeModule(layPartner, MainPartner.moduleName(), {1, 3})
        PlayerPanel.addForPartnerStrength()
    end
end

function create( ... )
    local publicBagFull = g_fnLoadUI("ui/public_bag_full_info.json")

    local btnClose = g_fnGetWidgetByName(publicBagFull, "BTN_PARTNER_BAG_FULL_CLOSE")
    btnClose:addTouchEventListener(onBtnClose)

    local btnExpand = g_fnGetWidgetByName(publicBagFull, "BTN_1")
    btnExpand:addTouchEventListener(onBtnExpand)

    local btnSell = g_fnGetWidgetByName(publicBagFull, "BTN_2")
    btnSell:setVisible(false)
    btnSell:setEnabled(false)

    local btnStrengthen = g_fnGetWidgetByName(publicBagFull, "BTN_3")
    btnStrengthen:addTouchEventListener(onBtnStrengthen)

    local layBtnTwo = g_fnGetWidgetByName(publicBagFull, "lay_btn_two")
    layBtnTwo:setVisible(false)
    layBtnTwo:setEnabled(false)
    
    return publicBagFull
end
