-- Filename: ChatUtil.lua
-- Author: menghao
-- Date: 2015-5-6
-- Purpose: 聊天方法


module("ChatUtil", package.seeall)


require "db/DB_Chat_interface"
require "script/module/chat/PublicChatView"


local _strNameSayTo 	-- 私聊用户的名字
local _strMsgWantSay 	-- 私聊信息
local m_scheduleId      --世界聊天cd计时器
local m_cdTime = 0


function createBattleMsg( uname1, uname2, battleID )
	return string.format("<fight>%s,%s,%s<fight/>", uname1, uname2, battleID)
end


function createAudioMsg( aid, aSec)
	return "<audio>".. aid ..","..aSec .."<audio/>"
end


function getMsgType( strText )
	local text_len = string.len(strText)
	if string.sub(strText, 1, 7) == "<audio>" and string.sub(strText, text_len - 7, text_len) == "<audio/>" then
		return ChatModel.ChatInfoType.AUDIO
	end
	if string.sub(strText, 1, 7) == "<fight>" and string.sub(strText, text_len - 7, text_len) == "<fight/>" then
		return ChatModel.ChatInfoType.BATTLE
	end

	return ChatModel.ChatInfoType.NORMAL
end


function parserChatMsg( strText )
	if (getMsgType(strText) == ChatModel.ChatInfoType.AUDIO
		or getMsgType(strText) == ChatModel.ChatInfoType.BATTLE) then
		local nLength = string.len(strText)
		local strNew = string.sub(strText, 8, nLength - 8)
		return string.split(strNew, ",")
	end

	return strText
end


-------------------------------------发消息相关---------------------------------------------------

function getCDTime( ... )
	return m_cdTime and m_cdTime or 0
end

-- 世界聊天增加cd时间
local function updateCDTime( ... )
	local curTime = TimeUtil.getSvrTimeByOffset()
	if (m_cdTime - curTime <= 0) then 
		m_cdTime = 0
		stopScheduler()
	end 
end 

-- 启动scheduler,玩家vip< chat_cd字段的vip，启动cd 
function startScheduler()
	if(m_scheduleId == nil) then
		local chat_cd = DB_Chat_interface.getDataById(1).chat_cd
		local tbData = lua_string_split(chat_cd,'|')
		if (tonumber(UserModel.getUserInfo().vip) < tonumber(tbData[1])) then 
			m_cdTime = TimeUtil.getSvrTimeByOffset() + tonumber(tbData[2])
			m_scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateCDTime, 1, false)
		else
			m_cdTime = 0 
		end 
	end
end


-- 停止scheduler
function stopScheduler()
	if(m_scheduleId)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_scheduleId)
		m_scheduleId = nil
	end
end


local function showTip( strTip )
	LayerManager.addLayout(UIHelper.createCommonDlg(strTip, nil, UIHelper.onClose, 1))
end


local function sendWorldCall( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		if (ChatModel.getCurTab() ~= 0) then
			if(dictData.ret == "") then
				PublicChatView.setText("")
				startScheduler()
			else
				showTip(gi18n[2829]) -- 网络异常
			end
		end 
	end
end


function sendWorld( strText )
	local dbInfo = DB_Chat_interface.getDataById(1)
	local tbData = lua_string_split(dbInfo.chat_cd,'|')
	local chatvip = tbData[1]

	-- 等级不够
	if (dbInfo.lv_require and tonumber(UserModel.getUserInfo().level) < dbInfo.lv_require) then
		ShowNotice.showShellInfo(gi18n[2830] .. dbInfo.lv_require)
		return
	end

	-- vip等级不够
	if (dbInfo.vip_lv_require and tonumber(UserModel.getUserInfo().vip) < dbInfo.vip_lv_require) then
		ShowNotice.showShellInfo(gi18n[2835] .. dbInfo.vip_lv_require)
		return
	end

	-- 内容不能为空
	if (not strText or strText == "") then
		showTip(gi18n[2831])
		return
	end

	-- cd时间不到
	if (tonumber(UserModel.getUserInfo().vip) < tonumber(chatvip) and m_cdTime > 0) then 
		ShowNotice.showShellInfo(gi18n[2851])
		return 
	end 

	RequestCenter.chat_sendWorld(sendWorldCall, Network.argsHandler(strText, 2,1))
end


local function sendPrivateCall(cbFlag, dictData, bRet)
	if(dictData.err == "ok") then
		if (ChatModel.getCurTab() ~= 0) then
			-- 用户不在线
			if(dictData.ret == "userOffline")then
				showTip(gi18n[2827])
				PublicChatView.autoCancelRecorder()
				return
			end

			if (dictData.ret ~= nil and dictData.ret.message ~= nil) then
				local chatInfo = {}
				chatInfo.message_text = dictData.ret.message
				chatInfo.sender_uname = UserModel.getUserName()
				chatInfo.sender_uid = UserModel.getUserUid()
				chatInfo.sender_tmpl = tostring(UserModel.getAvatarHtid())
				chatInfo.sender_fight = fight
				chatInfo.sender_level = tostring(UserModel.getHeroLevel())
				chatInfo.sender_vip = UserModel.getVipLevel()
				chatInfo.isSelfSend = true
				chatInfo.channel = tostring(4)
				chatInfo.figure = tostring(UserModel.getAvatarHtid())

				ChatModel.addChat(chatInfo)
				PublicChatView.setText("")
			end
		end 
	end
end


local function doPrivateSend(userInfo)
	local uid = tonumber(userInfo.uid)
	RequestCenter.chat_sendPersonal(sendPrivateCall, Network.argsHandler(uid, _strMsgWantSay))
end


local function getUidCallBack(cbFlag, dictData, bRet)
	if (dictData.err == "ok") then
		if (ChatModel.getCurTab() ~= 0) then
			-- 用户不存在
			if(dictData.ret == nil or dictData.ret.err ~= "ok") then
				showTip(gi18n[2826])
				PublicChatView.autoCancelRecorder()
				return
			end

			doPrivateSend(dictData.ret)
		end 
	end
end


function sendPrivate( strText )
	_strNameSayTo = PublicChatView.getName()
	_strMsgWantSay = strText

	local dbInfo = DB_Chat_interface.getDataById(3)
	-- 等级不够
	if (dbInfo.lv_require and tonumber(UserModel.getUserInfo().level) < dbInfo.lv_require) then
		showTip(gi18n[2834] .. dbInfo.lv_require)
		PublicChatView.autoCancelRecorder()
		return
	end

	-- vip等级不够
	if (dbInfo.vip_lv_require and tonumber(UserModel.getUserInfo().vip) < dbInfo.vip_lv_require) then
		showTip(gi18n[2835] .. dbInfo.vip_lv_require)
		PublicChatView.autoCancelRecorder()
		return
	end

	-- 不能给自己发消息
	if(_strNameSayTo == UserModel.getUserName())then
		showTip(gi18n[2832])
		PublicChatView.autoCancelRecorder()
		return
	end

	-- 内容不为空
	if (not strText or strText == "") then
		showTip(gi18n[2831])
		PublicChatView.autoCancelRecorder()
		return
	end

	RequestCenter.user_getUserInfoByUname(getUidCallBack, Network.argsHandler(_strNameSayTo))
end


local function sendUnionCall( cbFlag, dictData, bRet )
	if (ChatModel.getCurTab() ~= 0) then
		if (dictData.err == "noguild" or dictData.err == "guild id is null") then
			showTip(gi18n[1925])
			return
		end

		if (dictData.err == "ok") then
			if (dictData.ret == "true") then
				PublicChatView.setText("")
			elseif (dictData.ret == "noguild") then
				showTip(gi18n[1925])
			else
				showTip(gi18n[1940])
			end
		end
	end  
end


function sendUnion( strText )
	-- 内容不为空
	if (not strText or strText == "") then
		showTip(gi18n[2831])
		return
	end

	RequestCenter.chat_sendGuild(sendUnionCall, Network.argsHandler(strText))
end
----------------------------------end----------------------------------------------

-- 获取UTF－8字符串长度
function getUTF8StrLen( str )
	local len = #str 
	local left = len 
	local totalLen = 0
	local arr = {0,0xc0,0xe0,0xf0,0xf8,0xfc}

	while left~=0 do 
		local temp = string.byte(str,-left)
		local i=#arr
		while arr[i] do 
			if temp>=arr[i] then 
				left = left-i
				break
			end 
			i=i-1
		end 
		totalLen = totalLen+1
	end 
	return totalLen
end

--按照utf-8编码截取 nMaxCount长度的字符串
function cutStringByUTF8(sName,nMaxCount)


    if sName == nil or nMaxCount == nil then
        return
    end
    local sStr = sName
    local tCode = {}
    local tName = {}
    local nLenInByte = #sStr
    local nWidth = 0

    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
        end
        if byteCount == 1 then
            nWidth = nWidth + 1
            table.insert(tName,char)
            
        elseif byteCount > 1 then
            nWidth = nWidth + byteCount
            table.insert(tName,char)
        end
    end


    if (nWidth<nMaxCount) then 
    	return sName
    end 


    local tbDataTemp = {}
    for i=1,nMaxCount do 
    	tbDataTemp[#tbDataTemp+1] = tName[i]
    end 

    local result = table.concat(tbDataTemp)
    return result
end

---------------------------------------------------------

function isBattleMsg(text)
	local text_len = string.len(text)
	local is_table = string.sub(text, 1, 7) == "<table>" and string.sub(text, text_len - 7, text_len) == "<table/>"
	return is_table
end


function isAudioMsg( text )
	local text_len = string.len(text)
	local is_table = string.sub(text, 1, 7) == "<audio>" and string.sub(text, text_len - 7, text_len) == "<audio/>"
	return is_table
end

function getTable(table_str)
	local str_len = string.len(table_str)
	local new_str = string.sub(table_str, 8, str_len - 8)
	return string.split(new_str, ",")
end

-- 语音聊天获取文本
function getRecordRext(index,audioID)
	RecordUtil.getSvrRecordTextById(audioID, function ( p_status, text_arr, audio_data )
		if( p_status~=0 )then
			return
		end
		logger:debug("语音翻译返回")
		logger:debug({p_status=p_status,text_arr=text_arr,audio_data=audio_data})

		if (text_arr.asr ) then 
			ChatModel.addAudioTextBy(audioID, text_arr.asr)
			return 
		end 

		if (index >=5) then 
				if(table.isEmpty(text_arr))then
				ChatModel.addAudioTextBy(audioID, "")
			else 
				text_arr.asr = text_arr.asr or "nil-nil"
				ChatModel.addAudioTextBy(audioID, text_arr.asr)
			end 
		end 
	end)
end


