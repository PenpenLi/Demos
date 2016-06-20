-- FileName: AwakeCPData.lua
-- Author: 
-- Date: 2015-11-25
-- Purpose: 觉醒物品合成
--[[TODO List]]

module("AwakeCPData", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _composeData = {}
local _tbComposeLine = {} -- 当前打开的合成路线，是一个一维table，{1=item1, 2=item2...}表示打开了item1被item2合成的路径，要将最后一个item的一阶合成表显示到UI上


local function init(...)
	_composeData = {}
	_tbComposeLine = {} 
end

-- 添加到合成路线
local function addToComposeLine( itemId )
	table.insert(_tbComposeLine, itemId)
end

-- 设置合成表	如果是合成，要先调用
function setComposeData( itemId, itemNum )
	init()

	_composeData = MainAwakeModel.getComposTableByItemId(itemId, itemNum)
	addToComposeLine(itemId)
	--------------------
	--addToComposeLine(831002)
	--addToComposeLine(832001)
	--------------------
end

function setNextCompose( pos )
	local nowComposeInfo = getNowComposeInfo()
	addToComposeLine(nowComposeInfo.childItems[pos].itemId)
end

function setUpLayer( layer )
	local newTable = {}
	local oldTable = getComposeLine()
	for k,v in ipairs(oldTable) do
		if (k<=layer) then
			table.insert(newTable, v)
		else
			break
		end
	end
	_tbComposeLine = newTable
end

------------------------------------------------

-- 得到当前的合成路线
function getComposeLine( ... )
	return _tbComposeLine
end

-- 得到当前的合成信息，如果它能被合成，那么他的childItems就是下面三个要被显示的子物品，否则，下方显示的是去获取
function getNowComposeInfo( )
	local nowComposeInfo = _composeData
	for i = 2, #_tbComposeLine do
		local tempComposeInfo = {}
		for k,v in ipairs( nowComposeInfo.childItems ) do
			if (v.itemId == _tbComposeLine[i]) then
				tempComposeInfo = v 
				break
			end
		end
		nowComposeInfo = tempComposeInfo
	end
	if (nowComposeInfo.canCompose == 1) then
		for k,v in ipairs(nowComposeInfo.childItems) do
			if (v.itemNeedNum > ItemUtil.getAwakeNumByTid(v.itemId)) then
				nowComposeInfo.enough = false
				break
			end
			nowComposeInfo.enough = true
		end
	end
	return nowComposeInfo
end

-- 得到当前的子物品的表，用于回传后端的参数
function getNowChildItems( nowInfo )
	local childItems = {}
	for k,v in ipairs(nowInfo.childItems) do
		local itemTids = MainAwakeModel.getItemIdByTidAndNum( v.itemId, v.itemNeedNum )
		for k1,v1 in pairs(itemTids) do
			childItems[k1] = v1
		end
	end
	return childItems
end

-----------------------------------------------------


function destroy(...)
	package.loaded["AwakeCPData"] = nil
	_composeData = {}
	_tbComposeLine = {} 
end

function moduleName()
    return "AwakeCPData"
end

function create(...)

end


