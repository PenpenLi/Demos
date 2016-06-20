-- FileName: EquipInfoView.lua
-- Author: zhangqi
-- Date: 2014-05-05
-- Purpose: 构造装备信息面板
--[[TODO List]]

module("EquipInfoView", package.seeall)

require "script/GlobalVars"
require "script/module/public/UIHelper"

-- UI控件引用变量 --
local m_layMain
local m_labTitle -- "tfd_title"
local m_btnClose -- "BTN_CLOSE"

-- 卡牌
local m_layCard -- "LAY_CARD"
local m_imgArm -- "IMG_ARM", 装备图片
local m_labName -- "TFD_NAME1", 装备名称
local m_imgStar -- "img_star_1", 星级图片，从"img_star_1" 到 "img_star_5"
local m_labnScore -- "LABN_PINJI", 品级数值

-- 属性值
local m_layInfo -- "LAY_INFO"
local m_labAttr -- "tfd_attr"
local m_labLvName -- "tfd_lvl"
local m_labLv -- "TFD_LVL_NUM", 等级值

local m_labName1 -- TFD_ATTR1 属性名字
local m_lab1 -- "TFD_ATTR1_NUM", 攻击加成
local m_labName2 -- TFD_ATTR2 属性名字
local m_lab2 -- "TFD_ATTR2_NUM", 生命加成
local m_labName3 -- TFD_ATTR3 属性名字
local m_lab3 -- "TFD_ATTR3_NUM", 最终伤害
local m_labName4 -- TFD_ATTR4 属性名字
local m_lab4 -- "TFD_ATTR4_NUM", 最终免伤

-- 每级属性加成
local m_labLvAttr -- "tfd_attr_title"

local m_labLvHRName
local m_labLvHR -- "TFD_ATTR5_NUM", 生命加成
local m_labLvAttack -- "TFD_ATTR6_NUM", 攻击加成
local m_lablvAttackName 

-- 简介
local m_labDescTitle -- "tfd_des_title"
local m_labDesc -- "TFD_DES"

-- 功能按钮
local m_layEquipBtn -- "LAY_BTNS_FROMEQUIP", 从装备列表里图标弹出
local m_btnReinforce -- "BTN_STRENGTHEN", "BTN_STRENGTHEN1", 强化按钮
local m_btnXilian -- "BTN_XILIAN", "BTN_XILIAN1", 洗炼按钮

local m_layFormationBtn -- "LAY_BTNS_FROMFOR", 从阵容装备弹出
local m_btnChange -- "BTN_CHANGE", 更换
local m_btnUnload -- "BTN_UNLOAD", 卸载

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_qualityColor = g_QulityColor

local function init(...)
	m_layMain = nil
	m_labTitle = nil
	m_btnClose = nil
	-- 卡牌
	m_layCard = nil
	m_imgArm = nil
	m_labName = nil
	m_imgStar = nil
	m_labnScore = nil
	-- 属性值
	m_layInfo = nil
	m_labAttr = nil
	m_labLvName = nil
	m_labLv = nil
	
	m_lab1 = nil
	m_lab2 = nil
	m_lab3 = nil
	m_lab4 = nil
	m_labName1 = nil
	m_labName2 = nil
	m_labName3 = nil
	m_labName4 = nil

	-- 每级属性加成
	m_labLvAttr = nil
	m_labLvHR  = nil
	m_labLvAttack = nil
	m_labLvHRName = nil
	m_lablvAttackName = nil

	-- 简介
	m_labDescTitle = nil
	m_labDesc = nil

	-- 功能按钮
	m_layEquipBtn = nil
	m_btnReinforce = nil
	m_btnXilian = nil

	m_layFormationBtn = nil
	m_btnChange = nil
	m_btnUnload = nil
end

function destroy(...)
	package.loaded["EquipInfoView"] = nil
end

function moduleName()
    return "EquipInfoView"
end

--[[desc: 根据入口模块（装备或阵容）构造不同的装备信息面板
    nType: 1, 阵容；2，装备
    tbInfo: 只包含装备信息相关内容的自定义table, {cardBgPath, name, nQuality, armPath, sScore, sLv, sAttack, sHR, sHurt, sEscap, sLvHR, sLvAttack, sDesc}
    tbBtnCallBack: 存放功能按钮的回调方法，{onChange, onUnload, onXilian, onReinforce}
    return: Widget
—]]
function create(nType, tbInfo, tbBtnCallBack)
	init()

	m_layMain = g_fnLoadUI("ui/equip_info.json")
	m_layMain:setSize(g_winSize)
	m_btnClose = m_fnGetWidget(m_layMain, "BTN_CLOSE")
	m_btnClose:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("BTN_CLOSEBTN_CLOSEBTN_CLOSEBTN_CLOSEBTN_CLOSE")

			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)

	-- 装备基本信息部分
	local imgBg = m_fnGetWidget(m_layMain, "img_bg")
	imgBg:setScale(g_fScaleX)

	m_labName = m_fnGetWidget(m_layMain, "TFD_NAME1")
	m_labName:setText(tbInfo.name)
	m_labName:setColor(g_QulityColor2[tbInfo.nQuality])
	UIHelper.labelNewStroke(m_labName, ccc3(0x24, 0x00, 0x00))

	for i = 5, tbInfo.nQuality + 1, -1 do
		local imgStar = m_fnGetWidget(m_layMain, "img_star_" .. i)
		if (imgStar) then
			imgStar:setVisible(false)
		end
	end

	m_imgArm = m_fnGetWidget(m_layMain, "IMG_ARM")
	m_imgArm:loadTexture(tbInfo.armPath)

	UIHelper.runFloatAction(m_imgArm)
	m_labnScore = m_fnGetWidget(m_layMain, "LABN_PINJI")
	m_labnScore:setStringValue(tbInfo.sScore)

	-- 属性部分
	m_layInfo = m_fnGetWidget(m_layMain, "LAY_INFO")

	m_labLv = m_fnGetWidget(m_layInfo, "TFD_LVL_NUM")
	m_labLv:setText(tbInfo.sLv)

	
	m_lab1 = m_fnGetWidget(m_layInfo, "TFD_ATTR1_NUM")
	m_lab2 = m_fnGetWidget(m_layInfo, "TFD_ATTR2_NUM")
	m_lab3 = m_fnGetWidget(m_layInfo, "TFD_ATTR3_NUM")
	m_lab4 = m_fnGetWidget(m_layInfo, "TFD_ATTR4_NUM")
	m_labName1 = m_fnGetWidget(m_layInfo, "TFD_ATTR1")
	m_labName2 = m_fnGetWidget(m_layInfo, "TFD_ATTR2")
	m_labName3 = m_fnGetWidget(m_layInfo, "TFD_ATTR3")
	m_labName4 = m_fnGetWidget(m_layInfo, "TFD_ATTR4")

	m_labLvHR = m_fnGetWidget(m_layInfo, "TFD_ATTR5_NUM")
	m_labLvHRName = m_fnGetWidget(m_layInfo, "TFD_ATTR5")
	m_labLvAttack = m_fnGetWidget(m_layInfo, "TFD_ATTR6_NUM")
	m_lablvAttackName = m_fnGetWidget(m_layInfo, "TFD_ATTR6")

	m_lab1:setText("")
	m_lab2:setText("")
	m_lab3:setText("")
	m_lab4:setText("")

	UIHelper.labelNewStroke(m_lab1, ccc3(0x06,0x44,0x00))
	UIHelper.labelNewStroke(m_lab2, ccc3(0x06,0x44,0x00))
	UIHelper.labelNewStroke(m_lab1)
	UIHelper.labelNewStroke(m_lab2)

	m_labName1:setText("")
	m_labName2:setText("")
	m_labName3:setText("")
	m_labName4:setText("")
	m_labLvHR:setText("")
	m_labLvAttack:setText("")
	m_labLvHRName:setText("")
	m_lablvAttackName:setText("")
	local tbAttrLab = {}
	tbAttrLab[1] = {m_lab1, m_labName1}
	tbAttrLab[2] = {m_lab2, m_labName2}
	tbAttrLab[3] = {m_lab3, m_labName3}
	tbAttrLab[4] = {m_lab4, m_labName4}
	
	logger:debug(tbInfo)
	logger:debug(#tbInfo.m_tbAttr)
	for i=1,#tbInfo.m_tbAttr do
		logger:debug(tbInfo.m_tbAttr[i].descName)
		logger:debug(tbAttrLab)
		tbAttrLab[i][2]:setText(tbInfo.m_tbAttr[i].descName)
		tbAttrLab[i][1]:setText(tbInfo.m_tbAttr[i].descString)
	end


	local tbAttrLabA = {}
	tbAttrLabA[1] = {m_labLvHR, m_labLvHRName}
	tbAttrLabA[2] = {m_labLvAttack, m_lablvAttackName}

	logger:debug(tbInfo.m_tbPLAttr)
	for i=1,#tbInfo.m_tbPLAttr do
		tbAttrLabA[i][2]:setText(tbInfo.m_tbPLAttr[i].descName)
		tbAttrLabA[i][1]:setText(tbInfo.m_tbPLAttr[i].descString)
	end

	m_labDesc = m_fnGetWidget(m_layInfo, "TFD_DES")
	m_labDesc:setText(tbInfo.sDesc)
	
	local strokeC = ccc3(0x00, 0x1f, 0x04)
	local tfdTitle = m_fnGetWidget(m_layInfo, "tfd_des_title")
	UIHelper.labelAddStroke(tfdTitle, m_i18n[1632], strokeC)

	local i18nAttr = m_fnGetWidget(m_layInfo, "tfd_attr")
	UIHelper.labelAddStroke(i18nAttr, m_i18n[1633], strokeC)

	local i18nAttrLv = m_fnGetWidget(m_layInfo, "tfd_attr_title")
	UIHelper.labelAddStroke(i18nAttrLv, m_i18n[1634], strokeC)
	-- 功能按钮
	m_layEquipBtn = m_fnGetWidget(m_layMain, "LAY_BTNS_FROMEQUIP")
	m_layFormationBtn = m_fnGetWidget(m_layMain, "LAY_BTNS_FROMFOR")
	local LAY_BTNS_FROMSALE = m_fnGetWidget(m_layMain, "LAY_BTNS_FROMSALE")
	if (nType == 1) then -- 从阵容打开
		m_layEquipBtn:removeFromParentAndCleanup(true)
		LAY_BTNS_FROMSALE:removeFromParent()
		m_btnChange = m_fnGetWidget(m_layFormationBtn, "BTN_CHANGE")
		m_btnChange:addTouchEventListener(tbBtnCallBack.onChange)

		UIHelper.titleShadow(m_btnChange,m_i18n[1638])


		m_btnUnload = m_fnGetWidget(m_layFormationBtn, "BTN_UNLOAD")
		UIHelper.titleShadow(m_btnUnload,m_i18n[1710])

		m_btnUnload:addTouchEventListener(tbBtnCallBack.onUnload)

		m_btnXilian = m_fnGetWidget(m_layFormationBtn, "BTN_XILIAN1")
		UIHelper.titleShadow(m_btnXilian,m_i18n[1639])
		m_btnXilian:addTouchEventListener(tbBtnCallBack.onXilian)

		m_btnReinforce = m_fnGetWidget(m_layFormationBtn, "BTN_STRENGTHEN1")
		m_btnReinforce:addTouchEventListener(tbBtnCallBack.onReinforce)
		UIHelper.titleShadow(m_btnReinforce,m_i18n[1007])

	elseif (nType == 2) then -- 从装备列表打开
		m_layFormationBtn:removeFromParentAndCleanup(true)
		LAY_BTNS_FROMSALE:removeFromParent()
		m_layEquipBtn:setEnabled(true)
		m_layEquipBtn:setVisible(true)

		m_btnXilian = m_fnGetWidget(m_layEquipBtn, "BTN_XILIAN")
		UIHelper.titleShadow(m_btnXilian,m_i18n[1639])
		m_btnXilian:addTouchEventListener(tbBtnCallBack.onXilian)


		m_btnReinforce = m_fnGetWidget(m_layEquipBtn, "BTN_STRENGTHEN")
		m_btnReinforce:addTouchEventListener(tbBtnCallBack.onReinforce)
		UIHelper.titleShadow(m_btnReinforce,m_i18n[1007])
	elseif (nType == 3) then -- 从碎片打开
		-- LAY_BTNS_FROMSALE:removeFromParent()
		m_layEquipBtn:removeFromParentAndCleanup(true)
		m_layFormationBtn:removeFromParentAndCleanup(true)
		local BTN_BACK = m_fnGetWidget(LAY_BTNS_FROMSALE,"BTN_BACK")
		BTN_BACK:addTouchEventListener(tbBtnCallBack.onBack)

		UIHelper.titleShadow(BTN_BACK, m_i18n[1019])

	elseif (nType == 4) then -- 从装备出售列表打开
		m_layEquipBtn:removeFromParentAndCleanup(true)
		m_layFormationBtn:removeFromParentAndCleanup(true)
		local BTN_BACK = m_fnGetWidget(LAY_BTNS_FROMSALE,"BTN_BACK")
		BTN_BACK:addTouchEventListener(tbBtnCallBack.onBack)
		UIHelper.titleShadow(BTN_BACK, m_i18n[1019])
	elseif (nType == 5) then -- 从装备碎片出售列表打开
		m_layEquipBtn:removeFromParentAndCleanup(true)
		m_layFormationBtn:removeFromParentAndCleanup(true)
		local BTN_BACK = m_fnGetWidget(LAY_BTNS_FROMSALE,"BTN_BACK")
		BTN_BACK:addTouchEventListener(tbBtnCallBack.onBack)
		UIHelper.titleShadow(BTN_BACK, m_i18n[1019])
	end
	return m_layMain
end
