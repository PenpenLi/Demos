-- FileName: GCApplyQueueView.lua
-- Author: yangna
-- Date: 2015-06-04
-- Purpose: 插队页面 
--[[TODO List]]

module("GCApplyQueueView", package.seeall)
require "script/module/guildCopy/GCRewardQueueUtil"
-- UI控件引用变量 --

-- 模块局部变量 --
local _i18n = gi18n
local _i18nString 	= gi18nString
local _fnGetWidget = g_fnGetWidgetByName

local _layMain = nil
local _listView = nil

local nTag = 101


local function init(...)

end

function destroy(...)
	package.loaded["GCApplyQueueView"] = nil
end

function moduleName()
    return "GCApplyQueueView"
end

function refreashListView(tbQueueData)
	_listView:removeAllItems()
	local queue = tbQueueData.queue

	for i=1, table.count(queue) do 
		_listView:pushBackDefaultItem()
		local cell = _listView:getItem(i-1)
		cell.LABN_RANK:setStringValue(tostring(i))

        cell.LAY_PHOTO:removeNodeByTag(nTag)
        local headSp = HeroUtil.getHeroIconByHTID(queue[i].figure)
        headSp:setTag(nTag)
        local size = cell.LAY_PHOTO:getSize()
        headSp:setPosition(ccp(size.width/2,size.height/2))
        cell.LAY_PHOTO:addNode(headSp)
        cell.TFD_NAME:setText(queue[i].uname)
        local color = UserModel.getPotentialColor({htid=queue[i].figure})
        cell.TFD_NAME:setColor(color)

	end 
end


function refreashUI( tbQueueData )
	refreashListView(tbQueueData)
	_layMain.TFD_NUM:setText(tbQueueData.visibleNum and tbQueueData.visibleNum or 0)

	local h,m = GCRewardQueueModel.getRemainTime()
	_layMain.TFD_TIME:setText(string.format(_i18n[5910],h,m))  --"%d小时%d分"

	if (GCRewardQueueUtil.isUserInQueue(tbQueueData.queue) ) then 
		_layMain.TFD_RANK_NOW:setText(string.format( _i18n[5909],GCRewardQueueUtil.getIndex(tbQueueData.queue)))  --"第%d位"
	else
		_layMain.TFD_RANK_NOW:setVisible(false)
	end 

	updateTime()
end

function updateTime( ... )
	schedule(_layMain, function ( ... )
		local h,m = GCRewardQueueModel.getRemainTime()
		print("h,m=",h,m)
		_layMain.TFD_TIME:setText(string.format(_i18n[5910],h,m))   --"%d小时%d分"
	end, 10)
end


function create(tbArgs,tbQueueData)
	_layMain = g_fnLoadUI("ui/union_queue.json")
	_layMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	_listView = _layMain.LSV_MAIN
	_layMain.BTN_CUT:addTouchEventListener(tbArgs.onInsert)

	logger:debug(tbQueueData)

	local tbData = GCRewardQueueModel.getIconAndNameByOne(tbQueueData)
	logger:debug(tbData)

	local icon = tbData.icon
	_layMain.LAY_ITEM:addChild(icon)
	local size = _layMain.LAY_ITEM:getSize()
	icon:setPosition(ccp(size.width/2,size.height/2))
	
	_layMain.TFD_ITEM_NAME:setText(tbData.name)
	_layMain.TFD_ITEM_NAME:setColor(g_QulityColor[tbData.quality])

	UIHelper.initListView(_listView)
	refreashUI(tbQueueData)

	return _layMain
end
