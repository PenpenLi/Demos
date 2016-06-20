-- Filename: config_91.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: ios 91 平台配置
module("config", package.seeall)

UIInterfaceOrientationPortrait           = "1"
UIInterfaceOrientationPortraitUpsideDown = "2"
UIInterfaceOrientationLandscapeLeft      = "3"
UIInterfaceOrientationLandscapeRight     = "4"

loginInfoTable = {}
function getFlag( ... )
	return "91adphone"
end

function getBBSName( ... )
	return "91社区"
end

function getAppID( ... )
	return "104098"
end

function getAppKey( ... )
	return "4cc9fe0c8edf31a7d62ad4355f09ecaaa18a8a98768ab7e5*3MCwm0JgV"
end

function getPidUrl( sessionid )
	local url = "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
    local uin = Platform.getSdk():callStringFuncWithParam("getUin",nil)
	local postString = url .. "?sid=" .. sessionid .. "&uin=".. uin .. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
 	return postString
end 

function getInitParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppID()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	dict:setObject(CCString:create("true"),"debug")
	dict:setObject(CCString:create(UIInterfaceOrientationPortrait),"orientation")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end

