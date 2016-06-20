SeasonWeeklyRaceConfig = class()

local _instance = nil
function SeasonWeeklyRaceConfig:ctor()
	self.dailyShare = 1
	self.freePlayByShare = 1
	self.dailyMainLevelPlay = 3
	self.freePlayByMainLevel = 2
	self.playCardGoodId = 150
	self.minLevel = 31
	self.levelIds = {230301,230302,230303,230304,230305,230306,230307,230308,230309,230310,230311,230312,230313,230314,230315,230316,230317,230318,230319,230320} -- default
	self.levelRewards = {}
	self.weeklyRewards = {}
	self.winterWeeklyRewards = {}
	self.surpassRewards = {}
	self.weeklyDropProp = 7
	self.specialPercentPlays = {14,16,20}
	self.specialPercent = 10
	self.maxDailyDropPropsCount = 1
	self.startTime = os.time({year=2015, month=9, day=1, hour=0, min=0, sec=0})
	self.rankMinNum = 50
	self.firstLevelOffset = 7
	self.surpassLimit = 200
	self.weeklyRaceType = 2 -- 分享二维码相关，1 为秋季周赛，新开发时需要递增并和后端确定数字
end

function SeasonWeeklyRaceConfig:getInstance()
	if not _instance then
		_instance = SeasonWeeklyRaceConfig.new()
		_instance:init()
	end
	return _instance
end

function SeasonWeeklyRaceConfig:getSpecialPercent(playCount)
	if self.specialPercentPlays then
		if table.exist(self.specialPercentPlays, playCount) then
			return self.specialPercent
		end
	end
	return nil
end

function SeasonWeeklyRaceConfig:init()
	if MetaManager:getInstance().autumnWeeklyLevelRewards then
		for _, v in pairs(MetaManager:getInstance().autumnWeeklyLevelRewards) do
			self.levelRewards[tonumber(v.day)] = v
		end
	end

	if MetaManager:getInstance().global.summer_week_match_levels_2016 then
		self.levelIds = MetaManager:getInstance().global.summer_week_match_levels_2016
	end

	print("self.levelIds", table.tostring(self.levelIds))
	self.maxDailyDropPropsCount = MetaManager:getInstance().global.summer_week_max_prop_daily or 1
	self.weeklyDropProp = MetaManager:getInstance().global.summer_week_max_prop or 7
	self.surpassRewards = MetaManager:getInstance().global.weekSurpassReward
	self.surpassLimit = MetaManager:getInstance().global.weekSurpassLimit
	self.weeklyRewards = MetaManager:getInstance().global.weekWeeklyReward
	self.rankMinNum = MetaManager:getInstance().global.weekRankMinNum
	self.winterWeeklyRewards = MetaManager:getInstance().global.winterWeeklyReward
end

function SeasonWeeklyRaceConfig:getDailyRewardsByDay(day)
	if day then
		local levelRewards = self.levelRewards[day]
		if levelRewards then return levelRewards.dailyRewards end
	end
	return nil
end

function SeasonWeeklyRaceConfig:getWeeklyRewards()
	--之前是weeklyRewards  1.30冬季周赛后用winterWeeklyRewards （为兼容老版本） 
	return self.winterWeeklyRewards
end

function SeasonWeeklyRaceConfig:getRankMinScore()
	return self.rankMinNum
end

function SeasonWeeklyRaceConfig:getSurpassRewards()
	return self.surpassRewards
end

function SeasonWeeklyRaceConfig:getSurpassLimit()
	return self.surpassLimit
end
