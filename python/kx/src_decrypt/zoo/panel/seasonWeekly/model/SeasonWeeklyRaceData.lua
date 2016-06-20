SeasonWeeklyRaceData = class()

local function copyTable(t)
	local ret = {}
	if type(t) == "table" then
		for k, v in pairs(t) do
			ret[k] = v
		end
	end
	return ret
end

function SeasonWeeklyRaceData:ctor()
	self.dailyMaxScore 	= 0
	self.dailyShare 	= 0
	self.dailyLevelPlay = 0
	self.receivedDailyRewards = {}
	self.leftPlay 		= 0
	self.dailyDropPropCount = 0

	self.weeklyScore 	= 0
	self.receivedWeeklyRewards = {}
	self.dropPropCount = 0
	self.totalPlayed = 0
	self.firstGuideRewarded = false

	self.updateTime = Localhost:timeInSec()
	self.lastPlayedTime = Localhost:time() -- 任务系统过滤任务用

	-- 上周奖励相关数据	
	self.lastWeekSurpass = 0
	self.lastWeekRank = 0
	self.lastWeekRewards = {}
	self.lastWeekRankRewards = {}

	-- 关卡ID随机需求
	self.randomedIndices = {}
	self.lastIndexFinished = false
end

function SeasonWeeklyRaceData:decrLeftPlay()
	self.leftPlay = self.leftPlay - 1
end

function SeasonWeeklyRaceData:resetDailyData()
	self.dailyMaxScore 	= 0
	self.dailyLevelPlay = 0
	self.dailyShare 	= 0
	self.leftPlay 		= 0
	self.receivedDailyRewards = {}
	self.dailyDropPropCount = 0
end

function SeasonWeeklyRaceData:resetWeeklyData()
	self:resetDailyData()

	self.weeklyScore 	= 0
	self.receivedWeeklyRewards = {}
	self.dropPropCount = 0
	self.totalPlayed = 0

	self.lastWeekSurpass = 0
	self.lastWeekRank = 0
	self.lastWeekRewards = {}
	self.lastWeekRankRewards = {}
	self.activeFriends = {}
end

function SeasonWeeklyRaceData:incrLeftPlay(incrPlay)
	print('wenkan incrLeftPlay', incrPlay, self.leftPlay)
	incrPlay = incrPlay or 1
	self.leftPlay = self.leftPlay + incrPlay
end

function SeasonWeeklyRaceData:addScore(newScore)
	if newScore > self.dailyMaxScore then
		self.dailyMaxScore = newScore
	end
	self.weeklyScore = self.weeklyScore + newScore
end

function SeasonWeeklyRaceData:addShareCount(addCount)
	addCount = addCount or 1
	self.dailyShare = self.dailyShare + addCount
end

function SeasonWeeklyRaceData:addDailyTimePropCount(addCount)
	addCount = addCount or 1
	self.dailyDropPropCount = self.dailyDropPropCount + addCount
end

function SeasonWeeklyRaceData:addDailyLevelPlayCount( addCount )
	addCount = addCount or 1
	self.dailyLevelPlay = self.dailyLevelPlay + addCount
end

function SeasonWeeklyRaceData:setLastPlayedTime()
	self.lastPlayedTime = Localhost:time()
end

function SeasonWeeklyRaceData:fromLua(src)
	local data = SeasonWeeklyRaceData.new()
	if src then
		data.dailyMaxScore 	= src.dailyMaxScore
		data.weeklyScore 	= src.weeklyScore
		data.leftPlay 		= src.leftPlay
		data.dailyLevelPlay = src.dailyLevelPlay or 0
		data.dailyShare 	= src.dailyShare
		data.receivedDailyRewards = copyTable(src.receivedDailyRewards)
		data.receivedWeeklyRewards = copyTable(src.receivedWeeklyRewards)
		data.updateTime = src.updateTime
		data.lastPlayedTime = src.lastPlayedTime
		data.dropPropCount = src.dropPropCount or 0
		data.totalPlayed = src.totalPlayed or 0
		data.dailyDropPropCount = src.droppedCountDaily or 0
		data.firstGuideRewarded = src.firstGuideRewarded
		data.randomedIndices = src.randomedIndices or {}
		data.lastIndexFinished = src.lastIndexFinished or false
	end
	return data
end

function SeasonWeeklyRaceData:fromRespData(src, localData)
	local data = SeasonWeeklyRaceData.new()
	if src then
		data.dailyMaxScore 	= src.levelMax
		data.weeklyScore 	= src.countThisWeek
		data.leftPlay 		= src.leftPlayTimes
		data.dailyLevelPlay = src.mainLevelCount or 0
		data.dailyShare 	= src.shareCount
		data.receivedDailyRewards = copyTable(src.todayReward)
		data.receivedWeeklyRewards = copyTable(src.rewardsThisWeek)
		data.dropPropCount = src.droppedCount
		data.totalPlayed = src.playSummerMatchTimes
		data.dailyDropPropCount = src.droppedCountDaily or 0
		data.firstGuideRewarded = src.firstGuideRewarded

		data.activeFriends = src.friendIds
		data.lastWeekSurpass = src.lastPassFriendCount
		data.lastWeekRank = src.lastPos
		data.lastWeekRewards = copyTable(src.rewardsLastWeek)
		data.lastWeekRankRewards = copyTable(src.rankRewardsLastWeek)

		if type(localData) == "table" and type(localData.lastPlayedTime) == "number" then
			data.lastPlayedTime = localData.lastPlayedTime
		end

		local timeStamp = Localhost:time()
		local num = tonumber(src.playCountReceived) or 0
		if num > 0 then
			CCUserDefault:sharedUserDefault():setFloatForKey("season.weekly.race.help.record", timeStamp)
			local now = Localhost:time()
			local createTime = UserManager:getInstance().mark.createTime or now
			local todayStart = math.floor((now - createTime) / 86400000) * 86400000 + createTime
			local timeStamp = CCUserDefault:sharedUserDefault():getFloatForKey("season.weekly.race.help.record")
			local hasNum = CCUserDefault:sharedUserDefault():getIntegerForKey("season.weekly.race.help.num")
			if type(timeStamp) == "number" and timeStamp > todayStart and timeStamp < todayStart + 86400000 and
				type(hasNum) == "number" and hasNum > 0 then
				CCUserDefault:sharedUserDefault():setIntegerForKey("season.weekly.race.help.num", num + hasNum)
			else
				CCUserDefault:sharedUserDefault():setIntegerForKey("season.weekly.race.help.num", num)
			end
			CCUserDefault:sharedUserDefault():flush()
		end
	end
	return data
end

function SeasonWeeklyRaceData:getLevelRandomDataFromLocal(data)
	self.randomedIndices = data.randomedIndices or {}
	self.lastIndexFinished = data.lastIndexFinished or false
end

function SeasonWeeklyRaceData:getIsShowHelpTip()
	local now = Localhost:time()
	local createTime = UserManager:getInstance().mark.createTime or now
	local todayStart = math.floor((now - createTime) / 86400000) * 86400000 + createTime
	local timeStamp = CCUserDefault:sharedUserDefault():getFloatForKey("season.weekly.race.help.record")
	local num = CCUserDefault:sharedUserDefault():getIntegerForKey("season.weekly.race.help.num")
	if type(timeStamp) == "number" and timeStamp > todayStart and timeStamp < todayStart + 86400000 and
		type(num) == "number" and num > 0 then
		return true
	end
	return false
end

function SeasonWeeklyRaceData:ShowedHelpTip()
	CCUserDefault:sharedUserDefault():setIntegerForKey("season.weekly.race.help.num", 0)
	CCUserDefault:sharedUserDefault():flush()
end

function SeasonWeeklyRaceData:getHelpNum()
	return tonumber(CCUserDefault:sharedUserDefault():getIntegerForKey("season.weekly.race.help.num"))
end

function SeasonWeeklyRaceData:encode()
	local data = {}
	for k, v in pairs(self) do
		if k ~= "class" and v ~= nil and type(v) ~= "function" then data[k] = v end
	end
	return data
end