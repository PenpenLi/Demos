-- Filename: DB_Arena_shop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Arena_shop", package.seeall)

keys = {
	"id", "items", "costPrestige", "sortType", "limitType", "baseNum", "isSold", "needLevel", "highest_rank", "highest_rank_display", 
}

Arena_shop = {
	id_1 = {1, "7|60002|50", 150, 1, 2, 1, 1, 0, 5000, 30000, },
	id_2 = {2, "3|0|100", 100, 2, 2, 1, 1, 0, 4000, 30000, },
	id_3 = {3, "7|102312|1", 100, 3, 2, 1, 1, 0, 3500, 30000, },
	id_4 = {4, "7|60502|20", 160, 4, 2, 1, 1, 0, 3000, 30000, },
	id_5 = {5, "7|60002|100", 300, 5, 2, 1, 1, 0, 2500, 30000, },
	id_6 = {6, "7|500001|10", 100, 6, 2, 1, 1, 0, 2000, 30000, },
	id_7 = {7, "7|60002|200", 600, 7, 2, 1, 1, 0, 1500, 2000, },
	id_8 = {8, "7|60502|30", 240, 8, 2, 1, 1, 0, 1200, 2000, },
	id_9 = {9, "7|500002|10", 500, 9, 2, 1, 1, 0, 1000, 2000, },
	id_10 = {10, "7|104412|1", 960, 10, 2, 1, 1, 0, 700, 2000, },
	id_11 = {11, "7|60503|15", 300, 11, 2, 1, 1, 0, 500, 2000, },
	id_12 = {12, "7|60503|20", 400, 12, 2, 1, 1, 0, 200, 2000, },
	id_13 = {13, "7|30016|10", 700, 13, 2, 1, 1, 0, 100, 500, },
	id_14 = {14, "3|0|100", 100, 14, 2, 1, 1, 0, 50, 500, },
	id_15 = {15, "7|60504|30", 1200, 15, 2, 1, 1, 0, 20, 50, },
	id_16 = {16, "7|500002|10", 500, 16, 2, 1, 1, 0, 10, 50, },
	id_17 = {17, "7|500002|20", 1000, 17, 2, 1, 1, 0, 5, 50, },
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
	local id_data = Arena_shop["id_" .. key_id]
	assert(id_data, "Arena_shop not found " ..  key_id)
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
	for k, v in pairs(Arena_shop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Arena_shop"] = nil
	package.loaded["DB_Arena_shop"] = nil
	package.loaded["db/DB_Arena_shop"] = nil
end

