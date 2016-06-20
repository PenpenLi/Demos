-- FileName: AwakeDrop.lua
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

AwakeDrop = class("AwakeDrop",EntireDrop)
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget  =  g_fnGetWidgetByName 
local m_i18n = gi18n


function AwakeDrop:ctor( ... )
    self.dropListBg = g_fnLoadUI("ui/property_guide.json")
    self:initBG()           -- 初始化背景
end

function AwakeDrop:create( awakeTid,returnCallfn )
	self.awakeTid = awakeTid
    -- 排掉不可显示的掉落模块
    if (self:exileModule()) then
        return nil
    end
	self:initAwakeTidDB()
    
    self.returnCallfn = returnCallfn

    self:createAwakeHeader()
    self:createFragListView()
    -- 返回回调
    -- self:insertDropReturnCallFn()

    return self.dropListBg
end

function AwakeDrop:insertDropReturnCallFn( ... )
    local curModuleName = LayerManager.curModuleName()
    DropUtil.insertCallFn(curModuleName,function ( ... )
        self:refreshOwnNum()
    end )
    if (self.returnCallfn) then
        DropUtil.insertCallFn(curModuleName,self.returnCallfn)
    end
end


function AwakeDrop:refreshOwnNum( ... )
    local dropListBg = self.dropListBg
    local layAwakeInfo = dropListBg.lay_awake_info
    local tfdOwnNum = layAwakeInfo.tfd_number        --  拥有数量
    self:initAwakeTidDB()
    tfdOwnNum:setText(self.fragOwnNum)
end

function AwakeDrop:initAwakeTidDB( ... )
    local awakeTid = self.awakeTid
    self.itemType = ItemUtil.getItemTypeByTid(awakeTid)
    local itemType = self.itemType
    if (itemType.isAwake) then                                            -- 装备碎片类
        self.AwakeDB = DB_Item_disillusion.getDataById(awakeTid)
        self.fragOwnNum = ItemUtil.getAwakeNumByTid(awakeTid)
        self.iconBg = "images/base/equip/small/" .. self.AwakeDB.icon_small
		local tbBasePro = {}
		local baseAttrFeild = self.AwakeDB.base_attr
		local tbBaseAttr = lua_string_split(baseAttrFeild, ",")
		for i,baseAttr in ipairs(tbBaseAttr) do
			local tbProperty = {}
			local tbAttr = lua_string_split(baseAttr, "|")
			local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(tbAttr[1]),tbAttr[2])
			tbProperty.name = baseInfo.displayName
			tbProperty.value = displayNum
			table.insert(tbBasePro,tbProperty)
		end
		self.tbBasePro = tbBasePro

    end
    
end

function AwakeDrop:createAwakeHeader( ... )
	-- 隐藏装备，伙伴碎片部分UI
    local dropListBg = self.dropListBg
	local layPropertyInfo = dropListBg.lay_property_info
	layPropertyInfo:setVisible(false)

    local layShadowInfo = dropListBg.lay_shadow_info
    layShadowInfo:setVisible(false)
	-- 碎片详细信息
	local layAwakeInfo = dropListBg.lay_awake_info 
    local tfdStuffName	=   layAwakeInfo.TFD_PROPERTY_NAME -- 碎片名字
    UIHelper.labelStroke(tfdStuffName)
    local stuffName = self.AwakeDB.name
    tfdStuffName:setText(stuffName)
    tfdStuffName:setColor(g_QulityColor[self.AwakeDB.quality])

	local tfdName= layAwakeInfo.tfd_name        --  已经拥有（文字）
	tfdName:setText(m_i18n[6907])
	local tfdOwnNum = layAwakeInfo.tfd_number       --  拥有数量
	tfdOwnNum:setText(self.fragOwnNum)
    -- 图标
    local stuffIcon =   layAwakeInfo.IMG_PROPERTY_ICON
	local icon = ItemUtil.createBtnByTemplateId(self.AwakeDB.id) 
	stuffIcon:addChild(icon)
	-- 基础属性
	local tbBasePro = self.tbBasePro 
	for i,basePro in ipairs(tbBasePro) do
		local attrName = layAwakeInfo["tfd_name" .. i]
		local attrValue = layAwakeInfo["tfd_num" .. i]
		attrName:setText(basePro.name)
		attrValue:setText("+" .. basePro.value )
	end 
end


function AwakeDrop:createFragListView(  )
    local GuidInfo = {}
    GuidInfo.guidStuffDB = self.AwakeDB
    self:createListView( self.dropListBg,GuidInfo,2,function ( ... )
        self:insertDropReturnCallFn()
    end)
end


