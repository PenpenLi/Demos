-- Filename: config_vivo.lua
-- Author: lu lu jin
-- Date: 2015-03-24
-- Purpose: vivo 平台配置
module("config", package.seeall)
local cjson = require "cjson"
loginInfoTable = {}

function getFlag( ... )
	return "vivo"
end

function getBBSName( ... )
	return ""
end

function getAppId( ... )
	return "04d36a88d17ae1cefd99db52644bde07"
end
-- APPKEY 就是CPKEY
function getAppKey( ... )
	return "20140213145436658600"
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
    local postString = url .. "?access_token=" .. Platform.sdkLoginInfo.sid .. "&uid=" .. Platform.sdkLoginInfo.username .. "&action=newsdk" .. Platform.getUrlParam().."&bind=" .. Platform.getUUID()
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
 	dict:setObject(CCString:create("金币"),"productName")
	dict:setObject(CCString:create("金币"),"productDes")
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

function getOrderUrl(coins,payType,amount)
	local myGroup = CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")
	print("groupId1:",myGroup)
	if string.sub(myGroup,1,4)=="game" then
		myGroup = string.sub(myGroup,5)
	end
	print("groupId2",myGroup)
	return "http://hhwmapi.chaohaowan.com/phone/exchange/vivo/cp/android?pid=" .. loginInfoTable.uid .. "&group=" .. myGroup .. "&orderAmount=" .. coins .. "&action=newGetorder" .. "&payType="..payType.. "&payAmount=".. amount .."&time=" .. BTUtil:getSvrTimeInterval() .. "&version=1.1.0"
end
 
function getOrderUrl_debug(coins,payType,amount)
	local myGroup = CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")
	print("groupId1:",myGroup)
	if string.sub(myGroup,1,4)=="game" then
		myGroup = string.sub(myGroup,5)
	end
	print("groupId2",myGroup)
	return "http://124.205.151.90/phone/exchange/vivo/cp/android?pid=" .. loginInfoTable.uid .. "&group=" .. myGroup .. "&orderAmount=" .. coins .. "&action=newGetorder".."&payType="..payType.. "&payAmount=".. amount .."&time=" .. BTUtil:getSvrTimeInterval() .. "&version=1.1.0"
end

-- VIVO 独特的充值
function vivoPay( coins,payType,amount,otherInfo )
	local requestCallback = function(sender, res)
            print("res:getResponseCode()",res:getResponseCode())
            if(res:getResponseCode()~=200)then
                PlatformUtil.showAlert( "网络异常，请稍后再试", nil, false, nil)
                return
            end
            local cjson = require "cjson"
            local jsonInfo = cjson.decode(res:getResponseData())
            print("res:getResponseString()=",jsonInfo)
            if type(jsonInfo) == "table"  and Platform.empty(jsonInfo) == false then
                local param = config.getPayParam(coins)
                param:setObject(CCString:create(payType or ""),"payType")
                param:setObject(CCString:create(amount or ""),"amount")
                param:setObject(CCString:create(otherInfo or ""),"otherInfo")
                param:setObject(CCString:create(jsonInfo.vivoSignature),"vivoSignature")
                param:setObject(CCString:create(jsonInfo.vivoOrder),"vivoOrder")
                print("res:jsonInfo.vivoOrder=",jsonInfo.vivoOrder)
                print("res:jsonInfo.vivoSignature=",jsonInfo.vivoSignature)
                Platform.getSdk():pay(param)
            end
        end

        local requestUrl = nil 
        if(Platform.isDebug())then
              requestUrl = getOrderUrl_debug(coins,payType,amount)
          else
              requestUrl = getOrderUrl(coins,payType,amount)
        end
        local request = LuaHttpRequest:newRequest()
        request:setRequestType(CCHttpRequest.kHttpGet)
        request:setUrl(requestUrl) 
        request:setResponseScriptFunc(requestCallback)
        CCHttpClient:getInstance():send(request)
        request:release()
end

