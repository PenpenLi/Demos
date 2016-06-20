-- Filename: config_huawei.lua
-- Author: lu lu jin
-- Date: 2015-04-03
-- Purpose: 华为平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "hwphone"
end

function getBBSName( ... )
	return "华为社区"
end

--APPID
function getAppId( ... )
	return "10369917"
end	
--支付ID
function getAppKey( ... )
	return "900086000020119614"
end
--浮标密钥
function getBuoSecret( ... )
	return "MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAIujTiIAMJKGCw/ff1S23dXzvBSn8uJL2uw918XLvXu+NHHiVYenX6EzzcZYo2XbpbjcgrglYE9m/nUrXMhG4eS/NYvIB0qLTLLx6K4uxIu2n6okgMOZb8LkySL6ZLnL9yuwVJGQze5hY9LukTna+TJF9nUbp+9FiSC1ubNiYgexAgMBAAECgYAVL26QPAUihdGx08/Gs4POjQ8Q9zYjXSzWwL821CVoW8ArMxKU5TDeDTUADbyknIF1HYd7lrgY8+BROIX4IMDusRLeRE8T11uHXAEHGBDu0FVq7ioBwtWpCKpTopFredZi5Fw/9dQ0BB0jBxfeXjmKqWnP5odxCwqY3jW7ktCkAQJBAMmR3vJaCNPppmqtjX4fREqBudhe9qp9uKN0UcsgwjpgPiYZP77/PR1/OT7RwlZNhp+PlQ3ynWowedX79jZ41XECQQCxWDPfMbhLcm1ShHOx9UBi+Iwt1Ghe4asjZ4Bk3mu0qQJS+bv/RZ7mTLDaSMMvgK0k/Ih0TOBNGs97SaBsjjZBAkA1jnmDQSLZU1pxO729hgc6GK/NaqX1dMQLQgu9ge25XvsEWm8Si3SskrIeG9Ob5KthV+ANvanPniOxFGo93OsxAkBaTiu7z7mk0ZPRnRi82cH7o8zd2Xd8OTXIRYAf3RLDX/yK/Bg7GNydMRgtTzf1DHUejGl/r1XYbXqRsSA7pv8BAkA0UtnGdeiELW38VXg/bNTxTqDtU6jFxIqDYINAUYRODSVW6VBQj5jb3fzaleJVFwCBr4OjSuXkhbVgpqKpbU5R"
end
--支付私钥
function getPayRsaPrivate( ... )
	return "MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAzVxUOomgtHRMDL5iAJKfy4AUJm72QbYvHDne8zSkLFBBsAaP6en4Y/wS+8YhpQVdOu28xaDADK7WZMLnA7AK/wIDAQABAkAcmxTchplNKboCOG7cV5BMv42PAPvqkV8klmcZB6cqyM8nSP2T1gU+rbv7NyoTu/vbswyTYGqS9/UlDUCKsKm5AiEA9VwDeNOsavQaGgxjcWyfaCllFz6srPo4fvB2oT58eJsCIQDWRD+Gj4kYwriI/aexWEfoO+Fr40wvd+e22sg7VxKjbQIgUitqjkB1cawmQar8crPp/rw+OrampZd27CwjzoRasxkCIQDBvBnYWEY03jOuofOTVehGooYTYATN0tPvsOhlRziyDQIgEH2s8AKDjcVvwawUN9L8C1AtahupYv6iSLY1GLCKgug="
end
--支付公钥
function getPayRsaPublic( ... )
	return "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAM1cVDqJoLR0TAy+YgCSn8uAFCZu9kG2Lxw53vM0pCxQQbAGj+np+GP8EvvGIaUFXTrtvMWgwAyu1mTC5wOwCv8CAwEAAQ=="
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
 	local postString = url .. "?token=" .. sessionid .. Platform.getUrlParam().. "&uid=" .. Platform.getSdk():callStringFuncWithParam("getUid",nil).."&bind=" ..  Platform.getUUID()
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
	dict:setObject(CCString:create(getBuoSecret()),"duoSecret")
	dict:setObject(CCString:create(getPayRsaPublic()),"payRsaPublic")
	dict:setObject(CCString:create(getPayRsaPrivate()),"payRsaPrivate")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	dict:setObject(CCString:create("cp"),"pl")
	dict:setObject(CCString:create("金币"),"productName")
	dict:setObject(CCString:create("中手游"),"companyName")
	dict:setObject(CCString:create("1"),"screentOrient")
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

	end

	return dict
end

