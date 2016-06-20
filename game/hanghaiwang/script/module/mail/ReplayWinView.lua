-- FileName: ReplayWinView.lua
-- Author: zhangjunwu
-- Date: 2014-07-24
-- Purpose: 邮件查看战报胜利结算面板
--[[TODO List]]

module("ReplayWinView", package.seeall)
require "script/module/public/EffectHelper"
require "script/module/mail/MailData"
-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["ReplayWinView"] = nil
end

function moduleName()
	return "ReplayWinView"
end

function create(...)

end


-- UI控件引用变量 --
local public_win = "ui/public_report_win.json"
local m_mainWidget


m_tbData = nil
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_tbBtnEvent
local m_i18n = gi18n
local m_i18nString = gi18nString


--[[desc:查看战报结算面板
    arg1: tbEvent点击事件，tbData数据table
    return: 是否有返回值，返回值说明  
—]]

function create(tbEvent,tbData)

	m_tbBtnEvent = tbEvent
	m_tbData = _tbData
	m_mainWidget = g_fnLoadUI(public_win)
	m_mainWidget:setSize(g_winSize)

	m_mainWidget.img_vsvg:setVisible(false)
	local shieldLayout = Layout:create() --屏蔽层 
	shieldLayout:setTouchEnabled(true)
	shieldLayout:setSize(g_winSize)
	m_mainWidget:addChild(shieldLayout)
	local function onCallback()
		palyBattleVsEffect(m_mainWidget.img_vsvg,m_mainWidget.img_vsvg.img_vs,function()
					shieldLayout:removeFromParent()
				end)
	end
	local IMG_RAINBOW = m_fnGetWidget(m_mainWidget,"IMG_RAINBOW")
	local IMG_TITLE = m_fnGetWidget(m_mainWidget,"IMG_TITLE")
	local winAnimation = EffBattleWin:new({imgTitle = IMG_TITLE, imgRainBow = IMG_RAINBOW,callback=onCallback})


	--local BTN_FORMATION = m_fnGetWidget(m_mainWidget,"BTN_FORMATION") 		--对方阵容按钮
	local BTN_REPORT = m_fnGetWidget(m_mainWidget,"BTN_REPORT")  			-- 发送战报按钮
	local BTN_AGAIN = m_fnGetWidget(m_mainWidget,"BTN_AGAIN")				-- 重播按钮
	local BTN_CONFIRM = m_fnGetWidget(m_mainWidget,"BTN_CONFIRM") 			--确定按钮
	local BTN_DATA = m_fnGetWidget(m_mainWidget,"BTN_DATA") 				-- 战斗数据按钮


	--BTN_FORMATION:addTouchEventListener(m_tbBtnEvent.onFormation)
	BTN_REPORT:addTouchEventListener(m_tbBtnEvent.onReport)
	BTN_AGAIN:addTouchEventListener(m_tbBtnEvent.onRepaly)
	-- BTN_CONFIRM:addTouchEventListener(m_tbBtnEvent.onConfirm)
	BTN_DATA:addTouchEventListener(m_tbBtnEvent.onBattleData)


	--UIHelper.titleShadow(BTN_FORMATION,m_i18n[2231])
	UIHelper.titleShadow(BTN_AGAIN,m_i18n[2229])
	-- UIHelper.titleShadow(BTN_CONFIRM,m_i18n[1029])
	-- UIHelper.titleShadow(BTN_REPORT,m_i18n[2164])
	UIHelper.titleShadow(BTN_DATA,m_i18n[2169])              			


	m_mainWidget:setTouchEnabled(true)
	m_mainWidget:addTouchEventListener(m_tbBtnEvent.onConfirm)

	m_mainWidget.IMG_FADEIN_EFFECT:loadTexture("ui/2x2.png")
	local node = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fadein_continue.ExportJson",
			animationName = "fadein_continue",
			loop = 1,
		})
	m_mainWidget.IMG_FADEIN_EFFECT:addNode(node)


	local TFD_NAME1  = m_fnGetWidget(m_mainWidget,"TFD_NAME1")
	local LABN_FIGHT1  = m_fnGetWidget(m_mainWidget,"LABN_FIGHT1")

	local LABN_FIGHT2  = m_fnGetWidget(m_mainWidget,"LABN_FIGHT2")
	local TFD_NAME2  = m_fnGetWidget(m_mainWidget,"TFD_NAME2")
	--邮件的查看战报隐藏 发送战报和对方阵容按钮 
	if(tbData.type == MailData.ReplayType.KTypeChatBattle) then
		--BTN_FORMATION:setEnabled(false)
		BTN_REPORT:setEnabled(false)    -- 兼容战报分享2016.2.25 yangna
		TFD_NAME1:setText(tbData.playerName)
		TFD_NAME2:setText(tbData.playerName2)

		if (tbData.fightForce) then    --2016.3.7 npc不显示战斗力
			LABN_FIGHT1:setStringValue(tbData.fightForce) 
		else 
			LABN_FIGHT1:setVisible(false)
			m_mainWidget.img_fight1:setVisible(false)
		end 

		if (tbData.fightForce2) then 
			LABN_FIGHT2:setStringValue(tbData.fightForce2)
		else 
			m_mainWidget.img_fight2:setVisible(false)
			LABN_FIGHT2:setVisible(false)
		end 
	else
		TFD_NAME1:setText(UserModel.getUserName())
		LABN_FIGHT1:setStringValue(UserModel.getFightForceValue())
		TFD_NAME2:setText(tbData.playerName)
		LABN_FIGHT2:setStringValue(tbData.fightForce)
	end
	
	-- UIHelper.labelNewStroke(TFD_NAME2) -- 2016-3-11描边又注掉了
	-- UIHelper.labelNewStroke(TFD_NAME1 ) -- 2016-3-11描边又注掉了

	return m_mainWidget
end
