-- Filename: Platform.lua
-- Author: baoxu
-- Date: 2013-11-06
-- Purpose: 


module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "xinlang"
end

 
function getPidUrl( sessionid )
	local postString = "phone/login/"  .. "?token=" .. sessionid.."&bind=" .. Platform.getUUID() .. Platform.getUrlParam()
	postString = postString .. "&uid=" .. Platform.sdkLoginInfo.userId .. "&machineid=" .. Platform.sdkLoginInfo.machineid .. "&ip=" .. Platform.sdkLoginInfo.ip
	
 	return postString
end 

function getBBSName( ... )
	return "新浪社区"
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
 	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end



function setLoginInfo( xmlTable )
	print("LoginInfo:",xmlTable)
	loginInfoTable = xmlTable
	print("loginInfoTable.uid:",loginInfoTable.uid)
	print("loginInfoTable.username:",loginInfoTable.username)
	print("loginInfoTable.userid:",loginInfoTable.userid)
	print("loginInfoTable.newuser:",loginInfoTable.newuser)
end

function getInitParam(  )
    local dict = CCDictionary:create()
    dict:setObject(CCString:create("2122446825"),"appId")
    dict:setObject(CCString:create("ea4a5ad96daea79de8916582c1a42c7d"),"appKey")
    return dict
end