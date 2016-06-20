-- Filename: DB_Treasure_sale.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Treasure_sale", package.seeall)

keys = {
	"id", "activity_icon", "activity_name", "activity_title", "goods_list", 
}

Treasure_sale = {
	id_1 = {1, "icon_copy.png", "challenge_copy.png", "title_copy.png", "501301|80|100|99|3;501401|85|100|50|6;501402|80|200|0|10;501501|75|100|0|0;", },
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
	local id_data = Treasure_sale["id_" .. key_id]
	assert(id_data, "Treasure_sale not found " ..  key_id)
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
	for k, v in pairs(Treasure_sale) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Treasure_sale"] = nil
	package.loaded["DB_Treasure_sale"] = nil
	package.loaded["db/DB_Treasure_sale"] = nil
end

