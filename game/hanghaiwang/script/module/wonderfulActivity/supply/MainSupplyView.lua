-- FileName: MainSupplyView.lua
-- Author: huxiaozhou
-- Date: 2014-05-29
-- Purpose: function description of module
-- 吃烧鸡显示模块
--[[TODO List]]

module("MainSupplyView", package.seeall)
require "script/module/public/EffectHelper"
-- UI控件引用变量 --

-- 模块局部变量 --
local json = "ui/activity_power.json"
local m_fnGetWidget = g_fnGetWidgetByName --读取UI组件方法
local m_mainWidget 
local m_tbEvent -- 按钮事件
local m_IMG_PRESS_BG

local function init(...)
	tbBtn = {}
end

function destroy(...)
	package.loaded["MainSupplyView"] = nil
end

function moduleName()
    return "MainSupplyView"
end



function lodaUI(  )
	-- local i18nTFD_TITLE = m_fnGetWidget(m_mainWidget,"TFD_TITLE") --需要国际化的文本 "饮用弗兰奇特供可乐能够补充体力！"
	local i18ntfd_noon =  m_fnGetWidget(m_mainWidget,"tfd_noon") -- "中午"
	local i18ntfd_noon_time = m_fnGetWidget(m_mainWidget,"tfd_noon_time")  -- "12点~14点"
	-- local i18nTFD_TIME1 = m_fnGetWidget(m_mainWidget,"TFD_TIME1") --"时间已过"
	local i18ntfd_night = m_fnGetWidget(m_mainWidget,"tfd_night") -- "黄昏"
	local i18ntfd_night_time = m_fnGetWidget(m_mainWidget,"tfd_night_time") -- "18点~20点"
	-- local i18nTFD_TIME2 = m_fnGetWidget(m_mainWidget,"TFD_TIME2") -- "时间未到"
	local i18ntfd_info = m_fnGetWidget(m_mainWidget,"tfd_info") -- "喝完可乐，这周你会非常SUPER!"

	local BTN_EAT = m_fnGetWidget(m_mainWidget,"BTN_EAT") -- 吃的按钮
	local BTN_PRESS = m_fnGetWidget(m_mainWidget,"BTN_PRESS") -- 可乐按钮
	local BTN_PRESS1 = m_fnGetWidget(m_mainWidget,"BTN_PRESS1")
	local BTN_PRESS2 = m_fnGetWidget(m_mainWidget,"BTN_PRESS2")

	m_IMG_PRESS_BG = m_fnGetWidget(m_mainWidget, "IMG_PRESS_BG") -- 吃烧鸡的桌子
	local IMG_SHADOW = m_fnGetWidget(m_mainWidget, "IMG_SHADOW") -- 可乐瓶子的影子

	m_IMG_PRESS_BG:setScale(g_fScaleX)

	-- yucong 格式化成本地对应的时间
	m_mainWidget.tfd_noon_time:setText(SupplyModel.getPeriodDes_Noon())
	m_mainWidget.tfd_night_time:setText(SupplyModel.getPeriodDes_Evening())
	m_mainWidget.tfd_night_time_0:setText(SupplyModel.getPeriodDes_Night())

	local isOnTime = SupplyModel.isOnTime()

	local t = {"IMG_GAIZI", "IMG_GAIZI1", "IMG_GAIZI2"}
	for i,v in ipairs(t) do
		local img = m_fnGetWidget(m_mainWidget, v) 
		if not isOnTime then
			img:setEnabled(false)
		end
	end


	if(isOnTime) then
		BTN_PRESS:addTouchEventListener(m_tbEvent.onPower) --注册按钮事件
		BTN_EAT:addTouchEventListener(m_tbEvent.onPower)  --注册按钮事件
		BTN_PRESS1:addTouchEventListener(m_tbEvent.onPower)
		BTN_PRESS2:addTouchEventListener(m_tbEvent.onPower)

		m_mainWidget.IMG_HAND_EFFECT:addNode(EffGuide:new():Armature())

	else
		m_mainWidget.IMG_HAND_EFFECT:removeAllNodes()
		BTN_EAT:setEnabled(false)
		BTN_PRESS:setEnabled(false)
		BTN_PRESS1:setEnabled(false)
		BTN_PRESS2:setEnabled(false)
		IMG_SHADOW:setEnabled(false)
	end
end

function updateUI(  )
	m_mainWidget.IMG_HAND_EFFECT:removeAllNodes()
	local IMG_FULANQI_MEICHI = m_fnGetWidget(m_mainWidget,"IMG_FULANQI_MEICHI") --没吃前图片
	IMG_FULANQI_MEICHI:setEnabled(false)
	local BTN_EAT = m_fnGetWidget(m_mainWidget,"BTN_EAT") -- 吃的按钮
	local BTN_PRESS = m_fnGetWidget(m_mainWidget,"BTN_PRESS") -- 可乐按钮
	BTN_PRESS:setEnabled(false)
	BTN_EAT:setEnabled(false)
end

-- 添加动画
function addCokeAnimation(  )

	AudioHelper.playEffect("audio/effect/texiao_coke.mp3")

	local layPress = m_fnGetWidget(m_mainWidget, "LAY_PRESS")
	for i=1,3 do
		local zorder
		local BTN_PRESS 
		if (i==1) then
			zorder = 3
			BTN_PRESS = m_fnGetWidget(m_mainWidget,"BTN_PRESS") -- 可乐按钮
		else
			BTN_PRESS = m_fnGetWidget(m_mainWidget,"BTN_PRESS" .. (i-1))
		end
		BTN_PRESS:setEnabled(false)

		local t = {"IMG_GAIZI", "IMG_GAIZI1", "IMG_GAIZI2"}
		for i,v in ipairs(t) do
			local img = m_fnGetWidget(m_mainWidget, v) 
			img:setEnabled(false)
		end

		local perPos = BTN_PRESS:getPositionPercent()
		local cokeAnimation = EffCoke:new():Armature()

		cokeAnimation:setPosition(ccp(layPress:getSize().width*perPos.x+17, layPress:getSize().height*perPos.y))
		layPress:addNode(cokeAnimation,zorder or 1)
	end
	local BTN_EAT = m_fnGetWidget(m_mainWidget,"BTN_EAT")
	BTN_EAT:setEnabled(false)

end


function create(tbEvent)
	m_tbEvent = tbEvent
	init()
	m_mainWidget = g_fnLoadUI(json)
	lodaUI()
	m_mainWidget:setSize(g_winSize)
	return m_mainWidget
end
