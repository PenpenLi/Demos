-- FileName: newLevelRewardView.lua
-- Author: sunyunpeng
-- Date: 2015-03-06
-- Purpose: 等级礼包的UI加载 和等级模块，由crl指定数据
--[[TODO List]]

module("NewLevelRewardView", package.seeall)



-- UI控件引用变量 --
local m_UIMain
local m_layTotal
local m_mainView  --纵向的主ListView
-- 模块局部变量 --

local m_fnGetWidget=g_fnGetWidgetByName
local m_tbInfo
local m_szRowCell  --行cell的size
local m_tbItems
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)
	m_mainView = nil
end

function destroy(...)
	init()
	package.loaded["NewLevelRewardView"] = nil
end

function moduleName()
	return "NewLevelRewardView"
end

--[[desc: 显示礼包列表各项奖励的
    rid: 领取在线奖励的
    m_btnGet: 领取在线奖励的按钮
    m_ImgAllreadyGet: 已领取图片
    return:  
—]]
local function receiveCallback(tbRowData)
	local tbItem = {}
	for i=1,#m_tbItems do
		local tb = {}
		tb.icon = UIHelper.getItemIconAndUpdate(m_tbItems[i].icon.reward_type, m_tbItems[i].icon.reward_values)
		tb.name = m_tbItems[i].name
		tb.quality = m_tbItems[i].quality
		table.insert(tbItem, tb)
	end

	local layReward = UIHelper.createGetRewardInfoDlg( gi18n[1904], tbItem, onConfirm)
	LayerManager.addLayout(layReward)

	require "script/module/wonderfulActivity/MainWonderfulActView"
	tbRowData.status =  2
	MainWonderfulActView.btnSelectChangeNum()
	LevelRewardCtrl.setRewardStatus(m_index )
	UIHelper.reloadListView(m_layTotal,#m_tbInfo.tbData,updateCellByIdex)
end

--[[desc: 领取按钮的回调函数
    rid: 领取在线奖励的
    m_btnGet: 领取在线奖励的按钮
    m_ImgAllreadyGet: 已领取图片
    return:  
—]]
local function btnGetCallback(tbRowData)
	for i=1,#m_tbItems do
		-- 判断背包是否已满
		local rewardType = tonumber(m_tbItems[i].icon.reward_type)
		if (rewardType == 4 or rewardType == 5 or rewardType == 6 or rewardType == 7) then
			if (ItemUtil.isBagFullExPartner(true)) then
				return
			end
		end
		-- 13 为英雄类型
		if (rewardType == 10 or rewardType == 13 ) then
			if (ItemUtil.isPartnerFull(true)) then
				return
			end
		end
	end

	local args = CCArray:create()
	args:addObject(CCInteger:create(tbRowData.rid))
	RequestCenter.levelfund_gainLevelfundPrize(
		function (cbFlag, dictData, bRet)
			if(dictData.err ~= "ok")then
				return
			end
			receiveCallback(tbRowData)
		end, args)
end

--[[desc: 创建每行的ListView
    tbRowData: 某等级在线奖励的具体数据
    colCell: ListView控件
    return:  
—]]
local function initRowView( tbRowData, colCell )
	local button = UIHelper.getItemIcon(tbRowData.icon.reward_type, tbRowData.icon.reward_values)
	local imgGood = g_fnGetWidgetByName(colCell,"IMG_GOODS") --物品背景
	imgGood:removeAllChildrenWithCleanup(true)
	imgGood:addChild(button)
	local labName = g_fnGetWidgetByName(colCell,"TFD_GOODS_NAME")
	UIHelper.labelEffect(labName, tbRowData.name)
	labName:setColor(g_QulityColor[tbRowData.quality])
end

--[[desc: 初始化每行上的listView的Cell
    tbRowData: 某等级在线奖励的具体数据
    rowCell: Cell控件
    return:  
—]]
local function initRowCell( tbRowData, rowCell )
	-- local labnCellTitle = m_fnGetWidget(rowCell,"LABN_CELL_TITLE")
	-- labnCellTitle:setStringValue(tbRowData.title)
	local tfdCellTitle = m_fnGetWidget(rowCell,"TFD_CELL_TITLE")
	tfdCellTitle:setText(tbRowData.title)
	local m_btnGet = m_fnGetWidget(rowCell,"BTN_GET")
	UIHelper.titleShadow(m_btnGet,m_i18n[2628])
	local m_ImgAllreadyGet = m_fnGetWidget(rowCell,"IMG_ALREADY")

	m_btnGet:setEnabled(true)
	m_btnGet:setBright(true)
	m_ImgAllreadyGet:setEnabled(true)
    
	if (tbRowData.status == 2) then
		m_ImgAllreadyGet:setEnabled(true)
		m_btnGet:setEnabled(false)
	elseif (tbRowData.status == 1) then
		m_btnGet:setEnabled(true)
		m_btnGet:setTitleText(m_i18n[2628])
		m_ImgAllreadyGet:setEnabled(false)
	else
		m_btnGet:setEnabled(true)
		m_btnGet:setBright(false)
        m_btnGet:setTitleColor(ccc3(0xf0,0xf0,0xf0))
		m_btnGet:setTitleText(m_i18n[2628])
		m_ImgAllreadyGet:setEnabled(false)
	end
	if (tbRowData.status == 1 ) then
		m_btnGet:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playTansuo02()
				m_tbItems = tbRowData.item
				btnGetCallback(tbRowData )
			end
		end)
	else
		m_btnGet:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				require "script/module/public/ShowNotice"
				ShowNotice.showShellInfo(m_i18nString(2504,tbRowData.level)) -- TDDO
			end
		end)
	end
end

--[[desc: 初始listView的初始显示
    idxRow: 初始化具体的CellIndex 
    return:  
—]]
function scrollPassGetRow( idxRow)
	-- if (m_mainView) then
	-- 	local colGap = m_mainView:getItemsMargin() -- 行cell间隔
	-- 	local passNum = idxRow - 1
	-- 	local hScrollTo = (m_szRowCell.height + colGap) * passNum
	-- 	local szInner = m_mainView:getInnerContainerSize()
	-- 	local szView = m_mainView:getSize()
	-- 	local totalHeight = (m_szRowCell.height + colGap) * #m_tbInfo.tbData
	-- 	m_mainView:setInnerContainerSize(CCSizeMake(szInner.width, totalHeight))
	-- 	local percent = (hScrollTo/(szInner.height - szView.height)) * 100
	-- 	m_mainView:jumpToPercentVertical(percent)
	-- end
end

function updateCellByIdex( list,idx )
	local cell = list:getItem(idx)  -- rowCell 索引从 0 开始
	local tbRowData = m_tbInfo.tbData[idx + 1]
	initRowCell(tbRowData,cell.item)

	for j = 1,4 do
		cell.item["LAY_CLONE" .. j]:setEnabled(true)
	end

	for j, colData in ipairs(tbRowData.item) do
		initRowView(colData, cell.item["LAY_CLONE" .. j]) -- 初始化每行上的listView的cell
	end

	for j = #tbRowData.item + 1,4 do
		if ( j <= 4) then
			cell.item["LAY_CLONE" .. j]:setEnabled(false)
		end
	end
end
--创建主ListView
local function createMainListView( ... )
	local layCellSize = m_layTotal.LAY_CELL:getSize()
	m_layTotal.IMG_CELL:setScale(g_fScaleX)

	m_layTotal.LAY_CELL:setSize(CCSizeMake( layCellSize.width * g_fScaleX,layCellSize.height * g_fScaleX))
	UIHelper.initListViewCell(m_layTotal)
	UIHelper.reloadListView(m_layTotal,#m_tbInfo.tbData,updateCellByIdex,m_index - 1,true)
	
	return m_mainView
end

function create( tbArgs )
	m_tbInfo = tbArgs
	m_index = m_tbInfo.index and tonumber(m_tbInfo.index) or #m_tbInfo.tbData 
	m_UIMain = g_fnLoadUI("ui/mystery_level.json")
	local imgBg = m_fnGetWidget(m_UIMain, "IMG_BG_MAIN")
	imgBg:setScale(g_fScaleX)
	m_layTotal = m_fnGetWidget(m_UIMain, "LSV_MAIN")

	createMainListView()
	return m_UIMain
end
