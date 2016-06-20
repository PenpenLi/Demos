-- FileName: LevelRewardNewView.lua
-- Author: zhangqi
-- Date: 2014-09-05
-- Purpose: 等级礼包的UI加载和显示模块，由Ctrl指定数据调用
--[[TODO List]]

module("LevelRewardNewView", package.seeall)

-- UI控件引用变量 --
local m_UIMain

local m_tfdTitle
local m_layTotal
local m_layCell

local m_mainView -- 纵向的主ListView


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_tbInfo
local m_szRowCell -- 行cell的size


-- add by huxiaozhou
-- 默认的关闭按钮事件
local function onClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
		m_mainView:setTouchEnabled(true)
	end
end

local function initRowView( tbRowData, colCell )
	local button = UIHelper.getItemIcon(tbRowData.icon.reward_type, tbRowData.icon.reward_values)

	local imgGood = g_fnGetWidgetByName(colCell,"IMG_GOODS") --物品背景
	imgGood:addChild(button)
	local labName = g_fnGetWidgetByName(colCell,"TFD_GOODS_NAME")
	UIHelper.labelEffect(labName, tbRowData.name)
	labName:setColor(g_QulityColor2[tbRowData.quality])
end

local function initRowCell( tbRowData, rowCell )
	local labnCellTitle = m_fnGetWidget(rowCell,"LABN_CELL_TITLE")
	labnCellTitle:setStringValue(tbRowData.title)
end

local function createMainListView( ... )
	local cfgList = {posType = POSITON_ABSOLUTE}
	m_mainView = UIHelper.createListView(cfgList)

	local rowCellRef = m_fnGetWidget(m_layTotal, "LAY_CELL")
	m_szRowCell = rowCellRef:getSize()
	m_mainView:setItemModel(rowCellRef)
	rowCellRef:removeFromParentAndCleanup(true)

	local rowCell, colCell, colLayout, colCellRef
	for i, rowData in ipairs(m_tbInfo.tbData) do
		m_mainView:pushBackDefaultItem()
		rowCell = m_mainView:getItem(i - 1)  -- rowCell 索引从 0 开始

		-- 创建每行的ListView
		colLayout = m_fnGetWidget(rowCell, "LAY_FORTBV")
		colCellRef = m_fnGetWidget(colLayout, "LAY_CLONE")
		local colCellCopy = colCellRef:clone()
		colCellRef:removeFromParentAndCleanup(true)

		initRowCell(rowData, rowCell) -- 初始化每行的cell

		local oneItemPercent = (colCellCopy:getSize().width) / colLayout:getSize().width

		for j, colData in ipairs(rowData.item) do
			local colCell = colCellCopy:clone()
			colCell:setPositionPercent(ccp(oneItemPercent * (j - 1), 0))
			colLayout:addChild(colCell)

			initRowView(colData, colCell) -- 初始化每行上的listView的cell
		end
	end
	return m_mainView
end

function scrollPassGetRow( idxRow )
	if (m_mainView) then
		local colGap = m_mainView:getItemsMargin() -- 行cell间隔

		local passNum = idxRow - 1

		local hScrollTo = (m_szRowCell.height + colGap) * passNum

		local szInner = m_mainView:getInnerContainerSize()
		local szView = m_mainView:getSize()
		local totalHeight = (m_szRowCell.height + colGap) * #m_tbInfo.tbData
		m_mainView:setInnerContainerSize(CCSizeMake(szInner.width, totalHeight))
		local percent = (hScrollTo/(szInner.height - szView.height)) * 100
		m_mainView:jumpToPercentVertical(percent)
	end
end

local function init(...)
	m_mainView = nil
end

function destroy(...)
	init()
	package.loaded["LevelRewardNewView"] = nil
end

function moduleName()
	return "LevelRewardNewView"
end

-- tbArgs = { closeEvent = fnCloseEvent, tbData = tbDataSource, index = idx}
function create( tbArgs )
	init()

	m_tbInfo = tbArgs

	m_UIMain = g_fnLoadUI("ui/reward_level.json")

	local btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	btnClose:addTouchEventListener(m_tbInfo.closeEvent)

	m_layTotal = m_fnGetWidget(m_UIMain, "LAY_TOTAL")

	m_layTotal:addChild(createMainListView())

	return m_UIMain
end
