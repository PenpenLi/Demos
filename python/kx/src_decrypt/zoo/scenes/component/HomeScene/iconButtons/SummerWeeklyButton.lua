require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

SummerWeeklyButton = class(IconButtonBase)

function SummerWeeklyButton:ctor()
	self.idPre = "SummerWeeklyButton"
    self.playTipPriority = 1010
end

function SummerWeeklyButton:playHasNotificationAnim(...)
    IconButtonManager:getInstance():addPlayTipActivityIcon(self)
end

function SummerWeeklyButton:stopHasNotificationAnim(...)
    IconButtonManager:getInstance():removePlayTipActivityIcon(self)
end

function SummerWeeklyButton:init()
	self.ui	= ResourceManager:sharedInstance():buildGroup("WeeklyRaceBtn")
	IconButtonBase.init(self, self.ui)

    self["tip"..IconTipState.kNormal] = Localization:getInstance():getText("weeklyrace.winter.panel.tip8")
    self["tip"..IconTipState.kExtend] = Localization:getInstance():getText("weekly.race.panel.rabbit.notice")
    self["tip"..IconTipState.kReward] = Localization:getInstance():getText("weeklyrace.winter.panel.tip5")

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

    local function onTimeout()
        local now = Localhost:time() / 1000
        if compareDate(os.date("*t", now), os.date("*t", now - 1)) ~= 0 then
            self:update()
        end
    end
    self.scheduler = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, 1, false)
end

function SummerWeeklyButton:dispose()
    if self.scheduler then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.scheduler)
    end
    IconButtonBase.dispose(self)
end

local SummerWeeklyTips = {
    kFirstTip = 1,
    kCanPlay = 2,
    kCanReward = 3,
}
function SummerWeeklyButton:update()
    self.numLabel:setVisible(false)
    self.numDot:setVisible(false)
    self.rewardDot:setVisible(false)

	local matchData = SeasonWeeklyRaceManager:getInstance():getAndUpdateMatchData()
    local showPlayTip = SeasonWeeklyRaceManager:getInstance():isShowDailyFirstTip()
	if SeasonWeeklyRaceManager:getInstance():hasReward() then 
    	self.rewardDot:setVisible(true)
        self:stopHasNotificationAnim()
		self:showTip(IconTipState.kReward)
    else
    	local leftPlay = SeasonWeeklyRaceManager:getInstance():getLeftPlay()
		if leftPlay > 0 then
			self.numLabel:setString(tostring(leftPlay))
		    self.numLabel:setVisible(true)
    		self.numDot:setVisible(true)
		end

        if leftPlay > 0 then
            local tipShowed = SeasonWeeklyRaceManager:getInstance():getTipShowTimes(SummerWeeklyTips.kCanPlay)
            if tipShowed < 1 then
                self:stopHasNotificationAnim()
                self:showTip(IconTipState.kExtend)
                SeasonWeeklyRaceManager:getInstance():onShowTip(SummerWeeklyTips.kCanPlay)
            end
        else
            self:stopHasNotificationAnim()
            -- self:showTip(IconTipState.kNormal)
        end
	end
    if showPlayTip then SeasonWeeklyRaceManager:getInstance():onShowDailyFirstTip() end
end

function SummerWeeklyButton:create(...)
	local btn = SummerWeeklyButton.new()
	btn:init()
	return btn
end

function SummerWeeklyButton:showTip(tipState)
    if not tipState then return end 
    self.tipState = tipState
    self.id = self.idPre .. self.tipState
    local tips = self["tip"..self.tipState]
    if tips then 
        self:setTipPosition(IconButtonBasePos.RIGHT)
        self:setTipString(tips)
        self:playHasNotificationAnim()
    end
end
