-- Filename: config_baofeng.lua
-- Author: lu lu jin
-- Date: 2015-03-30
-- Purpose: 暴风平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "baofeng"
end

function getBBSName( ... )
	return "暴风社区"
end

function getAppId( ... )
	return "10062"
end

function getAppKey( ... )
	return "211erowjljfff%￥"
end

function getGameId( ... )
	return "86"
end

function getServerId( ... )
	return "25"
end

function getChannelId( ... )
	return "213"
end


function getAppName( ... )
	return "航海王"
end
--用来配置充值回调。（如果充值回调在本地可以在此方法配置）
function getPayNotifyUrl( ... )
	if Platform.isDebug() then
		return "http://124.42.71.49/phone/exchange/baofeng/cp/android"
	else
		return "http://hhwmapi.chaohaowan.com/phone/exchange/baofeng/cp/android"
	end
end

function getPidUrl( sessionid )
	local url = "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?userid=" .. Platform.getSdk():callStringFuncWithParam("getUid",nil) .. Platform.getUrlParam() .. "&bind=" .. Platform.getUUID()
 	return postString
end 

function setLoginInfo( jsonTable )
	 
	loginInfoTable.uid = jsonTable.uid
 	loginInfoTable.newuser = jsonTable.newuser
	print_table("setLoginInfo",loginInfoTable)
end

function getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppId()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	dict:setObject(CCString:create(getAppName()),"appName")
	dict:setObject(CCString:create(getGameId()),"gameId")
    dict:setObject(CCString:create(getServerId()),"serverId")
    dict:setObject(CCString:create(getChannelId()),"channelId")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
 	dict:setObject(CCString:create(getPayNotifyUrl()),"payUrl")
 	dict:setObject(CCString:create("cp"),"pl")
 	--游戏角色名
 	dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
 	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")

	return dict
end

function getUserInfoParam(gameState)
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

