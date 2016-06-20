require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"
require "zoo.data.RabbitWeeklyManager"

RabbitWeeklyButton = class(IconButtonBase)

function RabbitWeeklyButton:ctor( ... )
    self.id = "RabbitWeeklyButton"
    self.playTipPriority = 10
end
function RabbitWeeklyButton:playHasNotificationAnim(...)
    IconButtonManager:getInstance():addPlayTipActivityIcon(self)
end

function RabbitWeeklyButton:stopHasNotificationAnim(...)
    IconButtonManager:getInstance():removePlayTipActivityIcon(self)
end


function RabbitWeeklyButton:init()
    self.ui = ResourceManager:sharedInstance():buildGroup('rabbitWeeklyButton')
    IconButtonBase.init(self, self.ui)
    self.ui:setTouchEnabled(true)
    self.ui:setButtonMode(true)
    self:update()
end

function RabbitWeeklyButton:update()
    local rabbitMgr = RabbitWeeklyManager:sharedInstance()
    local isPlayDay = rabbitMgr:isPlayDay()
    self.wrapper:getChildByName('iconPlay'):setVisible(isPlayDay)
    self.wrapper:getChildByName('iconWait'):setVisible(not isPlayDay)

    local number = 0

    if isPlayDay then
        number = rabbitMgr:getFreePlayLeft()
        local remainNumber = rabbitMgr:getRemainingPlayCount()
        if remainNumber > 0 then
            self.wrapper:getChildByName('num'):setString(tostring(remainNumber))
            self.wrapper:getChildByName('num'):setVisible(true)
            self.wrapper:getChildByName('redDot'):setVisible(true)
        else
            self.wrapper:getChildByName('num'):setVisible(false)
            self.wrapper:getChildByName('redDot'):setVisible(false)
        end

        if number > 0 or rabbitMgr:getRemainingPayCount() > 0 then -- 有免费次数或者可以购买次数
            self.id = "RabbitWeeklyButton"
            self:showTip(Localization:getInstance():getText("weekly.race.icon.rabbit.tip1"))
        end
    else
        if rabbitMgr:canReceiveWeeklyReward() then
            number = 1
        end

        if number == 0 then
            self.wrapper:getChildByName('num'):setVisible(false)
            self.wrapper:getChildByName('redDot'):setVisible(false)
        else
            self.wrapper:getChildByName('num'):setString(tostring(number))
            self.wrapper:getChildByName('num'):setVisible(true)
            self.wrapper:getChildByName('redDot'):setVisible(true)
            self.id = "RabbitWeeklyButton2"
            self:showTip(Localization:getInstance():getText("weekly.race.icon.rabbit.tip2"))
        end
    end
end

function RabbitWeeklyButton:create(...)
    local instance = RabbitWeeklyButton.new()
    if instance then instance:init() end
    return instance
end

function RabbitWeeklyButton:showTip(tip)
    self:setTipPosition(IconButtonBasePos.RIGHT)
    self:setTipString(tip)
    -- IconButtonBase.playHasNotificationAnim(self)
    self:playHasNotificationAnim()
end



