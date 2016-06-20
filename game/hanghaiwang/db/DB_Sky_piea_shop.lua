-- Filename: DB_Sky_piea_shop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Sky_piea_shop", package.seeall)

keys = {
	"id", "cd", "goldGost", "refresh", "item", 
}

Sky_piea_shop = {
	id_1 = {1, "090000,120000,180000,210000", "1|10,10|20,20|40,50|80", 20, nil, },
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
	local id_data = Sky_piea_shop["id_" .. key_id]
	assert(id_data, "Sky_piea_shop not found " ..  key_id)
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
	for k, v in pairs(Sky_piea_shop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Sky_piea_shop"] = nil
	package.loaded["DB_Sky_piea_shop"] = nil
	package.loaded["db/DB_Sky_piea_shop"] = nil
end

