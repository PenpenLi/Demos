-- Filename: ChatModel.lua
-- Author: menghao
-- Date: 2015-5-6
-- Purpose: 聊天数据缓存


module("ChatModel", package.seeall)


local MAX_CHAT_NUM = 100 	-- 聊天缓存条数上限
-- 聊天消息类型
ChatInfoType = {
	NORMAL = 1, 	-- 普通
	BATTLE = 2, 	-- 玩家战报
	AUDIO = 3, 		-- 语音聊天
}
local _nCurTab = 0 	-- 0:不在聊天界面 1:世界 2:私人 3:联盟
local _worldChatCache = {}
local _privateChatCache = {}
local _unionChatCache = {}
local _recordCache = {}
local _nUnread 		-- 未读消息数
local m_chatBubbleData  --聊天气泡数据


function setUnreadNum( num )
	_nUnread = num
	PublicChatView.upUnread(_nUnread)
end


function addUnreadNum( ... )
	setUnreadNum(_nUnread + 1)
end


function setCurTab( num )
	_nCurTab = num
end


function getCurTab( ... )
	return _nCurTab
end


function getChatCache( ... )
	if (_nCurTab == 1) then
		return _worldChatCache
	elseif (_nCurTab == 2) then
		return _privateChatCache
	elseif (_nCurTab == 3) then
		return _unionChatCache
	end
end

-- 聊天气泡
function setChatBubbleData( data )
	m_chatBubbleData = data
end

-- 聊天气泡
function getChatBubbleData()
	return m_chatBubbleData
end


local function addChatToCache( chatInfo )
	local channel = tonumber(chatInfo.channel)
	if (channel==2 or channel==3 or channel==4 or channel==101) then 
		setChatBubbleData(chatInfo)
		GlobalNotify.postNotify(GlobalNotify.CHAT_BUBBLE)
	end 

	-- 世界频道
	if (channel == 2 or channel == 3) then
		_worldChatCache[#_worldChatCache + 1] = chatInfo
		if (#_worldChatCache > MAX_CHAT_NUM) then
			if (ChatUtil.getMsgType(_worldChatCache[1].message_text) == ChatInfoType.AUDIO) then
				local audioID = ChatUtil.parserChatMsg(_worldChatCache[1].message_text)[1]
				removeAudioBy(audioID)
			end
			table.remove(_worldChatCache, 1)
		end
		if (_nCurTab == 1) then
			PublicChatView.addNewChatCell(chatInfo)
		end
	end

	-- 私人频道
	if (channel == 4) then
		_privateChatCache[#_privateChatCache + 1] = chatInfo
		if (#_privateChatCache > MAX_CHAT_NUM) then
			if (ChatUtil.getMsgType(_privateChatCache[1].message_text) == ChatInfoType.AUDIO) then
				local audioID = ChatUtil.parserChatMsg(_privateChatCache[1].message_text)[1]
				removeAudioBy(audioID)
			end
			table.remove(_privateChatCache, 1)
		end
		if (_nCurTab == 2) then
			PublicChatView.addNewChatCell(chatInfo)
			g_redPoint.chat = {visible = false, num = 0}
		else
			g_redPoint.chat.num = g_redPoint.chat.num + 1
			g_redPoint.chat.visible = true
		end

		if (_nCurTab and _nCurTab ~=0) then
			ChatView.upRedPoint()
		end

		if (LayerManager.curModuleName()=="MainShip") then 
			MainShip.upChatRedPoint()
		end 
	end

	-- 公会频道
	if (channel == 101) then
		_unionChatCache[#_unionChatCache + 1] = chatInfo
		if (#_unionChatCache > MAX_CHAT_NUM) then
			if (ChatUtil.getMsgType(_unionChatCache[1].message_text) == ChatInfoType.AUDIO) then
				local audioID = ChatUtil.parserChatMsg(_unionChatCache[1].message_text)[1]
				removeAudioBy(audioID)
			end
			table.remove(_unionChatCache, 1)
		end
		if (_nCurTab == 3) then
			PublicChatView.addNewChatCell(chatInfo)
		end
	end
end


function addChat(chatData)
	if (#chatData == 0) then
		local chatInfo = chatData
		addChatToCache(chatInfo)
	else
		for i=1,#chatData do
			local chatInfo = chatData[i]
			addChatToCache(chatInfo)
		end
	end
end


-- 添加一条语音
function addAudioBy( aid, p_audio )
	if (_recordCache[aid] == nil) then
		_recordCache[aid] = {}
	end
	_recordCache[aid].audio = p_audio
end


-- 添加一条语音文字
function addAudioTextBy(aid, p_text )
	if (_recordCache[aid] == nil) then
		_recordCache[aid] = {}
	end
	_recordCache[aid].text = p_text
end


function removeAudioBy( aid )
	logger:debug({removeAudioBy = aid})
	_recordCache[aid] = nil
end


-- 获取语音
function getAudioBy( aid )
	if (_recordCache[aid] == nil) then
		return nil
	else
		return _recordCache[aid].audio
	end
end


-- 获取语音文字
function getAudioTextBy( aid )
	if (_recordCache[aid] == nil) then
		return nil
	else
		return _recordCache[aid].text
	end
end


