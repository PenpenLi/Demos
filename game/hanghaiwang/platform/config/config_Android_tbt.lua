-- Filename: config_91.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: ios 91 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "tbtphone"
end

function getBBSName( ... )
	return "同步推社区"
end

function getAppId( ... )
	return "100150204"
end

function getAppKey( ... )
	return "Wi7QdSpAMCZm0yJVti6FcS*3MCwm0JgV"
end

function isDebug( ... )
	return "false"
end

--1竖屏 2横屏 3自动
function orient( ... )
	return "1"
end

function continueWhenCheckUpdateFailed( ... )
	return "true"
end

function getPidUrl( sessionid )
	return "phone/login?session=" .. sessionid .. Platform.getUrlParam() .. "&bind=" .. Platform.getUUID()
end 

function getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppId()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	dict:setObject(CCString:create(isDebug()),"isDebug")
	dict:setObject(CCString:create(orient()),"orient")
	dict:setObject(CCString:create(continueWhenCheckUpdateFailed()),"continueWhenCheckUpdateFailed")
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
	return dict
end
