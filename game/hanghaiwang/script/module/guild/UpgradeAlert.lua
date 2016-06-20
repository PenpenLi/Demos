-- FileName: UpgradeAlert.lua
-- Author: huxiaozhou
-- Date: 2014-09-19
-- Purpose: function description of module
--[[TODO List]]
-- 升级建筑前的提示

module("UpgradeAlert", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
-- 模块局部变量 --
local json = "ui/union_level_up.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbContent

local tbbuiding_infos = {}
tbbuiding_infos["hall"] = {}
tbbuiding_infos["hall"].name = "\"" .. m_i18n[3701] .. "\""--"联盟大厅"
tbbuiding_infos["hall"].sType = "hall"
tbbuiding_infos["hall"].nType = 1

tbbuiding_infos["guanyu"] = {}
tbbuiding_infos["guanyu"].name = "\"" .. m_i18n[3721] .. "\"" --"人鱼咖啡厅"
tbbuiding_infos["guanyu"].sType = "guanyu"
tbbuiding_infos["guanyu"].nType = 2

tbbuiding_infos["shop"] = {}
tbbuiding_infos["shop"].name =  "\"" .. m_i18n[3816] .. "\""  --联盟商店
tbbuiding_infos["shop"].sType = "shop"
tbbuiding_infos["shop"].nType = 3

tbbuiding_infos["copy"] = {}
tbbuiding_infos["copy"].name =  "\"" .. m_i18n[5955] .. "\""  --联盟副本
tbbuiding_infos["copy"].sType = "copy"
tbbuiding_infos["copy"].nType = 4

local function init(...)

end

function destroy(...)
	package.loaded["UpgradeAlert"] = nil
end

function moduleName()
    return "UpgradeAlert"
end



-- 升级回调
function upgradeCallback( cbFlag, dictData, bRet  )
	if(dictData.err == "ok")then
		GuildDataModel.addGuildDonate(-m_tbContent.cost)
		GuildDataModel.addGuildLevelBy(tbbuiding_infos[m_tbContent.sType].nType+1, 1, m_tbContent.cost)
		-- 回调
		if (m_tbContent.confirmCBFunc) then
			m_tbContent.confirmCBFunc(m_tbContent.sType)
		end
		LayerManager.removeLayout()
	end
end

-- 确认按钮 事件
function fnConfirm( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local args = Network.argsHandler(tbbuiding_infos[m_tbContent.sType].nType)
		RequestCenter.guild_upgradeGuild(upgradeCallback, args)
	end
end

-- 取消按钮 关闭按钮  事件
function fnClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
	end
end

function fnCancel (sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		LayerManager.removeLayout()
	end
end


function loadUI( ... )
	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE") --关闭按钮

	local BTN_CONFIRM = m_fnGetWidget(m_mainWidget, "BTN_CONFIRM")  -- 确认按钮
	local BTN_CANCEL = m_fnGetWidget(m_mainWidget, "BTN_CANCEL") -- 取消按钮
	BTN_CLOSE:addTouchEventListener(fnClose)
	BTN_CANCEL:addTouchEventListener(fnCancel)
	BTN_CONFIRM:addTouchEventListener(fnConfirm)

	UIHelper.titleShadow(BTN_CONFIRM, m_i18n[1324])
	UIHelper.titleShadow(BTN_CANCEL, m_i18n[1325])

	-- local TFD_TITLE = m_fnGetWidget(m_mainWidget, "TFD_TITLE") -- 建筑升级
	local tfd_info2 = m_fnGetWidget(m_mainWidget, "tfd_info2") -- 联盟建筑等级无法超过联盟大厅等级

	local LAY_FIT1 = m_fnGetWidget(m_mainWidget, "LAY_FIT1")
	local LAY_FIT2 = m_fnGetWidget(m_mainWidget, "LAY_FIT2")

	local tfd_spend = m_fnGetWidget(LAY_FIT1, "tfd_spend") -- 花费
	tfd_spend:setText(m_i18n[5707])

	local TFD_SPEND_NUM = m_fnGetWidget(LAY_FIT1, "TFD_SPEND_NUM") 

	local tfd_jianshedu = m_fnGetWidget(LAY_FIT1, "tfd_jianshedu") --联盟建设度
	tfd_jianshedu:setText(m_i18n[3751])
	local tfd_can = m_fnGetWidget(LAY_FIT2, "tfd_can") --可将

	local TFD_CURRENT = m_fnGetWidget(LAY_FIT2, "TFD_CURRENT")
	TFD_CURRENT:setText(m_tbContent.curLv)

	-- local TFD_BUILDING = m_fnGetWidget(LAY_FIT2, "TFD_BUILDING") 
	-- TFD_BUILDING:setText("由")

	local TFD_NEXT = m_fnGetWidget(LAY_FIT2, "TFD_NEXT")
	TFD_NEXT:setText(m_tbContent.curLv + 1)

	local TFD_BUILDING_1 = m_fnGetWidget(LAY_FIT2, "TFD_BUILDING_1")
	TFD_BUILDING_1:setText(m_i18n[3586])
	TFD_SPEND_NUM:setText(m_tbContent.cost)
	m_mainWidget.tfd_ji:setText(m_i18n[3643])

	if m_tbContent.sType == "hall" then
		tfd_info2:removeFromParentAndCleanup(true)
		tfd_can:setText(m_i18nString(3585,tbbuiding_infos["hall"].name))
	else
		tfd_can:setText(m_i18nString(3585,tbbuiding_infos[m_tbContent.sType].name))
		tfd_info2:setText(m_i18n[3573])
	end

end


--[[
tbParams = {
	 sType = 建筑类型  hall  guanyu
	cost = 花费多少建设度
	curLv = 当前等级
	confirmCBFunc = 确认回调
	}
--]]

function create(tbParams)
	m_tbContent = tbParams
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	loadUI()
	-- return m_mainWidget
	LayerManager.addLayout(m_mainWidget)
end
