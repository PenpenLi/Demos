-- Filename: DB_Pet_cost.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Pet_cost", package.seeall)

keys = {
	"id", "feed_critRatio", "feed_critweight", "gold_cost", "gold_exp", "gold_critRatio", "gold_critweight", 
}

Pet_cost = {
	id_1 = {1, 1000, "20000|6000,30000|3000,40000|1000", 10, 100, 2500, "20000|6000,30000|3000,40000|1000", },
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
	local id_data = Pet_cost["id_" .. key_id]
	assert(id_data, "Pet_cost not found " ..  key_id)
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
	for k, v in pairs(Pet_cost) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Pet_cost"] = nil
	package.loaded["DB_Pet_cost"] = nil
	package.loaded["db/DB_Pet_cost"] = nil
end

