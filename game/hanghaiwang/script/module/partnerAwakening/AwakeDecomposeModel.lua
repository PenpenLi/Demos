-- FileName: AwakeDecomposeModel.lua
-- Author: LvNanchun
-- Date: 2015-11-19
-- Purpose: 觉醒物品分解界面提示框数据
--[[TODO List]]

module("AwakeDecomposeModel", package.seeall)

-- UI variable --

-- module local variable --
local _tbInfo
local _dbInfo
local _gColor = g_QulityColor
local _buyNum = 0
local _maxNum = 0

local function init(...)

end

function destroy(...)
    package.loaded["AwakeDecomposeModel"] = nil
end

function moduleName()
    return "AwakeDecomposeModel"
end

function create(...)

end

--[[desc:处理CTRL传入的初始数据
    arg1: 初始数据的table
    return: 无  
—]]
function dealInfo( tbItem )
	_tbInfo = {}

	_tbInfo.name = tbItem.name
	_tbInfo.num = tonumber(tbItem.item_num)
	_tbInfo.color = _gColor[tonumber(tbItem.nQuality)]
	_tbInfo.gid = tonumber(tbItem.gid)
	_tbInfo.tid = tonumber(tbItem.item_template_id)

	_dbInfo = tbItem.dbConf
end

--[[desc:获取构建界面需要的信息
    arg1: 无
    return: 构建界面的信息table  
—]]
function getViewInfo( )
	return _tbInfo
end

--[[desc:根据物品数量和model中持久化的配置信息获取能有多少觉醒结晶
    arg1: 物品数量
    return: 觉醒结晶数量  
—]]
function getCoinNumByItemNum( num )
	return tonumber(_dbInfo.resolve_num) * num
end

function setBuyNumAndMaxNum( buyNum, maxNum )
	_buyNum = buyNum
	_maxNum = maxNum
end

function getDeleteNum(  )
	return (_maxNum == _buyNum) and 1 or 0
end

