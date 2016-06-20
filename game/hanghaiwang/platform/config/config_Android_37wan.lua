-- Filename: Platform.lua
-- Author: baoxu
-- Date: 2013-11-25
-- Purpose: 


module("config", package.seeall)

function getFlag( ... )
	return "37wan"
end

loginInfoTable = {}

function getPidUrl( sessionid )
	local postString = "phone/login/" .. "?token=" .. Platform.getSdk():callStringFuncWithParam("getUToken",nil) .."&uid=" .. Platform.getSdk():callStringFuncWithParam("getUid",nil) .. "&userName=" .. Platform.getSdk():callStringFuncWithParam("getUName",nil) .. "&localtime="  .. Platform.getSdk():callStringFuncWithParam("getLTime",nil) .. "&action=newSdkUp" .. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
    print("userid = ",Platform.getSdk():callStringFuncWithParam("getUid",nil))
    print("username = ",Platform.getSdk():callStringFuncWithParam("getUName",nil))
 	return postString
end 

function getAppId( ... )
	return "1001044"
end

function getAppKey( ... )
	return "azkuOK4s.6NYDQcxFS7Zvhfo-gHjwenU"
end

function getBBSName( ... )
	return ""
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
 	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
 	dict:setObject(CCString:create(NewLoginCtrl.getSelectServerInfo().name),"groupName")
 	--游戏角色名
 	dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
 	dict:setObject(CCString:create(UserModel.getHeroLevel()),"appUlevel")
 	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	return dict
end

function getUserInfoParam( gameState )
	require "script/model/user/UserModel"
    local dict = CCDictionary:create()
    dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
    dict:setObject(CCString:create(NewLoginCtrl.getSelectServerInfo().name),"groupName")
    dict:setObject(CCString:create(loginInfoTable.newuser),"newuser")
    dict:setObject(CCString:create(loginInfoTable.uid),"uid")
    if(tonumber(gameState) == 1)then
        dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	    dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
	    dict:setObject(CCString:create(UserModel.getUserUtid()),"appUtid")
	    dict:setObject(CCString:create(UserModel.getHeroLevel()),"appUlevel")
	    dict:setObject(CCString:create(UserModel.getGoldNumber()),"appUgold")
	    dict:setObject(CCString:create(UserModel.getVipLevel()),"appUvip")
	end
	--print("gameState = ",gameState)
	return dict
end

function setLoginInfo( xmlTable )
	print("LoginInfo:",xmlTable)
	loginInfoTable = xmlTable
	print("loginInfoTable.uid:",loginInfoTable.uid)
	print("loginInfoTable.username:",loginInfoTable.username)
	print("loginInfoTable.userid:",loginInfoTable.userid)
	print("loginInfoTable.newuser:",loginInfoTable.newuser)
end

function getInitParam(  )
    local dict = CCDictionary:create()

    dict:setObject(CCString:create("1001210"),"appId")
    dict:setObject(CCString:create("m6KC07v4S1Ju89YTzl:BGaFLnRPQexy*"),"appKey")
    return dict
end
