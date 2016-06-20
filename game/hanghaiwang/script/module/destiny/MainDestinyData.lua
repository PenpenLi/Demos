-- FileName: MainDestinyData.lua
-- Author: lizy
-- Date: 2014-04-00
-- Purpose: 天命模块的数据封装
--[[TODO List]]


--服务器返回的主船信息
-- 主船信息 tbDestinyInfo
-- cur_ship = "1"	当前主船id
-- cur_break = "0"  当前改造id
-- left_score = "3"   副本剩余星数
-- va_ship = {
--  	‘all’    所有主船id
--  	{
-- 		shipId   主船id
--  	}
-- }


module("MainDestinyData", package.seeall)

require "db/DB_Destiny"
require "db/DB_Affix"

-- UI控件引用变量 --

-- 模块局部变量 --
local destroyInfo = nil
local nextDesiyny
local tbDestinyInfo   --主船信息
local tbDestinyBaseInfo
--突破增加的属性
local Hp = 0         --生命
local phyAtt = 0     --物攻
local phyDef = 0     --物防
local magAtt = 0     --魔攻
local magDef = 0     --魔防

local isBreak = false

local function init(...)

end

function destroy(...)
	package.loaded["MainDestinyData"] = nil
end

function moduleName()
	return "MainDestinyData"
end

function create(...)

end

function getIsBreak( ... )
	return isBreak
end

function setIsBreak( _isBreak )
	isBreak = _isBreak
end

function setDestinyBaseInfo( _baseInfo )
	tbDestinyBaseInfo = _baseInfo
end

function getDestinyBaseInfo(  )
	return tbDestinyBaseInfo
end

function setDestinyInfo( _tbInfo )
	tbDestinyInfo = _tbInfo

	if (nextDesiyny == nil) then
		nextDesiyny = tonumber(tbDestinyInfo.cur_break) +1
		local pNum = table.count(DB_Destiny.Destiny)
		if (nextDesiyny > pNum) then
			nextDesiyny = pNum
		end
	end
end

--获取当前主船id
function getCurShip(  )

	return tbDestinyInfo.cur_ship
end

function setCurShip(newShipid )

	tbDestinyInfo.cur_ship = newShipid
end

function getDestinyInfo(  )
	return tbDestinyInfo
end

function getNextDestinyId(   )
	return nextDesiyny
end

function setNextDestinyId(  )
	nextDesiyny = nextDesiyny + 1
	local pNum = table.count(DB_Destiny.Destiny)
	if (nextDesiyny > pNum) then
		nextDesiyny = pNum
	end
end

function changeCopyStar( num )
	tbDestinyInfo.left_score = tbDestinyInfo.left_score - num
end

function  getNextDestiny( ... )
	return getDestinyById(getNextDestinyId())
end

function getDestinyById( id )
	destroyInfo = DB_Destiny.getDataById(id)
	return destroyInfo
end

--根据affixID计算增加的属性
function getAffix(affixID)
	local data  = DB_Affix.getDataById(affixID)
	return  data
end

-- 判断本次天命表里的是否为空
function isBreak( )
	local isBreak = false
	local destinyData = DB_Destiny.getDataById(getNextDestinyId()) or nil
	local breakData = nil
	if (destinyData== nil) then
		return false
	end
	if (destinyData.isBreak) then
		isBreak= true
	end
	return isBreak
end

function upDestiny( ... )
	destroyInfo = DB_Destiny.getDataById(nextDesiyny)
	return destroyInfo
end

function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end


--[[
得到还需要修炼多少次可突破
n :n次突破
－1:没有找到下一次突破
]]
function getTimeForBreak( ... )
	local time = -1
	local isHaveBreak = false

	if (tbDestinyInfo.cur_break == 0) then
		tbDestinyInfo.cur_break = 1
	end
	
	local index = nextDesiyny
	local data 
	time = 1
	local tabLength = table.nums(DB_Destiny.Destiny)
	while index <= tabLength do 
		data = DB_Destiny.getDataById(index)
		if data == nil then
			break
		end 
		
		if data.isBreak ~= nil and tonumber(data.isBreak) ~= 0 then
			isHaveBreak = true
			break
		end 
		time = time +1
		index = index +1
	end 		

	if not isHaveBreak then 
		return -1
	end 

	return time
end

--多少次前 达到的突破
function getTimeForBreaks( ... )
	local res = 0
	-- local time = 0

	if (tbDestinyInfo.cur_break == 0) then
		tbDestinyInfo.cur_break = 1
	end

	local index = tonumber(tbDestinyInfo.cur_break) 
	while index > 0 do
		local data = DB_Destiny.getDataById(index)
		if data.isBreak ~= nil and tonumber(data.isBreak) ~= 0 then
			res = 1
			break
		end 
		-- time = time + 1 
		index = index - 1
	end 
	return res
end

--初始化 到当前突破等级增加的属性和
function initBaseInfo( )
	firstBaseInfoInit() --初始化属性值

	if (tbDestinyInfo.cur_break ~= 0) then
		local preDestiny = nextDesiyny - 1
		while(preDestiny > 0) do 
			local destinyData = DB_Destiny.getDataById(preDestiny)
			local attArr = string.split(destinyData.attArr, ",") --取到属性值
			local tableLength = table.getn(attArr)
			for index=1, tonumber(tableLength) do 
				local attArrs = string.split(attArr[index], "|")
				setBaseInfoOfper(attArrs[1], attArrs[2])
			end 
			preDestiny = destinyData.destinyId - 1
		end 
	end
	return tbDestinyBaseInfo
end

function firstBaseInfoInit( ... )
	Hp =0
	phyAtt=0
	phyDef=0
	magDef=0
	magAtt=0
end

--翻译增加了什么值
function setBaseInfoOfper(affixID , value )
	if tonumber(affixID)  == 1  then
		Hp = Hp + value
	elseif tonumber(affixID) == 2  then
		phyAtt = phyAtt + value
	elseif tonumber(affixID) == 4  then
		phyDef = phyDef + value
	elseif tonumber(affixID) == 5  then
		magDef =  magDef + value
	elseif tonumber(affixID) == 3  then
		magAtt =  magAtt + value
	end
end

--生命
function getHp( ... )
	local name = MainDestinyData.getAffix(1)
	local res = 0

	if tonumber(name.type) == 2 then
		res = Hp / 100
	else
		res = Hp
	end
	return res
end

--物攻
function getPhyAttack( ... )
    local name = MainDestinyData.getAffix(2)
	local res  = 0

	if tonumber(name.type) == 2 then
		res = phyAtt / 100
	else
		res = phyAtt
	end
	return res  	
end        

--物防
function getPhyDefend( ... )
	local name = MainDestinyData.getAffix(4)
	local res = 0

	if tonumber(name.type) == 2 then
		res = phyDef / 100
	else
		res = phyDef
	end
	return res
end

--魔攻
function getMagAttack( ... )
	local name = MainDestinyData.getAffix(3)
	local res = 0

	if tonumber(name.type) == 2 then
		res = magAtt / 100
	else
		res = magAtt
	end
	return res
end

--魔防
function getMagDefend( ... )
	local name = MainDestinyData.getAffix(5)
	local res  = 0

	if tonumber(name.type) == 2 then
		res = tonumber(magDef) / 100
	else
		res = magDef
	end
	return res
end



