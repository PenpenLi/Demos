-- Filename: 	RecordUtil.lua
-- Author: 		chengliang
-- Date: 		2015-04-07
-- Purpose: 	语音聊天相关工具
-- modified:
-- zhangqi, 2015-11-30, 用Platform.getAudioHost() 代替语音服务url变量，避免总是遗忘线上线下的url切换


module("RecordUtil", package.seeall)


local kFlagAudio 	= 1
local kFlagText 	= 2
local kFlagBoth		= 3

local _i18n = gi18n

local isHavePression = -1
-- 初始化  语音初始化失败返回-1,成功返回0
function initRecord()
	if(isRecordOpen()== false)then
		return
	end
	isHavePression = CAudioRecordAndPlay:getInstance():init(false)   
	return isHavePression
end

-- 获取语音初始化结果
function getInitResult( ... )
	return isHavePression==0 and true or false
end

-- 开始录音
function startRecord( ... )
	if(isRecordOpen()== false)then
		return
	end
	return CAudioRecordAndPlay:getInstance():startRecording()
end


-- 结束录音 返回录音数据，录音时长
function stopRecord( ... )
	if(isRecordOpen()== false)then
		return
	end
	local audioLen = 0
	return CAudioRecordAndPlay:getInstance():stopRecording(audioLen)
end


-- 播放录音
function playRecordBy( aid, p_callback )
	if(isRecordOpen()== false)then
		return
	end
	local recorder = ChatModel.getAudioBy(aid)
	if(recorder)then
		CAudioRecordAndPlay:getInstance():startPlayout(recorder, p_callback, 1)
	else
		getSvrRecordById(aid,
			function( status, json_str, audio_data  )
				if(status ~= 0)then
					p_callback(-1)
				else
					ChatModel.addAudioBy(aid, audio_data)
					playRecordBy(aid, p_callback)
				end
			end
		)
	end
end


-- 停止播放
function stopPlayRecord()
	if(isRecordOpen()== false)then
		return
	end
	CAudioRecordAndPlay:getInstance():stopPlayout()
end


-- 发送录音
function sendRecorder( recordData, p_ms, p_callback )
	local arrField = {
		ms 		= p_ms,
		len 	= string.len(recordData),
		pid 	= Platform.getPid(),
		time 	= TimeUtil.getSvrTimeByOffset(),
	}
	local hashStr = string.format("pid%sms%slen%stime%sdfae8d317f6536", arrField.pid, arrField.ms, arrField.len, arrField.time)
	arrField.hash = CCCrypto:md5(hashStr, string.len(hashStr), false);


	local cjson = require "cjson"
	local jsonStr = cjson.encode(arrField)
	local len = string.len(jsonStr)
	local b4 = string.char( len % 256 );
	len  =  math.floor(len / 256);
	local b3 = string.char( len % 256 );
	len  =  math.floor(len / 256);
	local b2 = string.char( len % 256 );
	len  =  math.floor(len / 256);
	local b1 = string.char( len % 256 );
	local postData = b1..b2..b3..b4.. jsonStr .. recordData

	local url = Platform.getAudioHost() .. '?method=audio.send'

	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpPost)
	request:setUrl(url)
	request:setRequestData(postData, string.len(postData))
	local arrHeader = CCArray:create()
	arrHeader:addObject(CCString:create("Expect:"))
	request:setHeaders(arrHeader)
	request:setResponseScriptFunc(function(sender, res)
		local status = res:getResponseCode()
		-- local errorBuffer = res:getErrorBuffer()

		-- logger:debug({errorBuffer=errorBuffer})
		-- logger:debug({status=status})
		if ( status == 200  ) then
			local data = res:getResponseData()
			p_callback(0, data)
		else
			p_callback(-1)
		end
	end)

	CCHttpClient:getInstance():send(request)
	request:release()
end


-- 当前录音分贝
function getCurVoiceLevel()
	local v_level = 0
	local v_DB = CAudioRecordAndPlay:getInstance():getCurRecordDbLevel()
	if(v_DB >-20)then
		v_level = 5
	elseif(v_DB >-35)then
		v_level = 4
	elseif(v_DB >-55)then
		v_level = 3
	elseif(v_DB >-65)then
		v_level = 2
	elseif(v_DB >-80)then
		v_level = 1
	else
		v_level = 0
	end
	return v_level
end


-- 获取录音
function getSvrRecordById( aid, p_callback )
	getSvrRecordOrTextBy(aid, kFlagAudio, p_callback)
end


-- 获取识别文字
function getSvrRecordTextById( aid, p_callback )
	getSvrRecordOrTextBy(aid, kFlagText, p_callback)
end


-- 获取录音 or 识别文字 flag: 1:语音，2：识别结果，3：两个都要
function getSvrRecordOrTextBy( aid, flag, p_callback )
	local url = Platform.getAudioHost() .. "?method=audio.get&id=".. aid .. "&flag=" .. flag

	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setUrl(url)
	request:setResponseScriptFunc(
		function(sender, res)
			local status = res:getResponseCode()
			if ( status == 200  ) then
				local data = res:getResponseData()
				local jsonLen = string.byte( data, 1)
				jsonLen = jsonLen * 256 + string.byte( data, 2)
				jsonLen = jsonLen * 256 + string.byte( data, 3)
				jsonLen = jsonLen * 256 + string.byte( data, 4)

				if jsonLen > string.len(data) - 4 then
					return
				end

				local jsonStr = string.sub(data, 5, jsonLen+4)

				local audio_data = string.sub(data, jsonLen+5, string.len(data))
				local cjson = require "cjson"
				local dataJson = cjson.decode( jsonStr )

				p_callback(0, dataJson, audio_data)
			else
				p_callback(-1)
			end
		end
	)

	CCHttpClient:getInstance():send(request)
	request:release()
end


function checkRecordPermission( ... )
	-- 取出来是空说明是第一次
	if  CCUserDefault:sharedUserDefault():getStringForKey("check_record_permisson") == "" then
		CCUserDefault:sharedUserDefault():setStringForKey("check_record_permisson", "true")
	else
		GameUtil:checkRecordPermission()   
	end

	local sResult = CCUserDefault:sharedUserDefault():getStringForKey("check_record_permisson")
	local bResult = (sResult == "true")

	-- android平台不使用检测语音权限的方式，用CAudioRecordAndPlay初始化结果决定
	if (g_system_type == kBT_PLATFORM_ANDROID) then 
		bResult = isHavePression == 0 and true or false
	end 

	if (not bResult) then
		local UIChatTip = g_fnLoadUI("ui/chat_tip.json")

		UIChatTip.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
		UIChatTip.BTN_PRIVATE:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				LayerManager.removeLayout()
			end
		end)

		if (g_system_type == kBT_PLATFORM_ANDROID) then
			UIChatTip.TFD_IOS:setEnabled(false)
			UIChatTip.TFD_ANDROID1:setText(_i18n[2845]) -- "请尝试按以下路径开启录音权限："
			UIChatTip.TFD_ANDROID2:setText(_i18n[2846]) -- "方法一：设定-应用程序许可-航海王强者之路-录制音频"
			UIChatTip.TFD_ANDROID3:setText(_i18n[2847]) -- "方法二：360卫士-权限管理-航海王强者之路-录音-允许"
		end
		if (g_system_type == kBT_PLATFORM_IOS) then
			UIChatTip.TFD_IOS:setText(_i18n[2848]) -- "请在IPhone的“设置-隐私-麦克风”选项中，允许航海王强者之路访问你的手机麦克风"
			UIChatTip.TFD_ANDROID1:setEnabled(false)
			UIChatTip.TFD_ANDROID2:setEnabled(false)
			UIChatTip.TFD_ANDROID3:setEnabled(false)
		end

		LayerManager.addLayout(UIChatTip)
	end

	return bResult
end


-- 屏蔽 录音
function isRecordOpen()
	return true
end


