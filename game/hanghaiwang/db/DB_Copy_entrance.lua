-- Filename: DB_Copy_entrance.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Copy_entrance", package.seeall)

keys = {
	"id", "name", "picture", "normal_copyid", "world_id", "position", "star_total", "point_position", "line_position", "ship_position", "can_explore_position", "name_position", "name_big", "scv_area", 
}

Copy_entrance = {
	id_1 = {1, "copy_name_2.png", "2.png", "1", "10000", "357,134", 15, "418,113", "236,199", "344,227", "470,183", "95,31", 2, 1357, },
	id_2 = {2, "copy_name_3.png", "3.png", "2", "10000", "184,-72", 24, "429,-83", "511,18", "511,-2", "215,10", "100,27", 3, 1357, },
	id_3 = {3, "copy_name_4.png", "4.png", "3", "10000", "263,-296", 30, "534,-214", "475,-150", "506,-264", "313,-217", "120,23", 4, 1357, },
	id_4 = {4, "copy_name_5.png", "5.png", "4", "10000", "638,-396", 30, "670,-214", "593,-247", "807,-214", "649,-292", "82,46", 5, 1638, },
	id_5 = {5, "copy_name_6.png", "6.png", "5", "10000", "709,-65", 30, "745,-102", "698,-152", "906,3", "742,12", "103,20", 6, 1709, },
	id_6 = {6, "copy_name_7.png", "7.png", "6", "10000", "982,198", 60, "1052,196", "898,49", "997,319", "1068,286", "158,34", 7, 1982, },
	id_7 = {7, "copy_name_8.png", "8.png", "7", "10000", "1093,4", 60, "1094,36", "1079,114", "1063,104", "1137,78", "116,19", 8, 2093, },
	id_8 = {8, "copy_name_9.png", "9.png", "8", "10000", "1140,-272", 60, "1080,-187", "1067,-80", "1090,-132", "1125,-182", "56,34", 9, 2140, },
	id_9 = {9, "copy_name_10.png", "10.png", "9|10", "10000", "1355,-169", 120, "1461,-184", "1275,-181", "1562,-94", "1389,-76", "107,34", 10, 2355, },
	id_10 = {10, "copy_name_11.png", "11.png", "11|12", "10000", "1564,-42", 120, "1563,-6", "1517,-98", "1470,77", "1595,38", "101,25", 11, 2564, },
	id_11 = {11, "copy_name_12.png", "12.png", "13", "10000", "1469,223", 60, "1596,211", "1519,89", "1682,234", "1494,298", "97,19", 12, 2564, },
	id_12 = {12, "copy_name_13.png", "13.png", "14", "10000", "1864,182", 60, "1895,167", "1730,190", "1817,265", "1890,260", "96,22", 13, 2864, },
	id_13 = {13, "copy_name_14.png", "14.png", "15|16", "10000", "2145,78", 120, "2096,97", "1995,139", "2081,145", "2178,146", "102,13", 14, 3145, },
	id_14 = {14, "copy_name_15.png", "15.png", "17|18", "10000", "1588,-345", 120, "1806,-280", "1944,-93", "1790,-212", "1619,-251", "100,37", 15, 3145, },
	id_15 = {15, "copy_name_16.png", "16.png", "19", "10000", "1881,-280", 60, "1960,-329", "1867,-312", "1874,-285", "1926,-220", "116,-2", 16, 3145, },
	id_16 = {16, "copy_name_17.png", "17.png", "20|21|22", "10000", "1860,-158", 180, "2061,-105", "2026,-226", "2097,-83", "1887,-54", "99,46", 17, 3145, },
	id_17 = {17, "copy_name_18.png", "18.png", "23|24", "10000", "2338,-266", 120, "2438,-263", "2251,-205", "2359,-276", "2380,-154", "112,53", 18, 3338, },
	id_18 = {18, "copy_name_19.png", "19.png", "25|26|27", "10000", "2598,-332", 180, "2576,-325", "2506,-298", "2571,-266", "2630,-258", "100,18", 19, 3598, },
	id_19 = {19, "copy_name_20.png", "20.png", "28", "10000", "2679,-168", 60, "2709,-83", "2647,-207", "2664,-117", "2630,-259", "125,48", 20, 3599, },
	id_20 = {20, "copy_name_21.png", "21.png", "29|30", "10000", "2477,35", 120, "2699,79", "2692,-4", "2657,-1", "2630,-260", "112,23", 21, 3600, },
	id_21 = {21, "copy_name_22.png", "22.png", "31|32|33", "10000", "2610,145", 180, "2813,129", "2755,108", "2865,125", "2630,-261", "157,39", 22, 3601, },
	id_22 = {22, "copy_name_23.png", "23.png", "34", "10001", "184,-72", 60, "429,-83", "511,18", "511,-2", "215,10", "100,27", 23, 3602, },
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
	local id_data = Copy_entrance["id_" .. key_id]
	assert(id_data, "Copy_entrance not found " ..  key_id)
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
	for k, v in pairs(Copy_entrance) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Copy_entrance"] = nil
	package.loaded["DB_Copy_entrance"] = nil
	package.loaded["db/DB_Copy_entrance"] = nil
end

