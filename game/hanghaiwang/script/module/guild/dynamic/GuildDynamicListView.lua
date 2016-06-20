-- FileName: GuildDynamicListView.lua
-- Author: zhangjunwu
-- Date: 2014-09-18
-- Purpose: 联盟动态界面
--[[TODO List]]

module("GuildDynamicListView", package.seeall)

require "script/module/guild/dynamic/DynamicCell"
require "script/module/guild/UnionCell"
-- UI控件引用变量 --
local m_mainWidget

-- 模块局部变量 --
local json = "ui/union_news.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent
local m_tbDynamicInfoData  		--联盟动态数据

local function init(...)
	m_tbDynamicInfoData = nil
end

function destroy(...)
	package.loaded["GuildDynamicListView"] = nil
end

function moduleName()
	return "GuildDynamicListView"
end

function updateUI( ... )
	local BTN_BACK = m_fnGetWidget(m_mainWidget, "BTN_BACK")
	BTN_BACK:addTouchEventListener(m_tbEvent.fnBack)
	UIHelper.titleShadow(BTN_BACK, gi18n[1019])
end
--[[
tbView = {szView = CCSize, szCell = CCSize, tbDataSource = table_array,
                CellAtIndexCallback = func, CellTouchedCallback = func, didScrollCallback = func, didZoomCallback = func}
--]]
function initListView()
	lay_View =  m_fnGetWidget(m_mainWidget,"LAY_FOR_TBV")
	--LAY_CELL:setEnabled(true)
	local btnCell = m_fnGetWidget(m_mainWidget,"LAY_CELL")
	local m_layCell = btnCell --btnCell:clone()  -- 缓存一个cell的layout，供创建cell用，避免多次读json文件
	m_layCell:setScale(g_fScaleX)
	-- m_layCell:retain() -- 需要单独释放

	local function cellAtIndex( tbData)
		local cell = DynamicCell:new(m_layCell)
		cell:init(tbData)
		cell:refresh(tbData,idx)
		return cell
	end

	local tbView = {}
	tbView.szView = CCSizeMake(lay_View:getSize().width * g_fScaleX,lay_View:getSize().height)
	tbView.szCell = CCSizeMake(btnCell:getSize().width * g_fScaleX,btnCell:getSize().height * g_fScaleX)
	tbView.CellAtIndexCallback = cellAtIndex

	tbView.tbDataSource = m_tbDynamicInfoData

	listView = HZListView:new()
	if (listView:init(tbView)) then
		-- lay_View:addNode(listView:getView())
		hzLayout = TableViewLayout:create(listView:getView())
		lay_View:addChild(hzLayout)
		listView:refresh()
	end

	btnCell:setEnabled(false)
	m_layCell:setEnabled(false)
end

function create( tbEvent , tbDynamicInfoData)
	m_tbEvent = tbEvent
	m_tbDynamicInfoData  = tbDynamicInfoData

	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)

	local img_bg = m_fnGetWidget(m_mainWidget,"img_bg")
	local img_background = m_fnGetWidget(m_mainWidget,"img_background")
	--img_background:setScale(g_fScaleX)
	img_bg:setScale(g_fScaleX)


	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	img_background:setScale(fScale)

	updateUI()
	--初始化军团列表
	initListView()
	return m_mainWidget
end
