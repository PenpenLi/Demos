-- Filename: DB_Item_treasure_fragment.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_treasure_fragment", package.seeall)

keys = {
	"id", "name", "info", "icon_small", "icon_big", "item_type", "quality", "sellable", "sellType", "sellNum", "maxStacking", "canDestroy", "type", "treasureId", "copyId", "dropexplore", "item_getway", 
}

Item_treasure_fragment = {
	id_5015016 = {5015016, "翎羽耳坠", "用蓝色小鸟的羽毛制成，十分精致。", "small_5_feng_1.png", "big_5_feng_1.png", 12, 6, 1, 1, 500, 999, nil, 1, 501501, nil, "13", "5", },
	id_5015026 = {5015026, "红龙耳环", "可以感知到佩戴者心情的耳环。", "small_5_feng_2.png", "big_5_feng_2.png", 12, 6, 1, 1, 500, 999, nil, 1, 501502, nil, "19", "5", },
	id_5015036 = {5015036, "深海耳环", "蓝色宝石制成的耳环。", "small_5_feng_3.png", "big_5_feng_3.png", 12, 6, 1, 1, 500, 999, nil, 1, 501503, nil, "26", "5", },
	id_5015046 = {5015046, "风通用4", "传说摩挲耳环会召唤出沉睡在耳环中的月魔，每一年，首饰工匠都需要给这双耳环的边缘重新绘上纹饰。", "small_5_feng_3.png", "big_5_feng_3.png", 12, 6, 1, 1, 500, 999, nil, 1, 501504, nil, nil, nil, },
	id_5025016 = {5025016, "紫钻指环", "贵族的藏宝室中珍藏的戒指。", "small_5_lei_1.png", "big_5_lei_1.png", 12, 6, 1, 1, 500, 999, nil, 2, 502501, nil, "17", "5", },
	id_5025026 = {5025026, "试炼之戒", "通过试炼之地才能得到的戒指。", "small_5_lei_2.png", "big_5_lei_2.png", 12, 6, 1, 1, 500, 999, nil, 2, 502502, nil, "23", "5", },
	id_5025036 = {5025036, "烈火指轮", "镶嵌着红宝石的戒指。", "small_5_lei_3.png", "big_5_lei_3.png", 12, 6, 1, 1, 500, 999, nil, 2, 502503, nil, nil, "5", },
	id_5025046 = {5025046, "雷通用4", "镶嵌着红宝石的戒指，佩戴上后仿佛能感受到火焰的温度。", "small_5_lei_3.png", "big_5_lei_3.png", 12, 6, 1, 1, 500, 999, nil, 2, 502504, nil, nil, nil, },
	id_5035016 = {5035016, "星芒项链", "星星形状的项坠。", "small_5_shui_1.png", "big_5_shui_1.png", 12, 6, 1, 1, 500, 999, nil, 3, 503501, nil, "15", "5", },
	id_5035026 = {5035026, "紫云晶挂坠", "紫色晶石制造的项链。", "small_5_shui_2.png", "big_5_shui_2.png", 12, 6, 1, 1, 500, 999, nil, 3, 503502, nil, "21", "5", },
	id_5035036 = {5035036, "远古之心", "由稀有的远古宝石制成的项链。", "small_5_shui_3.png", "big_5_shui_3.png", 12, 6, 1, 1, 500, 999, nil, 3, 503503, nil, nil, "5", },
	id_5035046 = {5035046, "水通用4", "古老王室传承的项链，使用的是稀有的远古宝石。", "small_5_shui_3.png", "big_5_shui_3.png", 12, 6, 1, 1, 500, 999, nil, 3, 503504, nil, nil, nil, },
	id_5010013 = {5010013, "风精灵", "风元素的精华孕育出的精灵。可用于饰品强化，提供2000饰品经验。", "small_5_feng_91.png", "big_5_feng_91.png", 12, 6, 1, 1, 500, 999, nil, 1, 501001, nil, nil, nil, },
	id_5020013 = {5020013, "雷精灵", "雷元素的精华孕育出的精灵。可用于饰品强化，提供2000饰品经验。", "small_5_lei_91.png", "big_5_lei_91.png", 12, 6, 1, 1, 500, 999, nil, 2, 502001, nil, nil, nil, },
	id_5030013 = {5030013, "水精灵", "水元素的精华孕育出的精灵。可用于饰品强化，提供2000饰品经验。", "small_5_shui_91.png", "big_5_shui_91.png", 12, 6, 1, 1, 500, 999, nil, 3, 503001, nil, nil, nil, },
	id_5040013 = {5040013, "火精灵", "火元素的精华孕育出的精灵。可用于饰品强化，提供2000饰品经验。", "small_5_huo_91.png", "big_5_huo_91.png", 12, 6, 1, 1, 500, 999, nil, 4, 504001, nil, nil, nil, },
	id_5010103 = {5010103, "饰品精华", "可用于精炼紫色饰品。", "small_5_feng_101.png", "big_5_feng_101.png", 12, 6, 1, 1, 500, 999, nil, 1, 501010, nil, nil, nil, },
	id_5005016 = {5005016, "通用饰品2", "我是通用饰品2", "small_5_tongyong_1.png", "big_5_tongyong_1.png", 12, 6, 1, 1, 500, 999, nil, 0, 500501, nil, nil, nil, },
	id_5000013 = {5000013, "经验银钻", "在饰品强化处使用可增加200点饰品经验。", "small_4_tongyong_91.png", "big_4_tongyong_91.png", 12, 4, 1, 1, 400, 999, nil, 0, 500001, nil, nil, "17", },
	id_5000023 = {5000023, "经验金钻", "在饰品强化处使用可增加1000点饰品经验。", "small_5_tongyong_91.png", "big_5_tongyong_91.png", 12, 5, 1, 1, 500, 999, nil, 0, 500002, nil, nil, "17", },
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
	local id_data = Item_treasure_fragment["id_" .. key_id]
	assert(id_data, "Item_treasure_fragment not found " ..  key_id)
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
	for k, v in pairs(Item_treasure_fragment) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_treasure_fragment"] = nil
	package.loaded["DB_Item_treasure_fragment"] = nil
	package.loaded["db/DB_Item_treasure_fragment"] = nil
end

