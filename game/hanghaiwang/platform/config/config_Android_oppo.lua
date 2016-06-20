-- Filename: config_91.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: ios 91 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "oppo"
end

function getBBSName( ... )
	return ""
end

function getAppId( ... )
	return "4840"
end

function getAppKey( ... )
	return "40Ko53W4wYyokc0840CW0k4sK"
end

function getAppSecret( ... )
	return "bbcCBF627FDF0c352cc91f8A422d43eA"
end

--测试log开关
function isDebugModel( ... )
	return "false"
end

--true为竖屏
function isOritationPort( ... )
	return "true"
end

--是否支持游戏内切换账号
function proInnerSwitcher( ... )
	return "true"
end

function getPayCallbackUrl( ... )
	if Platform.isDebug() then
		return "http://124.205.151.90/phone/exchange/oppo/cp/android"
	end
	return "http://hhwmapi.chaohaowan.com/phone/exchange/oppo/cp/android"
end

function getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppId()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	dict:setObject(CCString:create(getAppSecret()),"appSecret")
	dict:setObject(CCString:create(isDebugModel()),"isDebugModel")
	dict:setObject(CCString:create(isOritationPort()),"isOritationPort")
	dict:setObject(CCString:create(proInnerSwitcher()),"proInnerSwitcher")
	return dict
end

function getPidUrl( sessionid )
	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
 	return "phone/login?token=" .. sessionid .. "&uid=" .. Platform.sdkLoginInfo.uid .. Platform.getUrlParam() .. "&bind=" .. Platform.getUUID()
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
	dict:setObject(CCString:create("航海王金币充值"),"productDesc")
	return dict
end

