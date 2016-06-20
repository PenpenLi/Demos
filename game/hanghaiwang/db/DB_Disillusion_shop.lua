-- Filename: DB_Disillusion_shop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Disillusion_shop", package.seeall)

keys = {
	"id", "goodsnum", "gold", "item", "cdtime", 
}

Disillusion_shop = {
	id_1 = {1, 6, "1|20", 60006, 7200, },
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
	local id_data = Disillusion_shop["id_" .. key_id]
	assert(id_data, "Disillusion_shop not found " ..  key_id)
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
	for k, v in pairs(Disillusion_shop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Disillusion_shop"] = nil
	package.loaded["DB_Disillusion_shop"] = nil
	package.loaded["db/DB_Disillusion_shop"] = nil
end

