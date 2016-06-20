-- Filename: DB_Game_book_formation.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Game_book_formation", package.seeall)

keys = {
	"id", "name", "hero_id", 
}

Game_book_formation = {
	id_1 = {1, "暴力输出队", "10030|10052|10024|10027|10026", },
	id_2 = {2, "灼烧队", "10035|50018|50014|10021|10077", },
	id_3 = {3, "毒伤队", "10023|50020|50022|10065", },
	id_4 = {4, "控制队", "10017|10019|10026|10025|50038", },
	id_5 = {5, "减怒队", "50020|50029|10033|50015|10034", },
	id_6 = {6, "美女队", "10025|50015|50020|50029|50038", },
	id_7 = {7, "回复队", "10034|50031|50015|50061|10030", },
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
	local id_data = Game_book_formation["id_" .. key_id]
	assert(id_data, "Game_book_formation not found " ..  key_id)
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
	for k, v in pairs(Game_book_formation) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Game_book_formation"] = nil
	package.loaded["DB_Game_book_formation"] = nil
	package.loaded["db/DB_Game_book_formation"] = nil
end

