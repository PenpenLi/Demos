-- Filename: DB_Tavern_mystery.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Tavern_mystery", package.seeall)

keys = {
	"id", "week_hero", "cost", "luck_maxnum", "luck_basenum", 
}

Tavern_mystery = {
	id_1 = {1, "10019|1000", 488, 1000, 10, },
	id_2 = {2, "10034|1000", 488, 1000, 10, },
	id_3 = {3, "10035|1000", 488, 1000, 10, },
	id_4 = {4, "10036|1000", 488, 1000, 10, },
	id_5 = {5, "10025|1000", 488, 1000, 10, },
	id_6 = {6, "10019|1000", 488, 1000, 10, },
	id_7 = {7, "10034|1000", 488, 1000, 10, },
	id_8 = {8, "10035|1000", 488, 1000, 10, },
	id_9 = {9, "10036|1000", 488, 1000, 10, },
	id_10 = {10, "10025|1000", 488, 1000, 10, },
	id_11 = {11, "10019|1000", 488, 1000, 10, },
	id_12 = {12, "10034|1000", 488, 1000, 10, },
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
	local id_data = Tavern_mystery["id_" .. key_id]
	assert(id_data, "Tavern_mystery not found " ..  key_id)
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
	for k, v in pairs(Tavern_mystery) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Tavern_mystery"] = nil
	package.loaded["DB_Tavern_mystery"] = nil
	package.loaded["db/DB_Tavern_mystery"] = nil
end

