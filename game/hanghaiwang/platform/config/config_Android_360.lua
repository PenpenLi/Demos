-- Filename: config_360.lua
-- Author: lu lu jin
-- Date: 2015-03-11
-- Purpose: 360平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "360azphone"
end

function getBBSName( ... )
	return "奇虎社区"
end

function getAppId( ... )
	return "1"
end

function getAppKey( ... )
	return "1"
end

function getPayNotifyUrl( ... )
	if Platform.isDebug() then
		return "http://124.205.151.90/phone/exchange/360azphone/cp/android"
	else
		return "http://hhwmapi.chaohaowan.com/phone/exchange/360azphone/cp/android"
	end
end

function getHost( ... )
	local host = nil
	if Platform.isDebug() then
		host = "http://124.205.151.90/"
	else
		host = "http://hhwmapi.chaohaowan.com/"
	end
	return host
end

function getPidUrl( sessionid )
	local url = "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?token=" .. sessionid .."&bind=" .. Platform.getUUID() .. Platform.getUrlParam()
 	return postString
end 

function setLoginInfo( jsonTable )
	loginInfoTable.access_token = jsonTable.access_token
	loginInfoTable.uid = jsonTable.uid
	loginInfoTable.userid = jsonTable.userid
	loginInfoTable.uname = jsonTable.uname
	print_table("setLoginInfo",loginInfoTable)
end

function getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getPayNotifyUrl()),"payurl")
	dict:setObject(CCString:create("10"),"rate")
	dict:setObject(CCString:create("100"),"productid")
	dict:setObject(CCString:create("金币"),"productname")
	dict:setObject(CCString:create("1"),"screentOrient") -- 1竖屏，2横屏
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")

	dict:setObject(CCString:create(loginInfoTable.access_token),"access_token")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(loginInfoTable.userid),"userid")
	dict:setObject(CCString:create(loginInfoTable.uname),"username")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
	return dict
end

function getWxShare( ... )
  local result = Platform.getSdk():callStringFuncWithParam("getWxShare",nil)
  if result ~= nil then
      return result
  else
      return "true"
  end
end
