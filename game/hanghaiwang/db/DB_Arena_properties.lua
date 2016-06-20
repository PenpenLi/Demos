-- Filename: DB_Arena_properties.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Arena_properties", package.seeall)

keys = {
	"id", "challenge_times", "win_base_coin", "lose_base_coin", "win_base_exp", "lose_base_exp", "costEndurance", "winPrestige", "losePrestige", "level_limit", "ship_position", "buy_add_times", "buy_gold", 
}

Arena_properties = {
	id_1 = {1, 10, 25, 0, 2, 1, 0, 20, 10, "30|0", "171|200,171|427,171|654,171|881,171|1108,171|1335,171|1562,171|1789,171|2016,171|2243,171|2470", 5, "1|50,2|60,3|70,4|80,5|90,6|100,7|110,8|120,9|130,10|140,11|150", },
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
	local id_data = Arena_properties["id_" .. key_id]
	assert(id_data, "Arena_properties not found " ..  key_id)
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
	for k, v in pairs(Arena_properties) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Arena_properties"] = nil
	package.loaded["DB_Arena_properties"] = nil
	package.loaded["db/DB_Arena_properties"] = nil
end

