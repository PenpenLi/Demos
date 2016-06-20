-- Filename: DB_Level_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Level_reward", package.seeall)

keys = {
	"id", "level", "reward_num", "reward_content1", "reward_type1", "reward_quality1", "reward_values1", "reward_desc1", "reward_type2", "reward_quality2", "reward_values2", "reward_desc2", "reward_type3", "reward_quality3", "reward_values3", "reward_desc3", "reward_type4", "reward_quality4", "reward_values4", "reward_desc4", "reward_type5", "reward_quality5", "reward_values5", "reward_desc5", "reward_type6", "reward_quality6", "reward_values6", "reward_desc6", "reward_type7", "reward_quality7", "reward_values7", "reward_desc7", "reward_type8", "reward_quality8", "reward_values8", "reward_desc8", 
}

Level_reward = {
	id_1 = {1, 5, 2, "一小叠贝里，能用它添置一些装备。", 1, 3, "20000", "贝里", 7, 4, "440023|10", "经验蓝影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_2 = {2, 10, 3, "金币和金条的巨大财宝堆，使用后可获得40金币。", 3, 5, "50", "金币", 7, 4, "440023|10", "经验蓝影", 7, 5, "60002|20", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_3 = {3, 12, 3, "金币和金条的巨大财宝堆，使用后可获得50金币。", 3, 5, "100", "金币", 13, 4, "10102|1", "希尔尔克", 7, 5, "60002|30", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_4 = {4, 15, 4, "金币和金条的巨大财宝堆，使用后可获得60金币。", 3, 5, "100", "金币", 7, 5, "60002|30", "进阶石", 1, 5, "60000", "贝里", 7, 4, "440023|15", "经验蓝影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_5 = {5, 18, 4, "金币和金条的巨大财宝堆，使用后可获得60金币。", 3, 5, "100", "金币", 7, 5, "440001|10", "经验紫影", 1, 5, "100000", "贝里", 7, 4, "101312|1", "冒险手枪", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_6 = {6, 20, 4, "金币和金条的巨大财宝堆，使用后可获得60金币。", 3, 5, "120", "金币", 7, 4, "103312|1", "冒险船帽", 1, 5, "140000", "贝里", 7, 5, "60002|40", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_7 = {7, 23, 4, "金币和金条的巨大财宝堆，使用后可获得80金币。", 3, 5, "120", "金币", 7, 5, "440001|9", "经验紫影", 1, 5, "160000", "贝里", 7, 5, "503402|1", "羽毛项坠", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_8 = {8, 25, 4, "金币和金条的巨大财宝堆，使用后可获得80金币。", 3, 5, "150", "金币", 7, 4, "104312|1", "冒险马甲", 1, 5, "180000", "贝里", 7, 5, "60002|40", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_9 = {9, 28, 4, "金币和金条的巨大财宝堆，使用后可获得80金币。", 3, 5, "150", "金币", 7, 5, "500002|2", "经验金钻", 1, 5, "200000", "贝里", 7, 5, "440001|20", "经验紫影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10 = {10, 30, 4, "金币和金条的巨大财宝堆，使用后可获得100金币。", 3, 5, "180", "金币", 7, 5, "500002|2", "经验金钻", 1, 5, "220000", "贝里", 7, 5, "60002|50", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_11 = {11, 33, 4, "金币和金条的巨大财宝堆，使用后可获得100金币。", 3, 5, "180", "金币", 7, 5, "440001|15", "经验紫影", 1, 5, "240000", "贝里", 7, 5, "60029|100", "宝物晶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_12 = {12, 36, 4, "金币和金条的巨大财宝堆，使用后可获得100金币。", 3, 5, "180", "金币", 7, 5, "440001|16", "经验紫影", 1, 5, "280000", "贝里", 7, 5, "60503|10", "高级附魔石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_13 = {13, 38, 4, "金币和金条的巨大财宝堆，使用后可获得150金币。", 3, 5, "200", "金币", 7, 5, "440001|19", "经验紫影", 1, 5, "320000", "贝里", 7, 5, "60503|15", "高级附魔石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_14 = {14, 40, 4, "金币和金条的巨大财宝堆，使用后可获得150金币。", 3, 5, "200", "金币", 7, 5, "440001|25", "经验紫影", 1, 5, "360000", "贝里", 7, 5, "60029|100", "宝物晶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_15 = {15, 45, 4, "金币和金条的巨大财宝堆，使用后可获得150金币。", 3, 5, "200", "金币", 7, 5, "440001|30", "经验紫影", 1, 5, "420000", "贝里", 7, 5, "60503|20", "高级附魔石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_16 = {16, 50, 4, "金币和金条的巨大财宝堆，使用后可获得200金币。", 3, 5, "240", "金币", 7, 5, "440001|35", "经验紫影", 1, 5, "480000", "贝里", 7, 5, "60029|100", "宝物晶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_17 = {17, 55, 4, "金币和金条的巨大财宝堆，使用后可获得200金币。", 3, 5, "240", "金币", 7, 5, "60008|400", "饰品精炼石", 1, 5, "540000", "贝里", 7, 5, "60503|20", "高级附魔石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_18 = {18, 60, 4, "金币和金条的巨大财宝堆，使用后可获得300金币。", 3, 5, "300", "金币", 7, 5, "500002|10", "经验金钻", 1, 5, "600000", "贝里", 7, 5, "60029|100", "宝物晶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_19 = {19, 65, 4, "金币和金条的巨大财宝堆，使用后可获得300金币。", 3, 5, "300", "金币", 7, 5, "60008|600", "饰品精炼石", 1, 5, "660000", "贝里", 7, 5, "60503|20", "高级附魔石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_20 = {20, 70, 4, "金币和金条的巨大财宝堆，使用后可获得300金币。", 3, 5, "300", "金币", 7, 5, "500002|15", "经验金钻", 1, 5, "720000", "贝里", 7, 5, "60029|100", "宝物晶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Level_reward["id_" .. key_id]
	assert(id_data, "Level_reward not found " ..  key_id)
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
	for k, v in pairs(Level_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Level_reward"] = nil
	package.loaded["DB_Level_reward"] = nil
	package.loaded["db/DB_Level_reward"] = nil
end

