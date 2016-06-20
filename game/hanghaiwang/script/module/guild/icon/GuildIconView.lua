-- FileName: GuildIconView.lua
-- Author: huxiaozhou
-- Date: 2015-03-31
-- Purpose:联盟新增图标选择界面
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("GuildIconView", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
local m_LSV_View
local arrowUp -- 向上箭头
local arrowDown -- 向下箭头
local selectedIcon
-- 模块局部变量 --
local json = "ui/union_flag.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local sIconPath = "images/union/flag/"

local m_tbEvent

local function init(...)
	m_mainWidget = nil
	m_LSV_View = nil
	arrowUp = nil
	arrowDown = nil
	selectedIcon = nil
end

function destroy(...)
	init()
	package.loaded["GuildIconView"] = nil
end

function moduleName()
    return "GuildIconView"
end

local function updateSelected(bEnable)
	if selectedIcon then
		local widget = selectedIcon:getParent()
		logger:debug(tolua.type(widget))
		local imgChoose = m_fnGetWidget(widget, "IMG_CHOOSE")
		imgChoose:setEnabled(bEnable)
	end
end

local function loadCell( cell,tbInfo, index)
	local tbData = tbInfo
	for i=1,4 do
		local lay_clone = m_fnGetWidget(cell, "LAY_CLONE" .. i)
		if i > #tbInfo then
			lay_clone:setEnabled(false)
		else
			local imgFlag = m_fnGetWidget(lay_clone, "IMG_FLAG")
			imgFlag:setTouchEnabled(true)
			imgFlag:setTag(tonumber(tbInfo[i]))
			imgFlag:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					logger:debug("choose ONE id = %s",sender:getTag())
					updateSelected(false)
					selectedIcon = sender
					m_tbEvent.onIcon(sender, eventType)
					updateSelected(true)
				end
			end)
			imgFlag:loadTexture(sIconPath .. GuildUtil.getLogoDataById(tbInfo[i]).img)
			local imgChoose = m_fnGetWidget(lay_clone, "IMG_CHOOSE")
			local logoId = GuildDataModel.getGuildIconId()
			logger:debug("logoId = %s",logoId)
			if tonumber(logoId) == tonumber(tbInfo[i])then
				selectedIcon = imgFlag
				imgChoose:setEnabled(true)
			else
				imgChoose:setEnabled(false)
			end

			
		end
	end
end

local function loadUI( ... )
	
	m_LSV_View = m_fnGetWidget(m_mainWidget,"LSV_MAIN") --listview
	-- arrowUp = m_fnGetWidget(m_mainWidget, "IMG_ARROW_UP") -- 向上箭头
	-- arrowUp:setEnabled(true)
	-- arrowUp:setVisible(true)
	-- arrowDown = m_fnGetWidget(m_mainWidget, "IMG_ARROW_DOWN") -- 向下箭头
	UIHelper.initListView(m_LSV_View)
	local tbIconData = GuildUtil.getAllIcons()
	local cell, nIdx
	for i,itemInfo in ipairs(tbIconData or {}) do
		m_LSV_View:pushBackDefaultItem()	
		nIdx = i - 1
		cell = m_LSV_View:getItem(nIdx) 
		logger:debug(cell)
    	loadCell(cell,itemInfo,i)
	end
	logger:debug("nIdx = %s",nIdx)

	local btnClose = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
	btnClose:addTouchEventListener(m_tbEvent.onClose)
end

function create(tbEvent)
	init()
	m_tbEvent = tbEvent
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	loadUI()
	return m_mainWidget
end
