-- FileName: TreaAlert.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 消费金币购买专属宝物提示面板
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("TreaAlert", package.seeall)

local _tbEvent
local _mainWidget
local json = "ui/special_shop_tip_total.json"

local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["TreaAlert"] = nil
end

function moduleName()
    return "TreaAlert"
end

function create(tbData,fnConfirm)
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

	_mainWidget.TFD_GOLD_NUM:setText(tbData.costNum)

	LayerManager.addLayout(_mainWidget)
end
