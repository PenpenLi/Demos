-- FileName: GCItemModel.lua
-- Author: liweidong
-- Date: 2015-06-04
-- Purpose: 据点model
--[[TODO List]]

module("GCItemModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["GCItemModel"] = nil
end

function moduleName()
    return "GCItemModel"
end

function create(...)

end

--返回一个副本是否在攻打时间范围内，并返回两个范围时间字符串
function getCopyAttackTimeInfo()
	local time = TimeUtil.getSvrTimeByOffset()
	local format = "%H%M%S"
    local pei = tonumber(TimeUtil.getLocalOffsetDate(format,time) ) 

    local copyDb=DB_Legion_copy_build.getDataById(1)
	local mysteryInfo = lua_string_split(copyDb.forbid_time, "|")
	local endtime 		=   mysteryInfo[2]
    local start   		=   mysteryInfo[1]
    local isCanAttack = true
    if((pei >= tonumber(start))  and  (tonumber(endtime) >= pei)) then
		isCanAttack = false
	end

	local function convertToTimeStr(timenum)
		local h = math.modf(timenum/10000)
		local m = math.modf(timenum/100)%100
		local s = timenum%100
		h = h<10 and "0"..h or h
		m = m<10 and "0"..m or m
		s = s<10 and "0"..s or s
		return h .. ":" .. m --.. ":" .. s
	end
	return isCanAttack,convertToTimeStr(start),convertToTimeStr(endtime)
end
--返回据点进度信息 -1 不可攻打 ，>=0 & <100 当前据点，100 已阵亡
function getStrongHoldStatus(copyId,holdId)
	local guildCopyInfo = DataCache.getGuildCopyData()
	local item = guildCopyInfo[""..copyId]
	if (item==nil) then
		return -1
	end
	if (tonumber(item.status)==2) then
		return 100 --已经通关
	end
	local baseOff = getBaseOffsetOfCopy(copyId,holdId)
	logger:debug("bass offset:" .. baseOff)
	if (item.va_gc.curBaseInfo.id==nil) then
		if (baseOff==1) then
			return 0
		else
			return -1
		end
	end
	logger:debug(item.va_gc.curBaseInfo.id+1)
	if (baseOff<item.va_gc.curBaseInfo.id+1) then
		return 100
	elseif (baseOff==item.va_gc.curBaseInfo.id+1) then
		if (item.baseRate==nil) then
			return 0
		end
		local percent = item.baseRate/10000*100
		return percent-percent%1 --取整
	else
		return -1
	end
end
--返回据点在副本的偏移位置
function getBaseOffsetOfCopy(copyId,holdId)
	require "db/DB_Legion_newcopy"
	local copyInfo=DB_Legion_newcopy.getDataById(copyId)
	for i=1,30 do
		local fieldName = "base"..i
		local baseId = copyInfo[fieldName]
		if (baseId~=nil and tonumber(baseId)==tonumber(holdId)) then
			return i
		end
	end
	return 0
end
--返回剩余挑战次数
function getAtackNum()
	local data = DataCache.getGuildCopyBaseData()
	require "db/DB_Legion_copy_build"
	local guildDb=DB_Legion_copy_build.getDataById(1)
	return guildDb.challenge_times+getBuyTimes()-1-data.atked_num
end
--获取当前第几次购买战斗次数 
function getBuyTimes()
	local data = DataCache.getGuildCopyBaseData()
	return data.buy_atk_num+1
end
--获取今日还可购买 增加战斗次数  的次数
function getBuyTimesRemainNum()
	local dbVip = DB_Vip.getDataById(UserModel.getVipLevel())
	local allnum=tonumber(dbVip.buy_lcopy_times)
	local canbuyTimes=allnum-getBuyTimes(id)+1
	if (canbuyTimes<0) then
		canbuyTimes=0
	end
	return canbuyTimes 
end
--获取当前购买 增加战斗次数 所需金币
function getBuyTimesGold()
	local buyTimes = getBuyTimes()
	local db=DB_Legion_copy_build.getDataById(1)
	local c_price = 0
	if db.buy_times_gold then
		local per_arr = string.split(db.buy_times_gold, ",")
		local tmp1 = string.split(per_arr[1], "|")
		local prekey,preval = tonumber(tmp1[1]),tonumber(tmp1[2])
		for _,val in pairs(per_arr) do
			local tmp = string.split(val, "|")
			if (tonumber(buyTimes)<tonumber(tmp[1]) and tonumber(buyTimes)>=prekey) then
				c_price = preval
				break
			end
			prekey,preval = tonumber(tmp[1]),tonumber(tmp[2])
			c_price = preval --大于等于最大次数情况 和 只填写第一次的情况
		end
	end
	return tonumber(c_price)
end
function getMaxBuyTimes()
	local dbVip = DB_Vip.getDataById(UserModel.getVipLevel())
	local allnum=tonumber(dbVip.buy_lcopy_times)
	return allnum
end
function getNextMaxBuyTimes()
	if(UserModel.getVipLevel() >= table.count(DB_Vip.Vip)) then
		return getMaxBuyTimes()
	else
		local dbVip = DB_Vip.getDataById(UserModel.getVipLevel()+1)
		local allnum=tonumber(dbVip.buy_lcopy_times)
		return allnum
	end
end
--增加一次战斗次数 isBuyTimes是否是购买的次数
function addBattleTimes()
	local data = DataCache.getGuildCopyBaseData()
	-- data.atked_num = data.atked_num+1
	data.buy_atk_num = data.buy_atk_num+1
end
--使用一次战斗次数
function subBattleTimes()
	local data = DataCache.getGuildCopyBaseData()
	data.atked_num = data.atked_num+1
end

