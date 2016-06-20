-- FileName: OpenServerModel.lua
-- Author: yucong
-- Date: 2015-08-11
-- Purpose: 开服7日活动model
--[[TODO List]]

module("OpenServerModel", package.seeall)

require "db/DB_Open_server_act"
require "db/DB_Open_server_reward"
require "script/module/IAP/IAPData"
require "script/model/user/UserModel"

MSG = {
	CB_GAIN_REWARD	= "CB_GAIN_REWARD",
	CB_RELOAD		= "CB_RELOAD",
	CB_MODITY_DATA	= "CB_MODITY_DATA",
	CB_BUY_OK		= "CB_BUY_OK",
	CB_BUY_FAILED	= "CB_BUY_FAILED",
}

kBUY_STATE_CAN		= 1 	-- 可购买
kBUY_STATE_ALREADY	= 2 	-- 已购买
kBUY_STATE_OUT		= 3 	-- 已售罄

kBUY_TAB			= 4 	-- 开服抢购页签index

local m_i18n	= gi18n
local _dbAct = DB_Open_server_act
local _dbReward = DB_Open_server_reward
local _nDay = 1
local _nTab = 1
local _tbDBDatas = {}
local _tbStatusDatas = {}
local _tbDayTip = {}
local _isClosed = false
-- local _tServerInfo = g_tbServerInfo.openDateTime
-- _tServerInfo.openDateTime = 1439085600
local _nOpenServerTime = g_tbServerInfo.openDateTime

function setDay( day )
	_nDay = day
end

function getDay( ... )
	return _nDay
end

function setTab( tab )
	_nTab = tab
end

function getTab( ... )
	return _nTab
end

function getDBData( ... )
	return _tbDBDatas
end

function getDataByDay( day )
	assert(_tbDBDatas[tonumber(day)], "第"..day.."天的数据不存在")
	return _tbDBDatas[tonumber(day)]
end

function setStatusData( data )
	logger:debug({statusData = data})
	if (table.isEmpty(data)) then
		_isClosed = true
		return
	end
	_tbStatusDatas = data
	-- _tbStatusDatas["purchase"] = {
	-- 	["1"] = {
	-- 		buyFlag = "0",
	-- 		remainNum = "10",
	-- 		},
	-- 	["2"] = {
	-- 		buyFlag = "1",
	-- 		remainNum = "0",
	-- 		},
	-- 	["3"] = {
	-- 		buyFlag = "0",
	-- 		remainNum = "0",
	-- 		},
	-- 	["4"] = {
	-- 		buyFlag = "1",
	-- 		remainNum = "0",
	-- 		},
	-- 	["5"] = {
	-- 		buyFlag = "1",
	-- 		remainNum = "0",
	-- 		},
	-- 	["6"] = {
	-- 		buyFlag = "1",
	-- 		remainNum = "0",
	-- 		},
	-- 	["7"] = {
	-- 		buyFlag = "0",
	-- 		remainNum = "0",
	-- 		},
	-- }
	--if (data.openServerTime) then
	_nOpenServerTime = g_tbServerInfo.openDateTime--tonumber(data.openServerTime)
	logger:debug("_nOpenServerTime:".._nOpenServerTime)
	--end
end

-- 检查开服时间与终止时间是否一致
function checkTime( ... )
	-- local tbServerTime = TimeUtil.getLocalOffsetDate("*t", _nOpenServerTime)
	-- local tbDeadTime = TimeUtil.getLocalOffsetDate("*t", getDeadDay())
	--assert((getDeadDay() - _nOpenServerTime)/(24 * 3600) + 1 == 7, "开服7日:[开服时间:".._nOpenServerTime.."与结束时间:"..getDeadDay().."不一致！]")
	--assert(TimeUtil.getDifferDayBaseZeroClock(getDeadDay(), _nOpenServerTime) == 7, "开服7日:[开服时间:".._nOpenServerTime.."与结束时间:"..getDeadDay().."不一致！]")
end

function getBuyStateWithData( data )
	if (not data) then
		return kBUY_STATE_ALREADY
	end
	data.buyFlag = tonumber(data.buyFlag)
	data.remainNum = tonumber(data.remainNum)
	if (data.buyFlag == 0 and data.remainNum > 0) then
		return kBUY_STATE_CAN
	elseif (data.buyFlag == 1) then
		return kBUY_STATE_ALREADY
	elseif (data.remainNum <= 0) then
		return kBUY_STATE_OUT
	end
end

function modifyStatusData( data )
	if (_isClosed or isDead()) then
		return
	end
	for k, rid in pairs(data or {}) do
		local statusInfo = _tbStatusDatas[tostring(rid)]
		if (statusInfo and tonumber(statusInfo.s) == 0) then
			statusInfo.s = 1
		elseif (statusInfo == nil) then
			local info = {}
			info.fn = 0
			info.s = 1
			_tbStatusDatas[tostring(rid)] = info
		end
	end
end

-- 充值成功后修改数据
-- value: 刚充值的金额
function modifyPayStatusData( value )
	if (_isClosed or isDead()) then
		return
	end
	for k,v in pairs(_dbReward.Open_server_reward) do
		local info = _dbReward.getDataById(tonumber(v[1]))
		-- 查找充值项
		if (tonumber(info.typeId) == 120) then
			local data = _tbStatusDatas[tostring(info.id)]
			-- 查找未完成的
			if (data and tonumber(data.s) == 0) then
				data.fn = tonumber(data.fn) + value
				if (data.fn >= tonumber(info.data)) then
					logger:debug("modifyPayStatusData:有新的可领取的充值奖励")
					data.s = 1
				end
			end
		end
	end
end

function getStatusData( ... )
	return _tbStatusDatas
end

function getOpenTime( ... )
	--return _tServerInfo.openDateTime
	return _nOpenServerTime
end

function getDeadDay( ... )
	return tonumber(_tbStatusDatas.DEADLINE) or 0
end

function getCloseDay( ... )
	return tonumber(_tbStatusDatas.CLOSEDAY) or 0
end

function initDatas( ... )
	for k,v in pairs(_dbAct.Open_server_act) do
		local info = _dbAct.getDataById(tonumber(v[1]))
		-- 页签信息
		info.tTabs = {}
		-- 红点信息
		info.tTips = {}
		info.tShop = {}
		for tab = 1, 3 do
			local tabInfo = {}
			tabInfo.name = info["achieve"..tab.."_desc"]
			-- 页签下的奖励信息
			tabInfo.achiveInfo = {}
			-- 红点数量
			local tipCount = 0
			local tRewardIds = string.strsplit(info["achieve_"..tab], "|")
			for key, rid in pairs(tRewardIds) do
				local rewardInfo = _dbReward.getDataById(tonumber(rid))
				-- 进度
				rewardInfo.maxnum = tonumber(rewardInfo.data)
				-- 副本任务的进度显示1
				if (tonumber(rewardInfo.typeId) == 102 or tonumber(rewardInfo.typeId) == 123 or tonumber(rewardInfo.typeId) == 106) then
					rewardInfo.maxnum = 1
				end
				local statusInfo = _tbStatusDatas[tostring(rid)]
				if (statusInfo) then
					rewardInfo.status = tonumber(statusInfo.s)  	-- 0未完成 1已完成 2已领奖
					rewardInfo.finishnum = tonumber(statusInfo.fn)
				else
					rewardInfo.status = 0 	-- 0未完成 1已完成 2已领奖
					rewardInfo.finishnum = 0
				end
				-- 竞技场的进度前端判断
				if (tonumber(rewardInfo.typeId) == 106) then
					if (rewardInfo.status == 0) then
						rewardInfo.finishnum = 0
					else
						rewardInfo.finishnum = 1
					end
				end
				-- 战斗力的进度前端显示
				if (tonumber(rewardInfo.typeId) == 119) then
					if (getCurDay() <= 7) then
						rewardInfo.finishnum = math.max(UserModel.getFightForceValue(), rewardInfo.finishnum)
					end
				end
				rewardInfo.finishnum = math.min(tonumber(rewardInfo.finishnum), rewardInfo.maxnum)
				
				table.insert(tabInfo.achiveInfo, rewardInfo)
				-- 累加红点
				if (rewardInfo.status == 1) then
					tipCount = tipCount + 1
				end
			end
			
			info.tTabs[tab] = tabInfo
			info.tTips[tab] = tipCount
		end
		for tab = kBUY_TAB, kBUY_TAB do
			info.tShop = {}
			local tabInfo = {}
			-- 红点数量
			local tipCount = info.tTips[tab] or 0

			local statusInfo = _tbStatusDatas["purchase"]
			if (statusInfo) then
				info.tShop = statusInfo[tostring(info.id)]
				if (info.tShop) then
					info.tShop.buyFlag = tonumber(info.tShop.buyFlag)
					info.tShop.remainNum = tonumber(info.tShop.remainNum)
					if (getBuyStateWithData(info.tShop) == kBUY_STATE_CAN) then
						tipCount = tipCount + 1
					end
				-- else
				-- 	info.tShop = {}
				-- 	info.tShop.buyFlag = 1
				-- 	info.tShop.remainNum = 0
				end
			end

			info.tTabs[tab] = tabInfo
			info.tTips[tab] = tipCount
		end

		_tbDBDatas[tonumber(info.id)] = info
	end

	handleDatas()
	logger:debug({_tbDBDatas = _tbDBDatas})
end

function handleDatas( ... )
	sortDatas()	
end

function sort( data1, data2 )
	return data1.id < data2.id
end

function sortDatas( ... )
	local tCan = {}	-- 可领取
	local tNot = {}	-- 不可领取
	local tHave = {} -- 已领取

	local dayData = getDataByDay(_nDay)
	local tabData = dayData.tTabs[_nTab] or {}
	logger:debug(_nTab)
	logger:debug(dayData.tTabs)
	for rid, info in pairs(tabData.achiveInfo or {}) do
		local status = info.status
		if (status == 1) then 	
			table.insert(tCan, info)
		elseif (status == 0) then
			table.insert(tNot, info)
		elseif (status == 2) then
			table.insert(tHave, info)
		end
	end

	table.sort(tCan, sort)
	table.sort(tNot, sort)
	table.sort(tHave, sort)

	tabData.achiveInfo = {}
	function combine( tb )
		for i,val in ipairs(tb) do
			tabData.achiveInfo[#tabData.achiveInfo+1] = tb[i]
		end
	end
	combine(tCan)
	combine(tNot)
	combine(tHave)
end
-- 入口是否显示红点
function isShowRed( ... )
	-- logger:debug(_tbStatusDatas)
	for dutyId, statusInfo in pairs(_tbStatusDatas or {}) do
		if (dutyId == "purchase") then
			for k, v in pairs(statusInfo) do
				--if (v.buyFlag == 0 and v.remainNum > 0) then 	-- 还没有执行initDatas方法
				logger:debug({v = v})
				if (getBuyStateWithData(v) == kBUY_STATE_CAN) then
					--return true -- 抢购的红点只显示在页签上
				end
			end
		elseif (type(statusInfo) == "table") then
			if (tonumber(statusInfo.s) == 1) then
				return true
			end
		end
	end
	return false
end

-- 取天数对应的红点
function getTipCountWithDay( day )
	local count = 0
	local data = _tbDBDatas[tonumber(day)]
	for k, v in pairs(data.tTips) do
		-- 抢购的红点只显示在页签上
		if (tonumber(k) ~= kBUY_TAB) then
			count = count + tonumber(v)
		end
	end
	return count
end

-- 当前活动进行到第几天了
function getCurDay( ... )
	local day = TimeUtil.getDifferDay(_nOpenServerTime) + 1
	assert(day > 0, "开服狂欢：当前配置的开服时间为 "..TimeUtil.getTimeFormatYMDHM(_nOpenServerTime))
	return day
end

-- 活动是否终止了
function isDead( ... )
	local now = TimeUtil.getSvrTimeByOffset()
	if (getDeadDay() < now) then
		return true
	end
	return false
end

-- 活动是否结束
function isClosed( ... )
	if (_isClosed) then 
		return _isClosed
	end

	-- for k, v in pairs(_dbAct.Open_server_act) do
	-- 	local data = _dbAct.getDataById(tonumber(v[1]))
	-- 	local closeDays = tonumber(data.close_day)	-- 活动关闭天数
	-- 	if (getCurDay() >= closeDays or getCurDay() <= 0) then
	-- 		_isClosed = true
	-- 	end
	-- end
	local now = TimeUtil.getSvrTimeByOffset()
	if (getCloseDay() < now) then
		_isClosed = true
	end
	return _isClosed
end

-- 获取对应的跳转type
function getTurnWithRid( rid )
	local data = _dbReward.getDataById(tonumber(rid))
	return data.turn
end

function getTypeIdWithRid( rid )
	local data = _dbReward.getDataById(tonumber(rid))
	return data.typeId
end

-- 设置条目为已领取
function itemCompleteWithRid( rid )
	-- 取当前选择的天数据
	local data = getDataByDay(_nDay)
	-- 取当前天下面的页签数据
	local tabInfo = data.tTabs[_nTab]
	local tipCount = data.tTips[_nTab]	-- 红点数量
	for k, info in pairs(tabInfo.achiveInfo) do
		if (tonumber(rid) == tonumber(info.id)) then
			info.status = 2
			tipCount = math.max(tipCount - 1, 0)
			break
		end
	end
	_tbStatusDatas[tostring(rid)].s = 2
	data.tTips[_nTab] = tipCount
	--logger:debug(tabInfo.achiveInfo)
end

-- 获取格式化后的倒计时 "x天 xx:xx:xx"
function getCountdown( time, isIncludeDay )
	local now = TimeUtil.getSvrTimeByOffset()	-- 当前时间
	-- -- 将开服时间是时分秒归0
	-- local total = temp.hour * 60 * 60 + temp.min * 60 + temp.sec
	-- _nOpenServerTime = _nOpenServerTime - total

	-- local interval = math.max(_nOpenServerTime + durationDays * 24 * 60 * 60 - now, 0)
	local interval = math.max(tonumber(time) - now, 0)

	if (interval == 0) then
		return string.format("0"..m_i18n[1937].." 00:00:00")
	end

	local hour	 = math.floor(interval/3600)
	local minute = math.floor((interval - hour*3600)/60)
	local second = math.floor(interval - hour*3600 - minute*60)
	local day  = 0
	if(hour >= 24) then
		day  = math.floor(hour/24)
		hour = hour - day*24
	end

	if (isIncludeDay) then
		return string.format("%d%s %02d:%02d:%02d", day, m_i18n[1937], hour, minute, second)
	else
		return string.format("%02d:%02d:%02d", hour, minute, second)
	end
end

-- 前往
function changeModule( type )
	type = tonumber(type)
	if (type == 0) then
		return
	end
	if(not SwitchModel.getSwitchOpenState(type,true)) then
		return
	end

	if (tonumber(type) == ksSwitchFormation) then -- 阵容
		require "script/module/formation/MainFormation"
		if (MainFormation.moduleName() ~= LayerManager.curModuleName()) then
			local layFormation = MainFormation.create(0)
			if (layFormation) then
				LayerManager.changeModule(layFormation, MainFormation.moduleName(), {1, 3}, true)
			end
		end
	elseif (tonumber(type) == ksSwitchGeneralTransform) then -- 伙伴进阶
		require "script/module/partner/MainPartner"
		if (MainPartner.moduleName() ~= LayerManager.curModuleName()) then
			local layPartner = MainPartner.create()
			if (layPartner) then
				LayerManager.changeModule(layPartner, MainPartner.moduleName(), {1, 3}, true)
				PlayerPanel.addForPartnerStrength()
			end
		end
	elseif (tonumber(type) == ksSwitchEliteCopy) then 	-- 精英副本
		require "script/module/copy/MainCopy"
		-- if(not SwitchModel.getSwitchOpenState(ksSwitchEliteCopy,true)) then
		-- 	return
		-- end 
	    local layCopy = MainCopy.create(2,false)
		if (layCopy) then
			LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
			PlayerPanel.addForCopy()
			MainCopy.updateBGSize()
			MainCopy.setFogLayer()

			MainScene.changeMenuCircle(3)
		end
	elseif (tonumber(type) == ksSwitchArena) then -- 竞技场
		require "script/module/arena/MainArenaCtrl"  
		if (MainArenaCtrl.moduleName() ~= LayerManager.curModuleName()) then
			require "script/module/switch/SwitchModel"
			if(SwitchModel.getSwitchOpenState(ksSwitchArena,true)) then
			   MainArenaCtrl.create()
			end
		end
	elseif (tonumber(type) == ksSwitchWeaponForge) then -- 装备强化
 		require "script/module/equipment/MainEquipmentCtrl"
		if (MainEquipmentCtrl.moduleName() ~= LayerManager.curModuleName()) then
			local layEquipment = MainEquipmentCtrl.create()
			if (layEquipment) then
				LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3}, true)
				PlayerPanel.addForPartnerStrength()
			end
		end
	elseif (tonumber(type) == ksSwitchGeneralForge) then -- 紫色伙伴等级
		require "script/module/partner/MainPartner"
		if (MainPartner.moduleName() ~= LayerManager.curModuleName()) then
			local layPartner = MainPartner.create()
			if (layPartner) then
				LayerManager.changeModule(layPartner, MainPartner.moduleName(), {1, 3}, true)
				PlayerPanel.addForPartnerStrength()
			end
		end	
	elseif (tonumber(type) == ksSwitchDestiny) then -- 主船改造
		require "script/module/Train/MainTrainCtrl"
		require "script/module/switch/SwitchModel"
		AudioHelper.playMainUIEffect()
		if (not SwitchModel.getSwitchOpenState(ksSwitchDestiny,true)) then
			return
		else
			MainTrainCtrl.create()
		end
	elseif (tonumber(type) == ksSwitchEquipFixed) then -- 装备附魔
		require "script/module/equipment/MainEquipmentCtrl"
		if (MainEquipmentCtrl.moduleName() ~= LayerManager.curModuleName()) then
			local layEquipment = MainEquipmentCtrl.create()
			if (layEquipment) then
				LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3}, true)
				PlayerPanel.addForPartnerStrength()
			end
		end
	elseif (tonumber(type) == ksSwitchTreasureFixed) then -- 宝物精炼	
		require "script/module/treasure/MainTreaBagCtrl"
		if (not LayerManager.isRunningModule(MainTreaBagCtrl)) then
			MainTreaBagCtrl.create()

		end
	elseif (tonumber(type) == ksSwitchTreasureForge) then -- 宝物强化
		require "script/module/treasure/MainTreaBagCtrl"
		if (not LayerManager.isRunningModule(MainTreaBagCtrl)) then
			MainTreaBagCtrl.create()
		end
	elseif (tonumber(type) == ksSwitchImpelDown) then -- 深海监狱
		require "script/module/impelDown/MainImpelDownCtrl"
		if (not LayerManager.isRunningModule(MainImpelDownCtrl)) then
			LayerManager.changeModule(MainImpelDownCtrl.create(), MainImpelDownCtrl.moduleName(), {1,3}, true)
		end
	elseif (tonumber(type) == ksSwitchExplore) then --探索
		require "script/module/copy/ExplorMainCtrl"
		if ( LayerManager.curModuleName() == ExplorMainCtrl.moduleName() ) then
			LayerManager.removeLayout() -- 多移除一层，因为加了个动画层
			LayerManager.removeLayout()
			AudioHelper.playCommonEffect()
			--发送离开和进入探索通知
			--SwitchCtrl.postBattleNotification(GlobalNotify.END_EXPLORE)			--临时注释掉，不要删
			--SwitchCtrl.postBattleNotification(GlobalNotify.BEGIN_EXPLORE)			--临时注释掉，不要删
		else
			require "script/module/switch/SwitchModel"
			if( not SwitchModel.getSwitchOpenState(ksSwitchExplore, true)) then
				return
			end
			require "script/module/copy/MainCopy"
			MainCopy.extraToExploreScene()
		end
 	end
end

function changeModuleWithTypeid( typeId )
	typeId = tonumber(typeId)
	-- 主线副本 副本星数 困难副本 等级突破
	if (typeId == 102 or typeId == 124 or typeId == 123 or typeId == 101) then
		require "script/module/copy/MainCopy"
		if (MainCopy.moduleName() ~= LayerManager.curModuleName()) then
			MainCopy.destroy()
			local layCopy = MainCopy.create()
			if (layCopy) then
				LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
				PlayerPanel.addForCopy()
				MainCopy.updateBGSize()
				MainCopy.setFogLayer()

				MainScene.changeMenuCircle(3)
			end
		end
	-- 好友
	elseif (typeId == 116) then
		require "script/module/friends/MainFdsCtrl"
		LayerManager.changeModule(MainFdsCtrl.create(), MainFdsCtrl.moduleName(), {1, 3}, true)
		PlayerPanel.addForActivity()
	-- 充值
	elseif (typeId == 120) then
		require "script/module/IAP/IAPCtrl"
		LayerManager.addLayout(IAPCtrl.create())
	end
end

function getBtnLabel( btn )
	return tolua.cast(btn:getTitleTTF(), "CCLabelTTF")
end

function destroy(...)
	_isClosed = false
	package.loaded["OpenServerModel"] = nil
end

function moduleName()
    return "OpenServerModel"
end

function create(...)

end
