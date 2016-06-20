-- FileName: PartnerSaleStar.lua 
-- Author: fubei
-- Date: 14-3-28 
-- Purpose: 
-- modified by zhangqi, 2014-07-24, 伙伴列表去掉了出售功能，装备的按星级出售改成按品级出售 

module("PartnerSellStar", package.seeall)
require "script/GlobalVars"

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

local ccs = ccs or {}

ccs.CheckBoxEventType = 
{
    selected = 0,
    unselected = 1,
}


local sellStarPartner = 0
local sellStarEquip = 1

-- vars
local layMain
local btnSelectAll
local btnUnSelectAll
local cbxChoiseStar1
-- local cbxChoiseStar2
local cbxChoiseStar3
local tbSelectState --已经选择的项
local tbChoiseBox = {}
local bcurSellStarType = 0
local m_saleList -- 对应的出售列表对象，zhangqi, 2014-08-06


-- 初始化和析构
function init( ... )
    m_saleList = nil
end
function destroy( ... )
    init()
    package.loaded["PartnerSellStar"] = nil
end

function moduleName()
    return "PartnerSellStar"
end

--批量处理checkbox状态
local function fnSetCheckState( blState )
    tbSelectState[1] = blState
    tbSelectState[2] = blState

    cbxChoiseStar1:setSelectedState(blState)
    cbxChoiseStar3:setSelectedState(blState)

    btnSelectAll:setEnabled(not blState)
    btnUnSelectAll:setEnabled(blState)
end

local function onBtnSelectAll( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        fnSetCheckState(true)
    end
end

local function onBtnUnSelectAll( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        fnSetCheckState(false)
    end
end

local function onBtnConfirm( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        logger:debug("bcurSellStarType: " .. bcurSellStarType)

        LayerManager.removeLayout()

        if (bcurSellStarType == sellStarEquip) then 
            require "script/module/equipment/MainEquipmentCtrl"
            MainEquipmentCtrl.setEquipSelectStateBySellStar(tbSelectState, m_saleList)
        end
    end
end

local function onCellChoiseStar( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        local tag = sender:getTag()
        if (tbSelectState[tag]) then
            tbSelectState[tag] = false
            tbChoiseBox[tag]:setSelectedState(false)
        else
            tbSelectState[tag] = true
            tbChoiseBox[tag]:setSelectedState(true)
        end

        local bAll = (tbSelectState[1] and tbSelectState[2])
        btnSelectAll:setEnabled(not bAll)
        btnUnSelectAll:setEnabled(bAll)
    end
end

-- zhangqi, 2014-08-06
-- sellStarType: 出售类型，1-装备；2-伙伴（功能已废弃）
-- saleList: 对应的出售列表对象，SaleList的实例
function create( sellStarType, saleList)
    init()
    m_saleList = saleList

    bcurSellStarType = sellStarType 
    tbSelectState = {false,false,false}
    local layMain = g_fnLoadUI("ui/partner_sell_star.json")

    local i18nTips = m_fnGetWidget(layMain, "TFD_CHOISE_STAR_TXT")
    i18nTips:setText(m_i18n[1026])

    local i18nWhite = m_fnGetWidget(layMain, "tfd_white") --  [1094] = "白色品质",[1095] = "绿色品质",
    i18nWhite:setText(m_i18n[1094])
    local i18nGreen = m_fnGetWidget(layMain, "tfd_green")
    i18nGreen:setText(m_i18n[1095])
    
    cbxChoiseStar1 = m_fnGetWidget(layMain, "CBX_CHOISE_STAR1")
    cbxChoiseStar1:setTag(1)

    cbxChoiseStar3 = m_fnGetWidget(layMain, "CBX_CHOISE_STAR3")
    cbxChoiseStar3:setTag(2)

    tbChoiseBox = {}
    table.insert(tbChoiseBox,cbxChoiseStar1)
    table.insert(tbChoiseBox,cbxChoiseStar3)

    local imgChoise1 = m_fnGetWidget(layMain, "img_choise_star_bg1")
    imgChoise1:setTag(1)
    imgChoise1:addTouchEventListener(onCellChoiseStar)
    

    local imgChoise3 = m_fnGetWidget(layMain, "img_choise_star_bg3")
    imgChoise3:setTag(2)
    imgChoise3:addTouchEventListener(onCellChoiseStar)

    local btnClose = m_fnGetWidget(layMain, "BTN_SELLSTAR_CLOSE", "Button")  --  [1026] = "请选择品质颜色", [1027] = "选择全部", [1028] = "取消选择",[1029] = "确定",
    btnClose:addTouchEventListener(UIHelper.onClose)


    btnSelectAll = m_fnGetWidget(layMain, "BTN_SELECT_ALL", "Button")
    UIHelper.titleShadow(btnSelectAll, m_i18n[1027])
    btnSelectAll:addTouchEventListener(onBtnSelectAll)

    btnUnSelectAll = m_fnGetWidget(layMain, "BTN_CANCEL_ALL")
    UIHelper.titleShadow(btnUnSelectAll, m_i18n[1028])
    btnUnSelectAll:setEnabled(false)
    btnUnSelectAll:addTouchEventListener(onBtnUnSelectAll)

    local btnConfirm = m_fnGetWidget(layMain, "BTN_CONFIRM", "Button")
    UIHelper.titleShadow(btnConfirm, m_i18n[1029])
    btnConfirm:addTouchEventListener(onBtnConfirm)

    return layMain
end















