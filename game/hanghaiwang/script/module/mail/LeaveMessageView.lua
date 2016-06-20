-- FileName: LeaveMessageView.lua
-- Author:zhangjunwu
-- Date: 2014-06-02
-- Purpose: 邮件回复留言界面
--[[TODO List]]

module("LeaveMessageView", package.seeall)
-- +-------+-------+------+
-- | uid   | uname | pid  |
-- +-------+-------+------+
-- | 20440 | 1231  | 1231 |
-- +-------+-------+------+
-- mysql> select uid,uname,pid from t_user where pid = 0509;
-- +-------+-------+-----+
-- | uid   | uname | pid |
-- +-------+-------+-----+
-- | 20522 | 0509  | 509 |
-- +-------+-------+-----+
-- UI控件引用变量 --
local m_editBoxBg = nil  	--输入框背景
local m_message_input = nil --输入框
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local function init(...)

end

function destroy(...)
	package.loaded["LeaveMessageView"] = nil
end

function moduleName()
	return "LeaveMessageView"
end
function getMessage( ... )
	return m_message_input:getText()
end
--创建输入框
function createEditBox( ... )
	-- 文本框
	require "script/module/public/UIHelper"
	logger:debug(m_editBoxBg:getSize())
	local size = m_editBoxBg:getSize()
	m_message_input = UIHelper.createEditBox(CCSizeMake(size.width, size.height),"images/base/potential/input_name_bg1.png",true,kCCVerticalTextAlignmentTop)
	--account_input:setFontColor(ccc3(255,0, 0));
	m_message_input:setPlaceHolder(m_i18n[2163]);
	m_message_input:setMaxLength(40);
	m_message_input:setPlaceholderFontColor(ccc3(0x82, 0x56, 0x00))
	m_message_input:setReturnType(kKeyboardReturnTypeDone)
	m_message_input:setInputFlag (kEditBoxInputFlagInitialCapsWord)

	m_editBoxBg:addNode(m_message_input)
end

--[[desc:功能简介
    arg1:  type，从何处调用改界面
    return: 是否有返回值，返回值说明  
—]]
function create(tbBtnEvent,_type)
	init()
	m_UIMain = g_fnLoadUI("ui/mail_message.json")

	local btnSend = m_fnGetWidget(m_UIMain, "BTN_SEND")				--发送按钮
	local btnBack = m_fnGetWidget(m_UIMain, "BTN_BACK")				--返回按钮
	local btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")			--取消按钮

	-- local TFD_TITLE= m_fnGetWidget(m_UIMain,"TFD_TITLE")			--好友留言
	-- TFD_TITLE:setText(m_i18nString(2158))

	m_editBoxBg = m_fnGetWidget(m_UIMain,"IMG_TYPE_WORDS")

	UIHelper.titleShadow(btnSend,m_i18n[2159])
	UIHelper.titleShadow(btnBack,m_i18n[1019])

	btnSend:addTouchEventListener(tbBtnEvent.onSend) 				--注册发送按钮
	btnBack:addTouchEventListener(tbBtnEvent.onBack) 				--注册返回按钮
	btnClose:addTouchEventListener(tbBtnEvent.onBack) 				--注册取消按钮
	--创建输入框
	--createEditBox()


	if(_type == LeaveMessageCtrl.LeaveMessageType.KTypeLeaveGuild) then
		local  img_title = m_fnGetWidget(m_UIMain,"img_title")
		img_title:loadTexture("ui/title_friend_msg.png")

	end

	return m_UIMain
end

