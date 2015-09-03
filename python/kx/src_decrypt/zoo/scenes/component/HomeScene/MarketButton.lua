require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

MarketButton = class(IconButtonBase)

function MarketButton:init(...)
    assert(#{...} == 0)

    self.ui = ResourceManager:sharedInstance():buildGroup('marketButtonIcon')

    IconButtonBase.init(self, self.ui)

    self.ui:setTouchEnabled(true)
    self.ui:setButtonMode(true)

    self.discount = self.ui:getChildByName('discount')
    self.new = self.ui:getChildByName('new')

    self.discount:setVisible(false)
    self.discount:setAnchorPoint(ccp(0.5, 0.5))
    self.new:setVisible(false)
    self.new:setAnchorPoint(ccp(0.5, 0.5))
    self.thirdPayPromo = self.ui:getChildByName('thirdpay_promo')
    self.thirdPayPromo:setAnchorPointCenterWhileStayOrigianlPosition()
    self.thirdPayPromo:setVisible(false)

end


function MarketButton:create(...)
    local instance = MarketButton.new()
    assert(instance)
    if instance then instance:init() end
    return instance
end

function MarketButton:showNew(isShow)
    if self.isDisposed then return end
    self.new:setVisible(isShow)
    if isShow  then
        self.new:runAction(self:buildAnimation())
    else
        self.new:stopAllActions()
    end
end

function MarketButton:showDiscount(isShow)
    if self.isDisposed then return end
    self.discount:setVisible(isShow)
    if isShow then
        self.discount:runAction(self:buildAnimation())
    else 
        self.discount:stopAllActions()
    end
end

function MarketButton:buildAnimation()
    local expand1 = CCScaleTo:create(7/24, 1.2)
    local shrink1 = CCScaleTo:create(7/24, 1)
    local expand2 = CCScaleTo:create(7/24, 1.2)
    local shrink2 = CCScaleTo:create(7/24, 1)
    local delay = CCDelayTime:create(90/24)
    local actions = CCArray:create()
    actions:addObject(expand1)
    actions:addObject(shrink1)
    actions:addObject(expand2)
    actions:addObject(shrink2)
    actions:addObject(delay)
    local repeatAction = CCRepeatForever:create(CCSequence:create(actions))
    return repeatAction
end

function MarketButton:playTopTip(tipTxt)
    self.topTip = ResourceManager:sharedInstance():buildGroup("market_btn_tip_homeScene")
    self.topTip:getChildByName('txt'):setString(tipTxt)
    self.ui:addChild(self.topTip)
    self.topTip:setPosition(ccp(0, 105))
    self.topTip:runAction(self:buildAnimation())

end

function MarketButton:stopTopTip()
    if self.topTip then
        self.topTip:removeFromParentAndCleanup(true)
        self.topTip = nil
    end
end

function MarketButton:showThirdPayPromotion(isShow, seconds)
    if self.isDisposed then return end
    if not seconds or seconds <= 0 then
        seconds = 0
    end
    self.thirdPayPromo:setVisible(isShow)
    if isShow then
        self.thirdPayPromo:runAction(self:buildAnimation())
        self:showDiscount(false) --避免冲突
    else
        self.thirdPayPromo:stopAllActions()
    end
    local function timeup()
        if self.isDisposed then return end
        self.thirdPayPromo:stopAllActions()
        self.thirdPayPromo:setVisible(false)
        self:showDiscount(MarketManager:sharedInstance():shouldShowMarketButtonDiscount())
        self:showNew(MarketManager:sharedInstance():shouldShowMarketButtonNew())
        if self.thirdPaySchedId then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.thirdPaySchedId)
        end
    end
    if self.thirdPaySchedId then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.thirdPaySchedId)
    end
    if seconds > 0 then
        self.thirdPaySchedId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(timeup,seconds,false)
    end
end