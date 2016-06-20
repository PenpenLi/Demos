-- Filename: DB_Recharge_welfare.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Recharge_welfare", package.seeall)

keys = {
	"id", "array", "original_cost", "discount_price", "recharge_day", 
}

Recharge_welfare = {
	id_1 = {1, "1|0|50000", 100, 5, 0, },
	id_2 = {2, "7|10032|2", 100, 50, 1, },
	id_3 = {3, "1|0|200000", 200, 20, 2, },
	id_4 = {4, "7|60002|150", 300, 50, 3, },
	id_5 = {5, "7|440001|10", 200, 50, 4, },
	id_6 = {6, "7|60504|10", 500, 50, 5, },
	id_7 = {7, "7|500002|10", 600, 50, 6, },
	id_8 = {8, "7|104412|1", 2000, 1, 7, },
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
	local id_data = Recharge_welfare["id_" .. key_id]
	assert(id_data, "Recharge_welfare not found " ..  key_id)
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
	for k, v in pairs(Recharge_welfare) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Recharge_welfare"] = nil
	package.loaded["DB_Recharge_welfare"] = nil
	package.loaded["db/DB_Recharge_welfare"] = nil
end

