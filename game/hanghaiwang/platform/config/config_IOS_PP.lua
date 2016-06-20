-- Filename: config_91.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: ios 91 平台配置
module("config", package.seeall)

UIInterfaceOrientationPortrait           = "1"
UIInterfaceOrientationPortraitUpsideDown = "2"
UIInterfaceOrientationLandscapeLeft      = "3"
UIInterfaceOrientationLandscapeRight     = "4"



loginInfoTable = {}
function getFlag( ... )
	return "ppzhushou"
end

function getBBSName( ... )
	return "PP社区"
end

function getHost( ... )
	local host = "http://hhwmapi.chaohaowan.com/"
	if(Platform.isDebug()) then
		host = "http://124.42.71.49/"
	end
	return host
end

function getPidUrl( sessionid )
	local url = "phone/login"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
    -- print("loginUrl:",url)
    -- local uin = Platform.getSdk():callStringFuncWithParam("getUin",nil)
	local postString = url .. "?token=" .. sessionid .. Platform.getUrlParam() .. "&bind=" .. Platform.getUUID()
 	return postString
end 

function getInitParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create("5835"),"appID")
	dict:setObject(CCString:create("3c1ccc8702c95160ffccee7a176773ca"),"appKey")
	dict:setObject(CCString:create("0"),"openRecharge")
	dict:setObject(CCString:create("1"),"UIInterfaceOrientationPortrait")
	dict:setObject(CCString:create("1"),"UIInterfaceOrientationPortraitUpsideDown")
	dict:setObject(CCString:create("0"),"UIInterfaceOrientationLandscapeLeft")
	dict:setObject(CCString:create("0"),"UIInterfaceOrientationLandscapeRight")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(Platform.getLastLoginGroup()),"groupId")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	-- dict:setObject(CCString:create(loginInfoTable.userid),"userid")
	-- dict:setObject(CCString:create(loginInfoTable.username),"username")
    dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	dict:setObject(CCString:create("金币"),"title")
	return dict
end

function setLoginInfo( xmlTable )
	print("LoginInfo:",xmlTable)
	loginInfoTable = xmlTable
	print("loginInfoTable.uid:",loginInfoTable.uid)
	print("loginInfoTable.username:",loginInfoTable.username)
	print("loginInfoTable.userid:",loginInfoTable.userid)
	--loginInfoTable.uid = xmlTable.uid
end