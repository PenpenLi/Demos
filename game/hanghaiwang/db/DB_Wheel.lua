-- Filename: DB_Wheel.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Wheel", package.seeall)

keys = {
	"id", "lv_limit", "last_day", "total_times", "cost_1", "max_gain_1", "cost_2", "max_gain_2", "cost_3", "max_gain_3", "cost_4", "max_gain_4", "cost_5", "max_gain_5", "cost_6", "max_gain_6", 
}

Wheel = {
	id_1 = {1, 5, 2, 4, 300, "338|0,358|0,388|10000,428|0,488|0,588|0,688|0", 688, "758|10000,818|0,858|0,898|0,928|0,958|0,998|0", 1688, "1738|0,1788|0,1818|0,1888|10000,2088|0,2188|0,2288|0", 2588, "2638|0,2688|0,2738|0,2788|0,2838|0,2858|0,2888|10000", nil, nil, nil, nil, },
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
	local id_data = Wheel["id_" .. key_id]
	assert(id_data, "Wheel not found " ..  key_id)
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
	for k, v in pairs(Wheel) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Wheel"] = nil
	package.loaded["DB_Wheel"] = nil
	package.loaded["db/DB_Wheel"] = nil
end

