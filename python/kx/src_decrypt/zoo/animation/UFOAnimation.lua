
UFOAnimation = class(CocosObject)
UFOType = table.const{
	kNormal = 1, 
	kRabbit = 2, 
}
local kCharacterAnimationTime = 1/30
local UFOAnimationType = {kFlyInto = 1, kReflyInto = 2, kPull = 3, kFlyOut = 4}
local BASE_SCALE = 1.2
local function createUFOBody( ... )
	-- body
	local sprite = Sprite:createWithSpriteFrameName("UFO_body_0000")
	local frame = SpriteUtil:buildFrames("UFO_body_%04d", 0, 8)
	local animate = SpriteUtil:buildAnimate(frame, kCharacterAnimationTime)
  	sprite:play(animate)
  	return sprite
end

local function createLightning( ... )
	-- body
	local container = Sprite:createEmpty()
	local index = -1
	for k = 1, 2 do 
		local sprite = Sprite:createWithSpriteFrameName("UFO_lightning_0000")
		local frame = SpriteUtil:buildFrames("UFO_lightning_%04d", 0, 10)
		local animate = SpriteUtil:buildAnimate(frame, kCharacterAnimationTime)
	  	sprite:play(animate)
	  	index = index * -1
	  	sprite:setPosition(ccp(index *  30, 0))
	  	sprite:setVisible(false)
	  	if k == 2 then sprite:setRotation(180) end
	  	local function changeVisible( ... )
	  		-- body
	  		sprite:setVisible(not sprite:isVisible())
	  	end 
	  	local action = CCRepeatForever:create(CCSequence:createWithTwoActions(CCDelayTime:create(k), CCCallFunc:create(changeVisible)))
	  	sprite:runAction(action)
	  	container:addChild(sprite)
	end

	local function callback( ... )
		-- body
		if container then container:removeFromParentAndCleanup(true) end
	end 

  	return container
end

local function addHoverEffect( sprite )
	-- body
	if sprite then
		-- sprite:stopAllActions()
		local time = 1 
		local action_move_up = CCMoveBy:create(time/2, ccp(0, 10))
		local action_move_down = CCMoveBy:create(time/2, ccp(0, -10))
		local action = CCRepeatForever:create(CCSequence:createWithTwoActions(action_move_up, action_move_down))
		sprite:runAction(action)
	end 
end

function UFOAnimation:create( ufoType )
	-- body
	local node = UFOAnimation.new(CCNode:create())
	node.name = "UFO"

	node.body = createUFOBody()
	node:addChild(node.body)

	node.ufoType = ufoType or UFOType.kNormal

	node.currentAnimation = nil
	return node
end

function UFOAnimation:resetUFO( ... )
	-- body
	self:stopAllActions()
	self:setScale(BASE_SCALE)
	self:setVisible(true)
	self:setRotation(0)
	if self.shadow then self.shadow:removeFromParentAndCleanup(true) self.shadow = nil end
	if self.body then  self.body:setPosition(ccp(0,0)) self.body:setRotation(0) end
	if self.carrot then 
		self.carrot:stopAllActions() 
		self.carrot:removeFromParentAndCleanup(true) 
		self.carrot = nil 
	end

end

--first flying in
function UFOAnimation:playAnimation_firstFlyin( toPosition , callback)
	-- body
	self:resetUFO()
	self.currentAnimation = UFOAnimationType.kFlyInto
	local time = 1
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	toPosition = toPosition or ccp(visibleSize.width / 2, visibleSize.height / 2)
	local fromPostion = ccp(0, visibleSize.height / 2)
	self:setPosition(fromPostion)

	local bezierConfig = ccBezierConfig:new()
	bezierConfig.controlPoint_1 = fromPostion
	bezierConfig.controlPoint_2 = ccp((toPosition.x - fromPostion.x)/ 2, (toPosition.y - fromPostion.y)/2)
	bezierConfig.endPosition = toPosition
	-- local bezierAction = CCBezierTo:create(time, bezierConfig)
	local bezierAction = CCEaseOut:create(CCBezierTo:create(time, bezierConfig),2) 

	local action_zoom   = CCScaleTo:create(time/4, 1.5)
	local action_rotation = CCRotateTo:create(time/4, -15)
	local action_back = CCRotateTo:create(time/4, 0)
	local action_narrow = CCScaleTo:create(time/4, BASE_SCALE)
	local array_scale = CCArray:create()
	array_scale:addObject(action_zoom)
	array_scale:addObject(action_rotation)
	array_scale:addObject(action_back)
	array_scale:addObject(action_narrow)
	local action_scale = CCSequence:create(array_scale)
	local action_flayin = CCSpawn:createWithTwoActions(bezierAction, action_scale)

	local function completeCallback( ... )
		-- body
		addHoverEffect(self)
		if callback and type(callback) == "function" then 
			callback()
		end
	end
	local array = CCArray:create()
	array:addObject(action_flayin)
	array:addObject(CCCallFunc:create(completeCallback))

	self:runAction(CCSequence:create(array))

end

function UFOAnimation:playAnimation_reFlyin( toPosition, callback )
	-- body
	self:resetUFO()
	self.currentAnimation = UFOAnimationType.kReflyInto
	local time = 4
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	toPosition = toPosition or ccp(visibleSize.width / 2, visibleSize.height /2 )

	local fromPostion = ccp(toPosition.x, visibleSize.height + self:getGroupBounds().size.height/2)
	self:setPosition(fromPostion)

	local move_action = CCEaseElasticOut:create(CCMoveTo:create(time, toPosition))

	local function completeCallback( ... )
		-- body
		addHoverEffect(self)
		if not self.lightning then 
			self.lightning = createLightning()
			self:addChild(self.lightning)
		end
		if callback and type(callback) == "function" then 
			callback()
		end
	end

	local array = CCArray:create()
	array:addObject(move_action)
	array:addObject(CCCallFunc:create(completeCallback))
	self:runAction(CCSequence:create(array))
end

function UFOAnimation:addLightCirlce()
	for k = 1, 4 do 
		local function addLightCirlce( ... )
			-- body
			local sprite = Sprite:createWithSpriteFrameName("UFO_light_circle")
			self:addChild(sprite)
			sprite:setPosition(ccp(0, -100))
			sprite:setScale(2.5)
			sprite:setScaleY(0.9)
			
			local action_scale = CCScaleTo:create(0.4, 0.1)
			local action_move = CCMoveTo:create(0.4, ccp(0, -20))
			local action_up = CCSpawn:createWithTwoActions(action_scale, action_move)

			local function circleCallback( ... )
				-- body
				if sprite then sprite:removeFromParentAndCleanup(true) end
				
			end
			local action_callfunc = CCCallFunc:create(circleCallback)
			sprite:runAction(CCSequence:createWithTwoActions(action_up, action_callfunc))
		end

		self:runAction(CCSequence:createWithTwoActions( CCDelayTime:create(k * 0.15), CCCallFunc:create(addLightCirlce)))
	end
end

function UFOAnimation:addCarrot()
	local carrot = Sprite:createWithSpriteFrameName("UFO_carrot")
	carrot:setAnchorPoint(ccp(0.5, 1))
	carrot:setPosition(ccp(0, -self.body:getGroupBounds().size.height / 2))
	self:addChild(carrot)

	local function animationCallback()
		if self.carrot then self.carrot:removeFromParentAndCleanup(true) self.carrot = nil end
	end

	local arr = CCArray:create()
	arr:addObject(CCOrbitCamera:create(0.7, 1, 0, 270, 180, 0, 0))
	arr:addObject(CCOrbitCamera:create(0.7, 1, 0, 450, -180, 0, 0))
	arr:addObject(CCCallFunc:create(animationCallback))
	carrot:runAction(CCSequence:create(arr))
	self.carrot = carrot
end


function UFOAnimation:playAnimation_pull( callback )
	-- body
	if self.currentAnimation and self.currentAnimation == UFOAnimationType.kPull then 
		if callback then callback() end
		return 
	end

	self:resetUFO()
	self.currentAnimation = UFOAnimationType.kPull
	--add cirlc
	self:addLightCirlce()
	--add carrot
	if self.ufoType == UFOType.kRabbit then 
		self:addCarrot()
	end
	--add shadow
	local shadow = Sprite:createWithSpriteFrameName("UFO_light_shadow")
	shadow:setAnchorPoint(ccp(0.5, 1))
	shadow:setPosition(ccp(0, -self.body:getGroupBounds().size.height / 2))
	shadow:setScale(2)
	self.shadow = shadow

	local function completeCallback( ... )
		-- body
		addHoverEffect(self)
		if shadow then shadow:removeFromParentAndCleanup(true) self.shadow = nil end
		if callback and type(callback) == "function" then callback() end
		self.body:setRotation(0)
		self.currentAnimation = nil
	end

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(1.1))
	array:addObject(CCScaleTo:create(0.3, 0.1))
	array:addObject(CCCallFunc:create(completeCallback))
	shadow:runAction(CCSequence:create(array))
	self:addChild(shadow)
	self.body:setRotation(-15)
end

function UFOAnimation:playAnimation_flyOut( callback )
	-- body
	if self.currentAnimation and self.currentAnimation == UFOAnimationType.kFlyOut then 
		if callback then callback() end
		return  
	end

	self:resetUFO()
	self.currentAnimation = UFOAnimationType.kFlyOut
	local time = 1
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local toPosition = ccp(visibleSize.width/2, visibleSize.height/2)
	local fromPosition = self:getPosition()

	local function completeCallback( ... )
		-- body
		addHoverEffect(self)
		self.currentAnimation = nil
		if callback then callback() end
	end

	local bezierConfig = ccBezierConfig:new()
	bezierConfig.controlPoint_1 = ccp(fromPosition.x, fromPosition.y)
	bezierConfig.controlPoint_2 = ccp(0, toPosition.y / 2)
	bezierConfig.endPosition = toPosition
	local bezierAction = CCBezierTo:create(time, bezierConfig)
	local scaleAction = CCScaleTo:create(time, 2.5)

	local bezierConfig_2 = ccBezierConfig:new()
	bezierConfig_2.controlPoint_1 = ccp(0, toPosition.y / 2)
	bezierConfig_2.controlPoint_2 = ccp(visibleSize.width / 2,(visibleSize.height - toPosition.y / 2) / 2)
	bezierConfig_2.endPosition = ccp(visibleSize.width, visibleSize.height)
	local bezierAction_2 = CCBezierTo:create(time, bezierConfig_2)
	local scaleAction_2 = CCScaleTo:create(time, 0.1)

	
	local callfuncAction = CCCallFunc:create(completeCallback)

	local array_action = CCArray:create()
	array_action:addObject(CCSpawn:createWithTwoActions(bezierAction, scaleAction))
	array_action:addObject(CCDelayTime:create(0.75 * time))
	array_action:addObject(CCSpawn:createWithTwoActions(bezierAction_2,scaleAction_2 ))
	array_action:addObject(callfuncAction)
	local ufo_action = CCSequence:create(array_action)
	self:runAction(ufo_action)

	----外星人
	local ufo_man = Sprite:createWithSpriteFrameName("UFO_man")
	ufo_man:setAnchorPoint(ccp(0, 0.5))
	local size = self:getGroupBounds().size
	local pos = ccp(0, size.height/4)
	ufo_man:setPosition(pos)
	self:addChild(ufo_man)
	ufo_man:setScale(0)
	local action_fadeIn  = CCSpawn:createWithTwoActions(CCFadeIn:create(time/4),CCScaleTo:create(time/4, 1)) 
	local action_fadeout = CCSpawn:createWithTwoActions(CCFadeOut:create(time/4),CCScaleTo:create(time/4, 0.1)) 
	local function ufomanCallback( ... )
		-- body
		if ufo_man then ufo_man:removeFromParentAndCleanup(true) end
	end 
	local array_man = CCArray:create()
	array_man:addObject(CCDelayTime:create(time))
	array_man:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(time/8),CCScaleTo:create(time/8, 1)) )
	array_man:addObject(CCSequence:createWithTwoActions(CCRotateTo:create(time/4, -15), CCRotateTo:create(time/4, 0)))
	array_man:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(time/8),CCScaleTo:create(time/8, 0.1)) )
	array_man:addObject(CCCallFunc:create(ufomanCallback))
	local action = CCSequence:create(array_man)
	ufo_man:runAction(action)
	---body

	local body_action_array	= CCArray:create()
	body_action_array:addObject(CCRotateTo:create(time/3 * 2, -15)) 
	body_action_array:addObject(CCRotateTo:create(time/3, 0)) 
	body_action_array:addObject(CCDelayTime:create(time/2))
	body_action_array:addObject(CCRotateTo:create(time/3 *2, 15))
	body_action_array:addObject(CCRotateTo:create(time/3, 0))
	self.body:runAction(CCSequence:create(body_action_array))

end



