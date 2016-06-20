-- Filename: DB_Legion_copy.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Legion_copy", package.seeall)

keys = {
	"id", "expId", "levelRatio", "teamCopy", "limitNum", 
}

Legion_copy = {
	id_1 = {1, 2004, 100, "1|400102,3|400103,5|400104,7|400105,9|400106,10|400107,11|400108,12|400109,13|400110,14|400111", 2, },
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
	local id_data = Legion_copy["id_" .. key_id]
	assert(id_data, "Legion_copy not found " ..  key_id)
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
	for k, v in pairs(Legion_copy) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Legion_copy"] = nil
	package.loaded["DB_Legion_copy"] = nil
	package.loaded["db/DB_Legion_copy"] = nil
end

