TargetItemFactory = class()

function TargetItemFactory.create(class, itemSprite, index, context)
	local item = class.new(itemSprite, index, context)
	item:init()

	local function onTouchBegin(evt)
		item:onTouchBegin(evt)
	end

	itemSprite:ad(DisplayEvents.kTouchBegin, onTouchBegin)
	itemSprite:setTouchEnabled(true)

	return item
end

LevelTargetItem = class()

function LevelTargetItem:ctor(itemSprite, index, context)
	self.sprite = itemSprite
	self.index = index
	self.context = context
end

function LevelTargetItem:create(itemSprite, index, context)
	local item = LevelTargetItem.new(itemSprite, index, context)
	item:init()

	local function onTouchBegin(evt)
		item:onTouchBegin(evt)
	end

	itemSprite:ad(DisplayEvents.kTouchBegin, onTouchBegin)
	itemSprite:setTouchEnabled(true)

	return item
end

function LevelTargetItem:getContentSize()
	return self.sprite:getContentSize()
end

function LevelTargetItem:setVisible(visible)
	return self.sprite:setVisible(visible)
end

function LevelTargetItem:getPosition()
	return self.sprite:getPosition()
end

function LevelTargetItem:setPosition(pos)
	self.sprite:setPosition(pos)
end

function LevelTargetItem:getGroupBounds()
	return self.sprite:getGroupBounds()
end

function LevelTargetItem:getParent()
	return self.sprite:getParent()
end

function LevelTargetItem:rma()
	self.sprite:rma()
end

function LevelTargetItem:onTouchBegin(evt)
		self:shakeObject()
		self.context:playLeafAnimation(true)
		self.context:playLeafAnimation(false)
		if not evt.target then return end
		local target = self.context.targets[evt.target.index]
		if target and target.type == "order2" or target.type == "order3" then
			CommonTip:showTip(Localization:getInstance():getText("game.target.tips."..target.type..'.'..target.id, {num = self.itemNum}), "positive")
		end
		he_log_info("auto_test_tap_target")
end

function LevelTargetItem:shakeObject( rotation )
	if self.isShaking then return false end
	self.isShaking = true

    self.sprite:stopAllActions()
    self.sprite:setRotation(0)

    local original = self.sprite.original
    if not original then
    	original = self.sprite:getPosition() 
    	self.sprite.original = {x=original.x, y=original.y}
	end
    self.sprite:setPosition(ccp(original.x, original.y))

    local array = CCArray:create()
    local direction = 1
    if math.random() > 0.5 then direction = -1 end

    rotation = rotation or 4
    local startRotation = direction * (math.random() * 0.5 * rotation + rotation)
    local startTime = 0.35

    local function onShakeFinish()
    	self.isShaking = false
    end

    array:addObject(CCSpawn:createWithTwoActions(CCRotateTo:create(startTime*0.3, startRotation), CCMoveBy:create(0.05, ccp(0, 6))))
    array:addObject(CCSpawn:createWithTwoActions(CCRotateTo:create(startTime, -startRotation*2), CCMoveBy:create(0.05, ccp(0, -6))))
    array:addObject(CCRotateTo:create(startTime, startRotation * 1.5))
    array:addObject(CCRotateTo:create(startTime, -startRotation))
    array:addObject(CCRotateTo:create(startTime, startRotation))
    array:addObject(CCRotateTo:create(startTime, -startRotation*0.5))
    array:addObject(CCRotateTo:create(startTime, 0))
    array:addObject(CCCallFunc:create(onShakeFinish))

    self.sprite:runAction(CCSequence:create(array))
    return true
end

function LevelTargetItem:initContent()
	local content = self.sprite:getChildByName("content")
	if content then
	    local zOrder = content:getZOrder()
	    self.zOrder = zOrder
		local contentPos = content:getPosition()
		local contentSize = content:getContentSize()

		self.iconSize = {x = contentPos.x, y = contentPos.y, width=contentSize.width, height=contentSize.height}
		content:removeFromParentAndCleanup(true)
		
		-- LevelTargetItem.iconSize = self.iconSize
		-- LevelTargetItem.zOrder = zOrder
	else
		-- self.iconSize = LevelTargetItem.iconSize
		-- self.zOrder = LevelTargetItem.zOrder
	end
end

function LevelTargetItem:init()

	local spriteSize = self.sprite:getGroupBounds().size
	self.sprite:setContentSize(CCSizeMake(spriteSize.width, spriteSize.height))

	self:initContent()
	
	local label = self.sprite:getChildByName("label")
	label.offsetX = label:getPosition().x
	label:setAlignment(kCCTextAlignmentRight)
	label:setString("0")
	label:setOpacity(0)
	label:setScale(2)

	local finished = self.sprite:getChildByName("finished")
	local finishedPos = finished:getPosition()
	local finished_icon = finished:getChildByName("icon")
	local finished_size = finished_icon:getContentSize()
	local finished_bg = finished:getChildByName("bg")
	finished:setVisible(false)
	finished:setPosition(ccp(finishedPos.x + finished_size.width/2, finishedPos.y - finished_size.height/2))
	finished_icon:setAnchorPoint(ccp(0.5, 0.5))
	finished_bg:setAnchorPoint(ccp(0.5, 0.5))

	self.finished_icon = finished_icon
	self.finished_bg = finished_bg

    local highlight = self.sprite:getChildByName('highlight')
    highlight:setVisible(false)

	self.isFinished = false
end

function LevelTargetItem:reset()
	local finished = self.sprite:getChildByName("finished")
	finished:setVisible(false)
	local label = self.sprite:getChildByName("label")
	label:setVisible(true)
end

function LevelTargetItem:finish()
	if self.isFinished then return end
	self.isFinished = true

	local label = self.sprite:getChildByName("label")
	label:setVisible(false)
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

function LevelTargetItem:shake()
	if self.isFinished then return end
	self:shakeObject()
	local icon = self.icon
	local label = self.sprite:getChildByName("label")
	
	if icon then
		local sequence = CCArray:create()
		sequence:addObject(CCDelayTime:create((self.index-1) * 0.1))
		sequence:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.15, 1.6), CCFadeIn:create(0.15)))
		sequence:addObject(CCScaleTo:create(0.15, 1))
		icon:stopAllActions()
		icon:runAction(CCSequence:create(sequence))
	end
	if label then
		label:setOpacity(0)
		label:setScale(2)

		local labelSeq = CCArray:create()
		labelSeq:addObject(CCDelayTime:create(0.3 + (self.index-1) * 0.1))
		labelSeq:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.15, 1), CCFadeIn:create(0.15)))
		label:stopAllActions()
		label:runAction(CCSequence:create(labelSeq))
	end
end

function LevelTargetItem:setContentIcon(icon, number )
	if self.icon then
		self.icon:removeFromParentAndCleanup(true)
	end
	self.icon = icon
	if self.icon and self.iconSize then
		local iconContentSize = self.iconSize
		local iconSize = self.icon:getContentSize()
		local y = iconContentSize.y - (iconContentSize.height)/2
		self.icon:setPosition(ccp(0, y - 3))
		self.icon:setOpacity(0)
		self.sprite:addChildAt(icon, self.zOrder)
	end
	local label = self.sprite:getChildByName("label")
	if number ~= nil and label then
		label:setString(tostring(number or 0))
		label:setOpacity(0)
		label:setScale(2)
	end
end

function LevelTargetItem:setTargetNumber(itemId, itemNum, animate, globalPosition )
	if self.isFinished then return end
	if not self.sprite.refCocosObj then return end

	if itemNum ~= nil then
		self.itemNum = itemNum
		if itemNum <= 0 then self:finish() end

		if animate and globalPosition and self.icon then
			local cloned = self.icon:clone(true)
			local targetPos = self.sprite:getParent():convertToNodeSpace(globalPosition)
			local position = cloned:getPosition()
			local tx, ty = position.x, position.y
			local function onIconScaleFinished()
				cloned:removeFromParentAndCleanup(true)
			end 
			local function onIconMoveFinished()			
				self.sprite:getChildByName("label"):setString(tostring(itemNum or 0))
				self.context:playLeafAnimation(true)
				self.context:playLeafAnimation(false)
				self:shakeObject()
				local sequence = CCSpawn:createWithTwoActions(CCScaleTo:create(0.3, 2), CCFadeOut:create(0.3))
				cloned:setOpacity(255)
				cloned:runAction(CCSequence:createWithTwoActions(sequence, CCCallFunc:create(onIconScaleFinished)))
			end 
			local moveTo = CCEaseSineInOut:create(CCMoveTo:create(0.5, ccp(tx, ty)))
			local moveOut = CCSpawn:createWithTwoActions(moveTo, CCFadeTo:create(0.5, 150))
			cloned:setPosition(targetPos)
			cloned:runAction(CCSequence:createWithTwoActions(moveOut, CCCallFunc:create(onIconMoveFinished)))
		else
			self.sprite:getChildByName("label"):setString(tostring(itemNum or 0))
		end
	end
end

function LevelTargetItem:revertTargetNumber(itemId, itemNum )
	if itemNum ~= nil then
		self.itemNum = itemNum
		if itemNum > 0 then 				
			self:reset()
			self.isFinished = false 
		end
		self.sprite:getChildByName("label"):setString(tostring(itemNum or 0))
	end
end

function LevelTargetItem:highlight(enable, showRaccoon)
    print('sprite.highlight')
    if self.highlighted == nil then
        self.highlighted = false
    end

    if self.highlighted == true then
        if enable == true then 
            return 
        else
            -- disable highlight
            print('disable')
            self.highlighted = false
            local highlight = self.sprite:getChildByName('highlight')
            highlight:stopAllActions()
            highlight:setVisible(false)
            
        end
    elseif self.highlighted == false then
        if not enable then 
            return 
        else
            print('enable')
            self.highlighted = true
            local highlight = self.sprite:getChildByName('highlight')
            highlight:stopAllActions()
            highlight:setVisible(true)
            local array = CCArray:create()
            array:addObject(CCFadeTo:create(0.5, 125))
            array:addObject(CCFadeTo:create(0.5, 255))
            highlight:runAction(CCRepeatForever:create(CCSequence:create(array)))
            
            if not showRaccoon then return end

            -- enable highlight
            local vs = Director:sharedDirector():getVisibleSize()
            local vo = Director:sharedDirector():getVisibleOrigin()
            local node = CommonSkeletonAnimation:createTutorialMoveIn()
            node:setScaleX(-1)
            local scene = Director:sharedDirector():getRunningScene()
            if not scene then return end
            local panelPosition = self:getParent():convertToWorldSpace(self.sprite:getPosition())
            -- local nodePos = ccp(panelPosition.x + 100, panelPosition.y)
            node:setAnchorPoint(ccp(0, 1))
            local nodePos = ccp(150, panelPosition.y)
            node:setPosition(nodePos)
            scene:addChild(node)
            node:setAnimationScale(0.3)
            local builder = InterfaceBuilder:create("flash/scenes/homeScene/homeScene.json")
            -- local tip = builder:buildGroup('homeScene_infiniteEnergyTip')
            local tip = GameGuideRunner:createPanelMini('venom.too.little.tips')
            -- tip:getChildByName('txt'):setString(Localization:getInstance():getText('venom.too.little.tips'))
            -- tip:getChildByName('bg'):setScaleX(-1)
            -- tip:getChildByName('bg'):setAnchorPoint(ccp(1, 1))
            local posTip = ccp(vo.x + vs.width / 2 - tip:getGroupBounds().size.width / 2, nodePos.y - 120)
            local tipStartPos = ccp(-500, nodePos.y - 120)
            tip:setPosition(tipStartPos)
            tip:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCEaseExponentialOut:create(CCMoveTo:create(0.3, posTip))))
            scene:addChild(tip)
            local function remove()
                if node and node.refCocosObj then node:runAction(
                        CCSequence:createWithTwoActions(
                            CCDelayTime:create(0.5),
                            CCCallFunc:create(
                                function () 
                                    if node and node.refCocosObj then 
                                        node:removeFromParentAndCleanup(true) 
                                    end 
                                end)
                        )
                    )  
                end
                if tip and tip.refCocosObj then 
                    tip:runAction(CCSequence:createWithTwoActions(
                        CCEaseExponentialIn:create(CCMoveTo:create(0.3, tipStartPos)),
                        CCCallFunc:create(
                            function () 
                                if tip and tip.refCocosObj then 
                                    tip:removeFromParentAndCleanup(true) 
                                end
                            end))
                    )  
                end
            end
            setTimeOut(remove, 5)
        end
    end
end