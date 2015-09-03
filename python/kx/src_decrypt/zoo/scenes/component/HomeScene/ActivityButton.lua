require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"
require "zoo.util.ActivityUtil"
require "zoo.scenes.component.HomeScene.iconButtons.IconButtonManager"

ActivityButton = class(IconButtonBase)

function ActivityButton:ctor( ... )
	self.id = "ActivityButton"
	self.playTipPriority = 1
end

function ActivityButton:playHasNotificationAnim(...)
	IconButtonManager:getInstance():addPlayTipIcon(self)
end

function ActivityButton:stopHasNotificationAnim(...)
	IconButtonManager:getInstance():removePlayTipIcon(self)
end


function ActivityButton:dispose( ... )
	
	for i,v in ipairs(ActivityUtil.onActivityStatusChangeCallbacks) do
		if v.obj == self and v.func == self.onActivityStatusChange then 
			table.remove(ActivityUtil.onActivityStatusChangeCallbacks,i)
			break
		end
	end

	IconButtonBase.dispose(self)
end
function ActivityButton:init()

	self.ui = ResourceManager:sharedInstance():buildGroup("activityButtonIcon")

	IconButtonBase.init(self, self.ui)

	self.ui:getChildByName("text3"):setVisible(false)
	
	self.wrapper:setTouchEnabled(false)
	self.wrapper:setTouchEnabled(true,0,false)
	self.wrapper:setButtonMode(true)

	self:setTipPosition(IconButtonBasePos.LEFT)
	self.clickReplaceScene = true
	for _,v in pairs(ActivityUtil:getNoticeActivitys()) do		
		local config = require("activity/"..v.source)
		if config.tips  then
			self.tips = config.tips
			self.id = "ActivityButton_" .. v.source
			if not IconButtonManager:getInstance():todayIsShow(self) then
				self:setTipString(self.tips)
			 	self:playHasNotificationAnim()
			 	break
			else
				self.id = "ActivityButton"
				self.tips = nil
			end
	 	end
	end

	self.wrapper:addEventListener(DisplayEvents.kTouchTap, function()
		if PopoutManager:sharedInstance():haveWindowOnScreen() then return end
		self.wrapper:setTouchEnabled(false)

		self:runAction(CCCallFunc:create(function( ... )
			Director.sharedDirector():pushScene(ActivityScene:create(),ActivityUtil:getNoticeActivitys())
			self.wrapper:setTouchEnabled(true)
		end))
	end)

	self.ui:getChildByName("guang"):setAnchorPoint(ccp(0.5,0.5))
	
	self.balloon1PosY = self.wrapper:getChildByName("balloon1"):getPositionY()
	self.balloon2PosY = self.wrapper:getChildByName("balloon2"):getPositionY()

	self:setNewStatus(false)
	self:hideRewardIcon()

	table.insert(ActivityUtil.onActivityStatusChangeCallbacks,{
		obj = self,
		func = self.onActivityStatusChange
	})

	self:onActivityStatusChange()
end

function ActivityButton:create(...)
	local button = ActivityButton.new()
	button:init()
	return button
end

function ActivityButton:setMsgNum( num )

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

function ActivityButton:showRewardIcon( ... )
	
	local msgBg = self.wrapper:getChildByName("msgBg")
	local msgNum = self.wrapper:getChildByName("msgNum")
	local rewardIcon = self.wrapper:getChildByName("rewardIcon")

	msgBg:setVisible(false)
	msgNum:setVisible(false)

	rewardIcon:setVisible(true)
end

function ActivityButton:hideRewardIcon( ... )

	local rewardIcon = self.wrapper:getChildByName("rewardIcon")

	self:setMsgNum(self.msgNum or 0)
	rewardIcon:setVisible(false)
end

function ActivityButton:setNewStatus(isNew)	
	if self.isNew == isNew then
		return 
	end
	self.isNew = isNew

	local guang = self.ui:getChildByName("guang")
	local balloon1 = self.wrapper:getChildByName("balloon1")
	local balloon2 = self.wrapper:getChildByName("balloon2")

	guang:stopAllActions()
	balloon1:stopAllActions()
	balloon2:stopAllActions()

	balloon1:setPositionY(self.balloon1PosY)
	balloon2:setPositionY(self.balloon2PosY)

	guang:setVisible(isNew)
	self.ui:getChildByName("text1"):setVisible(isNew)
	self.ui:getChildByName("text2"):setVisible(not isNew)

	if isNew then 
		guang:setScale(1)
		guang:runAction(CCRepeatForever:create(CCRotateBy:create(90.0/24.0,360)))

		local arr1 = CCArray:createWithCapacity(4)
		arr1:addObject(CCDelayTime:create(5.0/24.0))
		arr1:addObject(CCMoveBy:create(0,ccp(0,5)))
		arr1:addObject(CCDelayTime:create(5.0/24.0))
		arr1:addObject(CCMoveBy:create(0,ccp(0,-5)))

		balloon1:runAction(CCRepeatForever:create(CCSequence:create(arr1)))

		local arr2 = CCArray:createWithCapacity(4)
		arr2:addObject(CCDelayTime:create(5.0/24.0))
		arr2:addObject(CCMoveBy:create(0,ccp(0,-5)))
		arr2:addObject(CCDelayTime:create(5.0/24.0))
		arr2:addObject(CCMoveBy:create(0,ccp(0,5)))

		balloon2:runAction(CCRepeatForever:create(CCSequence:create(arr2)))
	else
		guang:setScale(0)
	end
end


function ActivityButton:onActivityStatusChange( ... )

	local function getMsgNum( ... )
		local msgNum = 0
		for _,v in pairs(ActivityUtil:getNoticeActivitys()) do
			msgNum = msgNum + ActivityUtil:getMsgNum(v.source)
		end
		return msgNum
	end

	local function hasRewardAcitviy( ... )
		for _,v in pairs(ActivityUtil:getNoticeActivitys()) do
			if ActivityUtil:hasRewardMark(v.source) then 
				return true
			end
		end
		return false
	end

	self:setMsgNum(getMsgNum())
	if hasRewardAcitviy() then 
		self:showRewardIcon()
	else
		self:hideRewardIcon()
	end
	-- 
	local function hasNewActivity( ... )
		for _,v in pairs(ActivityUtil:getNoticeActivitys()) do
			if ActivityUtil:getCacheVersion(v.source) == "" then 
				return true
			end
		end
		return false
	end

	self:setNewStatus(hasNewActivity())
end