PriorityPaymentGuidePanel = class(BasePanel)

function PriorityPaymentGuidePanel:create(payment)
    local panel = PriorityPaymentGuidePanel.new()
    panel:loadRequiredResource(PanelConfigFiles.third_pay_show_priority_panel)
    panel:init(payment)
    return panel
end

function PriorityPaymentGuidePanel:init(payment)
    local ui = self:buildInterfaceGroup('third_pay_priority_payment_panel')
    BasePanel.init(self, ui)

    self.payment = payment

    local closeBtn = self.ui:getChildByName('closeBtn')
    closeBtn:setVisible(false)
    -- closeBtn:setButtonMode(true)
    -- closeBtn:setTouchEnabled(true, 0, true)
    -- closeBtn:ad(DisplayEvents.kTouchTap, function () self:onCloseBtnTapped(true) end)

    local btn = GroupButtonBase:create(self.ui:getChildByName('btn'))
    btn:setString('确定')
    btn:setEnabled(true)
    btn:ad(DisplayEvents.kTouchTap, function () self:onBtnTapped() end)

    local gotoSettingBtn = self.ui:getChildByName('gotoSettingBtn')
    gotoSettingBtn:setButtonMode(true)
    gotoSettingBtn:setTouchEnabled(true, 0, true)
    gotoSettingBtn:ad(DisplayEvents.kTouchTap, function () self:onGotoSettingBtnTapped() end)

    self.ui:getChildByName('desc'):setString(localize('pay.way.panel.text'))

    self:initPayment()
end

function PriorityPaymentGuidePanel:onBtnTapped()
    DcUtil:UserTrack({category = "set", sub_category = "buy_way_setting_pop", click = 0})
    self:removeSelf()
end

function PriorityPaymentGuidePanel:onGotoSettingBtnTapped()
    DcUtil:UserTrack({category = "set", sub_category = "buy_way_setting_pop", click = 1})
    self:removeSelf()
    NewGameSettingPanel:create():popout()
end

function PriorityPaymentGuidePanel:popoutShowTransition()
    self:setToScreenCenterVertical()
end

function PriorityPaymentGuidePanel:popout()
    self.allowBackKeyTap = true
    PopoutQueue.sharedInstance():push(self, false)
    self:setPositionY(self:getPositionY() + 130)
    self:runAction(CCEaseElasticOut:create(CCMoveBy:create(0.8, ccp(0, -130))))
end

function PriorityPaymentGuidePanel:removeSelf()
    self.allowBackKeyTap = false
    PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)
end

function PriorityPaymentGuidePanel:onCloseBtnTapped()
    DcUtil:UserTrack({category = "set", sub_category = "buy_way_setting_pop", click = 2})
    self:removeSelf()
end

function PriorityPaymentGuidePanel:initPayment()
    local iconName = ''
    local paymentName = ''
    if table.exist(PlatformPaymentChinaMobileEnum, self.payment) and self.payment ~= Payments.UNSUPPORT then
        iconName = 'china_mobile_pay_icon'
        paymentName = '中国移动'
    elseif table.exist(PlatformPaymentChinaUnicomEnum, self.payment) and self.payment ~= Payments.UNSUPPORT then
        iconName = 'china_union_pay_icon'
        paymentName = '中国联通'
    elseif table.exist(PlatformPaymentChinaTelecomEnum, self.payment) and self.payment ~= Payments.UNSUPPORT then
        iconName = 'china_telecom_pay_icon'
        paymentName = '中国电信'
    elseif self.payment == Payments.WDJ then
        iconName = 'wdj_pay_icon'
        paymentName = '豌豆荚支付'
    elseif self.payment == Payments.QQ then
        iconName = 'qq_pay_icon'
        paymentName = '腾讯支付'
    elseif self.payment == Payments.ALIPAY then
        iconName = 'ali_pay_icon'
        paymentName = '支付宝支付'
    elseif self.payment == Payments.MI then
        iconName = 'mi_pay_icon'
        paymentName = '小米支付'
    elseif self.payment == Payments.QIHOO then
        iconName = '360_pay_icon'
        paymentName = '360支付'
    elseif self.payment == Payments.WECHAT then
        iconName = 'wechat_pay_icon'
        paymentName = '微信支付'
    else
        assert(false, 'PriorityPaymentGuidePanel:initPayment'..tostring(self.payment))
        return
    end

    print(iconName)
    local icon = self.builder:buildGroup(iconName)
    
    local ph = self.ui:getChildByName('ph')
    ph:setVisible(false)
    ph:getParent():addChildAt(icon, ph:getZOrder())
    icon:setPositionX(ph:getPositionX())
    icon:setPositionY(ph:getPositionY())
    icon:setScale(ph:getContentSize().width*ph:getScaleX()/icon:getGroupBounds().size.width)

    self.ui:getChildByName('payname'):setString(paymentName)

end