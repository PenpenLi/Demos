-- Filename: config_cczhushou.lua
-- Author: lu lu jin
-- Date: 2016-02-01
-- Purpose: 虫虫助手平台配置
module("config", package.seeall)

loginInfoTable = {}
function getFlag( ... )
	return "cczhushou"
end

function getBBSName( ... )
	return ""
end

function getAppID( ... )
	return "103360"
end

function getAppKey( ... )
	return "d63504b9b503492bae05b01fdcc1622c"
end


function getPidUrl( sessionid )
	local url = "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?userid=" .. Platform.sdkLoginInfo.uid .. "&token=" .. Platform.sdkLoginInfo.sid .. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
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
	local waresid
	if(coins == 60)then
		waresid = 105283
	elseif(coins == 300)then
		waresid = 105284
	elseif(coins == 980)then
		waresid = 105285
	elseif(coins == 1980)then
		waresid = 105286
	elseif(coins == 3280)then
		waresid = 105287
	elseif(coins == 6480)then
		waresid = 105288
	elseif(coins == 10)then
		waresid = 105289
	elseif(coins == 100)then
		waresid = 105290
	elseif(coins == 500)then
		waresid = 105292
	elseif(coins == 1000)then
		waresid = 105293
	elseif(coins == 2000)then
		waresid = 105294
	elseif(coins == 5000)then
		waresid = 105295
	elseif(coins == 10000)then
		waresid = 105296
	elseif(coins == 20000)then
		waresid = 105297
	end
	dict:setObject(CCString:create(waresid),"waresid")
	return dict
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
