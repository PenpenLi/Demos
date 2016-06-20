-- Filename: DB_Vipsalary.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Vipsalary", package.seeall)

keys = {
	"vip_level", "reward", 
}

Vipsalary = {
	id_1 = {1, "1|0|10000", },
	id_2 = {2, "1|0|20000,7|60006|1", },
	id_3 = {3, "1|0|30000,7|60006|1,7|440001|1", },
	id_4 = {4, "1|0|40000,7|60006|1,7|440001|1,7|60002|5", },
	id_5 = {5, "1|0|50000,7|60006|1,7|440001|2,7|60002|5", },
	id_6 = {6, "1|0|60000,7|60006|2,7|440001|2,7|60002|5", },
	id_7 = {7, "1|0|70000,7|60006|2,7|440001|2,7|60002|10", },
	id_8 = {8, "1|0|80000,7|60006|2,7|440001|2,7|60503|2,7|60002|10", },
	id_9 = {9, "1|0|120000,7|60006|2,7|440001|2,7|60503|2,7|60002|10", },
	id_10 = {10, "1|0|130000,7|60006|2,7|440001|3,7|60503|2,7|60002|10", },
	id_11 = {11, "1|0|150000,7|60006|2,7|440001|3,7|60503|4,7|60002|10", },
	id_12 = {12, "1|0|200000,7|60006|2,7|440001|3,7|60503|4,7|60002|10", },
	id_13 = {13, "1|0|220000,7|60006|2,7|440001|3,7|60503|4,7|60002|15", },
	id_14 = {14, "1|0|240000,7|60006|2,7|440001|4,7|60503|4,7|60002|15", },
	id_15 = {15, "1|0|260000,7|60006|2,7|440001|4,7|60503|6,7|60002|15", },
	id_16 = {16, "1|0|280000,7|60006|3,7|440001|4,7|60503|6,7|60002|20", },
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
	local id_data = Vipsalary["id_" .. key_id]
	assert(id_data, "Vipsalary not found " ..  key_id)
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
	for k, v in pairs(Vipsalary) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Vipsalary"] = nil
	package.loaded["DB_Vipsalary"] = nil
	package.loaded["db/DB_Vipsalary"] = nil
end

