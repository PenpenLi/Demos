-- Filename: DB_Sign_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Sign_reward", package.seeall)

keys = {
	"id", "des", "type_1", "quality_1", "value_1", "des_1", "type_2", "quality_2", "value_2", "des_2", "type_3", "quality_3", "value_3", "des_3", "type_4", "quality_4", "value_4", "des_4", "type_5", "quality_5", "value_5", "des_5", 
}

Sign_reward = {
	id_1 = {1, "累积签到奖励", 3, 3, "100", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_2 = {2, "累积签到奖励", 7, 1, "440001|1", "经验紫影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_3 = {3, "累积签到奖励", 7, 4, "10042|10", "耐力药水(中)", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_4 = {4, "累积签到奖励", 7, 3, "60001|10", "悬赏单", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_5 = {5, "累积签到奖励", 7, 5, "60005|4", "免战旗", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_6 = {6, "累积签到奖励", 7, 4, "500001|5", "经验银钻", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_7 = {7, "累积签到奖励", 7, 5, "410022|5", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_8 = {8, "累积签到奖励", 3, 3, "100", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_9 = {9, "累积签到奖励", 7, 5, "60005|4", "免战旗", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10 = {10, "累积签到奖励", 7, 4, "10042|10", "耐力药水(中)", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_11 = {11, "累积签到奖励", 3, 4, "150", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_12 = {12, "累积签到奖励", 7, 3, "60001|10", "悬赏单", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_13 = {13, "累积签到奖励", 7, 3, "410022|5", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_14 = {14, "累积签到奖励", 7, 1, "440001|1", "经验紫影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_15 = {15, "累积签到奖励", 7, 4, "500001|5", "经验银钻", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_16 = {16, "累积签到奖励", 3, 4, "150", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_17 = {17, "累积签到奖励", 7, 5, "410022|5", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_18 = {18, "累积签到奖励", 7, 4, "10042|10", "耐力药水(中)", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_19 = {19, "累积签到奖励", 7, 3, "60001|10", "悬赏单", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_20 = {20, "累积签到奖励", 3, 5, "200", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_21 = {21, "累积签到奖励", 7, 1, "440001|1", "经验紫影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_22 = {22, "累积签到奖励", 7, 4, "410022|5", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_23 = {23, "累积签到奖励", 7, 4, "500001|5", "经验银钻", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_24 = {24, "累积签到奖励", 7, 3, "410022|5", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_25 = {25, "累积签到奖励", 7, 5, "60005|4", "免战旗", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_26 = {26, "累积签到奖励", 7, 4, "10042|10", "耐力药水(中)", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_27 = {27, "累积签到奖励", 7, 3, "60001|10", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_28 = {28, "累积签到奖励", 7, 1, "440001|1", "经验紫影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_29 = {29, "累积签到奖励", 7, 4, "500001|5", "经验银钻", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_30 = {30, "累积签到奖励", 3, 5, "200", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_31 = {31, "累积签到奖励", 7, 5, "60001|10", "悬赏单", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_101 = {101, "累积签到奖励", 1, 4, "50000", "贝里", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_102 = {102, "累积签到奖励", 7, 5, "60002|50", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_103 = {103, "累积签到奖励", 7, 4, "500001|10", "经验银钻", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_104 = {104, "累积签到奖励", 7, 5, "410032|5", "佐罗影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_105 = {105, "累积签到奖励", 3, 5, "100", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_106 = {106, "累积签到奖励", 7, 5, "60025|40", "突破石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_107 = {107, "累积签到奖励", 7, 5, "60006|10", "刷新卡", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_108 = {108, "累积签到奖励", 7, 5, "410032|5", "佐罗影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_109 = {109, "累积签到奖励", 3, 5, "100", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_110 = {110, "累积签到奖励", 1, 4, "100000", "贝里", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_111 = {111, "累积签到奖励", 7, 5, "60006|10", "刷新卡", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_112 = {112, "累积签到奖励", 7, 5, "410032|5", "佐罗影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_113 = {113, "累积签到奖励", 3, 5, "100", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_114 = {114, "累积签到奖励", 7, 5, "60029|400", "宝物结晶", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_115 = {115, "累积签到奖励", 7, 5, "60002|60", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_116 = {116, "累积签到奖励", 7, 5, "410032|5", "佐罗影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_117 = {117, "累积签到奖励", 3, 5, "120", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_118 = {118, "累积签到奖励", 7, 3, "10042|4", "耐力药水(中）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_119 = {119, "累积签到奖励", 7, 5, "30016|3", "宝物礼盒", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_120 = {120, "累积签到奖励", 7, 5, "410032|5", "佐罗影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_121 = {121, "累积签到奖励", 3, 5, "150", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_122 = {122, "累积签到奖励", 7, 5, "60008|300", "饰品精华", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_123 = {123, "累积签到奖励", 7, 5, "30013|4", "金钥匙", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_124 = {124, "累积签到奖励", 7, 5, "410032|10", "佐罗影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_125 = {125, "累积签到奖励", 3, 5, "150", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_126 = {126, "累积签到奖励", 7, 5, "30016|3", "宝物礼盒", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_127 = {127, "累积签到奖励", 3, 5, "200", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_128 = {128, "累积签到奖励", 7, 1, "440001|1", "经验紫影", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_129 = {129, "累积签到奖励", 7, 4, "500001|2", "经验银钻", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_130 = {130, "累积签到奖励", 3, 5, "200", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_131 = {131, "累积签到奖励", 7, 3, "60001|10", "悬赏单", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_201 = {201, "累积签到奖励", 1, 4, "50000", "贝里", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_202 = {202, "累积签到奖励", 7, 5, "60002|50", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_203 = {203, "累积签到奖励", 7, 4, "500001|10", "经验银钻", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_204 = {204, "累积签到奖励", 7, 5, "410022|5", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205 = {205, "累积签到奖励", 3, 5, "100", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_206 = {206, "累积签到奖励", 7, 5, "60025|40", "突破石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_207 = {207, "累积签到奖励", 7, 5, "60006|10", "刷新卡", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_208 = {208, "累积签到奖励", 7, 5, "410022|5", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_209 = {209, "累积签到奖励", 3, 5, "100", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_210 = {210, "累积签到奖励", 1, 4, "100000", "贝里", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_211 = {211, "累积签到奖励", 7, 5, "60006|10", "刷新卡", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_212 = {212, "累积签到奖励", 7, 5, "410022|5", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_213 = {213, "累积签到奖励", 3, 5, "100", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_214 = {214, "累积签到奖励", 7, 5, "60029|400", "宝物结晶", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_215 = {215, "累积签到奖励", 7, 5, "60002|60", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_216 = {216, "累积签到奖励", 7, 5, "410022|5", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_217 = {217, "累积签到奖励", 3, 5, "120", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_218 = {218, "累积签到奖励", 7, 3, "10042|4", "耐力药水(中）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_219 = {219, "累积签到奖励", 7, 5, "30016|3", "宝物礼盒", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_220 = {220, "累积签到奖励", 7, 5, "410022|5", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_221 = {221, "累积签到奖励", 3, 5, "150", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_222 = {222, "累积签到奖励", 7, 5, "60008|300", "饰品精华", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_223 = {223, "累积签到奖励", 7, 5, "30013|4", "金钥匙", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_224 = {224, "累积签到奖励", 7, 5, "410022|10", "布鲁克影子", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_225 = {225, "累积签到奖励", 3, 5, "150", "金币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_226 = {226, "累积签到奖励", 7, 5, "30016|3", "宝物礼盒", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_227 = {227, "累积签到奖励", 7, 5, "60025|40", "突破石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_228 = {228, "累积签到奖励", 7, 5, "60006|10", "刷新卡", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_229 = {229, "累积签到奖励", 7, 4, "500001|10", "经验银钻", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_230 = {230, "累积签到奖励", 1, 4, "50000", "贝里", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_231 = {231, "累积签到奖励", 7, 5, "60002|50", "进阶石", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Sign_reward["id_" .. key_id]
	assert(id_data, "Sign_reward not found " ..  key_id)
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
	for k, v in pairs(Sign_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Sign_reward"] = nil
	package.loaded["DB_Sign_reward"] = nil
	package.loaded["db/DB_Sign_reward"] = nil
end

