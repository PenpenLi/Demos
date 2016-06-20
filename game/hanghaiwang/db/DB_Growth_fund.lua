-- Filename: DB_Growth_fund.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Growth_fund", package.seeall)

keys = {
	"id", "need_vip", "golds_array", "need_gold", "all_perp", "reward", 
}

Growth_fund = {
	id_1 = {1, 4, "10|500,15|600,25|600,30|600,35|800,40|800,45|900,50|1200", 1000, "1|1500", "200|7|101312|1,500|7|60002|50,800|3|0|300,1000|7|60006|20,1500|1|0|600000,2000|7|102412|1,3000|3|0|888", },
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
	local id_data = Growth_fund["id_" .. key_id]
	assert(id_data, "Growth_fund not found " ..  key_id)
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
	for k, v in pairs(Growth_fund) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Growth_fund"] = nil
	package.loaded["DB_Growth_fund"] = nil
	package.loaded["db/DB_Growth_fund"] = nil
end

