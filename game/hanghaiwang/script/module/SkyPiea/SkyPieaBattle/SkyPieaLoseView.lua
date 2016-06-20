-- FileName: SkyPieaLoseView.lua
-- Author: menghao
-- Date: 2015-1-15
-- Purpose: 空岛战斗失败面板view


module("SkyPieaLoseView", package.seeall)


-- UI控件引用变量 --
local m_UIMain


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString = gi18nString

local function init(...)

end


function destroy(...)
	package.loaded["SkyPieaLoseView"] = nil
end


function moduleName()
	return "SkyPieaLoseView"
end


function create(...)
	m_UIMain = g_fnLoadUI("ui/air_lose.json")

	local tfd_txt = m_fnGetWidget(m_UIMain, "tfd_txt")
	tfd_txt:setText(m_i18nString(1996))

	local imgTitle = m_fnGetWidget(m_UIMain, "IMG_TITLE")
	local imgBG = m_fnGetWidget(m_UIMain, "IMG_BG")
	EffBattleLose:new(imgBG, imgTitle)

	local function quitBattle( ... )
		AudioHelper.resetAudioState() 
		LayerManager.removeLayout()
		EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
	end

	-- 下方三个按钮
	-- local btnSure = m_fnGetWidget(m_UIMain, "BTN_CONFIRM1")
	local LAY_FIT = m_fnGetWidget(m_UIMain, "LAY_FIT")
	LAY_FIT:setTouchEnabled(true)
	LAY_FIT:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			quitBattle()
		end
	end)

	-- 提升相关
	local imgCry = m_fnGetWidget(m_UIMain, "img_cry")
	-- local tfdInfo = m_fnGetWidget(m_UIMain, "TFD_INFO")
	local btnEquip = m_fnGetWidget(m_UIMain, "BTN_ZHUANGBEI")
	local btnBuZhen = m_fnGetWidget(m_UIMain, "BTN_MINGJIANG")
	local btnHero = m_fnGetWidget(m_UIMain, "BTN_WUJIANG")

	-- tfdInfo:setText(gi18nString(1346, ""))

	btnHero:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			quitBattle()
			require "script/module/partner/MainPartner"
			LayerManager.changeModule(MainPartner.create(), MainPartner.moduleName(), {1, 3})
			PlayerPanel.addForPartnerStrength()
			require "script/module/main/MainScene"
			MainScene.changeMenuCircle(1)
		end
	end)

	btnEquip:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			quitBattle()
			require "script/module/equipment/MainEquipmentCtrl"
			LayerManager.changeModule(MainEquipmentCtrl.create(), MainEquipmentCtrl.moduleName(), {1, 3})
			PlayerPanel.addForPartnerStrength()
			require "script/module/main/MainScene"
			MainScene.changeMenuCircle(1)
		end
	end)

	btnBuZhen:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			quitBattle()
			require "script/module/formation/MainFormation"
			LayerManager.changeModule(MainFormation.create(0), MainFormation.moduleName(), {1,3}, true)
			require "script/module/main/MainScene"
			MainScene.changeMenuCircle(2)
		end
	end)

	return m_UIMain
end

