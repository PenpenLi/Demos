-- Filename: config_dianxin.lua
-- Author: lu lu jin
-- Date: 2015-05-04
-- Purpose: 单独电信平台配置
module("config", package.seeall)

loginInfoTable = {}
function getFlag( ... )
	return "dxphone"
end

function getBBSName( ... )
	return ""
end

--APPID
function getAppId( ... )
	return "5077733"
end	

function getAppKey( ... )
	return "40d930db1ebaf7009ae1cd8112470a6d"
end

function getClientId( ... )
	return "96516442"
end

function getClientSeret( ... )
	return "5f8b1dfc214b48649c5833b19fa630c9"
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
 	local postString = url .. "?token=" .. sessionid .. "&version=" .. Platform.sdkLoginInfo.version .. Platform.getUrlParam() .. "&bind=" ..  Platform.getUUID()
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
    dict:setObject(CCString:create(getClientId()),"clientId")
    dict:setObject(CCString:create(getClientSeret()),"clientSeret")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	dict:setObject(CCString:create(Platform.getPid()),"pid")
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


