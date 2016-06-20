-- FileName: SBListModel.lua
-- Author: liweidong
-- Date: 2015-09-15
-- Purpose: 专属宝物背包list model
--[[TODO List]]

module("SBListModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _itemListSortData = nil
local _fragListSortData = nil
local gi18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["SBListModel"] = nil
end

function moduleName()
    return "SBListModel"
end

function create(...)

end
--根据tid计算对应碎片有数量（多个格子的数量相加），并返回合成一个宝物需要多少碎片
function getFragNumAndMaxByTid(tid)
	tid= tonumber(tid)
	local num = 0
	local item = ItemUtil.getItemById(tid)
	local max = item.need_part_num
	local tbAllBagInfo = DataCache.getBagInfo() 
	for key,val in pairs(tbAllBagInfo.exclFrag) do
		if (tid==tonumber(val.itemDesc.id)) then
			num = num+val.item_num
		end
	end
	return num,max
end
--获取当前可合成的宝物数
function getFragCompoundNum()
	local num =0 
	local tbAllBagInfo = DataCache.getBagInfo() 
	for key,val in pairs(tbAllBagInfo.exclFrag) do
		local itemNum = tonumber(val.item_num)
		local itemMax = tonumber(val.itemDesc.need_part_num)
		if (itemNum>=itemMax ) then
			num = num+1
		end
	end
	return num
end
--获取宝物个数
function getItemNum()
	local tbAllBagInfo = ItemUtil.getSpecialOnBag() --DataCache.getRemoteBagInfo() 

	return table.count(tbAllBagInfo)--.excl)
end
--返回宝物最大个数
function getItemMaxNum()
	local tbAllBagInfo = DataCache.getRemoteBagInfo() or {}
   	return tbAllBagInfo.gridMaxNum.excl
end
--获取宝物碎片个数
function getFragmentNum()
	local tbAllBagInfo = DataCache.getRemoteBagInfo() 
	return table.count(tbAllBagInfo.exclFrag)
end
--返回碎片最大个数
function getFragMaxNum()
	local tbAllBagInfo = DataCache.getRemoteBagInfo() or {}
   	return tbAllBagInfo.gridMaxNum.exclFrag
end
--生成排序后的宝物背包数据 
function getItemListData(fresh)
	if (not fresh) then
		return _itemListSortData
	end
	local fnSortItem = function(a,b)
		if (a.itemDesc.quality~=b.itemDesc.quality) then
			return a.itemDesc.quality>b.itemDesc.quality
		elseif (tonumber(a.va_item_text.exclusiveEvolve)~=tonumber(b.va_item_text.exclusiveEvolve)) then
			return tonumber(a.va_item_text.exclusiveEvolve)>tonumber(b.va_item_text.exclusiveEvolve)
		elseif (a.itemDesc.base_score~=b.itemDesc.base_score) then
			return a.itemDesc.base_score>b.itemDesc.base_score
		elseif (a.itemDesc.id~=b.itemDesc.id) then
			return a.itemDesc.id<b.itemDesc.id
		end
	end
	-- TimeUtil.timeStart("getSpecialOnFormation")
	local formationBagCache = ItemUtil.getSpecialOnFormation()
	-- logger:debug({formationBagCache=formationBagCache})
	-- TimeUtil.timeEnd("getSpecialOnFormation")

	-- logger:debug({getItemListData_formationBagCache = formationBagCache})
	local formationBag = {}
	for key,val in pairs(formationBagCache) do
		local item = {}
		local mt = {}
		mt.__index = val
		setmetatable(item, mt)
		local heroInfo = DB_Heroes.getDataById(HeroModel.getHtidByHid(item.equip_hid))
		item.equip_hid = item.equip_hid
		item.parter = string.format(gi18n[1681],heroInfo.name)
		table.insert(formationBag,item)
	end
	table.sort(formationBag,fnSortItem)
	-- logger:debug({getItemListData_formationBag = formationBag})
	-- TimeUtil.timeStart("getSpecialOnBag")
	local tbAllBagInfo = ItemUtil.getSpecialOnBag()--DataCache.getBagInfo() -- yucong 获取背包与已下阵伙伴身上的
	-- TimeUtil.timeEnd("getSpecialOnBag")
	-- logger:debug({tbAllBagInfo=tbAllBagInfo})
	
	local bagData = {}
	for key,val in ipairs(tbAllBagInfo) do
		local item = {}
		local mt = {}
		mt.__index = val
		setmetatable(item, mt)
		--logger:debug(item.itemDesc)
		item.parter = ""
		table.insert(bagData,item)
	end
	table.sort(bagData,fnSortItem)
	--目前没有加上阵容上的宝物
	_itemListSortData = formationBag
	for i,v in ipairs(bagData) do
		_itemListSortData[#_itemListSortData+1]=v
	end
	return _itemListSortData
-- 1.	根据是否装备，装备在伙伴身上的排在前面。
-- 2.	根据品质，品质高的排在前面：红、橙、紫、蓝、绿、白
-- 3.	根据进阶等级，进阶等级高的排在前面。
-- 4.	根据品级，品级高的排在前面。
-- 5.	根据ID，id大的排在前面。

end

--
function getChargAfterListData( ... )
	local fnSortItem = function(a,b)
		if (a.itemDesc.quality~=b.itemDesc.quality) then
			return a.itemDesc.quality>b.itemDesc.quality
		elseif (tonumber(a.va_item_text.exclusiveEvolve)~=tonumber(b.va_item_text.exclusiveEvolve)) then
			return tonumber(a.va_item_text.exclusiveEvolve)>tonumber(b.va_item_text.exclusiveEvolve)
		elseif (a.itemDesc.base_score~=b.itemDesc.base_score) then
			return a.itemDesc.base_score>b.itemDesc.base_score
		elseif (a.itemDesc.id~=b.itemDesc.id) then
			return a.itemDesc.id<b.itemDesc.id
		end
	end

	local formationBagCache = ItemUtil.getSpecialOnFormation()
	-- logger:debug({formationBagCache=formationBagCache})

	local formationBag = {}
	for key,val in pairs(formationBagCache) do
		local item = {}
		item = val
		table.insert(formationBag,item)
	end
	table.sort(formationBag,fnSortItem)
	-- logger:debug({formationBag=formationBag})

	-- logger:debug({getItemListData_formationBag = formationBag})
	
	local tbAllBagInfo = ItemUtil.getSpecialOnBag()--DataCache.getBagInfo() -- yucong 获取背包与已下阵伙伴身上的
	-- logger:debug({tbAllBagInfo=tbAllBagInfo})
	local bagData = {}
	for key,val in ipairs(tbAllBagInfo) do
		table.insert(bagData,val)
	end
	table.sort(bagData,fnSortItem)
		--目前没有加上阵容上的宝物
	local itemListSortData = {}
	itemListSortData = formationBag
	for i,v in ipairs(bagData) do
		itemListSortData[#itemListSortData+1]=v
	end

	return itemListSortData


end

--根据格子id生成item cell数据
function getItemCellData(id)
	local tbAllBagInfo = _itemListSortData
	local item = _itemListSortData[id]
	require "script/module/specialTreasure/SpecTreaModel"
	item.property = SpecTreaModel.fnGetTreaProperty(tonumber(item.itemDesc.id),tonumber(item.va_item_text.exclusiveEvolve))
	return item
end
--生成排序后的宝物碎片背包数据
function getFragListData(fresh)
	if (not fresh) then
		return _fragListSortData
	end
	local tbAllBagInfo = DataCache.getBagInfo() 
	_fragListSortData = {}
	for key,val in pairs(tbAllBagInfo.exclFrag) do
		local item = {}
		local mt = {}
		mt.__index = val
		setmetatable(item, mt)
		table.insert(_fragListSortData,item)
	end
	table.sort(_fragListSortData,function(a,b)

			local a_itemNum = tonumber(a.item_num)
			local a_itemMax = tonumber(a.itemDesc.need_part_num)
			local b_itemNum = tonumber(b.item_num)
			local b_itemMax = tonumber(b.itemDesc.need_part_num)
			if (a_itemNum>=a_itemMax and b_itemNum<b_itemMax) then
				return true
			elseif (a_itemNum<a_itemMax and b_itemNum>=b_itemMax) then
				return false
			else
				if (a.itemDesc.quality~=b.itemDesc.quality) then
					return a.itemDesc.quality>b.itemDesc.quality
				elseif (a.itemDesc.id~=b.itemDesc.id) then
					return a.itemDesc.id<b.itemDesc.id
				end
			end
		end)
	return _fragListSortData
-- 1.	根据是否可合成，可合成的排在前面。
-- 2.	根据品质，品质高的排在前面：红、橙、紫、蓝、绿、白
-- 3.	根据ID，id大的排在前面。

end
--根据格子id生成grag cell数据
function getFragCellData(id)
	local tbAllBagInfo = _fragListSortData
	local item = tbAllBagInfo[id]
	return item
end

