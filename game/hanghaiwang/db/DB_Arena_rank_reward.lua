-- Filename: DB_Arena_rank_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Arena_rank_reward", package.seeall)

keys = {
	"id", "rank_up", "rank_down", "rank_n", "reward", 
}

Arena_rank_reward = {
	id_1 = {1, 20000, 10000, 50, 1, },
	id_2 = {2, 10000, 5000, 25, 1, },
	id_3 = {3, 5000, 2000, 5, 2, },
	id_4 = {4, 2000, 1000, 5, 3, },
	id_5 = {5, 1000, 500, 1, 1, },
	id_6 = {6, 500, 200, 2, 3, },
	id_7 = {7, 200, 100, 1, 3, },
	id_8 = {8, 100, 50, 1, 5, },
	id_9 = {9, 50, 10, 1, 8, },
	id_10 = {10, 10, 4, 1, 30, },
	id_11 = {11, 4, 3, 1, 100, },
	id_12 = {12, 3, 2, 1, 200, },
	id_13 = {13, 2, 1, 1, 400, },
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
	local id_data = Arena_rank_reward["id_" .. key_id]
	assert(id_data, "Arena_rank_reward not found " ..  key_id)
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
	for k, v in pairs(Arena_rank_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Arena_rank_reward"] = nil
	package.loaded["DB_Arena_rank_reward"] = nil
	package.loaded["db/DB_Arena_rank_reward"] = nil
end

