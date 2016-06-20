-- FileName: ShipInfoModel.lua
-- Author: Xufei
-- Date: 2015-10-16
-- Purpose: 主船信息数据模块
--[[TODO List]]

module("ShipInfoModel", package.seeall)

require "script/module/ship/ShipData"
require "db/DB_Affix"
require "db/DB_Ship_ability"

-- UI控件引用变量 --

-- 模块局部变量 --
local _shipId = nil
local _shipStatus = {}						-- 后端传的船的状态，包括哪个是主船，激活了哪些船
local _shipInfo = {}						-- 船的信息，配置表
local _shipActivated = false				-- 是否拥有该船
local _shipStrengthenLevel = 0				-- 强化等级

local _shipStrengthenAttribute = {}			-- 强化属性
local _shipStrengthenTalent = {}			-- 强化天赋
local _shipActivatedAttribute = {}			-- 激活属性
local _shipIntroduce = nil 					-- 船的介绍

local function getIfShipActivatedById( shipId, shipInfo )
    local shipActivated = false
    local shipLv = 0
    for k,v in pairs (shipInfo) do
        if (k == shipId) then
            shipActivated = true
            shipLv = v.strengthen_level
            break
        end
    end
    return shipActivated, tonumber(shipLv)
end

-- 如果isFromFormation = true,则说明是从阵容获取到的主船信息，则shipInfo里是一个table，
-- 如果isFromFormation = false or nil,则是从本方主船获取的信息，shipInfo传入的是shipId
function updateShipInfoModel( shipInfo, isFromFormation )	
	if (not isFromFormation) then	
		_shipId = shipInfo
		_shipStatus = ShipData.getAllShipInfo()
		_shipInfo = ShipData.getShipInfoById(_shipId)
		_shipActivated, _shipStrengthenLevel = ShipData.getIfShipActivatedById(_shipId)
	else
		_shipId = shipInfo.main_ship
		_shipStatus = {}
		_shipStatus.nowShipId = shipInfo.main_ship
		_shipStatus.nShipNum = table.count(DB_Super_ship.Super_ship)
		_shipStatus.strengthShipInfo = shipInfo.ship
		_shipInfo = DB_Super_ship.getDataById(tonumber(_shipId))
		_shipActivated, _shipStrengthenLevel = getIfShipActivatedById(shipInfo.main_ship,shipInfo.ship )
	end
end

function getShipId( ... )
	return _shipId
end

function getIsActivited( ... )
	return _shipActivated
end

function getStrengthenLevel( ... )
	return _shipStrengthenLevel
end

function getShipName( ... )
	return _shipInfo.name
end

function getShipMaxLv( ... )
	return _shipInfo.str_limit
end

function getShipAniId( ... )
	return _shipInfo.home_graph
end

function getShipQuality( ... )
	return _shipInfo.quality
end

function getShipCannon( ... )
	local cannonBallId = _shipInfo.shell_id
	local cannonBallDB 
	local cannonInfo
	local cannonAttr
	local cannonLv
	if (cannonBallId) then
		cannonBallDB = DB_Ship_skill.getDataById(cannonBallId)
		cannonInfo = CannonModel.getCannonInfoByBallId( cannonBallId )
	end
	if (cannonInfo and cannonInfo == 0) then
		cannonLv = 0
		cannonAttr = ArmShipData.getCannonBallAttrByLel(cannonBallId)
		logger:debug({cannonAttr_0 = cannonAttr})
	else
		cannonLv = tonumber(cannonInfo[1])
		logger:debug({cannonLv = cannonLv})
		cannonAttr = ArmShipData.getCannonBallAttrByLel(cannonBallId,cannonLv)
		logger:debug({cannonAttr_not0 = cannonAttr})
	end
	return cannonAttr,cannonBallDB,cannonLv
end

-- 得到强化属性 -- 2015-12-01 主船的强化属性要加上主船的基本属性
function getStrengthenAttribute()
	local strAttr = _shipInfo.attr
	local tbAttr = lua_string_split(strAttr, ",")
	_shipStrengthenAttribute = {}

	for k,v in pairs(tbAttr) do
		local tb = {}
		local tbSingle = lua_string_split(v, "|")
		tb.attrId = tonumber(tbSingle[1])
		tb.attrValue = tonumber(tbSingle[2])

		local affix = DB_Affix.getDataById(tonumber(tbSingle[1]))
		tb.descName = affix.displayName .. "："
		

		table.insert(_shipStrengthenAttribute, tb)
	end
	table.sort(_shipStrengthenAttribute, function (a,b)
		return a.attrId < b.attrId
	end)

	local strAddAttr = _shipInfo.str_attr
	local tbAddAttr = lua_string_split(strAddAttr, ",")
	for k,v in ipairs (tbAddAttr) do
		local tbSingle = lua_string_split(v, "|")
		for k1,v1 in ipairs (_shipStrengthenAttribute) do
			if ( v1.attrId == tonumber(tbSingle[1]) ) then
				logger:debug({awgaewrhgaetht = v1.attrId })
				v1.attrValue = v1.attrValue + tonumber(tbSingle[2]) * tonumber(_shipStrengthenLevel)
				v1.descString = "+" .. tostring(v1.attrValue)
			end
		end
	end
	
	logger:debug({ _shipStrengthenAttribute = _shipStrengthenAttribute })
	return _shipStrengthenAttribute

end

-- 得到激活属性
function getActivatedAttribute()
	local actAttr = _shipInfo.activate_attr
	if (actAttr) then
		local tbAttr = lua_string_split(actAttr, ",")
		_shipActivatedAttribute = {}

		for k,v in pairs(tbAttr) do
			local tb = {}
			local tbSingle = lua_string_split(v, "|")
			tb.attrId = tonumber(tbSingle[1])
			tb.attrValue = tbSingle[2]

			local affix = DB_Affix.getDataById(tonumber(tbSingle[1]))
			tb.descName = affix.displayName .. "："
			tb.descString = "+" .. tb.attrValue

			table.insert(_shipActivatedAttribute, tb)
		end
		table.sort(_shipActivatedAttribute, function (a,b)
			return a.attrId < b.attrId
		end)
		
		logger:debug({ _shipActivatedAttribute = _shipActivatedAttribute })
		return _shipActivatedAttribute
	else
		return nil
	end
end

-- 得到强化天赋
function getStrengthenTalent( ... )
	local strTalent = _shipInfo.str_awake
	local tbTalent = lua_string_split(strTalent, ",")
	_shipStrengthenTalent = {}

	for k,v in pairs(tbTalent) do
		local tb = {}
		local tbSingle = lua_string_split(v, "|")

		local ability = DB_Ship_ability.getDataById(tonumber(tbSingle[2]))
		tb.title = ability.name
		tb.desc = ability.desc
		tb.attr = ability.attr

		if (tonumber(tbSingle[1])<=_shipStrengthenLevel) then
			tb.isAwake = true
		else
			tb.isAwake = false
		end
		tb.awakeLv = tonumber(tbSingle[1])
		tb.talent = tbSingle[2]
		table.insert(_shipStrengthenTalent, tb)
	end
	table.sort(_shipStrengthenTalent, function (a,b)
		return a.awakeLv < b.awakeLv
	end)

	logger:debug({ _shipStrengthenTalent = _shipStrengthenTalent })
	return _shipStrengthenTalent
end

-- 得到船的介绍
function getShipIntroduce()
	_shipIntroduce= _shipInfo.desc

	logger:debug({ _shipIntroduce = _shipIntroduce })
	return _shipIntroduce
end

------------------------------------
local function init(...)

end

function destroy(...)
	package.loaded["ShipInfoModel"] = nil
end

function moduleName()
    return "ShipInfoModel"
end

function create(...)

end
