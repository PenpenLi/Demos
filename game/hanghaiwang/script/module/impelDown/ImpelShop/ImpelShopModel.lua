-- FileName: ImpelShopModel.lua
-- Author: LvNanchun
-- Date: 2015-09-09
-- Purpose: function description of module
--[[TODO List]]

module("ImpelShopModel", package.seeall)
require "db/DB_Tower_shop"

-- UI variable --

-- module local variable --
local _tbGoodsInfo
local _tbDBGoodsInfo
-- 通过本商店购买的物品的数量
local _tbBoughtNum = {}
-- 现在拥有的物品的数量
local _tbHaveNum = {}
local _tbNeedReset
local _tbTipData = {}
local _tbQualityColor = g_QulityColor
local _nMaxLevel = 0

local function init(...)

end

function destroy(...)
    package.loaded["ImpelShopModel"] = nil
end

function moduleName()
    return "ImpelShopModel"
end

function create(...)

end

function setMaxLevel( nLevel )
	_nMaxLevel = nLevel
end

function getMaxLevel()
	return _nMaxLevel
end

function getTipDataById( cell , infoId )
	if (cell and infoId) then
		return _tbTipData[cell][infoId]
	elseif (cell) then
		return _tbTipData[cell]
	else
		return _tbTipData
	end
end

function setTipDataById( cell , infoId , info )
	logger:debug("ImpelShopModelTipData")
	logger:debug({_tbTipData = _tbTipData})
	logger:debug({_tbTipDatacell = _tbTipData[cell]})

	if not (_tbTipData[cell]) then
		_tbTipData[cell] = {}
	end
	logger:debug({_tbTipDatacellinfoId = _tbTipData[cell][infoId]})
	_tbTipData[cell][infoId] = info
	logger:debug({_tbTipDatacellinfoId = _tbTipData[cell][infoId]})
end

--[[desc:获取某一物品买过的数量
    arg1: 物品id
    return: 物品数量
—]]
local function getBoughtNumById( goodId )
	return _tbBoughtNum[goodId]
end

function refreshAllMaxNum( tbGoodInfo )
	local prisonCoinNum = UserModel.getImpelDownNum()
	for k,v in pairs(tbGoodInfo) do
		if (v.nowNum) then
			v.nowNum = v.baseNum - getBoughtNumById(tonumber(v.id))
			if ((math.floor(prisonCoinNum / (tonumber(v.cost)))) > tonumber(v.nowNum)) then
				_tbTipData[k].maxNum = tonumber(v.nowNum)
				_tbTipData[k].limitType = "num"
			else
				_tbTipData[k].maxNum = math.floor(prisonCoinNum / (tonumber(v.cost)))
				_tbTipData[k].limitType = "gold"
			end
		else
			_tbTipData[k].maxNum = math.floor(prisonCoinNum / (tonumber(v.cost)))
			_tbTipData[k].limitType = "gold"
		end
	end
end

--[[desc:获取配置表信息
    arg1: 无
    return: 无
—]]
function setGoodsInfo()
	_tbGoodsInfo = {}
	_tbGoodsInfo[1] = {}
	_tbGoodsInfo[2] = {}
	_tbGoodsInfo[3] = {}
	_tbDBGoodsInfo = {}

	for i=1,table.count(DB_Tower_shop.Tower_shop) do
		logger:debug("impelShop" .. tostring(i))
		logger:debug({DB_Tower_shop.getDataById(i)})
		table.insert( _tbGoodsInfo[tonumber(DB_Tower_shop.getDataById(i).position)] , DB_Tower_shop.getDataById(i) )
		table.insert(_tbDBGoodsInfo , DB_Tower_shop.getDataById(i))
	end

	logger:debug({_tbGoodsInfo = _tbGoodsInfo})
end

--[[desc:设置购买数量，通过后端数据
    arg1: 后端的购买数量信息
    return: 无  
—]]
function setBoughtNum( tbBoughtNum )
	for i=1,table.count(DB_Tower_shop.Tower_shop) do
		_tbBoughtNum[i] = 0
	end

	for k,v in pairs(tbBoughtNum) do
		for i,j in pairs(v) do
			_tbBoughtNum[tonumber(i)] = tonumber(j)
		end
	end
end

--[[desc:购买某一商品时修改购买过的数量
    arg1: 商品id ， 增加的数量
    return: 无  
—]]
function setBoughtNumById( goodId , num )
	_tbBoughtNum[goodId] = _tbBoughtNum[goodId] + num
end

--[[desc:每天重置需要重置购买数量的数量
    arg1: 无
    return: 无  
—]]
function resetBoughtEveryDay()
	if not ( _tbNeedReset ) then
		_tbNeedReset = {}
		for k,v in pairs(_tbGoodsInfo) do 
			for i,j in pairs(v) do 
				if (tonumber(j.limitType) == 1) then
					table.insert(_tbNeedReset , tonumber(j.id))
				end
			end
		end
	end

	for k,v in pairs(_tbNeedReset) do 
		_tbBoughtNum[v] = 0
	end
end

--[[desc:获取在本商店剩余可买的物品的数量
    arg1: 物品id（配置表中的）
    return: 物品数量  
—]]
function getNowNumById( goodId )
	return _tbDBGoodsInfo[goodId].baseNum - getBoughtNumById(tonumber(goodId))
end

--[[desc:获取某一物品现在拥有的数量
    arg1: 物品索引
    return: 物品数量
—]]
function getOwnNumByIndex( cellIndex )
	return _tbHaveNum[tonumber(cellIndex)]
end

--[[desc:设置某一物品现在拥有的数量
    arg1: 物品的索引， 增加的数量
    return: 无 
—]]
function setOwnNumByIndex( cellIndex , num )
	_tbHaveNum[tonumber(cellIndex)] = _tbHaveNum[tonumber(cellIndex)] + tonumber(num)
end

--[[desc:根据列表索引返回对应的listView显示数据
    arg1: 列表索引1，2，3
    return: 列表数据table
—]]
function getGoodsInfoByIndex( listIndex )
	if not (_tbGoodsInfo) then
		setGoodsInfo()
	end 
	logger:debug({_tbGoodsInfo = _tbGoodsInfo})

	local tbGoodDBInfo = _tbGoodsInfo[listIndex]
	local tbInfo = {}
	logger:debug({tbGoodDBInfo = tbGoodDBInfo})

	for k,v in pairs(tbGoodDBInfo) do  
		local tbGoodInfo = {}
		local bInsert = true
		tbGoodInfo.item = v.items
		tbGoodInfo.cost = v.costPrison
		tbGoodInfo.isForever = false
		tbGoodInfo.baseNum = v.baseNum
		if (tonumber(v.limitType) == 3) then
			tbGoodInfo.nowNum = nil
		elseif (tonumber(v.limitType) == 2) then
			tbGoodInfo.nowNum = v.baseNum - getBoughtNumById( tonumber(v.id) )
			tbGoodInfo.isForever = true
			if (tbGoodInfo.nowNum == 0) then
				bInsert = false
			end
		elseif (tonumber(v.limitType) == 1) then
			tbGoodInfo.nowNum = v.baseNum - getBoughtNumById( tonumber(v.id) )
		end
		tbGoodInfo.id = v.id
		tbGoodInfo.levelLimit = v.levelLimit
		local itemCopy = RewardUtil.parseRewards(v.items)[1]
		local itemId = RewardUtil.getItemsDataByStr(v.items)[1].tid
		local itemInfo = ItemUtil.getItemById(itemId)
		logger:debug({itemInfo = itemInfo})
		tbGoodInfo.color = _tbQualityColor[tonumber(itemInfo.quality)]
		if (itemInfo.isFragment) then
			tbGoodInfo.isFragment = true
			local ownNum = DataCache.getEquipFragNumByItemTmpid(itemId)
--			local ownNum = ItemUtil.getNumInBagByTid(itemId)
			tbGoodInfo.ownNum = ownNum
			_tbHaveNum[k] = ownNum
			tbGoodInfo.maxNum = itemInfo.nMax
		else
			local ownNum = ItemUtil.getNumInBagByTid(itemId)
			tbGoodInfo.ownNum = ownNum
			_tbHaveNum[k] = ownNum
			tbGoodInfo.isFragment = false
		end
		tbGoodInfo.name = itemCopy.name
		tbGoodInfo.icon = itemCopy.icon
		tbGoodInfo.icon:retain()
		tbGoodInfo.itemId = tonumber(itemId)
		tbGoodInfo.isRecommend = (tonumber(v.recommended) == 1)

		logger:debug({tbGoodInfo = tbGoodInfo})
		if (bInsert) then
			table.insert(tbInfo , tbGoodInfo)
		end
	end

	logger:debug({tbInfo = tbInfo})

	return tbInfo
end

--[[desc:根据标签编号获取限制等级
    arg1: 标签编号
    return: 限制等级
—]]
function getTabLimitLevelById( tabId )
	local dbInfo = DB_Tower.getDataById(1)
	assert(dbInfo, "未配置限制等级")
	local strLimit = dbInfo.passOpen
	local tbLimit = string.split(strLimit, ",")
	local tbLimitNum = {0, 0}
	tbLimitNum[1] = tonumber(tbLimit[1])
	tbLimitNum[2] = tonumber(tbLimit[2])
	if (tabId > 1) then
		return tbLimitNum[tonumber(tabId - 1)]
	else
		return 0
	end
end


