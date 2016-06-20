local NewChoosePaymentPanel = class(BasePanel)

function NewChoosePaymentPanel:create(paymentsToShow)
    print('NewChoosePaymentPanel:create')
    local panel = NewChoosePaymentPanel.new()
    panel:loadRequiredResource(PanelConfigFiles.choose_payment_panel)
    panel:init(paymentsToShow)

    return panel
end

function NewChoosePaymentPanel:init(paymentsToShow)
    self.ui = self:buildInterfaceGroup('NewChoosePaymentPanel')
    BasePanel.init(self, self.ui)

    self.extend = true

    self.AliSelectedAndExtend = self.ui:getChildByName("aliSelectedExtend_item")
    self.AliNormal = self.ui:getChildByName("aliNormal_item")
    self.wechat_item = self.ui:getChildByName("wechat_item")
    self.panelBG = self.ui:getChildByName("bg1")

    self:initAliPaymentItem()
    self:initWeChatPaymentItem()

    self.closeBtn = self.ui:getChildByName("btnClose")
    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:addEventListener(DisplayEvents.kTouchTap, 
        function() 
            self:onCloseBtnTapped()
            print("btnclose tapped!!!!!!!!!!")
        end)

    --if PaymentManager.getInstance():getDefaultThirdPartPayment() == PlatformPaymentThirdPartyEnum.kWECHAT then
    --    self:layoutForWechatFirstPriority()
    --else
        self:layoutForAlipayFirstPriority()
    --end
end

function NewChoosePaymentPanel:extendItem()
    self.alipaymentBG = self.AliSelectedAndExtend:getChildByName("bg1")
    local size = self.alipaymentBG:getGroupBounds().size
    local panelBGSize = self.panelBG:getGroupBounds().size

    self.wechat_item:setPositionY(self.wechat_item:getPositionY() - 210)

    self.AliSelectedAndExtend:addChild(self.tipLayer)
    self.alipaymentBG:setPreferredSize(CCSizeMake(size.width, 408))
    self.panelBG:setPreferredSize(CCSizeMake(panelBGSize.width, 672))
    self.extend = true

    self:setPositionY(self:getPositionY() + 210/2)
end 

function NewChoosePaymentPanel:foldItem()
    self.alipaymentBG = self.AliSelectedAndExtend:getChildByName("bg1")
    local size = self.alipaymentBG:getGroupBounds().size
    local panelBGSize = self.panelBG:getGroupBounds().size

    self.wechat_item:setPositionY(self.wechat_item:getPositionY() + 210)

    self.tipLayer:removeFromParentAndCleanup(false)
    self.alipaymentBG:setPreferredSize(CCSizeMake(size.width, 198))
    self.panelBG:setPreferredSize(CCSizeMake(panelBGSize.width, 462))
    self.extend = false

    self:setPositionY(self:getPositionY() - 210/2)
end

function NewChoosePaymentPanel:initWeChatPaymentItem()
    self.wechat_item:getChildByName("text"):setString(localize("panel.choosepayment.wechat")) --"微信支付")
    self.wechat_item:setTouchEnabled(true, 0 , true)
    self.wechat_item:ad(DisplayEvents.kTouchTap, function()
            self.selectedPayment = Payments.WECHAT
            self:onCloseBtnTapped()
            print("wechat item tapped!!!!!!!!!!!!!!")
        end)
end

function NewChoosePaymentPanel:initAliPaymentItem()
    self.AliSelectedAndExtend:getChildByName("txtPayment"):setString(localize("panel.choosepayment.alipay"))--"支付宝支付")
    self.AliSelectedAndExtend:getChildByName("txtOpenPayment"):setString(localize("panel.choosepayment.alipay.kuaifu")) --"开通支付宝快付")

    self.tipLayer = self.AliSelectedAndExtend:getChildByName("tip")
    self.tipLayer:getChildByName("tip1"):setString(localize("panel.choosepayment.quest"))--"什么是支付宝快捷支付？")
    self.tipLayer:getChildByName("tip2"):setString(localize("panel.choosepayment.answer.0"))--"开通快捷支付后，每次小额支付时不再需要反复输入密码，方便安全。")
    self.tipLayer:getChildByName("tip3"):setString(localize("panel.choosepayment.answer.1"))-- "1.安全保障，仅限小额支付。")
    self.tipLayer:getChildByName("tip4"):setString(localize("panel.choosepayment.answer.2"))--"2.此操作仅授权给开心消消乐。")

    self.iconHelp = self.AliSelectedAndExtend:getChildByName("iconHelp")
    self.iconHelp:setTouchEnabled(true, 0, true)
    self.iconHelp:setButtonMode(true)
    self.iconHelp:addEventListener(DisplayEvents.kTouchTap, 
        function()
            if self.extend then
                self:foldItem()
                DcUtil:UserTrack({ category='alipay_mianmi_accredit ', sub_category = 'help'})
            else
                self:extendItem()
            end
            print("iconHelp tapped!!!!!!!!!!")
        end)

    self.checkBox = self.AliSelectedAndExtend:getChildByName("checkBox")
    local checkIcon = self.checkBox:getChildByName("icon")
    local AliQuickPayGuide = require "zoo.panel.alipay.AliQuickPayGuide"
    checkIcon:setVisible(false)--AliQuickPayGuide.isGuideTime())

    self.checkBox:setTouchEnabled(true, 0, true)
    self.checkBox:setButtonMode(true)
    self.checkBox:addEventListener(DisplayEvents.kTouchTap, 
        function()
            checkIcon:setVisible(not checkIcon:isVisible())
            print("checkBox tapped!!!!!!!!!!")
        end)
    
    --如果已签约不走防打扰逻辑
    if UserManager.getInstance():isAliSigned() then
        checkIcon:setVisible(false)
        self.iconHelp:setVisible(false)
        self.checkBox:setVisible(false)
        self.AliSelectedAndExtend:getChildByName("txtOpenPayment"):setString(localize("alipay.pay.kf.confirm"))
    end

    self.aliTouchArea = self.AliSelectedAndExtend:getChildByName("bg2")
    self.aliTouchArea:setTouchEnabled(true, 0, true)
    self.aliTouchArea:ad(DisplayEvents.kTouchTap, function() 
                print("alipayment touched!!!!!!!!!!!!!!")
                if checkIcon:isVisible() then
                    self.selectedPayment = Payments.ALI_QUICK_PAY
                else
                    self.selectedPayment = Payments.ALIPAY

                    local AliQuickPayGuide = require "zoo.panel.alipay.AliQuickPayGuide"
                    if AliQuickPayGuide.isGuideTime() then
                        AliQuickPayGuide.updateGuideTimeAndPopCount()
                    else
                        AliQuickPayGuide.updateOnlyGuideTime()
                    end
                end

                self:onCloseBtnTapped()
        end)
end

function NewChoosePaymentPanel:layoutForWechatFirstPriority()
    self.wechat_item:setPositionY(self.AliSelectedAndExtend:getPositionY())
    self.AliNormal:setPositionY(self.AliNormal:getPositionY() + 210)
    self.AliSelectedAndExtend:removeFromParentAndCleanup(true)

    local panelBGSize = self.panelBG:getGroupBounds().size
    self.panelBG:setPreferredSize(CCSizeMake(panelBGSize.width, 462))
end

function NewChoosePaymentPanel:layoutForAlipayFirstPriority()
     self.AliNormal:removeFromParentAndCleanup(true)
     self:foldItem()
end

function NewChoosePaymentPanel:popout(onCloseCallback)
    self:setPositionForPopoutManager()
    self.doneCallback = onCloseCallback

    PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
    self.allowBackKeyTap = true
end

function NewChoosePaymentPanel:onCloseBtnTapped()
    if self.doneCallback then self.doneCallback(self.selectedPayment) end

    PopoutManager:sharedInstance():removeWithBgFadeOut(self, false)
    self.allowBackKeyTap = false
end

return NewChoosePaymentPanel