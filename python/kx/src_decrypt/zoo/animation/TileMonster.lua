TileMonster = class(CocosObject)

local kCharacterAnimationTime = 1/30
local animationList = table.const
{
	kNormal = 1,
	kEncourage = 2,
	kJump = 3
}

function TileMonster:create()
	-- body
	local node = TileMonster.new(CCNode:create())
	node.name = "tile_monster"
	node:initMonster()
	return node
end

function TileMonster:initMonster( ... )
	-- body
	local mainSprite = Sprite:createWithSpriteFrameName("BigMonster_ext_0000")
	self.mainSprite = mainSprite
	self.currentAnimation = nil
	self:addChild(mainSprite)

	-- self:testAnimation()
end

function TileMonster:playNormalAnimation( callback )
	-- body
end

function TileMonster:playEncourageAnimation( callback )
	-- body
	if self.currentAnimation == animationList.kEncourage then
		if callback and type(callback) == "function" then callback() end
		return 
	end

	local function animationCallback( ... )
		-- body
		self.currentAnimation = nil
		if callback and type(callback) == "function" then callback() end

	end

	if self.mainSprite then 
		self.currentAnimation = animationList.kEncourage
		local frames = SpriteUtil:buildFrames("BigMonster_ext_%04d", 0, 34)
		local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
		self.mainSprite:play(animate, 0, 1, animationCallback)
	end


end

function TileMonster:playJumpAnimation( callback )
	-- body
	if not self.mainSprite then callback() return end
	self.mainSprite:stopAllActions()

	local function animationCallback( ... )
		-- body
		GamePlayMusicPlayer:playEffect(GameMusicType.kMonsterJumpOut)
		local action = CCSequence:createWithTwoActions(CCFadeOut:create(0.5), CCCallFunc:create(callback))
		self.mainSprite:runAction(action)

	end
	self.currentAnimation = animationList.kJump
	local frames = SpriteUtil:buildFrames("BigMonster_jump_%04d", 0, 45)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.mainSprite:play(animate, 0, 1, animationCallback)
end

---------------------------
--测试各种动画
---------------------------
function TileMonster:testAnimation( ... )
	-- body
	local function jumpAniamtioncallback( ... )
		-- body
		print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< jumpAniamtioncallback")

	end
	
	local function animationcallback( ... )
		-- body
		self:playJumpAnimation(jumpAniamtioncallback)

	end

	local function delaycallback( ... )
		-- body
		self:playEncourageAnimation(animationcallback)
	end

	local action_delay = CCDelayTime:create(2)
	local action_callback = CCCallFunc:create(delaycallback)
	self:runAction(CCSequence:createWithTwoActions(action_delay, action_callback))
end