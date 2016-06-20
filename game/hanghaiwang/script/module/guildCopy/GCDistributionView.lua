-- FileName: GCDistributionView.lua
-- Author: zhangjunwu
-- Date: 2015-06-05
-- Purpose: 工会副本战利品分配 View

module("GCDistributionView", package.seeall)

-- UI控件引用变量 --
local m_i18n 			= gi18n
local m_i18nString 		= gi18nString
local m_fnGetWidget 	= g_fnGetWidgetByName

local _cloneCell 		= nil 
-- 模块局部变量 --
local _layMain 			= nil
local _listView 		= nil
local _iconTag 			= 1235
local _tbAllRewardInfo  = {}
local _tbEventArgs 		= {}
local _titleCellSize 
local function init(...)

end

function destroy(...)
	package.loaded["GCDistributionView"] = nil
end

function moduleName()
    return "GCDistributionView"
end

local function getListCount(  )
	return #_tbAllRewardInfo
end
 

function updateListView(tbRewardInfo)
	_tbAllRewardInfo = tbRewardInfo
	UIHelper.reloadListView(_listView, getListCount(), updateCellByIdex)

	_layMain.TFD_NO_ITEM:setEnabled(true)
	if(table.count(_tbAllRewardInfo) > 0) then
		_layMain.TFD_NO_ITEM:setEnabled(false)
	end
end

function updateCellByIdex( lsv, idx )
	logger:debug(idx)
	local tbData = _tbAllRewardInfo[idx + 1]
	local cell = lsv:getItem(idx)
	--是副本的名字 cell
	logger:debug(tbData.copyName)
	if(tbData.copyName ~= nil) then
		cell:removeAllChildrenWithCleanup(false)
		local nodeCopyTitle = _cloneCell:clone()
		logger:debug("_titleCellSize")
		logger:debug(_titleCellSize.height)
		nodeCopyTitle:setSize(_titleCellSize)
		nodeCopyTitle:setPosition(ccp(0,0))
		nodeCopyTitle:setAnchorPoint(ccp(0,0))
		nodeCopyTitle.TFD_COPY_NAME:setText(tbData.copyName)
		UIHelper.labelNewStroke(nodeCopyTitle.TFD_COPY_NAME , ccc3(0x92,0x53,0x1b))
		cell:setSize(_titleCellSize)
		cell:addChild(nodeCopyTitle)
		lsv:updateSizeAndPosition()
	else

		local rewardInfo  = GCRewardQueueModel.getIconAndNameByOne(tbData)
		local LAY_CELL = cell.item.LAY_CELL
		LAY_CELL.TFD_ITEM_NUM:setText(tbData.visibleNum .. m_i18n[5921])
		LAY_CELL.TFD_ITEM_NAME:setText(rewardInfo.name)
		LAY_CELL.TFD_ITEM_NAME:setColor(g_QulityColor[rewardInfo.quality])

		local icon = rewardInfo.icon
		icon:setScale(0.8)
		LAY_CELL.LAY_ITEM:removeChildByTag(_iconTag,true)
		LAY_CELL.LAY_ITEM:addChild(icon,1,_iconTag)
		local size = LAY_CELL.LAY_ITEM:getSize()
		icon:setPosition(ccp(size.width/2,size.height/2))

		local _tbQueue = tbData.queue
		local nPeopleNum = table.count(_tbQueue)
		LAY_CELL.TFD_PLAYER_NUM:setText(nPeopleNum)

		LAY_CELL.BTN_FENPEI:setTag(idx)
		LAY_CELL.BTN_FENPEI:addTouchEventListener(_tbEventArgs.onDistribution)  --手动分配
		UIHelper.titleShadow(LAY_CELL.BTN_FENPEI ,m_i18n[5920])
		LAY_CELL.TFD_TIME:setText(GCDistributionCtrl.getTimeStrToAutoReward())
	end
	
end



function create(tbArgs,tbAllRewardInfo)

	_tbEventArgs = tbArgs
	_tbAllRewardInfo = tbAllRewardInfo

	_layMain = g_fnLoadUI("ui/union_fenpei.json")

	_layMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	_listView = _layMain.LSV_MAIN

	if(table.count(tbAllRewardInfo) > 0) then
		_layMain.TFD_NO_ITEM:setEnabled(false)
	end

	_cloneCell = _layMain.LAY_CELL_TITLE:clone()
	_titleCellSize = _cloneCell:getSize()
	_cloneCell:retain()

	_layMain.LAY_CELL_TITLE:removeFromParentAndCleanup(true)

	UIHelper.registExitAndEnterCall(_layMain,
	function()
		logger:debug("_cloneCell release")
		_cloneCell:release()
	end,
	function()

	end
	)

	UIHelper.initListViewCell(_listView)
	UIHelper.reloadListView(_listView, getListCount(), updateCellByIdex)

	return _layMain
end
