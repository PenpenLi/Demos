-- FileName: AwakeItemInfoModel.lua
-- Author: LvNanchun
-- Date: 2015-11-18
-- Purpose: function description of module
--[[TODO List]]

module("AwakeItemInfoModel", package.seeall)

-- UI variable --

-- module local variable --
local _gColor = g_QulityColor

local function init(...)

end

function destroy(...)
    package.loaded["AwakeItemInfoModel"] = nil
end

function moduleName()
    return "AwakeItemInfoModel"
end

--[[desc:分解字符串
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function dealStr( str )
	local tbStr = string.split(str, ",")
	local tbNum = {}
	for k,v in pairs(tbStr) do 
		tbNum[k] = string.split(v, "|")
		for i,j in pairs(tbNum[k]) do 
			tbNum[k][i] = tonumber(j)
		end
	end

	return tbNum
end

--[[desc:将字符串处理成属性的table
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function dealAttr( str )
	local tbAttr = dealStr(str)

	for k,v in pairs(tbAttr) do
		tbAttr[k].desc = DB_Affix.getDataById(v[1]).displayName
	end

	return tbAttr
end

--[[desc:根据物品id获取配置界面所需信息
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getInfoById( itemId )
	local itemInfo = ItemUtil.getItemById(itemId)
	local tbInfo = {}
	tbInfo.itemId = itemInfo.id
	tbInfo.name = itemInfo.name
	tbInfo.attr = dealAttr(itemInfo.base_attr)
	tbInfo.nowNum = ItemUtil.getAwakeNumByTid(itemId)
	tbInfo.color = _gColor[tonumber(itemInfo.quality)]

	return tbInfo
end

