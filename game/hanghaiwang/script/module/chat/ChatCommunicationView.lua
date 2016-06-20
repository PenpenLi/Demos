-- FileName: ChatCommunicationView.lua
-- Author: menghao
-- Date: 2014-06-07
-- Purpose: 点别人头像弹出框view


module("ChatCommunicationView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_btnClose
local m_btnAdd
local m_btnPrivate

local m_imgHead
local m_tfdLv
local m_labnFightValue
local m_tfdName


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName


local function init(...)

end


function destroy(...)
	package.loaded["ChatCommunicationView"] = nil
end


function moduleName()
	return "ChatCommunicationView"
end


function create(tbInfo, tbEventListener)
	logger:debug(tbInfo)
	m_UIMain = g_fnLoadUI("ui/chat_commnunication.json")

	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	m_btnAdd = m_fnGetWidget(m_UIMain, "BTN_ADD")
	m_btnPrivate = m_fnGetWidget(m_UIMain, "BTN_PRIVATE")

	m_imgHead = m_fnGetWidget(m_UIMain, "IMG_PHOTO")
	m_tfdLv = m_fnGetWidget(m_UIMain, "TFD_LV")
	m_labnFightValue = m_fnGetWidget(m_UIMain, "TFD_ZHANDOULI")
	m_tfdName = m_fnGetWidget(m_UIMain, "TFD_NAME")
	m_tfdName:setText(tbInfo.sender_uname)
	m_tfdName:setColor(UserModel.getPotentialColor({htid = tbInfo.figure})) -- zhangqi, 2015-07-28

	m_UIMain.BTN_PVP:addTouchEventListener(tbEventListener.onPVP)

	m_btnClose:addTouchEventListener(tbEventListener.onClose)
	m_btnAdd:addTouchEventListener(tbEventListener.onAdd)
	m_btnPrivate:addTouchEventListener(tbEventListener.onPrivate)

	UIHelper.titleShadow(m_UIMain.BTN_PVP, gi18n[6701]) 
	m_UIMain.BTN_PVP.tag = tbInfo.sender_uid
	UIHelper.titleShadow(m_btnAdd, gi18n[2810])
	UIHelper.titleShadow(m_btnPrivate, gi18n[2802])

	local heroIcon = HeroUtil.createHeroIconBtnByHtid(tbInfo.figure, nil, nil)
	m_imgHead:addChild(heroIcon)
	

	UIHelper.labelAddStroke(m_tfdLv, string.format("%s级",tbInfo.sender_level))

	m_labnFightValue:setText(tbInfo.sender_fight)

	return m_UIMain
end

