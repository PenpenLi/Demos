
TileHoney = class(CocosObject)

local kCharacterAnimationTime = 1/30
function TileHoney:create()
	local node = TileHoney.new(CCNode:create())
	node.name = "honey"
	return node
end

function TileHoney:normal()
	-- body
	if not self.mainSprite then 
		self.mainSprite = Sprite:createWithSpriteFrameName("honey_normal_0000")
		self:addChild(self.mainSprite)
	end
	self.mainSprite:stopAllActions()
	local frames = SpriteUtil:buildFrames("honey_normal_%04d", 0 , 21)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.mainSprite:play(animate)
end

function TileHoney:add( callback )
	-- body
	if not self.mainSprite then 
		self.mainSprite = Sprite:createWithSpriteFrameName("honey_add_0000")
		self:addChild(self.mainSprite)
	end
	self.mainSprite:stopAllActions()
	local frames = SpriteUtil:buildFrames("honey_add_%04d", 0 , 28)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.mainSprite:play(animate, 0, 1, callback)
end

function TileHoney:disappear( callback )
	-- body
	if not self.mainSprite then 
		self.mainSprite = Sprite:createWithSpriteFrameName("honey_disappear_0000")
		self:addChild(self.mainSprite)
	end
	self.mainSprite:stopAllActions()
	local frames = SpriteUtil:buildFrames("honey_disappear_%04d", 0 , 19)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.mainSprite:play(animate, 0, 1, callback)
end

function TileHoney:createFlyAnimation( fromPos, toPos, callback )
	-- body
	local sprite = Sprite:createWithSpriteFrameName("light_track_0000")
	local frames = SpriteUtil:buildFrames("light_track_%04d", 0, 18)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	sprite:play(animate)
	local rotation = 0
	if toPos.y - fromPos.y > 0 then
		rotation = math.deg(math.atan((toPos.x - fromPos.x)/(toPos.y - fromPos.y)))
	elseif toPos.y -fromPos.y < 0 then
		rotation = 180 + math.deg(math.atan((toPos.x - fromPos.x) / (toPos.y - fromPos.y)))
	else
		if toPos.x - fromPos.x > 0 then rotation = 90
		else
			rotation = -90
		end
	end
	sprite:setRotation(rotation)
	sprite:setPosition(fromPos)
	local actionList = CCArray:create()
	actionList:addObject(CCMoveTo:create(0.4, toPos))
	actionList:addObject(CCCallFunc:create(callback))
	sprite:runAction(CCSequence:create(actionList))

	return sprite
end
