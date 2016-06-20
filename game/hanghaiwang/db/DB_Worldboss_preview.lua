-- Filename: DB_Worldboss_preview.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Worldboss_preview", package.seeall)

keys = {
	"id", "desc", "reward", "chance_drop", "bossid", "order", 
}

Worldboss_preview = {
	id_1 = {1, "击杀者", "1|0|100000,12|0|800,7|60601|800", nil, 1, 1, },
	id_2 = {2, "伤害第1名", "1|0|200000,12|0|1000,7|60601|1200", nil, 1, 2, },
	id_3 = {3, "伤害第2名", "1|0|100000,12|0|900,7|60601|1100", nil, 1, 3, },
	id_4 = {4, "伤害第3名", "1|0|90000,12|0|800,7|60601|1000", nil, 1, 4, },
	id_5 = {5, "伤害第4-10名", "1|0|80000,12|0|750,7|60601|800", nil, 1, 5, },
	id_6 = {6, "伤害第11-20名", "1|0|70000,12|0|700,7|60601|600", nil, 1, 6, },
	id_7 = {7, "伤害第21-50名", "1|0|65000,12|0|650,7|60601|500", nil, 1, 7, },
	id_8 = {8, "伤害第51-100名", "1|0|60000,12|0|600,7|60601|400", nil, 1, 8, },
	id_9 = {9, "伤害第101-200名", "1|0|55000,12|0|550,7|60601|400", nil, 1, 9, },
	id_10 = {10, "伤害第201-300名", "1|0|50000,12|0|500,7|60601|400", nil, 1, 10, },
	id_11 = {11, "伤害第301-400名", "1|0|45000,12|0|450,7|60601|400", nil, 1, 11, },
	id_12 = {12, "伤害第401-500名", "1|0|40000,12|0|400,7|60601|400", nil, 1, 12, },
	id_13 = {13, "伤害第501-1000名", "1|0|35000,12|0|350,7|60601|400", nil, 1, 13, },
	id_14 = {14, "伤害第1001-1500名", "1|0|30000,12|0|300,7|60601|400", nil, 1, 14, },
	id_15 = {15, "伤害第1501-2000名", "1|0|25000,12|0|250,7|60601|400", nil, 1, 15, },
	id_16 = {16, "伤害第2001-5000名", "1|0|20000,12|0|200,7|60601|400", nil, 1, 16, },
	id_17 = {17, "伤害第5001名之后", "1|0|15000,12|0|150,7|60601|400", nil, 1, 17, },
	id_18 = {18, "击杀者", "1|0|100000,12|0|800,7|500002|1", nil, 2, 1, },
	id_19 = {19, "伤害第1名", "1|0|200000,12|0|1000,7|500002|3", nil, 2, 2, },
	id_20 = {20, "伤害第2名", "1|0|100000,12|0|900,7|500002|2", nil, 2, 3, },
	id_21 = {21, "伤害第3名", "1|0|90000,12|0|800,7|500002|1", nil, 2, 4, },
	id_22 = {22, "伤害第4-10名", "1|0|80000,12|0|750", 500002, 2, 5, },
	id_23 = {23, "伤害第11-20名", "1|0|70000,12|0|700,", 500002, 2, 6, },
	id_24 = {24, "伤害第21-50名", "1|0|65000,12|0|650,", nil, 2, 7, },
	id_25 = {25, "伤害第51-100名", "1|0|60000,12|0|600,", nil, 2, 8, },
	id_26 = {26, "伤害第101-200名", "1|0|55000,12|0|550,", nil, 2, 9, },
	id_27 = {27, "伤害第201-300名", "1|0|50000,12|0|500,", nil, 2, 10, },
	id_28 = {28, "伤害第301-400名", "1|0|45000,12|0|450,", nil, 2, 11, },
	id_29 = {29, "伤害第401-500名", "1|0|40000,12|0|400,", nil, 2, 12, },
	id_30 = {30, "伤害第501-1000名", "1|0|35000,12|0|350,", nil, 2, 13, },
	id_31 = {31, "伤害第1001-1500名", "1|0|30000,12|0|300,", nil, 2, 14, },
	id_32 = {32, "伤害第1501-2000名", "1|0|25000,12|0|250,", nil, 2, 15, },
	id_33 = {33, "伤害第2001-5000名", "1|0|20000,12|0|200,", nil, 2, 16, },
	id_34 = {34, "伤害第5001名之后", "1|0|15000,12|0|150,", nil, 2, 17, },
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
	local id_data = Worldboss_preview["id_" .. key_id]
	assert(id_data, "Worldboss_preview not found " ..  key_id)
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
	for k, v in pairs(Worldboss_preview) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Worldboss_preview"] = nil
	package.loaded["DB_Worldboss_preview"] = nil
	package.loaded["db/DB_Worldboss_preview"] = nil
end

