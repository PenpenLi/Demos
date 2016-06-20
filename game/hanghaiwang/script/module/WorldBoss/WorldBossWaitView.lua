-- FileName: WorldBossWaitView.lua
-- Author: zhangqi
-- Date: 2014-01-31
-- Purpose: 世界Boss等待活动开启的UI部分
--[[TODO List]]

-- module("WorldBossWaitView", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

local m_NTU = TimeUtil
local m_bossModel = WorldBossModel
local _tColor = {
	normal1 = ccc3(0x28, 0x00, 0x00),
	normal2 = ccc3(0xff, 0x00, 0x00),
}

WorldBossWaitView = class("WorldBossWaitView")

function WorldBossWaitView:ctor(layRoot)
	self.layMain = m_fnGetWidget(layRoot, "LAY_PREPARE")
	UIHelper.registExitAndEnterCall(self.layMain, function () self:stopWaitTimer() end)
end

function WorldBossWaitView:stopWaitTimer( ... )
	logger:debug("WorldBossWaitView:stopWaitTimer")
	if (self.unregWaitNotify) then
		self.unregWaitNotify()
		self.unregWaitNotify = nil
	end
	if(self.gsUpdateName) then
		GlobalScheduler.removeCallback(self.gsUpdateName)
		self.gsUpdateName = nil
	end
	if (self._schedulId) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self._schedulId)
		self._schedulId = nil
	end
end

function WorldBossWaitView:fnUpdate( ... )
	local layer = self.layMain
	local countdown = WorldBossModel.getOpenCountdown()
	if (layer.TFD_TOMORROW and layer.TFD_TOMORROW:isEnabled()) then
		layer.TFD_TOMORROW:setEnabled(false)
	end
	local TFD_WAIT = m_fnGetWidget(layer, "TFD_WAIT")
	local TFD_WAIT_TIME = m_fnGetWidget(layer, "TFD_WAIT_TIME")
	local BTN_START = m_fnGetWidget(layer, "BTN_START")
	-- 可以开始打boss了
	if (countdown == 0) then
		self:stopWaitTimer()
		if(TFD_WAIT and TFD_WAIT:isEnabled()) then
			TFD_WAIT:setEnabled(false)
			if (TFD_WAIT_TIME) then
				TFD_WAIT_TIME:setEnabled(false)
			end
		end
		m_fnGetWidget(layer, "TFD_OPEN_TIME"):setVisible(false)
		m_fnGetWidget(layer, "tfd_ed"):setVisible(false)
		m_fnGetWidget(layer, "tfd_op"):setVisible(false)

		if(BTN_START and not BTN_START:isEnabled()) then
			BTN_START:setEnabled(true)
		end
	-- 没到时间 显示倒计时
	else
		if (TFD_WAIT and not TFD_WAIT:isEnabled()) then
			TFD_WAIT:setEnabled(true)
			if (TFD_WAIT_TIME) then
				TFD_WAIT_TIME:setEnabled(true)
			end
		end
		if (BTN_START and BTN_START:isEnabled()) then
			BTN_START:setEnabled(false)
		end
		if (TFD_WAIT_TIME) then
			TFD_WAIT_TIME:setText(countdown)
		end
		self.waitCount = self.waitCount - 1
	end
end

function WorldBossWaitView:showFinish( ... )
	if (self.layMain.TFD_TOMORROW and not self.layMain.TFD_TOMORROW:isEnabled()) then
		self.layMain.TFD_TOMORROW:setEnabled(true)
	end
end

function WorldBossWaitView:initView( enterInfo )
	self.m_enterInfo = enterInfo
	local baseInfo = self.m_enterInfo
	local layRoot = self.layMain

	self.m_dbBoss = m_bossModel.getActvieBossDb()

	UIHelper.titleShadow(layRoot.BTN_START, m_i18n[5530])
	layRoot.BTN_START:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("MainWorldBossCtrl---tostart")
			MainWorldBossCtrl.create(false, 2)
		end
	end)
	layRoot.BTN_START:setEnabled(false)
	layRoot.TFD_TOMORROW:setText(m_i18n[6022])--"今天活动已结束，请明天再来参加"
	layRoot.TFD_TOMORROW:setEnabled(false)
	UIHelper.labelNewStroke(layRoot.TFD_TOMORROW, _tColor.normal1, 2)

	layRoot.TFD_WAIT_TIME = m_fnGetWidget(layRoot, "TFD_WAIT_TIME") -- 活动开始倒计时
	layRoot.TFD_WAIT:setEnabled(false)
	layRoot.TFD_WAIT_TIME:setEnabled(false)
	UIHelper.labelNewStroke(layRoot.TFD_WAIT, _tColor.normal1, 2)
	UIHelper.labelNewStroke(layRoot.TFD_WAIT_TIME, _tColor.normal1, 2)

	local nowTv = m_NTU.getSvrTimeByOffset() -- 2016-02-26, 需要获取当前时间戳进行对比
	local count = m_bossModel.m_bossBegin - nowTv
	self.waitCount = count > 0 and count or (m_NTU.m_daySec + count) -- 保存开启倒计时的总秒数

	-- 注册app从后台切回前台的全局 Notify Observer, 重新计算倒计时的总秒数，避免受schedul被暂停的影响
	-- self:stopWaitTimer()
	-- self.unregWaitNotify = GlobalNotify.addObserverForForeground(
	-- 	"WorldBossWaitView", 
	-- 	function ( ... )
	-- 		logger:debug("WorldBossWaitView:initWaitView-applicationWillEnterForeground recv")
	-- 		local _, nowTv = m_NTU.getServerDateTime()
	-- 		local count = m_bossModel.m_bossBegin - nowTv
	-- 		self.waitCount = count > 0 and count or (m_NTU.m_daySec + count) -- 保存开启倒计时的总秒数
	-- 	end
	-- )

	if(nowTv > m_bossModel.m_bossEnd - 2 or m_bossModel.isBossDead()) then -- 结束，更新下一个Boss的信息；下一次触发自动进入未开启状态
		self:showFinish()
	else
		self.gsUpdateName = "WorldBossWaitView-updateEndTimer"
		GlobalScheduler.addCallback(self.gsUpdateName,
			function ( ... )
				self:fnUpdate()
			end)
		--self._schedulId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function () self:fnUpdate() end, 1, false)
	end
	logger:debug({baseInfo = baseInfo})
	local i18n_top3 = m_fnGetWidget(layRoot, "tfd_rank1")
	i18n_top3:setText(m_i18n[6023])--"上一轮前三："
	UIHelper.labelNewStroke(i18n_top3, _tColor.normal1, 2)
	for i = 1, 3 do
		local label = m_fnGetWidget(layRoot, "TFD_PLAYER_NAME"..tostring(i))
		local pInfo = baseInfo.top_three[i]
		local des = pInfo and pInfo.name or m_i18n[1093]
		if (i ~= 3) then
			des = des.."，"
		end
		label:setText(des)

		-- UIHelper.labelNewStroke(label, _tColor.normal1, 2) -- 2016-3-11描边又注掉了
	end
	-- TFD_PLAYER_NAME2停靠问题
	layRoot.TFD_PLAYER_NAME2:setAnchorPoint(ccp(0, 0.5))
	layRoot.TFD_PLAYER_NAME2:setPosition(ccp(layRoot.TFD_PLAYER_NAME1:getPositionX() + layRoot.TFD_PLAYER_NAME1:getContentSize().width, 
												layRoot.TFD_PLAYER_NAME2:getPositionY()))

	local i18n_killer = m_fnGetWidget(layRoot, "tfd_kill1")
	i18n_killer:setText(m_i18n[6024])
	UIHelper.labelNewStroke(i18n_killer, _tColor.normal1, 2)
	local labKiller = m_fnGetWidget(layRoot, "TFD_KILL_NAME1")
	local pname = baseInfo.boss_killer.uname == "" and m_i18n[1093] or baseInfo.boss_killer.uname
	labKiller:setText(pname or m_i18n[1093])
	-- UIHelper.labelNewStroke(labKiller, _tColor.normal1, 2) -- 2016-3-11描边又注掉了

	local labOpenTime = m_fnGetWidget(layRoot, "TFD_OPEN_TIME")
	local time = TimeUtil.getIntervalByTime(self.m_dbBoss.beginTime)
	time = time + WorldBossModel.getOffsetTime()
	-- 2016-02-27 不同时区不同显示
	local tbTime = os.date("*t", time + TimeUtil.getOffsetFromLocalToSvr())--TimeUtil.getServerDateTime(time)
	-- 2016-02-17，time是开始时间对应不同时区的时间戳 time已经是服务器时间，不需要再转换
	-- local tbTime = os.date("*t", time)

	local opH, opM = string.match(self.m_dbBoss.beginTime, "(%d%d)(%d%d)(%d%d)")
	labOpenTime:setText(string.format("%02d:%02d", tbTime.hour, tbTime.min))
	UIHelper.labelNewStroke(labOpenTime, _tColor.normal2, 2)

	layRoot.tfd_op:setText(m_i18n[4007])	-- "开启"
	layRoot.tfd_ed:setText(m_i18n[2314])	-- "每天"
	UIHelper.labelNewStroke(layRoot.tfd_op, _tColor.normal2, 2)
	UIHelper.labelNewStroke(layRoot.tfd_ed, _tColor.normal2, 2)

	-- local _, tv_now = m_NTU.getServerDateTime()
	-- self:updateWaitTimer(m_bossModel.m_bossBegin - tv_now)
end
