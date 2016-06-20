-- FileName: GCRewardQueueView.lua
-- Author: yangna
-- Date: 2015-06-03
-- Purpose: 奖励队列 视图
--[[TODO List]]

module("GCRewardQueueView", package.seeall)
require "db/DB_Legion_copy_reward"
require "script/module/guildCopy/GCRewardQueueUtil"

-- UI控件引用变量 --

-- 模块局部变量 --
local _i18n = gi18n
local _i18nString 	= gi18nString
local _fnGetWidget = g_fnGetWidgetByName

local _layMain = nil
local _listView = nil

local _iconTag = 1235
local _tbArgs = nil

local function init(...)

end

function destroy(...)
	package.loaded["GCRewardQueueView"] = nil
end

function moduleName()
    return "GCRewardQueueView"
end

function refreashListView(tbRewardData)
	_listView:removeAllItems()
	local tbRewardDataTemp = GCRewardQueueModel.getIconAndName(tbRewardData)

	for i=1,#tbRewardData do 
		_listView:pushBackDefaultItem()

		local queue = tbRewardData[i].queue  --物品的队列
		local tbData = tbRewardDataTemp[i]

		local cell = _listView:getItem(i-1)

		cell.TFD_GOODS_NAME:setText(tbData.name)
		cell.TFD_GOODS_NAME:setColor(g_QulityColor[tbData.quality])

		local icon = tbData.icon
		cell.LAY_CLONE:removeChildByTag(_iconTag,true)
		cell.LAY_CLONE:addChild(icon,1,_iconTag)
		local size = cell.LAY_CLONE:getSize()
		icon:setPosition(ccp(size.width/2,size.height/2))

		cell.BTN_APPLY_ALREADY:setTouchEnabled(false)
		cell.BTN_APPLY_ALREADY:setVisible(false)
		cell.BTN_APPLY_ALREADY:addTouchEventListener(_tbArgs.onAbandon)
		cell.BTN_APPLY_ALREADY:setTag(i)

		cell.BTN_APPLY:setTouchEnabled(false)
		cell.BTN_APPLY:setVisible(false)
		cell.BTN_APPLY.itemname = tbData.name
		cell.BTN_APPLY:addTouchEventListener(_tbArgs.onApply)
		cell.BTN_APPLY:setTag(i)
		UIHelper.titleShadow(cell.BTN_APPLY,_i18n[3507])    --申请
		
		cell.BTN_QUEUE:addTouchEventListener(_tbArgs.onQueneContent)
		cell.BTN_QUEUE:setTag(i)

		-- 当前副本有无玩家排队
		if (GCRewardQueueUtil.isUserInQueue(queue)) then 
		 	cell.TFD_RANK:setVisible(true)
		 	cell.TFD_QUEUE_NUM:setVisible(false)
		 	cell.TFD_RANK:setText(string.format(_i18n[5913] ,GCRewardQueueUtil.getIndex(queue)))  --"申请排名%d"
			cell.BTN_APPLY_ALREADY:setTouchEnabled(true)
			cell.BTN_APPLY_ALREADY:setVisible(true)
		else
 		 	cell.TFD_RANK:setVisible(false)
		 	cell.TFD_QUEUE_NUM:setVisible(true)
		 	cell.TFD_QUEUE_NUM:setText(string.format(_i18n[5914],GCRewardQueueUtil.count(queue)))  --"已有%d人申请"
 			cell.BTN_APPLY:setTouchEnabled(true)
			cell.BTN_APPLY:setVisible(true)
		end 

		if (GCRewardQueueUtil.count(queue) > 0) then 
			cell.BTN_QUEUE:setVisible(true)
			cell.BTN_QUEUE:setTouchEnabled(true)
		else 
			cell.BTN_QUEUE:setVisible(false)
			cell.BTN_QUEUE:setTouchEnabled(false)
		end 

		cell.TFD_OWN:setText(string.format(_i18n[5915],tbRewardData[i].visibleNum))  --"剩余%d件"
	end 

	-- performWithDelay(_layMain, function ( ... )
	-- 	_listView:jumpToPercentVertical(0)
	-- end, 0.1)

	
end


function updateListByIndex( index )
	local cell = _listView:getItem(index-1)
	if (cell) then 
		cell.BTN_APPLY:setTouchEnabled(false)
		cell.BTN_APPLY:setVisible(false)
		cell.BTN_APPLY_ALREADY:setTouchEnabled(true)
		cell.BTN_APPLY_ALREADY:setVisible(true)
	end 
end


function getMainLay( ... )
	return _layMain
end


function create( tbArgs,tbRewardData )
	_tbArgs = tbArgs
	_layMain = g_fnLoadUI("ui/union_reward_queue.json")

	_layMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	_listView = _layMain.LSV_TOTAL

	UIHelper.initListView(_listView)

	refreashListView(tbRewardData)

	return _layMain
end
