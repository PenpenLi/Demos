-- FileName: MainArenaCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-09
-- Purpose: 竞技场的页签控制模块
--[[TODO List]]


module ("MainArenaCtrl",package.seeall)

require "script/module/main/LayerManager"
require "script/module/arena/MainArenaView"
require "script/module/arena/ArenaRankCtrl"
require "script/module/arena/ArenaShopCtrl"
require "script/network/RequestCenter"
require "script/module/arena/ArenaData"
require "script/module/arena/ArenaCtrl"
require "script/module/arena/ArenaReward"

local m_i18n = gi18n
local m_i18nString = gi18nString

-- 背景界面
local m_arenaMain 

local m_arenaCurWidget
local m_arenaInfo
-- local m_bRemoveBattle = false    	--是否需要在加载玩竞技场的数据后  删除战斗场景

local function init(...)
	m_arenaMain = nil
	m_arenaCurWidget = nil
	m_bRemoveBattle = false
end

function destroy(...)
	m_arenaCurWidget = " "
	package.loaded["MainArenaCtrl"] = nil
end

function moduleName()
    return "MainArenaCtrl"
end




--[[desc:获取竞技场信息
    return: nil 
—]]
function getArenaInfo( callbackFunc )
	-- 获取竞技场信息callback
	local function getArenaInfoCallBack( cbFlag, dictData, bRet )
		if(bRet == true)then
			local dataRet = dictData.ret
			if(dataRet.ret == "lock")then
				ShowNotice.showShellInfo(m_i18n[2259])
				return
			end
			if(dataRet.ret == "ok")then
				ArenaData.arenaInfo = dataRet.res
				ArenaData.arenaInfo.reward_time = ArenaData.arenaInfo.reward_time + TimeUtil.getSvrTimeByOffset()
				-- 设置挑战列表数据
				ArenaData.setOpponentsData( dataRet.res.opponents )
				if callbackFunc ~= nil then
					callbackFunc()
				end
			end
		end
	end
	RequestCenter.arena_getArenaInfo(getArenaInfoCallBack)
end


-- 返回
function doBack(  )
    require "script/module/activity/MainActivityCtrl"
    local  layActivity  =  MainActivityCtrl.create()
    if (layActivity) then
        LayerManager.changeModule(layActivity, MainActivityCtrl.moduleName(), {1,3}, true)
        PlayerPanel.addForActivity()
    end
end

function createView(  )
	TimeUtil.timeEnd("Arena netWork")

	TimeUtil.timeStart("Arena Create View")
	-- 按钮事件
	local tbBtnEvent = {}
	-- 布阵按钮
	tbBtnEvent.onBuZhen = function( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/formation/Buzhen"
        	Buzhen.create()
		end	
	end
	-- 排行按钮
	tbBtnEvent.onRank = function( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			ArenaCtrl.create(ArenaCtrl.tbType.rank)
		end	
	end
	-- 兑换按钮
	tbBtnEvent.onShop = function (sender, eventType) 
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			ArenaCtrl.create(ArenaCtrl.tbType.shop)
		end
	end
	-- 退出按钮
	tbBtnEvent.onBack = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED)then
			AudioHelper.playBackEffect()
			doBack()
		end
	end

TimeUtil.timeStart("Arena ViewCreate")	
	m_arenaMain = MainArenaView.create(tbBtnEvent)
TimeUtil.timeEnd("Arena ViewCreate")

	if (m_arenaMain) then
	    -- modified by zhangjunwu  2014-08-18 
	    if(BattleState.isPlaying() == true) then
	    	--删除战斗场景 或者副本战斗升级界面，去竞技，防止界面跳转的时候 有副本界面的残留
	    	EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) 
	    	require "script/module/switch/SwitchCtrl"
            SwitchCtrl.postBattleNotification("END_BATTLE")
	    end
	     LayerManager.changeModule(m_arenaMain, "MainArenaCtrl", {1,3}, true)
	    
	      performWithDelay(m_arenaMain, function ( ... ) 
                    TimeUtil.timeStart("Arena addShip")
                    MainArenaView.addShip()
                    TimeUtil.timeEnd("Arena addShip")
                end,0.05)
 TimeUtil.timeStart("Arena PlayerPanel")
	    PlayerPanel.addForArena()
 TimeUtil.timeEnd("Arena PlayerPanel")
    end
    TimeUtil.timeEnd("Arena Create")
    TimeUtil.timeEnd("Arena Create View")
end


-- callbackFunc:回调
function getLuckyList( _callBack)
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true)then
			logger:debug(dictData)
			ArenaData.luckyListData = dictData.ret
			getArenaInfo(_callBack)
		end
	end
	RequestCenter.arena_getLuckyList(requestFunc)
end

function create()
	TimeUtil.timeStart("Arena Create")
	if(ArenaData.arenaScheduleId[1] ~= nil)then
		logger:debug("CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(ArenaData.arenaScheduleId[1])")
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(ArenaData.arenaScheduleId[1])
		ArenaData.arenaScheduleId[1] = nil
	end
	init()
	TimeUtil.timeStart("Arena netWork")
	getLuckyList(createView)
	g_fnLoadUI("ui/arena_challenge.json")
end


