-- Filename: DB_WordsAnimationType.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_WordsAnimationType", package.seeall)

keys = {
	"id", "name", "img", "type", 
}

WordsAnimationType = {
	id_1 = {1, "暴击", "critical.png", 1, },
	id_2 = {2, "暴击数字", "critical.png", 2, },
	id_3 = {3, "伤害数字", "red.png", 2, },
	id_4 = {4, "加血数字", "green.png", 2, },
	id_5 = {5, "怒气↑", "angerup.png", 3, },
	id_6 = {6, "攻击↑", "attackup.png", 3, },
	id_7 = {7, "格挡↑", "blockup.png", 3, },
	id_8 = {8, "暴击↑", "criticalup.png", 3, },
	id_9 = {9, "防御↑", "defenseup.png", 3, },
	id_10 = {10, "闪避↑", "dodgeup.png", 3, },
	id_11 = {11, "放逐", "banish.png", 3, },
	id_12 = {12, "灼烧", "burn.png", 3, },
	id_13 = {13, "魅惑", "charm.png", 3, },
	id_14 = {14, "混乱", "confusion.png", 3, },
	id_15 = {15, "沮丧", "depress.png", 3, },
	id_16 = {16, "眩晕", "dizzy.png", 3, },
	id_17 = {17, "封怒", "forbidanger.png", 3, },
	id_18 = {18, "禁疗", "forbidcure.png", 3, },
	id_19 = {19, "冰冻", "frozen.png", 3, },
	id_20 = {20, "免疫", "immunity.png", 3, },
	id_21 = {21, "底力", "indomitable.png", 3, },
	id_22 = {22, "无敌", "invincible.png", 3, },
	id_23 = {23, "魔免", "magicimmune.png", 3, },
	id_24 = {24, "麻痹", "paralysis.png", 3, },
	id_25 = {25, "石化", "petrification.png", 3, },
	id_26 = {26, "物免", "physicsimmune.png", 3, },
	id_27 = {27, "中毒", "poison.png", 3, },
	id_28 = {28, "标记", "sign.png", 3, },
	id_29 = {29, "沉默", "silence.png", 3, },
	id_30 = {30, "格挡", "block.png", 3, },
	id_31 = {31, "闪避", "dodge.png", 3, },
	id_32 = {32, "反击", "fightback.png", 3, },
	id_33 = {33, "怒气↓", "angerdown.png", 4, },
	id_34 = {34, "攻击↓", "attackdown.png", 4, },
	id_35 = {35, "防御↓", "defensedown.png", 4, },
	id_36 = {36, "命中↓", "hitratedown.png", 4, },
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
	local id_data = WordsAnimationType["id_" .. key_id]
	assert(id_data, "WordsAnimationType not found " ..  key_id)
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
	for k, v in pairs(WordsAnimationType) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_WordsAnimationType"] = nil
	package.loaded["DB_WordsAnimationType"] = nil
	package.loaded["db/DB_WordsAnimationType"] = nil
end

