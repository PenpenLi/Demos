-- Filename: DB_Nightmare_copy.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Nightmare_copy", package.seeall)

keys = {
	"id", "challenge_times", "buy_gold", 
}

Nightmare_copy = {
	id_1 = {1, 5, "1|50,2|100,3|150,4|200", },
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
	local id_data = Nightmare_copy["id_" .. key_id]
	assert(id_data, "Nightmare_copy not found " ..  key_id)
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
	for k, v in pairs(Nightmare_copy) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Nightmare_copy"] = nil
	package.loaded["DB_Nightmare_copy"] = nil
	package.loaded["db/DB_Nightmare_copy"] = nil
end

