TileBlackCuteBall = class(CocosObject)
local kCharacterAnimationTime = 1/30
function TileBlackCuteBall:create(strength)
	local s = TileBlackCuteBall.new(CCNode:create())
	s.animation = Sprite:createWithSpriteFrameName("black_cute_ball_2_0000")
	s:addChild(s.animation)
	if strength >= 2 then
		local function callback( ... )
			-- body
			s:playLife2()
		end 
		s:playLifeP1(callback)
	elseif strength == 1 then
		s:playLife1()
	end
	return s
end

function TileBlackCuteBall:playLife2(callback)
	-- body
	self.animation:stopAllActions()
	local frames = SpriteUtil:buildFrames("black_cute_ball_2_%04d", 0, 1)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.animation:play(animate)
	if callback then callback() end
end

function TileBlackCuteBall:playLife1( callback )
	-- body
	self.animation:stopAllActions()
	local frames = SpriteUtil:buildFrames("black_cute_ball_1_%04d", 0, 28)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.animation:play(animate)

	if callback then callback() end
end

function TileBlackCuteBall:playLife0( callback )
	-- body
	self.animation:stopAllActions()
	local frames = SpriteUtil:buildFrames("black_cute_ball_0_%04d", 0, 34)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.animation:play(animate, 0, 1, callback)
end

function TileBlackCuteBall:playLifeP1( callback )
	-- body
	self.animation:stopAllActions()
	local frames = SpriteUtil:buildFrames("black_cute_ball_p1_%04d", 0, 29)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.animation:play(animate, 0, 1, callback)
end

function TileBlackCuteBall:playJump0( callback )
	-- body
	self.animation:stopAllActions()
	local frames = SpriteUtil:buildFrames("black_cute_ball_jump0_%04d", 0, 5)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.animation:play(animate, 0, 1, callback)
end

function TileBlackCuteBall:playJump1(  callback )
	-- body
	self.animation:stopAllActions()
	local frames = SpriteUtil:buildFrames("black_cute_ball_jump1_%04d", 11, 18)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.animation:play(animate, 0, 1, callback)
end

function TileBlackCuteBall:playJumpToAnimation( toPosition,midcallback, callback )
	-- body
	local function endJumpCallback( ... )
		-- body
		if callback then callback() end
	end

	local function jumppingCallback( ... )
		-- body
		self:playJump1(endJumpCallback)
		if midcallback then midcallback() end
	end

	local function startJumpCallback( ... )
		-- body
		self:playLife2()
		local fromPos = self:getPosition()
		local jumpHeight = math.abs(toPosition.y - fromPos.y) /2 + GamePlayConfig_Tile_Height * 1.5
		local actionList  = CCArray:create()
		actionList:addObject(CCJumpTo:create(0.5, toPosition, jumpHeight, 1))
		actionList:addObject(CCCallFunc:create(jumppingCallback))
		self:runAction(CCSequence:create(actionList))
	end  
	self:playJump0(startJumpCallback)
end