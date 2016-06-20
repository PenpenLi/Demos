-- Filename: DB_Accumulate_sign.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Accumulate_sign", package.seeall)

keys = {
	"id", "accumulate_type", "add_up_days", "reward_num", "reward_type1", "reward_quality1", "reward_value1", "reward_desc1", "reward_type2", "reward_quality2", "reward_value2", "reward_desc2", "reward_type3", "reward_quality3", "reward_value3", "reward_desc3", "reward_type4", "reward_quality4", "reward_value4", "reward_desc4", 
}

Accumulate_sign = {
	id_1 = {1, 1, 1, 3, 3, 5, "150", "金币", 7, 5, "60006|5", "刷新卡", 1, 5, "100000", "贝里", nil, nil, nil, nil, },
	id_2 = {2, 1, 2, 4, 7, 5, "103412|1", "武装钢盔", 3, 5, "200", "金币", 7, 5, "30012|1", "白银钥匙", 7, 5, "60006|5", "刷新卡", },
	id_3 = {3, 1, 3, 4, 7, 5, "700031|1", "路飞草帽", 3, 5, "300", "金币", 7, 5, "30012|1", "白银钥匙", 7, 5, "60006|5", "刷新卡", },
	id_4 = {4, 1, 4, 4, 7, 5, "700016|1", "乔巴医疗包", 3, 5, "350", "金币", 7, 5, "30013|1", "黄金钥匙", 7, 5, "60006|5", "刷新卡", },
	id_5 = {5, 1, 5, 4, 7, 5, "700015|1", "天候棒", 3, 5, "400", "金币", 7, 5, "30013|1", "黄金钥匙", 7, 5, "60006|5", "刷新卡", },
	id_6 = {6, 1, 6, 4, 7, 5, "700014|1", "狙击王面具", 3, 5, "400", "金币", 7, 5, "30013|1", "黄金钥匙", 7, 5, "60006|5", "刷新卡", },
	id_7 = {7, 1, 7, 4, 13, 6, "10025|1", "波尔·汉库珂", 3, 5, "500", "金币", 7, 5, "30013|1", "黄金钥匙", 7, 5, "60006|5", "刷新卡", },
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
	local id_data = Accumulate_sign["id_" .. key_id]
	assert(id_data, "Accumulate_sign not found " ..  key_id)
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
	for k, v in pairs(Accumulate_sign) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Accumulate_sign"] = nil
	package.loaded["DB_Accumulate_sign"] = nil
	package.loaded["db/DB_Accumulate_sign"] = nil
end

