SummerWeeklyShowOffData = class()

function SummerWeeklyShowOffData:ctor()
	self.date = nil
	self.dailyChampShared = 0
	self.dailySurpassShared = 0
	self.showPlayTip = true
end

function SummerWeeklyShowOffData:create()
	local data = SummerWeeklyShowOffData.new()
	data:init()
	return data
end

function SummerWeeklyShowOffData:init()
	self.date = self:keyOfToday()
end

function SummerWeeklyShowOffData:incrChampShared()
	self.dailyChampShared = self.dailyChampShared + 1
end

function SummerWeeklyShowOffData:incrSurpassShared()
	self.dailySurpassShared = self.dailySurpassShared + 1
end

function SummerWeeklyShowOffData:keyOfToday( ... )
	local day = os.date("*t", Localhost:timeInSec())
	return day.year.."_"..day.month.."_"..day.day
end

function SummerWeeklyShowOffData:hasExpired()
	if self.date ~= self:keyOfToday() then
		return true
	end
	return false
end

function SummerWeeklyShowOffData:fromLua(src)
	if src then
		local data = SummerWeeklyShowOffData.new()
		data.date = src.date
		data.dailyChampShared = src.dailyChampShared or 0
		data.dailySurpassShared = src.dailySurpassShared or 0
		data.showPlayTip = src.showPlayTip
		return data
	end
	return nil
end
