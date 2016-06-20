-- FileName: GCDistributionCtrl.lua
-- Author: zhangjunwu
-- Date: 2015-06-05
-- Purpose: 工会副本战利品分配Ctrl

module("GCDistributionCtrl", package.seeall)

require "script/module/guildCopy/GCDistributionView"
require "script/module/guildCopy/GCDistriPeopleCtrl"
require "script/module/guildCopy/GCRewardQueueModel"
-- UI控件引用变量 --

-- 模块局部变量 --
local _tbAllRewardInfo   	 = {}
local _tbEvent = {}
local _tbQueueData = {}

local function init(...)
end

function destroy(...)
	package.loaded["GCDistributionCtrl"] = nil
end

function moduleName()
    return "GCDistributionCtrl"
end

_tbEvent.onDistribution = function ( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then 
		AudioHelper.playInfoEffect() 

		local nIndex = sender:getTag()
		logger:debug(nIndex)
		local tbDistriInfo = _tbAllRewardInfo[tonumber(nIndex) + 1]

		if (not GuildDataModel.getMemberInfoList()) then 
			GuildDataModel.sendRequestForMemberList( function ( ... )
				GCDistriPeopleCtrl.create(tbDistriInfo)
			end )
		else
			GCDistriPeopleCtrl.create(tbDistriInfo)
		end

	end 
end


local m_i18n = gi18n
function getDisTriTimeDesByInterval( timeInt )
	timeInt = tonumber(timeInt)
	if (timeInt<0) then --liweidong 有负数情况需要使用本方法
		timeInt = 0
	end
	local result = ""
	local oh	 = math.floor(timeInt/3600)
	local om 	 = math.floor((timeInt - oh*3600)/60)
	local os 	 = math.floor(timeInt - oh*3600 - om*60)
	local hour = oh
	local day  = 0
	if(oh>=24) then
		day  = math.floor(hour/24)
		hour = oh - day*24
	end
	if(day ~= 0) then
		result = result .. day .. m_i18n[1937]
	end
	if(hour ~= 0) then
		result = result .. hour .. m_i18n[1977]
	end
	if(om ~= 0) then
		result = result .. om .. m_i18n[5411]
	end
	return result
end


--获取距离自动发奖的时间字符串	
function getTimeStrToAutoReward( ... )
	local timeToAutoReward = 0
	local timeToAutoRewardDes = ""
	--返回今天本公会手动发奖的次数
	local disNum = GuildCopyModel.getRewardDistributeNum()
	local curTime = TimeUtil.getSvrTimeByOffset()
	curTime = tonumber(curTime)

	local tbRewardTimeArry  = string.split(DB_Legion_copy_build.getDataById(1).reward_time, "|")


	local nLastTime =  tbRewardTimeArry[#tbRewardTimeArry]
	local nStartTime =  tbRewardTimeArry[1]
	-- local nCurTime =  tbRewardTimeArry[disNum + 1]
	local nCurTimeInt = 0 --TimeUtil.getIntervalByTime(nCurTime)


	for i,v in pairs(tbRewardTimeArry) do
		local timeInt = TimeUtil.getIntervalByTime(v)
		-- logger:debug(timeInt)
		-- logger:debug(curTime)
		if(curTime < timeInt) then
			nCurTimeInt = timeInt
			break
		end
	end

	-- logger:debug(tbRewardTimeArry)
	-- logger:debug(tbRewardTimeArry[1])
	-- logger:debug(tbRewardTimeArry[2])
	-- logger:debug(nCurTime)
	-- logger:debug(disNum)
	local nStartTimeInt = TimeUtil.getIntervalByTime(nStartTime)
	local nLastTimeInt = TimeUtil.getIntervalByTime(nLastTime)
	-- logger:debug(nStartTime)
	-- logger:debug(nCurTime)
	-- logger:debug(nLastTime)
	-- logger:debug({nStartTimeInt = nStartTimeInt})
	-- logger:debug({nCurTimeInt = nCurTimeInt})
	-- logger:debug(nLastTimeInt)
	--当前时间已经超过了当日发奖的最后截之日起
	if(curTime > nLastTimeInt) then
		nStartTimeInt = nStartTimeInt + 24 * 3600
			-- logger:debug({nStartTimeInt = nStartTimeInt})
			-- logger:debug({nStartTimeInt = TimeUtil.getServerDateTime(nStartTimeInt)})
			-- logger:debug({curTime = curTime})
		timeToAutoReward = nStartTimeInt - curTime
		-- logger:debug({timeToAutoReward = timeToAutoReward})

	else
		timeToAutoReward =  nCurTimeInt   - curTime
	end
	logger:debug(timeToAutoReward)
	local a =timeToAutoReward % 60 
	timeToAutoRewardDes = getDisTriTimeDesByInterval(timeToAutoReward - a)
	logger:debug(timeToAutoRewardDes)

	return timeToAutoRewardDes
end


function setTitleDataByCopyId(_copyId)
	local rewardCount = 0
	local titleDataIndex = 0
	for i,v in ipairs(_tbAllRewardInfo) do
		if(v.copyId == _copyId) then
			rewardCount = rewardCount + 1
			if(rewardCount == 1) then
				titleDataIndex = i
			end
		end
	end
	if(rewardCount <= 1) then
		table.remove(_tbAllRewardInfo,titleDataIndex)
	end
end

--更新分配的数据
function updateRewardDataByUid( _Uid ,_copyId)
	for i,v in ipairs(_tbAllRewardInfo) do
		local tbQueueInfo = v.queue
		logger:debug(tbQueueInfo)
		 for ii,vv in ipairs(tbQueueInfo or {}) do
		 	if(tonumber(vv.uid) == tonumber(_Uid)) then
		 		--从队列中删除此用户
		 		table.remove(tbQueueInfo,ii)
		 		v.visibleNum = v.visibleNum - 1
		 		if(v.visibleNum <= 0 or table.count(tbQueueInfo) <=0) then
		 			-- v = nil
		 			table.remove(_tbAllRewardInfo,i)
		 		end
		 		--副本cell对应的记录队列数据更新
		 		setTitleDataByCopyId(_copyId)
		 		return
		 	end
		 end
	end
end


--更新数据并刷新UI
function updateRewardListView(_Uid ,_copyId)
	updateRewardDataByUid(_Uid,_copyId)
	GCDistributionView.updateListView(_tbAllRewardInfo)
end

-- 更具uid 获得伤害值
local function getHiDamageByUid(copyInfo,userInfo)
	for k,v in pairs(copyInfo.va_gc.membHiDamageList) do
		if(tonumber(k) == tonumber(userInfo.uid)) then
			logger:debug(v.hp)
			return tonumber(v.hp)
		end
	end
	return  0
end

--[[desc:获取发奖需要的奖励队列数据
    copyid: 副本id
    return: 是否有返回值，返回值说明  
—]]
function getDistriRewardData( copyid )
	copyid = tostring(copyid)
	local tbGuildData = _tbQueueData
	if (tbGuildData[copyid]==nil or tbGuildData[copyid].va_gc==nil) then 
		return nil
	end 

	local tbData = tbGuildData[copyid].va_gc.rewardQueue or {}
	
	for k,v in pairs(tbData) do 
		v.detail,v.visibleNum = GCRewardQueueModel.getDetailByTime(v.detail,v.rewardConf[3])
	end 

	table.sort(tbData,function ( a,b )
		return a.visibleNum > b.visibleNum
	end)

	return tbData
end

--获取所有可分配的数据
function getRewardInfo()
	_tbAllRewardInfo = {}
	for copyId,tbCopyInfo in pairs(_tbQueueData) do
			local arrReward = getDistriRewardData(copyId) or {}
			local bIsCopyEnter = false
			local tbCopyTitleInfo = {}
			for k,v in pairs(arrReward) do
				logger:debug(v)
				v.copyId = copyId
				local queue = v.queue or {} --物品的队列

				local queueCount = table.count(queue)
				local tbData = GCRewardQueueModel.getIconAndNameByOne(v)
				v.rewardType = v.rewardConf[1]
				v.subType = v.rewardConf[2]
				v.copyId = copyId

				local visibleNum = tonumber(v.visibleNum)
				if(queueCount > 0 and visibleNum > 0) then
					if(bIsCopyEnter == false) then
						tbCopyTitleInfo.copyId = copyId
						-- 奖励表数据
						local copyDb = DB_Legion_newcopy.getDataById(copyId)
						tbCopyTitleInfo.copyName = copyDb.name
						table.insert(_tbAllRewardInfo,tbCopyTitleInfo)
						bIsCopyEnter = true
					end

					for iii,vUid in pairs(queue) do
						vUid.HiDamage = getHiDamageByUid(tbCopyInfo,vUid)
						vUid.copyHp = tbCopyInfo.copyHp
					end
					table.insert(_tbAllRewardInfo,v)
				end
			end
	end
	logger:debug(_tbAllRewardInfo)
end

function create(tbQueueData)
	init()
	_tbQueueData = tbQueueData
	getRewardInfo()

	local distriView = GCDistributionView.create(_tbEvent,_tbAllRewardInfo)

	UIHelper.registExitAndEnterCall(distriView,
		function()
			-- init()
		end,
		function()
		end
	)

	LayerManager.addLayout(distriView)
end
