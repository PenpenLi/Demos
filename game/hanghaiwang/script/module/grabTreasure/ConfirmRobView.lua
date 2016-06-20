-- FileName: ConfirmRobView.lua
-- Author: zjw
-- Date: 2014-5-11
-- Purpose: 点击船只后进入夺宝确定界面


module("ConfirmRobView", package.seeall)

-- UI控件引用变量 --
local m_UIMain
local m_btnClose
local m_btnAvoidWar
local m_btnGold


-- 模块局部变量 --
local m_fnGetWidget 				= g_fnGetWidgetByName
local m_i18nString 					= gi18nString

local m_tbRoberInfo = nil
local m_tbFragInfo = nil


local function initUI( ... )
	-- 获取控件
	local i18nRobInfo = m_fnGetWidget(m_UIMain,"tfd_title")
	UIHelper.labelEffect(i18nRobInfo,m_i18nString(2430))
	--抢夺玩家
	local i18nName = m_fnGetWidget(m_UIMain,"tfd_grab_player")
	--i18nName:setText(m_i18nString(2431))
	UIHelper.labelEffect(i18nName,m_i18nString(2431))
	--抢夺碎片
	local i18nFrag= m_fnGetWidget(m_UIMain,"tfd_grab_fragment")
	--i18nFrag:setText(m_i18nString(2432))
	UIHelper.labelEffect(i18nFrag,m_i18nString(2432))
	--抢夺概率
	local i18nRatio = m_fnGetWidget(m_UIMain,"tfd_grab_probability")
	--i18nRatio:setText(m_i18nString(2433))
	UIHelper.labelEffect(i18nRatio,m_i18nString(2433))
	--抢夺阵容
	local i18nZhenRong = m_fnGetWidget(m_UIMain,"tfd_formation")
	--i18nZhenRong:setText(m_i18nString(2434))
	UIHelper.labelEffect(i18nZhenRong,m_i18nString(2434))

	--对手名字
	local labPlayerName = m_fnGetWidget(m_UIMain,"TFD_PALYER_NAME")
	--labPlayerName:setText(m_tbRoberInfo.uname)
	UIHelper.labelEffect(labPlayerName,m_tbRoberInfo.uname)
	--对手等级
	local labPlayerLevel = m_fnGetWidget(m_UIMain,"TFD_PLAYER_LEVEL")  --level
	--labPlayerLevel:setText(m_tbRoberInfo.level)

	UIHelper.labelAddStroke(labPlayerLevel,m_tbRoberInfo.level)
	--碎片名字
	local TFD_FragName  = m_fnGetWidget(m_UIMain,"TFD_FRAGMENT_NAME")
	--TFD_FragName:setText(m_tbFragInfo.name)
	logger:debug("抢夺碎片的名字是:" .. m_tbFragInfo.name)
	UIHelper.labelEffect(TFD_FragName,m_tbFragInfo.name)
	logger:debug(m_tbFragInfo)
	TFD_FragName:setColor(g_QulityColor2[m_tbFragInfo.quality])

	--概率
	local labPlayerRatio= m_fnGetWidget(m_UIMain,"TFD_PROBABILITY_NUM")
	--labPlayerRatio:setText(m_tbRoberInfo.ratioDesc)
	UIHelper.labelEffect(labPlayerRatio,m_tbRoberInfo.ratioDesc)
	--概率颜色
	local nameColor = TreasureUtil.getPercentColorByName(m_tbRoberInfo.ratioDesc)
	labPlayerRatio:setColor(nameColor)

	--英雄
	logger:debug(m_tbRoberInfo.squad)
	local sortSquad = TreasureUtil.sortQuad(m_tbRoberInfo.squad, m_tbRoberInfo.npc)
	logger:debug(sortSquad)
	for k,v in pairs(sortSquad) do
		if( k <4) then
			local robHeadBg = m_fnGetWidget(m_UIMain,"IMG_HERO_ICON_BG" .. k)
			local robHeadSprite = TreasureUtil.getRobberHeadIcon(m_tbRoberInfo.npc,v)
			robHeadSprite:setAnchorPoint(ccp(0.5,0.5))
			--robHeadSprite:setPosition(30 + 132*(k-1), heroBg:getContentSize().height/2)
			robHeadBg:addChild(robHeadSprite)
		end
	end

	local btnCancle = m_fnGetWidget(m_UIMain,"BTN_CLOSE")
	local btnGrab = m_fnGetWidget(m_UIMain,"BTN_GRAB")
	btnCancle:addTouchEventListener(m_tbFragInfo.onClose)
	btnGrab:addTouchEventListener(m_tbFragInfo.onGrab)

	UIHelper.titleShadow(btnGrab,m_i18nString(2419))
end


local function init(...)
	initUI()
end

function destroy(...)
	package.loaded["ConfirmRobView"] = nil
end

function moduleName()
	return "ConfirmRobView"
end

function create(tbInfo,tbFragInfo)
	m_UIMain = g_fnLoadUI("ui/grab_info.json")
	m_tbFragInfo = tbFragInfo
	m_tbRoberInfo = tbInfo
	logger:debug(m_tbRoberInfo)

	initUI()

	return m_UIMain
end
