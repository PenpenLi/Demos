-- FileName: VipCardModel.lua
-- Author: LvNanchun
-- Date: 2015-07-01
-- Purpose: 月卡功能数据
--[[TODO List]]

module("VipCardModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _tbVipCardInfo = {}
local _nRedPoint
local _tbTime = {}
local _tbTimeStamp = {}
-- 存储一个网络信息的时间判断是否过时需要重拉信息
local _netInfoTime

local function init(...)

end

function destroy(...)
	package.loaded["VipCardModel"] = nil
end

function moduleName()
    return "VipCardModel"
end

function create(...)

end


--[[desc:从后端获取的购买情况
    arg1: 后端数据
    return: 无
—]]
function setVipCardPersonalInfo( personalInfo )
	logger:debug({personalInfo = personalInfo})

	if (table.isEmpty(personalInfo)) then
		_tbTimeStamp = personalInfo
	
		_tbTime.reward_time ,_tbTimeStamp.reward_time = TimeUtil.getServerDateTime(personalInfo.reward_time)
		_tbTime.due_time ,_tbTimeStamp.due_time = TimeUtil.getServerDateTime(personalInfo.due_time)
		_tbTime.buy_time ,_tbTimeStamp.buy_time = TimeUtil.getServerDateTime(personalInfo.buy_time)

		_tbTime.reward_time.year = _tbTime.reward_time.year - 1
		_tbTime.due_time.year = _tbTime.due_time.year - 1
		_tbTime.buy_time.year = _tbTime.buy_time.year - 1
		_tbTimeStamp.reward_time = _tbTimeStamp.reward_time - 24 * 60 * 60
		_tbTimeStamp.due_time = _tbTimeStamp.due_time - 24 * 60 * 60
		_tbTimeStamp.buy_time = _tbTimeStamp.buy_time - 24 * 60 * 60
	else
		_tbTimeStamp = personalInfo
	
		_tbTime.reward_time ,_tbTimeStamp.reward_time = TimeUtil.getServerDateTime(personalInfo.reward_time)
		_tbTime.due_time ,_tbTimeStamp.due_time = TimeUtil.getServerDateTime(personalInfo.due_time)
		_tbTime.buy_time ,_tbTimeStamp.buy_time = TimeUtil.getServerDateTime(personalInfo.buy_time)
	end

	-- 将此时的时间存起来作为数据的时间戳判断是否数据过时需要重拉
	_netInfoTime = TimeUtil.getServerDateTime()

	logger:debug({_tbTime = _tbTime})

end

--[[desc:手动改变上次购买的时间
    arg1: 无
    return: 无 
—]]
function changeLastBuyTime()
	local tbTimeNow = TimeUtil.getServerDateTime(_tbTimeStamp.reward_time + 24 * 60 * 60)

	_tbTime.reward_time = tbTimeNow
end

--[[desc:手动改变结束时间
    arg1: 暂无
    return: 无
—]]
function changeDueTime(  )
	local tbTimeDue = TimeUtil.getServerDateTime(_tbTimeStamp.due_time + 24 * 60 * 60 * 31)
	_tbTime.due_time = tbTimeDue
end

--[[desc:返回今天是否已经领过
    arg1: 无
    return: 返回是否领取的bool值，true表示没领取过
—]]
function bGetOrNotToday()
	if not (table.isEmpty(_tbTime)) then
		local nLastGetTime = _tbTime.reward_time.year * 10000 + _tbTime.reward_time.month * 100 + _tbTime.reward_time.day
		
		require "script/model/user/UserModel"
		local timeOffset = UserModel.getDayOffset()
		local tbNowTime = TimeUtil.getServerDateTime(TimeUtil.getSvrTimeByOffset(-timeOffset))
		local nNowTime = tbNowTime.year * 10000 + tbNowTime.month * 100 + tbNowTime.day
		local nDueTime = _tbTime.due_time.year * 10000 + _tbTime.due_time.month * 100 + _tbTime.due_time.day
		logger:debug({nLastGetTime = nLastGetTime})
		logger:debug({nNowTime = nNowTime})
		logger:debug({nDueTime = nDueTime})
		local answer = (nNowTime > nLastGetTime and nNowTime <= nDueTime)
		logger:debug(answer)
		return answer
	else
		return true
	end
end

--[[desc:返回是否购买过
    arg1: 无
    return: 返回bool值表示是否购买过,true表示买过
—]]
function bBuyOrNot()
	logger:debug({_tbTime = _tbTime})
	if (not table.isEmpty(_tbTime)) then
		local nLastGetTime = _tbTime.reward_time.year * 10000 + _tbTime.reward_time.month * 100 + _tbTime.reward_time.day
		require "script/model/user/UserModel"
		local timeOffset = UserModel.getDayOffset()
		local tbNowTime = TimeUtil.getServerDateTime(TimeUtil.getSvrTimeByOffset(-timeOffset))
		local nNowTime = tbNowTime.year * 10000 + tbNowTime.month * 100 + tbNowTime.day
		local nDueTime = _tbTime.due_time.year * 10000 + _tbTime.due_time.month * 100 + _tbTime.due_time.day
		return (nNowTime <= nDueTime)
	else
		return false
	end
end

--[[desc:返回当前是否可以购买
    arg1: 无
    return: bool,true表示可以购买
—]]
function bCanBuy()
	if (table.isEmpty(_tbVipCardInfo)) then
		setVipCardInfo()
	end

	if (_tbVipCardInfo[1].can_rebuy == 1) then
		return true
	else
		return not bBuyOrNot()
	end
end

--[[desc:取配置表信息
    arg1: 无
    return: 无
—]]
function setVipCardInfo()
	require "db/DB_Vip_card"
	if (table.isEmpty(_tbVipCardInfo)) then
		for k,v in pairs(DB_Vip_card.Vip_card) do 
			table.insert(_tbVipCardInfo , DB_Vip_card.getDataById(v[1]))
		end
		logger:debug({_tbVipCardInfo = _tbVipCardInfo})
	end
end

--[[desc:返回当前奖励的价格
    arg1: 无
    return: 奖励价格
—]]
function getPriceNumById( prizeId )
	for k,v in pairs(_tbVipCardInfo) do
		if (v.id == prizeId) then 
			return v.rmb
		end
	end
end

--[[desc:返回当前奖励的金币数
    arg1: 无
    return: 金币数
—]]
function getCoinNumById( prizeId )
	for k,v in pairs(_tbVipCardInfo) do
		if (v.id == prizeId) then 
			return v.gold
		end
	end
end

--[[desc:设置红点的数目
    arg1: 红点变化数
    return: 无  
—]]
function setRedPoint( redPointNum )
	setVipCardInfo()
	local nRed = 0
	if (bGetOrNotToday() and bBuyOrNot()) then
--		nRed = #_tbVipCardInfo
		nRed = 1
	end
	if (redPointNum) then
		if (redPointNum < 0) then
			redPointNum = 0
		end
	end
	
	_nRedPoint = redPointNum or nRed
end

--[[desc:返回是否显示红点
    arg1: 无
    return: 返回显示红点的个数
—]]
function getRedPoint()
	if not (_nRedPoint) then
		setRedPoint()
	end
	return _nRedPoint
end

--[[desc:根据id获取奖励的数组
    arg1: id
    return: 奖励数量
—]]
function getTbOfPrizeById( prizeId )
	local nPrizeNum = 0
	setVipCardInfo()

	for k,v in pairs(_tbVipCardInfo) do
		if (v.id == prizeId) then 
			return lua_string_split(v.cardReward , "|") 
		end
	end
end

--[[desc:根据id返回持续时间
    arg1: 奖励id
    return: 持续时间
—]]
function getContinueTimeById( prizeId )
	setVipCardInfo()
	for k,v in pairs(_tbVipCardInfo) do
		if (v.id == prizeId) then 
			return v.continueTime
		end
	end
end 

--[[desc:获取剩余天数
    arg1: 无
    return: 剩余的天数
—]]
function getRemainDays()
	-- 若模块中的信息是同一天的信息，则直接返回结果，否则减去这个天数
	return (_tbTime.due_time.year - _tbTime.reward_time.year) * 365 + _tbTime.due_time.yday - _tbTime.reward_time.yday or getContinueTimeById(1) - TimeUtil.getDifferDay(_netInfoTime)
end