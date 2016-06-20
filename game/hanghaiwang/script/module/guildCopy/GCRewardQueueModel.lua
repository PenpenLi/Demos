-- FileName: GCRewardQueueModel.lua
-- Author: yangna
-- Date: 2015-06-03
-- Purpose: 奖励队列数据
--[[TODO List]]

module("GCRewardQueueModel", package.seeall)
require "db/DB_Legion_newcopy"

-- UI控件引用变量 --

-- 模块局部变量 --
local _isInQueue = false   --玩家是否在排队
local _nUserCopyId = nil  --玩家所排队所在副本id
local _nUserQueueData = nil  --玩家排队的奖励数据（队伍在奖励数据里）
local _curCopyId = nil  --当前副本id


local function init(...)
	_isInQueue = false
	_nUserCopyId = nil
	_nUserQueueData = nil
	_curCopyId = nil 
end

function destroy(...)
	package.loaded["GCRewardQueueModel"] = nil
end

function moduleName()
    return "GCRewardQueueModel"
end



local function findUser( tbData )
	tbData = tbData or {}
	local index = nil
	local uid = tonumber(UserModel.getUserUid())
	for i=1,table.count(tbData) do 
		if (tonumber(tbData[i].uid)==uid) then 
			index = i 
			break
		end 
	end 
	return index
end


--[[desc: 初始化玩家在队伍中的信息：是否已在排队，排队副本id，排队奖励，排名
    copyid: copyid=nil,从所有副本数据中查找，copyid不为空，从指定副本数据中查找
    return: 无  
—]]
function initPlayerQueueInfo(copyid )
	_isInQueue = false
	_nUserCopyId = nil
	_nUserQueueData = nil

	local function search( id,copyData )
		local ret = false
		logger:debug(id)
		logger:debug(copyData)

		for i=1,table.count(copyData) do 
			local index = findUser(copyData[i].queue)
			if (index) then 
				setIsInQueue(true,id,copyData[i])
				ret = true
				break
			end 
		end 
		return ret
	end

	if (copyid) then 
		local tbGuildData = DataCache.getGuildCopyData()
		search(copyid, tbGuildData[""..copyid].va_gc.rewardQueue )
	else 
		local tbGuildData = DataCache.getGuildCopyData()
		for k,v in pairs(tbGuildData) do 
			if ( v.va_gc and search(k,v.va_gc.rewardQueue)) then 
				break
			end 
		end 
	end 

	if (_nUserQueueData) then 
		_nUserQueueData.detail,_nUserQueueData.visibleNum =	getDetailByTime(_nUserQueueData.detail,_nUserQueueData.rewardConf[3])
	end 

	logger:debug(" 初始化玩家队伍信息")
	logger:debug(_isInQueue)
	logger:debug(_nUserCopyId)
	logger:debug(_nUserQueueData)

end

-- 记录玩家所在队伍的副本id，所在队伍的奖励数据
function setIsInQueue(ret,copyId,tbData)
	_isInQueue = ret
	_nUserCopyId = copyId
	_nUserQueueData = tbData
end

-- 获取玩家队伍所在的副本id
function getUserCopyId( ... )
	return _nUserCopyId
end

-- 获取玩家是否已排队
function getIsInQueue( ... )
	return _isInQueue
end

-- 玩家排队的奖励数据
function getUserQueueData( ... )
	return  _nUserQueueData
end

--当前的副本id
function setCurCopyId( copyid )
	_curCopyId = copyid
end
--当前的副本id
function getCurCopyId( ... )
	return _curCopyId
end


--[[desc:获取排队奖励队列数据,奖励掉落大于0的优先在前，掉落相同的按照配置顺序排
    copyid: 副本id
    return: 奖励队列数据
—]]
function getRewardQueueData( copyid )
	copyid = tostring(copyid)
	local tbGuildData = DataCache.getGuildCopyData()
	-- 指定副本的奖励数据
	local curCopyData = tbGuildData[copyid].va_gc.rewardQueue or {}

	-- 按时间过滤玩家可见的掉落
	for k,v in pairs(curCopyData) do 
		v.detail,v.visibleNum = getDetailByTime(v.detail,v.rewardConf[3])
		v.queue = v.queue or {}
	end 

	--合并奖励配置中的数据
	local copyDb = DB_Legion_newcopy.getDataById(copyid)
	local tbData = lua_string_split(copyDb.reward_id,",")
	local tbDataTemp = {}
	for k,v in pairs(tbData) do 
		local cell = lua_string_split(v,"|")
		cell.index = k
		table.insert(tbDataTemp,cell)
	end 

	-- 删除配置中的相同项
	for k, v in pairs(curCopyData) do 
		for i=1,table.count(tbDataTemp) do 
			if ( v.rewardConf and tonumber(v.rewardConf[1])==tonumber(tbDataTemp[i][1]) and tonumber(v.rewardConf[2])==tonumber(tbDataTemp[i][2]) ) then 
				v.index = tbDataTemp[i].index
				table.remove(tbDataTemp,i)
				break
			end 
		end 
	end

	for k,v in pairs(curCopyData) do 
		v.index = v.index or 0
	end 

	-- 合并配置
	for k,v in pairs(tbDataTemp) do 
		local data = {}
		data.rewardConf = v 
		data.visibleNum = 0
		data.queue = {}
		data.index = v.index
		table.insert(curCopyData,data)
	end 

	local function sortFun(a,b)
		if (a.visibleNum == b.visibleNum) then 
			return a.index < b.index
		else 
			return a.visibleNum > b.visibleNum
		end 
	end

	table.sort(curCopyData,sortFun)
	return curCopyData
end


--[[desc:根据副本奖励数据 获取奖励的 quality，icon，name
    tbData : 副本奖励数据
    return: ｛ ｛ quality，icon，name ｝ ｝
—]]
function getIconAndName( tbRewardData )
	local tbData = {}

	for i=1,table.count(tbRewardData) do 
		local cell = {}
		cell.type = tbRewardData[i].rewardConf[1]
		cell.id = tbRewardData[i].rewardConf[2]
		cell.num = tbRewardData[i].rewardConf[3] 
		table.insert(tbData,cell)
	end 

	local tbRewardData = RewardUtil.getItemsDataByTb(tbData)
	local tbRewardDataTemp = RewardUtil.parseRewardsByTb(tbRewardData)
	return tbRewardDataTemp
end


--[[desc:获取一个奖励数据的quality，icon，name
    arg1: 一个奖励数据
    return: ｛ quality，icon，name ｝ 
—]]
function getIconAndNameByOne( tbRewardData )
	local tbData = {}
	tbData.type = tbRewardData.rewardConf[1]
	tbData.id = tbRewardData.rewardConf[2]
	tbData.num = tbRewardData.rewardConf[3] 

	local tbRewardData = RewardUtil.getItemsDataByTb( {tbData} )
	local tbRewardDataTemp = RewardUtil.parseRewardsByTb(tbRewardData)
	return tbRewardDataTemp[1]
end


--[[desc:过滤玩家加入工会前后的掉落 
    tbData:getAllInfo 的detail
    num:配置中三元组的num
    return: 玩家可以排队的奖励table和奖励掉落个数 
—]]
function getDetailByTime( tbData,num )
	tbData = tbData or {}
	local tbDetail = {}
	local nNum = 0
	local playerTime = GuildDataModel.getMineSigleGuildInfo().rejoin_time

	for k,v in pairs(tbData) do 
		if (tonumber(k)>=tonumber(playerTime)) then 
			tbDetail[k] = v
			nNum = nNum + tonumber(v)
		end 
	end 

	--(掉落数量不是分配数量的整数倍，向上取整容错处理)
	local visibleNum = math.ceil(nNum/num)
	return tbDetail,visibleNum
end


-- 返回服务器当前时间 格式: 时分秒 如 130000
function getCurTiem()
	local time = TimeUtil.getSvrTimeByOffset()
	time = tonumber(time)
	local format = "%H%M%S"
	
	return TimeUtil.getLocalOffsetDate(format,time)  
end

-- 当前时间是否能插队
function isCanInsertQueue( ... )
	local tbCopy = DB_Legion_copy_build.getDataById(1)
	local tbRewardTime = lua_string_split(tbCopy.reward_time,"|") 
	local nNetxTime = nil
	local nCurTime = getCurTiem()
	for i=1,#tbRewardTime do 
		if (tonumber(nCurTime) < tonumber(tbRewardTime[i])) then 
			nNetxTime = tbRewardTime[i]
			break
		end 
	end 

	if (not nNetxTime) then 
		return true
	end 

	local time1 = nNetxTime%100 + (math.floor(nNetxTime/100)%100)*60 + math.floor(nNetxTime/10000)*60*60
	local time2 = nCurTime%100 + (math.floor(nCurTime/100)%100)*60 + math.floor(nCurTime/10000)*60*60
	local time = time1 - time2

	if (time > getCurForbidTime()) then 
		return true
	end 

	return false
end

-- 不可插队时长
function getCurForbidTime( copyId )
	local tbCopy = DB_Legion_copy_build.getDataById(1)
	return tbCopy.cut_forbid_time	
end

-- 获取物品距离下次自动分配的剩余时间,返回 小时，分
function getRemainTime( ... )
	local tbCopy = DB_Legion_copy_build.getDataById(1)
	local tbRewardTime = lua_string_split(tbCopy.reward_time,"|") 
	local nNetxTime = nil
	local nCurTime = getCurTiem()

	for i=1,#tbRewardTime do 
		if (tonumber(nCurTime) < tonumber(tbRewardTime[i])) then 
			nNetxTime = tbRewardTime[i]
			break
		end 
	end 

	nNetxTime = nNetxTime or tbRewardTime[1]
	local time1 = nNetxTime%100 + (math.floor(nNetxTime/100)%100)*60 + math.floor(nNetxTime/10000)*60*60
	local time2 = nCurTime%100 + (math.floor(nCurTime/100)%100)*60 + math.floor(nCurTime/10000)*60*60
	local time0 = os.time({year=2015,month=1,day=1,hour=0,min=0,sec=0})
	local remina = time0 + time1 - time2
	return os.date("%H",remina) , os.date("%M",remina)
end


--[[desc:插队补偿的贡献
    index: 插队玩家当前在队伍排名 
    return: 补偿贡献  
—]]
function getCutCompensate( index )
	local tbCopy = DB_Legion_copy_build.getDataById(1)
	local nNum = index - 1
	local nNeedGet = tbCopy.cut_need * tbCopy.cut_compensate / 10000 / nNum
	return nNeedGet
end

-- 获取插队需要消耗的贡献度
function getCutNeed( ... )
	local tbCopy = DB_Legion_copy_build.getDataById(1)
	return 	tbCopy.cut_need
end

function create(...)
	init()
end

-- 伤害排行贝里奖励
function getRankBellyData( copyid )
	local tbCopyRank = DB_Legion_newcopy.getDataById(copyid)
	if (tbCopyRank) then 
		local tbData = lua_string_split(tbCopyRank.rank_belly,"|")
		return tbData
	end 

	return nil
end

-- 伤害排行贡献度奖励
function getRankContriData( copyid )
	local tbCopyRank = DB_Legion_newcopy.getDataById(copyid)
	if (tbCopyRank) then 
		local tbData = lua_string_split(tbCopyRank.rank_contribution,"|")
		return tbData
	end 

	return nil
end

--获取指定副本的伤害排行数据
function getHitRankData( copyId )
	local tbGuildData = DataCache.getGuildCopyData()
	-- 指定副本的奖励数据
	local tbHitData = tbGuildData[tostring(copyId)].va_gc.membHiDamageList
	logger:debug(tbHitData)

	if (not tbHitData) then 
		return {} 
	end 

	local tbData = {}
	for k,v in pairs(tbHitData) do 
		table.insert(tbData,v)
	end 

	local function fnSort( a,b )
		return tonumber(a.hp) > tonumber(b.hp)
	end

	table.sort(tbData,fnSort)
	logger:debug(tbData)

	return tbData

end

