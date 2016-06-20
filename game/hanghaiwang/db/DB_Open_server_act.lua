-- Filename: DB_Open_server_act.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Open_server_act", package.seeall)

keys = {
	"id", "open_day", "deadline", "close_day", "achieve1_desc", "achieve_1", "achieve2_desc", "achieve_2", "achieve3_desc", "achieve_3", "goods", "before_price", "now_price", "limited_num", "parameter", 
}

Open_server_act = {
	id_1 = {1, 1, 8, 8, "累计充值", "120001", "主线副本", "101001|101002|101003|101004|102001|102002|102003|102004|102005", "装备强化", "103001|103002|104001|104002|105001", "7|101322|1,7|102322|1,7|103322|1,7|104322|1", 960, 480, 15000, 720, },
	id_2 = {2, 2, 8, 8, "累计充值", "120002", "竞技场", "106001|106002|106003|106004|106005|106006|106007", "伙伴进阶", "107001|107002|107003|107004", "7|501401|1,7|502401|1,7|503401|1", 600, 300, 10000, 2160, },
	id_3 = {3, 3, 8, 8, "累计充值", "120003", "副本星数", "124001|124002|124003|124004|124005|124006|124007", "伙伴升级", "112001|112002|112003|112004", "7|102412|1,7|103412|1", 1920, 1440, 8000, 3600, },
	id_4 = {4, 4, 8, 8, "累计充值", "120004", "深海监狱", "121001|121002|121003|121004|121005|121006", "装备附魔", "109001|109002|109003|109004|110001|110002|110003|110004", "7|101412|1,7|104412|1", 1920, 1440, 7000, 5040, },
	id_5 = {5, 5, 8, 8, "累计充值", "120005", "探索", "111001|111002|111003|111004|111005|111006", "饰品强化", "114001|114002|115001|115002|115003|115004", "7|502501|1", 1200, 960, 6000, 6480, },
	id_6 = {6, 6, 8, 8, "累计充值", "120006", "饰品精炼", "117001|117002|118001|118002|118003|118004", "困难难度", "123001|123002|123003|123004|123005|123006|123007", "7|503503|1", 1200, 960, 6000, 7920, },
	id_7 = {7, 7, 8, 8, "累计充值", "120007", "战力突破", "119001|119002|119003|119004|119005|119006|119007|119008|119009", "等级突破", "101005|101006|101007|101008|101009|101010|101011", "7|700025|3,7|60029|2000", 2500, 2000, 5000, 9360, },
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
	local id_data = Open_server_act["id_" .. key_id]
	assert(id_data, "Open_server_act not found " ..  key_id)
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
	for k, v in pairs(Open_server_act) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Open_server_act"] = nil
	package.loaded["DB_Open_server_act"] = nil
	package.loaded["db/DB_Open_server_act"] = nil
end

