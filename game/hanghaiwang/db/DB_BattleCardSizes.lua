-- Filename: DB_BattleCardSizes.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_BattleCardSizes", package.seeall)

keys = {
	"id", "level", "width", "height", 
}

BattleCardSizes = {
	id_1 = {1, 1, 135, 169, },
	id_2 = {2, 2, 198, 251, },
	id_3 = {3, 3, 313, 402, },
	id_4 = {4, 4, 630, 480, },
}

local mt = {}
mt.__index = function (table, key)
	for i = 1, #keys do
		if (keys[i] == key) then
			return table[i]
		end
	end
end

function getDataById(key_id)
	local id_data = BattleCardSizes["id_" .. key_id]
	assert(id_data, "BattleCardSizes not found " ..  key_id)
	if id_data == nil then
		return nil
	end
	if getmetatable(id_data) ~= nil then
		return id_data
	end
	setmetatable(id_data, mt)

	return id_data
end

function getArrDataByField(fieldName, fieldValue)
	local arrData = {}
	local fieldNo = 1
	for i=1, #keys do
		if keys[i] == fieldName then
			fieldNo = i
			break
		end
	end
	for k, v in pairs(BattleCardSizes) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_BattleCardSizes"] = nil
	package.loaded["DB_BattleCardSizes"] = nil
	package.loaded["db/DB_BattleCardSizes"] = nil
end

