require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"
require "zoo.util.ActivityUtil"

ActivityIconButton = class(IconButtonBase)

function ActivityIconButton:create( source,version )
	local button = ActivityIconButton.new()
	button:init( source,version )
	return button
end

function ActivityIconButton:ctor( ... )
	self.playTipPriority = 0
end
function ActivityIconButton:playHasNotificationAnim(...)
	IconButtonManager:getInstance():addPlayTipActivityIcon(self)
end
function ActivityIconButton:stopHasNotificationAnim(...)
	IconButtonManager:getInstance():removePlayTipActivityIcon(self)
end

function ActivityIconButton:dispose( ... )

	for i,v in ipairs(ActivityUtil.onActivityStatusChangeCallbacks) do
		if v.obj == self and v.func == self.onActivityStatusChange then 
			table.remove(ActivityUtil.onActivityStatusChangeCallbacks,i)
			break
		end
	end

	if self.onUserLogin then
		GlobalEventDispatcher:getInstance():removeEventListener(
			kGlobalEvents.kUserLogin,
			self.onUserLogin
		)
	end

	IconButtonBase.dispose(self)
end

function ActivityIconButton:init( source,version )
	self.idPre = "ActivityIconButton_" .. source
	self.id = self.idPre .. self.tipState

	self.source = source
	self.version = version

	local config = require("activity/" .. source)

	self["tip"..IconTipState.kNormal] = config.tips 
	self["tip"..IconTipState.kExtend] = config.tipsExtend 
	self["tip"..IconTipState.kReward] = config.tipsReward 

	self.leftRegionLayoutBar = config.leftRegionLayoutBar

	self.playTipPriority = config.tipPriority or 999

	self.clickReplaceScene = config.clickReplaceScene
	self.playIconAnim = config.playIconAnim
	self.notLoginPlayIconAnim = config.notLoginPlayIconAnim

	self.ui = ResourceManager:sharedInstance():buildGroup("activityImageButtonIcon")
	IconButtonBase.init(self, self.ui)

	self.wrapper:getChildByName("placeholder"):removeFromParentAndCleanup(true)

	self.wrapper:addChildAt(self:buildIcon(),0)

	self.wrapper:setTouchEnabled(true)
	self.wrapper:setButtonMode(true)

	self:setTipPosition(IconButtonBasePos.LEFT)

 	self.wrapper:setPositionX(96/2)
	self.wrapper:setPositionY(-96)

	local manualAdjustX = config.iconManualAdjustX or 0
	local manualAdjustY = config.iconManualAdjustY or 0
	for _,v in pairs({"msgNum","msgBg","rewardIcon"}) do
		local u = self.wrapper:getChildByName(v)
		u:setPositionX(u:getPositionX() - 96/2 + manualAdjustX)
		u:setPositionY(u:getPositionY() + 96 + manualAdjustY)
	end

	-- if self.tips then 
	-- 	self:setTipString(self.tips)
	--  	self:playHasNotificationAnim()
	-- end

	self.wrapper:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if PopoutManager:sharedInstance():haveWindowOnScreen() then 
			return 
		end
		ActivityData.new(self):start(true,true)
	end)

	table.insert(ActivityUtil.onActivityStatusChangeCallbacks,{
		obj = self,
		func = self.onActivityStatusChange
	})

	if not _G.kUserLogin then
		self.onUserLogin = function( ... )
			self:onActivityStatusChange(self.source)
		end
		GlobalEventDispatcher:getInstance():addEventListener(
			kGlobalEvents.kUserLogin,
			self.onUserLogin
		)
	end

	self:onActivityStatusChange(self.source)

end

function ActivityIconButton:buildIcon( ... )
	local config = require("activity/" .. self.source)

	local image = Sprite:create("activity/" .. config.icon)
	image:setAnchorPoint(ccp(0.5,0))

	return image
end

function ActivityIconButton:onActivityStatusChange( source )

	if self.source ~= source then 
		return 
	end

	local function setMsgNum( num )
		local msgBg = self.wrapper:getChildByName("msgBg")
		local msgNum = self.wrapper:getChildByName("msgNum")

		self.msgNum = num

		if msgBg and msgNum then 
			msgBg:setVisible(num > 0)
			msgNum:setVisible(num > 0)
			if num > 0 then 
				msgNum:setString(tostring(num))
			end
		end
	end

	local function showRewardIcon( ... )
		local msgBg = self.wrapper:getChildByName("msgBg")
		local msgNum = self.wrapper:getChildByName("msgNum")
		local rewardIcon = self.wrapper:getChildByName("rewardIcon")

		msgBg:setVisible(false)
		msgNum:setVisible(false)

		rewardIcon:setVisible(true)
	end

	local function hideRewardIcon( ... )
		local rewardIcon = self.wrapper:getChildByName("rewardIcon")

		setMsgNum(self.msgNum or 0)
		rewardIcon:setVisible(false)
	end

	local function needPlayIconAnim( ... )
		if self.tip then --有tip动画
			return true
		elseif not _G.kUserLogin and self.notLoginPlayIconAnim then
			return true
		elseif ActivityUtil:getMsgNum(self.source) > 0 and self.playIconAnim then
			return true
		elseif ActivityUtil:hasRewardMark(self.source) and self.playIconAnim then
			return true
		else
			return false
		end
	end

	setMsgNum(ActivityUtil:getMsgNum( self.source ))
	if ActivityUtil:hasRewardMark( self.source ) then 
		self.tipState = IconTipState.kReward
		self.id = self.idPre .. self.tipState
		showRewardIcon()
	else
		self.tipState = IconTipState.kNormal
		self.id = self.idPre .. self.tipState
		hideRewardIcon()
	end

	if self.tipState then 
		local tips = self["tip"..self.tipState]
		if tips then 
			self:setTipString(tips)
		 	self:playHasNotificationAnim()
		end
	end

	if needPlayIconAnim() then
		self:playOnlyIconAnim()
	else
		self:stopOnlyIconAnim()
	end
end

function ActivityIconButton:addToUi( homeScene )
	if self.leftRegionLayoutBar then
		self.regionLayoutBar = homeScene.leftRegionLayoutBar
		self.regionLayoutBar:addItem(self)

		self:setTipPosition(IconButtonBasePos.RIGHT)
	else
		self.regionLayoutBar = homeScene.rightRegionLayoutBar

		local index = self.regionLayoutBar:getItemIndex(homeScene.activityButton)
		if index then
			self.regionLayoutBar:addItemAt(self,index)
		else 
			self.regionLayoutBar:addItem(self)
		end

		self:setTipPosition(IconButtonBasePos.LEFT)
	end
end

function ActivityIconButton:removeFromUi( homeScene )
	if self.regionLayoutBar then
		self.regionLayoutBar:removeItem(self,true)
		self.regionLayoutBar = nil
	end
end