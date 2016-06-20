-- FileName: ShipMainModel.lua
-- Author: LvNanchun
-- Date: 2015-10-16
-- Purpose: 主船主界面逻辑
--[[TODO List]]

module("ShipMainModel", package.seeall)
require "script/module/ship/ShipData"
require "db/DB_Affix"

-- UI variable --

-- module local variable --
local _activateShipId
local _attrSub = {}

local function init(...)

end

function destroy(...)
    package.loaded["ShipMainModel"] = nil
end

function moduleName()
    return "ShipMainModel"
end

function create(...)

end

--[[desc:功能简介
    arg1: 参数说明
    return: 
—]]
function getListViewInfo(  )
	local tbListInfo = ShipData.getAllShipInfo()
	local tbShipState = {}
	local tbShipStateSort = {}
	local nowShipId = tbListInfo.nowShipId

	for i = 1, tbListInfo.nShipNum do
		tbShipState[i] = ShipData.getShipInfoById(i)
		tbShipState[i].state = 3
	end

	for k,v in pairs(tbListInfo.strengthShipInfo) do 
		logger:debug("MainShipModel")
		logger:debug(k)
		logger:debug(nowShipId)
		if (tonumber(k) == tonumber(nowShipId)) then
			tbShipState[tonumber(k)].state = 1
		else
			tbShipState[tonumber(k)].state = 2
		end
		tbShipState[tonumber(k)].strengthLevel = tonumber(v.strengthen_level)
	end

	-- 循环赋值确定listView的顺序
	local i = 1
	for k,v in pairs(tbShipState) do
		if (v.state == 1) then
			tbShipStateSort[i] = {}
			tbShipStateSort[i].id = v.id
			tbShipStateSort[i].name = v.name
			tbShipStateSort[i].quality = v.quality
			tbShipStateSort[i].state = v.state
			tbShipStateSort[i].home_graph = v.home_graph
			i = i + 1
			break
		end 
	end
	for k,v in pairs(tbShipState) do
		if (v.state == 2) then
			tbShipStateSort[i] = {}
			tbShipStateSort[i].id = v.id
			tbShipStateSort[i].name = v.name
			tbShipStateSort[i].quality = v.quality
			tbShipStateSort[i].state = v.state
			tbShipStateSort[i].home_graph = v.home_graph
			i = i + 1
		end
	end
	for k,v in pairs(tbShipState) do
		if (v.state == 3) then
			tbShipStateSort[i] = {}
			tbShipStateSort[i].id = v.id
			tbShipStateSort[i].name = v.name
			tbShipStateSort[i].quality = v.quality
			tbShipStateSort[i].state = v.state
			tbShipStateSort[i].home_graph = v.home_graph
			i = i + 1
		end
	end
	tbShipStateSort.shipNum = i - 1

	return tbShipStateSort
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function splitAttrStr( attrStr )
	assert(attrStr, "配置属性加成字符串为空")

	local tbAttr = {}

	local tbStr = string.split(attrStr, ",")
	for k,v in pairs(tbStr) do 
		local tbData = string.split(v, "|")

		tbAttr[tonumber(tbData[1])] = tonumber(tbData[2])
	end

	return tbAttr
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getPreSubAttr(  )
	return _attrSub
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getAttrInfo( shipId )
	local tbAttrInfo = {}
	local tbListInfo = ShipData.getAllShipInfo()
	local tbShipInfo = ShipData.getShipInfoById(shipId)

	tbAttrInfo.name = tbShipInfo.name
	tbAttrInfo.quality = tbShipInfo.quality
	tbAttrInfo.shipId = tbShipInfo.id
	local mainShipAttr = {}
	if (tbListInfo.nowShipId and tbListInfo.nowShipId > 0) then
		local mainStrengthLevel = tonumber(tbListInfo.strengthShipInfo[tonumber(tbListInfo.nowShipId)].strengthen_level)
		mainShipAttr = ShipData.getShipAttrByShipIdAndStrLevel(tbListInfo.nowShipId, mainStrengthLevel)
	else
		mainShipAttr = ShipData.getShipAttrByShipIdAndStrLevel()
	end

	tbAttrInfo.attr = mainShipAttr
	
	if (shipId == tonumber(tbListInfo.nowShipId)) then
		tbAttrInfo.isMainShip = true
	else
		tbAttrInfo.isMainShip = false
		local strengthLevel = tonumber(tbListInfo.strengthShipInfo[shipId].strengthen_level)
		tbAttrInfo.sub = {}

		local nowShipAttr = ShipData.getShipAttrByShipIdAndStrLevel(shipId, strengthLevel)

		tbAttrInfo.subStr = {}
		tbAttrInfo.subColor = {}

		for i = 1,5 do
			tbAttrInfo.sub[i] = (nowShipAttr[i] or 0) - (mainShipAttr[i] or 0)
			if (tbAttrInfo.sub[i] > 0) then
				tbAttrInfo.subStr[i] = "+" .. tostring(tbAttrInfo.sub[i])
				tbAttrInfo.subColor[i] = ccc3(0x00, 0x8a, 0x00)
			elseif (tbAttrInfo.sub[i] == 0) then
				tbAttrInfo.subStr[i] = nil
			else
				tbAttrInfo.subStr[i] = tostring(tbAttrInfo.sub[i])
				tbAttrInfo.subColor[i] = ccc3(0xd8, 0x14, 0x00)
			end
		end
--		_attrSub.sub = tbAttrInfo.sub
--		_attrSub.subColor = tbAttrInfo.subColor
		_attrSub.preAttr = tbAttrInfo.attr
		_attrSub.nextAttr = nowShipAttr
	end

	tbAttrInfo.attrName = {}
	for i = 1,5 do
		tbAttrInfo.attrName[i] = ShipData.getAffixInfoById(i).displayName .. "："
	end

	tbAttrInfo.strengthLevel = tonumber(tbListInfo.strengthShipInfo[shipId].strengthen_level)

	logger:debug({tbAttrInfo = tbAttrInfo})

	return tbAttrInfo
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getNameImageById( shipId )
	return "images/ship/ship_name/ship" .. tostring(shipId) .. "_name.png"
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getActivateInfoById( shipId )
	local shipInfo = ShipData.getShipInfoById(shipId)
	local activateStr = shipInfo.activate_item
	local shipItemInfo = {}
	-- 若激活配置为空需要实现免费激活的功能
	if (activateStr) then
		local tbActivate = string.split(activateStr, "|")
		-- 构建激活面板用的信息
		shipItemInfo = ShipData.getShipItemInfoById(tonumber(tbActivate[1]))
		shipItemInfo.needNum = tonumber(tbActivate[2])
		require "script/module/public/ItemUtil"
		shipItemInfo.tid = tonumber(tbActivate[1])
--		shipItemInfo.btn = ItemUtil.createBtnByTemplateIdAndNumber(tonumber(tbActivate[1]))
		shipItemInfo.btn = ItemUtil.createBtnByTemplateId(tonumber(tbActivate[1]))
		shipItemInfo.haveNum = tonumber(ItemUtil.getNumInBagByTid(tonumber(tbActivate[1])))
		-- 不免费
		shipItemInfo.isFree = false
		shipItemInfo.shipId = shipInfo.id
	else
		-- 若激活道具不存在，haveNum为1，needNum为0，确保激活成功
		-- 免费
		shipItemInfo.isFree = true
		shipItemInfo.needNum = 0
		shipItemInfo.haveNum = 1
	end
	if (shipItemInfo.needNum <= shipItemInfo.haveNum) then
		shipItemInfo.isEnough = true
	else
		shipItemInfo.isEnough = false
	end

	return shipItemInfo
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getActivateSuccessInfo( shipId )
	local successInfo = {}
	-- 构建激活成功界面用的信息
	local tbListInfo = ShipData.getAllShipInfo()
	local preInfo = getAttrInfo(tbListInfo.nowShipId)
	-- 此处完成修改ShipData中数据的过程
	ShipData.activateShipById(shipId)
	local nowInfo = getAttrInfo(tbListInfo.nowShipId)
	successInfo.pre = preInfo.attr
	successInfo.now = nowInfo.attr
	successInfo.color = {}
	for k,v in pairs(preInfo.attr) do
		successInfo.color[k] = (nowInfo.attr[k] > preInfo.attr[k]) and ccc3(0x00, 0x8a, 0x00) or ccc3(0xd8, 0x14, 0x00)
	end
	return successInfo
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getRebornGoldById( shipId )
	local shipInfo = ShipData.getShipInfoById(shipId)
	return tonumber(shipInfo.reborn_gold)
end

--[[desc:返回现在加成的属性，用于计算战斗力
    arg1: 无
    return: 属性的table
—]]
function getNowAttr( ... )
	local tbListInfo = ShipData.getAllShipInfo()
	
	if ((not tbListInfo.nowShipId) or tbListInfo.nowShipId < 1) then
		-- 若没有主船时只计算激活属性
		return ShipData.getShipAttrByShipIdAndStrLevel()
	else
		local mainStrengthLevel = tonumber(tbListInfo.strengthShipInfo[tonumber(tbListInfo.nowShipId)].strengthen_level)
		local mainShipAttr = ShipData.getShipAttrByShipIdAndStrLevel(tbListInfo.nowShipId, mainStrengthLevel)
		logger:debug({mainShipAttr = mainShipAttr})
		return mainShipAttr
	end
end

--[[desc:返回船小图标和品质边框
    arg1: 参数说明
    return: 两个返回，第一个是船图标地址，第二个是品质背景地址，第三个是品质边框地址 
—]]
function getShipIconById( shipId )
	local tbShipInfo = ShipData.getShipInfoById(shipId)
	local iconId = tbShipInfo.ship_graph
	local iconQuality = tbShipInfo.quality
	return "images/ship/ship_icon/ship" .. tostring(iconId) .. ".png", "images/base/potential/color_" .. tostring(iconQuality) .. ".png", "images/base/potential/equip_" .. tostring(iconQuality) .. ".png"
end