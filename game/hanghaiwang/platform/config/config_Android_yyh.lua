-- Filename: config_yyh.lua
-- Author: lu lu jin
-- Date: 2015-04-03
-- Purpose: 华为平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "yyhphone"
end

function getBBSName( ... )
	return "应用汇社区"
end

--APPID
function getAppId( ... )
	return "10662"
end	

function getAppKey( ... )
	return "8z513Z52E6CMxXgF"
end

function getPayId( ... )
	return "5000383332"
end

function getPayKey( ... )
	return "Qzk2NjRGRjQ1QjVDMjM5MkZDRDNDNzkzMjREMEYyMDdDMTQ4NzNGNk1UUTFNRFF6TmpNM09ETTVNamMzTWpnNE1ERXJNamN6TURnNU5UUTNNamd4TWpneU56azVORGc1TnpZNE1UUTVOakEwTlRJM01ESTVOekF6"
end

function getAppName( ... )
	return "航海王"
end
--用来配置充值回调。（如果充值回调在本地可以在此方法配置）
function getPayNotifyUrl( ... )
	if Platform.isDebug() then
		return "http://124.205.151.90/phone/exchange/yyhphone/cp/android"
	else
		return "http://hhwmapi.chaohaowan.com/phone/exchange/yyhphone/cp/android"
	end
end


function getPidUrl( sessionid )
	local url = "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
 	local postString = url .. "?ticket=" .. sessionid .. Platform.getUrlParam() .. "&bind=" ..  Platform.getUUID()
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
    dict:setObject(CCString:create(getPayId()),"payId")
    dict:setObject(CCString:create(getPayKey()),"payKey")
 	dict:setObject(CCString:create("hhw_yyh_dou"),"yyhDou")
    dict:setObject(CCString:create(getPayNotifyUrl()),"notifyUrl")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	local waresid
	if(coins == 100)then
		waresid = 2
	elseif(coins == 300)then
		waresid = 3
	elseif(coins == 500)then
		waresid = 4
	elseif(coins == 1000)then
		waresid = 5
	elseif(coins == 2000)then
		waresid = 6
	elseif(coins == 5000)then
		waresid = 7
	elseif(coins == 10000)then
		waresid = 8
	elseif(coins == 20000)then
		waresid = 9
	elseif(coins == 10)then
		waresid = 1
	elseif(coins == 60)then
		waresid = 10
	elseif(coins == 980)then
		waresid = 11
	elseif(coins == 1980)then
		waresid = 12
	elseif(coins == 3280)then
		waresid = 13
	elseif(coins == 6480)then
		waresid = 14
	end
	dict:setObject(CCString:create(waresid),"waresid")
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

