SeaOrderTargetItem = class(LevelTargetItem)

local function getAnimation(item, itemId, itemNum, globalPosition, rotation)
	local panel = item.sprite
	local context = item.context

	local scene = Director:sharedDirector():getRunningScene()
    if not scene then return end

	FrameLoader:loadArmature('skeleton/sea_animal_animation')

	local vo = Director:sharedDirector():getVisibleOrigin()
	local vs = Director:sharedDirector():getVisibleSize()
	local node = nil
	local anchorPoint = ccp(0, 0) 
	local scale = 1
	local nodeWidth = 0
	local offsetX = 0

	if itemId == GameItemOrderType_SeaAnimal.kPenguin then
		node = ArmatureNode:create('penguin')
		if rotation == 0 then
			anchorPoint = ccp(0.5, 0.75)
		elseif rotation == 90 then
			anchorPoint = ccp(0.5, 0.75)
		end
		nodeWidth = 70 * 2
		offsetX = -100
		scale = 140 / node:getGroupBounds().size.height
	elseif itemId == GameItemOrderType_SeaAnimal.kSeaBear then
		node = ArmatureNode:create('seabear')
		if rotation == 0 then
			anchorPoint = ccp(1/6, 5/6)
		end
		nodeWidth = 70 * 3
		offsetX = -80
		scale = 210 / node:getGroupBounds().size.height
	elseif itemId == GameItemOrderType_SeaAnimal.kSeal then
		node = ArmatureNode:create('seadog')
		if rotation == 0 then
			anchorPoint = ccp(1/6, 3/4) 
		elseif rotation == -90 then
			anchorPoint = ccp(1/6, 1/4)
		end
		nodeWidth = 70 * 3
		offsetX = -200
		scale = 140 / node:getGroupBounds().size.height
	else 
		return 
	end
	local csize = node:getGroupBounds().size
	node:setContentSize(CCSizeMake(csize.width, csize.height))
	if rotation ~= 0 then
		node:setRotation(-rotation)
	end
	node:setScale(scale)
	node:playByIndex(0)
	node:setAnimationScale(0.875)
	node:setAnchorPoint(anchorPoint)
    node:setPosition(globalPosition)
    scene:addChild(node)

	local scale = 30 / math.max(node:getGroupBounds().size.width, node:getGroupBounds().size.height)

	local function onIconScaleFinished()
		if node and not node.isDisposed then
			print('removed')
			node:removeFromParentAndCleanup(true)
		end
	end 

	local function onIconMoveFinished()			
		panel:getChildByName("label"):setString(tostring(itemNum or 0))
		context:playLeafAnimation(true)
		context:playLeafAnimation(false)
		item:shakeObject()
		local sequence = CCSpawn:createWithTwoActions(CCScaleTo:create(0.3, scale * 2), CCFadeOut:create(0.3))
		node:setOpacity(255)
		node:runAction(CCSequence:createWithTwoActions(sequence, CCCallFunc:create(onIconScaleFinished)))
	end 

	-- 防止动画飞出屏幕
	local moveOffsetX = 0
	local moveOffsetY = 0
	if globalPosition.x > ( vo.x + vs.width - nodeWidth) then
		moveOffsetX = offsetX
	end


	local a = CCArray:create()
	a:addObject(CCDelayTime:create(0.5))
	-- a:addObject(CCRotateBy:create(0.2, rotation))
	a:addObject(CCSpawn:createWithTwoActions(CCRotateBy:create(0.2, rotation), CCMoveBy:create(0.2, ccp(moveOffsetX, moveOffsetY))))
	a:addObject(CCDelayTime:create(2))
	a:addObject(CCCallFunc:create(function () node:setAnchorPointCenterWhileStayOrigianlPosition() end))
	-- local destPos = panel.icon:getPosition()
    local destPos = item.icon:getParent():convertToWorldSpace(item.icon:getPosition())
	local b = CCArray:create()
	b:addObject(CCEaseSineInOut:create(CCMoveTo:create(0.5, ccp(destPos.x, destPos.y))))
	b:addObject(CCFadeTo:create(0.5, 150))
	b:addObject(CCScaleTo:create(0.5, scale))
	a:addObject(CCSpawn:create(b))
	a:addObject(CCCallFunc:create(onIconMoveFinished))
	node:runAction(CCSequence:create(a))
end


function SeaOrderTargetItem:setTargetNumber(itemId, itemNum, animate, globalPosition, rotation )
	if self.isFinished then return end
	if not self.sprite.refCocosObj then return end
	if itemNum ~= nil then
		self.itemNum = itemNum
		if itemNum <= 0 then self:finish() end

		if animate and globalPosition and self.icon then
            if rotation ~= nil then -- 目标是海洋生物
				getAnimation(self, itemId, itemNum, globalPosition, rotation)
            else -- 目标不是海洋生物
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
            end
		else
			self.sprite:getChildByName("label"):setString(tostring(itemNum or 0))
		end
	end
end