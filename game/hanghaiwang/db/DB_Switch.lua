-- Filename: DB_Switch.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Switch", package.seeall)

keys = {
	"id", "level", "copyId", "explore_times", "name", "swichId", "desc", "show", "alertContent", "functionShowLv", 
}

Switch = {
	id_1 = {1, nil, 1001, nil, "阵容", 1, "需击败“[哥特岛] - 哥特岛海贼”开启", 0, "上阵伙伴可大幅提高战斗力", nil, },
	id_2 = {2, nil, 1003, nil, "伙伴进阶", 2, "需击败“[哥特岛] - 爱比达手下”开启，可进阶伙伴，大幅提高战斗力", 0, "进阶伙伴可大幅增加伙伴战斗力", nil, },
	id_3 = {3, 3, nil, nil, "酒馆", 3, "需xx级开启，可招募强力稀有伙伴，获得珍贵宝箱和大量贝里。", 1, "可招募强力伙伴", nil, },
	id_4 = {4, 38, nil, nil, "精英副本", 4, "需xx级开启，可获得稀有装备", 1, "通关精英副本可获得橙色伙伴碎片", 33, },
	id_5 = {5, 1, nil, nil, "活动", 5, "需xx级开启", 0, nil, nil, },
	id_6 = {6, 18, nil, nil, "名将", 6, "需xx级开启，收集名将增进好感，提高战斗力", 0, "培养名将可提升全体战斗力", nil, },
	id_7 = {7, 30, nil, nil, "比武", 7, "需xx级开启，可参加比武获得稀有道具", 0, "参加比武获得稀有道具", nil, },
	id_8 = {8, 14, nil, nil, "竞技场", 8, "需xx级开启，可参加竞技排名，获得声望兑换大量进阶石和稀有道具", 1, "参加竞技可获得大量声望", nil, },
	id_9 = {9, 23, nil, nil, "日常副本", 9, "需xx级开启,挑战日常副本可以获得大量贝里和经验道具", 1, "挑战日常副本可获得大量贝里和经验道具", nil, },
	id_10 = {10, 40, nil, nil, "宠物", 10, "该功能暂未开启，敬请期待", 0, "喂养宠物可以提升全体战斗力", nil, },
	id_11 = {11, 42, nil, nil, "资源岛", 11, "需xx级开启，可占领资源岛获得大量贝里", 1, "占领资源岛可以获得大量贝里", nil, },
	id_12 = {12, 28, nil, nil, "占卜屋", 12, "需xx级开启，可获得项链和大量贝里", 0, "完成占卜可以获得项链", nil, },
	id_13 = {13, 5, nil, nil, "签到", 13, "需xx级开启，每日签到领大量福利", 0, "每日登陆签到不同好礼等你拿", nil, },
	id_14 = {14, 5, nil, nil, "等级礼包", 14, "需xx级开启，可获得稀有伙伴和大量金币", 0, "等级提高更多好礼等你拿", nil, },
	id_15 = {15, 1, nil, nil, "铁匠铺", 15, "需击败“[科托岛] - 甲板海贼”开启", 0, nil, nil, },
	id_16 = {16, 7, nil, nil, "装备强化", 16, "需xx级开启，可强化装备，大幅提升战斗力", 1, "强化装备可以大幅度提升战力", nil, },
	id_17 = {17, nil, 1001, nil, "伙伴强化", 17, "需击败“[风车村] - 风车村山贼”开启，可强化伙伴，大幅提升战斗力", 1, "强化伙伴可以大幅提升战力", nil, },
	id_19 = {19, 18, nil, nil, "饰品强化", 19, "需xx级开启", 0, nil, nil, },
	id_20 = {20, 1, nil, nil, "夺宝", 20, "探索中获得紫色饰品碎片后开启", 0, "夺宝可获得宝物碎片合成饰品", nil, },
	id_21 = {21, 16, nil, nil, "回收", 21, "需xx级开启，可回收伙伴影子获得海魂，使用海魂可在伙伴商店兑换伙伴影子", 1, "回收伙伴影子可获得海魂", nil, },
	id_22 = {22, 24, nil, nil, "修炼", 22, "需xx级开启，可使用副本星数修炼提升全员伙伴属性", 1, "修炼可大幅提升全体上阵伙伴属性", nil, },
	id_23 = {23, 19, nil, nil, "公会", 23, "需xx级开启，可创建或加入公会", 1, "可创建或加入公会", nil, },
	id_24 = {24, 35, nil, nil, "装备附魔", 24, "需xx级开启，可给装备附魔，提高装备属性", 0, "附魔可提高装备属性", nil, },
	id_25 = {25, 40, nil, nil, "饰品精炼", 25, "需xx级开启", 0, "饰品精炼", nil, },
	id_26 = {26, 150, nil, nil, "神秘空岛", 26, "需xx级开启，可在神秘空岛发起挑战，获得空岛贝提升战斗力", 1, "挑战神秘空岛可获得空岛贝提升战力", nil, },
	id_27 = {27, 32, nil, nil, "激战海王类", 27, "需xx级开启，参与激战海王类活动可以获得大量贝里和声望", 1, "挑战海王类可以获得大量贝里，声望和木材", nil, },
	id_28 = {28, 999, nil, nil, "空岛贝", 28, "需xx级开启，装备空岛贝可提升伙伴战力", 0, "装备空岛贝可提升伙伴战力", nil, },
	id_29 = {29, 1, nil, nil, "主角时装", 29, "需xx级开启", 0, "进击的魔神", nil, },
	id_30 = {30, 9, nil, nil, "探索", 30, "需xx级开启，可获得经验和稀有道具", 1, "探索可提升经验并获得稀有饰品", nil, },
	id_31 = {31, 18, nil, nil, "饰品", 31, "需xx级开启，可装备饰品提升战斗力", 0, "装备饰品可以提升大量属性", nil, },
	id_32 = {32, 5, nil, nil, "每日任务", 32, "需xx级开启，完成每日任务获得大量道具", 0, "完成每日任务可获得各种道具", nil, },
	id_33 = {33, 22, nil, nil, "伙伴突破", 33, "需xx级开启，可将紫色伙伴突破为橙色伙伴", 0, "可将紫色伙伴突破为橙色伙伴，提升战力", nil, },
	id_34 = {34, 21, nil, nil, "重生", 34, "需xx级开启，可将伙伴重生为初始状态", 0, "可使伙伴恢复初始状态", nil, },
	id_35 = {35, 22, nil, nil, "小伙伴", 35, "需xx级开启，可放置伙伴，和阵上伙伴配合，激活羁绊关系增加属性", 0, "可上阵小伙伴，激活羁绊增加属性", nil, },
	id_36 = {36, 9, nil, nil, "购买商品", 36, "需xx级开启，可前往商城购买物品", 0, "可在商城中购买商品", nil, },
	id_37 = {37, 6, nil, nil, "神秘招募", 37, "需xx级开启，可进行神秘招募", 0, "可在酒馆中进行神秘招募", nil, },
	id_38 = {38, 21, nil, nil, "深海监狱", 38, "需xx级开启，可在深海监狱发起挑战，获得装备提升战斗力", 1, "挑战深海监狱可获得装备提升战力", nil, },
	id_39 = {39, nil, 5010, nil, "主船", 39, "需击败“[糖汁村] - 克洛船长”开启", 1, "强化主船可增加所有伙伴战斗奖励", nil, },
	id_40 = {40, 52, nil, nil, "伙伴觉醒", 40, "需xx级开启，可增加伙伴战斗力", 1, "觉醒伙伴可提升伙伴战斗力", 50, },
	id_41 = {41, 20, nil, nil, "游戏宝典", 41, "需xx级开启", 0, "游戏宝典", nil, },
	id_42 = {42, 31, nil, nil, "宝物商店", 42, "需xx级开启，可以兑换专属宝物", 0, "宝物商店中可兑换宝物", nil, },
	id_43 = {43, 20, nil, nil, "饰品宝箱", 43, "需xx级开启，可以开启宝箱获得饰品", 0, "饰品宝箱中可获得饰品", nil, },
	id_44 = {44, 19, nil, nil, "公会副本", 44, "需加入公会，且公会中公会大厅达到3级后开启", 0, "公会副本中可获得稀有材料", 19, },
	id_45 = {45, 55, nil, nil, "噩梦副本", 45, "需xx级开启，可以攻打噩梦难度的副本", 0, "噩梦副本中可获得极品奖励", nil, },
	id_46 = {46, 55, nil, nil, "船炮", 46, "需xx级开启，可以装备炮弹在战斗中释放", 0, "装备炮弹后，可以在战斗中释放技能", nil, },
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
	local id_data = Switch["id_" .. key_id]
	assert(id_data, "Switch not found " ..  key_id)
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
	for k, v in pairs(Switch) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Switch"] = nil
	package.loaded["DB_Switch"] = nil
	package.loaded["db/DB_Switch"] = nil
end

