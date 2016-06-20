-- FileName: OpenGiftsView.lua
-- Author: zhangqi
-- Date: 2014-07-16
-- Purpose: 得到多个物品时的展示面板UI，例如道具背包中使用vip礼包
--[[TODO List]]

module("OpenGiftsView", package.seeall)

-- UI控件引用变量 --
local m_layMain

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

local function init(...)
	m_layMain = nil
end

function destroy(...)
	package.loaded["OpenGiftsView"] = nil
end

function moduleName()
    return "OpenGiftsView"
end

local function createGiftList( tbGifts )
	logger:debug("createGiftList")
	logger:debug(tbGifts)
	
	local lsvGift = m_fnGetWidget(m_layMain, "LSV_OPEN_GIFT")
	UIHelper.initListView(lsvGift)

	local nIdx, cell = 0, nil
	for i, gift in ipairs(tbGifts) do
		lsvGift:pushBackDefaultItem()

    	nIdx = i - 1
    	cell = lsvGift:getItem(nIdx)  -- cell 索引从 0 开始

    	local layIcon = m_fnGetWidget(cell, "LAY_ITEM_ICON") -- 物品图标
    	UIHelper.addBtnToLayout(gift.icon, layIcon)

    	local labType = m_fnGetWidget(cell, "TFD_ITEM_TYPE") -- 类型文字
    	labType:setText(gift.sign) -- zhangqi, 2015-09-24

    	local labName = m_fnGetWidget(cell, "TFD_ITEM_NAME") -- 名称
    	labName:setColor(g_QulityColor[tonumber(gift.item.quality)])
		UIHelper.labelEffect(labName, gift.item.name)

    	local i18nNum = m_fnGetWidget(cell, "TFD_ITEM_NUM_WORD") -- 数量标题
    	UIHelper.labelEffect(i18nNum, m_i18n[1332])

    	local labNum = m_fnGetWidget(cell, "TFD_ITEM_NUM") -- 数量值
    	labNum:setText(gift.num)

    	local labDesc = m_fnGetWidget(cell, "TFD_ITEM_DESC") -- 物品描述
    	labDesc:setText(gift.item.desc)
	end
end

--[[
tbInfo = {sTitle = "", tbGift = {},}
{item = tbItem, icon = btnIcon, sign = signPath, num = tbGift.num or 1, name, quality}
]]
function create(tbInfo)
	init()

	m_layMain = g_fnLoadUI("ui/bag_open_gift_several.json")

	local btnClose = m_fnGetWidget(m_layMain, "BTN_CLOSE") -- 关闭按钮
	btnClose:addTouchEventListener(UIHelper.onClose)

	local btnOk = m_fnGetWidget(m_layMain, "BTN_CERTAIN") -- 确定按钮
	btnOk:addTouchEventListener(UIHelper.onClose)
	UIHelper.titleShadow(btnOk, m_i18n[1029])

	local i18nTitle2 = m_fnGetWidget(m_layMain, "TFD_COMMON_TITLE")
	UIHelper.labelEffect(i18nTitle2, m_i18n[1901])

	createGiftList(tbInfo.tbGift)

	return m_layMain
end
