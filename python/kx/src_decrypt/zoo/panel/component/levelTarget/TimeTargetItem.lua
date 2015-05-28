TimeTargetItem = class(LevelTargetItem)

function TimeTargetItem:init()
	local spriteSize = self.sprite:getGroupBounds().size
	
	local label = self.sprite:getChildByName("label")
	label.offsetX = label:getPosition().x
	label:setAlignment(kCCTextAlignmentCenter)
	label:setAnchorPoint(ccp(0.5, 0.5))
	label:setString("0")

	local finished = self.sprite:getChildByName("finished")
	local finishedPos = finished:getPosition()
	local finished_icon = finished:getChildByName("icon")
	local finished_size = finished_icon:getContentSize()
	local finished_bg = finished:getChildByName("bg")
    local highlight = self.sprite:getChildByName('highlight')

	finished:setVisible(false)
	finished:setPosition(ccp(finishedPos.x + finished_size.width/2, finishedPos.y - finished_size.height/2))
	finished_icon:setAnchorPoint(ccp(0.5, 0.5))
	finished_bg:setAnchorPoint(ccp(0.5, 0.5))
    highlight:setVisible(false)
    
    self.highlight = highlight
    self.finished_bg = finished_bg
    self.finished_icon = finished_icon
    self.label = label
end

function TimeTargetItem:onTouchBegin(evt)
	self:shakeObject()
	self.context:playLeafAnimation(true)
	self.context:playLeafAnimation(false)
end

function TimeTargetItem:reset()
	local finished = self.sprite:getChildByName("finished")
	finished:setVisible(false)
end

function TimeTargetItem:finish()
	if self.isFinished then return end
	self.isFinished = true

	local finished = self.sprite:getChildByName("finished")
	finished:setVisible(true)

	self.finished_icon:stopAllActions()
	self.finished_icon:setScale(2.5)
	self.finished_icon:setOpacity(0)
	self.finished_icon:runAction(CCSpawn:createWithTwoActions(CCFadeIn:create(0.5), CCEaseBounceOut:create(CCScaleTo:create(0.5, 0.8))))

	local function onPlayShake()
		self:shake()
	end
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.25))
	array:addObject(CCCallFunc:create(onPlayShake))
	array:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(0.5), CCScaleTo:create(0.5, 1.2)))
	array:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(0.5), CCScaleTo:create(0.5, 2)))
	self.finished_bg:stopAllActions()
	self.finished_bg:setScale(0.6)
	self.finished_bg:setOpacity(0)
	self.finished_bg:runAction(CCSequence:create(array))
end

function TimeTargetItem:shake()
	self:shakeObject()
end

function TimeTargetItem:fadeIn(delayTime )
	delayTime = delayTime or 0
	local position = self.label:getPosition()
	local spawn = CCArray:create()
	spawn:addObject(CCFadeIn:create(0.4))
	spawn:addObject(CCScaleTo:create(0.4, 0.7))
	spawn:addObject(CCMoveTo:create(0.4, ccp(position.x, position.y)))
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(delayTime))
	array:addObject(CCSpawn:create(spawn))
	array:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.2, 1.2), CCTintTo:create(0.2, 210, 255, 0)))
	array:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.2, 0.7), CCTintTo:create(0.2, 255, 255, 255)))
	
	self.label:setPosition(ccp(position.x+25, position.y-100))
	self.label:setOpacity(0)
	self.label:setScale(0.1)
	self.label:runAction(CCSequence:create(array))
end

function TimeTargetItem:setContentIcon( icon, number )
	local label = self.sprite:getChildByName("label")
	if number ~= nil and label then
		label:setString(tostring(number or 0))
		label:setOpacity(0)
	end
	self.maxNumber = number
end

function TimeTargetItem:setTargetNumber( itemId, itemNum )
	self.itemNum = itemNum
	if itemNum >= self.maxNumber then self:finish() end
end

function TimeTargetItem:revertTargetNumber( itemId, itemNum )
	self.itemNum = itemNum
	if itemNum < self.maxNumber then 				
		self:reset()
		self.isFinished = false 
	end
end

