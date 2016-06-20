-- Filename: DB_Item_gift.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_gift", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "choose_reward", 
}

Item_gift = {
	id_20001 = {20001, "影子选择包", "开启后可选择路飞，娜美，索隆，乔巴的影子中的一1个", "vip_gift_3.png", "vip_gift_3.png", 5, 5, 0, nil, nil, 9999, nil, 0, "7|410031|1,7|410015|1,7|410016|1,7|410032|1", },
	id_20002 = {20002, "宝物碎片选择包", "临时描述", "vip_gift_3.png", "vip_gift_3.png", 5, 5, 0, nil, nil, 9999, nil, 0, "14|5015016|1,14|5015026|1,14|5015036|1,14|5015046|1", },
	id_20003 = {20003, "橙饰品选择包", "打开后可以选择一个橙色的饰品", "vip_gift_3.png", "vip_gift_3.png", 5, 6, 0, nil, nil, 9999, nil, 0, "7|502501|1,7|502502|1,7|502503|1,7|503501|1,7|503502|1,7|503503|1,7|501501|1,7|501502|1,7|501503|1", },
	id_20004 = {20004, "橙伙伴选择包", "打开后可以选择一个橙色伙伴的80个碎片（可以合成一个橙色的伙伴）", "vip_gift_3.png", "vip_gift_3.png", 5, 6, 0, nil, nil, 9999, nil, 0, "7|410017|80,7|410023|80,7|410024|80,7|410026|80,7|410027|80,7|410030|80,7|410041|80,7|410052|80", },
	id_20005 = {20005, "测试装备选择包", "测试装备选择包", "vip_gift_3.png", "vip_gift_3.png", 5, 5, 0, nil, nil, 9999, nil, 0, "7|101412|1,7|102412|1", },
	id_20006 = {20006, "测试装备碎片选择包", "测试装备碎片选择包", "vip_gift_3.png", "vip_gift_3.png", 5, 5, 0, nil, nil, 9999, nil, 0, "7|1015126|2,7|1015126|2", },
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
	local id_data = Item_gift["id_" .. key_id]
	assert(id_data, "Item_gift not found " ..  key_id)
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
	for k, v in pairs(Item_gift) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_gift"] = nil
	package.loaded["DB_Item_gift"] = nil
	package.loaded["db/DB_Item_gift"] = nil
end

