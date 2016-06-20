-- FileName: MainAchieveView.lua
-- Author: huxiaozhou
-- Date: 2014-11-10
-- Purpose: function description of module
-- 每日任务和 成就系统的 标签显示页


module("MainAchieveView", package.seeall)
require "script/module/dailyTask/MainDailyTaskData"
local json = "ui/achievement_tab.json"
local m_i18n = gi18n
local m_i18nString = gi18nString


-- UI控件引用变量 --

local m_selectedBtn --被选中的按钮

-- 模块局部变量 --
local m_tbEvent
local m_mainWidget
local m_fnGetWidget = g_fnGetWidgetByName

local function init(...)
	m_tbEvent = nil
	m_selectedBtn = nil
end

function destroy(...)
	package.loaded["MainAchieveView"] = nil
end

function moduleName()
    return "MainAchieveView"
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
		m_selectedBtn:setTitleColor(ccc3(0xbf,0x93,0x67))
	end
	if localBtn then
		-- m_selectedBtn:setTitleColor(ccc3(0xbf,0x93,0x67))
		m_selectedBtn = localBtn
		m_selectedBtn:setTitleColor(ccc3(255,255,255))
		m_selectedBtn:setFocused(true)
	end
end


function updateUI()
	local BTN_TAB1 = m_fnGetWidget(m_mainWidget, "BTN_TAB1") -- 每日任务按钮
	BTN_TAB1:setTag(1)
	-- UIHelper.titleShadow(BTN_TAB1, m_i18n[1982])
	BTN_TAB1:setTitleText(m_i18n[1982])

	local BTN_TAB2 = m_fnGetWidget(m_mainWidget, "BTN_TAB2") -- 成就系统按钮
	BTN_TAB2:setTag(2)
	BTN_TAB2:setTitleText(m_i18n[1995]) --TODO
	-- UIHelper.titleShadow(BTN_TAB2,"成就") 

	local BTN_BACK = m_fnGetWidget(m_mainWidget, "BTN_BACK") -- 返回按钮

	UIHelper.titleShadow(BTN_BACK, m_i18n[1019])

	local imgBg   = m_fnGetWidget(m_mainWidget,"img_bg")
	imgBg:setScale(g_fScaleX)

	local layEasyInfo = m_fnGetWidget(m_mainWidget,"lay_easy_info")
	layEasyInfo:setScale(g_fScaleX)

	local imgSmallBag = m_fnGetWidget(m_mainWidget,"img_small_bg")
	imgSmallBag:setScale(g_fScaleX)

	local imgChain    = m_fnGetWidget(m_mainWidget,"img_chain")
	imgChain:setScale(g_fScaleX)
	
	local dailyTaskNum  = m_fnGetWidget(m_mainWidget,"LABN_NUM")
	local imgTaskTip 	= m_fnGetWidget(m_mainWidget,"IMG_TAB_TIPS")
	if tonumber(MainDailyTaskData.getRewardAbleNum()) ~= 0 then
		dailyTaskNum:setStringValue(MainDailyTaskData.getRewardAbleNum())
	else
		imgTaskTip:setVisible(false)
	end

	BTN_TAB1:addTouchEventListener(m_tbEvent.onTask)
	BTN_TAB2:addTouchEventListener(m_tbEvent.onAchieve)

	BTN_BACK:addTouchEventListener(m_tbEvent.onBack)
	btnSelectFunc(BTN_TAB1)
end

function updateRedPoint()
	local BTN_TAB2 = m_fnGetWidget(m_mainWidget, "BTN_TAB2") 
	local achieveNum  = m_fnGetWidget(BTN_TAB2,"LABN_NUM")
	local imgTip 	= m_fnGetWidget(BTN_TAB2,"IMG_TAB_TIPS")
	if tonumber(AchieveModel.getTotalUnRewardNum()) ~= 0 then
		imgTip:setEnabled(true)
		achieveNum:setStringValue(AchieveModel.getTotalUnRewardNum())
	else
		imgTip:setEnabled(false)
	end

end

function create(tbEvent)
	init()
	m_tbEvent = tbEvent
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	updateUI()
	updateRedPoint()
	return m_mainWidget
end
