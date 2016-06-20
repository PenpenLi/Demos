-- Filename: DB_ShareReward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_ShareReward", package.seeall)

keys = {
	"id", "des", "img", "quality", "isDaily", "achieveId", "reward", "sort", 
}

ShareReward = {
	id_1 = {1, "分享冒险经历到微信", "beili_da.png", 5, 1, nil, "1|0|5000", 1, },
	id_5 = {5, "获得梅丽号", "jinbi_da.png", 5, 0, 202009, "3|0|50", 2, },
	id_7 = {7, "获得橙色伙伴", "jinbi_da.png", 5, 0, 301002, "3|0|200", 3, },
	id_6 = {6, "达到竞技场排名500名以上", "jinbi_da.png", 5, 0, 106003, "3|0|50", 4, },
	id_8 = {8, "获得紫色品质宝物", "jinbi_da.png", 5, 0, 402001, "3|0|100", 5, },
	id_2 = {2, "达到30级", "jinbi_da.png", 5, 0, 201005, "3|0|100", 6, },
	id_3 = {3, "达到40级", "jinbi_da.png", 5, 0, 201009, "3|0|150", 7, },
	id_4 = {4, "达到50级", "jinbi_da.png", 5, 0, 201013, "3|0|200", 8, },
	id_9 = {9, "在激战海王类中击杀近海之王", "jinbi_da.png", 5, 0, 214001, "3|0|100", 9, },
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
	local id_data = ShareReward["id_" .. key_id]
	assert(id_data, "ShareReward not found " ..  key_id)
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
	for k, v in pairs(ShareReward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_ShareReward"] = nil
	package.loaded["DB_ShareReward"] = nil
	package.loaded["db/DB_ShareReward"] = nil
end

