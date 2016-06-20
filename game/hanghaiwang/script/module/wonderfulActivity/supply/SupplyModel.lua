-- FileName: SupplyModel.lua
-- Author: huxiaozhou
-- Date: 2014-05-29
-- Purpose: 吃烧鸡数据存储
--[[TODO List]]

module("SupplyModel", package.seeall)

-- 判断整个精彩活动是否有提示
-- 现在就2个，以后有一个，加一个
function hasTipInActive(  )
    if( isOnTime() or isMysteryNewIn()) then
        return true
    else
        return false
    end
end

-- 整点送体力的时间
local _supplyTime = nil 
function getSupplyTime(  )
    if _supplyTime then
        return _supplyTime 
    else
        return 0
    end
end

function setSupplyTime( supplyTime )
	_supplyTime = tonumber(supplyTime)
end

-- 判断是否为今天
 function isToday(timestamp)
    local today = TimeUtil.getLocalOffsetDate("*t",TimeUtil.getSvrTimeByOffset())
    local secondOfToday = os.time({day=today.day, month=today.month,
        year=today.year, hour=0, minute=0, second=0})
    if timestamp >= secondOfToday and timestamp < secondOfToday + 24 * 60 * 60 then
        return true
    else
        return false
    end
end

-- 判断是否到时间了
function isOnTime( )   
    local isOnTime = false
    local _, now = TimeUtil.getServerDateTime()
    if(not isPassTime( tonumber(_supplyTime), 115900) and isOnAfternoon(now)) then
        isOnTime = true
    elseif(not isPassTime(tonumber(_supplyTime),175900) and isOnEvening(now)) then
        isOnTime = true
    elseif(not isPassTime(tonumber(_supplyTime),205900) and isOnNight(now)) then
        isOnTime = true
    end
    return isOnTime
end

-- 一个时间戳，每天开始时间，每天结束时间，判断是否在开始时间和结束时间内
function isOnByTimeInterval(timeInt, startTime ,endTime)
    local _isOnTime = false
    local starTimeInt = TimeUtil.getIntervalByTime(startTime)
    local endTimeInt= TimeUtil.getIntervalByTime(endTime)
    -- logger:debug({isOnByTimeInterval_timeInt = timeInt, starTimeInt = starTimeInt, endTimeInt = endTimeInt})
    if(timeInt > starTimeInt and timeInt< endTimeInt) then
        _isOnTime = true
    end
    return _isOnTime
end

-- 判断 是否在每天的18~20 点
function isOnEvening (timeInt) 
	return isOnByTimeInterval(timeInt, 175900,200000)
end

-- 判断 是否在下午
function isOnAfternoon(timeInt)
    return isOnByTimeInterval(timeInt, 115900,140000)
end

-- 判断是否在晚上
function isOnNight( timeInt )
    return isOnByTimeInterval(timeInt, 205900,230000)
end

--[[
    @des    :判断所给的时间戳是否小于所给的时间点
    @param  :timeInt, timeHour
    @return :true or false 
]]
function isPassTime(timeInt, timeHour )
	local isPass = false
    local startTimeInt=  TimeUtil.getIntervalByTime(timeHour)
    -- 2016-02-17, zhangqi, timeInt是后端传的时间戳，需要转换成服务器时间
    local _, svrGetTime = TimeUtil.getServerDateTime(timeInt)
    -- if(timeInt > startTimeInt ) then
    -- 2016-02-17, zhangqi, startTimeInt已经是一个服务器时间，所以才能和svrGetTime进行比较
    if (svrGetTime > startTimeInt) then
        isPass = true
    end
    logger:debug({isPassTime_timeInt = timeInt, isPassTime_svrGetTime = svrGetTime, timeHour = timeHour, startTimeInt = startTimeInt, isPassTime_isPass = tostring(isPass)})
    return isPass

end

function getNoon( ... )
    return 120000, 140000
end

function getEvening( ... )
    return 180000, 200000
end

function getNight( ... )
    return 210000, 230000
end

-- 获取时间段的描述
-- 12-14点
function getPeriodDes_Noon( ... )
    local btime, etime = getNoon()
    return string.format("%02d-%02d%s", convertDBTime2Local(btime).hour, convertDBTime2Local(etime).hour, gi18n[5521])
end
-- 获取时间段的描述
function getPeriodDes_Evening( ... )
    local btime, etime = getEvening()
    return string.format("%02d-%02d%s", convertDBTime2Local(btime).hour, convertDBTime2Local(etime).hour, gi18n[5521])
end
-- 获取时间段的描述
function getPeriodDes_Night( ... )
    local btime, etime = getNight()
    return string.format("%02d-%02d%s", convertDBTime2Local(btime).hour, convertDBTime2Local(etime).hour, gi18n[5521])
end
-- 根据db配置的时间110000转换为本地时间
function convertDBTime2Local( dbTime )
    local time = TimeUtil.getIntervalByTime(dbTime) + TimeUtil.getOffsetFromLocalToSvr()
    return os.date("*t", time) --TimeUtil.getServerDateTime(time)
end