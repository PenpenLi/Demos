-- Filename: DB_Item_normal.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_normal", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "isSellDirect", "item_getway", "enhance_exp", 
}

Item_normal = {
	id_60001 = {60001, "悬赏单", "世界政府通缉海盗而发布的悬赏单，可用于招募伙伴。", "xuanshangdan.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60002 = {60002, "进阶石", "可用于伙伴进阶。", "lanboqiu.png", "lanboqiu_big.png", 10, 5, 1, 1, 1000, 9999, nil, 1, nil, "5|6|7|9", nil, },
	id_60003 = {60003, "小喇叭", "消耗1个小喇叭可以进行1次世界聊天。", "lanboqiu.png", nil, 10, 1, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60004 = {60004, "大喇叭", "消耗1个大喇叭可以进行1次世界广播。", "lanboqiu.png", nil, 10, 1, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60005 = {60005, "免战旗", "可以将主船隐藏的神奇旗子，可用于在夺宝中开启免战。", "lanboqiu.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60006 = {60006, "刷新卡", "可用于刷新商店中的商品。", "shenmishuaxinka.png", "big_shenmishuaxinka.png", 10, 5, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60007 = {60007, "洗炼石", "阿拉巴斯坦的沙丘中出现的闪闪发亮的石头。可用于洗练装备。", "lanboqiu.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60008 = {60008, "饰品精炼石", "可用于精炼饰品。", "baowujinghua.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, nil, "16|6", nil, },
	id_60009 = {60009, "蓝色宝物碎片", "可随机获得一个蓝色宝物碎片。", "lanboqiu.png", nil, 10, 4, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60010 = {60010, "蓝色装备碎片", "可随机获得一个蓝色装备碎片。", "lanboqiu.png", nil, 10, 4, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60011 = {60011, "永久指针", "附有龙魂之力，可用于猎魂中召唤神龙开启第4场景。", "lanboqiu.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60012 = {60012, "更名卡", "舍弃之前的声名和威望，你确定要这么做吗？用于更改主角名称。", "gengmingka.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60013 = {60013, "奥秘牌", "“给你一次重新选择人生的机会”——《塔罗之道》。使用后可免费刷新一次已有塔罗牌。", "lanboqiu.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60014 = {60014, "强攻旗", "可用于免费重置普通副本攻打次数。", "lanboqiu.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60015 = {60015, "伐树令", "进入摇钱树乐园用的门票，可用于额外攻打摇钱树活动副本。", "lanboqiu.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60016 = {60016, "时装精华", "谜一样的水晶，靠近时装时会自动向前骑上，光彩非常。可用于强化时装。", "lanboqiu.png", nil, 10, 5, 1, 1, 1000, 9999, nil, 1, nil, nil, nil, },
	id_60017 = {60017, "觉醒令", "蕴含突破武将能力，领悟觉醒的力量。可用于洗练武将觉醒能力。", "lanboqiu.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60018 = {60018, "紫色宝物碎片", "可随机获得一个紫色宝物碎片。", "lanboqiu.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, nil, nil, nil, },
	id_60019 = {60019, "探险指针", "精致小巧，航海士会把它伪装成纽扣钉在衣服上。用于增加探索次数。", "explore_compass.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60020 = {60020, "夺宝指针", "指针所指的两个方向中必有一个会出现珍贵的宝藏，想好选哪边了吗？可用于增加夺宝次数。", "lanboqiu.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60021 = {60021, "空岛贝", "空岛特产，居家旅行报仇打架必备，可装备在伙伴身上，增强战斗力。", "conch_gongji.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60022 = {60022, "空岛币", "空岛上的通用货币，可在神秘空岛中兑换物品。", "air_coin.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60023 = {60023, "杂货", "海盗们争相购买的各种杂货，在背包出售后可获得大量贝里。", "small_sell_mutong_1.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60024 = {60024, "紫色影子", "稀有的紫色伙伴影子，集齐一定数量后可合成紫色伙伴。", "purple_shadow.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60025 = {60025, "突破石", "可用于将紫色伙伴突破为橙色。", "xilianshi.png", "big_xilianshi.png", 10, 5, 1, 1, 1000, 9999, nil, 1, nil, "4", nil, },
	id_60026 = {60026, "竞技券", "可用于增加竞技场挑战次数。", "jjc_card_1.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60027 = {60027, "宝物沙漏", "可用于刷新宝物商店中的商品。", "shenmishuaxinka.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60028 = {60028, "万能宝物", "可用于兑换任意一种宝物。", "small_5_wanneng_1.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, },
	id_60029 = {60029, "宝物晶石", "可用于宝物进阶。", "item_crystal.png", "item_crystal_big.png", 10, 5, 1, 1, 1000, 9999, nil, 1, nil, "9", nil, },
	id_60030 = {60030, "宝物结晶", "可用于在宝物商店中兑换宝物。", "icon_treasure_coin.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, "14", nil, },
	id_60031 = {60031, "装备结晶", "可用于在装备商店中兑换装备。", "icon_impel_down_coin.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, "15|23", nil, },
	id_60032 = {60032, "觉醒结晶", "可用于在觉醒商店中兑换觉醒道具。", "icon_disillusion_coin.png", "icon_disillusion_coin_big.png", 10, 5, 0, nil, nil, 999, nil, 1, nil, "24", nil, },
	id_60033 = {60033, "觉醒石", "可用于伙伴觉醒。", "item_small_disillusionstone.png", "item_big_disillusionstone.png", 10, 5, 0, nil, nil, 9999, nil, 1, nil, "20|25", nil, },
	id_60034 = {60034, "海魂", "可用于在伙伴商店中兑换伙伴和饰品。", "haihun.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, nil, "10|19", nil, },
	id_60101 = {60101, "金之精魄", "蕴含金之属性的精魄，可用于特殊活动。活动期间击败普通副本任意据点有概率掉落。", "lanboqiu.png", nil, 10, 1, 1, 1, 1000, 9999, nil, 1, nil, nil, nil, },
	id_60102 = {60102, "木之精魄", "蕴含木之属性的精魄，可用于特殊活动。活动期间击败普通副本任意据点有概率掉落。", "lanboqiu.png", nil, 10, 1, 1, 1, 1000, 9999, nil, 1, nil, nil, nil, },
	id_60103 = {60103, "水之精魄", "蕴含水之属性的精魄，可用于特殊活动。活动期间击败普通副本任意据点有概率掉落。", "lanboqiu.png", nil, 10, 1, 1, 1, 1000, 9999, nil, 1, nil, nil, nil, },
	id_60104 = {60104, "火之精魄", "蕴含火之属性的精魄，可用于特殊活动。活动期间击败普通副本任意据点有概率掉落。", "lanboqiu.png", nil, 10, 1, 1, 1, 1000, 9999, nil, 1, nil, nil, nil, },
	id_60105 = {60105, "土之精魄", "蕴含土之属性的精魄，可用于特殊活动。活动期间击败普通副本任意据点有概率掉落。", "lanboqiu.png", nil, 10, 1, 1, 1, 1000, 9999, nil, 1, nil, nil, nil, },
	id_60201 = {60201, "魔石", "蕴含着神器魔力的石头，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60202 = {60202, "乌金", "通体乌黑通透，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60203 = {60203, "玄铁", "颜色深黑，透出隐隐红光，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60204 = {60204, "翎羽", "由凤凰身上掉落的羽毛，极为罕见，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60205 = {60205, "神玉", "光滑美观，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60301 = {60301, "散件武器图纸", "散件武器图纸，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60302 = {60302, "散件防具图纸", "散件防具图纸，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60303 = {60303, "散件项链图纸", "散件项链图纸，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60311 = {60311, "套装武器图纸", "散件武器图纸，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60312 = {60312, "套装防具图纸", "散件防具图纸，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60313 = {60313, "套装项链图纸", "散件项链图纸，是铸造橙装必备的材料之一。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60314 = {60314, "测试进阶石", "可用于伙伴进阶。", "lanboqiu.png", nil, 10, 5, 1, 1, 1000, 1, nil, 1, nil, nil, nil, },
	id_60315 = {60315, "贝里", "奈美最喜欢的东西之一——贝里，可从副本探索中获得。", "beili_da.png", nil, 10, 4, 1, 1, 1000, 1, nil, 1, nil, nil, nil, },
	id_60316 = {60316, "金币", "能够购买珍稀物品的金币，可从副本探索中获得。", "jinbi_da.png", nil, 10, 4, 1, 1, 1000, 1, nil, 1, nil, nil, nil, },
	id_60317 = {60317, "主角经验", "让你变成更有资历的船长，可从副本探索中获得。", "exp_icon.png", nil, 10, 4, 1, 1, 1000, 1, nil, 1, nil, nil, nil, },
	id_60318 = {60318, "船员证", "成为我的伙伴一起到新世界冒险吧！可用于开启小伙伴栏位。", "lanboqiu.png", nil, 10, 6, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60319 = {60319, "竞技场沙漏", "竞技场中可以重置时间的奇妙物品，可用于刷新竞技场商店。", "lanboqiu.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, nil, nil, nil, },
	id_60401 = {60401, "木桶", "海盗船上都会配备的普通木桶，出售可获得2500贝里。", "small_sell_mutong_1.png", "big_sell_mutong_1.png", 10, 2, 1, 1, 2500, 9999, nil, 1, 1, nil, nil, },
	id_60402 = {60402, "宠物粮", "便宜的狗粮，出售可获得5000贝里。", "small_sell_gouliang_2.png", "big_sell_gouliang_2.png", 10, 2, 1, 1, 5000, 9999, nil, 1, 1, nil, nil, },
	id_60403 = {60403, "纸质风车", "设计简单的小风车，出售可获得10000贝里。", "small_sell_fengche_3.png", "big_sell_fengche_3.png", 10, 3, 1, 1, 10000, 9999, nil, 1, 1, nil, nil, },
	id_60404 = {60404, "无籽柑橘", "好吃的橘子，出售可获得25000贝里。", "small_sell_juzi_4.png", "big_sell_juzi_4.png", 10, 4, 1, 1, 25000, 9999, nil, 1, 1, nil, nil, },
	id_60405 = {60405, "海鲜浓汤", "美味绝伦的海鲜浓汤，出售可获得50000贝里。", "small_sell_nongtang_5.png", "big_sell_nongtang_5.png", 10, 5, 1, 1, 50000, 9999, nil, 1, 1, nil, nil, },
	id_60406 = {60406, "贝里", "全世界通用的货币。贝里可用于强化伙伴和装备。", "beili_xiao.png", nil, 10, 4, 1, 1, 1000, 1, nil, 1, nil, "1|2|3", nil, },
	id_60501 = {60501, "低级附魔石", "用于装备附魔，可增加5点附魔经验，附魔等级提升会提高装备属性", "fumoshi1.png", nil, 10, 3, 1, 1, 3000, 9999, nil, 1, nil, "11|6", 5, },
	id_60502 = {60502, "中级附魔石", "用于装备附魔，可增加10点附魔经验，附魔等级提升会提高装备属性", "fumoshi2.png", nil, 10, 4, 1, 1, 4000, 9999, nil, 1, nil, "11|6", 10, },
	id_60503 = {60503, "高级附魔石", "用于装备附魔，可增加25点附魔经验，附魔等级提升会提高装备属性", "fumoshi3.png", nil, 10, 5, 1, 1, 5000, 9999, nil, 1, nil, "11|6", 25, },
	id_60504 = {60504, "极品附魔石", "用于装备附魔，可增加50点附魔经验，附魔等级提升会提高装备属性", "fumoshi4.png", nil, 10, 6, 1, 1, 6000, 9999, nil, 1, nil, "11|6|27", 50, },
	id_60601 = {60601, "木材", "优秀船工精选的造船材料，可用于强化主船。", "wood.png", nil, 10, 5, 0, nil, nil, 99999, nil, 1, nil, "13", nil, },
	id_60701 = {60701, "金币袋", "能够购买珍稀物品的金币", "jinbi_da.png", nil, 10, 5, 0, nil, nil, 1, nil, 1, nil, nil, nil, },
	id_60801 = {60801, "钢材", "含有少量钒的合金材料，韧性极强，是船炮强化的材料之一。", "gangcai.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, nil, "26|27", nil, },
	id_60802 = {60802, "火药", "可由火花、火焰等引起剧烈燃烧的粉末状物品，是船炮强化的材料之一。", "huoyao.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, nil, "26|27", nil, },
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
	local id_data = Item_normal["id_" .. key_id]
	assert(id_data, "Item_normal not found " ..  key_id)
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
	for k, v in pairs(Item_normal) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_normal"] = nil
	package.loaded["DB_Item_normal"] = nil
	package.loaded["db/DB_Item_normal"] = nil
end

