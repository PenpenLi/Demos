-- Filename: config_lenovo.lua
-- Author: lu lu jin
-- Date: 2015-03-27
-- Purpose: 联想平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "lianxiang"
end

function getBBSName( ... )
	return ""
end

function getAppId( ... )
	return "1510190725976.app.ln"
end

function getAppKey( ... )
	return "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAJaJX9/Ii6pCiAkVkxZEXltxZRk8Q+EjNDXkG7vZ1NX0diVQtyoFwee8tbvX1KUNMCO/wpDUpXBPFJ2uuuubG4YYyt83zestOaIG93612r73Ucp5PLlJPFO6ZYFzd3guKxT8jpxHbqA9b3lw9Jz+c3Np+J/lbjDvJw6s+muscJPvAgMBAAECgYAsp8nCB6qushfKohTE6TkYZTX5W3BDa/8D8YvsmLzTTzZw8VW0aIrR5KAAfhD9eUELicn8zqfY/gx+jiOy2os6MPNn3v6BtHrNW3ltfC0yJH1fYDaPbLF2To5gvmFHJIkeZpNK4zB8gECQzLgizc91V/sXPTjVwMO/tQph202sMQJBAOqfw0yOppz0eytH+DfA3tx3q+rZPU6HLBKfOPEOLxnNF0PbtskFa+gfRFLCnzGdVGi/oe8isH48UT4psys8iUkCQQCkQGd1cNl3z3U7EIxODhlWXWS1NXd8VduVVIv/tHfXfOJZYR3mPG/osHBbdDGGYkefVrxa0Z5dOV+S5QOX0at3AkEAuxs9fEgmxvSRZSq34H6HO/qTt24XXhCeLRudJV/SYBkWfJ8zXYxdSXfl3LooikCVmBN66GIZrhIcGB7ZK5nTQQJBAJrTWrKJPXSCSa7zWk35XEjcoCFv1MGO7P1GRPEz3ANz5Kj7soNkVNix+Dc8v7I80eaQi9vP28dkXYLJ/SkOquECQAMrIA7+zqQuACHcz1tqTEPhxP4fdPdbXVCwecZ9mFS5h2ITpMH5ML3s03UgHqavGjG5AMhe1jXi4vnzoQ/X/OU="
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
	local postString = url .. "?lpsust=" .. sessionid .. "&realm=" .. getAppId() .. "&account=".. Platform.getSdk():callStringFuncWithParam("getLoginName",nil) .. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
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
	local waresid
	if(coins == 60)then
		waresid = 24982
	elseif(coins == 300)then
		waresid = 24983
	elseif(coins == 980)then
		waresid = 24984
	elseif(coins == 1980)then
		waresid = 24985
	elseif(coins == 3280)then
		waresid = 24986
	elseif(coins == 6480)then
		waresid = 24987
	elseif(coins == 10)then
		waresid = 44059
	elseif(coins == 100)then
		waresid = 44065
	elseif(coins == 500)then
		waresid = 44067
	elseif(coins == 1000)then
		waresid = 44068
	elseif(coins == 2000)then
		waresid = 44069
	elseif(coins == 5000)then
		waresid = 44070
	elseif(coins == 10000)then
		waresid = 44071
	elseif(coins == 20000)then
		waresid = 44074
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

