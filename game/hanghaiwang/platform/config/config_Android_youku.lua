-- Filename: config_91.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: ios 91 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "youku"
end

function getBBSName( ... )
	return ""
end

function getPayCallbackUrl( ... )
	if Platform.isDebug() then
		return "http://124.205.151.90/phone/exchange/youku/cp/android"
	end
	return "http://hhwmapi.chaohaowan.com/phone/exchange/youku/cp/android"
end

function getInitParam( ... )
	local dict = CCDictionary:create()
	return dict
end

function getPidUrl( sessionid )
 	return "phone/login?token=" .. sessionid .. Platform.getUrlParam() .. "&bind=" .. Platform.getUUID()
end

function setLoginInfo( xmlTable )
	print("LoginInfo:",xmlTable)
	loginInfoTable = xmlTable
	print("loginInfoTable.uid:",loginInfoTable.uid)
	print("loginInfoTable.username:",loginInfoTable.username)
	print("loginInfoTable.userid:",loginInfoTable.userid)
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(getPayCallbackUrl()),"payCallbackUrl")
	dict:setObject(CCString:create("金币"),"productName")
	return dict
end

