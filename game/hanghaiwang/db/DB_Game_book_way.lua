-- Filename: DB_Game_book_way.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Game_book_way", package.seeall)

keys = {
	"id", "type", "type_name", "way_name", "way_icon", "way_desc", 
}

Game_book_way = {
	id_1 = {1, 1, "伙伴提升", "伙伴强化", "images/drop/strong_huobanqianghua.png", "消耗绿色伙伴影子或经验影子可以强化伙伴；伙伴升级后各项属性可获得明显提升", },
	id_2 = {2, 1, "伙伴提升", "伙伴进阶", "images/drop/strong_huobanjinjie.png", "消耗贝里和进阶石可进阶伙伴，需要伙伴达到一定等级；伙伴进阶不仅可使属性大幅提升，还能解锁超强天赋", },
	id_3 = {3, 1, "伙伴提升", "属性加成", "images/drop/strong_jiban.png", "伙伴之间存在属性加成关系，获得对应的伙伴后(无需上阵)即可激活，大幅增强属性；在阵容中装备特殊饰品也可激活属性加成。", },
	id_4 = {4, 1, "伙伴提升", "伙伴觉醒", "images/drop/strong_juexing.png", "消耗觉醒道具和觉醒石提高觉醒的等级，可大幅提高伙伴的各项属性", },
	id_5 = {5, 2, "装备提升", "装备强化", "images/drop/strong_zhuangbeiqianghua.png", "使用贝里可以强化装备；装备的强化等级上限为玩家等级上限的2倍", },
	id_6 = {6, 2, "装备提升", "装备附魔", "images/base/props/day_task_18.png", "使用附魔石可以附魔装备；装备附魔后可大幅提升装备属性", },
	id_7 = {7, 2, "装备提升", "装备套装", "images/drop/strong_taozhuang.png", "集齐一套完整的装备可激活套装属性；“套装”这两个字意味着什么你懂的", },
	id_8 = {8, 2, "装备提升", "装备强化大师", "images/drop/strong_dashi.png", "当伙伴身上所有的装备强化或附魔都达到一定等级可激活强化大师，强化大师可按装备等级大幅增加属性", },
	id_9 = {9, 2, "装备提升", "装备获得(装备商店)", "images/drop/shop_equip.png", "副本和深海监狱中可以获得大量装备；有装备的伙伴才能发挥更强的作用", },
	id_10 = {10, 3, "饰品提升", "饰品强化", "images/drop/strong_shipinqianghua.png", "消耗经验饰品可强化饰品；饰品强化后可提升饰品属性", },
	id_11 = {11, 3, "饰品提升", "饰品精炼", "images/drop/strong_shipinjinglian.png", "使用饰品精炼石可以对饰品进行精炼；回收蓝、紫饰品可以获得饰品精炼石", },
	id_12 = {12, 3, "饰品提升", "饰品强化大师", "images/drop/strong_dashi.png", "伙伴身上所有的饰品都强化到一定等级可激活强化大师，强化大师会根据装备等级大幅提升伙伴属性", },
	id_13 = {13, 4, "宝物提升", "宝物进阶", "images/drop/strong_baowujinjie.png", "消耗宝物晶石可以进阶宝物，宝物进阶后能够大幅提高自身属性，在特定的进阶等级还可以开启特殊宝物能力", },
	id_14 = {14, 4, "宝物提升", "宝物获得(探索)", "images/base/props/day_task_5.png", "在探索中，探索不同的地点可以获得不同的宝物；特定伙伴拥有自己的专属宝物，装备并进阶到一定等级可以激活专属技能", },
	id_15 = {15, 5, "贝里获得", "巨蛇宝藏", "images/wonderfullAct/activity_belly.png", "每天都有两次攻打巨蛇宝藏的机会，战斗中攻击的伤害值越高，获得的贝里奖励越多", },
	id_16 = {16, 5, "贝里获得", "资源岛", "images/base/props/day_task_22.png", "在资源岛中，可以收获大量的贝里", },
	id_17 = {17, 5, "贝里获得", "购买贝里", "images/wonderfullAct/activity_belly.png", "可以用少量金币换取大量贝里", },
	id_18 = {18, 6, "金币获得", "竞技场", "images/base/props/day_task_9.png", "在竞技场中刷新自己的最高排名；可获得金币奖励", },
	id_19 = {19, 6, "金币获得", "日常任务", "images/drop/strong_renwu.png", "每日任务中有大量金币奖励", },
	id_20 = {20, 6, "金币获得", "成长基金", "images/wonderfullAct/activity_fund.png", "不可不买的超值福利；购买后共可返还6000金！", },
	id_21 = {21, 6, "金币获得", "充值", "images/drop/strong_chongzhi.png", "通过充值获得金币，合理使用金币能够快速提高实力，成为有名的大海盗", },
	id_22 = {22, 7, "进阶石", "普通副本", "images/base/props/day_task_6.png", "攻打普通副本，在副本中可领取副本宝箱，其中可获得大量进阶石", },
	id_23 = {23, 7, "进阶石", "竞技场兑换", "images/drop/shop_arena.png", "提高竞技场排名可以获得的声望；声望可在竞技场商店中兑换进阶石", },
	id_24 = {24, 7, "进阶石", "伙伴商店", "images/wonderfullAct/activity_mystery.png", "在伙伴商店中，可以兑换进阶石，进阶石是进阶伙伴的必备道具", },
	id_25 = {25, 8, "附魔石", "深海监狱", "images/base/props/day_task_21.png", "攻打深海监狱层数越多，可以获得的附魔石越多，附魔石是装备附魔的必备道具", },
	id_26 = {26, 8, "附魔石", "普通副本", "images/base/props/day_task_6.png", "攻打普通副本可以掉落附魔石，附魔石是装备附魔的必备道具", },
	id_27 = {27, 8, "附魔石", "装备商店", "images/drop/shop_equip.png", "在装备商店中，可以用监狱币兑换附魔石，附魔石是装备附魔的必备道具", },
	id_28 = {28, 8, "附魔石", "普通商店", "images/drop/drop_shop.png", "在普通商店中，可以直接用金币购买附魔石，附魔石是装备附魔的必备道具", },
	id_29 = {29, 9, "VIP提升", "充值", "images/drop/strong_chongzhi.png", "充值可以提升VIP经验，VIP等级提升后可获得特殊福利", },
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
	local id_data = Game_book_way["id_" .. key_id]
	assert(id_data, "Game_book_way not found " ..  key_id)
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
	for k, v in pairs(Game_book_way) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Game_book_way"] = nil
	package.loaded["DB_Game_book_way"] = nil
	package.loaded["db/DB_Game_book_way"] = nil
end

