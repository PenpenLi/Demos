TileTransDoor = class(CocosObject)

local kCharacterAnimationTime = 1/30
local colorList = {"red", "green", "blue"}
local function createAnimation(sprite, sprite_name, frameNum, animationTime, finishCallback)
	local frames = SpriteUtil:buildFrames(sprite_name, 0, frameNum)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	sprite:play(animate, 0, animationTime, finishCallback)
end

function TileTransDoor:create(color, transType, transDirection)
	-- body
	local node = TileTransDoor.new(CCNode:create())
	node:setRotation(rotation)
	node:initData(color, transType, transDirection)
	node:initView()
	return node
end

function TileTransDoor:initData(color, transType, transDirection)
	self.color = colorList[color]
	self.position = ccp(-GamePlayConfig_Tile_Width/2, 0)
	self.rotation = 0
	if transType == TransmissionType.kStart then
		self.rotation = (transDirection -1) * 90
	else
		self.rotation = (transDirection + 1) * 90
	end
end

function TileTransDoor:initView()
	local door = Sprite:createWithSpriteFrameName("trans_door_"..self.color.."_0000")
	createAnimation(door, "trans_door_"..self.color.."_%04d", 15)
	door:setAnchorPoint(ccp(0.5, 0.5))
	door:setPosition(self.position)
	self:addChild(door)
	self.door = door

	local light = Sprite:createWithSpriteFrameName("trans_light_mask_0000")
	light:setVisible(false)
	light:setAnchorPoint(ccp(0.3, 0.5))
	light:setPosition(self.position)
	self:addChild(light)
	self.light = light

	local stars = Sprite:createWithSpriteFrameName("trans_star_mask_0000")
	createAnimation(stars, "trans_star_mask_%04d", 20)
	stars:setAnchorPoint(ccp(0.2, 0.5))
	stars:setPosition(self.position)
	self:addChild(stars)
	self.stars = stars

	self:setRotation(self.rotation)
end

function TileTransDoor:playTransAnimation()
	local function callback()
		self.light:setVisible(false)
	end
	self.light:setVisible(true)
	createAnimation(self.light, "trans_light_mask_%04d", 18, 1, callback)
end