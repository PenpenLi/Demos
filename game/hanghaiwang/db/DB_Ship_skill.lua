-- Filename: DB_Ship_skill.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Ship_skill", package.seeall)

keys = {
	"id", "skill_name", "quality", "icon_small", "skill_type", "base_desc", "desc_str", "desc_level", "desc_prep", "period_desc_str", "period_desc_level", "period_desc_prep", "bulletName", "actionName", "muzzleEffect", "aimEffectName", "enterSceneType", "quitSceneType", "aimMode", "aimEffectMode", "skillNameImg", "bulletMode", "skillEffect", "skillEffectMode", "aaccumulateEff", "muzzleEffectSound", "skillEffectSound", "aimSound", "actionSound", "rotationSound", 
}

Ship_skill = {
	id_10001 = {10001, "实心炮", 4, "shixinpao.png", 1, "[物理]单体伤害", "船炮伤害|%", "0", "80+level*1.28", nil, nil, nil, "seffect1", "cannon1_action1", "cannon_fire1", "aim1", 1, 1, 1, 1, "ship_shixinpao.png", 1, "explosion1", 1, nil, "peak_showdown5", nil, "aim2", nil, "aim1", },
	id_10002 = {10002, "流星炮", 5, "liuxingpao.png", 1, "[魔法]攻击横排，减少敌人造成的伤害", "船炮伤害|%", "0", "52.5+level*0.84", "使目标伤害减少%d%%,持续1回合", "0|5", "4+level/5*1", "seffect2", "cannon1_action1", "cannon_fire1", "aim1", 1, 1, 1, 1, "ship_liuxingpao.png", 2, "explosion2", 2, nil, "peak_showdown5", nil, "aim2", nil, "aim1", },
	id_10003 = {10003, "铁锤球", 5, "tiechuiqiu.png", 1, "[物理]攻击后排横排，提高目标所受伤害", "船炮伤害|%", "0", "52.5+level*0.84", "使目标受到的伤害提高%d%%,持续1回合", "0|5", "4+level/5*1", "seffect2", "cannon1_action1", "cannon_fire1", "aim1", 1, 1, 1, 1, "ship_tiechuiqiu.png", 2, "explosion2", 2, nil, "peak_showdown5", nil, "aim2", nil, "aim1", },
	id_10004 = {10004, "毒气弹", 6, "duqidan.png", 1, "[物理]攻击直线，概率中毒", "船炮伤害|%", "0", "98.4+level*1.64", "%.1f%%撕裂1回合|100%%撕裂1回合,%.1f%%撕裂2回合", "0|5,80|5", "(40+level/5*2)/100,(0+level/5*2)/100", "seffect1", "cannon1_action1", "cannon_fire1", "aim1", 1, 1, 1, 1, "ship_duqidan.png", 2, "explosion5", 2, nil, nil, nil, nil, nil, nil, },
	id_10005 = {10005, "巴奇弹", 5, "baqidan.png", 1, "[物理]攻击随机2人，概率撕裂", "船炮伤害|%", "0", "98.4+level*1.64", "%.1f%%撕裂1回合|100%%撕裂1回合,%.1f%%撕裂2回合", "0|5,80|5", "(40+level/5*2)/100,(0+level/5*2)/100", "seffect1", "cannon1_action1", "cannon_fire1", "aim1", 1, 1, 1, 1, "ship_baqidan.png", 2, "explosion7", 2, nil, nil, nil, nil, nil, nil, },
	id_10006 = {10006, "风来炮", 5, "fenglaipao.png", 1, "[魔法]攻击直线，概率减2怒", "船炮伤害|%", "0", "100+level*1.6", "%.1f%%概率降低2点怒气", "0|5", "10+level/5*3", "seffect1", "cannon1_action1", "cannon_fire1", "aim1", 1, 1, 1, 1, "ship_fenglaipao.png", 3, "seffect4", 2, "seffect4", nil, nil, nil, nil, nil, },
	id_10007 = {10007, "燃烧弹", 5, "ranshaodan.png", 1, "[物理]攻击十字，概率灼烧", "船炮伤害|%", "0", "98.4+level*1.64", "%.1f%%撕裂1回合|100%%撕裂1回合,%.1f%%撕裂2回合", "0|5,80|5", "(40+level/5*2)/100,(0+level/5*2)/100", "seffect1", "cannon1_action1", "cannon_fire1", "aim1", 1, 1, 1, 1, "ship_ranshaodan.png", 2, "explosion6", 2, nil, nil, nil, nil, nil, nil, },
	id_10008 = {10008, "闪光弹", 5, "shanguangdan.png", 1, "[物理]攻击随机一人，概率致盲", "船炮伤害|%", "0", "98.4+level*1.64", "%.1f%%撕裂1回合|100%%撕裂1回合,%.1f%%撕裂2回合", "0|5,80|5", "(40+level/5*2)/100,(0+level/5*2)/100", "seffect1", "cannon1_action1", "cannon_fire1", "aim1", 1, 1, 1, 1, "ship_shanguangdan.png", 2, "explosion8", 2, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Ship_skill["id_" .. key_id]
	assert(id_data, "Ship_skill not found " ..  key_id)
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
	for k, v in pairs(Ship_skill) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Ship_skill"] = nil
	package.loaded["DB_Ship_skill"] = nil
	package.loaded["db/DB_Ship_skill"] = nil
end

