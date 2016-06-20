-- Filename: DB_Welfare_shop_start.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Welfare_shop_start", package.seeall)

keys = {
	"id", "activity_time", "activity_icon", "activity_name", "activity_title", "goods_list", 
}

Welfare_shop_start = {
	id_1 = {1, "1|1", "icon_welfare_shop.png", "name_welfare_shop.png", "title_welfare_shop.png", "1|6|10|4|5", },
	id_2 = {2, "2|3", "icon_sale_store.png", "name_sale_store.png", "title_sale_store.png", "2|5|9|1|10", },
	id_3 = {3, "4|5", "icon_timelimit_buy.png", "name_timelimit_buy.png", "title_timelimit_buy.png", "3|4|7|8|9", },
	id_4 = {4, "6|7", "icon_welfare_shop.png", "name_welfare_shop.png", "title_welfare_shop.png", "2|3|6|8|5", },
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
	local id_data = Welfare_shop_start["id_" .. key_id]
	assert(id_data, "Welfare_shop_start not found " ..  key_id)
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
	for k, v in pairs(Welfare_shop_start) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Welfare_shop_start"] = nil
	package.loaded["DB_Welfare_shop_start"] = nil
	package.loaded["db/DB_Welfare_shop_start"] = nil
end

