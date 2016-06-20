-- FileName: PropertyDrop.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]
require "script/module/public/StuffDrop"

PropertyDrop = class("PropertyDrop",StuffDrop)
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n


-- UI控件引用变量 --

-- 模块局部变量 --

function PropertyDrop:ctor( ... )
    self:initMaps()
    self.dropListBg = g_fnLoadUI("ui/property_guide.json")
    self:initBG()           -- 初始化背景
end

function PropertyDrop:create( dropID,returnCallfn )
	self.entireTid = dropID
    self.returnCallfn = returnCallfn

    -- 排掉不可显示的掉落模块
    local isNeddCheckExile = true  -- 需要检查所有模块的id
    if (dropID == 60030 or dropID == 60031) then                             -- 宝物结晶,装备结晶
        logger:debug({dropID=dropID})
        isNeddCheckExile = false
    end

    if (isNeddCheckExile and self:exileModule()) then
        return nil
    end
	self:initPropertyDB()

	self:createHeader()     -- 设定背景表头
	self:createPropertyListView()   -- 初始化列表 

	return self.dropListBg
end


function PropertyDrop:insertDropReturnCallFn( ... )
    logger:debug("insertDropReturnCallFn")
    local curModuleName = LayerManager.curModuleName()
    if (self.returnCallfn) then
        DropUtil.insertCallFn(curModuleName,self.returnCallfn)
    end
end


function PropertyDrop:initPropertyDB( ... )
    local entireTid = self.entireTid
    self.itemType = ItemUtil.getItemTypeByTid(entireTid)
    local itemType = self.itemType
   
    if(itemType.isNormal) then    
        self.entireDB = DB_Item_normal.getDataById(entireTid)
        local dataArray = string.split(self.entireDB.item_getway, "|") or nil
        self.cellTypes = dataArray
    elseif(itemType.isShip) then                                             -- 主船
        self.entireDB = DB_Item_ship.getDataById(entireTid)
        local dataArray = string.split(self.entireDB.item_getway, "|") or nil
        self.cellTypes = dataArray
    end
    
end


function PropertyDrop:createHeader( ... )
	local dropListBg = self.dropListBg
    local layShadowInfo =  dropListBg.lay_shadow_info
    layShadowInfo:setVisible(false)
    local layAwakeInfo = dropListBg.lay_awake_info
    layAwakeInfo:setVisible(false)
    
	self.tfdProperName = dropListBg.TFD_PROPERTY_NAME
	self.tfdProperName:setText(self.entireDB.name)  --贝里  1520

	self.tfdInfo = dropListBg.tfd_info
	self.tfdInfo:setText(self.entireDB.desc)  -- 贝里描述

    self.imgPropertyBg = dropListBg.img_property_bg
    self.imgPropertyBg:loadTexture("images/base/potential/color_" .. self.entireDB.quality .. ".png")

	self.imgPropertyIcon = dropListBg.IMG_PROPERTY_ICON 
	self.imgPropertyIcon:loadTexture("images/base/props/" .. self.entireDB.icon_small)

    self.imgPropertyFrame = dropListBg.IMG_PROPERTY_FRAME
    self.imgPropertyFrame:loadTexture("images/base/potential/equip_" .. self.entireDB.quality .. ".png")

end

function PropertyDrop:createPropertyListView( )
    require "script/module/public/DropLVUtil"
    local dropLVUtil = DropLVUtil:new()
    local GuidInfo = {}
    GuidInfo.guidStuffDB = self.entireDB
    GuidInfo.stuffTid = self.entireTid
    dropLVUtil:create(self.dropListBg,GuidInfo,1,function ( ... )
        self:insertDropReturnCallFn()
    end)
end









