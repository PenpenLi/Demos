-- FileName: FragmentDrop.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]
require "db/DB_Item_fragment"
require "db/DB_Copy"
require "db/DB_Elitecopy"
require "db/DB_Stronghold"
require "script/module/copy/MainCopy"
require "script/module/copy/battleMonster"
require "script/model/hero/HeroModel"
require "script/module/public/UIHelper"
require "script/module/config/AudioHelper"
require "script/module/switch/SwitchModel"
require "script/module/public/StuffDrop"
require "script/module/public/EntireDrop"

FragmentDrop = class("FragmentDrop",EntireDrop)
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget  =  g_fnGetWidgetByName 
local m_i18n = gi18n


function FragmentDrop:create( FragTid,returnCallfn )
	self.fragTid = FragTid
    -- 排掉不可显示的掉落模块
    if (self:exileModule()) then
        return nil
    end
	self:initFragDB()
    
    self.returnCallfn = returnCallfn

    self:createFragHeader()
    self:createFragListView(  )
    -- 返回回调
    -- self:insertDropReturnCallFn()

    return self.dropListBg
end

function FragmentDrop:insertDropReturnCallFn( ... )
    local curModuleName = LayerManager.curModuleName()
    DropUtil.insertCallFn(curModuleName,function ( ... )
        self:refreshOwnFragNum()
    end )
    if (self.returnCallfn) then
        DropUtil.insertCallFn(curModuleName,self.returnCallfn)
    end
end


function FragmentDrop:refreshOwnFragNum( ... )
    self:initFragDB()
    
    local dropListBg = self.dropListBg
    local layShadowInfo = dropListBg.lay_shadow_info
    local tfdCanRecruit = layShadowInfo.tfd_can_recruit  -- "/"
    local tfdHeroNeed = layShadowInfo.TFD_HERO_NAME  -- "分母"

    local tfdOwnNum = layShadowInfo.TFD_NUM        --  拥有数量
    local formerNum = tonumber(tfdOwnNum:getStringValue())
    logger:debug({formerNum = formerNum})
    logger:debug({formerNum = self.fragOwnNum})
    -- 检查 是几位数数字
    local deviationX = (self:chenkNumClass(tonumber(self.fragOwnNum)) - (self:chenkNumClass(formerNum))) * 8
    logger:debug({deviationX = deviationX}) 
    tfdCanRecruit:setPosition(ccp(tfdCanRecruit:getPositionX() + deviationX * 2,tfdCanRecruit:getPositionY()))
    tfdHeroNeed:setPosition(ccp(tfdHeroNeed:getPositionX() + deviationX * 2,tfdHeroNeed:getPositionY()))
    tfdOwnNum:setPosition(ccp(tfdOwnNum:getPositionX() + deviationX,tfdOwnNum:getPositionY()))

    tfdOwnNum:setText(tonumber(self.fragOwnNum))
end

function FragmentDrop:initFragDB( ... )
    -- self.itemType = ItemUtil.getItemTypeByTid(entireTid)
    local fragTid = self.fragTid
    self.itemType = ItemUtil.getItemTypeByTid(fragTid)
    local itemType = self.itemType
    if (itemType.isFragment) then                                            -- 装备碎片类
        self.fragDB = DB_Item_fragment.getDataById(fragTid)
        self.entireTid = self.fragDB.aimItem
        self.entireDB = DB_Item_arm.getDataById(self.entireTid)
        self.aptitude = self.entireDB.base_score
        self.fragOwnNum = DataCache.getEquipFragNumByItemTmpid(fragTid)
        self.iconBg = "images/base/equip/small/" .. self.fragDB.icon_small

    elseif(itemType.isShadow) then                                           -- 武将碎片类
        self.fragDB = DB_Item_hero_fragment.getDataById(fragTid)
        self.entireTid = self.fragDB.aimItem
        self.entireDB = DB_Heroes.getDataById(self.entireTid)
        self.aptitude = self.entireDB.heroQuality
        self.fragOwnNum = DataCache.getHeroFragNumByItemTmpid(fragTid)
        self.iconBg = "images/base/hero/head_icon/" .. self.fragDB.icon_small

    elseif(itemType.isTreasureFragment) then                                 -- 宝物碎片
        self.fragDB = DB_Item_treasure_fragment.getDataById(fragTid)
        self.entireTid = self.fragDB.treasureId
        self.entireDB = DB_Item_treasure.getDataById(self.entireTid)
        self.aptitude = self.entireDB.base_score
        self.fragOwnNum = TreasureData.getFragmentNum(fragTid)
        self.iconBg = "images/base/treas/small/" .. self.fragDB.icon_small

    elseif(itemType.isSpeTreasureFragment) then                              -- 专属宝物碎片
        self.fragDB = DB_Item_exclusive_fragment.getDataById(fragTid)
        self.entireTid = self.fragDB.treasureId
        self.entireDB = DB_Item_exclusive.getDataById(self.entireTid)
        self.aptitude = self.entireDB.base_score
        require "script/module/specialBag/SBListModel"
        self.fragOwnNum = SBListModel.getFragNumAndMaxByTid(fragTid)
        self.iconBg = "images/base/exclusive/small/" .. self.fragDB.icon_small
    end
    
end

function FragmentDrop:createFragHeader( ... )
	-- 隐藏装备，伙伴碎片部分UI
    local dropListBg = self.dropListBg
	local layPropertyInfo = dropListBg.lay_property_info
	layPropertyInfo:setVisible(false)

    local layAwakeInfo = dropListBg.lay_awake_info
    layAwakeInfo:setVisible(false)
    
	-- 碎片详细信息
	local layShadowInfo = dropListBg.lay_shadow_info 
    local tfdStuffName	=   layShadowInfo.TFD_SHADOW_NAME -- 碎片名字
    UIHelper.labelStroke(tfdStuffName)
    local stuffName = self.fragDB.name
    tfdStuffName:setText(stuffName)
    tfdStuffName:setColor(g_QulityColor[self.fragDB.quality])

    local tfdStuff =  layShadowInfo.tfd_shadow  -- 影子（文字）
    local itemType = self.itemType
    if (itemType.isShadow) then
        tfdStuff:setText(m_i18n[1002])
    else
        tfdStuff:setText(m_i18n[2448])
    end
    tfdStuff:setColor(g_QulityColor[self.fragDB.quality])

	local tfd_quality = layShadowInfo.tfd_quality  -- 资质（文字）
	local tfdQualityNum = layShadowInfo.TFD_QUALITY_NUM  -- 资质num
	tfdQualityNum:setText(self.aptitude)

	local layText= layShadowInfo.lay_txt        --  数量lay
	local tfdGet= layShadowInfo.tfd_get        --  数量（文字）
	local tfdOwnNum = layShadowInfo.TFD_NUM       --  拥有数量
	tfdOwnNum:setText(self.fragOwnNum)
	local tfdNeedNum = layShadowInfo.TFD_HERO_NAME  --  招募需要的数量
    local itemType  = self.itemType 
    if (itemType.isTreasureFragment) then
        require "script/module/grabTreasure/TreasureData"
        tfdNeedNum:setText(TreasureData.getCompondNumByFragId(self.fragTid))
    else  
        tfdNeedNum:setText(self.fragDB.need_part_num)
    end

	local tfdNpGet = layShadowInfo.TFD_NP_GET        -- 该伙伴不可招募（文字）
	-- 是否可招募
    local isCompose =   self.fragDB.is_compose
    local pExp = tonumber(self.fragDB.isExp) or 0
    if  (pExp == 1 or tonumber(isCompose) == 0) then 
        layText:setEnabled(false)
        tfdNpGet:setEnabled(true)
        tfdNpGet:setText(m_i18n[1100])
    else 
        layText:setEnabled(true)
        tfdNpGet:setEnabled(false)
    end

    -- 图标
	local iconBag 	=   layShadowInfo.IMG_ICON_BG
    local iconBorder=   layShadowInfo.IMG_UP_BG
    local stuffIcon =   layShadowInfo.IMG_ICON

	iconBag:loadTexture("images/base/potential/color_".. self.fragDB.quality .. ".png")
    iconBorder:loadTexture("images/base/potential/officer_".. self.fragDB.quality .. ".png")
    stuffIcon:loadTexture(self.iconBg)
end

function FragmentDrop:createFragListView( )
    local GuidInfo = {}
    GuidInfo.guidStuffDB = self.fragDB
    GuidInfo.stuffTid = self.fragTid
    self:createListView( self.dropListBg,GuidInfo,1,function ( ... )
        self:insertDropReturnCallFn()
    end)
end

