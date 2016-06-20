-- Filename: config_Android_jrtt.lua
-- Author: kun liao
-- Date: 2015-9-9
-- Purpose: android 今日头条 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "leshi"
end


function getPidUrl( sessionid )
	local postString = "phone/login/" .. "?access_token=" .. sessionid .. "&uid=" .. Platform.sdkLoginInfo.uid .. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
 	return postString
end 


function getBBSName( ... )
	return ""
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(loginInfoTable.newuser),"newuser")
	return dict
end

function getUserInfoParam(gameState)
	require "script/model/user/UserModel"
    local dict = CCDictionary:create()
    dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
    dict:setObject(CCString:create(NewLoginCtrl.getSelectServerInfo().name),"groupName")
    dict:setObject(CCString:create(loginInfoTable.newuser),"newuser")
    if(tonumber(gameState) == 1)then
	    -- 下面的appUid和appUname暂时获取不到，先不用
	    dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	    dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
	    dict:setObject(CCString:create(UserModel.getUserUtid()),"appUtid")
	    dict:setObject(CCString:create(UserModel.getHeroLevel()),"appUlevel")
	end

	return dict
end

function setLoginInfo( xmlTable )
	print("LoginInfo:",xmlTable)
	loginInfoTable = xmlTable
end

function getGroupParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end



function getInitParam(  )
	local dict = CCDictionary:create()
	  dict:setObject(CCString:create(get_Host().."phone/exchange/leshi/cp/android"),"notify_url")
	return dict
end




 function get_Host( ... )
    
    local host

    if (Platform.isDebug()) then
        host = "http://124.205.151.90/"
    else
    	host = Platform.getHost()
    end

   
    return host
end