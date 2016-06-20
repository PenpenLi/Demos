-- FileName: SkyPieaRankView.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 空岛排行榜 显示器
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("SkyPieaRankView", package.seeall)

require "script/module/SkyPiea/SkyPieaRank/SkyPieaRankCell"

-- UI控件引用变量 --
local json = "ui/air_rank.json"
-- 模块局部变量 --
local m_mainWidget
local m_fnGetWidget = g_fnGetWidgetByName
local m_tbEvent
local m_layCell -- 排行榜 cell
local m_i18n = gi18n

local m_tbRankData = {}
local function init(...)
	m_tbRankData = {}
end

function destroy(...)
	package.loaded["SkyPieaRankView"] = nil
end

function moduleName()
	return "SkyPieaRankView"
end

--[[
-- 创建排行榜列表
tbView = {szView = CCSize, szCell = CCSize, tbDataSource = table_array,
           CellAtIndexCallback = func, CellTouchedCallback = func, didScrollCallback = func, didZoomCallback = func}
--]]
function initListView()
	list_View =  m_fnGetWidget(m_mainWidget,"LAY_CELL_BG")
	local btnCell = m_fnGetWidget(m_mainWidget,"LAY_CELL")
	m_layCell = btnCell:clone()  -- 缓存一个cell的layout，供创建cell用，避免多次读json文件
	-- m_layCell:setScale(g_fScaleX)
	m_layCell:retain() -- 需要单独释放

	local function cellAtIndex( tbData)
		local cell = SkyPieaRankCell:new(m_layCell)
		cell:init(tbData)
		cell:refresh(tbData,idx)
		return cell
	end

	local tbView = {}
	tbView.szView = CCSizeMake(list_View:getSize().width,list_View:getSize().height)
	tbView.szCell = CCSizeMake(btnCell:getSize().width,btnCell:getSize().height)
	tbView.CellAtIndexCallback = cellAtIndex

	tbView.tbDataSource = m_tbRankData.top

	local listView = HZListView:new()
	if (listView:init(tbView)) then
		local hzLayout = TableViewLayout:create(listView:getView())
		list_View:addChild(hzLayout)
		listView:refresh()
	end

	btnCell:setEnabled(false)
	m_layCell:setEnabled(false)
end

--[[
	@desc: 加载空岛爬排行榜UI
—]]
function loadUI(  )
	local btnClose = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
	local btnPreReward = m_fnGetWidget(m_mainWidget, "BTN_SURE")
	UIHelper.titleShadow(btnPreReward, m_i18n[1952])
	btnClose:addTouchEventListener(m_tbEvent.onClose)
	btnPreReward:addTouchEventListener(m_tbEvent.onPreReward)

	local i18nDesc = m_fnGetWidget(m_mainWidget, "tfd_desc") -- 每日00:00点进行结算并发放奖励
	i18nDesc:setText(m_i18n[5412])


	m_mainWidget.tfd_now_rank:setText(m_i18n[2204])
	m_mainWidget.tfd_now_score:setText(m_i18n[5468])
	m_mainWidget.tfd_now_floor:setText(m_i18n[5469])
	m_mainWidget.tfd_now_reward:setText(m_i18n[5470])


	local labRank = m_fnGetWidget(m_mainWidget, "TFD_NOW_RANK_NUM")
	local labScore = m_fnGetWidget(m_mainWidget, "TFD_NOW_SCORE_NUM")
	local labFloor = m_fnGetWidget(m_mainWidget, "TFD_NOW_FLOOR_NUM")
	local labReward = m_fnGetWidget(m_mainWidget, "TFD_AIR")
	labReward:setText(SkyPieaModel.getSkyRewardNum())
	labRank:setText(m_tbRankData.myRank)
	labScore:setText(m_tbRankData.point)
	labFloor:setText(m_tbRankData.cur_base)
	initListView()

end

--[[
	@desc: 创建
    @param 	tbEvent  type:  table 按钮 绑定事件
    @return: m_mainWidget  type: userdata air_rank 主画布
—]]
function create(tbEvent)
	m_tbEvent = tbEvent
	m_mainWidget = g_fnLoadUI(json)
	m_tbRankData = SkyPieaModel.getRankList()
	loadUI()
	UIHelper.registExitAndEnterCall(m_mainWidget,function ( )
		m_layCell:release() -- 记住要释放
	end)

	return m_mainWidget
end
