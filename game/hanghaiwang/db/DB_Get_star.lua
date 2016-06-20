-- Filename: DB_Get_star.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Get_star", package.seeall)

keys = {
	"id", "type", "round", "blood", "dead", "description", 
}

Get_star = {
	id_1 = {1, 2, 99, nil, nil, "战斗胜利", },
	id_2 = {2, 3, nil, 0, nil, "战斗胜利", },
	id_3 = {3, 4, nil, nil, 99, "战斗胜利", },
	id_4 = {4, 2, 10, nil, nil, "回合数不超过10", },
	id_5 = {5, 2, 5, nil, nil, "回合数不超过5", },
	id_6 = {6, 3, nil, 50, nil, "团队剩余血量不低于50%", },
	id_7 = {7, 3, nil, 70, nil, "团队剩余血量不低于70%", },
	id_8 = {8, 4, nil, nil, 1, "最多死亡一名伙伴", },
	id_9 = {9, 4, nil, nil, 0, "伙伴全部存活", },
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
	local id_data = Get_star["id_" .. key_id]
	assert(id_data, "Get_star not found " ..  key_id)
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
	for k, v in pairs(Get_star) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Get_star"] = nil
	package.loaded["DB_Get_star"] = nil
	package.loaded["db/DB_Get_star"] = nil
end

