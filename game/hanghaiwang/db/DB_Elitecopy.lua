-- Filename: DB_Elitecopy.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Elitecopy", package.seeall)

keys = {
	"id", "name", "desc", "image", "pre_copyid", "coins", "general_soul", "exp", "energy", "rewards", "baseids", "next_eliteid", "thumbnail", "world_id", "position", "name_png", "point_position", "line_position", "ship_position", "scv_area", 
}

Elitecopy = {
	id_200001 = {200001, "哥特岛精英", nil, "name_copy2.png", 1, nil, nil, nil, 10, nil, 200002, 200002, "2.png", 20001, "357,134", "copy_name_2.png", "418,113", "236,199", "344,227", 1357, },
	id_200002 = {200002, "谢尔兹镇精英", nil, "name_copy3.png", 2, nil, nil, nil, 10, nil, 200003, 200003, "3.png", 20001, "184,-72", "copy_name_3.png", "429,-83", "511,18", "511,-2", 1357, },
	id_200003 = {200003, "橘子镇精英", nil, "name_copy4.png", 3, nil, nil, nil, 10, nil, 200004, 200004, "4.png", 20001, "263,-296", "copy_name_4.png", "534,-214", "475,-150", "506,-264", 1357, },
	id_200004 = {200004, "糖汁村精英", nil, "name_copy5.png", 4, nil, nil, nil, 10, nil, 200005, 200005, "5.png", 20001, "638,-396", "copy_name_5.png", "670,-214", "593,-247", "807,-214", 1638, },
	id_200005 = {200005, "海上餐厅精英", nil, "name_copy6.png", 5, nil, nil, nil, 10, nil, 200006, 200006, "6.png", 20001, "709,-65", "copy_name_6.png", "745,-102", "698,-152", "906,3", 1709, },
	id_200006 = {200006, "阿龙公园精英", nil, "name_copy7.png", 6, nil, nil, nil, 10, nil, 200007, 200007, "7.png", 20001, "982,198", "copy_name_7.png", "1052,196", "898,49", "997,319", 1982, },
	id_200007 = {200007, "巴格镇精英", nil, "name_copy8.png", 7, nil, nil, nil, 10, nil, 200008, 200008, "8.png", 20001, "1093,4", "copy_name_8.png", "1094,36", "1079,114", "1063,104", 2093, },
	id_200008 = {200008, "李维斯山精英", nil, "name_copy9.png", 8, nil, nil, nil, 10, nil, 200009, 200009, "9.png", 20001, "1140,-272", "copy_name_9.png", "1080,-187", "1067,-80", "1090,-132", 2140, },
	id_200009 = {200009, "威士忌山峰精英", nil, "name_copy10.png", 10, nil, nil, nil, 10, nil, 200010, 200010, "10.png", 20001, "1355,-169", "copy_name_10.png", "1461,-184", "1275,-181", "1562,-94", 2355, },
	id_200010 = {200010, "小花园精英", nil, "name_copy11.png", 12, nil, nil, nil, 10, nil, 200011, 200011, "11.png", 20001, "1564,-42", "copy_name_11.png", "1563,-6", "1517,-98", "1470,77", 2564, },
	id_200011 = {200011, "铁桶岛精英", nil, "name_copy12.png", 13, nil, nil, nil, 10, nil, 200012, 200012, "12.png", 20001, "1469,223", "copy_name_12.png", "1596,211", "1519,89", "1682,234", 2564, },
	id_200012 = {200012, "拿哈那沙漠精英", nil, "name_copy13.png", 14, nil, nil, nil, 10, nil, 200013, 200013, "13.png", 20001, "1864,182", "copy_name_13.png", "1895,167", "1730,190", "1817,265", 2864, },
	id_200013 = {200013, "阿拉巴斯坦精英", nil, "name_copy14.png", 16, nil, nil, nil, 10, nil, 200014, 200014, "14.png", 20001, "2145,78", "copy_name_14.png", "2096,97", "1995,139", "2081,145", 3145, },
	id_200014 = {200014, "加亚精英", nil, "name_copy15.png", 18, nil, nil, nil, 10, nil, 200015, 200015, "15.png", 20001, "1588,-345", "copy_name_15.png", "1806,-280", "1944,-93", "1790,-212", 3145, },
	id_200015 = {200015, "天空圣地精英", nil, "name_copy16.png", 19, nil, nil, nil, 10, nil, 200016, 200016, "16.png", 20001, "1881,-280", "copy_name_16.png", "1960,-329", "1867,-312", "1874,-285", 3145, },
	id_200016 = {200016, "黄金乡精英", nil, "name_copy17.png", 22, nil, nil, nil, 10, nil, 200017, 200017, "17.png", 20001, "1860,-158", "copy_name_17.png", "2061,-105", "2026,-226", "2097,-83", 3145, },
	id_200017 = {200017, "长环岛精英", nil, "name_copy18.png", 24, nil, nil, nil, 10, nil, 200018, 200018, "18.png", 20001, "2338,-266", "copy_name_18.png", "2438,-263", "2251,-205", "2359,-276", 3338, },
	id_200018 = {200018, "七水之城精英", nil, "name_copy19.png", 27, nil, nil, nil, 10, nil, 200019, 200019, "19.png", 20001, "2598,-332", "copy_name_19.png", "2576,-325", "2506,-298", "2571,-266", 3598, },
	id_200019 = {200019, "海上列车精英", nil, "name_copy20.png", 28, nil, nil, nil, 10, nil, 200020, 200020, "20.png", 20001, "2679,-168", "copy_name_20.png", "2709,-83", "2647,-207", "2664,-117", 3599, },
	id_200020 = {200020, "司法岛精英", nil, "name_copy21.png", 30, nil, nil, nil, 10, nil, 200021, 200021, "21.png", 20001, "2477,35", "copy_name_21.png", "2699,79", "2692,-4", "2657,-1", 3600, },
	id_200021 = {200021, "司法之塔精英", nil, "name_copy22.png", 33, nil, nil, nil, 10, nil, 200022, 200022, "22.png", 20001, "2610,145", "copy_name_22.png", "2813,129", "2755,108", "2865,125", 3601, },
	id_200022 = {200022, "踌躇之桥精英", nil, "name_copy23.png", 34, nil, nil, nil, 10, nil, 200023, nil, "23.png", 20001, "2841,209", "copy_name_23.png", "2985,170", "2899,137", "3030,172", 3603, },
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
	local id_data = Elitecopy["id_" .. key_id]
	assert(id_data, "Elitecopy not found " ..  key_id)
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
	for k, v in pairs(Elitecopy) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Elitecopy"] = nil
	package.loaded["DB_Elitecopy"] = nil
	package.loaded["db/DB_Elitecopy"] = nil
end

