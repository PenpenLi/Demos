-- Filename: DB_Contest_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Contest_reward", package.seeall)

keys = {
	"id", "desc", "coin", "soul", "gold", "items", 
}

Contest_reward = {
	id_1 = {1, "第1名", 10000, 0, 500, "410006|10", },
	id_2 = {2, "第2名", 9000, 0, 400, "410006|9", },
	id_3 = {3, "第3名", 8000, 0, 300, "410006|9", },
	id_4 = {4, "第4名", 7000, 0, 200, "410006|8", },
	id_5 = {5, "第5名", 6000, 0, 100, "410006|8", },
	id_6 = {6, "第6~10名", 5000, 0, 90, "410006|7", },
	id_7 = {7, "第11~20名", 4500, 0, 80, "410006|7", },
	id_8 = {8, "第21~50名", 4000, 0, 70, "410006|6", },
	id_9 = {9, "第51~100名", 3500, 0, 60, "410006|6", },
	id_10 = {10, "第101~200名", 3000, 0, 50, "410006|5", },
	id_11 = {11, "第201~300名", 2500, 0, 50, "410006|5", },
	id_12 = {12, "第301~400名", 2000, 0, 50, "410006|4", },
	id_13 = {13, "第401~500名", 1500, 0, 50, "410006|4", },
	id_14 = {14, "第501~1000名", 1250, 0, nil, nil, },
	id_15 = {15, "第1001~2000名", 1000, 0, nil, nil, },
	id_16 = {16, "第2001~5000名", 750, 0, nil, nil, },
	id_17 = {17, "第5001名后", 500, 0, nil, nil, },
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
	local id_data = Contest_reward["id_" .. key_id]
	assert(id_data, "Contest_reward not found " ..  key_id)
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
	for k, v in pairs(Contest_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Contest_reward"] = nil
	package.loaded["DB_Contest_reward"] = nil
	package.loaded["db/DB_Contest_reward"] = nil
end

