TileMonsterFrosting = class(CocosObject)

local kCharacterAnimationTime = 1/30

function TileMonsterFrosting:create(frostingType)
	local node = TileMonsterFrosting.new(CCNode:create())
	node.name = "tile_monster_frosting_"..frostingType
	node:initFrostring(frostingType)
	return node
end

function TileMonsterFrosting:initFrostring( frostingType )
	-- body
	local str = string.format("big_monster_frosting_%04d", frostingType - 1)
	self.mainSprite = Sprite:createWithSpriteFrameName(str)
	self:addChild(self.mainSprite)
end

function TileMonsterFrosting:playDestroyAnimation( callback )
	-- body
	
	local frames = SpriteUtil:buildFrames("BigMonster_frosting_destroy_%04d", 0, 16)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.mainSprite:play(animate, 0, 1, callback)
end
