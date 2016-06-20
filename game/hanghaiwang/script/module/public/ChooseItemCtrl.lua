-- FileName: ChooseItemCtrl.lua
-- Author: yucong
-- Date: 2015-12-26
-- Purpose: 奖励选择框
--[[TODO List]]

module("ChooseItemCtrl", package.seeall)
local ChooseItemView = ChooseItemView
local _instance = nil
local _layer = nil
local _type = nil
local _selectIndex = -1
local _eventSelector = nil

---------------- 类型 ----------------
kTYPE_GAIN	= "1" 	-- 领取
kTYPE_BUY	= "2" 	-- 购买

---------------- MSG ----------------
MSG_BTN_CLICK	= "MSG_BTN_CLICK"

---------------- i18 ----------------
TB_DES	= {
	[kTYPE_GAIN] = {
		DES_BTN 		= gi18n[1029],
		DES_NOCHOOSE 	= "请选择领取的物品",
		DES_TITLE2		= "请从以下奖励中选取一个",
	},
	[kTYPE_BUY] = {
		DES_BTN 		= gi18n[1435],
		DES_NOCHOOSE 	= "请选择购买的物品",
		DES_TITLE2		= "请从以下奖励中选取一个",
	},
}

function onBtnPress( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- AudioHelper.playCommonEffect()
		if (_selectIndex >= 0) then
			--ShowNotice.showShellInfo("选中:".._selectIndex)
			LayerManager.removeLayout()
			GlobalNotify.postNotify(MSG_BTN_CLICK, _selectIndex)
			if (_eventSelector) then
				_eventSelector(_selectIndex)
				_eventSelector = nil
			end		
		else
			AudioHelper.playCommonEffect()
			ShowNotice.showShellInfo(TB_DES[_type].DES_NOCHOOSE)
		end
	end
end

function onCellPress( sender, eventType )
	if (eventType == CHECKBOX_STATE_EVENT_SELECTED) then
		AudioHelper.playCommonEffect()
		switchCell(sender:getTag())
	else
		AudioHelper.playCommonEffect()
		_selectIndex = -1
	end
end

function onListView( sender, eventType )
	if (eventType == SCROLLVIEW_EVENT_SCROLLING) then
		local hOffset = sender:getHContentOffset()

		if (not sender:isBounceEnabled()) then
			_layer.IMG_ARROW_LEFT:setVisible(false)
			_layer.IMG_ARROW_RIGHT:setVisible(false)
			return
		end
		
		if (hOffset >= 0) then -- 右箭头不显示
			_layer.IMG_ARROW_LEFT:setVisible(true)
			_layer.IMG_ARROW_RIGHT:setVisible(false)
		else
			local lOffMax = sender:getViewSize().width - sender:getInnerContainerSize().width -- 左边的最大位移
			logger:debug({hOffset = hOffset, lOffMax = lOffMax})
			if (hOffset <= lOffMax) then -- 左箭头不显示
				_layer.IMG_ARROW_LEFT:setVisible(false)
				_layer.IMG_ARROW_RIGHT:setVisible(true)
			else
				_layer.IMG_ARROW_LEFT:setVisible(true)
				_layer.IMG_ARROW_RIGHT:setVisible(true)
			end
		end
	end	
end

function switchCell( index )
	local oldCell = _layer.LSV_MAIN:getItem(_selectIndex)
	if (oldCell) then
		oldCell.CBX_CHOOSE:setSelectedState(false)
	end
	_selectIndex = index
	local newCell = _layer.LSV_MAIN:getItem(_selectIndex)
	if (newCell) then
		newCell.CBX_CHOOSE:setSelectedState(true)
	end
end

local function init(...)
	_selectIndex = -1
	_eventSelector = nil
	_type = nil
end

function destroy(...)
	_instance = nil
	_layer = nil
	--_type = nil
	--_selectIndex = -1
	--_eventSelector = nil
	package.loaded["ChooseItemCtrl"] = nil
end

function moduleName()
    return "ChooseItemCtrl"
end

-- @param goodsStr 奖励串
-- @param kType 类型 对应kTYPE_GAIN, ...
-- @param func 回调，参数为选中的index，从0开始
function create(goodsStr, kType, func)
	init()
	_type = kType
	_eventSelector = func
	_instance = ChooseItemView:new()
	_layer = _instance:create(goodsStr, _type)
	LayerManager.addLayoutNoScale(_layer)
	onListView(_layer.LSV_MAIN, SCROLLVIEW_EVENT_SCROLLING)
end
