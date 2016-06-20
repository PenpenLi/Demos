-- FileName: SpecTreaDrop.lua
-- Author: sunyunpeng
-- Date: 2015-09-15
-- Purpose: function description of module
--[[TODO List]]

SpecTreaDrop = class("SpecTreaDrop")
local m_i18n = gi18n
local dropReturnInfo


-- UI控件引用变量 --

-- 模块局部变量 --

function SpecTreaDrop:ctor( ... )
	local layOut = g_fnLoadUI("ui/special_property.json")
	self.dropBg = layOut
end

function SpecTreaDrop:create( Tid,htid ,returnCallfn)
    self.returnCallfn = returnCallfn
	self:initBg()
	self:initTreaInfo(Tid,htid)  -- 基本信息 
	self:initTreaInfoHeader()                   
	self:initTreaAttr()
	self:initListView()
	return self.dropBg
end


function SpecTreaDrop:init( ... )
	self:initBg()
end

-- 初始化掉落信息背景
function SpecTreaDrop:initBg( ... )
	-- 关闭界面
	local btnClose = self.dropBg.BTN_CLOSE
	btnClose:addTouchEventListener(function ( ... )
		AudioHelper.playCloseEffect()
 		LayerManager.removeLayout(self.dropBg)
	end)
end


-- 输出化宝物DB信息
function SpecTreaDrop:initTreaDB( specialTreaTid )
	require "db/DB_Item_exclusive"
	self.specialTreaDB = DB_Item_exclusive.getDataById(specialTreaTid)

end

-- 插入回调函数
function SpecTreaDrop:insertDropReturnCallFn( ... )
    local curModuleName = LayerManager.curModuleName()
    if (self.returnCallfn) then
        DropUtil.insertCallFn(curModuleName,self.returnCallfn)
    end

    DropUtil.insertCallFn(curModuleName,function ( ... )
    	logger:debug("SpecTreaDrop_insertDropReturnCallFn")
    	-- 拥有数量
		local tfdOwnNum = self.dropBg.TFD_OWN_NUM
    	logger:debug(self.specialTreaDB.id)
	    local _,__,ownNum = SpecTreaModel.getSpecTreaNumByTid(nil,self.specialTreaDB.id)
    	logger:debug(ownNum)
		tfdOwnNum:setText(ownNum)   -- todo
    end )
end


-- 初始化宝物详细信息
function SpecTreaDrop:initTreaInfo( specialTreaTid ,htid)
	local m_i18nString = gi18nString
	self:initTreaDB( specialTreaTid )
	local treaFeild = self.specialTreaDB
	local fragIdInfoDB = lua_string_split(treaFeild.fragment, "|")
	self.treaFragDB = DB_Item_exclusive_fragment.getDataById(fragIdInfoDB[1])
	self.treaRefineLevel =  0
	require "script/module/specialTreasure/SpecTreaModel"
	self.treaAttrInfo = SpecTreaModel.fnGetTreaProperty(specialTreaTid, 0)
	local fragIdInfoDB = lua_string_split(treaFeild.fragment, "|")
	require "db/DB_Item_exclusive_fragment"
	self.treaFragDB = DB_Item_exclusive_fragment.getDataById(fragIdInfoDB[1])
	if (htid) then
		self.showHeroDB = DB_Heroes.getDataById(htid)
		local treaFeild = self.showHeroDB.treaureId
		logger:debug({SpecTreaDrop_initTreaInfo = self.showHeroDB})
		logger:debug({SpecTreaDrop_initTreaInfo = treaFeild})
		local tbTrea = lua_string_split(treaFeild,"|")
		local limitDes =  m_i18nString(6952,tbTrea[3])
		if (tonumber(tbTrea[2]) ~= 0) then
			self.showAwakeDB = DB_Awake_ability.getDataById(tonumber(tbTrea[2]))
			self.limitDes = self.showAwakeDB.des .. limitDes
		end
	end
end

-- 创建掉落信息标头信息
function SpecTreaDrop:initTreaInfoHeader( ... )
	local MainLayout = self.dropBg
	local layPropertyInfo = MainLayout.lay_property_info
	-- 宝物基础信息
	local treaDB = self.specialTreaDB
	-- 宝物名字
	local tfdTreaName= MainLayout.TFD_PROPERTY_NAME
	tfdTreaName:setText(treaDB.name)
	tfdTreaName:setColor(g_QulityColor2[treaDB.quality])
	-- 宝物图标
	local itemInfo = MainLayout.LAY_ITEM
	local szIcon = itemInfo:getSize()
	local btnIcon = ItemUtil.createBtnByTemplateId(treaDB.id)
	btnIcon:setPosition(ccp(szIcon.width/2, szIcon.height/2))
	itemInfo:addChild(btnIcon)
	-- 已拥有
	local tfdOwn = MainLayout.tfd_own
	tfdOwn:setText(m_i18n[6907])-- todo
	-- 拥有数量
	local tfdOwnNum = MainLayout.TFD_OWN_NUM
	local _,__,ownNum = SpecTreaModel.getSpecTreaNumByTid(nil,treaDB.id)
	tfdOwnNum:setText(ownNum)   -- todo
	-- 宝物品级
	local tfdPinji = MainLayout.tfd_pinji
	tfdPinji:setText(m_i18n[1675])
	tfdPinji:setColor(g_QulityColor3[treaDB.quality])
	-- 品级数字
	local tfdPinjiNum = MainLayout.TFD_PINJI_NUM
	tfdPinjiNum:setText(treaDB.base_score)
	tfdPinjiNum:setColor(g_QulityColor3[treaDB.quality])
end

-- 创建掉落信息
function SpecTreaDrop:initTreaAttr( ... )
	local MainLayout = self.dropBg
	local treaDB = self.specialTreaDB
	-- 宝物描述
	local TFD_INFO = MainLayout.TFD_INFO
	TFD_INFO:setText( self.limitDes or treaDB.info)

	local treaRefineLevel = self.treaRefineLevel
	local treaAttrInfo = self.treaAttrInfo

	-- local tfdAttrNameTb = {"生命:","物攻:","魔攻:","物防:","魔防:"}
	for i=1,5 do
		local WidgtName = "TFD_ATTR_NAME" .. i
		local WidgtNum = "TFD_ATTR_NUM" .. i

		local attrItemInfo = treaAttrInfo[i]
		local tfdAttrName = MainLayout[WidgtName]
		tfdAttrName:setText(attrItemInfo.name)
		local tfdAttrNum = MainLayout[WidgtNum]
		tfdAttrNum:setText("+" .. attrItemInfo.value)
	end

end

-- 创建掉落引导列表
function SpecTreaDrop:initListView( ... )
	local MainLayout = self.dropBg
	local getWayBg = MainLayout.img_get_way_bg
	-- 获取途径TitleDDB_item_eex
	local tfdTitle = MainLayout.tfd_title
	tfdTitle:setText(m_i18n[1098])

	local dropLVUtil = DropLVUtil:new()
    local GuidInfo = {}
    GuidInfo.guidStuffDB = self.treaFragDB
    GuidInfo.stuffTid = self.specialTreaDB.id
    dropLVUtil:create(self.dropBg,GuidInfo,1,function ( ... )
        self:insertDropReturnCallFn()
    end)

	-- -- 获取途径列表
	-- self.mListView = getWayBg.LSV_LIST
 --    UIHelper.initListView(self.mListView) 
 --    local cellIndex = 0
 --   	-- 探索
 --   	local cellIndex = self:createExplor(cellIndex)
 --   	-- 宝物商店
 --   	local cellIndex = self:creatOtherGetway(cellIndex)
end










