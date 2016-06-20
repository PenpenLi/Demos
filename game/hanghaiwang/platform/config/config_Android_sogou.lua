-- Filename: config_sogou.lua
-- Author: lu lu jin
-- Date: 2015-03-16
-- Purpose: 搜狗平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "sogou"
end

function getBBSName( ... )
	return ""
end

function getAppId( ... )
	return "631"
end

function getAppKey( ... )
	return "c855db9d1c54474de4c9510dd386aef287fde6aec5f3e47dc5f67bae531a9045"
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
    local postString = url .. "?token=" .. sessionid .."&uid=" .. Platform.sdkLoginInfo.uid .. Platform.getUrlParam() .."&bind=" .. Platform.getUUID()
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

function getWxShare( ... )
  local result = Platform.getSdk():callStringFuncWithParam("getWxShare",nil)
  if result ~= nil then
      return result
  else
      return "true"
  end
end