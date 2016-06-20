-- Filename: config_kupai.lua
-- Author: lu lu jin
-- Date: 2015-04-02
-- Purpose: 酷派平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "kpaiphone"
end

function getBBSName( ... )
	return "酷派社区"
end

function getAppId( ... )
	return "5000002193"
end

function getAppKey( ... )
	return "008fe9e33fa54a929eb0544941eefce7"
end

--应用私钥
function getPrivateKey( ... )
	return "MIICWwIBAAKBgQCH0PkzSdTETtu7hOKYqoDktqJs3J7j73hPwl/yvFye8Ot/FHJHj2bx0w8nyEBU3e1hllNq0QZQ6PFq3N+z9rgSeHs88VjGSyCgFEkCmlfB4ZefPBG9Ab9YO7Dj38ObVf9f4WnxLduyHiWsKPPwQLGTjIlb1h3fi+BJF/hiCRyS4QIDAQABAoGAZjo8KIetF6nHqMioCoNkC0MQ1OHm0uhf5aEHuVxgVt4+U+Pe9NASi3jy0l3fVkHJOIf+98qnd2UuueHQm9PbziUWUcgkz+UmQ909b7RR+SbdVAvQ93l3/LlOKLCyrgAyjKYWsixUyUoChvHYLljdMsoccBKt77Mp7mwSr134ecUCQQDjWshgcFF/bRbUFpgnOXqOJqoMMfIU49nSg6WbjOh7huZm4ofrrlJcs+6aykCRUBABvAfZ5boqmDFuPlgTGmHXAkEAmO2qOtGxuj9pngTbMNfOVIikzcjeVmGZMW4fyynMewJpMLGvRZjxGQ/hKixc9j90vApM3UtPNUEr7bSPwcqKBwJAQWcrP3rwJu0V5Rs+2AHT/LKotmtjzZiiX8nZST8m3eo3u58tJKJ4NQzZ9hN6sZLLmAQkag2JGZnAlos+wPgU7wJAcauOcaP2D/MchUkkx5xREEJ1BUS+BsUKwlQRq8hI5lH3cCtSlU/GPZOxENDi1GJ8WVzqnz5gBLyJc2lXxXrPtwJAIpllpnRu8LeNe6FN2h77mB46CPeq4kFj+4ys31Jc07n6nyvpydfieyLbAkDUnz2gbr7JeyIHjqoiuPqr3WP8lg=="
end

--平台公钥
function getPublicKey( ... )
	return "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCVs3LOBf1vQ4UBj1kQHRUzC4bKtZ3IK9fGqLyKMVsqskIjw/+EZS12H1M7nBBAfDWOWnwg+BzmtjnJxhAq7Yft3sjyDiwWPtbq2yb3B1DhTMpAT400EMNgMHAVjEIqXSDTqtgAtcTZb04M8Gs+jwvHj3/5xtTVMFoPgVsCRadnnwIDAQAB"
end

function getAppName( ... )
	return "航海王"
end
--用来配置充值回调。（如果充值回调在本地可以在此方法配置）
function getPayNotifyUrl( ... )
	if Platform.isDebug() then
		return "http://124.205.151.90/phone/exchange/kpaiphone/cp/android"
	else
		return "http://hhwmapi.chaohaowan.com/phone/exchange/kpaiphone/cp/android"
	end
end


function getPidUrl( sessionid )
	local url = "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?code=" .. Platform.sdkLoginInfo.sid .. Platform.getUrlParam() .. "&bind=" .. Platform.getUUID()
 	return postString
end 

function setLoginInfo( jsonTable )
	 
	loginInfoTable.uid = jsonTable.uid
 	loginInfoTable.newuser = jsonTable.newuser
 	loginInfoTable.token = jsonTable.access_token
 	loginInfoTable.openid = jsonTable.openid
	print_table("setLoginInfo",loginInfoTable)
end

function getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppId()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	dict:setObject(CCString:create(getAppName()),"appName")
	dict:setObject(CCString:create("1"),"screentOrient") -- 1竖屏，2横屏
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
 	dict:setObject(CCString:create(getPayNotifyUrl()),"payUrl")
 	dict:setObject(CCString:create("cp"),"pl")
 	dict:setObject(CCString:create(Platform.getPid()),"pid")
 	dict:setObject(CCString:create(loginInfoTable.token),"token")
 	dict:setObject(CCString:create(loginInfoTable.openid),"openid")
 	dict:setObject(CCString:create(getPrivateKey()),"privateKey")
 	dict:setObject(CCString:create(getPublicKey()),"publicKey")
 	--游戏角色名
 	dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
 	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	local waresid
	if(coins == 100)then
		waresid = 9
	elseif(coins == 300)then
		waresid = 2
	elseif(coins == 500)then
		waresid = 10
	elseif(coins == 1000)then
		waresid = 11
	elseif(coins == 2000)then
		waresid = 12
	elseif(coins == 5000)then
		waresid = 13
	elseif(coins == 10000)then
		waresid = 14
	elseif(coins == 20000)then
		waresid = 15
	elseif(coins == 10)then
		waresid = 4
	elseif(coins == 60)then
		waresid = 3
	elseif(coins == 980)then
		waresid = 1
	elseif(coins == 1980)then
		waresid = 7
	elseif(coins == 3280)then
		waresid = 6
	elseif(coins == 6480)then
		waresid = 5
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

