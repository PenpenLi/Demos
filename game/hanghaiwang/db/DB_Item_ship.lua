-- Filename: DB_Item_ship.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_ship", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "isSellDirect", "item_getway", "activate_ship", "resolve_item", 
}

Item_ship = {
	id_40001 = {40001, "黄金梅利号", "可用于激活黄金梅利号主船", "ship_meili.png", nil, 9, 5, 0, nil, nil, 999, nil, 1, 0, "28", 2, "60601|1250", },
	id_40002 = {40002, "千里阳光号", "可用于激活千里阳光号主船", "ship_sunny.png", nil, 9, 5, 0, nil, nil, 999, nil, 1, 0, nil, 4, "60601|1250", },
	id_40003 = {40003, "轻木帆船", "可用于激活轻木帆船", "ship1.png", nil, 9, 3, 0, nil, nil, 999, nil, 1, 0, nil, 1, "60601|25", },
	id_40004 = {40004, "可爱小鸭号", "可用于激活可爱小鸭号主船", "ship4.png", nil, 9, 5, 0, nil, nil, 999, nil, 1, 0, "4", 3, "60601|1125", },
	id_40005 = {40005, "测试-4", "测试-4", "ship_meili.png", nil, 9, 5, 0, nil, nil, 999, nil, 1, 0, nil, 6, "60601|10", },
	id_40006 = {40006, "测试-5", "测试-5", "ship_meili.png", nil, 9, 5, 0, nil, nil, 999, nil, 1, 0, nil, 7, "60601|10", },
	id_40007 = {40007, "测试-6", "测试-6", "ship_meili.png", nil, 9, 5, 0, nil, nil, 999, nil, 1, 0, nil, 8, "60601|10", },
	id_40008 = {40008, "测试-7", "测试-7", "ship_meili.png", nil, 9, 5, 0, nil, nil, 999, nil, 1, 0, nil, 9, "60601|10", },
	id_40009 = {40009, "测试-8", "测试-8", "ship_meili.png", nil, 9, 5, 0, nil, nil, 999, nil, 1, 0, nil, 10, "60601|10", },
	id_40010 = {40010, "测试-9", "测试-9", "ship_meili.png", nil, 9, 5, 0, nil, nil, 999, nil, 1, 0, nil, 11, "60601|10", },
	id_40011 = {40011, "测试-10", "测试-10", "ship_meili.png", nil, 9, 5, 0, nil, nil, 999, nil, 1, 0, nil, 12, "60601|10", },
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
	local id_data = Item_ship["id_" .. key_id]
	assert(id_data, "Item_ship not found " ..  key_id)
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
	for k, v in pairs(Item_ship) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_ship"] = nil
	package.loaded["DB_Item_ship"] = nil
	package.loaded["db/DB_Item_ship"] = nil
end

