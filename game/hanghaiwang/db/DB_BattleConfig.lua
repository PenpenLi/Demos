-- Filename: DB_BattleConfig.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_BattleConfig", package.seeall)

keys = {
	"id", "arena_background", "arena_backmusic", "tower_background", "tower_backmusic", "mine_background", "mine_backmusic", "topshow1_background", "topshow1_backmusic", "topshow2_background", "topshow2_backmusic", "default_background", "default_backmusic", "wa_background", "wa_backmusic", 
}

BattleConfig = {
	id_1 = {1, "bgfightJiaban01.jpg", "fight3.mp3", "bgfighthuangjinzhong14.jpg", "fight2.mp3", "bgfight05_haian.jpg", "fight2.mp3", "bgfightchuxingtai00.jpg", "copy1.mp3", "bgfightchuxingtai00.jpg", "copy1.mp3", "bgfightJiaban01.jpg", "fight3.mp3", "bgfightJiaban01.jpg", "fight3.mp3", },
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
	local id_data = BattleConfig["id_" .. key_id]
	assert(id_data, "BattleConfig not found " ..  key_id)
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
	for k, v in pairs(BattleConfig) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_BattleConfig"] = nil
	package.loaded["DB_BattleConfig"] = nil
	package.loaded["db/DB_BattleConfig"] = nil
end

