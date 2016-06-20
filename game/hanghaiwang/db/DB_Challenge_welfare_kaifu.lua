-- Filename: DB_Challenge_welfare_kaifu.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Challenge_welfare_kaifu", package.seeall)

keys = {
	"id", "type", "time", "icon", "name", "title", "desc", "require1", "reward_id1", "require2", "reward_id2", "require3", "reward_id3", "require4", "reward_id4", "require5", "reward_id5", "require6", "reward_id6", "require7", "reward_id7", "require8", "reward_id8", "require9", "reward_id9", "require10", "reward_id10", 
}

Challenge_welfare_kaifu = {
	id_1 = {1, 2, "2|2", "icon_arena.png", "challenge_arena.png", "title_arena.png", "竞技场挑战一定次数，就可以获得丰厚奖励哦！", 5, "7|60025|40", 10, "7|60025|60", 15, "7|60025|80", 20, "7|60025|100", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_2 = {2, 4, "3|3", "drop_explore.png", "challenge_explore.png", "title_explore.png", "探索达到一定次数，就可以获得丰厚奖励哦！", 40, "7|60025|30", 50, "7|60025|30", 60, "7|60025|40", 80, "7|60025|40", 100, "7|60025|60", 120, "7|60025|60", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_3 = {3, 1, "4|4", "icon_copy.png", "challenge_copy.png", "title_copy.png", "挑战一定次数的普通难度或者困难难度的副本，就可以获得丰厚奖励哦！", 40, "7|60025|30", 50, "7|60025|30", 60, "7|60025|40", 80, "7|60025|40", 100, "7|60025|60", 120, "7|60025|60", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_4 = {4, 2, "5|5", "icon_arena.png", "challenge_arena.png", "title_arena.png", "竞技场挑战一定次数，就可以获得丰厚奖励哦！", 5, "7|60025|40", 10, "7|60025|60", 15, "7|60025|80", 20, "7|60025|100", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_5 = {5, 4, "6|6", "drop_explore.png", "challenge_explore.png", "title_explore.png", "探索达到一定次数，就可以获得丰厚奖励哦！", 40, "7|60025|30", 50, "7|60025|30", 60, "7|60025|40", 80, "7|60025|40", 100, "7|60025|60", 120, "7|60025|60", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_6 = {6, 1, "7|7", "icon_copy.png", "challenge_copy.png", "title_copy.png", "挑战一定次数的普通难度或者困难难度的副本，就可以获得丰厚奖励哦！", 40, "7|60025|30", 50, "7|60025|30", 60, "7|60025|40", 80, "7|60025|40", 100, "7|60025|60", 120, "7|60025|60", nil, nil, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Challenge_welfare_kaifu["id_" .. key_id]
	assert(id_data, "Challenge_welfare_kaifu not found " ..  key_id)
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
	for k, v in pairs(Challenge_welfare_kaifu) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Challenge_welfare_kaifu"] = nil
	package.loaded["DB_Challenge_welfare_kaifu"] = nil
	package.loaded["db/DB_Challenge_welfare_kaifu"] = nil
end

