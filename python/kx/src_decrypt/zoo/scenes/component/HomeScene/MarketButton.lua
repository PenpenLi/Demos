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