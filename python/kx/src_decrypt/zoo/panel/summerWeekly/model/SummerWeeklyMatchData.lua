SummerWeeklyMatchData = class()

local function copyTable(t)
	local ret = {}
	if type(t) == "table" then
		for k, v in pairs(t) do
			ret[k] = v
		end
	end
	return ret
end

function SummerWeeklyMatchData:ctor()
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

	-- 上周奖励相关数据	
	self.lastWeekSurpass = 0
	self.lastWeekRank = 0
	self.lastWeekRewards = {}
	self.lastWeekRankRewards = {}
end

function SummerWeeklyMatchData:decrLeftPlay()
	self.leftPlay = self.leftPlay - 1
end

function SummerWeeklyMatchData:resetDailyData()
	self.dailyMaxScore 	= 0
	self.dailyLevelPlay = 0
	self.dailyShare 	= 0
	self.leftPlay 		= 0
	self.receivedDailyRewards = {}
	self.dailyDropPropCount = 0
end

function SummerWeeklyMatchData:resetWeeklyData()
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

function SummerWeeklyMatchData:incrLeftPlay(incrPlay)
	incrPlay = incrPlay or 1
	self.leftPlay = self.leftPlay + incrPlay
end

function SummerWeeklyMatchData:addScore(newScore)
	if newScore > self.dailyMaxScore then
		self.dailyMaxScore = newScore
	end
	self.weeklyScore = self.weeklyScore + newScore
end

function SummerWeeklyMatchData:addShareCount(addCount)
	addCount = addCount or 1
	self.dailyShare = self.dailyShare + addCount
end

function SummerWeeklyMatchData:addDailyTimePropCount(addCount)
	addCount = addCount or 1
	self.dailyDropPropCount = self.dailyDropPropCount + addCount
end

function SummerWeeklyMatchData:addDailyLevelPlayCount( addCount )
	addCount = addCount or 1
	self.dailyLevelPlay = self.dailyLevelPlay + addCount
end

function SummerWeeklyMatchData:fromLua(src)
	local data = SummerWeeklyMatchData.new()
	if src then
		data.dailyMaxScore 	= src.dailyMaxScore
		data.weeklyScore 	= src.weeklyScore
		data.leftPlay 		= src.leftPlay
		data.dailyLevelPlay = src.dailyLevelPlay
		data.dailyShare 	= src.dailyShare
		data.receivedDailyRewards = copyTable(src.receivedDailyRewards)
		data.receivedWeeklyRewards = copyTable(src.receivedWeeklyRewards)
		data.updateTime = src.updateTime
		data.dropPropCount = src.dropPropCount or 0
		data.totalPlayed = src.totalPlayed or 0
		data.dailyDropPropCount = src.droppedCountDaily or 0
		data.firstGuideRewarded = src.firstGuideRewarded
	end
	return data
end

function SummerWeeklyMatchData:fromRespData(src)
	local data = SummerWeeklyMatchData.new()
	if src then
		data.dailyMaxScore 	= src.levelMax
		data.weeklyScore 	= src.countThisWeek
		data.leftPlay 		= src.leftPlayTimes
		data.dailyLevelPlay = src.mainLevelCount
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
	end
	return data
end
