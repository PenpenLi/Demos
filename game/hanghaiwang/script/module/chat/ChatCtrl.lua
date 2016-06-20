-- FileName: ChatCtrl.lua
-- Author: menghao
-- Date: 2015-04-22
-- Purpose: 聊天主ctrl


module("ChatCtrl", package.seeall)

require "script/module/chat/ChatModel"
require "script/module/chat/ChatUtil"
require "script/module/chat/RecordUtil"
require "script/module/chat/ChatView"
require "script/module/chat/PublicChatView"
require "script/module/chat/GMChatCtrl"
require "script/module/chat/AudioTip"


-- UI控件引用变量 --


-- 模块局部变量 --
local TAG_CHAT_CHILD_VIEW = 1556
local layMain
local _nTabWhenBegan 	-- 开始录音时记录在哪个tab
local _i18n = gi18n

function destroy(...)
	package.loaded["ChatCtrl"] = nil
end


function moduleName()
	return "ChatCtrl"
end

local function sendAudioInfo( audioID, sec )
	local audioContent = ChatUtil.createAudioMsg(audioID, sec)
	if (_nTabWhenBegan == 1) then
		ChatUtil.sendWorld(audioContent)
	elseif (_nTabWhenBegan == 2) then
		ChatUtil.sendPrivate(audioContent)
	elseif (_nTabWhenBegan == 3) then
		ChatUtil.sendUnion(audioContent)
	end
end


-- 开始录音
function beganRecorder( )
	_nTabWhenBegan = ChatModel.getCurTab()

	AudioHelper.stopMusic()
	AudioHelper.stopAllEffects()
	RecordUtil.stopPlayRecord()

	AudioTip.create()
	RecordUtil.startRecord()
end


-- 录音时移动
function movedRecorder( isInRect )
	AudioTip.setSendEnabled(isInRect)
end


-- 结束录音
function endRecorder( )
	local audioData, audioTimeMs = RecordUtil.stopRecord()
	AudioTip.remove()
	AudioHelper.resumeMusic()

	if ( (audioTimeMs / 1000) < 1 ) then
		ShowNotice.showShellInfo(_i18n[2840]) -- "说话时间太短"
		return
	end

	RecordUtil.sendRecorder(audioData, audioTimeMs,
		function( status, a_data )
			if (ChatModel.getCurTab()~=0 and _nTabWhenBegan == ChatModel.getCurTab()) then  --确保语音回调的时候还在聊天页面,并且在正确的子页面
				if(status == 0)then
					-- 正常
					local cjson = require "cjson"
					local arrStr = cjson.decode(a_data)
					ChatModel.addAudioBy(arrStr.id, audioData)
					sendAudioInfo(arrStr.id, audioTimeMs)
				else
					ShowNotice.showShellInfo(_i18n[2841]) --"发送录音不正常"
				end
			end 
		end
	)
end


-- 取消录音
function cancelRecorder()
	AudioTip.remove()
	RecordUtil.stopRecord()
	AudioHelper.resumeMusic()
end


 function addChatViewByType( nType, uname )
	ChatView.setBtnsFocusedByType(nType)

	if (ChatModel.getCurTab() == nType and PublicChatView.getName() == tostring(uname)) then
		return
	end

	ChatModel.setCurTab(nType)

	layMain:removeChildByTag(TAG_CHAT_CHILD_VIEW, true)
	if (nType == 4) then
		local layChat = GMChatCtrl.create()
		layMain:addChild(layChat, 1, TAG_CHAT_CHILD_VIEW)
	else
		local layChat = PublicChatView.create(nType, uname)
		layMain:addChild(layChat, 1, TAG_CHAT_CHILD_VIEW)
	end
end


function refreshChatListView( ... )
	PublicChatView.upChatLsv()
end


local function onClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		RecordUtil.stopPlayRecord()
		AudioHelper.resumeMusic()
		AudioHelper.playBackEffect() -- 2016-01-08
		LayerManager.removeLayout()
		LayerManager.remuseAllLayoutVisible(moduleName())
	end
end


local function onWorld( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		RecordUtil.stopPlayRecord()
		AudioHelper.resumeMusic()
		AudioHelper.playTabEffect()
		addChatViewByType(1)
	end
end


local function onPrivate( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		RecordUtil.stopPlayRecord()
		AudioHelper.resumeMusic()
		AudioHelper.playTabEffect()
		addChatViewByType(2)
	end
end


local function onUnion( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		RecordUtil.stopPlayRecord()
		AudioHelper.resumeMusic()
		AudioHelper.playTabEffect()
		addChatViewByType(3)
	end
end


local function onGM( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		RecordUtil.stopPlayRecord()
		AudioHelper.resumeMusic()
		AudioHelper.playTabEffect()
		addChatViewByType(4)
	end
end


function create(nChatType, uname)
	-- logger:debug("进入聊天初始化语音")
		-- RecordUtil.initRecord()
	-- 已在聊天模块
	if (ChatModel.getCurTab() and ChatModel.getCurTab() ~= 0) then

	else
		local tbEvents = {onClose = onClose, onWorld = onWorld, onPrivate = onPrivate, onUnion = onUnion, onGM = onGM}
		layMain = ChatView.create(tbEvents)
		-- LayerManager.addLayout(layMain)
		-- LayerManager.hideAllLayout(moduleName())
		LayerManager.addLayoutNoScale(layMain)
		
	end
	addChatViewByType(nChatType or 1, uname)

	UIHelper.registExitAndEnterCall(layMain, function ( ... )
		ChatModel.setCurTab(0)
		-- PublicChatView.releaseCell()
	end)
end


