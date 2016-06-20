-- Filename: DB_Exploration.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Exploration", package.seeall)

keys = {
	"initialTimes", "levelAddTimesLimit", "recoveryTime", "upLevelAddTimes", "noTimesSpentItemId", "noTimesSpentGold", "costGoldAdd", "explorationOneTimeAdd", 
}

Exploration = {
	id_20 = {20, "15|2,20|2,25|2,30|2,35|2,40|2,45|2,50|2,55|2,60|2,65|2,70|2,75|2,80|2", 1200, 10, "60019|5", "20|5", "5|100", 1, },
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
	local id_data = Exploration["id_" .. key_id]
	assert(id_data, "Exploration not found " ..  key_id)
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
	for k, v in pairs(Exploration) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Exploration"] = nil
	package.loaded["DB_Exploration"] = nil
	package.loaded["db/DB_Exploration"] = nil
end

