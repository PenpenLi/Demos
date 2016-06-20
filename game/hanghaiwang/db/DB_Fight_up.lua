-- Filename: DB_Fight_up.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Fight_up", package.seeall)

keys = {
	"id", "name", "icon", "title", "index", "percentage", 
}

Fight_up = {
	id_1 = {1, "伙伴强化", "fight_hero_strengthen_icon.png", "fight_hero_strengthen.png", 30, 40, },
	id_2 = {2, "伙伴进阶", "fight_hero_advanced_icon.png", "fight_hero_advanced.png", 35, 40, },
	id_3 = {3, "上阵伙伴", "fight_formation_hero_icon.png", "fight_formation_hero.png", 40, 40, },
	id_4 = {4, "装备穿戴", "fight_equip_wear_icon.png", "fight_equip_wear.png", 50, 40, },
	id_5 = {5, "装备强化", "fight_equip_strengthen_icon.png", "fight_equip_strengthen.png", 55, 40, },
	id_6 = {6, "装备附魔", "fight_equip_advanced_icon.png", "fight_equip_advanced.png", 60, 40, },
	id_7 = {7, "饰品穿戴", "fight_trea_wear_icon.png", "fight_trea_wear.png", 65, 40, },
	id_8 = {8, "饰品强化", "fight_trea_strengthen_icon.png", "fight_trea_strengthen.png", 70, 40, },
	id_9 = {9, "饰品精炼", "fight_trea_advanced_icon.png", "fight_trea_advanced.png", 75, 40, },
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
	local id_data = Fight_up["id_" .. key_id]
	assert(id_data, "Fight_up not found " ..  key_id)
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
	for k, v in pairs(Fight_up) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Fight_up"] = nil
	package.loaded["DB_Fight_up"] = nil
	package.loaded["db/DB_Fight_up"] = nil
end

