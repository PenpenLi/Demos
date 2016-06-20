-- Filename: DB_Normal_config.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Normal_config", package.seeall)

keys = {
	"id", "changeName", "clearFightCdCost", "treasureOpenLevel", "clearFightTimesCost", "astrologyItem", "gold_box_change", "explore_cost", "binding_reward", "newplayer_lv", "explore_sure_reward", "explore_rank_reward", "conchOpenLevel", "air_island_reward", "shop_drop_shadow", "lufei_limit_lv", "equip_str5_lv", "helpArmyIncomeRatio", "oneHelpArmyEnhance", "lootHelpArmyCostExection", "resPlayerLv", "resAddTime", "resPlayerVip", "helpArmyTime", "goldResCost", "min_time", "res_ratio", "lcopy_round", "res_type", "Level_execution", "Level_stamina", "gold_box_switch", "belly_copy_round", "equip_level", "start_upgrade_level", "resetDcopyBaseCost", "signcircle", "no_exp_stronghold", "get_item_stronghold", "free_time_cd", "free_time_remain", "allshop_start_level", "res_silver_legionadd", "res_wood_legionadd", "res_wood_ratio", "sign_charge_lv", 
}

Normal_config = {
	id_1 = {1, "100|60012", "10|10|100", "18,22,25", "10|10|100", "60013|1", 10, "1", "3|0|100,7|30013|1", "2|3|4|5|7|9|13|14|15|16|19|23|42", "10|3|0|20,20|3|0|30,30|7|501301|1,40|7|502301|1,50|7|503401|1,60|14|5015016|2,70|14|5015016|2,100|14|5015016|2", "50", "30,32,37,42,47,55", "60021|60022|60023|60024", "440001,440002,440022,440023", "10031|20,10173|20", 7, 50, 10, 5, 20, "28800|0|5,28800|10|5,28800|20|5", 1, 28800, 50, 3600, 116, 10, "4|3|2|1,1|2|3|4,4|5|6|7", "0|0|0|0|0|10|10|10|10|10|10|10|10|10|10|15|15|15|15|15|20|20|20|20|20|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25|25", "0|0|0|0|0|0|0|8|5|5|5|5|5|5|5|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10|10", "4|25", 5, 30, 30, "10|10|100", "1,2,3,4,5,6,7,8,9,10,11,12", "5010", "5010|40003", 169200, 1800, 16, "3|600,4|1200,5|1800", "3|15,4|30,5|45", 278, 20, },
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
	local id_data = Normal_config["id_" .. key_id]
	assert(id_data, "Normal_config not found " ..  key_id)
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
	for k, v in pairs(Normal_config) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Normal_config"] = nil
	package.loaded["DB_Normal_config"] = nil
	package.loaded["db/DB_Normal_config"] = nil
end

