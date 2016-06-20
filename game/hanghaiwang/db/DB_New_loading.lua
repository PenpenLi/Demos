-- Filename: DB_New_loading.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_New_loading", package.seeall)

keys = {
	"id", "heroid", 
}

New_loading = {
	id_1 = {1, 10031, },
	id_2 = {2, 10017, },
	id_3 = {3, 10019, },
	id_4 = {4, 10023, },
	id_5 = {5, 10024, },
	id_6 = {6, 10025, },
	id_7 = {7, 10026, },
	id_8 = {8, 10027, },
	id_9 = {9, 10030, },
	id_10 = {10, 10034, },
	id_11 = {11, 10035, },
	id_12 = {12, 10041, },
	id_13 = {13, 10052, },
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
	local id_data = New_loading["id_" .. key_id]
	assert(id_data, "New_loading not found " ..  key_id)
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
	for k, v in pairs(New_loading) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_New_loading"] = nil
	package.loaded["DB_New_loading"] = nil
	package.loaded["db/DB_New_loading"] = nil
end

