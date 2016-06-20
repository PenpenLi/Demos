-- FileName: RechargeBonusModel.lua
-- Author: Xufei
-- Date: 2015-08-20
-- Purpose: 充值红利 数据
--[[TODO List]]

module("RechargeBonusModel", package.seeall)
require "script/model/utils/ActivityConfigUtil"

-- UI控件引用变量 --

-- 模块局部变量 --
local _i18n = gi18n
local _hasClick = 0
local _hasGetBackend = 0
local _tbRechargeBonusBackendInfo = {}
-- 初始化累积充值天数为0
_tbRechargeBonusBackendInfo.accumRechargeDate = "0"
local _tbRechargeBonusConfigData = {}



-- 更新累积充值的天数
function updateChargeDays( ... )
	if (hasGetBonusBackendInfo()) then
		if (not isTodayRecharged()) then
			addAccumRechargeDate()
		end
	else
		_tbRechargeBonusBackendInfo.accumRechargeDate = "1"
		setTodayRecharge()
	end
end

-- 返回是否拉取过后端数据
function hasGetBonusBackendInfo( ... )
	if (_hasGetBackend == 1) then
		return true
	elseif (_hasGetBackend == 0) then
		return false
	end
end

-- 获得是否有未购买而能购买的
function isHaveCanBuy( ... )
	if (isActivityInTime()) then
		local listData = getDataForView()
		for k,v in ipairs(listData) do
			if (v.status == 1) then
				return true
			end
		end
	end
	return false
end

-- 获得未购买而能购买的个数
function getNumCanBuy( ... )
	local count = 0
	if (isActivityInTime()) then
		local listData = getDataForView()
		for k,v in ipairs(listData) do
			if (v.status == 1) then
				count = count +1
			end
		end
	end
	return count
end

-- 获取是否购买完所有档次的物品
function isAllHaveBought( ... )
	if (hasGetBonusBackendInfo()) then
		for k,v in pairs(_tbRechargeBonusBackendInfo.status) do
			if (tostring(v) == "0") then
				return false
			end
		end
		return true
	else
		return false
	end
end

-- 记录登录后是否点击过充值红利图标
function setHasClick( ... )
	_hasClick = 1
end

-- 红点字数 给内部图标判断
function numRedPoint( ... )
	if (tonumber(getNewAniState()) ~= 1) then
		return 0
	elseif (isActivityInTime() and hasGetBonusBackendInfo() and isHaveCanBuy()) then
		return getNumCanBuy()
	else
		return 0
	end
end

-- 是否需要显示红点 给外部图标无字红点判断
function needShowRedPoint( ... )
	if (not isActivityInTime()) then
		return false
	elseif (numRedPoint()>0 or (tonumber(getNewAniState()) ~= 1)) then
		return true
	else
		return false
	end
end

-- 获得累积充值的天数
function getAccumRechargeDate()
	return tonumber(_tbRechargeBonusBackendInfo.accumRechargeDate)
end

-- 设置后端传递来的信息
function setBackendInfo( info )
	_tbRechargeBonusBackendInfo = info
	_hasGetBackend = 1
	-- 判断并保存充值前，今天是否充值过
	setIfTodayRecharge()
	logger:debug({ recahrgeBonusBackendInfo = _tbRechargeBonusBackendInfo })
end

-- 得到活动起始时间
function getActivityStartTime( ... )
	local activityConfigData = ActivityConfigUtil.getDataByKey("chargeWeal")
	return activityConfigData.start_time
end

-- 增加1天的累积充值天数，并将今天设置为充值过
function addAccumRechargeDate( ... )
	_tbRechargeBonusBackendInfo.accumRechargeDate = tostring(getAccumRechargeDate()+1)
	setTodayRecharge()
end

-- 将今天设置为充值过
function setTodayRecharge( ... )
	_tbRechargeBonusBackendInfo.isTodayCharge = "true"
end

-- 返回今天是否充值过
function isTodayRecharged( ... )
	if (_tbRechargeBonusBackendInfo.isTodayCharge == "true") then
		return true
	elseif (_tbRechargeBonusBackendInfo.isTodayCharge == "false") then
		return false
	end
end


-- 判断今日是否充值过,在活动拉取后端的时候判断并保存在后端数据中
function setIfTodayRecharge( ... )
	-- require "script/module/IAP/IAPData"
	-- local chargeData = IAPData.getIAPInfo()
	-- logger:debug({chargeDataRecharge = chargeData})

	-- local recentChargeDate = 0
	-- for k,v in pairs(chargeData) do
	-- 	if (tonumber(v)>recentChargeDate) then
	-- 		recentChargeDate = tonumber(v)
	-- 	end
	-- end
	-- logger:debug({recentchargeDataRecharge = recentChargeDate})
	-- require "script/utils/TimeUtil"
	-- local differDays = TimeUtil.getDifferDay(recentChargeDate)
	-- logger:debug({differDays = differDays})
	-- if (differDays == 0) then
	-- 	_tbRechargeBonusBackendInfo.isTodayCharge = "true"
	-- else
	-- 	_tbRechargeBonusBackendInfo.isTodayCharge = "false"
	-- end
end

-- 得到活动到今天持续了几天，包括今天在内
function getActivityContinueDays( ... )
	local activityStartTime = getActivityStartTime()
	local continueDays = TimeUtil.getDifferDay(activityStartTime)

	logger:debug({continueDaysBefore = continueDays})
	return continueDays+1
end

-- 判断活动是否开启
function isActivityInTime( ... )

	logger:debug({awef = ActivityConfigUtil.isActivityOpen( "chargeWeal" )})
	return ActivityConfigUtil.isActivityOpen( "chargeWeal" ) -- 是否开启
end

-- 得到活动结束时间
function getActivityEndTime( ... )
	local activityConfigData = ActivityConfigUtil.getDataByKey("chargeWeal")
	return activityConfigData.end_time
end

-- 得到倒计时的字符串
function getCountDownTime( ... )
	local endTime = getActivityEndTime()
	local startTime = getActivityStartTime()

	local strTime = NewTimeUtil.getTimeFormatYMDHMdot(startTime) .. " — " .. NewTimeUtil.getTimeFormatYMDHMdot(endTime)
	return strTime
end

-- 设置配置表数据
function setConfigData( ... )
	_tbRechargeBonusConfigData = {}

	local activityConfigData = ActivityConfigUtil.getDataByKey("chargeWeal")
	--logger:debug({activityConfigRechargeBonus = activityConfigData})
	--logger:debug({activityConfigDataRechargeBonus = activityConfigData.data})

	for k,v in pairs(activityConfigData.data) do 
		local tb = {}
		tb.id = v.id
		tb.array = v.array
		tb.originalCost = v.original_cost
		tb.discontPrice = v.discount_price
		tb.rechargeDay = tonumber(v.recharge_day)
		tb.status = 0
		tb.type = v.array_type
		table.insert(_tbRechargeBonusConfigData, tb)
	end
	--logger:debug({ rechargeBonusConfigData = _tbRechargeBonusConfigData })
	table.sort(_tbRechargeBonusConfigData, function (a,b)
		return a.id < b.id
	end)

	logger:debug({ rechargeBonusConfigData = _tbRechargeBonusConfigData })
end

-- 将新购买的记录增加进保存的后端数据中
function updateBackendData( index )
	_tbRechargeBonusBackendInfo.status[tostring(index)] = "1"
end

-- 获得显示listView的数据
function getDataForView( )
	local tbRewardListData = {}
	if ( hasGetBonusBackendInfo() ) then
		setConfigData()
		tbRewardListData = _tbRechargeBonusConfigData
		for k,v in pairs(tbRewardListData) do
			if (tonumber(_tbRechargeBonusBackendInfo.accumRechargeDate) >= tonumber(v.rechargeDay)) then
				v.status = 1
			end
		end
		for k,v in pairs (_tbRechargeBonusBackendInfo.status) do
			if (tonumber(v) == 1) then
				tbRewardListData[tonumber(k)].status = 2
			end
		end
		
	--	logger:debug({ tbRewardListData = tbRewardListData })
	else
		setConfigData()
		tbRewardListData = _tbRechargeBonusConfigData
		for k,v in pairs(tbRewardListData) do
			if (tonumber(_tbRechargeBonusBackendInfo.accumRechargeDate) >= tonumber(v.rechargeDay)) then
				v.status = 1
			end
		end
	end
	return tbRewardListData
end

 -- 在手机中存储是否曾经访问过这个按钮
function setNewAniState( nState )
	g_UserDefault:setIntegerForKey("recharge_bones_visible"..UserModel.getUserUid()..getActivityStartTime()..getActivityEndTime(), nState)
end

-- 获取是否访问过这个按钮的状态
function getNewAniState()
	return g_UserDefault:getIntegerForKey("recharge_bones_visible"..UserModel.getUserUid()..getActivityStartTime()..getActivityEndTime())
end

function setCell( cell )
	_selfCell = cell
end

function getCell( ... )
	return _selfCell
end

-------------------------------------------------

local function init(...)
	_tbRechargeBonusBackendInfo = nil
	_tbRechargeBonusConfigData = nil
end

function destroy(...)
	_tbRechargeBonusBackendInfo = nil
	_tbRechargeBonusConfigData = nil
	package.loaded["RechargeBonusModel"] = nil
end

function moduleName()
    return "RechargeBonusModel"
end

function create(...)
	init()
end
