-- FileName: SpendAccumulateModel.lua
-- Author: Xufei
-- Date: 2015-06-25
-- Purpose: 消费累积 数据模块
--[[TODO List]]

module("SpendAccumulateModel", package.seeall)
require "script/model/utils/ActivityConfigUtil"

-- UI控件引用变量 --

-- 模块局部变量 --
local _tbSpendAccInfo = {}	--后端的数据table
local _tbSpendAccData = {}	--配置表数据table
local _haveEntered = 0 --用于判断是否进入过活动界面
local _haveGetBackEnd = 0 --用于判断是否已经拉取过后端

local _selfCell = nil

--记录是否点击过消费累计图标
function setHaveEntered()
	logger:debug("_haveEntered true")
	_haveEntered = 1
end

--返回后端数据表
function getTbSpendAccInfo()
	return _tbSpendAccInfo
end

--判断后端返回的已领取表是否为空
function isSpendInfoSentRewardNil()
	if (_tbSpendAccInfo.sentReward) then
		return false
	else
		return true
	end
end

--desc:将_tbSpendAccInfo设置为后端数据 
function setSpendAccInfo( tbSpendAccInfoFromBackEnd )
	_tbSpendAccInfo = tbSpendAccInfoFromBackEnd
	_haveGetBackEnd = 1	
	--GlobalNotify.addObserver("SpendAccumulateGoldSpend", setExpenseGolds, nil, "spendGold") --通知改为加在preRequest里，为了防止在游戏中活动突然开启，并开始消费的情况
end

--[[desc:获取活动时间，用以显示在view里
    arg1: 参数说明
    return: “时间戳-时间戳”
—]]
function getActivityTime()
	local SpendAccData = ActivityConfigUtil.getDataByKey("spend")
	local SpendTimeStart = SpendAccData.start_time
	local SpendTimeEnd = SpendAccData.end_time
	local SpendTime = SpendTimeStart .. '-' .. SpendTimeEnd
	logger:debug({SpendTimeIs = SpendTime})
	return SpendTime
end

--[[desc:更新_tbSpendAccInfo后端数据，添加进来新领取的奖励
    arg1: 新领取的奖励的id
—]]
function updateSpendAccInfo( index )
	if (_tbSpendAccInfo.sentReward == "false") then
		_tbSpendAccInfo.sentReward = {}
	end
	table.insert(_tbSpendAccInfo.sentReward, tostring(index))
	logger:debug({update_tbSpendAccInfo = _tbSpendAccInfo})
end

--desc:将_tbSpendAccData设置为配置表数据，配置表由ActivityConfigUtil获得
function setSpendAccData()
	_tbSpendAccData = {}
	local SpendAccData = ActivityConfigUtil.getDataByKey("spend")
	logger:debug({spendaccdataActivityconfig = SpendAccData})
	for k,v in ipairs(SpendAccData.data) do
		local tb = {}
		tb[1] = tonumber(v.id)
		tb[3] = tonumber(v.expenseGold)
		tb[4] = v.reward
		table.insert(_tbSpendAccData,tonumber(v.id),tb)
	end
	logger:debug({_tbSpendAccData_setSpendAccData = _tbSpendAccData})
end

--得到花费的金币数
function getExpenseGolds()
	return _tbSpendAccInfo.expenseGold
end

--[[desc:更新花费的金币数
    arg1: 由全局通知获得的消费数，为负数则是消费
—]]
function setExpenseGolds( value )
	if (_tbSpendAccInfo.expenseGold == nil) then
		_tbSpendAccInfo.expenseGold = 0
	end
	if (isInTime()) then
		if (type(value) == "string") then
			value = tonumber(value)
		end
		if (value < 0) then
			_tbSpendAccInfo.expenseGold = _tbSpendAccInfo.expenseGold - value
			updateRedPointInActivity()
			GlobalNotify.postNotify("SpendAccRefreshViewInView")
		end
	end
end

--[[desc:获得一行的所有宝物信息
    arg1: 行数
    return: 宝物信息  
—]]
function getRewardDataByTag( tag )
	local tbReward = {}
	local curData = _tbSpendAccData[tag][4]
	tbReward = lua_string_split(curData, ',')
	for k,v in pairs(tbReward) do
		tbReward[k] = {}
		tbReward[k].type =  lua_string_split(v, '|')[1]
		tbReward[k].id =  lua_string_split(v, '|')[2]
		tbReward[k].quantity =  lua_string_split(v, '|')[3]
	end
	logger:debug({tbReward  =  tbReward})
	return tbReward
end

--[[desc:得到用于ListView创建的数据
    return: tbListViewData ,注：status=0未领取,status=1已领取
—]]
function getSpendListViewData()
	local tbListViewData = {}
	for k,v in pairs(_tbSpendAccData) do
		tbListViewData[k] = {}
		tbListViewData[k].des = nil
		tbListViewData[k].gold = v[3]
		tbListViewData[k].reward = RewardUtil.parseRewards(v[4])
		tbListViewData[k].status = 0
	end
	if (_tbSpendAccInfo.sentReward ~= "false") then
		for k,v in pairs(_tbSpendAccInfo.sentReward) do
			tbListViewData[tonumber(v)].status = 1
		end
	end
	logger:debug({tbListViewData = tbListViewData})
	return tbListViewData
end

--desc:返回奖励列表长度，得到一共有多少奖励
function getRewardNum()
	return #_tbSpendAccData
end

--[[desc:返回是否没有全部领完奖励
    return: 没领完：true，领完：false  
—]]
function notAllHaveGet()
	return #_tbSpendAccInfo.sentReward ~= #_tbSpendAccData
end

--desc:返回可以领取的奖励table
function getCanReceiveTb()
	local tbCanReceive = {}
	local tbRewardData = getSpendListViewData()
	local numSpend = tonumber(getExpenseGolds())
	for k,v in pairs(tbRewardData) do
		if (v.status == 0 and (numSpend >= v.gold)) then
			table.insert(tbCanReceive,k)
		end
	end
	logger:debug({tbCanReceive = tbCanReceive})
	return tbCanReceive
end

--desc:返回第一个可以领取的奖励的id，如果没有则返回0，用以自动跳到第一个可领取的行
function getScrollLine()
	local tbCanReceive = getCanReceiveTb()
	logger:debug({tbCanReceiveasdf = #tbCanReceive})
	if (table.isEmpty(tbCanReceive)) then
		return 0
	else
		return tbCanReceive[1] - 1
	end
end

--desc:返回是否在活动时间内
function isInTime()
	return ActivityConfigUtil.isActivityOpen("spend")
end

--desc:在登录前活动没开启，登录后才开启的情况下，一定没有领取过奖励，此时只通过消费数来计算能拿哪些奖励
function getCanReceiveNumOnlyByGold()
	local goldSpended = getExpenseGolds()
	local numCanReceive = 0
	if (table.isEmpty(_tbSpendAccData)) then
		setSpendAccData()
	end
	for k,v in pairs(_tbSpendAccData) do
		if (tonumber(goldSpended) >= v[3]) then
			numCanReceive = numCanReceive + 1
		end
	end
	return numCanReceive
end

--desc:返回可以领取的奖励数，即红点数
function getCanReceiveNum()
	local goldSpended = getExpenseGolds()
	local numCanReceive = 0
	for k,v in pairs(_tbSpendAccData) do
		if (tonumber(goldSpended) >= v[3]) then
			numCanReceive = numCanReceive + 1
		end
	end
	if (not table.isEmpty(_tbSpendAccInfo)) then
		if (_tbSpendAccInfo.sentReward ~= "false" and _tbSpendAccInfo.sentReward) then
			numCanReceive = numCanReceive - #_tbSpendAccInfo.sentReward
		end
	else
		return 0
	end
	logger:debug({numCanReceive = numCanReceive})
	return numCanReceive
end

--desc:返回可以领取的奖励数前先读取配置数据，在进入活动时调用
function getCanReceiveNumInWonderfulAct()
	if (table.isEmpty(_tbSpendAccData)) then
		setSpendAccData()
	end
	local num = getCanReceiveNum()
	return num
end

--判断主页活动图标上是否显示红点
function needShowRedPointOnActivity()
	if (_haveGetBackEnd == 1) then
		if(getCanReceiveNumInWonderfulAct() == 0) then
			if (notAllHaveGet()) then
				return ( isInTime() and (_haveEntered == 0) )
			else
				return false
			end
		else
			return isInTime()
		end
	else
		return ( isInTime() and (_haveEntered == 0) )
	end
end

--判断消费累计图标上是否需要显示红点
function needShowRedPoint()
	if isInTime() then
		if (not table.isEmpty(_tbSpendAccInfo)) then
			if (getCanReceiveNumInWonderfulAct() ~= 0) then
				return true
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

--desc:用于在购买贝里等活动时，更新消费累积红点
function updateRedPointInActivity()
	require "script/module/main/LayerManager"
	if (LayerManager.curModuleName() == "MainWonderfulActCtrl") then
		if (getCanReceiveNum() > 0) then
			WonderfulActModel.tbBtnActList.spendAccumulate:setVisible(true)
			WonderfulActModel.tbBtnActList.spendAccumulate.IMG_TIP:setEnabled(true)
			local numberLab = WonderfulActModel.tbBtnActList.spendAccumulate.LABN_TIP_EAT
			numberLab:setStringValue(getCanReceiveNum())
		end
	end
end

-- 在手机中存储是否曾经访问过这个按钮
function setNewAniState( nState )
	g_UserDefault:setIntegerForKey("new_spendAcc_visible"..UserModel.getUserUid()..getActivityTime(), nState)
end

-- 获取是否访问过这个按钮的状态
function getNewAniState()
	return g_UserDefault:getIntegerForKey("new_spendAcc_visible"..UserModel.getUserUid()..getActivityTime())
end

function setCell( cell )
	_selfCell = cell
end

function getCell( ... )
	return _selfCell
end


------------------- 创建方法 -----------------------
local function init()

end

function destroy()
	package.loaded["SpendAccumulateModel"] = nil
end

function moduleName()
    return "SpendAccumulateModel"
end

function create()

end
