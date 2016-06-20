require "zoo.panel.phone.PhoneLoginInfo"
require "zoo.panel.phone.PhoneConfirmPanel"
require "zoo.panel.phone.SendCodeConfirmPanel"
require "zoo.panel.phone.VerifyPhoneConfirmPanel"
require "zoo.panel.phone.PhoneLoginPanel"
require "zoo.panel.accountPanel.ChangePhoneConfirmPanel"

AccountBindingSource = table.const{
    ACCOUNT_SYSTEM  = 1,
    ADD_FRIEND = 2,
}

AccountBindingLogic = class()

function AccountBindingLogic:bindNewPhone(onReturnCallback, onBindSuccessCallback, source)
    local function onCancel( ... )
        if onReturnCallback then
            onReturnCallback()
        end

        CommonTip:showTip("您已取消绑定手机号~")
    end

    local function onPhoneLoginComplete( openId,phoneNumber,accessToken )

        local profile = UserManager.getInstance().profile
        local sns_token = {openId=openId,accessToken=accessToken, authorType=PlatformAuthEnum.kPhone}
        local snsInfo = { snsName=phoneNumber }
        if not _G.sns_token then
            snsInfo.name = profile:getDisplayName()
            snsInfo.headUrl = profile.headUrl
        end
        AccountBindingLogic:bindConnect(PlatformAuthEnum.kPhone,snsInfo,sns_token, onBindSuccessCallback, nil, nil, source)
    end

    local phoneLoginInfo = PhoneLoginInfo.new(PhoneLoginMode.kAddBindingLogin)
    if not _G.sns_token then
        phoneLoginInfo:setGuestAddBinding(true)
    end
    local panel = PhoneLoginPanel:create(phoneLoginInfo)
    panel:setBackCallback(onCancel)
    panel:setPhoneLoginCompleteCallback(onPhoneLoginComplete)
    panel:popout()


    DcUtil:UserTrack({ category="setting",sub_category="setting_click_binding" ,object=PlatformAuthEnum.kPhone })
end

function AccountBindingLogic:updateSnsUserProfile( authorizeType,snsName,name,headUrl )
    local profile = UserManager.getInstance().profile
    local http = UpdateProfileHttp.new()

    profile:setSnsInfo(authorizeType,snsName,name,headUrl)

    local snsPlatform = PlatformConfig:getPlatformAuthName(authorizeType)
    snsName = HeDisplayUtil:urlEncode(snsName)
    if name then
        name = HeDisplayUtil:urlEncode(name)
    end

    http:load(name, headUrl,snsPlatform,snsName)
end

function AccountBindingLogic:bindConnect(authorizeType,snsInfo,sns_token, onConnectFinish, onConnectError, onConnectCancel, source)
    if not snsInfo then
        snsInfo = { snsName = Localization:getInstance():getText("game.setting.panel.use.device.name.default") }
    end
    if _G.sns_token then 
        AccountBindingLogic:snsBindConnect(authorizeType,snsInfo,sns_token, onConnectFinish, onConnectError, source)
    else
        AccountBindingLogic:guestBindConnect(authorizeType,snsInfo,sns_token, onConnectFinish, onConnectError, onConnectCancel, source)
    end
end

function AccountBindingLogic:snsBindConnect( authorizeType,snsInfo,sns_token, connectFinishCallback, connectErrorCallback , source)
    local oldAuthorizeType = SnsProxy:getAuthorizeType()

    local snsName = snsInfo.snsName
    local name = snsInfo.name
    local headUrl = snsInfo.headUrl

    local function onConnectFinish( ... )
        AccountBindingLogic:updateSnsUserProfile(authorizeType,snsName,name,headUrl)

        if authorizeType ~= PlatformAuthEnum.kPhone then
            if not PlatformConfig:isQQPlatform() then
                SnsProxy:setAuthorizeType(authorizeType)
                SnsProxy:syncSnsFriend(sns_token)
                SnsProxy:setAuthorizeType(oldAuthorizeType)
            end
        end
        print("bindSns:connect success")
        DcUtil:UserTrack({ category='setting', sub_category="setting_click_binding_success", object = authorizeType})        

        if connectFinishCallback then 
            connectFinishCallback() 
        end
    end

    local function onConnectError ( event )

        if tonumber(event.data) == 730764 then
            local tipStr = localize("setting.alert.content.2", 
                                    {account = PlatformConfig:getPlatformNameLocalization(authorizeType), 
                                     account1 = PlatformConfig:getPlatformNameLocalization(authorizeType),
                                     account2 =  PlatformConfig:getPlatformNameLocalization(authorizeType)
                                    })
            -- if source == AccountBindingSource.ACCOUNT_SYSTEM then
            --     local panel = AccountConfirmPanel:create()
            --     panel:initLabel(tipStr, "知道了")
            --     panel:popout()
            --     panel.allowBackKeyTap = false
            -- else
                local txt = {tip = tipStr, 
                             yes = "知道了",
                             no = ""}

                CommonTipWithBtn:showTip(txt, 2, nil, nil, nil, true)
            -- end
        else
            CommonTip:showTip("绑定账号失败！","negative")
        end
        print("bindSns:snsBindConnect error")
        if connectErrorCallback then
            connectErrorCallback()
        end
    end

    local http = ExtraConnectHttp.new(true)    
    http:addEventListener(Events.kComplete, onConnectFinish)
    http:addEventListener(Events.kError, onConnectError)
    http:syncLoad2(
        sns_token.openId,
        sns_token.accessToken,
        PlatformConfig:getPlatformAuthName(authorizeType),
        HeDisplayUtil:urlEncode(snsName)
    )
end

function AccountBindingLogic:guestBindConnect( authorizeType,snsInfo,sns_token, finishCallback, errorCallback, cancelCallback, source)

    local snsName = snsInfo.snsName
    local name = snsInfo.name
    local headUrl = snsInfo.headUrl
    source = source or AccountBindingSource.ACCOUNT_SYSTEM

    local function onFinish( mustExit )
        if mustExit then
            AccountBindingLogic:updateSnsUserProfile(authorizeType,snsName,name,headUrl)  -- TODO
            if finishCallback then
                finishCallback(mustExit)
            end            
            if __ANDROID then luajava.bindClass("com.happyelements.android.ApplicationHelper"):restart()
            else Director.sharedDirector():exitGame() end        
        else
            _G.sns_token = sns_token
            AccountBindingLogic:updateSnsUserProfile(authorizeType,snsName,name,headUrl)  -- TODO
            if authorizeType ~= PlatformAuthEnum.kPhone then
                SnsProxy:syncSnsFriend()
            end

            HomeScene:sharedInstance().settingButton:updateDotTipStatus()
            if finishCallback then
                finishCallback(mustExit)
            end    
        end
        DcUtil:UserTrack({ category='setting', sub_category="setting_click_binding_success", object = authorizeType})

    end

    local function onCancel( ... )
        if cancelCallback then
            cancelCallback()
        end
    end

    local function onError(  )
        if errorCallback then
            errorCallback()
        end

        CommonTip:showTip("绑定账号失败！","negative")
        print("bindSns:guestBindConnect connect error")
    end

    local openId = sns_token.openId
    local accessToken = sns_token.accessToken
    local snsPlatform = PlatformConfig:getPlatformAuthName(authorizeType)
    local oldSnsPlatform =  nil

    local function preconnect( onGetPreConnect )

        local function onError( evt )
            onGetPreConnect(nil)
        end
        local function onFinish( evt )  
            onGetPreConnect(evt.data)
        end

        local cachedHttpList = UserService.getInstance():getCachedHttpData()
        local hasCache = cachedHttpList and #cachedHttpList > 0

        local http = PreQQConnectHttp.new(true)
        http:addEventListener(Events.kComplete, onFinish)
        http:addEventListener(Events.kError, onError)
        http:syncLoad2(openId,accessToken,hasCache,snsPlatform,HeDisplayUtil:urlEncode(snsName))
    end

    local function connect( onGetConnect )

        local function onError( evt )
            onGetConnect(nil)
        end

        local function onFinish( evt )
            onGetConnect(evt.data)
        end

        local http = QQConnectHttp.new(true)
        http:addEventListener(Events.kComplete, onFinish)
        http:addEventListener(Events.kError, onError)
        http:syncLoad(openId,accessToken,snsPlatform,HeDisplayUtil:urlEncode(snsName))
    end

    
    local function onGetConnect( result )
        if result and result.uid and result.uuid then
            local serverNewUid = result.uid
            local serverNewUDID = result.uuid
            local localOldUid = UserManager.getInstance().uid

            UdidUtil:saveUdid(serverNewUDID)
            Localhost.getInstance():setLastLoginUserConfig(serverNewUid, serverNewUDID, _G.kDefaultSocialPlatform)
            if tostring(serverNewUid) ~= tostring(localOldUid) then
                Localhost.getInstance():deleteUserDataByUserID(localOldUid)

                local function onRegisterFinish( ... ) 
                    SnsProxy:setAuthorizeType(authorizeType)
                    Localhost:setCurrentUserOpenId(sns_token.openId,sns_token.accessToken,authorizeType)

                    onFinish(true)
                end
                local function onRegisterError( ... )
                    UdidUtil:revertUdid()
                    Localhost.getInstance():setLastLoginUserConfig(0, nil, _G.kDefaultSocialPlatform) 

                    onFinish(true)
                end

                local scene = Director:sharedDirector():getRunningScene()
                if scene then 
                    CountDownAnimation:createNetworkAnimation(scene, onRegisterError) 
                end

                kDeviceID = serverNewUDID            
                local logic = PostLoginLogic.new()
                logic:addEventListener(PostLoginLogicEvents.kComplete, onRegisterFinish)
                logic:addEventListener(PostLoginLogicEvents.kError, onRegisterError)
                logic:load()
            else
                kDeviceID = serverNewUDID
                UserManager.getInstance().sessionKey = kDeviceID
                Localhost.getInstance():flushCurrentUserData()

                ConnectionManager:invalidateSessionKey()

                SnsProxy:setAuthorizeType(authorizeType)
                Localhost:setCurrentUserOpenId(sns_token.openId,nil,authorizeType)

                onFinish(false)
            end
        else
            onError()
            return
        end

    end

    local function onGetPreConnect( result )
        if not result then 
            onError()
            return
        end

        local errorCode = result.errorCode or 0
        local alertCode = result.alertCode or 0
        if errorCode > 0 then
            onError()
            return
        end

        if alertCode > 0 then 

                local function onTouchPositiveButton()
                    connect(onGetConnect)
                end
                local function onTouchNegativeButton()
                    onCancel()
                    if source == AccountBindingSource.ADD_FRIEND then
                        if authorizeType == PlatformAuthEnum.kPhone then
                            CommonTip:showTip(localize("add.friend.panel.cancel.phonebook"), "negative")
                        else
                            --todo:
                        end
                    end
                end

            local entrance = authorizeType == PlatformAuthEnum.kPhone and AccountBindingSource.ACCOUNT_SYSTEM or source
            print("alert code: "..tostring(alertCode))
            if alertCode == QzoneSyncLogic.AlertCode.MERGE then
                local platform = PlatformConfig:getPlatformNameLocalization(authorizeType)
                local formated = QzoneSyncLogic:formatLevelInfoMessage(result.mergeLevelInfo or 1, tonumber(result.mergeUpdateTimeInfo))
                local accMode = Localization:getInstance():getText("loading.tips.preloading.warnning.mode1")

                local mergePanel = require("zoo.panel.accountPanel.NewQQMergePanel"):create(
                    entrance, 
                    localize("loading.tips.start.btn.qq", {platform=platform}),
                    localize("loading.tips.preloading.warnning.new3", {platform = platform, user=formated}),
                    localize("loading.tips.preloading.warnning.new4", {platform = platform, mode=accMode}),
                    localize("loading.tips.preloading.warnning.new5", {platform = platform})
                )
                mergePanel:setOkCallback(onTouchPositiveButton)
                mergePanel:setCancelCallback(onTouchNegativeButton)
                mergePanel:popout()
            elseif alertCode == QzoneSyncLogic.AlertCode.DIFF_PLATFORM then

                local panel = require("zoo.panel.accountPanel.NewCrossDevicePanel"):create(entrance)
                panel:setOkCallback(onTouchPositiveButton)
                panel:setCancelCallback(onTouchNegativeButton)
                panel:popout() 

            elseif alertCode == QzoneSyncLogic.AlertCode.NEED_SYNC then
                local platform = PlatformConfig:getPlatformNameLocalization(authorizeType)
                local cachedHttpList = UserService.getInstance():getCachedHttpData()
                local hasCache =  cachedHttpList and #cachedHttpList > 0

                if hasCache then
                    local syncPanel = require("zoo.panel.accountPanel.NewQQSyncPanel"):create( 
                        entrance,
                        Localization:getInstance():getText("loading.tips.start.btn.qq", {platform=platform}),
                        Localization:getInstance():getText("loading.tips.preloading.warnning.new1", {platform=platform}),
                        Localization:getInstance():getText("loading.tips.preloading.warnning.new2", {platform=platform})
                    )
                    syncPanel:setOkCallback(onTouchPositiveButton)
                    syncPanel:setCancelCallback(onTouchNegativeButton)
                    syncPanel:popout()
                else
                    onTouchPositiveButton()
                end
            else
                print("unhandled alert code!!!!!!!!!")
                onError()
                return
            end
        else
            onGetConnect(result)
        end
    end

    RequireNetworkAlert:callFuncWithLogged(function( ... )
        preconnect(onGetPreConnect)
        
    end,function( ... )
        onError()

    end,kRequireNetworkAlertAnimation.kSync)
end


function AccountBindingLogic:changePhoneBinding(onConfirmCallback, onReturnCallback)
    local function onCancel()
        if onReturnCallback then
            onReturnCallback()
        end
        CommonTip:showTip("您已取消更换手机号~")
    end

    local function requestRebindingHttp( openId,phoneNumber,accessToken )
        local function onRebindingFinish(event)
            UserManager:getInstance().userExtend:setFlagBit(8, true)

            local snsName = phoneNumber
            UserManager:getInstance().profile:setSnsInfo(PlatformAuthEnum.kPhone, snsName)

            CommonTip:showTip(Localization:getInstance():getText("setting.alert.content.8"),"positive",nil,4)

            DcUtil:UserTrack({ category="setting", sub_category="setting_click_switch_success" })
        end

        local function onRebindingError(evt)
            CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
        end

        local http = RebindingHttp.new()
        http:addEventListener(Events.kComplete, onRebindingFinish)
        http:addEventListener(Events.kError, onRebindingError)
        http:load(phoneNumber,openId,accessToken)
    end

    local function popoutNewPhonePanel( ... )
        local phoneNumber = UserManager:getInstance().profile:getSnsUsername(PlatformAuthEnum.kPhone) or ''

        local phoneLoginInfo = PhoneLoginInfo.new(PhoneLoginMode.kBindingNewLogin)
        phoneLoginInfo:setOldPhone(phoneNumber)

        local panel = PhoneLoginPanel:create(phoneLoginInfo)
        panel:setBackCallback(onCancel)
        panel:setPhoneLoginCompleteCallback(requestRebindingHttp)
        panel:popout()
    end

    local function popoutOldPhonePanel( ... )
        local phoneLoginInfo = PhoneLoginInfo.new(PhoneLoginMode.kBindingOldLogin)
        local phoneNumber = UserManager:getInstance().profile:getSnsUsername(PlatformAuthEnum.kPhone) or ''

        local panel = VerifyPhoneConfirmPanel:create(phoneLoginInfo,phoneNumber,"changeBindingVerifyOldV2")
        panel:setBackCallback(onCancel)
        panel:setPhoneLoginCompleteCallback(popoutNewPhonePanel)
        panel:popout()
    end

    local function popoutSendCodeConfirmPanel( ... )
        -- if onConfirmCallback then
        --    onConfirmCallback()
        -- end        
        local phoneNumber = UserManager:getInstance().profile:getSnsUsername(PlatformAuthEnum.kPhone) or ''
        phoneNumber = string.sub(phoneNumber,1,3) .. string.rep("*",4) .. string.sub(phoneNumber,-4,-1)
        local panel = SendCodeConfirmPanel:create(phoneNumber,true,PhoneLoginMode.kBindingOldLogin)
        panel:setCancelCallback(onCancel)
        panel:setOkCallback(popoutOldPhonePanel)
        panel:popout()
    end

    local function verifyOldPhone( ... )
        local phoneLoginInfo = PhoneLoginInfo.new(PhoneLoginMode.kBindingOldLogin)

        local phoneNumber = UserManager:getInstance().profile:getSnsUsername(PlatformAuthEnum.kPhone) or ''
        local function onSuccess( data )
            HttpsClient.setSessionId(data.sessionId)
            popoutSendCodeConfirmPanel()

            DcUtil:UserTrack({ 
                category='login', 
                sub_category='login_account_phone', 
                step=1, 
                place=phoneLoginInfo:getDcPlace(),
                where=phoneLoginInfo:getDcWhere(),
                custom=phoneLoginInfo:getDcCustom(),
            })
        end
        local function onError( errorCode, errorMsg, data )
            CommonTip:showTip(localize("phone.register.error.tip."..errorCode))
        end
        
        local data = { phoneNumber = phoneNumber, deviceUdid = MetaInfo:getInstance():getUdid() }
        local httpsClient = HttpsClient:create("changeBindingVerifyOldPhoneNumber",data,onSuccess,onError)
        httpsClient:send()
    end

    local function popoutConfirmPanel( ... )
        local panel = ChangePhoneConfirmPanel:create()
        panel:setCancelCallback(onCancel)
        panel:setOkCallback(verifyOldPhone)
        panel:popout()
    end

    popoutConfirmPanel()

    DcUtil:UserTrack({ category='setting', sub_category="setting_click_switch" })
end

function AccountBindingLogic:bindNewSns(authorizeType, onConnectFinish, onConnectError, onConnectCancel, source)

    local scene = Director:sharedDirector():getRunningScene()
    if not scene then
        return
    end
    local isCancel = false
    local animation
    animation = CountDownAnimation:createBindAnimation(scene, function( ... )
        isCancel = true
        animation:removeFromParentAndCleanup(true)
        if onConnectCancel then
            onConnectCancel()
        end
    end)
    
    local oldAuthorizeType = SnsProxy:getAuthorizeType()
    local logoutCallback = {
        onSuccess = function(result)

            local function onSNSLoginResult( status, result )
                if status == SnsCallbackEvent.onSuccess and result then
                    local sns_token = result
                    sns_token.authorType = authorizeType

                    print("login Sns account success:" .. table.tostring(sns_token))

                    local function successCallback( ... )
                        if not isCancel then
                            print("going to bind new sns account!!!!!!!!!")
                            local snsInfo = {
                                snsName = SnsProxy.profile.nick,
                                name = SnsProxy.profile.nick,
                                headUrl = SnsProxy.profile.headUrl,
                            }

                            AccountBindingLogic:bindConnect(authorizeType,snsInfo,sns_token, onConnectFinish, onConnectError, onConnectCancel, source)

                            animation:removeFromParentAndCleanup(true)
                        end

                        print("bindSns: successCallback")
                    end
                    local function errorCallback( ... )
                        if not isCancel then
                            AccountBindingLogic:bindConnect(authorizeType,nil,sns_token, onConnectFinish, onConnectError, onConnectCancel, source)
                            animation:removeFromParentAndCleanup(true)
                        end

                        print("~~~~~~~~~~~bindSns: errorCallback")
                    end
                    local function cancelCallback( ... )
                       if not isCancel then
                            AccountBindingLogic:bindConnect(authorizeType,nil,sns_token, onConnectFinish, onConnectError, onConnectCancel, source)
                            animation:removeFromParentAndCleanup(true)
                        end

                        print("~~~~~~~~~~~~bindSns: cancelCallback")
                    end
                    SnsProxy:setAuthorizeType(authorizeType)
                    SnsProxy:getUserProfile(successCallback,errorCallback,cancelCallback)
                    SnsProxy:setAuthorizeType(oldAuthorizeType)
                -- elseif status == SnsCallbackEvent.onCancel then
                --     local platform = PlatformConfig:getPlatformNameLocalization(authorizeType)
                --     CommonTip:showTip(localize("add.friend.panel.cancel.login.qq", {platform = platform}))
                --     animation:removeFromParentAndCleanup(true)
                --     if onConnectCancel then
                --         onConnectCancel()
                --     end
                else
                    if not isCancel then
                        if source == AccountBindingSource.ADD_FRIEND then
                            --CommonTip:showTip("绑定账号失败！","negative")
                            print("sync sns friends canceled!!!!!!!")
                        else
                            CommonTip:showTip("绑定账号失败！","negative")
                        end
                        
                        animation:removeFromParentAndCleanup(true)
                        if onConnectError then
                            onConnectError()
                        end
                    end

                    print("bindSns:login error " .. tostring(status))
                end
            end
            SnsProxy:setAuthorizeType(authorizeType)
            SnsProxy:login(onSNSLoginResult)
            SnsProxy:setAuthorizeType(oldAuthorizeType)
        end,
        onError = function(errCode, msg) 
            if not isCancel then
                CommonTip:showTip("绑定账号失败！","negative")
                animation:removeFromParentAndCleanup(true)
                if onConnectError then
                    onConnectError()
                end
            end

            print("bindSns:",errCode,msg)
        end,
        onCancel = function()
            if not isCancel then
                CommonTip:showTip("绑定账号失败！","negative")
                animation:removeFromParentAndCleanup(true)
                if onConnectCancel then
                    onConnectCancel()
                end
            end

            print("bindSns: cancel")
        end
    }

    SnsProxy:setAuthorizeType(authorizeType)
    SnsProxy:logout(logoutCallback)
    SnsProxy:setAuthorizeType(oldAuthorizeType)

    DcUtil:UserTrack({ category='setting', sub_category="setting_click_binding", object = authorizeType})
end
