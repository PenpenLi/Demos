-- Filename: config_Android_yygame.lua
-- Author: kun liao
-- Date: 2014-07-02
-- Purpose: android YY 平台配置
module("config", package.seeall)

loginInfoTable = {}
UIInterfaceOrientationPortrait           = "1"
UIInterfaceOrientationPortraitUpsideDown = "2"
UIInterfaceOrientationLandscapeLeft      = "3"
UIInterfaceOrientationLandscapeRight     = "4"

function getFlag( ... )
	return "YY"
end


function getPidUrl( sessionid )
	local url = "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
    local postString = url .. "?token=" .. sessionid..Platform.getUrlParam().."&bind=" ..  Platform.getUUID()
 	return postString
end 



function getBBSName( ... )
	return "用户社区"
end

function getPayParam( coins )
	local dict = CCDictionary:create()
    dict:setObject(CCString:create(coins),"coins")
    dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
    dict:setObject(CCString:create(UserModel.getUserName()),"appName")
    dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	  dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
 	  dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
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
  loginInfoTable = xmlTable
end

function getInitParam( )
  local dict = CCDictionary:create()
  dict:setObject(CCString:create("MHANG"),"appid")
  dict:setObject(CCString:create("5f1241db413a4ef78bd424dd3af3101d"),"appkey")
  return dict
end