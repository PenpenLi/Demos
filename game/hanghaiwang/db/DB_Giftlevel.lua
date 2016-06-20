-- Filename: DB_Giftlevel.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Giftlevel", package.seeall)

keys = {
	"id", "giftatt", "giftdef", "giftlif", "rangeatt", "rangedef", "rangelif", "trainatt", "traindef", "trainlif", "speed", "rangespe", "trainspe", 
}

Giftlevel = {
	id_1 = {"1", "1.3|E,1.5|D,1.8|C,1.9|B-,2|B,2.1|B+,2.2|A-,2.3|A,2.4|A+,2.5|S-,2.65|S,2.8|S+,2.95|SS-,3.1|SS,3.25|SS+,3.4|SSS-,3.55|SSS,3.6|SSS+", "0.35|E,0.52|D,0.69|C,0.74|B-,0.8|B,0.86|B+,0.92|A-,0.98|A,1.04|A+,1.12|S-,1.2|S,1.28|S+,1.37|SS-,1.46|SS,1.54|SS+,1.62|SSS-,1.71|SSS,1.8|SSS+", "1|E,1.09|D,1.19|C,1.22|B-,1.25|B,1.28|B+,1.31|A-,1.34|A,1.38|A+,1.42|S-,1.47|S,1.52|S+,1.56|SS-,1.61|SS,1.66|SS+,1.71|SSS-,1.75|SSS,1.8|SSS+", "1.3|3.85", "0.35|1.8", "1|1.8", "0|28", "0|28", "0|14", "1|E,3|D,5|C,6|B-,7|B,8|B+,9|A-,10|A,11|A+,12|S-,13|S,14|S+,15|SS-,16|SS,17|SS+,18|SSS-,19|SSS,20|SSS+", "1|20", "0|1", },
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
	local id_data = Giftlevel["id_" .. key_id]
	assert(id_data, "Giftlevel not found " ..  key_id)
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
	for k, v in pairs(Giftlevel) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Giftlevel"] = nil
	package.loaded["DB_Giftlevel"] = nil
	package.loaded["db/DB_Giftlevel"] = nil
end

