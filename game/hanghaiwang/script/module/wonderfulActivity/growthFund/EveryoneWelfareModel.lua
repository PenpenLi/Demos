-- FileName: EveryoneWelfareModel.lua
-- Author: Xufei
-- Date: 2015-08-10
-- Purpose: 全民福利 数据模块
--[[TODO List]]

module("EveryoneWelfareModel", package.seeall)
require "db/DB_Growth_fund"

-- UI控件引用变量 --

-- 模块局部变量 --
local _tbEveryoneWelfareBackendInfo = {}
local _tbEveryoneWelfareConfigData = {}


-- 重新拉取后端的购买人数，用来在全民界面购买后刷新人数
function refreshBoughtNum( tbPara )
	function everyoneWelfareCallback( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug("Got EveryoneWelfare Data! for bought people number")
			setBackendInfo(dictData.ret)
			
			if (tbPara.layTab) then
				tbPara.layTab.IMG_ALL_PEOPLE:setVisible(getNumStillCanReceive()>0)
			end
			local numOfRed = GrowthFundModel.getUnprizedNumByLevel() + EveryoneWelfareModel.getNumStillCanReceive()
			logger:debug({refreshhongdianafterbought = numOfRed})
			local mainActivity = WonderfulActModel.tbBtnActList.growthfund
			mainActivity:setVisible(true)
			mainActivity.LABN_TIP_EAT:setStringValue(numOfRed)

			if ((numOfRed) == 0) then
				mainActivity.IMG_TIP:setVisible(false)
			end
			if (tbPara.layWelfare) then
				GrowthFundCtrl.refreshWelfareView()
			end
		end
	end
	RequestCenter.growUp_getInfo(everyoneWelfareCallback)
end

-- 返回领取了的奖励数
function getNumHaveReceived()
	return table.count(_tbEveryoneWelfareBackendInfo.received)
end

-- 返回总共的奖励数
function getSumRewardNum()
	setConfigData()
	local tbReward = lua_string_split( _tbEveryoneWelfareConfigData[6], "," )
	return table.count(tbReward)
end

-- 返回可以领取的奖励数(包括已经领过的)
function getNumAllCanReceive()
	setConfigData()
	local numAllCanReceive = 0
	local tbReward = lua_string_split( _tbEveryoneWelfareConfigData[6], "," )
	for k,v in ipairs(tbReward) do
		local tbString = lua_string_split( v, "|" )
		if (tonumber(_tbEveryoneWelfareBackendInfo.num) >= tonumber(tbString[1])) then
			numAllCanReceive = numAllCanReceive + 1
		end
	end
	return numAllCanReceive
end

-- 返回还可以领取的奖励数(不包括已经领过的)
function getNumStillCanReceive()
	if (getNumAllCanReceive() > getNumHaveReceived()) then
		return getNumAllCanReceive() - getNumHaveReceived()
	else
		return 0
	end
end

-- 返回是否已经领完全部奖励
function isAllHaveGot()
	return (getSumRewardNum() == getNumHaveReceived())
end

-- 返回第一个未领取但能领取的奖励序号,没有则返回0
function getNumOfFirstStillCanReceive()
	for i = 0, getNumAllCanReceive() - 1 do
		if ( not table.include(_tbEveryoneWelfareBackendInfo.received, tostring(i)) ) then
			return i
		end
	end
	return 0
end

-- 在领取奖励后更新数据
function updateInfo( rewardIndex )
	logger:debug({asdaweilovamndoivganrwdeofgjaowuhg = rewardIndex})
	table.insert(_tbEveryoneWelfareBackendInfo.received, tostring(rewardIndex))
end

-- 返回是否拉取过后端
function isGotBackEnd()
	if (table.isEmpty(_tbEveryoneWelfareBackendInfo)) then
		return false
	else
		return true
	end
end

-- 设置后端传来的数据Info
function setBackendInfo( backendInfo )
	if ( not table.isEmpty(backendInfo.welfare) ) then
		_tbEveryoneWelfareBackendInfo = backendInfo.welfare
	end

	logger:debug({BackendInfoOfEveryoneWelfare = _tbEveryoneWelfareBackendInfo})
end

-- 获得已购买人数
function getNumBought( )
	return _tbEveryoneWelfareBackendInfo.num or "0"
end

-- 计算已购买人数
function getFakeNumBought( )
	-- int（（log（time，100）-b）*c））
	local timeOpen = NewLoginCtrl.getSelectServerInfo().openDateTime
	local tbTimeNow, timeNow = TimeUtil.getServerDateTime()
	local timeForGrowth = (timeNow - timeOpen) / 60
	local tb = lua_string_split (_tbEveryoneWelfareConfigData[5],"|")
	logger:debug({asdfweoinvargvna = math.floor(  ( math.log(timeForGrowth)/math.log(100) - tb[1] ) * tb[2] )}  )
end

-- 读取配置的奖励数据
function setConfigData( )
	if ( table.isEmpty(_tbEveryoneWelfareConfigData) ) then
		 _tbEveryoneWelfareConfigData = DB_Growth_fund.getDataById(1)
	
		logger:debug({EveryoneWelfareConfigData = _tbEveryoneWelfareConfigData})
	end
end

--[[desc:处理并获得View所需的数据
    return: tbRewardListData = { 1={numPeople,rewardType,rewardId,rewardNum,status},2={...}...}
    		rewardString:"1|0|1000"
    		status:0,1,2:不能领，可以领，已经领
—]]
function getDataForView( )
	local tbRewardListData = {}
	if ( not table.isEmpty(_tbEveryoneWelfareBackendInfo) ) then
		setConfigData()
		local all_perp = _tbEveryoneWelfareConfigData[5]
		local tbReward = lua_string_split( _tbEveryoneWelfareConfigData[6], "," )
		for k,v in ipairs(tbReward) do
			local tbString = lua_string_split( v, "|" )
			local tbTemp = {}
			tbTemp.numPeople = tbString[1]
			tbTemp.rewardType = tbString[2]
			tbTemp.rewardId = tbString[3]
			tbTemp.rewardNum = tbString[4]
			tbTemp.rewardString = (tbString[2] .."|".. tbString[3] .."|".. tbString[4])
			tbTemp.status = 0
			if (tonumber(_tbEveryoneWelfareBackendInfo.num) >= tonumber(tbString[1])) then
				tbTemp.status = 1
			end
			table.insert(tbRewardListData, k, tbTemp)
		end
		for k,v in pairs(_tbEveryoneWelfareBackendInfo.received) do
			tbRewardListData[tonumber(v)+1].status = 2
		end
		
		logger:debug({ tbRewardListData = tbRewardListData })
	end
	return tbRewardListData
end

--------------------------------------------

local function init(...)

end

function destroy(...)
	package.loaded["EveryoneWelfareModel"] = nil
end

function moduleName()
    return "EveryoneWelfareModel"
end

function create(...)

end
