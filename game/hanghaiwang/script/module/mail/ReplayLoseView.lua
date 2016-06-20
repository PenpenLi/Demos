-- FileName: ReplayLoseView.lua
-- Author: zhangjunwu
-- Date: 2014-07-24
-- Purpose: 查看战报失败界面
--[[TODO List]]

module("ReplayLoseView", package.seeall)
require "script/module/public/EffectHelper"
-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["ReplayLoseView"] = nil
end

function moduleName()
    return "ReplayLoseView"
end

-- UI控件引用变量 --
local public_lose = "ui/public_report_lose.json"
local m_mainWidget

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString = gi18nString
local m_i18n = gi18n

local m_tbBtnEvent



function updateUI(  )


end

function create(tbBtnEvent,tbData)
	m_tbBtnEvent = tbBtnEvent
	m_mainWidget = g_fnLoadUI(public_lose)
	m_mainWidget:setSize(g_winSize)

	local BTN_WUJIANG = m_fnGetWidget(m_mainWidget,"BTN_WUJIANG") --武将强化按钮
	local BTN_ZHUANGBEI = m_fnGetWidget(m_mainWidget,"BTN_ZHUANGBEI") -- 装备强化按钮
	local BTN_MINGJIANG = m_fnGetWidget(m_mainWidget,"BTN_MINGJIANG") -- 2014-08-06, zhangqi, 查看阵容

	--local BTN_FORMATION = m_fnGetWidget(m_mainWidget,"BTN_FORMATION") --对方阵容按钮
	local BTN_REPLAY = m_fnGetWidget(m_mainWidget,"BTN_REPLAY") -- 重播按钮
	local BTN_CONFIRM = m_fnGetWidget(m_mainWidget,"BTN_CONFIRM") -- 确定按钮
	local BTN_REPORT = m_fnGetWidget(m_mainWidget,"BTN_REPORT") -- 发送战报
	local BTN_DATA = m_fnGetWidget(m_mainWidget,"BTN_DATA") -- 战斗数据

	BTN_WUJIANG:addTouchEventListener(m_tbBtnEvent.onPartner)
	BTN_ZHUANGBEI:addTouchEventListener(m_tbBtnEvent.onEquip)
	BTN_MINGJIANG:addTouchEventListener(m_tbBtnEvent.onTrainstar)


	--BTN_FORMATION:addTouchEventListener(m_tbBtnEvent.onFormation)
	BTN_REPLAY:addTouchEventListener(m_tbBtnEvent.onRepaly)
	-- BTN_CONFIRM:addTouchEventListener(m_tbBtnEvent.onConfirm)
	BTN_REPORT:addTouchEventListener(m_tbBtnEvent.onReport)
	BTN_DATA:addTouchEventListener(m_tbBtnEvent.onBattleData)
	


	--UIHelper.titleShadow(BTN_FORMATION,m_i18n[2231])
	UIHelper.titleShadow(BTN_REPLAY,m_i18n[2229])
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

	--邮件的查看战隐藏 发送战报和对方阵容按钮
	require "script/module/mail/MailData"
	local TFD_INFO = m_fnGetWidget(m_mainWidget,"TFD_INFO") --船长加油哦
	TFD_INFO:setText(m_i18n[1996])

	local TFD_NAME1  = m_fnGetWidget(m_mainWidget,"TFD_NAME1")
	local LABN_FIGHT1  = m_fnGetWidget(m_mainWidget,"LABN_FIGHT1")
	local LABN_FIGHT2  = m_fnGetWidget(m_mainWidget,"LABN_FIGHT2")
	local TFD_NAME2  = m_fnGetWidget(m_mainWidget,"TFD_NAME2")

	--邮件的查看战报隐藏 发送战报和对方阵容按钮
	if(tbData.type == MailData.ReplayType.KTypeChatBattle) then
		--BTN_FORMATION:setEnabled(false)
		BTN_REPORT:setEnabled(false)
		TFD_NAME1:setText(tbData.playerName2)
		if (tbData.fightForce2) then 
			LABN_FIGHT1:setStringValue(tbData.fightForce2)
		else 
			LABN_FIGHT1:setVisible(false)
			m_mainWidget.img_fight1:setVisible(false)
		end 
	else
		TFD_NAME1:setText(UserModel.getUserName())
		LABN_FIGHT1:setStringValue(UserModel.getFightForceValue())
		
	end

	logger:debug(tbData.playerName)
	TFD_NAME2:setText(tbData.playerName)
	if (tbData.fightForce) then 
		LABN_FIGHT2:setStringValue(tbData.fightForce)
	else 
		LABN_FIGHT2:setVisible(false)
		m_mainWidget.img_fight2:setVisible(false)
	end 


	-- UIHelper.labelNewStroke(TFD_NAME2) -- 2016-3-11描边又注掉了
	-- UIHelper.labelNewStroke(TFD_NAME1 ) -- 2016-3-11描边又注掉了
    --特效
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
    local IMG_BG = m_fnGetWidget(m_mainWidget,"IMG_BG")
	local IMG_TITLE = m_fnGetWidget(m_mainWidget,"IMG_TITLE")
	EffBattleLose:new(m_mainWidget,IMG_TITLE,onCallback)


	-- if(tbData.playerName ~= UserModel.getUserName() and tbData.playerName2 ~= UserModel.getUserName()) then
	-- 	BTN_WUJIANG:setEnabled(false)
	-- 	BTN_ZHUANGBEI:setEnabled(false)
	-- 	BTN_MINGJIANG:setEnabled(false)
	-- end



	-- modify by yangna 2016.2.23 兼容战报分享，查看别人的战报不显示强化，阵容等按钮
	local mUid = tonumber(UserModel.getUserUid()) 
	if (tonumber(tbData.uid)~=mUid and tonumber(tbData.uid2)~=mUid) then 
		m_mainWidget.LAY_TODO:setEnabled(false)
	end 

	return m_mainWidget
end
