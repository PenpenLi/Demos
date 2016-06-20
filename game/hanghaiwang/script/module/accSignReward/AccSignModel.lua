-- FileName: AccSignModel.lua
-- Author: zhangjunwu
-- Date: 2014-11-25
-- Purpose: 开服礼包 数据模块
--[[TODO List]]

module("AccSignModel", package.seeall)
require "db/DB_Accumulate_sign"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_tbAccInfo 		= nil 
local m_tbDataSource 	= nil

local function init(...)

end

function destroy(...)
	package.loaded["AccSignModel"] = nil
end

function moduleName()
    return "AccSignModel"
end

function create(...)

end
function setAccSignInfo( tbAccInfo )
	logger:debug("开服礼包后端返回的数据是:")
	logger:debug(tbAccInfo)
	logger:debug(tbAccInfo)
	m_tbAccInfo = tbAccInfo
end



function getAccGotTimes( ... )
	return m_tbAccInfo.acc_got
end

--更新已领取奖励的数据
function updateAccGotData( index )
	table.insert(m_tbAccInfo.acc_got,index)
end


function getSignTimes( ... )
	return m_tbAccInfo.sign_num
end

-- 获取所有开服礼包奖励的信息
function getAllAccRewardData()
	-- local tbData = {}
	local tbAccRewardData = {}
	for k,v in pairs(DB_Accumulate_sign.Accumulate_sign) do
		table.insert(tbAccRewardData, DB_Accumulate_sign.getDataById(v[1]))
	end

	-- local tbAccRewardData = {}
	-- for k,v in pairs(tbData) do
	-- 	table.insert(tbAccRewardData, DB_Accumulate_sign.getDataById(v[1]))
	-- end

	local function keySort ( rewardData_1, rewardData_2 )
		return tonumber(rewardData_1.id ) < tonumber(rewardData_2.id)
	end
	table.sort( tbAccRewardData, keySort)

	m_tbDataSource = {}
	index = nil
	for k,v in pairs(tbAccRewardData) do
		local tbData = {}
		tbData.rid = v.id
		tbData.add_up_days = v.add_up_days

		local nCountReward = 0
		nCountReward = tonumber(v.reward_num)

		tbData.item = {}
		for i=1,nCountReward do
			if v["reward_type" .. i] then
				local tb = {}
				tb.icon = { reward_type = v["reward_type" .. i], reward_values = v["reward_value" .. i]}
				tb.name = v["reward_desc" .. i]
				tb.quality = v["reward_quality" .. i]

				table.insert(tbData.item, tb)
			end
		end
		table.insert(m_tbDataSource, tbData)
	end

	logger:debug(m_tbDataSource)
	return m_tbDataSource
end


--[[desc:得到listview 应该停留再哪个cell上
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getCurrentIndex( ... )
	local loginTims 	= m_tbAccInfo.sign_num
	local tbReceived 	= m_tbAccInfo.acc_got

	local tbUnGotId = {}
	for i,v in ipairs(m_tbDataSource) do
		local add_up_days = v.add_up_days

		local bReceived = false
		for k, _v in pairs(tbReceived) do

			if(tonumber(add_up_days) == tonumber(_v)) then
				bReceived = true
				break 
			end
		end

		if(bReceived == false) then
			table.insert(tbUnGotId,v)
		end

	end

	logger:debug(tbUnGotId)
	local function keySort ( rewardData_1, rewardData_2 )
		return tonumber(rewardData_1.rid ) < tonumber(rewardData_2.rid)
	end
	table.sort( tbUnGotId, keySort)

	logger:debug(tbUnGotId)
	logger:debug(tbUnGotId[1])
	
	if tbUnGotId[1] == nil then
		return 1
	end

	return tbUnGotId[1].add_up_days

end

--可以领取的奖励个数，用来显示小红点
function getCanGotRewardNum()
	local loginTims 	= tonumber(m_tbAccInfo.sign_num)
	local tbReceived 	= (m_tbAccInfo.acc_got)
	local nTotleDay     = table.count(m_tbDataSource) --表里配了多少天的礼包
	loginTims = loginTims > nTotleDay and nTotleDay or loginTims
	local num = tonumber(loginTims) - table.count(tbReceived)
	return num
end

--判断开服礼包的图片是否需要显示
function accIconNeedShow( ... )
	if(table.isEmpty(m_tbDataSource)) then
		getAllAccRewardData()
	end

	local loginTims 	= m_tbAccInfo.sign_num  	 --已经登录的天数
	local tbReceived 	= m_tbAccInfo.acc_got
	local nTotleDay     = table.count(m_tbDataSource) --表里配了多少天的礼包

	logger:debug("已经领取奖励的次数为:" .. table.count(tbReceived))
	logger:debug("已经登录的天数:" .. loginTims)
	logger:debug("表里配了多少天的礼包:" .. nTotleDay)
	if(table.count(tbReceived) >= nTotleDay ) then

		return false
	else
		return true
	end

end

