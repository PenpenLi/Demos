-- Filename: DB_Sky_piea_buff.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Sky_piea_buff", package.seeall)

keys = {
	"id", "buff", "costStar", "icon", "tips", "title", 
}

Sky_piea_buff = {
	id_1001 = {1001, "1|12|100,1|13|100", 1, "buff_attack.png", "增加攻击", "攻击", },
	id_2001 = {2001, "1|12|200,1|13|200", 5, "buff_attack.png", "增加攻击", "攻击", },
	id_3001 = {3001, "1|12|300,1|13|300", 10, "buff_attack.png", "增加攻击", "攻击", },
	id_4001 = {4001, "1|12|400,1|13|400", 20, "buff_attack.png", "增加攻击", "攻击", },
	id_5001 = {5001, "1|12|500,1|13|500", 40, "buff_attack.png", "增加攻击", "攻击", },
	id_1002 = {1002, "1|14|200", 1, "buff_phy_defend.png", "增加物理防御", "物防", },
	id_2002 = {2002, "1|14|400", 5, "buff_phy_defend.png", "增加物理防御", "物防", },
	id_3002 = {3002, "1|14|600", 10, "buff_phy_defend.png", "增加物理防御", "物防", },
	id_4002 = {4002, "1|14|800", 20, "buff_phy_defend.png", "增加物理防御", "物防", },
	id_5002 = {5002, "1|14|1000", 40, "buff_phy_defend.png", "增加物理防御", "物防", },
	id_1003 = {1003, "1|15|200", 1, "buff_magic_defend.png", "增加魔法防御", "魔防", },
	id_2003 = {2003, "1|15|400", 5, "buff_magic_defend.png", "增加魔法防御", "魔防", },
	id_3003 = {3003, "1|15|600", 10, "buff_magic_defend.png", "增加魔法防御", "魔防", },
	id_4003 = {4003, "1|15|800", 20, "buff_magic_defend.png", "增加魔法防御", "魔防", },
	id_5003 = {5003, "1|15|1000", 40, "buff_magic_defend.png", "增加魔法防御", "魔防", },
	id_1004 = {1004, "1|11|100", 1, "buff_hp_up.png", "增加生命", "生命", },
	id_2004 = {2004, "1|11|200", 5, "buff_hp_up.png", "增加生命", "生命", },
	id_3004 = {3004, "1|11|300", 10, "buff_hp_up.png", "增加生命", "生命", },
	id_4004 = {4004, "1|11|400", 20, "buff_hp_up.png", "增加生命", "生命", },
	id_5004 = {5004, "1|11|500", 40, "buff_hp_up.png", "增加生命", "生命", },
	id_1005 = {1005, "2|1|2000", 1, "buff_hp_add.png", "恢复血量", "回血", },
	id_2005 = {2005, "2|1|4000", 5, "buff_hp_add.png", "恢复血量", "回血", },
	id_3005 = {3005, "2|1|6000", 10, "buff_hp_add.png", "恢复血量", "回血", },
	id_4005 = {4005, "2|1|8000", 20, "buff_hp_add.png", "恢复血量", "回血", },
	id_5005 = {5005, "2|1|10000", 40, "buff_hp_add.png", "恢复血量", "回血", },
	id_1006 = {1006, "2|2|1000", 1, "buff_hp_add.png", "恢复血量", "回血", },
	id_2006 = {2006, "2|2|2000", 5, "buff_hp_add.png", "恢复血量", "回血", },
	id_3006 = {3006, "2|2|3000", 10, "buff_hp_add.png", "恢复血量", "回血", },
	id_4006 = {4006, "2|2|4000", 20, "buff_hp_add.png", "恢复血量", "回血", },
	id_5006 = {5006, "2|2|5000", 40, "buff_hp_add.png", "恢复血量", "回血", },
	id_1007 = {1007, "3|1|1", 1, "buff_anger.png", "恢复怒气", "回怒", },
	id_3007 = {3007, "3|1|2", 10, "buff_anger.png", "恢复怒气", "回怒", },
	id_5007 = {5007, "3|1|4", 40, "buff_anger.png", "恢复怒气", "回怒", },
	id_2008 = {2008, "3|2|1", 5, "buff_anger.png", "恢复怒气", "回怒", },
	id_4008 = {4008, "3|2|2", 20, "buff_anger.png", "恢复怒气", "回怒", },
	id_5008 = {5008, "3|2|3", 10, "buff_anger.png", "恢复怒气", "回怒", },
	id_1009 = {1009, "4|1|500", 1, "buff_new_life.png", "复活", "复活", },
	id_2009 = {2009, "4|1|1000", 5, "buff_new_life.png", "复活", "复活", },
	id_3009 = {3009, "4|1|1500", 10, "buff_new_life.png", "复活", "复活", },
	id_4009 = {4009, "4|1|2000", 20, "buff_new_life.png", "复活", "复活", },
	id_5009 = {5009, "4|1|2500", 40, "buff_new_life.png", "复活", "复活", },
	id_3010 = {3010, "4|2|500", 10, "buff_new_life.png", "复活", "复活", },
	id_4010 = {4010, "4|2|1000", 20, "buff_new_life.png", "复活", "复活", },
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
	local id_data = Sky_piea_buff["id_" .. key_id]
	assert(id_data, "Sky_piea_buff not found " ..  key_id)
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
	for k, v in pairs(Sky_piea_buff) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Sky_piea_buff"] = nil
	package.loaded["DB_Sky_piea_buff"] = nil
	package.loaded["db/DB_Sky_piea_buff"] = nil
end

