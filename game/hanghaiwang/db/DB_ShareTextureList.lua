-- Filename: DB_ShareTextureList.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_ShareTextureList", package.seeall)

keys = {
	"id", "animation", "shareName", 
}

ShareTextureList = {
	id_1 = {1, "meffect_45", "meffect_44", },
	id_2 = {2, "die_1_2", "die_1_1", },
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
	local id_data = ShareTextureList["id_" .. key_id]
	assert(id_data, "ShareTextureList not found " ..  key_id)
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
	for k, v in pairs(ShareTextureList) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_ShareTextureList"] = nil
	package.loaded["DB_ShareTextureList"] = nil
	package.loaded["db/DB_ShareTextureList"] = nil
end

