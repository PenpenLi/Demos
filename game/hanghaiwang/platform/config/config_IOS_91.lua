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
	return "91phone"
end

function getName( ... )
	return "91社区"
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
	dict:setObject(CCString:create("115896"),"appID")
	dict:setObject(CCString:create("396d0c05b824b4828d225fb2de227d77e2c0631154ea1065"),"appKey")
	dict:setObject(CCString:create("true"),"debug")
	dict:setObject(CCString:create(UIInterfaceOrientationPortrait),"orientation")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(Platform.getLastLoginGroup()),"groupId")
	return dict
end

