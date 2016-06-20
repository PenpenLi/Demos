-- Filename: DB_Game_book_type.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Game_book_type", package.seeall)

keys = {
	"id", "name", "hero_id", 
}

Game_book_type = {
	id_1 = {1, "突破", "50031|50020|50016|50085|50076|50018|50038|50029|50073|50043|50014|50086|50072|50063|50015|50061|50101|50060|50022|50042|50064", },
	id_2 = {2, "肉盾", "10017|50031|10033|50061|10040", },
	id_3 = {3, "输出", "10026|10024|10052|10035|10030|10032", },
	id_4 = {4, "鼓舞", "50016|50101|10041|50043|50073", },
	id_5 = {5, "控制", "10017|10019|10026|10025|50038", },
	id_6 = {6, "辅助", "10034|50022|50085|50015|50020", },
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
	local id_data = Game_book_type["id_" .. key_id]
	assert(id_data, "Game_book_type not found " ..  key_id)
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
	for k, v in pairs(Game_book_type) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Game_book_type"] = nil
	package.loaded["DB_Game_book_type"] = nil
	package.loaded["db/DB_Game_book_type"] = nil
end

