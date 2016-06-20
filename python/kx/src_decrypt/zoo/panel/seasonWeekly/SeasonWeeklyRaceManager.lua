require "zoo.panel.seasonWeekly.model.SeasonWeeklyRaceData"
require "zoo.panel.seasonWeekly.model.SeasonWeeklyMatchRankData"
require "zoo.panel.seasonWeekly.model.SeasonWeeklyShowOffData"
require "zoo.panel.seasonWeekly.SeasonWeeklyRaceConfig"
require "zoo.panel.seasonWeekly.SeasonWeeklyRaceHttpUtil"
require "zoo.PersonalCenter.AchievementManager"

SummerWeeklyMatchEvents = {
	kDataChangeEvent = "weekly.summer.dataChange",
}

SeasonWeeklyRaceManager = class()

local startDate = {year = 2015, month=6, day=2, hour=0, min=0, sec=0}
local DAY_SEC	= 3600 * 24
local WEEK_SEC 	= DAY_SEC * 7

local _instance = nil

function SeasonWeeklyRaceManager:ctor()
	self.matchData = nil
	self.rankData = nil
	self.uid = nil
	self.levelId = nil
	self.wday = nil
	self.firstMondayTime = SeasonWeeklyRaceManager:getMondayTime(os.time(startDate))
end

function SeasonWeeklyRaceManager:getInstance()
	if not _instance then
		_instance = SeasonWeeklyRaceManager.new()
		_instance:init()
	end
	return _instance
end

function SeasonWeeklyRaceManager:init()
	self.uid = UserManager.getInstance().uid

	local time = Localhost:timeInSec()
    -- self.week = self:getWeek(time)
	self.wday = self:getWDay(time)
	self.levelId = self:calcLevelId()
end

function SeasonWeeklyRaceManager:getWeeklyRewards()
	return SeasonWeeklyRaceConfig:getInstance():getWeeklyRewards()
end

function SeasonWeeklyRaceManager:getWeek(time)
	time = time or Localhost:timeInSec()
	local diffTime = math.abs(time - self.firstMondayTime)
	local week = math.ceil((diffTime + 1) / WEEK_SEC)
	-- if week == 0 then week = 1 end
	return week
end

function SeasonWeeklyRaceManager:getWDay(time)
	time = time or Localhost:timeInSec()
	local wday = tonumber(os.date('%w', time))
	if wday == 0 then wday = 7 end
	return wday
end

function SeasonWeeklyRaceManager:onDataChanged(refreshRankList)
	print('wenkan hasEventListenerByName', GlobalEventDispatcher:getInstance():hasEventListenerByName(SummerWeeklyMatchEvents.kDataChangeEvent))
	GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(SummerWeeklyMatchEvents.kDataChangeEvent, {refreshRankList = refreshRankList}))
end

function SeasonWeeklyRaceManager:getAndUpdateMatchData()
	if not self.matchData then
		self.matchData = self:getMatchDataFromLocal()
	end
	if self:hasWeekChanged(self.matchData) then
		local time = Localhost:timeInSec()
	    -- self.week = self:getWeek(time)
		self.wday = self:getWDay(time)
		self.levelId = self:calcLevelId()

		self.matchData:resetWeeklyData()
		self.matchData.updateTime = time
		self:flushToStorage()
	else
		if self:hasDayChanged(self.matchData) then
			local time = Localhost:timeInSec()
			self.wday = self:getWDay(time)
			self.levelId = self:calcLevelId()

			self.matchData:resetDailyData()
			self.matchData.updateTime = time
			self:flushToStorage()
		end
	end
	-- print("getAndUpdateMatchData:", table.tostring(self.matchData))
	return self.matchData
end

function SeasonWeeklyRaceManager:getMondayTime(time)
	time = time or Localhost:timeInSec()
	local dateT = os.date("*t", time)
	dateT.hour = 0
	dateT.min = 0
	dateT.sec = 0
	local wday = dateT.wday - 1 -- 周日wday=1
	if wday == 0 then wday = 7 end -- 周日
	local mondayTime = os.time(dateT) - (wday - 1) * DAY_SEC
	return mondayTime
end

function SeasonWeeklyRaceManager:getLeftTime( ... )
	local nextMondyTime = self:getMondayTime() + WEEK_SEC
	local leftTime = nextMondyTime - Localhost:timeInSec()

	local leftDay = math.floor(leftTime/DAY_SEC)
	local leftHour = math.floor((leftTime - leftDay * DAY_SEC)/3600)
	local leftMinute = math.floor((leftTime - leftDay * DAY_SEC - leftHour * 3600)/60)

	return {
		leftDay = leftDay,
		leftHour = leftHour,
		leftMinute = leftMinute,
	}
end

function SeasonWeeklyRaceManager:calcLevelId()
	local config = SeasonWeeklyRaceConfig:getInstance()
    local levelIds = config.levelIds
    if not levelIds or #levelIds < 1 then
    	return nil
    end
    if not self.matchData then
		self.matchData = self:getMatchDataFromLocal()
	end
    local randomed = self.matchData.randomedIndices or {}
    local lastFinished = self.matchData.lastIndexFinished
    local haveGuide = GameGuide:sharedInstance():checkHaveGuide(230331)

    -- 如果没有玩过引导关 则强制进入引导关
    if haveGuide then
    	if lastFinished then
    		table.remove(self.matchData.randomedIndices)
    	end
		table.removeValue(self.matchData.randomedIndices, 230331)
		table.insert(self.matchData.randomedIndices, 230331)
		self.matchData.lastIndexFinished = false
		self:flushToStorage()
		return 230331
    end

    if #randomed == 0 or lastFinished then
    	local lastLevelId = randomed[#randomed]
    	if #randomed == #levelIds then
    		randomed = {}
    		self.matchData.randomedIndices = {}
    	end
    	while true do
    		local index = math.random(#levelIds)
    		if not table.indexOf(randomed, levelIds[index]) and levelIds[index] ~= lastLevelId then
    			table.insert(self.matchData.randomedIndices, levelIds[index])
    			self.matchData.lastIndexFinished = false
    			self:flushToStorage()
    			return levelIds[index]
    		end
    	end
    else
    	return randomed[#randomed]
    end

    -- 下方是理论上更稳定和高效的方式
    -- 但由于其中出现了哈希操作以及集合很小因此实际时间比上方纯随机并比对 的速度要慢很多
    -- 因此先使用上方的随机方式 如果集合变大可以再进行效率评估并确认是否采用下方的算法
    -- TIP：这个版本没有以上版本中的每轮最后和第一个两个的去重 我的懒癌又犯了……

 --    if #randomed == 0 or lastFinished then
 --    	if #randomed == #levelIds then
 --    		randomed = {}
 --    		self.matchData.randomedIndices = {}
 --    	end
 --    	local tmp = {}
	-- 	for i, v in ipairs(randomed) do
	-- 		tmp[v] = true
	-- 	end
 --    	levelIds = table.filter(levelIds, function(v)
 --    			return not tmp[v]
 --    		end)
 --    	local index = math.random(#levelIds)
	-- 	table.insert(self.matchData.randomedIndices, levelIds[index])
	-- 	self.matchData.lastIndexFinished = false
	-- 	self:flushToStorage()
	-- 	return levelIds[index]
 --    else
 --    	return randomed[#randomed]
 --    end
end

function SeasonWeeklyRaceManager:getLevelId()
	return self.levelId
end

function SeasonWeeklyRaceManager:isLevelReached(topLevelId)
	topLevelId = topLevelId or UserManager:getInstance().user:getTopLevelId()
	local minLevel = SeasonWeeklyRaceConfig:getInstance().minLevel or 31
	return topLevelId >= minLevel
end

function SeasonWeeklyRaceManager:loadData(onFinish, withAnim)
	local function onSuccess()
		if onFinish then onFinish() end
	end

	local function onFail( ... )
		self:getAndUpdateMatchData()
		if onFinish then onFinish() end
	end
	self:getMatchDataFromServer(onSuccess, onFail, not withAnim)
end

function SeasonWeeklyRaceManager:getMatchDataFromServer( onSuccess, onFail, inBackground )

	local function onRequestSuccess(evt)
		local matchData = Localhost.getInstance():readWeeklyMatchData()
		self.matchData = SeasonWeeklyRaceData:fromRespData(evt.data, matchData)
		local localData = Localhost.getInstance():readWeeklyMatchData()
		if localData then
			self.matchData:getLevelRandomDataFromLocal(localData)
		end
		self:flushToStorage()
		-- print("self.matchData", table.tostring(self.matchData))

		local time = Localhost:timeInSec()
	    -- self.week = self:getWeek(time)
		self.wday = self:getWDay(time)
		self.levelId = self:calcLevelId()

		if onSuccess then onSuccess(evt) end
	end

	local function onRequestFail(evt)
		if onFail then onFail(evt) end
	end

	local http = SeasonWeeklyRaceHttpUtil.newGetInfoHttp(inBackground, onRequestSuccess, onRequestFail, onRequestFail)

    http:syncLoad(self.levelId)
end

function SeasonWeeklyRaceManager:hasReward()
	local lastWeekRewards = self:getLastWeekRewards()
	if #lastWeekRewards > 0 then return true end
	local lastWeekRankRewards = self:getLastWeekRankRewards()
	if #lastWeekRankRewards > 0 then return true end

	local dailyReward = self:getNextDailyReward()
	if dailyReward and dailyReward.needMore == 0 and not dailyReward.nextDayReward then return true end

	local weeklyRewards = self:getNextWeeklyReward()
	for _, v in pairs(weeklyRewards) do
		if v.needMore == 0 and not v.hasReceived then return true end
	end
	return false
end

function SeasonWeeklyRaceManager:hasWeeklyRewards()
	local weeklyRewards = self:getNextWeeklyReward()
	for _, v in pairs(weeklyRewards) do
		if v.needMore == 0 and not v.hasReceived then return true end
	end
	return false
end

function SeasonWeeklyRaceManager:hasLastWeekRewards()
	local lastWeekRewards = self:getLastWeekRewards()
	if #lastWeekRewards > 0 then return true end
	local lastWeekRankRewards = self:getLastWeekRankRewards()
	if #lastWeekRankRewards > 0 then return true end
	return false
end

function SeasonWeeklyRaceManager:hasLastWeekRankRewards()
	local lastWeekRankRewards = self:getLastWeekRankRewards()
	if #lastWeekRankRewards > 0 then return true end
	return false
end

function SeasonWeeklyRaceManager:getMatchDataFromLocal()
	local matchData = self:readFromStorage()
	if not matchData then
		matchData = SeasonWeeklyRaceData.new()
	end
	return matchData
end

function SeasonWeeklyRaceManager:hasWeekChanged(oldData)
	return self:getWeek(Localhost:timeInSec()) > self:getWeek(oldData.updateTime)
end

function SeasonWeeklyRaceManager:hasDayChanged(oldData)
	local diffDay = compareDate(os.date("*t", Localhost:timeInSec()), os.date("*t", oldData.updateTime))
	return diffDay > 0
end

function SeasonWeeklyRaceManager:receiveDailyReward( rewardId, onSuccess, onFail )
	local function onReceiveSuccess(evt)
		if evt and evt.data then
			UserManager:getInstance():addRewards(evt.data.rewards)
			UserService:getInstance():addRewards(evt.data.rewards)
		end
		table.insert(self.matchData.receivedDailyRewards, rewardId)
		self:flushToStorage()
		DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_2016_get_dailyreward', reward_id=rewardId, day=self.wday}, true)
		if onSuccess then onSuccess(evt) end
	end

	local function onReceiveFail(event)
		local function localFail()
			onFail(event)
		end
        if event and event.data then
            CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative", localFail)
        end
		if onFail then onFail(event) end
	end

	local function onRequestCancel( event )
		if onFail then onFail(event) end
	end
	self:receiveReward(self.levelId, GetWeeklyRaceRewardsType.kDailyReward, rewardId, onReceiveSuccess, onReceiveFail, onRequestCancel)
end

function SeasonWeeklyRaceManager:receiveWeeklyReward( rewardId, onSuccess, onFail )
	local function onReceiveSuccess(evt)
		if evt and evt.data then
			UserManager:getInstance():addRewards(evt.data.rewards)
			UserService:getInstance():addRewards(evt.data.rewards)
		end
		table.insert(self.matchData.receivedWeeklyRewards, rewardId)
		self:flushToStorage()
		if not self:hasWeeklyRewards() then
			LocalNotificationManager.getInstance():cancelWeeklyRaceRewardNotification()
		end
		DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_2016_get_weeklyreward', reward_id=rewardId}, true)
		if onSuccess then onSuccess(evt) end
	end

	local function onReceiveFail(event)
		local function localFail()
			onFail(event)
		end
        if event and event.data then
            CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative", localFail)
        end
		if onFail then onFail(event) end
	end

	local function onRequestCancel( event )
		if onFail then onFail(event) end
	end
	self:receiveReward(self.levelId, GetWeeklyRaceRewardsType.kWeeklyReward, rewardId, onReceiveSuccess, onReceiveFail, onRequestCancel)
end

function SeasonWeeklyRaceManager:receiveLastWeekRewards(levelId, onSuccess, onFail )
	local function onReceiveSuccess(evt)
		if evt and evt.data then
			UserManager:getInstance():addRewards(evt.data.rewards)
			UserService:getInstance():addRewards(evt.data.rewards)
		end
		for _, rewardId in pairs(self.matchData.lastWeekRewards) do
			DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_2016_get_last_weeklyreward', reward_id=rewardId}, true)
		end
		self.matchData.lastWeekRewards = {}
		if self:hasLastWeekRankRewards() then
			DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_2016_get_last_weeklyreward', reward_id=6}, true)
			self.matchData.lastWeekRankRewards = {}
		end
		if onSuccess then onSuccess(evt) end
	end

	local function onReceiveFail(event)
		self.matchData.lastWeekRewards = {}
		self.matchData.lastWeekRankRewards = {}
        if event and event.data then
            CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative", onFail)
        end
		if onFail then onFail(event) end
	end
	local function onRequestCancel( event )
		self.matchData.lastWeekRewards = {}
		self.matchData.lastWeekRankRewards = {}
		if onFail then onFail(event) end
	end
	self:receiveReward(levelId, GetWeeklyRaceRewardsType.kLastWeekRewards, 0, onReceiveSuccess, onReceiveFail, onRequestCancel)
end

function SeasonWeeklyRaceManager:receiveLastWeekRankRewards(levelId, onSuccess, onFail )
	local function onReceiveSuccess(evt)
		local hasExtRewards = false
		local goldNum = 0
		if evt and evt.data and evt.data.rewards then
			if #evt.data.rewards > 1 then
				hasExtRewards = true
			end
			for _, v in pairs(evt.data.rewards) do
				if v.itemId == 2 then
					goldNum = goldNum + v.num
				end
			end
			UserManager:getInstance():addRewards(evt.data.rewards)
			UserService:getInstance():addRewards(evt.data.rewards)
		end

		-- local rewardId = 0
		-- if hasExtRewards and self.matchData then
		-- 	rewardId = self.matchData.lastWeekRank or 0
		-- end
		DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_2016_get_rankreward', num=goldNum}, true)

		self.matchData.lastWeekRankRewards = {}
		if onSuccess then onSuccess(evt) end
	end

	local function onReceiveFail(event)
		self.matchData.lastWeekRankRewards = {}
        if event and event.data then
            CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative", onFail)
        end
		if onFail then onFail(event) end
	end

	local function onRequestCancel( event )
		self.matchData.lastWeekRankRewards = {}
		if onFail then onFail(event) end
	end
	self:receiveReward(levelId, GetWeeklyRaceRewardsType.kLastWeekRankRewards, 0, onReceiveSuccess, onReceiveFail, onRequestCancel)
end

function SeasonWeeklyRaceManager:getLastWeekRewards()
	local rewards = {}
	local weeklyRewards = self:getWeeklyRewards()
	if self.matchData and self.matchData.lastWeekRewards and #self.matchData.lastWeekRewards > 0 then
		local weeklyRewards = self:getWeeklyRewards()
		if weeklyRewards and #weeklyRewards > 0 then
			for _, v in pairs(weeklyRewards) do
				if table.exist(self.matchData.lastWeekRewards, v.id) then
					table.insert(rewards, v)
				end
			end
		end
	end
	return rewards, 0
end

function SeasonWeeklyRaceManager:getLastWeekRewardsForRewardsPanel()
	local rewards = self:getLastWeekRewards()
	local rRewards = self:getLastWeekRankRewards()
	if #rRewards > 0 then
		table.insert(rewards, {items = rRewards, id = 6})
	end
	return rewards, 0
end

function SeasonWeeklyRaceManager:getLastWeekRankRewards()
	local levelId = self.levelId
	if self.matchData and self.matchData.lastWeekRankRewards and #self.matchData.lastWeekRankRewards > 0 then
		return self.matchData.lastWeekRankRewards, levelId, self.matchData.lastWeekRank, self.matchData.lastWeekSurpass
	end
	return {}, levelId, 0, 0
end

function SeasonWeeklyRaceManager:getLastWeekRankRewardsForRewardsPanel()
	local rewards, levelId, num1, num2 = self:getLastWeekRankRewards()
	local thisWeek = self:getWeek(Localhost:timeInSec())
	local lastWeek = self:getWeek(tonumber(CCUserDefault:sharedUserDefault():getStringForKey("game.weekly.summer.lask.rank")) or 0)
	if thisWeek == lastWeek then
		return {}, levelId, 0, 0
	end
	return rewards, levelId, num1, num2
end

function SeasonWeeklyRaceManager:setLastWeekRankRewardsCancelFlag()
	CCUserDefault:sharedUserDefault():setStringForKey("game.weekly.summer.lask.rank", tostring(Localhost:timeInSec()))
	CCUserDefault:sharedUserDefault():flush()
end

function SeasonWeeklyRaceManager:receiveReward(levelId, rewardType, rewardId, onSuccess, onFail, onCancel)
	local function onRequestSuccess(evt)
		if onSuccess then onSuccess(evt) end
	end
	local function onRequestFail(evt)
		if onFail then onFail(evt) end
	end
	local function onRequestCancel(evt)
		if onCancel then onCancel(evt) end
	end

	local http = SeasonWeeklyRaceHttpUtil.newGetRewardsHttp(onRequestSuccess, onRequestFail, onRequestCancel)
	
	local function afterLogin()
		http:syncLoad(levelId, rewardType, rewardId, self.wday)
	end
	RequireNetworkAlert:callFuncWithLogged(afterLogin, afterLogin, kRequireNetworkAlertAnimation.kSync)
end

function SeasonWeeklyRaceManager:onPlayMainLevel()
	self:getAndUpdateMatchData():addDailyLevelPlayCount(1)
	if self.matchData.dailyLevelPlay == SeasonWeeklyRaceConfig:getInstance().dailyMainLevelPlay then
		self.matchData:incrLeftPlay(SeasonWeeklyRaceConfig:getInstance().freePlayByMainLevel)
	end
	self:flushToStorage()
	self:onDataChanged()
end

function SeasonWeeklyRaceManager:getShareCount()
	return self.matchData.dailyShare
end

function SeasonWeeklyRaceManager:getDailyMaxScore()
	return self.matchData.dailyMaxScore
end

function SeasonWeeklyRaceManager:getWeeklyScore()
	return self.matchData.weeklyScore
end

function SeasonWeeklyRaceManager:onShareSuccess( onSuccess, onFail, onCancel )
	local function sendNotify()
		local function onNotifySuccess( evt )
			print('wenkan ', table.tostring(evt))
			if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
				self:getAndUpdateMatchData():addShareCount(1)
				local isAddCount = false
				if self.matchData.dailyShare == SeasonWeeklyRaceConfig:getInstance().dailyShare then
					self.matchData:incrLeftPlay(SeasonWeeklyRaceConfig:getInstance().freePlayByShare)
					isAddCount = true
				end
				self:flushToStorage()
				self:onDataChanged()
				if onSuccess then onSuccess(isAddCount) end
			else
				print('wenkan not mitalk')
				if type(evt.data) == "table" and type(tonumber(evt.data.extra)) == "number" then
					self.matchData:incrLeftPlay(tonumber(evt.data.extra))
					self:getAndUpdateMatchData():addShareCount((tonumber(evt.data.extra) > 0) and 1 or 0)
				end
				self:flushToStorage()
				self:onDataChanged()
				if onSuccess then onSuccess(tonumber(evt.data.extra)) end
			end
		end

		local function onNotifyFail(evt)
			if onFail then onFail(evt) end
		end

		local function onNotifyCancel(evt)
			if onCancel then onCancel() end
		end

		local http = SeasonWeeklyRaceHttpUtil.newOpNotifyHttp(onNotifySuccess, onNotifyFail, onNotifyCancel)
		-- if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		-- 	http:syncLoad(OpNotifyType.kAutumnWeekMatchShare, {})
		-- else
			http:syncLoad(OpNotifyType.kRdefSpringWeekMatchShare, {})
		-- end
	end

	local function onLoginFailed()
		if onFail then onFail() end
	end
	RequireNetworkAlert:callFuncWithLogged(sendNotify, onLoginFailed, kRequireNetworkAlertAnimation.kSync)
end

function SeasonWeeklyRaceManager:isDailyFirstShare()
	-- 需求 去掉分享面板上分享得次数功能
	return false
	-- return self.matchData.dailyShare < SeasonWeeklyRaceConfig:getInstance().dailyShare
end

function SeasonWeeklyRaceManager:onPaySuccess()
	self.matchData:incrLeftPlay(1)
	self:flushToStorage()
	self:onDataChanged()
end

-- TODO Localhost:timeInSec()与打开面板的时间差
function SeasonWeeklyRaceManager:getNextDayDailyRewards()
	local nextDayTime = Localhost:timeInSec() + DAY_SEC
	local wday = self:getWDay(nextDayTime)
    return self:getDailyRewardsByDay(wday)
end

function SeasonWeeklyRaceManager:getDailyRewardsByDay(wday)
	return SeasonWeeklyRaceConfig:getInstance():getDailyRewardsByDay(wday)
end

function SeasonWeeklyRaceManager:getNextDailyReward()
	local ret = nil

	local reward = nil
	local isAllReceived = false
	local wday = self:getWDay(Localhost:timeInSec())
	local todayRewards = self:getDailyRewardsByDay(wday)
	if todayRewards and #todayRewards > 0 then
		if #self.matchData.receivedDailyRewards < #todayRewards then
			for i = 1, #todayRewards do
				if not table.exist(self.matchData.receivedDailyRewards, i) then
					reward = todayRewards[i]
					break
				end
			end
		else
			isAllReceived = true
			local nextdayRewards = self:getNextDayDailyRewards()
			if nextdayRewards and #nextdayRewards > 0 then 
				reward = nextdayRewards[1]
			end
		end
	end

	if reward then
		ret = {}
		ret.id = reward.id
		ret.condition = reward.condition
		ret.needMore = 0
		if self.matchData.dailyMaxScore < reward.condition then
			ret.needMore = reward.condition - self.matchData.dailyMaxScore
		end
		ret.nextDayReward = isAllReceived
		ret.items = reward.items
	end

	-- print("getNextDailyReward:", table.tostring(ret))
	return ret
end

function SeasonWeeklyRaceManager:getNextWeeklyReward()
	local ret = {}

	local weeklyRewards = self:getWeeklyRewards()
	if weeklyRewards and #weeklyRewards > 0 then
		for i, reward in ipairs(weeklyRewards) do
			local rewardDetail = {}
			rewardDetail.id = reward.id
			rewardDetail.condition = reward.condition
			rewardDetail.needMore = 0
			if self.matchData.weeklyScore < reward.condition then
				rewardDetail.needMore = reward.condition - self.matchData.weeklyScore
			end
			rewardDetail.items = reward.items
			if table.exist(self.matchData.receivedWeeklyRewards, i) then
				rewardDetail.hasReceived = true
			else
				rewardDetail.hasReceived = false
			end
			table.insert(ret, rewardDetail)
		end
	end
	return ret
end

function SeasonWeeklyRaceManager:getLeftPlay()
	return self.matchData.leftPlay
end

function SeasonWeeklyRaceManager:canGetFreePlay()
	return not self:hasDailyShareCompleted() or not self:hasDailyLevelPlayCompleted()
end

function SeasonWeeklyRaceManager:hasDailyShareCompleted()
	return self.matchData.dailyShare >= SeasonWeeklyRaceConfig:getInstance().dailyShare
end

function SeasonWeeklyRaceManager:hasDailyLevelPlayCompleted()
	return self.matchData.dailyLevelPlay >= SeasonWeeklyRaceConfig:getInstance().dailyMainLevelPlay
end

function SeasonWeeklyRaceManager:getDailyLevelPlayCount()
	return self.matchData.dailyLevelPlay
end

function SeasonWeeklyRaceManager:getRankMinScore()
	return SeasonWeeklyRaceConfig:getInstance():getRankMinScore()
end

function SeasonWeeklyRaceManager:canShareChamp()
	if not self.rankData or self.rankData:getRankNum() < 5 then return false end

	local newRank = self.rankData and self.rankData:getMyRank() or 0
	if newRank > 0 then
		local data = self:getShowOffData()
		if newRank == 1 and data.dailyChampShared < 1 then
			return true
		end
	end
	return false
end

function SeasonWeeklyRaceManager:canShareSurpass()
	if not self.rankData or self.rankData:getRankNum() < 5 then return false end

	local newRank = self.rankData and self.rankData:getMyRank() or 0
	if self.oldRank and newRank > 0 then
		local data = self:getShowOffData()
		if self.oldRank == 0 or newRank < self.oldRank then -- 之前没有进入排行榜
			return self.rankData:getSurpassCount() > 0 and data.dailySurpassShared < 1
		end
	end
	return false
end

function SeasonWeeklyRaceManager:getSurpassFriends()
	if not self.rankData then return {} end
	return self.rankData:getSurpassFriends()
end

function SeasonWeeklyRaceManager:getShowOffData()
	if not self.showOffData then
		local extraData = Localhost:getInstance():readLocalExtraData()
		if extraData and extraData.summerWeeklyShowOff then 
			self.showOffData = SeasonWeeklyShowOffData:fromLua(extraData.summerWeeklyShowOff)
		end
	end
	if not self.showOffData or self.showOffData:hasExpired() then
		self.showOffData = SeasonWeeklyShowOffData:create()
	end
	return self.showOffData
end

function SeasonWeeklyRaceManager:onShareChampSuccess()
	local data = self:getShowOffData()
	data:incrChampShared()
	local extraData = Localhost:getInstance():readLocalExtraData() or {}
	extraData.summerWeeklyShowOff = data
	Localhost:getInstance():flushLocalExtraData(extraData)
	AchievementManager:onShareSuccess(AchievementManager.shareId.WEEKLY_FIRST_FRI_RANK, data)
end

function SeasonWeeklyRaceManager:onShareSurpassSuccess()
	local data = self:getShowOffData()
	data:incrSurpassShared()
	local extraData = Localhost:getInstance():readLocalExtraData() or {}
	extraData.summerWeeklyShowOff = data
	Localhost:getInstance():flushLocalExtraData(extraData)
	AchievementManager:onShareSuccess(AchievementManager.shareId.WEEKLY_GEM_OVER_FRIEND, data)
end

function SeasonWeeklyRaceManager:getTipShowTimes(tipType)
	local data = self:getShowOffData()
	return data:getTipShowCount(tipType)
end

function SeasonWeeklyRaceManager:onShowTip(tipType)
	local data = self:getShowOffData()
	data:onShowTip(tipType)
	-- save data
	local extraData = Localhost:getInstance():readLocalExtraData() or {}
	extraData.summerWeeklyShowOff = data
	Localhost:getInstance():flushLocalExtraData(extraData)
end

function SeasonWeeklyRaceManager:isShowDailyFirstTip()
	local data = self:getShowOffData()
	return data.showPlayTip
end

function SeasonWeeklyRaceManager:onShowDailyFirstTip()
	local data = self:getShowOffData()
	data.showPlayTip = false
	local extraData = Localhost:getInstance():readLocalExtraData() or {}
	extraData.summerWeeklyShowOff = data
	Localhost:getInstance():flushLocalExtraData(extraData)
end

function SeasonWeeklyRaceManager:getRankData( onSuccess, onFail )
	local levelId = self.levelId
	local function onRequestSuccess( evt )
		local rankList = evt.data.rankList
		self.rankData = SeasonWeeklyMatchRankData.new(self:getRankMinScore())
		local activeFriends = {}
		local myScore = 0
		if self.matchData and not self:hasWeekChanged(self.matchData) then
			activeFriends = self.matchData.activeFriends
			myScore = self.matchData.weeklyScore
		end
		self.rankData:initWithData(self.uid, rankList, activeFriends)
		self.rankData:updateMyScore(myScore)
		
		if onSuccess then onSuccess() end
	end

	local function onRequestFail(evt)
		-- if self.rankData and self.levelId == self.rankData.levelId then
		-- 	local myScore = self.matchData and self.matchData.weeklyScore or 0
		-- 	self.rankData:updateMyScore(myScore)
		-- else
		-- 	self.rankData = nil
		-- end
		self.rankData = nil
		if onFail then onFail(evt) end
	end
	local http = SeasonWeeklyRaceHttpUtil.newGetRankListHttp(onRequestSuccess, onRequestFail)
	http:load(CommonRankType.kWinterWeekMatch, 1, levelId)
end

function SeasonWeeklyRaceManager:flushToStorage()
	if self.matchData then
		Localhost.getInstance():writeWeeklyMatchData(self.matchData:encode())
	end
end

function SeasonWeeklyRaceManager:readFromStorage()
	local data = Localhost.getInstance():readWeeklyMatchData()
	if data then
		return SeasonWeeklyRaceData:fromLua(data)
	end
	return nil
end

function SeasonWeeklyRaceManager:onStartLevel()
	self.matchData:setLastPlayedTime()
	self:flushToStorage()
end

function SeasonWeeklyRaceManager:onPassLevel(levelId, targetCount)
	DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_2016_acorn_num', level_id=levelId, num=targetCount}, true)
	if self.rankData then
		self.oldRank = self.rankData:getMyRank()
	end
	if type(targetCount) == "number" and targetCount > 0 then
		self:getAndUpdateMatchData()
		self.matchData:addScore(targetCount)
		-- self:flushToStorage()
		-- self:onDataChanged(true)

		if self:hasWeeklyRewards() then
			LocalNotificationManager.getInstance():setWeeklyRaceRewardNotification()
		end
	end

	self.matchData:decrLeftPlay()
	self.matchData.totalPlayed = self.matchData.totalPlayed + 1
	self.matchData.lastIndexFinished = true
	self:flushToStorage()
	self:onDataChanged(false)
end

function SeasonWeeklyRaceManager:getSurpassGoldReward()
	local surpass = self.rankData:getSurpassCount()
	local goldReward = 0
	local surpassLimit = SeasonWeeklyRaceConfig:getInstance():getSurpassLimit()
	local surpassRewards = SeasonWeeklyRaceConfig:getInstance():getSurpassRewards()

	if surpass > surpassLimit then surpass = surpassLimit end
	if surpassRewards then
		for _, v in pairs(surpassRewards) do
			if v.itemId == 2 then
				goldReward = goldReward + v.num * surpass
			end
		end
	end
	return goldReward, surpass
end

function SeasonWeeklyRaceManager:getLeftBuyCount()
	local goodId = self:getBuyGoodId()
	local num = UserManager:getInstance():getDailyBoughtGoodsNumById(goodId)
	local meta = MetaManager:getInstance():getGoodMeta(goodId)
	return meta.limit - num
end

function SeasonWeeklyRaceManager:getMaxBuyCount()
	local goodId = self:getBuyGoodId()
	return MetaManager:getInstance():getGoodMeta(goodId).limit
end

function SeasonWeeklyRaceManager:getBuyRmb( ... )
	local goodId = self:getBuyGoodId()
	local meta = MetaManager:getInstance():getGoodMeta(goodId)
	return meta.rmb / 100
end

function SeasonWeeklyRaceManager:getBuyQCash( ... )
	local goodId = self:getBuyGoodId()
	local meta = MetaManager:getInstance():getGoodMeta(goodId)
	return meta.qCash
end

function SeasonWeeklyRaceManager:getBuyGoodId( ... )
	return SeasonWeeklyRaceConfig:getInstance().playCardGoodId
end

-- function SeasonWeeklyRaceManager:getBuyMoney( ... )
-- 	local meta = MetaManager:getInstance():getGoodMeta(self:getBuyGoodId())
-- 	return meta.qCash
-- end

function SeasonWeeklyRaceManager:buyPlayCard( onSuccess, onFail, onCancel, onFinish, ignoreSecondConfirm)
    if self:getLeftBuyCount() <= 0 then
        CommonTip:showTip(Localization:getInstance():getText("weekly.race.no.more.play.tip"), "negative")
        return
    end

    local playCardGoodId = self:getBuyGoodId()

    local function onBuyGoldFinish(evt)
        if evt and evt.target then evt.target:rma() end
        if onFinish then onFinish() end
    end

    local function onCreateGoldPanel()
        local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
        if index ~= 0 then
            local panel = createMarketPanel(index)
            panel:popout()
            panel:addEventListener(kPanelEvents.kClose, onBuyGoldFinish)
        end
    end

    local function onBuySuccess()
        print("onBuySuccess")
        self:onPaySuccess()
        if onSuccess then onSuccess() end
    end

    local function onBuyFail(errCode, errMsg)
        if errCode == 730330 then -- not enough gold
            GoldlNotEnoughPanel:create(onCreateGoldPanel, onCancel):popout()
        else
            if __ANDROID then -- ANDROID
	            if errCode == 730241 or errCode == 730247 then
					CommonTip:showTip(errMsg, "negative", onFail)
				else
					CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative", onFail)
				end
            else -- else, onIOS and PC we use gold!
                CommonTip:showTip(Localization:getInstance():getText("error.tip."..errCode), "negative", onFail)
            end
        end
    end

    local function onBuyCancel()
        if onCancel then onCancel() end
    end
    
    if __ANDROID then -- ANDROID
        if PaymentManager.getInstance():checkCanWindMillPay(playCardGoodId) then
            local function successCallback()
                self:onPaySuccess()
                if onSuccess then onSuccess() end
            end
            local function failCallback()
                if onFail then onFail() end
            end
            local function cancelCallback()
                if onCancel then onCancel() end
            end
            local function updateFunc()
                if onFinish then onFinish() end
            end

			self.dcAndroidInfo = DCWindmillObject:create()
            self.dcAndroidInfo:setGoodsId(playCardGoodId)
            PaymentDCUtil.getInstance():sendAndroidWindMillPayStart(self.dcAndroidInfo)

            local logic = WMBBuyItemLogic:create()
            local buyLogic = BuyLogic:create(playCardGoodId, 2)
            buyLogic:getPrice()
            logic:buy(playCardGoodId, 1, self.dcAndroidInfo, buyLogic, successCallback, failCallback, cancelCallback, updateFunc)
        else 
            local logic = IngamePaymentLogic:create(playCardGoodId)
            if ignoreSecondConfirm then
                logic:ignoreSecondConfirm(true)
            end
            logic:buy(onBuySuccess, onBuyFail, onBuyCancel)
        end
    else -- else, on IOS and PC we use gold!
    	local function onUserHasLogin()
    		local logic = BuyLogic:create(playCardGoodId, 2)
            logic:getPrice()
            logic:start(1, onBuySuccess, onBuyFail)
    	end
    	onUserHasLogin()
    	-- RequireNetworkAlert:callFuncWithLogged(onUserHasLogin)
    end
end

function SeasonWeeklyRaceManager:applyForNewShareQrCode(count, ts, weeklyType, successCallback, failCallback, cancelCallback)
	local function onSuccess(evt)
		if type(evt.data.targetCount) == "number" then
			count = evt.data.targetCount
		else
			count = math.ceil(count / 5) * 5
		end
		if successCallback then successCallback(count, evt.data.qrCodeId) end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt) end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end
	local http = SendQrCodeHttp.new(true)
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFail)
	http:addEventListener(Events.kCancel, onCancel)
	http:syncLoad(weeklyType, ts, count)
end

function SeasonWeeklyRaceManager:snsShare(imagePath, title, text, successCallback, failCallback, cancelCallback)
	local shareCallback = {
		onSuccess = function(result)
			if successCallback then successCallback(false) end
		end,
		onError = function(errCode, errMsg)
			if failCallback then failCallback() end
		end,
		onCancel = function()
			if cancelCallback then cancelCallback() end
		end,
	}

	if __WIN32 then
		shareCallback.onSuccess()
		return
	end
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/wechat_icon.png")
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		SnsUtil.sendImageMessage(PlatformShareEnum.kMiTalk, title, text, thumb,
			imagePath, shareCallback)
	else
		SnsUtil.sendImageMessage(PlatformShareEnum.kWechat, title, text, thumb,
			imagePath, shareCallback)
	end
end

--这个是发送点对点分享的
function SeasonWeeklyRaceManager:snsShareForFeed(title, text, linkUrl,thumbAddress,successCallback, failCallback, cancelCallback)
	local shareCallback = {
		onSuccess = function(result)
			if successCallback then successCallback(false) end
		end,
		onError = function(errCode, errMsg)
			if failCallback then failCallback() end
		end,
		onCancel = function()
			if cancelCallback then cancelCallback() end
		end,
	}

	if __WIN32 then
		shareCallback.onSuccess()
		return
	end
	if not thumbAddress then 
		thumbAddress = "materials/wechat_icon.png"
	end
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename(thumbAddress)
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		--imposible
		assert(false, "this is imposible: SeasonWeeklyRaceManager.lua  line 980")
	else
		SnsUtil.sendLinkMessage(PlatformShareEnum.kWechat, title, text, thumb, linkUrl, false, shareCallback)
	end
end

function SeasonWeeklyRaceManager:showWeeklyTimeTutor()
    if self:hasDailyLevelPlayCompleted() then
        return
    end

    -- local userDefault = CCUserDefault:sharedUserDefault()
    -- local curTime = os.time()
    -- local lastTutorTime = userDefault:getStringForKey("summer.mainlevel.tutor.time")
    -- if lastTutorTime then 
    --     local oneDaySec = 24 * 3600
    --     lastTutorTime = tonumber(lastTutorTime)
    --     if type(lastTutorTime) == "number" then 
    --         if curTime - lastTutorTime < oneDaySec then 
    --             return 
    --         end
    --     end
    -- end
    -- userDefault:setStringForKey("summer.mainlevel.tutor.time", tostring(curTime))
    -- userDefault:flush()

    local scene = HomeScene:sharedInstance()
    local layer = scene.guideLayer
    local levelId = UserManager:getInstance().user:getTopLevelId()
    
    local topLevelNode = scene.worldScene.levelToNode[levelId]
    if topLevelNode then 
        local pos = topLevelNode:getPosition()
        local worldPos = topLevelNode:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
        local trueMask = GameGuideUI:mask(180, 1, ccp(worldPos.x, worldPos.y-70), 1.2, false, false, false, false, true)
        trueMask.setFadeIn(0.3, 0.3)

        --关卡花代理
        local touchLayer = LayerColor:create()
        touchLayer:setColor(ccc3(255,0,0))
        touchLayer:setOpacity(0)
        touchLayer:setAnchorPoint(ccp(0.5, 0.5))
        touchLayer:ignoreAnchorPointForPosition(false)
        touchLayer:setPosition(ccp(worldPos.x, worldPos.y-70))
        touchLayer:changeWidthAndHeight(100, 100)
        touchLayer:setTouchEnabled(true, 0, true)

        local function onTrueMaskTap()
            --点击关闭引导
            if layer:contains(trueMask) then 
                layer:removeChild(trueMask)
            end
        end

        local function onTouchLayerTap()
            --关了自己
            onTrueMaskTap()
            --打最高关卡
            if not PopoutManager:sharedInstance():haveWindowOnScreen()
                    and not HomeScene:sharedInstance().ladyBugOnScreen then
                local levelType = LevelType:getLevelTypeByLevelId(levelId)
                local startGamePanel = StartGamePanel:create(levelId, levelType)
                startGamePanel:popout(false)
            end
        end
        touchLayer:addEventListener(DisplayEvents.kTouchTap, onTouchLayerTap)
        trueMask:addChild(touchLayer)

        trueMask:addEventListener(DisplayEvents.kTouchTap, onTrueMaskTap)

        local panel = nil
        -- if worldPos.x > 360 then 
        --     panel = GameGuideUI:panelSDR(Localization:getInstance():getText("weekly.race.panel.rabbit.tutorial", {num = leftPlayTime, n = '\n'}), false, 0)
        -- else
            panel = GameGuideUI:panelSD(Localization:getInstance():getText("weekly.race.panel.rabbit.tutorial",
            	{num = SeasonWeeklyRaceConfig:getInstance().dailyMainLevelPlay - self.matchData.dailyLevelPlay, n = '\n'}), false, 0)
        -- end
        panel:setScale(0.8)
        local panelPos = panel:getPosition()
        panel:setPosition(ccp(panelPos.x + 120, worldPos.y+250))
        local function addTipPanel()
            trueMask:addChild(panel)
        end
        trueMask:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(addTipPanel)))

        local hand = GameGuideAnims:handclickAnim(0.5, 0.3)
        hand:setAnchorPoint(ccp(0, 1))
        hand:setPosition(ccp(worldPos.x , worldPos.y - 70))
        trueMask:addChild(hand)

        if layer then
            layer:addChild(trueMask)
        end
    end
end

function SeasonWeeklyRaceManager:isNeedShowTimeWarnPanel()
    return not self:isTimeWarningDisabled() and self:isTimeNotEnough()
end

-- 时间晚于当日23:30时，首先弹出提示面板
function SeasonWeeklyRaceManager:isTimeNotEnough()
    local currentTime = math.ceil(Localhost:time()/1000)
    local currentDate = os.date("*t", currentTime)
    if currentDate.hour >= 23 and currentDate.min >= 30 then
        return true
    end
    return false
end

function SeasonWeeklyRaceManager:isTimeWarningDisabled()
    return CCUserDefault:sharedUserDefault():getBoolForKey("game.weekly.summer.timewarning")
end

function SeasonWeeklyRaceManager:setTimeWarningDisabled(isEnable)
    if isEnable ~= true then isEnable = false end
    CCUserDefault:sharedUserDefault():setBoolForKey("game.weekly.summer.timewarning", isEnable)
    CCUserDefault:sharedUserDefault():flush()
end

function SeasonWeeklyRaceManager:sendPassNotify(friendIds, successCallback, failCallback, cancelCallback)
	local function onSuccess()
		if successCallback then successCallback(false) end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt) end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end

	local http = SeasonWeeklyRaceHttpUtil.newPushNotifyHttp(onSuccess, onFail, onCancel)
	local profileName = HeDisplayUtil:urlDecode(UserManager.getInstance().profile.name or "")
	http:load(friendIds, Localization:getInstance():getText("weekly.race.summer.rank.share", {name = profileName}),
		LocalNotificationType.kSpringShowOffPassFriend, Localhost:time())
end

function SeasonWeeklyRaceManager:getSpecialPercent()
	local specialPercent = nil
	if self.matchData.dropPropCount >= SeasonWeeklyRaceConfig:getInstance().weeklyDropProp or
	   self.matchData.dailyDropPropCount>= SeasonWeeklyRaceConfig:getInstance().maxDailyDropPropsCount then
		specialPercent = 0
	else
		specialPercent = SeasonWeeklyRaceConfig:getInstance():getSpecialPercent(self.matchData.totalPlayed)
	end
	-- print("~~~~~~~~~~~~~~getSpecialPercent:", self.matchData.dropPropCount, self.matchData.totalPlayed, specialPercent)
	return specialPercent
end

function SeasonWeeklyRaceManager:onDropPropInGame()
	if self.matchData then
		self.matchData.dropPropCount = self.matchData.dropPropCount + 1
		self:flushToStorage()
	end
end

function SeasonWeeklyRaceManager:getUpdateTime()
	return (self.matchData or {}).lastPlayedTime
end

function SeasonWeeklyRaceManager:getIsShowHelpRecord()
	return self.matchData:getIsShowHelpTip()
end

function SeasonWeeklyRaceManager:ShowedHelpTip()
	self.matchData:ShowedHelpTip()
end

function SeasonWeeklyRaceManager:getHelpNum()
	return self.matchData:getHelpNum()
end

SeasonWeeklyDecisionType = table.const{
	kCanPlay = "can_play",
	kMainLevelTutorOut = "main_level_tutor_out",
	kMainLevelTutorIn = "main_level_tutor_in",
	kShareTutor = "share_tutor",
	kCanBuy = "can_buy",
	kCanNotPlay = "can_not_play",

	kShowWithFreePanel = "show_with_free_panel",
}

SeasonWeeklyLocalKey = table.const{
	kTodayFirstClick = "today_first_click",
	kTodayFirstLevel = "today_first_level_weekly",
	kTodayFirstShare = "today_first_share_weekly",
}

function SeasonWeeklyRaceManager:pocessSeasonWeeklyDecision(fromMessageCenter)
	local function handleDecisionFunc(seasonWeeklyDecisionType)
		print("======================================>>>>", seasonWeeklyDecisionType)
		if seasonWeeklyDecisionType == SeasonWeeklyDecisionType.kMainLevelTutorOut then 
			HomeScene:sharedInstance().worldScene:moveTopLevelNodeToCenter(function ()
				SeasonWeeklyRaceManager:getInstance():showWeeklyTimeTutor()
			end)
		else
			if fromMessageCenter and seasonWeeklyDecisionType == SeasonWeeklyDecisionType.kCanNotPlay then 
				--弹消息中心的tip 今日次数已用完 请明天再来挑战吧
				CommonTip:showTip(Localization:getInstance():getText("今日次数已用完，明日再来挑战吧~"), "positive")
				return
			end

			local homeScene = HomeScene:sharedInstance()
			if homeScene.summerWeeklyButton and not homeScene.summerWeeklyButton.isDisposed then
				homeScene.summerWeeklyButton:update()
			end
			if not PopoutManager:sharedInstance():haveWindowOnScreen() and not homeScene.ladyBugOnScreen then
				WinterWeeklyPanel:create(seasonWeeklyDecisionType):popout()
			end
		end
	end

	local function onMatchDataLoaded()
		if SeasonWeeklyRaceManager:getInstance():getLeftPlay() > 0 then 
			--有次数剩余
			handleDecisionFunc(SeasonWeeklyDecisionType.kCanPlay)
		else
			local isTodayFirstClick = self:checkKeyDailyRefresh(SeasonWeeklyLocalKey.kTodayFirstClick, self:hasReward())
			if isTodayFirstClick and not self:hasReward() then 
				--当天首次点击
				handleDecisionFunc(SeasonWeeklyDecisionType.kMainLevelTutorOut)
			else
				local currentMainLevelCount = self:getDailyLevelPlayCount()
    			local mainLevelCountLimit = SeasonWeeklyRaceConfig:getInstance().dailyMainLevelPlay

				if currentMainLevelCount < mainLevelCountLimit then
					--没获得过主线次数
					local isFirstFreeLevelTutor = self:checkKeyDailyRefresh(SeasonWeeklyLocalKey.kTodayFirstLevel)
					if isFirstFreeLevelTutor then 
						--有引导
						handleDecisionFunc(SeasonWeeklyDecisionType.kMainLevelTutorIn)
					else
						handleDecisionFunc(SeasonWeeklyDecisionType.kShowWithFreePanel)
					end
				else
				    local currentShareCount = self:getShareCount()
				    local shareCountLimit = SeasonWeeklyRaceConfig:getInstance().dailyShare

					if currentShareCount < shareCountLimit then 
						--没分享过
						local isFirstFreeShareTutor = self:checkKeyDailyRefresh(SeasonWeeklyLocalKey.kTodayFirstShare)
						if isFirstFreeShareTutor then 
							--有引导
							handleDecisionFunc(SeasonWeeklyDecisionType.kShareTutor)
						else
							handleDecisionFunc(SeasonWeeklyDecisionType.kShowWithFreePanel)
						end
					else
						if SeasonWeeklyRaceManager:getInstance():getLeftBuyCount() > 0 then
							handleDecisionFunc(SeasonWeeklyDecisionType.kCanBuy)
						else
							handleDecisionFunc(SeasonWeeklyDecisionType.kCanNotPlay)
						end
					end
				end
			end
		end
	end

	self:loadData(onMatchDataLoaded, true)
end

local function now()
	return os.time() + (__g_utcDiffSeconds or 0)
end

local function getDayStartTimeByTS(ts)
	local utc8TimeOffset = 57600 -- (24 - 8) * 3600
	local oneDaySeconds = 86400 -- 24 * 3600
	return ts - ((ts - utc8TimeOffset) % oneDaySeconds)
end

function SeasonWeeklyRaceManager:checkKeyDailyRefresh(localKey, skipWriteKey)
	local userDefault = CCUserDefault:sharedUserDefault()
    local lastDayStartTime = userDefault:getStringForKey(localKey)
	local todayStartTime = getDayStartTimeByTS(now())

	local function writeTodayStartTime()
		if not skipWriteKey then
			userDefault:setStringForKey(localKey, tostring(todayStartTime))
	    	userDefault:flush()
	    end
	end

    if lastDayStartTime then 
        lastDayStartTime = tonumber(lastDayStartTime)
        if type(lastDayStartTime) == "number" then 
        	if todayStartTime > lastDayStartTime then 
        		writeTodayStartTime()
        		return true
        	else
        		return false
        	end
        else
        	writeTodayStartTime()
        	return true
        end
    else
    	writeTodayStartTime()
    	return true
    end
end