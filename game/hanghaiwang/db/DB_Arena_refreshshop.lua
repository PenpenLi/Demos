-- Filename: DB_Arena_refreshshop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Arena_refreshshop", package.seeall)

keys = {
	"id", "goodsnum", "gold", "item", "settlegoods", 
}

Arena_refreshshop = {
	id_1 = {1, 3, "1|10,5|50,10|100", 60319, "3|4|5", },
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
	local id_data = Arena_refreshshop["id_" .. key_id]
	assert(id_data, "Arena_refreshshop not found " ..  key_id)
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
	for k, v in pairs(Arena_refreshshop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Arena_refreshshop"] = nil
	package.loaded["DB_Arena_refreshshop"] = nil
	package.loaded["db/DB_Arena_refreshshop"] = nil
end

