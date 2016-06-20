-- FileName: TreasBagHandler.lua
-- Author: zhangqi
-- Date: 2015-09-26
-- Purpose: 宝物背包数据处理类
--[[TODO List]]
local m_i18n = gi18n

require "script/module/public/Bag/BagHandler"

TreasBagHandler = class("TreasBagHandler", BagHandler)

-- must 每个背包子类必须实现，用以初始化背包类型等不同的属性
function TreasBagHandler:init( ... )
	self._bagType = BAG_TYPE_STR.treas
	self._nTabIdx = 1
end

-- optional 获取阵容上物品的背包子类需要实现，比如装备，宝物，专属宝物，空岛贝
function TreasBagHandler:getFormationItem( ... )
	local treas = ItemUtil.getTreasOnFormation() -- 先获取已装备的宝物
	return treas
end


-- must 初始化背包列表的一条数据，每种背包子类必须实现
function TreasBagHandler:initOne( tbItemRef )
	require "db/DB_Item_treasure"
	local dbData = DB_Item_treasure.getDataById(tbItemRef.item_template_id)

	local item = tbItemRef

	-- item.bagType = BAG_TYPE.treas -- 记录数据的背包类型，便于删除和修改
	item.dbConf = dbData -- 物品对应的配置表信息

	item.id = tonumber(dbData.id) -- 排序用

	item.name = dbData.name -- 名称

	item.sOwner = ItemUtil.getOwnerByEquipId(tbItemRef.equip_hid) -- 是否已装备

	local tbScore = ItemUtil.getTreaScoreByData(tbItemRef)
	item.sRank = tbScore.num -- 品级

	item.sStrongNum =  tonumber(tbItemRef.va_item_text.treasureLevel) or 0 -- 强化等级

	item.nQuality = dbData.quality -- 品质

	-- logger:debug({TreasBagHandler_initOne_item = item})
end

-- must 每种背包子类必须实现
-- 1.在列表滑动回调中调用，填补初始化后剩余的其他字段 2.如果物品属性变化，需要重新给所有字段赋值
function TreasBagHandler:fillOne( tbItemRef )
	-- logger:debug({TreasBagHandler_fillOne_tbItemRef = tbItemRef})

	-- if (tbItemRef.icon) then
	-- 	-- logger:debug({fillOneWithData_has_item = tbItemRef})
	-- 	return -- 如果已经填充过直接返回
	-- end
	
	-- ********************************************************* --
	if (not tbItemRef.dbConf) then
		return -- 如果没有配置信息字段则认为是下拉按钮面板，直接返回
	end

	local item = tbItemRef
	
	local dbData, itemData = item.dbConf, item.va_item_text

	local nItemId = tonumber(item.item_id)

	item.bRefineItem = tonumber(dbData.is_refine_item) == 1 -- 是否精炼材料，2015-09-16
	item.info = dbData.info -- 用于宝物精华属性显示，2015-09-16

	item.sign = ItemUtil.getSignTextByItem(dbData)
	item.icon = {id = dbData.id}
	item.icon.onTouch = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playInfoEffect()
			require "script/module/treasure/NewTreaInfoCtrl"
			NewTreaInfoCtrl.createByItemId(nItemId, 3) -- 表示打开的信息面板带去获取按钮
		end
	end

	if (nItemId and nItemId > 0 and itemData.treasureEvolve) then
		item.sRefinNum = itemData.treasureEvolve or 0 -- 精炼等级，icon右下角钻石
	end

	item.onRefining = function ( sender, eventType ) -- 精炼按钮事件
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if (not dbData.costId) then
				ShowNotice.showShellInfo(m_i18n[1747]) -- zhangqi, 2015-12-29, 如果不可精炼
				return
			end
			
			require "script/module/treasure/treaRefineCtrl"
			treaRefineCtrl.create(nItemId, g_treaInfoFrom.layFromBagType)
		end
	end

	item.onStrong = function ( sender, eventType ) -- 强化按钮事件
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if (not SwitchModel.getSwitchOpenState(ksSwitchTreasureForge,true) ) then
				return -- 如果宝物强化未开启，提示后直接返回
			end

			-- 先判断是否经验宝物，如果是经验宝物提示不能强化，避免多调用一次treaForgeCtrl.create
			if (dbData.isExpTreasure == 1 or tonumber(dbData.id) == 501010) then
				ShowNotice.showShellInfo(m_i18n[1512])
				return
			end

			local treaItemId = item.item_id
			require "script/module/treasure/treaForgeCtrl"
			local layout = treaForgeCtrl.create(treaItemId,1)
			LayerManager.changeModule(layout, treaForgeCtrl.moduleName(), {1, 3}, true)
			PlayerPanel.addForPartnerStrength()
		end
	end

	-- 处理经验宝物
	if (tonumber(dbData.isExpTreasure) == 1) then
		local add_exp = tonumber(dbData.base_exp_arr) + tonumber(itemData.treasureExp)
		item.sSupplyExp = tostring(add_exp) -- 提供经验的数值
	else
		-- 获得相关数值
		local attr_arr, score_t, ext_active = ItemUtil.getTreasAttrByItemId(nItemId, item)
		local strDesc = ""
		strDesc = self:createAttrString(attr_arr,ext_active)

		item.tbAttr = {}
		table.insert(item.tbAttr, strDesc)
	end

	-- logger:debug({TreasBagHandler_fillOne_item = item})
end

-- 必须由子类实现: 对 _tbCache 的排序方法
--[[
排序规则：
-- modified by zhangqi, 2014-04-24
1.已装备的宝物 > 未装备宝物。
2.高品质 > 低品质
3.品级高 > 品级低
4.强化等级高 > 强化等级低
5.di大 > id小
]]
function TreasBagHandler:listSorter( item1, item2 )
	-- 是否已经装备
	if (item1.sOwner ~= "" and item2.sOwner == "") then
		return true
	end
	if (item1.sOwner == "" and item2.sOwner ~= "") then
		return false
	end

	-- 品质
	if (item1.nQuality > item2.nQuality) then
		return true
	end
	if (item1.nQuality < item2.nQuality) then
		return false
	end

	-- 品级
	if (item1.sRank > item2.sRank) then
		return true
	end
	if (item1.sRank < item2.sRank) then
		return false
	end

	-- 强化等级 StrongNum
	if (item1.sStrongNum > item2.sStrongNum) then
		return true
	end
	if (item1.sStrongNum < item2.sStrongNum) then
		return false
	end

	-- id
	return item1.id > item2.id
end

-- 子类可以根据需求决定是否实现：有下拉按钮的背包才需要实现
function TreasBagHandler:updateIndex( ... )
	for i, item in ipairs(self._tbList) do
		item.idx = i
	end
end

--拼接属性字符串
function TreasBagHandler:createAttrString( atrrs, baseAttrs )
	local strDesc = ""
	-- 加基本属性显示 add by sunyunpeng 2015.07.07
	for i , ext_active_info in ipairs(baseAttrs) do
		if (ext_active_info.isOpen) then
			local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(ext_active_info.attId, ext_active_info.num)
			strDesc = strDesc .. affixDesc.displayName .. "：+" .. displayNum .. "\n"
		end
	end

	for i , attr_info in ipairs(atrrs) do
		local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(attr_info.attId, attr_info.num)
		strDesc = strDesc .. affixDesc.displayName .. "：+" .. displayNum .. "\n"
	end

	return strDesc
end

-- optional 返回出售列表数据，包括初始化和并排序，某些需要出售列表的背包需要实现
function TreasBagHandler:getSaleListData( ... )
	local tbSales = {}

	local dbData, saleIdx = nil, 0

	local listData = self:getListData()
	for i, item in ipairs(listData) do
		dbData = item.dbConf

		if (item.gid and dbData.sellable == 1 and item.nQuality <= 3) then -- 可卖且三星以下

			-- 补充出售列表需要的字段
			item.nNum = tonumber(item.item_num)
			item.sPrice = tostring(dbData.sellNum)
			item.bSelect = false

			tbSales[#tbSales + 1] = item
		end
	end

	-- logger:debug({getSaleListData_treas = tbSales})

	return tbSales
end

-- optional 背包出售列表排序方法，某些需要出售列表的背包需要实现
function TreasBagHandler:saleListSorter( item1, item2 )

end

-- must 返回某种背包的当前最大可携带数, 每种背包子类必须实现
function BagHandler:getMaxNum( ... )
	return tonumber(self._refBagInfo.gridMaxNum.treas)
end
