-- Filename: DB_SharePlatform.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_SharePlatform", package.seeall)

keys = {
	"id", "platformId", "name", "weixinId", "platformWord", "url", "platformTitle", "platformIcon", "platformImage", "shareContent", 
}

SharePlatform = {
	id_1 = {1, "360azphone", "360", nil, "当年爱玩的游戏的素材，童年的回忆啊~", "http://www.baidu.com", "我就是辣么帅气的汉子！", "lufei.png", "lufei.jpg", 1, },
	id_2 = {2, "baiduphone", "百度安卓", nil, "史诗！", "http://www.baidu.com", "我就是辣么帅气的汉子！", "lufei.png", "lufei.jpg", 2, },
	id_3 = {3, "xmphone", "小米", nil, "当年爱玩的游戏的素材，童年的回忆啊~", "http://www.baidu.com", "我就是辣么帅气的汉子！", "lufei.png", "lufei.jpg", 1, },
	id_4 = {4, "hwphone", "华为", nil, "史诗！", "http://www.baidu.com", "我就是辣么帅气的汉子！", "lufei.png", "lufei.jpg", 2, },
	id_5 = {5, "appstore", "苹果商店", "wx6eac2a6c2a6de08d", "当年爱玩的游戏的素材，童年的回忆啊~", "http://www.baidu.com", "我就是辣么帅气的汉子！", "lufei.png", "lufei.jpg", 1, },
	id_6 = {6, "appstore", "苹果开发包", "wx6eac2a6c2a6de08d", "当年爱玩的游戏的素材，童年的回忆啊~", "http://www.baidu.com", "我就是辣么帅气的汉子！", "lufei.png", "lufei.jpg", 1, },
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
	local id_data = SharePlatform["id_" .. key_id]
	assert(id_data, "SharePlatform not found " ..  key_id)
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
	for k, v in pairs(SharePlatform) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_SharePlatform"] = nil
	package.loaded["DB_SharePlatform"] = nil
	package.loaded["db/DB_SharePlatform"] = nil
end

