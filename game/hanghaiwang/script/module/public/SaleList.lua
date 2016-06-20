-- FileName: SaleList.lua
-- Author: zhangqi
-- Date: 2014-06-26
-- Purpose: 各种背包列表的出售列表，可以创建道具，宝物，伙伴，影子，装备，装备碎片，时装出售列表
--[[TODO List]]

local m_saleName = "LAY_BAG_SALE"
local m_fnGetWidget = g_fnGetWidgetByName
local m_color = g_TabTitleColor
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_bagTab = BAGTAB
local m_num = 0
local m_moduleName = {{"ItemSale"}, {"PartnerSale", "ShadowSale"}, {"EquipSale", "EquipFragSale", "FashionSale"},
						{}, {"TreasSale"},
					}

---------------------------------------- SaleList 类定义 ----------------------------------------

SaleList = class("SaleList")

function SaleList:ctor(...)
	self.mainSale = g_fnLoadUI("ui/bag_common_sale.json")
	self.mainSale:setName(m_saleName)

	local imgBg = m_fnGetWidget(self.mainSale, "img_bg") -- 背景需要不变形的缩放
	imgBg:setScale(g_fScaleX)

	local imgBottom = m_fnGetWidget(self.mainSale, "img_sell_bottom_bg")
	imgBottom:setScale(g_fScaleX) -- 2015-04-29

	local layEasyInfo = m_fnGetWidget(self.mainSale, "lay_easy_info")
	layEasyInfo:setScale(g_fScaleX)

	local imgSmallBg = m_fnGetWidget(self.mainSale, "img_small_bg")
	imgSmallBg:setScale(g_fScaleX)

	local imgChain = m_fnGetWidget(self.mainSale, "img_bag_sale_chain")
	imgChain:setScale(g_fScaleX)

	self.labNum = m_fnGetWidget(self.mainSale, "TFD_NUM") -- 已选中个数
	self.labIncome = m_fnGetWidget(self.mainSale, "TFD_SELL_BELLY_NUM") -- 累计出售价格

	self.btnBack = m_fnGetWidget(self.mainSale, "BTN_BACK") -- 返回按钮
	UIHelper.titleShadow(self.btnBack, m_i18n[1019])
	
	self.btnStar = m_fnGetWidget(self.mainSale, "BTN_STAR_SELL") -- 按品级出售
	UIHelper.titleShadow(self.btnStar, m_i18n[1018])

	self.btnSell = m_fnGetWidget(self.mainSale, "BTN_SELL") -- 出售按钮
	UIHelper.titleShadow(self.btnSell, m_i18n[1022])

	self.layBag = m_fnGetWidget(self.mainSale, "LAY_BAG_SALE_LIST") -- 出售列表
	logger:debug("SaleList:ctor, layBag.w = %f, layBag.h = %f", self.layBag:getSize().width, self.layBag:getSize().height)
end

function SaleList.create( bagType, bagIndex, bagInfo )
	local list = SaleList:new()

	list.bagInfo = bagInfo
	list.moduleName = m_moduleName[bagType][bagIndex]
	list.bagIndex = bagIndex
	list.bagType = bagType

	list:init()

	return list
end

function SaleList:getModuleName( ... )
	return self.moduleName or "SaleList"
end

-- 初始化HZTableView
function SaleList:initViewList( ... )
	logger:debug("SaleList:initViewList")
	local tbCfg = self.bagInfo.fnGetSaleListConfig(self)
	self.mDataSource = tbCfg.tbDataSource -- 保存列表数据，出售后从其中删去已经出售的物品数据，避免重新加载背包信息

    self.mList = HZListView:new()
    local hzList = self.mList
    local szView = self.layBag:getSize()
    logger:debug("initViewList, view.w = %f, view.h = %f", szView.width, szView.height)
    tbCfg.szView = CCSizeMake(szView.width, szView.height)
    if (hzList:init(tbCfg)) then
        -- self.layBag:addNode(hzList:getView())
        local hzLayout = TableViewLayout:create(hzList:getView())
        self.layBag:addChild(hzLayout)
        hzList:refresh()
    end
end

function SaleList:getSelectIndexMax( ... )
	
	if (table.count(self.mSelectIdx) > 0) then
		local allIdx = table.allKeys(self.mSelectIdx)
		table.sort(allIdx)
		return allIdx[#allIdx]
	else
		return 0
	end
end

function SaleList:changeItem( bStat, nPrice, cellIndex )
	local sign = bStat == true and 1 or -1
	self.mCount = self.mCount + sign
	self.mPrice = self.mPrice + nPrice*sign
	m_num = self.mCount
	self:updateIncome(self.mCount, self.mPrice)

	self.mSelectIdx[cellIndex] = bStat or nil
end

-- 刷新出售列表中已选中个数和累计出售价格
function SaleList:updateIncome( nNum, nIncome )
	self.labNum:setText(nNum or "0")
	 
	self.labIncome:setText(nIncome or "0")
	if (not nNum) then
		self.mCount = 0
		self.mPrice = 0
	end
end

-- 出售的回调
function SaleList:sellCallback( cbFlag, dictData, bRet )
    if (bRet) then
    	logger:debug("sellCallback self.bagIndex = %d, self.bagType = %d", self.bagIndex, self.bagType)
        assert(self.mList, "sellCallback: mList must not be nil")
        local mod = m_moduleName[self.bagType][self.bagIndex]

        ShowNotice.showShellInfo(m_i18nString(1508, self.mPrice))
        UserModel.addSilverNumber(self.mPrice)

        -- 出售成功后, 非伙伴的物品出售需要从背包删除
        if (self.bagType  ~= BAGTYPE.PARTNER) then
	        for kGid, item in pairs(self.mSellList) do
	            ItemUtil.reduceItemByGid(kGid, nil, true)
	        end

	        logger:debug("reduceItemByGid")
	    end

	    if(self.bagType == BAGTYPE.EQUIP) then

	    	require "script/module/equipment/MainEquipmentCtrl"
	    	--清空装备背包数据 ,
	    	if(self.bagIndex == 1) then
	    		--清空装备背包数据 ,
	    		MainEquipmentCtrl.cleanArmData()
	    	else
	    		MainEquipmentCtrl.cleanArmFragData()
	    	end
	    end

        self:updateIncome() -- 重置出售数量和总价

        self.mSellList = {}

        -- 更新出售列表数据
        local newData = self.bagInfo.fnGetSaleListData(self)
        self.mList:changeData(newData)
		self.mList:refreshNotReload()

		self.mList:reloadDataDelByOffset(tonumber(m_num),self:getSelectIndexMax())

		m_num = 0
		self.mSelectIdx = {}
    end
end

-- 初始化出售列表
function SaleList:init( ... )
	logger:debug("SaleList:init")

	self.mCount = 0
	self.mPrice = 0
	self:updateIncome() -- 初始化出售数量和价格
	
	self.mSellList = {} -- 被出售列表

	self.mSelectIdx = {} -- 选中cell的index集合

	local bagType = self.bagType

	local sType = m_bagTab[bagType][self.bagIndex]
	-- 国际化
	local labSelect = m_fnGetWidget(self.mainSale, "TFD_SELECT_TXT")
	labSelect:setText(sType.selectTitle)
	local labTotal = m_fnGetWidget(self.mainSale, "tfd_sell_txt")
	labTotal:setText(m_i18n[1021])

	-- 返回按钮事件
	self.btnBack:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			if (bagType == BAGTYPE.BAG) then
				require "script/module/bag/MainBagCtrl"
				MainBagCtrl.create()
	        elseif (bagType == BAGTYPE.PARTNER) then
	        	require "script/module/partner/MainPartner"
				LayerManager.changeModule(MainPartner.create(), MainPartner.moduleName(), {1, 3}, true)
				PlayerPanel.addForPartnerStrength()
	        elseif (bagType == BAGTYPE.EQUIP) then
	        	require "script/module/equipment/MainEquipmentCtrl"
				LayerManager.changeModule(MainEquipmentCtrl.create(self.bagIndex), MainEquipmentCtrl.moduleName(), {1, 3}, true)
				PlayerPanel.addForPartnerStrength()
	        elseif (bagType == BAGTYPE.TREA) then
	        	MainTreaBagCtrl.create()
			else
				logger:debug("SaleList not found bagType: " .. bagType)
	        end
		end
	end)

	-- 按星级出售, 改成按品级出售了, 只有装备出售具有
	if (self.bagInfo.onStarSale) then
		local fnStarSale = self.bagInfo.onStarSale[self.bagIndex]
		if (fnStarSale) then
			self.btnStar:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					fnStarSale(self)
				end
			end)
		else
			self.btnStar:removeFromParentAndCleanup(true)
		end
	else
		self.btnStar:removeFromParentAndCleanup(true)
	end

	-- 出售按钮
	self.btnSell:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

            if (table.isEmpty(self.mSellList) ) then
                ShowNotice.showShellInfo(m_i18n[1641])
            else
                local text = m_i18nString(1662, self.mCount, sType.title, self.mPrice) -- "您已选择出售%d件%s，总计出售%d贝里"
                local dlg = UIHelper.createCommonDlg(text, nil, 
                									 	function ( sender, eventType ) -- 出售确认按钮事件
										                	if (eventType == TOUCH_EVENT_ENDED) then
										                		AudioHelper.playBtnEffect("buttonbuy.mp3")

										                		LayerManager.removeLayout()
															    local tempArgs = CCArray:create()
															    for k, v in pairs(self.mSellList) do
															        local arrItems = CCArray:create()
															        arrItems:addObject(CCInteger:create(tonumber(v.gid)))
															        arrItems:addObject(CCInteger:create(v.item_id))
															        arrItems:addObject(CCInteger:create(v.nNum))
															        tempArgs:addObject(arrItems)
															    end
															    local arrArgs = CCArray:create()
															    arrArgs:addObject(tempArgs)
															    RequestCenter.bag_sellItems(function ( cbFlag, dictData, bRet )
																						    	self:sellCallback(cbFlag, dictData, bRet)
																						    end, arrArgs)
										                	end
										                end,2, function ( sender, eventType )
										                	if (eventType == TOUCH_EVENT_ENDED) then
										                		AudioHelper.playCloseEffect()
																LayerManager.removeLayout()
										                	end
										                end)
                LayerManager.addLayout(dlg)
            end
		end
	end)

	-- 物品列表
	self:initViewList()

end
