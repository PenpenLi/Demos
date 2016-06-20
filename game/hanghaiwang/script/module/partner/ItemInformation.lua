-- FileName: ItemInformation.lua 
-- Author: fubei
-- Date: 14-3-28 
-- Purpose: function description of module 

module("ItemInformation", package.seeall)
require "script/GlobalVars"
require "script/module/public/ItemUtil"
require "script/module/public/ShowNotice"

-- vars
local item_information

local imgItemIcon
local tfdItemName
local tfdItemProfile
local m_i18n = gi18n

-- 初始化和析构
function init( ... )
end
function destroy( ... )
end

function moduleName()
    return "ItemInformation"
end

local function onBtnClose( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        LayerManager.removeLayout()
    end
end

local function onBtnGoUcpy( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        --前往联盟副本
        AudioHelper.playMainMenuBtn()
        AudioHelper.playMainMusic()

        require "script/module/copy/MainCopy"
        if (MainCopy.moduleName() ~= LayerManager.curModuleName() or MainCopy.isInExploreMap()) then
            MainCopy.destroy()
            LayerManager.changeModule(Layout:create(), "ExploreAndCopyChange", {}, true)
            local timeTemp = os.clock()
            local timeS = os.time()
            print("begin clock : %s", timeTemp)
            local layCopy = MainCopy.create()
            if (layCopy) then
                LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
                PlayerPanel.addForCopy()
                MainCopy.updateBGSize()
                MainCopy.setFogLayer()
                print("end clock : %s", os.clock() - timeTemp)
                print("end time : %s", os.time() - timeS)
            end
        end
    end
end

--前往竞技场
local function onBtnGoArena( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        require "script/module/switch/SwitchModel"
        if(not SwitchModel.getSwitchOpenState(ksSwitchArena,true)) then
            return
        end
        LayerManager.removeLayout()
        require "script/module/arena/MainArenaCtrl"        
        ArenaCtrl.create(ArenaCtrl.tbType.shop)
    end
end

--神秘商店
local function onBtnMysteriousShop( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        require "script/module/switch/SwitchModel"
        if(not SwitchModel.getSwitchOpenState(ksSwitchResolve,true)) then
            return
        end
        require "script/module/wonderfulActivity/MainWonderfulActCtrl"
        local act = MainWonderfulActCtrl.create("castle")
        LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
    end
end

--去联盟商店
local function onBtnUnionShop( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        require "script/module/guild/GuildDataModel"
        require "script/module/guild/MainGuildCtrl"
        local isInUnion = false
        isInUnion = GuildDataModel.getIsHasInGuild()
        logger:debug({isInUnion=isInUnion})
        if (isInUnion) then
            MainGuildCtrl.enterShop()
        else
            ShowNotice.showShellInfo(m_i18n[1925])
        end
    end
end

local function updateItemInfo( itemtid )
    local itemInfo = ItemUtil.getItemById(itemtid)
    if (imgItemIcon ~= nil ) then
        local itemBtn,itemInfo = ItemUtil.createBtnByTemplateId(itemtid)
        imgItemIcon:addChild(itemBtn)
    end
    if (tfdItemName ~= nil ) then
        tfdItemName:setText(itemInfo.name .. "")
    end
    if (tfdItemProfile ~= nil ) then
        tfdItemProfile:setText(itemInfo.desc .. "")
    end
end

function create( itemTid , type)
    local pString = "ui/item_information.json"
    local pType = tonumber(type) or 0
    if(pType == 1) then
        pString = "ui/break_item.json"
    end
    local item_information =   g_fnLoadUI(pString) -- GUIReader:shareReader():widgetFromJsonFile("ui/item_information.json")
    if (item_information) then
        item_information:setSize(g_winSize)
    end

    local btnClose = g_fnGetWidgetByName(item_information, "BTN_ITEM_INFORMATION", "Button")
    if (btnClose ~= nil) then
        btnClose:addTouchEventListener(onBtnClose)
    end

    if(pType == 0) then
        local btnGoArena = g_fnGetWidgetByName(item_information, "BTN_GO_ARENA", "Button")
        if (btnGoArena ~= nil) then
            UIHelper.titleShadow(btnGoArena,gi18n[1091])
            btnGoArena:addTouchEventListener(onBtnGoArena)
        end
        local btnGoMysteriousShop = g_fnGetWidgetByName(item_information, "BTN_GO_MYSTERIOUS_SHOP", "Button")
        if (btnGoMysteriousShop ~= nil) then
            --UIHelper.titleShadow(btnGoMysteriousShop,gi18n[1906]) -- 神秘商店
            UIHelper.titleShadow(btnGoMysteriousShop,gi18n[3816]) -- 公会商店
            --btnGoMysteriousShop:addTouchEventListener(onBtnMysteriousShop)
            btnGoMysteriousShop:addTouchEventListener(onBtnUnionShop)
        end
    elseif(pType == 1) then
        local btnGoUcpy = g_fnGetWidgetByName(item_information, "BTN_GO_UCOPY", "Button")
        if (btnGoUcpy ~= nil) then
            UIHelper.titleShadow(btnGoUcpy,m_i18n[1157]) --wm_todo
            btnGoUcpy:addTouchEventListener(onBtnGoUcpy)
        end
        local btnGoMysteriousShop = g_fnGetWidgetByName(item_information, "BTN_GO_MYSTERIOUS_SHOP", "Button")
        if (btnGoMysteriousShop ~= nil) then
           -- UIHelper.titleShadow(btnGoMysteriousShop,gi18n[1906])
            UIHelper.titleShadow(btnGoMysteriousShop,gi18n[3816]) -- 公会商店
            --btnGoMysteriousShop:addTouchEventListener(onBtnMysteriousShop)
            btnGoMysteriousShop:addTouchEventListener(onBtnUnionShop)
        end
    end

    

    
	imgItemIcon = g_fnGetWidgetByName(item_information, "IMG_ITEM_ICON", "ImageView")
	tfdItemName = g_fnGetWidgetByName(item_information, "TFD_ITEM_NAME", "Label")         
	tfdItemProfile = g_fnGetWidgetByName(item_information, "TFD_ITEM_PROFILE", "Label")

    updateItemInfo(itemTid)

    return item_information
end















