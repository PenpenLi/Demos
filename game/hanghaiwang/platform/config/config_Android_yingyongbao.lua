-- Filename: config_Android_yingyongbao.lua
-- Author: kun liao
-- Date: 2014-06-13
-- Purpose: android 应用宝 平台配置
module("config", package.seeall)

loginInfoTable = {}


function getFlag( ... )
	return "yingyongbao"
end

function getPidUrl( sessionid )
	local url = "phone/login/"
	local action = Platform.sdkLoginInfo.action
	local mid = Platform.sdkLoginInfo.mid
	if(action == "phoneQQAc")then
		local openid = Platform.sdkLoginInfo.openid
		local openkey = Platform.sdkLoginInfo.token
		local userip = Platform.sdkLoginInfo.ip
		local postString = url .. "?openid=" .. openid.."&openkey="..openkey.."&userip="..(userip or "").."&action="..action.."&mid="..mid..Platform.getUrlParam().."&bind=" .. Platform.getUUID()
		return postString
 	elseif (action == "weixinAc")then
 		local openid = Platform.sdkLoginInfo.openid
 		local accessToken = Platform.sdkLoginInfo.accessToken
		local postString = url .. "?accessToken=" .. accessToken.."&action="..action.."&openid="..openid.."&mid="..mid..Platform.getUrlParam().."&bind=" .. Platform.getUUID()
		return postString
 	end
end 


function getInitParam(  )
	local dict = CCDictionary:create()
	if Platform.isDebug() then
		dict:setObject(CCString:create("true"),"isDebug")
	end
	dict:setObject(CCString:create("SaveGameCoinsWithNum"),"payType")
    dict:setObject(CCString:create("1104294477"),"qqAppId")
    dict:setObject(CCString:create("oWhdk4tEyKX2g18U"),"qqAppKey")
    dict:setObject(CCString:create("wxa7bb139335643e22"),"wxAppId")
    dict:setObject(CCString:create("a623b4abf29ec45aafdadc6e3dee5aac"),"wxAppKey")
    dict:setObject(CCString:create(tostring(Platform.isDebug())),"isDebug")
    dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end



function getBBSName( ... )
	return ""
end

function getPayParam( coins )
	local dict = CCDictionary:create()
    dict:setObject(CCString:create(coins),"coins")
    dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
    dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
 	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
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

function setLoginInfo( xmlTable )
  print("LoginInfo:",xmlTable)
  loginInfoTable = xmlTable
end