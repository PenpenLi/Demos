-- Filename: config_zhongshouyou.lua
-- Author: lu lu jin
-- Date: 2015-03-05
-- Purpose: 中手游平台配置
module("config", package.seeall)

loginInfoTable = {}
function getFlag( ... )
	return "zsyphone"
end

function getBBSName( ... )
	return "中手游社区"
end

function getAppID( ... )
	return "5023944"
end

function getAppKey( ... )
	return "8996c9d49c4fcfc6b5d3c4b20db1f1b4"
end


function getPidUrl( sessionid )
	local url = "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?userid=" .. Platform.sdkLoginInfo.uid .. "&zsysign=" .. Platform.sdkLoginInfo.sid .. "&timestamp=" .. Platform.sdkLoginInfo.timestamp .. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
 	return postString
end 

function getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppID()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(Platform.getPid()),"pid")
	dict:setObject(CCString:create(NewLoginCtrl.getSelectServerInfo().name),"groupName")
	dict:setObject(CCString:create(UserModel.getUserUid()),"roleId")
	dict:setObject(CCString:create(UserModel.getUserName()),"roleName")

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

function setLoginInfo( jsonTable )
	 
	loginInfoTable.uid = jsonTable.uid
 	loginInfoTable.newuser = jsonTable.newuser
	print_table("setLoginInfo",loginInfoTable)
end

function getUserInfoParam(gameState)
    local dict = CCDictionary:create()
    dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
    dict:setObject(CCString:create(NewLoginCtrl.getSelectServerInfo().name),"groupName")
    dict:setObject(CCString:create(loginInfoTable.newuser),"newuser")
    dict:setObject(CCString:create(loginInfoTable.uid),"uid")
    if(tonumber(gameState) == 1)then
	    -- 下面的appUid和appUname暂时获取不到，先不用
	    dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	    dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
	    dict:setObject(CCString:create(UserModel.getUserUtid()),"appUtid")
	    dict:setObject(CCString:create(UserModel.getHeroLevel()),"appUlevel")
	end

	return dict
end
