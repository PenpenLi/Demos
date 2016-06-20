-- Filename: DB_Legion_goods.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Legion_goods", package.seeall)

keys = {
	"id", "items", "costContribution", "sortType", "goodType", "limitType", "needLegionLevel", "baseNum", "personalLimit", "isSold", "recommended", "costGold", 
}

Legion_goods = {
	id_10101 = {10101, "1|30020|1", 2500, 10101, 1, 3, 0, 15, 1, 1, 1, nil, },
	id_10201 = {10201, "1|30025|1", 2500, 10201, 1, 3, 0, 15, 1, 1, 1, nil, },
	id_10301 = {10301, "1|500001|10", 1000, 10301, 1, 3, 0, 10, 1, 1, 0, nil, },
	id_10401 = {10401, "1|500002|2", 1000, 10401, 1, 3, 0, 10, 1, 1, 0, nil, },
	id_10501 = {10501, "1|60008|50", 1000, 10501, 1, 3, 0, 10, 1, 1, 0, nil, },
	id_10601 = {10601, "1|60008|100", 2000, 10601, 1, 3, 0, 15, 1, 1, 1, nil, },
	id_10701 = {10701, "1|10032|1", 500, 10701, 1, 3, 0, 10, 1, 1, 0, nil, },
	id_10801 = {10801, "1|10042|1", 400, 10801, 1, 3, 0, 10, 1, 1, 0, nil, },
	id_10901 = {10901, "1|10033|1", 1000, 10901, 1, 3, 0, 10, 1, 1, 1, nil, },
	id_11001 = {11001, "1|10043|1", 800, 11001, 1, 3, 0, 10, 1, 1, 1, nil, },
	id_11101 = {11101, "1|30012|1", 480, 11101, 1, 3, 0, 10, 1, 1, 0, nil, },
	id_11201 = {11201, "1|30013|1", 980, 11201, 1, 3, 0, 10, 1, 1, 1, nil, },
	id_11301 = {11301, "1|30016|1", 800, 11301, 1, 3, 0, 10, 1, 1, 1, nil, },
	id_11401 = {11401, "1|60025|20", 200, 11401, 1, 3, 0, 10, 1, 1, 0, nil, },
	id_11501 = {11501, "1|60025|50", 500, 11501, 1, 3, 0, 15, 1, 1, 1, nil, },
	id_11601 = {11601, "1|60006|5", 1000, 11601, 1, 3, 0, 10, 1, 1, 0, nil, },
	id_11701 = {11701, "1|440001|5", 250, 11701, 1, 3, 0, 10, 1, 1, 0, nil, },
	id_11801 = {11801, "1|60033|20", 300, 11801, 1, 3, 0, 15, 1, 1, 1, nil, },
	id_1001 = {1001, "1|60025|10", 200, 2, 2, 1, 0, 2, 2, 1, nil, nil, },
	id_1002 = {1002, "1|60025|20", 400, 7, 2, 1, 5, 2, 2, 1, nil, nil, },
	id_1003 = {1003, "1|60025|50", 1000, 12, 2, 1, 10, 2, 2, 1, nil, nil, },
	id_1004 = {1004, "1|30012|1", 480, 3, 2, 1, 0, 2, 2, 1, nil, nil, },
	id_1005 = {1005, "1|30013|1", 980, 9, 2, 1, 6, 2, 2, 1, nil, nil, },
	id_1006 = {1006, "1|10042|1", 500, 6, 2, 1, 2, 1, 1, 1, nil, nil, },
	id_1007 = {1007, "1|10043|1", 1000, 13, 2, 1, 12, 1, 1, 1, nil, nil, },
	id_1008 = {1008, "1|60019|5", 500, 4, 2, 1, 0, 1, 1, 1, nil, nil, },
	id_1009 = {1009, "1|60006|2", 400, 5, 2, 1, 1, 1, 1, 1, nil, nil, },
	id_1010 = {1010, "1|60006|5", 1000, 14, 2, 1, 15, 1, 1, 1, nil, nil, },
	id_1011 = {1011, "1|60501|1", 20, 8, 2, 1, 5, 5, 5, 1, nil, nil, },
	id_1012 = {1012, "1|60502|1", 40, 10, 2, 1, 9, 2, 2, 1, nil, nil, },
	id_1013 = {1013, "1|60503|1", 100, 15, 2, 1, 20, 2, 2, 1, nil, nil, },
	id_1014 = {1014, "1|60033|20", 600, 11, 2, 1, 10, 2, 2, 1, nil, nil, },
	id_1015 = {1015, "1|60033|30", 900, 16, 2, 1, 22, 1, 1, 1, nil, nil, },
	id_1016 = {1016, "1|60033|30", 900, 17, 2, 1, 25, 1, 1, 1, nil, nil, },
	id_1017 = {1017, "1|40004|1", 8000, 1, 2, 2, 5, 1, 1, 1, nil, 1000, },
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
	local id_data = Legion_goods["id_" .. key_id]
	assert(id_data, "Legion_goods not found " ..  key_id)
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
	for k, v in pairs(Legion_goods) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Legion_goods"] = nil
	package.loaded["DB_Legion_goods"] = nil
	package.loaded["db/DB_Legion_goods"] = nil
end

