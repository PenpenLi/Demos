-- Filename: DB_Formation.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Formation", package.seeall)

keys = {
	"id", "openSort", "openPositionLv", "leadposition", "openNumByLv", "openFriendByLv", "openBenchByLv", "consume_item", "consume_needlv", "consume_needvip", "onekey_when", "formation_display", "bench_display", 
}

Formation = {
	id_1 = {1, "2,4,1,3,5,0", "1,1,1,1,1,12", 1, "1|2,5|3,13|4,19|5,27|6", "22|1,28|2,35|3,40|4,45|5,50|6,60|7,70|8,999|9,999|10,999|11,999|12,999|13,999|14,999|15,999|16,999|17,999|18,999|19,999|20", "50|1,999|2,999|3", "60318|999,60318|999,60318|999,60318|999,60318|1,60318|2,60318|5,60318|10,60318|10,60318|10,60318|10,60318|10,60318|10,60318|10,60318|10,60318|10,60318|10,60318|10,60318|10,60318|10", "999,999,999,999,999,999,999,999,70,70,70,70,70,70,70,70,70,70,70,70", "999,999,999,999,999,999,999,999,1,2,3,4,5,6,7,8,9,10,11,12", 2, 6, "27|1,999|2,999|3", },
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
	local id_data = Formation["id_" .. key_id]
	assert(id_data, "Formation not found " ..  key_id)
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
	for k, v in pairs(Formation) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Formation"] = nil
	package.loaded["DB_Formation"] = nil
	package.loaded["db/DB_Formation"] = nil
end

