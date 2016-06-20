-- FileName: FragmentInfoView.lua
-- Author: menghao
-- Date: 2014-5-13
-- Purpose: 碎片信息view


module("FragmentInfoView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_btnClose
local m_tfdItemName
local m_tfdItemIntroduce
local m_tfdFinish
local m_labnNumHave
local m_labnNumNeed
local m_tfdNum
local m_imgItemBg
local m_imgItemIcon


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local mi18n = gi18n


local function init(...)

end


function destroy(...)
	package.loaded["FragmentInfoView"] = nil
end


function moduleName()
	return "FragmentInfoView"
end


function create(tbInfo)
	if tonumber(tbInfo.numNeed) <= tonumber(tbInfo.numHave) then
		m_UIMain = g_fnLoadUI("ui/treasure_fragment_info.json")
	else
		m_UIMain = g_fnLoadUI("ui/treasure_fragment_info_grab.json")
		local btnGrab = m_fnGetWidget(m_UIMain, "BTN_GRAB")
		UIHelper.titleShadow(btnGrab, mi18n[2419])
		btnGrab:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()

				function createView( ... )
					local layGrabTreasure = RobTreasureCtrl.create(tbInfo.id)
					LayerManager.changeModule(layGrabTreasure, RobTreasureCtrl.moduleName(), {1, 3}, true)
					PlayerPanel.addForGrab()
				end

				TreasureService.getRecRicher(createView,tbInfo.id)
			end
		end)
	end

	-- 获取各控件
	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")

	m_tfdItemName = m_fnGetWidget(m_UIMain, "TFD_ITEM_NAME")
	m_tfdItemIntroduce = m_fnGetWidget(m_UIMain, "TFD_ITEM_DESC")
	m_tfdFinish = m_fnGetWidget(m_UIMain, "TFD_FINISH")
	m_labnNumHave = m_fnGetWidget(m_UIMain, "LABN_NUM")
	m_labnNumNeed = m_fnGetWidget(m_UIMain, "LABN_NUM_ALL")
	m_tfdNum = m_fnGetWidget(m_UIMain, "TFD_NUM")

	m_imgItemBg = m_fnGetWidget(m_UIMain, "IMG_ITEM_BG")
	m_imgItemIcon = m_fnGetWidget(m_UIMain, "IMG_ITEM_ICON")

	local tfdCollect = m_fnGetWidget(m_UIMain, "TFD_COLLECT")
	local tfdElse = m_fnGetWidget(m_UIMain, "TFD_ELSE")

	UIHelper.labelEffect(tfdCollect, mi18n[1096])
	UIHelper.labelEffect(tfdElse, mi18n[2421])

	-- 初始化UI
	m_btnClose:addTouchEventListener(tbInfo.onClose)

	m_tfdItemName:setColor(g_QulityColor[tbInfo.quality])
	UIHelper.labelEffect(m_tfdItemName, tbInfo.fragmentName)
	m_tfdItemIntroduce:setText(tbInfo.fragmentIntroduce)
	m_tfdFinish:setText(mi18n[2447])
	m_labnNumHave:setStringValue(tbInfo.numHave)
	m_labnNumNeed:setStringValue(tbInfo.numNeed)
	UIHelper.labelEffect(m_tfdNum, tbInfo.numNeed)

	local icon = ItemUtil.createBtnByTemplateId(tbInfo.id)
	m_imgItemIcon:addChild(icon)

	return m_UIMain
end

