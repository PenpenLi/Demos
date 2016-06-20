-- Filename: DB_Tower.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Tower", package.seeall)

keys = {
	"id", "times", "cost", "loseTimes", "loseTimeGold", "wipeCd", "wipeCost", "passOpen", 
}

Tower = {
	id_1 = {1, 3, "0,150,500", 2, "10,20,30", 30, 1, "20,45", },
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
	local id_data = Tower["id_" .. key_id]
	assert(id_data, "Tower not found " ..  key_id)
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
	for k, v in pairs(Tower) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Tower"] = nil
	package.loaded["DB_Tower"] = nil
	package.loaded["db/DB_Tower"] = nil
end

