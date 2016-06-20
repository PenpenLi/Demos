-- Filename: config_Android_meizu.lua
-- Author: kun liao
-- Date: 2015-06-24
-- Purpose: 魅族 平台配置
module("config", package.seeall)


loginInfoTable = {}
function getFlag( ... )
  return "meizu"
end

function getBBSName( ... )
  return "魅族"
end

function getPidUrl( sessionId )
        local postString = "phone/login/" .. "?sessionId=" .. sessionId.."&uid="..Platform.sdkLoginInfo.uid..Platform.getUrlParam().."&bind=" .. Platform.getUUID()
  return postString
end 

function getInitParam( )
  local dict = CCDictionary:create()
  dict:setObject(CCString:create("2526644"),"appid")
  dict:setObject(CCString:create("40d7db7b4e0f47ef82c46a7200169d7c"),"appkey")
  if(Platform.isDebug()) then
    dict:setObject(CCString:create("http://124.205.151.90/phone/exchange/meizu/cp/android?action=GetTokenForEx"),"payUrl")
  else
    dict:setObject(CCString:create(Platform.getHost().."phone/exchange/meizu/cp/android?action=GetTokenForEx"),"payUrl")
  end
  return dict
end

function getPayParam( coins )
  local dict = CCDictionary:create()
  dict:setObject(CCString:create(coins),"coins")
  dict:setObject(CCString:create(loginInfoTable.uid),"uid")
  dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
  dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
  return dict
end

function setLoginInfo( xmlTable )
    print("LoginInfo:",xmlTable)
    loginInfoTable = xmlTable
end
