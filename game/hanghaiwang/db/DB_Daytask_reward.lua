-- Filename: DB_Daytask_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Daytask_reward", package.seeall)

keys = {
	"id", "needScore", "reward", "needLv", 
}

Daytask_reward = {
	id_1 = {1, 25, "3|0|20,1|0|20000", 1, },
	id_2 = {2, 60, "3|0|50,7|60006|1", 1, },
	id_3 = {3, 100, "3|0|100,7|60006|2,7|10032|1", 1, },
	id_4 = {4, 25, "3|0|20|,1|0|20000", 20, },
	id_5 = {5, 60, "3|0|50,7|60006|1", 20, },
	id_6 = {6, 100, "3|0|100,7|60006|2,7|10032|1,7|30013|1", 20, },
	id_7 = {7, 25, "3|0|20|,1|0|20000", 30, },
	id_8 = {8, 60, "3|0|50,7|60006|1", 30, },
	id_9 = {9, 100, "3|0|100,7|60006|2,7|10032|1,7|30013|1", 30, },
	id_10 = {10, 25, "3|0|20|,1|0|30000", 35, },
	id_11 = {11, 60, "3|0|50,7|60006|1,7|60503|4", 35, },
	id_12 = {12, 100, "3|0|100,7|60006|2,7|10032|1,7|30013|1", 35, },
	id_13 = {13, 25, "3|0|20|,1|0|40000", 38, },
	id_14 = {14, 60, "3|0|50,7|60006|1,7|60503|4", 38, },
	id_15 = {15, 100, "3|0|100,7|60006|2,7|10032|1,7|30013|1", 38, },
	id_16 = {16, 25, "3|0|20|,1|0|40000", 42, },
	id_17 = {17, 60, "3|0|50,7|60006|1,7|60503|4", 42, },
	id_18 = {18, 100, "3|0|100,7|60006|2,7|10032|1,7|30013|1", 42, },
	id_19 = {19, 25, "3|0|20|,1|0|40000", 52, },
	id_20 = {20, 60, "3|0|50,7|60006|1,7|60503|4", 52, },
	id_21 = {21, 100, "3|0|100,7|60006|2,7|10032|1,7|30013|1", 52, },
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
	local id_data = Daytask_reward["id_" .. key_id]
	assert(id_data, "Daytask_reward not found " ..  key_id)
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
	for k, v in pairs(Daytask_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Daytask_reward"] = nil
	package.loaded["DB_Daytask_reward"] = nil
	package.loaded["db/DB_Daytask_reward"] = nil
end

