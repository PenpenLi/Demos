-- Filename: DB_Npcface.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Npcface", package.seeall)

keys = {
	"id", "face_image", "position_x", "position_y", 
}

Npcface = {
	id_1 = {1, "face_xinshou_angry.png", 0, 0, },
	id_2 = {2, "face_xinshou_happy.png", 0, 0, },
	id_3 = {3, "face_xinshou_fear.png", 0, 0, },
	id_4 = {4, "face_xinshou_yun.png", 0, 0, },
	id_5 = {5, "face_xinshou_yinxian.png", 0, 0, },
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
	local id_data = Npcface["id_" .. key_id]
	assert(id_data, "Npcface not found " ..  key_id)
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
	for k, v in pairs(Npcface) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Npcface"] = nil
	package.loaded["DB_Npcface"] = nil
	package.loaded["db/DB_Npcface"] = nil
end

