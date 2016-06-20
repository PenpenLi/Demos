-- Filename: DB_Goods.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Goods", package.seeall)

keys = {
	"id", "sell_mode", "type", "icon", "desc", "original_price", "current_price", "vip_needed", "user_lv_needed", "vip_discount", "limit_num", "item_id", "hero_id", "drop_table_id", "buy_siliver_num", "cost_gold_add_siliver", "belly_critical", "belly_critical_must", "is_show", "factor", "recommended", 
}

Goods = {
	id_1 = {1, 2, 10, nil, "中号体力药水，可以抵抗困意。使用后可获得25点体力。", 50, 0, 0, 0, nil, 0, 10032, nil, nil, nil, "1|25,2|25,3|30,4|30,5|40,6|40,7|50,8|50,9|60,10|60,11|80,12|80,13|100,14|100,15|100,16|100,17|100,18|100,19|100,20|120,21|120", nil, nil, 1, nil, 1, },
	id_2 = {2, 2, 11, nil, "中号耐力药水，味道还不错。饮用后可获得5点耐力。", 50, 0, 0, 0, nil, nil, 10042, nil, nil, nil, "1|30,2|30,3|40,4|40,5|50,6|50,7|50,8|50,9|60,10|60,11|60,12|60,13|60,14|80,15|80,16|80,17|80,18|80,19|80,20|80,21|80,22|80,23|80,24|80,25|80,26|100,27|100,28|100,29|100,30|100,31|100,32|100,33|100,34|100,35|100,36|100,37|100,38|100,39|100,40|100,41|100,42|100,43|100,44|100,45|100", nil, nil, 1, nil, 1, },
	id_11 = {11, 3, 1, nil, "多年前被某个著名海盗藏在村外小山洞中的宝箱，打开后可获得贝里。", nil, 0, 0, 0, nil, nil, nil, nil, nil, 4000, "1|10,2|10,3|10,4|20,5|20,6|20,7|20,8|20,9|20,10|20,11|20,12|20,13|20,14|20,15|30,16|30,17|30,18|30,19|30,20|30,21|30,22|30,23|30,24|30,25|30,26|30,27|30,28|30,29|30,30|50", "1|1000000,2|100000,3|50000,4|25000,5|12500,6|6250,7|3130,8|1500,9|1000,10|500", "5|2", 0, "270,340,100", 1, },
	id_10 = {10, 3, 2, nil, "每个影子可提供10000伙伴经验。", nil, 5, 0, 0, nil, nil, 440001, nil, nil, nil, "1|0,2|5,3|10,4|15", nil, nil, 1, nil, 1, },
	id_7 = {7, 3, 5, nil, "金钥匙，用于开启黄金宝箱。", nil, 128, 0, 0, nil, nil, 30013, nil, nil, nil, nil, nil, nil, 0, nil, 1, },
	id_9 = {9, 3, 7, nil, "银钥匙，用于开启白银宝箱。", nil, 48, 0, 0, nil, nil, 30012, nil, nil, nil, nil, nil, nil, 0, nil, 1, },
	id_13 = {13, 3, 9, nil, "宝物礼盒，开启可以获得宝物或碎片。", nil, 80, 0, 0, nil, nil, 30016, nil, nil, nil, nil, nil, nil, 1, nil, 1, },
	id_14 = {14, 3, 12, nil, "用于装备附魔，可增加50点附魔经验，附魔等级提升会提高装备属性。", nil, 20, 0, 0, nil, nil, 60504, nil, nil, nil, nil, nil, nil, 1, nil, 1, },
	id_15 = {15, 3, 13, nil, "含有少量钒的合金材料，韧性极强，是船炮强化的材料之一。", nil, 5, 0, 0, nil, nil, 60801, nil, nil, nil, nil, nil, nil, 1, nil, 1, },
	id_16 = {16, 3, 14, nil, "可由火花、火焰等引起剧烈燃烧的粉末状物品，是船炮强化的材料之一。", nil, 20, 0, 0, nil, nil, 60802, nil, nil, nil, nil, nil, nil, 1, nil, 1, },
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
	local id_data = Goods["id_" .. key_id]
	assert(id_data, "Goods not found " ..  key_id)
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
	for k, v in pairs(Goods) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Goods"] = nil
	package.loaded["DB_Goods"] = nil
	package.loaded["db/DB_Goods"] = nil
end

