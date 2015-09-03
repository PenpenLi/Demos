require 'zoo.panel.component.common.HorizontalTileLayout'
require "zoo.baseUI.ButtonWithShadow"

NewGameSettingPanel = class(BasePanel)
function NewGameSettingPanel:init()

    self.ui = self:buildInterfaceGroup("newGameSettingPanel")

    BasePanel.init(self, self.ui)

    self.onClosePanelBtnTappedCallback  = false

    self.panelChildren = {}
    self.ui:getVisibleChildrenList(self.panelChildren)

    self.musicBtn       = self.ui:getChildByName("musicBtn")
    self.soundBtn       = self.ui:getChildByName("soundBtn")

    self.notificationBtn        = self.ui:getChildByName("notificationBtn")
    self.notificationPauseIcon  = self.ui:getChildByName("notificationPauseIcon")

    self.musicPauseIcon = self.ui:getChildByName("musicPauseIcon")
    self.soundPauseIcon = self.ui:getChildByName("soundPauseIcon")

    self.panelTitle     = self.ui:getChildByName("panelTitle")
    self.closeBtn       = self.ui:getChildByName("closeBtn")

    self.soundBtnTip    = self.ui:getChildByName("soundBtnTip")
    self.musicBtnTip    = self.ui:getChildByName("musicBtnTip")
    self.notificationBtnTip = self.ui:getChildByName("notificationBtnTip")
    self.tips   = {self.soundBtnTip, self.musicBtnTip, self.notificationBtnTip}
    self.bg = self.ui:getChildByName("_newBg")


    self.panelTitle:setText(Localization:getInstance():getText("quit.panel.tittle"))
    

    
    -- Set Music / Effect Pause Icon 
    if GamePlayMusicPlayer:getInstance().IsMusicOpen then
        self.soundPauseIcon:setVisible(false)
    end

    if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then
        self.musicPauseIcon:setVisible(false)
    end

    if CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification") then
        self.notificationPauseIcon:setVisible(false) 
    end

    local size = self.panelTitle:getContentSize()
    local scale = 65 / size.height
    self.panelTitle:setScale(scale)
    self.panelTitle:setPositionX((self.bg:getGroupBounds().size.width - size.width * scale) / 2)

    -------------------
    -- Add Event Listener
    -- ----------------
    local function onClosePanelBtnTapped(event)
        self:onCloseBtnTapped(event)
    end

    local function onMusicBtnTapped()
        self:onMusicBtnTapped()
    end

    local function onNotificationBtnTapped()
        self:onNotificationBtnTapped()
    end

    self.musicBtn:setButtonMode(true)
    self.musicBtn:setTouchEnabled(true)
    self.musicBtn:addEventListener(DisplayEvents.kTouchTap, onMusicBtnTapped)

    local function onSoundBtnTapped()
        self:onSoundBtnTapped()
    end
    self.soundBtn:setButtonMode(true)
    self.soundBtn:setTouchEnabled(true)
    self.soundBtn:addEventListener(DisplayEvents.kTouchTap, onSoundBtnTapped)

    self.notificationBtn:setButtonMode(true)
    self.notificationBtn:setTouchEnabled(true)
    self.notificationBtn:addEventListener(DisplayEvents.kTouchTap, onNotificationBtnTapped)

    -- CLose Btn
    local function onCloseBtnTapped(event)
        self:onCloseBtnTapped(event)
    end

    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)

    if __IOS or __WP8 then -- WP8怎么初始化，待定。。。
        self:initIOS()
    elseif __ANDROID or __WIN32 then
        self:initAndroid()
    end
end

function NewGameSettingPanel:hidePaymentIcons()
    local bg4 = self.ui:getChildByName('bg4')
    local pay_text = self.ui:getChildByName('pay_text')
    local select = self.ui:getChildByName('select')
    local ph = self.ui:getChildByName('ph')
    bg4:removeFromParentAndCleanup(true)
    pay_text:removeFromParentAndCleanup(true)
    select:removeFromParentAndCleanup(true)
    ph:removeFromParentAndCleanup(true)
    local _newBg2 = self.ui:getChildByName('_newBg2')
    _newBg2:setPreferredSize(CCSizeMake(595,195))
    local _newBg = self.ui:getChildByName('_newBg')
    _newBg:setPreferredSize(CCSizeMake(632,320))
end

function NewGameSettingPanel:initIOS()
    self:hidePaymentIcons()
end

function NewGameSettingPanel:initAndroid()
    print('PlatformConfig ', table.tostring(PlatformConfig.paymentConfig))
    local payments = {}
    for k, v in pairs(PlatformConfig.paymentConfig.thirdPartyPayment) do
        if v ~= Payments.UNSUPPORT then
            table.insert(payments, v)
        end
    end
        

    local defaultSms = PaymentManager:getInstance():getDefaultSmsPayment()
    if defaultSms and defaultSms ~= Payments.UNSUPPORT then
        if PaymentManager.getInstance():checkSmsPayEnabled() then 
            table.insert(payments, defaultSms)
        end
    end

    local ph = self.ui:getChildByName('ph')
    local pay_text = self.ui:getChildByName('pay_text')
    local bg4 = self.ui:getChildByName('bg4')
    local pos, width, height
    local iconCount = #payments
    if iconCount == 0 then
        self:hidePaymentIcons()
        return 
    elseif iconCount == 1 then
        pos = ccp(370, -275)
        width = 77
        height = 56
        pay_text:setPosition(ccp(185, -288))
        bg4:setPreferredSize(CCSizeMake(260, 84))
        bg4:setPosition(ccp(188, -260))
    elseif iconCount == 2 then
        pos = ccp(332, -275)
        width = 139
        height = 56
        pay_text:setPosition(ccp(171, -288))
        bg4:setPreferredSize(CCSizeMake(327, 84))
        bg4:setPosition(ccp(156, -260))
    elseif iconCount == 3 then
        pos = ccp(304, -275)
        width = 196
        height = 56
        pay_text:setPosition(ccp(140, -288))
        bg4:setPreferredSize(CCSizeMake(389, 84))
        bg4:setPosition(ccp(131, -260))
    else
        assert(false, 'NewGameSettingPanel:initAndroid payment count not supported so far...')
    end


    ph:setVisible(false)
    local layout = HorizontalTileLayoutWithAlignment:create(width, height)
    layout:setAlignment(HorizontalAlignments.kCenter)
    layout:setItemHorizontalMargin(5)

    local function buildIcon(payment)
        local icon = self:getPaymentIcon(payment)
        if not icon then return nil end
        icon:setScale(height/icon:getGroupBounds().size.height)
        icon:setTouchEnabled(true, 0, true)
        return icon
    end

    local currentDefaultPayment = PaymentManager:getInstance():getDefaultPayment()
    print('currentDefaultPayment', currentDefaultPayment)

    if currentDefaultPayment == nil or currentDefaultPayment == Payments.UNSUPPORT then
        self.ui:getChildByName('select'):setVisible(false)
    end

    self.paymentIcons = {}

    for k, v in pairs(payments) do
        local icon = buildIcon(v)
        if icon then
            local wrapper = ItemInLayout:create()
            wrapper:setContent(icon)
            icon:ad(DisplayEvents.kTouchTap, function () self:onPaymentIconTapped(v) end)
            layout:addItem(wrapper)
            self.paymentIcons[v] = wrapper
        end
    end
    ph:getParent():addChildAt(layout, ph:getZOrder())
    layout:setPosition(pos)

    pay_text:setString(localize('game.setting.panel.pay.tip')..':')

    self:onPaymentIconTapped(currentDefaultPayment, true)

end

function NewGameSettingPanel:onPaymentIconTapped(payment, isInit)
    if payment == nil or payment == Payments.UNSUPPORT then return end
    local wrapper = self.paymentIcons[payment]
    if not wrapper then print('onPaymentIconTapped ERROR ', payment) return end
    local select = self.ui:getChildByName('select')
    select:setVisible(true)
    local pos = wrapper:getPosition()
    local size = wrapper:getGroupBounds().size
    local rb_corner = ccp(pos.x + size.width, pos.y - size.height)
    local select_pos = select:getParent():convertToNodeSpace(wrapper:getParent():convertToWorldSpace(rb_corner))
    select:setPositionX(select_pos.x)
    select:setPositionY(select_pos.y)

    if not isInit then
        self:setPaymentTip(payment)
        self:setPriorityPayment(payment)
    end
end

function NewGameSettingPanel:setPriorityPayment(payment)

    -- 如果是移动短代，就要判断具体是哪一种
    if table.exist(PlatformPaymentChinaMobileEnum, payment) then
        payment = PaymentManager:getInstance():getDefaultSmsPayment()
        print('setPriorityPayment sms ', payment)
    end

    if payment ~= Payments.UNSUPPORT and payment ~= nil then
        -- 设置真实的默认支付
        PaymentManager:getInstance():setDefaultPayment(payment)
        DcUtil:UserTrack({category = "set", sub_category = "buy_way_setting", way = payment})
    end

    print('setPriorityPayment', PaymentManager:getInstance():getDefaultPayment())
end

function NewGameSettingPanel:onMusicBtnTapped(...)    

    if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then
        GamePlayMusicPlayer:getInstance():pauseBackgroundMusic()
        self.musicPauseIcon:setVisible(true)

        self.musicBtnTip:setString(Localization:getInstance():getText("game.setting.panel.music.close.tip"))
    else
        GamePlayMusicPlayer:getInstance():resumeBackgroundMusic()
        self.musicPauseIcon:setVisible(false)

        self.musicBtnTip:setString(Localization:getInstance():getText("game.setting.panel.music.open.tip"))
    end

    self:playShowHideLabelAnim(self.musicBtnTip)
end


function NewGameSettingPanel:onSoundBtnTapped(...)
    if GamePlayMusicPlayer:getInstance().IsMusicOpen then
        GamePlayMusicPlayer:getInstance():pauseSoundEffects()
        self.soundPauseIcon:setVisible(true)

        self.soundBtnTip:setString(Localization:getInstance():getText("game.setting.panel.sound.close.tip"))
    else
        GamePlayMusicPlayer:getInstance():resumeSoundEffects()
        self.soundPauseIcon:setVisible(false)

        self.soundBtnTip:setString(Localization:getInstance():getText("game.setting.panel.sound.open.tip"))
    end

    self:playShowHideLabelAnim(self.soundBtnTip)
end

function NewGameSettingPanel:onNotificationBtnTapped(...)

    print("GameSettingPanel:onNotificationBtnTapped Called !")
    if not CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification") then
        CCUserDefault:sharedUserDefault():setBoolForKey("game.local.notification", true)
        self.notificationBtnTip:setString(Localization:getInstance():getText("game.setting.panel.notification.open.tip"))
        self.notificationPauseIcon:setVisible(false)
    else
        CCUserDefault:sharedUserDefault():setBoolForKey("game.local.notification", false)
        self.notificationBtnTip:setString(Localization:getInstance():getText("game.setting.panel.notification.close.tip"))
        self.notificationPauseIcon:setVisible(true)
    end
    self:playShowHideLabelAnim(self.notificationBtnTip)
    CCUserDefault:sharedUserDefault():flush()
end


function NewGameSettingPanel:playShowHideLabelAnim(labelToControl, ...)

    local delayTime = 3

    labelToControl:stopAllActions()

    local function showFunc()
        -- Hide All Tip
        for k,v in pairs(self.tips) do
            v:setVisible(false)
        end

        labelToControl:setVisible(true)
    end
    local showAction = CCCallFunc:create(showFunc)


    local delay = CCDelayTime:create(delayTime)


    local function hideFunc()
        labelToControl:setVisible(false)
    end
    local hideAction = CCCallFunc:create(hideFunc)

    local actionArray = CCArray:create()
    actionArray:addObject(showAction)
    actionArray:addObject(delay)
    actionArray:addObject(hideAction)

    local seq = CCSequence:create(actionArray)
    --return seq
    
    labelToControl:runAction(seq)
end

function NewGameSettingPanel:onCloseBtnTapped(event, ...)
    assert(#{...} == 0)

    he_log_warning("this kind of panel pop remove anim can reused.")
    he_log_warning("reform needed !")

    AdvertiseSDK:dismissDomobAD()

    local function animFinished()
        self.allowBackKeyTap = false
        PopoutManager:sharedInstance():remove(self, true)

        if self.onClosePanelBtnTappedCallback then
            self.onClosePanelBtnTappedCallback()
        end
    end

    self:playHideAnim(animFinished)
end


function NewGameSettingPanel:onEnterHandler(event, ...)
    assert(#{...} == 0)
    if event == "enter" then
        self.allowBackKeyTap = true
        self:playShowAnim(false)
    end
end

function NewGameSettingPanel:createShowAnim(...)
    assert(#{...} == 0)

    he_log_warning("this show Anim is common to a type of panel !!!")
    he_log_warning("reform needed !")


    local centerPosX    = self:getHCenterInParentX()
    local centerPosY    = self:getVCenterInParentY()

    local function initActionFunc()

        local initPosX  = centerPosX
        local initPosY  = centerPosY + 100
        self:setPosition(ccp(initPosX, initPosY))
    end
    local initAction = CCCallFunc:create(initActionFunc)

    -- Move To Center Anim
    local moveToCenter      = CCMoveTo:create(0.5, ccp(centerPosX, centerPosY))
    local backOut           = CCEaseQuarticBackOut:create(moveToCenter, 33, -106, 126, -67, 15)
    local targetedMoveToCenter  = CCTargetedAction:create(self.refCocosObj, backOut)

    -- Action Array
    local actionArray = CCArray:create()
    actionArray:addObject(initAction)
    actionArray:addObject(targetedMoveToCenter)

    -- Seq
    local seq = CCSequence:create(actionArray)
    return seq
end

function NewGameSettingPanel:playShowAnim(animFinishCallback, ...)
    assert(animFinishCallback == false or type(animFinishCallback) == "function")
    assert(#{...} == 0)

    local showAnim  = self:createShowAnim()

    local function finishCallback()
        if animFinishCallback then
            animFinishCallback()
        end
        he_log_info("auto_test_quit_panel_open")
    end
    local callbackAction = CCCallFunc:create(finishCallback)

    local seq = CCSequence:createWithTwoActions(showAnim, callbackAction)
    self:runAction(seq)
end

function NewGameSettingPanel:playHideAnim(animFinishCallback, ...)
    animFinishCallback()
end

function NewGameSettingPanel:setOnClosePanelBtnTapped(onClosePanelBtnTappedCallback, ...)
    assert(type(onClosePanelBtnTappedCallback) == "function")
    assert(#{...} == 0)

    self.onClosePanelBtnTappedCallback = onClosePanelBtnTappedCallback
end

function NewGameSettingPanel:create()
    local newNewGameSettingPanel = NewGameSettingPanel.new()
    newNewGameSettingPanel:loadRequiredResource(PanelConfigFiles.panel_game_setting)
    newNewGameSettingPanel:init()
    return newNewGameSettingPanel
end

function NewGameSettingPanel:popout()
    PopoutQueue.sharedInstance():push(self, true)
    self.allowBackKeyTap = true
end


function NewGameSettingPanel:getPaymentIcon(payment)
    if payment == Payments.UNSUPPORT then return nil end
    local iconName = ''
    if table.exist(PlatformPaymentChinaMobileEnum, payment) then
        iconName = 'china_mobile_pay_icon'
    elseif table.exist(PlatformPaymentChinaUnicomEnum, payment) then
        iconName = 'china_union_pay_icon'
    elseif table.exist(PlatformPaymentChinaTelecomEnum, payment) then
        iconName = 'china_telecom_pay_icon'
    elseif payment == Payments.WDJ then
        iconName = 'wdj_pay_icon'
    elseif payment == Payments.QQ then
        iconName = 'qq_pay_icon'
    elseif payment == Payments.ALIPAY then
        iconName = 'ali_pay_icon'
    elseif payment == Payments.MI then
        iconName = 'mi_pay_icon'
    elseif payment == Payments.QIHOO then
        iconName = '360_pay_icon'
    elseif payment == Payments.WECHAT then
        iconName = 'wechat_pay_icon'
    end
    local icon = self.builder:buildGroup(iconName)
    return icon
end

function NewGameSettingPanel:setPaymentTip(payment)
    local tipString = '' 
    if table.exist(PlatformPaymentChinaMobileEnum, payment) and payment ~= Payments.UNSUPPORT then
        tipString = localize('game.setting.panel.pay.close.tip')
    elseif table.exist(PlatformPaymentChinaUnicomEnum, payment) and payment ~= Payments.UNSUPPORT then
        tipString = localize('game.setting.panel.pay.close.tip')
    elseif table.exist(PlatformPaymentChinaTelecomEnum, payment) and payment ~= Payments.UNSUPPORT then
        tipString = localize('game.setting.panel.pay.close.tip')
    elseif payment == Payments.WDJ then
        tipString = localize('game.setting.panel.pay.wdj.open.tip')
    elseif payment == Payments.QQ then
        tipString = localize('game.setting.panel.pay.tencent.open.tip')
    elseif payment == Payments.ALIPAY then
        tipString = localize('game.setting.panel.pay.alipay.open.tip')
    elseif payment == Payments.MI then
        tipString = localize('game.setting.panel.pay.mi.open.tip')
    elseif payment == Payments.QIHOO then
        tipString = localize('game.setting.panel.pay.360.open.tip')
    elseif payment == Payments.WECHAT then
        tipString = localize('game.setting.panel.pay.wechat.open.tip')
    end

    local tipUI = self.ui:getChildByName('payment_tip')
    tipUI:setString(tipString)
    local arr = CCArray:create()
    arr:addObject(CCShow:create())
    arr:addObject(CCDelayTime:create(3))
    arr:addObject(CCHide:create())
    tipUI:stopAllActions()
    tipUI:runAction(CCSequence:create(arr))

end