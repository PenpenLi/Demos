-- FileName: RapidSaleView.lua
-- Author: sunyunpeng
-- Date: 2015-04-10
-- Purpose: 快速出售View
--[[TODO List]]

module("RapidSaleView", package.seeall)



-- UI控件引用变量 --
local m_UIMain
local m_layTotal
local m_mainView  --纵向的主ListView
local m_btnSale
local m_btnClose
local m_btnNo
local m_tfdPrice
local m_tfdWarning
local m_tfdCanGet 

-- 模块局部变量 --
local m_fnGetWidget=g_fnGetWidgetByName
local m_tbInfo
local m_btnStr
local m_i18nString = gi18nString
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["RapidSaleView"] = nil
end

function moduleName()
	return "RapidSaleView"
end

--创建ListView上的Cell上的 可快速出卖的物品图标
local function initRowView( colData, colCell )
	local itemIcon   -- 物品图标

	itemIcon = ItemUtil.createBtnByTemplateIdAndNumber(colData.id, colData.num, function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			PublicInfoCtrl.createItemInfoViewByTid(colData.id, colData.num)
		end
	end)


	local imgGood = g_fnGetWidgetByName(colCell,"IMG_ITEM_BG") --物品背景
	imgGood:addChild(itemIcon)
	local labName = g_fnGetWidgetByName(colCell,"TFD_SHOP_RECRUIT_PREVIEW_NAME")  --物品名字
	UIHelper.labelEffect(labName, colData.name)
end


--创建主ListView
local function createMainListView( ... )
	m_mainView = UIHelper.createListView(m_UIMain)
	local rowCellRef = m_fnGetWidget(m_layTotal, "lay_item_list")
	m_mainView:setItemModel(rowCellRef)
	rowCellRef:removeFromParentAndCleanup(true)
	local rowCell, colCell, colLayout, colCellRef
	for i, rowData in ipairs(m_tbInfo.tbData) do
		m_mainView:pushBackDefaultItem()
		rowCell = m_mainView:getItem(i - 1)  -- rowCell 索引从 0 开始
		-- 创建每行的ListView
		colCellRef = m_fnGetWidget(rowCell, "lay_item_bg1")
		local colCellCopy = colCellRef:clone()
		colCellRef:removeFromParentAndCleanup(true)
		--initRowCell(rowData, rowCell) -- 初始化每行的cell
		local oneItemPercent = ( colCellRef:getSize().width / rowCellRef:getSize().width)

		for j, colData in ipairs(rowData) do
			local colCell = colCellCopy:clone()
			colCell:setPositionPercent(ccp(oneItemPercent * (j - 1), 0))
			rowCell:addChild(colCell)
			initRowView(colData, colCell) -- 初始化每行上的listView的cell
		end
		m_tfdPrice:setText(m_tbInfo.totalSilver)
	end

	return m_mainView
end


function create(tbArgs)

	m_tbInfo = tbArgs
    m_btnStr = tbArgs.btnStr
	m_UIMain = g_fnLoadUI("ui/public_sell_item.json")
	m_layTotal = m_fnGetWidget(m_UIMain, "LSV_MAIN")

	m_tfdPrice=m_fnGetWidget(m_UIMain, "TFD_PRICE")
	m_layTotal:addChild(createMainListView())

	m_btnNo = m_fnGetWidget(m_UIMain, "BTN_NO")
	m_btnNo:addTouchEventListener(m_tbInfo.closeEvent)
	UIHelper.titleShadow(m_btnNo, m_i18n[1993])

	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	m_btnClose:addTouchEventListener(m_tbInfo.closeEvent)

	m_btnSale = m_fnGetWidget(m_UIMain, "BTN_YES")
	m_btnSale:addTouchEventListener(m_tbInfo.rapidSaleEvent)
	UIHelper.titleShadow(m_btnSale, m_i18n[1992])


    m_tfdWarning = m_fnGetWidget(m_UIMain, "TFD_RECRUIT")
    m_tfdWarning:setText(m_i18n[1990])
    m_tfdCanGet = m_fnGetWidget(m_UIMain, "tfd_can_get")
    m_tfdCanGet:setText(m_i18n[1991])


	require "script/module/public/Bag"
	local m_bagTab = BAGTAB

	local sType = m_bagTab[BAGTYPE.BAG]
	return m_UIMain
end
