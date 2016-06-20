-- Filename: DB_Legion_copy_build.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Legion_copy_build", package.seeall)

keys = {
	"id", "expid", "levelRatio", "openlv", "vital_of_power", "vital_of_stamina", "vital_limit", "vital_day_limit", "challenge_times", "buy_times_gold", "reset_progress", "forbid_time", "reward_time", "cut_need", "cut_compensate", "cut_forbid_time", 
}

Legion_copy_build = {
	id_1 = {1, 2004, 100, 3, 1, 1, "100000|110000|120000|130000|140000|150000|160000|170000|180000|190000|200000|210000|220000|230000|240000|250000|260000|270000|280000|290000|300000|300000|300000|300000|300000|300000", 800, 2, "1|50", 5000, "040000|040001", "120000|180000", 500, 5000, 600, },
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
	local id_data = Legion_copy_build["id_" .. key_id]
	assert(id_data, "Legion_copy_build not found " ..  key_id)
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
	for k, v in pairs(Legion_copy_build) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Legion_copy_build"] = nil
	package.loaded["DB_Legion_copy_build"] = nil
	package.loaded["db/DB_Legion_copy_build"] = nil
end

