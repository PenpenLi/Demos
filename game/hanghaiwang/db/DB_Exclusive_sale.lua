-- Filename: DB_Exclusive_sale.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Exclusive_sale", package.seeall)

keys = {
	"id", "activity_icon", "activity_name", "activity_title", "goods_list", 
}

Exclusive_sale = {
	id_1 = {1, "icon_copy.png", "challenge_copy.png", "title_copy.png", "700014|80|100|99|3;700015|85|100|50|6;700016|80|200|0|10;700017|75|100|0|0;", },
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
	local id_data = Exclusive_sale["id_" .. key_id]
	assert(id_data, "Exclusive_sale not found " ..  key_id)
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
	for k, v in pairs(Exclusive_sale) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Exclusive_sale"] = nil
	package.loaded["DB_Exclusive_sale"] = nil
	package.loaded["db/DB_Exclusive_sale"] = nil
end

