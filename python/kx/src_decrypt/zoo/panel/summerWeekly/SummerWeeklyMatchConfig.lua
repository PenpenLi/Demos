SummerWeeklyMatchConfig = class()

local _instance = nil
function SummerWeeklyMatchConfig:ctor()
	self.dailyShare = 1
	self.freePlayByShare = 1
	self.dailyMainLevelPlay = 3
	self.freePlayByMainLevel = 2
	self.playCardGoodId = 150
	self.minLevel = 31
	self.levelIds = {230007, 230008, 230009, 230010, 230011, 230012} -- default
	self.levelRewards = {}
	self.weeklyDropProp = 7
	self.specialPercentPlays = {14,16,20}
	self.specialPercent = 10
	self.maxDailyDropPropsCount = 1
end

function SummerWeeklyMatchConfig:getInstance()
	if not _instance then
		_instance = SummerWeeklyMatchConfig.new()
		_instance:init()
	end
	return _instance
end

function SummerWeeklyMatchConfig:getSpecialPercent(playCount)
	if self.specialPercentPlays then
		if table.exist(self.specialPercentPlays, playCount) then
			return self.specialPercent
		end
	end
	return nil
end

function SummerWeeklyMatchConfig:init()
	if MetaManager:getInstance().summerWeeklyRewards then
		for _, v in pairs(MetaManager:getInstance().summerWeeklyRewards) do
			self.levelRewards[v.levelId] = v
		end
	end
	self.levelIds = MetaManager:getInstance().global.summer_week_match_levels
	self.maxDailyDropPropsCount = MetaManager:getInstance().global.summer_week_max_prop_daily or 1
	self.weeklyDropProp = MetaManager:getInstance().global.summer_week_max_prop or 7
end

function SummerWeeklyMatchConfig:getRewardsConfigByLevelId(levelId)
	if levelId then
		return self.levelRewards[levelId]
	end
	return nil
end