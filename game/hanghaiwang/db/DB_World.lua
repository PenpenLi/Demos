-- Filename: DB_World.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_World", package.seeall)

keys = {
	"id", "name", "world_pic", "iscopy", "normal_id", "elite_id", "legion_id", "disillusion_id", "nextid", "lastid", "change_fog", "change_map", "music_path", "last_position", "next_position", "entrance", "world_num", "fog_num", 
}

World = {
	id_10000 = {10000, "世界地图一", "word1", 1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27", nil, nil, nil, nil, nil, "1,fog1|2,fog1|3,fog1|4,fog2|5,fog2|6,fog2|7,fog2|8,fog3|9,fog3|10,fog3|11,fog3|12,fog3|13,fog3|14,fog3|15,fog3|16,fog4|17,fog4|18,fog4", nil, nil, nil, nil, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18", 4, 4, },
	id_20001 = {20001, "精英世界地图一", "word1", 2, nil, "200001|200002|200003|200004|200005|200006|200007|200008|200009|200010|200011|200012|200013|200014|200015|200016|200017|200018", nil, nil, nil, nil, "200001,fog1|200002,fog1|200003,fog1|200004,fog2|200005,fog1|200006,fog2|200007,fog2|200008,fog3|200009,fog3|200010,fog3|200011,fog3|200012,fog3|200013,fog3|200014,fog3|200015,fog3|200016,fog4|200017,fog4|200018,fog4", nil, nil, nil, nil, nil, 4, 4, },
	id_30000 = {30000, "公会副本世界地图", "word1", 3, nil, nil, "400001|400002|400003|400004|400005|400006|400007|400008|400009|400010|400011|400012|400013|400014|400015|400016|400017|400018", nil, nil, nil, "400001,fog1|400002,fog1|400003,fog1|400004,fog2|400005,fog2|400006,fog2|400007,fog3|400008,fog3|400009,fog3|400010,fog3|400011,fog3|400012,fog3|400013,fog3|400014,fog3|400015,fog4|400016,fog4|400017,fog4|400018,fog4", nil, nil, nil, nil, nil, 4, 4, },
	id_10001 = {10001, "普通副本世界地图2", "word1", 1, "34", nil, nil, nil, nil, nil, "22,fog4", nil, nil, nil, nil, "22", 4, 4, },
	id_40000 = {40000, "觉醒副本世界地图", "word1", 4, nil, nil, nil, "500001|500002|500003|500004|500005|500006|500007|500008|500009|500010|500011|500012|500013|500014|500015|500016|500017|500018", nil, nil, "500001,fog1|500002,fog1|500003,fog1|500004,fog2|500005,fog2|500006,fog2|500007,fog3|500008,fog3|500009,fog3|500010,fog3|500011,fog3|500012,fog3|500013,fog3|500014,fog3|500015,fog4|500016,fog4|500017,fog4|500018,fog4", nil, nil, nil, nil, nil, 4, 4, },
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
	local id_data = World["id_" .. key_id]
	assert(id_data, "World not found " ..  key_id)
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
	for k, v in pairs(World) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_World"] = nil
	package.loaded["DB_World"] = nil
	package.loaded["db/DB_World"] = nil
end

