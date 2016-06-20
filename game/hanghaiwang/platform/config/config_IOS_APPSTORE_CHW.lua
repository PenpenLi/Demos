-- Filename: config_91.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: ios 91 平台配置
module("config", package.seeall)

UIInterfaceOrientationPortrait           = "1"
UIInterfaceOrientationPortraitUpsideDown = "2"
UIInterfaceOrientationLandscapeLeft      = "3"
UIInterfaceOrientationLandscapeRight     = "4"

local _token = nil
m_userDefault = CCUserDefault:sharedUserDefault()
-- m_udid = UIDUtil:getUID() -- ios设备标识符
-- m_bBind = false -- 当前登陆账户是否绑定过设备标识符的标志，登陆时web端会返回
-- m_bRegister = false -- 当前登陆账号是否一个游戏注册账号
-- m_bGotBindReward = false -- 当前游戏账号是否领取过绑定礼包
local payItems = {
	id_60="com.onepiece.pirate_6rmb", -- Tier1
	id_300="com.onepiece.pirate_30rmb", -- Tier5，购买后获得游戏内300金币
	id_500="com.onepiece.pirate_50rmb", -- Tier8
	id_980="com.onepiece.pirate_98rmb", -- Tier15
	id_1980="com.onepiece.pirate_198rmb", -- Tier30
	id_3280="com.onepiece.pirate_328rmb", -- Tier50
	id_6480="com.onepiece.pirate_648rmb", -- Tier60
}

local monthlyItems = {
	id_300="com.onepiece.pirate_card_30rmb",
}

loginInfoTable = {}
function getFlag( ... )
	return "appstore"
end

function getName( ... )
	return ""
end

function getPidUrl( sessionid )
	_token = sessionid

	local url = "/phone/login/"
	url = url .. "?token=" .. sessionid or ""
	url = url .. Platform.getUrlParam()
	url = url .. "&bind=" .. Platform.getUUID()
 	return url
end 

function getAppId( )
	return "1001"
end

function getToken( )
	return _token
end

function getAppKey( ... )
	return "HhWzlIyIg0M2aerNoxze"
end

function getAdShowUrl( version )
 	return "/phone/adshow?version="..version .. Platform.getUrlParam()
end 

function getBBSName( ... )
	return "用户中心"
end

function getADUrl( pid)
	winSize = CCDirector:sharedDirector():getVisibleSize()
	local mac = "000000"
	local idfa = Platform.getSdk():callStringFuncWithParam("getIdfa",nil)
	print("mac =",mac)
	print("idfa =",idfa)
	return Platform.getHost() .. "/phone/adstat?".. Platform.getUrlParam().."&pid=".. pid .. "&mac=" .. mac .. "&idfa=" .. idfa.."&devres="..winSize.width.."x"..winSize.height
end

function getInitParam(  )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppId()),"appID")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	-- dict:setObject(CCString:create("1104794336"),"qqappid")
	dict:setObject(CCString:create("wxff6bc07f3cd70f78"),"wxappid")
	dict:setObject(CCString:create(UIInterfaceOrientationPortrait),"orientation")
	dict:setObject(CCString:create(tostring(Platform.isDebug())),"debug")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	return dict
end



function getProductid( coins, payType)
	if(payType == Platform.MONTHLY)then
		print("monthlyItems[id_..coins]",monthlyItems["id_"..coins])
		return monthlyItems["id_"..coins]
	else
		print("payItems[id_..coins]",payItems["id_"..coins])
		return payItems["id_"..coins]
	end
end

-- function getLoginUrl( username,password )
-- 	username = Platform.encodeURL(username)
-- 	password = Platform.encodeURL(password)
-- 	local uuid = Platform.getUUID()
-- 	local loginUrl = Platform.getHost().."phone/login/?".. Platform.getUrlParam().."&action=login&username=" .. username .. "&password=" .. password .. "&ext=" .. "&bind=" .. uuid 
-- 	if(uuid ~= nil)then
--  	   loginUrl = loginUrl  .. "&uuid=" .. uuid
--     end
	
-- 	return Platform.signUrl(loginUrl)
-- end

-- function getRegisterUrl( username,password,email )
-- 	username = Platform.encodeURL(username)
-- 	password = Platform.encodeURL(password)
-- 	email = Platform.encodeURL(email)
-- 	local uuid = Platform.encodeURL(Platform.getUUID())
-- 	local registerUrl 
-- 	registerUrl = Platform.getHost().."phone/login/?action=register" .. Platform.getUrlParam()  .. "&username=".. username .. "&password=" .. password .. "&email=" .. email.. "&bind=" .. uuid
-- 	if(uuid ~= nil)then
--  	   registerUrl = registerUrl  .. "&uuid=" .. uuid
--     end
    
-- 	return Platform.signUrl(registerUrl)
-- end

-- function getChangePasswordUrl(username, passwordOld, password)
-- 	local renewpassUrl = ""
-- 	renewpassUrl = Platform.getHost().."phone/login/?action=renewpass".. Platform.getUrlParam()

-- 	local uuid = Platform.encodeURL(Platform.getUUID())
-- 	if(uuid ~= nil)then
--  	   renewpassUrl = renewpassUrl  .. "&bind=" .. uuid
--     end

--     username = Platform.encodeURL(username)
--     passwordOld = Platform.encodeURL(passwordOld)
--     password = Platform.encodeURL(password)

--     renewpassUrl = string.format("%s&username=%s&passwordOld=%s&passwordNew=%s", renewpassUrl, username, passwordOld, password)
--     return Platform.signUrl(renewpassUrl)
-- end

-- -- 快速注册首次返回自动生成账号密码的请求
-- function getFastRegisterUrl( uuid )
-- 	local m_udid = Platform.encodeURL(uuid or Platform.getUUID())
-- 	local deviceid = "&deviceid=" .. m_udid
-- 	local fastRegisterUrl = Platform.getHost().."phone/fastreg?" .. Platform.getUrlParam() .. deviceid .. "&flag=1"
		

-- 	return Platform.signUrl(fastRegisterUrl)
-- end

-- -- 快速注册保存和注册账号密码的请求
-- function getFastRegisterActionUrl( uname, pwd )
-- 	local m_udid = Platform.encodeURL(uuid or Platform.getUUID())
-- 	local deviceid = "&deviceid=" .. m_udid

-- 	uname = Platform.encodeURL(uname)
-- 	pwd = Platform.encodeURL(pwd)
-- 	local registUrl = Platform.getHost() .. "phone/fastreg?action=" .. Platform.encodeURL("regUsername") .. Platform.getUrlParam() .. deviceid .. "&username=" .. uname .. "&password=" .. pwd
-- 	return Platform.signUrl(registUrl)
-- end

-- -- 返回webview中打开绑定邮箱页面的参数dict
-- function getBindEmailParam( ... )
-- 	local iPhoneUrl = "&device=" .. Platform.encodeURL("iphone")
-- 	local iPadUrl = "&device=" .. Platform.encodeURL("iPad")

-- 	-- http://124.42.71.49/phone/bindemail?pid=fc06f32d332b5d0b&pl=appstore&gn=cp&os=ios&redirect=email&device=iphone&time=1435652540&sign=16f239d8dae5467ad9e246691c898c64
-- 	local bindingUrl = Platform.getHost() .. "phone/bindemail?" .. Platform.getUrlParam()
-- 	bindingUrl = bindingUrl .. "&redirect=email&pid=" .. Platform.getPid() .. iPhoneUrl
-- 	local bindingTitle = "绑定邮箱"

-- 	local dict = CCDictionary:create()
-- 	-- dict:setObject(CCString:create(iPhoneUrl), "url_iphone")
-- 	-- dict:setObject(CCString:create(iPadUrl), "url_ipad")
-- 	dict:setObject(CCString:create(Platform.signUrl(bindingUrl)), "webUrl")
-- 	dict:setObject(CCString:create(bindingTitle), "webTitle")
-- 	return dict
-- end

-- function getADUrl( pid)
-- 	winSize = CCDirector:sharedDirector():getVisibleSize()
-- 	local mac = "000000"
-- 	local idfa = Platform.getSdk():callStringFuncWithParam("getIdfa",nil)
-- 	print("mac =",mac)
-- 	print("idfa =",idfa)
-- 	local url = Platform.getHost() .. "phone/adstat?".. Platform.getUrlParam().."&pid=".. pid .. "&mac=" .. mac .. "&idfa=" .. idfa.."&devres="..winSize.width.."x"..winSize.height
-- 	return Platform.signUrl(url)
-- end

-- function getAdShowUrl( version )
--  	return "phone/adshow?version="..version .. Platform.getUrlParam()
-- end 

-- kLoginsStateNotLogin="0"
-- kLoginsStateUDIDLogin="1"
-- kLoginsStateZYXLogin="2"

-- function loginState( Stat )
-- 	if (Stat) then
-- 		m_userDefault:setStringForKey("loginState", Stat)
-- 	else
-- 		return m_userDefault:getStringForKey("loginState")
-- 	end
-- end
-- function getLoginState( ... )
-- 	local stat = loginState()
-- 	if ((not stat) or stat == "") then
-- 		return kLoginsStateNotLogin
-- 	end
-- 	return stat
-- end
