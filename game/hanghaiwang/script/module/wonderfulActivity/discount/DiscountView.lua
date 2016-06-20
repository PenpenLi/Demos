-- FileName: DiscountView.lua
-- Author: zhangjunwu
-- Date: 2015-11-12
-- Purpose: 折扣活动view
--[[TODO List]]

module("DiscountView", package.seeall)

-- UI控件引用变量 --

-- UI控件引用变量 --
local m_mainWidget = nil
local m_mainView = nil

-- 模块局部变量 --
local json = "ui/activity_timelimit_sale.json"
local m_fnGetWidget = g_fnGetWidgetByName --读取UI组件方法
local m_i18nString = gi18nString
local m_tbEvent -- 按钮事件

local m_layTotal 		= nil 	--listview父节点 
local m_lsv 			= nil
local _actNameStr 		= ""
function destroy(...)
	package.loaded["DiscountView"] = nil
end

function moduleName()
    return "DiscountView"
end

--单独更新菜单上的时间 
function updateTopListTime()
	m_mainWidget.tfd_time_num:setText(DiscountData.getLastTimeByName(_actNameStr))
	m_mainWidget.tfd_time_num:updateSizeAndPosition()
end

local function btnBuyCallback(rowCell,rowData, selectedIndex)
	function disCountBuyCallbck(cbFlag, dictData, bRet )
		local newData = nil
		if(dictData.err == "ok") then
			if(  not table.isEmpty(dictData.ret)) then
				local tbInfo  = {name = _actNameStr,rowId = rowData.id,
								selfBuy =dictData.ret.goodsInfo.selfBuy,
								allBuy = dictData.ret.goodsInfo.global, }
				 newData = DiscountData.setDisCountDataByName(tbInfo)
			end
		end

		if(dictData.ret.ret == "ok") then
			setLimitBuyLabel(rowCell,newData)
			local tbRewardInfo = {}
			local tbInfo = {}
			-- logger:debug({rowData = rowData})
			-- tbRewardInfo.icon, tbInfo = ItemUtil.createBtnByTemplateIdAndNumber(rowData.tid,rowData.num or 1)
			-- tbRewardInfo.name = tbInfo.name
			-- tbRewardInfo.quality = tbInfo.quality
			-- logger:debug({tbRewardInfo = tbRewardInfo})

			local itemStr = rowData.items
			if (selectedIndex) then
				itemStr = lua_string_split(itemStr, ",")[selectedIndex]
			end

			local itemIconInfo = RewardUtil.parseRewards(itemStr,true)
			-- local tbInfo = itemIconInfo[1].dbInfo
			-- tbRewardInfo.name = itemIconInfo[1].name
			-- tbRewardInfo.quality = itemIconInfo[1].quality
			-- tbRewardInfo.icon =itemIconInfo[1].icon
			-- local tt = {}
			-- table.insert(tt, tbRewardInfo)
			local layReward = UIHelper.createGetRewardInfoDlg( gi18n[3341], itemIconInfo)
			LayerManager.addLayout(layReward)

			UserModel.addGoldNumber(-rowData.current_price) -- 成功扣金币

		elseif(dictData.ret.ret == "limit") then
			ShowNotice.showShellInfo("全服的购买次数已经用完了")   --todo
			setLimitBuyLabel(rowCell,newData)
		end

	end

	if(DiscountData.getActivityLastTime(_actNameStr) <= 0) then
		ShowNotice.showShellInfo("活动已经结束了")   --todo
		return
	end

	logger:debug(rowData)
	if(tonumber(rowData.AllBought) >= tonumber(rowData.global_limit) and tonumber(rowData.global_limit)>0) then
		ShowNotice.showShellInfo("全服的购买次数已经用完了")   --todo
		return 
	elseif(tonumber(rowData.selfBought) >= tonumber(rowData.self_limit)) then
		ShowNotice.showShellInfo("个人的购买次数已经用完了")   --todo
		return 
	end
	
	local needGold = tonumber(rowData.current_price)



	if (UserModel.getGoldNumber() < needGold ) then
		AudioHelper.playCommonEffect()
		LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
		return
	else
		AudioHelper.playBuyGoods()
	end


	local tbRpcArgs
	if (selectedIndex) then
		tbRpcArgs = {_actNameStr,rowData.id,1, selectedIndex}
	else
		tbRpcArgs = {_actNameStr,rowData.id,1}
	end 
	RequestCenter.discount_buyDisItem(disCountBuyCallbck ,Network.argsHandlerOfTable(tbRpcArgs))
end

local function setUILayer()
	--标题图片
	m_mainWidget.img_title:loadTexture(DiscountData.tbTitleImg[_actNameStr])
	--活动结束时间倒计时
	m_mainWidget.tfd_time:setText("活动结束时间：") --todo

	m_mainWidget.tfd_time_num:setText(DiscountData.getLastTimeByName(_actNameStr))
	schedule(m_mainWidget,updateTopListTime,1.0) --创建定时，更新剩余时间
end

local function setLabelColor( nCanBuy ,labelItem)
	if(nCanBuy == 0) then
		--当剩余可购买的数量显示为0时，请使用红色#d81400表示数量“0”
		labelItem:setColor(ccc3(0xd8, 0x14, 0x00))
	else
	end
end

function setLimitBuyLabel(rowCell,  rowData)
	rowCell.lay_all_limit:setEnabled(false)
	rowCell.lay_sale_limit:setEnabled(false)
	rowCell.lay_personal_limit:setEnabled(false)

	--如果全服不限购 
	if(rowData.global_limit == 0) then
		rowCell.lay_personal_limit:setEnabled(true)
		local nSelfCanBuy = rowData.self_limit - rowData.selfBought
		nSelfCanBuy = nSelfCanBuy <= 0 and 0 or nSelfCanBuy
		rowCell.lay_personal_limit.TFD_LEFT:setText(tostring(nSelfCanBuy))
		setLabelColor(nSelfCanBuy,rowCell.lay_personal_limit.TFD_LEFT)
		rowCell.lay_personal_limit.TFD_RIGHT:setText(tostring(rowData.self_limit))

		if( nSelfCanBuy <= 0) then
			rowCell.BTN_BUY:setEnabled(false)
			rowCell.img_outof_sale:setEnabled(true)
		end
	else

		rowCell.lay_all_limit:setEnabled(true)
		rowCell.lay_sale_limit:setEnabled(true)

		local nAllCanBuy = rowData.global_limit - rowData.AllBought
		rowCell.lay_all_limit.TFD_LEFT:setText(tostring(nAllCanBuy))
		rowCell.lay_all_limit.TFD_RIGHT:setText(tostring(rowData.global_limit))

		local nSelfCanBuy = rowData.self_limit - rowData.selfBought
		rowCell.lay_sale_limit.TFD_LEFT:setText(tostring(nSelfCanBuy))
		rowCell.lay_sale_limit.TFD_RIGHT:setText(tostring(rowData.self_limit))
		setLabelColor(nAllCanBuy,rowCell.lay_all_limit.TFD_LEFT)
		setLabelColor(nSelfCanBuy,rowCell.lay_sale_limit.TFD_LEFT)

		if(nAllCanBuy <= 0 or nSelfCanBuy <= 0) then
			rowCell.BTN_BUY:setEnabled(false)
			rowCell.img_outof_sale:setEnabled(true)
		end
	end
end

local iconArray = {}
function createMainListViewBy( tbListData)
	--初始化界面的控件内容
	setUILayer()
	--初始化列表
	local itemDef = m_lsv:getItem(0) -- 获取编辑器中的默认cell
	m_lsv:setItemModel(itemDef)
	m_lsv:removeAllItems() -- 初始化清空列表
	-- logger:debug(tbListData)

	for i, rowData in ipairs(tbListData) do
		m_lsv:pushBackDefaultItem()
		local rowCell = m_lsv:getItem(i - 1)  -- rowCell 索引从 0 开始
		

		local itemIconInfo = RewardUtil.parseRewards(rowData.items)
		logger:debug(itemIconInfo)


	--[==[	2015-12-30 xufei 删除旧的UI的显示
		----------========================
		-- local tbInfo  = ItemUtil.createBtnByTemplateId(rowData.tid)
		
		-- local btnItem, tbInfo = ItemUtil.createBtnByTemplateIdAndNumber(rowData.tid,rowData.num or 1,function ( sender,eventType )
		-- 	if (eventType == TOUCH_EVENT_ENDED) then
		-- 		PublicInfoCtrl.createItemInfoViewByTid(tonumber(rowData.tid))
		-- 	end
		-- end)
		-- ItemUtil.addNumLabel(btnItem, {num = rowData.num or 0}) -- zhangqi, 2015-06-19
		local tbInfo = itemIconInfo[1].dbInfo
		if(tbInfo) then
			rowCell.tfd_desc:setText(tbInfo.desc)

		else
			 local des = m_i18nString(2615) .. rowData.num .. itemIconInfo[1].name
			 rowCell.tfd_desc:setText(des)
		end
		rowCell.tfd_item_name:setText(itemIconInfo[1].name)
		rowCell.tfd_item_name:setColor(g_QulityColor[tonumber(itemIconInfo[1].quality)])
		logger:debug(itemIconInfo.icon)
		rowCell.IMG_ITEM_ICON:addChild(itemIconInfo[1].icon)
		-----------======================
	]==]

		-- 每行的lsv
		local goodsListView = rowCell.LSV_GOODS
		local orCell = rowCell.LAY_OR
		orCell:setZOrder(0)
		UIHelper.initListView(goodsListView)
		goodsListView:removeAllItems()
		goodsListView:setClippingEnabled(true)
		local index = 0
		if (rowData.array_type == "1") then -- 按照不能选的来
			for k1,v1 in ipairs (itemIconInfo) do
				goodsListView:pushBackDefaultItem()
				local goodCell = goodsListView:getItem(k1-1)
				goodCell:addChild(v1.icon)
				v1.icon:setPosition(ccp(goodCell:getContentSize().width/2, goodCell:getContentSize().height/2))
				--goodCell.TFD_NAME:setColor(g_QulityColor[v1[1].quality])
				--goodCell.TFD_NAME:setText(v1[1].name)
			end
		elseif (rowData.array_type == "2") then -- 按照能选的来
			for k1,v1 in ipairs (itemIconInfo) do
				goodsListView:pushBackDefaultItem()
				index = index + 1
				local goodCell = goodsListView:getItem(index-1)
				goodCell:addChild(v1.icon)
				v1.icon:setPosition(ccp(goodCell:getContentSize().width/2, goodCell:getContentSize().height/2))
				--goodCell.TFD_NAME:setColor(g_QulityColor[v1[1].quality])
				--goodCell.TFD_NAME:setText(v1[1].name)
				local cloneORCell = orCell:clone()
				goodsListView:pushBackCustomItem(cloneORCell)
				index = index + 1
			end
			goodsListView:removeLastItem()
		end
		UIHelper.setSliding(goodsListView)

		
		rowCell.tfd_zhekou_num:setText(rowData.nDisPer)
		rowCell.LAY_YUANJIA.TFD_GOLD_NUM:setText(rowData.original_price)
		rowCell.LAY_TEJIA.TFD_GOLD_NUM:setText(rowData.current_price)

		-- img_outof_sale
		rowCell.img_outof_sale:setEnabled(false)

		setLimitBuyLabel(rowCell,rowData)
		
		UIHelper.titleShadow(rowCell.BTN_BUY, m_i18nString(1319))
		rowCell.BTN_BUY:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				
				if (rowData.array_type == "1") then
					btnBuyCallback(rowCell,rowData)
				elseif (rowData.array_type == "2") then
					AudioHelper.playCommonEffect()
					ChooseItemCtrl.create(rowData.items, ChooseItemCtrl.kTYPE_BUY, function ( index )
						btnBuyCallback(rowCell,rowData,index+1)
					end)
				end
			end
		end)

	end
	UIHelper.setSliding( m_lsv )

	return m_mainView
end

function fnReleaseIcon()
	logger:debug("dicountView fnReleaseIcon" .. _actNameStr)
	-- logger:debug(iconArray)
	-- for i,v in ipairs(iconArray) do
	-- 	v:release()
	-- end
	-- iconArray = {}
end

function create(tbEvent,strActName)
	m_tbEvent = tbEvent
	_actNameStr = strActName


	-- init()
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	local imgBg = m_fnGetWidget(m_mainWidget, "img_main_bg")
	imgBg:setScale(g_fScaleX)

	m_lsv = m_mainWidget.LSV_TOTAL

	local LAY_CELL1 = m_fnGetWidget(m_lsv,"LAY_CELL1")

	LAY_CELL1:setSize(CCSizeMake(LAY_CELL1:getSize().width*g_fScaleX,LAY_CELL1:getSize().height*g_fScaleX))
	local bg = m_fnGetWidget(LAY_CELL1,"IMG_CELL")
	bg:setScale(g_fScaleX)

	m_mainWidget.img_chunjie_middle:setScale(g_fScaleX)
	m_mainWidget.img_chunjie_top:setScale(g_fScaleX)
	m_mainWidget.img_chunjie_bg:setScale(g_fScaleX)
	UIHelper.labelNewStroke( m_mainWidget.tfd_time_num )
	UIHelper.labelNewStroke( m_mainWidget.tfd_time )

	UIHelper.registExitAndEnterCall(m_mainWidget,
	function()
		logger:debug("dicountView exit")
		fnReleaseIcon()
	end,
	function()

	end
	)


	return m_mainWidget
end
