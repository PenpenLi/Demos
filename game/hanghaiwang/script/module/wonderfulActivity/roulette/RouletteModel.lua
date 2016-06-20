-- FileName: RouletteModel.lua
-- Author: lvnanchun
-- Date: 2015-08-17
-- Purpose: 幸运转盘业务逻辑
--[[TODO List]]

module("RouletteModel", package.seeall)
require "db/DB_Wheel"

-- UI variable --
local _listCell
local _btnIcon

-- module local variable --
local _tbTimeInfo
local _dbInfo
local _tbConfigInfo = nil
local _tbActicityInfo
local _nRoundTime
local _userDefault = g_UserDefault
local _dbSource = 1 -- 1为本地2为平台

local function init(...)

end

function destroy(...)
    package.loaded["RouletteModel"] = nil
end

function moduleName()
    return "RouletteModel"
end

function create(...)

end

function getDbSourceType(  )
	return _dbSource
end

--[[desc:获取上面listView中这个活动对应的按钮
    arg1: 对应listView中的cell和按钮
    return: 无 
—]]
function setIconBtn( listCell , btnIcon )
	_listCell = listCell
	_btnIcon = btnIcon
end

--[[desc:获取之前获取的cell和按钮
    arg1: 无
    return: 对应listView中的cell和按钮  
—]]
function getIcon()
	return _listCell , _btnIcon
end

--[[desc:在手机中存储是否曾经访问过这个按钮
    arg1: 访问状态
    return: 无  
—]]
function setNewAniState( nState )
	_userDefault:setIntegerForKey("new_roulette_visible"..UserModel.getUserUid(), nState)
end

--[[desc:获取是否访问过这个按钮的状态
    arg1: 无
    return: 储存的状态  
—]]
function getNewAniState()
	return _userDefault:getIntegerForKey("new_roulette_visible"..UserModel.getUserUid())
end

--[[desc:设置活动信息，包括用过的次数等
    arg1: 活动信息
    return: 无  
—]]
function setActivityInfo( activityInfo )
	_tbActicityInfo = activityInfo
	_nRoundTime = tonumber(_tbActicityInfo.round_times)
end

--[[desc:设置活动次数
    arg1: 变化的次数
    return: 无  
—]]
function changeRoundTime( changeTime )
	_nRoundTime = _nRoundTime + changeTime
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function setDBInfo()
	if (_dbSource == 2 and ActivityConfigUtil.isActivityOpen("turntable")) then
		_dbInfo = ActivityConfigUtil.getDataByKey("turntable").data
	else
		_dbInfo = DB_Wheel.getDataById(1)
	end
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getRemainTime()
	if not (_dbInfo) then
		setDBInfo()
	end

	local nDays 
	local openTime
	local endTime 

	local remainTimeStr , bOver , _ 
	local __ , bOpen , _ 

	if (_dbSource ~= 2) then
		nDays = tonumber(_dbInfo.last_day)
		openTime = tonumber(g_tbServerInfo.openDateTime)
		endTime = openTime - (openTime + 8 * 3600 ) % 86400 + nDays * 86400
	
		logger:debug(nDays)
		logger:debug(openTime)
		logger:debug(endTime)
	
		require "script/utils/NewTimeUtil"
		remainTimeStr , bOver , _ = NewTimeUtil.expireTimeString( openTime , (endTime - openTime) )
		__ , bOpen , _ = NewTimeUtil.expireTimeString( openTime )
	
		if not (bOpen) then
			bOver = true
		end

		-- 此处如果开服的结束了拉取平台的配置检查是否开启了平台的配置
		if (bOver) then
			if (ActivityConfigUtil.isActivityOpen("turntable")) then
				local activityConfigInfo = ActivityConfigUtil.getDataByKey("turntable")
				_dbInfo = activityConfigInfo.data[1]
	
				logger:debug({_dbInfo = _dbInfo})
				_dbSource = 2
	
				local openTime = activityConfigInfo.start_time
				local endTime = activityConfigInfo.end_time
	
				remainTimeStr , __ , _ = NewTimeUtil.expireTimeString( openTime , (endTime - openTime) )
				
				bOver = false
			end
		end
	else
		bOver = true
		if (ActivityConfigUtil.isActivityOpen("turntable")) then
			local activityConfigInfo = ActivityConfigUtil.getDataByKey("turntable")
			_dbInfo = activityConfigInfo.data[1]
	
			logger:debug({_dbInfo = _dbInfo})
			_dbSource = 2
	
			local openTime = activityConfigInfo.start_time
			local endTime = activityConfigInfo.end_time
	
			remainTimeStr , __ , _ = NewTimeUtil.expireTimeString( openTime , (endTime - openTime) )
			
			bOver = false
		end
	end

	logger:debug("rouletteTimefinal")
	logger:debug(remainTimeStr)
	logger:debug(bOver)

	return remainTimeStr , bOver
end

--[[desc:自行计算活动是否开启
    arg1: 无
    return: boolen  
—]]
function bActivityOpen()
	local _ , bOver = getRemainTime()
	return not bOver
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getMaxNum(  )
	if (_dbSource == 2) then
		local nVip = UserModel.getVipLevel()
		local vipNum = _dbInfo.vip_num
		local tbNumStr = string.split(vipNum, ",")
		local limitNum = 0
		logger:debug({tbNumStr = tbNumStr})
		for i,v in ipairs(tbNumStr) do
			local tbOneNum = string.split(v, "|")
			if (tonumber(tbOneNum[1]) <= nVip) then
				limitNum = tonumber(tbOneNum[2])
			else
				break
			end
		end
		logger:debug({limitNum = limitNum})
		return limitNum
	else
		return tonumber(_dbInfo.total_times)
	end
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getNextVipLevel()
	local nVip = UserModel.getVipLevel()
	local vipNum = _dbInfo.vip_num
	local tbNumStr = string.split(vipNum, ",")
	local nextVip = 0

	for i,v in ipairs(tbNumStr) do
		local tbOneNum = string.split(v, "|")
		if (tonumber(tbOneNum[1]) > nVip) then
			nextVip = tonumber(tbOneNum[1])
			break
		end
	end

	return nextVip
end

--[[desc:是否显示红点
    arg1: 无
    return: boolen  
—]]
function bShowRedPoint()
	if (bActivityOpen()) then
		if (_nRoundTime) then
			local _ , nCost = getRewardByTime( _nRoundTime + 1 )
	
			if (nCost) then
				logger:debug({getGoldNumber = UserModel.getGoldNumber()})
				logger:debug({nCost = nCost})
				return UserModel.getGoldNumber() >= nCost and _nRoundTime < getMaxNum()
			else
				return false
			end
		else 
			return false
		end
	else
		return false
	end
end

--[[desc:处理奖励字符串
    arg1: 奖励字符串
    return: 奖励的table
—]]
local function dealRewardString( strReward )
	local tbRewardStr = string.split(strReward , ',')
	local tbReward = {}
	for k,v in pairs(tbRewardStr) do 
		table.insert(tbReward , string.split(v , '|'))
	end

	return tbReward
end

--[[desc:按照次数获取奖励内容
    arg1: 第几次的奖励
    return: tReward获取的奖励table，nCost花费金钱
—]]
function getRewardByTime( nTime )
	if not (_dbInfo) then
		setDBInfo()
	end

	local nMaxNum = getMaxNum()

	local nRoundTime = nTime > nMaxNum and nMaxNum or nTime

	local strRewardIndex = "max_gain_" .. tostring(nRoundTime)
	local costIndex = "cost_" .. tostring(nRoundTime)

	local tbReward = dealRewardString(_dbInfo[strRewardIndex])
	local nCost = tonumber(_dbInfo[costIndex])

	return tbReward , nCost
end

--[[desc:是否达到幸运轮盘需求等级
    arg1: 无
    return: boolen
—]]
function bRouletteLevelNotReached()
	if (bActivityOpen()) then
		if not (_dbInfo) then
			setDBInfo()
		end
		local nLevel = tonumber(_dbInfo.lv_limit)
		logger:debug({_dbInfo = _dbInfo})
		logger:debug({nLevel = nLevel})
		return UserModel.getHeroLevel() < nLevel
	else
		return false
	end
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getVipLevelMaxNum(  )
	local vip1 = DB_Vip.getDataById(1).level
	return tonumber(vip1) + table.count(DB_Vip.Vip) - 1, tonumber(vip1)
end

--[[desc:是否显示图标
    arg1: 无
    return: boolen
—]]
function bShowIconBtn()
	if (bActivityOpen()) then
		if not (_dbInfo) then
			setDBInfo()
		end
	
		local bShow = true
		local bOver = false 
		local bLevelNotReach = false 
		local bTimeOver = false
		local nVip = UserModel.getVipLevel()
	
		_ , bOver = getRemainTime()
		bLevelNotReach = bRouletteLevelNotReached()

		if (_nRoundTime and (_dbSource ~= 2 or (_dbSource == 2 and nVip == getVipLevelMaxNum()))) then
			bTimeOver = (_nRoundTime >= getMaxNum())
		end
	
		if (bOver or bLevelNotReach or bTimeOver) then
			bShow = false
		end
	
		return bShow
	else 
		return false
	end
end





