-- Filename: DB_Allshop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Allshop", package.seeall)

keys = {
	"id", "icon", "name", "desc", 
}

Allshop = {
	id_1 = {1, "drop_shop.png", "酒馆", "酒馆可招募伙伴，购买体力和耐力药水等道具", },
	id_2 = {2, "shop_arena.png", "竞技场商店", "竞技场商店可购买进阶石等道具", },
	id_3 = {3, "activity_mystery.png", "伙伴商店", "伙伴商店可购买伙伴、进阶石等道具", },
	id_4 = {4, "shop_guild.png", "公会商店", "公会商店可购买突破石、耐力药水等道具", },
	id_5 = {5, "shop_equip.png", "装备商店", "装备商店可购买高品质装备", },
	id_6 = {6, "shop_trea.png", "宝物商店", "宝物商店可购买专属宝物", },
	id_7 = {7, "shop_air.png", "空岛商店", "空岛商店可购买空岛贝", },
	id_8 = {8, "shop_awake.png", "觉醒商店", "觉醒商店可购买觉醒道具", },
	id_9 = {9, "shop_jewel.png", "饰品宝箱", "开启饰品宝箱可获得饰品", },
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
	local id_data = Allshop["id_" .. key_id]
	assert(id_data, "Allshop not found " ..  key_id)
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
	for k, v in pairs(Allshop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Allshop"] = nil
	package.loaded["DB_Allshop"] = nil
	package.loaded["db/DB_Allshop"] = nil
end

