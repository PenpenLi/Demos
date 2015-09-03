require 'zoo.panel.IosPayGuidePanels'
require "zoo.payment.PaymentIosDCUtil"

local function addReward(reward)
    for k, v in pairs(reward) do 
        if v.itemId == ItemType.COIN then
            UserManager:getInstance().user:setCoin(UserManager:getInstance().user:getCoin() + v.num)
            UserService:getInstance().user:setCoin(UserService:getInstance().user:getCoin() + v.num)
            if HomeScene:sharedInstance().coinButton then
                HomeScene:sharedInstance():checkDataChange()
                HomeScene:sharedInstance().coinButton:updateView()
            end
        elseif v.itemId == ItemType.GOLD then
            UserManager:getInstance().user:setCash(UserManager:getInstance().user:getCash() + v.num)
            UserService:getInstance().user:setCash(UserService:getInstance().user:getCash() + v.num)
            if HomeScene:sharedInstance().goldButton then
                HomeScene:sharedInstance():checkDataChange()
                HomeScene:sharedInstance().goldButton:updateView()
            end
        else
            UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
            UserService:getInstance():addUserPropNumber(v.itemId, v.num)
        end
    end
end

IosOneYuanShopPanel = class(BasePanel)

function IosOneYuanShopPanel:create(items, cdSeconds, promoEndCallback)
    local instance = IosOneYuanShopPanel.new()
    instance:loadRequiredResource('ui/ios_one_yuan_shop_panel.json')
    instance:init(items, cdSeconds, promoEndCallback)
    return instance
end

function IosOneYuanShopPanel:init(items, cdSeconds, promoEndCallback)
    self.items = items or {}
    local ui = self:buildInterfaceGroup('ios_payguide_panel')
    BasePanel.init(self, ui)
    self.desc = ui:getChildByName('desc')
    self.desc:setString(localize('ios.tuiguang.desc3'))
    self.buyBtn = GroupButtonBase:create(ui:getChildByName('btn'))
    self.guideBtn = ui:getChildByName('guideBtn')
    self.originalPrice = ui:getChildByName('originalPrice')
    self.nowPrice = ui:getChildByName('nowPrice')
    self.animText = ui:getChildByName('animText')
    self.redline = ui:getChildByName('redline')
    self.timeTxt = ui:getChildByName('time')

    self.buyBtn:setEnabled(true)
    self.buyBtn:setString('')
    self.buyBtn:ad(DisplayEvents.kTouchTap, function () self:onBuyBtnTapped() end)

    self.guideBtn:setButtonMode(true)
    self.guideBtn:setTouchEnabled(true, 0, true)
    self.guideBtn:ad(DisplayEvents.kTouchTap, function () self:onGuideBtnTapped() end)

    self.closeBtn = ui:getChildByName('closeBtn')
    self.closeBtn:setTouchEnabled(true,0,true)
    self.closeBtn:ad(DisplayEvents.kTouchTap, function() self:onCloseBtnTapped() end)

    self.promoEndCallback = promoEndCallback

    self:initItems()
    self:skeleton()
    self:startTimer(cdSeconds)

    self.data = IapBuyPropLogic:oneYuanShop()
    self.uniquePayId = PaymentIosDCUtil.getInstance():getNewIosPayID()
    PaymentIosDCUtil.getInstance():sendPayStart(Payments.IOS_RMB, 0, self.uniquePayId, self.data.productIdentifier, 1, 1, 0)
end

function IosOneYuanShopPanel:startTimer(cdSeconds)
    self.cdSeconds = cdSeconds
    if self.schedId then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedId)
        self.schedId = nil
    end
    local function onTick()
        if self.isDisposed then return end
        self.cdSeconds = self.cdSeconds - 1
        if self.cdSeconds >= 0 then
            self.timeTxt:setString('倒计时：'..convertSecondToHHMMSSFormat(self.cdSeconds))
        else
            if self.schedId then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedId)
                self.schedId = nil
            end
            self.buyBtn:setEnabled(false)
            if self.promoEndCallback then
                self.promoEndCallback()
            end
        end
    end
    self.schedId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onTick, 1, false)
    onTick()
end

function IosOneYuanShopPanel:skeleton()
    -- FrameLoader:loadArmature("activity/IOSPayGuide/animation")
    local armature = ArmatureNode:create('ios_huanxiong/iosPay_huanxiong')
    local ph = self.ui:getChildByName('skeleton')
    ph:setVisible(false)
    armature:setPositionX(ph:getPositionX())
    armature:setPositionY(ph:getPositionY())
    ph:getParent():addChildAt(armature, ph:getZOrder())
    armature:playByIndex(0)
end

function IosOneYuanShopPanel:initItems()
    local ph1 = self.ui:getChildByName('item1')
    local ph2 = self.ui:getChildByName('item2')
    local num1 = self.ui:getChildByName('num1')
    local num2 = self.ui:getChildByName('num2')
    local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
    local icon1 = iconBuilder:buildGroup('Prop_'..self.items[1].itemId)
    local icon2 = iconBuilder:buildGroup('Prop_'..self.items[2].itemId)
    ph1:setVisible(false)
    ph1:getParent():addChildAt(icon1, ph1:getZOrder())
    icon1:setPositionX(ph1:getPositionX())
    icon1:setPositionY(ph1:getPositionY())
    icon1:setScale(ph1:getContentSize().width * ph1:getScaleX() / icon1:getGroupBounds().size.width)
    num1:setText('x'..self.items[1].num)

    ph2:setVisible(false)
    ph2:getParent():addChildAt(icon2, ph2:getZOrder())
    icon2:setPositionX(ph2:getPositionX())
    icon2:setPositionY(ph2:getPositionY())
    icon2:setScale(ph2:getContentSize().width * ph2:getScaleX() / icon2:getGroupBounds().size.width)
    num2:setText('x'..self.items[2].num)

    self.icon1 = icon1
    self.icon2 = icon2
end

function IosOneYuanShopPanel:playEntryAnimation(playAnim)
    self:playPriceAnimation(playAnim)
    CCUserDefault:sharedUserDefault():setBoolForKey('ios.pay.guide.activity.anim.played', true)
end

function IosOneYuanShopPanel:playPriceAnimation(playAnim)
    local deltaX = -285 --从素材抄的
    local deltaY = 15
    if not playAnim  then
        self.animText:setPositionX(self.animText:getPositionX() + deltaX)
        self.animText:setPositionY(self.animText:getPositionY() + deltaY)
        self.redline:setPositionX(self.redline:getPositionX() + deltaX)
        self.redline:setPositionY(self.redline:getPositionY() + deltaY)
        self.originalPrice:setVisible(false)
        return 
    end
    self.nowPrice:setVisible(false)
    self.animText:setVisible(false)
    self.redline:setVisible(false)
    self.redline:setScaleX(0)
    local arr1 = CCArray:create()
    arr1:addObject(CCDelayTime:create(1)) -- 等
    arr1:addObject(CCShow:create())
    arr1:addObject(CCScaleTo:create(0.5, 1, 1)) -- 拉长
    arr1:addObject(CCEaseSineOut:create(CCMoveBy:create(0.5, ccp(deltaX, deltaY)))) -- 飞
    self.redline:runAction(CCSequence:create(arr1))
    local arr2 = CCArray:create()
    arr2:addObject(CCDelayTime:create(1.5))
    arr2:addObject(CCHide:create())
    self.originalPrice:runAction(CCSequence:create(arr2))
    local arr3 = CCArray:create()
    arr3:addObject(CCDelayTime:create(1.5))
    arr3:addObject(CCShow:create())
    arr3:addObject(CCEaseSineOut:create(CCMoveBy:create(0.5, ccp(deltaX, deltaY)))) -- 飞
    self.animText:runAction(CCSequence:create(arr3))
    local arr4 = CCArray:create()
    arr4:addObject(CCDelayTime:create(1.5)) -- 等
    arr4:addObject(CCShow:create())
    self.nowPrice:runAction(CCSequence:create(arr4))
end

function IosOneYuanShopPanel:onBuyBtnTapped()
    self.buyBtn:setEnabled(false)
    local function onSuccess()
        print('onBuyBtnTapped success')
        if self.isDisposed then return end
        self.buyBtn:setEnabled(false)
        self.buyBtn:setString('已购买')
        self.nowPrice:setVisible(false)
        self:playRewardAnim(self.items)
        -- addReward(self.items)
        if self.promoEndCallback then
            self.promoEndCallback()
        end
    end
    local function onFail()
        print('onBuyBtnTapped fail')
        if self.isDisposed then return end
        self.buyBtn:setEnabled(true)
        CommonTip:showTip(localize('buy.gold.panel.err.undefined'))
    end

    local peDispatcher = PaymentEventDispatcher.new()
    local function successDcFunc(evt)
        self.paySuccess = true
        PaymentIosDCUtil.getInstance():sendPayEnd(Payments.IOS_RMB, Payments.IOS_RMB, self.uniquePayId, self.data.productIdentifier, 1, 1, 0, self.data.iapPrice, 0, 0)
    end
    local function failedDcFunc(evt)
        self.failBeforePayEnd = true
        PaymentIosDCUtil.getInstance():sendPayEnd(Payments.IOS_RMB, Payments.IOS_RMB, self.uniquePayId, self.data.productIdentifier, 1, 1, 0, self.data.iapPrice, 0, 1)
    end
    peDispatcher:addEventListener(PaymentEvents.kIosBuySuccess, successDcFunc)
    peDispatcher:addEventListener(PaymentEvents.kIosBuyFailed, failedDcFunc)

    IapBuyPropLogic:buy(self.data, onSuccess, onFail, peDispatcher)
end

function IosOneYuanShopPanel:onGuideBtnTapped()
    self:removeSelf()
    IosPayCartoonPanel:create():popout()
end

function IosOneYuanShopPanel:removeSelf()
    if not self.paySuccess then 
        local endResult = 3
        if self.failBeforePayEnd then 
            endResult = 4
        end
        PaymentIosDCUtil.getInstance():sendPayEnd(Payments.IOS_RMB, Payments.IOS_RMB, self.uniquePayId, self.data.productIdentifier, 1, 1, 0, self.data.iapPrice, 0, endResult)
    end
    self.allowBackKeyTap = false
    PopoutManager:sharedInstance():removeWithBgFadeOut(self, false)
end

function IosOneYuanShopPanel:onCloseBtnTapped()
    self:removeSelf()
end

function IosOneYuanShopPanel:popout()
    PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
    self:setToScreenCenter()
    self.allowBackKeyTap = true
    self:playEntryAnimation(not CCUserDefault:sharedUserDefault():getBoolForKey('ios.pay.guide.activity.anim.played', false))
end

function IosOneYuanShopPanel:playRewardAnim(rewards)
    local scene = Director:sharedDirector():getRunningScene()
    if not scene then return end
    HomeScene:sharedInstance():checkDataChange()
    for k, v in ipairs(rewards) do
        if v.itemId == 2 then
            local config = {updateButton = true,}
            local anim = HomeSceneFlyToAnimation:sharedInstance():coinStackAnimation(config)
            local position = self['icon'..k]:getPosition()
            local wPosition = self['icon'..k]:getParent():convertToWorldSpace(ccp(position.x, position.y))
            anim.sprites:setPosition(ccp(wPosition.x + 100, wPosition.y - 90))
            scene:addChild(anim.sprites)
            anim:play()
        elseif v.itemId == 14 then
            local num = v.num
            if num > 10 then num = 10 end
            local config = {number = num, updateButton = true,}
            local anim = HomeSceneFlyToAnimation:sharedInstance():goldFlyToAnimation(config)
            local position = self['icon'..k]:getPosition()
            local size = self['icon'..k]:getGroupBounds().size
            local wPosition = self['icon'..k]:getParent():convertToWorldSpace(ccp(position.x + size.width / 4, position.y - size.height / 4))
            for k, v2 in ipairs(anim.sprites) do
                v2:setPosition(ccp(wPosition.x, wPosition.y))
                v2:setScaleX(self['icon'..k]:getScaleX())
                v2:setScaleY(self['icon'..k]:getScaleY())
                scene:addChild(v2)
            end
            anim:play()
        else
            local num = v.num
            if num > 10 then num = 10 end
            local config = {propId = v.itemId, number = num, updateButton = true,}
            local anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
            local position = self['icon'..k]:getPosition()
            local size = self['icon'..k]:getGroupBounds().size
            local wPosition = self['icon'..k]:getParent():convertToWorldSpace(ccp(position.x, position.y))
            for k, v2 in ipairs(anim.sprites) do
                v2:setPosition(ccp(wPosition.x, wPosition.y))
                v2:setScaleX(self['icon'..k]:getScaleX())
                v2:setScaleY(self['icon'..k]:getScaleY())
                scene:addChild(v2)
            end
            anim:play()
        end
    end
end
