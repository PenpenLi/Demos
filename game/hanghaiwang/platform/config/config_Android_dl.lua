-- Filename: config_dl.lua
-- Author: lu lu jin
-- Date: 2015-03-13
-- Purpose: 当乐平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "dlazphone"
end

function getBBSName( ... )
	return "当乐社区"
end

function getAppId( ... )
	return "3056"
end

function getAppKey( ... )
	return "BdmQ5LgI"
end

function getMerchantId( ... )
	return "662"
end

function getServerSeqNum( ... )
	return "1"
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
		host = "http://124.205.151.90/"
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
	local postString = url .. "?token=" .. sessionid .. "&mid=".. Platform.getSdk():callStringFuncWithParam("getUserid",nil) .. Platform.getUrlParam().. "&action=newsdk" .."&bind=" .. Platform.getUUID()
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
	dict:setObject(CCString:create(getMerchantId()),"merchantId")
	dict:setObject(CCString:create(getServerSeqNum()),"serverSeqNum")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
	dict:setObject(CCString:create(NewLoginCtrl.getSelectServerInfo().name),"groupName")
	dict:setObject(CCString:create("金币"),"productName")
	dict:setObject(CCString:create("金币"),"body")
	return dict
end

