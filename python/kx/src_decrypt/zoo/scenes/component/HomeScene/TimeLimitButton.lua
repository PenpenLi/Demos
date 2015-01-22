require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

require "zoo.panel.TimeLimitPanel"

TimeLimitButton = class(IconButtonBase)


function TimeLimitButton:create()
	local button = TimeLimitButton.new()
	button:init()
	return button
end

function TimeLimitButton:init()

    self.ui = ResourceManager:sharedInstance():buildGroup('timeLimitButtonIcon')

    IconButtonBase.init(self, self.ui)

    self.clock = self.wrapper:getChildByName("clock")
    self.zhe = self.wrapper:getChildByName("zhe")

    self.clock:setAnchorPoint(ccp(0.5,0))

    local bounds = self.clock:getGroupBounds()

    self.timerText = self.ui:getChildByName("time")
	self.timerText:setAnchorPoint(ccp(0.5,self.timerText:getAnchorPoint().y))
	self.timerText:setPositionX(bounds.size.width/2 + 10)

    self.ui:getChildByName("text"):setVisible(false)

    local function setTimeString( ... )
        local leftTime = TimeLimitData:getInstance():getLeftTime()
        if leftTime.hour == 0 and leftTime.min == 0 and leftTime.sec == 0 then 
            self:runAction(CCCallFunc:create(function( ... )
                if type(self.remove) == "function" then
                    self:remove()
                end
            end))
        else
            self.timerText:setString(string.format("%02d:%02d:%02d", leftTime.hour,leftTime.min,leftTime.sec))    
        end
    end

    self.timerText:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(
        CCDelayTime:create(1.0),
        CCCallFunc:create(setTimeString)
    )))
    setTimeString()

    self.clock:runAction(self:buildAnimation())
end

function TimeLimitButton:buildAnimation()

    local zheArr = CCArray:create()
    for k,v in pairs({3,53 + 120}) do
        zheArr:addObject(CCMoveBy:create(10/60,ccp(0,-2)))
        zheArr:addObject(CCMoveBy:create(12/60,ccp(0,2)))
        zheArr:addObject(CCDelayTime:create(v/60))
    end

    local clockArr = CCArray:create()
    for k,v in pairs({5,55 + 120}) do
        clockArr:addObject(CCScaleTo:create(6/60,1,0.85))
        clockArr:addObject(CCSpawn:createWithTwoActions(
            CCScaleTo:create(4/60,1,1.05),
            CCMoveBy:create(4/60,ccp(0,20))
        ))
        clockArr:addObject(CCSpawn:createWithTwoActions(
            CCScaleTo:create(4/60,1,0.85),
            CCMoveBy:create(4/60,ccp(0,2))
        ))
        clockArr:addObject(CCSpawn:createWithTwoActions(
            CCScaleTo:create(6/60,1,1),
            CCMoveBy:create(6/60,ccp(0,-22))
        ))
        clockArr:addObject(CCDelayTime:create(v/60))
    end

    return CCRepeatForever:create(CCSpawn:createWithTwoActions(
        CCTargetedAction:create(self.zhe.refCocosObj,CCSequence:create(zheArr)),
        CCTargetedAction:create(self.clock.refCocosObj,CCSequence:create(clockArr))
    ))
end
