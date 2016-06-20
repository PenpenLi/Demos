-- Filename: DB_Exclusiveshop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Exclusiveshop", package.seeall)

keys = {
	"id", "goodsnum", "gold", "item", "cdtime", 
}

Exclusiveshop = {
	id_1 = {1, 8, "1|20", 60006, 7200, },
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
	local id_data = Exclusiveshop["id_" .. key_id]
	assert(id_data, "Exclusiveshop not found " ..  key_id)
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
	for k, v in pairs(Exclusiveshop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Exclusiveshop"] = nil
	package.loaded["DB_Exclusiveshop"] = nil
	package.loaded["db/DB_Exclusiveshop"] = nil
end

