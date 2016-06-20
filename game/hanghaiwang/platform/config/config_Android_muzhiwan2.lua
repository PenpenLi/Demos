-- Filename: config_muzhiwan.lua
-- Author: lu lu jin
-- Date: 2015-03-18
-- Purpose: 拇指玩平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "mzw2phone"
end

function getBBSName( ... )
	return "K拇指玩"
end

function getPidUrl( sessionid )
	local url = "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
   local postString = url .. "?token="..sessionid..Platform.getUrlParam().."&bind=" ..  Platform.getUUID()
 	return postString
end 

function setLoginInfo( jsonTable )
	 
	loginInfoTable.uid = jsonTable.uid
 	loginInfoTable.newuser = jsonTable.newuser
	print_table("setLoginInfo",loginInfoTable)
end

function getInitParam( ... )
	local dict = CCDictionary:create()
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(NewLoginCtrl.getSelectServerInfo().name),"groupName")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
    dict:setObject(CCString:create(UserModel.getHeroLevel()),"appUlevel")
    dict:setObject(CCString:create("金币"),"productName")
	return dict
end

function getUserInfoParam( gameState )
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

