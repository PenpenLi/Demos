-- Filename: DB_Rand_box.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Rand_box", package.seeall)

keys = {
	"id", "need_item", "need_gold", "dropid", 
}

Rand_box = {
	id_2 = {2, 30012, "1|20,2|25,4|30,6|40,10|50,14|60", 12, },
	id_3 = {3, 30013, "1|50,3|60,5|80,9|100,13|120,17|140,21|160", 13, },
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
	local id_data = Rand_box["id_" .. key_id]
	assert(id_data, "Rand_box not found " ..  key_id)
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
	for k, v in pairs(Rand_box) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Rand_box"] = nil
	package.loaded["DB_Rand_box"] = nil
	package.loaded["db/DB_Rand_box"] = nil
end

