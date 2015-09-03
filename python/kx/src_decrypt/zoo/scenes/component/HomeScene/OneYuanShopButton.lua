require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"


OneYuanShopButton = class(IconButtonBase)

function OneYuanShopButton:create(time)
    local instance = OneYuanShopButton.new()
    instance:init(time)
    return instance
end

function OneYuanShopButton:init(time)
    self.ui = ResourceManager:sharedInstance():buildGroup('ios_payguide_btn')
    IconButtonBase.init(self, self.ui)
    self.ui:setTouchEnabled(true)
    self.ui:setButtonMode(true)
    self.timeTxt = self.wrapper:getChildByName('time')
    self.timeTxt:setText('00:00:00')

    self:setCdTime(time or 0)
end

function OneYuanShopButton:stopTimer()
    if self.schedId then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedId)
        self.schedId = nil
    end
end

function OneYuanShopButton:setCdTime(seconds)
    self:stopTimer()
    self.cdTime = seconds
    local function onTick()
        if self.cdTime < 0 then return end
        if self.isDisposed then return end
        self.cdTime = self.cdTime - 1
        if self.cdTime >= 0 then
            self.timeTxt:setText(convertSecondToHHMMSSFormat(self.cdTime))
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
