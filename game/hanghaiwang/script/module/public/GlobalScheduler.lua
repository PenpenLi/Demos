-- FileName: GlobalScheduler.lua
-- Author: zhangqi
-- Date: 2015-01-24
-- Purpose: 
-- 		唯一的全局定时调度器，调度间隔 1 秒；
--		允许其他模块根据一个name注册回调方法，如果name已存在则不能重复注册；
--		所有注册的回调方法默认按注册的先后顺序执行，也可以根据name注销这些方法
--[[TODO List]]

module("GlobalScheduler", package.seeall)


-- 模块局部变量 --
local m_scheduler = CCDirector:sharedDirector():getScheduler()
local m_fnUnScheduler = nil -- 停止全局定时器的方法
local m_tbCallbacks = {} -- 保存注册的回调方法
local m_tbIndependent = {} -- 保存创建独立定时器的id, 用于统一注销, 2015-06-01

local m_bossBegin = 0 -- boss的即将开启时间戳
local m_bossEnd = 0 -- boss的结束时间戳
-- local mWorldBossModel = WorldBossModel
local mFrameScheduleReleaseFun =nil --第针方法定时器


--- 检测 竞技场 是否到发奖时间 hxz
local getArenaRwardStatus = false --当前整点是否已经拉取过奖励 因为当前整点是一个时间区域，所以需要一个状态记录 liweidong
local function checkArenaSendReward( ... )
	if (SwitchModel.getSwitchOpenState(ksSwitchArena,false)) then
		--如果游戏卡的话，用等于某一时间点是不会执行的。把时间点定在一个区域里3秒
		if (TimeUtil.getIntervalByTime(220001) <= TimeUtil.getSvrTimeByOffset() and TimeUtil.getIntervalByTime(220004) >= TimeUtil.getSvrTimeByOffset()) then --TimeUtil.getSvrTimeByOffset()) then
			if (getArenaRwardStatus) then
				return
			end
			getArenaRwardStatus = true
			-- 到期拉去竞技场奖励
			local time = math.random(4,5*60) -- 5分钟内随机一个时间点 至少从4秒开始计算，超出整点区域
			local fnUnSchedule = nil
			local function updateArena ( )
				-- logger:debug("timeDown == " .. time)
				if (time<=0) then
					RequestCenter.arena_sendRankReward()
					fnUnSchedule()
					getArenaRwardStatus = false
				end
				time = time - 1
			end
			fnUnSchedule = scheduleFunc(updateArena)
		end
	end
end
--检测 公会副本 是否到发奖时间 liweidong
local getGuildCopyRwardStatus = false --当前整点是否已经拉取过奖励 因为当前整点是一个时间区域，所以需要一个状态记录
local function checkGuildCopyReward()
	require "script/module/guild/GuildDataModel"
	require "script/module/guild/GuildUtil"
	if (SwitchModel.getSwitchOpenState(ksSwitchGuild,false) and GuildDataModel.getIsHasInGuild() and GuildUtil.isGuildCopyOpen()) then
		require "db/DB_Legion_copy_build"
		local guildDb=DB_Legion_copy_build.getDataById(1)
		local rewardTimeArr = lua_string_split(guildDb.reward_time, "|")
		for _,val in ipairs(rewardTimeArr) do
			--如果游戏卡的话，用等于某一时间点是不会执行的。把时间点定在一个区域里3秒
			if (TimeUtil.getIntervalByTime(tonumber(val)+1) <= TimeUtil.getSvrTimeByOffset() and TimeUtil.getIntervalByTime(tonumber(val)+4) >= TimeUtil.getSvrTimeByOffset()) then --TimeUtil.getSvrTimeByOffset()) then
				if (getGuildCopyRwardStatus) then
					return
				end
				getGuildCopyRwardStatus = true
				local time = math.random(4,2*60) -- 2分钟内随机一个时间点 至少从4秒开始计算，超出整点区域
				local fnUnSchedule = nil
				local function updateArena ( )
					-- logger:debug("timeDown == " .. time)
					if (time<=0) then
						RequestCenter.checkGuildCopyReward()
						fnUnSchedule()
						getGuildCopyRwardStatus = false
					end
					time = time - 1
				end
				fnUnSchedule = scheduleFunc(updateArena)
				break
			end
		end
	end
end

-- --到00:00:00副本中据点的攻打次数需要重置，连战cd需要重置240000
-- local function resetCopyAttackCount ( ... )
-- 	if (curServerTime == TimeUtil.getSvrIntervalByTime(240000)) then
-- 		-- 普通副本
-- 		local function preGetNormalCopyCallback( cbFlag, dictData, bRet )
-- 			if(bRet)then
-- 				logger:debug("preGetNormalCopyCallback")
-- 				DataCache.setNormalCopyData( dictData.ret )
-- 				require "script/module/copy/battleMonster"
-- 				battleMonster.resetNightConfig()
-- 			end
-- 		end
-- 		RequestCenter.getLastNormalCopyList(preGetNormalCopyCallback)
-- 	end
-- end
--到0点重置用户所有基本数据和UI显示 liweidong
local function resetCommonUserData()
	if (UserModel.createTimeMarkBySvrTime()==UserModel.getCurDataTimeMark()) then --数据标识一样，不需要重置数据
		return
	end
	--重新设置数据日期标识
	UserModel.setCurDataTimeMark()

	--######每一个模块留一个方法供调用，方法实现数据重置和相应UI刷新######--

	--####1、重置商店相关 功能主要有商店、宝箱、贝里等一些购买的功能。####--
	-- 由于购买次数数据都在一起，这里统一拉取数据，各个模块只需要更新UI刷新即可 liweidong
	-- 获取当前商店的信息
	function shopInfoCallback( cbFlag, dictData, bRet )
		if(dictData.err ~= "ok")then
			return
		end
		local _curShopCacheInfo = dictData.ret
		logger:debug(_curShopCacheInfo)
		DataCache.setShopCache(_curShopCacheInfo)
		--更新购买贝里UI
		ShopCtrl.resetShopUI()
		--其他
	end
	RequestCenter.shop_getShopInfo(shopInfoCallback)

	--####2、其他模块自己实现更新数据和UI功能####--
	--重置活动副本数据和ui显示
	require "script/module/copyActivity/MainCopyModel"
	MainCopyModel.resetAcopyData()
	--重置副本
	require "script/module/copy/MainCopy"
	MainCopy.resetCopyData()
	
	require "script/module/registration/MainRegistrationCtrl"
	MainRegistrationCtrl.resetView()
	require "script/module/achieve/MainAchieveCtrl"
	MainAchieveCtrl.resetView()	
	--占卜屋重置数据
	require "script/module/astrology/MainAstrologyModel"
	MainAstrologyModel.resetView()	
	--开服礼包重置数据
	require "script/module/accSignReward/MainAccSignView"
	MainAccSignView.fnFreshListView()

	-- 我的好友数据重置
	require "script/module/friends/MainFdsCtrl"
	MainFdsCtrl.refreashView()

	-- 深海监狱重置数据
	MainImpelDownCtrl.refreashResetTimes()

	-- 神秘招募数据刷新
	require "script/module/shop/MysRecruitView"
	MysRecruitView.resetView()

	-- 开宝箱数据刷新
	require "script/module/wonderfulActivity/buyBox/BuyBoxView"
	BuyBoxView.resetBuyBoxInfo()
end

function init(...)
	addCallback("checkArenaSendReward", checkArenaSendReward)
	-- addCallback("resetCopyAttackCount", resetCopyAttackCount) 已统一处理 liweidong
	addCallback("checkGuildCopySendReward", checkGuildCopyReward) --检测公会副本发奖
	
	addCallback("resetCommonUserData", resetCommonUserData) --liweidong 12点重置所有数据

	--liweidong 增加一个每一帧都回调的scheduler
	if (mFrameScheduleReleaseFun) then
		mFrameScheduleReleaseFun()
		mFrameScheduleReleaseFun = nil
	end
	mFrameScheduleReleaseFun = scheduleFunc(function()
			--第一帧都要执行的程序
			everyFrameEvent()
		end,0,false)
end

-- 开始调度
function schedule(...)
	if (m_fnUnScheduler) then
		return
	end

	init()

	m_fnUnScheduler = scheduleFunc(function ( ... )		
		for name, func in pairs(m_tbCallbacks) do
			if (type(func) == "function") then
				-- logger:debug("GlobalScheduler:do:%s", name)
				func()
			end
		end
	end)
end

-- 注册一个全局调度回调
-- sName, 字符串, 回调名字; fnCallback, 回调方法;
function addCallback( sName, fnCallback )
	if (m_tbCallbacks[sName]) then
		logger:debug("GlobalScheduler-addCallback: %s is exist", sName)
		return
	end
	m_tbCallbacks[sName] = fnCallback
	logger:debug("GlobalScheduler-addCallback: sName = %s", sName)
end

-- 注销一个全局调度回调
-- sName, 字符串, 回调名字;
function removeCallback( sName )
	if (m_tbCallbacks and m_tbCallbacks[sName]) then
		m_tbCallbacks[sName] = nil
		logger:debug("GlobalScheduler removeCallback: %s", sName)
	end
end

-- 启动一个定时调度器，
-- 参数：fnFunc, 回调方法；nInterval，调度间隔，默认1秒; 
--		bPaused, 为true则不会立即执行，直到调用了resume相关方法，默认为false, 立即开始计时
-- return: 注销改调度器的方法
function scheduleFunc( fnFunc, nInterval, bPaused )
	local schedulId = m_scheduler:scheduleScriptFunc(fnFunc, nInterval or 1, bPaused or false)
	logger:debug("scheduleFunc-id = %d", schedulId)

	print(debug.traceback())
	m_tbIndependent[schedulId] = true
	logger:debug({scheduleFunc_m_tbIndependent = m_tbIndependent})
	
	return function ( ... )
		if (schedulId ~= 0) then
			logger:debug("scheduleFunc stop schedule, id = %d", schedulId)
			m_tbIndependent[schedulId] = nil
			-- logger:debug({scheduleFunc_m_tbIndependent = m_tbIndependent})
			m_scheduler:unscheduleScriptEntry(schedulId)
		end
	end
end


function destroy(...)
	logger:debug("GlobalScheduler-destroy")

	-- zhangqi, 2015-06-01, 停止所有通过GlobalScheduler启动的独立定时器
	logger:debug({m_tbIndependent = m_tbIndependent})
	for schedulId, v in pairs(m_tbIndependent) do
		m_scheduler:unscheduleScriptEntry(schedulId)
		m_tbIndependent[schedulId] = nil
	end
	logger:debug({m_tbIndependent = m_tbIndependent})

	if (mFrameScheduleReleaseFun) then
		mFrameScheduleReleaseFun()
		mFrameScheduleReleaseFun = nil
	end
	m_fnUnScheduler = nil

	m_tbCallbacks = {}

	package.loaded["GlobalScheduler"] = nil
	package.loaded["script/module/public/GlobalScheduler"] = nil
	logger:debug("GlobalScheduler-destroy ok")
end

function moduleName()
    return "GlobalScheduler"
end
