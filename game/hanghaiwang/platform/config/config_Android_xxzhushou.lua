-- Filename: config_91.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: ios 91 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "xxzhushou"
end

function getBBSName( ... )
	return ""
end

function getAppId( ... )
	return "101147"
end

function getAppKey( ... )
	return "ME5TTKGC969S0243"
end

function getPidUrl( sessionid )
	return "phone/login?token=" .. sessionid .. Platform.getUrlParam() .. "&bind=" .. Platform.getUUID()
end 

function getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppId()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	return dict
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
	dict:setObject(CCString:create("金币"),"productName")
	dict:setObject(CCString:create("航海王金币充值"),"productDesc")
	return dict
end

