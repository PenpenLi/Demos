require "hecore.EventDispatcher"

TurnTable = class(EventDispatcher)

TurnTableEvents = {
	kTouchStart = "TurnTableEvents.kTouchStart",
	kTouchEnd = "TurnTableEvents.kTouchEnd",
	kAnimStart = "TurnTableEvents.kAnimStart",
	kAnimFinish = "TurnTableEvents.kAnimFinish",
	kTouchSlow = "TurnTableEvents.kTouchSlow",
}

function TurnTable:create(ui)
	local ret = TurnTable.new()
	ret:_init(ui)
	return ret
end

function TurnTable:_init(ui)
	self.target = 0
	self.range = 0
	self.ui = ui
	local function onEnterHandler(event) self:onEnterHandler(event) end
	ui:registerScriptHandler(onEnterHandler)
	ui:addEventListener(DisplayEvents.kTouchBegin, function(evt) self:onTouchBegin(evt) end)
	ui:addEventListener(DisplayEvents.kTouchMove, function(evt) self:onTouchMove(evt) end)
	ui:addEventListener(DisplayEvents.kTouchEnd, function(evt) self:onTouchEnd(evt) end)
end

function TurnTable:setTargetAngle(target, range)
	self.target, self.range = -target, range
end

function TurnTable:onEnterHandler(event)
	print("TurnTable:onEnterHandler", event)
	if event == "enter" then
		if GameGuide then
			GameGuide:sharedInstance():onTurnTableEnabled(self.ui:getParent(), self, self.ui:isTouchEnabled())
		end
	elseif event == "exit" then
		if GameGuide then
			GameGuide:sharedInstance():onTurnTableEnabled(self.ui:getParent(), self, false)
		end
	end
end

function TurnTable:setEnabled(enabled)
	self.ui:setTouchEnabled(enabled)
	local scene = Director:sharedDirector():getRunningScene()
	if not scene then return end
	local parent = self.ui:getParent()
	while parent:getParent() do parent = parent:getParent() end
	if parent ~= scene then return end
	if GameGuide then
		GameGuide:sharedInstance():onTurnTableEnabled(self.ui:getParent(), self, enabled)
	end
end

function TurnTable:onTouchBegin(evt)
	self.ui:stopAllActions()
	local pos = self.ui:getParent():convertToWorldSpace(ccp(self.ui:getPositionX(), self.ui:getPositionY()))
	self.posX, self.posY = pos.x, pos.y
	local angle = math.atan((evt.globalPosition.x - self.posX) / (evt.globalPosition.y - self.posY))
	local distance = ccpDistance(ccp(self.posX, self.posY), evt.globalPosition)
	if ((evt.globalPosition.y - self.posY) / distance) < 0 then angle = angle + math.pi end
	local rotation = self.ui:getRotation()
	while rotation < -90 or rotation > 270 do
		if rotation > 270 then rotation = rotation - 360
		else rotation = rotation + 360 end
	end
	self.startRotation = angle * 180 / math.pi - rotation
	self.rotationRec = {}
	self.lastRotation = rotation
	self:dispatchEvent(Event.new(TurnTableEvents.kTouchStart, {}, self))
end

function TurnTable:onTouchMove(evt)
	local angle = math.atan((evt.globalPosition.x - self.posX) / (evt.globalPosition.y - self.posY))
	local distance = ccpDistance(ccp(self.posX, self.posY), evt.globalPosition)
	if ((evt.globalPosition.y - self.posY) / distance) < 0 then angle = angle + math.pi end
	self.ui:setRotation(angle * 180 / math.pi - self.startRotation)
	if #self.rotationRec >= 10 then table.remove(self.rotationRec, 1) end
	local rotation = self.ui:getRotation()
	while rotation < -90 or rotation > 270 do
		if rotation > 270 then rotation = rotation - 360
		else rotation = rotation + 360 end
	end
	table.insert(self.rotationRec, rotation - self.lastRotation)
	self.lastRotation = rotation
	if self.schedule then Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedule) end
	local function onTimeOut() self.rotationRec = {} end
	self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeOut, 0.1, false)
end

function TurnTable:onTouchEnd(evt)
	if self.schedule then Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedule) end
	local angle = math.atan((evt.globalPosition.x - self.posX) / (evt.globalPosition.y - self.posY))
	local distance = ccpDistance(ccp(self.posX, self.posY), evt.globalPosition)
	if ((evt.globalPosition.y - self.posY) / distance) < 0 then angle = angle + math.pi end
	self.ui:setRotation(angle * 180 / math.pi - self.startRotation)
	local sum = 0
	for k, v in ipairs(self.rotationRec) do
		local rotation = v
		if rotation > 180 then rotation = rotation - 360
		elseif rotation < -180 then rotation = rotation + 360 end
		sum = sum + rotation
	end
	local rotation = self.ui:getRotation()
	while rotation < -90 or rotation > 270 do
		if rotation > 270 then rotation = rotation - 360
		else rotation = rotation + 360 end
	end
	self:dispatchEvent(Event.new(TurnTableEvents.kTouchEnd, {}, self))
	sum = sum + rotation - self.lastRotation
	sum = sum / (#self.rotationRec + 1)
	print("sum", sum)
	if math.abs(sum) > 7 then
		if sum > 0 then sum = 7
		elseif sum < -7 then sum = -7 end
	end
	if math.abs(sum) > 1.5 then
		self:dispatchEvent(Event.new(TurnTableEvents.kAnimStart, {}, self))
		self:calcStopping(sum)
	else
		-- self:notCalcStopping(sum)
		self:dispatchEvent(Event.new(TurnTableEvents.kTouchSlow, {}, self))
	end
end

function TurnTable:notCalcStopping(sumSpeed)
	self.ui:runAction(CCEaseSineOut:create(CCRotateBy:create(math.abs(sumSpeed) / 5, sumSpeed * 50)))
end

function TurnTable:calcStopping(sumSpeed)
	local arr = CCArray:create()
	local finalTarget = self.target + math.random() * self.range - self.range / 2
	sumSpeed = sumSpeed * 100
	if sumSpeed == 0 then return end
	local rotation = self.ui:getRotation()
	while rotation < -90 or rotation > 270 do
		if rotation > 270 then rotation = rotation - 360
		else rotation = rotation + 360 end
	end
	local target = 0
	if sumSpeed >= 0 then
		if rotation >= 0 then target = finalTarget + 360
		else target = finalTarget - 720 end
	elseif sumSpeed < 0 then
		if rotation >= 0 then target = finalTarget - 360
		else target = finalTarget - 720 end
	end
	local firstTime = (target - rotation) / sumSpeed
	arr:addObject(CCRotateBy:create(firstTime, (target - rotation)))
	local lastCount = math.floor(math.abs(sumSpeed) / 100 / 1.5)
	local lastTarget = 360
	local lastTime = lastTarget * lastCount / math.abs(sumSpeed / 2)
	if sumSpeed < 0 then lastTarget = -360 end
	arr:addObject(CCEaseSineOut:create(CCRotateBy:create(lastTime, lastTarget * lastCount)))
	local function onFinish()
		self:dispatchEvent(Event.new(TurnTableEvents.kAnimFinish, {}, self))
	end
	arr:addObject(CCCallFunc:create(onFinish))
	self.ui:runAction(CCSequence:create(arr))
end

function TurnTable:getDiskPosition()
	return self.ui:getPosition()
end

function TurnTable:getDiskRadius()
	local quater = self.ui:getChildByName("quater1")
	local size = quater:getContentSize()
	return size.height
end

function TurnTable:getDiskRes()
	return self.ui
end