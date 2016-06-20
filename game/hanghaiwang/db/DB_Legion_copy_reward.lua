-- Filename: DB_Legion_copy_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Legion_copy_reward", package.seeall)

keys = {
	"id", "type", "item_id", "item_num", 
}

Legion_copy_reward = {
	id_1 = {1, 1, nil, 50000, },
	id_2 = {2, 2, 103422, 1, },
	id_3 = {3, 2, 103501, 1, },
	id_4 = {4, 2, 103502, 1, },
	id_5 = {5, 2, 103503, 1, },
	id_6 = {6, 2, 103512, 1, },
	id_7 = {7, 2, 103522, 1, },
	id_8 = {8, 2, 104101, 1, },
	id_9 = {9, 2, 104201, 1, },
	id_10 = {10, 2, 104202, 1, },
	id_11 = {11, 1, nil, 50000, },
	id_12 = {12, 2, 104222, 1, },
	id_13 = {13, 2, 104301, 1, },
	id_14 = {14, 2, 104302, 1, },
	id_15 = {15, 2, 104303, 1, },
	id_16 = {16, 2, 104312, 1, },
	id_17 = {17, 2, 104322, 1, },
	id_18 = {18, 2, 104401, 1, },
	id_19 = {19, 2, 104402, 1, },
	id_20 = {20, 2, 104403, 1, },
	id_21 = {21, 1, nil, 50000, },
	id_22 = {22, 2, 104422, 1, },
	id_23 = {23, 2, 104501, 1, },
	id_24 = {24, 2, 104502, 1, },
	id_25 = {25, 2, 104503, 1, },
	id_26 = {26, 2, 104512, 1, },
	id_27 = {27, 2, 104522, 1, },
	id_28 = {28, 2, 101391, 1, },
	id_29 = {29, 2, 100001, 1, },
	id_30 = {30, 2, 100002, 1, },
	id_31 = {31, 1, nil, 50000, },
	id_32 = {32, 2, 100004, 10, },
	id_33 = {33, 2, 60002, 10, },
	id_34 = {34, 2, 60001, 10, },
	id_35 = {35, 2, 60005, 10, },
	id_36 = {36, 2, 60006, 10, },
	id_37 = {37, 2, 60012, 10, },
	id_38 = {38, 2, 60019, 10, },
	id_39 = {39, 2, 60026, 10, },
	id_40 = {40, 2, 410001, 10, },
	id_41 = {41, 1, nil, 50000, },
	id_42 = {42, 2, 410003, 10, },
	id_43 = {43, 2, 410004, 10, },
	id_44 = {44, 2, 410005, 10, },
	id_45 = {45, 2, 410006, 10, },
	id_46 = {46, 2, 410007, 10, },
	id_47 = {47, 2, 410008, 10, },
	id_48 = {48, 2, 410009, 10, },
	id_49 = {49, 2, 410010, 10, },
	id_50 = {50, 2, 410011, 10, },
	id_51 = {51, 1, nil, 50000, },
	id_52 = {52, 2, 410013, 5, },
	id_53 = {53, 2, 410014, 5, },
	id_54 = {54, 2, 410015, 5, },
	id_55 = {55, 2, 410016, 5, },
	id_56 = {56, 2, 410017, 5, },
	id_57 = {57, 2, 410018, 5, },
	id_58 = {58, 2, 410019, 5, },
	id_59 = {59, 2, 410020, 5, },
	id_60 = {60, 2, 410021, 5, },
	id_61 = {61, 1, nil, 50000, },
	id_62 = {62, 2, 410023, 6, },
	id_63 = {63, 2, 410024, 6, },
	id_64 = {64, 2, 410025, 6, },
	id_65 = {65, 2, 410026, 6, },
	id_66 = {66, 2, 410027, 6, },
	id_67 = {67, 2, 410028, 6, },
	id_68 = {68, 2, 410029, 6, },
	id_69 = {69, 2, 410030, 6, },
	id_70 = {70, 2, 410031, 6, },
	id_71 = {71, 1, nil, 50000, },
	id_72 = {72, 2, 504506, 2, },
	id_73 = {73, 2, 504507, 2, },
	id_74 = {74, 2, 504508, 2, },
	id_75 = {75, 2, 504509, 2, },
	id_76 = {76, 2, 504510, 2, },
	id_77 = {77, 2, 504511, 2, },
	id_78 = {78, 2, 504512, 2, },
	id_79 = {79, 2, 504513, 2, },
	id_80 = {80, 2, 503401, 2, },
	id_81 = {81, 1, nil, 50000, },
	id_82 = {82, 2, 503501, 6, },
	id_83 = {83, 2, 503502, 6, },
	id_84 = {84, 2, 503503, 6, },
	id_85 = {85, 2, 5015016, 6, },
	id_86 = {86, 2, 5015026, 6, },
	id_87 = {87, 2, 5015036, 6, },
	id_88 = {88, 2, 5015046, 6, },
	id_89 = {89, 2, 5015056, 6, },
	id_90 = {90, 2, 5015066, 6, },
	id_91 = {91, 1, nil, 50000, },
	id_92 = {92, 2, 5015086, 3, },
	id_93 = {93, 2, 5015096, 3, },
	id_94 = {94, 2, 5015106, 3, },
	id_95 = {95, 2, 5015116, 3, },
	id_96 = {96, 2, 5015126, 3, },
	id_97 = {97, 2, 5015086, 3, },
	id_98 = {98, 2, 5015096, 3, },
	id_99 = {99, 2, 5015106, 3, },
	id_100 = {100, 2, 5015116, 3, },
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
	local id_data = Legion_copy_reward["id_" .. key_id]
	assert(id_data, "Legion_copy_reward not found " ..  key_id)
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
	for k, v in pairs(Legion_copy_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Legion_copy_reward"] = nil
	package.loaded["DB_Legion_copy_reward"] = nil
	package.loaded["db/DB_Legion_copy_reward"] = nil
end

