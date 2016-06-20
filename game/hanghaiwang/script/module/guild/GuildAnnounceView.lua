-- FileName: GuildAnnounceView.lua
-- Author: huxiaozhou
-- Date: 2014-09-16
-- Purpose: function description of module
--[[TODO List]]
-- 工会宣言 显示器

module("GuildAnnounceView", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
-- 模块局部变量 --
local json = "ui/union_announce.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent

local m_announceBox

local m_sType

local function init(...)

end

function destroy(...)
	package.loaded["GuildAnnounceView"] = nil
end

function moduleName()
    return "GuildAnnounceView"
end

local function loadUI(  )
	-- local i18nTFD_TITLE = m_fnGetWidget(m_mainWidget,"TFD_TITLE") -- 联盟公告
	-- i18nTFD_TITLE:removeFromParentAndCleanup(true)
	local i18nTFD_MOST = m_fnGetWidget(m_mainWidget, "TFD_MOST") -- 最多可以输入25个字

	local IMG_TYPE = m_fnGetWidget(m_mainWidget, "IMG_TYPE") -- 可输入框的背景

	local img_title_xuanyan = m_fnGetWidget(m_mainWidget, "img_title_xuanyan")
	local img_title_gonggao = m_fnGetWidget(m_mainWidget, "img_title_gonggao")

	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE") --关闭按钮
	local BTN_CONFIRM = m_fnGetWidget(m_mainWidget, "BTN_CONFIRM") -- 确定按钮
	local BTN_CANCEL = m_fnGetWidget(m_mainWidget, "BTN_CANCEL") -- 取消按钮
	BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)
	BTN_CANCEL:addTouchEventListener(m_tbEvent.fnCancel)
	BTN_CONFIRM:addTouchEventListener(m_tbEvent.fnConfirm)
	
	UIHelper.titleShadow(BTN_CONFIRM, m_i18n[1324])
	
	UIHelper.titleShadow(BTN_CANCEL, m_i18n[1325])
	local size = IMG_TYPE:getSize()
	logger:debug("size.width = %s",size.width)
	logger:debug("size.height = %s", size.height)
	m_announceBox = UIHelper.createEditBox(CCSizeMake(size.width-6, size.height), "images/base/potential/input_name_bg1.png", true)
	m_announceBox:setFontSize(26)
	local c3Font = ccc3(0x82, 0x56, 0x00) -- zhangqi, 2015-10-13
	m_announceBox:setAnchorPoint(ccp(0.5, 0.5))

	-- 清理一下当前弹出层的触摸状态，解决点击按钮同时点击editbox再放开导致的所有按钮无响应问题
	local function editboxCommonHandler(eventType, sender)
		if eventType == "began" then
			local lab = sender:getChildByTag(1001)
			local x,y = sender:getPosition()
			lab:setVisible(false)
			sender:setPosition(ccp(x,y))
			sender:setText(lab:getString())
			-- triggered when an edit box gains focus after keyboard is shown
		elseif eventType == "ended" then
		-- triggered when an edit box loses focus after keyboard is hidden.
		elseif eventType == "changed" then
		-- triggered when the edit box text was changed.
		elseif eventType == "return" then
			-- triggered when the return button was pressed or the outside area of keyboard was touched.
			logger:debug("return, text = %s", sender:getText())
			local lab = sender:getChildByTag(1001)
			lab:setVisible(true)
			lab:setString(sender:getText())
			sender:setText("")
			UIHelper.clearTouchStat()
		end
	end


	local labttf = nil
	if(m_sType ~= nil and m_sType == "post") then
		img_title_gonggao:setEnabled(true)
		img_title_xuanyan:setEnabled(false)
		-- m_announceBox:setText(GuildDataModel.getPost())
		labttf = CCLabelTTF:create(GuildDataModel.getPost(), g_sFontName, 26, CCSizeMake(size.width-6, size.height), kCCTextAlignmentLeft, kCCVerticalTextAlignmentCenter)
		labttf:setString(GuildDataModel.getPost())
		m_announceBox:setText("")
		i18nTFD_MOST:setText(m_i18n[3561])
	else
		img_title_gonggao:setEnabled(false)
		img_title_xuanyan:setEnabled(true)
		i18nTFD_MOST:setText(m_i18n[3533])
		-- m_announceBox:setText(GuildDataModel.getSlogan())
		labttf = CCLabelTTF:create(GuildDataModel.getSlogan(), g_sFontName, 26, CCSizeMake(size.width-6, size.height), kCCTextAlignmentLeft, kCCVerticalTextAlignmentCenter)
		labttf:setString(GuildDataModel.getSlogan())
		m_announceBox:setText("")
	end

	labttf:setColor(c3Font)
	m_announceBox:addChild(labttf, 1, 1001)
	labttf:setPosition(ccp(size.width*0.5, size.height*0.5))
	m_announceBox:registerScriptEditBoxHandler(editboxCommonHandler)
	
	m_announceBox:setPlaceholderFontColor(c3Font)
	m_announceBox:setMaxLength(200)
	m_announceBox:setReturnType(kKeyboardReturnTypeDone)
	m_announceBox:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	m_announceBox:setFontColor(c3Font)
	m_announceBox:setFontSize(26)
	IMG_TYPE:addNode(m_announceBox)

end

function getAnnounceText(  )
	return m_announceBox:getChildByTag(1001):getString()
end


function create(tbEvent, sType)
	init()
	m_sType = sType
	m_tbEvent = tbEvent
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	loadUI()
	return m_mainWidget
end
