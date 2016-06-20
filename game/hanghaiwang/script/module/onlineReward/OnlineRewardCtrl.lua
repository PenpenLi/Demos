-- FileName: OnlineRewardCtrl.lua
-- Author: menghao
-- Date: 2014-08-29
-- Purpose: 在线奖励ctrl


module("OnlineRewardCtrl", package.seeall)

require "script/module/onlineReward/OnlineRewardView"

-- 模块局部变量 --
local m_nCurID
local m_tbCurReward
local m_nFutureTime
local m_nAccumulateTime
local m_scheduleFlag = "onlineReward_schedule"

-- 是否已经领完所有奖励
function gotAll( ... )
	return m_tbCurReward == nil
end

function getFutureTime( ... )
	return m_nFutureTime
end

-- 获取是否可以领奖的状态
function canGetStat( ... )
	local leftTime = m_nFutureTime - TimeUtil.getSvrTimeByOffset()
	local bGet = leftTime <= 0 and true or false
	return bGet
end

-- 断线自动重连成功需要从后端拉取在线奖励信息进行前后同步
local function reGetTime( ... )
	RequestCenter.online_getOnlineInfo(function (cbFlag, dictData, bRet )
		if (bRet) then
			if (not table.isEmpty(dictData.ret)) then
				calFutureTime(dictData)
			end
		end
	end)
end

-- preRequest.lua 中调用
function calFutureTime( dictData )
	require "db/DB_Online_reward"
	local rewardNum = table.count(DB_Online_reward.Online_reward)

	local nStep = tonumber(dictData.ret.step)
	if ( nStep > rewardNum - 1) then -- 如果已经领取完了
		m_tbCurReward = nil
		m_nAccumulateTime = 0
		m_nFutureTime = 0
		return
	end

	m_nCurID = nStep + 1
	m_tbCurReward = DB_Online_reward.getDataById(m_nCurID)
	m_nAccumulateTime = tonumber(dictData.ret.accumulate_time)
	m_nFutureTime = TimeUtil.getSvrTimeByOffset() + m_tbCurReward.count_down_time - m_nAccumulateTime

	GlobalNotify.addObserver(GlobalNotify.RECONN_OK, reGetTime, nil, m_scheduleFlag) -- 2015-12-16
end


local function init(...)

end


function destroy(...)
	package.loaded["OnlineRewardCtrl"] = nil
end

function moduleName()
	return "OnlineRewardCtrl"
end

function updateTimer( leftTime )
	logger:debug("updateTimer leftTime = %s", leftTime)
	OnlineRewardView.updateUI(canGetStat(), leftTime)
end

local function receiveCallback( cbFlag, dictData, bRet )
	if (not bRet) then
		return
	end

	local function onlineDataCallback(cbFlag, dictData, bRet )
		if (bRet) then
			if (not table.isEmpty(dictData.ret)) then
				local tbGotReward = m_tbCurReward -- 保存当前已领奖励的引用以便构造全屏的领奖面板

				calFutureTime(dictData)

				if (m_tbCurReward == nil) then -- 本次已领取完所有奖励
					LayerManager.removeLayout() -- 关闭在线奖励对话框
					MainShip.removeOnlinRewardIcon() -- 删除主界面的在线奖励图标
					MainShip.removeOnlineRewardObserver() -- 注销断网重连通知

					GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, m_scheduleFlag) -- 2015-12-16
				else
					OnlineRewardView.upItems(m_tbCurReward, canGetStat())
					MainShip.startOnlineScheduler() -- zhangqi, 2015-09-10
				end

				local tbItem = {}
				for i=1,tbGotReward.reward_num do
					local tb = {}
					tb.icon = UIHelper.getItemIconAndUpdate(tbGotReward["reward_type" .. i], tbGotReward["reward_values" .. i])
					tb.name = tbGotReward["reward_desc" .. i]
					tb.quality = tbGotReward["reward_quality" .. i]
					table.insert(tbItem, tb)
				end

				local layReward = UIHelper.createGetRewardInfoDlg( gi18n[1930], tbItem)
				LayerManager.addLayout(layReward)
			end
		end
	end

	RequestCenter.online_getOnlineInfo(onlineDataCallback)
end

function create(...)
	local onGet = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			-- 判断背包是否已满
			for i = 1, tonumber(m_tbCurReward.reward_num) do
				local rewardType = tonumber(m_tbCurReward["reward_type" .. i])
				if (rewardType == 4 or rewardType == 5 or rewardType == 6 or rewardType == 7) then
					if ItemUtil.isPropBagFull(true) or ItemUtil.isTreasBagFull(true) then
						AudioHelper.playCommonEffect() -- 2016-01-18，时间到但不可领取的按钮音效
						return
					end
				end
				if (rewardType == 10) then
					if ItemUtil.isPartnerFull(true) then
						AudioHelper.playCommonEffect() -- 2016-01-18，时间到但不可领取的按钮音效
						return
					end
				end
			end

			AudioHelper.playTansuo02() -- 2016-01-17， 可以领取的按钮音效

			local args = CCArray:create()
			args:addObject(CCInteger:create(m_nCurID))
			RequestCenter.online_gainGift(receiveCallback, args)
		end
	end

	local leftTime = m_nFutureTime - TimeUtil.getSvrTimeByOffset()
	leftTime = leftTime < 0 and 0 or leftTime

	local layMain = OnlineRewardView.create(onGet, canGetStat(), m_tbCurReward, leftTime)

	return layMain, updateTimer
end

