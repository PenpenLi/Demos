-- Filename: DB_Sale_box.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Sale_box", package.seeall)

keys = {
	"id", "time", "box1_name", "box1_icon", "box1_des", "box1_oricost", "box1_discount", "box1_num", "box2_name", "box2_icon", "box2_des", "box2_oricost", "box2_discount", "box2_num", "box3_name", "box3_icon", "box3_des", "box3_oricost", "box3_discount", "box3_num", 
}

Sale_box = {
	id_1 = {1, "1|7", "资源宝箱", "salebox3.png", "购买可随机获得刷新卡、体力药水（中）、耐力药水（中）、进阶石、经验蓝影", 58, 38, 5, "战力宝箱", "salebox2.png", "购买可随机获得高级附魔石、经验银钻、宝物晶石、刷新卡", 88, 58, 4, "战力宝箱", "salebox1.png", "购买可随机获得极品附魔石、经验金钻、宝物晶石、刷新卡、宝物礼盒", 198, 128, 10, },
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
	local id_data = Sale_box["id_" .. key_id]
	assert(id_data, "Sale_box not found " ..  key_id)
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
	for k, v in pairs(Sale_box) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Sale_box"] = nil
	package.loaded["DB_Sale_box"] = nil
	package.loaded["db/DB_Sale_box"] = nil
end

