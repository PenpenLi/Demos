-- FileName: SkyPieaRankPreRewadView.lua
-- Author: huxiaozhou
-- Date: 2015-01-09
-- Purpose: 空岛奖励预览界面
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("SkyPieaRankPreRewadView", package.seeall)
require "script/module/SkyPiea/SkyPieaRank/SkyPieaRankRewardCell"

-- UI控件引用变量 --
local json = "ui/air_rank_reward.json"

-- 模块局部变量 --
local m_mainWidget
local m_fnGetWidget = g_fnGetWidgetByName
local m_tbEvent
local m_layCell
local function init(...)

end

function destroy(...)
	package.loaded["SkyPieaRankPreRewadView"] = nil
end

function moduleName()
	return "SkyPieaRankPreRewadView"
end


--[[
	@desc: 创建修改每个cell上的头像
    @param 	 iconData type: table -- 物品的结构表 包括icon
    @param 	 iconCell type: imageView 物品背景位置
—]]
local function initRowView( iconData, iconCell )
	local imgGood = m_fnGetWidget(iconCell,"IMG_GOODS") --物品背景
	imgGood:addChild(iconData.icon)
	local labName = m_fnGetWidget(iconCell,"TFD_GOODS_NAME")
	UIHelper.labelEffect(labName, iconData.name)
	labName:setColor(g_QulityColor2[tonumber(iconData.quality)])
end


--[[
	@desc: 修改每个cell上的显示
    @param 	cell  type: userdata-layout
	@param 	tbData  type: table 每个cell 上用到得数据
	@param 	index  type: number  cell 的index
—]]
local function loadCell( cell, tbData, index)
	logger:debug(tbData)
	local i18ntfd_kaifu = m_fnGetWidget(cell, "tfd_kaifu") -- 第
	local i18ntfd_tian = m_fnGetWidget(cell, "tfd_tian") -- 天
	local tfdTitle = m_fnGetWidget(cell, "TFD_CELL_TITLE")
	tfdTitle:setText(tbData.desc)
	-- 创建每行的ListView
	local colLayout = m_fnGetWidget(cell, "LAY_FORTBV")
	local colCellRef = m_fnGetWidget(colLayout, "LAY_CLONE")

	local colCellCopy = colCellRef:clone()
	colCellRef:removeFromParentAndCleanup(true)


	local oneItemPercent = (colCellCopy:getSize().width) / colLayout:getSize().width

	local rowData = RewardUtil.parseRewards(tbData.items)

	for j, colData in ipairs(rowData) do
		local colCell = colCellCopy:clone()
		colCell:setPositionPercent(ccp(oneItemPercent * (j - 1), 0))
		colLayout:addChild(colCell)
		initRowView(colData, colCell)
	end

end


--[[
-- 创建排行榜列表
tbView = {szView = CCSize, szCell = CCSize, tbDataSource = table_array,
           CellAtIndexCallback = func, CellTouchedCallback = func, didScrollCallback = func, didZoomCallback = func}
--]]
function initListView()
	list_View =  m_fnGetWidget(m_mainWidget,"LSV_CELL")
	local btnCell = m_fnGetWidget(m_mainWidget,"LAY_CELL")
	m_layCell = btnCell:clone()  -- 缓存一个cell的layout，供创建cell用，避免多次读json文件
	m_layCell:retain() -- 需要单独释放

	local function cellAtIndex( tbData)
		local cell = SkyPieaRankRewardCell:new(m_layCell)
		cell:init(tbData)
		cell:refresh(tbData,idx)
		return cell
	end

	local tbView = {}
	tbView.szView = CCSizeMake(list_View:getSize().width,list_View:getSize().height)
	tbView.szCell = CCSizeMake(btnCell:getSize().width,btnCell:getSize().height)
	tbView.CellAtIndexCallback = cellAtIndex

	tbView.tbDataSource = SkyPieaModel.getAllRankRewards()

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
	@desc: 加载初始化UI
—]]
local function loadUI(  )
	local btnClose = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
	local btnConfirm = m_fnGetWidget(m_mainWidget, "BTN_SURE")
	UIHelper.titleShadow(btnConfirm, gi18n[1324])
	btnClose:addTouchEventListener(m_tbEvent.onClose)
	btnConfirm:addTouchEventListener(m_tbEvent.onConfirm)

	-- local main_lsv = m_fnGetWidget(m_mainWidget, "LSV_CELL")
	-- UIHelper.initListView(main_lsv)
	-- local tbRewards = SkyPieaModel.getAllRankRewards()

	-- local nIdx
	-- for i,cellData in ipairs(tbRewards or {}) do
	-- 	main_lsv:pushBackDefaultItem()
	-- 	nIdx = i - 1
	-- 	local cell = main_lsv:getItem(nIdx)  -- cell 索引从 0 开始
	-- 	loadCell(cell,cellData,i)
	-- end
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
	loadUI()
	UIHelper.registExitAndEnterCall(m_mainWidget, function (  )
		m_layCell:release()
	end)
	return m_mainWidget
end
