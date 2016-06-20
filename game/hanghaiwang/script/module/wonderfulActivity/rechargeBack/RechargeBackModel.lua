-- FileName: RechargeBackModel.lua
-- Author: Xufei
-- Date: 2015-07-01
-- Purpose: 充值回馈 数据模块
--[[TODO List]]

module("RechargeBackModel", package.seeall)
require "script/model/utils/ActivityConfigUtil"

-- UI控件引用变量 --

-- 模块局部变量 --
local _tbRechargeBackInfo = {}	--后端的数据table
local _tbRechargeBackData = {}	--配置表数据table
local _haveEntered = 0 --用于判断是否进入过活动界面
local _haveGetBackEnd = 0 --用于判断是否已经拉取过后端

local _selfCell = nil

--记录是否点击过充值回馈按钮
function setHaveEntered()
	_haveEntered = 1
end

--返回保存的后端
function getTbRechargeBackInfo()
	return _tbRechargeBackInfo
end

--判断是否获取到后端返回的sentReward
function isRechargeBackinfoSentRewardNil()
	if (_tbRechargeBackInfo.sentReward) then
		return false
	else
		return true
	end
end

--desc:将_tbRechargeBackInfo设置为后端数据
function setRechargeBackInfo( tbRechargeBackInfoFromBackEnd )
	_tbRechargeBackInfo = tbRechargeBackInfoFromBackEnd
	_haveGetBackEnd = 1
	--这里要改成充值后发送通知，调用setRechargeGolds函数，更新充值的金币数
	--另外也可以在充值功能做好后，在充值那里调用setRechargeGold接口
	--GlobalNotify.addObserver("RechargeBackGoldRecharge", setRechargeGolds, nil, "recahrgeGold")
	logger:debug({_tbRechargeBackInfo = _tbRechargeBackInfo})
end

--[[desc:获取活动时间用于在view里显示
    arg1: 参数说明
    return: “时间戳-时间戳”
—]]
function getActivityTime()
	local RechargeBackData = ActivityConfigUtil.getDataByKey("topupFund")
	local SpendTimeStart = RechargeBackData.start_time
	local SpendTimeEnd = RechargeBackData.end_time
	local SpendTime = SpendTimeStart .. '-' .. SpendTimeEnd
	logger:debug({SpendTimeIs = SpendTime})
	return SpendTime
end

--[[desc:更新_tbRechargeBackInfo后端数据，添加进来新领取的奖励
    arg1: 新领取的奖励的序号
    return: 是否有返回值，返回值说明  
—]]
function updateRechargeBackInfo( index )
	if (_tbRechargeBackInfo.sentReward == "false") then
		_tbRechargeBackInfo.sentReward = {}
	end
	table.insert(_tbRechargeBackInfo.sentReward, tostring(index))
end

--desc:将_tbRechargeBackData设置为配置表数据
function setRechargeBackData()
	_tbRechargeBackData = {}
	local RechargeBackData = ActivityConfigUtil.getDataByKey("topupFund")
	logger:debug({rechargebackDatafromactivityconfig = RechargeBackData})
	for k,v in ipairs(RechargeBackData.data) do
		local tb = {}
		tb.id = tonumber(v.id)
		tb.expenseGold = tonumber(v.expenseGold)
		tb.reward = v.reward
		tb.type = v.array_type
		table.insert(_tbRechargeBackData,tonumber(v.id),tb)
	end
	logger:debug({_tbRechargeBackDataIs = _tbRechargeBackData})
end

--desc:得到目前的充值的金币数
function getRechargeGolds()
	return _tbRechargeBackInfo.gold_accum
end

--[[desc:更新充值的金币数，用接受通知的方式，或者直接在充值功能里被调用
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function setRechargeGolds( value )
	if (isInTime()) then
		if (_tbRechargeBackInfo.gold_accum == nil) then
			_tbRechargeBackInfo.gold_accum = 0
		end
		if (type(value) == "string") then
			value = tonumber(value)
		end
		logger:debug({valueIsIsIS = value})
		logger:debug({gold_accumIsIsIS = _tbRechargeBackInfo.gold_accum})
		if (value > 0) then
			_tbRechargeBackInfo.gold_accum = _tbRechargeBackInfo.gold_accum + value
			updateRedPointInActivity()
		end
		logger:debug({gold_accumIsIsIS2 = _tbRechargeBackInfo.gold_accum})
	end
end

--[[desc:获得一行的所有宝物信息 可以改成用rewardUtil里的方法
    arg1: 行数
    return: 宝物信息  
—]]
function getRewardDataByTag( tag )
	local tbReward = {}
	local curData = _tbRechargeBackData[tag].reward
	return curData
end

--[[desc:得到用于ListView创建的数据
    arg1: 无
    return: tbListViewData ,注：status=0未领取,status=1已领取
—]]
function getListViewData()
	local tbListViewData = {}
	for k,v in pairs(_tbRechargeBackData) do
		tbListViewData[k] = {}
		tbListViewData[k].type = v.type
		tbListViewData[k].rewardStr = v.reward
		tbListViewData[k].des = nil
		tbListViewData[k].gold = v.expenseGold
		tbListViewData[k].reward = RewardUtil.parseRewards(v.reward)
		tbListViewData[k].status = 0
	end
	if (_tbRechargeBackInfo.sentReward ~= "false") then
		for k,v in pairs(_tbRechargeBackInfo.sentReward) do
			tbListViewData[tonumber(v)].status = 1
		end
	end
	logger:debug({tbListViewData = tbListViewData})
	return tbListViewData
end

--desc:返回奖励列表长度
function getRewardNum()
	return #_tbRechargeBackData
end

--[[desc:返回是否没有全部领完奖励
    return: 没领完：true，领完：false  
—]]
function notAllHaveGet()
	return #_tbRechargeBackInfo.sentReward ~= #_tbRechargeBackData
end

--desc:返回可以领取的奖励table
function getCanReceiveTb()
	local tbCanReceive = {}
	local tbRewardData = getListViewData()
	local numSpend = tonumber(getRechargeGolds())
	for k,v in pairs(tbRewardData) do
		if (v.status == 0 and (numSpend >= v.gold)) then
			table.insert(tbCanReceive,k)
		end
	end
	logger:debug({tbCanReceive = tbCanReceive})
	return tbCanReceive
end

--desc:返回第一个可以领取的奖励的id，如果没有则返回0
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
	return ActivityConfigUtil.isActivityOpen("topupFund")
end

--desc:返回可领取的奖励数，在登录前活动没开启，登录后才开启的情况下，一定没有领取过奖励，此时只通过充值金币数来计算
function getCanReceiveNumOnlyByGold( ... )
	local goldSpended = getRechargeGolds()
	local numCanReceive = 0
	if (table.isEmpty(_tbRechargeBackData)) then
		setRechargeBackData()
	end
	for k,v in pairs(_tbRechargeBackData) do
		if (tonumber(goldSpended) >= v.expenseGold) then
			numCanReceive = numCanReceive + 1
		end
	end
	return numCanReceive
end

--desc:返回可以领取的奖励数，即红点数，给RechargeBackView使用
function getCanReceiveNum()
	local goldSpended = getRechargeGolds()
	local numCanReceive = 0
	for k,v in pairs(_tbRechargeBackData) do
		if (tonumber(goldSpended) >= v.expenseGold) then
			numCanReceive = numCanReceive + 1
		end
	end
	if (not table.isEmpty(_tbRechargeBackInfo)) then
		if (_tbRechargeBackInfo.sentReward ~= "false" and _tbRechargeBackInfo.sentReward) then
			numCanReceive = numCanReceive - #_tbRechargeBackInfo.sentReward
		end
	else
		return 0
	end
	logger:debug({numCanReceive = numCanReceive})
	return numCanReceive
end

--desc:返回可以领取的奖励数前先读取配置数据，在进入活动时调用
function getCanReceiveNumInWonderfulAct()
	if (table.isEmpty(_tbRechargeBackData)) then
		setRechargeBackData()
	end
	local num = getCanReceiveNum()
	return num
end

--主页活动图标上是否显示红点
function needShowRedPointOnActivity()
	if (_haveGetBackEnd == 1) then
		if (getCanReceiveNumInWonderfulAct() == 0) then
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

--desc:充值回馈图标上是否需要显示红点
function needShowRedPoint()
	logger:debug("judge need show red point")
	if isInTime() then
		if(not table.isEmpty(_tbRechargeBackInfo)) then
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
	return (getCanReceiveNumInWonderfulAct() ~= 0) and (isInTime())
end

--在充值后更新显示红点
function updateRedPointInActivity()
	require "script/module/main/LayerManager"
	if (LayerManager.curModuleName() == "MainWonderfulActCtrl") then
		if (getCanReceiveNum() > 0) then
			WonderfulActModel.tbBtnActList.rechargeBack:setVisible(true)
			WonderfulActModel.tbBtnActList.rechargeBack.IMG_TIP:setEnabled(true)
			local numberLab = WonderfulActModel.tbBtnActList.rechargeBack.LABN_TIP_EAT
			numberLab:setStringValue(getCanReceiveNum())
		end
	end
end

 -- 在手机中存储是否曾经访问过这个按钮
function setNewAniState( nState )
	g_UserDefault:setIntegerForKey("new_rechargeBack_visible"..UserModel.getUserUid()..getActivityTime(), nState)
end

-- 获取是否访问过这个按钮的状态
function getNewAniState()
	return g_UserDefault:getIntegerForKey("new_rechargeBack_visible"..UserModel.getUserUid()..getActivityTime())
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
	package.loaded["RechargeBackModel"] = nil
end

function moduleName()
    return "RechargeBackModel"
end

function create()

end