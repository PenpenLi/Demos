-- Filename: DB_Online_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Online_reward", package.seeall)

keys = {
	"id", "count_down_time", "reward_num", "reward_type1", "reward_quality1", "reward_values1", "reward_desc1", "reward_type2", "reward_quality2", "reward_values2", "reward_desc2", "reward_type3", "reward_quality3", "reward_values3", "reward_desc3", "reward_type4", "reward_quality4", "reward_values4", "reward_desc4", "reward_type5", "reward_quality5", "reward_values5", "reward_desc5", "reward_type6", "reward_quality6", "reward_values6", "reward_desc6", "reward_type7", "reward_quality7", "reward_values7", "reward_desc7", 
}

Online_reward = {
	id_1 = {1, 60, 2, 1, 2, "10000", "贝里", 7, 3, "440022|3", "经验绿影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_2 = {2, 120, 2, 1, 2, "10000", "贝里", 7, 4, "440023|2", "经验蓝影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_3 = {3, 300, 2, 1, 2, "10000", "贝里", 7, 5, "440001|1", "经验紫影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_4 = {4, 600, 2, 3, 5, "10", "金币", 7, 5, "440001|2", "经验紫影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_5 = {5, 1200, 2, 3, 5, "20", "金币", 7, 5, "60002|10", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_6 = {6, 1800, 2, 3, 5, "30", "金币", 7, 5, "440001|4", "经验紫影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_7 = {7, 3600, 2, 3, 5, "40", "金币", 7, 5, "60002|20", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Online_reward["id_" .. key_id]
	assert(id_data, "Online_reward not found " ..  key_id)
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
	for k, v in pairs(Online_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Online_reward"] = nil
	package.loaded["DB_Online_reward"] = nil
	package.loaded["db/DB_Online_reward"] = nil
end

