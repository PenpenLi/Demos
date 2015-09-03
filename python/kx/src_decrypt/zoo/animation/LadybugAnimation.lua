require "hecore.display.Director"
require "zoo.animation.CardinalSpline"

local kStarFactor = 24 * 3.1415926 / 180
local kMaskBeginWidth = 17
local kMaskEndWidth = 50

LadybugAnimation = class()

function LadybugAnimation:ctor()
	local layer = Layer:create()
  	layer.name = "lady bug"
  	layer:setTouchEnabled(true)

  	local kPropListScaleFactor = 1
  	if __frame_ratio and __frame_ratio < 1.6 then  kPropListScaleFactor = 0.92 end
  	layer:setScale(kPropListScaleFactor)

  	local ladybug = ResourceManager:sharedInstance():buildGroup("ladybug")
	self.ladybug = ladybug
  	layer:addChild(ladybug)

  	self.layer = layer
  	self.scriptID = -1
  	self.progress = 0

	self.starLevel = 0

  	self.star1 = self:createDarkStar("star_1", 1)
  	self.star2 = self:createDarkStar("star_2", 2)
  	self.star3 = self:createDarkStar("star_3", 3)

  	local background = ladybug:getChildByName("background")
  	local backgroundPos = background:getPosition()
  	local backgroundSize = background:getContentSize()
  	background:setAnchorPoint(ccp(0, 0.5))
  	background:setPosition(ccp(backgroundPos.x, backgroundPos.y-backgroundSize.height*0.5))
  	self.background = background

  	self.star1:setAnchorPoint(ccp(0.5, 0.5))
  	self.star2:setAnchorPoint(ccp(0.5, 0.5))
  	self.star3:setAnchorPoint(ccp(0.5, 0.5))

  	local animal = ladybug:getChildByName("lady_bug_icon")
  	local content = animal:getChildByName("bg")
  	content:setAnchorPoint(ccp(0.5, 0.5))

  	local animalStar = Sprite:createWithSpriteFrameName("ladybug_glow_circle0000")
  	animalStar:setOpacity(0)
  	animal.animalStar = animalStar
  	animal:addChild(animalStar)
  	animal.playStar = function( self )
  		local star = self.animalStar
  		if star then
  			star:stopAllActions()
  			star:setOpacity(0)
  			star:runAction(CCSequence:createWithTwoActions(CCFadeIn:create(0.4), CCFadeOut:create(0.3)))
  		end  		
  	end
	
	self.batch = SpriteBatchNode:createWithTexture(animalStar:getTexture())
	self.layer:addChild(self.batch)
	
  	local lightMask = ladybug:getChildByName("light_mask")
  	local maskSize = lightMask:getContentSize()
  	local maskPos = lightMask:getPosition()
  	local maskIndex = ladybug:getChildIndex(lightMask)

  	local spriteX = maskPos.x
  	local spriteY = maskPos.y
  	local spriteWidth = maskSize.width
  	local spriteHeight = maskSize.height
  	kMaskBeginWidth = spriteX

  	lightMask:removeFromParentAndCleanup(false)
  	lightMask:setAnchorPoint(ccp(0,0.5))
  	lightMask:setPosition(ccp(0, spriteY+spriteHeight*1.5 + 5))
  	lightMask:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1, 230), CCFadeTo:create(1, 255))))

  	local stencilNode = CCLayerColor:create(ccc4(255,255,255,255), spriteWidth, spriteHeight)
	stencilNode:setAnchorPoint(ccp(0,0))
	self.stencilNode = stencilNode

  	local clip = ClippingNode.new(CCClippingNode:create(stencilNode))
  	clip.name = "clip"
  	clip:setAnchorPoint(ccp(0, 0))
  	clip:setPosition(ccp(spriteX, spriteY - spriteHeight))
	clip:addChild(lightMask)
	ladybug:addChildAt(clip, maskIndex)
	
  	self.spriteWidth = spriteWidth
  	self.spriteHeight = spriteHeight
	
  	local shiningStars = Sprite:createWithSpriteFrameName("firefly_light0000")
    shiningStars:setAnchorPoint(ccp(0.5,0.5))
    shiningStars:setOpacity(150)
    shiningStars:runAction(CCRepeatForever:create(SpriteUtil:buildAnimate(SpriteUtil:buildFrames("firefly_light%04d", 0, 25), 1/30)))
    animal:addChild(shiningStars)

  	self.animal	= animal

  	local pathNode = ladybug:getChildByName("path")
  	local offset = pathNode:getPosition()
  	local path = {}
  	for i,v in ipairs(pathNode.list) do
  		local p = v:getPosition()
  		path[i] = ccp(offset.x + p.x, offset.y + p.y)
  	end
  	pathNode:removeFromParentAndCleanup(true)

  	local spine = CardinalSpline.new(path, 0.25)
  	self.spine = spine

    self.fourStar_shining = self.ladybug:getChildByName('fourstar_shining')
    self.fourStar_shining:setVisible(false)
    self.fourthStar = self.ladybug:getChildByName('fourth_star')
    self.fourthStar:setVisible(false)
    self.sunshine = self.ladybug:getChildByName('sunshine')
    self.sunshine:setVisible(false)
    self.sunshine:setAnchorPoint(ccp(0.5, 0.5))
    self.fourthStar:setAnchorPoint(ccp(0.5, 0.5))
    self.fourthStar:getChildByName('star_white'):setAnchorPoint(ccp(0.5, 1))
    self.fourthStar:getChildByName('star_normal'):setAnchorPoint(ccp(0.5, 1))
    self.leaf1 = self.ladybug:getChildByName('fourstar_leaves1')
    self.leaf2 = self.ladybug:getChildByName('fourstar_leaves2')
    self.leaf3 = self.ladybug:getChildByName('fourstar_leaves3')
    self.leaf1:setVisible(false)
    self.leaf2:setVisible(false)
    self.leaf3:setVisible(false)

    -- test
    -- local function test()
    --     self:playFourStarAnimation()
    -- end
    -- setTimeOut(test, 5)

end

function LadybugAnimation:createDarkStar( textKey, starIndex )
	local context = self
	local container = self.ladybug:getChildByName(textKey)
	container.starIndex = index
	local function onTouchTap(evt) 
		local score = context["star"..starIndex.."score"] or 0
		local dark = context["star"..starIndex]
		local light = context["bigstar"..starIndex]
		if light then dark = light end
		local fntFile = "fnt/energy_cd.fnt"
		if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/energy_cd.fnt" end
		local label = BitmapText:create(tostring(score), fntFile)
		local function onAnimationFinished() label:removeFromParentAndCleanup(true) end
		local array = CCArray:create()
		array:addObject(CCEaseBackOut:create(CCMoveBy:create(0.3, ccp(0, 20)))) 
		array:addObject(CCDelayTime:create(0.5))
		array:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(0.5), CCMoveBy:create(0.3, ccp(0, 10))))
		array:addObject(CCCallFunc:create(onAnimationFinished))
		label:runAction(CCSequence:create(array))
		label:setPosition(container:convertToWorldSpace(ccp(0, 0)))
		
		local shake = CCArray:create()
		shake:addObject(CCMoveBy:create(0.05, ccp(-3, 0)))
		shake:addObject(CCMoveBy:create(0.1, ccp(6, 0)))
		shake:addObject(CCMoveBy:create(0.05, ccp(-3, 0)))
		dark:runAction(CCSequence:create(shake))

		local scene = Director:sharedDirector():getRunningScene()
		if scene then scene:addChild(label) end
	end
	container:ad(DisplayEvents.kTouchTap, onTouchTap)
	container:setTouchEnabled(true, 0, true)
	return container
end

function LadybugAnimation:create()
	local ret = LadybugAnimation.new()
	ret:moveTo(0)
	return ret
end
function LadybugAnimation:dispose()
	if self.scriptID >= 0 then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.scriptID) 
		self.scriptID = -1
	end
	self.isDisposed = true
end

function LadybugAnimation:setPosition(p)
	self.layer:setPosition(p)
end

function LadybugAnimation:reset(delayTime)
	self:moveTo(0)

	delayTime = delayTime or 2.5
	local position = self.animal:getPosition()	
	self.animal:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime),CCEaseSineOut:create(CCMoveTo:create(0.6, ccp(position.x, position.y)))))
	self.animal:setPosition(ccp(position.x-100, position.y+20))

	if self.bigstar1 then self.bigstar1:removeFromParentAndCleanup(true) end
	if self.bigstar2 then self.bigstar2:removeFromParentAndCleanup(true) end
	if self.bigstar3 then self.bigstar3:removeFromParentAndCleanup(true) end
	self.bigstar1 = nil
	self.bigstar2 = nil
	self.bigstar3 = nil
end
function LadybugAnimation:moveTo(progress)
	if progress < 0 then progress = 0 end
	if progress > 1 then progress = 1 end

	if self.scriptID >= 0 then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.scriptID) 
		self.scriptID = -1
	end

	self.progress = progress
	local position = self.spine:calculatePosition(progress)
	local angle = self.spine:calculateAngle(progress)
	self.animal:setPosition(position)
	self.animal:setRotation(angle)
	self:updateMaskProgress(progress)	
end

function LadybugAnimation:revertTo( progress )
	self:moveTo(progress)
	progress = self.progress

	if self.star1progress ~= nil and self.star2progress ~= nil and self.star3progress ~= nil then
		if progress < self.star1progress and self.bigstar1 ~= nil then
			self.bigstar1:removeFromParentAndCleanup(true)
			self.bigstar1 = nil
			self.starLevel = 0
		end

		if progress < self.star2progress and self.bigstar2 ~= nil then
			self.bigstar2:removeFromParentAndCleanup(true)
			self.bigstar2 = nil
			self.starLevel = 1
		end

		if progress < self.star3progress and self.bigstar3 ~= nil then
			self.bigstar3:removeFromParentAndCleanup(true)
			self.bigstar3 = nil
			self.starLevel = 2
		end
	end
end

--@private
function LadybugAnimation:updateMaskProgress( progress )
	local position = self.animal:getPosition()
	local width = position.x - kMaskBeginWidth
	local max = self.spriteWidth - kMaskEndWidth
	if width > max then width = max end
	if progress >= 1 then width = self.spriteWidth end
	self.stencilNode:setContentSize(CCSizeMake(width, self.spriteHeight)) 
end
function LadybugAnimation:updateStarProgress( progress )
	if progress < 0 then progress = 0 end
	if progress > 1 then progress = 1 end
	if self.star1progress ~= nil and self.star2progress ~= nil and self.star3progress ~= nil then

		if progress >= self.star1progress and self.bigstar1 == nil then
			self:showStar(self.star1, "bigstar1")
		end

		if progress >= self.star2progress and self.bigstar2 == nil then
			self:showStar(self.star2, "bigstar2")
		end

		if progress >= self.star3progress and self.bigstar3 == nil then
			self:showStar(self.star3, "bigstar3")
		end
	end
end

function LadybugAnimation:animateTo( progress, duration , ...)
	assert(type(progress) == "number")
	assert(type(duration) == "number")
	assert(#{...} == 0)

	if self.progress == progress then return end

	local animal = self.animal
	if not animal then return end

	if self.scriptID >= 0 then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.scriptID) 
		self.scriptID = -1
	end

	local beginValue = self.progress
	local deltaValue = progress - self.progress
	self.progress = progress

	local totalTime = 0
	local context = self
	local function onUpdateAnimation( dt )
		if context.isDisposed then 
			if context.scriptID >= 0 then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(context.scriptID) end
			return 
		end

		totalTime = totalTime + dt
		local timePercent = totalTime / duration

		if timePercent > 1 then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(context.scriptID) 
			context.scriptID = -1

			local finalValue = beginValue + deltaValue
			local position = self.spine:calculatePosition(finalValue)
			animal:setPosition(position)
			self:updateMaskProgress(finalValue)
			self:updateStarProgress(finalValue)
		else
			local currentValue = beginValue + deltaValue * timePercent
			local position = self.spine:calculatePosition(currentValue)
			local angle = self.spine:calculateAngle(currentValue)
			animal:setPosition(position)
			animal:setRotation(angle)
			self:updateMaskProgress(currentValue)
			self:updateStarProgress(currentValue)
		end	
	end 
	self.scriptID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onUpdateAnimation,0.01,false)
end

function LadybugAnimation:setStarPosition( star, progress )
	if progress < 0 then progress = 0 end
	if progress > 1 then progress = 1 end
	local position = self.spine:calculatePosition(progress)
	star:setPosition(ccp(position.x, position.y))
end
function LadybugAnimation:setStarsPosition( star1progress, star2progress, star3progress )	
	if star3progress > 0.88 then star3progress = 0.88 end

	self.star1progress = star1progress
	self.star2progress = star2progress
	self.star3progress = star3progress

	self:setStarPosition(self.star1, star1progress)
	self:setStarPosition(self.star2, star2progress)
	self:setStarPosition(self.star3, star3progress)
end
function LadybugAnimation:setStarsScore( star1score, star2score, star3score )
	self.star1score = star1score
	self.star2score = star2score
	self.star3score = star3score
end

local function createStarDustAnimation( parent, onAnimationFinished, r_base )
	r_base = r_base or 45
	for i = 1, 15 do	
		local angle = i * kStarFactor
		local r = r_base + math.random() * r_base * 0.25
		local x = 0 + math.cos(angle) * r
		local y = 0 + math.sin(angle) * r
		
		local sprite = nil
		if math.random() > 0.6 then sprite = Sprite:createWithSpriteFrameName("win_star_big0000")
		else sprite = Sprite:createWithSpriteFrameName("win_star_dust0000") end
		sprite:setPosition(ccp(0, 0))
		sprite:setScale(0)
		sprite:setOpacity(0)
		sprite:setRotation(math.random() * 360)

		local spawn = CCArray:create()
		spawn:addObject(CCFadeIn:create(0.1))
		spawn:addObject(CCMoveTo:create(0.2 + math.random() * 0.2, ccp(x, y)))
		spawn:addObject(CCScaleTo:create(0.4, math.random()*0.6 + 0.8))

		local sequence = CCArray:create()
		sequence:addObject(CCSpawn:create(spawn))
		sequence:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(0.3), CCScaleBy:create(0.3, 1)))

		if onAnimationFinished ~= nil then
			sequence:addObject(CCCallFunc:create(onAnimationFinished))
		else
			local function onMoveFinished( ) sprite:removeFromParentAndCleanup(true) end
			sequence:addObject(CCCallFunc:create(onMoveFinished))
		end

		sprite:runAction(CCSequence:create(sequence))
		parent:addChild(sprite)
	end
end

function LadybugAnimation:createFinishStarAnimation(position)
	local shiningStars = Sprite:createWithSpriteFrameName("ladybug_rotated_star0000")
	local node = SpriteBatchNode:createWithTexture(shiningStars:getTexture())
	node:setPosition(ccp(position.x, position.y))

    shiningStars:setAnchorPoint(ccp(0.5,0.5))
    shiningStars:setScale(0.6)
    shiningStars:runAction(CCRepeat:create(SpriteUtil:buildAnimate(SpriteUtil:buildFrames("ladybug_rotated_star%04d", 0, 11), 1/30), 1))
    node:addChild(shiningStars)

    local function onAnimationFinished()
    	node:removeFromParentAndCleanup(true)
    end 
    createStarDustAnimation(node, onAnimationFinished, 35)
    return node
end

function LadybugAnimation:createFinsihExplodeStar( position )
	local win_star = ParticleSystemQuad:create("particle/win_star.plist")
	win_star:setAutoRemoveOnFinish(true)
	win_star:setPosition(ccp(position.x,position.y))
	return win_star
end

function LadybugAnimation:createFinsihShineStar( position )
	local overlay = Sprite:createWithSpriteFrameName("win_star_shine0000")
	local container = SpriteBatchNode:createWithTexture(overlay:getTexture())
	container:setPosition(ccp(position.x, position.y))
	overlay:dispose()

	for i = 1, 5 do
		local win_star_shine = Sprite:createWithSpriteFrameName("win_star_shine0000")
		local x = math.random() * 100 - 40
		local y = math.random() * 100 - 40
		local fadeArray = CCArray:create()
		fadeArray:addObject(CCDelayTime:create(0.3 + math.random() * 0.5))
		fadeArray:addObject(CCFadeIn:create(0.2))
		fadeArray:addObject(CCFadeOut:create(0.3))
		
		win_star_shine:setPosition(ccp(x, y))
		win_star_shine:setOpacity(0)
		win_star_shine:setScale(math.random() * 0.5 + 0.4)
		win_star_shine:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 100)))
		win_star_shine:runAction(CCRepeatForever:create(CCSequence:create(fadeArray)))
		container:addChild(win_star_shine)
	end
	
	local delayTime = 0.5 + math.random()
	local spawn = CCSpawn:createWithTwoActions(CCFadeTo:create(0.1, 80), CCRotateBy:create(0.6, 360))
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(delayTime))
	array:addObject(spawn)
	array:addObject(CCFadeOut:create(0.1))
	
	return container
end

function LadybugAnimation:showStar( star, starName )
	if self[starName] then return end
	
	local position = star:getPosition()

	local shiningStars = Sprite:createWithSpriteFrameName("ladybug_rotated_star0000")
	local node = SpriteBatchNode:createWithTexture(shiningStars:getTexture())
	node:setPosition(ccp(position.x, position.y))
	self.layer:addChild(node)

    shiningStars:setAnchorPoint(ccp(0.5,0.5))
    shiningStars:setScale(0.6)
    shiningStars:runAction(CCRepeat:create(SpriteUtil:buildAnimate(SpriteUtil:buildFrames("ladybug_rotated_star%04d", 0, 11), 1/30), 1))
    node:addChild(shiningStars)

    local overlay = Sprite:createWithSpriteFrameName("ladybug_sunshine0000")
    overlay:setAnchorPoint(ccp(0.5,0.5))
    overlay:setOpacity(0)
    overlay:setScale(0.6)
    overlay:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 120)))
    local fadeIn = CCSpawn:createWithTwoActions(CCFadeTo:create(0.25, 200), CCScaleTo:create(0.25, 2.4))
    local fadeOut = CCSpawn:createWithTwoActions(CCFadeOut:create(0.6), CCScaleTo:create(0.6, 2))
    overlay:runAction(CCSequence:createWithTwoActions(fadeIn, fadeOut))
    node:addChild(overlay)

    self.background:stopAllActions()
    self.background:setRotation(0)
    self.background:runAction(CCRepeat:create(CCSequence:createWithTwoActions(CCRotateBy:create(0.03,-1), CCRotateBy:create(0.03,1)), 2))

    --star dust
	createStarDustAnimation(node)

    self.animal:playStar()

	self[starName] = node

	if star == self.star1 then
		self.starLevel = 1
	elseif star == self.star2 then
		self.starLevel = 2
	elseif star == self.star3 then
		self.starLevel = 3
	end
end

function LadybugAnimation:setBigStarVisible(starIndex, visible, ...)
	assert(type(starIndex) == "number")
	assert(type(visible) == "boolean")
	assert(#{...} == 0)

	local bigStarToControl		= false
	local smallStarToControl	= false

	if starIndex == 1 then
		bigStarToControl 	= self["bigstar1"]
		smallStarToControl	= self.star1
	elseif starIndex == 2 then
		bigStarToControl 	= self["bigstar2"]
		smallStarToControl	= self.star2
	elseif starIndex == 3 then
		bigStarToControl 	= self["bigstar3"]
		smallStarToControl	= self.star3
	elseif starIndex == 4 then -- four star level
		-- ignore
	end

	if bigStarToControl then
		bigStarToControl:setVisible(visible)
		smallStarToControl:setVisible(visible)
	end
end


function LadybugAnimation:getStarLevel(...)
	assert(#{...} == 0)
	return self.starLevel
end

function LadybugAnimation:getBigStarPosInWorldSpace(...)
	assert(#{...} == 0)

	local star1Pos	= self.star1:getPosition()
	local star2Pos	= self.star2:getPosition()
	local star3Pos	= self.star3:getPosition()
    local star4Pos  = self.fourthStar:getPosition()

	-- Convert To World Space
	local star1WorldPos = self.ladybug:convertToWorldSpace(ccp(star1Pos.x, star1Pos.y))
	local star2WorldPos = self.ladybug:convertToWorldSpace(ccp(star2Pos.x, star2Pos.y))
	local star3WorldPos = self.ladybug:convertToWorldSpace(ccp(star3Pos.x, star3Pos.y))
    local star4WorldPos = self.ladybug:convertToWorldSpace(ccp(star4Pos.x, star4Pos.y))

	return {star1WorldPos, star2WorldPos, star3WorldPos, star4WorldPos}
end

function LadybugAnimation:getBigStarSize(...)
	assert(#{...} == 0)

	local shiningStars = Sprite:createWithSpriteFrameName("ladybug_rotated_star0000")
	shiningStars:setScale(0.4)
	local size = shiningStars:getGroupBounds().size
	shiningStars:dispose()

	return size
end

function LadybugAnimation:addScoreStar( globalPosition )
	local batch = self.batch
	if batch == nil then return end

	local targetPosition = self.animal:getPosition()
	local r = 16 + math.random() * 10
	local localPosition = batch:convertToNodeSpace(globalPosition)
	for i = 1, 10 do	
		if math.random() > 0.6 then
			local angle = i * 36 * 3.1415926 / 180
			local x = localPosition.x + math.cos(angle) * r
			local y = localPosition.y + math.sin(angle) * r
			local sprite = Sprite:createWithSpriteFrameName("game_collect_small_star0000")
			sprite:setPosition(ccp(localPosition.x, localPosition.y))
			sprite:setScale(math.random()*0.6 + 0.7)
			sprite:setOpacity(0)
			local moveTime = 0.3 + math.random() * 0.64
			local moveTo = CCMoveTo:create(moveTime, ccp(targetPosition.x, targetPosition.y))
			local function onMoveFinished( ) sprite:removeFromParentAndCleanup(true) end
			local moveIn = CCEaseElasticOut:create(CCMoveTo:create(0.25, ccp(x, y)))
			local array = CCArray:create()
			array:addObject(CCSpawn:createWithTwoActions(moveIn, CCFadeIn:create(0.25)))
			array:addObject(CCEaseSineIn:create(moveTo))
			array:addObject(CCCallFunc:create(onMoveFinished))
			sprite:runAction(CCSequence:create(array))
			batch:addChild(sprite)
		end
	end
end

function LadybugAnimation:playFourStarAnimation()

    self:animateTo(1, 0.5) -- ladybug moves to the end

    self.sunshine:setVisible(true)
    self.sunshine:setScale(0)
    self.fourthStar:setVisible(true)
    self.fourthStar:setScale(0)

    local starZOrder = self.fourthStar:getZOrder()

    local fourStarAnimationArray = CCArray:create()
    local waitTime = CCDelayTime:create(0.5)
    fourStarAnimationArray:addObject(waitTime)

    -- ladybug turns into a star
    local animalAction = CCTargetedAction:create(self.animal.refCocosObj,
                        CCSpawn:createWithTwoActions(
                            CCRotateBy:create(1, 360*4),
                            CCSequence:createWithTwoActions(CCDelayTime:create(0.7), CCScaleTo:create(0.3, 1.2))
                                                        )
                                                 )
    local fourthStarSunshineAction = CCTargetedAction:create(self.sunshine.refCocosObj,
                                        CCSpawn:createWithTwoActions(
                                            CCRotateBy:create(1, -480),
                                            CCSequence:createWithTwoActions(
                                                CCScaleTo:create(0.6, 1), CCScaleTo:create(0.4, 0)
                                                                            )
                                                                     )
                                                             )
    local fourthStarWhite = self.fourthStar:getChildByName('star_white')
    local fourthStarWhiteAction = CCTargetedAction:create(fourthStarWhite.refCocosObj, CCFadeOut:create(0.8))

    local fourthStarAction = CCTargetedAction:create(self.fourthStar.refCocosObj,
                                CCEaseBounceOut:create(CCSpawn:createWithTwoActions(CCRotateBy:create(1, -360), CCScaleTo:create(1, 1)))
                                                     )

    local spawnArray = CCArray:create()
    spawnArray:addObject(fourthStarSunshineAction)
    spawnArray:addObject(fourthStarWhiteAction)
    spawnArray:addObject(fourthStarAction)


    local function hideStars()

        if self.star1 then self.star1:setVisible(false) end
        if self.star2 then self.star2:setVisible(false) end
        if self.star3 then self.star3:setVisible(false) end
        if self.bigstar1 then self.bigstar1:setVisible(false) end
        if self.bigstar2 then self.bigstar2:setVisible(false) end
        if self.bigstar3 then self.bigstar3:setVisible(false) end

    end

    local sequenceArray = CCArray:create()
    sequenceArray:addObject(animalAction)
    sequenceArray:addObject(CCSpawn:create(spawnArray))
    sequenceArray:addObject(CCCallFunc:create(hideStars))
    local animalToStarAction = CCSequence:create(sequenceArray)

    fourStarAnimationArray:addObject(animalToStarAction)


    -- shining branch effect
    self.fourStar_shining:setVisible(true)
    local spriteWidth = self.fourStar_shining:getContentSize().width
    local spriteHeight = self.fourStar_shining:getContentSize().height
    local spriteX = self.fourStar_shining:getPositionX()
    local spriteY = self.fourStar_shining:getPositionY()
    local maskIndex = self.fourStar_shining:getZOrder()
    local parent = self.fourStar_shining:getParent()
    self.fourStar_shining:removeFromParentAndCleanup(false)

    self.fourStar_shining = SpriteColorAdjust:createWithSpriteFrameName('fourstar_shining0000')
    self.fourStar_shining:setAnchorPoint(ccp(0, 1))

    local maskNode = ClippingNode:create({size = {width = spriteWidth, height = spriteHeight}})
    -- local maskNode = LayerColor:create()
    -- maskNode:setContentSize(CCSizeMake(spriteWidth, spriteHeight))
    maskNode:setAnchorPoint(ccp(0, 0))
    maskNode:setPosition(ccp(spriteX, spriteY - spriteHeight))
    maskNode:addChild(self.fourStar_shining)
    self.fourStar_shining:setPosition(ccp(0, spriteHeight))
    local maskStencil = maskNode:getStencil()
    maskStencil:setPosition(ccp(spriteWidth + 10, 0))
    parent:addChildAt(maskNode, maskIndex)
    local maskAction = CCEaseExponentialIn:create(CCMoveBy:create(0.5, ccp(-spriteWidth - 20, 0)))
    local branchAction = CCTargetedAction:create(maskStencil, maskAction)


    -- creating shining stars on the tree branch
    for i=1, 30 do 
        local win_star_shine = Sprite:createWithSpriteFrameName("win_star_shine0000")
        local choice = i % 6 + 1
        local pos = self.spine:getControlPointAtIndex(choice) or ccp(0, 0)
        local x = pos.x + math.random(-100, 10)
        local y = pos.y + math.random(-15, 20)
        local fadeArray = CCArray:create()
        fadeArray:addObject(CCDelayTime:create(math.random(0, 100)/100))
        fadeArray:addObject(CCFadeIn:create(0.3))
        fadeArray:addObject(CCDelayTime:create(math.random(10, 50)/100))
        fadeArray:addObject(CCFadeOut:create(0.4))
        
        win_star_shine:setPosition(ccp(x, y))
        win_star_shine:setOpacity(0)
        win_star_shine:setScale(math.random(20, 110) / 100)
        win_star_shine:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 100)))
        win_star_shine:runAction(CCRepeatForever:create(CCSequence:create(fadeArray)))
       self.star1:getParent():addChild(win_star_shine)
    end

    fourStarAnimationArray:addObject(branchAction)
    

    -- star effects
    local function createStarAction(delay)
        local smallScale = 0.3
        local largeScale = 1
        local duration = 1.3
        local scaleDuration = 0.7
        local ui = ResourceManager:sharedInstance():buildGroup("fourStar_starAnim")
        ui:setAnchorPoint(ccp(0.5, 1))
        local whiteStar = ui:getChildByName('star_white')
        whiteStar:setAnchorPoint(ccp(0.5, 1))
        local normalStar = ui:getChildByName('star_normal')
        normalStar:setAnchorPoint(ccp(0.5, 1))
        local sunshine = ui:getChildByName('sunshine')
        sunshine:setAnchorPoint(ccp(0.5, 1))
        local starHandle = ui:getChildByName('star_handle')
        whiteStar:setScale(smallScale)
        local whiteStarTmp = CCArray:create()
        whiteStarTmp:addObject(CCScaleTo:create(scaleDuration, largeScale))
        whiteStarTmp:addObject(CCFadeOut:create(scaleDuration))
        local whiteStarAction = CCTargetedAction:create(whiteStar.refCocosObj,
                                CCEaseExponentialOut:create(CCSpawn:create(whiteStarTmp))
                                                        )
        normalStar:setScale(smallScale)
        local normalStarTmp = CCArray:create()
        normalStarTmp:addObject(CCScaleTo:create(scaleDuration, largeScale))
        local normalStarAction = CCTargetedAction:create(normalStar.refCocosObj,
                                    CCEaseExponentialOut:create(CCSpawn:create(normalStarTmp))
                                                         )
        sunshine:setScale(0)
        sunshine:setAnchorPoint(ccp(0.5, 0.5))
        local sunshineTmp = CCArray:create()
        sunshineTmp:addObject(CCEaseExponentialOut:create(CCScaleTo:create(0.6, 1)))
        sunshineTmp:addObject(CCDelayTime:create(0.5))
        sunshineTmp:addObject(CCScaleTo:create(0.5, 0))
        local sequence = CCSequence:create(sunshineTmp)
        local rotate = CCRotateBy:create(1.3, 360)
        local sunshineAction = CCTargetedAction:create(sunshine.refCocosObj,
                                    CCSpawn:createWithTwoActions(sequence, rotate)
                                                         )
        ui:setRotation(90) -- left turn 90
        local uiAction = CCTargetedAction:create(ui.refCocosObj, 
                            CCSpawn:createWithTwoActions(
                                CCFadeIn:create(0.1),
                                CCEaseElasticOut:create(
                                    CCRotateBy:create(duration, -90)
                                                        )
                                                    )
                                                 )
        local actionBundleTmp = CCArray:create()-- delay time between stars
        actionBundleTmp:addObject(whiteStarAction)
        actionBundleTmp:addObject(normalStarAction)
        actionBundleTmp:addObject(sunshineAction)
        actionBundleTmp:addObject(uiAction)
        local function showStar()
            if ui and not ui.isDisposed then ui:setVisible(true) end
        end
        local retArray = CCArray:create()
        retArray:addObject(CCDelayTime:create(delay))
        retArray:addObject(CCCallFunc:create(showStar))
        retArray:addObject(CCSpawn:create(actionBundleTmp))
        local ret = CCSequence:create(retArray)
        return ui, ret
    end

    local spawnArray = CCArray:create()
    local delay = 0
    for i=3, 1, -1 do  -- the last star on top, the first on bottom
        local starAnim, action = createStarAction(delay)
        local starRes = self['star'..i]
        starRes:getParent():addChildAt(starAnim, starZOrder - 1)
        starAnim:setVisible(false)
        starAnim:setPosition(ccp(starRes:getPositionX(), starRes:getPositionY()))
        spawnArray:addObject(action)
        delay = delay + 0.3
    end
    fourStarAnimationArray:addObject(CCSpawn:create(spawnArray))

    -- creating leaves growing effect
    local leafArray = CCArray:create()
    for i=1,3 do 
        local leaf = self['leaf'..i]
        local function showLeaf()
            if leaf and not leaf.isDisposed then leaf:setVisible(true) end
        end
        local pos = nil
        if i % 2 == 0 then -- 2 goes here
            pos = ccp(-5, -20)
        else
            pos = ccp(0, 20) -- 1,3 goes here
        end
        local leafAction = CCTargetedAction:create(leaf.refCocosObj, CCSequence:createWithTwoActions(CCCallFunc:create(showLeaf),  CCMoveBy:create(0.8, pos)))
        leafArray:addObject(leafAction)
    end
    fourStarAnimationArray:addObject(CCSpawn:create(leafArray))

    self.ladybug:runAction(CCSequence:create(fourStarAnimationArray))


end