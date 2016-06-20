-- FileName: WorldBossModel.lua
-- Author: zhangqi
-- Date: 2015-01-19
-- Purpose: 世界Boss的数据存储和访问模块
--[[TODO List]]

module("WorldBossModel", package.seeall)

require "db/DB_Worldboss"
require "script/utils/TimeUtil"

-- 模块局部变量 --
local mTU = TimeUtil
local m_totalBoss = table.count(DB_Worldboss.Worldboss) -- 所有Boss总数
local m_dbBoss = nil -- 当前Boss在boss表里的数据
local m_allBoss = nil -- 所有Boss在表里的数据
local m_attackRank = nil -- 后端拉取的伤害排行榜数据
local m_BossInfo = nil -- enterBoss 返回的后端信息
local m_overInfo = nil

m_today = 0 -- 本次活动周几
local m_duration = 0 -- 本次活动的持续时间，单位秒

m_bossBegin = 0 -- 本次开启时间戳
m_bossEnd = 0 -- 本次结束时间戳
local m_offset = 0
local mBossKillName = nil
local _tbPopDamage = {}	-- 弹出伤害框的信息 会根据关键帧分割成多分
BG_MUSIC	= "juqing_03.mp3"
BG_MUSIC2	= "jizhan_amb.mp3"

MSG = {
	BOSS_PLAY_ACTION = "BOSS_PLAY_ACTION",	-- boss受攻击	
	BOSS_PLAY_DEATH = "BOSS_PLAY_DEATH",	-- boss死亡
	BOSS_POP_DAMADGE = "BOSS_POP_DAMADGE",	-- 伤害弹出
	BOSS_ENTER_BATTLE = "BOSS_ENTER_BATTLE",	-- 进入战斗
	BOSS_EXIT_BATTLE = "BOSS_EXIT_BATTLE",	-- 退出战斗
}

function setDamageInfo( info )
	_tbPopDamage = info
end

function getDamageInfo( ... )
	return _tbPopDamage
end

local function getActiveBoss( wday )
	logger:debug("getActiveBoss")
	for i = 1, m_totalBoss do
		local boss = DB_Worldboss.getDataById(i)
		local tbWday = string.strsplit(boss.week, "|")
		if (table.include(tbWday, {tostring(wday)})) then
			return boss
		end
	end
end

local function getAllBoss( ... )
	m_allBoss = {}
	for i = 1, m_totalBoss do
		table.insert(m_allBoss, DB_Worldboss.getDataById(i))
	end
end

local function initInfo( ... )
	m_dbBoss = getActiveBoss(m_today) -- 读取当前Boss信息
	logger:debug("m_dbBoss:")
	logger:debug(m_dbBoss)

	local svrWday = mTU.getTodayWday()
	if(not svrWday) then
		svrWday = 1
	end
	local offset = (m_today - svrWday) * mTU.m_daySec
	-- logger:debug(string.format("m_today:%d, svrWday:%d", m_today, svrWday))
	-- logger:debug(offset)
	-- logger:debug(m_offset)
	logger:debug(mTU.getIntervalByTime(m_dbBoss.beginTime)) -- 1456578000 1456624800
	m_bossBegin = mTU.getIntervalByTime(m_dbBoss.beginTime) + offset + m_offset + TimeUtil.getOffsetFromLocalToSvr() -- 绝对时间戳
	m_bossEnd = mTU.getIntervalByTime(m_dbBoss.endTime) + offset + m_offset + TimeUtil.getOffsetFromLocalToSvr()
	m_duration = m_bossEnd - m_bossBegin
	logger:debug("m_duration:"..m_duration)
end

function init(...)
	if (m_dbBoss) then
		--return
	end

	getAllBoss() -- 读取所有Boss信息

	-- 根据服务器时间检测当前是周几，然后从配置表中读取当天开启的Boss信息
	local tbDate, tv_now = mTU.getServerDateTime()
	logger:debug("WorldBossModel-init-tbDate")
	logger:debug(tbDate)
	logger:debug(tv_now)

	m_today = mTU.getRealwday(tbDate.wday)
	-- local todayBoss = getActiveBoss(m_today)
	-- if (tv_now >= mTU.getIntervalByTime(todayBoss.endTime)) then
	-- 	updateToNextBossDb()
	-- else
		initInfo()
	-- end

	m_attackRank = {}
end

function destroy(...)
	package.loaded["WorldBossModel"] = nil
end

function moduleName()
    return "WorldBossModel"
end

function getActvieBossDb( ... )
	return m_dbBoss
end

-- 更新到下一次boss的信息
function updateToNextBossDb( ... )
	m_today = m_today % 7 + 1
	initInfo()
end

function getAllBossDb( ... )
	return m_allBoss
end

function getDuration( ... )
	return m_duration
end

-- 按当前显示的Boss读取对应的奖励信息
function getRewardPreview( ... )
	require "db/DB_Worldboss_preview"
	local arrPreview = DB_Worldboss_preview.getArrDataByField("bossid", m_dbBoss.id)
	table.sort(arrPreview, function ( data1, data2 )
		return (data1.order < data2.order)
	end)
	-- logger:debug("getRewardPreview")
	-- logger:debug(arrPreview)

	return arrPreview
end

function getEndCount( ... )
	local _, nowSvr = mTU.getServerDateTime()
	local passSec = nowSvr - m_BossInfo.start_time
	local endCount = m_duration - passSec
	logger:debug("duration = %d, nowSvr = %d, start_time = %d, endCount = %d", m_duration, nowSvr, m_BossInfo.start_time, endCount)
	return endCount
end

-- 将后端返回的boss信息处理后保存到 m_BossInfo
local function setBossInfo( enterBoss )
	logger:debug("setBossInfo")
	logger:debug(enterBoss)

	local intExcept = {["uname"] = true, ["boss_killer"] = true, ["top_three"] = true, }
	m_BossInfo = {}
	for k, v in pairs(enterBoss) do
		m_BossInfo[k] = intExcept[k] and v or tonumber(v) -- int类型的字段转成number类型再保存
	end
	logger:debug(m_BossInfo)
end

function loadEnterBossInfo( fnCallback )
	logger:debug("loadEnterBossInfo")
	RequestCenter.boss_enterBoss(function ( cbFlag, dictData, bRet )
		logger:debug("boss_enterBoss callback")
		if (bRet) then
			logger:debug(dictData.ret)

			setBossInfo(dictData.ret)
			init()

			if (fnCallback) then
				fnCallback(m_BossInfo)
			end
		end
	end, Network.argsHandlerOfTable({1}))
end

-- 拉取排行榜数据
function loadAttackRank( fnCallback )
	RequestCenter.boss_getAtkerRank(function ( cbFlag, dictData, bRet )
		logger:debug("WorldBossModel-loadAttackRank")
		logger:debug(dictData)
		if (bRet) then
			m_attackRank = dictData.ret
			if (fnCallback) then
				fnCallback(m_attackRank)
			end
		end
	end, Network.argsHandlerOfTable({1}))
end

function setBossOver( aidInfo )
	mBossKillName = aidInfo.uname
end

function setBossOverInfo( _setInfo)
	m_overInfo = _setInfo
	if(m_overInfo) then
		m_overInfo.uname = mBossKillName
		if(mBossKillName) then
			m_overInfo.boss_dead = 1 
		else
			m_overInfo.boss_dead = 0
		end
	end
	mBossKillName = nil
end

function getBossOverInfo( ... )
	return m_overInfo
end

function fnIsBossOver( ... )
	local pBool = mBossKillName and true or false
	if(not pBool) then
		pBool = m_overInfo and true or false
	end
	return pBool
end

function setAttackRank( arrRank )
	m_attackRank = arrRank or {}
end

function getAttackRank( ... )
	return m_attackRank
end

function setOffSetTime( pOffset )
	logger:debug(pOffset)
	m_offset = tonumber(pOffset) or 0
end

function getOffsetTime( ... )
	return m_offset or 0
end

function isBossDead( ... )
	if(m_BossInfo and m_BossInfo.boss_dead == 1) then
		return true
	end
	return false
end

function getBossImageParth( ... )
	return "images/base/hero/body_img/"
end

-- 获取伤害数值
function getRedNumber( value )
	logger:debug(value)
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("images/battle/number/battleWords.plist")
	local numLayer = CCNode:create()
	numLayer:setPosition(ccp(100, 100))
	local valueString = "-" .. value
	local x = 0
	for i=1, #valueString do
	  		 	
 		local singleChar 	= string.char(string.byte(valueString,i))
 		local frameName  	= "red_" .. singleChar .. ".png"
 		local frameData  	= CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
 		if(singleChar == nil or frameData == nil) then error("CCSpriteBatchNumber can't find :" .. frameName) end -- if end
 		 
 		local frameSprite 	= CCSprite:create()
 		   
 		frameSprite:setDisplayFrame(frameData)
        frameSprite:setAnchorPoint(ccp(0, 0.5))
        frameSprite:setCascadeOpacityEnabled(true)
		frameSprite:setPosition(x,0)
		local frameSpriteWidth = frameSprite:getContentSize().width
		x = x + frameSpriteWidth
		numLayer:addChild(frameSprite)
 	end
 	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("images/battle/number/battleWords.plist")
	return numLayer
end

-- 获取闪烁动作
function getBlinkAction( ... )
	local actions = CCArray:create()
	actions:addObject(CCDelayTime:create(0.5))
	actions:addObject(CCFadeOut:create(1.5))
	actions:addObject(CCFadeIn:create(1.5))
	return CCRepeatForever:create(CCSequence:create(actions))
end

-- 获取特效的完整路径
function getEffectPath( exportjson )
	assert(exportjson, "exportjson is empty!")
	return "images/effect/worldboss/"..exportjson
end

-- 随机获取boss受攻击动画名和关键帧
function randomBossEffect( ... )
	local data = {"boss_attack_03_1", "boss_attack_03_2", "boss_attack_03_3"}
	local index = math.random(1, #data + 1)
	local frame = {
		{2, 3, 4},
		{1},
		{5, 6, 7},
	}
	return data[index], frame[index]
end

function randomWaveEffect( ... )
	local data = {"boss_attack_04_1", "boss_attack_04_2"}
	return data[math.random(1, #data + 1)]
end

function randomSignEffect( ... )
	local data = {"boss_attack_05_1", "boss_attack_05_2", "boss_attack_05_3", "boss_attack_05_4"}
	return data[math.random(1, #data + 1)]
end

-- 开启倒计时
function getOpenCountdown( ... )
	--logger:debug("boss begin time:"..TimeUtil.getTimeFormatYMDHMS(m_bossBegin).." m_offset:"..m_offset)
	--logger:debug(TimeUtil.getTimeFormatYMDHMS(now))
	-- zhangqi, 2016-02-20, 因为m_bossBegin是个绝对时间戳，所以now也取当前的绝对时间戳
	local now = mTU.getSvrTimeByOffset()
	logger:debug("m_bossBegin:"..m_bossBegin)--1456580701 1456627501
	-- local _, now = mTU.getServerDateTime()
	local delta = m_bossBegin - now
	if (delta <= 0) then
		return 0
	end
	return TimeUtil.getTimeString(delta)
end

-- 结束倒计时
function getCloseCountdown( ... )
	-- local _, now = mTU.getServerDateTime()
	local now = mTU.getSvrTimeByOffset(0)
	-- local now = mTU.getSvrTimeByOffset()
	-- 修复防止m_BossInfo数据位nil
	local startTime = m_bossBegin
	if (m_BossInfo and m_BossInfo.start_time) then
		startTime = m_BossInfo.start_time-- - TimeUtil.getOffsetFromLocalToSvr()
	end
	local delta = startTime + getDuration() - now
	logger:debug("startTime:"..startTime)
	if (delta <= 0) then
		return 0
	end
	return TimeUtil.getTimeString(delta)
end

-- 贝里鼓舞倒计时
function getSilverInspireCountdown( ... )
	local _, now = mTU.getServerDateTime()
	local db_inspire = DB_Worldbossinspire.getDataById(1)
	local inspireCD = tonumber(db_inspire.inspireCd) or 0
	local endTime = (m_BossInfo.inspire_time_silver or 0) + inspireCD - TimeUtil.getOffsetFromLocalToSvr()
	local delta = endTime - now
	if (delta <= 0) then
		return 0
	end
	return TimeUtil.getTimeString(delta)
end

-- 攻击倒计时
function getAttackCountdown( ... )
	local db_inspire = DB_Worldbossinspire.getDataById(1)
	local nCD = tonumber(db_inspire.cd) or 0
	local nLast_time = tonumber(m_BossInfo.last_attack_time)
	-- local _, now = TimeUtil.getServerDateTime()
	local now = mTU.getSvrTimeByOffset()
	local delta = nLast_time + nCD - now
	if (delta <= 0) then
		return 0
	end
	return TimeUtil.getTimeString(delta)
end

--[[desc:返回开始时间的时间戳
    arg1: 无
    return: 开始时间的时间戳
—]]
function getBeginTime(  )
	return m_bossBegin
end

-- 返回世界boss开启状态
function isOpen( ... )
	-- 功能未开启
	if(not SwitchModel.getSwitchOpenState(ksSwitchWorldBoss,false)) then
		return false
	end
	-- 有击杀者，已关闭
	if (mBossKillName) then
		return false
	end
	logger:debug(mBossKillName)
	logger:debug(fnIsBossOver())
	logger:debug(getOpenCountdown())
	logger:debug(getCloseCountdown())
	logger:debug(m_BossInfo)

	-- 无击杀者，开始倒计时结束，开启
	if (getOpenCountdown() == 0) then
		if (getCloseCountdown() == 0) then
			return false
		end
		return true
	end
	-- 是否boss时间 1是 0非(boss死亡推送不会更新m_BossInfo，所以这个判断只是放在最后处理)
	if (m_BossInfo and m_BossInfo.boss_time == 1) then 
		return true
	end
	return false
end
