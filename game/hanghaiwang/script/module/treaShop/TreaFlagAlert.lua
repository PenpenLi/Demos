-- FileName: TreaFlagAlert.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 专属宝物碎片界面提示
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("TreaFlagAlert", package.seeall)

local _mainWidget
local json = "ui/special_shop_tip_frag.json"

local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)
	_fnConfirm = nil
end

function destroy(...)
	package.loaded["TreaFlagAlert"] = nil
end

function moduleName()
    return "TreaFlagAlert"
end

function create(tbData,fnConfirm, sType)
	init()
	_mainWidget = g_fnLoadUI(json)
	_mainWidget:setSize(g_winSize)

	_mainWidget.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	_mainWidget.BTN_BUY:addTouchEventListener(fnConfirm)

	UIHelper.labelShadowWithText(_mainWidget.TFD_BUY, m_i18n[1435])

	local  itemIcon,tbItemInfo = ItemUtil.createBtnByTemplateIdAndNumber(tbData.tid,tbData.num)
	local layGoods = _mainWidget.LAY_ITEM
	layGoods:addChild(itemIcon,-1)
	itemIcon:setPosition(ccp(layGoods:getSize().width*.5,layGoods:getSize().height*.5))

	_mainWidget.TFD_NAME:setText(tbItemInfo.name)
	_mainWidget.TFD_NAME:setColor(g_QulityColor[tonumber(tbItemInfo.quality)])
	
	local num, max = 0,0
	if sType == 1 then
		require "script/module/specialBag/SBListModel"
		num, max = SBListModel.getFragNumAndMaxByTid(tbData.tid)
	else
		local itemData = ItemUtil.getItemById(tbData.tid)
		num, max = itemData.nOwn, itemData.nMax
	end
	
		
	local tfdNumOwn = _mainWidget.TFD_NUM_OWN   -- 物品当前数量
	local tfdNumNeed = _mainWidget.TFD_NUM_NEED
	tfdNumOwn:setText(num)
	tfdNumNeed:setText(max)
	if tonumber(num)<tonumber(max) then
		tfdNumOwn:setColor(ccc3(0xd8, 0x14, 0x00))
	else
		tfdNumOwn:setColor(ccc3(0x00, 0x8a, 0x00))
	end


	_mainWidget.TFD_GOLD_NUM:setText(tbData.costNum)
	LayerManager.addLayout(_mainWidget)
end
