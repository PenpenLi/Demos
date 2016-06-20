-- Filename: DB_Shell.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Shell", package.seeall)

keys = {
	"id", "shell_skill", "shell_child_skill", "shell_buff", "shell_fight_ratio", 
}

Shell = {
	id_10001 = {10001, 150000, nil, nil, 6000, },
	id_10002 = {10002, 150100, nil, "201001|0", 9000, },
	id_10003 = {10003, 150200, nil, "201101|0", 9000, },
	id_10004 = {10004, 150300, nil, "201201|0", 15000, },
	id_10005 = {10005, 150400, nil, "201301|0", 15000, },
	id_10006 = {10006, 150500, nil, "201401|0", 12000, },
	id_10007 = {10007, 150600, nil, "201501|0", 10000, },
	id_10008 = {10008, 150700, nil, "201601|0", 10000, },
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
	local id_data = Shell["id_" .. key_id]
	assert(id_data, "Shell not found " ..  key_id)
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
	for k, v in pairs(Shell) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Shell"] = nil
	package.loaded["DB_Shell"] = nil
	package.loaded["db/DB_Shell"] = nil
end

