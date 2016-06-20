-- FileName: WorldBossView.lua
-- Author: zhangqi
-- Date: 2015-01-19
-- Purpose: 世界Boss的主UI模块，和等待界面
--[[TODO List]]

-- module("WorldBossView", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_worldModel = WorldBossModel
local mLayerManager = LayerManager
local _tbEffectTags = {
	boss_atk_effect = 999991,
	boss_death_effect = 999992,
}
local _bgmId2 = nil

WorldBossView = class("WorldBossView")

function WorldBossView:ctor()
	self.layMain = g_fnLoadUI("ui/world_boss_main.json")
	self.layWait = m_fnGetWidget(self.layMain, "LAY_PREPARE")
	self.layFight = m_fnGetWidget(self.layMain, "LAY_FIGHTING")
end

function WorldBossView:init( ... )
	local tbEvents = self.m_enterInfo.events
	local layRoot = self.layMain

	self.layMain.img_bg:setScaleX(g_fScaleX) -- 背景图适配
	self.layMain.img_bg:setScaleY(g_fScaleY) -- 背景图适配
	self.layMain.img_tab:setScaleX(g_fScaleX)

	UIHelper.titleShadow(layRoot.BTN_CLOSE, m_i18n[1019])
	layRoot.BTN_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			RequestCenter.boss_leaveBoss()
			require "script/module/activity/MainActivityCtrl"
			MainActivityCtrl.create()
		end
	end)

	UIHelper.titleShadow(layRoot.BTN_RANK, m_i18n[2248])
	layRoot.BTN_RANK:addTouchEventListener(tbEvents.fnRank)

	UIHelper.titleShadow(layRoot.BTN_BOSS_PREVIEW, m_i18n[6001]) -- Boss预览
	layRoot.BTN_BOSS_PREVIEW:addTouchEventListener(tbEvents.fnBoss)

	UIHelper.titleShadow(layRoot.BTN_REWARD_PREVIEW, m_i18n[1952])
	layRoot.BTN_REWARD_PREVIEW:addTouchEventListener(tbEvents.fnReward)

	layRoot.TFD_BOSS_NAME:setText(self.m_dbBoss.name)
	UIHelper.labelNewStroke(layRoot.TFD_BOSS_NAME, g_FontInfo.strokeColor, 2)

	layRoot.BTN_REPORT:addTouchEventListener(tbEvents.fnStrategy)
	-- boss等级
	local pNumer = tonumber(self.m_enterInfo.level) or 1
	layRoot.TFD_LV:setText("Lv." .. pNumer)
	UIHelper.labelNewStroke(layRoot.TFD_LV, g_FontInfo.strokeColor, 2)
	
	layRoot.IMG_BOSS:setZOrder(-2)

	-- 背景特效
	local bgArmature = UIHelper.createArmatureNode({
			filePath = WorldBossModel.getEffectPath("boss_attack_01.ExportJson"),
			animationName = "boss_attack_01",
			loop = 1,
		})
	bgArmature:setAnchorPoint(ccp(layRoot.img_bg:getAnchorPoint().x, layRoot.img_bg:getAnchorPoint().y))
	bgArmature:setPosition(ccp(layRoot.img_bg:getPositionX(), layRoot.img_bg:getPositionY()))
	layRoot.LAY_MAIN:addNode(bgArmature, -3)

	local bgArmature2 = UIHelper.createArmatureNode({
			filePath = WorldBossModel.getEffectPath("boss_attack_02.ExportJson"),
			animationName = "boss_attack_02",
			loop = 1,
		})
	bgArmature2:setAnchorPoint(ccp(layRoot.img_bg:getAnchorPoint().x, layRoot.img_bg:getAnchorPoint().y))
	bgArmature2:setPosition(ccp(layRoot.img_bg:getPositionX(), layRoot.img_bg:getPositionY()))
	layRoot.LAY_MAIN:addNode(bgArmature2, -1)

	bgArmature:setScaleX(g_fScaleX)
	bgArmature:setScaleY(g_fScaleY)
	bgArmature2:setScaleX(g_fScaleX)
	bgArmature2:setScaleY(g_fScaleY)
end

function WorldBossView:initWaitView( ... )
	self.layFight:setEnabled(false)
	if(self.m_fight) then
		self.m_fight:stopScheduler()
	end
	self.layWait:setEnabled(true)
	if(not self.m_wait) then
		require "script/module/WorldBoss/WorldBossWaitView"
		local m_waitView = WorldBossWaitView
		self.m_wait = m_waitView:new(self.layMain)
	end
	self.m_wait:initView(self.m_enterInfo)
end

function WorldBossView:initFightView( ... )
	self.layWait:setEnabled(false)
	if(self.m_wait) then
		self.m_wait:stopWaitTimer()
	end
	self.layFight:setEnabled(true)
	if(not self.m_fight) then
		require "script/module/WorldBoss/WorldBossFightView"
		local m_fightView = WorldBossFightView
		self.m_fight = m_fightView:new(self.layMain)
	end
	self.m_fight:initView(self.m_enterInfo)
end

function WorldBossView:create( tbInfo , goType)
	self.m_enterInfo = tbInfo
	self.m_dbBoss = m_worldModel.getActvieBossDb()
	-- 注册onExit()
	UIHelper.registExitAndEnterCall(self.layMain, function ( ... )
		--GlobalScheduler.removeCallback("WorldBossView")
		logger:debug("WorldBossView Exit")
		self:onExit()
    end, function ( ... )
    	self:onEnter()
    end)
	if(tonumber(goType) == 0) then
		if(MainWorldBossCtrl.moduleName() ~= mLayerManager.curModuleName()) then
			self:init() -- 初始化公共的UI部分
		end
		if (tbInfo.boss_time == 0) then -- 等待界面
			self:initWaitView()
		elseif (tbInfo.boss_dead == 0) then -- 战斗中，Boss 没死
			self:initFightView()
		end
		if(MainWorldBossCtrl.moduleName() ~= mLayerManager.curModuleName()) then
			mLayerManager.changeModule(self.layMain, MainWorldBossCtrl.moduleName(), {1}, true)
			PlayerPanel.addForArena()
		end
	elseif (tonumber(goType) == 1) then -- 等待界面
		self:initWaitView()
	elseif (tonumber(goType) == 2) then -- 战斗中，Boss 没死
		self:initFightView()
	end
	self:setBossImg()

    if (GuideModel.getGuideClass() == ksGuideBoss and GuideBossView.guideStep == 2) then  
        GuideCtrl.createBossGuide(3,nil, nil, function (  )
        	GuideCtrl.removeGuide()
        end) 
    end 

end

function WorldBossView:playMusic( ... )
	logger:debug("worldboss playMusic")
	self:clearMusic()
	AudioHelper.stopMusic()
	AudioHelper.clearCache()
	AudioHelper.playSceneMusic(m_worldModel.BG_MUSIC)
	local musicState, _ = AudioHelper.getAudioState()
	logger:debug(musicState)
	if (musicState == "true") then
		_bgmId2 = AudioHelper.playEffect("audio/bgm/" .. m_worldModel.BG_MUSIC2, true)
	end
end

function WorldBossView:clearMusic( ... )
	if (_bgmId2) then
		AudioHelper.stopEffect(_bgmId2)
		_bgmId2 = nil
	end
end

function WorldBossView:setBossImg( ... )
	-- boss形象
	local pName = string.format("%sbody_elite_jinhaizhiwang.png",m_worldModel.getBossImageParth())--,self.m_dbBoss.model)
	local _, now = TimeUtil.getServerDateTime()
	local closeCountdown = WorldBossModel.getCloseCountdown()
	logger:debug("closeCountdown:"..closeCountdown)
	if(--[[now > WorldBossModel.m_bossEnd - 2]]closeCountdown == 0 or WorldBossModel.isBossDead()) then
		pName = string.format("%sbody_beat_jinhaizhiwang.png", m_worldModel.getBossImageParth())
	end
	self.layMain.IMG_BOSS:loadTexture(pName)
end

function WorldBossView:stopAllSchedAndNoti( ... )
	if(self.m_wait) then
		self.m_wait:stopWaitTimer()
	end
	if(self.m_fight) then
		self.m_fight:stopScheduler()
	end
end

function WorldBossView:getWaitView( ... )
	return self.m_wait
end

function WorldBossView:getFightView( ... )
	return self.m_fight
end

-- boss受攻击动作
function WorldBossView:fnMSG_BOSS_PLAY_ACTION( ... )
	local layRoot = self.layMain
	if (not layRoot.IMG_BOSS:isVisible()) then
		--logger:debug("正在播放一个动画呐~")
		return
	end
	layRoot.IMG_BOSS:setVisible(false)
	-- 受攻击动画
	local animationName, tFrame = WorldBossModel.randomBossEffect()

	-- 多次伤害的又不用了
	-- local damageInfo = WorldBossModel.getDamageInfo()
	-- logger:debug({damageInfo = damageInfo})
	-- -- 最大分割数
	-- damageInfo.maxnum = #tFrame
	-- -- 当前剩余分割数
	-- damageInfo.num = #tFrame
	-- WorldBossModel.setDamageInfo(damageInfo)
	local bossEffect = UIHelper.createArmatureNode({
			filePath = WorldBossModel.getEffectPath("boss_attack_03.ExportJson"),
			animationName = animationName,
			loop = -1,
			fnMovementCall = function ( sender, MovementEventType, frameEventName )
		 			if (MovementEventType == 1) then 
						sender:removeFromParentAndCleanup(true)
						layRoot.IMG_BOSS:setVisible(true)
					end
				end,
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				local isFrame = false
				for k,v in pairs(tFrame) do
					if (frameEventName == tostring(v)) then
						isFrame = true
					end
				end
				if (isFrame) then
					local waveEffect = UIHelper.createArmatureNode({
							filePath = WorldBossModel.getEffectPath("boss_attack_04.ExportJson"),
							animationName = WorldBossModel.randomWaveEffect(),
							loop = 0,
							fnMovementCall = function ( sender, MovementEventType, frameEventName )
					 			if (MovementEventType == 1) then 
									sender:removeFromParentAndCleanup(true)
								end
							end,
						})
					local pos = layRoot.IMG_BOSS:getWorldPosition()
					waveEffect:setPosition(ccp(pos.x, pos.y - 30))
					layRoot.LAY_MAIN:addNode(waveEffect, -2)

					local signEffect = UIHelper.createArmatureNode({
							filePath = WorldBossModel.getEffectPath("boss_attack_05.ExportJson"),
							animationName = WorldBossModel.randomSignEffect(),
							loop = 0,
							fnMovementCall = function ( sender, MovementEventType, frameEventName )
					 			if (MovementEventType == 1) then 
									sender:removeFromParentAndCleanup(true)
								end
							end,
						})
					signEffect:setPosition(layRoot.IMG_BOSS:getWorldPosition())
					layRoot.LAY_MAIN:addNode(signEffect, -2)
					-- 多次伤害的又不用了
					--GlobalNotify.postNotify(m_worldModel.MSG.BOSS_POP_DAMADGE)
				end 
			end,
		})
	bossEffect:setAnchorPoint(ccp(layRoot.IMG_BOSS:getAnchorPoint().x, layRoot.IMG_BOSS:getAnchorPoint().y))
	bossEffect:setPosition(ccp(layRoot.IMG_BOSS:getPositionX(), layRoot.IMG_BOSS:getPositionY()))
	layRoot.LAY_MAIN:addNode(bossEffect, -2)
end

-- 播放boss死亡动作
function WorldBossView:fnMSG_BOSS_DEATH_ACTION( ... )
	local info = WorldBossModel.getBossOverInfo()
	if (not info) then
		MainWorldBossCtrl.create(false, 1)
		assert(false, "world boss over info is NULL!")
		return
	end
	-- [boss死亡]，播放动画，然后切换；[没死亡]，直接切换
	if (tonumber(info.boss_dead) ~= 1) then
		MainWorldBossCtrl.create(false, 1)
		return
	end

	local layRoot = self.layMain
	layRoot.IMG_BOSS:setVisible(false)
	-- 受攻击动画
	local bossEffect2 = UIHelper.createArmatureNode({
			filePath = WorldBossModel.getEffectPath("boss_attack_03.ExportJson"),
			animationName = "boss_attack_03_3",
			loop = -1,
			fnMovementCall = function ( sender, MovementEventType, frameEventName )
		 			if (MovementEventType == 1) then 
						sender:removeFromParentAndCleanup(true)
						layRoot.IMG_BOSS:setVisible(true)
					end
				end,
		})
	bossEffect2:setAnchorPoint(ccp(layRoot.img_bg:getAnchorPoint().x, layRoot.img_bg:getAnchorPoint().y))
	bossEffect2:setPosition(ccp(layRoot.img_bg:getPositionX(), layRoot.img_bg:getPositionY()))
	bossEffect2:setTag(_tbEffectTags.boss_death_effect)
	layRoot.LAY_MAIN:addNode(bossEffect2, -2)
	
	local bossEffect = UIHelper.createArmatureNode({
			filePath = WorldBossModel.getEffectPath("boss_attack_06.ExportJson"),
			animationName = "boss_attack_06",
			loop = -1,
			fnMovementCall = function ( sender, MovementEventType, frameEventName )
		 			if (MovementEventType == 1) then 
						sender:removeFromParentAndCleanup(true)
					end
				end,
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if (frameEventName == "1") then
					MainWorldBossCtrl.create(false, 1)
				end 
			end,
		})
	bossEffect:setAnchorPoint(ccp(layRoot.img_bg:getAnchorPoint().x, layRoot.img_bg:getAnchorPoint().y))
	bossEffect:setPosition(ccp(layRoot.img_bg:getPositionX(), layRoot.img_bg:getPositionY()))
	layRoot.LAY_MAIN:addNode(bossEffect, 02)
end

-- 退出战斗
function WorldBossView:fnMSG_BOSS_EXIT_BATTLE( ... )
	self:playMusic()
end

-- 进入战斗
function WorldBossView:fnMSG_BOSS_ENTER_BATTLE( ... )
	self:clearMusic()
end

function WorldBossView:notifications( ... )
	return {
		[m_worldModel.MSG.BOSS_PLAY_ACTION]	= function () self:fnMSG_BOSS_PLAY_ACTION() end,
		[m_worldModel.MSG.BOSS_PLAY_DEATH] = function () self:fnMSG_BOSS_DEATH_ACTION() end,
		[m_worldModel.MSG.BOSS_ENTER_BATTLE] = function () self:fnMSG_BOSS_ENTER_BATTLE() end,
		[m_worldModel.MSG.BOSS_EXIT_BATTLE] = function () self:fnMSG_BOSS_EXIT_BATTLE() end,
	}
end

function WorldBossView:onEnter( ... )
	logger:debug("WorldBossView:onEnter")
	self:playMusic()
	for msg, func in pairs(self:notifications()) do
		GlobalNotify.addObserver(msg, func, false, msg.."WorldBossView")
	end
end

function WorldBossView:onExit( ... )
	for msg, func in pairs(self:notifications()) do
		GlobalNotify.removeObserver(msg, msg.."WorldBossView")
	end
	self:clearMusic()
	self:stopAllSchedAndNoti()
end
