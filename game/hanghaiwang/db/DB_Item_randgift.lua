-- Filename: DB_Item_randgift.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_randgift", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "dropID", "delayOpenTime", "use_minRoleLv", "use_maxRoleLv", "use_needItem", "use_needNum", "use_costBely", "use_costGold", 
}

Item_randgift = {
	id_30001 = {30001, "原木宝箱", "用青铜制造的宝箱，开启后可获得白色、绿色饰品。", "tongxiangzi.png", nil, 8, 3, 0, nil, nil, 9999, nil, 0, 11, nil, 1, 999, nil, 1, nil, nil, },
	id_30002 = {30002, "白银宝箱", "用白银铸造的宝箱，开启后可获得绿色、蓝色饰品。", "yinxiangzi.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 12, nil, 1, 999, nil, 1, nil, nil, },
	id_30003 = {30003, "黄金宝箱", "用黄金铸造的宝箱，开启后可获得绿色、蓝色、紫色饰品。", "jinxiangzi.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 13, nil, 1, 999, nil, 1, nil, nil, },
	id_30004 = {30004, "白金宝箱", "白金宝箱", "datili.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 11, nil, 1, 999, nil, 1, nil, nil, },
	id_30005 = {30005, "钻石宝箱", "钻石宝箱", "datili.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 12, nil, 1, 999, nil, 1, nil, nil, },
	id_30011 = {30011, "青铜钥匙", "铜钥匙，用于开启青铜宝箱。开启后可获得低品质物品。", "tongyaoshi.png", nil, 8, 3, 0, nil, nil, 9999, nil, 0, 11, nil, 1, 999, nil, 1, nil, nil, },
	id_30012 = {30012, "白银钥匙", "银钥匙，用于开启中级饰品宝箱。开启后可获得紫色、蓝色饰品或橙饰品碎片。", "yinyaoshi.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 12, nil, 1, 999, nil, 1, nil, nil, },
	id_30013 = {30013, "黄金钥匙", "金钥匙，用于开启高级饰品宝箱。开启后可获得橙色、紫色饰品或橙饰品碎片。", "jinyaoshi.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 13, nil, 1, 999, nil, 1, nil, nil, },
	id_30014 = {30014, "白金钥匙", "开启白金箱子", "datili.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 11, nil, 1, 999, nil, 1, nil, nil, },
	id_30015 = {30015, "钻石钥匙", "开启钻石箱子", "datili.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 12, nil, 1, 999, nil, 1, nil, nil, },
	id_30016 = {30016, "宝物礼盒", "使用后，可随机获得一个宝物或宝物碎片", "shipinlihe.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 1, nil, 1, 999, nil, 1, nil, nil, },
	id_30017 = {30017, "紫伙伴包", "莫利亚用于存放伙伴的礼包，打开后获得1个紫色伙伴(30个碎片)", "yingzibao6.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 6403, nil, 1, 999, nil, 1, nil, nil, },
	id_30018 = {30018, "橙伙伴包", "莫利亚用于存放伙伴的礼包，打开后获得1个橙色伙伴(80个碎片)", "yingzibao6.png", nil, 8, 6, 0, nil, nil, 9999, nil, 0, 6414, nil, 1, 999, nil, 1, nil, nil, },
	id_30019 = {30019, "紫影子包(5)", "莫利亚用于存放伙伴影子的礼包，打开后获得5个紫色伙伴影子。", "yingzibao6.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 6401, nil, 1, 999, nil, 1, nil, nil, },
	id_30020 = {30020, "紫影子包(10)", "莫利亚用于存放伙伴影子的礼包，打开后获得10个紫色伙伴影子。", "yingzibao6.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 6402, nil, 1, 999, nil, 1, nil, nil, },
	id_30021 = {30021, "蓝伙伴影子包", "莫利亚用于存放伙伴影子的礼包，打开后获得1个蓝色伙伴影子。", "yingzibao6.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 901, nil, 1, 999, nil, nil, nil, nil, },
	id_30022 = {30022, "紫伙伴影子包", "莫利亚用于存放伙伴影子的礼包，打开后获得1个紫色伙伴影子。", "yingzibao6.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 602, nil, 1, 999, nil, nil, nil, nil, },
	id_30023 = {30023, "橙伙伴影子包", "莫利亚用于存放伙伴影子的礼包，打开后获得1个橙色伙伴影子。", "yingzibao6.png", nil, 8, 6, 0, nil, nil, 9999, nil, 0, 603, nil, 1, 999, nil, nil, nil, nil, },
	id_30024 = {30024, "宝物礼盒", "使用后，可随机获得一个宝物或宝物碎片", "baowulihe.png", nil, 8, 6, 0, nil, nil, 9999, nil, 0, 15, nil, 1, 999, nil, 1, nil, nil, },
	id_30025 = {30025, "橙影子包(10)", "莫利亚用于存放伙伴影子的礼包，打开后获得10个橙色伙伴影子。", "yingzibao6.png", nil, 8, 6, 0, nil, nil, 9999, nil, 0, 6412, nil, 1, 999, nil, 1, nil, nil, },
	id_30101 = {30101, "绿色礼物包", "装有礼物的绿色好感礼物随机礼包，使用后可获得1个绿色名将好感礼物。", "libao1.png", nil, 8, 3, 0, nil, nil, 9999, nil, 0, 502, nil, 1, 999, nil, nil, nil, nil, },
	id_30102 = {30102, "蓝色礼物包", "装有礼物的蓝色好感礼物随机礼包，使用后可获得1个蓝色名将好感礼物。", "libao2.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 503, nil, 1, 999, nil, nil, nil, nil, },
	id_31001 = {31001, "测试宝箱", "测试获得英雄", "tongxiangzi.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 11, nil, 1, 999, 31002, 1, nil, nil, },
	id_31002 = {31002, "测试钥匙", "测试获得英雄", "tongyaoshi.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 12, nil, 1, 999, 31001, 1, nil, nil, },
	id_30031 = {30031, "紫魔防饰品包", "装有紫色品质饰品的礼包，使用后可获得1个紫色魔防型饰品。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 332, nil, 1, 999, nil, nil, nil, nil, },
	id_30032 = {30032, "紫攻击饰品包", "装有紫色品质饰品的礼包，使用后可获得1个紫色攻击型饰品。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 331, nil, 1, 999, nil, nil, nil, nil, },
	id_30033 = {30033, "紫生命饰品包", "装有紫色品质饰品的礼包，使用后可获得1个紫色生命型饰品。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 335, nil, 1, 999, nil, nil, nil, nil, },
	id_30034 = {30034, "紫物防饰品包", "装有紫色品质饰品的礼包，使用后可获得1个紫色物防型饰品。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 336, nil, 1, 999, nil, nil, nil, nil, },
	id_30041 = {30041, "橙魔防饰品包", "装有橙色品质饰品的礼包，使用后可获得1个橙色魔防型饰品。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 334, nil, 1, 999, nil, nil, nil, nil, },
	id_30042 = {30042, "橙攻击饰品包", "装有橙色品质饰品的礼包，使用后可获得1个橙色攻击型饰品。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 333, nil, 1, 999, nil, nil, nil, nil, },
	id_30043 = {30043, "橙生命饰品包", "装有橙色品质饰品的礼包，使用后可获得1个橙色生命型饰品。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 337, nil, 1, 999, nil, nil, nil, nil, },
	id_30044 = {30044, "橙物防饰品包", "装有橙色品质饰品的礼包，使用后可获得1个橙色物防型饰品。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 338, nil, 1, 999, nil, nil, nil, nil, },
	id_30051 = {30051, "蓝书碎片包", "蓝色兵书碎片礼包，使用后可获得1个蓝色兵书碎片。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 322, nil, 1, 999, nil, nil, nil, nil, },
	id_30052 = {30052, "紫书碎片包", "紫色兵书碎片礼包，使用后可获得1个紫色兵书碎片。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 323, nil, 1, 999, nil, nil, nil, nil, },
	id_30061 = {30061, "蓝马碎片包", "蓝色战马碎片礼包，使用后可获得1个蓝色战马碎片。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 312, nil, 1, 999, nil, nil, nil, nil, },
	id_30062 = {30062, "紫马碎片包", "紫色战马碎片礼包，使用后可获得1个紫色战马碎片。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 313, nil, 1, 999, nil, nil, nil, nil, },
	id_30071 = {30071, "蓝饰品碎片包", "蓝色饰品碎片包，使用后可随机获得1个蓝色碎片。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 303, nil, 1, 999, nil, nil, nil, nil, },
	id_30081 = {30081, "蓝装备碎片包", "蓝色装备碎片包，使用后可随机获得1个蓝色装备碎片（可获得套装）。", "libao2.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 208, nil, 1, 999, nil, nil, nil, nil, },
	id_30091 = {30091, "紫装备碎片包", "紫色装备碎片包，使用后可随机获得1个紫色装备碎片（可获得套装）。", "libao2.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 209, nil, 1, 999, nil, nil, nil, nil, },
	id_30092 = {30092, "装备礼盒", "使用后，可随机获得一个装备或装备碎片", "libao2.png", nil, 8, 6, 0, nil, nil, 9999, nil, 0, 16, nil, 1, 999, nil, nil, nil, nil, },
	id_30201 = {30201, "5星伙伴包", "莫利亚用于存放伙伴影子的礼包，打开后获得一个12资质的紫色伙伴影子。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 902, nil, 1, 999, nil, nil, nil, nil, },
	id_30302 = {30302, "橙色伙伴包", "莫利亚用于存放伙伴影子的礼包，打开后获得1个橙色伙伴的80个影子。", "vip_gift_3.png", nil, 8, 6, 0, nil, nil, 9999, nil, 0, 903, nil, 1, 999, nil, nil, nil, nil, },
	id_30301 = {30301, "放开那红包", "放开那红包，“红”福齐天！使用后可随机获得50、100或500金币！", "jinbihongbao.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 805, nil, 1, 999, nil, nil, nil, nil, },
	id_30303 = {30303, "汤圆", "深受大家欢迎的传统小吃，元宵节时销路最佳！使用后可获得惊喜奖励。", "festival_tangyuan.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 210001, nil, 1, 999, nil, nil, nil, nil, },
	id_30304 = {30304, "小树苗", "植树节使用，一分耕耘一分收获，汗水之后必定是惊喜。", "festival_tree.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 210002, nil, 1, 999, nil, nil, nil, nil, },
	id_30305 = {30305, "彩蛋", "给鸡蛋涂上各种美丽的色彩和图案，打开后礼物就在其中。", "festival_egg.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 210003, nil, 1, 999, nil, nil, nil, nil, },
	id_30401 = {30401, "紫饰品礼盒", "装有礼物的紫色饰品随机礼包，使用后可获得1个紫色饰品。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 110001, nil, 1, 999, nil, nil, nil, nil, },
	id_30402 = {30402, "橙饰品礼盒", "装有礼物的橙色饰品随机礼包，使用后可获得1个橙色饰品。", "libao3.png", nil, 8, 6, 0, nil, nil, 9999, nil, 0, 306, nil, 1, 999, nil, nil, nil, nil, },
	id_30403 = {30403, "橙饰品礼盒", "装有礼物的橙色饰品随机礼包，使用后可获得1个橙色饰品。", "libao3.png", nil, 8, 6, 0, nil, nil, 9999, nil, 0, 313, nil, 1, 999, nil, nil, nil, nil, },
	id_30501 = {30501, "惊喜奖励礼包", "使用后可获得橘子镇探索点中的紫色饰品碎片1个。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 150001, nil, 1, 999, nil, nil, nil, nil, },
	id_30502 = {30502, "惊喜奖励礼包", "使用后可获得阿龙公园探索点中的紫色饰品碎片1个。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 150002, nil, 1, 999, nil, nil, nil, nil, },
	id_30503 = {30503, "惊喜奖励礼包", "使用后可获得巴格镇探索点中的紫色饰品碎片1个。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 150003, nil, 1, 999, nil, nil, nil, nil, },
	id_30504 = {30504, "惊喜奖励礼包", "使用后可获得威士忌山峰探索点中的紫色饰品碎片1个。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 150004, nil, 1, 999, nil, nil, nil, nil, },
	id_30505 = {30505, "惊喜奖励礼包", "使用后可获得铁桶岛探索点中的紫色饰品碎片1个。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 150005, nil, 1, 999, nil, nil, nil, nil, },
	id_30506 = {30506, "惊喜奖励礼包", "使用后可获得阿拉巴斯坦探索点中的紫色饰品碎片1个。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 150006, nil, 1, 999, nil, nil, nil, nil, },
	id_30507 = {30507, "惊喜奖励礼包", "使用后可获得黄金乡探索点中的紫色饰品碎片1个。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 150007, nil, 1, 999, nil, nil, nil, nil, },
	id_30508 = {30508, "惊喜奖励礼包", "使用后可获得七水之城探索点中的紫色饰品碎片1个。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 150008, nil, 1, 999, nil, nil, nil, nil, },
	id_30509 = {30509, "惊喜奖励礼包", "使用后可获得司法之塔探索点中的紫色饰品碎片1个。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 150009, nil, 1, 999, nil, nil, nil, nil, },
	id_30510 = {30510, "惊喜奖励礼包", "使用后可获得踌躇之桥探索点中的紫色饰品碎片1个。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 150010, nil, 1, 999, nil, nil, nil, nil, },
	id_30511 = {30511, "奇遇在线奖励1", "奇遇在线奖励1", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 180001, nil, 1, 999, nil, nil, nil, nil, },
	id_30512 = {30512, "奇遇在线奖励2", "奇遇在线奖励2", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 180002, nil, 1, 999, nil, nil, nil, nil, },
	id_30513 = {30513, "奇遇开宝箱1", "奇遇开宝箱1", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 191001, nil, 1, 999, nil, nil, nil, nil, },
	id_30601 = {30601, "绿觉醒礼包", "使用后可获得2个绿色觉醒材料", "libao3.png", nil, 8, 3, 0, nil, nil, 9999, nil, 0, 209001, nil, 1, 999, nil, nil, nil, nil, },
	id_30602 = {30602, "蓝觉醒礼包", "使用后可获得2个蓝色觉醒材料", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 209002, nil, 1, 999, nil, nil, nil, nil, },
	id_30701 = {30701, "船炮资源包", "使用后可随机获得船炮的升级材料", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 209101, nil, 1, 999, nil, nil, nil, nil, },
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
	local id_data = Item_randgift["id_" .. key_id]
	assert(id_data, "Item_randgift not found " ..  key_id)
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
	for k, v in pairs(Item_randgift) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_randgift"] = nil
	package.loaded["DB_Item_randgift"] = nil
	package.loaded["db/DB_Item_randgift"] = nil
end

