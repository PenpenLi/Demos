-- Filename: DB_Aster.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Aster", package.seeall)

keys = {
	"id", "name", "des", "icon", "coin", "star", "weight", 
}

Aster = {
	id_1 = {1, "宝剑", nil, "tarot1.png", 0, 1, 1000, },
	id_2 = {2, "恶魔", nil, "tarot2.png", 0, 1, 1000, },
	id_3 = {3, "皇帝", nil, "tarot3.png", 0, 1, 1000, },
	id_4 = {4, "教皇", nil, "tarot4.png", 0, 1, 1000, },
	id_5 = {5, "力量", nil, "tarot5.png", 0, 1, 1000, },
	id_6 = {6, "恋人", nil, "tarot6.png", 0, 1, 1000, },
	id_7 = {7, "命运之轮", nil, "tarot7.png", 0, 1, 1000, },
	id_8 = {8, "魔术师", nil, "tarot8.png", 0, 1, 1000, },
	id_9 = {9, "权杖", nil, "tarot9.png", 0, 1, 1000, },
	id_10 = {10, "审判", nil, "tarot10.png", 0, 1, 1000, },
	id_11 = {11, "圣杯", nil, "tarot11.png", 0, 1, 1000, },
	id_12 = {12, "死神", nil, "tarot12.png", 0, 1, 1000, },
	id_13 = {13, "塔", nil, "tarot13.png", 0, 1, 1000, },
	id_14 = {14, "太阳", nil, "tarot14.png", 0, 1, 1000, },
	id_15 = {15, "星币", nil, "tarot15.png", 0, 1, 1000, },
	id_16 = {16, "星星", nil, "tarot16.png", 0, 1, 1000, },
	id_17 = {17, "隐士", nil, "tarot17.png", 0, 1, 1000, },
	id_18 = {18, "愚者", nil, "tarot18.png", 0, 1, 1000, },
	id_19 = {19, "月亮", nil, "tarot19.png", 0, 1, 1000, },
	id_20 = {20, "正义", nil, "tarot20.png", 0, 1, 1000, },
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
	local id_data = Aster["id_" .. key_id]
	assert(id_data, "Aster not found " ..  key_id)
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
	for k, v in pairs(Aster) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Aster"] = nil
	package.loaded["DB_Aster"] = nil
	package.loaded["db/DB_Aster"] = nil
end

