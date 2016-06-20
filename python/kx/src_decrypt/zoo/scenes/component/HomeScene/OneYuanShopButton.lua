require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"


OneYuanShopButton = class(IconButtonBase)

function OneYuanShopButton:create(time, proType)
    local instance = OneYuanShopButton.new()
    instance:init(time, proType)
    return instance
end

function OneYuanShopButton:init(time, proType)
    self.ui = ResourceManager:sharedInstance():buildGroup('ios_payguide_btn')
    local wrapperUI = self.ui:getChildByName("wrapper")
    local icon = wrapperUI:getChildByName("icon")
    local iconAlpha = wrapperUI:getChildByName("icon_alpha")
    if __IOS then 
        if proType and proType == IosOneYuanPromotionType.OneYuanAlphaProp then 
            icon:setVisible(false)
        else
            iconAlpha:setVisible(false)
        end
    elseif __ANDROID then 
        icon:setVisible(false)
    end
    IconButtonBase.init(self, self.ui)
    self.ui:setTouchEnabled(true)
    self.ui:setButtonMode(true)
    self.timeTxt = self.wrapper:getChildByName('time')
    self.timeTxt:setPreferredSize(120, 80)
    self.timeTxt:setString('00:00:00')
    self.timeTxt:setPositionX(self.timeTxt:getPositionX() - 18)
    self.timeTxt:setPositionY(self.timeTxt:getPositionY() + 6)

    self:setCdTime()
end

function OneYuanShopButton:stopTimer()
    if self.schedId then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedId)
        self.schedId = nil
    end
end

function OneYuanShopButton:setCdTime()
    self:stopTimer()
    if __IOS then 
        self.cdTime = IosPayGuide:getOneYuanShopLeftSeconds() or 0
    elseif __ANDROID then 
        self.cdTime = AndroidSalesManager.getInstance():getItemSalesLeftSeconds() or 0
    end
    local function onTick()
        if self.cdTime <= 0 then return end
        if self.isDisposed then return end
        if __IOS then 
            self.cdTime = IosPayGuide:getOneYuanShopLeftSeconds() or 0
        elseif __ANDROID then 
            self.cdTime = AndroidSalesManager.getInstance():getItemSalesLeftSeconds() or 0
        end
        if self.cdTime >= 0 then
            self.timeTxt:setString(convertSecondToHHMMSSFormat(self.cdTime))
        else
            self:stopTimer()
        end
    end
    if self.cdTime > 0 then
        self.schedId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onTick, 1, false)
    end
    onTick()
end

function OneYuanShopButton:dispose()
    self:stopTimer()
    ActivityIconButton.dispose(self)
end
