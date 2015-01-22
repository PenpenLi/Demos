require "hecore.sns.SnsCallbackEvent"
require "hecore.luaJavaConvert"
require "zoo.data.MetaManager"

assert(__ANDROID, "must be android platform")

SnsProxy = {profile = {}}

local authorProxy = luajava.bindClass("com.happyelements.hellolua.aps.proxy.APSAuthorizeProxy"):getInstance()
local shareProxy = luajava.bindClass("com.happyelements.hellolua.aps.proxy.APSShareProxy"):getInstance()

local function buildError(errorCode, extra)
    return { errorCode = errorCode, msg = extra }
end

local function buildCallback(callback, resultParser)
    if type(callback) == "table" then
        return convertToInvokeCallback(callback)
    end
  
    local function onError(errorCode, extra)
        if callback then
            callback(SnsCallbackEvent.onError, buildError(errorCode, extra) )
        end
    end

    local function onCancel()
        if callback then
            callback(SnsCallbackEvent.onCancel)
        end
    end
      
    local function onSuccess(result)
        local tResult = nil
        if resultParser ~= nil and result ~= nil then
            tResult = resultParser(result)
        end

        if callback then
            callback(SnsCallbackEvent.onSuccess, tResult)
        end
    end
      
    return luajava.createProxy("com.happyelements.android.InvokeCallback", {
        onSuccess = onSuccess,
        onError = onError,
        onCancel = onCancel
    })
end

function convertToInvokeCallback(callback)
    return luajava.createProxy("com.happyelements.android.InvokeCallback", {
        onSuccess = callback.onSuccess,
        onError = callback.onError,
        onCancel = callback.onCancel
    })
end

function SnsProxy:initPlatformConfig()
    print("initPlatformConfig:"..PlatformConfig.name)

    require "hecore.sns.aps.AndroidPayment"
    require "hecore.sns.aps.AndroidAuthorize"
    require "hecore.sns.aps.AndroidShare"
    AndroidAuthorize.getInstance():initAuthorizeConfig(PlatformConfig.authConfig)
    AndroidPayment.getInstance():initPaymentConfig(PlatformConfig.paymentConfig)
    AndroidShare.getInstance():initShareConfig(PlatformConfig.shareConfig)

    if PlatformConfig:isPlatform(PlatformNameEnum.kCMGame) then
        -- 移动"和"游戏基地
        local cmgamePayment = luajava.bindClass("com.happyelements.android.operatorpayment.cmgame.CMGamePayment"):getInstance()
        -- enable or disable music and sound according to CMGame setting
        local isMusicEnabled = cmgamePayment:isMusicEnabled()
        local config = CCUserDefault:sharedUserDefault()
        config:setBoolForKey("game.disable.background.music", not isMusicEnabled)
        config:setBoolForKey("game.disable.sound.effect", not isMusicEnabled)
        config:flush()
    end
    
    if AndroidPayment.getInstance():isPaymentTypeSupported(Payments.QIHOO) then -- 设置支付回调地址，方便修改和测试。默认为线上值
        local qihooConfig = luajava.bindClass("com.happyelements.android.platform.qihoo.QihooConfig")
        qihooConfig:setRefreshPayTokenUrl(NetworkConfig.dynamicHost .. "payment/refreshQihooPayToken")
        qihooConfig:setNotifyUrl(NetworkConfig.dynamicHost .. "payment/qihoo")
    end 

    authorProxy:setAuthorizeType(AndroidAuthorize.getInstance():getDefaultAuthorizeType())
end

function SnsProxy:setAuthorizeType( authorType )
    authorProxy:setAuthorizeType(authorType)
end

function SnsProxy:getAuthorizeType()
    return authorProxy:getAuthorizeType()
end

-- called
function SnsProxy:isLogin()
    if PrepackageUtil:isPreNoNetWork() then return false end
    
    local lastLoginUser = Localhost.getInstance():getLastLoginUserConfig()
    if not lastLoginUser then
        return false
    end

    local userData = Localhost.getInstance():readUserDataByUserID(lastLoginUser.uid)
    -- print("userData:"..table.tostring(userData))
    if userData and userData.openId then
        -- if __ANDROID and PlatformConfig:isPlatform(PlatformNameEnum.kMI) then
        --     print("userData.snsType:"..table.tostring(userData.authorType))
        --     if not userData.authorType then return false end
        --     self:setAuthorizeType(userData.authorType) -- 使用上次登陆的平台进行判断
        -- end
        return authorProxy:isLogin()
    end
    return false
end
-- login
function SnsProxy:login(callback) 
    local authorDelegate = authorProxy:getAuthorizeDelegate()
    print("authorDelegate:")
    print(authorDelegate)
    local resultParser = function(result)
        local tResult = luaJavaConvert.map2Table(result)
        return tResult
    end
    authorProxy:login(buildCallback(callback, resultParser))
end

function SnsProxy:changeAccount( callback )
    local resultParser = function(result)
        local tResult = luaJavaConvert.map2Table(result)
        return tResult
    end
    if authorProxy:getAuthorizeType() == PlatformAuthEnum.k360 then
        local function safe_change_360()
            local delegate = authorProxy:getAuthorizeDelegate()
            delegate:changeAccount(buildCallback(callback, resultParser))
        end
        pcall(safe_change_360)
    else
        authorProxy:login(buildCallback(callback, resultParser))
    end
end

-- called
function SnsProxy:inviteFriends(callback)
    authorProxy:inviteFriends(convertToInvokeCallback(callback))
end

function SnsProxy:getAllFriends(callback)
    authorProxy:getFriends(0, 999, convertToInvokeCallback(callback))
end
-- logout    
function SnsProxy:logout(callback) 
    authorProxy:logout(buildCallback(callback, nil))
end

function SnsProxy:sendInviteMessage(shareType, friendIds, title, text, imageUrl, thumbUrl, callback) 
    local params = {title=title, text=text, image=imageUrl, thumb=thumbUrl}
    shareProxy:setShareType(tonumber(shareType))
    shareProxy:sendInviteMessage(friendIds, luaJavaConvert.table2Map(params), buildCallback(callback, nil))
end

function SnsProxy:shareImage( shareType, title, text, imageUrl, thumbUrl, callback )
    local params = {title=title, text=text, image=imageUrl, thumb=thumbUrl}
    shareProxy:setShareType(tonumber(shareType))
    shareProxy:shareImage(true, luaJavaConvert.table2Map(params), buildCallback(callback, nil))
end

function SnsProxy:shareText( shareType, title, text, callback )
    local params = {title=title, text=text}
    shareProxy:setShareType(tonumber(shareType))
    shareProxy:shareText(true, luaJavaConvert.table2Map(params), buildCallback(callback, nil))
end

--360的全部分享也走这个
function SnsProxy:shareLink( shareType, title, text, linkUrl, thumbUrl, callback )
    local params = {title=title, text=text, link=linkUrl, thumb=thumbUrl}
    print("SnsProxy:shareLink-"..table.tostring(params))
    shareProxy:setShareType(tonumber(shareType))
    shareProxy:shareLink(true, luaJavaConvert.table2Map(params), buildCallback(callback, nil))
end

-- called
function SnsProxy:getOperatorOne()
    return AndroidPayment.getInstance():getOperator()
end
-- called
function SnsProxy:submitScore( leaderBoardId, level )
    if authorProxy:isLogin() then
        authorProxy:submitUserScore(leaderBoardId, level, buildCallback(nil))
    end
end

function SnsProxy:showPlatformLeaderbord( )
    if authorProxy:isLogin() then
        authorProxy:showLeaderBoard()
    else
        local callback = {
            onSuccess=function( result )
                authorProxy:showLeaderBoard()
            end,
            onError=function(errorCode, msg)
            end,
            onCancel=function()
            end
        }
        authorProxy:login(convertToInvokeCallback(callback))
    end
end
-- called
function SnsProxy:purchaseItem(goodsType, itemId, itemAmount, realAmount, callback)
end

-- called
function SnsProxy:syncSnsFriend()
    print("SnsProxy:syncSnsFriend")
    if authorProxy:isLogin() then
        local callback = {
            onSuccess=function( result )
                local userList = luaJavaConvert.list2Table(result)
                local friendOpenIds = {}
                local count = 0
                for i, v in ipairs(userList) do
                    table.insert(friendOpenIds, v.openId)
                    print(tostring(i)..":uid="..tostring(v.openId))
                    count = i
                end
                if count > 0 then
                    local function onRequestError( evt )
                        evt.target:removeAllEventListeners()
                        print("onPreQzoneError callback")
                    end
                    local function onRequestFinish( evt )
                        evt.target:removeAllEventListeners()
                        print("onRequestFinish callback")
                    end 

                    local http = SyncSnsFriendHttp.new()
                    http:addEventListener(Events.kComplete, onRequestFinish)
                    http:addEventListener(Events.kError, onRequestError)

                    http:load(friendOpenIds)
                end
            end,
            onError = function( err, msg )
                print("err:"..tostring(err)..",msg:"..tostring(msg))
            end,
            onCancel = function()
            end
        }
        authorProxy:getFriends(0, 999, convertToInvokeCallback(callback))
    end
end
-- called
function SnsProxy:getUserProfile(successCallback,errorCallback,cancelCallback)
    if authorProxy:isLogin() then
        print("SnsProxy:getUserProfile")
        local callback = {
            onSuccess=function(result)
                SnsProxy.profile = luaJavaConvert.map2Table(result)
                print("getUserProfile=", table.tostring(SnsProxy.profile))
                successCallback(result)
            end,
            onError=function(err,msg)
                print("getUserProfile onError=", msg)
                errorCallback(err,msg)
            end,
            onCancel=function()
                cancelCallback()
            end
        }
        authorProxy:getUserProfile(convertToInvokeCallback(callback))
    else
        cancelCallback()
    end
end