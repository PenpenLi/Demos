-- Filename: DB_Getway.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Getway", package.seeall)

keys = {
	"id", "getway_name", "getway_desc", "getway_icon", "type", 
}

Getway = {
	id_1 = {1, "巨蛇宝藏", "攻打巨蛇宝藏日常副本可获得大量贝里", "activity_belly.png", 1, },
	id_2 = {2, "购买贝里", "使用金币可购买大量贝里", "activity_belly.png", 1, },
	id_3 = {3, "资源矿", "资源矿可以产出大量贝里", "day_task_22.png", 1, },
	id_4 = {4, "公会商店", "公会商店可兑换", "shop_guild.png", 1, },
	id_5 = {5, "伙伴商店", "伙伴商店可兑换伙伴", "activity_mystery.png", 1, },
	id_6 = {6, "竞技场商店", "竞技场商店可购买进阶石", "shop_arena.png", 1, },
	id_7 = {7, "普通副本", "攻打普通副本可获得心仪的道具", "drop_copy.png", 1, },
	id_8 = {8, "精英副本", "攻打精英副本可获得突破石", "drop_elitecopy.png", 1, },
	id_9 = {9, "探索", "进行探索可获得心仪的道具", "drop_explore.png", 1, },
	id_10 = {10, "伙伴回收", "回收伙伴可获得海魂", "drop_resolve.png", 1, },
	id_11 = {11, "装备商店", "可兑换装备和附魔石", "shop_equip.png", 1, },
	id_12 = {12, "宝物商店", "宝物商店可兑换饰品、专属宝物和万能材料", "shop_trea.png", 1, },
	id_13 = {13, "船魂回收", "回收船魂可获得强化所用木材", "drop_resolve.png", 1, },
	id_14 = {14, "宝物回收", "回收宝物可获得宝物结晶", "drop_resolve.png", 1, },
	id_15 = {15, "装备回收", "回收装备可获得装备结晶", "drop_resolve.png", 1, },
	id_16 = {16, "饰品回收", "回收饰品可获得饰品精炼石", "drop_resolve.png", 1, },
	id_17 = {17, "巴奇宝钻", "日常副本巴奇宝钻可以产出经验饰品", "acopy_monster_small_3.png", 1, },
	id_18 = {18, "亿万悬赏", "亿万悬赏必得热点伙伴或热点伙伴影子", "drop_senior.png", 1, },
	id_19 = {19, "影子回收", "回收影子可以获得海魂", "drop_resolve.png", 1, },
	id_20 = {20, "觉醒商店", "觉醒商店可购买觉醒材料", "shop_awake.png", 1, },
	id_21 = {21, "开服礼包", "开服礼包可获得高级伙伴和宝物", "btn_open_server_n.png", 1, },
	id_22 = {22, "等级礼包", "领取等级礼包可获得路飞影子", "activity_level.png", 1, },
	id_23 = {23, "深海监狱", "勇闯深海监狱可获得大量装备结晶", "day_task_21.png", 1, },
	id_24 = {24, "觉醒背包", "觉醒背包可回收觉醒道具获得觉醒结晶", "strong_juexing.png", 1, },
	id_25 = {25, "觉醒副本", "攻打觉醒副本可获得觉醒材料", "drop_awake_copy.png", 1, },
	id_26 = {26, "噩梦副本", "攻打噩梦副本可获得材料", "drop_copy.png", 1, },
	id_27 = {27, "酒馆", "酒馆可购买大量资源", "drop_shop.png", 1, },
	id_28 = {28, "首充礼包", "累计充值198元即可获得", "activity_first_recharge.png", 0, },
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
	local id_data = Getway["id_" .. key_id]
	assert(id_data, "Getway not found " ..  key_id)
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
	for k, v in pairs(Getway) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Getway"] = nil
	package.loaded["DB_Getway"] = nil
	package.loaded["db/DB_Getway"] = nil
end

