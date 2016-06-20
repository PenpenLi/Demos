-- Filename: Platform.lua
-- Author: baoxu
-- Date: 2014-2-13
-- Purpose: PPS 平台接入数据定义
module("config", package.seeall)

local loginInfoTable = {}

function getFlag( ... )
	return "ppsphone"
end



function getPidUrl( sessionid )
	local url = "phone/login/"
	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .."?ppssign=" .. sessionid ..  "&uid=" .. Platform.sdkLoginInfo.uid.."&ppstime="..Platform.sdkLoginInfo.time..Platform.getUrlParam().. "&bind=" .. Platform.getUUID()
	print("userid = ",Platform.getSdk():callStringFuncWithParam("getUid",nil))
 	return postString
end 

function getBBSName( ... )
	return "PPS社区"
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
   
end



function getInitParam( ... )
	local dict = CCDictionary:create()
    dict:setObject(CCString:create("3314"),"gameid")
   
	return dict
end
