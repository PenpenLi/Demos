-- FileName: MainDestinyShipData.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]
--主船模版数据


---主船模版字段
--[[
id 主船ID
name 名字
attr 属性增加
home_graph  主页中主船形象
ship_graph  主船改造主船形象
explore_graph 探索主船形象
arena_graph 竞技场主船形象
grab_graph 夺宝主船形象
]]


module("MainDestinyShipData", package.seeall)

-- UI控件引用变量 --

require "db/DB_Ship"
require "script/module/destiny/MainDestinyData"

-- 模块局部变量 --

local tbShipInfo  --主船数据
--主船增加的属性
local nCurShipid  --当前主船ID
local Hp = 0         --生命
local phyAtt = 0     --物攻
local phyDef = 0     --物防
local magAtt = 0     --魔攻
local magDef = 0     --魔防


local function init(...)

end

function destroy(...)
	package.loaded["MainDestinyShipData"] = nil
end

function moduleName()
    return "MainDestinyShipData"
end

function create(...)

end

--主船配置表id
function setShipId( id )
	nCurShipid = id 
end

--读取主船配置信息
function setShipInfo( )
	tbShipInfo = DB_Ship.getDataById(nCurShipid)
end

function getShipInfo( )
	return tbShipInfo
end

function getShipname( ... )
	return tbShipInfo.name
end

function getNextShipName( ... )
	local getnums = table.count
	local length = getnums(DB_Ship.Ship)
	if tonumber(nCurShipid) < length then 
		local data = DB_Ship.getDataById(nCurShipid + 1)
		return data.name
	else 
		return nil
	end 
end

function getHomeGraph( ... )
	return tbShipInfo.home_graph
end

function getShipGraph( ... )
	return tbShipInfo.ship_graph
end

function getExploreGraph( ... )
	return tbShipInfo.explore_graph
end

--主船增加的属性初始化
function initShipBaseAttr( )
	Hp = 0
	phyAtt = 0
	phyDef = 0
	magDef = 0
	magAtt = 0
end

--主船增加的基本属性
function setShipBaseAttr( )

	initShipBaseAttr()

	local attArr = string.split(tbShipInfo.attr, ",") 
	for i=1, #attArr do
		local propertyTable = lua_string_split(attArr[i],"|")
		addBaseShipAttr(propertyTable[1],propertyTable[2])
	end
end

function addBaseShipAttr(affixID , value )
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

-- 生命
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

-- 物防
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

-- 魔攻
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




