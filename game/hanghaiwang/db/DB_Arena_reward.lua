-- Filename: DB_Arena_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Arena_reward", package.seeall)

keys = {
	"rank", "reward_coin", "reward_prestige", "reward_coin_base", 
}

Arena_reward = {
	id_1 = {1, 1000, 3000, 100000, },
	id_2 = {2, 900, 2500, 100000, },
	id_3 = {3, 800, 2300, 100000, },
	id_4 = {4, 750, 2100, 100000, },
	id_5 = {5, 700, 2000, 100000, },
	id_25 = {25, 675, 1800, 100000, },
	id_50 = {50, 650, 1600, 100000, },
	id_100 = {100, 625, 1400, 100000, },
	id_150 = {150, 600, 1200, 100000, },
	id_200 = {200, 575, 1100, 100000, },
	id_300 = {300, 550, 1000, 100000, },
	id_400 = {400, 525, 900, 100000, },
	id_500 = {500, 500, 800, 100000, },
	id_1000 = {1000, 450, 600, 100000, },
	id_1500 = {1500, 400, 500, 100000, },
	id_2000 = {2000, 350, 400, 100000, },
	id_3000 = {3000, 300, 200, 100000, },
	id_5000 = {5000, 200, 100, 100000, },
	id_10000 = {10000, 100, 100, 100000, },
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
	local id_data = Arena_reward["id_" .. key_id]
	assert(id_data, "Arena_reward not found " ..  key_id)
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
	for k, v in pairs(Arena_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Arena_reward"] = nil
	package.loaded["DB_Arena_reward"] = nil
	package.loaded["db/DB_Arena_reward"] = nil
end

