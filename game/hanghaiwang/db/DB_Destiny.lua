-- Filename: DB_Destiny.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Destiny", package.seeall)

keys = {
	"destinyId", "attArr", "costCopystar", "isBreak", "silverCost", 
}

Destiny = {
	id_1 = {1, "1|90", 10, nil, 0, },
	id_2 = {2, "2|18", 10, nil, 1400, },
	id_3 = {3, "3|18", 10, nil, 2000, },
	id_4 = {4, "4|24", 15, nil, 2300, },
	id_5 = {5, "5|24", 15, nil, 4500, },
	id_6 = {6, "2|24", 15, nil, 5000, },
	id_7 = {7, "3|24", 15, nil, 6800, },
	id_8 = {8, "1|120,4|24", 15, nil, 9800, },
	id_9 = {9, "1|120,5|24", 15, nil, 12000, },
	id_10 = {10, "2|24,3|24", 15, nil, 15200, },
	id_11 = {11, "1|120", 15, nil, 16200, },
	id_12 = {12, nil, 20, 2, 17100, },
	id_13 = {13, "2|36", 20, nil, 20900, },
	id_14 = {14, "3|36", 20, nil, 22000, },
	id_15 = {15, "4|36", 20, nil, 23100, },
	id_16 = {16, "5|36", 20, nil, 25000, },
	id_17 = {17, "2|36", 20, nil, 25300, },
	id_18 = {18, "3|36", 20, nil, 26500, },
	id_19 = {19, "1|180,4|36", 20, nil, 28000, },
	id_20 = {20, "1|180,5|36", 20, nil, 28000, },
	id_21 = {21, "2|36,3|36", 20, nil, 29500, },
	id_22 = {22, "1|180", 20, nil, 31000, },
	id_23 = {23, "2|36", 20, nil, 31000, },
	id_24 = {24, "3|36", 20, nil, 32500, },
	id_25 = {25, "4|36", 20, nil, 34000, },
	id_26 = {26, "5|36", 20, nil, 34000, },
	id_27 = {27, "2|36", 20, nil, 35500, },
	id_28 = {28, "3|36", 20, nil, 37000, },
	id_29 = {29, "1|180,4|36", 20, nil, 37000, },
	id_30 = {30, "1|180,5|36", 20, nil, 38500, },
	id_31 = {31, "2|36,3|36", 20, nil, 40000, },
	id_32 = {32, "1|180", 20, nil, 40000, },
	id_33 = {33, "2|36", 20, nil, 41500, },
	id_34 = {34, "3|36", 20, nil, 43000, },
	id_35 = {35, "4|36", 20, nil, 42700, },
	id_36 = {36, "5|36", 20, nil, 43000, },
	id_37 = {37, "2|36", 20, nil, 46000, },
	id_38 = {38, "3|36", 20, nil, 46000, },
	id_39 = {39, "1|180,4|36", 20, nil, 46000, },
	id_40 = {40, "1|180,5|36", 20, nil, 49000, },
	id_41 = {41, "2|36,3|36", 20, nil, 49000, },
	id_42 = {42, "1|180", 20, nil, 49000, },
	id_43 = {43, "2|36", 20, nil, 52000, },
	id_44 = {44, "3|36", 20, nil, 52000, },
	id_45 = {45, "4|36", 20, nil, 52000, },
	id_46 = {46, "5|36", 20, nil, 55000, },
	id_47 = {47, "2|36", 20, nil, 55000, },
	id_48 = {48, "3|36", 20, nil, 55000, },
	id_49 = {49, "1|180,4|36", 20, nil, 58000, },
	id_50 = {50, "1|180,5|36", 20, nil, 58000, },
	id_51 = {51, "2|36,3|36", 20, nil, 58000, },
	id_52 = {52, "1|180", 20, nil, 61000, },
	id_53 = {53, "2|36", 20, nil, 61000, },
	id_54 = {54, "3|36", 20, nil, 61000, },
	id_55 = {55, "4|36", 20, nil, 63000, },
	id_56 = {56, "5|36", 20, nil, 63000, },
	id_57 = {57, "2|36", 20, nil, 63000, },
	id_58 = {58, "3|36", 20, nil, 65000, },
	id_59 = {59, "1|180,4|36", 20, nil, 65000, },
	id_60 = {60, "1|180,5|36", 20, nil, 65000, },
	id_61 = {61, "2|36,3|36", 20, nil, 67000, },
	id_62 = {62, "1|180", 20, nil, 67000, },
	id_63 = {63, "2|36", 20, nil, 67000, },
	id_64 = {64, "3|36", 20, nil, 69000, },
	id_65 = {65, "4|36", 20, nil, 69000, },
	id_66 = {66, "5|36", 20, nil, 69000, },
	id_67 = {67, "2|36", 20, nil, 71000, },
	id_68 = {68, "3|36", 20, nil, 71000, },
	id_69 = {69, "1|180,4|36", 20, nil, 71000, },
	id_70 = {70, "1|180,5|36", 20, nil, 73000, },
	id_71 = {71, "2|36,3|36", 20, nil, 73000, },
	id_72 = {72, "1|180", 20, nil, 73000, },
	id_73 = {73, "2|36", 20, nil, 75000, },
	id_74 = {74, "3|36", 20, nil, 75000, },
	id_75 = {75, "4|36", 20, nil, 75000, },
	id_76 = {76, "5|36", 20, nil, 77000, },
	id_77 = {77, "2|36", 20, nil, 77000, },
	id_78 = {78, "3|36", 20, nil, 77000, },
	id_79 = {79, "1|180,4|36", 20, nil, 79000, },
	id_80 = {80, "1|180,5|36", 20, nil, 79000, },
	id_81 = {81, "2|36,3|36", 20, nil, 79000, },
	id_82 = {82, "1|180", 20, nil, 81000, },
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
	local id_data = Destiny["id_" .. key_id]
	assert(id_data, "Destiny not found " ..  key_id)
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
	for k, v in pairs(Destiny) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Destiny"] = nil
	package.loaded["DB_Destiny"] = nil
	package.loaded["db/DB_Destiny"] = nil
end

