--Filename:timeUtil.lua
--Author：hechao
--Date：2013/4/18
--Purpose:公用方法集合
module("TimeUtil",package.seeall)

require "script/utils/LuaUtil"
local m_i18n = gi18n
----------------------------newtimeutil合并-------------------

m_daySec = 86400
m_hourSec = 3600

-- 根据索引返回周几对应的数字，从 1 ～ 7
m_wdayI18n = {m_i18n[1956], m_i18n[1957], m_i18n[1958], m_i18n[1959], m_i18n[1960], m_i18n[1961], m_i18n[1962], }

-- 给定 lua os.date("*t") 得到table中的wday字段值，返回实际对应的星期几
function getRealwday( wday )
	local day = {7, 1, 2, 3, 4, 5, 6}
	return day[wday]
end

function getTodayWday( ... )
	local tbDate = getServerDateTime()
	return getRealwday(tbDate.wday)
end

-- 返回本地时间和服务器时间的快慢偏差（非时区偏差），单位秒
function getDiffFromLocalToSvr( ... )
	local diff = os.time() - getSvrTimeByOffset() 
	--logger:debug("getDiffFromLocalToSvr-diff = %d", diff)
	return diff
end

-- 返回本地和服务器时区的时间偏差，单位秒
function getOffsetFromLocalToSvr( ... )
	local localZone = os.date("%z")  -- 本地时区和格林威治时间(GMT)相差的时间信息，如东八区 "+0800"， 其他 "-1100"
	local sign, hour, min = string.match(localZone, "(.)(%d%d)(%d%d)")
	-- logger:debug("localZone = %s, sign = %s, hour = %s, min = %s", localZone, sign, hour, min)

	local localOffset = (tonumber(hour)*60*60 + tonumber(min)*60) * tonumber(sign .. "1")
	-- 当前时间本地时区和服务器时区偏差的秒数 = 本地和格林威治时区偏差秒数 + 服务器时区和格林威治时区偏差秒数
	local localSvrOffset = localOffset + gi18nTimeOffset()
	--logger:debug("svrOffset = %d, localOffset = %d, localSvrOffset = %d", gi18nTimeOffset(), localOffset, localSvrOffset)

	return localSvrOffset
end

-- zhangqi, 2015-01-19, 返回根据配置的时区偏移秒数以及设备当前时间计算得出的游戏服务器时间
-- return 1, 当前时间table， {year = , month = , day = , yday = , wday = , hour = , min = , sec = , isdst = false}
-- return 2, 当前时间戳
function getServerDateTime( timeInt )
	-- 2016-02-17, 给逻辑运算添加括号，修正之前timeInt不为nil时不会减去getOffsetFromLocalToSvr的问题
	local now = (timeInt or getSvrTimeByOffset()) - getOffsetFromLocalToSvr()
	local tDate = os.date("*t", now)
	if (tDate.isdst == true) then
		now = now - 60*60 -- 2016-02-29， 如果当前时区是夏时制，则把时间向前拨一个小时在进行转换
		tDate = os.date("*t", now)
	end
	return tDate, now
end

-- zhangqi, 2016-02-20, 指定一个服务器时区的时间戳，返回其对应的时区无关的时间戳，
-- 便于和本地的时间戳计算差值，常用于倒计时的计算
-- svrTimestamp：相对于服务器时区的时间戳
-- return：服务器时区时间戳对应的时区无关时间戳
function standTimestamp( svrTimestamp )
	assert(svrTimestamp, "svrTimestamp must not be nil")
	return svrTimestamp + getOffsetFromLocalToSvr()
end

--考虑时区问题，提供新的os.date()方法  liweidong
-- serTime 服务器时间戳 当前时间一般都由getSvrTimeByOffset生成
function getLocalOffsetDate(format,serTime)
	local _, svrTime = getServerDateTime(serTime) -- zhangqi, 原来的逻辑直接调用getServerDateTime即可
	-- logger:debug({getLocalOffsetDate_serTime = serTime, svrTime = svrTime, format = format})
	return os.date(format, svrTime)
end

-- timeInterval, 时间戳
-- strFmt, 表示转换时间字符串的格式字符串，如: "%Y-%m-%d %H:%M:%S"
function getTimeStringWithFormat( timeInterval, strFmt )
	return os.date(strFmt, tonumber(timeInterval))
end

-- m_time：时间戳  return：时间格式：2014-06-01
function getTimeFormatYMD( m_time )
	return getTimeStringWithFormat(m_time, "%Y-%m-%d")
end

-- para：时间戳  return：时间格式：2014-06-01 01:01
function getTimeFormatYMDHM( m_time )
	return getTimeStringWithFormat(m_time, "%Y-%m-%d %H:%M")
end

----------------------------newtimeutil end-------------------

-- 将一个时间戳转换成"00:00:00"格式
function getTimeString(timeInt)
	local ret = string.format("%02d:%02d:%02d", math.floor(timeInt/(60*60)), math.floor((timeInt/60)%60), timeInt%60)
	return (tonumber(timeInt) <= 0) and "00:00:00" or ret
end

-- 将一个时间数转换成"00时00分00秒"格式
function getTimeStringFont(timeInt)
	local def = string.format("00%s00%s00%s", m_i18n[1977], m_i18n[1976], m_i18n[1981])
	local ret = string.format("%02d%s%02d%s%02d%s", 
			math.floor(timeInt/(60*60)), m_i18n[1977], math.floor((timeInt/60)%60), m_i18n[1976], timeInt%60, m_i18n[1981])
	return (tonumber(timeInt) <= 0) and def or ret
end

-- nGenTime: 起始时间戳（也可以是一个未来的时间，比如CD时间戳）
-- nDuration: 固定的有效期间，单位秒，计算某个未来时间的剩余时间时不需要指定。
-- 返回3个结果，第一个是剩余到期时间的字符串，"HH:MM:SS", 不足2位自动补零；第二个是bool，标识nGenTime是否到期；第三个是剩余秒数
function expireTimeString( nGenTime, nDuration )
    local nNow = BTUtil:getSvrTimeInterval()
    --logger:debug("nGenTime = " .. nGenTime .. " nNow = " .. nNow)
    local nViewSec = (nDuration or 0) - (nNow - nGenTime)
    nViewSec = nViewSec<0 and 0 or nViewSec
    return getTimeString(nViewSec), nViewSec <= 0, nViewSec
end

-- xufei，2016-01-04，获得传入时间当天零点的时间戳
function getZeroClockTime( time )
	local tbTime = getServerDateTime(time)
	tbTime.hour = 0
	tbTime.min = 0
	tbTime.sec = 0
	return os.time(tbTime)
end

-- zhangqi, 2016-01-02, 将传入的两个时间戳转换成服务器时区的时间戳
-- 然后再转换成各自当天0点的时间戳，最后返回转换后的时间戳的相差天数
function getDifferDayBaseZeroClock( time1, time2 )
	local tb1 = getServerDateTime(time1)
    tb1.hour = 0
    tb1.min = 0
    tb1.sec = 0

    local tb2 = getServerDateTime(time2)
    tb2.hour = 0
    tb2.min = 0
    tb2.sec = 0

    return (os.time(tb1) - os.time(tb2))/(24*60*60)
end

--得到一个时间戳timeInt与当前时间的相隔天数
--offset是偏移量,例如凌晨4点:4*60*60
--return type is integer, 0--当天, n--不在同一天,相差n天
function getDifferDay(timeInt, offset)
	timeInt = tonumber(timeInt or 0)
	offset = tonumber(offset or 0)
    local curTime = tonumber(BTUtil:getSvrTimeInterval()) - offset
    local diff = getDifferDayBaseZeroClock(curTime, timeInt - offset)
    local sign = diff * -1 > 0 and -1 or 1
    return diff, sign
end

-- 指定一个日期时间字符串，返回对应的时间戳 xufei 2016-01-04
-- sTime: 格式："20160104141000" 14位
-- 没计算时差
function getTimestampByTimeStr( sTime )
	local temp = {}
	temp.year, temp.month, temp.day, temp.hour, temp.min, temp.sec = string.match(sTime, 
		"(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)(%d%d)")
	return os.time(temp)
end

--给一个时间如:153000,得到今天15:30:00的时间戳 
function getIntervalByTime( time )
	local temp = getServerDateTime()
	time = string.format("%06d", time)

	temp.hour, temp.min, temp.sec = string.match(time, "(%d%d)(%d%d)(%d%d)" )
    return os.time(temp)
end

--指定一个格式如：hh:mm:ss 的时间字符串，返回这个时间转换为秒后的整数值
function getSecondByTime( timeString )
	local timeInfo = string.split(timeString,":")
	return tonumber(timeInfo[1])*3600 + tonumber(timeInfo[2])*60 + tonumber(timeInfo[3])
end

-- 把一个时间戳转换为 ”n天n小时n分钟n秒“ 如果某一项为0则不显示这一项
-- timeInt:时间戳
function getTimeDesByInterval( timeInt )
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
		result = result .. om .. m_i18n[1976]
	end
	if(os ~= 0) then
		result = result .. os .. m_i18n[1981]
	end
	return result
end


-- 把一个时间戳转换为 ”n天n:n:n秒“ 如果某一项为0则不显示这一项
-- timeInt:时间戳
function getTimeByInterval( timeInt )
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
	local ret = string.format("%02d:%02d:%02d", hour, om, os)
	result = result .. ret
	return result
end



--给一个时间如:153000,得到今天15:30:00的时间戳 相对于服务器的东八区时间 -- add by chengliang
-- modified: zhangqi, 2016-02-17, 为保持调用接口的代码不变，改为引用相同功能的方法：getIntervalByTime
function getSvrIntervalByTime( time )
 	return getIntervalByTime(time)
end

-- 得到服务器时间
-- 参数second_num:偏移的秒数  负数：比服务器慢，正数：比服务器快，默认-1
function getSvrTimeByOffset( second_num )
	-- 当前服务器时间
    local curServerTime = BTUtil:getSvrTimeInterval()
    local offset = tonumber(second_num) or -1
    return curServerTime+offset
end

-- para：时间戳  return：时间格式：2014-06-01 01:01:01  add by chengliang
function getTimeFormatYMDHMS( m_time )
    return getTimeStringWithFormat(m_time, "%Y-%m-%d %H:%M:%S")
end

-- para：时间戳  return：时间格式：2014-06-01 01:01  add by licong  精确到分钟
function getTimeToMin( m_time )
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)

	local timeString = temp.year .."-".. m_month .."-".. m_day .."  ".. m_hour ..":".. m_min 

    return timeString
end

-- para：时间戳  return：时间格式： 01:01  add by 李攀 只要 小时和分钟

function getTimeOnlyMin( m_time )
	local temp = os.date("*t",m_time)

	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)

	local timeString = m_hour ..":".. m_min 

    return timeString
end

-- modified, zhangqi, 2015-01-20
-- 参数 second, 秒数
-- 返回 second 表示的时间字符串，单位按 "分钟"， "小时"， "天"
function getTimeStringWithUnit( second )
	second = tonumber(second)
	if (second < 60*60) then
		return math.ceil(second/60) .. m_i18n[1976]
	elseif (second < 60*60*24) then
		return math.ceil(second/(60*60)) .. m_i18n[1977]
	else
		return math.ceil(second/(60*60*24) ) .. m_i18n[1937]
	end
end

-- zhangqi, 2015-06-11, 以下3个方法用于检测一段代码的运行时间
-- timeStart 和 timeEnd 可以嵌套，但必须一一对应，原则是就近匹配
local tbTimeStart = {}
function clearTimeStart( ... )
	tbTimeStart = {}
end
-- 启动一次计时，strFlag 作为当前计时的标记名称
function timeStart( strFlag )
	if (not g_debug_mode) then
		return -- zhangqi, 2016-03-03, 如果不是开发模式直接返回
	end

	for k,v in pairs(tbTimeStart) do
		if (strFlag==v.flag) then
			return --如果存在不再插入
		end
	end 
	table.insert(tbTimeStart, {flag = strFlag, ms = BTUtil:Now()/1000})
end
-- 终止最近的一个 timeStart 计时，输出时间间隔，单位毫秒
-- 输出："strFlag use ms: 实际花费的毫秒数", strFlag 就是 timeStart的参数
--liweidong 增加strFlag参数，终止指定一个 timeStart 计时，方便个人使用。现在还可以像之前一样不传参数使用（终止最近的一个 timeStart 计时）
function timeEnd( strFlag )
	if (not g_debug_mode) then
		return -- zhangqi, 2016-03-03, 如果不是开发模式直接返回
	end
	
	assert(not table.isEmpty(tbTimeStart), "no time start")
	if (not strFlag) then
		local start = table.remove(tbTimeStart)
		print(start.flag .. " use ms: " .. (BTUtil:Now()/1000 - start.ms))
		print("")
	else
		for k,v in pairs(tbTimeStart) do
			if (strFlag==v.flag) then
				print(v.flag .. " use ms: " .. (BTUtil:Now()/1000 - v.ms))
				print("")
				table.remove(tbTimeStart,k)
				return
			end
		end
	end
end



