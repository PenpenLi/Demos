-- FileName: ShowGetView.lua
-- Author: menghao
-- Date: 2014-11-15
-- Purpose: 获取到宝物或者宝物碎片显示ctrl
--[[TODO List]]


module("ShowGetView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_imgBlack
local m_imgBG
local m_tfdCongratulations
local m_tfdItemName
local m_imgItemBG


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName


local function init(...)

end


function destroy(...)
	package.loaded["ShowGetView"] = nil
end


function moduleName()
	return "ShowGetView"
end


function create(itemID, itemName, call)
	m_UIMain = g_fnLoadUI("ui/treasure_get_info.json")

	-- 增加屏蔽
	local popLayer = OneTouchGroup:create()
	popLayer:setTouchPriority(g_tbTouchPriority.explore)
	CCDirector:sharedDirector():getRunningScene():addChild(popLayer)

	m_imgBlack = m_fnGetWidget(m_UIMain, "img_black")
	m_imgBG = m_fnGetWidget(m_UIMain, "img_txt_bg")
	m_tfdCongratulations = m_fnGetWidget(m_UIMain, "tfd_congratulations")
	m_tfdItemName = m_fnGetWidget(m_UIMain, "TFD_ITEM_NAME")
	m_imgItemBG = m_fnGetWidget(m_UIMain, "IMG_ITEM_BG")

	m_tfdItemName:setText(itemName)
	local icon, itemData= ItemUtil.createBtnByTemplateId(itemID)
	m_imgItemBG:addChild(icon)
	m_tfdItemName:setColor(g_QulityColor2[itemData.quality])
	if (itemData.isTreasureFragment) then
		m_tfdCongratulations:setText(gi18n[5525])
	else
		m_tfdCongratulations:setText(gi18n[1604])
	end

	local actions = CCArray:create()
	actions:addObject(CCDelayTime:create(0.3))
	actions:addObject(CCShow:create())
	actions:addObject(CCEaseSineOut:create(CCMoveTo:create(0.3, ccp(g_winSize.width * 0.5,g_winSize.height * 0.5 + 100))))
	actions:addObject(CCDelayTime:create(0.6))
	actions:addObject(CCMoveBy:create(0.3, ccp(0,600)))
	actions:addObject(CCHide:create())
	actions:addObject(CCCallFunc:create(function ( ... )
		popLayer:removeFromParentAndCleanup(true)
		if (call) then
			call()
		end
	end))

	m_imgBlack:setScale(g_fScaleX)
	m_imgBlack:runAction(CCSequence:create(actions))

	return m_UIMain
end

