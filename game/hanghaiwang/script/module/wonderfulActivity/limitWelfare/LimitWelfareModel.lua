-- FileName: LimitWelfareModel.lua
-- Author: Xufei
-- Date: 2015-01-19
-- Purpose: 限时福利
--[[TODO List]]

module("LimitWelfareModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _listIcon = nil
local _listName = nil
local _dbLimitWelfare = {}
local _selfCell = nil
local TITTLE_PIC_PATH = "images/wonderfullAct/"

local function init(...)
	_dbLimitWelfare = {}
end

-- function isLimitWelfareOpen( needReturnDB )
-- 	if ( true or  ActivityConfigUtil.isActivityOpen("weal") ) then
-- 		local limitWelfareDB = ActivityConfigUtil.getDataByKey( "weal" ).data
-- 		local serverRealOpenTime = g_tbServerInfo.openDateTime
-- 		local nowTime = TimeUtil.getSvrTimeByOffset()
-- 		local isFindOpen = false
-- 		local openedDB = {}
-- 		for k,v in pairs ( limitWelfareDB ) do
-- 			local nilTime = "00000000000000"
-- 			local dbServerTime = TimeUtil.getTimestampByTimeStr(v.server_time or nilTime)
-- 			local dbStartTime = TimeUtil.getTimestampByTimeStr(v.start_time or nilTime)
-- 			local dbEndTime = TimeUtil.getTimestampByTimeStr(v.end_time or nilTime)
-- 			--logger:debug({ key = k,v =   {look_dbServerTime = dbServerTime,
-- 							-- look_dbStartTime = dbStartTime,
-- 							-- look_dbEndTime = dbEndTime,
-- 							-- look_realServerTime = serverRealOpenTime,
-- 							-- look_realNowTime = nowTime}})
-- 			if ( (dbServerTime>=serverRealOpenTime) and (dbStartTime<=nowTime) and (dbEndTime>=nowTime) ) then
-- 				isFindOpen = true
-- 				openedDB = v
-- 				break
-- 			end
-- 		end
-- 		if (isFindOpen) then
-- 			--logger:debug("limitW_have_find_open")
-- 			--logger:debug(openedDB)
-- 			updateLimitActData(openedDB)
-- 			if (needReturnDB) then
-- 				return true, openedDB
-- 			else
-- 				return true
-- 			end
-- 		else
-- 			--logger:debug("limitW_not_find_open")
-- 			return false
-- 		end
-- 	else
-- 		--logger:debug("limitW_all_not_open")
-- 		return false
-- 	end
-- end


--[[desc:活动是否开启  modify by yangna 2016.2.27
    arg1: 参数说明
    return: 1 bool 是否开启 ; 2 table 数据
—]]
function isLimitWelfareOpen(  )
	-- logger:debug("=======?")
	local status =  ActivityConfigUtil.isActivityOpen("weal") 
	if (not status) then 
		logger:debug("活动没开启")
		return false
	end 


	local limitWelfareDB = ActivityConfigUtil.getDataByKey( "weal" ).data

	-- logger:debug(limitWelfareDB)

	local serverRealOpenTime = g_tbServerInfo.openDateTime
	local nowTime = TimeUtil.getSvrTimeByOffset()
	local isFindOpen = false
	local openedDB = {}
	for k,v in pairs ( limitWelfareDB ) do
		local nilTime = "00000000000000"
		local dbServerTime = TimeUtil.getTimestampByTimeStr(v.server_time or nilTime)
		local dbStartTime = TimeUtil.getTimestampByTimeStr(v.start_time or nilTime)
		local dbEndTime = TimeUtil.getTimestampByTimeStr(v.end_time or nilTime)

		dbServerTime = TimeUtil.standTimestamp(dbServerTime)
		dbStartTime = TimeUtil.standTimestamp(dbStartTime)
		dbEndTime = TimeUtil.standTimestamp(dbEndTime)
	
		if ( (dbServerTime>=serverRealOpenTime) and (dbStartTime<=nowTime) and (dbEndTime>=nowTime) ) then
			isFindOpen = true
			openedDB = v
			break
		end
	end


	-- logger:debug({
	-- 	isFindOpen = isFindOpen,
	-- 	openedDB = openedDB,
	-- 	})

	if (isFindOpen) then
		updateLimitActData(openedDB)
		return true, openedDB
	end 

	return false
end


-- function getLimitWelfareData( ... )
-- 	if (isLimitWelfareOpen()) then
-- 		local _,limitWelfareDB = isLimitWelfareOpen(true)

-- 		--logger:debug("limitWelfare_is_open_and_return_db")
-- 		--logger:debug({now_weal_data = limitWelfareDB})
-- 		return limitWelfareDB
-- 	else
-- 		--logger:debug("limitW_return_nil")
-- 		return nil
-- 	end
-- end



function getLimitWelfareData( ... )
	local status,limitWelfareDB = isLimitWelfareOpen()
	return status and limitWelfareDB or nil
end


function updateLimitActData( limitWelDB )
	init()
	_dbLimitWelfare = limitWelDB or {}
end

function getLimitWelDB( ... )
	return _dbLimitWelfare
end

function getCountDownTime( ... )
	local nowTime = TimeUtil.getSvrTimeByOffset()
	local nilTime = "00000000000000"
	local endTime = TimeUtil.getTimestampByTimeStr(_dbLimitWelfare.end_time or nilTime)
	endTime = TimeUtil.standTimestamp(endTime)

	if (endTime > nowTime) then
		return TimeUtil.getTimeDesByInterval( endTime - nowTime )
	else
		return "本轮活动已经结束" -- TODO
	end
end

function getIcons( ... )
	local tbIcons = {}
	tbIcons.listIcon = _dbLimitWelfare.icon
	tbIcons.listName = _dbLimitWelfare.name
	tbIcons.tittle = _dbLimitWelfare.title
	return tbIcons
end

function setIconActAndName(icon,imageName)
 	_listIcon = icon
 	_listName = imageName
end

function getIconAndName( ... )
	local tbRet = {}
	tbRet.icon = _listIcon
	tbRet.name = _listName
	return tbRet
end

-- 在手机中存储是否曾经访问过这个按钮
function setNewAniState( nState )
	g_UserDefault:setIntegerForKey("limit_welfare_new_visible"..g_tbServerInfo.groupid..UserModel.getUserUid().._dbLimitWelfare.end_time, nState)
end

-- 获取是否访问过这个按钮的状态
function getNewAniState()
	return g_UserDefault:getIntegerForKey("limit_welfare_new_visible"..g_tbServerInfo.groupid..UserModel.getUserUid().._dbLimitWelfare.end_time)
end

function setCell( cell )
	_selfCell = cell
end

function getCell( ... )
	return _selfCell
end


function destroy(...)
	_dbLimitWelfare = {}
	setCell( nil )
	package.loaded["LimitWelfareModel"] = nil
end


function moduleName()
    return "LimitWelfareModel"
end

function create(...)

end
