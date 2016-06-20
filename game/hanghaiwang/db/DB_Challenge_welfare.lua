-- Filename: DB_Challenge_welfare.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Challenge_welfare", package.seeall)

keys = {
	"id", "type", "server_time", "start_time", "end_time", "icon", "name", "title", "desc", "task_desc", "require1", "reward_id1", "require2", "reward_id2", "require3", "reward_id3", 
}

Challenge_welfare = {
	id_1 = {1, 1, 20151204100000, 20151126110000, 20151126170000, "icon_copy.png", "challenge_copy.png", "title_copy.png", "挑战一定次数的普通难度或者困难难度的副本，就可以获得丰厚奖励哦！", "挑战副本据点", 10, "1|0|20000", 30, "7|10032|1", 60, "3|0|100", },
	id_2 = {2, 2, 20151204100000, 20151126170500, 20151126171000, "icon_arena.png", "challenge_arena.png", "title_arena.png", "竞技场挑战一定次数，就可以获得丰厚奖励哦！", "挑战竞技场", 3, "12|0|200", 6, "7|60002|50", 10, "3|0|100", },
	id_3 = {3, 3, 20151204100000, 20151106113000, 20151106114500, "icon_conch.png", "challenge_conch.png", "title_conch.png", "空岛挑战达到一定层数，就可以获得丰厚奖励哦！", "挑战空岛到达第", 10, "20|0|40", 25, "7|60029|50", 50, "3|0|100", },
	id_4 = {4, 4, 20151204100000, 20151106114500, 20151106120000, "drop_explore.png", "challenge_explore.png", "title_explore.png", "探索达到一定次数，就可以获得丰厚奖励哦！", "探索", 10, "20|0|40", 25, "7|60029|50", 50, "3|0|100", },
	id_5 = {5, 3, 20151204100000, 20151106140000, 20151106143000, "icon_conch.png", "challenge_conch.png", "title_conch.png", "空岛挑战达到一定层数，就可以获得丰厚奖励哦！", "挑战空岛到达第", 10, "20|0|40", 25, "7|60029|50", 50, "3|0|100", },
	id_6 = {6, 4, 20151204100000, 20151106143000, 20151106150000, "drop_explore.png", "challenge_explore.png", "title_explore.png", "探索达到一定次数，就可以获得丰厚奖励哦！", "探索", 10, "20|0|40", 25, "7|60029|50", 50, "3|0|100", },
	id_7 = {7, 3, 20151204100000, 20151106150000, 20151106153000, "icon_conch.png", "challenge_conch.png", "title_conch.png", "空岛挑战达到一定层数，就可以获得丰厚奖励哦！", "挑战空岛到达第", 10, "20|0|40", 25, "7|60029|50", 50, "3|0|100", },
	id_8 = {8, 4, 20151204100000, 20151106153000, 20151106160000, "drop_explore.png", "challenge_explore.png", "title_explore.png", "探索达到一定次数，就可以获得丰厚奖励哦！", "探索", 10, "20|0|40", 25, "7|60029|50", 50, "3|0|100", },
	id_9 = {9, 3, 20151204100000, 20151106190000, 20151106193000, "icon_conch.png", "challenge_conch.png", "title_conch.png", "空岛挑战达到一定层数，就可以获得丰厚奖励哦！", "挑战空岛到达第", 10, "20|0|40", 25, "7|60029|50", 50, "3|0|100", },
	id_10 = {10, 3, 20151204100000, 20151106193000, 20151106200000, "icon_conch.png", "challenge_conch.png", "title_conch.png", "空岛挑战达到一定层数，就可以获得丰厚奖励哦！", "挑战空岛到达第", 10, "20|0|40", 25, "7|60029|50", 50, "3|0|100", },
	id_11 = {11, 3, 20151204100000, 20151106200000, 20151106203000, "icon_conch.png", "challenge_conch.png", "title_conch.png", "空岛挑战达到一定层数，就可以获得丰厚奖励哦！", "挑战空岛到达第", 10, "20|0|40", 25, "7|60029|50", 50, "3|0|100", },
	id_12 = {12, 3, 20151204100000, 20151106203000, 20151106210000, "icon_conch.png", "challenge_conch.png", "title_conch.png", "空岛挑战达到一定层数，就可以获得丰厚奖励哦！", "挑战空岛到达第", 10, "20|0|40", 25, "7|60029|50", 50, "3|0|100", },
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
	local id_data = Challenge_welfare["id_" .. key_id]
	assert(id_data, "Challenge_welfare not found " ..  key_id)
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
	for k, v in pairs(Challenge_welfare) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Challenge_welfare"] = nil
	package.loaded["DB_Challenge_welfare"] = nil
	package.loaded["db/DB_Challenge_welfare"] = nil
end

