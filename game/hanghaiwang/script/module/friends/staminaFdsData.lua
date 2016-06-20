-- FileName: staminaFdsData.lua
-- Author: xianghuiZhang
-- Date: 2014-04-00
-- Purpose: 好友赠送耐力数据model
--[[TODO List]]

module("staminaFdsData", package.seeall)
require "script/module/friends/MainFdsData"

-- UI控件引用变量 --

-- 模块局部变量 --
local curUId --当前玩家id
local curTime --当前赠送时间
local tbStaminaData --我的好友

local function init(...)

end

function destroy(...)
	package.loaded["staminaFdsData"] = nil
end

function moduleName()
    return "staminaFdsData"
end

function create(callback)
	-- RequestCenter.friend_receiveLoveList(callback)
end

function setStaminaData( tbData )
	tbStaminaData = tbData
	setTodayReceiveTimes(getOneDayTotalTimes() - tonumber(tbData.num))
	setReceiveList(tbStaminaData.va_love)
	logger:debug({tbStaminaData = tbStaminaData})
end

function getStaminaList( ... )
	if (tbStaminaData ~= nil) then
		return tbStaminaData.va_love
	end
	return nil
end

function getReceiveList( onCallBack )
	local tbPageFdsData = {}
	local tbStamina = getStaminaList()
	if (tbStamina) then
		for k,v in pairs(tbStamina) do
			if (v ~= nil) then
				v.eventBack = onCallBack
				v.dayTime = getValidTime(v.time)
				local tbFdsData = getThisFriendDataByUid(v.uid)
				if (tbFdsData ~= nil and tbFdsData.uname ~= nil) then
					v.uname = tbFdsData.uname
					v.fight_force = tbFdsData.fight_force
					v.level = tbFdsData.level
					v.utid = tbFdsData.utid
					v.figure = tbFdsData.figure
					table.insert(tbPageFdsData,v)
				end
			end
		end
	end
	return tbPageFdsData
end

-- 得到好友的数据
function getThisFriendDataByUid( uid )
	local tbFdsData = MainFdsData.getFriendsList()
	if(tbFdsData == nil)then
		return
	end
	print("============= uid ",uid)
	local data = {}
	for k,v in pairs(tbFdsData) do
		if(tonumber(uid) == tonumber(v.uid))then
			data = v
		end
	end
	return data
end

function setUid( fuid )
	curUId = fuid
end

function getUid( ... )
	return curUId	
end

function setTime( ftime )
	curTime = ftime
end

function getMsgName( ... )
	local msgName = nil
	for k,v in pairs(tbStaminaData) do
		if (tonumber(v.uid) == curUId) then
			msgName = v.uname
		end
	end
	return msgName	
end

-- 得到总共可领取的次数
function getOneDayTotalTimes( ... )
	require "db/DB_Give_stamina"
	local times = 0
	local data = DB_Give_stamina.getDataById(1)
	times = tonumber(data.get_stamina_times)
	return times
end

-- 得到一次可赠送的体力值
function getGiveStaminaNum( ... )
	require "db/DB_Give_stamina"
	local num = 0
	local data = DB_Give_stamina.getDataById(1)
	num = tonumber(data.give_stamina_num)
	return num
end

-- 得到今日剩余次数
function getTodayReceiveTimes( ... )
	return receiveTimes
end

-- 设置今日剩余次数
function setTodayReceiveTimes( data )
	receiveTimes = tonumber(data)
end

-- 设置可领取列表
function setReceiveList( listData )
	receiveList = {}
	for k,v in pairs(listData) do
		receiveList[#receiveList+1] = listData[k]
	end
	print("receiveList:")
	print_t(receiveList)
	-- 按时间由大到小排序
	local function timeDownSort( a, b )
		return tonumber(a.time) > tonumber(b.time)
	end
	table.sort( receiveList, timeDownSort )
	print_t(receiveList)
	tbStaminaData.va_love = receiveList
end

-- 删除已领取的数据
-- delStaminaDataByTimeAndUid
function delStaminaDataByTimeAndUid()
	local data = {}
	local oldData = getStaminaList()
	for k,v in pairs(oldData) do
		if(tonumber(curTime) == tonumber(v.time) and tonumber(curUId) == tonumber(v.uid))then
			oldData[k] = nil
		else
			data[#data+1] = oldData[k]
		end
	end
	curUId = nil
	curTime = nil
	setReceiveList( data )
end

-- 得到体力有效时间 返回一个str 如:"今天"
local tDay = {
	gi18n[2143], gi18n[2144], gi18n[2145], gi18n[2146], gi18n[2147], gi18n[2148], gi18n[2149], gi18n[2150], gi18n[2151], gi18n[2152], gi18n[2153], gi18n[2154], gi18n[2155], gi18n[2156], gi18n[2157], gi18n[2165]
}
-- timeData：时间戳
function getValidTime( time )
	local timeData = tonumber(time)
	if( timeData == nil)then
		return " "
	end
	local curServerTime = TimeUtil.getSvrTimeByOffset()
	local date = TimeUtil.getLocalOffsetDate("*t", curServerTime)
	-- print_t(date)
	print("curMonth",date.month)
	print("curDay",date.day)
	local curHour = tonumber(date.hour)
	print("curHour",curHour)
	local curMin = tonumber(date.min)
	print("curMin",curMin)
	local cruSec = tonumber(date.sec)
	print("cruSec",cruSec)
	-- 今天从0点到现在的所有秒数
	local curTotal = curHour*3600 + curMin*60 + cruSec
	-- timeData 跟 现在时间 的时间差
	local subTime = curServerTime - tonumber(timeData)
	-- 判断是否在同一天
	-- 两个时间段相差的秒数
	local overTime =  subTime - curTotal
	-- overTime 大于0表明不是今天
	if( overTime > 0)then
		-- 向上取整 1天前为1
		local num = math.ceil(overTime/(24*3600))
		print("num:",num)
		return tDay[num+1]
	else
		return tDay[1]
	end
end

-- 把当前时间设置为上次赠送的时间
function setGiveTimeByUid( ... )
	if(tbStaminaData == nil)then
		return
	end
	print("============= curUId ",curUId)
	for k,v in pairs(tbStaminaData) do
		if(tonumber(curUId) == tonumber(v.uid))then
			local curServerTime = TimeUtil.getSvrTimeByOffset()
			v.lovedTime = curServerTime
		end
	end 
end


--是否需要回赠
function isRebateFun( ... )
	local isGiveData = 0
	local fdsData = getThisFriendDataByUid(curUId)

	local isGive = MainFdsData.isGiveTodayByTime( fdsData.lovedTime ) 
	if(isGive)then
		-- 已赠送则不需要回赠为0
		isGiveData = 0
	else
		-- 未赠送 需要回赠为1
		isGiveData = 1
	end
	return isGiveData
end

--全部赠送好友耐力后更新好友耐力状态
function getFdsGiveData( dataList )
	local staminaData = getStaminaList()
	if(staminaData ~= nil) then
		local tbDelData = {}
		if (dataList ~= nil) then
			print("dataList")
			print_t(dataList)
			for k,v in pairs(dataList) do
				for lk,lv in pairs(staminaData) do
					if (tonumber(v.uid) ~= tonumber(lv.uid)) then
						table.insert(tbDelData,lv.uid)
					end
				end
			end
		else
			tbDelData = staminaData
		end
		return tbDelData
	end
	return nil
end

---------数据请求
function getAllLoveReq( callback )
	RequestCenter.friend_reveiveAllLove(callback)
end

function getLoveReq( callback )
	local args = Network.argsHandler(curTime, curUId, isRebateFun())
	RequestCenter.friend_reveiveLove(callback,args)
end

