
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年08月27日 12:33:57
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "hecore.display.CocosObject"
require "zoo.ResourceManager"
require "zoo.scenes.component.HomeScene.LockedCloud"
require "zoo.scenes.component.HomeScene.hiddenBranch.HiddenBranch"
require "zoo.scenes.component.HomeScene.hiddenBranch.ExploreCloud"
require "zoo.UIConfigManager"
require "zoo.panel.StartGamePanel"
require "zoo.common.CallbackChain"


local function sinFunction(Y, deltaX, ...)
	assert(type(Y) == "number")
	assert(type(deltaX) == "number")
	assert(#{...} == 0)

	local A = 150
	local B = 800

	if Y > A then Y = A end

	local X = 2 * B / math.pi * math.asin( Y / A)

	X = X + deltaX

	if X > B then X = B end

	local newY = A * math.sin(math.pi / ( 2 * B) * X)


	if tostring(newY) == "nan" then
		debug.debug()
	end

	return newY
end

---------------------------------------------------
-------------- ScrollDirection
---------------------------------------------------

ScrollDirection = {kNone = 0, kVertical = 1, kHorizontal = 2}


---------------------------------------------------
-------------- VelocityMeasurer
---------------------------------------------------

assert(not VelocityMeasurer)
VelocityMeasurer = class()

function VelocityMeasurer:init(measureInterval, getCurPosCallback, ...)
	assert(type(measureInterval) == "number")
	assert(type(getCurPosCallback) == "function")
	
	assert(#{...} == 0)

	self.prePosX = false
	self.prePosY = false
	self.curPosX = false
	self.curPosY = false

	self.curSpeedY = 0
	self.lastSpeedY = 0
	self.curSpeedX = 0
	self.lastSpeedX = 0

	self.measureInterval	= measureInterval
	self.getCurPosCallback	= getCurPosCallback

	self.measuredVelocityX = false
	self.measuredvelocityY = false

	self.scheduledFunc = false

	self.preSpeed = 0
	self.curSpeed = 0
end

function VelocityMeasurer:setInitialPos(x, y, ...)
	assert(type(x) == "number")
	assert(type(y) == "number")
	assert(#{...} == 0)

	self.prePosX = x
	self.prePosY = y
	self.curPosX = x
	self.curPosY = y

	self.preSpeed = 0
	self.curSpeed = 0
	
	self.measuredVelocityX = false
	self.measuredvelocityY = false
end

function VelocityMeasurer:startMeasure(...)
	assert(#{...} == 0)

	local assertFalseMsg = "Call setInitialPos First !"
	assert(self.prePosX, assertFalseMsg)
	assert(self.prePosY, assertFalseMsg)
	assert(self.curPosX, assertFalseMsg)
	assert(self.curPosY, assertFalseMsg)

	local scheduler = CCDirector:sharedDirector():getScheduler()

	local function scheduledFunc()

		local curPos = self.getCurPosCallback()
		assert(curPos.x)
		assert(curPos.y)

		self.prePosX = self.curPosX
		self.prePosY = self.curPosY
		self.curPosX = curPos.x
		self.curPosY = curPos.y

		self.measuredVelocityX = (self.curPosX - self.prePosX) / self.measureInterval
		self.measuredVelocityY = (self.curPosY - self.prePosY) / self.measureInterval

		self.lastSpeedY = self.curSpeedY
		self.curSpeedY = self.measuredVelocityY
	end
	
	scheduledFunc()
	if not self.scheduledFunc then
		self.scheduledFunc = scheduler:scheduleScriptFunc(scheduledFunc, self.measureInterval, false)
	end
end

function VelocityMeasurer:stopMeasure(...)
	assert(#{...} == 0)

	assert(self.scheduledFunc)
	if self.scheduledFunc then
		local scheduler = CCDirector:sharedDirector():getScheduler()
		scheduler:unscheduleScriptEntry(self.scheduledFunc)
		self.scheduledFunc = false
	end
end

function VelocityMeasurer:getMeasuredVelocityX(...)
	assert(#{...} == 0)

	return self.measuredVelocityX
end

function VelocityMeasurer:getMeasuredVelocityY(...)
	assert(#{...} == 0)

	return self.measuredVelocityY
end

function VelocityMeasurer:create(measureInterval, getCurPosCallback, ...)
	assert(type(measureInterval) == "number")
	assert(type(getCurPosCallback) == "function")
	assert(#{...} == 0)

	local newVelocityMeasurer = VelocityMeasurer.new()
	newVelocityMeasurer:init(measureInterval, getCurPosCallback)
	return newVelocityMeasurer
end

function VelocityMeasurer:getSpeedY()
	return (self.lastSpeedY + self.curSpeedY) / 2
end

function VelocityMeasurer:getSpeedX()
	return (self.lastSpeedX + self.curSpeedX) / 2
end

function VelocityMeasurer:setXY(x, y)

	self.prePosX = self.curPosX
	self.prePosY = self.curPosY
	self.curPosX = x
	self.curPosY = y

	self.measuredVelocityX = (self.curPosX - self.prePosX) / self.measureInterval
	self.measuredVelocityY = (self.curPosY - self.prePosY) / self.measureInterval

	self.lastSpeedY = self.curSpeedY
	self.lastSpeedX = self.curSpeedX
	self.curSpeedY = self.measuredVelocityY
	self.curSpeedX = self.measuredVelocityX
end

---------------------------------------------------
-------------- WorldSceneScroller
---------------------------------------------------
--
assert(not WorldSceneScrollerEvents)
WorldSceneScrollerEvents = 
{
	MOVE_TO_PERCENTAGE	= "WorldSceneScrollerEvents.MOVE_TO_PERCENTAGE",

	--
	MOVING_STARTED		= "WorldSceneScrollerEvents.MOVING_STARTED",
	MOVING_STOPPED		= "WorldSceneScrollerEvents.MOVING_STOPPED",

	--
	SCROLLED_TO_RIGHT	= "WorldSceneScrollerEvents.SCROLLED_TO_RIGHT",
	SCROLLED_TO_LEFT	= "WorldSceneScrollerEvents.SCROLLED_TO_LEFT",
	SCROLLED_TO_ORIGIN	= "WorldSceneScrollerEvents.SCROLLED_TO_ORIGIN"
}

assert(not CheckSceneOutRangeConstant)
CheckSceneOutRangeConstant = 
{
	IN_RANGE		= 1,
	TOP_OUT_OF_RANGE	= 2,
	BOTTOM_OUT_OF_RANGE	= 3
}


WorldSceneScrollerActionTag = {
	AUTO_ROLL_ACTION		= 1,
	DELAY_STOP_SCROLL_ACTION	= 2
}

WorldSceneScrollerHorizontalState = {
	
	SCROLLING_TO_RIGHT	= 1,
	STAY_IN_RIGHT		= 2,
	SCROLLING_TO_LEFT	= 3,
	STAY_IN_LEFT		= 4,
	SCROLLING_TO_ORIGIN	= 5,
	STAY_IN_ORIGIN		= 6
}

WorldSceneScrollerTouchState = {
	SOME_THING_ABOVE_SCROLLER_TOUCHED = 1, -- flower, cloud, friendStack
	VERTICAL_SCROLLER_TOUCHED = 2, -- on touch scroll vertical
	HORIZONTAL_SCROLLER_TOUCHED = 3, -- on touch branch scroll horizontal
}

assert(not WorldSceneScroller)
WorldSceneScroller = class(Layer)

function WorldSceneScroller:init(...)
	assert(#{...} == 0)

	-- Init Base
	Layer.initLayer(self)

	---------------------------
	---- Data Control Scroll Horizontal
	---------------------------------
	self.scrollHorizontalState = WorldSceneScrollerHorizontalState.STAY_IN_ORIGIN

	----------------------------
	------- Other Data
	--------------------------
	self.scrollable	= true
	local animInterval = CCDirector:sharedDirector():getAnimationInterval()

	-- -------------
	-- Scroll Effect
	-- ----------------
	self.movingStartedFlag = false
	
	local config 				= UIConfigManager:sharedInstance():getConfig()
	self.autoScrollTimerInterval		= config.worldSceneScroller_autoScrollTimerInterval

	-- Slow Down Based On Ratio
	self.velocitySlowdownRatio		= config.worldSceneScroller_velocitySlowdownRatio
	self.velocityThreshold			= config.worldSceneScroller_velocityThreshold

	assert(self.autoScrollTimerInterval)
	assert(self.velocitySlowdownRatio)
	assert(self.velocityThreshold)

	----------------------------
	---- Measure Finger Speed
	--------------------------
	
	-- Data Control Measure Finger Speed
	self.fingerPreviousPositionY 	= false
	self.fingerPositionY		= false

	local function getCurFingerPos()
		return ccp(0, self.fingerPositionY)
	end

	self.velocityMeasurerArray = {}
	local measurer = VelocityMeasurer:create(animInterval * 1, getCurFingerPos)
	table.insert(self.velocityMeasurerArray, measurer)

	local measurer = VelocityMeasurer:create(animInterval * 2, getCurFingerPos)
	table.insert(self.velocityMeasurerArray, measurer)

	local measurer = VelocityMeasurer:create(animInterval * 4, getCurFingerPos)
	table.insert(self.velocityMeasurerArray, measurer)

	local config = UIConfigManager:sharedInstance():getConfig()
	self.fingerVelocityRatio = config.worldSceneScroller_fingerVelocityRatio
	assert(self.fingerVelocityRatio)

	-- -------------------
	-- Scrollable Range
	-- ------------------
	self.topScrollRangeY	= 100
	self.belowScrollRangeY	= 150
	self.horizontalScrollMaxTime = 0.4

	-------------------
	-- Event Listener
	-- -----------------
	-- Scroll Horizontal Event Listener
	local function onScrolledToLeftOrRight(event)
		self:onScrolledToLeftOrRight(event)
	end
	self:addEventListener(WorldSceneScrollerEvents.SCROLLED_TO_LEFT, onScrolledToLeftOrRight)
	self:addEventListener(WorldSceneScrollerEvents.SCROLLED_TO_RIGHT, onScrolledToLeftOrRight)

	local function onScrolledToOrigin(event)
		self:onScrolledToOrigin(event)
	end
	self:addEventListener(WorldSceneScrollerEvents.SCROLLED_TO_ORIGIN, onScrolledToOrigin)
end

------------------------------------
-------- Event Listener
------------------------------------

local function onScrollerTouchMove(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchMove)
	assert(event.context)
	assert(#{...} == 0)

	local self = event.context
	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()

	--if self.clickOffset then
	if self.clicked then

		---------------------------
		-- Stop "Delay To Stop Auto Scroll Action"
		-- -----------------------------------------
		self:stopDelayStopAutoScroll()
		------------------------
		-- Manually Stop Auto Scroll Action
		-- ---------------------------------
		if self:isAutoRollTimerRunning() then
			if __WP8 then self.stopRollByTouchMove = true end
			self:stopAutoRollTimer()
		end

		-- First Move 
		if not self.movingStartedFlag then
			self.movingStartedFlag = true
			self:dispatchEvent(Event.new(WorldSceneScrollerEvents.MOVING_STARTED))
			local maskedLayerY	= self.maskedLayer:getPositionY()
			self.clickOffset	= event.globalPosition.y - maskedLayerY
		end

		self.fingerPreviousPositionY	= self.fingerPositionY
		self.fingerPositionY 		= event.globalPosition.y

		local newPositionY		= false

		-- -----------------------------
		-- Check Current Scene Position
		-- Whether Out Of Range
		-- -------------------------------------------------------
		local scenePositionState	= self:checkSceneOutRange()

		if CheckSceneOutRangeConstant.IN_RANGE == scenePositionState then

			newPositionY	= event.globalPosition.y - self.clickOffset

		elseif CheckSceneOutRangeConstant.TOP_OUT_OF_RANGE == scenePositionState then 

			-- he_log_warning("self.maskedLayer is defined in child class !! Separate is not complete !")
			local positionY = self.maskedLayer:getPositionY()

			local maskedLayerPositionY	= self.maskedLayer:getPositionY()
			local virtualPositionY		= maskedLayerPositionY + self.belowScrollRangeY - visibleOrigin.y
			local deltaX	= self.fingerPositionY - self.fingerPreviousPositionY

			local newVirtualPositionY = sinFunction(virtualPositionY, deltaX)

			newPositionY	= newVirtualPositionY - self.belowScrollRangeY + visibleOrigin.y

		elseif CheckSceneOutRangeConstant.BOTTOM_OUT_OF_RANGE == scenePositionState then

			local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()

			local positionY = self.maskedLayer:getPositionY()
			local deltaBlackEdge	= visibleOrigin.y + self.visibleSize.height - (positionY + self.topScrollRangeY)
			local deltaX	= -(self.fingerPositionY - self.fingerPreviousPositionY)

			local newDeltaBlackEdge = sinFunction(deltaBlackEdge, deltaX)

			newPositionY = visibleOrigin.y + self.visibleSize.height - newDeltaBlackEdge - self.topScrollRangeY
		else 
			assert(false)
		end

		self.maskedLayer:setPositionY(newPositionY)

		-- Treated As A ScrollBar
		-- Calculate The Percentage
		self:dispatchMoveToPercentageEvent()
	else
		-- Do Nothing
	end
end

local function onScrollerTouchEnd(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchEnd)
	assert(event.context)
	assert(#{...} == 0)

	local self = event.context

	self.clickOffset = nil
	self.clicked	= false

	---------------------------
	-- Stop "Delay To Stop Auto Scroll Action"
	-- -----------------------------------------
	self:stopActionByTag(WorldSceneScrollerActionTag.DELAY_STOP_SCROLL_ACTION)
	-- First Move 
	if not self.movingStartedFlag then
		self.movingStartedFlag = true
		self:dispatchEvent(Event.new(WorldSceneScrollerEvents.MOVING_STARTED))
	end

	-- ---------------------
	-- Stop Calculate Speed
	-- -------------------
	for k,measurer in ipairs(self.velocityMeasurerArray) do
		measurer:stopMeasure()
	end

	self.velocity = false

	for k,measurer in ipairs(self.velocityMeasurerArray) do

		local velocity = measurer:getMeasuredVelocityY()

		if velocity and velocity ~= 0 then
			if not self.velocity then
				self.velocity = velocity
			elseif math.abs(velocity) < math.abs(self.velocity) then 
				self.velocity = velocity
			end
		end
	end

	if not self.velocity then 
		self.velocity = 0
	end

	self.velocity = self.velocity * self.fingerVelocityRatio

	-- --------------------
	-- Remove Event Listener
	-- --------------------
	self:removeEventListener(DisplayEvents.kTouchMove, onScrollerTouchMove)
	self:removeEventListener(DisplayEvents.kTouchEnd, onScrollerTouchEnd)

	-- ---------------
	-- Start Auto Roll
	-- -----------------
	if not self.autoRollTimerId then
		self:startAutoRollTimer()
	end
end

-----------------------------------------------
----- Function About "Delay Stop Auto Scroll"
-----------------------------------------------

function WorldSceneScroller:startDelayStopAutoScroll(...)
	assert(#{...} == 0)

	-- -------------------------------
	-- Delay To Stop Previous Possile Auto Roll
	-- ----------------------------
	local animInterval = CCDirector:sharedDirector():getAnimationInterval()

	-- Delay
	local delay = CCDelayTime:create(animInterval * 3)

	-- Call Stop
	local function delayStopAutoScroll()

		if self:isAutoRollTimerRunning() then
			self:stopAutoRollTimer()
		end
	end
	local stopAutoScrollAction = CCCallFunc:create(delayStopAutoScroll)

	-- Seq
	local seq = CCSequence:createWithTwoActions(delay, stopAutoScrollAction)
	seq:setTag(WorldSceneScrollerActionTag.DELAY_STOP_SCROLL_ACTION)
	self:runAction(seq)
end

function WorldSceneScroller:stopDelayStopAutoScroll(...)
	assert(#{...} == 0)

	---------------------------
	-- Stop "Delay To Stop Auto Scroll Action"
	-- -----------------------------------------
	self:stopActionByTag(WorldSceneScrollerActionTag.DELAY_STOP_SCROLL_ACTION)
end
----------------------------------------------------

function WorldSceneScroller:onScrollerTouchBegin(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchBegin)
	assert(#{...} == 0)

	self:startDelayStopAutoScroll()

	-- Check If Scrollable
	if self.scrollable == false then
		return 
	end
	
	self.clicked	= true

	-- Init Variable For
	-- Recording Finger Position When Touch,Move
	self.fingerPreviousPositionY	= event.globalPosition.y
	self.fingerPositionY		= event.globalPosition.y

	-- Add Event Listener
	self:addEventListener(DisplayEvents.kTouchMove, onScrollerTouchMove, self)
	self:addEventListener(DisplayEvents.kTouchEnd, onScrollerTouchEnd, self)

	---- ------------------------------
	---- Calculate Velocity
	---- ------------------------------
	for k,measurer in ipairs(self.velocityMeasurerArray) do
		measurer:setInitialPos(0, self.fingerPositionY)
		measurer:startMeasure()
	end
end

function WorldSceneScroller:getMaxMaskedLayerY(...)
	assert(#{...} == 0)

	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	return visibleOrigin.y - self.belowScrollRangeY
end

function WorldSceneScroller:getMinMaskedLayerY(...)
	assert(#{...} == 0)

	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	return -(self.topScrollRangeY - self.visibleSize.height - visibleOrigin.y)
end

function WorldSceneScroller:checkSceneOutRange(testMaskedLayerY, ...)
	assert(#{...} == 0)

	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()

	local maskedLayerY = false

	if testMaskedLayerY then
		maskedLayerY	= testMaskedLayerY
	else
		maskedLayerY	= self.maskedLayer:getPositionY()
	end

	if maskedLayerY < visibleOrigin.y - self.belowScrollRangeY and maskedLayerY > visibleOrigin.y -(self.topScrollRangeY - self.visibleSize.height) then
		return CheckSceneOutRangeConstant.IN_RANGE
	end

	if maskedLayerY > visibleOrigin.y -self.belowScrollRangeY then
		return CheckSceneOutRangeConstant.TOP_OUT_OF_RANGE

	elseif maskedLayerY < visibleOrigin.y -(self.topScrollRangeY - self.visibleSize.height) then

		return CheckSceneOutRangeConstant.BOTTOM_OUT_OF_RANGE
	end

	return CheckSceneOutRangeConstant.IN_RANGE
end

---------------------------------------------------
-------  Auto Roll
--------------------------------------------------

function WorldSceneScroller:startAutoRollTimer(...)
	assert(#{...} == 0)

	local scheduler = CCDirector:sharedDirector():getScheduler()

	local function autoRollTimer()
		self:autoRollTimer()
	end

	-- Initially Call autoRollTimer Manually
	-- After self.autoScrollTimerInterval The Scheduler Then Call It
	assert(not self.autoRollTimerId)
	self.autoRollTimerId = scheduler:scheduleScriptFunc(autoRollTimer, self.autoScrollTimerInterval, false)
	autoRollTimer()
end

function WorldSceneScroller:setTopScrollRange(topScrollRangeY, ...)
	assert(type(topScrollRangeY) == "number")
	assert(#{...} == 0)

	self.topScrollRangeY = topScrollRangeY
end

if __WP8 then -- wp8不能显示所有好友

function WorldSceneScroller:checkFriendVisible()
	if self.friendPictureLayer and self.maskedLayer then
		local maskedLayerPositionY = self.maskedLayer:getPositionY()
		local _childs = self.friendPictureLayer:getChildrenList()
		if _childs then
			if not self.visibleSize then
				self.visibleSize = CCDirector:sharedDirector():getVisibleSize()
			end
			if not self.visibleOrigin then
				self.visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
			end
			for i, v in ipairs(_childs) do
				if v then
					local childPositionY = maskedLayerPositionY + v:getPositionY()
					local canShow = childPositionY > self.visibleOrigin.y and childPositionY < self.visibleOrigin.y + self.visibleSize.height
					if canShow and not v:isVisible() then
						v:setVisible(true)
					elseif not canShow and v:isVisible() then
						v:setVisible(false)
					end
				end
			end
		end
	end
end

end

function WorldSceneScroller:stopAutoRollTimer(...)
	assert(#{...} == 0)

	-- Stop
	local scheduler = CCDirector:sharedDirector():getScheduler()

	if self.autoRollTimerId then
		-- Stop All AUTO_ROLL_ACTION
		local autoRollAction = self.maskedLayer:getActionByTag(WorldSceneScrollerActionTag.AUTO_ROLL_ACTION)
		while autoRollAction ~= nil do
			self.maskedLayer:stopAction(autoRollAction)
			autoRollAction = self.maskedLayer:getActionByTag(WorldSceneScrollerActionTag.AUTO_ROLL_ACTION)
		end

		scheduler:unscheduleScriptEntry(self.autoRollTimerId)
		self.autoRollTimerId = nil

		if __WP8 and not self.stopRollByTouchMove then self:checkFriendVisible() end
	end

	-- Dispatch Event
	if self.movingStartedFlag then
		self.movingStartedFlag	= false
		self:dispatchEvent(Event.new(WorldSceneScrollerEvents.MOVING_STOPPED))
	end

	if __WP8 then self.stopRollByTouchMove = false end
end

function WorldSceneScroller:isAutoRollTimerRunning(...)
	assert(#{...} == 0)

	if self.autoRollTimerId then
		return true
	end

	return false
end

function WorldSceneScroller:autoRollTimer(...)
	assert(#{...} == 0)

	local scenePositionState = self:checkSceneOutRange()

	if CheckSceneOutRangeConstant.IN_RANGE == scenePositionState then

		if self.scrollable == false then
			self:stopAutoRollTimer()
			return
		end

		-- If Velocity == 0, Stop Auto Roll
		if self.velocity == 0 then
			self:stopAutoRollTimer()
			return
		end

		-- Slow Down self.velocity 
		-- Until To Zero
		--local deltaVelocity = self.velocitySlowdownAcceleration * self.autoScrollTimerInterval
		local nextVelocity = math.abs(self.velocity) * self.velocitySlowdownRatio

		if nextVelocity < self.velocityThreshold then
			nextVelocity = 0
		end

		if self.velocity < 0 then
			self.velocity = -nextVelocity
		else
			self.velocity = nextVelocity
		end

		local deltaY	= self.velocity * self.autoScrollTimerInterval

		local maskedLayerPosition	= self.maskedLayer:getPosition()
		local maskedLayerPositionX	= maskedLayerPosition.x
		local maskedLayerPositionY	= maskedLayerPosition.y

		local newPositionY = maskedLayerPositionY + deltaY

		------------------------------------------------------------------
		-- Below Ensure Not Exceed The Region, When Auto Scroll Is Too Fast
		-- -----------------------------------------------------------------

		local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
		if newPositionY > visibleOrigin.y then
			newPositionY = visibleOrigin.y
		end


		-- Note this Constance From sinFunction !!, Reform Needed
		local sinFunctionA = 150

		if newPositionY < visibleOrigin.y - self.topScrollRangeY - sinFunctionA  then
			newPositionY = visibleOrigin.y - self.topScrollRangeY - sinFunctionA
		end

		local previousAction = self.maskedLayer:getActionByTag(WorldSceneScrollerActionTag.AUTO_ROLL_ACTION)
		if previousAction then
			self.maskedLayer:stopAction(previousAction)
		end

		self:dispatchMoveToPercentageEvent()

		-- Move To Action
		local moveToAction	= CCMoveTo:create(self.autoScrollTimerInterval, ccp(maskedLayerPositionX, newPositionY))

		-- Dispatch Event Action
		local function moveToCallback()
			self:dispatchMoveToPercentageEvent()
		end
		local callFunc		= CCCallFunc:create(moveToCallback)

		local sequenceAction	= CCSequence:createWithTwoActions(callFunc, moveToAction)

		sequenceAction:setTag(WorldSceneScrollerActionTag.AUTO_ROLL_ACTION)
		self.maskedLayer:runAction(sequenceAction)

	elseif CheckSceneOutRangeConstant.TOP_OUT_OF_RANGE == scenePositionState or
		CheckSceneOutRangeConstant.BOTTOM_OUT_OF_RANGE == scenePositionState then

		self:stopAutoRollTimer()
		-- Start Restore
		self:outRangeRestore()
	else 
		assert(false)
	end
end

-----------------------------------------------------------
------------ When Out Of Range Restore
------------------------------------------------------
function WorldSceneScroller:outRangeRestore(...)
	assert(#{...} == 0)

	local newPositionY 	= false
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()

	local scenePositionState = self:checkSceneOutRange()
	if scenePositionState == CheckSceneOutRangeConstant.TOP_OUT_OF_RANGE then

		newPositionY = visibleOrigin.y - self.belowScrollRangeY
	elseif scenePositionState == CheckSceneOutRangeConstant.BOTTOM_OUT_OF_RANGE then

		newPositionY = visibleOrigin.y - (self.topScrollRangeY - self.visibleSize.height)
	else 
		assert(false, "Call WorldSceneScroller:outRangeRestore In Proper Situation !")
	end

	self.maskedLayer:stopAllActions()
	local moveToAction	= CCMoveTo:create(0.2, ccp(0,newPositionY))
	local easeOutAction	= CCEaseOut:create(moveToAction, 1)

	local function callBack()
		self:dispatchMoveToPercentageEvent()
	end
	local callFuncAction	= CCCallFunc:create(callBack)

	local sequenceAction	= CCSequence:createWithTwoActions(easeOutAction, callFuncAction)
	self.maskedLayer:runAction(sequenceAction)
end

---------------------------------------
------- About MOVE_TO_PERCENTAGE Event
-------------------------------------------

function WorldSceneScroller:dispatchMoveToPercentageEvent(...)
	assert(#{...} == 0)

	local positionY		= self.maskedLayer:getPositionY()

	local scrollHeight	= self.topScrollRangeY - self.belowScrollRangeY - self.visibleSize.height
	local deltaHeight	= positionY + self.belowScrollRangeY

	local percentage	= - deltaHeight / scrollHeight

	self:dispatchEvent(Event.new(WorldSceneScrollerEvents.MOVE_TO_PERCENTAGE, percentage, self))
end

-----------------------------------------------------
--------------- Scrollable
---------------------------------------------------


function WorldSceneScroller:setScrollable(scrollable, ...)
	assert(scrollable ~= nil)
	assert(type(scrollable) == "boolean")
	assert(#{...} == 0)

	self.scrollable = scrollable
end

function WorldSceneScroller:isScrollable(...)
	assert(#{...} == 0)

	return self.scrollable
end

function WorldSceneScroller:verticalScrollTo(newPositionY, callback)
	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local centerYInScreen = visibleOrigin.y + visibleSize.height / 2

	local config = UIConfigManager:sharedInstance():getConfig()
	local topLevelBelowScreenCenter = config.worldScene_topLevelBelowScreenCenter

	local newMaskedLayerPosY = centerYInScreen - topLevelBelowScreenCenter - newPositionY
	local newMaskedLayerPosX = self.maskedLayer:getPositionX()

	local startPosY = self.maskedLayer:getPositionY()
	local destPosY = newMaskedLayerPosY

	local max = self:getMinMaskedLayerY()
	local deltaLength = -(destPosY - startPosY)
	local percent = math.abs(deltaLength/max)
	--local percent = self.testPercent or 0
	local time = 12 * percent  --deltaLength / linearVelocity

	local minTime = 0.3
	if time > 1.8 then time = 1.8 end
	if time < minTime then time = minTime end

	local moveTo = CCMoveTo:create(time, ccp(newMaskedLayerPosX, newMaskedLayerPosY))
	local ease = moveTo
	if time <= minTime then
		ease = CCEaseSineOut:create(moveTo)
	elseif time > minTime and time < 0.65 then
		ease = CCEaseOut:create(moveTo, 2)
	else
		ease = CCEaseExponentialOut:create(moveTo)
	end

	if __WP8 then
		local oldcallback = callback
		callback = function()
			if oldcallback then oldcallback() end
			self:checkFriendVisible()
		end
	end

	local array = CCArray:create()
	array:addObject(ease)
	array:addObject(CCCallFunc:create(callback))
	self.maskedLayer:runAction(CCSequence:create(array))
end

--------------------------------------------
--------- Scroll Left Right
-----------------------------------------

------------------------------------------
-- offsetX : offset from origin x
------------------------------------------
function WorldSceneScroller:horizontalScrollTo(offsetX)
	self.maskedLayer:setPositionX(self.visibleOrigin.x + offsetX)
end

function WorldSceneScroller:horizontalAutoFitScroll()
	if self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_LEFT then
		if self.maskedLayer:getPositionX() < (self.visibleOrigin.x + self:getHorizontalScrollRange()) * 4 / 5 then
			self:scrollToOrigin()
		else
			self:scrollToLeft()
		end
	elseif self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_RIGHT then
		if self.maskedLayer:getPositionX() > (self.visibleOrigin.x - self:getHorizontalScrollRange()) * 4 / 5 then
			self:scrollToOrigin()
		else
			self:scrollToRight()
		end
	end
end

function WorldSceneScroller:getHorizontalScrollRange()
	if not self.scrollHorizontalRange then
		self.scrollHorizontalRange = self.visibleSize.width / 2
	end
	return self.scrollHorizontalRange
end

function WorldSceneScroller:scrollToRight(...)
	assert(#{...} == 0)

	self.scrollHorizontalState = WorldSceneScrollerHorizontalState.SCROLLING_TO_RIGHT

	self:setScrollable(false)

	local newPositionX	= self.visibleOrigin.x - self:getHorizontalScrollRange()
	local newPositionY	= self.maskedLayer:getPositionY()
	local time = math.abs(math.abs(self.maskedLayer:getPositionX()) - math.abs(newPositionX)) / math.abs(newPositionX) * self.horizontalScrollMaxTime

	local moveTo	= CCMoveTo:create(time, ccp(newPositionX, newPositionY))

	-- Call BackUp , Dispatch Event
	local function onScrolledToRight()
		assert(self.scrollHorizontalState == WorldSceneScrollerHorizontalState.SCROLLING_TO_RIGHT)
		self.scrollHorizontalState = WorldSceneScrollerHorizontalState.STAY_IN_RIGHT
		self:setTouchEnabled(true)

		self:dispatchEvent(Event.new(WorldSceneScrollerEvents.SCROLLED_TO_RIGHT))
	end
	local callFunc	= CCCallFunc:create(onScrolledToRight)

	-- Sequence
	local sequence	= CCSequence:createWithTwoActions(moveTo, callFunc)
	self:setTouchEnabled(false)

	self.maskedLayer:runAction(sequence)
end


function WorldSceneScroller:scrollToLeft(...)
	assert(#{...} == 0)

	self.scrollHorizontalState = WorldSceneScrollerHorizontalState.SCROLLING_TO_LEFT

	self:setScrollable(false)

	local newPositionX	= self.visibleOrigin.x + self:getHorizontalScrollRange()
	local newPositionY	= self.maskedLayer:getPositionY()

	-- Move To
	local time = math.abs(math.abs(self.maskedLayer:getPositionX()) - math.abs(newPositionX)) / math.abs(newPositionX) * self.horizontalScrollMaxTime
	local moveTo	= CCMoveTo:create(time, ccp(newPositionX, newPositionY))

	-- Call BackUp , Dispatch Event
	local function onScrolledToLeft()
		assert(self.scrollHorizontalState == WorldSceneScrollerHorizontalState.SCROLLING_TO_LEFT)
		self.scrollHorizontalState = WorldSceneScrollerHorizontalState.STAY_IN_LEFT
		self:setTouchEnabled(true)
		self:dispatchEvent(Event.new(WorldSceneScrollerEvents.SCROLLED_TO_LEFT))
	end
	local callFunc	= CCCallFunc:create(onScrolledToLeft)

	-- Sequence
	local sequence	= CCSequence:createWithTwoActions(moveTo, callFunc)

	self.maskedLayer:runAction(sequence)
	self:setTouchEnabled(false)
end

function WorldSceneScroller:scrollToOrigin(...)
	assert(#{...} == 0)

	assert(self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_LEFT or
		self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_RIGHT)

	self.scrollHorizontalState = WorldSceneScrollerHorizontalState.SCROLLING_TO_ORIGIN

	local newPositionX	= self.visibleOrigin.x
	local newPositionY	= self.maskedLayer:getPositionY()

	local time = math.abs(self.maskedLayer:getPositionX()) / math.abs(self.visibleSize.width / 2) * self.horizontalScrollMaxTime
	local moveTo	= CCMoveTo:create(time, ccp(newPositionX, newPositionY))

	-- Call BackUp , Dispatch Event , Set self.scrollable True
	local function onScrolledToOrigin()
		assert(self.scrollHorizontalState == WorldSceneScrollerHorizontalState.SCROLLING_TO_ORIGIN)
		self.scrollHorizontalState = WorldSceneScrollerHorizontalState.STAY_IN_ORIGIN
		self:setScrollable(true)
		self:setTouchEnabled(true)
		self:dispatchEvent(Event.new(WorldSceneScrollerEvents.SCROLLED_TO_ORIGIN))

		if __WP8 then self:checkFriendVisible() end
	end
	local callFunc	= CCCallFunc:create(onScrolledToOrigin)

	-- Sequence
	local sequence	= CCSequence:createWithTwoActions(moveTo, callFunc)
	self.maskedLayer:runAction(sequence)
	self:setTouchEnabled(false)
end

---------------------------------
---- Evnet Handler
----------------------------------

he_log_warning("??")

--Abstract method, implements in concrete class - WorldScene
function WorldSceneScroller:onScrolledToLeftOrRight(event, ...)
end

function WorldSceneScroller:onScrolledToOrigin(event, ...)
end
