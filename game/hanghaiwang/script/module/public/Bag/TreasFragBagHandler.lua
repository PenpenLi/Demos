-- FileName: TreasFragBagHandler.lua
-- Author: zhangqi
-- Date: 2015-09-28
-- Purpose: 饰品碎片背包数据处理类
--[[TODO List]] 

require "script/module/public/Bag/BagHandler"

TreasFragBagHandler = class("TreasFragBagHandler", BagHandler)

--[[ 饰品碎片作为背包物品修改保留
function TreasFragBagHandler:updateBagInfo( ... )
	self._bUpdate = true
	-- logger:debug({updateBagInfo_refBaginfo = self._refBagInfo})
	self:calcCanFuseNum() -- 重新计算可合成数量
end
]]

-- must 每个背包子类必须实现，用以初始化背包类型等不同的属性
function TreasFragBagHandler:init( ... )
	self._bagType = BAG_TYPE_STR.treasFrag
	self._nTabIdx = 2
	self._nCanFuseNum = 0 -- 可合成饰品数量
end

-- optional 创建引用后端背包数据的背包列表数据，默认根据背包类型创建，非真正背包系统的物品需要重载（例如伙伴，宝物碎片）
function TreasFragBagHandler:createListData( ... )                                                                      
    self._refBagInfo = DataCache.getRemoteBagInfo() -- 后端返回背包信息的引用                                           
                                                                                                                        
    require "script/module/grabTreasure/TreasureData"                                                                   
    local tbFragData = TreasureData.seizerInfoData or {} -- 有可能为nil加空表容错                                       
    self._refTreasFrag = tbFragData.frag                                                                                
                                                                                                                        
    self._tbList = {}                                                                                                   
                                                                                                                        
    for i, frag in ipairs(self._refTreasFrag or {}) do -- 有可能为nil加空表容错                                         
        -- frag.gid = frag.frag_id -- 碎片id 模拟 背包格子 id                                                           
        if (tonumber(frag.frag_num) > 0) then                                                                           
            self._tbList[#self._tbList + 1] = frag                                                                      
        end                                                                                                             
    end                                                                                                                 
                                                                                                                        
    self._ownNum = #self._tbList                                                                                        
end                                                                                                                     

-- must 初始化背包列表的一条数据，每种背包子类必须实现
function TreasFragBagHandler:initOne( tbItemRef )
	local item = tbItemRef
	if (item.dbConf) then
		item.nOwn = tonumber(tbItemRef.frag_num) -- 已有数量
		item.bCompond = item.nOwn >= item.nNeed -- 是否可以合成
		return
	end

	require "db/DB_Item_treasure_fragment"
	-- local dbFrag = DB_Item_treasure_fragment.getDataById(tbItemRef.item_template_id)
	local dbFrag = DB_Item_treasure_fragment.getDataById(tbItemRef.frag_id)

	-- item.bagType = BAG_TYPE_STR.treasFrag -- 记录数据的背包类型，便于删除和修改
	item.dbConf = dbFrag -- 物品对应的配置表信息

	item.id = tonumber(dbFrag.id) -- 排序用
	item.treasId = tonumber(dbFrag.treasureId) -- 对应饰品id

	item.gid = item.id -- 饰品碎片用id模拟gid，便于handler的统一接口处理

	item.name = dbFrag.name -- 名称

	item.nOwn = tonumber(tbItemRef.frag_num) -- 已有数量
	item.nNeed = self:getCompondNum(item.treasId) -- 合成需要数量
	-- item.nOwn = tonumber(tbItemRef.item_num) -- 已有数量
	-- item.nNeed = tonumber(self:getCompondNum(item.treasId)) -- 合成需要数量

	item.bCompond = item.nOwn >= item.nNeed -- 是否可以合成

	item.nQuality = dbFrag.quality -- 品质
end

-- must 每种背包子类必须实现
-- 1.在列表滑动回调中调用，填补初始化后剩余的其他字段 2.如果物品属性变化，需要重新给所有字段赋值
function TreasFragBagHandler:fillOne( tbItemRef )
	local item = tbItemRef

	-- if (item.icon) then
	-- 	logger:debug({fillOneWithIdx_has_item = item})
	-- 	return -- 如果已经填充过直接返回
	-- end
	if (not item.icon) then
		item.icon = {id = item.id}
		item.icon.onTouch = function ( sender, eventType )  -- 图标按钮事件，弹出饰品碎片信息框
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playInfoEffect()
				require "script/module/treasure/NewTreaInfoCtrl"
				NewTreaInfoCtrl.createBtTid(item.id,0,0,3) -- 底栏按钮获取途径 不可进阶
				-- require "script/module/public/PublicInfoCtrl"
				-- LayerManager.addLayout(PublicInfoCtrl.createItemInfoViewByTid(item.id))
			end
		end
	end

	if (item.bCompond) then
		item.onDrop = nil
		item.onCompond = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()

				if (ItemUtil.isTreasBagFull(true)) then
					return -- 饰品背包满则提示
				end

				-- LayerManager.addUILoading() -- 添加屏蔽

				logger:debug("TreaFrag onCompond work")

				local fragId = sender:getTag() -- 实际是饰品碎片id：frag_id
				self:compound(fragId)
			end
		end
	else
		item.onCompond = nil
		item.onDrop = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()

				require "script/module/public/FragmentDrop"
				local objFragDrop = FragmentDrop:new()
				LayerManager.addLayout(objFragDrop:create(sender:getTag()))
			end
		end
	end
end

-- must 背包列表排序方法，每种背包子类需要实现
--[[
排序规则：
第一优先级：是否可合成，可合成的饰品碎片优先排序。
第二优先级：对应装备的潜能，潜能高的装备碎片优先排序。
第三优先级：饰品碎片的数量，数量多的饰品碎片优先排序。
第四优先级：对应饰品碎片id，id大的优先排序。
]]
function TreasFragBagHandler:listSorter( item1, item2 )
	-- 是否可合成
	if (item1.bCompond and not item2.bCompond) then
		return true
	end
	if (not item1.bCompond and item2.bCompond) then
		return false
	end

	-- 潜能
	if (item1.nQuality > item2.nQuality) then
		return true
	end
	if (item1.nQuality < item2.nQuality) then
		return false
	end

	-- 拥有数量
	if (item1.nOwn > item2.nOwn) then
		return true
	end
	if (item1.nOwn < item2.nOwn) then
		return false
	end

	-- id
	return item1.id > item2.id
end

-- 子类可以根据需求决定是否实现：有下拉按钮的背包才需要实现
function TreasFragBagHandler:updateIndex( ... )
	for i, item in ipairs(self._tbList or {}) do
		item.idx = i
	end
end

-- optional 返回出售列表数据，包括初始化和并排序，某些需要出售列表的背包需要实现
function TreasFragBagHandler:getSaleListData( ... )
	local tbSales = {}

	local dbData, saleIdx = nil, 0

	local listData = self:getListData()
	for i, item in ipairs(listData) do
		dbData = item.dbConf

		if (item.gid and dbData.sellable == 1) then
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

-- zhangqi, 2015-09-23, 饰品碎片背包里的合成
function TreasFragBagHandler:compound( fragId )
  	local fragData = self:getFragWithId(tostring(fragId)) -- 取到当前合成的碎片数据
	logger:debug({compound_fragData = fragData})

	local function requestFunc( cbFlag, dictData, bRet )
		logger:debug({fragCompound_dictData = dictData})

		if (bRet and dictData.ret == "true") then
			fragData.frag_num = tonumber(fragData.frag_num) - fragData.nNeed
			if (fragData.frag_num < 0) then
				fragData.frag_num = 0
			end

			-- zhangqi, 2015-12-10, 合成后需要刷新TreasureData相关碎片的当前数量
			TreasureData.setFrag(fragId, fragData.frag_num)

			-- 刷新已有数量和是否可合成标记，以便刷新排序
			fragData.nOwn = fragData.frag_num
			fragData.bCompond = fragData.nOwn >= fragData.nNeed -- 是否可以合成

			GlobalNotify.addObserver(GlobalNotify.BAG_PUSH_CALL, function ( ... )
				local treasHandler = BagModel.getBagHandler(BAG_TYPE_STR.treas)
				if (treasHandler) then
					treasHandler._objBag:updateListWithData(treasHandler:getListData(), 1)
				end
			end, true)
		end
		self:compoundCallback(bRet, fragData)
	end

	local args = CCArray:create()
	args:addObject(CCString:create(fragData.treasId))
	RequestCenter.trea_fuse(requestFunc,args)
end

function TreasFragBagHandler:getFragWithId( sFragId )
	for i, frag in ipairs(self._tbList or {}) do
		-- if (tostring(frag.item_id) == sFragId) then
		if (tostring(frag.frag_id) == sFragId) then
			return frag
		end
	end
end

function TreasFragBagHandler:compoundCallback( bSucc, fragData )
	if (bSucc) then
		-- 用招募的界面显示合成的饰品
		require "script/module/shop/HeroDisplay"
        local data = {}
        data.tid = tonumber(fragData.treasId)
        data.num = 1 -- 数量为 1
        data.iType = 5 -- 5 代表类型为：装备
        HeroDisplay.create(data, 5)

		self:updateBagInfo()

		self:refreshListView(fragData)
	else
		-- 合成失败提示
		LayerManager.addLayout(UIHelper.createCommonDlg(gi18n[2439], nil, UIHelper.onClose, 1))
	end
end

-- 刷新背包UI
function TreasFragBagHandler:refreshListView( fragData )
	if (self._objBag) then
		local listData = self:getListData()

		-- local delNum = (fragData.nOwn - fragData.nNeed) == 0 and 1 or 0
		local delNum = fragData.nOwn == 0 and 1 or 0
		self._objBag:updateListWithData(listData, nil, delNum, fragData.idx)

		self:calcCanFuseNum()

		self._objBag:udpateTabRedCircle(self._nTabIdx,true, self._nCanFuseNum) --更新碎片红点
	end
end

-- 根据背包数据计算当前可合成饰品的数量
function TreasFragBagHandler:calcCanFuseNum( ... )
	self._nCanFuseNum = 0
	
	require "db/DB_Item_treasure_fragment"

	local nOwn, nNeed, dbFrag = 0, 0, nil
	for i, frag in ipairs(self._tbList or {}) do
		-- dbFrag = DB_Item_treasure_fragment.getDataById(frag.item_id)
		dbFrag = DB_Item_treasure_fragment.getDataById(frag.frag_id)

		-- nOwn = tonumber(frag.item_num)  -- 已有数量
		nOwn = tonumber(frag.frag_num)
		nNeed = self:getCompondNum(dbFrag.treasureId) -- 合成需要数量
		if (nOwn >= nNeed) then
			self._nCanFuseNum = self._nCanFuseNum + math.floor(nOwn/nNeed) -- 每个可堆叠的碎片实际可以兑换饰品的数量
		end
	end
	logger:debug({calcCanFuseNum_nCanFuseNum = self._nCanFuseNum})
	
	return self._nCanFuseNum
end

-- 根据饰品tid返回对应的饰品碎片tid和合成需要数量
function TreasFragBagHandler:getCompondNum( treasId )
	require "db/DB_Item_treasure"
	local dbTrea = DB_Item_treasure.getDataById(treasId)
	local tbRet = string.strsplit(dbTrea.fragment_ids, "|")
	return tonumber(tbRet[2])
end
