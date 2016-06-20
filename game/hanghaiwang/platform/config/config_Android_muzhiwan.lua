-- Filename: config_muzhiwan.lua
-- Author: lu lu jin
-- Date: 2015-03-18
-- Purpose: 拇指玩平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "mzwphone"
end

function getBBSName( ... )
	return "拇指玩"
end

function getAppId( ... )
	return "0"
end

function getAppKey( ... )
	return "0"
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
	dict:setObject(CCString:create(getPayNotifyUrl()),"payurl")
	dict:setObject(CCString:create(getAppId()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	dict:setObject(CCString:create(getAppName()),"appName")
	dict:setObject(CCString:create("0"),"orientation") --设置横竖屏，1横屏，0竖屏
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
	return dict
end

