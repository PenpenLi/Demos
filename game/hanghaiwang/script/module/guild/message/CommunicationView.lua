-- FileName: CommunicationView.lua
-- Author: zhangjunwu
-- Date: 2014-09-23
-- Purpose:留言板玩家头像弹出的面板
--[[TODO List]]

module("CommunicationView", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
local m_editBoxBg = nil  	----搜素输入框背景
local m_message_input = nil --输入框
local listView = nil

-- 模块局部变量 --
local json = "ui/union_communication.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent
local m_tbUserInfoData


local function init(...)
	m_tbUserInfoData = nil
end

function destroy(...)
	package.loaded["CommunicationView"] = nil
end

function moduleName()
	return "CommunicationView"
end

local function initBTN( ... )
	local LAY_1 = m_fnGetWidget(m_mainWidget,"LAY_1")   --自己点击自己后得情况
	local LAY_3 = m_fnGetWidget(m_mainWidget,"LAY_3")	--自己点击别人后得情况
	LAY_1:setEnabled(false)
	LAY_3:setEnabled(false)

	--关闭按钮
	local BTN_CLOSE = m_fnGetWidget(m_mainWidget,"BTN_CLOSE")
	BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)

	if(tostring(m_tbUserInfoData.uid) == tostring(UserModel.getUserUid())) then
		LAY_1:setEnabled(true)

		--查看信息按钮
		local BTN_FORMATION = m_fnGetWidget(LAY_1,"BTN_FORMATION")
		UIHelper.titleShadow(BTN_FORMATION,m_i18n[3652]) --查看信息
		BTN_FORMATION:addTouchEventListener(m_tbEvent.fnInfo)
		BTN_FORMATION:setTag(m_tbUserInfoData.uid)

		local img_bg = m_fnGetWidget(m_mainWidget,"img_bg")
		--img_bg:setScaleY(0.8)
		img_bg:setSize(CCSizeMake(img_bg:getVirtualRenderer():getContentSize().width,img_bg:getVirtualRenderer():getContentSize().height*0.8))
	else
		-- 添加好友
		LAY_3:setEnabled(true)
		--查看信息按钮
		local BTN_FORMATION = m_fnGetWidget(LAY_3,"BTN_FORMATION")
		UIHelper.titleShadow(BTN_FORMATION,m_i18n[3652])   --查看信息
		BTN_FORMATION:addTouchEventListener(m_tbEvent.fnInfo)
		BTN_FORMATION:setTag(m_tbUserInfoData.uid)


		local BTN_ADD = m_fnGetWidget(LAY_3,"BTN_ADD")
		local BTN_MAIL = m_fnGetWidget(LAY_3,"BTN_MAIL")

		if(m_tbUserInfoData.isFriend == true) then
			UIHelper.titleShadow(BTN_ADD,m_i18n[3659])  --已经是好友
			BTN_ADD:setGray(true)
		else
			UIHelper.titleShadow(BTN_ADD,m_i18n[2921])  --添加好友
			BTN_ADD:addTouchEventListener(m_tbEvent.fnAddFrd)
			BTN_ADD:setTag(m_tbUserInfoData.uid)
		end

		-- 发送邮件好友

		--UIHelper.titleShadow(BTN_MAIL,"发送邮件哦")
		BTN_MAIL:addTouchEventListener(m_tbEvent.fnSendMessage)
		BTN_MAIL:setTag(m_tbUserInfoData.uid)
		UIHelper.titleShadow(BTN_MAIL,m_i18n[3667])  --发送邮件

		local BTN_CHAT = m_fnGetWidget(LAY_3,"BTN_CHAT") --私聊
		UIHelper.titleShadow(BTN_CHAT,m_i18n[2802])  --添加好友
		BTN_CHAT:addTouchEventListener(m_tbEvent.fnChat)
		BTN_CHAT:setTag(m_tbUserInfoData.uid)

		UIHelper.titleShadow(LAY_3.BTN_PVP, gi18n[6701]) 
		LAY_3.BTN_PVP:addTouchEventListener(m_tbEvent.fnPVP)
		LAY_3.BTN_PVP.tag = m_tbUserInfoData.uid
	

	end


end

function create( tbEvent , tbUserInfoData)
	m_tbEvent = tbEvent
	m_tbUserInfoData  = tbUserInfoData
	logger:debug("和你交流的玩家信息是：")
	logger:debug(tbUserInfoData)

	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)

	--初始化按钮状态
	initBTN()

	local  TFD_NAME  = m_fnGetWidget(m_mainWidget,"TFD_NAME")   --名字
	TFD_NAME:setText(m_tbUserInfoData.uname)
	--玩家名字颜色
	local nameColor = UserModel.getPotentialColor({htid = m_tbUserInfoData.figure})
	TFD_NAME:setColor(nameColor) -- 2015-07-29

	local  TFD_LV  = m_fnGetWidget(m_mainWidget,"TFD_LV")   --等级
	TFD_LV:setText(m_tbUserInfoData.level .. m_i18n[5956])

	local  LABN_ZHANDOULI  = m_fnGetWidget(m_mainWidget,"TFD_ZHANDOULI")   --战斗力
	LABN_ZHANDOULI:setText(tonumber(m_tbUserInfoData.fight_force) .. "")

	--玩家头像
	local headIconBtn,heroInfo = HeroUtil.createHeroIconBtnByHtid(m_tbUserInfoData.figure)
	local headIconBg = m_fnGetWidget(m_mainWidget,"IMG_PHOTO")
	headIconBg:addChild(headIconBtn)

	--'type':            职务类型：0团员，1团长，2副团
	local IMG_MEMBER = m_fnGetWidget(m_mainWidget,"IMG_MEMBER")  			--成员图片
	local IMG_LEADER = m_fnGetWidget(m_mainWidget,"IMG_LEADER")  			--联盟长图片
	local IMG_VICE_LEADER = m_fnGetWidget(m_mainWidget,"IMG_VICE_LEADER")  	--副联盟长图片
	IMG_MEMBER:setEnabled(false)
	IMG_LEADER:setEnabled(false)
	IMG_VICE_LEADER:setEnabled(false)

	if(m_tbUserInfoData.type == "1") then
		IMG_LEADER:setEnabled(true)
	elseif(m_tbUserInfoData.type == "2") then
		IMG_VICE_LEADER:setEnabled(true)
	elseif(m_tbUserInfoData.type == "0") then
		IMG_MEMBER:setEnabled(true)
	end


	return m_mainWidget

end

