-- Filename: DB_Vip_card.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Vip_card", package.seeall)

keys = {
	"id", "continueTime", "cardReward", "itemId", "rmb", "gold", "can_rebuy", "gain_item", 
}

Vip_card = {
	id_1 = {1, 31, "3|0|100", 10, 30, 300, 1, 60701, },
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
	local id_data = Vip_card["id_" .. key_id]
	assert(id_data, "Vip_card not found " ..  key_id)
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
	for k, v in pairs(Vip_card) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Vip_card"] = nil
	package.loaded["DB_Vip_card"] = nil
	package.loaded["db/DB_Vip_card"] = nil
end

