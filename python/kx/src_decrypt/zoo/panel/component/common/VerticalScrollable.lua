-------------------------------------------------------
-- This class intends to decribe a container with scrolling ability.

require 'zoo.scenes.component.HomeScene.WorldSceneScroller'

ScrollableEvents = {
	kEndMoving = "endMoving",
	kStartMoving = "startMoving" 
}

VerticalScrollable = class(Layer)

function VerticalScrollable:create(width, height, useClipping, useBlockingLayers)
	local instance = VerticalScrollable.new()
	instance:init(width, height, useClipping, useBlockingLayers)
	return instance
end

function VerticalScrollable:ctor()
	Layer.initLayer(self)
	self.name = 'VerticalScrollable'
	-- self.debugTag = 1
end

function VerticalScrollable:init(width, height, useClipping, useBlockingLayers)

	if useClipping == nil then 
		useClipping = true
	end
	if useBlockingLayers == nil then 
		useBlockingLayers = true
	end


	self:ignoreAnchorPointForPosition(true)
	self:setAnchorPoint(ccp(0, 1))

	self.width = width
	self.height = height
	self.bottomMostOffset = 0
	self.topMostOffset = 0
	self.yOffset = 0

	local rect = {size = {width = self.width, height = self.height}}
-- fix issue: nested or stacked clipping node doesn't work properly
	local clipping = nil
if useClipping then 
	clipping = ClippingNode:create(rect)
else
	clipping = LayerColor:create()
	clipping:setColor(ccc3(22,22,22))
	clipping:setOpacity(0)
	clipping:setContentSize(CCSizeMake(rect.size.width, rect.size.height))
end
-- end of fix
	clipping.name = 'VerticalScrollable.clipping'
	-- clipping.debugTag = 1

	-- clipping:setAnchorPoint(ccp(0, 1))

	local topBlocking = nil
	local bottomBlocking = nil
if useBlockingLayers then
	topBlocking = LayerColor:create()
	topBlocking:setColor(ccc3(255, 0, 0))
	topBlocking:setOpacity(0)
	topBlocking.name = 'VerticalScrollable.topBlocking'
	-- topBlocking.debugTag = 1

	bottomBlocking = LayerColor:create()
	bottomBlocking:setColor(ccc3(0, 20, 0))
	bottomBlocking:setOpacity(0)
	bottomBlocking.name = 'VerticalScrollable.bottomBlocking'
	-- bottomBlocking.debugTag = 1
end

	local touchLayer = LayerColor:create()
	touchLayer:setColor(ccc3(0, 0, 255))
	touchLayer:setOpacity(0)
	touchLayer.name = 'VerticalScrollable.touchLayer'
	-- touchLayer.debugTag = 1

	-- using a zero-sized node to simulate a cursor,
	-- so that the child will be placed at (0,0)
	-- and later the cordinates (x, y) will always
	-- be greater than zero(this is more practical, isn't it?)
	-- the cursor won't move
	local cursor = Layer:create()
	cursor.name = 'VerticalScrollable.cursor'
	-- cursor.debugTag = 1

	-- using a zero-sized node to simalute a container with
	-- its anchor point set to (0, 1)
	-- thus later when move the container, the yOffset is equal to 
	-- this container's Y cordinate.
	local container = LayerColor:create()
	container.name = 'VerticalScrollable.container'
	-- container.debugTag = 1

	container:setPosition(ccp(0, 0))
	container:setOpacity(0)
	cursor:addChild(container)
	cursor:setPosition(ccp(0, self.height))
	self.cursor = cursor

if useBlockingLayers then
	topBlocking:setContentSize(CCSizeMake(self.width, 500))
	topBlocking:setPosition(ccp(0,self.height))
	topBlocking:setTouchEnabled(true, 1, true)
	topBlocking:ad(DisplayEvents.kTouchTap, function() print('topBlocking') end)

	bottomBlocking:setContentSize(CCSizeMake(self.width, 500))
	bottomBlocking:setPosition(ccp(0, -(500)))
	bottomBlocking:setTouchEnabled(true, 1, true)
	bottomBlocking:ad(DisplayEvents.kTouchTap, function() print('bottomBlocking') end)
end

	touchLayer:setContentSize(CCSizeMake(self.width, self.height))
	touchLayer:setTouchEnabled(true, 0, false)
	touchLayer:setPosition(ccp(0, -self.height))
	touchLayer:ad(DisplayEvents.kTouchBegin, function(event) self:onTouchBegin(event) end)
	touchLayer:ad(DisplayEvents.kTouchMove, function(event) self:onTouchMove(event) end)
	touchLayer:ad(DisplayEvents.kTouchEnd, function(event) self:onTouchEnd(event) end)

if useBlockingLayers then 
	clipping:addChild(topBlocking)
	clipping:addChild(bottomBlocking)
end

	clipping:addChild(cursor)
	clipping:setPosition(ccp(0, -self.height))

	self.topBlocking = topBlocking
	self.bottomBlocking = bottomBlocking
	self.touchLayer = touchLayer
	self.clipping = clipping

	-- topBlocking.debugTag = 1
	-- bottomBlocking.debugTag = 1
	-- touchLayer.debugTag = 1
	-- clipping.debugTag = 1
	-- cursor.debugTag = 1
	-- container.debugTag = 1

	self:addChild(clipping)
	self:addChild(touchLayer)

	self.clipping = clipping
	self.touchLayer = touchLayer
	self.container = container

	self.last_x = 0
	self.last_y = 0
	------------------- SPEEDOMETER -----------------
	local function __getPosition()
		return ccp(self.last_x, self.last_y)
	end

	-- self.speedwatch = TouchMoveVelocity:create()

	self.speedometers = {}
	self.speedometers[1] = VelocityMeasurer:create(6/60, __getPosition) -- take meature every x frames
	-- self.speedometers[2] = VelocityMeasurer:create(6/60, __getPosition)
end

function VerticalScrollable:setScrollEnabled(enabled)
	self.touchLayer:setTouchEnabled(enabled, 0, false)
end

function VerticalScrollable:setScrollableHeight(height)
	if height - self.height > 0 then
		self.topMostOffset = height - self.height
	else 
		self.topMostOffset = self.bottomMostOffset
	end

end

-- set to false will do:
-- if the finger start with vertical movements,
-- we'll recongnize it as a vertical gesture, and thus
-- even if there is horizontal move, we ignore any further movements
function VerticalScrollable:setIgnoreHorizontalMove(ignore)
	self.ignoreHorizontalMove = ignore
end

-- defaultly, we ignore vertical movements
-- means: what ever the gesture is, we capture its X diffs
function VerticalScrollable:isIgnoreHorizontalMove()
	if self.ignoreHorizontalMove ~= nil then
		return self.ignoreHorizontalMove
	else 
		return true
	end
end

function VerticalScrollable:checkMoveStarted(x, y)
	local distance = ccpDistance(ccp(self.moveStartX, self.moveStartY), ccp(x, y))
	local threshold = 15
	-- if already started, we dont check any more
	if self.scrollDirection ~= ScrollDirection.kNone then return true end
	-- while distance is too short, return false
	if distance < threshold then return false end

	local dx = math.abs(self.moveStartX - x)
	local dy = math.abs(self.moveStartY - y)
	if dy > dx then 
		self.scrollDirection = ScrollDirection.kVertical
		return true
	else
		self.scrollDirection = ScrollDirection.kHorizontal
		return true
	end
end

function VerticalScrollable:getScrollDirection()
	return self.scrollDirection or ScrollDirection.kNone
end

function VerticalScrollable:onTouchBegin(event)
	print 'on touch begin'

	self.scrollDirection = ScrollDirection.kNone
	self:stopSlide()
	self:onEndMoving()

	self.last_y = event.globalPosition.y
	self.last_x = event.globalPosition.x

	-- self.speedwatch:onTouchBegin(0, self.last_y)

	self.moveStartX = event.globalPosition.x
	self.moveStartY = event.globalPosition.y
	for k, v in pairs(self.speedometers) do
		v:setInitialPos(self.last_x, self.last_y) 
		v:startMeasure()
	end
end

function VerticalScrollable:onTouchMove(event)
	local y = event.globalPosition.y
	local x = event.globalPosition.x

	if not self:isIgnoreHorizontalMove() then
		-- if move not started, or if horizontal move, then return
		if not self:checkMoveStarted(x, y) 
			or self:getScrollDirection() ~= ScrollDirection.kVertical 
		then 
			return 
		end
	end
	
	-- self.speedwatch:onTouchMove(0, self.last_y)
	self.speedometers[1]:setXY(0, y)
	if self.last_y == 0 then self.last_y = y end
	local dy = y - self.last_y
	local tarOffset = self.yOffset + dy

	if tarOffset >= self.bottomMostOffset and tarOffset <= self.topMostOffset then
		self:__moveTo(tarOffset)
	elseif tarOffset > self.topMostOffset or tarOffset < self.bottomMostOffset then
		self:__moveTo(tarOffset - dy / 2)
	end
	self.last_y = y
	self:updateContentViewArea()
end

function VerticalScrollable:onTouchEnd(event)
	-- print 'on touch end'
	-- top out of border
	self.last_y = event.globalPosition.y
	self.last_x = event.globalPosition.x

	if not self:isIgnoreHorizontalMove() then
		-- if move not started, or if horizontal move, then return
		if not self:checkMoveStarted(self.last_x, self.last_y) 
			or self:getScrollDirection() ~= ScrollDirection.kVertical 
		then 
			return 
		end
	end

	-- self.speedwatch:onTouchEnd(0, self.last_y)
	for i, v in ipairs(self.speedometers) do
		v:stopMeasure()
	end

	self.yOffset = self.container:getPositionY()


	local speed = self:getSwipeSpeed()
	
	if self.yOffset > self.topMostOffset then
		self:__moveTo(self.topMostOffset, 0.3)
	--bottom out of border
	elseif self.yOffset < self.bottomMostOffset then 
		self:__moveTo(self.bottomMostOffset, 0.3)
	elseif speed ~= 0 then
		self:slide(speed)
	end
	self:updateContentViewArea()
end

function VerticalScrollable:getSwipeSpeed()
	-- local speedx, speedy = self.speedwatch:getVelocityXY()
	local speedy = self.speedometers[1]:getMeasuredVelocityY()
	print ('speedy ', speedy)

	if speedy > 30 or speedy < -30
	then
		return speedy
	else 
		return 0
	end
end

function VerticalScrollable:stopSlide()
	self.container:stopAllActions()
	if self.schedId ~= nil then
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedId)
		self.schedId = nil
	end
end

function VerticalScrollable:slide(speed)

	local scheduler = Director:sharedDirector():getScheduler()
	local resistance = 500
	local duration = math.abs(speed / resistance)
	local distance = speed / resistance * 1500

	local function __unschdule()
		print ('__unschdule')
		if self.schedId ~= nil then
			scheduler:unscheduleScriptEntry(self.schedId)
			self.schedId = nil
		end
	end

	local action = CCSequence:createWithTwoActions(
	                CCEaseExponentialOut:create(
	                 CCMoveBy:create(duration, ccp(0, distance))
	                 ),
	                CCCallFunc:create(__unschdule)
	              	)

	self.container:runAction(action)

	local function __check()
		print('__check')
		if not self.isDisposed then 
			self.yOffset = self.container:getPositionY()
			if self.yOffset > self.topMostOffset then

				self.container:stopAllActions()
				self:__moveTo(self.topMostOffset, 0.3)
				__unschdule()
			elseif self.yOffset < self.bottomMostOffset then

				self.container:stopAllActions()
				self:__moveTo(self.bottomMostOffset, 0.3)
				__unschdule()
			end
			self:updateContentViewArea()
		else 
			__unschdule()
		end
	end
	__unschdule()
	if self.schedId == nil then 
		self.schedId = scheduler:scheduleScriptFunc(__check, 1/60, false)
	end
end

function VerticalScrollable:__moveTo( Y_Position, duration )
	if not duration then
		duration = 0
	end

	local dY = Y_Position - self.yOffset

	if duration == 0 then 
		self.container:setPositionY(Y_Position)
	else
		self:onStartMoving()
		local moveAction = CCSequence:createWithTwoActions(
		                    CCEaseSineOut:create(CCMoveTo:create(duration, ccp(0, Y_Position))),
		                    CCCallFunc:create(function() self:onEndMoving() end)
		                    )
		self.container:runAction(moveAction)
	end

	self.yOffset = Y_Position
end

function VerticalScrollable:gotoPositionY(position)
	self.container:stopAllActions()
	self:__moveTo(position, 0.3)
end

function VerticalScrollable:getContent()
	return self.content
end

function VerticalScrollable:setContent(uiComponent)
	if not uiComponent then return end
	self:removeContent()
	self.content = uiComponent
	self.container:addChild(uiComponent)
	local height
	if type(uiComponent.getHeight) == "function" then
		height = uiComponent:getHeight()
	else
		height = uiComponent:getGroupBounds().size.height
	end
	-- print('content hei/\ght', height)
	self:setScrollableHeight(height)
	self:updateContentViewArea()
end

function VerticalScrollable:updateScrollableHeight()
	self:setScrollableHeight(self.content:getHeight())
	print("self.container.posY: ", self.container:getPositionY())
	print("content height: ", self.content:getHeight(), " self.height: ", self.height)

	if self.content:getHeight() < self.height then
		self:gotoPositionY(0)		
	else
		local maxTopOffset = self.content:getHeight() - self.height
		if self.container:getPositionY() > maxTopOffset then
			self:gotoPositionY(maxTopOffset)
		end
	end
end

function VerticalScrollable:removeContent()
	if self.content and self.content:getParent() then 
		self.content:removeFromParentAndCleanup(true)
		self.content = nil
	end
	self:setScrollableHeight(0)
end

-- implementation obliged: items use this function to 
-- test click Hit Point
function VerticalScrollable:getViewRectInWorldSpace()
	-- DO NOT use getGroupBounds() on clipping nodes, it does not work on clipping nodes
	-- use touchLayer instead to present the view area
	local size = self.touchLayer:getGroupBounds().size
	local origin = self.touchLayer:getPosition()
	local pos = self.touchLayer:getParent():convertToWorldSpace(ccp(origin.x, origin.y))
	self.clippingRect = CCRectMake(pos.x, pos.y, size.width, size.height)
	return self.clippingRect
end

-- To improve performance, the self.content property must implement
-- "updateViewArea" function, letting only items between the top and bottom 
-- be visible.
function VerticalScrollable:updateContentViewArea()
	if self.content and self.content.updateViewArea then
		local top = self.yOffset
		local bottom = self.yOffset + self.height
		self.content:updateViewArea(top, bottom)
	end
end

function VerticalScrollable:onStartMoving()
	-- print('VerticalScrollable:onStartMoving')
	local function __update()
		-- print('__update')
		self:updateContentViewArea()
	end
	if not self.updateSchedId then
		self.updateSchedId = Director:sharedDirector():getScheduler():scheduleScriptFunc(__update, 1/60, false)
	end
end

function VerticalScrollable:onEndMoving()
	print('VerticalScrollable:onEndMoving')
	self:dispatchEvent(Event.new(ScrollableEvents.kEndMoving, nil, self))
	if self.updateSchedId then 
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.updateSchedId)
		self.updateSchedId = nil
	end
end

function VerticalScrollable:dispose()
	-- print('VerticalScrollable:dispose()')
	if self.schedId ~= nil then
		-- print('unschedule1')
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedId)
		self.schedId = nil
	end
	if self.updateSchedId ~= nil then 
		-- print('unschedule2')
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.updateSchedId)
		self.updateSchedId = nil
	end
	Layer.dispose(self)
end

