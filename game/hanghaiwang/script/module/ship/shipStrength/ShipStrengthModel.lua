-- FileName: ShipStrengthModel.lua
-- Author: LvNanchun
-- Date: 2015-10-19
-- Purpose: function description of module
--[[TODO List]]

module("ShipStrengthModel", package.seeall)
require "script/module/ship/ShipData"

-- UI variable --

-- module local variable --
local _allShipInfo
local _nowShip
local _dbShipInfo
local _dbShipItemInfo

local function init(...)

end

function destroy(...)
    package.loaded["ShipStrengthModel"] = nil
end

function moduleName()
    return "ShipStrengthModel"
end

function create(...)

end

function setNowShipId( shipId )
	_nowShip = shipId
	_dbShipInfo = ShipData.getShipInfoById(shipId)
	_dbShipItemInfo = ShipData.getShipItemInfoById(shipId)
end

function getShipId(  )
	return _nowShip
end

function setStrengthInfo( )
	_allShipInfo = ShipData.getAllShipInfo()
end

function getStrengthLevel()
	assert(_allShipInfo.strengthShipInfo[_nowShip], "ship did not activate")
	return tonumber(_allShipInfo.strengthShipInfo[_nowShip].strengthen_level)
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function splitAttrStr( attrStr )
	assert(attrStr, "配置属性加成字符串为空")

	local tbAttr = {}

	local tbStr = string.split(attrStr, ",")
	for k,v in pairs(tbStr) do 
		local tbData = string.split(v, "|")

		tbAttr[tonumber(tbData[1])] = tonumber(tbData[2])
	end

	return tbAttr
end

function getAttrInfoByLevel( strengthLevel )
	local attrInfo = {}
	local awakeAttr = _dbShipInfo.str_awake

	attrInfo = ShipData.getShipAttrByShipIdAndStrLevel(_nowShip, strengthLevel)

	attrInfo.name = _dbShipInfo.name
	attrInfo.quality = _dbShipInfo.quality

	if (awakeAttr) then
		local tbCache = splitAttrStr(awakeAttr)
		for k,v in pairs(tbCache) do
			if (k == strengthLevel) then
				local abilityInfo = ShipData.getShipAbilityById(v)
				logger:debug({abilityInfo = abilityInfo})
				attrInfo.awakeInfo = abilityInfo
			end
		end
	end

	attrInfo.attrName = {}
	for i = 1,5 do
		attrInfo.attrName[i] = ShipData.getAffixInfoById(i).displayName .. "："
	end

	logger:debug({attrInfo = attrInfo})
	return attrInfo
end

function getStrItemByLevel( strengthLevel )
	local tbStrItem = {}

	tbStrItem.belly = tonumber(string.split(_dbShipInfo.str_belly_fee, "|")[strengthLevel + 1])
	local itemStr = string.split(_dbShipInfo.str_item_fee, ",")[strengthLevel + 1]
	local tbItem = string.split(itemStr, "|")
	tbStrItem.itemNeedNum = tonumber(tbItem[2])
	require "script/module/public/ItemUtil"
	tbStrItem.item = ItemUtil.getItemById(tonumber(tbItem[1]))
--	tbStrItem.button = ItemUtil.createBtnByItemAndNum(tbStrItem.item , tbStrItem.itemNum)
--	tbStrItem.button = ItemUtil.createBtnByTemplateIdAndNumber(tonumber(tbItem[1]))
	tbStrItem.button = ItemUtil.createBtnByItem(tbStrItem.item)
	tbStrItem.itemHaveNum = tonumber(ItemUtil.getNumInBagByTid(tonumber(tbItem[1])))

	logger:debug({tbStrItem = tbStrItem})
	return tbStrItem
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getNameImage()
	return "images/ship/ship_name/ship" .. tostring(_nowShip) .. "_name.png"
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getShipAniNumber( )
	return _dbShipInfo.home_graph
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getStrLevelLimit( )
	return tonumber(_dbShipInfo.str_limit)
end