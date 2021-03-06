-- Filename: DB_Loot.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Loot", package.seeall)

keys = {
	"id", "baseTreasures", "ratioArr", "ratioDec", "shieldSpentItemId", "shieldSpentGold", "shieldTime", "shieldTimeLimit", "allShieldTime", "robSpentItemId", "dayNum", "buyNeedGold", "enemyTime", 
}

Loot = {
	id_1 = {1, nil, "500,1000,1500,2500,4000,6000,10000", "极低概率,较低概率,低概率,一般概率,较高概率,高概率,极高概率", "60005|1", 20, 14400, 360000, "00:00:01|10:00:00", 60020, 5, "1|50,2|100,3|100,5|150,150|200", 86400, },
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
	local id_data = Loot["id_" .. key_id]
	assert(id_data, "Loot not found " ..  key_id)
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
	for k, v in pairs(Loot) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Loot"] = nil
	package.loaded["DB_Loot"] = nil
	package.loaded["db/DB_Loot"] = nil
end

