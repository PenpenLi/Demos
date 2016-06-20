
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月 4日 13:30:45
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.baseUI.BaseUI"

---------------------------------------------------
-------------- MoveOrTimeCounter
---------------------------------------------------

assert(not MoveOrTimeCounterType)
MoveOrTimeCounterType = {
	MOVE_COUNT	= 1,
	TIME_COUNT	= 2
}

assert(not MoveOrTimeCounter)
assert(BaseUI)

MoveOrTimeCounter = class(BaseUI)

local function shakeObject( sprite, rotation )
	if sprite.isShaking then return false end

    sprite:stopAllActions()
    sprite:setRotation(0)

	sprite.isShaking = true

    local original = sprite.original
    if not original then
    	original = sprite:getPosition()
    	sprite.original = {x=original.x, y=original.y}
	end
    sprite:setPosition(ccp(original.x, original.y))

    local array = CCArray:create()
    local direction = 1
    if math.random() > 0.5 then direction = -1 end

    rotation = rotation or 4
    local startRotation = direction * (math.random() * 0.5 * rotation + rotation)
    local startTime = 0.35

    local function onShakeFinish()
    	sprite.isShaking = false
    end

    array:addObject(CCSpawn:createWithTwoActions(CCRotateTo:create(startTime*0.3, startRotation), CCMoveBy:create(0.05, ccp(0, 6))))
    array:addObject(CCSpawn:createWithTwoActions(CCRotateTo:create(startTime, -startRotation*2), CCMoveBy:create(0.05, ccp(0, -6))))
    array:addObject(CCRotateTo:create(startTime, startRotation * 1.5))
    array:addObject(CCRotateTo:create(startTime, -startRotation))
    array:addObject(CCRotateTo:create(startTime, startRotation))
    array:addObject(CCRotateTo:create(startTime, -startRotation*0.5))
    array:addObject(CCRotateTo:create(startTime, 0))
    array:addObject(CCCallFunc:create(onShakeFinish))

    sprite:runAction(CCSequence:create(array))
    return true
end
function MoveOrTimeCounter:shake()
	shakeObject(self, 2)
end

function MoveOrTimeCounter:stopShaking()
	if self.counterType == MoveOrTimeCounterType.TIME_COUNT 
			and not self.isShaking then
		return
	end
	self:stopAllActions()
	self:setRotation(0)
	self.isShaking = false
end

function MoveOrTimeCounter:init(panelStyle, levelId, counterType, count, ...)
	self.oldString = ''
	assert(type(levelId) == "number")
	assert(counterType == MoveOrTimeCounterType.MOVE_COUNT or counterType == MoveOrTimeCounterType.TIME_COUNT)
	assert(type(count) == "number")
	assert(#{...} == 0)

	-- Get UI Resource
	self.ui = ResourceManager:sharedInstance():buildGroup(panelStyle)
	assert(self.ui)
	local function onTouchBegin(evt) 
		self:shake()
	end
	local uisize = self.ui:getGroupBounds().size
	local uipos = self.ui:getPosition()
	self.ui:setPosition(ccp(uipos.x-uisize.width/2, uipos.y))
	self.ui:ad(DisplayEvents.kTouchBegin, onTouchBegin)
	self.ui:setTouchEnabled(true)

	-- Init Base Class
	BaseUI.init(self, self.ui)

	-- ----------------
	-- Get UI Resource
	-- -----------------
	self.msgLabel		= self.ui:getChildByName("msgLabel")

	assert(self.msgLabel)

	-- -------
	-- Data
	-- -------
	self.counterType	= counterType
	self.count		= count
	self.levelId		= levelId
	self.fntFile		= "fnt/steps_cd.fnt"

	-------------------
	-- Create UI Component
	-- --------------------
	
	-- Center MonospaceBMLabel
	self.label = false
	if self.counterType == MoveOrTimeCounterType.MOVE_COUNT then
		self.label	= LabelBMMonospaceFont:create(60, 70, 36, self.fntFile)
		self.label:setPositionY(-154 + 68)
	elseif self.counterType == MoveOrTimeCounterType.TIME_COUNT then
		self.label = LabelBMMonospaceFont:create(48, 48, 25, self.fntFile)
		self.label:setPositionY(-134 + 45 - 7)
	else
		assert(false)
	end

	self.ui:addChild(self.label)
	self.label:setAnchorPoint(ccp(0,1))

	-- -------------
	-- Update UI
	-- ------------

	if self.counterType == MoveOrTimeCounterType.MOVE_COUNT then
		if LevelMapManager:getInstance():getLevelGameMode(self.levelId) == GamePlayType.kRabbitWeekly then
			self:setStageNumber(1)
			self:setCount(self.count)
		else

			local msgLabelTxtKey 	= "move.or.time.counter.step.txt"
			local msgLabelTxtValue	= Localization:getInstance():getText(msgLabelTxtKey, {})
			self.msgLabel:setString(msgLabelTxtValue)
			self:setCount(self.count)
		end
	elseif self.counterType == MoveOrTimeCounterType.TIME_COUNT then

		local msgLabelTxtKey	= "move.or.time.counter.time.txt"
		local msgLabelTxtValue	= Localization:getInstance():getText(msgLabelTxtKey, {})
		self.msgLabel:setString(msgLabelTxtValue)

		self.label:setString("-:--")
		self.label:setToParentCenterHorizontal()
	end
end

function MoveOrTimeCounter:dispose()
	if self.ui then
		self.ui:rma()
		self.ui = nil
	end
	BaseUI.dispose(self)
end

function MoveOrTimeCounter:setCount(count, playAnim, ...)
	assert(count)
	assert(#{...} == 0)

	self.count	= math.floor(count)
	self:updateView(playAnim)
end

function MoveOrTimeCounter:setInfinite()
	self.label:setString("∞")
end

----------------------------------
---------- Update View
----------------------------------

function MoveOrTimeCounter:updateView(playAnim, ...)
	assert(#{...} == 0)

	if self.counterType == MoveOrTimeCounterType.MOVE_COUNT then
		self:updateCountMoveView(playAnim)
	elseif self.counterType == MoveOrTimeCounterType.TIME_COUNT then
		self:updateCountTimeView(playAnim)
	else 
		assert(false)
	end
end

function MoveOrTimeCounter:updateCountTimeView(playAnim, ...)
	assert(#{...} == 0)
	-- Treate self.count As Second 
	-- Convert It To Minute
	--
	local minute = math.floor(self.count / 60)
	local second	= self.count - minute * 60

	if second < 10 then
		second = "0" .. second
	end
	
	local minuteString = false
	
	self:animateString(tostring(minute) .. ":" .. tostring(second), playAnim)
end

function MoveOrTimeCounter:updateCountMoveView(playAnim, ...)
	assert(#{...} == 0)
	
	local shiwei 	= math.floor(self.count / 10)
	local gewei	= self.count - shiwei * 10
	
	self:animateString(tostring(self.count), playAnim)
end

function MoveOrTimeCounter:fadeOutLabel()
	if self.isDisposed then return end
	
	local beginTime, endTime = 0.15, 0.3
	
	local old = self.label:copyToCenterLayer()
	local function onAnimationFinish() 
		if self.isDisposed then return end
		old:removeFromParentAndCleanup(true) 
	end
	
	local removeArray = CCArray:create()
	removeArray:addObject(CCScaleTo:create(beginTime, 1.6))
	removeArray:addObject(CCScaleTo:create(endTime, 0))
	removeArray:addObject(CCCallFunc:create(onAnimationFinish))
	local oldIndex = self.ui:getChildIndex(self.label)
	self.ui:addChildAt(old, oldIndex)
	old:runAction(CCSequence:create(removeArray))

	local label = old:getChildByName("label")
	local charsLabel = label.charsLabel
	if charsLabel and #charsLabel > 0 then
		for i,v in ipairs(charsLabel) do
			v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(beginTime), CCFadeOut:create(endTime)))
		end
	end
end
function MoveOrTimeCounter:fadeInLabel(delayTime)
	if self.isDisposed then return end

	delayTime = delayTime or 0.2
	local endTime = 0.3
	
	local old = self.label:copyToCenterLayer()
	old:setScale(1.6)
	local function onAnimationFinish() 
		if self.isDisposed then return end
		self.label:setVisible(true)
		old:removeFromParentAndCleanup(true) 
	end

	local removeArray = CCArray:create()
	removeArray:addObject(CCDelayTime:create(delayTime))
	removeArray:addObject(CCScaleTo:create(endTime, 1))
	removeArray:addObject(CCCallFunc:create(onAnimationFinish))
	local oldIndex = self.ui:getChildIndex(self.label)

	self.ui:addChild(old)
	old:runAction(CCSequence:create(removeArray))

	local label = old:getChildByName("label")
	local charsLabel = label.charsLabel
	if charsLabel and #charsLabel > 0 then
		for i,v in ipairs(charsLabel) do
			v:setOpacity(0)
			v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime), CCFadeIn:create(endTime)))
		end
	end
end
function MoveOrTimeCounter:animateString( newString, animate )
	if self.isDisposed then return end
	
	local playAnimation = true
	if self.counterType == MoveOrTimeCounterType.TIME_COUNT then playAnimation = false end

	if playAnimation then self:fadeOutLabel() end
	self.label:setString(newString)
	if string.len(self.oldString) ~= string.len(newString) then
		self.label:setToParentCenterHorizontal()
	end
	self.oldString = newString
	if playAnimation then
		self:fadeInLabel()
		self.label:setVisible(false)
	end
end

function MoveOrTimeCounter:create(panelStyle, levelId, counterType, count, ...)
	assert(type(levelId) == "number")
	assert(counterType == MoveOrTimeCounterType.MOVE_COUNT or counterType == MoveOrTimeCounterType.TIME_COUNT)
	assert(type(count) == "number")
	assert(#{...} == 0)

	local newCounter = MoveOrTimeCounter.new()
	newCounter:init(panelStyle, levelId, counterType, count)
	return newCounter
end

function MoveOrTimeCounter:setStageNumber(stageNumber)
	local text = ""
	if type(stageNumber) == 'number' and stageNumber >= 0 then
		text = Localization:getInstance():getText('move.or.time.counter.next.stage', {num = stageNumber})
	elseif type(stageNumber) == 'string' and stageNumber == 'infinite' then
		text = Localization:getInstance():getText('move.or.time.counter.tip.endless.stage')
	end
	self.msgLabel:setString(text)
end
