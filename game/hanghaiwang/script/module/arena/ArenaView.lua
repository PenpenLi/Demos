-- FileName: ArenaView.lua
-- Author: huxiaozhou
-- Date: 2014-12-10
-- Purpose: 竞技场 商店 排行 背景显示
-- /


module("ArenaView", package.seeall)

local arena_bg_json     = "ui/arena_bg.json"
local arena_yeqian_json = "ui/arena_yeqian.json"


-- UI控件引用变量 --
local m_selectedBtn --被选中的按钮

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString


local function init(...)
	m_selectedBtn = nil
end

function destroy(...)
	package.loaded["ArenaView"] = nil
end

function moduleName()
    return "ArenaView"
end


--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getSelectedBtnTag( )
	if m_selectedBtn then
		return m_selectedBtn:getTag()
	end
	return 1
end


--[[desc:创建页签和背景
    arg1: tbEvent 按钮事件的表
    return: 页签也和背景  
—]]

function btnSelectFunc( localBtn )
	if m_selectedBtn then
		m_selectedBtn:setFocused(false)
	end
	if localBtn then
		m_selectedBtn = localBtn
		m_selectedBtn:setFocused(true)
	end
end


function create(tbEvent, nType)
	init()
	local layBg = g_fnLoadUI(arena_bg_json)
	local arena_yeqian = g_fnLoadUI(arena_yeqian_json)
	layBg:addChild(arena_yeqian)
	local BTN1 = m_fnGetWidget(arena_yeqian, "BTN_1")
	local BTN2 = m_fnGetWidget(arena_yeqian, "BTN_2")

	BTN1:setTag(1)
	BTN2:setTag(2)

	local BTN_SHOP1 = m_fnGetWidget(arena_yeqian, "BTN_SHOP1")
	local BTN_SHOP2 = m_fnGetWidget(arena_yeqian, "BTN_SHOP2")
	BTN_SHOP1:setTag(1)
	BTN_SHOP2:setTag(2)

	if ArenaData.getBShowRedPoint() then
		BTN_SHOP2.IMG_SHOP_TIP:addNode(UIHelper.createRedTipAnimination())
	end

	logger:debug(nType)
	BTN1:addTouchEventListener(tbEvent.onBtn1)
	BTN2:addTouchEventListener(tbEvent.onBtn2)

	BTN_SHOP1:addTouchEventListener(tbEvent.onBtn1)
	BTN_SHOP2:addTouchEventListener(tbEvent.onBtn2)

	if tonumber(nType) == tonumber(ArenaCtrl.tbType.rank) then
		UIHelper.titleShadow(BTN1, m_i18n[2248])
		UIHelper.titleShadow(BTN2, m_i18n[2249])
		BTN_SHOP1:removeFromParent()
		BTN_SHOP2:removeFromParent()
		BTN_SHOP1 = nil
		BTN_SHOP2 = nil
		if(ArenaData.getRankListContainNPC()) then
			BTN2:removeFromParentAndCleanup(true)
		end
	else
		BTN1:removeFromParent()
		BTN2:removeFromParent()
		BTN1 = nil
		BTN2 = nil
		UIHelper.titleShadow(BTN_SHOP2, m_i18n[2250])
		UIHelper.titleShadow(BTN_SHOP1, m_i18n[2251])
	end
	btnSelectFunc(BTN1 or BTN_SHOP1)

	local BTN_BACK = m_fnGetWidget(arena_yeqian, "BTN_BACK")


	BTN_BACK:addTouchEventListener(tbEvent.onBack)
	UIHelper.titleShadow(BTN_BACK, m_i18n[1019])

	local IMG_BG = m_fnGetWidget(arena_yeqian, "IMG_BG")
	IMG_BG:setScale(g_fScaleX)
	local img_chain = m_fnGetWidget(arena_yeqian, "img_chain")
	img_chain:setScale(g_fScaleX)

	local img_bg = m_fnGetWidget(layBg, "IMG_BG")
	img_bg:setScale(g_fScaleX)
	return layBg
end
