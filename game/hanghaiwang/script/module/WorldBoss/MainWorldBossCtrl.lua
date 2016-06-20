-- FileName: MainWorldBossCtrl.lua
-- Author:  wangming
-- Date: 2015-01-13
-- Purpose: 世界boss模块的控制层
--[[TODO List]]

module("MainWorldBossCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
m_MainView = nil -- 主界面引用对象, 暴露给外部用于UI的刷新
local m_WorldBossWin = nil
local mWorldBossModel = WorldBossModel

local function init(...)

end

function destroy(...)
	logger:debug("WorldBoss destroy")
	m_MainView:onExit()
	mWorldBossModel.setBossOverInfo(nil)
	m_WorldBossWin = nil
	m_MainView = nil
	package.loaded["MainWorldBossCtrl"] = nil
	package.loaded["script/module/WorldBoss/MainWorldBossCtrl"] = nil
	
	GlobalNotify.removeObserver(GlobalNotify.NETWORK_FAILED, moduleName())
    GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, moduleName())
end

function fnBack( ... )
	logger:debug("worldbossctrl fnback")
	if (m_MainView) then
		m_MainView:playMusic()
	end
end

function fnGo( ... )
	logger:debug("worldbossctrl retainFn")
	if (m_MainView) then
		m_MainView:clearMusic()
	end
end

function moduleName()
    return "MainWorldBossCtrl"
end

-- 攻略
local function onStrategy( ... )
	local curDBBoss = WorldBossModel.getActvieBossDb()
	local bossid = tonumber(curDBBoss.id)  --这里需要boss id
	AudioHelper.playStrategy()
	StrategyCtrl.create({
		type = 5, 
		name = curDBBoss.name, 
		param1 = bossid,
		-- 进入战斗
		callback1 = function ( ... )
			GlobalNotify.postNotify(WorldBossModel.MSG.BOSS_ENTER_BATTLE)
		end,
		-- 退出战斗
		callback2 = function ( ... )
			GlobalNotify.postNotify(WorldBossModel.MSG.BOSS_EXIT_BATTLE)
		end,
	})
end

-- 奖励预览
local function onPrereward( ... )
	require "script/module/WorldBoss/WorldBossRewardPreview"
	local view = WorldBossRewardPreview:new()
	LayerManager.addLayout(view:create())
end

local function fnGoRank( ... )
	require "script/module/WorldBoss/WorldBossRankView"
	local view = WorldBossRankView:new()
	LayerManager.addLayout(view:create())
end

-- 排行榜
local function onRank( ... )
	mWorldBossModel.loadAttackRank(fnGoRank)

	-- 测试WorldBossWinView
	--require "script/module/WorldBoss/WorldBossWinView"
 	--LayerManager.addLayoutNoScale(WorldBossWinView:new():create())
end

-- boss预览
local function onBossPreview( ... )
	require "script/module/WorldBoss/WorldBossPreview"
	local view = WorldBossPreview:new()
	LayerManager.addLayout(view:create())
end

local function eventWrapper( fnCallback )
	return function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			require "script/module/config/AudioHelper"
			AudioHelper.playCommonEffect()
			if (fnCallback) then
				fnCallback()
			end
		end
	end
end

--boss胜利界面
local function fnShowBossWin( ... )
	local pInfo = mWorldBossModel.getBossOverInfo()
	if(not pInfo) then
		logger:debug("not pInfo")
		return
	end
	require "script/battle/BattleModule"
	if(BattleState.isPlaying()) then
		logger:debug("BattleState.isPlaying()")
		return
	end
	fnGoBossWin()
end

function fnCloseBossWin( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
		m_WorldBossWin = nil
	end
end

function fnGoBossWin( ... )
	if(m_WorldBossWin) then
		return 
	end
	require "script/module/WorldBoss/WorldBossWinView"
	m_WorldBossWin = WorldBossWinView:new()
	LayerManager.addLayoutNoScale(m_WorldBossWin:create())
end

local function fnNetworkfailed_Back( ... )
	logger:debug("wm-----fnNetworkfailed_Back")
	if(m_MainView) then
		m_MainView:stopAllSchedAndNoti()
	end
end

local function fnReconn_ok_Back( ... )
	logger:debug("wm-----fnReconn_ok_Back")
	create(true)
end

--显示活动场景
function create( isNormalIn , pType)
	mWorldBossModel.loadEnterBossInfo(function ( tbBossInfo )
		tbBossInfo.events = {
				fnReward = eventWrapper(onPrereward),
				fnRank = eventWrapper(onRank), 
				fnBoss = eventWrapper(onBossPreview),
				fnStrategy = eventWrapper(onStrategy),
		}

		require "script/module/WorldBoss/WorldBossView"
		if(not m_MainView) then
			m_MainView = WorldBossView:new()
			GlobalNotify.addObserver(GlobalNotify.NETWORK_FAILED, fnNetworkfailed_Back , false , moduleName())
		    GlobalNotify.addObserver(GlobalNotify.RECONN_OK, fnReconn_ok_Back, false, moduleName())
		end
		local pGoType = pType or 0
		m_MainView:create(tbBossInfo , pGoType)
		logger:debug({tbBossInfo = tbBossInfo})
		if(not isNormalIn) then
			fnShowBossWin()
		end
	end)
end


