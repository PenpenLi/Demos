-- Filename: DB_Legion.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Legion", package.seeall)

keys = {
	"id", "needLevel", "costSilver", "costGold", "cd", "baseNum", "maxNum", "maxLevel", "expId", "donate1", "donate2", "donate3", "donate4", "donate5", "viceLevelArr", "jionNumLimit", "accuseCost", "deleteNumLimit", 
}

Legion = {
	id_1 = {1, 17, 500000, 500, 43200, "1|25,2|26,3|27,4|28,5|28,6|29,7|29,8|30,9|30,10|31,11|31,12|32,13|32,14|33,15|33,16|34,17|34,18|35,19|35,20|36,21|36,22|37,23|38,24|39,25|40,26|40,27|40,28|40,29|40,30|40,31|40,32|40,33|40,34|40,35|40,36|40,37|40,38|40,39|40,40|40,41|40,42|40,43|40,44|40,45|40,46|40,47|40,48|40,49|40,50|40,51|40,52|40,53|40,54|40,55|40,56|40,57|40,58|40,59|40,60|40,61|40,62|40,63|40,64|40,65|40,66|40,67|40,68|40,69|40,70|40,71|40,72|40,73|40,74|40,75|40,76|40,77|40,78|40,79|40,80|40,81|40,82|40,83|40,84|40,85|40,86|40,87|40,88|40,89|40,90|40,91|40,92|40,93|40,94|40,95|40,96|40,97|40,98|40,99|40,100|40", 50, 25, 2001, "20000|0|200|200|0", "0|20|600|400|0", "0|200|1000|2000|3", nil, nil, "10|2,20|2,30|2,40|2,99|2", 5, 300, 5, },
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
	local id_data = Legion["id_" .. key_id]
	assert(id_data, "Legion not found " ..  key_id)
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
	for k, v in pairs(Legion) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Legion"] = nil
	package.loaded["DB_Legion"] = nil
	package.loaded["db/DB_Legion"] = nil
end

