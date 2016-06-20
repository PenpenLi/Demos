-- FileName: CommunicationCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-09-23
-- Purpose:留言板点击玩家头像，弹出的面板
--[[TODO List]]

module("CommunicationCtrl", package.seeall)
require "script/module/guild/message/CommunicationView"
require "script/module/guild/InviteFrdsTips"
require "script/module/mail/LeaveMessageCtrl"

-- UI控件引用变量 --
local m_i18nString = gi18nString
local mi18n = gi18n
-- 模块局部变量 --
local tbEvents = {}
local m_tbUserInfo = {}
local function init(...)
end

function destroy(...)
	package.loaded["CommunicationCtrl"] = nil
end

function moduleName()
	return "CommunicationCtrl"
end

function addFriendClickCallback(cbFlag, dictData, bRet)
	if(dictData.err == "ok") then
		if(dictData.ret == "ok") then
			ShowNotice.showShellInfo(mi18n[2836])
		elseif(dictData.ret == "applied")then
			ShowNotice.showShellInfo(mi18n[2837])
		elseif(dictData.ret == "alreadyfriend")then
			ShowNotice.showShellInfo(mi18n[2838])
		elseif(dictData.ret == "reach_maxnum")then
			ShowNotice.showShellInfo(mi18n[2839])
		end
	end
end

function create( tbUserInfo )
	logger:debug("CommunicationCtrl create")
	m_tbUserInfo = tbUserInfo
	tbEvents = {}

	-- 关闭按钮事件
	tbEvents.fnClose = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnClose")
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end
	-- 查看信息按钮事件
	tbEvents.fnInfo = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnInfo")
			AudioHelper.playCommonEffect()

			require "script/module/formation/FormationCtrl"
			FormationCtrl.loadFormationWithUid(sender:getTag())
		end
	end

	-- 发送邮件按钮事件
	tbEvents.fnSendMessage = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnSendMessage")
			AudioHelper.playCommonEffect()

			if(m_tbUserInfo.isFriend) then

				local sendUid = sender:getTag()
				LayerManager.addLayout(LeaveMessageCtrl.create(sendUid,LeaveMessageCtrl.LeaveMessageType.KTypeLeaveGuild))
				LeaveMessageView.createEditBox()
			else
				local str = m_i18nString(3662) --	成为好友可发送邮件留言",
				ShowNotice.showShellInfo(str)
			end

		end
	end
	-- 私聊按钮事件
	tbEvents.fnChat = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnChat")
			AudioHelper.playCommonEffect()
			require "script/module/chat/ChatCtrl"
			local name = m_tbUserInfo.uname
			local layChat = ChatCtrl.create(2, name)
		end
	end
	-- 邀请好友按钮事件
	tbEvents.fnAddFrd = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnAddFrd")
			AudioHelper.playCommonEffect()
			local uid = sender:getTag()
			RequestCenter.friend_applyFriend(addFriendClickCallback,Network.argsHandler(uid,""))
			-- LayerManager.addLayout(InviteFrdsTips.create(uid))
		end
	end

	tbEvents.fnPVP = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnPVP")
			AudioHelper.playCommonEffect()

			require "script/module/public/PVP"
			PVP.doPVP(sender.tag)

		end
	end


	local messageView = CommunicationView.create(tbEvents ,m_tbUserInfo)
	LayerManager.addLayout(messageView)

end


