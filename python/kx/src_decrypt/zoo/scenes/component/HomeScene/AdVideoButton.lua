require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

AdVideoButton = class(IconButtonBase)
function AdVideoButton:ctor( ... )
    self.id = "AdVideoButton"
    self.playTipPriority = 41
end
function AdVideoButton:playHasNotificationAnim(...)
    IconButtonManager:getInstance():addPlayTipIcon(self)
end

function AdVideoButton:stopHasNotificationAnim(...)
    IconButtonManager:getInstance():removePlayTipIcon(self)
end


function AdVideoButton:init()
    self.ui = ResourceManager:sharedInstance():buildGroup('AdVideoIcon')
    IconButtonBase.init(self, self.ui)
    self.ui:setTouchEnabled(true)
    self.ui:setButtonMode(true)
    self.wrapper = self.ui:getChildByName("wrapper")
    self.numberShow = self.wrapper:getChildByName("num_show")
    self.textShow = self.wrapper:getChildByName("text_show")
    self.timeCount = self.wrapper:getChildByName("time_count")  
end

function AdVideoButton:updateState( ... )
    -- body
    local function __onTick()
        local timeCountDown = (AdVideoManager:getInstance().timeInterval + AdVideoManager:getInstance():getLastPlayTime() - Localhost:time() )/1000
        if timeCountDown <= 0 then
            self.timeCount:setVisible(false)
            self.numberShow:setVisible(true)
            self.textShow:setVisible(true)
            if self.timer then
                self.timer:stop()
                self.timer = nil
            end
            self:showTip(Localization:getInstance():getText("watch_ad_tips"))
        else    
            self.timeCount:setVisible(true)
            self.timeCount:setString(convertSecondToHHMMSSFormat(timeCountDown))
        end
        
        
    end
   
    if not self.timer then
        self.timer = OneSecondTimer:create()
    end
    self.timer:setOneSecondCallback(__onTick)
    self.timer:start()
    self.numberShow:setVisible(false)
    self.textShow:setVisible(false)
     __onTick()
end

function AdVideoButton:create(...)
    local instance = AdVideoButton.new()
    if instance then instance:init() end
    return instance
end

function AdVideoButton:showTip(tip)
    self:setTipPosition(IconButtonBasePos.LEFT)
    self:setTipString(tip)
    self:playHasNotificationAnim()
end

function AdVideoButton:dispose( ... )
    -- body
    if self.timer then
        self.timer:stop()
        self.timer = nil
    end
end
