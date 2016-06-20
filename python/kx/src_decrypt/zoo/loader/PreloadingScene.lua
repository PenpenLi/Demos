require "hecore.display.TextField"
require "hecore.display.ArmatureNode"
require "hecore.ui.PopoutManager"
require "hecore.ui.ProgressBar"

require "zoo.config.ResourceConfig"
require "zoo.ui.InterfaceBuilder"
require "zoo.ui.ButtonBuilder"

require "zoo.util.FrameLoader"
require "zoo.util.HeadImageLoader"
require "zoo.util.WeChatSDK"
require "zoo.util.GameCenterSDK"

require "zoo.scenes.HomeScene"
require "zoo.scenes.PreloadingSceneUI"

require "zoo.data.LevelMapManager"
require "zoo.data.MetaManager"
require "zoo.data.UserManager"
require "zoo.data.LadyBugMissionManager"
require "zoo.data.UserEnergyRecoverManager"
require "zoo.data.MaintenanceManager"

require "zoo.net.LoginLogic"
require "zoo.net.SyncManager"

require "hecore.sns.SnsProxy"
require "zoo.util.SnsUtil"

require "zoo.panel.AnnouncementPanel"
require "zoo.util.YYBTMSelfUpdateManager"

require "zoo.gameGuide.BindPhoneGuideLogic"

require "zoo.panel.phone.LoginInfoChangePanel"
require "zoo.gamePlay.CheckPlay"

kLoginErrorType = table.const {
    register = 1,
    changeUser = 2,
    syncData = 3,
    connect = 4,
}

local PreloadingScene = class(Scene)

function PreloadingScene:onInit()
    self.name = "PreloadingScene"
    local isWin32Debug = __WIN32 and NetworkConfig.showDebugButtonInPreloading
    if not isWin32Debug and MaintenanceManager.getInstance():isEnabled("PhoneAccountSystem") then
        PlatformConfig:setPhonePlatformAuth()
    end

    LevelMapManager.getInstance():initialize()
    MetaManager.getInstance():initialize()
    GameCenterSDK:getInstance():authenticateLocalUser()
    self:handleCMPaymentDecision()
    PreloadingSceneUI:initUI(self)
    self:checkNeedRegister()
    self:preloadResource() 
    if not PlatformConfig:isPlatform(PlatformNameEnum.kQQ) then--应用宝版本公告先不弹，检测省流量更新后再弹
        self:loadAnnouncement()
    end

end

function PreloadingScene:updateConfig()
    local function onUpdateConfigError( evt )
        if evt then evt.target:removeAllEventListeners() end
        print("onUpdateConfigFinish error")
    end
    local function onUpdateConfigFinish( evt )
        evt.target:removeAllEventListeners()
        print("onUpdateConfigFinish finished", table.tostring(evt.data))
        if evt.data then
            Localhost.getInstance():saveUpdatedGlobalConfig(evt.data)
        end
    end 
    local http = UpdateConfigFromServerHttp.new()
    http:addEventListener(Events.kComplete, onUpdateConfigFinish)
    http:addEventListener(Events.kError, onUpdateConfigError)
    http:load()
end

function PreloadingScene:create()
    local s = PreloadingScene.new()
    s:initScene()
    return s
end

function PreloadingScene:getPlatformNameLocalization()
    return PlatformConfig:getPlatformNameLocalization()
end

function PreloadingScene:handleCMPaymentDecision()
    local function onComplete(evt)
        if __ANDROID then SnsProxy:initPlatformConfig() end
    end

    local decisionProcessor = require("zoo.loader.CMPaymentDecisionProcessor").new()
    decisionProcessor:addEventListener(Events.kComplete, onComplete)
    decisionProcessor:addEventListener(Events.kError, onComplete)
    decisionProcessor:start()
end

function PreloadingScene:toggleLoginUIElements(enable)
    if self.antiAddictionText then
        self.antiAddictionText:setVisible(enable)
    end
    if self.startButton then
        self.startButton:setVisible(enable)
    end
    if self.blueButton then
        self.blueButton:setVisible(enable)
    end
end

function PreloadingScene:loadAnnouncement( ... )

    AnnouncementPanel.loadAnnouncement(function( xml )
        if self.isDisposed then 
            return
        end
        if not xml then
            return 
        end
        local announcements = AnnouncementPanel.parseAnnouncement(xml)
        print("announcements",table.tostring(announcements))
        if table.size(announcements) <= 0 then 
            return 
        end

        if not self.isLoadResourceComplete then 
            self.announcements = announcements
        else
            if self.stopAutoLogin then
                self:stopAutoLogin()
            end
            self:toggleLoginUIElements(false) 
            AnnouncementPanel:create(announcements,self):popout(function ()
                if self.startAutoLogin then
                    self:startAutoLogin()
                end
                self:toggleLoginUIElements(true)
            end) 
        end
    end)
end

function PreloadingScene:checkNeedRegister()
    local function onRegisterSuccess(evt)
        evt.target:rma()
        
        local loginInfo = evt.data
        local userId = loginInfo.uid
        local sessionKey = loginInfo.sk
        local platform = loginInfo.p
        Localhost.getInstance():setLastLoginUserConfig(userId, sessionKey, platform)
    end

    local function guestLoginNewUser(evt)
        evt.target:rma()

        local registerNewUserProcessor = require("zoo.loader.RegisterNewUserProcessor").new()
        registerNewUserProcessor:ad(Events.kComplete, onRegisterSuccess)
        registerNewUserProcessor:start()
    end

    local registerDetectProcessor = require("zoo.loader.NeedRegisterDetectProcessor").new()
    registerDetectProcessor:ad(registerDetectProcessor.events.kLocalNewUser, guestLoginNewUser)
    registerDetectProcessor:start()
end

local yybisSkiped = false
function PreloadingScene:preloadResource()
    if PlatformConfig:isPlatform(PlatformNameEnum.kQQ) then
        --应用宝省流量更新逻辑
        local checkUpdateEnableResult = function(result)
            print("RRR   YYB Update  yybUpdateMaintenanceIsOn = " .. tostring(result))
            if result then
                YYBTMSelfUpdateManager:getInstance():showUpdatePanel(self)
            else
                if YYBTMSelfUpdateManager:getInstance().isSkiped == false then
                    self:loadAnnouncement()
                    self.progressBar:setVisible(true)
                    self:doLoadResource()
                    YYBTMSelfUpdateManager:getInstance().isSkiped = true
                end
            end
        end
        self.progressBar:setVisible(false)
        YYBTMSelfUpdateManager:getInstance():checkUpdateEnable(checkUpdateEnableResult)
    else
        self:doLoadResource()
    end
end

function PreloadingScene:doLoadResource()
    local function onLoadResourceComplete(evt)
        evt.target:rma()
        -- self:buildAuthUI()

        if (_G.isCheckPlayModeActive) then
             self:startReplay()
        else
            if self.announcements then 
                AnnouncementPanel:create(self.announcements,self):popout(function () self:buildAuthUI() end)
            else
                self:buildAuthUI()
            end
        end
        self.isLoadResourceComplete = true

        if not __WP8 then AsyncLoader:getInstance():load() end

        _G.kResourceLoadComplete = true
    end

    if (_G.isCheckPlayModeActive) then
        
        for k , v in pairs( ResourceConfig.asyncPlist ) do
            table.insert( ResourceConfig.plist , v )
        end

        ResourceConfig.asyncPlist = {}
    end

    local loadResourceProcess = require("zoo.loader.LoadResourceProcessor").new() 
    loadResourceProcess:addEventListener(Events.kComplete, onLoadResourceComplete)
    loadResourceProcess:start(self.statusLabel, self.statusLabelShadow, self.progressBar)
end

function PreloadingScene:startReplay()
    -- Fang Zuo Bi Mode
    if (_G.isCheckPlayModeActive) then

        -- tell agent to give me some oper

        -- CheckPlay:check( checkId , diffData , playData )
        print(">>>>>>>>>>>>> FANG ZUO BI START >>>>>>>>>>>>>")
        
        StartupConfig:getInstance():init(StartupConfig:getInstance():getCheckClientReceiveAddress(),StartupConfig:getInstance():getCheckClientSendAddress())
        StartupConfig:getInstance():receive()
        setTimeOut(function() 
            CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function() 
                CheckPlay:heardBeat()
            end,10,false)
        end,3)

        -- local checkId = "999"
        -- local diff = "[{\"totalLevel\":9,\"gameData\":{\"addMoveBase\":0,\"balloonFrom\":0,\"confidence\":99,\"dropRules\":[],\"gameModeName\":\"Order\",\"hasDropDownUFO\":false,\"moveLimit\":17,\"numberOfColours\":5,\"orderList\":[{\"k\":\"1_2\",\"v\":10}],\"pm25\":0,\"portals\":[],\"randomSeed\":838669,\"replaceColorMaxNum\":0,\"scoreTargets\":[200,350,480],\"specialAnimalMap\":[[0,0,0,0,0,0,0,0,0],[0,0,4,2,0,64,2,0,0],[0,32,64,16,4,32,4,4,0],[0,64,4,16,16,2,16,4,0],[0,64,4,2,4,32,4,16,0],[0,0,32,2,4,16,16,0,0],[0,0,0,4,2,16,0,0,0],[0,0,0,0,32,0,0,0,0],[0,0,0,0,0,0,0,0,0]],\"tileMap\":[[\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\"],[\"0\",\"0\",\"18\",\"18\",\"0\",\"18\",\"18\",\"0\",\"0\"],[\"0\",\"18\",\"2\",\"2\",\"18\",\"2\",\"2\",\"18\",\"0\"],[\"0\",\"2\",\"2\",\"2\",\"2\",\"2\",\"2\",\"2\",\"0\"],[\"0\",\"2\",\"2\",\"2\",\"2\",\"2\",\"2\",\"2\",\"0\"],[\"0\",\"0\",\"2\",\"2\",\"2\",\"2\",\"2\",\"0\",\"0\"],[\"0\",\"0\",\"0\",\"2\",\"2\",\"2\",\"0\",\"0\",\"0\"],[\"0\",\"0\",\"0\",\"0\",\"2\",\"0\",\"0\",\"0\",\"0\"],[\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\"]],\"tips\":\"1\"}}]"
        -- local data = "{\"level\":9,\"replaySteps\":[{\"x2\":4,\"x1\":3,\"y2\":5,\"y1\":5},{\"x2\":4,\"x1\":4,\"y2\":6,\"y1\":5},{\"x2\":5,\"x1\":5,\"y2\":7,\"y1\":6},{\"x2\":3,\"x1\":2,\"y2\":3,\"y1\":3}],\"hasDropBuff\":false,\"randomSeed\":1461830956,\"selectedItemsData\":{}}"
        -- -- score 36085
        -- local simplejson = require("cjson")
        -- tDiff = simplejson.decode(diff)
        -- tData = simplejson.decode(data)
        -- print(tData.level)
        -- print(tData.replaySteps)
        -- print(tData.replaySteps[1])
        -- print(tData.randomSeed)
        -- print(tData.hasDropBuff)
        -- print(tDiff[1].totalLevel)
        -- print(tDiff[1].gameData.confidence)

        -- --setTimeOut( function () CheckPlay:check(checkId,tDiff,tData) end , 10 )
        -- CheckPlay:check(checkId,tDiff,tData)

        print(">>>>>>>>>>>>> FANG ZUO BI END >>>>>>>>>>>>>")
    end
end

function PreloadingScene:buildAuthUI()
    local function onGuestLogin()
        self:hideButtons()
        self:guestRegisterDetect()
    end

    local isGuestLogin = PlatformConfig:isAuthConfig(PlatformAuthEnum.kGuest)
    if isGuestLogin then
        if NetworkConfig.showDebugButtonInPreloading then 
            PreloadingSceneUI:buildDebugButton(self, onGuestLogin)
        else
            PreloadingSceneUI:buildGuestLoginButton(self, onGuestLogin)
        end
    else
        local redButton, blueButton = PreloadingSceneUI:buildOAuthLoginButtons(self)
        self:redefineButtonForPlatform(redButton, blueButton)
        -- BindPhoneGuideLogic:get():onShowLoginBtn(self.oauthButton)
    end

    he_log_info("auto_test_apk_start_success")
    self.requireButtons = true
end

function PreloadingScene:redefineButtonForPlatform(redButton, blueButton)
    local function onTouchGuestLogin(evt)
        self:onGuestButtonTouched()
    end

    local function onTouchOAuthLogin(evt)
        self:onOAuthButtonTouched()
    end

    self.redButton = redButton
    self.blueButton = blueButton

    self.blueButton:removeEventListenerByName(DisplayEvents.kTouchTap)
    self.blueButton:addEventListener(DisplayEvents.kTouchTap, onTouchGuestLogin)
    self.redButton:removeEventListenerByName(DisplayEvents.kTouchTap)
    self.redButton:addEventListener(DisplayEvents.kTouchTap, onTouchOAuthLogin)

    self:updateOAuthButtonState()
end


function PreloadingScene:updateOAuthButtonState()
    if MaintenanceManager.getInstance():isEnabled("PhoneAccountSystem") then
        PlatformConfig:setPhonePlatformAuth()
    end

    self.oauthButton = self.redButton -- 默认情况下，红按钮
    if self.redButton.agreement then
        if self.redButton.agreement.touchLayer and not self.redButton.agreement.touchLayer.isDisposed then
            self.redButton.agreement.touchLayer:setTouchEnabled(true)
        end
        CCUserDefault:sharedUserDefault():setBoolForKey("game.user.agreement.checked", false)
    end

    local function checkAgreement( cb )
        if self.antiAddictionText and self.antiAddictionText:isVisible() then
            self.antiAddictionText:setVisible(false)
        end

        if self.redButton.agreement then
            if not self.redButton.agreement.isDisposed and
                self.redButton.agreement.checked then
                if self.redButton.agreement.touchLayer and not self.redButton.agreement.touchLayer.isDisposed then
                    self.redButton.agreement.touchLayer:setTouchEnabled(false)
                end
                cb()
                CCUserDefault:sharedUserDefault():setBoolForKey("game.user.agreement.checked", true)
            else
                CommonTip:showTip(Localization:getInstance():getText("loading.agreement.button.reject"))       
            end
        else
            cb()
        end        
    end

    local function isCheckAgreement( ... )
        if self.redButton.agreement then
            return not self.redButton.agreement.isDisposed and self.redButton.agreement.checked
        else
            return true
        end
    end

    -- 游客登录
    local function onTouchGuestLogin(evt)
        if self.stopAutoLogin then
            self:stopAutoLogin()
        end
        checkAgreement(function( ... )
            self:onGuestButtonTouched()

            DcUtil:UserTrack({ category='login', sub_category='login_click_custom' })
        end)

    end

    -- 开始游戏
    local function onTouchOAuthLogin(evt)
        if self.stopAutoLogin then
            self:stopAutoLogin()
        end
        checkAgreement(function( ... )
            self:onOAuthButtonTouched()
        end)

    end

    -- 切换账号
    local function onTouchChangeAccount(evt)
        if self.stopAutoLogin then
            self:stopAutoLogin()
        end
        checkAgreement(function( ... )
            self:onChangeAccountButtonTouched()
        end)

    end

    local lastAuthorType = PlatformConfig:getLastPlatformAuthType()
    if lastAuthorType and not PlatformConfig:hasAuthConfig(lastAuthorType) then
        self:logoutWithChangeAccount()
    end

    local isLogin = false
    if SnsProxy then
        isLogin = SnsProxy:isLogin() or (SnsProxy:isPhoneLogin() and not SnsProxy:isPhoneLoginExpire())

        if SnsProxy:isPhoneLogin() and SnsProxy:isPhoneLoginExpire() then
            self:logoutWithChangeAccount()
            self.lastPhoneLoginExpire = true
        elseif not isLogin then
            -- 解决msdk覆盖安装问题，先这么解决
            -- 线上更新ios出现没有snsid 但是数据是sns的，改为只处理应用宝平台
            if PlatformConfig:isQQPlatform() then 
                local savedConfig = Localhost.getInstance():getLastLoginUserConfig()
                if savedConfig then
                    local userData = Localhost:getInstance():readUserDataByUserID(savedConfig.uid)
                    if userData and userData.openId then
                        self:logoutWithChangeAccount()
                    end
                end
            end
        end
    end

    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
        if self.blueButton then self.blueButton:setVisible(false) end

        local platform = self:getPlatformNameLocalization()
        local platformLoginTip = Localization:getInstance():getText("loading.tips.start.btn.qq", { platform = platform })
        
        self.redButton:setString(platformLoginTip)
        self.redButton:removeEventListenerByName(DisplayEvents.kTouchTap)
        self.redButton:addEventListener(DisplayEvents.kTouchTap, onTouchOAuthLogin)
        self.redButton:setTouchEnabled(true)
        self.redButton:setVisible(true)
        return
    end

    local function displayLoginTipLabel()
        local posY = self.blueButton:getPositionY()
        local btnSize = self.blueButton:getGroupBounds().size
        if self.loginTipsLabel then
            self.loginTipsLabel:setPositionY(posY - btnSize.height / 2 - 15)
            self.loginTipsLabel:setVisible(CCUserDefault:sharedUserDefault():getBoolForKey("game.user.agreement.checked"))
        end
    end

    self.redButton:setTouchEnabled(true)
    self.blueButton:setTouchEnabled(true)

    self.startAutoLogin = nil
    self.stopAutoLogin = nil
    if isLogin then
        self.redButton:setString(Localization:getInstance():getText("button.start.game.loading"))
        self.blueButton:setString(Localization:getInstance():getText("loading.tips.start.btn.change.qq"))

        self.redButton:removeEventListenerByName(DisplayEvents.kTouchTap)
        self.redButton:addEventListener(DisplayEvents.kTouchTap, onTouchOAuthLogin)
        self.blueButton:removeEventListenerByName(DisplayEvents.kTouchTap)
        self.blueButton:addEventListener(DisplayEvents.kTouchTap, onTouchChangeAccount)

        self.oauthButton = self.blueButton

        function self:startAutoLogin( ... )
            if not isCheckAgreement() then
                return
            end
            -- 3秒后自动登录
            local platform = PlatformConfig:getPlatformNameLocalization(SnsProxy:getAuthorizeType())
            self.redButton:setString(platform .. "登录中……")
            self.redButton:runAction(CCSequence:createWithTwoActions(
                CCDelayTime:create(3),
                CCCallFunc:create(onTouchOAuthLogin)
            ))
        end

        function self:stopAutoLogin( ... )
            self.redButton:setString(Localization:getInstance():getText("button.start.game.loading"))
            self.redButton:stopAllActions()
        end

        self:startAutoLogin()
    else
        local platform = Localization:getInstance():getText("platform.platform")
        local platformLoginTip = Localization:getInstance():getText("loading.tips.start.btn.qq", { platform = platform })

        self.redButton:setString(platformLoginTip)
        self.blueButton:setString(Localization:getInstance():getText("loading.tips.start.btn.guest"))

        self.redButton:removeEventListenerByName(DisplayEvents.kTouchTap)
        self.redButton:addEventListener(DisplayEvents.kTouchTap, onTouchOAuthLogin)
        self.blueButton:removeEventListenerByName(DisplayEvents.kTouchTap)
        self.blueButton:addEventListener(DisplayEvents.kTouchTap, onTouchGuestLogin)
    end

    if self.blueButton then 
        if PublishActUtil:isGroundPublish() then 
            self.blueButton:setVisible(false)
        else
            self.blueButton:setVisible(true)
        end
    end

    if self.redButton then 
        self.redButton:setVisible(true) 
    end
end

function PreloadingScene:onGuestButtonTouched()
    self:alertBeforeGuestLogin()
    self:hideButtons()
end

function PreloadingScene:onChangeAccountButtonTouched( ... )

    local function onSelectSnsLogin( evt )
        self:updateOAuthButtonState()
        if self.stopAutoLogin then
            self:stopAutoLogin()
        end
        SnsProxy:setAuthorizeType(evt.data)

        self:changeAccount()
    end

    local function onSelectPhoneLoginComplete( evt )
        -- local loginInfo = evt.data
        -- self:doLogin(loginInfo, true)

        self:oauthRegisterDetect(true)
    end

    local function onCancel( ... )
        self:updateOAuthButtonState()
        self:clearStatus()
    end
    
    self:hideButtons()

    local processor = require("zoo.loader.SelectAccountLoginProcessor").new()
    processor:addEventListener(processor.Events.kSnsLogin, onSelectSnsLogin)
    processor:addEventListener(processor.Events.kPhoneLoginComplete,onSelectPhoneLoginComplete)
    processor:addEventListener(processor.Events.kCancel,onCancel)
    processor:start(self,true)

end

function PreloadingScene:changeAccount()
    local oauthChangeAccountProcessor = require("zoo.loader.OAuthChangeAccountProcessor").new()

    local function onChangeAccountComplete(evt)
        evt.target:rma()
        self:hideButtons()
        if evt.data then
            local loginInfo = evt.data
            self:doLogin(loginInfo, true, true)
        else
            self:oauthRegisterDetect()
        end
    end

    local function onChangeAccountError(evt)
        evt.target:rma()
        CommonTip:showTip(Localization:getInstance():getText("error.tip.-2"),'negative',nil,1)
        self:updateOAuthButtonState()
    end

    local function onChangeAccountCancel(evt)
        evt.target:rma()
        self:updateOAuthButtonState()
    end

    local function onChangeAccountReady(evt)
        -- do not remove event listener here, just logout ready
        local function cancelLoginCallback()
            oauthChangeAccountProcessor:rma()
            self:updateOAuthButtonState()
        end

        self:changeUIOnSNSLogin(cancelLoginCallback)
    end

    oauthChangeAccountProcessor:addEventListener(Events.kComplete, onChangeAccountComplete)
    oauthChangeAccountProcessor:addEventListener(Events.kError, onChangeAccountError)
    oauthChangeAccountProcessor:addEventListener(Events.kCancel, onChangeAccountCancel)
    oauthChangeAccountProcessor:addEventListener(Events.kStart, onChangeAccountReady)
    oauthChangeAccountProcessor:start(self)
end

function PreloadingScene:alertBeforeGuestLogin()
    local function confirmGuestLogin(evt)
        evt.target:rma()
        self:guestRegisterDetect()
    end

    local function cancelGuestLogin(evt)
        evt.target:rma()
        self:updateOAuthButtonState()
    end

    local alertProcessor = require("zoo.loader.AlertBeforeGuestLoginProcessor").new()
    alertProcessor:addEventListener(Events.kComplete, confirmGuestLogin)
    alertProcessor:addEventListener(Events.kCancel, cancelGuestLogin)
    alertProcessor:start(self:getPlatformNameLocalization())
end

function PreloadingScene:onOAuthButtonTouched()
    local isLogin = SnsProxy:isLogin() or SnsProxy:isPhoneLogin()
    print("onOAuthButtonTouched " .. tostring(isLogin))
    if isLogin then
        -- login with cached OAuth info
        self:oauthLoginWithCache()
        self:hideButtons()
    else
        self:hideButtons()
        self:selectAccountLogin()
    end
end

function PreloadingScene:selectAccountLogin( ... )

    local function onSelectSnsLogin( evt )
        self:updateOAuthButtonState()
        if self.stopAutoLogin then
            self:stopAutoLogin()
        end
        SnsProxy:setAuthorizeType(evt.data)

        self:oauthLoginWithRequest()
    end

    local function onSelectPhoneLoginComplete( evt )
        -- local loginInfo = evt.data
        -- self:doLogin(loginInfo, true)
        self:oauthRegisterDetect()
    end

    local function onCancel( ... )
        self:updateOAuthButtonState()
        self:clearStatus()
    end

    local processor = require("zoo.loader.SelectAccountLoginProcessor").new()
    processor:addEventListener(processor.Events.kSnsLogin, onSelectSnsLogin)
    processor:addEventListener(processor.Events.kPhoneLoginComplete,onSelectPhoneLoginComplete)
    processor:addEventListener(processor.Events.kCancel,onCancel)
    processor:start(self,false,self.lastPhoneLoginExpire)
end

function PreloadingScene:oauthLoginWithCache()
    local function loginWithCache(evt)
        evt.target:rma()
        self:oauthRegisterDetect()
    end

    local function loginWithRequest(evt)
        evt.target:rma()
        self:oauthLoginWithRequest()
    end

    if PlatformConfig:isPlatform(PlatformNameEnum.k360) and SnsProxy:getAuthorizeType() == PlatformAuthEnum.k360 then
        self:changeUIOnGuestLogin()
    end

    local oauthLoginWithTokenCacheProcessor = require("zoo.loader.OAuthLoginWithCacheProcessor").new()
    oauthLoginWithTokenCacheProcessor:addEventListener(Events.kComplete, loginWithCache)
    oauthLoginWithTokenCacheProcessor:addEventListener(Events.kError, loginWithRequest)
    oauthLoginWithTokenCacheProcessor:start()
end

function PreloadingScene:oauthLoginWithRequest()
    print("oauthLoginWithRequest")
    local isCancel = false

    local function onLoginSuccess(evt)
        print("oauthLoginProcessor " .. "onLoginSuccess")
        evt.target:rma()
        self.requireButtons = false
        self:hideButtons()
        self:oauthRegisterDetect()
        self:clearStatus()
    end

    local function onLoginFail(evt)
        print("oauthLoginProcessor " .. "onLoginFail")
        evt.target:rma()
        self.requireButtons = false
        self:updateOAuthButtonState()
        self:clearStatus()
    end

    local function onLoginCancel(evt)
        print("oauthLoginProcessor " .. "onLoginCancel")
        evt.target:rma()
        isCancel = true
        self:updateOAuthButtonState()
        self:clearStatus()
    end

    local oauthLoginProcessor = require("zoo.loader.OAuthLoginWithRequestProcessor").new()
    oauthLoginProcessor:addEventListener(Events.kComplete, onLoginSuccess)
    oauthLoginProcessor:addEventListener(Events.kError, onLoginFail)
    oauthLoginProcessor:addEventListener(Events.kCancel, onLoginCancel)
    oauthLoginProcessor:start(self)

    local function cancelLoginCallback()
        oauthLoginProcessor:rma()
        self:updateOAuthButtonState()
    end

    if not isCancel then
        self:changeUIOnSNSLogin(cancelLoginCallback)
    end
end

function PreloadingScene:oauthRegisterDetect(isSyncAfterChangeAccount)
    local function guestLoginOldUser(evt)
        evt.target:rma()
        local loginInfo = Localhost.getInstance():getLastLoginUserConfig()
        self:doLogin(loginInfo, true, isSyncAfterChangeAccount)
    end

    local function guestLoginNewUser(evt)
        evt.target:rma()
        self:registerOAuthUser()
    end

    local registerDetectProcessor = require("zoo.loader.NeedRegisterDetectProcessor").new()
    registerDetectProcessor:ad(registerDetectProcessor.events.kLocalOldUser, guestLoginOldUser)
    registerDetectProcessor:ad(registerDetectProcessor.events.kLocalNewUser, guestLoginNewUser)
    registerDetectProcessor:start()
end


function PreloadingScene:guestRegisterDetect()
    local function guestLoginOldUser(evt)
        evt.target:rma()
        local loginInfo = Localhost.getInstance():getLastLoginUserConfig()
        self:doLogin(loginInfo, false)
    end

    local function guestLoginNewUser(evt)
        evt.target:rma()
        self:registerGuestUser()
    end

    local registerDetectProcessor = require("zoo.loader.NeedRegisterDetectProcessor").new()
    registerDetectProcessor:ad(registerDetectProcessor.events.kLocalOldUser, guestLoginOldUser)
    registerDetectProcessor:ad(registerDetectProcessor.events.kLocalNewUser, guestLoginNewUser)
    registerDetectProcessor:start()
end

function PreloadingScene:doLogin(loginInfo, isOAuth, isSyncAfterChangeAccount)
    -- 切换账号后,避免原账号同步的过程中user接口发送错误的loginType
    if isSyncAfterChangeAccount then
        _G.kLoginType = -1 -- invalid
    else
        if isOAuth then self.loginType = SnsProxy:getAuthorizeType()
        else self.loginType = PlatformAuthEnum.kGuest end
        _G.kLoginType = self.loginType
    end

    local function onLoginFinish(evt)
        evt.target:rma()
        if isSyncAfterChangeAccount then
            if isOAuth then self.loginType = SnsProxy:getAuthorizeType()
            else self.loginType = PlatformAuthEnum.kGuest end
            _G.kLoginType = self.loginType
        end
        self:clearStatus()
        self:onLoadLoginFinish()
        MissionModel:getInstance():updateDataOnLogin(true , isOAuth , loginInfo)
    end

    local function onLoginFail(evt)
        evt.target:rma()
        
        self.loginType = nil
        _G.kLoginType = nil
        -- login请求失败:游客登录时直接进入游戏; OAuth登录时如果openId对应的用户有本地数据记录则直接进入游戏,否则需要刷新按钮
        if isOAuth then
            local localUserConfig = Localhost.getInstance():getLastLoginUserConfig()
            local userData = nil
            if localUserConfig then 
                userData = Localhost.getInstance():readUserDataByUserID(localUserConfig.uid)
            end

            if userData 
                and _G.sns_token
                and userData.openId == _G.sns_token.openId
                then 
                self:clearStatus()
                self:onLoadLoginFinish()
                MissionModel:getInstance():updateDataOnLogin(false , isOAuth , loginInfo)
            else
                local msg = Localization:getInstance():getText("loading.tips.register.failure."..kLoginErrorType.register)
                CommonTip:showTip(msg, "negative")

                self:clearStatus()
                self.requireButtons = false
                -- 
                self:logout()
                self:updateOAuthButtonState()
            end
        else
            self:clearStatus()
            self:onLoadLoginFinish()
            MissionModel:getInstance():updateDataOnLogin(false , isOAuth , loginInfo)
        end

    end

    local loginProcessor = require("zoo.loader.LoginServerProcessor").new() 
    loginProcessor:ad(Events.kComplete, onLoginFinish)
    loginProcessor:ad(Events.kError, onLoginFail)
    loginProcessor:start(loginInfo)

    self:changeUIOnGuestLogin()

    MaintenanceManager.getInstance():initialize() -- require uid. initialize here
end

function PreloadingScene:registerOAuthUser()
    local function onRegisterSuccess(evt)
        evt.target:rma()
        local loginInfo = evt.data
        self:doLogin(loginInfo, true)
    end

    local function onRegisterError(evt)
        evt.target:rma()
        local msg = Localization:getInstance():getText("loading.tips.register.failure."..kLoginErrorType.register)
        CommonTip:showTip(msg, "negative")
        self:clearStatus()
        -- 
        self:logout()
        self:updateOAuthButtonState()
    end

    local registerNewUserProcessor = require("zoo.loader.RegisterNewUserProcessor").new()
    registerNewUserProcessor:ad(Events.kComplete, onRegisterSuccess)
    registerNewUserProcessor:ad(Events.kError, onRegisterError)
    registerNewUserProcessor:start()

    self:changeUIOnRegister()
end


function PreloadingScene:registerGuestUser()
    local function onRegisterSuccess(evt)
        evt.target:rma()
        local loginInfo = evt.data
        self:doLogin(loginInfo, false)
    end

    local function onRegisterError(evt)
        evt.target:rma()
        self:loginOffline()
        MaintenanceManager.getInstance():initialize() -- require uid. initialize here
    end

    local registerNewUserProcessor = require("zoo.loader.RegisterNewUserProcessor").new()
    registerNewUserProcessor:ad(Events.kComplete, onRegisterSuccess)
    registerNewUserProcessor:ad(Events.kError, onRegisterError)
    registerNewUserProcessor:start()

    self:changeUIOnRegister()
end

function PreloadingScene:updateStatusLabel(text)
    if self.statusLabel and self.statusLabel.refCocosObj then
        self.statusLabel:stopAllActions()

        self.statusLabel:setVisible(true)
        self.statusLabel:setString(text)

        self.statusLabelShadow:setVisible(true)
        self.statusLabelShadow:setString(text)

        self.preventWallowLabel:setVisible(true)
    end
end

function PreloadingScene:changeUIOnGuestLogin()
    if self.statusLabel and self.statusLabel.refCocosObj then
        self.statusLabel:setVisible(true)
        self.statusLabel:setString("小浣熊努力登录中，请稍候~")
        self.statusLabelShadow:setVisible(true)
        self.statusLabelShadow:setString("小浣熊努力登录中，请稍候~")
        self.preventWallowLabel:setVisible(true)
    end
end

function PreloadingScene:changeUIOnRegister()
    if self.statusLabel and self.statusLabel.refCocosObj then
        self.statusLabel:setVisible(true)
        self.statusLabel:setString("小浣熊正在为您创建账号...")
        self.statusLabelShadow:setVisible(true)
        self.statusLabelShadow:setString("小浣熊正在为您创建账号...")
        self.preventWallowLabel:setVisible(true)
    end
end

function PreloadingScene:changeUIOnSNSLogin(cancelLoginCallback)
    if self.loginTipsLabel then self.loginTipsLabel:setVisible(false) end

    local loadingTip = "正在登录中"
    local cancelTip = "取消"
    local function onTouchCancel(evt)
        if cancelLoginCallback and type(cancelLoginCallback) == "function" then
            cancelLoginCallback()
        end
    end
    self.redButton:setString(loadingTip)
    self.blueButton:setString(cancelTip)
    self.redButton:setTouchEnabled(false)
    self.blueButton:removeEventListenerByName(DisplayEvents.kTouchTap)
    self.blueButton:addEventListener(DisplayEvents.kTouchTap, onTouchCancel)
end

function PreloadingScene:changeUIOnConnect()
    if self.statusLabel and self.statusLabel.refCocosObj then
        self.statusLabel:setVisible(true)
        self.statusLabel:setString("数据合并中，请稍候~")
        self.statusLabelShadow:setVisible(true)
        self.statusLabelShadow:setString("数据合并中，请稍候~")
        self.preventWallowLabel:setVisible(true)
    end
end

function PreloadingScene:hideButtons()
    if self.startButton then self.startButton:setVisible(false) end
    if self.redButton then self.redButton:setVisible(false) end
    if self.blueButton then self.blueButton:setVisible(false) end
    if self.loginTipsLabel then self.loginTipsLabel:setVisible(false) end
end

function PreloadingScene:clearStatus()
    if self.statusLabel and self.statusLabel.refCocosObj then
        self.statusLabel:setString("")
        self.statusLabel:setVisible(false)
        self.statusLabel:stopAllActions()
        self.statusLabelShadow:setString("")
        self.statusLabelShadow:setVisible(false)
        self.statusLabelShadow:stopAllActions()
    end
end

local function gotoHome()
    Localhost:saveCgPlayed(1)
    UserEnergyRecoverManager:sharedInstance():startCheckEnergy()

    Director:sharedDirector():replaceScene(HomeScene:create())

    setTimeOut(function() 
        local resName1 = "materials/logo.plist"
        local resName2 = "flash/loading.plist"
        if __use_small_res then  
            resName1 = "materials/logo@2x.plist"
            resName2 = "flash/loading@2x.plist"
        end
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(resName1)
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(resName2)
        CCTextureCache:sharedTextureCache():removeUnusedTextures()
    end, 0.1)
end

function PreloadingScene:startGame()
    local config = Localhost:getDefaultConfig()
    if config.pl == 0 then
        local function onStartupAnimationFinish()
            self:updateUserNickname()
            gotoHome()
        end
        local StartupAnimation = require("zoo.animation.StartupAnimation")
        StartupAnimation:play(onStartupAnimationFinish)
    else 
        self:updateUserNickname()
        gotoHome() 
    end

    if PlatformConfig:isPlatform(PlatformNameEnum.kWDJ) 
        or PlatformConfig:isPlatform(PlatformNameEnum.k360) 
        or PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) 
        or __IOS_FB 
        or (__IOS_QQ and SnsProxy:isQQLogin()) -- ios平台下只有qq登录时才会同步第三方好友
        or (_G.kUserSNSLogin and SnsProxy:getAuthorizeType() == PlatformAuthEnum.kQQ)
    then --只有sns账号登录时才会去同步sns好友。
        if _G.kUserSNSLogin and not PlatformConfig:isQQPlatform() then
            SnsProxy:syncSnsFriend()
        end
    end
end

function PreloadingScene:updateUserNickname()
    local updateUserNicknameProcessor = require("zoo.loader.UpdateUserNicknameProcessor")
    updateUserNicknameProcessor:start()
end

function PreloadingScene:loginOffline()
    print("login offline")
    local function onLoginFinish( evt )
        evt.target:removeAllEventListeners()

        if not self.refCocosObj then return end

        self.statusLabel:setString("")
        self.statusLabel:setVisible(false)
        self.statusLabel:stopAllActions()
        self.statusLabelShadow:setString("")
        self.statusLabelShadow:setVisible(false)
        self.statusLabelShadow:stopAllActions()

        self.preventWallowLabel:setString("");
        self.preventWallowLabel:setVisible(false);
        
        self:onLoadLoginFinish()
    end 

    local logic = LoginLogic.new()
    logic:addEventListener(Events.kComplete, onLoginFinish)
    logic:addEventListener(Events.kError, onLoginFinish)
    logic:execute()
end

function PreloadingScene:onLoadLoginFinish()
    self:loadLevelConfigDynamicUpdate()
    local openId, accessToken,authorType
    if kUserLogin and sns_token then 
        openId = sns_token.openId
        accessToken = sns_token.accessToken
        authorType = sns_token.authorType
    end

    if openId and accessToken then 
        self:syncOAuthData(openId, accessToken,authorType) 
    else
        self:detectDeviceLoginInfo()
    end
end

function PreloadingScene:detectDeviceLoginInfo()
    local function onSuccess(evt)
        evt.target:rma()
        print("detect device login success")
        self:popoutLoginChangePanel(evt.data)
    end

    local function onFail(evt)
        evt.target:rma()
        print("detect device login fail")
        self:startGame()
    end

    local function onError(evt)
        evt.target:rma()
        print("detect device login error")
        self:startGame()
    end

    local deviceLoginDetectProcessor = require("zoo.loader.DeviceLoginDetectProcessor").new()
    deviceLoginDetectProcessor:addEventListener(deviceLoginDetectProcessor.events.kSuccess, onSuccess)
    deviceLoginDetectProcessor:addEventListener(deviceLoginDetectProcessor.events.kFail, onFail)
    deviceLoginDetectProcessor:addEventListener(deviceLoginDetectProcessor.events.kError, onError)
    deviceLoginDetectProcessor:start(self.loginType)
end

function PreloadingScene:popoutLoginChangePanel(alertInfo)
    local function onConfirm()
        local uid = UserManager:getInstance().uid
        if uid and type(uid) == 'number' then
            Cookie.getInstance():write("loginInfo" .. uid, "1")
        end
        self:startGame() 
    end

    local function onCancel(decision)
        if decision == LoginInfoChangePanel.CancelBtnDecisionType.kExitGame then
            Director.sharedDirector():exitGame()
        elseif decision == LoginInfoChangePanel.CancelBtnDecisionType.kSwitchLogin then
            self:logout()
            self:updateOAuthButtonState()
        end
    end
    
    local panel = LoginInfoChangePanel:create(alertInfo)
    panel:setConfirmCallback(onConfirm)
    panel:setCancelCallback(onCancel)
    panel:popout()
end

function PreloadingScene:loadLevelConfigDynamicUpdate()
    local levelConfigUpdateProcessor = require("zoo.loader.LevelConfigUpdateProcessor").new()
    levelConfigUpdateProcessor:start()
end

function PreloadingScene:isNeedChangeToMiAccount()
    return __ANDROID and PlatformConfig:isPlatform(PlatformNameEnum.kMI) 
            and SnsProxy:getAuthorizeType() == PlatformAuthEnum.kWeibo
            and sns_token 
end


function PreloadingScene:syncOAuthData(openId,accessToken,authorType)
    local function onSyncSuccess(evt)
        evt.target:rma()
        self:detectDeviceLoginInfo()
        self:clearStatus()
    end

    local function onSyncCancel(evt)
        evt.target:rma()
        self:updateOAuthButtonState()
        self:clearStatus()
    end

    local function onSyncCancelLogout(evt)
        evt.target:rma()
        self:logout()
        self:updateOAuthButtonState()
        self:clearStatus()
    end

    local syncProcessor = require("zoo.loader.SyncOAuthDataProcessor").new()
    syncProcessor:addEventListener(syncProcessor.events.kSyncSuccess, onSyncSuccess)
    syncProcessor:addEventListener(syncProcessor.events.kSyncCancel, onSyncCancel)
    syncProcessor:addEventListener(syncProcessor.events.kSyncCancelLogout, onSyncCancelLogout)
    syncProcessor:start(openId, accessToken,authorType)

    self:changeUIOnConnect()
end

function PreloadingScene:logout()
    return self:_logout(true)
end

function PreloadingScene:logoutWithChangeAccount()
    return self:_logout(false)
end

function PreloadingScene:_logout(deleteUserData)
    local result = {}
    local uid = UserManager.getInstance().uid
    if deleteUserData then
        if uid then 
            print("delete user data in PreloadingScene:logout() uid " .. uid)
            Localhost.getInstance():deleteUserDataByUserID(uid) 
        end
    end
    result.uid = uid
    result.udid = _G.kDeviceID
    local savedConfig = Localhost.getInstance():getLastLoginUserConfig()
    if savedConfig then
        local savedUid = tostring(savedConfig.uid)
        if savedUid then 
            if deleteUserData then
                Localhost.getInstance():deleteUserDataByUserID(savedUid) 
            end
            result.uid = savedUid
            result.udid = savedConfig.sk
        end
    end
    Localhost.getInstance():deleteLastLoginUserConfig()
    Localhost.getInstance():deleteGuideRecord()
    Localhost.getInstance():deleteMarkPriseRecord()
    Localhost.getInstance():deletePushRecord()
    Localhost.getInstance():deleteWeeklyMatchData()
    Localhost.getInstance():deleteUserMissionData()
    Localhost.getInstance():deleteLocalExtraData()
    LocalNotificationManager.getInstance():cancelAllAndroidNotification()

    CCUserDefault:sharedUserDefault():setStringForKey("game.devicename.userinput", "")
    -- CCUserDefault:sharedUserDefault():setIntegerForKey("thisWeekNoSelectAccount",0)
    CCUserDefault:sharedUserDefault():flush()

    UserManager.getInstance():reset()
    UserService.getInstance():reset()

    _G.kDeviceID = UdidUtil:revertUdid()
    _G.sns_token = nil
    _G.kUserSNSLogin = false
    _G.kLoginType = nil

    if SnsProxy then SnsProxy.profile = {} end

    return result 
end

function PreloadingScene:onKeyBackClicked(...)
    assert(#{...} == 0)
    print("HomeScene:onKeyBackClicked Called !")

    if __WP8 then
        if self.exitDialog then return end
        self.exitDialog = true
        local function msgCallback(r)
            if r then 
                Director.sharedDirector():exitGame()
            else
                self.exitDialog = false
            end
        end
        Wp8Utils:ShowMessageBox(Localization:getInstance():getText("game.exit.tip"), "", msgCallback)
        return
    end

    local function callPaymentExit(paymentClass)
        if paymentClass then
            local function buildCallback(onExit, onCancel)
                return luajava.createProxy("com.happyelements.android.InvokeCallback", {
                    onSuccess = onExit or function(result) end,
                    onError = onError or function(errCode, msg) end,
                    onCancel = onCancel or function() end
                })
            end
            local exitCallback = buildCallback(
                function(obj)
                    Director.sharedDirector():exitGame()
                end,
                function()
                    self.exitDialog = false
                end
            )
            self.exitDialog = true
            paymentClass:exitGame(exitCallback)
        end
    end

    local pfName = StartupConfig:getInstance():getPlatformName()
    if PlatformConfig:isBaiduPlatform() then
        local dUOKUProxy = luajava.bindClass("com.happyelements.hellolua.duoku.DUOKUProxy"):getInstance()
        if dUOKUProxy then
            dUOKUProxy:detectDKGameExit()
        end
    elseif PlatformConfig:isPlatform(PlatformNameEnum.kCMGame) then
        local cmgamePayment = luajava.bindClass("com.happyelements.android.operatorpayment.cmgame.CMGamePayment")
        callPaymentExit(cmgamePayment)
    elseif PlatformConfig:isPlatform(PlatformNameEnum.k189Store) then
        local telecomPayment = luajava.bindClass("com.happyelements.android.operatorpayment.telecom.TelecomPayment")
        callPaymentExit(telecomPayment)
    else
        if self.exitDialog then return end
        local function buildCallback(onSuccess, onError, onCancel)
            return luajava.createProxy("com.happyelements.android.InvokeCallback", {
                onSuccess = onSuccess or function(result) end,
                onError = onError or function(errCode, msg) end,
                onCancel = onCancel or function() end
            })
        end

        local snsCallback = buildCallback(
            function(obj)
                print("Info - Keypad Callback: sns onSuccess")
                Director.sharedDirector():exitGame()
            end
            ,
            function(errorCode, errExtra)
                print("Info - Keypad Callback: sns onError")
                self.exitDialog = false
            end
            ,
            function() 
                print("Info - Keypad Callback: sns onCancel")
                self.exitDialog = false
            end
        )
        local dialogUtil = luajava.bindClass("com.happyelements.android.utils.DialogUtil")
        self.exitDialog = true
        dialogUtil:alertDialog(
            Localization:getInstance():getText("game.exit.tip"),
            Localization:getInstance():getText("game.exit.yes"),
            Localization:getInstance():getText("game.exit.no"),
            snsCallback)
    end

end

function PreloadingScene:onEnterForeGround()
    local function onEnterForeGroundStatusUpdate()
        local isLogin = false
        if __ANDROID then isLogin = SnsProxy:isLogin() end
        if self.requireButtons and not isLogin then self:updateOAuthButtonState() end
    end
end

return PreloadingScene