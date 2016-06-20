-- Filename: config_Android_jinli.lua
-- Author: kun liao
-- Date: 2014-06-23
-- Purpose: android 金立 平台配置
module("config", package.seeall)

loginInfoTable = {}


function getFlag( ... )
	return "jinli"
end





function getPidUrl( sessionid )
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
        local postString = "phone/login/" .. "?userid=" .. sessionid.."&token="..Platform.sdkLoginInfo.token..Platform.getUrlParam().."&bind=" .. Platform.getUUID()
 	return postString
end 


function getBBSName( ... )
	return "用户社区"
end

function getPayParam( coins )
	local dict = CCDictionary:create()
    dict:setObject(CCString:create(coins),"coins")
    dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
    dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
 	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
    return dict
end

function setLoginInfo( xmlTable )
    print("LoginInfo:",xmlTable)
    loginInfoTable = xmlTable
    print("loginInfoTable.uid:",loginInfoTable.uid)
    print("loginInfoTable.username:",loginInfoTable.username)
    print("loginInfoTable.userid:",loginInfoTable.userid)
end
function getInitParam(  )
    local dict = CCDictionary:create()
    dict:setObject(CCString:create("61916DD7D7C747E782DC8B8EF1EF13FE"),"apiKey")
    dict:setObject(CCString:create("21C0F9CB22B64E05979BC23AC7CD2D92"),"secretKey")
     if (Platform.isDebug()) then
        dict:setObject(CCString:create("http://124.205.151.90/phone/exchange/jinli/cp/android?action=GetTokenForEx"),"requestUrl")
    else
        dict:setObject(CCString:create(Platform.getHost().."phone/exchange/jinli/cp/android?action=GetTokenForEx"),"requestUrl")
    end
    return dict
end
