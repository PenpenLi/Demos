-- Filename: config_youmi.lua
-- Author: lu lu jin
-- Date: 2015-03-11
-- Purpose: 有米平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "owan"
end

function getBBSName( ... )
	return "偶玩社区"
end

function getAppId( ... )
	return "6c3ea63b7c954e18"
end

function getAppKey( ... )
	return "3858030030583645"
end

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
	local postString = url .."?owansign=" .. sessionid ..  "&uid=" .. Platform.sdkLoginInfo.uid.."&owantime="..Platform.sdkLoginInfo.time..Platform.getUrlParam().. "&bind=" .. Platform.getUUID()
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

	dict:setObject(CCString:create("0"),"openRecharge")
	dict:setObject(CCString:create("0"),"UIInterfaceOrientationPortrait")
	dict:setObject(CCString:create("0"),"UIInterfaceOrientationPortraitUpsideDown")
	dict:setObject(CCString:create("1"),"UIInterfaceOrientationLandscapeLeft")
	dict:setObject(CCString:create("1"),"UIInterfaceOrientationLandscapeRight")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
	dict:setObject(CCString:create(UserModel.getAvatarLevel()),"appLevel")
	return dict
end

function getUserInfoParam( gameState )
    local dict = CCDictionary:create()
    dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
   	dict:setObject(CCString:create(NewLoginCtrl.getSelectServerInfo().name),"groupName")
    dict:setObject(CCString:create(loginInfoTable.newuser),"newuser")
    dict:setObject(CCString:create(loginInfoTable.uid),"uid")
    if(tonumber(gameState) == 1)then
       	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
       	dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
       	--print("gameState = ",gameState)
       	--print("appUid = ",UserModel.getUserUid())
       	--print("appUname = ",UserModel.getUserName())
	end
	--print("gameState = ",gameState)
	return dict
end

