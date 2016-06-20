-- Filename: DB_Paomadeng.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Paomadeng", package.seeall)

keys = {
	"id", "type", "num", "desc", 
}

Paomadeng = {
	id_101 = {101, 1, 3, "人，正在大杀特杀！", },
	id_102 = {102, 1, 5, "人，手起刀落，如入无人之境！", },
	id_103 = {103, 1, 10, "人，进入杀戮模式，背景一片血红。", },
	id_104 = {104, 1, 15, "人，未逢敌手，已有大成之兆！", },
	id_105 = {105, 1, 20, "人，已经无人能挡！你摊上事了！", },
	id_106 = {106, 1, 25, "人，悬赏金直线飙升！", },
	id_107 = {107, 1, 30, "人，霸气所至，寸草不生！", },
	id_108 = {108, 1, 35, "人，化身修罗兵刃，杀气贯穿天地！", },
	id_109 = {109, 1, 40, "人，煞气之名传扬四海，震惊天下！", },
	id_110 = {110, 1, 50, "人，遇神杀神，遇魔杀魔，所向披靡，无人可挡！", },
	id_201 = {201, 2, 3, "连胜，截获成果！", },
	id_202 = {202, 2, 5, "连胜，意气风发！", },
	id_203 = {203, 2, 10, "连胜，崭露头角！", },
	id_204 = {204, 2, 15, "连胜，实力惊人！", },
	id_205 = {205, 2, 20, "连胜，声名大振！", },
	id_206 = {206, 2, 25, "连胜，横空出世！", },
	id_207 = {207, 2, 30, "连胜，威慑天下！", },
	id_208 = {208, 2, 35, "连胜，登高一呼，取而代之！", },
	id_209 = {209, 2, 40, "连胜，将对手挑落神坛，自立顶峰！", },
	id_210 = {210, 2, 50, "连胜，成为了新的传说！", },
	id_301 = {301, 3, 3, "人，小有所成！", },
	id_302 = {302, 3, 5, "人，声名鹊起！", },
	id_303 = {303, 3, 10, "人，被海盗们视为刽子手！", },
	id_304 = {304, 3, 15, "人，被海盗们视为屠戮者！", },
	id_305 = {305, 3, 20, "人，被海盗们视为索命恶鬼！", },
	id_306 = {306, 3, 30, "人，悬赏金已达百万！", },
	id_307 = {307, 3, 50, "人，悬赏金已达千万！", },
	id_308 = {308, 3, 100, "人，悬赏金已过亿！", },
	id_309 = {309, 3, 200, "人，真是最恶劣的一代！", },
	id_310 = {310, 3, 300, "人，世界政府欲招募其为王下七武海！", },
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
	local id_data = Paomadeng["id_" .. key_id]
	assert(id_data, "Paomadeng not found " ..  key_id)
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
	for k, v in pairs(Paomadeng) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Paomadeng"] = nil
	package.loaded["DB_Paomadeng"] = nil
	package.loaded["db/DB_Paomadeng"] = nil
end

