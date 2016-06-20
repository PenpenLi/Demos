-- FileName: ShareModel.lua
-- Author: yucong
-- Date: 2015-07-03
-- Purpose: 每日分享Model
--[[TODO List]]

module("ShareModel", package.seeall)

require "db/DB_ShareReward"
require "db/DB_SharePlatform"
require "script/module/public/RewardUtil"
require "script/module/achieve/AchieveModel"

local _db_ShareReward	= DB_ShareReward
local _db_SharePlatform = DB_SharePlatform

MSG = {
	CB_GET_SHARE_REWARD	= "GET_SHARE_REWARD",
	CB_SHARE_RELOAD		= "SHARE_RELOAD",
}

-------------------- 属性 --------------------
local _tbDBShares	= {}
local _tbAchieves	= {}
local _tbShareContents	= {}
local _tbStatus		= {}	-- 是否已领取

function getDBShares( ... )
	return _tbDBShares
end

function getShareContent( platformId )
	--return _tbShareContents
	for k,v in pairs(_tbShareContents) do
		if (v.platformId == platformId) then
			return v
		end
	end
	assert(false, "未找到分享平台:"..platformId)
end

function setStatus( status )
	_tbStatus = status
end

function getStatus( ... )
	return _tbStatus
end

function setAchieveInfo( info )
	logger:debug(info)
	_tbAchieves = info
end

function getAchieveInfo( ... )
	return _tbAchieves
end
-------------------- 方法 --------------------
function handleDatas( ... )
	logger:debug("handleDatas")
	_tbDBShares = {}
	_tbShareContents = {}
	for k,v in pairs(_db_ShareReward.ShareReward) do
		local data = _db_ShareReward.getDataById(v[1])
		data.rewardNum = tonumber(lua_string_split(data.reward, "|")[3])
		data.tInfo = {}
		if (data.achieveId ~= nil) then
			data.tInfo = getAchieveDataById(data.achieveId)
			assert(data.tInfo.status, "ShareModel:成就下传不全")
		else
			data.tInfo.status = 1
		end
		table.insert(_tbDBShares, data)
	end
	logger:debug({_tbDBShares = _tbDBShares})

	for k,v in pairs(_db_SharePlatform.SharePlatform) do
		local data = _db_SharePlatform.getDataById(v[1])
		_tbShareContents[tonumber(data.id)] = data
	end
end

function getAchieveDataById( aid, isSimple )
	isSimple = isSimple or false
	local tbDbItem = AchieveModel.getAchieveInfoById(aid)
	--logger:debug({_tbAchieves = _tbAchieves})
	for child_type,childData in pairs(_tbAchieves or {}) do
		for id,item in pairs(childData) do
			if tonumber(id) == tonumber(aid) then
				local status = tonumber(item.s)
				tbDbItem.status = status
				if (not isSimple) then
					tbDbItem.finish_num = getFinishedNumById(id, child_type)
					tbDbItem.max_num = AchieveModel.getMaxInData(tbDbItem)
				end
				break
			end	
		end
	end
	return tbDbItem
end

function getDBShareWithId( id )
	local data = nil
	local db = ShareModel.getDBShares()
	for k, info in pairs(db) do
		if (info.id == id) then
			data = info
			break
		end
	end
	return data
end

-- 获取完成显示的 数量
function getFinishedNumById( _id, childType)
	if(table.isEmpty(_tbAchieves) == true) then
		return 0
	end

	if tonumber(childType) == 401 or tonumber(childType) == 402 or tonumber(childType) == 106 or tonumber(childType) == 301 then
		if getIsFinishedById(_id, childType) ~= 0 then
			return 1
		else
			return 0
		end
	end
	return tonumber(_tbAchieves[tostring(childType)][tostring(_id)].fn)
end

-- 获取完成度
function getIsFinishedById( _id, childType)
	logger:debug(_id)
	assert(_tbAchieves[tostring(childType)][tostring(_id)], "后端给的数据有问题 找不到成就id:" .. _id .. "childType:" .. childType)
	if(table.isEmpty(_tbAchieves) == true) then
		return 0
	end
	return tonumber(_tbAchieves[tostring(childType)][tostring(_id)].s)
end

function sort( data1, data2 )
	return data1.id < data2.id
end

function sortDatas( ... )
	logger:debug("sortDatas")
	local tCan = {}	-- 可分享
	local tNot = {}	-- 不可分享
	local tHave = {} -- 已分享
	
	for k, info in pairs(_tbDBShares or {}) do
		local status = _tbStatus[info.id] or 0
		if ((info.tInfo.status == 1 or info.tInfo.status == 2) and status == 0) then 	-- 达成调教并且未分享
			table.insert(tCan, info)
		elseif (info.tInfo.status == 0) then 	-- 不可分享并且未分享
			table.insert(tNot, info)
		elseif (status == 1) then
			table.insert(tHave, info)
		end
	end

	table.sort(tCan, sort)
	table.sort(tNot, sort)
	table.sort(tHave, sort)

	_tbDBShares = {}
	function combine( tb )
		for i,val in ipairs(tb) do
			_tbDBShares[#_tbDBShares+1] = tb[i]
		end
	end
	combine(tCan)
	combine(tNot)
	combine(tHave)
	
	--logger:debug({_tbDBShares = _tbDBShares})
end

function setStatus_handle( data )
	local tStatus = {}
	for k,v in pairs(DB_ShareReward.ShareReward) do
		local info = DB_ShareReward.getDataById(v[1])
		local id = tonumber(info.id)
		tStatus[id] = 0
		if (data[tostring(id)]) then
			tStatus[id] = tonumber(data[tostring(id)])
		end
	end
	setStatus(tStatus)
end

function getTipsCount( ... )
	local count = 0
	for k,v in pairs(DB_ShareReward.ShareReward) do
		local data = _db_ShareReward.getDataById(v[1])
		local status = _tbStatus[data.id]
		local tInfo = {}
		if (data.achieveId ~= nil) then
			tInfo = getAchieveDataById(data.achieveId, true)
		else
			tInfo.status = 1
		end

		if ((tInfo.status == 1 or tInfo.status == 2) and status ~= 1) then
			count = count + 1
		end
	end
	return count
end

function getCellImg( isDaily )
	if (isDaily) then
		return "images/common/cell/bag_cell_2_bg.png", "images/common/cell/bag_cell_txt_2_bg.png"
	else
		return "images/common/cell/bag_cell_3_bg.png", "images/common/cell/bag_cell_txt_3_bg.png"
	end
end

local function init(...)

end

function destroy(...)
	_tbDBShares = nil
	_tbShareContents = nil
	_bGainDaily = false
	package.loaded["ShareModel"] = nil
end

function moduleName()
    return "ShareModel"
end

function create(...)

end
