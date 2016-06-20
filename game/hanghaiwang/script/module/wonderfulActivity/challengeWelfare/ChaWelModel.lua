-- FileName: ChaWelModel.lua
-- Author: liweidong
-- Date: 2015-10-19
-- Purpose: function description of module
--[[TODO List]]

module("ChaWelModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _challengeNum = 0
local _challengeReward = {0,0,0,0}
local _curCell = nil
local _userDefault = g_UserDefault
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["ChaWelModel"] = nil
end

function moduleName()
    return "ChaWelModel"
end

function create(...)

end

-- --获取db所有id
function getChallengeWelfareDbIds()
	require "db/DB_Challenge_welfare_kaifu"
	local ids = {}
	for keys,val in pairs(DB_Challenge_welfare_kaifu.Challenge_welfare_kaifu) do
		local keyArr = lua_string_split(keys, "_")
		table.insert(ids,tonumber(keyArr[2]))
	end
	return ids
	-- local dbInfo = ActivityConfigUtil.getDataByKey("wealLittle")
	-- logger:debug({ChaWelCtrl = dbInfo})
end
--返回当前活动的DB信息
function getCurActitveDbInfo()
	local nowServerInfo = NewLoginCtrl.getSelectServerInfo()
	local openTimes = nowServerInfo.openDateTime

	local nowTimeNum = tonumber(TimeUtil.getLocalOffsetDate("%Y%m%d",TimeUtil.getSvrTimeByOffset()) ) 
	local ids = getChallengeWelfareDbIds()
	for _,id in ipairs(ids) do
		local db = DB_Challenge_welfare_kaifu.getDataById(id)
		local timeArr = lua_string_split(db.time,"|")
		local time1 = openTimes+(timeArr[1]-1)*(24*60*60)
		local time2 = openTimes+(timeArr[2]-1)*(24*60*60)
		local openTimeNum1 = tonumber(TimeUtil.getLocalOffsetDate("%Y%m%d",time1) ) 
		local openTimeNum2 = tonumber(TimeUtil.getLocalOffsetDate("%Y%m%d",time2) ) 
		if (openTimeNum1<=nowTimeNum and openTimeNum2>=nowTimeNum) then
			return db
		end
	end

	
	local format = "%Y%m%d%H%M%S"
    local openTimeStr = tonumber(TimeUtil.getLocalOffsetDate(format,openTimes) ) 
    local nowTime = TimeUtil.getSvrTimeByOffset()
    local nowTimeStr = tonumber(TimeUtil.getLocalOffsetDate(format,nowTime) )
    logger:debug({openTimeStr=openTimeStr,nowTimeStr=nowTimeStr})
	-- local ids = getChallengeWelfareDbIds()

	local dbInfo = ActivityConfigUtil.getDataByKey("wealLittle")
	logger:debug({ActivityConfigUtil = dbInfo})
	if (not dbInfo) then
		return nil
	end
	logger:debug({ChaWelCtrl = dbInfo})
	for _,val in ipairs(dbInfo.data) do
		-- local dbInfo = DB_Challenge_welfare.getDataById(id)
		if (tonumber(val.server_time)>=tonumber(openTimeStr) and 
			tonumber(nowTimeStr)>=tonumber(val.start_time) and 
			tonumber(nowTimeStr)<=tonumber(val.end_time)) then
			return val
		end		
	end
	return nil
end

--返回挑战次数和领取状态
function getChalNumAndRewStatus()
	return _challengeNum,_challengeReward
end
--设置领取状态
function setRewardStautsByIdx(idx)
	_challengeReward[idx]=1
end
--设置挑战次数
function setChallengeWelNum(type,num)
	local db = getCurActitveDbInfo()
	if (db==nil) then
		return
	end
	_challengeNum = num
	-- if (tonumber(db.type)==tonumber(type)) then
	-- 	_challengeNum = num
	-- end
end
--设置挑战福利服务器数据
function setChallengeWelInfo(data)
	if (type(data)~="table") then
		return 
	end
	_challengeNum = 0
	if (data.process) then
		for _,v in pairs(data.process) do
			_challengeNum = tonumber(v)
		end
	end
	_challengeReward = {0,0,0,0}
	if (data.rewarded) then
		for _,v in pairs(data.rewarded) do
			local idx = (v+1)-(v+1)%1
			_challengeReward[idx]=1
		end
	end
end
--返回列表数据
function getListData()
	local data = {}
	local db = getCurActitveDbInfo()
	if (db==nil) then
		return data
	end
	logger:debug({getCurActitveDbInfo=db})
	local chalNum,rewardStatus = getChalNumAndRewStatus()
	for i=1,10 do
		if (db["require" .. i] and tonumber(db["require" .. i])~=nil) then
			local item ={}
			item.db = db
			item.haveNum = tonumber(chalNum)
			item.rewardStatus = rewardStatus[i]
			item.needNum = tonumber(db["require" .. i])
			logger:debug({haveNume = item.haveNum})
			logger:debug({needNum = item.needNum})
			if (item.haveNum>item.needNum) then
				item.haveNum = item.needNum
			end
			item.reward = db["reward_id" .. i]
			item.timeUnit = m_i18n[4909]
			if (tonumber(db.type)==3) then
				item.timeUnit = m_i18n[5410]
			end
			table.insert(data,item)
		else
			break
		end
	end
	return data
end
--返回红点状态
function getRedTipStatus()
	local data = getListData()
	local redNum = 0
	for _,v in ipairs(data) do
		if (v.rewardStatus~=1 and v.haveNum>=v.needNum) then
			redNum = redNum+1
		end
	end
	return redNum
end

--返回活动剩余时间
function getActitiveyRemainTimes()
	local db = getCurActitveDbInfo()
	if (db==nil) then
		return 0
	end
	if (db.time) then
		local nowServerInfo = NewLoginCtrl.getSelectServerInfo()
		local openTimes = nowServerInfo.openDateTime
		local openday=TimeUtil.getLocalOffsetDate("*t",openTimes) 
		logger:debug({openday=openday})
		openday.hour=0
		openday.min=0
		openday.sec=0
		openTimes = os.time(openday) --openTimes - openTimes%(24*60*60)

		local timeArr = lua_string_split(db.time,"|")
		local time2 = openTimes+(timeArr[2])*(24*60*60)
		return time2
	else
		local endTime = tostring(db.end_time)
		local date = {}
		date.year = tonumber(string.sub(endTime,1,4))
		date.month = tonumber(string.sub(endTime,5,6))
		date.day = tonumber(string.sub(endTime,7,8))
		date.hour = tonumber(string.sub(endTime,9,10))
		date.min = tonumber(string.sub(endTime,11,12))
		date.sec = tonumber(string.sub(endTime,13,14))
		return os.time(date)
	end
end
--[[desc:在手机中存储是否曾经访问过这个按钮
    arg1: 访问状态
    return: 无  
—]]
function setNewAniState( nState )
	local db = getCurActitveDbInfo()
	if (db==nil) then
		return 
	end
	_userDefault:setIntegerForKey("new_challenge_visible"..UserModel.getUserUid()  .. (db.start_time or db.time), nState)
end

--[[desc:获取是否访问过这个按钮的状态
    arg1: 无
    return: 储存的状态  
—]]
function getNewAniState()
	local db = getCurActitveDbInfo()
	if (db==nil) then
		return 1
	end
	-- do return 0 end
	return _userDefault:getIntegerForKey("new_challenge_visible"..UserModel.getUserUid() .. (db.start_time or db.time))
end
--保存顶部cell
function setCell(cell)
	_curCell = cell
end
--返回顶部cell
function getCell()
	return _curCell
end