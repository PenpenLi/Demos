-- FileName: WorldBossAtkView.lua
-- Author: wangming
-- Date: 2015-02-04
-- Purpose: 世界Boss战斗结算面板
--[[TODO List]]

-- module("WorldBossAtkView", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

WorldBossAtkView = class("WorldBossAtkView")

function WorldBossAtkView:ctor( ... )
	self.layMain = g_fnLoadUI("ui/attack_win.json")
end

local function onFinish(  )
	require "script/module/config/AudioHelper"
	logger:debug("wm----close")

	require ("script/battle/notification/EventBus")
	EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)

	GlobalNotify.postNotify(WorldBossModel.MSG.BOSS_EXIT_BATTLE)
end

local function onTouch( touchType , x , y )
	logger:debug("onTouch")
	if ( touchType ==  "ended" ) then
		onFinish()
	end
end

function WorldBossAtkView:create( data )
	AudioHelper.playMusic("audio/bgm/sheng.mp3",false)
	local layRoot = self.layMain
	local pInfo = data or nil
	layRoot.LAY_UNION_COPY:setVisible(false)
	local tfd_attack = m_fnGetWidget(layRoot, "tfd_attack") -- 本次攻击伤害
	tfd_attack:setText(m_i18n[6025])
	local tfd_belly = m_fnGetWidget(layRoot, "tfd_belly") -- 获得贝里
	tfd_belly:setText(m_i18n[1328])	-- 获得贝里：
	local tfd_prestige = m_fnGetWidget(layRoot, "tfd_prestige") -- 获得声望
	tfd_prestige:setText(m_i18n[6018])	-- "获得声望："
	layRoot.tfd_reward_title:setText(m_i18n[6027])
	UIHelper.labelNewStroke(layRoot.tfd_reward_title, ccc3(0x49, 0x00, 0x00), 3)

	local pAtk = 0
	local pBelly = 0
	local pPrestige = 0
	if(pInfo) then
		pAtk = pInfo[1] or 0
		pBelly = pInfo[2] or 0
		pPrestige = pInfo[3] or 0
	end

	local TFD_ATTACK_NUM = m_fnGetWidget(layRoot, "TFD_ATTACK_NUM") -- 伤害数值
	TFD_ATTACK_NUM:setText(pAtk)
	local TFD_BELLY_NUM = m_fnGetWidget(layRoot, "TFD_BELLY_NUM") -- 贝利数值
	TFD_BELLY_NUM:setText(pBelly)
	local TFD_PRESTIGE_NUM = m_fnGetWidget(layRoot, "TFD_PRESTIGE_NUM") -- 声望数值
	TFD_PRESTIGE_NUM:setText(pPrestige)

	layRoot.IMG_EFFECT_TIP:setVisible(false)
	-- local tip = CCSprite:create("ui/close_effect_tip.png")
	-- tip:setAnchorPoint(ccp(layRoot.IMG_EFFECT_TIP:getAnchorPoint().x, layRoot.IMG_EFFECT_TIP:getAnchorPoint().y))
	-- tip:setPosition(ccp(layRoot.IMG_EFFECT_TIP:getPositionX(), layRoot.IMG_EFFECT_TIP:getPositionY()))
	-- layRoot:addNode(tip)
	
	-- 点击任意位置关闭
	layRoot.LAY_MAIN:setTouchEnabled(true)
	layRoot.LAY_MAIN:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.resetAudioState()
			AudioHelper.playCloseEffect()
			onFinish()
		end
	end)

	-- 背景光特效
	layRoot.img_effect:setVisible(false)
	local armature = UIHelper.createArmatureNode({
			filePath = WorldBossModel.getEffectPath("new_rainbow.ExportJson"),
			animationName = "new_rainbow",
			loop = 1,
		})
	armature:setPosition(ccp(layRoot.img_effect:getPositionX(), layRoot.img_effect:getPositionY()))
	layRoot.LAY_MAIN:addNode(armature, 1)

	-- 触摸文字特效
	local armature2 = UIHelper.createArmatureNode({
			filePath = WorldBossModel.getEffectPath("fadein_close.ExportJson"),
			animationName = "fadein_close",
			loop = 1,
		})
	armature2:setAnchorPoint(ccp(layRoot.IMG_EFFECT_TIP:getAnchorPoint().x, layRoot.IMG_EFFECT_TIP:getAnchorPoint().y))
	armature2:setPosition(ccp(layRoot.IMG_EFFECT_TIP:getPositionX(), layRoot.IMG_EFFECT_TIP:getPositionY()))
	layRoot:addNode(armature2)
	-- 闪烁动作
	-- local action = WorldBossModel.getBlinkAction()
	-- armature2:runAction(action)

	-- 战斗结束特效
	layRoot.img_title:setVisible(false)
	local actions = CCArray:create()
	actions:addObject(CCDelayTime:create(0.1))
	actions:addObject(CCCallFuncN:create(function ( ... )
		local armature3 = UIHelper.createArmatureNode({
			filePath = WorldBossModel.getEffectPath("fight_end.ExportJson"),
			animationName = "fight_end",
		})
		armature3:setAnchorPoint(ccp(0.5, 0.5))
		armature3:setPosition(ccp(layRoot.img_title:getPositionX(), layRoot.img_title:getPositionY() + layRoot.img_title:getContentSize().height/2))
		layRoot.LAY_MAIN.IMG_BG:addNode(armature3, 10)
	end))
	layRoot:runAction(CCSequence:create(actions))

	-- 查看战报
	layRoot.BTN_REPORT:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playSendReport()
			local brid = BattleState.getBattleBrid()
			local curDBBoss = WorldBossModel.getActvieBossDb()
			UIHelper.sendBattleReport(brid, m_i18n[7811], curDBBoss.name)
		end
	end)

	return self.layMain
end
