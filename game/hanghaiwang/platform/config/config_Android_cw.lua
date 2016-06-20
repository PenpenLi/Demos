-- Filename: config_Android_cw.lua
-- Author: kun liao
-- Date: 2015-3-11
-- Purpose: android 益玩 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "ywphone"
end


function getPidUrl( sessionid )
	local postString = "phone/login/" .. "?token=" .. sessionid 
		.. "&openid=" .. Platform.sdkLoginInfo.openId 
		.. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
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
	print("loginInfoTable.uid:",loginInfoTable.uid)
	print("loginInfoTable.username:",loginInfoTable.username)
	print("loginInfoTable.userid:",loginInfoTable.userid)
	print("loginInfoTable.newuser:",loginInfoTable.newuser)


end

function getGroupParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end



function getInitParam(  )
	local dict = CCDictionary:create()
    dict:setObject(CCString:create("10200"),"appId")
    dict:setObject(CCString:create("1L7mJAWP9d2vlpUb"),"signkey")
    dict:setObject(CCString:create("43481"),"packetid")
    --dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end