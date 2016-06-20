-- FileName: BondData.lua
-- Author: yucong
-- Date: 2015-07-23
-- Purpose: 羁绊数据类
--[[TODO List]]

module("BondData", package.seeall)

local _tbBondDatas = {}
local _tbOtherBondDatas = {}	-- 保存一个他们的羁绊信息

function setBondData( data )
	_tbBondDatas = handleDatas(data)
end

function getBondData( ... )
	return _tbBondDatas
end

function setOtherData( data )
	--_tbOtherBondDatas[tonumber(uid)] = data
	_tbOtherBondDatas = {}
	for k,v in pairs(data or {}) do
		_tbOtherBondDatas[tonumber(k)] = v
	end
end

function getOtherData( ... )
	return _tbOtherBondDatas
end

function handleDatas( data )
	return data
end

-- 羁绊是否开启
function isBondOpen_modelId( modelId, bid, isOther )
	local datasource = _tbBondDatas
	if (isOther == true) then
		datasource = _tbOtherBondDatas--[tonumber(uid)]
	end
	-- logger:debug(datasource)
	assert(datasource, "BondData datasource is null")
	local data = datasource[tonumber(modelId)]
	local state = 0
	for k, v in pairs(data or {}) do
		if (tonumber(v) == tonumber(bid)) then
			return true
		end
	end
	return false
end

-- 羁绊是否开启
-- 最终存入的key都是modelId，需要进行转换
function isBondOpen( htid, bid, isOther )
	local modelId = HeroModel.getHeroModelId(htid)
	return isBondOpen_modelId(modelId, bid, isOther)
end

function isBondCache( modelId )
	if (_tbBondDatas[tonumber(modelId)]) then
		return true
	end
	return false
end