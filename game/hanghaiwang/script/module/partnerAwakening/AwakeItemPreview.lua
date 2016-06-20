-- FileName: AwakeItemPreview.lua
-- Author: Xufei
-- Date: 2015-12-21
-- Purpose: 觉醒物品预览界面
--[[TODO List]]

AwakeItemPreview = class("AwakeItemPreview")

-- UI控件引用变量 --

-- 模块局部变量 --
local _layMain = nil
local _fnGetWidget = g_fnGetWidgetByName
local _i18n = gi18n




function AwakeItemPreview:showListView( ... )
	_listViewData = MainAwakeModel.getItemPreviewData()
	local nIdx,cell
	_listView:removeAllItems()
	for k,v in ipairs (_listViewData) do
		_listView:pushBackDefaultItem()
		nIdx = k - 1
		cell = _listView:getItem(nIdx)
		cell.TFD_LEVEL_STAR:setText(v.star)
		cell.TFD_LEVEL_NUM:setText(v.Lv)
		for k1,v1 in ipairs (v.consumeInfo) do 
			local itemCell = _fnGetWidget(cell, "LAY_ITEM"..tostring(k1)) 
			itemCell:addChild(v1.icon)
			v1.icon:setPosition(ccp(itemCell:getContentSize().width/2, itemCell:getContentSize().height/2))
			itemCell.TFD_OWN_NUM:setText(v1.haveNum)

			if (tonumber(v1.haveNum)<=0) then
				itemCell.TFD_OWN_NUM:setColor(ccc3(0xff, 0x00, 0x00))
				itemCell.IMG_MENGBAN:setVisible(true)
			else
				itemCell.IMG_MENGBAN:setVisible(false)
			end
		end
			cell.tfd_own:setText(_i18n[6907])
			cell.tfd_star:setText(_i18n[7428])
			cell.tfd_level:setText(_i18n[3643])
	end
end


function AwakeItemPreview:init( ... )
	local _listViewData = nil
	local _listView = nil
end

function AwakeItemPreview:destroy(...)
	package.loaded["AwakeItemPreview"] = nil
end

function AwakeItemPreview:moduleName()
    return "AwakeItemPreview"
end

function AwakeItemPreview:ctor()
	self.layMain = g_fnLoadUI("ui/awake_item_preview.json") 
end

function AwakeItemPreview:create(...)
	_layMain = self.layMain
	UIHelper.registExitAndEnterCall(_layMain,
		function()
			self:destroy()
			GlobalNotify.removeObserver("AWAKE_PRIVIEW_REFRESH","AWAKE_PRIVIEW_REFRESH")
		end,
		function()
			self:init()
			GlobalNotify.addObserver("AWAKE_PRIVIEW_REFRESH", function ( ... )
				_listViewData = MainAwakeModel.getItemPreviewData()
				self:showListView()
			end, false,"AWAKE_PRIVIEW_REFRESH")
		end
	)
	
	_listView = _layMain.LSV_MAIN

	_layMain.BTN_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)

	UIHelper.initListView(_listView)

	self:showListView()
	



	LayerManager.addLayout(_layMain)
end
