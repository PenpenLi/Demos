-- Filename: DB_Tower_shop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Tower_shop", package.seeall)

keys = {
	"id", "items", "costPrison", "limitType", "baseNum", "levelLimit", "position", "recommended", 
}

Tower_shop = {
	id_1 = {1, "7|1013124|1", 50, 3, nil, 0, 1, 0, },
	id_2 = {2, "7|1023124|1", 50, 3, nil, 0, 1, 0, },
	id_3 = {3, "7|1033124|1", 50, 3, nil, 0, 1, 0, },
	id_4 = {4, "7|1043124|1", 50, 3, nil, 0, 1, 0, },
	id_5 = {5, "7|1013224|1", 120, 3, nil, 0, 1, 1, },
	id_6 = {6, "7|1023224|1", 120, 3, nil, 0, 1, 1, },
	id_7 = {7, "7|1033224|1", 120, 3, nil, 0, 1, 1, },
	id_8 = {8, "7|1043224|1", 120, 3, nil, 0, 1, 1, },
	id_9 = {9, "7|60501|1", 40, 1, 100, 0, 1, 0, },
	id_10 = {10, "7|60502|1", 80, 1, 60, 0, 1, 0, },
	id_11 = {11, "7|60503|1", 200, 1, 40, 0, 1, 0, },
	id_12 = {12, "7|60504|1", 400, 1, 20, 30, 1, 0, },
	id_13 = {13, "7|1014125|1", 320, 3, nil, 20, 2, 0, },
	id_14 = {14, "7|1024125|1", 320, 3, nil, 20, 2, 0, },
	id_15 = {15, "7|1034125|1", 320, 3, nil, 20, 2, 0, },
	id_16 = {16, "7|1044125|1", 320, 3, nil, 20, 2, 0, },
	id_17 = {17, "7|1014225|1", 600, 3, nil, 35, 2, 1, },
	id_18 = {18, "7|1024225|1", 600, 3, nil, 35, 2, 1, },
	id_19 = {19, "7|1034225|1", 600, 3, nil, 35, 2, 1, },
	id_20 = {20, "7|1044225|1", 600, 3, nil, 35, 2, 1, },
	id_21 = {21, "7|1015126|1", 2000, 3, nil, 45, 3, 0, },
	id_22 = {22, "7|1025126|1", 2000, 3, nil, 45, 3, 0, },
	id_23 = {23, "7|1035126|1", 2000, 3, nil, 45, 3, 0, },
	id_24 = {24, "7|1045126|1", 2000, 3, nil, 45, 3, 0, },
	id_25 = {25, "7|1015226|1", 3500, 3, nil, 55, 3, 1, },
	id_26 = {26, "7|1025226|1", 3500, 3, nil, 55, 3, 1, },
	id_27 = {27, "7|1035226|1", 3500, 3, nil, 55, 3, 1, },
	id_28 = {28, "7|1045226|1", 3500, 3, nil, 55, 3, 1, },
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
	local id_data = Tower_shop["id_" .. key_id]
	assert(id_data, "Tower_shop not found " ..  key_id)
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
	for k, v in pairs(Tower_shop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Tower_shop"] = nil
	package.loaded["DB_Tower_shop"] = nil
	package.loaded["db/DB_Tower_shop"] = nil
end

