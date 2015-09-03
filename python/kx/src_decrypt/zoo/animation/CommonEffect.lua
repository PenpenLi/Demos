-------------------------------------------------------------------------
--  Class include: CommonEffect, FallingStar, Firebolt
-------------------------------------------------------------------------

require "hecore.display.Director"
require "hecore.display.ArmatureNode"

local kCharacterAnimationTime = 1/26
local kRad3Ang = -180/3.1415926
local numberLineParticles = 0
--
-- CommonEffect ---------------------------------------------------------
--
CommonEffect = class()
function CommonEffect:reset()
	numberLineParticles = 0
end
function CommonEffect:buildLineEffect(batchNode)
	local node = Sprite:createEmpty()
	if batchNode then 
		node:setTexture(batchNode.refCocosObj:getTexture())
	end

	local function buildLightLine(direction)
		local sprite = Sprite:createWithSpriteFrameName("speed_line0000")
		sprite:setScale(0.1 * direction)
		sprite:setOpacity(0)
		sprite:setAnchorPoint(ccp(0.3,0.5))

		local lineAnimationTime = 0.25
		local function onLightAnimationEnd()
			if sprite and not sprite.isDisposed then
				sprite:stopAllActions()
				sprite:runAction(CCSpawn:createWithTwoActions(CCMoveBy:create(0.2, ccp(80*direction, 0)), CCFadeOut:create(0.2)))
			end
		end 

		local array = CCArray:create()
		array:addObject(CCScaleTo:create(0.2, 1*direction))
		array:addObject(CCFadeIn:create(0.1))
		array:addObject(CCMoveBy:create(0.4, ccp(100*direction, 0)))
		array:addObject(CCSequence:createWithTwoActions(CCDelayTime:create(0.4), CCCallFunc:create(onLightAnimationEnd)))
		array:addObject(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(onLightAnimationEnd)))
		sprite:runAction(CCSpawn:create(array))
		return sprite
	end

	local function createStars( ... )
		-- body
		local maxStar = 10
		for k = 1, maxStar do 
			local sprite = Sprite:createWithSpriteFrameName("star")
			sprite:setScale(math.random())
			sprite:setOpacity(0)
			local x =( k - 5) * 50
			local index = k %2 == 0 and 1 or -1
			local y = math.random() *20 * index
			sprite:setPosition(ccp(x,y))
			local actionList = CCArray:create()
			actionList:addObject(CCFadeIn:create(0.1))
			actionList:addObject(CCDelayTime:create(0.5))
			actionList:addObject(CCFadeOut:create(0.2))
			sprite:runAction(CCSpawn:createWithTwoActions(CCSequence:create(actionList), CCRotateBy:create(2, 720)))
			node:addChild(sprite)

		end
	end

	local function onLightAnimationBegin()
		local right = buildLightLine(1)
		right:setPositionXY(0, 0)
		node:addChildAt(right,0)
		local left = buildLightLine(-1)
		left:setPositionXY(0, 0)
		node:addChildAt(left,0)
	end

	

	local function onAnimationFinished() 
		node:removeFromParentAndCleanup(true)
		numberLineParticles = numberLineParticles - 1
		if numberLineParticles < 0 then numberLineParticles = 0 end
	end

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.2))
	array:addObject(CCCallFunc:create(onLightAnimationBegin))
	array:addObject(CCDelayTime:create(1.2))
	array:addObject(CCCallFunc:create(onAnimationFinished))
	node:runAction(CCSequence:create(array))

	local displayParticles = true
	if numberLineParticles > 4 then
		displayParticles = false
		if math.random() < 0.35 then displayParticles = true end
	end
	if _G.__use_low_effect then displayParticles = false end
	if displayParticles then
		numberLineParticles = numberLineParticles + 1
		createStars()
	end

	return node
end


function CommonEffect:buildBonusLineEffect()
	local node = CocosObject:create()
	node:setScaleY(2)

	local function buildLightLine(direction)
		local sprite = Sprite:createWithSpriteFrameName("speed_line_yellow0000")
		sprite:setScale(0.1*direction)
		sprite:setOpacity(0)
		sprite:setAnchorPoint(ccp(0.3,0.5))

		local lineAnimationTime = 0.25
		local function onLightAnimationEnd()
			if sprite and not sprite.isDisposed then
				sprite:stopAllActions()
				sprite:runAction(CCSpawn:createWithTwoActions(CCMoveBy:create(0.2, ccp(80*direction, 0)), CCFadeOut:create(0.2)))
			end
		end 

		local array = CCArray:create()
		array:addObject(CCScaleTo:create(0.2, 1*direction))
		array:addObject(CCFadeIn:create(0.1))
		array:addObject(CCMoveBy:create(lineAnimationTime, ccp(100*direction, 0)))
		array:addObject(CCSequence:createWithTwoActions(CCDelayTime:create(lineAnimationTime), CCCallFunc:create(onLightAnimationEnd)))
		sprite:runAction(CCSpawn:create(array))
		return sprite
	end

	local function onLightAnimationBegin()
		local right = buildLightLine(1)
		right:setPositionXY(0, 0)
		node:addChildAt(right,0)
		local left = buildLightLine(-1)
		left:setPositionXY(0, 0)
		node:addChildAt(left,0)
	end

	local function onAnimationFinished() node:removeFromParentAndCleanup(true) end
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.2))
	array:addObject(CCCallFunc:create(onLightAnimationBegin))
	array:addObject(CCDelayTime:create(1.2))
	array:addObject(CCCallFunc:create(onAnimationFinished))
	node:runAction(CCSequence:create(array))

	if not _G.__use_low_effect then 
		local starLine = ParticleSystemQuad:create("particle/star_line_yellow.plist")
		starLine:setAutoRemoveOnFinish(true)
		starLine:setPosition(ccp(0,0))
		node:addChild(starLine)

		local rightSpeed = ParticleSystemQuad:create("particle/speed_right.plist")
		rightSpeed:setAutoRemoveOnFinish(true)
		rightSpeed:setPosition(ccp(0,0))
		node:addChild(rightSpeed)

		local leftSpeed = ParticleSystemQuad:create("particle/speed_left.plist")
		leftSpeed:setAutoRemoveOnFinish(true)
		leftSpeed:setPosition(ccp(0,0))
		node:addChild(leftSpeed)
	end

	return node
end

function CommonEffect:buildRequireSwipePanel()
	local container = CocosObject:create()
	local function onAnimationFinished() container:removeFromParentAndCleanup(true) end
	local panel = ResourceManager:sharedInstance():buildGroup("panel_require_swape")
	local targetSize = panel:getGroupBounds().size
	local label = panel:getChildByName("label")
	label:setString(Localization:getInstance():getText("level.help.require.swipe"))
	panel:setPosition(ccp(-targetSize.width/2, targetSize.height/2 + 100))
	container:addChild(panel)

	local panelChildren = {}
	panel:getVisibleChildrenList(panelChildren)
	for i,child in ipairs(panelChildren) do
		local array = CCArray:create()
		array:addObject(CCFadeIn:create(0.3))
		array:addObject(CCDelayTime:create(0.7))
		array:addObject(CCFadeOut:create(0.1))
		child:setOpacity(0)
		child:runAction(CCSequence:create(array))
	end

	local seq = CCArray:create()
	seq:addObject(CCEaseElasticOut:create(CCMoveBy:create(0.3, ccp(0, -100)))) 
	seq:addObject(CCDelayTime:create(0.8))
	seq:addObject(CCCallFunc:create(onAnimationFinished))
	panel:runAction(CCSequence:create(seq))
	return container
end

local kSpecialEffectName = {"good_icon", "great_icon", "excellent_icon", "amazing_icon", "unbelievable_icon"}
function CommonEffect:buildSpecialEffectTitle( effectType )
	effectType = effectType or 1
	local winSize = CCDirector:sharedDirector():getVisibleSize()
	local winOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local textureKey = kSpecialEffectName[effectType] or "good_icon"
	local sprite = Sprite:createWithSpriteFrameName(textureKey .. " instance 10000") 
	local textureSize = sprite:getContentSize()
	local width, height = textureSize.width + 100, textureSize.height + 50

	local container = SpriteBatchNode:createWithTexture(sprite:getTexture())
	local topHeight = GamePlayConfig_Top_Height * winSize.width / GamePlayConfig_Design_Width
	local bottomHeight = GamePlayConfig_Bottom_Height * winSize.width / GamePlayConfig_Design_Width
	local actualY = winOrigin.y + (winSize.height - topHeight - bottomHeight) * 0.7 + bottomHeight
	container:setPosition(ccp(winSize.width/2, actualY))
	container:addChild(sprite)

	for i = 1, 6 do
		local win_star_shine = Sprite:createWithSpriteFrameName("title_star_shine instance 10000")
		local x = math.random() * width - width * 0.5
		local y = math.random() * height - height * 0.5
		local fadeArray = CCArray:create()
		fadeArray:addObject(CCDelayTime:create(0.3 + math.random() * 0.5))
		fadeArray:addObject(CCFadeIn:create(0.2))
		fadeArray:addObject(CCFadeOut:create(0.3))
		
		win_star_shine:setPosition(ccp(x, y))
		win_star_shine:setOpacity(0)
		win_star_shine:setScale(math.random() * 0.6 + 0.6)
		win_star_shine:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 100)))
		win_star_shine:runAction(CCRepeatForever:create(CCSequence:create(fadeArray)))
		container:addChild(win_star_shine)
	end

	local function onAnimationFinished( )
		container:removeFromParentAndCleanup(true)
	end
	local array = CCArray:create()
	array:addObject(CCSpawn:createWithTwoActions(CCEaseElasticOut:create(CCScaleTo:create(0.6, 1.3)), CCFadeIn:create(0.25)))
	array:addObject(CCDelayTime:create(0.3))
	array:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(0.3), CCScaleTo:create(0.3, 1.6)))
	array:addObject(CCCallFunc:create(onAnimationFinished))

	sprite:setOpacity(0)
	sprite:setScale(0)	
	sprite:runAction(CCSequence:create(array))

	return container
end

function CommonEffect:buildBonusEffect()
	local winSize = CCDirector:sharedDirector():getVisibleSize()
	local node = CocosObject:create()
	node:setPosition(ccp(winSize.width/2, winSize.height/2 + 130))

	local function onAnimationFinished() node:removeFromParentAndCleanup(true) end
	local textSeq = CCArray:create()
	textSeq:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.3, 1.2), CCFadeIn:create(0.3)))
	textSeq:addObject(CCDelayTime:create(2.3))
	textSeq:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.2, 1.5), CCFadeOut:create(0.2)))
	textSeq:addObject(CCDelayTime:create(0.4))
	textSeq:addObject(CCCallFunc:create(onAnimationFinished))

	local text = Sprite:createWithSpriteFrameName("bonustime_icon instance 10000")
	local container = SpriteBatchNode:createWithTexture(text:getTexture())
	node:addChild(container)

	text:setScale(0.5)
	text:setOpacity(0)
	text:runAction(CCSequence:create(textSeq))
	container:addChild(text)	

	local overlay = Sprite:createWithSpriteFrameName("title_text_overlay instance 10000")

	local function onPlayAnimationEnd()
		node:addChildAt(CommonEffect:buildBonusLineEffect(), 1)
	end

	local overlaySeq = CCArray:create()
	overlaySeq:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.3, 1), CCFadeIn:create(0.3)))
	overlaySeq:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(0.5), CCScaleTo:create(0.5, 1.3)))
	overlaySeq:addObject(CCFadeTo:create(1.3, 30))
	overlaySeq:addObject(CCCallFunc:create(onPlayAnimationEnd))
	overlaySeq:addObject(CCFadeTo:create(0.2, 50))
	overlaySeq:addObject(CCFadeOut:create(0.6))
	
	overlay:setScale(0.5)
	overlay:setOpacity(0)
	overlay:runAction(CCSequence:create(overlaySeq))
	container:addChild(overlay)

	for i = 1, 8 do
		local win_star_shine = Sprite:createWithSpriteFrameName("title_star_shine instance 10000")
		local x = math.random() * 500 - 280
		local y = math.random() * 150 - 80
		local fadeArray = CCArray:create()
		fadeArray:addObject(CCDelayTime:create(0.3 + math.random() * 0.5))
		fadeArray:addObject(CCFadeIn:create(0.2))
		fadeArray:addObject(CCFadeOut:create(0.3))
		
		win_star_shine:setPosition(ccp(x, y))
		win_star_shine:setOpacity(0)
		win_star_shine:setScale(math.random() * 0.6 + 0.6)
		win_star_shine:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 100)))
		win_star_shine:runAction(CCRepeatForever:create(CCSequence:create(fadeArray)))
		container:addChild(win_star_shine)
	end

	node:addChild(CommonEffect:buildBonusLineEffect())

	return node
end

function CommonEffect:buildExplodeEffect()
	CommonEffect:preLoadCommonEffectResource()
	local node = CocosObject:create()
	node.name = "explode"
	node.touchEnabled = false
	node.touchChildren = false
	node:setScale(ViewSizeUtil.getScale())

	local destroySprite = Sprite:createWithSpriteFrameName("explode0000")
	node:addChild(destroySprite)

	local frames = SpriteUtil:buildFrames(node.name.."%04d", 0, 19)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)

	local function onRepeatFinishCallback()
		node:dp(Event.new(Events.kComplete, nil, node))
	end 
	destroySprite:play(animate, 0, 1, onRepeatFinishCallback)
	return node
end

function CommonEffect:buildGetPropLightAnimWithoutBg()
	local fps = 30
	FrameLoader:loadImageWithPlist("flash/get_prop_bganim.plist")
	local anim = Sprite:createEmpty()
	anim.lightBg1 = Sprite:createWithSpriteFrameName("circleLight.png")
	anim.lightBg1:setAnchorPoint(ccp(0.5, 0.5))
	anim.lightBg1:setScale(0.6)
	anim:addChild(anim.lightBg1)

	anim.lightBg1:runAction(CCSpawn:createWithTwoActions(CCScaleTo:create(7 / fps, 1.08), CCFadeTo:create(7 / fps, 0.6 * 255)))
	anim.lightBg1:runAction((CCRepeatForever:create(CCRotateBy:create(0.1, 9))))

	local function createLight()
		local container = Sprite:createEmpty()
		container:setAnchorPoint(ccp(0.5, 0.5))

		local opacity = 0.78 * 255
		local sprite = Sprite:createWithSpriteFrameName("circleLight2.png")
		sprite:setAnchorPoint(ccp(0.5, 0.5))
		sprite:setScale(0.88)
		sprite:setOpacity(0.92 * opacity)
		container:addChild(sprite)
		
		local seq = CCArray:create()
		seq:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(17 / fps, 1.14), CCFadeTo:create(17 / fps, opacity)))
		seq:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(19 / fps, 0.88), CCFadeTo:create(19 / fps, 0.92 * opacity)))
		sprite:runAction(CCRepeatForever:create(CCSequence:create(seq)))
		return container
	end

	local function createStarAnim()
		local container = Sprite:createEmpty()
		container:setAnchorPoint(ccp(0.5, 0.5))

		local starLight = Sprite:createWithSpriteFrameName("star_light.png")
		local star = Sprite:createWithSpriteFrameName("star.png")

		container:addChild(starLight)
		container:addChild(star)

		local lightAnim = CCSpawn:createWithTwoActions(CCScaleTo:create(10 / fps, 1), CCFadeTo:create(10 / fps, 0.1 * 255))
		local function resetLight() 
			starLight:setScale(0.5)
			starLight:setOpacity(255)
		end
		resetLight()
		local lightSeq = CCSequence:createWithTwoActions(lightAnim, CCCallFunc:create(resetLight))
		starLight:runAction(CCRepeatForever:create(lightSeq))
		local function resetStar()
			star:setOpacity(255)
			star:setScale(0.94)
		end
		resetStar()
		local spawnArr = CCArray:create()
		spawnArr:addObject(CCRotateBy:create(10 / fps, 90))
		spawnArr:addObject(CCFadeTo:create(10 / fps, 0.1 * 255))
		spawnArr:addObject(CCScaleTo:create(10 / fps, 1.22))
		local starAnim = CCSpawn:create(spawnArr)
		local starSeq = CCSequence:createWithTwoActions(starAnim, CCCallFunc:create(resetStar))
		star:runAction(CCRepeatForever:create(starSeq))

		return container
	end

	anim.lightBg3 = createLight()
	anim.lightBg3:setScale(0.85)
	anim:addChild(anim.lightBg3)
	anim.lightBg3:runAction(CCScaleTo:create(7 / fps, 1.4))

	anim.lightBg2 = createLight()
	anim.lightBg2:setScale(1.05)
	anim:addChild(anim.lightBg2)
	local ops = {{x=-1, y=1}, {x=1, y=1},{x=1, y=-1},{x=-1, y=-1}}
	for i = 1, 14 do
		local star = createStarAnim()
		local op = ops[i%4 + 1]
		local posX = (400 - math.random(400)) / 10 * op.x -- [0, 40]
		local posY = (400 - math.random(400)) / 10 * op.y -- [0, 40]

		local pos = ccp(posX, posY)
		star:setPosition(pos)
		-- star:setRotation(math.random(90))
		star:setScale(0.4 + math.random(5) / 10)

		local deltaX, deltaY = 0, 0
		local deltaDistance = (100 + math.random(50))
		if pos.x == 0 or pos.y == 0 then 
			if pos.x == 0 and pos.y ~= 0 then 
				deltaY = deltaDistance
			elseif pos.y == 0 and pos.x ~= 0 then 
				deltaX = deltaDistance 
			else
				deltaX = math.random(deltaDistance)
				deltaY = math.sqrt(deltaDistance * deltaDistance - deltaX * deltaX)
			end
			if math.random(10) > 5 then deltaX = 0-deltaX end
			if math.random(10) > 5 then deltaY = 0-deltaY end
		else
			local a = math.sqrt(pos.x * pos.x + pos.y * pos.y)
			deltaX = deltaDistance * pos.x / a
			deltaY = deltaDistance * pos.y / a
		end

		local function onAnimFinished()
			star:removeFromParentAndCleanup(true)
		end
		local seq = CCArray:create()
		seq:addObject(CCMoveBy:create(6 / fps, ccp(deltaX * 3 / 7, deltaY * 3 / 7)))
		seq:addObject(CCMoveBy:create(9 / fps, ccp(deltaX * 4 / 7, deltaY * 4 / 7)))
		seq:addObject(CCCallFunc:create(onAnimFinished))
		star:runAction(CCSequence:create(seq))
		anim:addChild(star)
	end

	return anim
end

function CommonEffect:buildGetPropLightAnim( text )
	local anim = Layer:create()
	anim.blackLayer = LayerColor:create()
	local winSize = CCDirector:sharedDirector():getWinSize()
	local blackBgScale = 1

	local blackWidth = winSize.width*blackBgScale*2
	local blackHeight = winSize.height*blackBgScale
	anim.blackLayer:changeWidthAndHeight(blackWidth, blackHeight)
	anim.blackLayer:setPosition(ccp(-blackWidth/2,-blackHeight/2))
	anim.blackLayer:setOpacity(150)
	anim:addChild(anim.blackLayer)

	local lightAnim = CommonEffect:buildGetPropLightAnimWithoutBg()
	lightAnim:setScale(1.23)
	anim:addChild(lightAnim)

	local sequenceArr3 = CCArray:create()
	sequenceArr3:addObject(CCDelayTime:create(2.5))
	sequenceArr3:addObject(CCFadeTo:create(0.3, 0))
	local function onAnimationFinished()
		anim:removeFromParentAndCleanup(true)
	end
	sequenceArr3:addObject(CCCallFunc:create(onAnimationFinished))
	anim.blackLayer:setTouchEnabled(true, 0, true)
	anim.blackLayer:stopAllActions()             
	anim.blackLayer:runAction(CCSequence:create(sequenceArr3))

	if type(text) == "string" then
		local label = TextField:create(text, nil, 30)
		label:setHorizontalAlignment(kCCTextAlignmentCenter)
		label:setAnchorPoint(ccp(0.5, 0.5))
		label:setPosition(ccp(0, 180))
		anim:addChild(label)
	end
	return anim
end

--
-- FallingStar ---------------------------------------------------------
--
FallingStar = class(Layer)

function FallingStar:buildUI(useWhiteColor)
  local textureKey = "fallingstar0000"
  if useWhiteColor then textureKey = "fallingstar_white0000" end

  local sprite = Sprite:createWithSpriteFrameName(textureKey)
  sprite:setAnchorPoint(ccp(0.5, 0.05))
  self:addChild(sprite)
  self.sprite = sprite

  if not _G.__use_low_effect then 
	  local particle = ParticleSystemQuad:create("particle/falling_star.plist")
	  particle:setPosition(ccp(0,0))
	  self:addChild(particle)
  end
end
function FallingStar:create(from, to, animationCallbackFunc, flyFinishedCallback, useWhiteColor, isHalloween)
  local ret = FallingStar.new()
  ret:initLayer()
  ret:buildUI(useWhiteColor)
  ret:fly(from, to, animationCallbackFunc, flyFinishedCallback, isHalloween)
  return ret
end

function FallingStar:fly( from, to, animationCallbackFunc, flyFinishedCallback, isHalloween )
  local dx = to.x - from.x
  local dy = to.y - from.y
  local distance = dx * dx + dy * dy
  local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
  local visibleHeight = visibleSize.height
  local time = 1.5*math.sqrt(distance)/visibleHeight		-- 1280 as screen height

  if isHalloween then
    time = time * 3
    self:setScale(1.5)
  end

  -- local time = distance*0.000005
  --if time > 1 then time = 1 end
  --if time < 0.5 then time = 0.5 end
  local angle = math.atan2(dy, dx) * kRad3Ang
  local function onAnimationFinished()
    if animationCallbackFunc ~= nil then animationCallbackFunc() end
    self:removeFromParentAndCleanup(true)
  end

  time = time * 0.7
  self.time = time
  local halfTime = time * 0.5
  local fadeIn = CCSpawn:createWithTwoActions(CCScaleTo:create(halfTime * 1.5, 2, 1.3), CCFadeIn:create(halfTime))
  local fadeOut = CCSpawn:createWithTwoActions(CCScaleTo:create(halfTime * 0.5, 0), CCFadeOut:create(halfTime * 0.5))
  local sprite = self.sprite
  sprite:setRotation(angle-90)
  sprite:setScale(0)
  sprite:setOpacity(0)
  sprite:runAction(CCSequence:createWithTwoActions(fadeIn, fadeOut))

  local array = CCArray:create()
  array:addObject(CCEaseSineInOut:create(CCMoveTo:create(time, to)))
  if flyFinishedCallback ~= nil then array:addObject(CCCallFunc:create(flyFinishedCallback)) end
  array:addObject(CCDelayTime:create(0.6))
  array:addObject(CCCallFunc:create(onAnimationFinished))
  self:setPosition(from)
  self:runAction(CCSequence:create(array))
end


--
-- Firebolt ---------------------------------------------------------
--
Firebolt = class(Layer)

function Firebolt:buildUI()
	--local glow = Sprite:createWithSpriteFrameName("")

	local sprite = Sprite:createWithSpriteFrameName("thunder_effect10000")
	sprite:setAnchorPoint(ccp(0.5, 0.05))
	self:addChild(sprite)
	self.sprite = sprite

	if not _G.__use_low_effect then 
		local particle = ParticleSystemQuad:create("particle/falling_star.plist")
		particle:setPosition(ccp(0,0))
		self:addChild(particle)
	end
end
function Firebolt:create(from, to, duration, animationCallbackFunc)
  local ret = Firebolt.new()
  ret:initLayer()
  ret:buildUI()
  ret:fly(from, to, duration, animationCallbackFunc)
  return ret
end

function Firebolt:fly( from, to, duration, animationCallbackFunc )
  local dx = to.x - from.x
  local dy = to.y - from.y
  local distance = dx * dx + dy * dy
  local time = duration or 0.4
  local angle = math.atan2(dy, dx) * kRad3Ang
  local function onAnimationFinished()
    if animationCallbackFunc ~= nil then animationCallbackFunc() end
    self:removeFromParentAndCleanup(true)
  end

  local halfTime = time * 0.5
  local fadeIn = CCSpawn:createWithTwoActions(CCScaleTo:create(halfTime, 2, 1.5), CCFadeIn:create(halfTime))
  local fadeOut = CCSpawn:createWithTwoActions(CCScaleTo:create(halfTime, 0), CCFadeOut:create(halfTime))
  local sprite = self.sprite
  sprite:setRotation(angle-90)
  sprite:setScale(0)
  sprite:setOpacity(0)
  sprite:runAction(CCSequence:createWithTwoActions(fadeIn, fadeOut))

  local array = CCArray:create()
  array:addObject(CCEaseSineInOut:create(CCMoveTo:create(time, to)))
  array:addObject(CCDelayTime:create(0.1))
  array:addObject(CCCallFunc:create(onAnimationFinished))
  self:setPosition(from)
  self:runAction(CCSequence:create(array))
end

function Firebolt:createLightOnly( from, to, duration, animationCallbackFunc )
	local sprite = Sprite:createWithSpriteFrameName("thunder_effect20000")
	local container = SpriteBatchNode:createWithTexture(sprite:getTexture())

	sprite:setAnchorPoint(ccp(0.5, 0.05))
	local bird = Sprite:createWithSpriteFrameName("colorbird_effect0000")

	local dx = to.x - from.x
  	local dy = to.y - from.y
  	local distance = dx * dx + dy * dy
  	local time = duration or 0.4
  	local angle = math.atan2(dy, dx) * kRad3Ang
  	local function onLightAnimationEnd()
  		container:removeFromParentAndCleanup(true)
  	end
	local function onAnimationFinished()
		local kStarFactor = 360*3.1415926 / 180
		local fadeOutTime = 0.2
		if animationCallbackFunc ~= nil then animationCallbackFunc() end
		bird:runAction(CCSequence:createWithTwoActions(CCSpawn:createWithTwoActions(CCScaleTo:create(fadeOutTime, 2),CCFadeOut:create(fadeOutTime)), CCCallFunc:create(onLightAnimationEnd)))
		for i = 0, 10 do
			local fadeTime = 0.2 + math.random() * 0.3
			local angle = math.random()*kStarFactor
			local x = math.cos(angle) * (80 + math.random() * 10) 
			local y = math.sin(angle) * (80 + math.random() * 10) 
			local star = Sprite:createWithSpriteFrameName("color_bird_star0000")
			star:setScale(1 + math.random())
			star:setPosition(ccp(math.random()* 15-8, math.random()*15-8))
			star:runAction(CCSpawn:createWithTwoActions(CCMoveTo:create(fadeTime, ccp(x, y)), CCFadeOut:create(fadeTime)))
			container:addChildAt(star, 0)
		end
	end

	local halfTime = (time-0.1) * 0.5

	bird:setOpacity(0)
	bird:runAction(CCFadeIn:create(halfTime))

	local fadeArray = CCArray:create()
	fadeArray:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(halfTime, 2, 1), CCFadeIn:create(halfTime)))
	fadeArray:addObject(CCDelayTime:create(0.1))
	fadeArray:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(halfTime, 2, 0), CCFadeOut:create(halfTime)))
	
	sprite:setRotation(angle-90)
	sprite:setScaleY(0)
	sprite:setOpacity(0)	
	sprite:runAction(CCSequence:create(fadeArray))

	local array = CCArray:create()
	array:addObject(CCEaseSineInOut:create(CCMoveTo:create(time, to)))
	array:addObject(CCDelayTime:create(0.1))
	array:addObject(CCCallFunc:create(onAnimationFinished))
	container:runAction(CCSequence:create(array))
	container:setPosition(from)
	
	container:addChild(bird)
	container:addChild(sprite)
	return container
end
