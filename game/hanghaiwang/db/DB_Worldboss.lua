-- Filename: DB_Worldboss.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Worldboss", package.seeall)

keys = {
	"id", "baseLv", "minLv", "maxLv", "attackSilver", "attackRestige", "beginTime", "endTime", "name", "model", "stronghold", "rewardId", "week", "Music", "desc", 
}

Worldboss = {
	id_1 = {1, 1, 1, 100, 10, 100, 210000, 211000, "近海之王", 1, 703001, 1, "1|2|3|4|5|6|7", "1.mp3", "普攻对敌方单体造成伤害，怒攻对敌方全体造成伤害。", },
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
	local id_data = Worldboss["id_" .. key_id]
	assert(id_data, "Worldboss not found " ..  key_id)
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
	for k, v in pairs(Worldboss) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Worldboss"] = nil
	package.loaded["DB_Worldboss"] = nil
	package.loaded["db/DB_Worldboss"] = nil
end

