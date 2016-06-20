-- Filename: Platform.lua
-- Author: fang
-- Date: 2013-09-22
-- Purpose: 该文件用于处理平台相关接口

-- 调试级别(游戏发布时该level必须为0)

module("Platform", package.seeall)
require "platform/PlatformUtil"
local cjson = require "cjson"
local inGameLogout=false


local _pid=""
local _loginBackCall = nil
local name = nil
local _unlockPay = "true"
local _showAd = false
local web_ip="http://115.182.233.42/"
local webTime = ""
local timeOffset=0
local m_userDefault = CCUserDefault:sharedUserDefault()
local _isFastLogin = 0

function getLastLoginGroup( ... )
    return m_userDefault:getStringForKey("lastLoginGroup")
end

function setLastLoginGroup( lastGroup )
    m_userDefault:setStringForKey("lastLoginGroup", lastGroup)
    m_userDefault:flush()
end

--登陆后返回的用户信息
sdkLoginInfo = {}

function isPlatform( ... )
    local onlineType = BTUtil:getBTOnlineType()
    if(onlineType == 0 or onlineType == 1)then
        return false
    else
        return true
    end
end

function getHost( ... )
    local host = "http://hhwmapi.chaohaowan.com/" -- 2015-03-19, 封测包

    if (isDebug()) then
        host = "http://192.168.1.113:17602/"
    end

    if (type(config.getHost) == "function") then
        host = config.getHost()
    end

    return host
end

function getAudioHost( ... )
    local host = "http://audiochat.chaohaowan.com:8002/" -- 2015-03-19, 封测包

    if (isDebug()) then
        host = "http://192.168.1.91:3333/"
    end

    if (type(config.getAudioHost) == "function") then
        host = config.getAudioHost()
    end

    return host
end

-- 更新包下载的url改成了配置在web平台的版本信息中，实际上此函数没有任何作用
function getDownloadHost( ... )
    local url = "http://static1.one-piece.cc/fkpirate " -- 2016-01-05

    if (not isPlatform() or isDebug()) then
        url = "http://192.168.1.134/Package/Update"
    end

    if (type(config.getDownUrl) == "function") then
        url = config.getDownUrl()
    end

    return url
end

--版本检测的
function getCheckVersionUrl( packageVersion, scriptVersion )
    local checkVersionUrl = getHost() .. "phone/get3dVersion?packageVersion=" .. packageVersion .. "&scriptVersion=" .. scriptVersion .. getUrlParam()
    return signUrl(checkVersionUrl)
end
--游戏内公告
-- zhangqi, 2016-01-27, 为了统一管理代码以及方便运营操作，web端要上线新的公告编辑系统
-- 配合修改请求接口，老的notice改为supernotice，多了2个保留参数默认值为1，reserve01=1&reserve02=1
-- 2016-02-03, 由于未完成测试，暂时恢复notice的请求
function getNoticeBeforeGameUrl( ... )
    local serverKey = getLastLoginGroup()
    -- local noticeUrl = getHost() .. "phone/supernotice?" .. getUrlParam() .. "&action=get&returntype=cardstr&reserve01=1&reserve02=1&serverKey=" .. serverKey
    local noticeUrl = getHost() .. "phone/notice?" .. getUrlParam() .. "&action=get&returntype=cardstr&serverKey=" .. serverKey
    return signUrl(noticeUrl)
end
--服务器列表和选服界面公告
function getServerListUrl( ... )
    local serverListUrl = getHost() .. "phone/serverlistnotice?" .. getUrlParam()
    return signUrl(serverListUrl)
end
-- zhangqi, 2016-01-12, 拉最近登录服务器列表，比拉服务器列表的请求多一个pid参数
function getRecentLoginUrl( ... )
    local serverListUrl = getHost() .. "phone/loginrole?" .. getUrlParam() .. "&pid=" .. getPid()
    return signUrl(serverListUrl)
end
--bug报告和查看
function getReportUrl( ... )
    local gmReportUrl = getHost() .. "phone/question?method=GET&serverID=%s&server_id=%s&content=%s&classID=%s&uid=%s&uname=%s&action=%s"
    return gmReportUrl
end
--bug报告和查看url
function getReviewUrl( ... )
    local gmReviewUrl = getHost() .. "phone/question?method=GET&serverID=%s&server_id=%s&uid=%s&action=%s"
    return gmReviewUrl
end
--获取游戏服务器信息url
function getGameServerInfoUrl( pid )
    require "script/module/login/NewLoginCtrl"
    local serverInfo = NewLoginCtrl.getSelectServerInfo()
    local serverInfoUrl = getHost() .. "phone/getHash/?&group_id=" .. serverInfo.group .. "&pid=" .. pid .. "&uuid=" .. getUUID()
    return signUrl(serverInfoUrl)
end

function isDebug( ... )
    return BTUtil:getDebugStatus()
end

function getSdk( ... )
    if(isPlatform() == false)then
        return
    end
    return protocol
end

function getConfig( ... )
    return config
end

function getBBSName( ... )
    if (config.getBBSName)then
        return config.getBBSName()
    end
    return ""
end

function getPlatformFlag( ... )
    if(isPlatform() == false)then
        return "CardPirate"
    end
    return protocol:callStringFuncWithParam("getPlatformName",nil)
end

-- 是否支持自己微信分享
function getWxShare( ... )
  if (type(getConfig().getWxShare) == "function") then
    return getConfig().getWxShare()
  else
    return "true"
  end
end

--注册回调
function registerHandler( ... )
    logger:debug(" registerHandler " )
    registerCrashHandler()
    registerLowMemoryHandler()
    registerLoginHandlers()
    registerLogoutScriptHandler()
    protocol:registerScriptHandlers("luaQuit",quit)

end

-- 初始化平台相关SDK
function initSDK()
    print("initSDK")
    if(isPlatform() == false)then
        require "platform/config/config_debug"
        return
    end
    protocol = PluginManager:getInstance():loadPlugin()


    local platformName = getPlatformFlag()
    require ("platform/config/config_" .. platformName)

    -- zhangqi, 2015-05-18, 先检查是否需要发送异常收集信息
    require "script/utils/ExceptionCollect"
    local expCollect = ExceptionCollect:getInstance()
    expCollect:checkLastException()

    ExceptionCollect:getInstance():start("sdk_login", getDeviceInfo())

    sendUuid("init","before")
    syncServerTime()
    local dict = config.getInitParam()
    protocol:callOCFunctionWithName_oneParam_noBack("initialize",dict)

    registerHandler()

    -- login()

    --启动防沉迷
    antiAddictionSchedule()
    if(platformName == "IOS_APPSTORE_CHW") then
        fnAdShow()
    end

    if(platformName == "IOS_APPSTORE_CHW")then
        require "platform/GameIAP"
        GameIAP.prepareStore()
    end

    if(platformName == "Android_yingyongbao" )then
        protocol:registerScriptHandlers("qqLogin",function( ... )
            print("android logcat registerScriptHandlers qqLogin")
            UIHelper.showYingyongbaoLogin(function( ... )
                protocol:callOCFunctionWithName_oneParam_noBack("loginWithQQ",nil)
            end,function( ... )
                protocol:callOCFunctionWithName_oneParam_noBack("loginWithWeixin",nil)
            end)
        end)
    end
    setCrashInfo()
end

--[[
  return:平台名字
]]
function getPL( ... )
    if protocol == nil then
        return "test"
    end
    return config.getFlag()

end

-- 进入用户中心
function enterUserCenter()
    if(isPlatform() == false)then
        -- 测试自动断开链接功能
        -- require "script/network/Network"
        -- Network.rpc(function ( ... )
        -- -- body
        -- end, "user.closeMe", "user.closeMe", nil, true)

        return
    end

    if(Platform.getPlatformFlag() == "apple") then
        PlatformUtil.openUrl("")
        return
    end
    protocol:enterPlatform(0)

end

-- 取得平台相关名字
function getPlatformName( ... )
    if(isPlatform() == false)then
        return "测试中心"
    end
    return config.getName()
end

function isLogin( ... )
    if(isPlatform() == false)then
        return
    end
    return protocol:isLogin()
end

function isFastLogin( ... )
    return _isFastLogin == 1 and true or false
end

--登陆
function login( loginBackCall )
        --             local dict = CCDictionary:create()

        -- protocol:callOCFunctionWithName_oneParam_noBack("crash",dict)

    ExceptionCollect:getInstance():info("sdk_login","call platform.login")
    local plName = getPlatformFlag()
    logger:debug("Platform.login: platform = %s", plName)
    -- and platformName ~= "IOS_91" and platformName ~= "Android_91"
    local bLogin = (plName ~= "IOS_PP" and plName ~= "IOS_PGY" and plName ~= "IOS_KUAIYONG" and plName ~= "IOS_TBT" and plName ~= "IOS_haima")
    if ( not bLogin ) then
        logger:debug("Platform.login plName = %s", plName)
        return
    end

    _loginBackCall = loginBackCall

    logger:debug("protocol login ")
    protocol:login()
    Platform.sendInformationToPlatform(kNewPlatformAccount)

end

function fnAdShow( ... )

    local sendDeviveTokenCallback = function (client, response)
        local ret_str = response:getResponseData()
        local retCode = response:getResponseCode()
        print("ret_str, retCode= ", ret_str, retCode)

        if(tonumber(retCode) == 200)then
            local cjson = require "cjson"
            local json = cjson.decode(ret_str)
            client_ip = json.ip
            if json and json.isshow and json.isshow == 1 then
                _showAd = true
            end
        end
    end

    local adUrl =  getHost() ..  config.getAdShowUrl(g_pkgVer.package)
    print("adUrl=",adUrl)
    local httpClent = sendHTTPRequestLua(sendDeviveTokenCallback, adUrl, 0)
end

function isAppleReview( ... )
    return _showAd
end

--注销sdk
function loginOut( ... )
    print("loginOut")
    print(debug.traceback())
    if(isPlatform() == false)then
        return
    end
    protocol:loginOut()
end

--注册登陆回调
function registerLoginHandlers( ... )
    if(isPlatform() == false)then
        logger:debug("isPlatform == false")
        return
    end
    protocol:registerLoginScriptHandler(function ( dict )
        local loginState = tonumber(dict.state)
        local session_id = dict.sid
        print("loginState =",loginState,"session_id=",session_id)
        if(loginState == 0) then
            print("platform sdk 登陆成功")
            _isFastLogin = tonumber(dict.isFastLogin or 0)
            ExceptionCollect:getInstance():info("sdk_login","login ok, call Platform.getPidBySessionId()")
            Platform.sdkLoginInfo=dict
            Platform.getPidBySessionId(session_id)
            if(not isAppleReview())then
                Platform.showToolBar()
            end
        else
            print("登陆失败")
            return
        end
    end)
end

--平台注销回调
function registerLogoutScriptHandler(pFunc)
    if(isPlatform() == false)then
        return
    end
    print("registerLogoutHandler")
    protocol:registerScriptHandlers("logout",function( ... )
        print(("key_2382"))
        logout()
    end)
end

local isFrestShowToolBar = true
--显示工具栏
function showToolBar( ... )
    if(isPlatform() == false)then
        return
    end
    if(not isFrestShowToolBar)then
        return
    end
    protocol:showToolBar()
end


-- 解禁充值功能
function fnLockPay( lock )
    _unlockPay = lock
end

PAYMENT="00"
MONTHLY="01"
function pay(coins,payType,amount,otherInfo)
    print("pay:",coins)
    if(isPlatform() == false)then
        return
    end

    local platformName = protocol:callStringFuncWithParam("getPlatformName",nil)
    if(platformName == "Android_vivo")then
        if(amount == nil or amount == "") then
            amount = ""
        end
        config.vivoPay(coins,payType,amount,otherInfo)
    elseif(platformName == "IOS_APPSTORE_CHW")then
        print("GameIAP.buyProduct :"..config.getProductid(coins,payType))
        GameIAP.buyProduct(config.getProductid(coins,payType))
        return
    else
        local param = config.getPayParam(coins)
        param:setObject(CCString:create(payType or ""),"payType")
        param:setObject(CCString:create(amount or ""),"amount")
        param:setObject(CCString:create(otherInfo or ""),"otherInfo")
        protocol:pay(param)
    end
end

--初始化平台Server
function initPlGroup( ... )
    local platformName = protocol:callStringFuncWithParam("getPlatformName",nil)
    if (platformName == "Android_km" or platformName == "Android_ck") then
        protocol:callOCFunctionWithName_oneParam_noBack("initServer",config.getGroupParam())
    end
end

function getSessionId()
    if(isPlatform() == false)then
        return
    end
    return protocol:callStringFuncWithParam("getSessionId",nil)
end

--登陆成功后获取pid
function getPidBySessionId( session_id )
    logger:debug("session_id : %s  _pid %s" , tostring(session_id),_pid )
    -- if _pid then
    --   LoginHelper.loginGame()
    --   return
    -- end
    local loginUrl = getHost() .. config.getPidUrl(session_id)
    print("loginUrl=",loginUrl)
    -- PlatformUtil.addLoadingUI()

    -- local request = LuaHttpRequest:newRequest()
    -- request:setRequestType(CCHttpRequest.kHttpGet)
    -- request:setUrl(loginUrl)
    -- request:setResponseScriptFunc(getPidResult)
    -- CCHttpClient:getInstance():send(request)
    -- request:release()

    sendHTTPRequestLua(getPidResult,loginUrl,0)
end
--获取pid 的回调
function getPidResult( sender, res )
    -- PlatformUtil.reduceLoadingUI()
    -- local m_tbAllWebData = nil
    print("res:getResponseCode()",res:getResponseCode())
    if(res:getResponseCode()~=200)then
        -- 请求结束，但没有返回 200 响应代码
        PlatformUtil.showAlert(("网络异常"), nil, function ( ... )
            Platform.quit()
        end,1)
        return
    else
        -- 请求成功，显示服务端返回的内容
        local cjson = require "cjson"
        local loginInfo = cjson.decode(res:getResponseData())
        print("res:getResponseString()=",loginInfo)

        if type(loginInfo) == "table"  and empty(loginInfo) == false then
            local uid = loginInfo.uid
            local errornu = loginInfo.errornu
            local errorDesc = loginInfo.errordesc
            local newuser = loginInfo.newuser
            if(errornu == 0) then

                setPid(uid) -- 2015-12-24, zhangqi

                ExceptionCollect:getInstance():info("sdk_login","get pid ok, pid = " .. getPid() .. ", call getServerList()")

                local dict = CCDictionary:create()
                dict:setObject(CCString:create(_pid),"pid")
                if protocol ~= nil then
                    protocol:callOCFunctionWithName_oneParam_noBack("setPushPid",dict)
                end
                --设置推送pid
                print("_pid_sever=",_pid)
                -- _pid = tostring(123124)
                -- print("_pid_xiesi=",_pid)
                if(type(config.setLoginInfo) == "function")then
                    config.setLoginInfo(loginInfo)
                end
                if(_loginBackCall)then
                    print("_loginBackCall",_loginBackCall)
                    _loginBackCall()
                    _loginBackCall=nil
                end
                print("getPlatformFlag()",getPlatformFlag())
                print("newuser",newuser)
                print("config.getADUrl ",config.getADUrl )
                
                if(getPlatformFlag() == "IOS_APPSTORE_CHW" and tonumber(newuser) == 1 and config.getADUrl )then
                    local url = config.getADUrl(getPid())
                    sendHTTPRequestLua(function ( ... ) end,url,0)
                    print("send idfa")
                end

                setCrashInfo()
                ExceptionCollect:getInstance():finish("sdk_login")

            elseif(errornu == "3") then
                Platform.loginOut()
                PlatformUtil.showAlert(("登陆验证失败或网络异常"), nil)
                CCLuaLog("error errornu is not 0")
                return

            else
                -- SDK91Share:shareSDK91():loginOut()
                Platform.loginOut()
                PlatformUtil.showAlert(("登陆验证失败或网络异常"), nil)
                CCLuaLog("error errornu is not 0")
                return
            end
        end
    end
end


--[[
    @des:   登陆功能
    @parm:  callBack  (返回用户名,密码,pid)
--]]
function sendLoginInHandler(uid, pwd, callBack)
    if uid == nil or pwd == nil then
        return
    end

    local url = config.getLoginUrl(uid,pwd)
    sendHTTPRequestLua(
        function( client, response)
            local ret_str = response:getResponseData()
            local retCode = response:getResponseCode()
            local ok = response:isSucceed()
            if not ok then
                -- 请求失败，显示错误代码和错误消息
                logger:fatal("The request failed: url:%s" , url)
                return
            end
            if retCode ~= 200 then
                -- 请求结束，但没有返回 200 响应代码
                logger:fatal("Response status code = %d : url : %s",retCode , url)
                return
            end
            -- 请求成功，显示服务端返回的内容
            local loginInfo = cjson.decode(ret_str)
            -- dump(loginInfo,"sendLoginInHandler(oper, uid, pwd)")

            if type(loginInfo) == "table"  and empty(loginInfo) == false then
                local pid = loginInfo.uid
                local errornu = loginInfo.errornu
                local errorDesc = loginInfo.errordesc
                if(errornu == 0) then
                    setPid(pid)
                    --准备登陆逻辑服务器
                    if callBack ~= nil and tolua.isnull(callBack) == false then
                        callBack(uid,pwd,getPid())
                        afterSign()
                    end
                    if(config.getADUrl)then
                        local url = config.getADUrl(getPid())
                        sendHTTPRequestLua(function ( ... ) end,url,0)
                    end

                else
                    PlatformUtil.showInfo(errorDesc)
                    -- if g_ShowGameLoginScene ~= nil and tolua.isnull(g_ShowGameLoginScene) == false then
                    --   g_ShowGameLoginScene:creatNewLogin()
                    -- end
                    -- SDK91Share:shareSDK91():loginOut()
                    return
                end
            else
                PlatformUtil.showInfo("loginInfo error")
            end
        end, url, 0)
end

--[[
    @des:   注册功能
    @parm:  callBack  (返回用户名,密码,pid)
--]]
function sendRegistHandler(username, pwd, email, callBack)

    if username == nil or pwd == nil or email == nil then
        return
    end

    --地址
    -- local url =  getHost().."/phone/login?pl=zyxphone&os=ios&gn=miniwow&action="..oper.."&username="..username.."&password="..pwd.."&email="..email
    local url = config.getRegisterUrl(username,pwd,email)
    sendHTTPRequestLua(
        function( client, response)
            local ret_str = response:getResponseData()
            local retCode = response:getResponseCode()
            local ok = response:isSucceed()
            if not ok then
                -- 请求失败，显示错误代码和错误消息
                logger:fatal("The request failed: url:%s" , url)
                return
            end
            if retCode ~= 200 then
                -- 请求结束，但没有返回 200 响应代码
                logger:fatal("Response status code = %d : url : %s",retCode , url)
                return
            end
            -- 请求成功，显示服务端返回的内容
            local registInfor = cjson.decode(ret_str)

            if type(registInfor) == "table"  and empty(registInfor) == false then
                local pid = registInfor.uid
                local errornu = registInfor.errornu
                local errorDesc = registInfor.errordesc
                if(errornu == 0) then
                    --自动登陆逻辑服务器
                    sendLoginInHandler(username, pwd, callBack)
                    -- sendUuid("true")
                else
                    PlatformUtil.showInfo(errorDesc)
                    return
                end
            else
                PlatformUtil.showInfo("registInfor error")
            end


        end, url, 0)
end

--[[
    @des:   快速注册功能
    @parm:  callBack  (返回用户名和密码)
--]]
function gotoFastRegister( callBack )
    local fastRegisterUrl = ""
    fastRegisterUrl = config.getFastRegisterUrl()
    print("fastRegisterUrl:",fastRegisterUrl)
    if fastRegisterUrl == nil or fastRegisterUrl == "" then
        return
    end
    sendHTTPRequestLua(
        function( client, response)
            local ret_str = response:getResponseData()
            local retCode = response:getResponseCode()
            local ok = response:isSucceed()
            if not ok then
                -- 请求失败，显示错误代码和错误消息
                logger:fatal("The request failed: url:%s" , url)
                return
            end
            if retCode ~= 200 then
                -- 请求结束，但没有返回 200 响应代码
                logger:fatal("Response status code = %d : url : %s",retCode , url)
                return
            end
            -- 请求成功，显示服务端返回的内容
            local loginInfo = cjson.decode(ret_str)
            if type(loginInfo) == "table"  and empty(loginInfo) == false then

                local uid = loginInfo.uid
                local errornu = loginInfo.errornu
                local errordesc = loginInfo.errordesc
                local username = loginInfo.username
                local password = loginInfo.password
                print("uid = ",uid)
                print("errornu=",errornu)
                print("errordesc=",errordesc)
                print("username=",username)
                print("password=",password)

                if (tonumber(errornu) == 0 and username ~= nil and password ~= nil) then
                    --准备登陆逻辑服务器
                    setPid(uid)
                    if (callBack ~= nil) then
                        --返回用户名和密码
                        callBack( username, password )
                        print("callback。。。。:",username,password)
                    end
                elseif (username ~= nil and password == nil) then
                    --已经注册过的，只有用户名，没有密码
                    PlatformUtil.showAlert("此设备已经快速注册过，不能再次注册\n\n用户名为："..username,
                        function ( ... )
                            PlatformUtil.closeAlert()
                        end,false)
                else
                    PlatformUtil.showInfo(errorDesc)
                    -- if g_ShowGameLoginScene ~= nil and tolua.isnull(g_ShowGameLoginScene) == false then
                    --   g_ShowGameLoginScene:creatNewLogin()
                    -- end
                    return
                end
            else
                PlatformUtil.showInfo("error")
            end
        end, fastRegisterUrl, 0)
end

-----------------------------与Platform_SDK的信息交互------------------------createByBaoXu
--Platform_SDK 对应的 接口 Teyp 类型
kEnterGameServer      = 0      --从Web端获取到Pid后开始登录游戏服务器
kCreateNewRole        = 1      --创建新角色
kEnterTheGameHall     = 2      --进入游戏大厅
kOutOfStoryLine       = 3      --新手剧情之后(即进入首个副本)
kRoleLevelInfo        = 4      --游戏内部玩家等级信息
kShareButtonClick     = 5      --调用分享按钮
kComeInMainLayer      = 6      --进入选服主页面
kNewPlatformAccount   = 7      --新账号注册
kLeaveTheGameHall     = 8      --离开主页面

local beforeGame  = 0      --进入游戏之前
local inTheGame   = 1      --已经进入游戏

--统一接收游戏内部传过来的消息--messageType是上面定义的方法类型,param是附加参数(可传随意参数)
function sendInformationToPlatform(messageType, param)
    if(isPlatform() == false or messageType == nil)then
        return
    end

    local platformName = protocol:callStringFuncWithParam("getPlatformName",nil)
    local dict = CCDictionary:create()

    if (messageType == kComeInMainLayer) then
        dict:setObject(CCString:create(messageType),"type")
        protocol:callOCFunctionWithName_oneParam_noBack("receiveInformationFromLua",dict)
        return
    end

    --没有方法getPlatformName的平台 结束调用,意味着不需要 统计相关数据
    if(type(config.getUserInfoParam) == "function")then
        --刚进入逻辑服务器的时候 有获取不到的参数 因此做下区分
        if(messageType == kEnterGameServer or messageType == kComeInMainLayer)then
            dict = config.getUserInfoParam(beforeGame)
        elseif(messageType == kEnterTheGameHall)then
            dict = config.getUserInfoParam(inTheGame)
        end
    end

    --监听角色升级,添加等级参数
    if(messageType == kRoleLevelInfo)then
        local level = param
        dict:setObject(CCString:create(level),"level")
    end

    --注册分享后的方法回调, 并设置分享的内容
    if(messageType == kShareButtonClick)then
        print("registerShareCallback")
        protocol:registerScriptHandlers("shareCallBack",function( param )
            --print(GetLocalizeStringBy("key_3190"),param.code)
            require "script/ui/share/ShareLayer"
            ShareLayer.shareCallback(param.code)
        end)
        dict = config.getShareInfoParam( dict )
    end
    if(Platform.getConfig().getFlag() == "huaqing")then
        if(messageType == kEnterTheGameHall) then
            local dict = CCDictionary:create()
            dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"group")
            protocol:callOCFunctionWithName_oneParam_noBack("loginGame",dict)
        end
    end

    dict:setObject(CCString:create(messageType),"type")
    protocol:callOCFunctionWithName_oneParam_noBack("receiveInformationFromLua",dict)

end
-----------------------------与Platform_SDK的信息交互------------------------createByBaoXu

--启动防沉迷倒计时
local beginSchedule = false
local minute = 0
function antiAddictionSchedule( time )
    if(antiAddictionSchedule == false) then
        antiAddictionSchedule = true
        CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(antiAddictionSchedule, 60, false)
    end

    minute = minute + 1
    if(minute >= 3*60)then
        if((minute - 3*60)%15 == 0)then
            antiAddictionQuery(3)
        end
    elseif(minute >= 5*60)then
        if((minute - 3*60)%5 == 0)then
            antiAddictionQuery(5)
        end
    end

end

--防沉迷
--type类型:小时,3或5
function antiAddictionQuery(type)
    --暂时只有360有
    if not (platformName == "Android_360")then
        return
    end
    if(isPlatform() == false)then
        return
    end
    local param = config.getPayParam(0)
    param:setObject(CCString:create(type),"type")
    protocol:callOCFunctionWithName_oneParam_noBack("antiAddictionQuery",param)
end

-- 注销游戏
function logout( ... )
    print("platform.logout1111111")
    setPid("")
    if(inGameLogout)then
        print("inGameLogout=",inGameLogout)
        inGameLogout = false
        return
    end
    require "script/module/public/GlobalNotify"
    GlobalNotify.addObserver(GlobalNotify.NETWORK_FAILED,
        function ( ... )
            print("LoginHelper.loginAgain22222222222")
            local scene = CCDirector:sharedDirector():getRunningScene()
            performWithDelay(scene, LoginHelper.loginAgain, 0.1)
        end, true, "SDK_LOGOUT" )
    require "script/network/Network"
    Network.rpc(function ( ... )
        print("...........rpc................logout")
    end, "user.closeMe", "user.closeMe", nil, true)

    return
end

--android 点击menu接口
function clickMenu( ... )
    local platformName = protocol:callStringFuncWithParam("getPlatformName",nil)
    if not (platformName == "Android_360" or platformName == "Android_dl" or platformName == "Android_xm")then
        return
    end
    function doRevive( flag,hid)
        if(flag==false)then

        else
            logout()
            protocol:callOCFunctionWithName_oneParam_noBack("switchAccount",nil)
        end
    end

    PlatformUtil.showAlert( "您要执行哪个操作", doRevive, false, hid,"")
end

--[[
  @des:得到用户pid
]]
function getPid( ... )
    return _pid
end

--[[
  @des:设置pid
]]
function setPid( pidStr )
    _pid = pidStr
    if(pidStr~=nil)then
        sendUuid("getpid","after")
    end
end

function setInGameLogout( isInGameLogout )
    inGameLogout = isInGameLogout
end

function openUrl( url )
    if(url == nil)then
        return
    end
    print("url=",url)
    if(g_system_type == kBT_PLATFORM_ANDROID )then
        local dict = CCDictionary:create()
        dict:setObject(CCString:create(url),"url")
        protocol:callOCFunctionWithName_oneParam_noBack("openUrl",dict)
    else
        PlatformUtil:openUrl(url)
    end
end

function registerCrashHandler( ... )
    print("registerCrashHandler")
    protocol:registerScriptHandlers("handleCrash",function( param )
        print("handleCrash")
        print("param",param)
        -- local dict = cjson.decode(param)
        local param = ""
        local dumpPath=""
        param = param .. "&pid=" .. (_pid or 0)
        param = param .. "&env=lua"
        param = param .. "&gn=" .. getGameName()
        param = param .. "&os="..getOS()
        param = param .. "&pl="..getPL()
        local serverInfo = CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")
        param = param .. "&server_group="..serverInfo

        local url = "http://debug.one-piece.cc:17801/index.php?"
        local data = param .. "&lua_traceback=" ..encodeURL(debug.traceback())        print("url=",url2)
        local dict = CCDictionary:create()
        dict:setObject(CCString:create(url),"url")
        dict:setObject(CCString:create(data),"data")
        protocol:callOCFunctionWithName_oneParam_noBack("sendToServer",dict)
    end)
end

function registerLowMemoryHandler( ... )
    print("registerLowMemoryHandler")
    protocol:registerScriptHandlers("lowMemory",function( param )
        CCDirector:sharedDirector():purgeCachedData()
    end)
end

function tracebackex()
    local ret = ""
    local level = 3
    ret = ret .. "stack traceback:\n"
    while true do
        --get stack info
        local info = debug.getinfo(level, "Sln")
        if not info then break end
        if info.what == "C" then                -- C function
            ret = ret .. tostring(level) .. "\tC function\n"
        else           -- Lua function
            ret = ret .. string.format("\t[%s]:%d in function `%s`\n", info.short_src, info.currentline, info.name or "")
        end
        --get local vars
        local i = 1
        while true do
            local name, value = debug.getlocal(level, i)
            if not name then break end
            ret = ret .. "\t\t" .. name .. " =\t" .. tostringex(value, 3) .. "\n"
            i = i + 1
        end
        level = level + 1
    end
    return ret
end

function tostringex(v, len)
    if len == nil then len = 0 end
    local pre = string.rep('\t', len)
    local ret = ""
    if type(v) == "table" then
        if len > 5 then return "\t{ ... }" end
        local t = ""
        for k, v1 in pairs(v) do
            t = t .. "\n\t" .. pre .. tostring(k) .. ":"
            t = t .. tostringex(v1, len + 1)
        end
        if t == "" then
            ret = ret .. pre .. "{ }\t(" .. tostring(v) .. ")"
        else
            if len > 0 then
                ret = ret .. "\t(" .. tostring(v) .. ")\n"
            end
            ret = ret .. pre .. "{" .. t .. "\n" .. pre .. "}"
        end
    else
        ret = ret .. pre .. tostring(v) .. "\t(" .. type(v) .. ")"
    end
    return ret
end

function getOS( ... )
    local OS = "ios"
    local plTarget = CCApplication:sharedApplication():getTargetPlatform()
    if plTarget == kTargetAndroid then
        OS = "android"
    elseif plTarget == kTargetWP8 then
        OS = "wp"
    else
        OS = "ios"
    end
    print("OS:",OS)
    return OS
end

function getGameName( ... )
    return "cp"
end

function getUrlParam( ... )
    local urlParam= "&pl=" .. config.getFlag() .. "&gn=" .. getGameName() .. "&os=" .. getOS()
    if config.getOther_pl ~= nil  and config.getOther_pl() ~= "" then
        local pl2= config.getOther_pl()
        return urlParam.."&other_pl="..pl2
    end
    return urlParam
end

function quit( ... )
    -- if g_system_type == kBT_PLATFORM_ANDROID then
    --   local dict = CCDictionary:create()
    --   protocol:callOCFunctionWithName_oneParam_noBack("quit",dict)
    -- else
    -- CCDirector:sharedDirector():endToLua()
    -- os.exit()
    -- end
    BTUtil:exitNow()
end

function getUUID( ... )
    if(not isPlatform())then
        return "UUID_IS_NULL"
    end

    -- if(getOS() == "android")then
        return protocol:callStringFuncWithParam("getUuid",nil)
    -- else
    --     -- TODO, zhangqi, 2015-07-03, 这里需要区分appstore和越狱平台调用不同的uuid获取方法
    --     return ""--UIDUtil:getUID() -- ios设备标识符
    -- end
end

function getServerId( ... )
    if(g_tbServerInfo== nil)then
        return ""
    end
    return g_tbServerInfo.groupid
end

function empty(var)
    return not var or var=="" or var==0 or (type(var)=="table" and table.isEmpty(var))
end

function setCrashInfo( ... )
    local dict = CCDictionary:create()
    for k,v in pairs(sdkLoginInfo or {}) do
        dict:setObject(CCString:create(tostring(v)),k)
    end

    dict:setObject(CCString:create(tostring(_pid)),"pid")
    -- dict:setObject(CCString:create("cpp"),"env")
    dict:setObject(CCString:create(getGameName()),"gn")
    dict:setObject(CCString:create(getOS()),"os")
    dict:setObject(CCString:create(config.getFlag()),"pl")
    dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupid")
    dict:setObject(CCString:create(g_pkgVer.script),"scriptVersion")
    dict:setObject(CCString:create(g_pkgVer.package),"packageVersion")
    protocol:callOCFunctionWithName_oneParam_noBack("setCrashInfo",dict)

end


function restartOrExitApp( ... )
    if(not isPlatform)then
        quit()
        return
    end
    if(getOS() == "android")then
        local protocol = Platform.getSdk()
        local dict = CCDictionary:create()
        dict:setObject(CCString:create("message"),"string")
        protocol:callOCFunctionWithName_oneParam_noBack("restartApplication",dict)
    else
        quit()
    end
end

function getDeviceInfo( )

    local info = {}
    info.versionName = protocol:callStringFuncWithParam("getVersion", nil)
    info.model = protocol:callStringFuncWithParam("getModel", nil)
    info.sysVersion = protocol:callStringFuncWithParam("getSysVersion", nil)
    info.uuid = getUUID()
    info.scriptVersion = g_pkgVer.script
    info.packageVersion = g_pkgVer.package
    return info
end

function sendUuid( _type, _extend )
    local group = CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup") or ""
    local url = getHost() .. "phone/getStart?"
    url = url .. "pid="..getPid()
    url = url .. "&uuid="..getUUID()
    url = url .. "&type=" ..  _type or "getStart"
    url = url .. "&extend=" .. _extend or ""
    url = url .. "&group=" .. group or ""
    url = url .. getUrlParam()

    sendHTTPRequestLua(
        function( client, response)
            local ret_str = response:getResponseData()
            local retCode = response:getResponseCode()
            print("ret_str")
        end, url, 0)
end



function lua_string_split(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end

function sendHTTPRequestLua( callback, url,  type)

    if((not string.find(url,"&sign=")) and (not string.find(url,"gettime")) and (not string.find(url,"getStart")) and (not string.find(url,"sendnotifications")))then
        url = signUrl(url)
    end
    local request = LuaHttpRequest:newRequest()
    request:setRequestType(type)--CCHttpRequest.kHttpGet
    request:setUrl(url)
    request:setResponseScriptFunc(function(client, response)
        print("request url:",url )
        print("response:",response:getResponseData() )
        if not response:isSucceed() then
            if(not string.find(url,web_ip) and not isDebug())then
                url = string.gsub(url,getHost(),web_ip)
                url = lua_string_split(url,"&time")[1]
                print("use back ip")
                sendHTTPRequestLua(callback, url,  type)
            else
                PlatformUtil.showAlert(("网络不稳定, 请检查后重试"), function ( ... )
                    PlatformUtil.closeAlert()
                end)
                PlatformUtil.reduceLoadingUI()
            end
            return
        end
        if(needCheck(response,callback, url, type))then
            return
        end
        if(callback)then
            callback(client, response)
        end
    end)
    local httpClient = CCHttpClient:getInstance()
    httpClient:send(request)
    request:release()
end

function needCheck( response, org_callback, org_url, org_type )
    local ret_str = response:getResponseData()
    local info = cjson.decode(ret_str)
    if type(info) == "table"  and empty(info) == false then
        local errornu = info.errornu
        local errorDesc = info.errordesc
        if(errornu == 100 or errornu == 101) then
            local confirStr = info.checkcode
            require "platform/CheckCodeTip"

            CheckCodeTip.showTip(confirStr,function (checkCode)
                org_url = lua_string_split(org_url,"&time")[1]
                org_url = lua_string_split(org_url,"&checkcode")[1]
                org_url = org_url .. "&checkcode=" .. checkCode or ""
                logger:debug("add check code url= %s",org_url)
                sendHTTPRequestLua(org_callback, org_url, org_type)
            end)
            return true
        end
    end
    return false
end

--- 签名下 url 增加time 和sign
function signUrl( _url )
    local  url = _url .. "&time="..getWebTime()
    local sortedParams = fnSortUrlParams (url)
    sortedParams = sortedParams .. "9c98948d313ccdAE962e899a60692c_russia"
    logger:debug("sortedParams = %s", sortedParams)
    local sign = CCCrypto:md5(sortedParams,string.len(sortedParams),false)
    url = url .. "&sign=" .. sign
    -- logger:debug("sign url %s" , url)
    return url
end

function fnSortUrlParams(pUrl)
    local result = ""
    local fullUrl = pUrl
    -- print("fullUrl : ", fullUrl)
    local aData01 = string.split(fullUrl, "?")
    if #aData01 > 1 then
        local params = ""
        for i=2, #aData01 do
            params = params .. aData01[i]
        end
        local aData02 = string.split(params, "&")
        if #aData02 > 1 then
            table.sort(aData02, function (p01, p02)
                local aData03 = string.split(p01, "=")
                local aData04 = string.split(p02, "=")

                return aData03[1] < aData04[1]
            end)
        end
        result = table.concat(aData02, "")
    end
    result = decodeURL(result)
    return result
end


function encodeURL(url)
    local aByte, zByte, AByte, ZByte, _Byte, dotByte, hypeByte, n0Byte, n9Byte = string.byte("azAZ_.-09", 1, 9)
    local ret = ""
    for i = 1, url:len() do
        local c = string.byte(url, i)
        if (c >= aByte and c <= zByte) or (c >= AByte and c <= ZByte) or (c>=n0Byte and  c<=n9Byte) or c == _Byte or c == dotByte or c == hypeByte then
            ret = ret .. string.char(c)
        else
            ret = ret .. '%'
            ret = ret .. string.format("%02x", c)
        end
    end
    return ret
end

function decodeURL(str)
    str = string.gsub (str, "+", " ")
    str = string.gsub (str, "%%(%x%x)", function(h) return string.char(tonumber(h,16)) end)
    str = string.gsub (str, "\r\n", "\n")
    return str
end

function syncServerTime( fun )
    local url = getHost() .. "phone/gettime"
    local sendDeviveTokenCallback = function (client, response)
        local ret_str = response:getResponseData()
        local retCode = response:getResponseCode()
        local ok = response:isSucceed()
        print("ret_str, retCode= ", ret_str, retCode)

        if(tonumber(retCode) == 200)then
            local cjson = require "cjson"
            local ret_info = cjson.decode(ret_str)
            if( ret_info ~= nil and ret_info.time ~= nil)then
                webTime = ret_info.time
                local serverTime = os.time()
                timeOffset = tonumber(webTime)-tonumber(serverTime)
                if(type(fun) == "function")then
                    fun(webTime)
                end
            end
        end
    end
    -- print("str_url：", str_url)
    local httpClent = sendHTTPRequestLua(sendDeviveTokenCallback, url, 0)
end

function getWebTime( ... )
    local currTime = os.time()
    local webtime = tonumber(currTime) + tonumber(timeOffset or 0)
    logger:debug("currTime %s timeOffset %s webtime %s" ,currTime , timeOffset , webtime )
    return webtime
end

function addLocalNotificationBy(key,msg,time)
    NotificationManager:addLocalNotificationBy(key, msg, time, kCFCalendarUnitDay_BT)
end


function cancelLocalNotificationBy(key)
    NotificationManager:cancelLocalNotificationBy(key)
end


function cancelAllLocalNotification()
    NotificationManager:cancelAllLocalNotification()
end

--返回android总内存, 返回单位M
function getAndroidMemory( ... )
    local MemTotal = 0

    for line in io.lines('/proc/meminfo') do
        for key in string.gmatch(line, "%a+") do
            print("key=",key)
            if(key == "MemTotal")then
                for value in string.gmatch(line,"%d+") do
                    MemTotal = tonumber(value)/1024
                    print("value=",value)
                    return MemTotal
                end
            end
            
        end
    end
    return MemTotal
end

--礼包码SDK
function doPostGiftCode( giftCode )
    local dict = CCDictionary:create()
    dict:setObject(CCString:create(giftCode),"giftCode")
    protocol:callOCFunctionWithName_oneParam_noBack("doPostGiftCode",dict)
end

