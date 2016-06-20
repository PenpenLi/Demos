-- FileName: AudioTip.lua
-- Author: menghao
-- Date: 2015-04-22
-- Purpose: 语音提示


module("AudioTip", package.seeall)


-- UI控件引用变量 --
local _UIMain

local _tfdEnd

local _tfdTip
local _imgMic

local _layNoSend
local _tfdCancel
local _imgBack


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local _nTiptag = 1369631

local function init(...)

end


function destroy(...)
	package.loaded["AudioTip"] = nil
end


function moduleName()
	return "AudioTip"
end

function setSendEnabled( bValue )
	_tfdTip:setEnabled(bValue)
	_imgMic:setEnabled(bValue)

	_layNoSend:setEnabled(not bValue)
	_imgBack:setEnabled(not bValue)
end


function showSend( ... )
	setSendEnabled(true)
end


function showNoSend( ... )
	setSendEnabled(false)
end


function showEnd( ... )
	_tfdEnd:setEnabled(true)
end


function remove( ... )
	if (_UIMain) then 
		_UIMain:removeFromParentAndCleanup(true)
		_UIMain = nil
	end 
end


function create(...)
	_UIMain = g_fnLoadUI("ui/chat_audio.json")

	local scene = CCDirector:sharedDirector():getRunningScene()
	scene:removeChildByTag(_nTiptag,true)
	scene:addChild(_UIMain, _nTiptag)

	performWithDelay(_UIMain, function ( ... )
		showEnd()
	end, 60)

	_tfdEnd = m_fnGetWidget(_UIMain, "TFD_END")
	_tfdEnd:setEnabled(false)

	_tfdTip = m_fnGetWidget(_UIMain, "TFD_TIP")
	_imgMic = m_fnGetWidget(_UIMain, "IMG_MICROPHONE")

	_layNoSend = m_fnGetWidget(_UIMain, "LAY_NO_SEND")
	_tfdCancel = m_fnGetWidget(_UIMain, "TFD_CANCEL")
	_imgBack = m_fnGetWidget(_UIMain, "IMG_BACK")

	showSend()
end

