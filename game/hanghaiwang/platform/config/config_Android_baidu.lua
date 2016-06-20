-- Filename: config_91.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: ios 91 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "baiduphone"
end

function getBBSName( ... )
	return ""
end

function getAppId( ... )
	return "7185062"
end

function getAppKey( ... )
	return "KMBmAHc9g4liPFuaUV325W2C"
end

--1：正式模式 其他：测试模式
function setDomain( ... )
	return "1"
end

--是否竖屏
function isOritationPort( ... )
	return "true"
end

function getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppId()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	dict:setObject(CCString:create(setDomain()),"setDomain")
	dict:setObject(CCString:create(isOritationPort()),"isOritationPort")
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
	dict:setObject(CCString:create("金币"),"productName")
	return dict
end

