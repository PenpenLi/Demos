-- Filename: config_Android_kuwo.lua
-- Author: kun liao
-- Date: 2015-9-18
-- Purpose: android 酷我 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "kuwo"
end


function getPidUrl( sessionid )
	local postString = "phone/login/" .. "?access_token=" .. sessionid 
		.. "&uid=" .. Platform.sdkLoginInfo.uid 
		.. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
 	return postString
end 


function getBBSName( ... )
	return "今日头条"
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
    dict:setObject(CCString:create("160cf76f5d38a173"),"clientId")
    dict:setObject(CCString:create("aff1415be79a74b1035f32e63496cbee"),"clientSecret")
    dict:setObject(CCString:create("9109e1fd0d5aa7d502b55b8da0f71659"),"payKey")
    dict:setObject(CCString:create("金币"),"productName")
    
	return dict
end

function getHost( ... )
	local host = nil
	if Platform.isDebug() then
		host = "http://124.42.71.49/"
	else
		host = "http://hhwmapi.chaohaowan.com/"
	end
	return host
end