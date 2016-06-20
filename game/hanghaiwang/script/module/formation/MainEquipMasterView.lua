-- FileName: MainEquipMasterView.lua
-- Author: wangming
-- Date: 2014-12-11
-- Purpose: 装备大师模块视图层
--[[TODO List]]

module("MainEquipMasterView", package.seeall)

-- require "script/module/public/UIHelper"
-- require "script/module/config/AudioHelper"
-- require "script/network/Network"
-- require "script/network/RequestCenter"
-- require "script/module/public/EffectHelper"
-- require "script/module/formation/MasterScoreView"
-- require "script/module/formation/MasterEquipAndTreasure"

local m_animationPath = "images/effect/forge"

-- 资源文件--
local equipMaster = "ui/formation_strenghen_guru.json" 
-- UI控件引用变量 --
local m_fnGetWidget =  g_fnGetWidgetByName 

-- 模块局部变量 --
local m_i18n = gi18n
local _curPage = 0
local m_heroInfo
local m_curPageNum
-- 页面序号
local _pageTag = {
    tagScore = 5,   -- 品级大师       
    tagEquipQH = 1, -- 装备强化
    tagEquipFM = 2, -- 装备附魔
    tagTreaQH = 3,  -- 宝物强化
    tagTreaJL = 4   -- 宝物精炼
}

-------------- 控件 ----------------
local _layBg
--切换按钮
local _switch_Score     
local _switch_Equip
local _switch_Treasure
local _curBtn = nil
-- 当前子页面
local _curLayer = nil
local _childrenLayer = {}
-------------- 控件 ----------------

local m_all_str_openVip = -1
local m_all_str_openLv = -1
local m_tipStr = nil
local showNode

local function init(...)

end

function destroy(...)
    _curBtn = nil
    m_arAni1 = nil
    m_arAni2 = nil
    m_arAni3 = nil
    m_arAni4 = nil
    showNode = nil
    _curLayer = nil
    _childrenLayer = {}
	package.loaded["MainEquipMasterView"] = nil
end

function moduleName()
    return "MainEquipMasterView"
end

function isOneKeyCannotUse( isShowInfo )
    local pShow = isShowInfo or false
    -- return ( not SwitchModel.getSwitchOpenState(ksSwitchMasterOneKey , pShow))
    local pherolv = UserModel.getHeroLevel()
    local pviplv = UserModel.getVipLevel()
    if(pherolv < m_all_str_openLv and pviplv < m_all_str_openVip) then
        if(pShow and m_tipStr) then
            require "script/module/public/ShowNotice"
            ShowNotice.showShellInfo(m_tipStr)
        end
        return true
    end
    return false
end

-- 属性的变化
function showAttrChangeAnimation( _info )

    local t_numerial, t_numerial_PL
    t_numerial, t_numerial_PL = ItemUtil.getTop2NumeralByIID(tonumber(_info.key))
    local addLv = tonumber(_info.varNew) - tonumber(_info.varOld)

    _n_string_t = {}        -- 属性名称
    _n_value_e  = {}        -- 强化增加

    --g_AttrNameWithoutSign = {hp = m_i18n[1068], phy_att = m_i18n[1069], magic_att = m_i18n[1070], phy_def = m_i18n[1071], magic_def = m_i18n[1072], }
    for key,v_num in pairs(t_numerial) do
        n_name = nil
        if (key == "hp") then
            n_name = g_AttrNameWithoutSign.hp
        elseif(key == "gen_att"  )then
            n_name = g_AttrNameWithoutSign.gen_att
        elseif(key == "phy_att"  )then
            n_name = g_AttrNameWithoutSign.phy_att
        elseif(key == "magic_att")then
            n_name = g_AttrNameWithoutSign.magic_att
        elseif(key == "phy_def"  )then
            n_name = g_AttrNameWithoutSign.phy_def
        elseif(key == "magic_def")then
            n_name = g_AttrNameWithoutSign.magic_def
        end
        table.insert(_n_string_t, n_name)
        table.insert(_n_value_e, t_numerial_PL[key])
    end

    local t_text = {}
    for k, strName in pairs(_n_string_t) do
        local o_text = {}
        o_text.txt = strName
        o_text.num = addLv* _n_value_e[k]
        table.insert(t_text, o_text)
    end

    require "script/utils/LevelUpUtil"
    LevelUpUtil.showFlyText(t_text)
end

-- 获得开启等级
function fnGetAllStrOpenLv( ... )
    m_all_str_openVip = -1
    m_all_str_openLv = -1
    m_tipStr = nil
    local vipData = nil
    local pCount = table.count(DB_Vip.Vip)
    local pVerTab = nil
    for i=1,pCount do
        vipData = DB_Vip.getDataById(i)
        if(vipData and vipData.all_str_limit) then
            pVerTab = string.split(vipData.all_str_limit, "|") 
            local pOpen = tonumber(pVerTab[1]) or 0
            if(pOpen == 1 and m_all_str_openVip == -1) then
                m_all_str_openVip = i
                m_all_str_openLv = tonumber(pVerTab[2]) or 0
                m_tipStr = string.format(m_i18n[5022],tostring(m_all_str_openVip),tostring(m_all_str_openLv))
                return m_all_str_openVip, m_all_str_openLv, m_tipStr
            end
        end
    end
    return m_all_str_openVip, m_all_str_openLv, m_tipStr
end

-- 加载品级大师
function loadScore( ... )
    -- _curLayer = _childrenLayer[1]
    -- _curLayer:setVisible(true)
    -- _curLayer:setEnabled(true)
    -- MasterScoreView.reload()
end

-- 加载装备强化
function loadEquip( ... )
    _curLayer = _childrenLayer[1]
    _curLayer:setVisible(true)
    _curLayer:setEnabled(true)
    MasterEquipAndTreasure.setCurPage(_curPage)
    MasterEquipAndTreasure.reload()
end

-- 加载宝物强化
function loadTreasure( ... )
    _curLayer = _childrenLayer[1]
    _curLayer:setVisible(true)
    _curLayer:setEnabled(true)
    MasterEquipAndTreasure.setCurPage(_curPage)
    MasterEquipAndTreasure.reload()
end

function setBtnColor( pBtn, color )
    if (pBtn) then
        local label = tolua.cast(pBtn:getTitleTTF(), "CCLabelTTF")
        if (label) then
            label:setColor(color)
        end
    end
end

-- yucong
-- 切换页面回调
local function onSwitch( sender,eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playTabEffect()
        local btn = tolua.cast(sender,"Button")
        -- 按下颜色改变 T_T
        if (eventType == TOUCH_EVENT_BEGAN) then
            setBtnColor(btn, ccc3(0xff, 0xff, 0xff))
        elseif (eventType == TOUCH_EVENT_MOVED) then
            setBtnColor(btn, ccc3(0xff, 0xff, 0xff))
        elseif (eventType == TOUCH_EVENT_CANCELED) then
            setBtnColor(btn, ccc3(0xbf, 0x93, 0x67))
        elseif (eventType == TOUCH_EVENT_ENDED) then
            if (btn) then
                enterPage(btn:getTag())
            end
        end
    end
end

-- 初始化分页栏按钮
function fnInitButtons( ... )

    local btnClose =  m_fnGetWidget(_layBg,"BTN_CLOSE")
    btnClose:addTouchEventListener(close)
    UIHelper.titleShadow(btnClose, m_i18n[1019])

    local normal_color = ccc3(0xbf, 0x93, 0x67)
    --装备强化
    _layBg.BTN_EQUIP:setTag(_pageTag.tagEquipQH)       -- 默认装备按钮 强化
    _layBg.BTN_EQUIP:setTitleText(m_i18n[5001])
    _layBg.BTN_EQUIP:setTitleColor(normal_color)
    _layBg.BTN_EQUIP:addTouchEventListener(onSwitch)
    -- 装备附魔
    _layBg.BTN_ENHANCE:setTag(_pageTag.tagEquipFM)       -- 默认装备按钮 强化
    _layBg.BTN_ENHANCE:setTitleText(m_i18n[5037])
    _layBg.BTN_ENHANCE:setTitleColor(normal_color)
    _layBg.BTN_ENHANCE:addTouchEventListener(onSwitch)
    --宝物强化
    _layBg.BTN_TREASURE:setTag(_pageTag.tagTreaQH)     -- 默认宝物按钮 强化
    _layBg.BTN_TREASURE:setTitleText(m_i18n[5002])
    _layBg.BTN_TREASURE:setTitleColor(normal_color)
    _layBg.BTN_TREASURE:addTouchEventListener(onSwitch)
    -- 宝物精炼
    _layBg.BTN_REFINE:setTag(_pageTag.tagTreaJL)       -- 默认装备按钮 强化
    _layBg.BTN_REFINE:setTitleText(m_i18n[5003])
    _layBg.BTN_REFINE:setTitleColor(normal_color)
    _layBg.BTN_REFINE:addTouchEventListener(onSwitch)
    --品级大师
    -- _switch_Score = m_fnGetWidget(_layBg , "BTN_SCORE")
    -- _switch_Score:setTag(_pageTag.tagScore)
    -- ttf = tolua.cast(_switch_Score:getTitleTTF(), "CCLabelTTF")
    -- ttf:setString(m_i18n[5023])
    -- ttf:setColor(normal_color)
    -- _switch_Score:addTouchEventListener(onSwitch)

end

function enterPage( index )

    if(index < 1) then
        index = _pageTag.tagEquipQH
    elseif (index >= 5) then
        index = _pageTag.tagEquipQH
    end

    -- 隐藏当前层
    if (_curLayer ~= nil) then
        _curLayer:setVisible(false)
        _curLayer:setEnabled(false)
        _curLayer = nil
    end

    _curPage = index
    if (_curBtn) then
        local normal_color = ccc3(0xbf, 0x93, 0x67)
        _curBtn:setFocused(false)
        _curBtn:setTouchEnabled(true)
        _curBtn:setTitleColor(normal_color)
        _curBtn = nil
    end
    
    if(_curPage == _pageTag.tagEquipQH) then 
        loadEquip()
        _curBtn = _layBg.BTN_EQUIP
    elseif (_curPage == _pageTag.tagEquipFM) then
        loadEquip()
        _curBtn = _layBg.BTN_ENHANCE
    elseif(_curPage == _pageTag.tagTreaQH) then
        loadTreasure()
        _curBtn = _layBg.BTN_TREASURE
    elseif (_curPage == _pageTag.tagTreaJL) then
        loadTreasure()
        _curBtn = _layBg.BTN_REFINE
    end
    if (_curBtn) then
        _curBtn:setFocused(true)
        _curBtn:setTouchEnabled(false)
        _curBtn:setTitleColor(ccc3(0xff, 0xff, 0xff))
    end
end

-- 创建页面主框架
local function createFrame( ... )
    local pBg = m_fnGetWidget(_layBg,"IMG_BG") 
    if(g_winSize.width ~= 640) then
        pBg:setScale(g_winSize.width/640)
    end
    _layBg.IMG_TAB:setScaleX(g_winSize.width /  640)
    -- _layBg.img_title_bg:setScaleX(g_winSize.width / 640)
    -- _layBg.img_title_bg:setScaleY(g_winSize.width / 640)

    UIHelper.labelAddNewStroke(_layBg.TFD_GET_INFO, m_i18n[5024], ccc3(0x00, 0x20, 0x68))

    fnInitButtons()

    if(not m_heroInfo) then
        return
    end

    if (_childrenLayer == nil or #_childrenLayer == 0) then
        -- 读取品级大师控件
        -- table.insert(_childrenLayer, MasterScoreView.create(_layBg, m_heroInfo, tonumber(m_curPageNum)))
        -- _childrenLayer[1]:setVisible(false)
        -- _childrenLayer[1]:setEnabled(false)
        -- 读取强化大师控件
        table.insert(_childrenLayer, MasterEquipAndTreasure.create(_layBg, m_heroInfo, tonumber(m_curPageNum)))
        _childrenLayer[1]:setVisible(false)
        _childrenLayer[1]:setEnabled(false)
    end
    _layBg.LAY_SCORE_GURU:setVisible(false)
    _layBg.LAY_SCORE_GURU:setTouchEnabled(false)
end

--强化大师
function create(_heroInfo , _curPageNum , _showTag)
    MainFormation.hideWidgetMain()
    destroy()
    fnGetAllStrOpenLv()


    m_heroInfo = _heroInfo or nil
    m_curPageNum = _curPageNum or 1
    
    _layBg = g_fnLoadUI(equipMaster)
   
    -- 隐藏跑马灯
    LayerManager.setPaomadeng(_layBg, -1)
    UIHelper.registExitAndEnterCall(_layBg, function ( ... )
        local changModuleType = LayerManager.getChangModuleType()
        if (changModuleType and changModuleType == 1) then
            logger:debug("MainEquipMasterView retainLayer")
            return
        end
        if(showNode) then
            showNode:removeFromParentAndCleanup(true)
            showNode = nil
        end
        LayerManager.resetPaomadeng()
        MainFormation.showWidgetMain()
        PlayerPanel.removeCurrentPanel()
        
        MasterScoreView.destroy()
        MasterEquipAndTreasure.destroy()
    end)

    -- 创建页面显示框架
    createFrame()

    -- 根据index进入页面
    enterPage(tonumber(_showTag) or _pageTag.tagEquipQH)

    return _layBg
end

--界面关闭的按键响应
function close( sender,eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playBackEffect()
      	LayerManager.removeLayout(_layBg)
        MainFormation.updateHeroEquipment(nil, nil, false)
    end
end
