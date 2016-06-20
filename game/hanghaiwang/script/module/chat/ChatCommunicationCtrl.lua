-- FileName: ChatCommunicationCtrl.lua
-- Author: menghao
-- Date: 2014-06-07
-- Purpose: 点别人头像弹出框ctrl


module("ChatCommunicationCtrl", package.seeall)


require "script/module/chat/ChatCommunicationView"


-- UI控件引用变量 --


-- 模块局部变量 --
local mi18n = gi18n


local function init(...)

end


function destroy(...)
	package.loaded["ChatCommunicationCtrl"] = nil
end


function moduleName()
	return "ChatCommunicationCtrl"
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


function create( tbInfo )
	local tbEventListener = {}

	tbEventListener.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	tbEventListener.onAdd = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			RequestCenter.friend_applyFriend(addFriendClickCallback,Network.argsHandler(tbInfo.sender_uid,""))
		end
	end

	tbEventListener.onPrivate = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			local name = tbInfo.sender_uname
			ChatCtrl.create(2, name)
		end
	end

	tbEventListener.onShield = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
		end
	end

-- 切磋按钮事件
	tbEventListener.onPVP = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			logger:debug("tbEventListener.onPVP")
			require "script/module/public/PVP"
			PVP.doPVP(sender.tag)
		end
	end


	local layMain = ChatCommunicationView.create(tbInfo, tbEventListener)
	return layMain
end

