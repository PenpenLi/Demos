-- FileName: Bag.lua
-- Author: zhangqi
-- Date: 2014-06-19
-- Purpose: 各种背包列表的工厂类，可以创建道具，宝物，伙伴，影子，装备，装备碎片，时装的背包列表
--[[TODO List]]


require "script/module/public/HZListView"

local m_saleName = "LAY_BAG_SALE"
local m_fnGetWidget = g_fnGetWidgetByName
local m_color = {normal = ccc3(0xbf, 0x93, 0x67), selected = ccc3(0xff, 0xff, 0xff)} --  g_TabTitleColor
local m_i18n = gi18n

----------------------------- 定义类 Bag, 加载一次公用UI的json文件 -----------------------------
Bag = class("Bag")

BAGTYPE = {
	BAG = 1, -- 背包(道具)
	PARTNER = 2, -- 伙伴, 影子
	EQUIP = 3, -- 装备, 装备碎片, 时装
	CONCH = 4, -- 空岛贝(类似装备)
	TREA = 5, -- 饰品背包（饰品，饰品碎片）
	AWAKE = 6, -- 觉醒物品背包
}

BAGTAB = {
	{{title = m_i18n[1402], selectTitle = m_i18n[1509]}}, -- 道具背包
	{{title = m_i18n[1089], selectTitle = m_i18n[1020]}, {title = m_i18n[1090], num = true}}, -- 伙伴
	{{title = m_i18n[1601], selectTitle = m_i18n[1509]}, {title = m_i18n[1602], selectTitle = m_i18n[1509]}}, -- 装备
	{{title = m_i18n[5501]}}, -- 空岛贝
	{{title = m_i18n[1701]}, {title = m_i18n[1255]}},
	{{title = "觉醒"}}, -- 觉醒物品背包
}

local mTabMax = 3
local mImgTips = {  {img = "IMG_TAB_TIPS1", num = "TFD_NUM1"}, 
					{img = "IMG_TAB_TIPS2", num = "TFD_NUM2"},
					{img = "IMG_TAB_TIPS3", num = "TFD_NUM3"}
				 } -- 标签按钮右上角红色圆点控件名称
local m_viewLayoutTag = 75478
				 
local m_moduleName = {"MainBag", "MainPartnerBag", "MainEquipBag", "MainConchBag", "MainTreaBag", "AwakeBagCtrl", }

-- 引用时加载一次json
-- if (not Bag.layMain) then -- 只加载一次json
-- 	Bag.layMain = g_fnLoadUI("ui/bag_common.json")
-- 	Bag.laySale = g_fnLoadUI("ui/bag_common_sale.json")
-- 	GUIReader:purge() -- 加载完释放Reader
-- end

-- nBtnIndex, 新创建时为1，从出售列表返回时是之前的self.mBtnIndex，以便返回到正确的列表
function Bag:ctor(...)
	self.mainList = g_fnLoadUI("ui/bag_common.json") -- Bag.layMain:clone()

	self.layBag = m_fnGetWidget(self.mainList, "LAY_BAG") -- 道具列表的父级层容器

	local imgBg = m_fnGetWidget(self.mainList, "img_bg") -- 背景需要不变形的缩放
	imgBg:setScale(g_fScaleX)

	local layEasyInfo = m_fnGetWidget(self.mainList, "lay_easy_info")
	layEasyInfo:setScale(g_fScaleX)

	local imgChain = m_fnGetWidget(self.mainList, "img_partner_chain")
	imgChain:setScale(g_fScaleX)

	local imgSmallBg = m_fnGetWidget(self.mainList, "img_small_bg")
	imgSmallBg:setScale(g_fScaleX)

	self.layOwnNum = m_fnGetWidget(self.mainList, "LAY_OWN_NUM") -- 携带数
	local labCarry = m_fnGetWidget(self.layOwnNum, "TFD_CARRY_NUM")
	labCarry:setText(m_i18n[1004])

	self.btnExpand = m_fnGetWidget(self.mainList, "BTN_EXPANG") -- 扩充按钮

	self.btnSale = m_fnGetWidget(self.mainList, "BTN_SALE") -- 出售按钮

	self.btnConch = m_fnGetWidget(self.mainList, "BTN_WEAR_CONCH") -- 空岛贝按钮
	self.btnConchBack = m_fnGetWidget(self.mainList, "BTN_BACK") -- 空岛贝背包返回按钮
	UIHelper.titleShadow(self.btnConchBack, m_i18n[1019]) -- 2015-04-29

	self.labOwn = m_fnGetWidget(self.mainList, "TFD_OWN_NUM") -- 携带数
	self.mOwnColor = ccc3(0x00, 0x2d, 0x80)

	self.labMax = m_fnGetWidget(self.mainList, "TFD_BAG_NUM")

	self.mTabs = {} -- 存放所有标签按钮的对象引用
	self.mBtnIndex = 1 -- 当前被选中的按钮索引值, 默认左起第一个
	self.mLists = {} -- array, 存放标签按钮对应的列表，索引和按钮索引对应
	self.ownNum = {}
	self.maxNum = {}
end

function Bag:clearViewBtnBarData( ... )
	for _, hzView in ipairs(self.mLists) do
		hzView:setBtnBarData() -- 关闭背包列表时清除缓存数据中可能存在的按钮面板数据, 2015-04-24
	end
end

function Bag:touchTabWithIndex( nIndex )
	--logger:debug("Bag:touchTabWithIndex")
	self:tabOnTouch(self.mTabs[nIndex])
end

-- -- 移动列表位置
-- function Bag:refreshBagListView( mBtnIndex, newOffset)
-- 	local list = self.mLists[i]
--     local curentView = list:getView()
-- 	curentView:setContentOffset(newOffset)
-- end


-- 改变标签按钮状态
function Bag:changeTabStat(btn, bStat)
	local tabStat = bStat
	for i, tab in ipairs(self.mTabs) do
        local list = self.mLists[i]
		tabStat = (tab == btn) and bStat or (not bStat)
		--logger:debug("tabStat = %d", tabStat == true and 1 or 0)
		if (tabStat) then
			self.mBtnIndex = i -- 保存当前被选中的按钮索引值，便于在扩充和出售按钮中做判断

			local bShow = self.expands and table.include(self.expands, i)
			self.btnExpand:setEnabled(bShow) -- 是否显示扩充按钮

			bShow = self.sales and table.include(self.sales, i)
			self.btnSale:setEnabled(bShow) -- 是否显示出售按钮

			bShow = self.nums and table.include(self.nums, i)
			self.layOwnNum:setEnabled(bShow) -- 是否显示携带数
			

            if (list) then
                local view = list:getView()
                view:setVisible(true)
                -- view:retain()
                view:removeFromParentAndCleanup(true) --view是self.layBag的子节点
                self.layBag:removeChildByTag(m_viewLayoutTag,true)
                local hzLayout = TableViewLayout:create(view)
                self.layBag:addChild(hzLayout, 100, m_viewLayoutTag)
                list:refresh()
                list:enterAnimation()
                -- view:release()

                local ownNum = self.bagInfo.tbTab[self.mBtnIndex].tbView.tbDataSource.ownNum
                self:updateOwnNumber(ownNum or list:cellCount())

                self:updateMaxNumber(self.maxNum[i])
			else
				performWithDelayFrame(self.mainList,function ( ... )
					TimeUtil.timeStart("create table view")
					self:initViewList(i) -- 构造列表
					TimeUtil.timeEnd("create table view")
					local list = self.mLists[i]
					local view = list:getView()
					view:retain()
					UIHelper.registExitAndEnterCall(self.layBag,function()
							view:release()
						end
						)
					list:enterAnimation()
				end,1)
				-- 进阶红点判断
				if (i == 1 and self.bagType == BAGTYPE.PARTNER) then
					performWithDelayFrame(self.mainList,function ( ... )
						local canTranseNum = PartnerTransUtil.getIsHaveHroAdvanced() and 1 or 0
						local bShow = canTranseNum > 0
						self:udpateTabRedCircle(1,bShow,canTranseNum)
					end,11)
				end
			end
        else
            if (list) then
            	list:setBtnBarData() -- 2015-04-24, 清除按钮面板的数据

                local view = list:getView()
                view:setVisible(false)
                -- view:retain()
                -- view:removeFromParentAndCleanup(true)
            end
		end
		tab:setFocused(tabStat)
		tab:setTitleColor(tabStat and m_color.selected or m_color.normal)
		tab:setTouchEnabled(not tabStat)
	end
end

-- 指定刷新标签上的红色圆点
function Bag:udpateTabRedCircle( TabIndex,bEnable, nNum )
	bEnable = nNum > 0 -- zhangqi, 2014-08-11, 根据数量值自动判断是否显示红点
	local layTabs = m_fnGetWidget(self.mainList, "lay_bag_tab")
	local Tab = m_fnGetWidget(layTabs, "BTN_TAB" .. TabIndex)
	self:setRedCircleStatAndNum(Tab, bEnable, nNum)
end

-- 刷新当前按下标签上的红色圆点
function Bag:udpateRedCircle( bEnable, nNum )
	bEnable = nNum > 0 -- zhangqi, 2014-08-11, 根据数量值自动判断是否显示红点
	self:setRedCircleStatAndNum(self.curTab, bEnable, nNum)
end
-- 刷新标签按钮上的红色圆点的状态和数字
function Bag:setRedCircleStatAndNum( btnTab, bEnable, nNum )
	if (btnTab) then
		-- local imgRed = m_fnGetWidget(btnTab, "IMG_TAB_TIPS")
		-- imgRed:setEnabled(bEnable)

		-- if (nNum and bEnable) then
		-- 	local labnNum = m_fnGetWidget(btnTab, "LABN_NUM")
		-- 	labnNum:setStringValue(nNum)
		-- end 
		local imgRedCircle = m_fnGetWidget(btnTab, "IMG_TAB_TIPS")
		imgRedCircle:setEnabled(false)

		local imgRedPoint = m_fnGetWidget(btnTab, "IMG_RED")
		if (bEnable) then
			imgRedPoint:removeAllNodes()
			imgRedPoint:addNode(UIHelper.createRedTipAnimination())
		else
			imgRedPoint:removeAllNodes()
		end

	end
end

-- 初始化标签按钮
function Bag:tabOnTouch ( sender ,tabOnTouch)
	--logger:debug("tabOnTouch: tag = %d", sender:getTag())
	local btn = tolua.cast(sender, "Button")
	self:changeTabStat(btn, true) -- 保持按下状态
	self.curTab = btn
end
function Bag:initTabBtns( )
	local tabs = BAGTAB[self.bagInfo.sType]
	local layTabs = m_fnGetWidget(self.mainList, "lay_bag_tab")

	for i, tab in ipairs(tabs) do
		local btn = m_fnGetWidget(layTabs, "BTN_TAB" .. i)
		-- btn:setTouchEnabled(false)
		table.insert(self.mTabs, btn)
		-- UIHelper.titleShadow(btn, tab.title) -- 2015-04-29, 去掉阴影
		btn:setTitleText(tab.title)

		btn:setTitleColor(m_color.normal)
		btn:setTag(i)
		btn:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playTabEffect()
				self:tabOnTouch(sender)
			end
		end)
		local imgRedCircle = m_fnGetWidget(btn, "IMG_TAB_TIPS")
		imgRedCircle:setEnabled(false)
		
		performWithDelayFrame(self.mainList,function()
				-- 初始化红色圆点状态
				local bShow = self.bagInfo.tbTab[i].num ~= nil and self.bagInfo.tbTab[i].num > 0
				self:setRedCircleStatAndNum( btn, bShow, self.bagInfo.tbTab[i].num )
				-- btn:setTouchEnabled(true)
			end,11)
	end

	-- 第一个标签默认保持按下状态
	self.curTab = self.mTabs[self.mBtnIndex] -- 保存当前按下的tab的引用，便于处理tab上的红色圆点
	self:changeTabStat(self.curTab, true)

	for i = mTabMax, #tabs+1, -1 do
		local btn = m_fnGetWidget(layTabs, "BTN_TAB" .. i)
		btn:removeFromParentAndCleanup(true) -- 删除多余的标签
	end
end

-- 扩充按钮添加事件回调
function Bag:initExpandBtn( ... )
	if (self.bagInfo.onExpand) then
		self.btnExpand:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				self.bagInfo.onExpand(self.mBtnIndex)
			end
		end)
	else
		self.btnExpand:setEnabled(false)
	end
end

-- 刷新携带数
function Bag:updateOwnNumber( nNum )
	if (nNum and tonumber(nNum) >= 0) then
		self.ownNum[self.mBtnIndex] = tonumber(nNum)
		self.labOwn:setText(nNum)
		if (self.ownNum[self.mBtnIndex] >= self.maxNum[self.mBtnIndex]) then
			self.labOwn:setColor(ccc3(0xff, 0x00, 0x00)) -- 携带数大于等于最大数时变红
		else
			self.labOwn:setColor(self.mOwnColor)
		end
	end
end

-- 刷新背包最大携带数
function Bag:updateMaxNumber( nNum, nIndex )
	if (nNum and tonumber(nNum) >= 0) then
		if (not nIndex) then
			self.maxNum[self.mBtnIndex] = tonumber(nNum)
			self.labMax:setText(nNum)
			if (self.ownNum[self.mBtnIndex] < self.maxNum[self.mBtnIndex]) then
				self.labOwn:setColor(self.mOwnColor)
			end
		else
			self.maxNum[nIndex] = tonumber(nNum)
		end
	end
end

-- 初始化携带数
function Bag:initOwnNumber( ... )
    local idx = self.mBtnIndex
    local numWithoutWeared = self.bagInfo.tbTab[idx].tbView.tbDataSource.ownNum
    self.ownNum[idx] = numWithoutWeared or #self.bagInfo.tbTab[idx].tbView.tbDataSource
	self.labOwn:setText(self.ownNum[idx])

    self.maxNum[idx] = self.bagInfo.tbTab[idx].nMaxNum -- 当前最大携带数
	self.labMax:setText(self.maxNum[idx])

	--logger:debug("Bag:initOwnNumber")
	if (self.ownNum[idx] >= self.maxNum[idx]) then
		--logger:debug("ownNum = %d,, maxNum = %d", self.ownNum[idx], self.maxNum[idx])
		self.labOwn:setColor(ccc3(0xff, 0x00, 0x00))
	else
		self.labOwn:setColor(self.mOwnColor)
	end
end

-- 
function Bag:getViewList( viewIndex )
	return self.mLists[viewIndex]
end

-- 初始化HZTableView
function Bag:initViewList( btnIndex )
	--logger:debug("Bag:initViewList btnIdx = %d", btnIndex)
    self.mLists[btnIndex] = HZListView:new("BAG")
    local hzList = self.mLists[btnIndex]
    local tbCfg = self.bagInfo.tbTab[btnIndex].tbView
    local szView = self.layBag:getSize()
    tbCfg.szView = CCSizeMake(szView.width, szView.height)

    if (btnIndex ~= 1 and tbCfg.getData) then
    	tbCfg.tbDataSource = tbCfg.getData()
    end
    
    if (hzList:init(tbCfg)) then
    	local hzLayout = TableViewLayout:create(hzList:getView())
    	hzLayout:setTag(m_viewLayoutTag)
        self.layBag:addChild(hzLayout)
        hzList:refresh()
    end

    hzList:saveOffsetOfInit() -- 2015-05-11
    -- 初始化携带数
    self:initOwnNumber()
end

-- 刷新某一个列表
-- tbData: 更新后的列表数据
-- nCellIdx: 需要刷新的cell的索引值，从 0 开始，如果nil则刷新所有cell
-- num: 删除的cell数量
-- moveToCellIndex 需要定位的cellIndex
function Bag:updateCurrentListWithData( tbData, nCellIdx, num, moveToCellIndex )
	self:clearViewBtnBarData() -- 2015-04-30
	-- logger:debug({tbData=tbData})
	local hzList = self.mLists[self.mBtnIndex]
	if (hzList) then
		--hzList:changeData(tbData)
		hzList:changeData(tbData)
		hzList:refreshNotReload()
		if (nCellIdx) then
			hzList:updateCellAtIndex(nCellIdx)
		else
			hzList:updateAllCell()
		end

		-- zhangqi, 2015-10-16, 修改刷新方式
		if (num) then
			hzList:reloadDataDelByOffset(num or 0)
		else
			-- 如果没有删除cell就保持当前列表的位移，只刷新数据
			local cellHeight = nil
			local bHasBtnBar = self.bagType == BAGTYPE.PARTNER or self.bagType == BAGTYPE.EQUIP or self.bagType == BAGTYPE.TREA
			if (self.mBtnIndex == 1 and bHasBtnBar) then
				local size = g_fnCellSize(CELLTYPE.BTN_BAR)
				cellHeight = size.height -- 如果是伙伴、装备、饰品等带按钮面板的列表需要计算按钮面板的cell高度
			end
			hzList:reloadDataByOffset(cellHeight)
		end

		self.bagInfo.tbTab[self.mBtnIndex].tbView.tbDataSource = tbData
		local ownNum = tbData.ownNum
		self:updateOwnNumber(ownNum or hzList:cellCount())

		if (moveToCellIndex) then
			hzList:moveToCellIndex(moveToCellIndex)
		end 
	end

end


-- 只重置列表数据：因为从装备背包引导获得碎片后，装备碎片的数据有变化，但是目前在装备列表，所以要重置碎片数据否则切换列表后数据不对
function Bag:resettbDataSource(tbData, listIndex )
	local hzList = self.mLists[listIndex]
	if (hzList) then
		self.bagInfo.tbTab[listIndex].tbView.tbDataSource = tbData
		hzList:changeData(tbData)
	end
end


-- 刷新某一个列表
-- modified: zhangqi, 2014-12-26
-- tbData: 更新后的列表数据
-- idx: 需要刷新数据的列表索引, nil 的话默认取当前Bag对象的mBtnIndex
-- num: 需要删除的cell的数量，一个物品使用完所有数量 num = 1，宝箱和钥匙都使用完时 num = 2, 未使用完为 0
-- idxCell: 需要删除物品在数据列表中的索引, 因为要符合CCTableViewCell的索引值，所以从0开始
-- moveToCellIndex 需要定位的cellIndex

function Bag:updateListWithData( tbData, idx, num, idxCell , moveToCellIndex)
	logger:debug("Bag:updateListWithData-idx:%s, num:%s, idxCell:%s", tostring(idx), tostring(num), tostring(idxCell))
	
	if (not idx) then
		idx = self.mBtnIndex
	end
	 
	local hzList = self.mLists[idx]
	if (hzList) then
		hzList:changeData(tbData)
		hzList:refreshNotReload()
		self.bagInfo.tbTab[idx].tbView.tbDataSource = tbData
		local ownNum = tbData.ownNum
		 
		if (idx ~= self.mBtnIndex) then
			self.ownNum[idx] = ownNum or hzList:cellCount() -- 如果需要刷新的列表不是当前显示的列表，只更新数据不刷新UI	 
		else
			self:updateOwnNumber(ownNum or hzList:cellCount())
		end
		if (num == nil) then
			num = 0
		end
 		hzList:reloadDataDelByOffset(num, idxCell or 0)	 
 		if (moveToCellIndex) then
			logger:debug({moveToCellIndex=moveToCellIndex})
			hzList:moveToCellIndex(moveToCellIndex)
		end 

	end
	
end

--newfunc 等到列表的偏移
function Bag:getListViewData( idx )
	if (not idx) then
		idx = self.mBtnIndex
	end
	 
	local hzList = self.mLists[idx]
	if (hzList) then
		local  view = hzList:getView()
		return view:getContentOffset()
	end
	return ccp(0,0)
end

-- 主UI出售按钮事件
function Bag:initSaleBtn( ... )
	--logger:debug("Bag:initSaleBtn")
	if (self.bagType == BAGTYPE.PARTNER) then
		self.btnSale:setEnabled(false) -- 如果是伙伴背包，需要隐藏出售按钮
		local posSale = self.btnSale:getPositionPercent() --  ccp(self.btnSale:getPosition())
		self.btnExpand:setPositionPercent(posSale)
		return
	end
	if (self.bagInfo.tbSale) then
		self.btnSale:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				require "script/module/public/SaleList"

				local tbSale = self.bagInfo.tbSale
				self.saleList = SaleList.create(self.bagType, self.mBtnIndex, tbSale)
				-- LayerManager.changeModule(self.saleList.mainSale, self.saleList:getModuleName(), {1,2}, true)
				-- zhangqi, 2015-10-08, 信息条改为附加到模块的根画布，此处配合修改
				LayerManager.changeModule(self.saleList.mainSale, self.saleList:getModuleName(), {1})
				PlayerPanel.addForPartnerStrength()
			end
		end)
	else
		self.btnSale:removeFromParentAndCleanup(true)
	end
end

-- 主UI空岛贝按钮事件
function Bag:initConchBtn( ... )
	if (self.bagType ~= BAGTYPE.CONCH) then
		self.btnConch:removeFromParentAndCleanup(true)
		self.btnConchBack:removeFromParentAndCleanup(true)
		return
	end

	self.btnConch:addTouchEventListener(self.bagInfo.eventWear)
	self.btnConchBack:addTouchEventListener(self.bagInfo.eventBack)
end

function Bag:init(  )
	-- 初始化标签按钮
	self:initTabBtns()
	-- 扩充按钮事件
	self:initExpandBtn()
	-- 出售按钮事件
	self:initSaleBtn()
	-- 空岛贝按钮事件
	self:initConchBtn()
end

function Bag:getModuleName( ... )
	return self.moduleName or "Bag"
end

function Bag.create( tbInfo, tabIndex)
	local bag = Bag:new()

	bag.bagInfo = tbInfo
    if (tabIndex) then
        bag.mBtnIndex = tabIndex
    end

	bag.bagType = tbInfo.sType
	bag.expands = tbInfo.expands -- zhangqi,2015-09-23,记录列表是否需要扩充
	bag.sales = tbInfo.sales -- zhangqi,2015-09-23,记录列表是否需要出售
	bag.nums = tbInfo.nums -- zhangqi, 2015-10-09, 标记是否需要显示携带数
	bag.moduleName = m_moduleName[bag.bagType]
	TimeUtil.timeStart("init Bag")
	bag:init()
	TimeUtil.timeEnd("init Bag")
	-- zhangqi, 2014-08-08, 打开背包后重置背包按钮的红点提示状态
	local function resetRedPointOfBag( ... )
		local redPoint = {g_redPoint.bag, g_redPoint.partner, g_redPoint.equip, g_redPoint.conch, g_redPoint.treasure, g_redPoint.awake}
		redPoint[bag.bagType].visible = false
		if (redPoint[bag.bagType].setvisible) then
			redPoint[bag.bagType].setvisible(0)
		end
		redPoint[bag.bagType].num = 0

		local btn = nil
		if (bag.bagType == BAGTYPE.BAG) then
			MainScene.updateBagPoint() -- 如果当前创建是道具背包，重置红点显示
		end
	end
	LayerManager.addUILayer() --前10帧防止切换页签
	performWithDelayFrame(bag.mainList,function()
			resetRedPointOfBag()
			LayerManager.removeUILayer()
		end,11)

	return bag
end

