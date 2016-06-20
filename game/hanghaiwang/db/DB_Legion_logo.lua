-- Filename: DB_Legion_logo.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Legion_logo", package.seeall)

keys = {
	"id", "img", 
}

Legion_logo = {
	id_1 = {1, "union_flag2.png", },
	id_2 = {2, "union_flag3.png", },
	id_3 = {3, "union_flag5.png", },
	id_4 = {4, "union_flag4.png", },
	id_5 = {5, "union_flag6.png", },
	id_6 = {6, "union_flag1.png", },
	id_7 = {7, "union_flag8.png", },
	id_8 = {8, "union_flag7.png", },
	id_9 = {9, "union_flag9.png", },
	id_10 = {10, "union_flag10.png", },
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
	local id_data = Legion_logo["id_" .. key_id]
	assert(id_data, "Legion_logo not found " ..  key_id)
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
	for k, v in pairs(Legion_logo) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Legion_logo"] = nil
	package.loaded["DB_Legion_logo"] = nil
	package.loaded["db/DB_Legion_logo"] = nil
end

