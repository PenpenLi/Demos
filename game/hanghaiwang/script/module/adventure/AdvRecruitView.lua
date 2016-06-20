-- FileName: AdvRecruitView.lua
-- Author: zhangqi
-- Date: 2015-04-03
-- Purpose: 慕名而来奇遇事件UI模块
--[[TODO List]]

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_strokeColor1 = ccc3(0x28, 0x00, 0x00)
local m_strokeColor2 = ccc3(0x65, 0x00, 0x00)

local m_defTimeString = "00:00:00"

AdvRecruitView = class("AdvRecruitView")

function AdvRecruitView:ctor(fnCloseCallback)
	self.layMain = g_fnLoadUI("ui/magical_thing_hero.json")
end

function AdvRecruitView:create(tbArgs)
	local layMain = self.layMain

	local imgBG = m_fnGetWidget(layMain, "img_bg")
	imgBG:setScale(g_fScaleX)

	self.btnRecruit = m_fnGetWidget(layMain, "BTN_BUY") -- 购买按钮
	if (tbArgs.complete) then
		self:updateOKState() -- 如果事件已完成则购买按钮置灰
	else
		UIHelper.titleShadow(self.btnRecruit, m_i18n[4356])
		self.btnRecruit:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				tbArgs.fnRecruitCallback()
			end
		end)
	end

	local i18n_title = m_fnGetWidget(layMain, "TFD_TITLE")
	i18n_title:setText(tbArgs.sTitle)
	UIHelper.labelNewStroke(i18n_title, m_strokeColor1)

	local imgDescBg = m_fnGetWidget(layMain, "img_desc_bg")
	imgDescBg:setScale(g_fScaleX)

	local i18n_desc = m_fnGetWidget(layMain, "TFD_DESC")
	i18n_desc:setText(tbArgs.desc)
	UIHelper.labelNewStroke(i18n_desc, m_strokeColor1)

	-- 菜肴图标
	local layIcon = m_fnGetWidget(layMain, "lay_icon_bg")
	local szIcon = layIcon:getSize()
	local imgIcon = ImageView:create()
	imgIcon:loadTexture(tbArgs.iconPath)
	local imgQuality = ImageView:create()
	imgQuality:loadTexture(tbArgs.iconQuality)
	imgQuality:addChild(imgIcon)
	imgQuality:setPosition(ccp(szIcon.width/2, szIcon.height/2))
	layIcon:addChild(imgQuality)
	local imgBorder = ImageView:create()
	imgBorder:loadTexture(tbArgs.iconBorder)
	imgQuality:addChild(imgBorder)

	-- 菜肴图标名称
	local labIconName = m_fnGetWidget(layMain, "tfd_item_name")
	labIconName:setText(tbArgs.sIconName)
	labIconName:setColor(g_QulityColor[tbArgs.nQuality])
	
	local labCostNum = m_fnGetWidget(layMain, "TFD_AGO_NUM")
	labCostNum:setText(tbArgs.nCostNum)
	UIHelper.labelNewStroke(labCostNum, m_strokeColor2)

	local i18n_time = m_fnGetWidget(layMain, "tfd_time")
	i18n_time:setText(m_i18n[4351])
	UIHelper.labelNewStroke(i18n_time, m_strokeColor1)
	self.labCD = m_fnGetWidget(layMain, "TFD_TIME_NUM") -- "00:00:00" -- 默认时间串
	self.labCD:setText(tbArgs.sTime)
	UIHelper.labelNewStroke(self.labCD, m_strokeColor1)

	-- 伙伴形象
	local imgModel = m_fnGetWidget(layMain, "IMG_MODLE")
	imgModel:loadTexture(tbArgs.sModelImg)
	imgModel:setTouchEnabled(true)
	imgModel:addTouchEventListener(tbArgs.ModelEvent)

	-- 伙伴形象名称
	local i18nQuality = {1829, 1830, 1831, 1832, 1833, 1834}
	local labModelName = m_fnGetWidget(layMain, "TFD_HERO")
	local qualityText = m_i18n[i18nQuality[tbArgs.nQuality]]
	labModelName:setColor(g_QulityColor2[tbArgs.nQuality])
	UIHelper.labelAddNewStroke(labModelName, m_i18nString(4363, tbArgs.sName, qualityText), m_strokeColor2)
	-- labModelName:setText()

	return layMain
end

function AdvRecruitView:updateOKState( ... )
	if (self.btnRecruit) then
		self.btnRecruit:setTouchEnabled(false)
		self.btnRecruit:setBright(false)
		self.btnRecruit:setTitleColor(g_btnTitleGray)
		UIHelper.titleShadow(self.btnRecruit, m_i18n[1089])
	end
end

function AdvRecruitView:updateCD( sTime )
	if (self.labCD and sTime) then
		self.labCD:setText(sTime)
	end
end

function AdvRecruitView:getCDString( ... )
	local cd = m_defTimeString
	if (self.labCD) then
		cd = self.labCD:getStringValue()
	end
	return cd
end
