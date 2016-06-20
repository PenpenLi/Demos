-- Filename: DB_Item_dress.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_dress", package.seeall)

keys = {
	"id", "name", "info", "icon_small", "icon_big", "item_type", "quality", "sellable", "sellType", "sellNum", "maxStacking", "canDestroy", "changeModel", "changeHeadIcon", "changeBodyImg", "changeRageHeadIcon", "baseAffix", "score", 
}

Item_dress = {
	id_80001 = {80001, "20001|炎马烈铠,20002|天马霓裳", "20001|马年时装！总有一天，我的如意郎君会身披炎马烈铠，踩着七彩祥云来迎接我！,20002|马年时装！你就像那黑夜中的天马座，那么耀眼，那么靓丽，那么令人难以自拔！", "20001|small_nanzhu_shizhuang_1.png,20002|small_nvzhu_shizhuang_1.png", "20001|big_nanzhu_shizhuang_1.png,20002|big_nvzhu_shizhuang_1.png", 14, 5, 0, 1, 1000, 1, 1, "20001|zhan_jiang_nanzhu_shizhuang1.png,20002|zhan_jiang_nvzhu_shizhuang1.png", "20001|head_nanzhu_shizhuang1.png,20002|head_nvzhu_shizhuang1.png", "20001|quan_jiang_nanzhu_shizhuang1.png,20002|quan_jiang_nvzhu_shizhuang1.png", "20001|nuqi_nanzhu_shizhuang1.png,20002|nuqi_nvzhu_shizhuang1.png", "1|1000,4|100,5|100,9|100,6|100,7|100,8|100", 10, },
	id_80002 = {80002, "20001|皇帝新装,20002|女王新装", "20001|皇帝的新装！你嘲笑我没穿衣服，我说你们不懂时尚，我的地盘我做主！,20002|女王大人的新装！你嘲笑我放荡不羁，我说你不懂我的心，只管叫我女王大人！", "20001|small_nanzhu_shizhuang_2.png,20002|small_nvzhu_shizhuang_2.png", "20001|big_nanzhu_shizhuang_2.png,20002|big_nvzhu_shizhuang_2.png", 14, 5, 0, 1, 1000, 1, 1, "20001|zhan_jiang_nanzhu.png,20002|zhan_jiang_nvzhu.png", "20001|head_nanzhu.png,20002|head_nvzhu.png", "20001|quan_jiang_nanzhu.png,20002|quan_jiang_nvzhu.png", "20001|nuqi_nanzhu.png,20002|nuqi_nvzhu.png", "1|1000,4|100,5|100,9|100,6|100,7|100,8|100", 9, },
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
	local id_data = Item_dress["id_" .. key_id]
	assert(id_data, "Item_dress not found " ..  key_id)
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
	for k, v in pairs(Item_dress) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_dress"] = nil
	package.loaded["DB_Item_dress"] = nil
	package.loaded["db/DB_Item_dress"] = nil
end

