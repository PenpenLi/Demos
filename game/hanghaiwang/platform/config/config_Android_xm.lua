-- Filename: config_xiaomi.lua
-- Author: chao he
-- Date: 2013-11-7
-- Purpose: android 小米 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "xmphone"
end


function getPidUrl( sessionid )
	local postString = "phone/login/" .. "?sid=" .. sessionid .. "&uid=".. Platform.getSdk():callStringFuncWithParam("getUid",nil) .. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
 	return postString
end 

function getBBSName( ... )
	return ""
end

function getPayParam( coins )
	require "script/model/user/UserModel"

	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(UserModel.getGoldNumber()),"gold_num")
	dict:setObject(CCString:create(UserModel.getVipLevel()),"vip")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
    dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
    dict:setObject(CCString:create(UserModel.getHeroLevel()),"appUlevel")

  
	return dict
end

function  getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create("2882303761517337997"),"appId")
	dict:setObject(CCString:create("5961733745997"),"appKey")
	return dict
end
