-- Filename: DB_Ship.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Ship", package.seeall)

keys = {
	"id", "name", "attr", "home_graph", "ship_graph", "explore_graph", "arena_graph", "grab_graph", "ship_battle_icon", 
}

Ship = {
	id_1 = {1, "轻木帆船", nil, 1, 1, 1, 1, 1, "ship_1.png", },
	id_2 = {2, "黄金梅丽号", "1|100,2|10,3|10,4|10,5|10", 2, 2, 2, 2, 2, "ship_2.png", },
	id_3 = {3, "可爱小鸭号", "1|100,2|10,3|10,4|10,5|10", 3, 3, 3, 3, 3, "ship_4.png", },
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
	local id_data = Ship["id_" .. key_id]
	assert(id_data, "Ship not found " ..  key_id)
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
	for k, v in pairs(Ship) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Ship"] = nil
	package.loaded["DB_Ship"] = nil
	package.loaded["db/DB_Ship"] = nil
end

