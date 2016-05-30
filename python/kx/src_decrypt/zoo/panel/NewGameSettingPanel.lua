require 'zoo.panel.component.common.HorizontalTileLayout'
require "zoo.baseUI.ButtonWithShadow"
require 'zoo.util.OpenUrlUtil'
require 'zoo.payment.WechatQuickPayLogic'
require 'zoo.panelBusLogic.AliQuickPayPromoLogic'

local AliUnsignConfirmPanel = require "zoo.panel.alipay.AliUnsignConfirmPanel"
local AliPaymentSignAccountPanel = require "zoo.panel.alipay.AliPaymentSignAccountPanel"

NewGameSettingPanel = class(BasePanel)

function NewGameSettingPanel:create(source)
    local newNewGameSettingPanel = NewGameSettingPanel.new()
    newNewGameSettingPanel:loadRequiredResource(PanelConfigFiles.panel_game_setting)
    newNewGameSettingPanel:init(source)
    return newNewGameSettingPanel
end

function NewGameSettingPanel:init(source)
    self.source = source

    self.ui = self:buildInterfaceGroup("newGameSettingPanel")

    BasePanel.init(self, self.ui)

    self.onClosePanelBtnTappedCallback  = false

    self.panelChildren = {}
    self.ui:getVisibleChildrenList(self.panelChildren)
    self.basicSettingModule = self.ui:getChildByName('basicSettingModule')
    self.musicBtn       = self.basicSettingModule:getChildByName("musicBtn")
    self.soundBtn       = self.basicSettingModule:getChildByName("soundBtn")
    self.notificationBtn        = self.basicSettingModule:getChildByName("notificationBtn")

    self.musicPauseIcon = self.basicSettingModule:getChildByName("musicPauseIcon")
    self.soundPauseIcon = self.basicSettingModule:getChildByName("soundPauseIcon")
    self.notificationPauseIcon  = self.basicSettingModule:getChildByName("notificationPauseIcon")

    self.musicBtnTip    = self.basicSettingModule:getChildByName("musicBtnTip")
    self.soundBtnTip    = self.basicSettingModule:getChildByName("soundBtnTip")
    self.notificationBtnTip = self.basicSettingModule:getChildByName("notificationBtnTip")

    self.tips   = {self.soundBtnTip, self.musicBtnTip, self.notificationBtnTip}

    self.windmillBtn = self.ui:getChildByName('windmillBtn')
    self.windmillBtn:ad(DisplayEvents.kTouchTap, function () self:onWindmillBtnTapped() end)

    self.prepackageNetworkBtn = self.ui:getChildByName('prepackageNetworkBtn')
    self.prepackageNetworkBtn:setVisible(false)

    self.panelTitle     = self.ui:getChildByName("panelTitle")
    self.closeBtn       = self.ui:getChildByName("closeBtn")

    self.panelTitle:setText(Localization:getInstance():getText("quit.panel.tittle"))
    self.bg = self.ui:getChildByName("_newBg")
    
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

    if __IOS or __WP8  or __WIN32 then -- WP8怎么初始化，待定。。。
        self:initIOS()
    elseif __ANDROID then
        self:initAndroid()
    end
end

function NewGameSettingPanel:hidePaymentIcons()
    local pay_text = self.ui:getChildByName('pay_text')
    local ph = self.ui:getChildByName('ph')
    pay_text:removeFromParentAndCleanup(true)
    ph:removeFromParentAndCleanup(true)

    for i=1,2 do
        local line = self.ui:getChildByName("line"..i)
        line:removeFromParentAndCleanup(true)
    end

    local _newBg2 = self.ui:getChildByName('_newBg2')
    _newBg2:setPreferredSize(CCSizeMake(595,195))
    local _newBg = self.ui:getChildByName('_newBg')
    _newBg:setPreferredSize(CCSizeMake(642,320))
end

function NewGameSettingPanel:initIOS()
    self:hidePaymentIcons()
    if self:shouldShowWindmillBtn() then
        self:showWindmillBtn()
    else
        self:hideWindmillBtn()
    end
end

function NewGameSettingPanel:shouldShowWindmillBtn()
    local isEnabled = MaintenanceManager:getInstance():isEnabled("IosSettingUrl")
    local hasNetwork = RequireNetworkAlert:popout(nil, 2)
    -- print('isEnabled', isEnabled, 'hasNetwork', hasNetwork)
    return isEnabled and hasNetwork
end

function NewGameSettingPanel:hideWindmillBtn()
    self.basicSettingModule:setPositionX(113)
    self.windmillBtn:setVisible(false)
    self.windmillBtn:setTouchEnabled(false)
end

function NewGameSettingPanel:showWindmillBtn()
    self.basicSettingModule:setPositionX(55)
    self.windmillBtn:setVisible(true)
    self.windmillBtn:setTouchEnabled(true)
end

local function isAliPayment(payment)
    return payment == Payments.ALIPAY or payment == Payments.ALI_QUICK_PAY
end

function NewGameSettingPanel:initAndroid()
    self:hideWindmillBtn()
    if PrepackageUtil:isPreNoNetWork() then
        self.basicSettingModule:setPositionX(55)
        self.prepackageNetworkBtn:setVisible(true)
        self.prepackageNetworkBtn:setTouchEnabled(true, 0, true)
        self.prepackageNetworkBtn:ad(DisplayEvents.kTouchTap, function () self:onPrepackageNetworkBtnTapped() end)
    end
    print('PlatformConfig ', table.tostring(PlatformConfig.paymentConfig))
    local payments = {}
    for k, v in pairs(PlatformConfig.paymentConfig.thirdPartyPayment) do
        if v ~= Payments.UNSUPPORT then
            table.insert(payments, v)
        end
    end
        

    local defaultSms = PaymentManager:getInstance():getDefaultSmsPayment()
    if defaultSms and defaultSms ~= Payments.UNSUPPORT then
        --if PaymentManager.getInstance():checkSmsPayEnabled() then 
            table.insert(payments, defaultSms)
        --end
    end

    print('payments: ', table.tostring(payments))

    local ph = self.ui:getChildByName('ph')
    local pay_text = self.ui:getChildByName('pay_text')
    local pos, width, height = nil, nil, 85
    local layoutY = ph:getPositionY()
    local textY = pay_text:getPositionY()
    local iconCount = #payments
    if iconCount == 0 then
        self:hidePaymentIcons()
        return
    end

    ph:setVisible(false)
    pos = ccp(ph:getPositionX(), ph:getPositionY())
    local phSize = ph:getGroupBounds().size
    local layout = VerticalTileLayout:create(phSize.width)
    self.layout = layout

    local function buildItem(payment)
        local icon, icon_height = self:getPaymentIcon(payment)
        if not icon then return nil end
        icon:setScale(height/icon_height)
        local itemName = 'normal_pay_setting_item'
        if payment == Payments.ALIPAY or (payment == Payments.WECHAT and _G.wxmmGlobalEnabled and WechatQuickPayLogic:getInstance():isMaintenanceEnabled()) then
            itemName = 'quick_pay_setting_item'
        end
        local item = self.builder:buildGroup(itemName)
        local itemHeight = item:getGroupBounds().size.height
        local ph = item:getChildByName('ph')
        ph:setVisible(false)
        ph:getParent():addChild(icon)
        icon:setPositionX(ph:getPositionX())
        icon:setPositionY(ph:getPositionY())
        item:setTouchEnabled(true, 0, true)

        if payment == Payments.ALIPAY then
            item:getChildByName('bigText'):setString(localize('panel.choosepayment.alipay'))
            item:getChildByName('text'):setString(localize('wechat.kf.set.ali.mm'))
        elseif payment == Payments.WECHAT then
            if _G.wxmmGlobalEnabled and WechatQuickPayLogic:getInstance():isMaintenanceEnabled() then
                item:getChildByName('bigText'):setString(localize('wechat.kf.pay2.wc'))
                item:getChildByName('text'):setString(localize('wechat.kf.set.wc.mm'))
            else
                item:getChildByName('text'):setString(localize('wechat.kf.pay2.wc'))
            end
        else
            local config = PaymentManager:getPaymentShowConfig(payment)
            item:getChildByName('text'):setString(config.name or '')
        end
        return item, itemHeight
    end

    local currentDefaultPayment = PaymentManager:getInstance():getDefaultPayment()
    print('currentDefaultPayment', currentDefaultPayment)

    if not table.includes(payments, currentDefaultPayment) then
        currentDefaultPayment = PaymentManager:getInstance():getDefaultPayment(true)
    end


    -- 微信第一，支付宝第二，三方其次，短代最后
    local function sortPayments(payments)
        local wechat = nil
        local ali = nil
        local third = {}
        local others = {}
        for k, v in pairs(payments) do
            if v == Payments.WECHAT then
                wechat = Payments.WECHAT
            elseif v == Payments.ALIPAY then
                ali = Payments.ALIPAY
            elseif table.exist(PlatformPaymentThirdPartyEnum, v) then
                table.insert(third, v)
            else
                table.insert(others, v)
            end
        end
        table.sort(third, function (v1, v2) return v1 < v2 end)
        table.sort(others, function (v1, v2) return v1 < v2 end)
        local ret = {}
        if wechat then
            table.insert(ret, wechat)
        end
        if ali then
            table.insert(ret, ali)
        end
        for k, v in pairs(third) do
            table.insert(ret, v)
        end
        for k, v in pairs(others) do
            table.insert(ret, v)
        end
        return ret
    end
    payments = sortPayments(payments)

    self.paymentIcons = {}
    for k, v in pairs(payments) do
        local item, item_height = buildItem(v)
        self.item_height = item_height
        if item then
            local wrapper = ItemInLayout:create()
            wrapper:setContent(item)
            wrapper:setHeight(item_height)
            item:ad(DisplayEvents.kTouchTap, function () self:onPaymentIconTapped(v) end)
            if v == Payments.ALIPAY 
            or (v == Payments.WECHAT and _G.wxmmGlobalEnabled and WechatQuickPayLogic:getInstance():isMaintenanceEnabled()) then
                local check_box = item:getChildByName('check_box')
                check_box:setTouchEnabled(true, 0, true)
                check_box:ad(DisplayEvents.kTouchTap, function () self:onQuickPaySwitchTapped(v) end)
            end
            layout:addItem(wrapper)
            self.paymentIcons[v] = wrapper
        end
    end

    self.ui:addChildAt(layout, ph:getZOrder())
    layout:setPosition(pos)
    print("layout position: ", layout:getPositionY(), layout:getPositionX())

    local layoutHeight = layout:getHeight()
    local _newBg2 = self.ui:getChildByName('_newBg2')
    _newBg2:setPreferredSize(CCSizeMake(595,_newBg2:getPreferredSize().height + layoutHeight))
    local _newBg = self.ui:getChildByName('_newBg')
    _newBg:setPreferredSize(CCSizeMake(642,_newBg:getPreferredSize().height + layoutHeight))
    --pay_text:setString(localize('game.setting.panel.pay.tip')..':')
    local payment = PaymentManager:getInstance():getDefaultPayment()
    self:setPaymentTip(payment)

    self:setQuickPayCheckBox(Payments.ALIPAY, UserManager.getInstance():isAliSigned())
    if _G.wxmmGlobalEnabled and WechatQuickPayLogic:getInstance():isMaintenanceEnabled() then
        self:setQuickPayCheckBox(Payments.WECHAT, UserManager.getInstance():isWechatSigned())
    end

    self:onPaymentIconTapped(currentDefaultPayment, true)
    self.previousPayment = currentDefaultPayment --打点数据 
end

function NewGameSettingPanel:onQuickPaySwitchTapped(payment)
    if payment == nil or payment == Payments.UNSUPPORT then return end
    local wrapper = self.paymentIcons[payment]
    if not wrapper then print('onPaymentIconTapped ERROR ', payment) return end

    if payment == Payments.ALIPAY then
        if UserManager.getInstance():isAliSigned() then
            local panel = AliUnsignConfirmPanel:create()
            panel:popout(function() 
                    if self.isDisposed then return end
                    self:setQuickPayCheckBox(Payments.ALIPAY, false)
                end)
        else
            local panel = AliPaymentSignAccountPanel:create(AliQuickSignEntranceEnum.NEW_GAME_SETTINGS_PANEL)
            panel:popout(nil, function() 
                    if self.isDisposed then return end
                    self:setQuickPayCheckBox(Payments.ALIPAY, true)
                end)
        end
    elseif payment == Payments.WECHAT then
        
        if UserManager.getInstance():isWechatSigned() then
            local WechatUnsignConfirmPanel = require 'zoo.panel.wechatPay.WechatUnsignConfirmPanel'
            local panel = WechatUnsignConfirmPanel:create()
            panel:popout(function() 
                    if self.isDisposed then return end
                    self:setQuickPayCheckBox(Payments.WECHAT, false)
                end)
        else
            local function onSuccess()
                CommonTip:showTip(localize('wechat.kf.sign.ok'), 'positive', nil, 3, false)
                if self.isDisposed then return end
                self:setQuickPayCheckBox(Payments.WECHAT, true)
            end
            local function onFail(error_code)
                if error_code == -1002 then
                    CommonTip:showTip(localize('wechat.kf.sign.fail.title')..'\n'..localize('wechat.kf.sign.fail.1'), 'negative', nil, 3)
                elseif error_code then
                    CommonTip:showTip(localize('wechat.kf.sign.fail.title')..'\n'..localize('error.tip.'..error_code), 'negative', nil, 3)
                else
                    CommonTip:showTip(localize('wechat.kf.sign.fail.title')..'\n'..localize('wechat.kf.sign.fail.2'), 'negative', nil, 3)
                end
                if self.isDisposed then return end
                self:setQuickPayCheckBox(Payments.WECHAT, false)
            end
            WechatQuickPayLogic:getInstance():sign(onSuccess, onFail, 3)
        end
    end
end

function NewGameSettingPanel:setQuickPayCheckBox(payment, value)
    if payment == nil or payment == Payments.UNSUPPORT then return end
    local wrapper = self.paymentIcons[payment]
    if not wrapper then print('onPaymentIconTapped ERROR ', payment) return end

    local check_icon = wrapper:getContent():getChildByName('check_box'):getChildByName('icon')
    check_icon:setVisible(value)
end

function NewGameSettingPanel:onPaymentIconTapped(payment, isInit)
    if payment == nil or payment == Payments.UNSUPPORT then return end
    local wrapper = self.paymentIcons[payment]
    if not wrapper then print('onPaymentIconTapped ERROR ', payment) return end

    print("selected payment: ", payment)

    for k, v in pairs(self.paymentIcons) do
        local isTapped = (v == wrapper)
        print('isTapped', isTapped)
        local ui = v:getContent()
        ui:getChildByName('bg_disabled'):setVisible(not isTapped)
        ui:getChildByName('bg_enabled'):setVisible(isTapped)
    end

    if not isInit then
        self:setPaymentTip(payment)
        self:setPriorityPayment(payment)
    end
end

function NewGameSettingPanel:setPriorityPayment(payment)
    self.manualSetPayment = true
    -- 如果是移动短代，就要判断具体是哪一种
    if table.exist(PlatformPaymentChinaMobileEnum, payment) then
        payment = PaymentManager:getInstance():getDefaultSmsPayment()
        print('setPriorityPayment sms ', payment)
    end

    if payment ~= Payments.UNSUPPORT and payment ~= nil then
        -- 设置真实的默认支付
        PaymentManager:getInstance():setDefaultPayment(payment)
    end

    print('setPriorityPayment', PaymentManager:getInstance():getDefaultPayment())
end

function NewGameSettingPanel:onMusicBtnTapped()    
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
    if __ANDROID and self.manualSetPayment then
        PaymentDCUtil.getInstance():sendDefaultPaymentChange(self.source, self.previousPayment, PaymentManager:getInstance():getDefaultPayment(), 0)
    end
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

function NewGameSettingPanel:onWindmillBtnTapped()
    if self:shouldShowWindmillBtn() then
        local url = UserManager:getInstance().iosSettingUrl
        if url ~= nil and #url > 0 then
            OpenUrlUtil:openUrl(url)
        end
    else
        return
    end
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
    elseif payment == Payments.WO3PAY then
        iconName = 'cuccwo_pay_icon'
    elseif payment == Payments.TELECOM3PAY then
        iconName = 'cuccwo_pay_icon'
    elseif payment == Payments.HUAWEI then
        iconName = 'huawei_pay_icon'
    elseif payment == Payments.QQ_WALLET then
        iconName = 'qqwallet_pay_icon'
    end
    local icon = self.builder:buildGroup(iconName)

    if table.keyOf(PlatformPaymentThirdPartyEnum, payment)
        and payment ~= Payments.WO3PAY 
        and payment ~= Payments.TELECOM3PAY then

        local size = icon:getGroupBounds().size
        local cut5 = self.builder:buildGroup("5cut")
        cut5:setPosition(ccp(size.width - 39, size.height - 38))
        cut5:setScale(0.75)
        icon:addChild(cut5)
        return icon, size.height
    end

    return icon, icon:getGroupBounds().size.height
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
    elseif payment == Payments.HUAWEI then
        tipString = localize('game.setting.panel.pay.huawei.open.tip')
    elseif payment == Payments.QQ_WALLET then
        tipString = localize('game.setting.panel.pay.qqwallet.open.tip')
    else
        tipString = "优先使用短信支付"
    end

    local pay_text = self.ui:getChildByName('pay_text')
    pay_text:setString(tipString)
end

function NewGameSettingPanel:onPrepackageNetworkBtnTapped()
    print('NewGameSettingPanel:onPrepackageNetworkBtnTapped')
    PrepackageUtil:showSettingNetWorkDialog()
end