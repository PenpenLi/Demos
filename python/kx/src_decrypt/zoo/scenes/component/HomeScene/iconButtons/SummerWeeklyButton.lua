require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

SummerWeeklyButton = class(IconButtonBase)

function SummerWeeklyButton:ctor()
	self.id = "SummerWeeklyButton"
    self.playTipPriority = 10
end

-- function SummerWeeklyButton:playHasNotificationAnim(...)
--     IconButtonManager:getInstance():addPlayTipIcon(self)
-- end

-- function SummerWeeklyButton:stopHasNotificationAnim(...)
--     IconButtonManager:getInstance():removePlayTipIcon(self)
-- end

function SummerWeeklyButton:init()
	self.ui	= ResourceManager:sharedInstance():buildGroup("summerWeeklyBtn")
	IconButtonBase.init(self, self.ui)

	self.tipLeftMarginToIconBtn	= 8 -- override
    self.ui:setTouchEnabled(true)
    self.ui:setButtonMode(true)

    self.numLabel = self.wrapper:getChildByName('num')
    self.numDot = self.wrapper:getChildByName('num_dot')
    self.rewardDot = self.wrapper:getChildByName('reward_dot')

    self.numLabel:setVisible(false)
    self.numDot:setVisible(false)
    self.rewardDot:setVisible(false)

    self:update()
end

function SummerWeeklyButton:update()
    self.numLabel:setVisible(false)
    self.numDot:setVisible(false)
    self.rewardDot:setVisible(false)

    self:stopHasNotificationAnim()

	local matchData = SummerWeeklyMatchManager:getInstance():getAndUpdateMatchData()
    local showPlayTip = SummerWeeklyMatchManager:getInstance():isShowDailyFirstTip()
	if SummerWeeklyMatchManager:getInstance():hasReward() then 
    	self.rewardDot:setVisible(true)
		self:showTip(Localization:getInstance():getText("weeklyrace.summer.panel.tip5"))
    else
    	local leftPlay = SummerWeeklyMatchManager:getInstance():getLeftPlay()
		if leftPlay > 0 then
			self.numLabel:setString(tostring(leftPlay))
		    self.numLabel:setVisible(true)
    		self.numDot:setVisible(true)
		end

        if showPlayTip then
            self:showTip(Localization:getInstance():getText("weeklyrace.summer.panel.tip8"))
        elseif leftPlay > 0 then
            self:showTip(Localization:getInstance():getText("weekly.race.panel.rabbit.notice"))
        end
	end
    if showPlayTip then SummerWeeklyMatchManager:getInstance():onShowDailyFirstTip() end
end

function SummerWeeklyButton:create(...)
	local btn = SummerWeeklyButton.new()
	btn:init()
	return btn
end

function SummerWeeklyButton:showTip(tip)
    self:setTipPosition(IconButtonBasePos.RIGHT)
    self:setTipString(tip)
    self:playHasNotificationAnim()
end
