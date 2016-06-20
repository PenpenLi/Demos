-- FileName: EntireDrop.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

EntireDrop = class("EntireDrop",StuffDrop)
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n

function EntireDrop:ctor( ... )
    self.dropListBg = g_fnLoadUI("ui/property_guide.json")
    self:initBG()           -- 初始化背景
end

function EntireDrop:create( entireTid,returnCallfn )
	self.entireTid = entireTid
    -- 排掉不可显示的掉落模块
    if (self:exileModule()) then
        return nil
    end
	self:initDB()
    
    self.returnCallfn = returnCallfn

    self:createEntireHeader()

    local GuidInfo = {}
    GuidInfo.guidStuffDB = self.entireDB
    GuidInfo.stuffTid = self.entireTid

    self:createListView(self.dropListBg ,GuidInfo,1,function ( ... )
        self:insertDropReturnCallFn()
    end)
    -- 返回回调
    -- self:insertDropReturnCallFn()

    return self.dropListBg
end

function EntireDrop:insertDropReturnCallFn( ... )
    logger:debug("EntireDrop insertDropReturnCallFn")
    local curModuleName = LayerManager.curModuleName()
    --整体的不需要刷新数量
    -- DropUtil.insertCallFn(curModuleName,function ( ... )
    --     self:refreshNum()
    -- end )
    if (self.returnCallfn) then
        DropUtil.insertCallFn(curModuleName,self.returnCallfn)
    end
end


function EntireDrop:refreshNum( ... )
    self:initDB()
    
    local dropListBg = self.dropListBg
    local layShadowInfo = dropListBg.lay_shadow_info
    local tfdOwnNum = layShadowInfo.TFD_NUM        --  拥有数量
    local tfdCanRecruit = layShadowInfo.tfd_can_recruit  -- "/"
    local tfdHeroNeed = layShadowInfo.TFD_HERO_NAME  -- "分母"
    -- 计算返回后由于数量增加的返回量
    local deviationX = (self:chenkNumClass(self.fragOwnNum) - (self:chenkNumClass(formerNum))) * 8 
    tfdCanRecruit:setPosition(ccp(tfdCanRecruit:getPositionX() + deviationX * 2,tfdCanRecruit:getPositionY()))
    tfdHeroNeed:setPosition(ccp(tfdHeroNeed:getPositionX() + deviationX * 2,tfdHeroNeed:getPositionY()))
    tfdOwnNum:setPosition(ccp(tfdOwnNum:getPositionX() + deviationX,tfdOwnNum:getPositionY()))

    tfdOwnNum:setText(self.fragOwnNum)
end

function EntireDrop:initDB( ... )
    local entireTid = self.entireTid
    self.itemType = ItemUtil.getItemTypeByTid(entireTid)
    local itemType = self.itemType
    if (itemType.isTreasure) then                                            -- 饰品类
        self.entireDB = DB_Item_treasure.getDataById(entireTid)
        self.aptitude = self.entireDB.base_score
        -- self.fragOwnNum = TreasureData.getFragmentNum(fragTid)
        self.iconBg = "images/base/treas/small/" .. self.entireDB.icon_small
    end
    
end

function EntireDrop:createEntireHeader( ... )
	-- 隐藏装备，伙伴碎片部分UI
    local dropListBg = self.dropListBg
	local layPropertyInfo = dropListBg.lay_property_info
	layPropertyInfo:setVisible(false)
    local layAwakeInfo = dropListBg.lay_awake_info
    layAwakeInfo:setVisible(false)
	-- 碎片详细信息
    local layShadowInfo = dropListBg.lay_shadow_info 
    local tfdStuffName	=   layShadowInfo.TFD_SHADOW_NAME -- 物品名字
    UIHelper.labelStroke(tfdStuffName)
    local stuffName = self.entireDB.name
    tfdStuffName:setText(stuffName)
    tfdStuffName:setColor(g_QulityColor[self.entireDB.quality])

    local tfdStuff =  layShadowInfo.tfd_shadow  -- 影子（文字）
    tfdStuff:setEnabled(false)

    local imgTips =  layShadowInfo.img_tips  -- 碎片tip标示
    imgTips:setEnabled(false)
    
	local tfd_quality = layShadowInfo.tfd_quality  -- 资质（文字）
	local tfdQualityNum = layShadowInfo.TFD_QUALITY_NUM  -- 资质num
	tfdQualityNum:setText(self.aptitude)

	local layText= layShadowInfo.lay_txt        --  数量lay
	layText:setEnabled(false)

	local tfdNpGet = layShadowInfo.TFD_NP_GET        -- 该伙伴不可招募（文字）
	tfdNpGet:setEnabled(true)
    tfdNpGet:setText("无法合成")
	
    -- 图标
	local iconBag 	=   layShadowInfo.IMG_ICON_BG
    local iconBorder=   layShadowInfo.IMG_UP_BG
    local stuffIcon =   layShadowInfo.IMG_ICON

	iconBag:loadTexture("images/base/potential/color_".. self.entireDB.quality .. ".png")
    iconBorder:loadTexture("images/base/potential/officer_".. self.entireDB.quality .. ".png")
    stuffIcon:loadTexture(self.iconBg)
end


function EntireDrop:createListView( dropListBg,GuidInfo,copyType,dropCallFn)
    require "script/module/public/DropLVUtil"
    local dropLVUtil = DropLVUtil:new()
    dropLVUtil:create(dropListBg,GuidInfo,copyType,dropCallFn)

end
