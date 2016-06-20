-- FileName: AdvTraderView.lua
-- Author: zhangqi
-- Date: 2015-04-02
-- Purpose: 神秘熊猫人奇遇事件UI模块
--[[TODO List]]

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

local m_strokeColor1 = ccc3(0x28, 0x00, 0x00)
local m_strokeColor2 = ccc3(0x65, 0x00, 0x00)

local m_defTimeString = "00:00:00"

AdvTraderView = class("AdvTraderView")

function AdvTraderView:ctor(fnCloseCallback)
	self.layMain = g_fnLoadUI("ui/magical_thing_item.json")
end

function AdvTraderView:create(tbArgs)
	local layMain = self.layMain

	local imgBG = m_fnGetWidget(layMain, "img_bg")
	imgBG:setScale(g_fScaleX)

	self.btnBuy = m_fnGetWidget(layMain, "BTN_BUY") -- 购买按钮
	if (tbArgs.complete) then
		self:updateOKState() -- 如果事件已完成则购买按钮置灰
	else
		UIHelper.titleShadow(self.btnBuy, m_i18n[4354])
		self.btnBuy:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				tbArgs.fnBuyCallback()
			end
		end)
	end

	local labTitle = m_fnGetWidget(layMain, "TFD_TITLE")
	labTitle:setText(tbArgs.sTitle)
	UIHelper.labelNewStroke(labTitle, m_strokeColor1)

	local imgDescBg = m_fnGetWidget(layMain, "img_desc_bg")
	imgDescBg:setScale(g_fScaleX)

	local i18n_desc = m_fnGetWidget(layMain, "TFD_DESC")
	i18n_desc:setText(tbArgs.desc)
	UIHelper.labelNewStroke(i18n_desc, m_strokeColor1)

	-- 物品图标
	local layItemIcon = m_fnGetWidget(layMain, "LAY_ITEM_BG")
	local szIcon = layItemIcon:getSize()
	tbArgs.btnItemIcon:setPosition(ccp(szIcon.width/2, szIcon.height/2))
	layItemIcon:addChild(tbArgs.btnItemIcon)
	-- 物品名称
	local labItemName = m_fnGetWidget(layMain, "tfd_item_name")
	labItemName:setText(tbArgs.sItemName)
	labItemName:setColor(g_QulityColor[tbArgs.nItemQuality])

	-- 打折图标
	local imgAgio = m_fnGetWidget(layMain, "IMG_AGIO")
	imgAgio:loadTexture(tbArgs.sAgioSign)
	imgAgio:setZOrder(1)

	-- 原价
	local i18n_ago = m_fnGetWidget(layMain, "tfd_ago")
	i18n_ago:setText(m_i18n[1470])
	local labAgoNum = m_fnGetWidget(layMain, "TFD_AGO_NUM")
	labAgoNum:setText(tbArgs.nAgoNum)

	local labNowNum = m_fnGetWidget(layMain, "TFD_NOW_NUM")
	labNowNum:setText(tbArgs.nNowNum)
	UIHelper.labelNewStroke(labNowNum, m_strokeColor2)

	local i18n_time = m_fnGetWidget(layMain, "tfd_time")
	i18n_time:setText(m_i18n[4351])
	UIHelper.labelNewStroke(i18n_time, m_strokeColor1)
	self.labCD = m_fnGetWidget(layMain, "TFD_TIME_NUM")
	self.labCD:setText(tbArgs.sTime)
	UIHelper.labelNewStroke(self.labCD, m_strokeColor1)

	-- 商人形象图片
	local imgTrader = m_fnGetWidget(layMain, "IMG_MODLE")
	imgTrader:loadTexture(tbArgs.sTraderImg)

	return layMain
end

function AdvTraderView:updateOKState( ... )
	if (self.btnBuy) then
		self.btnBuy:setTouchEnabled(false)
		self.btnBuy:setBright(false)
		self.btnBuy:setTitleColor(g_btnTitleGray)
		UIHelper.titleShadow(self.btnBuy, m_i18n[1452])
	end
end

function AdvTraderView:updateCD( sTime )
	if (self.labCD and sTime) then
		self.labCD:setText(sTime)
	end
end

function AdvTraderView:getCDString( ... )
	local cd = m_defTimeString
	if (self.labCD) then
		cd = self.labCD:getStringValue()
	end
	return cd
end
