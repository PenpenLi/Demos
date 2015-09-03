require "zoo.panel.summerWeekly.model.SummerWeeklyMatchData"
require "zoo.panel.summerWeekly.model.SummerWeeklyMatchRankData"
require "zoo.panel.summerWeekly.model.SummerWeeklyShowOffData"
require "zoo.panel.summerWeekly.SummerWeeklyMatchConfig"

SummerWeeklyMatchEvents = {
	kDataChangeEvent = "weekly.summer.dataChange",
}

SummerWeeklyMatchManager = class()

local startDate = {year = 2015, month=6, day=2, hour=0, min=0, sec=0}
local DAY_SEC	= 3600 * 24
local WEEK_SEC 	= DAY_SEC * 7

local _instance = nil

function SummerWeeklyMatchManager:ctor()
	self.matchData = nil
	self.rankData = nil
	self.uid = nil
	self.levelId = nil
	self.week = nil
	self.wday = nil
	self.firstMondayTime = SummerWeeklyMatchManager:getMondayTime(os.time(startDate))
end

function SummerWeeklyMatchManager:getInstance()
	if not _instance then
		_instance = SummerWeeklyMatchManager.new()
		_instance:init()
	end
	return _instance
end

function SummerWeeklyMatchManager:init()
	self.uid = UserManager.getInstance().uid

	local time = Localhost:timeInSec()
    self.week = self:getWeek(time)
	self.wday = self:getWDay(time)
	self.levelId = self:calcLevelId(self.week)
	-- print(table.tostring(self:getRewardsConfig()))
end

function SummerWeeklyMatchManager:getRewardsConfig()
	return SummerWeeklyMatchConfig:getInstance():getRewardsConfigByLevelId(self.levelId)
end

function SummerWeeklyMatchManager:getWeek(time)
	time = time or Localhost:timeInSec()
	local diffTime = math.abs(time - self.firstMondayTime)
	local week = math.ceil((diffTime + 1) / WEEK_SEC)
	-- if week == 0 then week = 1 end
	return week
end

function SummerWeeklyMatchManager:getWDay(time)
	time = time or Localhost:timeInSec()
	local wday = tonumber(os.date('%w', time))
	if wday == 0 then wday = 7 end
	return wday
end

function SummerWeeklyMatchManager:onDataChanged(refreshRankList)
	GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(SummerWeeklyMatchEvents.kDataChangeEvent, {refreshRankList = refreshRankList}))
end

function SummerWeeklyMatchManager:getAndUpdateMatchData()
	if not self.matchData then
		self.matchData = self:getMatchDataFromLocal()
	end
	if self:hasWeekChanged(self.matchData) then
		local time = Localhost:timeInSec()
	    self.week = self:getWeek(time)
		self.wday = self:getWDay(time)
		self.levelId = self:calcLevelId(self.week)

		self.matchData:resetWeeklyData()
		self.matchData.updateTime = time
		self:flushToStorage()
	else
		if self:hasDayChanged(self.matchData) then
			local time = Localhost:timeInSec()
			self.wday = self:getWDay(time)

			self.matchData:resetDailyData()
			self.matchData.updateTime = time
			self:flushToStorage()
		end
	end
	-- print("getAndUpdateMatchData:", table.tostring(self.matchData))
	return self.matchData
end

function SummerWeeklyMatchManager:getMondayTime(time)
	time = time or Localhost:timeInSec()
	local dateT = os.date("*t", time)
	dateT.hour = 0
	dateT.min = 0
	dateT.sec = 0
	local wday = dateT.wday - 1 -- 周日wday=1
	if wday == 0 then wday = 7 end -- 周日
	local firstMondayTime = os.time(dateT) - (wday - 1) * DAY_SEC
	return firstMondayTime
end

function SummerWeeklyMatchManager:getLeftTime( ... )
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

function SummerWeeklyMatchManager:calcLevelId(diffWeek)
    local config = SummerWeeklyMatchConfig:getInstance().levelIds
    if not config or #config < 1 then
    	return nil
    end
    local levelId = nil
    if diffWeek > 0 then
    	local size = #config
    	local index = diffWeek % size
    	if index == 0 then index = size end
	    levelId = config[index]
	end
    return levelId
end

function SummerWeeklyMatchManager:getLevelId()
	return self.levelId
end

function SummerWeeklyMatchManager:isLevelReached(topLevelId)
	topLevelId = topLevelId or UserManager:getInstance().user:getTopLevelId()
	local minLevel = SummerWeeklyMatchConfig:getInstance().minLevel or 31
	return topLevelId >= minLevel
end

function SummerWeeklyMatchManager:loadData(onFinish, withAnim)
	local function onSuccess()
		if onFinish then onFinish() end
	end

	local function onFail( ... )
		self:getAndUpdateMatchData()
		if onFinish then onFinish() end
	end
	self:getMatchDataFromServer(onSuccess, onFail, not withAnim)
end

function SummerWeeklyMatchManager:getMatchDataFromServer( onSuccess, onFail, inBackground )
	local loadAnimation = nil

	local function onRequestSuccess(evt)
		if loadAnimation then loadAnimation:removeFromParentAndCleanup(true) end
		self.matchData = SummerWeeklyMatchData:fromRespData(evt.data)
		self:flushToStorage()
		-- print("self.matchData", table.tostring(self.matchData))

		local time = Localhost:timeInSec()
	    self.week = self:getWeek(time)
		self.wday = self:getWDay(time)
		self.levelId = self:calcLevelId(self.week)

		if onSuccess then onSuccess(evt) end
	end

	local function onRequestFail(evt)
		if loadAnimation then 
			loadAnimation:removeFromParentAndCleanup(true) 
		end
		if onFail then onFail(evt) end
	end
	local http = GetSummerWeekMatchInfoHttp.new()
    http:ad(Events.kComplete, onRequestSuccess)
    http:ad(Events.kError, onRequestFail)

    if not inBackground then
	    local function onCloseButtonTap()
	        if http then http:removeAllEventListeners() end
	        loadAnimation:removeFromParentAndCleanup(true)
			if onFail then onFail() end
	    end
	    local scene = Director:sharedDirector():getRunningScene()
    	loadAnimation = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap)
    end

    http:syncLoad(self.levelId)
end

function SummerWeeklyMatchManager:hasReward()
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

function SummerWeeklyMatchManager:hasWeeklyRewards()
	local weeklyRewards = self:getNextWeeklyReward()
	for _, v in pairs(weeklyRewards) do
		if v.needMore == 0 and not v.hasReceived then return true end
	end
	return false
end

function SummerWeeklyMatchManager:getMatchDataFromLocal()
	local matchData = self:readFromStorage()
	if not matchData then
		matchData = SummerWeeklyMatchData.new()
	end
	return matchData
end

function SummerWeeklyMatchManager:hasWeekChanged(oldData)
	return self:getWeek() ~= self:getWeek(oldData.updateTime)
end

function SummerWeeklyMatchManager:hasDayChanged(oldData)
	local diffDay = compareDate(os.date("*t", Localhost:timeInSec()), os.date("*t", oldData.updateTime))
	return diffDay ~= 0
end

function SummerWeeklyMatchManager:receiveDailyReward( rewardId, onSuccess, onFail )
	local function onReceiveSuccess(evt)
		if evt and evt.data then
			UserManager:getInstance():addRewards(evt.data.rewards)
			UserService:getInstance():addRewards(evt.data.rewards)
		end
		table.insert(self.matchData.receivedDailyRewards, rewardId)
		self:flushToStorage()
		DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_get_dailyreward', reward_id=rewardId, day=self.wday})
		if onSuccess then onSuccess(evt) end
	end

	local function onReceiveFail(event)
        if event and event.data then
            CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative", onFail)
        end
		if onFail then onFail(event) end
	end

	local function onRequestCancel( event )
		if onFail then onFail() end
	end
	self:receiveReward(self.levelId, GetSummerWeekMatchRewardType.kDailyReward, rewardId, onReceiveSuccess, onReceiveFail, onRequestCancel)
end

function SummerWeeklyMatchManager:receiveWeeklyReward( rewardId, onSuccess, onFail )
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
		DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_get_weeklyreward', reward_id=rewardId})
		if onSuccess then onSuccess(evt) end
	end

	local function onReceiveFail(event)
        if event and event.data then
            CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative", onFail)
        end
		if onFail then onFail(event) end
	end

	local function onRequestCancel( event )
		if onFail then onFail() end
	end
	self:receiveReward(self.levelId, GetSummerWeekMatchRewardType.kWeeklyReward, rewardId, onReceiveSuccess, onReceiveFail, onRequestCancel)
end

function SummerWeeklyMatchManager:receiveLastWeekRewards(levelId, onSuccess, onFail )
	local function onReceiveSuccess(evt)
		for _, rewardId in pairs(self.matchData.lastWeekRewards) do
			DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_get_last_weeklyreward', reward_id=rewardId})
		end
		if evt and evt.data then
			UserManager:getInstance():addRewards(evt.data.rewards)
			UserService:getInstance():addRewards(evt.data.rewards)
		end
		self.matchData.lastWeekRewards = {}
		if onSuccess then onSuccess(evt) end
	end

	local function onReceiveFail(event)
		self.matchData.lastWeekRewards = {}
        if event and event.data then
            CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative", onFail)
        end
		if onFail then onFail(event) end
	end
	local function onRequestCancel( event )
		self.matchData.lastWeekRewards = {}
		if onFail then onFail() end
	end
	self:receiveReward(levelId, GetSummerWeekMatchRewardType.kLastWeekRewards, 0, onReceiveSuccess, onReceiveFail, onRequestCancel)
end

function SummerWeeklyMatchManager:receiveLastWeekRankRewards(levelId, onSuccess, onFail )
	local function onReceiveSuccess(evt)
		local hasExtRewards = false
		if evt and evt.data and evt.data.rewards then
			if #evt.data.rewards > 1 then
				hasExtRewards = true
			end
			UserManager:getInstance():addRewards(evt.data.rewards)
			UserService:getInstance():addRewards(evt.data.rewards)
		end

		local rewardId = 0
		if hasExtRewards and self.matchData then
			rewardId = self.matchData.lastWeekRank or 0
		end
		DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_get_rankreward', reward_id=rewardId})

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
		if onFail then onFail() end
	end
	self:receiveReward(levelId, GetSummerWeekMatchRewardType.kLastWeekRankRewards, 0, onReceiveSuccess, onReceiveFail, onRequestCancel)
end

function SummerWeeklyMatchManager:getLastWeekRewards()
	local rewards = {}
	local levelId = self:getLevelId(self.week - 1)
	if self.matchData and self.matchData.lastWeekRewards and #self.matchData.lastWeekRewards > 0 then
		local config = SummerWeeklyMatchConfig:getInstance():getRewardsConfigByLevelId(levelId)
		if config and config.weeklyRewards and #config.weeklyRewards > 0 then
			for _, v in pairs(config.weeklyRewards) do
				if table.exist(self.matchData.lastWeekRewards, v.id) then
					table.insert(rewards, v)
				end
			end
		end
	end
	return rewards, levelId
end

function SummerWeeklyMatchManager:getLastWeekRankRewards()
	local levelId = self:getLevelId(self.week - 1)
	if self.matchData and self.matchData.lastWeekRankRewards and #self.matchData.lastWeekRankRewards > 0 then
		return self.matchData.lastWeekRankRewards, levelId, self.matchData.lastWeekRank, self.matchData.lastWeekSurpass
	end
	return {}, levelId, 0, 0
end

function SummerWeeklyMatchManager:receiveReward(levelId, rewardType, rewardId, onSuccess, onFail, onCancel)
	assert(levelId, "levelId can not be nil")

	local loadAnimation = nil
	local timeoutId = nil

	local function onRequestSuccess(evt)
		if timeoutId then cancelTimeOut(timeoutId) end
		if loadAnimation then loadAnimation:removeFromParentAndCleanup(true) end
		if onSuccess then onSuccess(evt) end
	end
	local function onRequestFail(evt)
		if timeoutId then cancelTimeOut(timeoutId) end
		if loadAnimation then loadAnimation:removeFromParentAndCleanup(true) end
		if onFail then onFail(evt) end
	end

	local http = GetSummerWeekMatchRewardHttp.new()
    http:ad(Events.kComplete, onRequestSuccess)
    http:ad(Events.kError, onRequestFail)

    local function addAnimation()
		timeoutId = nil
	    local function onCloseButtonTap()
	        if http then http:removeAllEventListeners() end
	        loadAnimation:removeFromParentAndCleanup(true)
			if onCancel then onCancel() end
	    end
	    local scene = Director:sharedDirector():getRunningScene()
		loadAnimation = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap)
	end
	timeoutId = setTimeOut(addAnimation, 1)

	http:syncLoad(levelId, rewardType, rewardId, self.wday)
end

function SummerWeeklyMatchManager:onPlayMainLevel()
	self:getAndUpdateMatchData():addDailyLevelPlayCount(1)
	if self.matchData.dailyLevelPlay == SummerWeeklyMatchConfig:getInstance().dailyMainLevelPlay then
		self.matchData:incrLeftPlay(SummerWeeklyMatchConfig:getInstance().freePlayByMainLevel)
	end
	self:flushToStorage()
	self:onDataChanged()
end

function SummerWeeklyMatchManager:getShareCount()
	return self.matchData.dailyShare
end

function SummerWeeklyMatchManager:getDailyMaxScore()
	return self.matchData.dailyMaxScore
end

function SummerWeeklyMatchManager:getWeeklyScore()
	return self.matchData.weeklyScore
end

function SummerWeeklyMatchManager:onShareSuccess( onSuccess, onFail )
	local function onNotifySuccess( evt )
		self:getAndUpdateMatchData():addShareCount(1)
		local isAddCount = false
		if self.matchData.dailyShare == SummerWeeklyMatchConfig:getInstance().dailyShare then
			self.matchData:incrLeftPlay(SummerWeeklyMatchConfig:getInstance().freePlayByShare)
			isAddCount = true
		end
		self:flushToStorage()
		self:onDataChanged()
		if onSuccess then onSuccess(isAddCount) end
	end

	local function onNotifyFail(evt)
		if onFail then onFail(evt) end
	end

	local http = OpNotifyHttp.new()
    http:ad(Events.kComplete, onNotifySuccess)
    http:ad(Events.kError, onNotifyFail)
	http:load(OpNotifyType.kWeeklyMatchShare, {})
end

function SummerWeeklyMatchManager:isDailyFirstShare()
	return self.matchData.dailyShare < SummerWeeklyMatchConfig:getInstance().dailyShare
end

function SummerWeeklyMatchManager:onPaySuccess()
	self.matchData:incrLeftPlay(1)
	self:flushToStorage()
	self:onDataChanged()
end

-- TODO Localhost:timeInSec()与打开面板的时间差
function SummerWeeklyMatchManager:getNextDayDailyRewards()
	local nextDayTime = Localhost:timeInSec() + DAY_SEC
    local nextWeek = self:getWeek(nextDayTime)
    local nextWday = self:getWDay(nextDayTime)
    return self:getDailyRewards(nextWeek, nextWday)
end

function SummerWeeklyMatchManager:getDailyRewards(week, wday)
	assert(week)
	assert(wday)
	local levelId = self:calcLevelId(week)
	local rewardsConfig = SummerWeeklyMatchConfig:getInstance():getRewardsConfigByLevelId(levelId)
	if rewardsConfig and rewardsConfig.dailyRewards and #rewardsConfig.dailyRewards > 0 then
		local index = wday % #rewardsConfig.dailyRewards
		if index == 0 then index = #rewardsConfig.dailyRewards end
		return rewardsConfig.dailyRewards[index]
	end
	return nil
end

function SummerWeeklyMatchManager:getNextDailyReward()
	local ret = nil

	local reward = nil
	local isAllReceived = false
	local todayRewards = self:getDailyRewards(self.week, self.wday)
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

function SummerWeeklyMatchManager:getNextWeeklyReward()
	local ret = {}

	local config = self:getRewardsConfig()
	if config and config.weeklyRewards and #config.weeklyRewards > 0 then
		for i, reward in ipairs(config.weeklyRewards) do
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

function SummerWeeklyMatchManager:getLeftPlay()
	return self.matchData.leftPlay
end

function SummerWeeklyMatchManager:canGetFreePlay()
	return not self:hasDailyShareCompleted() or not self:hasDailyLevelPlayCompleted()
end

function SummerWeeklyMatchManager:hasDailyShareCompleted()
	return self.matchData.dailyShare >= SummerWeeklyMatchConfig:getInstance().dailyShare
end

function SummerWeeklyMatchManager:hasDailyLevelPlayCompleted()
	return self.matchData.dailyLevelPlay >= SummerWeeklyMatchConfig:getInstance().dailyMainLevelPlay
end

function SummerWeeklyMatchManager:getDailyLevelPlayCount()
	return self.matchData.dailyLevelPlay
end

function SummerWeeklyMatchManager:getRankMinScore()
	local rankMinNum = 0
	local config = self:getRewardsConfig()
	if config then rankMinNum = config.rankMinNum end
	return rankMinNum
end

function SummerWeeklyMatchManager:canShareChamp()
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

function SummerWeeklyMatchManager:canShareSurpass()
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

function SummerWeeklyMatchManager:getSurpassFriends()
	if not self.rankData then return {} end
	return self.rankData:getSurpassFriends()
end

function SummerWeeklyMatchManager:getShowOffData()
	if not self.showOffData then
		local extraData = Localhost:getInstance():readLocalExtraData()
		if extraData and extraData.summerWeeklyShowOff then 
			self.showOffData = SummerWeeklyShowOffData:fromLua(extraData.summerWeeklyShowOff)
		end
	end
	if not self.showOffData or self.showOffData:hasExpired() then
		self.showOffData = SummerWeeklyShowOffData:create()
	end
	return self.showOffData
end

function SummerWeeklyMatchManager:onShareChampSuccess()
	local data = self:getShowOffData()
	data:incrChampShared()
	local extraData = Localhost:getInstance():readLocalExtraData() or {}
	extraData.summerWeeklyShowOff = data
	Localhost:getInstance():flushLocalExtraData(extraData)
end

function SummerWeeklyMatchManager:onShareSurpassSuccess()
	local data = self:getShowOffData()
	data:incrSurpassShared()
	local extraData = Localhost:getInstance():readLocalExtraData() or {}
	extraData.summerWeeklyShowOff = data
	Localhost:getInstance():flushLocalExtraData(extraData)
end

function SummerWeeklyMatchManager:isShowDailyFirstTip()
	local data = self:getShowOffData()
	return data.showPlayTip
end

function SummerWeeklyMatchManager:onShowDailyFirstTip()
	local data = self:getShowOffData()
	data.showPlayTip = false
	local extraData = Localhost:getInstance():readLocalExtraData() or {}
	extraData.summerWeeklyShowOff = data
	Localhost:getInstance():flushLocalExtraData(extraData)
end

function SummerWeeklyMatchManager:getRankData( onSuccess, onFail )
	local http = GetCommonRankListHttp.new()
	local levelId = self.levelId
	local function onRequestSuccess( evt )
		local rankList = evt.data.rankList
		local rankMinNum = nil
		local config = self:getRewardsConfig()
		if config then rankMinNum = config.rankMinNum end
		self.rankData = SummerWeeklyMatchRankData.new(config.levelId, rankMinNum)
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
    http:addEventListener(Events.kComplete, onRequestSuccess)
    http:addEventListener(Events.kError, onRequestFail)
	http:load(CommonRankType.kSummerWeeklyMatch, 1, levelId)
end

function SummerWeeklyMatchManager:flushToStorage()
	if self.matchData then
		Localhost.getInstance():writeWeeklyMatchData(self.matchData)
	end
end

function SummerWeeklyMatchManager:readFromStorage()
	local data = Localhost.getInstance():readWeeklyMatchData()
	if data then
		return SummerWeeklyMatchData:fromLua(data)
	end
	return nil
end

function SummerWeeklyMatchManager:onStartLevel()
	self.matchData:decrLeftPlay()
	self.matchData.totalPlayed = self.matchData.totalPlayed + 1
	self:flushToStorage()
end

function SummerWeeklyMatchManager:onPassLevel(levelId, targetCount)
	DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_watermelon_num', level_id=levelId, num=targetCount})
	if self.rankData then
		self.oldRank = self.rankData:getMyRank()
	end
	if type(targetCount) == "number" and targetCount > 0 then
		self.matchData:addScore(targetCount)
		self:getAndUpdateMatchData()
		self:flushToStorage()
		-- self:onDataChanged(true)

		if self:hasWeeklyRewards() then
			LocalNotificationManager.getInstance():setWeeklyRaceRewardNotification()
		end
	end
end

function SummerWeeklyMatchManager:getSurpassGoldReward()
	local surpass = self.rankData:getSurpassCount()
	local goldReward = 0
	local config = self:getRewardsConfig()
	if config then
		if surpass > config.surpassLimit then surpass = config.surpassLimit end
		if config.surpassRewards then
			for _, v in pairs(config.surpassRewards) do
				if v.itemId == 2 then
					goldReward = goldReward + v.num * surpass
				end
			end
		end
	end
	return goldReward, surpass
end

function SummerWeeklyMatchManager:getLeftBuyCount()
	local goodId = self:getBuyGoodId()
	local num = UserManager:getInstance():getDailyBoughtGoodsNumById(goodId)
	local meta = MetaManager:getInstance():getGoodMeta(goodId)
	return meta.limit - num
end

function SummerWeeklyMatchManager:getMaxBuyCount()
	local goodId = self:getBuyGoodId()
	return MetaManager:getInstance():getGoodMeta(goodId).limit
end

function SummerWeeklyMatchManager:getBuyRmb( ... )
	local goodId = self:getBuyGoodId()
	local meta = MetaManager:getInstance():getGoodMeta(goodId)
	return meta.rmb / 100
end

function SummerWeeklyMatchManager:getBuyQCash( ... )
	local goodId = self:getBuyGoodId()
	local meta = MetaManager:getInstance():getGoodMeta(goodId)
	return meta.qCash
end

function SummerWeeklyMatchManager:getBuyGoodId( ... )
	return SummerWeeklyMatchConfig:getInstance().playCardGoodId
end

-- function SummerWeeklyMatchManager:getBuyMoney( ... )
-- 	local meta = MetaManager:getInstance():getGoodMeta(self:getBuyGoodId())
-- 	return meta.qCash
-- end

function SummerWeeklyMatchManager:buyPlayCard( onSuccess, onFail, onCancel, onFinish, ignoreSecondConfirm)
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

    local function onBuyFail( evt )
        if type(evt) == "table" and evt.data == 730330 then -- not enough gold
            -- local text = {
            --     tip = Localization:getInstance():getText("buy.prop.panel.tips.no.enough.cash"),
            --     yes = Localization:getInstance():getText("buy.prop.panel.yes.buy.btn"),
            --     no = Localization:getInstance():getText("buy.prop.panel.not.buy.btn"),
            -- }
            -- CommonTipWithBtn:showTip(text, "negative", onCreateGoldPanel, onCancel)
            GoldlNotEnoughPanel:create(onCreateGoldPanel, onCancel, nil):popout()
        else
            if __ANDROID then -- ANDROID
                CommonTip:showTip(Localization:getInstance():getText("add.step.panel.buy.fail.android"), "negative", onFail)
            else -- else, onIOS and PC we use gold!
                CommonTip:showTip(Localization:getInstance():getText("error.tip."..evt.data), "negative", onFail)
            end
        end
    end

    local function onBuyCancel()
        -- print("onBuyCancel")
        if onCancel then onCancel() end
    end
    if __ANDROID then -- ANDROID
        if PaymentManager.getInstance():checkCanWindMillPay(playCardGoodId) then
            local uniquePayId = PaymentDCUtil.getInstance():getNewPayID() 
            PaymentDCUtil.getInstance():sendPayStart(Payments.WIND_MILL, 0, uniquePayId, playCardGoodId, 1, 1, 0, 1)
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

            local logic = WMBBuyItemLogic:create()
            local buyLogic = BuyLogic:create(playCardGoodId, 2)
            buyLogic:getPrice()
            logic:buy(playCardGoodId, 1, uniquePayId, buyLogic, successCallback, failCallback, cancelCallback, updateFunc)
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

function SummerWeeklyMatchManager:snsShare(imagePath, title, text, successCallback, failCallback, cancelCallback)
	local shareCallback = {
		onSuccess = function(result)
			self:onShareSuccess(successCallback, failCallback)
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

function SummerWeeklyMatchManager:showWeeklyTimeTutor()
    if self:hasDailyLevelPlayCompleted() then
        return
    end

    local userDefault = CCUserDefault:sharedUserDefault()
    local curTime = os.time()
    local lastTutorTime = userDefault:getStringForKey("summer.mainlevel.tutor.time")
    if lastTutorTime then 
        local oneDaySec = 24 * 3600
        lastTutorTime = tonumber(lastTutorTime)
        if type(lastTutorTime) == "number" then 
            if curTime - lastTutorTime < oneDaySec then 
                return 
            end
        end
    end
    userDefault:setStringForKey("summer.mainlevel.tutor.time", tostring(curTime))
    userDefault:flush()

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
            	{num = SummerWeeklyMatchConfig:getInstance().dailyMainLevelPlay - self.matchData.dailyLevelPlay, n = '\n'}), false, 0)
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

function SummerWeeklyMatchManager:isNeedShowTimeWarnPanel()
    return not self:isTimeWarningDisabled() and self:isTimeNotEnough()
end

-- 时间晚于当日23:30时，首先弹出提示面板
function SummerWeeklyMatchManager:isTimeNotEnough()
    local currentTime = math.ceil(Localhost:time()/1000)
    local currentDate = os.date("*t", currentTime)
    if currentDate.hour >= 23 and currentDate.min >= 30 then
        return true
    end
    return false
end

function SummerWeeklyMatchManager:isTimeWarningDisabled()
    return CCUserDefault:sharedUserDefault():getBoolForKey("game.weekly.summer.timewarning")
end

function SummerWeeklyMatchManager:setTimeWarningDisabled(isEnable)
    if isEnable ~= true then isEnable = false end
    CCUserDefault:sharedUserDefault():setBoolForKey("game.weekly.summer.timewarning", isEnable)
    CCUserDefault:sharedUserDefault():flush()
end

function SummerWeeklyMatchManager:sendPassNotify(friendIds, successCallback, failCallback, cancelCallback)
	local function onSuccess()
		self:onShareSuccess(successCallback, failCallback)
	end
	local function onFail(evt)
		if failCallback then failCallback(evt) end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end

	local http = PushNotifyHttp.new()
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFail)
	http:addEventListener(Events.kCancel, onCancel)
	local profileName = HeDisplayUtil:urlDecode(UserManager.getInstance().profile.name or "")
	http:load(friendIds, Localization:getInstance():getText("weekly.race.summer.rank.share", {name = profileName}),
		LocalNotificationType.kSummerShowOffPassFriend, Localhost:time())
end

function SummerWeeklyMatchManager:getSpecialPercent()
	local specialPercent = nil
	if self.matchData.dropPropCount >= SummerWeeklyMatchConfig:getInstance().weeklyDropProp or
	   self.matchData.dailyDropPropCount>= SummerWeeklyMatchConfig:getInstance().maxDailyDropPropsCount then
		specialPercent = 0
	else
		specialPercent = SummerWeeklyMatchConfig:getInstance():getSpecialPercent(self.matchData.totalPlayed)
	end
	-- print("~~~~~~~~~~~~~~getSpecialPercent:", self.matchData.dropPropCount, self.matchData.totalPlayed, specialPercent)
	return specialPercent
end

function SummerWeeklyMatchManager:onDropPropInGame()
	if self.matchData then
		self.matchData.dropPropCount = self.matchData.dropPropCount + 1
		self:flushToStorage()
	end
end