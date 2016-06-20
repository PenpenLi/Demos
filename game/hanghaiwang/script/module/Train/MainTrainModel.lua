-- FileName: MainTrainModel.lua
-- Author: yangna
-- Date: 2015-10-25
-- Purpose: 修炼系统数据
--[[TODO List]]

module("MainTrainModel", package.seeall)
require "db/DB_Affix"
require "db/DB_Train"
-- UI控件引用变量 --

-- 模块局部变量 --
local pageId = 0   -- (0~max-1)

--修炼增加的属性
local Hp = 0         --生命
local phyAtt = 0     --物攻
local phyDef = 0     --物防
local magAtt = 0     --魔攻
local magDef = 0     --魔防

local tbTrainData = nil


-- local tbTrainData = {   --当前修炼信息
-- 	train_id="0",         --当前修炼id
-- 	left_score="5000",		--当前副本剩余星数
-- }



local m_last_pageid = 0
local m_last_trainid = 0


local function init(...)

end

function destroy(...)
	package.loaded["MainTrainModel"] = nil
end

function moduleName()
    return "MainTrainModel"
end

function setTrainData(data )
	tbTrainData = data
end

function getTrainData( ... )
	return tbTrainData
end


function setLastTrainId( id )
	m_last_trainid = id
end

function setLastPageId( id )
	m_last_pageid = id
end

function getLastTrainId( ... )
	return m_last_trainid
end

function getLastPageId( ... )
	return m_last_pageid
end


-- 下次修炼id
function getNextTrainId( ... )
	local id = tonumber(tbTrainData.train_id) + 1
	return id
end

function setCurTrainId(id)
	tbTrainData.train_id = id
end

function getCurTrainId( ... )
	return tbTrainData.train_id
end


function getTotalPage( ... )
	local length = table.count(DB_Train.Train)
	return math.ceil(length/5)
end

function setPageId( id )
	id = id < 0 and 0 or id
	id = id > getTotalPage()-1 and getTotalPage()-1 or id	
	pageId = id
end

-- 恢复正常页数
function resetPageId( ... )
	pageId = math.ceil(MainTrainModel.getNextTrainId()/5) - 1
end 

function getPageId( ... )
	return pageId
end

function getLeftScore( ... )
	return tbTrainData.left_score
end

function addLeftScore( addStarNum )
	tbTrainData.left_score = tbTrainData.left_score + addStarNum
end

--根据affixID计算增加的属性
function getAffix(affixID)
	local data  = DB_Affix.getDataById(affixID)
	return  data
end


local function initBaseInfo( ... )
	Hp = 0         --生命
	phyAtt = 0     --物攻
	phyDef = 0     --物防
	magAtt = 0     --魔攻
	magDef = 0     --魔防
end

--到当前等级增加的属性和
function refreashBaseInfo( )
	initBaseInfo() --初始化属性值

	if (not tbTrainData) then
		return 
	end 

	local id = tonumber(tbTrainData.train_id)  
	while(id > 0) do 
		local tbData = DB_Train.getDataById(id)
		local attArr = string.split(tbData.attArr, ",") --取到属性值
		local tableLength = table.getn(attArr)
		for index=1, tonumber(tableLength) do 
			local attArrs = string.split(attArr[index], "|")
			setBaseInfoOfper(attArrs[1], attArrs[2])
		end 
		id = id - 1
	end 
end

--增加了什么值
function setBaseInfoOfper(affixID , value )
	if tonumber(affixID)  == 1  then
		Hp = Hp + value
	elseif tonumber(affixID) == 2  then
		phyAtt = phyAtt + value
	elseif tonumber(affixID) == 4  then
		phyDef = phyDef + value
	elseif tonumber(affixID) == 5  then
		magDef =  magDef + value
	elseif tonumber(affixID) == 3  then
		magAtt =  magAtt + value
	end
end


--生命
function getHp( ... )
	local name = MainTrainModel.getAffix(1)
	local res = 0

	if tonumber(name.type) == 2 then
		res = Hp / 100
	else
		res = Hp
	end
	return res
end

--物攻
function getPhyAttack( ... )
    local name = MainTrainModel.getAffix(2)
	local res  = 0

	if tonumber(name.type) == 2 then
		res = phyAtt / 100
	else
		res = phyAtt
	end
	return res  	
end        

--物防
function getPhyDefend( ... )
	local name = MainTrainModel.getAffix(4)
	local res = 0

	if tonumber(name.type) == 2 then
		res = phyDef / 100
	else
		res = phyDef
	end
	return res
end

--魔攻
function getMagAttack( ... )
	local name = MainTrainModel.getAffix(3)
	local res = 0

	if tonumber(name.type) == 2 then
		res = magAtt / 100
	else
		res = magAtt
	end
	return res
end

--魔防
function getMagDefend( ... )
	local name = MainTrainModel.getAffix(5)
	local res  = 0

	if tonumber(name.type) == 2 then
		res = tonumber(magDef) / 100
	else
		res = magDef
	end
	return res
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




function create(...)

end
