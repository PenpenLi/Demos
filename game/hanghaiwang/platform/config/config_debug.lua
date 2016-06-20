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
	return "pushOnline"
end

function getName( ... )
	return "游戏"
end

function getHost( ... )
	local host = "http://test.chaohaowan.com:8499/" -- release 作为体验包打包用，连体验服 url

	local osTarget = CCApplication:sharedApplication():getTargetPlatform()
	-- iOS开发包的 debug 版 或 安卓开发包就连线下配置，zhangqi, 2015-09-30
	if (Platform.isDebug() or (osTarget == kTargetAndroid)) then
		host = "http://192.168.1.113:17602/"
	end
	return host
end

function getPidUrl( sessionid )
	local url = "/phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
    local uin = Platform.getSdk():callStringFuncWithParam("getUin",nil)
	local postString = url .. "?sid=" .. sessionid .. "&uin=".. uin .. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
 	return postString
end 

function getInitParam( coins )
	local dict = CCDictionary:create()
	if(Platform.isDebug())then
		dict:setObject(CCString:create("115653"),"appID")
		dict:setObject(CCString:create("511dcac1997d06b351f95fa3076b2c24a1c1d97358462dd8"),"appKey")
		dict:setObject(CCString:create("true"),"debug")
		dict:setObject(CCString:create(UIInterfaceOrientationLandscapeRight),"orientation")

	else
		-- dict:setObject(CCString:create("104964"),"appID")
		-- dict:setObject(CCString:create("07b68523759147d46ff30ba8f4aef42779a89b1b727a3528"),"appKey")
		-- dict:setObject(CCString:create("true"),"false")
	end
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(Platform.getLastLoginGroup()),"groupId")
	return dict
end

