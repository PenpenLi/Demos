-- Filename: DB_Game_notice.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Game_notice", package.seeall)

keys = {
	"id", "content", "needItem", 
}

Game_notice = {
	id_16 = {16, "恭喜|将伙伴|进阶到了|，战斗力得到大幅提升！", nil, },
	id_17 = {17, "恭喜|在酒馆中通过|招募了|，船队中又增加了一个强大的助力！", nil, },
	id_18 = {18, "恭喜|在酒馆十连抽时招到了|，和伙伴们一起寻找[ONE PIECE]，成为航海王！", nil, },
	id_23 = {23, "恭喜|使用|获得了|冒险中收获的宝藏已经数不清啦！", "1|0|500000,7|10023|1,7|5015016|1,7|5015026|1,7|5015036|1,7|5025016|1,7|5025026|1,7|5025036|1,7|5035016|1,7|5035026|1,7|5035036|1,7|60008|1,7|501501|1,7|501502|1,7|501503|1,7|502501|1,7|502502|1,7|502503|1,7|503501|1,7|503502|1,7|503503|1", },
	id_25 = {25, "恭喜|打开首充礼包，获得了|，贝里*|，瞬间变土豪！", nil, },
	id_26 = {26, "离活动：激战海王类“|”开始仅剩5分钟，请各位船长做好挑战准备！", nil, },
	id_27 = {27, "活动：激战海王类“|”已开启，请船长前往日常去挑战！击杀近海之王会获得大量声望奖励哦~！", nil, },
	id_28 = {28, "恭喜|成功击杀|，获得海王类击杀奖励！", nil, },
	id_29 = {29, "本次激战海王类活动已结束。伤害最高前三名：第一名 | ，伤害|；第二名 | ，伤害|；第三名 | ，伤害|。", nil, },
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
	local id_data = Game_notice["id_" .. key_id]
	assert(id_data, "Game_notice not found " ..  key_id)
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
	for k, v in pairs(Game_notice) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Game_notice"] = nil
	package.loaded["DB_Game_notice"] = nil
	package.loaded["db/DB_Game_notice"] = nil
end

