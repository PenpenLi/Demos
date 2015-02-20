require "hecore.display.Director"

HiddenBranchAnimation = class(Sprite)

function HiddenBranchAnimation:initStatic()
	local sprite = CCSprite:create()
	self:setRefCocosObj(sprite)
	--self.refCocosObj:setTexture(texture)

	local sprite1 = self:buildStatic("hide_branch10000", ccp(-15, -6))
	local sprite2 = self:buildStatic("hide_branch20000", ccp(-5, -40))
	local sprite3 = self:buildStatic("hide_branch30000", ccp(-20, -5))

	sprite2:setPosition(ccp(0, 10))
	sprite3:setPosition(ccp(0, 59))
	self.sprite1 = sprite1
	self.sprite2 = sprite2
	self.sprite3 = sprite3
	
	self:addChild(sprite1)
	self:addChild(sprite2)
	self:addChild(sprite3)
end

function HiddenBranchAnimation:createStatic()
	local v = HiddenBranchAnimation.new()
	v:initStatic()
	return v
end

function HiddenBranchAnimation:initAnim(callback)
	local sprite = CCSprite:create()
	self:setRefCocosObj(sprite)

	local callbackCounter = 0
	local function onAnimUnitCallback()
		callbackCounter = callbackCounter + 1
		if callbackCounter >= 3 then
			if callback and type(callback) == "function" then
				callback()
			end
		end
	end

	local sprite1 = self:buildAnim("hide_branch10000", "hiddenBranchMask1", ccp(-15, -6), onAnimUnitCallback)
	local sprite2 = self:buildAnim("hide_branch20000", "hiddenBranchMask2", ccp(-5, -40), onAnimUnitCallback)
	local sprite3 = self:buildAnim("hide_branch30000", "hiddenBranchMask3", ccp(-20, -5), onAnimUnitCallback)

	sprite1:setPosition(ccp(-15, -6))
	sprite2:setPosition(ccp(0, 10))
	sprite3:setPosition(ccp(0, 59))

	self:addChild(sprite1)
	self:addChild(sprite2)
	self:addChild(sprite3)
end

function HiddenBranchAnimation:createAnim(callback)
	local v = HiddenBranchAnimation.new()
	v:initAnim(callback)
	return v
end

function HiddenBranchAnimation:buildStatic(spriteName, offset)
	local sprite = Sprite:createWithSpriteFrameName(spriteName)
	sprite:setAnchorPoint(ccp(0, 0))
	sprite:setPosition(offset)

	return sprite
end

function HiddenBranchAnimation:buildAnim(spriteName, maskName, offset, animCallback)
	local sprite = Sprite:createWithSpriteFrameName(spriteName)
	sprite:setAnchorPoint(ccp(0, 0))

	local spriteSize = sprite:getContentSize()
	local spriteWidth = spriteSize.width
	local spriteHeight = spriteSize.height
	
	local frameLength = 37
	local pattern = maskName .. "%04d"

	local stencilNode = CCSprite:createWithSpriteFrameName(string.format(pattern, 0))
	stencilNode:setAnchorPoint(ccp(0, 0))
	stencilNode:setScale(2)
	stencilNode:setPosition(offset)

	local clip = ClippingNode.new(CCClippingNode:create(stencilNode))
	clip:setAlphaThreshold(0)
	clip:setAnchorPoint(ccp(0, 0))
	clip:addChild(sprite)

	local function onAnimationFinish()
		local layer = CCLayerColor:create(ccc4(255,255,255,255), spriteWidth, spriteHeight)
		layer:setAnchorPoint(ccp(0,0))
		clip:setStencil(layer)
		clip:setAlphaThreshold(1)
		if animCallback and type(animCallback) == "function" then
			animCallback()
		end
	end
	
	local animate = SpriteUtil:buildAnimate(SpriteUtil:buildFrames(pattern, 0, frameLength), 1 / 30)
	local rep = CCRepeat:create(animate, 1)
	local callback = CCCallFunc:create(onAnimationFinish)

	stencilNode:runAction(CCSequence:createWithTwoActions(rep, callback))

	return clip
end 

