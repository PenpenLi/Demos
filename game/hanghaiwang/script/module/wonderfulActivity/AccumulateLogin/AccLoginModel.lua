-- FileName: AccLoginModel.lua
-- Author: yucong
-- Date: 2015-11-11
-- Purpose: 累计登录model
--[[TODO List]]

module("AccLoginModel", package.seeall)

STATE_CAN		= 1 	-- 可领取
STATE_NOT		= 2 	-- 不可领取
STATE_ALREADY	= 3 	-- 已领取

MSG_CLOSED		= "MSG_CLOSED"	-- 已关闭

local _tbAccData = nil
local _tbAccRewards = nil
local _tbDBData = nil
local _isClosed = false
local _selfCell = nil

function setAccData( data )
	logger:debug("AccLogin setAccData")
	logger:debug({tbAccData = data})
	_tbAccData = data
end

function getAccData( ... )
	return _tbAccData
end

function getAccNum( ... )
	return tonumber(_tbAccData.sign_num) or 0
end

function getAccStartTime( ... )
	local activity_data = ActivityConfigUtil.getDataByKey("accgift")
	if (activity_data) then
		return tonumber(activity_data.start_time) or 0
	end
	return 0
end

function getAccEndTime( ... )
	local activity_data = ActivityConfigUtil.getDataByKey("accgift")
	if (activity_data) then
		logger:debug(activity_data)
		return tonumber(activity_data.end_time) or 0
	end
	return 0
end

function getAccServerTime( ... )
	local activity_data = ActivityConfigUtil.getDataByKey("accgift")
	if (activity_data) then
		return tonumber(activity_data.need_open_time) or 0
	end
	return 0
end

-- 获取领取状态
function getState( day )
	logger:debug("AccLogin getState ".. day)
	if (not _tbAccData) then
		return STATE_NOT
	end
	local va_sign = _tbAccData.va_sign
	local state = nil
	for k, v in pairs(va_sign) do
		if (tonumber(v) == tonumber(day)) then
			state = v
			break
		end
	end
	if (state) then
		logger:debug("AccLogin STATE_ALREADY")
		return STATE_ALREADY
	end
	if (getAccNum() >= day) then
		logger:debug("AccLogin STATE_CAN")
		return STATE_CAN
	end
	logger:debug("AccLogin STATE_NOT")
	return STATE_NOT
end

function missionComplete( id )
	logger:debug("AccLogin complete")
	--logger:debug(_tbAccData)
	table.insert(_tbAccData.va_sign, id)

	-- 全领取了也关闭
	if (not _isClosed) then
		local flag = false
		local data = getRewards()
		for k, info in pairs(data) do
			if (info ~= "" and getState(k) ~= STATE_ALREADY) then
				flag = true
				break
			end
		end
		if (not flag) then
			_isClosed = true
			GlobalNotify.postNotify(MSG_CLOSED)
		end
	end
end

function getDBData( ... )
	local activity_data = ActivityConfigUtil.getDataByKey("accgift")
	for k, info in pairs(activity_data.data) do
		return info
	end
	return nil
end

function getRewards( ... )
	local dbData = getDBData()
	logger:debug({accdbData = dbData})
	return lua_string_split(dbData.reward_array or "", ";")
end

function getRewardTypeWithDay( day )
	local dbData = getDBData()
	local rewardTypes = lua_string_split(dbData.reward_type, "|")
	return tonumber(rewardTypes[day])
end

function handleDatas( ... )
	
end

-- 倒计时str
function getCountDown( ... )
	if (_isClosed) then
		return "0"..gi18n[1981]
	end
	local delta = getAccEndTime() - TimeUtil.getSvrTimeByOffset()
	if (delta <= 0) then
		_isClosed = true
		GlobalNotify.postNotify(MSG_CLOSED)
		return "0"..gi18n[1981]
	end
	return TimeUtil.getTimeDesByInterval(delta)
end

-- 获取活动的持续时间 格式：2015.06.17 10:00 — 2015.06.17 10:00
function getDuration( ... )
	local startTime = TimeUtil.getTimeStringWithFormat(getAccStartTime(), "%Y.%m.%d %H:%M")
	local endTime = TimeUtil.getTimeStringWithFormat(getAccEndTime(), "%Y.%m.%d %H:%M")
	local str = string.format("%s - %s", startTime, endTime)
	return str
end

-- 红点数量
function getTipCount( ... )
	local count = 0
	if (not ActivityConfigUtil.getDataByKey("accgift")) then
		return count
	end
	if (tonumber(AccLoginModel.getNewAniState()) ~= 1) then
		return count
	end
	local data = getRewards()
	for k, info in pairs(data) do
		if (info ~= "" and getState(k) == STATE_CAN) then
			count = count + 1
		end
	end
	return count
end

-- 是否关闭
function isClosed( ... )
	if (not ActivityConfigUtil.isActivityOpen("accgift")) then
		return true
	end
	local now = TimeUtil.getSvrTimeByOffset()
	if (_isClosed) then
		return _isClosed
	end
	-- 开启时间未到
	if (now < getAccStartTime()) then
		logger:debug("AccLogin 开启时间没到")
		return true
	end
	-- 服务器开启时间在配置时间之前才可开启
	local nOpenServerTime = g_tbServerInfo.openDateTime
	if (nOpenServerTime > getAccServerTime()) then
		logger:debug("AccLogin 此服务器不开启")
		return true
	end
	-- 超时关闭	
	local endTime = getAccEndTime()
	if (now > endTime) then
		logger:debug("AccLogin 已结束")
		return true
	end
	-- 全领取了也关闭
	local isClosed = true
	local data = getRewards()
	for k, info in pairs(data) do
		if (info ~= "" and getState(k) ~= STATE_ALREADY) then
			isClosed = false
			break
		end
	end
	logger:debug(isClosed)
	return isClosed
end

-- 在手机中存储是否曾经访问过这个按钮
function setNewAniState( nState )
	g_UserDefault:setIntegerForKey("new_accgift_visible"..UserModel.getUserUid()..getAccEndTime(), nState)
end

-- 获取是否访问过这个按钮的状态
function getNewAniState()
	return g_UserDefault:getIntegerForKey("new_accgift_visible"..UserModel.getUserUid()..getAccEndTime())
end

function setCell( cell )
	_selfCell = cell
end

function getCell( ... )
	return _selfCell
end