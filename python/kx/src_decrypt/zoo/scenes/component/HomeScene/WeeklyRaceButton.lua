require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"
require "zoo.data.WeeklyRaceManager"

WeeklyRaceButton = class(IconButtonBase)

function WeeklyRaceButton:init()
    self.ui = ResourceManager:sharedInstance():buildGroup('weelyRaceButtonIcon')
    IconButtonBase.init(self, self.ui)
    self.ui:setTouchEnabled(true)
    self.ui:setButtonMode(true)
    self:update()
end

function WeeklyRaceButton:update()
    local isPlayDay = WeeklyRaceManager:sharedInstance():isPlayDay()
    self.wrapper:getChildByName('iconPlay'):setVisible(isPlayDay)
    self.wrapper:getChildByName('iconWait'):setVisible(not isPlayDay)
end

function WeeklyRaceButton:create(...)
    local instance = WeeklyRaceButton.new()
    assert(instance)
    if instance then instance:init() end
    return instance
end

function WeeklyRaceButton:showTip(tip)
    self:setTipPosition(IconButtonBasePos.RIGHT)
    self:setTipString(tip)
    IconButtonBase.playHasNotificationAnim(self)
end
