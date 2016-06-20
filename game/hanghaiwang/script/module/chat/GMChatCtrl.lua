-- FileName: GMChatCtrl.lua
-- Author: menghao
-- Date: 2014-06-09
-- Purpose: GM聊天ctrl


module("GMChatCtrl", package.seeall)


require "script/module/chat/GMChatView"


-- UI控件引用变量 --


-- 模块局部变量 --
local m_i18n = gi18n


local function onDlgClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
		GMChatView.setEditBoxTouchEnabled(true)
	end
end


function sendCallback(sender, res)
	LayerManager.removeLoading()

	if (res:getResponseCode()==200)then
		GMChatView.setText("")
		ShowNotice.showShellInfo(m_i18n[2828])
	else
		ShowNotice.showShellInfo(m_i18n[2829])
	end
end


local function sendClick()
	if(GMChatView.getText()~=nil and GMChatView.getText()~="" )then

		local str = GMChatView.getText()

		-----------------------------------------
		-- 长度最大200个utf-8
		local utf8Len = ChatUtil.getUTF8StrLen(str)
	 	if (utf8Len>200) then 
	 		str = ChatUtil.cutStringByUTF8(str,200)
	 	end  
		-----------------------------------------
		require "platform/Platform"
		local fmt = Platform.getReportUrl(), nil
		local url = string.format(fmt, g_tbServerInfo.group, g_tbServerInfo.groupid, str, tostring(GMChatView.getclassType()),
			tostring(UserModel.getUserInfo().uid), UserModel.getUserInfo().uname, "question")

		url = Platform.signUrl(url) -- 2015-05-15, 加上新接口需要的签名信息

		local request = LuaHttpRequest:newRequest()
		request:setRequestType(CCHttpRequest.kHttpGet)
		request:setUrl(url)
		request:setResponseScriptFunc(sendCallback)

		LayerManager.addLoading()

		CCHttpClient:getInstance():send(request)
		request:release()
	else
		LayerManager.addLayout(UIHelper.createCommonDlg(m_i18n[2831], nil, onDlgClose, 1))
		GMChatView.setEditBoxTouchEnabled(false)
	end
end


function getQuestionCallBack(sender, res)
	LayerManager.removeLoading()

	if(res:getResponseCode()==200)then
		local cjson = require "cjson"
		local results = cjson.decode(res:getResponseData())

		local strName = UserModel.getUserInfo().uname
		local strSex = tostring(UserModel.getUserSex() == 1 and 1 or 0)
		local color = UserModel.getPotentialColor()	-- zhangqi, 2015-07-28

		for i=1,#(results.msg) do
			local strQuestion = results.msg[i].question
			local strAnswer = ((results.msg[i].answer==nil or results.msg[i].answer=="")
				and m_i18n[2822] or results.msg[i].answer)

			GMChatView.addChatInfo(color, strName, strQuestion, strAnswer)
		end
		GMChatView.showLook()
	else
		LayerManager.addLayout(UIHelper.createCommonDlg(m_i18n[2829], nil, onDlgClose, 1))
		GMChatView.setEditBoxTouchEnabled(false)
	end
end


function showReviewView()
	GMChatView.resetListView()
	require "platform/Platform"
	local fmt = Platform.getReviewUrl()
	local url = string.format(fmt, g_tbServerInfo.group, g_tbServerInfo.groupid, tostring(UserModel.getUserInfo().uid), "answer")

	url = Platform.signUrl(url) -- 2015-05-15, 加上新接口需要的签名信息

	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setUrl(url)
	request:setResponseScriptFunc(getQuestionCallBack)

	LayerManager.addLoading()

	CCHttpClient:getInstance():send(request)
	request:release()
end


local function init(...)

end


function destroy(...)
	package.loaded["GMChatCtrl"] = nil
end


function moduleName()
	return "GMChatCtrl"
end


function create(...)
	local tbEventListener = {}

	tbEventListener.onSubmit = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			GMChatView.showSend()
		end
	end

	tbEventListener.onLook = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			GMChatView.showLook()
			showReviewView()
		end
	end

	tbEventListener.onSend = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			sendClick()
		end
	end

	local layMain = GMChatView.create( tbEventListener )
	return layMain
end

