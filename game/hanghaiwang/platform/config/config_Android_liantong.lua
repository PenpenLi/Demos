-- Filename: config_Android_jinli.lua
-- Author: kun liao
-- Date: 2014-06-23
-- Purpose: android 金立 平台配置
module("config", package.seeall)

loginInfoTable = {}


function getFlag( ... )
	return "liantong"
end


function getPidUrl( sessionid )
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
        local postString = "phone/login/" .. "?token=" .. sessionid..Platform.getUrlParam().."&bind=" .. Platform.getUUID()
 	return postString
end 


function getBBSName( ... )
	return "联通"
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
    dict:setObject(CCString:create("9022623518820150228180751012600"),"CLIENT_ID")
    dict:setObject(CCString:create("33f8346c837d409b"),"CLIENT_KEY")
    dict:setObject(CCString:create("http://124.42.71.49/phone/exchange/liantong/cp/android"),"requestUrl")

    return dict
end
