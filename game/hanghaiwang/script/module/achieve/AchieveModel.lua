-- FileName: AchieveModel.lua
-- Author: huxiaozhou
-- Date: 2014-11-10
-- Purpose: function description of module
-- 成就系统数据类

module("AchieveModel", package.seeall)
require "script/module/public/RewardUtil"
require "db/DB_Achie_table"

local m_i18n = gi18n
local m_i18nString = gi18nString

-- 模块局部变量 --
local m_tbAchieve = {

}

local m_tbFinished = {}

local function init(...)
	m_tbAchieve = { }
end

function destroy(...)
	package.loaded["AchieveModel"] = nil
end

function moduleName()
    return "AchieveModel"
end

function setAchieve( tbAchieve)
	init()
	m_tbAchieve = tbAchieve
end

function getTotalUnRewardNum(  )
	local count = 0
	for _,ChildType in pairs(m_tbAchieve or {}) do
		for id, tbItem in pairs(ChildType) do
				if tonumber(tbItem.s) == 1 then
				local tbDbItem = getAchieveInfoById(id)
				local isShow = tonumber(tbDbItem.is_show) or 1
				if isShow == 1  then
					count = count + 1
				end	
			end
		end
	end
	return tonumber(count)
end



--  now just a test
-- 获取完成度
function getIsFinishedById( _id, childType)
	logger:debug(_id)
	assert(m_tbAchieve[tostring(childType)][tostring(_id)], "后端给的数据有问题 找不到成就id:" .. _id .. "childType:" .. childType)
	if(table.isEmpty(m_tbAchieve) == true) then
		return 0
	end
	return tonumber(m_tbAchieve[tostring(childType)][tostring(_id)].s)
end

-- 获取完成显示的 数量
function getFinishedNumById( _id, childType)
	if(table.isEmpty(m_tbAchieve) == true) then
		return 0
	end

	if tonumber(childType) == 401 or tonumber(childType) == 402 or tonumber(childType) == 106 or tonumber(childType) == 301 then
		if getIsFinishedById(_id, childType) ~= 0 then
			return 1
		else
			return 0
		end
	end


	return tonumber(m_tbAchieve[tostring(childType)][tostring(_id)].fn)
end

--获取最大完成显示的数字
function getMaxInData( tbItem )
	local finishArry = string.split(tbItem.finish_arry, "|")
	logger:debug(tbItem)
	logger:debug(finishArry)
		if #finishArry == 1 then
			if tonumber(tbItem.child_type) == 401 or tonumber(tbItem.child_type) == 402 or tonumber(tbItem.child_type) == 106 or tonumber(tbItem.child_type) == 301  then
				return 1
			end
			return tonumber(finishArry[1])
		elseif #finishArry == 2 then
			return tonumber(finishArry[2])
		elseif #finishArry == 3 then
			return tonumber(finishArry[3])
		end
end

-- 排序 显示顺序排序
function sort (achi_1, achi_2)
	local bSort = false
	if tonumber(achi_1.sort) < tonumber(achi_2.sort) then
		bSort = true
	end
	if tonumber(achi_1.id) < tonumber(achi_2.id) then
		bSort = true
	end
	return bSort
end

-- 排序 根据当前的完成状态排序
function sortShow (achi_1, achi_2)
	local bSort = false
	if tonumber(achi_1.status) > tonumber(achi_2.status) then
		bSort = true
	end
	return bSort
end

function getShowAchieves(  )
	local tbShowData = {}
	for child_type,childData in pairs(m_tbAchieve or {}) do
		for id,item in pairs(childData) do
			local tbDbItem = getAchieveInfoById(id)
			local status = tonumber(item.s)
			local isShow = tonumber(tbDbItem.is_show) or 1
			if (status == 0 or status == 1) and isShow == 1  then
				tbDbItem.status = status
				tbDbItem.finish_num = getFinishedNumById(id, child_type)
				tbDbItem.max_num = getMaxInData(tbDbItem)
				if tbShowData[child_type] == nil then
					tbShowData[child_type] = {}
				end
				table.insert(tbShowData[child_type], tbDbItem)
			end
		end
	end
	local tb = {}
	for child_type, childData in pairs(tbShowData) do
		table.sort(childData, sort)
		if not table.isEmpty(childData) then
			table.insert(tb, childData[1])
		end
	end
	table.sort(tb, sort)
	table.sort(tb, sortShow)
	return tb
end


function changeCache( aid, status)
	for _,ChildType in pairs(m_tbAchieve or {}) do
		for id, tbItem in pairs(ChildType) do
			if tonumber(id) == tonumber(aid) then
				tbItem.s = status
			end
		end
	end
end

-- 修改缓存数据
function changeSortAchieveById(aid, status)
	logger:debug("begin changeSortAchieveById")
	logger:debug(aid)
	changeCache(aid, status)
	logger:debug("end changeSortAchieveById")
end

-- 获取成就的每一条信息
function getAchieveInfoById( _id )
	local tbDataItem = DB_Achie_table.getDataById(_id)
	return tbDataItem
end


-- 为每日分享提供一个获取一条信息的接口
function getAchieveDataById(aid)
	local tbDbItem = getAchieveInfoById(aid)
	for child_type,childData in pairs(m_tbAchieve or {}) do
		for id,item in pairs(childData) do
			if tonumber(id) == tonumber(aid) then
				local status = tonumber(item.s)
				tbDbItem.status = status
				tbDbItem.finish_num = getFinishedNumById(id, child_type)
				tbDbItem.max_num = getMaxInData(tbDbItem)
				break
			end	
		end
	end
	return tbDbItem
end


function getRewrdItems( rewardDataStr )
	local tbReward = RewardUtil.getItemsDataByStr(rewardDataStr)
	logger:debug(tbReward)
	local tbRewardItem = {}
	for _, reward in ipairs(tbReward) do
		logger:debug(reward)
		if reward.type == "item" then
			table.insert(tbRewardItem, reward.tid)
		end
	end
	return tbRewardItem
end

function getStringByRewardStr( rewardDataStr )
	local tbReward = RewardUtil.getItemsDataByStr(rewardDataStr)
	logger:debug(tbReward)
	local strName = ""
	local strNum = "X"
	for _,v in ipairs(tbReward) do
		strName = strName .. v.name 
		strNum =  strNum .. v.num
	end
	return strName, strNum 
end



