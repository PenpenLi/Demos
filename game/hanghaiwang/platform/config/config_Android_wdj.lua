-- Filename: config_91.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: ios 91 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "wdjphone"
end

function getBBSName( ... )
	return ""
end

--测试log开关
function isDebugModel( ... )
	return "true"
end

function getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(isDebugModel()),"isDebugModel")
	return dict
end

function getPidUrl( sessionid )
	local uid = Platform.getSdk():callStringFuncWithParam("getUid",nil) 
 	return "phone/login?token=" .. sessionid .. "&uid=" .. uid .. Platform.getUrlParam() .. "&bind=" .. Platform.getUUID()
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
	dict:setObject(CCString:create("金币"),"orderDesc")
	return dict
end

