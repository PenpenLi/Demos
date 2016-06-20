-- Filename: DB_First_gift.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_First_gift", package.seeall)

keys = {
	"id", "platform_type", "activity_desc", "img", "reward_item_ids", "gold2", "reward2", "gold3", "reward3", 
}

First_gift = {
	id_1 = {1, 1, "首次充值即可获得丰富奖励", nil, "13|10016|1,7|60002|50,1|0|100000", 980, "7|101412|1,7|60002|100,1|0|250000", 1980, "7|40001|1,7|60601|5000,1|0|400000", },
	id_2 = {2, 2, "首次充值即可获得丰富奖励", nil, "13|10016|1,7|60002|50,1|0|100000", 980, "7|101412|1,7|60002|100,1|0|250000", 1980, "7|40001|1,7|60601|5000,1|0|400000", },
	id_3 = {3, 3, "首次充值即可获得丰富奖励", nil, "13|10016|1,7|60002|50,1|0|100000", 980, "7|101412|1,7|60002|100,1|0|250000", 1980, "7|40001|1,7|60601|5000,1|0|400000", },
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
	local id_data = First_gift["id_" .. key_id]
	assert(id_data, "First_gift not found " ..  key_id)
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
	for k, v in pairs(First_gift) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_First_gift"] = nil
	package.loaded["DB_First_gift"] = nil
	package.loaded["db/DB_First_gift"] = nil
end

