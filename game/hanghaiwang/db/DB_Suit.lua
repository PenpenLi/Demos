-- Filename: DB_Suit.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Suit", package.seeall)

keys = {
	"id", "name", "total_num", "max_lock", "suit_items", "lock_num1", "astAttr1", "lock_num2", "astAttr2", "lock_num3", "astAttr3", "lock_num4", "astAttr4", "lock_num5", "astAttr5", "lock_num6", "astAttr6", "lock_num7", "astAttr7", "lock_num8", "astAttr8", "lock_num9", "astAttr9", "lock_num10", "astAttr10", 
}

Suit = {
	id_21 = {21, "碧绿套装", 4, 3, "101212,102212,103212,104212", 2, "4|20,5|20", 3, "2|30,3|30,1|100", 4, "2|60,3|60,4|40,5|40,1|200", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_22 = {22, "浪人套装", 4, 3, "101222,102222,103222,104222", 2, "4|28,5|28", 3, "2|42,3|42,1|140", 4, "2|84,3|84,4|56,5|56,1|280", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_31 = {31, "冒险套装", 4, 3, "101312,102312,103312,104312", 2, "4|35,5|35", 3, "2|50,3|50,1|175", 4, "2|105,3|105,4|70,5|70,1|350", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_32 = {32, "骑士套装", 4, 3, "101322,102322,103322,104322", 2, "4|49,5|49", 3, "2|70,3|70,1|245", 4, "2|147,3|147,4|98,5|98,1|490", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_41 = {41, "武装套装", 4, 3, "101412,102412,103412,104412", 2, "4|70,5|70", 3, "2|105,3|105,1|350", 4, "2|215,3|215,4|140,5|140,1|700", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_42 = {42, "精钢套装", 4, 3, "101422,102422,103422,104422", 2, "4|98,5|98", 3, "2|147,3|147,1|490", 4, "2|301,3|301,4|196,5|196,1|980", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_43 = {43, "战斗套装", 4, 3, "101432,102432,103432,104432", 2, "4|119,5|119", 3, "2|178,3|178,1|595", 4, "2|365,3|365,4|238,5|238,1|1190", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_51 = {51, "霸王威慑套装", 4, 3, "101512,102512,103512,104512", 2, "4|115,5|115", 3, "2|170,3|170,1|575", 4, "2|345,3|345,4|230,5|230,1|1150", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_52 = {52, "英雄裁决套装", 4, 3, "101522,102522,103522,104522", 2, "4|161,5|161", 3, "2|238,3|238,1|805", 4, "2|483,3|483,4|322,5|322,1|1610", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_53 = {53, "统御能量套装", 4, 3, "101532,102532,103532,104532", 2, "4|195,5|195", 3, "2|289,3|289,1|977", 4, "2|586,3|586,4|391,5|391,1|1955", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Suit["id_" .. key_id]
	assert(id_data, "Suit not found " ..  key_id)
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
	for k, v in pairs(Suit) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Suit"] = nil
	package.loaded["DB_Suit"] = nil
	package.loaded["db/DB_Suit"] = nil
end

