-- Filename: DB_Pay_list.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Pay_list", package.seeall)

keys = {
	"id", "platform_type", "consume_money", "consume_grade", "gold_num", "product_id", "icon", "is_show", "is_recommend", "special_gold_num", 
}

Pay_list = {
	id_1 = {1, 1, 10, 100, 10, 1, "jinbi_xiao.png", 1, 1, 100, },
	id_2 = {2, 1, 30, 300, 30, 2, "jinbi_xiao.png", 1, 1, 300, },
	id_3 = {3, 1, 50, 500, 50, 3, "jinbi_zhong.png", 1, 1, 500, },
	id_4 = {4, 1, 100, 1000, 110, 4, "jinbi_zhong.png", 1, 1, 1000, },
	id_5 = {5, 1, 200, 2000, 225, 5, "jinbi_zhong.png", 1, 1, 2000, },
	id_6 = {6, 1, 500, 5000, 580, 7, "jinbi_da.png", 1, 1, 5000, },
	id_7 = {7, 1, 1000, 10000, 1180, 8, "jinbi_chaoda.png", 1, 1, 10000, },
	id_8 = {8, 1, 2000, 20000, 2400, 9, "jinbi_chaoda.png", 1, 1, 20000, },
	id_101 = {101, 2, 6, 60, 6, 1, "jinbi_xiao.png", 1, 1, 60, },
	id_102 = {102, 2, 30, 300, 30, 2, "jinbi_xiao.png", 1, 1, 300, },
	id_103 = {103, 2, 98, 980, 113, 3, "jinbi_zhong.png", 1, 1, 980, },
	id_104 = {104, 2, 198, 1980, 238, 4, "jinbi_zhong.png", 1, 1, 1980, },
	id_105 = {105, 2, 328, 3280, 420, 5, "jinbi_da.png", 1, 1, 3280, },
	id_106 = {106, 2, 648, 6480, 875, 6, "jinbi_chaoda.png", 1, 1, 6480, },
	id_201 = {201, 3, 10, 100, 10, 1, "jinbi_xiao.png", 1, 1, 100, },
	id_202 = {202, 3, 25, 250, 25, 2, "jinbi_xiao.png", 1, 1, 250, },
	id_203 = {203, 3, 50, 500, 50, 3, "jinbi_zhong.png", 1, 1, 500, },
	id_204 = {204, 3, 100, 1000, 110, 4, "jinbi_zhong.png", 1, 1, 1000, },
	id_205 = {205, 3, 200, 2000, 225, 5, "jinbi_zhong.png", 1, 1, 2000, },
	id_206 = {206, 3, 300, 3000, 340, 6, "jinbi_da.png", 1, 1, 3000, },
	id_207 = {207, 3, 500, 5000, 580, 7, "jinbi_da.png", 1, 1, 5000, },
	id_208 = {208, 3, 1000, 10000, 1180, 8, "jinbi_chaoda.png", 1, 1, 10000, },
	id_209 = {209, 3, 2000, 20000, 2400, 9, "jinbi_chaoda.png", 1, 1, 20000, },
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
	local id_data = Pay_list["id_" .. key_id]
	assert(id_data, "Pay_list not found " ..  key_id)
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
	for k, v in pairs(Pay_list) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Pay_list"] = nil
	package.loaded["DB_Pay_list"] = nil
	package.loaded["db/DB_Pay_list"] = nil
end

