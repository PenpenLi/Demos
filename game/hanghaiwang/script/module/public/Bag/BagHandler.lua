-- FileName: BagHandler.lua
-- Author: zhangqi
-- Date: 2015-09-26
-- Purpose: 背包处理的基类，定义各种类型背包需要的公共处理方法
--[[TODO List]] 

-- 全局变量，保存后端背包类型名称
BAG_TYPE_STR = {
	arm = "arm",
	armFrag = "armFrag",
	excl = "excl",
	exclFrag = "exclFrag",
	heroFrag = "heroFrag",
	treas = "treas",
	treasFrag = 12, --"treasFrag", -- 宝物碎片，目前不属于背包物品，从夺宝系统中获取
	conch = "conch",
	props = "props",
	awake = "awake",
}

-- zhangqi, 2015-11-19, PreRequest中用到统一处理背包信息变化的通知标志
BAG_CHANGE = {
	treas = GlobalNotify.TREAS_CHANGED,
	treasFrag = GlobalNotify.TREAS_FRAG_CHANGED,
}

BagHandler = class("BagHandler")

-- tbArgs = {baseBag = nil, type = {"treas"["arm", "conch", ....]}
function BagHandler:ctor( tbArgs )
	tbArgs = tbArgs or {}

	self._refBagInfo = nil -- tbArgs.baseBag or DataCache.getRemoteBagInfo() -- 后端返回背包信息的引用

	self._tbList = nil -- 每种背包的列表数据，实际存储的是后端背包数据的引用，以便只操作一套数据节省缓存

	self._refTreasFrag = nil -- TreasureData.seizerInfoData -- 夺宝系统宝物碎片信息的引用

	-- 需要从阵容获取的物品的列表，也是数据的引用；
	-- 为了简化处理，每次背包变化都重新获取：先从背包列表数据删除已有的阵容上物品，然后再把新获取的加入到背包列表数据
	-- self._tbFormation = nil

	self._ownNum = 0 -- 背包里物品的数量（不包含阵容上物品）
	self._bUpdate = true -- 背包信息是否需要刷新

	self._objBag = nil -- 保存背包的对象引用，便于刷新UI
	self._nTabIdx = 0 -- 记录背包标签的索引，便于获取对应的TableView
end

function BagHandler:setBagObject( objBag )
	self._objBag = objBag
end

-- must 每个背包子类必须实现，用以初始化背包类型等不同的属性
function BagHandler:init( ... )
	logger:debug("BagHandler:init")
	-- TODO self._bagType = nil
end

-- 初始化一个背包列表数据
function BagHandler:initList( ... )
	self:createListData()

	self:addFormationItem()

	for i, item in ipairs(self._tbList or {}) do
		self:initOne(item)
	end

	self:sortList()

	self._bUpdate = false
end

function BagHandler:updateBagInfo( ... )
	self._bUpdate = true
	-- logger:debug({updateBagInfo_refBaginfo = self._refBagInfo})
end

-- optional 创建引用后端背包数据的背包列表数据，默认根据背包类型创建，非真正背包系统的物品需要重载（例如伙伴，宝物碎片）
function BagHandler:createListData( ... )
	self._refBagInfo = DataCache.getRemoteBagInfo() -- 后端返回背包信息的引用
	-- logger:debug({createListData_self__refBagInfo = self._refBagInfo[self._bagType]})

	self._tbList = {}

	for gid, item in pairs(self._refBagInfo[self._bagType]) do
		item.gid = gid
		self._tbList[#self._tbList + 1] = item
	end

	self._ownNum = #self._tbList
	self._tbList.ownNum = self._ownNum -- Bag.lua 中更新携带数会用到

	-- logger:debug({BagHandler_createListData_tbList = self._tbList})
end

-- 将阵容上物品加入背包列表备选：获取阵容上物品的背包子类需要实现，比如装备，饰品，专属宝物，空岛贝
function BagHandler:addFormationItem( ... )
	self._tbFormation = self:getFormationItem() or {} -- 先获取阵容上的物品，不需要则为空表

	for i, item in ipairs(self._tbFormation) do
		self._tbList[#self._tbList + 1] = item -- 将已装备的数据加入背包列表
	end
end

-- optional 获取阵容上物品的背包子类需要实现，比如装备，饰品，专属宝物，空岛贝
function BagHandler:getFormationItem( ... )

end

-- must 初始化背包列表的一条数据，每种背包子类必须实现
function BagHandler:initOne( tbItemRef )
	logger:debug("BagHandler:initOne")
end


-- 统一排序方法
function BagHandler:sortList( ... )
	table.sort(self._tbList, function (item1, item2)
								return self:listSorter(item1, item2) 
							end) -- 排序

	self:updateIndex() -- 刷新用于下拉按钮处理的列表数据的 idx 字段
end

-- must 背包列表排序方法，每种背包子类需要实现
function BagHandler:listSorter( item1, item2 )
	logger:debug("BagHandler:listSorter")
end

-- optional 刷新用于下拉按钮处理的列表数据的 idx 字段，带下拉按钮面板的背包子类才需要实现
function BagHandler:updateIndex( ... )

end

-- must 每种背包子类必须实现
-- 1.在列表滑动回调中调用，填补初始化后剩余的其他字段 2.如果物品属性变化，需要重新给所有字段赋值
function BagHandler:fillOne( tbItemRef )
	logger:debug("BagHandler:fillOne")
end

-- 返回初始化过的背包列表数据, 列表没创建才创建
-- 数据的更新会在背包推送回调中处理，这里如果有更新标记只重新排序
function BagHandler:getListData( ... )
	--if (not self._tbList) then
		--self:initList()
	--elseif (self._bUpdate) then
	if (self._bUpdate) then -- 2015-11-25, 改回每次变化都重建背包数据，避免其他模块没有完全依赖背包推送导致的背包信息混乱
		self:initList()
	end
	return self._tbList
end

-- optional 返回出售列表数据，包括初始化和并排序，某些需要出售列表的背包需要实现
function BagHandler:getSaleListData( ... )

end

-- optional 背包出售列表排序方法，某些需要出售列表的背包需要实现
function BagHandler:saleListSorter( item1, item2 )

end

-- must 返回某种背包的当前最大可携带数, 每种背包子类必须实现
function BagHandler:getMaxNum( ... )
	logger:debug("BagHandler:getMaxNum")
end

-- 返回某种背包的当前拥有数量（不包括阵容上伙伴已装备的）
function BagHandler:getOwnNum( ... )
	return self._ownNum
end

-- 将指定格子id和物品信息添加到背包列表中
function BagHandler:addItemByGid( gid, itemInfo )
	logger:debug({BagHandler_addItemByGid_gid = gid, itemInfo = itemInfo})
	itemInfo.gid = gid
	self._tbList[#self._tbList + 1] = itemInfo

	self:initOne(itemInfo)

	self._ownNum = #self._tbList
	self._tbList.ownNum = self._ownNum -- Bag.lua 中更新携带数会用到
end

function BagHandler:removeItemByGid ( gid )
	logger:debug({BagHandler_removeItemByGid_gid = gid})
	local idx = 0
	for i, item in ipairs(self._tbList) do
		if (tonumber(item.gid) == tonumber(gid)) then
			idx = i
			break
		end
	end
	if (idx > 0) then
		table.remove(self._tbList, idx)
	end
	logger:debug({removeItemByGid_gid = gid, idx = idx})
end

function BagHandler:replaceItemByGid( gid, itemInfo )
	logger:debug({BagHandler_replaceItemByGid_gid = gid, itemInfo = itemInfo})
	for i, item in ipairs(self._tbList) do
		if (tonumber(item.gid) == tonumber(gid)) then
			self._tbList[i] = itemInfo
			logger:debug("BagHandler:replaceItemByGid: gid = " .. gid)
			self:initOne(itemInfo)
			break
		end
	end
end
