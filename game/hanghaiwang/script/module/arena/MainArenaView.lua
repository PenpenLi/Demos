-- FileName: MainArenaView.lua
-- Author: huxiaozhou
-- Date: 2014-05-09
-- Purpose: 页签和背景显示
--[[TODO List]]


module ("MainArenaView",package.seeall)
require "script/module/arena/ArenaItem"



local arena_challenge_json = "ui/arena_challenge.json"


-- 页签 
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbItem = {}
-- UI 控件
local m_mainWidget
local SCV_MAIN
local m_imgInfoBg
local bInArena

local function init(...)
	m_tbEvent = nil
	m_mainWidget = nil
	m_tbItem = {}
end

function destroy(...)
	package.loaded["MainArenaView"] = nil
end

function moduleName()
    return "MainArenaView"
end

function addShip( )
	TimeUtil.timeStart("BoatEff")	
	local innerSize = SCV_MAIN:getInnerContainerSize()
	ArenaData.allUserData = ArenaData.getOpponentsData() 
	local tbPos = ArenaData.getShipPosition()
	ArenaItem.destroy()
	ArenaItem.create()
	for index,val in ipairs(ArenaData.allUserData) do
		val.index = index
		
		performWithDelayFrame(SCV_MAIN, function ( ... )
			local itemModule = ArenaItem.createBoat(val)
			SCV_MAIN:addChild(itemModule,1)
			m_tbItem[tostring(index)] = itemModule
			itemModule:setPosition(ccp(tbPos[#tbPos-index+1].x, tbPos[#tbPos-index+1].y))	
		end,index)

	end
	TimeUtil.timeEnd("BoatEff")
end


function updateInfo(  )
	TimeUtil.timeStart("updateInfo1")
	local i18ntfd_times_remain = m_fnGetWidget(m_imgInfoBg, "tfd_times_remain") -- 今日剩余次数：
	local lay_times_fit = m_fnGetWidget(m_imgInfoBg, "lay_times_fit")
	local TFD_TIMES_OWN = m_fnGetWidget(lay_times_fit, "TFD_TIMES_OWN") -- 当前有挑战次数
	local TFD_TIMES_MAX = m_fnGetWidget(lay_times_fit, "TFD_TIMES_TOTAL") -- 当前可拥有的最大次数

	TFD_TIMES_OWN:setText(ArenaData.getTodayChallengeNum() or "")
	TFD_TIMES_MAX:setText(ArenaData.getChallengeTimes() or "")

	local TFD_ITEM_INFO = m_fnGetWidget(m_imgInfoBg, "TFD_ITEM_INFO") --拥有挑战券：
	local LAY_ITEM_FIT = m_fnGetWidget(m_imgInfoBg, "LAY_ITEM_FIT")
	local TFD_TIMES_OWN1 = m_fnGetWidget(LAY_ITEM_FIT, "TFD_TIMES_OWN") -- 当前有挑战次数
	TimeUtil.timeEnd("updateInfo1")
	TimeUtil.timeStart("updateInfo2")
	local  hasNumberS = 0
	local cacheInfoS = ItemUtil.getCacheItemInfoBy(60026)
    if( not table.isEmpty(cacheInfoS))then
        hasNumberS = cacheInfoS.item_num
    end
	TFD_TIMES_OWN1:setText(hasNumberS)

	logger:debug("ArenaData.getTodayChallengeNum() = %s",ArenaData.getTodayChallengeNum())
	logger:debug("hasNumberS = %s", hasNumberS)
	if ArenaData.getTodayChallengeNum() > 0 then
		i18ntfd_times_remain:setEnabled(true)
		lay_times_fit:setEnabled(true)
		TFD_ITEM_INFO:setEnabled(false)
		LAY_ITEM_FIT:setEnabled(false)
	elseif tonumber(hasNumberS) >0 then
		TFD_ITEM_INFO:setEnabled(true)
		LAY_ITEM_FIT:setEnabled(true)
		i18ntfd_times_remain:setEnabled(false)
		lay_times_fit:setEnabled(false)
	else
		logger:debug("XXXXXXXXXXXXX")
		TFD_ITEM_INFO:setEnabled(false)
		LAY_ITEM_FIT:setEnabled(false)
		i18ntfd_times_remain:setEnabled(true)
		lay_times_fit:setEnabled(true)
	end
TimeUtil.timeEnd("updateInfo2")
TimeUtil.timeStart("updateInfo3")
	local i18ntfd_highest_rank = m_fnGetWidget(m_imgInfoBg, "tfd_highest_rank") -- 历史最高排名：
	local TFD_RANK_NUM = m_fnGetWidget(m_imgInfoBg, "TFD_RANK_NUM") -- 最高排名
	TFD_RANK_NUM:setText(ArenaData.getMinPosition() or "")

	local LABN_RANK = m_fnGetWidget(m_imgInfoBg, "LABN_RANK") 
	LABN_RANK:setStringValue(ArenaData.getSelfRanking())

	local i18ntfd_prestige_now = m_fnGetWidget(m_imgInfoBg, "tfd_prestige_now") -- 可获得声望
	local TFD_PRESTAGE = m_fnGetWidget(m_imgInfoBg, "TFD_PRESTAGE")

	local tfd_gain_belly = m_fnGetWidget(m_imgInfoBg, "tfd_gain_belly") -- 可获得贝里
	local TFD_BELLY = m_fnGetWidget(m_imgInfoBg, "TFD_BELLY")

	local silverData,prestigeData = ArenaData.getAwardItem(ArenaData.getSelfRanking(),UserModel.getUserInfo().level)
	TFD_BELLY:setText(silverData)
	TFD_PRESTAGE:setText(prestigeData)
	local i18ntfd_des = m_fnGetWidget(m_imgInfoBg, "tfd_des") -- 每日22:00发奖
	local i18ntfd_time = m_fnGetWidget(m_imgInfoBg, "tfd_time") --倒计时：
	local TFD_COUNTDOWN = m_fnGetWidget(m_imgInfoBg, "TFD_COUNTDOWN") 
	-- yucong 格式化成本地对应的时间
	local endTime = ArenaData.getAwardTime() + 1
	local tbTime = os.date("*t", endTime)
	i18ntfd_des:setText(string.format("%s%02d:%02d%s", m_i18n[2410], tbTime.hour, tbTime.min, "发奖"))

TimeUtil.timeEnd("updateInfo3")
	local time = ArenaData.getRefreshCdTime()
	if (time>0) then
		TFD_COUNTDOWN:setEnabled(true)
		local timeStr = TimeUtil.getTimeString(ArenaData.getRefreshCdTime())
		TFD_COUNTDOWN:setText(timeStr)
	else
		i18ntfd_time:setText(m_i18n[2260])
		TFD_COUNTDOWN:setEnabled(false)
	end
	--这种格式都要改成UIHelper.registExitAndEnterCall
	-- TFD_COUNTDOWN:registerScriptHandler(function ( eventType,node )
	-- 	if(eventType == "exit") then
	-- 		if(ArenaData.arenaScheduleId[1] ~= nil)then
	-- 			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(ArenaData.arenaScheduleId[1])
	-- 			ArenaData.arenaScheduleId[1] = nil
	-- 		end
	-- 		remove_arena_dataRefresh()
	-- 		bInArena = false
	-- 	end
	-- 	if eventType == "enter" then
	-- 		bInArena = true
	-- 		re_arena_dataRefresh()
	-- 	end
	-- end)
	UIHelper.registExitAndEnterCall(TFD_COUNTDOWN,function()
			if(ArenaData.arenaScheduleId[1] ~= nil)then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(ArenaData.arenaScheduleId[1])
				ArenaData.arenaScheduleId[1] = nil
			end
			remove_arena_dataRefresh()
			bInArena = false
		end,
		function()
			bInArena = true
			re_arena_dataRefresh()
		end)
	-- 更新倒计时
	local function updateRewardTime()
		if (ArenaData.getRefreshCdTime() < 0) then
			-- 到期取消定时器
			if(ArenaData.arenaScheduleId[1] ~= nil)then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(ArenaData.arenaScheduleId[1])
				ArenaData.arenaScheduleId[1] = nil
				i18ntfd_time:setText(m_i18n[2260])
				TFD_COUNTDOWN:setEnabled(false)
			end
			return
		end
		local timeStr = TimeUtil.getTimeString(ArenaData.getRefreshCdTime())

		TFD_COUNTDOWN:setText(timeStr)
	end
	if (ArenaData.getRefreshCdTime() > 0 ) then
		-- 启动定时器
		if( ArenaData.arenaScheduleId[1] == nil )then
			ArenaData.arenaScheduleId[1] = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateRewardTime, 1, false)
		end
	end


end

function updateChallengeTimes( ... )

	local LAY_ITEM_FIT = m_fnGetWidget(m_imgInfoBg, "LAY_ITEM_FIT")
	local TFD_TIMES_OWN1 = m_fnGetWidget(LAY_ITEM_FIT, "TFD_TIMES_OWN") -- 
	local TFD_ITEM_INFO = m_fnGetWidget(m_imgInfoBg, "TFD_ITEM_INFO") --拥有挑战券：
	local i18ntfd_times_remain = m_fnGetWidget(m_imgInfoBg, "tfd_times_remain") -- 今日剩余次数：
	
	local  hasNumberS = 0
	local cacheInfoS = ItemUtil.getCacheItemInfoBy(60026)
    if( not table.isEmpty(cacheInfoS))then
        hasNumberS = cacheInfoS.item_num
    end
	TFD_TIMES_OWN1:setText(hasNumberS)



	local TFD_TIMES_OWN = m_fnGetWidget(m_imgInfoBg, "TFD_TIMES_OWN") -- 当前有挑战次数
	local TFD_TIMES_MAX = m_fnGetWidget(m_imgInfoBg, "TFD_TIMES_TOTAL") -- 当前可拥有的最大次数

	TFD_TIMES_OWN:setText(ArenaData.getTodayChallengeNum() or "")
	TFD_TIMES_MAX:setText(ArenaData.getChallengeTimes() or "")
	local lay_times_fit = m_fnGetWidget(m_imgInfoBg, "lay_times_fit")
	lay_times_fit:requestDoLayout()

	if ArenaData.getTodayChallengeNum() > 0 then
		TFD_ITEM_INFO:setEnabled(false)
		LAY_ITEM_FIT:setEnabled(false)
		i18ntfd_times_remain:setEnabled(true)
		lay_times_fit:setEnabled(true)
	elseif tonumber(hasNumberS) >0 then
		TFD_ITEM_INFO:setEnabled(true)
		LAY_ITEM_FIT:setEnabled(true)
		i18ntfd_times_remain:setEnabled(false)
		lay_times_fit:setEnabled(false)
	else
		TFD_ITEM_INFO:setEnabled(false)
		LAY_ITEM_FIT:setEnabled(false)
		i18ntfd_times_remain:setEnabled(true)
		lay_times_fit:setEnabled(true)
	end



end

function reLoadUI(  )
	if bInArena then
		for key,item in pairs(m_tbItem or {}) do
			item:removeFromParentAndCleanup(true)
			m_tbItem[key] = nil
		end
		m_tbItem = {}
		updateInfo()
		addShip()
	end
end


function re_arena_dataRefresh_callback(cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		local ret = dictData.ret
		require "script/module/arena/ArenaData"
		-- 设置玩家排名
		ArenaData.setSelfRanking(ret.position)
		if(table.count(ret.opponents) ~= 0)then
			ArenaData.setOpponentsData( ret.opponents )
			reLoadUI()
		end
	end
end

function re_arena_dataRefresh()
	Network.re_rpc(re_arena_dataRefresh_callback, "re.arena.dataRefresh", "re.arena.dataRefresh")
end

function remove_arena_dataRefresh( ... )
	Network.remove_re_rpc("re.arena.dataRefresh")
end


function create( tbEvent)
	init()
	-- 滑动的竞技场界面
	TimeUtil.timeStart("loadJson")
	m_mainWidget = g_fnLoadUI(arena_challenge_json)
	m_mainWidget:setSize(g_winSize)
	TimeUtil.timeEnd("loadJson")

	local IMG_BG = m_fnGetWidget(m_mainWidget, "IMG_BG")
	IMG_BG:setScale(g_fScaleX)

	-- TimeUtil.timeStart("waterEff")

	-- require "script/module/public/EffectHelper"
	-- for i=1,3 do
	-- 	if i==1 then
	-- 		local imgEffect = m_fnGetWidget(IMG_BG, "IMG_EFFECT" .. i)
	-- 		local waterEff = EffArenaWater:new()
	-- 		imgEffect:addNode(waterEff:Armature())
	-- 	end
	-- end
	-- TimeUtil.timeEnd("waterEff")	


TimeUtil.timeStart("View init")
	local BTN_PLAYER = m_fnGetWidget(m_mainWidget, "BTN_PLAYER")
	BTN_PLAYER:removeFromParentAndCleanup(true)

	SCV_MAIN = m_fnGetWidget(m_mainWidget, "SCV_MAIN")
	SCV_MAIN:setTouchEnabled(true)
	m_imgInfoBg = m_fnGetWidget(m_mainWidget, "img_main_bg")
	
	-- 按钮 以及注册回调
	local btn_buzhen = m_fnGetWidget(m_mainWidget,"BTN_BUZHEN")
	btn_buzhen:addTouchEventListener(tbEvent.onBuZhen)

	-- 排行按钮
	local btn_rank = m_fnGetWidget(m_mainWidget,"BTN_RANK")
	btn_rank:addTouchEventListener(tbEvent.onRank)
	btn_rank:setTag(2)

	-- 商店按钮
	local btn_shop = m_fnGetWidget(m_mainWidget,"BTN_SHOP")
	btn_shop:addTouchEventListener(tbEvent.onShop)
	btn_shop:setTag(3)
	if ArenaData.getBShowRedPoint() then
		btn_shop.IMG_SHOP_TIP:addNode(UIHelper.createRedTipAnimination())
	end

	-- 返回按钮
	local btn_back = m_fnGetWidget(m_mainWidget,"BTN_CLOSE")
	btn_back:addTouchEventListener(tbEvent.onBack)
	UIHelper.titleShadow(btn_back, m_i18n[1019])
TimeUtil.timeEnd("View init")
TimeUtil.timeStart("updateInfo")
	updateInfo()
TimeUtil.timeEnd("updateInfo")
TimeUtil.timeStart("newGuide")
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideArenaView"
	if (GuideModel.getGuideClass() == ksGuideArena and GuideArenaView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createArenaGuide(3,nil,nil,function (  )
			GuideCtrl.removeGuide()
		end)
		GuideCtrl.setPersistenceGuide("arena","close") -- 保存记忆状态 已经走过竞技场引导
	end
TimeUtil.timeEnd("newGuide")
	UIHelper.registExitAndEnterCall(m_mainWidget, function ( ... )
		UIHelper.removeArmatureFileCache()
		ArenaItem.destroy()
	end)

	return m_mainWidget
end

