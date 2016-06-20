-- FileName: EquipInfoViewNew.lua
-- Author: zhangqi
-- Date: 2015-04-17
-- Purpose: 新装备信息面板的UI模块
--[[TODO List]]

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

local m_tbSubType = ItemUtil.getEquipSubTypeTable()

local m_strokeColor = ccc3(0x28, 0x00, 0x00)
local m_shadowColor = ccc3(0x00, 0x00, 0x00)
local m_c3Unlock = ccc3(0x00, 0x89, 0x00) -- 激活属性值的颜色

local m_qualityName = { m_i18n[1668], m_i18n[1669], m_i18n[1670], m_i18n[1671], m_i18n[1672], m_i18n[1673],}
local m_typeText = {1664, 1665, 1666, 1667,1680}

local tbShowBtn = {false, true, true, true, true} -- index 对应入口类型，true 表示只显示确定按钮

local m_nLsvItemCount = 4 -- 默认的属性列表的item数量

local m_strokeColor2 = ccc3(0x92,0x53,0x1b)

EquipInfoViewNew = class("EquipInfoViewNew")

function EquipInfoViewNew:ctor( ... )
	self.layMain = g_fnLoadUI("ui/equip_taozhuang_info.json")
end

function EquipInfoViewNew:create( nCreateType, tbEquipInfo, tbBtnEvent, isDrawTip )
	self.tbInfo = tbEquipInfo
	self.tbEvent = tbBtnEvent
	self.createType = nCreateType
	self._isChangeBtnTip = isDrawTip or false	-- add by yucong 更换按钮的红点显示

	self:initBase()

	self:initAttrList()

	self:initButton()

	return self.layMain
end

function EquipInfoViewNew:initBase( ... )
	local tbInfo = self.tbInfo
	local layBase = m_fnGetWidget(self.layMain, "LAY_NOSCV")

	local imgBg = m_fnGetWidget(self.layMain, "img_bg") -- 背景图，需要拉伸满足适配
	imgBg:setScale(g_fScaleX)

	local btnClose = m_fnGetWidget(layBase, "BTN_CLOSE") -- 返回按钮
	btnClose:addTouchEventListener(UIHelper.onBack)
	UIHelper.titleShadow(btnClose, m_i18n[1019])

	local imgArm = m_fnGetWidget(layBase, "IMG_ARM") -- 装备图片
	imgArm:loadTexture(tbInfo.armPath)
	if(imgArm)then 
		UIHelper.runFloatAction(imgArm)   --添加装备上下浮动效果
	end 

	local qualityColor2 = g_QulityColor2[tbInfo.nQuality] -- 品质色值
	-- zhangqi, 2015-06-30, 品质名称改为 IMG_QUALITY
	local imgQualityName = m_fnGetWidget(layBase, "IMG_QUALITY") -- 品质名称
	imgQualityName:loadTexture(g_QulityImageIndex[tbInfo.nQuality])

	local colorPinJi = g_QulityColor3[tbInfo.nQuality] -- 品质色值
	local i18n_pinji = m_fnGetWidget(layBase, "TFD_PINJI_TXT") -- 品级
	i18n_pinji:setText(m_i18n[1675])
	i18n_pinji:setColor(colorPinJi)

	local labPinji = m_fnGetWidget(layBase, "TFD_PINJI") -- 品级数值
	labPinji:setText(tbInfo.sScore)
	labPinji:setColor(colorPinJi)

	local labName = m_fnGetWidget(self.layMain, "TFD_NAME1") -- 装备名称
	self:setSpecialText(labName, {text = tbInfo.name, color = qualityColor2, bStroke = true})

	local labEnhanceLv = m_fnGetWidget(self.layMain, "TFD_ENHANCE_LV") -- 当前附魔等级
	if (tbInfo.bCanEnhant and tbInfo.sCurEnhanceLv) then
		self:setSpecialText(labEnhanceLv, {text = tbInfo.sCurEnhanceLv, color = qualityColor2, bStroke = true})
	else
		labEnhanceLv:setEnabled(false)
	end

	self.lsvMain = m_fnGetWidget(self.layMain, "LSV_MAIN") -- 属性列表
	self.layBaseInfo = m_fnGetWidget(self.lsvMain, "LAY_BASE_INFO") -- 基本属性Cell，装备附魔解锁等级为0才显示
	self.layAttr = m_fnGetWidget(self.lsvMain, "LAY_STR_INFO") -- 强化属性Cell
	self.layAttr:setTag(0)
	self.layEnhance = m_fnGetWidget(self.lsvMain, "LAY_ENHANCE_INFO") -- 附魔属性Cell
	self.layEnhanceAvility = m_fnGetWidget(self.lsvMain, "LAY_ENHANCE_ABILITY") -- 附魔能力属性cell
	self.layEnhance:setTag(1)
	self:getWidgetOfEnhance()
	self.laySuit = m_fnGetWidget(self.lsvMain, "LAY_TAOZHUANG") -- 套装信息Cell
	self.laySuit:setTag(2)
	self.layDesc = m_fnGetWidget(self.lsvMain, "LAY_DESC") -- 装备介绍
	self.layDesc:setTag(3)

	local layBtn = m_fnGetWidget(self.layMain, "LAY_BTNS") -- 底部按钮
	self.btnUnload = m_fnGetWidget(layBtn, "BTN_UNLOAD") -- 卸下按钮
	self.btnChange = m_fnGetWidget(layBtn, "BTN_CHANGE") -- 更换按钮
	self.btnOk = m_fnGetWidget(layBtn, "BTN_BACK") -- 确定按钮
end

function EquipInfoViewNew:getWidgetOfEnhance( ... )
	self.tbEnhanceWidget = {}
	local tbWidgetName = {"tfd_enhance_title", "TFD_ENHANCELV", "TFD_ENHANCE_LVNUM","TFD_ATTR3", "TFD_ATTR3_NUM", 
							"TFD_ATTR4", "TFD_ATTR4_NUM", "TFD_ATTR5", "TFD_ATTR5_NUM",
							"BTN_XILIAN", "TFD_EXP", "TFD_EXP_NUM"}
	for _, name in ipairs(tbWidgetName) do
		self.tbEnhanceWidget[name] = m_fnGetWidget(self.layEnhance, name)
	end
end

function EquipInfoViewNew:initAttrList( ... )
	local tbInfo = self.tbInfo

	if (tbInfo.nSubType == m_tbSubType.EXP) then
		self:initExpAttr() -- 初始化经验装备
	else
		self:initNormalAttr() -- 一般装备
	end

	-- 装备介绍
	-- self.layDesc = m_fnGetWidget(self.lsvMain, "LAY_DESC") -- 装备介绍
	local i18n_desc_title = m_fnGetWidget(self.layDesc, "tfd_desc_title") -- "简 介"
	UIHelper.labelAddNewStroke(i18n_desc_title, m_i18n[1677], m_strokeColor2)
	local labDesc = m_fnGetWidget(self.layDesc, "TFD_DES")
	labDesc:setText(self.tbInfo.sDesc)
end

-- 初始化一般装备属性
function EquipInfoViewNew:initNormalAttr( ... )
	local tbInfo = self.tbInfo

	self:initEnhanceBase() -- 附魔基础属性，2016-01-20

	self:initStrengthAttr() -- 初始化强化属性
	
	self:initEnhanceAttr() -- 初始化附魔属性

	self:initEnhanceAbility() -- 附魔能力属性，2016-01-20
	
	self:initSuitAttr() -- 如果是套装初始化套装属性
end

-- 初始化附魔基础属性
function EquipInfoViewNew:initEnhanceBase( ... )
	local tbInfo = self.tbInfo
	if (tbInfo.m_tbEnchanBase) then
		logger:debug({m_tbEnchanBase = tbInfo.m_tbEnchanBase})
		-- tfd_attr, TFD_ATTR1, TFD_ATTR1_NUM
		local labTitle = m_fnGetWidget(self.layBaseInfo, "tfd_attr")
		UIHelper.labelAddNewStroke(labTitle, m_i18n[1113], m_strokeColor2)
		local labAttr = m_fnGetWidget(self.layBaseInfo, "TFD_ATTR1")
		labAttr:setText(tbInfo.m_tbEnchanBase[1].descName)
		local labValue = m_fnGetWidget(self.layBaseInfo, "TFD_ATTR1_NUM")
		labValue:setText(tbInfo.m_tbEnchanBase[1].descString)
		labValue:setColor(m_c3Unlock)
	else
		self.lsvMain:removeItem(self.lsvMain:getIndex(self.layBaseInfo))
	end
end

function EquipInfoViewNew:initEnhanceAbility( ... )
	local tbInfo = self.tbInfo
	
	if (tbInfo.m_tbEnchanBility) then
		-- logger:debug({m_tbEnchanBility = tbInfo.m_tbEnchanBility})
		local tbBility = tbInfo.m_tbEnchanBility

		local labTitle = m_fnGetWidget(self.layEnhanceAvility, "tfd_enhance_title")
		UIHelper.labelAddNewStroke(labTitle, m_i18n[1682], m_strokeColor2)

		local cdAttrDef -- 记录属性label的默认颜色，便于后续使用

		-- 设置每条属性的内容样式和位置
		local function setAttrLabel( layAttr, tbAttr, lastLayout, pH )
			local labName = m_fnGetWidget(layAttr, "TFD_ATTR3")
			labName:setText(tbAttr.descName)
			local labValue = m_fnGetWidget(layAttr, "TFD_ATTR3_NUM")
			labValue:setText(tbAttr.descString)
			local labDesc = m_fnGetWidget(layAttr, "TFD_ATTR3_NUM_0")
			local fmtDesc = "(" .. m_i18n[1603] .. m_i18n[1141] .. ")" -- [1603] = "附魔", [1141] = "%s级解锁",
			labDesc:setText(string.format(fmtDesc, tostring(tbAttr.baseLv)))

			local c3color = tbAttr.bUnlock and m_c3Unlock or cdAttrDef
			labName:setColor(c3color)
			labValue:setColor(c3color)
			labDesc:setColor(c3color)

			if (lastLayout) then -- 如果存在上一条属性的layout，才进行位置的设置
				local x, y = layAttr:getPosition() -- 上一条属性的位置信息
				layAttr:setPosition(ccp(x, y - pH)) -- 在上一条位置上再减去1条属性的高度
			end

		end

		-- 排列所有附魔能力属性
		local tbLayout = {} -- 存放第一条默认属性的layout和所有复制出来的
		tbLayout[1] = m_fnGetWidget(self.layEnhanceAvility, "LAY_ABILITY1") -- 默认自带的1条附魔能力属性
		local szAttr = tbLayout[1]:getSize()

		local layTemp = tbLayout[1]:clone() -- 临时复制layout，取子控件Label的默认颜色，因为直接获取会随控件的颜色改变而改变
		local labName = m_fnGetWidget(layTemp, "TFD_ATTR3")
		cdAttrDef = labName:getColor()

		local imgBg = m_fnGetWidget(self.layEnhanceAvility, "IMG_ENHANCE_PAPER_BG")

		for i, attr in ipairs(tbBility) do
			if (tbLayout[i-1]) then
				tbLayout[i] = tbLayout[i-1]:clone()
				imgBg:addChild(tbLayout[i])
			end

			setAttrLabel(tbLayout[i], attr, tbLayout[i-1], szAttr.height)
		end

		-- 重新计算和设置Cell的高度
		local szlayEA = self.layEnhanceAvility:getSize()
		szlayEA.height = szlayEA.height + (#tbBility - 1) * szAttr.height
		self.layEnhanceAvility:setSize(szlayEA)
	else
		self.lsvMain:removeItem(self.lsvMain:getIndex(self.layEnhanceAvility))
	end
end

-- 初始化强化属性
function EquipInfoViewNew:initStrengthAttr( ... )
	local tbInfo = self.tbInfo
	local layAttr = self.layAttr

	local i18n_title = m_fnGetWidget(layAttr, "tfd_attr") -- "强化属性"
	UIHelper.labelAddNewStroke(i18n_title, m_i18n[1679], m_strokeColor2)

	local i18n_lv = m_fnGetWidget(layAttr, "TFD_LV") -- "等级："
	i18n_lv:setText(m_i18n[1067])
	local labLevel = m_fnGetWidget(layAttr, "TFD_LV_NUM") -- "15/18"
	labLevel:setText(tbInfo.sLv)

	local i18n_attr1 = m_fnGetWidget(layAttr, "TFD_ATTR1") -- "生命："
	i18n_attr1:setText(tbInfo.m_tbAttr[1] and tbInfo.m_tbAttr[1].descName or "")
	local labAttr1 = m_fnGetWidget(layAttr, "TFD_ATTR1_NUM") -- "+1200"
	labAttr1:setText(tbInfo.m_tbAttr[1] and tbInfo.m_tbAttr[1].descString or "")

	local i18n_attr2 = m_fnGetWidget(layAttr, "TFD_ATTR2") -- "物攻："
	i18n_attr2:setText(tbInfo.m_tbAttr[2] and tbInfo.m_tbAttr[2].descName or "")
	local labAttr2 = m_fnGetWidget(layAttr, "TFD_ATTR2_NUM") -- "+1200"
	labAttr2:setText(tbInfo.m_tbAttr[2] and tbInfo.m_tbAttr[2].descString or "")

	local btnStrength = m_fnGetWidget(layAttr, "BTN_STRENGTHEN") -- 强化按钮

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideEquipView"
	

	local scene = CCDirector:sharedDirector():getRunningScene()
    performWithDelay(scene, function(...)
     	if (GuideModel.getGuideClass() == ksGuideSmithy and GuideEquipView.guideStep == 4) then
			require "script/module/guide/GuideCtrl"
			self.lsvMain:setTouchEnabled(false)
			local pos = btnStrength:getWorldPosition()
			GuideCtrl.createEquipGuide(5, 0, pos)
		end
    end, 0.05)


	if (self.tbEvent.onReinforce) then
		UIHelper.titleShadow(btnStrength, m_i18n[1007])
		btnStrength:addTouchEventListener(self.tbEvent.onReinforce)
	else
		btnStrength:setEnabled(false) -- 如果是查看他人装备不显示强化按钮
	end
end

-- 初始化附魔属性
function EquipInfoViewNew:initEnhanceAttr( ... )
	local tbInfo = self.tbInfo

	if (not tbInfo.bCanEnhant) then
		self.lsvMain:removeItem(self.layEnhance:getTag() - (m_nLsvItemCount - self.lsvMain:getChildrenCount()))
		return
	end

	local widgets = self.tbEnhanceWidget
	UIHelper.labelAddNewStroke(widgets["tfd_enhance_title"], m_i18n[1676], m_strokeColor2)

	-- 隐藏经验属性
	local tbShow = {["BTN_XILIAN"] = false, ["TFD_EXP"] = true, ["TFD_EXP_NUM"] = true}
	for name, widget in pairs(widgets) do
		if (tbShow[name]) then
			widget:setEnabled(false)
		end
	end

	widgets["TFD_ENHANCELV"]:setText(m_i18n[1067])
	widgets["TFD_ENHANCE_LVNUM"]:setText(tbInfo.sEnhanceLv)

	-- zhangqi, 2015-12-26
	local tbLabel = {} -- 按名称存放显示属性的label，便于循环访问
	local idx = 1
	for i = 3, 5 do
		local lab = {}
		lab.attr = widgets["TFD_ATTR" .. i]
		lab.num = widgets["TFD_ATTR" .. i .. "_NUM"]
		tbLabel[#tbLabel + 1] = lab
	end

	-- 根据配置的实际附魔属性个数显示相关内容
	for i, attr in ipairs(tbInfo.m_tbEnchantAttr) do
		tbLabel[i].attr:setText(attr.descName)
		tbLabel[i].num:setText(attr.descString)
	end

	-- 处理属性个数不足3个的情况，隐藏用不到的label控件
	for i = #tbInfo.m_tbEnchantAttr + 1, #tbLabel do
		logger:debug("m_tbEnchantAttr i = " .. i)
		tbLabel[i].attr:setEnabled(false)
		tbLabel[i].num:setEnabled(false)
	end

	local btn = widgets["BTN_XILIAN"]
	if (self.tbEvent.onXilian) then
		UIHelper.titleShadow(btn, m_i18n[1639])
		btn:addTouchEventListener(self.tbEvent.onXilian)
	else
		btn:setEnabled(false)
	end
end

-- 初始化经验装备属性
function EquipInfoViewNew:initExpAttr( ... )
	self.lsvMain:removeItem(self.layAttr:getTag() - (m_nLsvItemCount - self.lsvMain:getChildrenCount()))
	self.lsvMain:removeItem(self.laySuit:getTag() - (m_nLsvItemCount - self.lsvMain:getChildrenCount()))

	local widgets = self.tbEnhanceWidget
	UIHelper.labelAddNewStroke(widgets["tfd_enhance_title"], m_i18n[1676], m_strokeColor2)

	-- 隐藏附魔属性
	local tbShow = {["BTN_XILIAN"] = true, ["TFD_EXP"] = true, ["TFD_EXP_NUM"] = true, ["tfd_enhance_title"] = true}
	for name, widget in pairs(widgets) do
		if (not tbShow[name]) then
			widget:setEnabled(false)
		end
	end

	local btn = widgets["BTN_XILIAN"]
	if (self.tbInfo.onXiLian) then
		UIHelper.titleShadow(btn, m_i18n[1639])
		btn:addTouchEventListener(self.tbInfo.onXiLian) -- 附魔按钮
	else
		btn:setEnabled(false)
	end
	widgets["TFD_EXP"]:setText(m_i18n[1746])
	widgets["TFD_EXP_NUM"]:setText("+" .. self.tbInfo.sMagicExp) -- "+1000"
end

-- 初始化套装属性
function EquipInfoViewNew:initSuitAttr( ... )
	local tbInfo = self.tbInfo

	if (not tbInfo.suit) then
		self.lsvMain:removeItem(self.laySuit:getTag() - (m_nLsvItemCount - self.lsvMain:getChildrenCount()))
		return -- 不是套装删除cell后返回
	end

	local qualityColor = g_QulityColor

	local tbSuit = tbInfo.suit
	local laySuit = self.laySuit

	local i18n_title = m_fnGetWidget(laySuit, "tfd_suit_title")
	UIHelper.labelAddNewStroke(i18n_title, m_i18n[1678], m_strokeColor2)

	local labName = m_fnGetWidget(laySuit, "TFD_TAOZHUANG_NAME") -- 名称
	labName:setText(tbSuit.name)
	labName:setColor(qualityColor[tbInfo.nQuality])

	for i, id in ipairs(tbSuit.ids) do -- 套装图标
		local layIcon = m_fnGetWidget(laySuit, "LAY_EQUIP_ICON" .. i) -- icon
		local szIcon = layIcon:getSize()

		local icon, equip = ItemUtil.createBtnByTemplateId(tonumber(id),function ( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				local tempArmIno = {}
				local ArmDb = DB_Item_arm.getDataById(id)

				tempArmIno.item_template_id = ArmDb.fragmentId
				require "script/module/equipment/MainEquipmentCtrl"
			 	if (ArmDb.fragmentId) then
					PublicInfoCtrl.createItemDropInfoViewByTid(ArmDb.fragmentId)
					-- local tbEquiptInfo = MainEquipmentCtrl.getArmFragDataByValue(tempArmIno)
					-- tbEquiptInfo.curNum = MainEquipmentCtrl.getFragmentNumByTID(tempArmIno.item_template_id)
					-- local tArgs={selectEquip = tbEquiptInfo}
					-- require "script/module/public/FragmentDrop"
					-- local fragmentDrop = FragmentDrop:new()
					-- local FragmentDropLayer = fragmentDrop:create(ArmDb.fragmentId)
					-- LayerManager.addLayout(FragmentDropLayer)
		   --  	else
		    	end
		    end
		end) -- 获取装备详细信息
		icon:setPosition(ccp(szIcon.width/2, szIcon.height/2))
		layIcon:addChild(icon)

		if (tbSuit.gray[id]) then
			UIHelper.setWidgetGray(icon, true)
			logger:debug("gray: " .. id)
		end

		local labName = m_fnGetWidget(laySuit, "TFD_EQUIP" .. i) -- 名称
		labName:setColor(qualityColor[equip.quality])
		labName:setText(equip.name)
	end

	self:initSuitAttrPanel(tbSuit)
end

-- 初始化套装属性值
function EquipInfoViewNew:initSuitAttrPanel( tbSuit )
	logger:debug({initSuitAttrPanel_tbSuit = tbSuit})

	local hasCount = tbSuit.hasCount
	local tbAttr = tbSuit.tbAttr

	local layAttr = m_fnGetWidget(self.laySuit, "LAY_EQUIP_ATTR")

	-- zhangqi, 2015-10-21, 隐藏指定的套装激活属性，依赖UI控件名称
	local function hideAttrWithIndex( layout, idx )
		local words = {"", "two", "three", "four"}
		idx = tonumber(idx)
		local arrChildren = layout["img_" .. words[idx] .. "_attrbg"]:getChildren()
		for node in array_iter(arrChildren) do
			local widget = tolua.cast(node, "Widget")
			if (string.find(widget:getName(), "TFD_EQUIP")) then
				widget:setEnabled(false)
			end
		end
	end

	-- [1635] = "装备2件：", [1636] = "装备3件：",[1637] = "装备4件：",
	for k, lock in pairs(tbAttr) do
		local layLock = m_fnGetWidget(layAttr, "LAY_EQUIP" .. k)
		hideAttrWithIndex(layLock, k) -- 2015-10-21，先隐藏所有属性，后面再显示实际有值的内容
		local labTitle = m_fnGetWidget(layLock, "TFD_EQUIP_" .. k)
		labTitle:setText(m_i18nString(1635, k))
		if (k <= hasCount) then
			labTitle:setColor(m_c3Unlock)
		end

		for idx, attr in pairs(lock) do
			local labName = m_fnGetWidget(layLock, "TFD_EQUIP" .. k .. "_ATTR" .. idx)
			labName:setEnabled(true)
			labName:setText(attr.descName)
			
			local labVal = m_fnGetWidget(layLock, "TFD_EQUIP" .. k .. "_ATTR" .. idx .. "_NUM")
			labVal:setEnabled(true)
			labVal:setText(attr.descString)
			if (k <= hasCount) then -- 当前已解锁的套装
				labName:setColor(m_c3Unlock)
				labVal:setColor(m_c3Unlock)
			end
		end
	end
end


-- 需要屏蔽掉落引导的模块，孙云鹏 2015-11-25
function EquipInfoViewNew:exceptModule( ... )
	local curModule = LayerManager.curModuleName()
    logger:debug({EquipInfoViewNew_exileModule=curModule})

	if (curModule == "AdventureMainCtrl") then   -- 奇遇模块
		return true
	end
	return false
end


function EquipInfoViewNew:initButton( ... )
	local bShow = tbShowBtn[self.createType]
	self.btnOk:setEnabled(bShow)
	self.btnUnload:setEnabled(not bShow)
	self.btnChange:setEnabled(not bShow)

	-- 红点
	if (self._isChangeBtnTip == true) then
		if(not self.btnChange.IMG_CHANGE_TIP:getNodeByTag(10)) then
			local tip = UIHelper.createRedTipAnimination()
			tip:setTag(10)
			self.btnChange.IMG_CHANGE_TIP:addNode(tip,10)
		end
	end
	self.btnChange.IMG_CHANGE_TIP:setVisible(self._isChangeBtnTip)

	if (self.tbEvent.onBack) then
		if (self.tbEvent.onFindDrop  and not self:exceptModule()) then
			local btnChanged = UIHelper.chagneGuildTOOk(self.btnOk)
			if (not btnChanged) then
				UIHelper.titleShadow(self.btnOk, m_i18n[1098])
				self.btnOk:addTouchEventListener(self.tbEvent.onFindDrop)
			end
		else
			UIHelper.titleShadow(self.btnOk, m_i18n[2629])
			self.btnOk:addTouchEventListener(self.tbEvent.onBack)
		end
	else
		if (self.tbEvent.onUnload) then
			UIHelper.titleShadow(self.btnUnload, m_i18n[1710])
			self.btnUnload:addTouchEventListener(self.tbEvent.onUnload)

			UIHelper.titleShadow(self.btnChange, m_i18n[1638])
			self.btnChange:addTouchEventListener(self.tbEvent.onChange)
		end
	end
end

function EquipInfoViewNew:setSpecialText(label, tbArgs)
	if (label) then
		label:setText(tbArgs.text)
		label:setColor(tbArgs.color)
		if (tbArgs.bStroke) then
			UIHelper.labelNewStroke(label, m_strokeColor)
		end
		UIHelper.labelShadow(label)
	end
end
