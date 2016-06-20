-- FileName: LeaveMessageCtrl.lua
-- Author:zhangjunwu
-- Date: 2014-06-02
-- Purpose: 邮件列表 好友留言界面
--[[TODO List]]

module("LeaveMessageCtrl", package.seeall)
require "script/module/mail/LeaveMessageView"
require "script/module/mail/MailService"
-- UI控件引用变量 --

-- 模块局部变量 --

local m_i18nString = gi18nString

LeaveMessageType = {
	KTypeLeaveMail= 1, -- 邮件 回复留言
	KTypeLeaveGuild = 2	--联盟，交流中得发送邮件
}

local function init(...)

end

function destroy(...)
	package.loaded["LeaveMessageCtrl"] = nil
end

function moduleName()
    return "LeaveMessageCtrl"
end


--[[desc:功能简介
    arg1: sendUid = 发送对象的uid；  _type 是从哪个界面点进来的
    return: 是否有返回值，返回值说明  
—]]
function create(send_uid,_type)
	init()
	local tbBtnEvent = {}
	-- 按钮 发送
	tbBtnEvent.onSend = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then	
				AudioHelper.playCommonEffect()
				local function sendMessageCall( dataRet )
					-- 发送成功后关闭本层
					LayerManager.removeLayout()
			        -- local str = "回复成功！"
			        if(_type == LeaveMessageType.KTypeLeaveGuild) then
			        	-- local str = "发送成功！"
 						ShowNotice.showShellInfo(m_i18nString(3576))
					else
						-- local str = "回复成功！"
			       	 	ShowNotice.showShellInfo(m_i18nString(2162))
			       	end
				end	

		 	local content = LeaveMessageView.getMessage()
	 		local messageLength = string.len(content)
	 		logger:debug(messageLength)
	 		if(messageLength > 0 ) then
	 			logger:debug(send_uid)
				MailService.sendMail(send_uid, 0, content,sendMessageCall)
			else
 				--ShowNotice.showShellInfo("消息不可为空")
 				require "script/module/public/ShowNotice"
 				ShowNotice.showShellInfo(m_i18nString(2161))
			end

		end
	end
	-- 按钮返回
	tbBtnEvent.onBack = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			LayerManager.removeLayout()
		end
	end

	local view = LeaveMessageView.create(tbBtnEvent,_type)
	return view
end
