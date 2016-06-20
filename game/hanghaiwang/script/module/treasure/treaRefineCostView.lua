-- FileName: treaRefineCostView.lua
-- Author: menghao
-- Date: 2014-12-12
-- Purpose: 宝物精炼消耗预览view


module("treaRefineCostView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_btnClose
local m_btnConfirm
local m_lsvConsume


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName


local function init(...)

end


function destroy(...)
	package.loaded["treaRefineCostView"] = nil
end


function moduleName()
	return "treaRefineCostView"
end


function create( tbAllCostInfo, itemID)
	logger:debug(tbAllCostInfo)
	m_UIMain= g_fnLoadUI("ui/treasure_refine_consume.json")

	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	m_btnConfirm = m_fnGetWidget(m_UIMain, "BTN_CONFIRM")

	m_btnClose:addTouchEventListener(UIHelper.onClose)
	UIHelper.titleShadow(m_btnConfirm, gi18n[2629])
	m_btnConfirm:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
		end
	end)

	m_lsvConsume = m_fnGetWidget(m_UIMain, "LSV_CONSUME")
	UIHelper.initListViewCell(m_lsvConsume)
	UIHelper.reloadListView(m_lsvConsume, #tbAllCostInfo, function ( lsv, idx )
		local item = m_lsvConsume:getItem(idx)

		local labnLv1 = m_fnGetWidget(item, "LABN_LV1")
		local labnLv2 = m_fnGetWidget(item, "LABN_LV2")
		local tfdInfo = m_fnGetWidget(item, "TFD_INFO")
		labnLv1:setStringValue(idx)
		labnLv2:setStringValue(idx + 1)
		tfdInfo:setText(gi18nString(1730, idx, idx + 1))

		local v = tbAllCostInfo[idx + 1]

		for i=1,4 do
			local layItem = m_fnGetWidget(item, "LAY_ITEM_CELL" .. i)
			local imgItem = m_fnGetWidget(layItem, "IMG_ITEM1")
			local tfdItemName = m_fnGetWidget(layItem, "TFD_ITEM_NAME")

			if (v[i]) then
				local btnIcon,tbItemInfo = ItemUtil.createBtnByTemplateIdAndNumber(v[i].tid, v[i].num, function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playInfoEffect()
						require "script/module/treasure/NewTreaInfoCtrl"
						NewTreaInfoCtrl.create(v[i].tid, 3)
					end
				end)
				imgItem:removeAllChildren()
				imgItem:addChild(btnIcon)
				tfdItemName:setText(tbItemInfo.name)
			else
				layItem:setEnabled(false)
			end
		end
	end)

	return m_UIMain
end


function adjustLsv( lv )
	logger:debug(lv)
	local height = m_lsvConsume:getItemsMargin() + m_lsvConsume:getItem(0):getSize().height
	local lsvHeight = m_lsvConsume:getSize().height

	performWithDelay(m_UIMain, function ( ... )
		m_lsvConsume:setContentOffset(ccp(0, lv * height + lsvHeight - m_lsvConsume:getInnerContainerSize().height))
	end, 0.001)
end

