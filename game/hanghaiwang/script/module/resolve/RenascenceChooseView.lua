-- FileName: RenascenceChooseView.lua
-- Author: menghao
-- Date: 2014-05-23
-- Purpose: 重生选择列表view


module("RenascenceChooseView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_tabBtn = {} -- 2015-04-29
local m_btnTab1
local m_btnTab2
local m_btnTab3
local m_btnTab4
local m_btnBack
local m_btnSure
local m_tfdChooseTxt
local m_tfdChooseNum

local m_layTableView

local m_imgBG
local m_imgChain
local m_imgSmallBG

local m_tbEventListener


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_color = {normal = ccc3(0xbf, 0x93, 0x67), selected = ccc3(0xff, 0xff, 0xff)}  -- g_TabTitleColor

local m_tbList

-- zhangqi, 2015-04-29
local m_tabStat = {{true, false, false}, {false, true, false}}
local otherType = {}
otherType.__index = function ( table, key )
	return {false, false, true}
end
setmetatable(m_tabStat, otherType)

function updateTxtAndBtn( str, cType )
	m_tfdChooseTxt:setText(str)
	m_tfdChooseNum:setText("0/1")

	for i = 1, 3 do
		local bFocus = m_tabStat[cType][i]
		m_tabBtn[i]:setFocused(bFocus)
		m_tabBtn[i]:setTitleColor(bFocus and m_color.selected or m_color.normal)
	end
	-- if (cType == 1) then
	-- 	m_tabBtn[1]:setFocused(true)
	-- 	m_tabBtn[2]:setFocused(false)
	-- 	m_tabBtn[3]:setFocused(false)
	-- elseif cType == 2 then
	-- 	m_btnTab1:setFocused(false)
	-- 	m_btnTab2:setFocused(true)
	-- 	m_btnTab3:setFocused(false)
	-- else
	-- 	m_btnTab1:setFocused(false)
	-- 	m_btnTab2:setFocused(false)
	-- 	m_btnTab3:setFocused(true)
	-- end
end


function updateNum( num )
	m_tfdChooseNum:setText(num .. "/1")
end


local function createTableView( tbEventListener )
	local tableSize = m_layTableView:getSize()
	local tableView = HZTableView:create(CCSizeMake(tableSize.width, tableSize.height))
	tableView:setDirection(kCCScrollViewDirectionVertical) 		-- 默认垂直滑动
	tableView:setVerticalFillOrder(kCCTableViewFillTopDown) 	-- 默认从上至下放置

	tableView:registerScriptHandler(tbEventListener.tableCellTouched,CCTableView.kTableCellTouched)
	tableView:registerScriptHandler(tbEventListener.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
	tableView:registerScriptHandler(tbEventListener.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
	tableView:registerScriptHandler(tbEventListener.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
	tableView:reloadData()

	local hzLayout = TableViewLayout:create(tableView)
	return hzLayout
end


function updateTableView( nFlag )
	m_layTableView:removeChildByTag(10, true)
	if (m_tbList[nFlag] == nil) then
		m_tbList[nFlag] = createTableView(m_tbEventListener)
	end
	m_layTableView:addChild(m_tbList[nFlag], 1, 10)
end


local function init(...)

end


function destroy(...)
	package.loaded["RenascenceChooseView"] = nil
end


function moduleName()
	return "RenascenceChooseView"
end


function create( tbEventListener, heroID, equipID, treaID)
	m_tbEventListener = tbEventListener

	m_UIMain = g_fnLoadUI("ui/renascence_choose.json")

	local imgBg = m_fnGetWidget(m_UIMain, "img_choose_bottom_bg")
	imgBg:setScale(g_fScaleX) -- 2015-04-29

	m_tbList = {}

	-- 获取各控件
	local i18nTitle = {1001, 1601, 1701}
	for i = 1, 3 do
		m_tabBtn[i] = m_fnGetWidget(m_UIMain,"BTN_TAB" .. i)
		m_tabBtn[i]:setTitleText(m_i18n[i18nTitle[i]]) -- 2015-04-29
	end
	m_tabBtn[4] = m_fnGetWidget(m_UIMain, "BTN_TAB4")
	m_tabBtn[4]:setEnabled(false)
	-- m_btnTab1 = m_fnGetWidget(m_UIMain, "BTN_TAB1")
	-- m_btnTab2 = m_fnGetWidget(m_UIMain, "BTN_TAB2")
	-- m_btnTab3 = m_fnGetWidget(m_UIMain, "BTN_TAB3")
	-- m_btnTab4 = m_fnGetWidget(m_UIMain, "BTN_TAB4")

	m_btnBack = m_fnGetWidget(m_UIMain, "BTN_BACK")
	m_btnSure = m_fnGetWidget(m_UIMain, "BTN_SURE")
	m_tfdChooseTxt = m_fnGetWidget(m_UIMain, "TFD_CHOOSE_TXT")
	m_tfdChooseNum = m_fnGetWidget(m_UIMain, "TFD_CHOOSE_NUM")

	m_layTableView = m_fnGetWidget(m_UIMain, "lay_renascence_list")

	m_imgBG = m_fnGetWidget(m_UIMain, "img_bg")
	m_imgChain = m_fnGetWidget(m_UIMain, "img_partner_chain")
	m_imgSmallBG = m_fnGetWidget(m_UIMain, "img_small_bg")

	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	m_imgBG:setScale(fScale)
	m_imgChain:setScale(g_fScaleX)
	m_imgSmallBG:setScale(g_fScaleX)

	-- 控件初始化
	for i = 1, 3 do
		m_tabBtn[i]:addTouchEventListener(tbEventListener["onTab" .. i])
	end
	-- m_btnTab1:addTouchEventListener(tbEventListener.onTab1)
	-- m_btnTab2:addTouchEventListener(tbEventListener.onTab2)
	-- m_btnTab3:addTouchEventListener(tbEventListener.onTab3)

	m_btnBack:addTouchEventListener(tbEventListener.onBack)
	m_btnSure:addTouchEventListener(tbEventListener.onSure)


	-- UIHelper.titleShadow(m_btnTab1,m_i18n[1001]) -- 2015-04-29, 去阴影
	-- UIHelper.titleShadow(m_btnTab2,m_i18n[1601])
	-- UIHelper.titleShadow(m_btnTab3,m_i18n[1701])

	UIHelper.titleShadow(m_btnSure,m_i18n[1029])
	UIHelper.titleShadow(m_btnBack,m_i18n[1019])

	if (equipID) then
		m_tabBtn[2]:setFocused(true)
		m_tabBtn[2]:setTitleColor(m_color.selected)
		m_tfdChooseTxt:setText(m_i18n[1522])
		m_tfdChooseNum:setText("1/1")
	elseif (treaID) then
		m_tabBtn[3]:setFocused(true)
		m_tabBtn[3]:setTitleColor(m_color.selected)
		m_tfdChooseTxt:setText(m_i18n[1713])
		m_tfdChooseNum:setText("1/1")
	else
		if (heroID) then
			m_tfdChooseNum:setText("1/1")
		else
			m_tfdChooseNum:setText("0/1")
		end
		m_tfdChooseTxt:setText(m_i18n[1020])
		m_tabBtn[1]:setFocused(true)
		m_tabBtn[1]:setTitleColor(m_color.selected)
	end

	m_layTableView:addChild(createTableView(tbEventListener), 1, 10)

	return m_UIMain
end

