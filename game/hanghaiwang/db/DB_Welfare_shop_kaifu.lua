-- Filename: DB_Welfare_shop_kaifu.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Welfare_shop_kaifu", package.seeall)

keys = {
	"id", "activity_time", "activity_icon", "activity_name", "activity_title", "goods_list", 
}

Welfare_shop_kaifu = {
	id_1 = {1, "1|1", "icon_welfare_shop.png", "name_welfare_shop.png", "title_welfare_shop.png", "101|102|103", },
	id_2 = {2, "2|2", "icon_welfare_shop.png", "name_welfare_shop.png", "title_welfare_shop.png", "201|202|203|204|205|206|207", },
	id_3 = {3, "3|3", "icon_welfare_shop.png", "name_welfare_shop.png", "title_welfare_shop.png", "301|302|303|304|305|306|307|308|309", },
	id_4 = {4, "4|4", "icon_welfare_shop.png", "name_welfare_shop.png", "title_welfare_shop.png", "401|402|403|404|405|406", },
	id_5 = {5, "5|5", "icon_welfare_shop.png", "name_welfare_shop.png", "title_welfare_shop.png", "501|502|503|504|505|506|507|508", },
	id_6 = {6, "6|6", "icon_welfare_shop.png", "name_welfare_shop.png", "title_welfare_shop.png", "601|602|603|604|605|606|607|608", },
	id_7 = {7, "7|7", "icon_welfare_shop.png", "name_welfare_shop.png", "title_welfare_shop.png", "701|702|703|704|705|706|707|708|709", },
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
	local id_data = Welfare_shop_kaifu["id_" .. key_id]
	assert(id_data, "Welfare_shop_kaifu not found " ..  key_id)
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
	for k, v in pairs(Welfare_shop_kaifu) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Welfare_shop_kaifu"] = nil
	package.loaded["DB_Welfare_shop_kaifu"] = nil
	package.loaded["db/DB_Welfare_shop_kaifu"] = nil
end

