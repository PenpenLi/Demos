-- Filename: config_chwsdk.lua
-- Author: lu lu jin
-- Date: 2015-11-06
-- Purpose: 超好玩平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	local other_pl = Platform.getSdk():callStringFuncWithParam("getOtherPl",nil) -- "gwphone"--
	print("pl2=====",other_pl)
	return other_pl
end

function getOther_pl( ... )
	return "chwphone"
end

function getBBSName( ... )
	return "超好玩社区"
end

function getAppId( ... )
	return "1001"
end

function getAppKey( ... )
	return "HhWzlIyIg0M2aerNoxze"
end

function getWxAppId( ... )
	return "wxff6bc07f3cd70f78"
end

function getQQAppId( ... )
	return ""
end

function getAppName( ... )
	return "航海王"
end
--用来配置充值回调。（如果充值回调在本地可以在此方法配置）
function getPayNotifyUrl( ... )
	if Platform.isDebug() then
		return ""
	else
		return ""
	end
end

function getHost( ... )
	local host = nil
	if Platform.isDebug() then
		host = "http://192.168.1.113:17602/"
	else
		host = "http://hhwmapi.chaohaowan.com/"
	end
	return host
end

function getPidUrl( sessionid )
	local url = "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
    local postString = url .. "?token=" .. sessionid .. Platform.getUrlParam() .."&bind=" .. Platform.getUUID()
 	return postString
end 

function setLoginInfo( jsonTable )
	 
	loginInfoTable.uid = jsonTable.uid
 	loginInfoTable.newuser = jsonTable.newuser
	logger:debug("setLoginInfo",loginInfoTable)
end

function getInitParam( ... )
	local dict = CCDictionary:create()
	if getFlag() == "gwphone" then 
		dict:setObject(CCString:create(getWxAppId()),"wxappid")
	end
	-- dict:setObject(CCString:create(getQQAppId()),"qqappid")
	dict:setObject(CCString:create(tostring(Platform.isDebug())),"debug")
	dict:setObject(CCString:create(getPayNotifyUrl()),"payurl")
	dict:setObject(CCString:create(getAppId()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	dict:setObject(CCString:create(getAppName()),"appName")
	dict:setObject(CCString:create("1"),"screentOrient") -- 1竖屏，2横屏
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	dict:setObject(CCString:create("金币"),"currency")
	dict:setObject(CCString:create("航海王金币"),"productname")
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
