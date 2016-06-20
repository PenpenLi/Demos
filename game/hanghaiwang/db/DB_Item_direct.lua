-- Filename: DB_Item_direct.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_direct", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "process_mode", "coins", "golds", "energy", "endurance", "award_item_id", "award_card_id", "add_challenge_times", "need_level", "use_getRime", 
}

Item_direct = {
	id_10001 = {10001, "大礼包", "现在还需要测试吗？", "datili.png", nil, 3, 3, 1, 1, 1000, 99, nil, 0, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10002 = {10002, "竞技场挑战券", "拿在手里就会感觉自己热血沸腾的竞技场挑战券，使用后可以恢复竞技场挑战次数1次。", "belly.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, 1, nil, nil, },
	id_10011 = {10011, "1万贝里", "使用后可获得1万贝里。", "beili_xiao.png", "beili_xiao_big.png", 3, 2, 0, nil, nil, 999, nil, 0, nil, 10000, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10012 = {10012, "5万贝里", "使用后可获得5万贝里。", "beili_zhong.png", "beili_zhong_big.png", 3, 3, 0, nil, nil, 999, nil, 0, nil, 50000, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10013 = {10013, "10万贝里", "使用后可获得10万贝里。", "beili_da.png", "beili_da_big.png", 3, 4, 0, nil, nil, 999, nil, 0, nil, 100000, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10014 = {10014, "50万贝里", "使用后可获得50万贝里。", "beili_teda.png", "beili_teda_big.png", 3, 5, 0, nil, nil, 999, nil, 0, nil, 500000, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10015 = {10015, "100万贝里", "使用后可获得100万贝里。", "beili_chaoda.png", "beili_chaoda_big.png", 3, 5, 0, nil, nil, 999, nil, 0, nil, 1000000, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10016 = {10016, "2万贝里", "你会获得2万贝里。", "beili_xiao.png", "beili_xiao_big.png", 3, 3, 0, nil, nil, 999, nil, 0, nil, 20000, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10017 = {10017, "2000贝里", "使用后可获得2000贝里。", "beili_xiao.png", "beili_xiao_big.png", 3, 2, 0, nil, nil, 999, nil, 0, nil, 2000, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10018 = {10018, "5000贝里", "使用后可获得5000贝里。", "beili_xiao.png", "beili_xiao_big.png", 3, 2, 0, nil, nil, 999, nil, 0, nil, 5000, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10021 = {10021, "10金币", "使用后可获得10金币。", "jinbi_xiao.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, 10, nil, nil, nil, nil, nil, nil, nil, },
	id_10022 = {10022, "50金币", "使用后可获得50金币。", "jinbi_zhong.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 50, nil, nil, nil, nil, nil, nil, nil, },
	id_10023 = {10023, "100金币", "使用后可获得100金币。", "jinbi_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 100, nil, nil, nil, nil, nil, nil, nil, },
	id_10024 = {10024, "500金币", "使用后可获得500金币。", "jinbi_chaoda.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 500, nil, nil, nil, nil, nil, nil, nil, },
	id_10025 = {10025, "1000金币", "使用后可获得1000金币。", "jinbi_chaoda.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 1000, nil, nil, nil, nil, nil, nil, nil, },
	id_10026 = {10026, "150金币", "使用后可获得150金币。", "jinbi_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 150, nil, nil, nil, nil, nil, nil, nil, },
	id_10027 = {10027, "5金币", "使用后可获得5金币。", "jinbi_xiao.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, 5, nil, nil, nil, nil, nil, nil, nil, },
	id_10028 = {10028, "20金币", "使用后可获得20金币。", "jinbi_xiao.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, 20, nil, nil, nil, nil, nil, nil, nil, },
	id_10029 = {10029, "200金币", "使用后可获得200金币。", "jinbi_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 200, nil, nil, nil, nil, nil, nil, nil, },
	id_10030 = {10030, "300金币", "使用后可获得300金币。", "jinbi_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 300, nil, nil, nil, nil, nil, nil, nil, },
	id_10031 = {10031, "体力药水(小)", "小号体力药水，能够提神醒脑。使用后可获得5点体力。", "tili_xiao.png", nil, 3, 2, 0, nil, nil, 999, nil, 0, nil, nil, nil, 5, nil, nil, nil, nil, nil, nil, },
	id_10032 = {10032, "体力药水(中)", "中号体力药水，可以抵抗困意。使用后可获得25点体力。", "tili_zhong.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, nil, 25, nil, nil, nil, nil, nil, nil, },
	id_10033 = {10033, "体力药水(大)", "大瓶体力药水，外出冒险必备。使用后可获得50点体力。", "tili_da.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, 50, nil, nil, nil, nil, nil, nil, },
	id_10034 = {10034, "体力药水(特大)", "特大瓶体力药水，一般作为储备能源藏在贮藏室。使用后可获得100点体力。", "tili_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, 100, nil, nil, nil, nil, nil, nil, },
	id_10035 = {10035, "体力药水(超大)", "超大瓶的体力药水，可以让一船队人都精力充沛。使用后可获得500点体力。", "tili_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, 500, nil, nil, nil, nil, nil, nil, },
	id_10041 = {10041, "耐力药水(小)", "小号耐力药水，一口就能喝完。饮用后可获得1点耐力。", "naili_xiao.png", nil, 3, 2, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, 1, nil, nil, nil, nil, nil, },
	id_10042 = {10042, "耐力药水(中)", "中号耐力药水，味道还不错。饮用后可获得5点耐力。", "naili_zhong.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, 5, nil, nil, nil, nil, nil, },
	id_10043 = {10043, "耐力药水(大)", "大瓶耐力药水，运动后可以来一瓶。饮用后可获得10点耐力。", "naili_da.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, 10, nil, nil, nil, nil, nil, },
	id_10044 = {10044, "耐力药水(特大)", "特大瓶耐力药水，一只手绝对无法拿起。饮用后可获得25点耐力。", "naili_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, 25, nil, nil, nil, nil, nil, },
	id_10045 = {10045, "耐力药水(超大)", "超大瓶的耐力药水，要用两个人的力气才能举起来。饮用获得50点耐力", "naili_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, 50, nil, nil, nil, nil, nil, },
	id_10051 = {10051, "小经验石", "历代船长的航海日志化成的石头，使用后可获得1000经验石。", "belly.png", nil, 3, 2, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10052 = {10052, "中经验石", "放在耳边似乎有人在喊“左转舵”，使用后可获得5000经验石。", "belly.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10053 = {10053, "大经验石", "在海底沉睡了数百年的沉船之中才有的石头，使用后可获得10000经验石。", "belly.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10054 = {10054, "特大经验石", "汇聚了历代海盗智慧的化石，被奥哈拉学者收集起来研究，使用后可获得5万经验石。", "belly.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10055 = {10055, "超级经验石", "被世界政府严格控制的神奇之石，由五老星裁决才可使用，使用后可获得10万经验石。", "belly.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10061 = {10061, "竞技帖", "买通后门扫地大妈后获得的竞技场通行证，使用后可获得1点竞技场次数。", "belly.png", nil, 3, 2, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, 1, nil, nil, },
	id_10062 = {10062, "中竞技包", "使用获得10竞技场次数", "belly.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, 5, nil, nil, },
	id_10063 = {10063, "大竞技包", "使用获得50竞技场次数", "belly.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, 10, nil, nil, },
	id_10064 = {10064, "特大竞技包", "使用获得200竞技场次数", "belly.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, 50, nil, nil, },
	id_10065 = {10065, "超级竞技包", "使用获得500竞技场次数", "belly.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, 100, nil, nil, },
	id_11001 = {11001, "凯波特", "伙伴“凯波特”的卡牌影子，使用后可获得伙伴“凯波特”影子15个。", "belly.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, "410136|15", nil, nil, nil, nil, },
	id_11002 = {11002, "小八", "伙伴“小八”的卡牌影子，使用后可获得伙伴“小八”影子15个。", "belly.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, "410135|15", nil, nil, nil, nil, },
	id_11003 = {11003, "大炮海盗", "伙伴“大炮海盗”的卡牌影子，使用后可获得伙伴“大炮海盗”影子10个。", "head_hz_huangfengpaoshou.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, "430005|10", nil, nil, nil, nil, },
	id_11004 = {11004, "大炮海盗", "伙伴“大炮海盗”的卡牌影子，使用后可获得伙伴“大炮海盗”影子10个。", "head_hz_huangfengpaoshou.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, "430005|10", nil, nil, nil, nil, },
	id_11005 = {11005, "大炮海盗", "伙伴“大炮海盗”的卡牌影子，使用后可获得伙伴“大炮海盗”影子10个。", "head_hz_huangfengpaoshou.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, "430005|10", nil, nil, nil, nil, },
	id_11006 = {11006, "大炮海盗", "伙伴“大炮海盗”的卡牌影子，使用后可获得伙伴“大炮海盗”影子10个。", "head_hz_huangfengpaoshou.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, "430005|10", nil, nil, nil, nil, },
	id_11007 = {11007, "大炮海盗", "伙伴“大炮海盗”的卡牌影子，使用后可获得伙伴“大炮海盗”影子10个。", "head_hz_huangfengpaoshou.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, "430005|10", nil, nil, nil, nil, },
	id_11008 = {11008, "大炮海盗", "伙伴“大炮海盗”的卡牌影子，使用后可获得伙伴“大炮海盗”影子10个。", "head_hz_huangfengpaoshou.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, "430005|10", nil, nil, nil, nil, },
	id_11009 = {11009, "大炮海盗", "伙伴“大炮海盗”的卡牌影子，使用后可获得伙伴“大炮海盗”影子10个。", "head_hz_huangfengpaoshou.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, "430005|10", nil, nil, nil, nil, },
	id_11010 = {11010, "大炮海盗", "伙伴“大炮海盗”的卡牌影子，使用后可获得伙伴“大炮海盗”影子10个。", "head_hz_huangfengpaoshou.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, "430005|10", nil, nil, nil, nil, },
	id_12001 = {12001, "vip0成长礼包", "vip0成长礼包，vip等级达到0以上可以购买。", "vip_gift_1.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 10000, nil, nil, nil, "60006|5,10042|1,10032|1", nil, nil, nil, nil, },
	id_12002 = {12002, "vip1成长礼包", "vip1成长礼包，vip等级达到1以上可以购买。", "vip_gift_1.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 50000, nil, nil, nil, "60006|5,30012|3", nil, nil, nil, nil, },
	id_12003 = {12003, "vip2成长礼包", "vip2成长礼包，vip等级达到2以上可以购买。", "vip_gift_1.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 100000, nil, nil, nil, "60006|5,104322|1,30012|5", nil, nil, nil, nil, },
	id_12004 = {12004, "vip3成长礼包", "vip3成长礼包，vip等级达到3以上可以购买。", "vip_gift_1.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 150000, nil, nil, nil, "60006|10,103322|1,30012|7", nil, nil, nil, nil, },
	id_12005 = {12005, "vip4成长礼包", "vip4成长礼包，vip等级达到4以上可以购买。", "vip_gift_2.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 200000, nil, nil, nil, "60006|15,102322|1,30012|10", nil, nil, nil, nil, },
	id_12006 = {12006, "vip5成长礼包", "vip5成长礼包，vip等级达到5以上可以购买。", "vip_gift_2.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 250000, nil, nil, nil, "60006|20,101322|1,30012|15", nil, nil, nil, nil, },
	id_12007 = {12007, "vip6成长礼包", "vip6成长礼包，vip等级达到6以上可以购买。", "vip_gift_2.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 300000, nil, nil, nil, "60006|20,103412|1,30012|20", nil, nil, nil, nil, },
	id_12008 = {12008, "vip7成长礼包", "vip7成长礼包，vip等级达到7以上可以购买。", "vip_gift_2.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 350000, nil, nil, nil, "60006|25,102412|1,30013|5", nil, nil, nil, nil, },
	id_12009 = {12009, "vip8成长礼包", "vip8成长礼包，vip等级达到8以上可以购买。", "vip_gift_3.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 400000, nil, nil, nil, "60006|25,104412|1,30013|10", nil, nil, nil, nil, },
	id_12010 = {12010, "vip9成长礼包", "vip9成长礼包，vip等级达到9以上可以购买。", "vip_gift_3.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 500000, nil, nil, nil, "60006|30,101412|1,30013|15", nil, nil, nil, nil, },
	id_12011 = {12011, "vip10成长礼包", "vip10成长礼包，vip等级达到10以上可购买。", "vip_gift_3.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 600000, nil, nil, nil, "30402|1,7200011|10,30013|20,60504|10", nil, nil, nil, nil, },
	id_12012 = {12012, "vip11成长礼包", "vip11成长礼包，vip等级达到11以上可购买。", "vip_gift_3.png", nil, 3, 6, 0, nil, nil, 9999, nil, 0, nil, 800000, nil, nil, nil, "103512|1,30402|1,7200011|15,30013|25,60504|20", nil, nil, nil, nil, },
	id_12013 = {12013, "vip12成长礼包", "vip12成长礼包，vip等级达到12以上可购买。", "vip_gift_3.png", nil, 3, 6, 0, nil, nil, 9999, nil, 0, nil, 1200000, nil, nil, nil, "102512|1,30402|1,7200011|20,30013|25,60504|30", nil, nil, nil, nil, },
	id_12014 = {12014, "vip13成长礼包", "vip13成长礼包，vip等级达到13以上可购买。", "vip_gift_3.png", nil, 3, 6, 0, nil, nil, 9999, nil, 0, nil, 1800000, nil, nil, nil, "104512|1,30402|1,7200011|25,30013|30,60504|40", nil, nil, nil, nil, },
	id_12015 = {12015, "vip14成长礼包", "vip14成长礼包，vip等级达到14以上可购买。", "vip_gift_3.png", nil, 3, 6, 0, nil, nil, 9999, nil, 0, nil, 2200000, nil, nil, nil, "101512|1,20003|1,7200011|30,30013|30,60504|50", nil, nil, nil, nil, },
	id_12016 = {12016, "vip15成长礼包", "vip15成长礼包，vip等级达到15以上可购买。", "vip_gift_3.png", nil, 3, 6, 0, nil, nil, 9999, nil, 0, nil, 3000000, nil, nil, nil, "101512|1,20003|1,7200011|40,30013|30,60504|60", nil, nil, nil, nil, },
	id_13001 = {13001, "100宝物结晶", "使用后可获得100宝物结晶。", "icon_treasure_coin.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, 100, },
	id_13002 = {13002, "200宝物结晶", "使用后可获得200宝物结晶。", "icon_treasure_coin.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, 200, },
	id_13003 = {13003, "500宝物结晶", "使用后可获得500宝物结晶。", "icon_treasure_coin.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, 500, },
	id_13004 = {13004, "2000宝物结晶", "使用后可获得2000宝物结晶。", "icon_treasure_coin.png", nil, 3, 6, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2000, },
	id_13005 = {13005, "5000宝物结晶", "使用后可获得5000宝物结晶。", "icon_treasure_coin.png", nil, 3, 6, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, 5000, },
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
	local id_data = Item_direct["id_" .. key_id]
	assert(id_data, "Item_direct not found " ..  key_id)
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
	for k, v in pairs(Item_direct) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_direct"] = nil
	package.loaded["DB_Item_direct"] = nil
	package.loaded["db/DB_Item_direct"] = nil
end

