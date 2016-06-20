-- FileName: AdBatlleEventModel.lua
-- Author: liweidong
-- Date: 2015-04-02
-- Purpose: 战斗事件model
--[[TODO List]]

module("AdBatlleEventModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local battleType=1 --战斗类型 1 继承血量 2非继承血量

local function init(...)

end

function destroy(...)
	package.loaded["AdBatlleEventModel"] = nil
end

function moduleName()
    return "AdBatlleEventModel"
end

function create(...)

end


--获取当前第几次重置战斗 
function getBuyTimes(eventInfo)
	return eventInfo.boss.num+1
end
--获取今日还可购买 重置战斗  的次数
function getBuyTimesRemainNum(eventInfo)
	local db=DB_Exploration_things.getDataById(eventInfo.etid)
	if (db.resettingCost==nil) then --不配置的情况下不能重置
		return 0
	end
	local costs = lua_string_split(db.resettingCost, ",")
	local allnumStr = costs[#costs]
	local item = lua_string_split(allnumStr,"|")
	local allnum=tonumber(item[1])
	local canbuyTimes=allnum-getBuyTimes(eventInfo)+1
	return canbuyTimes 
end
--这个方法保留 不要删除注视 当时要求专门写的另一种计算次数所需金币的方法，向后取金币
-- --获取当前购买 重置战斗 所需金币
-- function getBuyTimesGold(eventInfo)
-- 	local buyTimes = getBuyTimes(eventInfo)
-- 	local db=DB_Exploration_things.getDataById(eventInfo.etid)
	
-- 	local c_price = 0
-- 	if db.resettingCost then
-- 		local per_arr = string.split(db.resettingCost, ",")
-- 		local tmp1 = string.split(per_arr[#per_arr], "|")
-- 		local prekey,preval = tonumber(tmp1[1]),tonumber(tmp1[2]) --保存最大所需金币
-- 		c_price=preval
-- 		for _,val in pairs(per_arr) do
-- 			local tmp = string.split(val, "|")
-- 			if (tonumber(buyTimes)<=tonumber(tmp[1])) then
-- 				c_price = tonumber(tmp[2])
-- 				break
-- 			end
-- 		end
-- 	end
-- 	return tonumber(c_price)
-- end

--获取当前购买 增加战斗次数 所需金币
function getBuyTimesGold(eventInfo)
	local buyTimes = getBuyTimes(eventInfo)
	local db=DB_Exploration_things.getDataById(eventInfo.etid)
	
	local c_price = 0
	if db.resettingCost then
		local per_arr = string.split(db.resettingCost, ",")
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

--设置boss血量
function setBossBlood(eventInfo,min,max)
	eventInfo.boss.currHp=min
	eventInfo.boss.maxHp=max
end
--重置一次战斗
function resetBattle(eventInfo)
	eventInfo.boss.num=eventInfo.boss.num+1
	eventInfo.boss.currHp=0
	eventInfo.boss.maxHp=0
end
--设置当前战斗类型
function setBattleType(btType)
	battleType=btType
end
--战斗模块回调方法
function onBattleResult(data)
	if (battleType==1) then
		return AdBattleEventCtrl.onBattleResult(data)
	else
		return AdBattleSingleEventCtrl.onBattleResult(data)
	end
end