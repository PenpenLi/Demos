-- Filename: config_xiaomi.lua
-- Author: chao he
-- Date: 2013-11-7
-- Purpose: android 安智 平台配置
module("config", package.seeall)

loginInfoTable = {}

UIInterfaceOrientationPortrait           = "1"
UIInterfaceOrientationPortraitUpsideDown = "2"
UIInterfaceOrientationLandscapeLeft      = "3"
UIInterfaceOrientationLandscapeRight     = "4"

function getFlag( ... )
	return "azphone"
end


function getPidUrl( sessionid )
	local postString = "phone/login/" .. "?sid=" .. sessionid .. "&account=".. Platform.getSdk():callStringFuncWithParam("getLoginName",nil).. Platform.getUrlParam().."&bind=" ..  Platform.getUUID()
 	return postString
end 



function getBBSName( ... )
	return "安智社区"
end

function getInitParam( ... )
	local dict = CCDictionary:create()
    dict:setObject(CCString:create("1431334731mfaEB9CKgMc4929yX2vl"),"appId")
    dict:setObject(CCString:create("l9CyL2QHdT07Y4z0G3amVa39"),"appKey")

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
