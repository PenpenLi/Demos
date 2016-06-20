-- Filename: config_kugou.lua
-- Author: lu lu jin
-- Date: 2015-05-26
-- Purpose: PPTV平台配置
module("config", package.seeall)

loginInfoTable = {}
function getFlag( ... )
	return "kugou"
end

function getBBSName( ... )
	return "酷狗社区"
end

--APPID
function getAppId( ... )
	return "1420"
end	
--APPKEY
function getAppKey( ... )
	return "IXefuoA3Y0ZPtdKBQhDeumyUgCj35jhg"
end
--MerchantId
function getMerchantId( ... )
	return "149"
end
--GameId
function getGameId( ... )
	return "10651"
end
--Code
function getCode( ... )
	return "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCxp8652/HV/nFFlWtPpelVdKJT+yFmjpEezRJpmOiHE4U+iN7zjr0XNJRnXvaH32E5oboSmr+jOHeVzfFPvLNUkDCJSAC3EqPVhUjfZXwz3CvTLcTF7i/GHvgRQx1KUgOxthu34BAfPdKatvOLYLOcnxswVAQB6Ej3uXh5ET836wIDAQAB"
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
 	local postString = url .. "?token=" .. sessionid .. "&uid=" ..  Platform.sdkLoginInfo.username .. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
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
    dict:setObject(CCString:create(getGameId()),"gameId")
    dict:setObject(CCString:create(getCode()),"code")
    dict:setObject(CCString:create(getMerchantId()),"merchantId")
    dict:setObject(CCString:create("1"),"screentOrient") -- 1竖屏，2横屏
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


