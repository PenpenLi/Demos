TileDigJewel = class(Sprite)

-- modify GameItemData.digJewelType
local JewelType = 
{
	kJewel = 0,
	kCake = 1,
	kHolycup = 2,
	kBell = 3,
	kRedbag = 4,
	kBlueJewel = 5,
	kGoldZongZi = 6,
	kQiXi2015 = 7,
	kCupcake = 8,
	kHalloween2015 = 9,
	kWukong = 10,
	kIceCream = 11,
	kChildrensDay = 12,
}

TileDigJewel.JewelTypeConfig = JewelType

function TileDigJewel:create(level, texture, levelType)
	local sprite = CCSprite:create()
	sprite:setTexture(texture)
	local node = TileDigJewel.new(sprite)
	node.parentTexture = texture

	--print('RRR  ++++++++++++++++++++++++ TileDigJewel:create   levelType = ', levelType)

	if levelType == GameLevelType.kSummerWeekly then
		node.jewelType = JewelType.kIceCream
	elseif levelType == GameLevelType.kMayDay then
		node.jewelType = JewelType.kChildrensDay
	elseif levelType == GameLevelType.kWukong then
		node.jewelType = JewelType.kWukong
	else
		node.jewelType = JewelType.kJewel
	end
	node.name = "digJewelTile"
	node:createSprite(level)
	node:initLevel(level)
	
	return node
end
------添加抖动动画
local function addJewAction( sprite, durationTime )
	-- body
	if sprite then sprite:stopAllActions() end

	local action_rotation_1 = CCRotateTo:create(0.1, -8.7)
	local action_rotation_2 = CCRotateTo:create(0.1, 9.2 )
	local action_rotation_3 = CCRotateTo:create(0.1, -10.7)
	local action_rotation_4 = CCRotateTo:create(0.05, 8)
	local action_rotation_5 = CCRotateTo:create(0.01, 0)

	durationTime = durationTime or 3
	local action_delay = CCDelayTime:create(durationTime)
	local array = CCArray:create()
	array:addObject(action_delay)
	array:addObject(action_rotation_1)
	array:addObject(action_rotation_2)
	array:addObject(action_rotation_3)
	array:addObject(action_rotation_4)
	array:addObject(action_rotation_5)
	
	local action_sequence = CCSequence:create(array)
	local action = CCRepeatForever:create(action_sequence)
	sprite:runAction(action)
end

local function getStars( ... )
	-- body
	local time = 0.5
	local sprite = Sprite:createWithSpriteFrameName("dig_star")
	local action_rotation = CCRotateBy:create(time, -90)
	local action_fadein = CCFadeIn:create(time/3)
	local action_fadeout = CCFadeOut:create(time/3)
	local action_delay = CCDelayTime:create(time/3)
	local array = CCArray:create()
	array:addObject(action_fadein)
	array:addObject(action_delay)
	array:addObject(action_fadeout)
	local action_sequence = CCSequence:create(array)

	local action_spawn = CCSpawn:createWithTwoActions(action_sequence, action_rotation)
	local action_delay_2 = CCDelayTime:create(time * 4)
	sprite:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(action_spawn,action_delay_2) ))
	return sprite
end

function TileDigJewel:createSprite( level )
	-- body
	if level < 1 or level > 3 then return end
	local lightCircleOffsetX, lightCircleOffsetY = 0, 0
	if self.jewelType == JewelType.kIceCream then
		lightCircleOffsetX = -2
		lightCircleOffsetY = -8
	end

	self.bgCloud = Sprite:createWithSpriteFrameName("dig_cloud_b_0000")
	self:addChild(self.bgCloud)
	
	if self.jewelType == JewelType.kBell then
		self.light_cirlce = Sprite:createWithSpriteFrameName("dig_light_cirlce_zongzi_0000")
		self.light_cirlce:setPosition(ccp(0 + lightCircleOffsetX, GamePlayConfig_Tile_Width/6 - 7))
	else
		self.light_cirlce = Sprite:createWithSpriteFrameName("dig_light_cirlce")
		self.light_cirlce:setPosition(ccp(0 + lightCircleOffsetX, GamePlayConfig_Tile_Width/6 + lightCircleOffsetY))
	end
	self:addChild(self.light_cirlce)
	self.light_cirlce:setVisible(false)

	local jewelActionDurationTime = 3
	if self.jewelType == JewelType.kJewel then
		self.jewel = Sprite:createWithSpriteFrameName("dig_jewel_0000") 
	elseif self.jewelType == JewelType.kIceCream then
		jewelActionDurationTime = 6
		self.jewel = Sprite:createWithSpriteFrameName("dig_icecream_0000")
		self.jewel:setPosition(ccp(2, 1)) 
	elseif self.jewelType == JewelType.kCupcake then
		self.jewel = Sprite:createWithSpriteFrameName("dig_cupcake_0000")
		self.jewel:setScale(0.9)
		self.jewel:setPositionY(self.jewel:getPositionY()+5)
	elseif self.jewelType == JewelType.kWukong then
		self.jewel = Sprite:createWithSpriteFrameName("dig_wukong_peach")
	elseif self.jewelType == JewelType.kChildrensDay then
		self.jewel = Sprite:createWithSpriteFrameName("dig_childrens_day")
		self.jewel:setPositionY(5)
	end
	self:addChild(self.jewel)
	addJewAction(self.jewel, jewelActionDurationTime)

	self.star_1 = getStars()
	self:addChild(self.star_1)
	local starOffset = ccp(0,0)
	if self.jewelType == JewelType.kIceCream then
		starOffset = ccp(-7, 0)
	end
	self.star_1:setPosition(ccp(-GamePlayConfig_Tile_Width/4+starOffset.x, GamePlayConfig_Tile_Width/4+starOffset.y))
end

function TileDigJewel:initLevel( level )
	-- body
	self.level = level
	if level > 0 then 
		local nameStr = "dig_jewel_front_0000"
		if level == 2 then 
			nameStr = "dig_jewel_front_0001"
		elseif level == 3 then
			nameStr = "dig_jewel_front_0002"
		end
		self.frontCloud = Sprite:createWithSpriteFrameName(nameStr)
		if (self.jewelType == JewelType.kBell or self.jewelType == JewelType.kCupcake) and level > 1 then
			if leve == 2 then
				self.frontCloud:setScaleY(0.95)
			else
				self.frontCloud:setScaleY(0.8)
				self.frontCloud:setPosition(ccp(0, -5))
			end
		end
		self:addChild(self.frontCloud)
	end
end

function TileDigJewel:changeLevel( level, callback )
	-- body
	local index = 0
	self.level = level
	if self.frontCloud then
		local index = self.frontCloud:getParent():getChildIndex(self.frontCloud)
		self.frontCloud:removeFromParentAndCleanup(true)
	end

	if level > 0 then 
		local nameStr = "dig_jewel_front_0000"
		if level == 2 then 
			nameStr = "dig_jewel_front_0001"
		elseif level == 3 then
			nameStr = "dig_jewel_front_0002"
		end
		self.frontCloud = Sprite:createWithSpriteFrameName(nameStr)
		if self.jewelType == JewelType.kBell and level > 1 then
			if leve == 2 then
				self.frontCloud:setScaleY(0.95)
			else
				self.frontCloud:setScaleY(0.8)
				self.frontCloud:setPosition(ccp(0, -5))
			end
		end
		if index > 0 then
			self:addChildAt(self.frontCloud, index)
		else
			self:addChild(self.frontCloud)
		end
	end
	
	if level == 2 then 
		self:playlevel3ExplorAnimation()
	elseif level == 1 then 
		self:playLevel2ExplorAnimation()
	elseif level == 0 then 
		self:playLevel1ExplorAnimation(callback);
	end
end



function TileDigJewel:playLightCircleAnimation( ... )
	-- body
	self.light_cirlce:setVisible(true)
	local time = 0.5
	local action_fadein = CCFadeIn:create(time)
	local action_rotateby = CCRotateBy:create(3 * time, 180)
	local action_fadeout = CCFadeOut:create(time)
	local action_sequence = CCSequence:createWithTwoActions(action_fadein, action_fadeout)
	local action = CCSpawn:createWithTwoActions(action_sequence, action_rotateby)
	local function localCallback( ... )
		-- body
		self.light_cirlce:setVisible(false)
	end 
	local action_result = CCSequence:createWithTwoActions(action, CCCallFunc:create(localCallback))
	self.light_cirlce:runAction(action_result)

end

function TileDigJewel:playlevel3ExplorAnimation( callback )
	-- body
	local cloud_fly = Sprite:createWithSpriteFrameName("dig_cloud_fly_animation_0000")
	self:addChild(cloud_fly)
	local characterPattern = "dig_cloud_fly_animation_%04d"
	local numFrames = 20
	local frames = SpriteUtil:buildFrames(characterPattern, 0, numFrames)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	local function finsishCallback( ... )
		-- body
		if cloud_fly then cloud_fly:removeFromParentAndCleanup(true) end
		if callback and type(callback) == "function" then 
			callback()
		end
	end
	cloud_fly:play(animate, 0, 1, finsishCallback)
end

function TileDigJewel:playLevel2ExplorAnimation( callback )
	-- body
	local cloud_fly = Sprite:createWithSpriteFrameName("dig_cloud_fly_animation_0000")
	self:addChild(cloud_fly)
	cloud_fly:setPosition(ccp(0,- GamePlayConfig_Tile_Width / 4))
	local characterPattern = "dig_cloud_fly_animation_%04d"
	local numFrames = 20
	local frames = SpriteUtil:buildFrames(characterPattern, 0, numFrames)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	local function finsishCallback( ... )
		-- body
		if cloud_fly then cloud_fly:removeFromParentAndCleanup(true) end
		if callback and type(callback) == "function" then 
			callback()
		end
	end
	cloud_fly:play(animate, 0, 1, finsishCallback)
	self:playLightCircleAnimation()
end

function TileDigJewel:playLevel1ExplorAnimation( callback )
	-- body
	if self.frontCloud then self.frontCloud:removeFromParentAndCleanup(true) end

	local time = 0.5
	local jewel = self.jewel
	self:playLightCircleAnimation()
	if jewel then jewel:stopAllActions() jewel:setRotation(0) end
	local function localCallback( ... )
		-- body
		if jewel then jewel:removeFromParentAndCleanup(true) end
	end 
	local action_jump = CCJumpBy:create(time / 2, ccp(0, 0), GamePlayConfig_Tile_Width/5, 1)
	local action_callback = CCCallFunc:create(localCallback)
	local array = CCArray:create()
	array:addObject(action_jump)
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(action_callback)
	local action_result = CCSequence:create(array)
	jewel:runAction(action_result)
	self.bgCloud:setVisible(false)
	self:playCloudDisappearAnimation(callback)

end

function TileDigJewel:playCloudDisappearAnimation( afterAnimationCallback )
	-- body
	local sprite_name = "dig_cloud_0000"
	local container = Sprite:createEmpty()
	container:setTexture(self.parentTexture)
	for k = 1, 8 do 
		local sprite = Sprite:createWithSpriteFrameName(sprite_name)
		local angle = (k-1) * 360/8   ----------角度
		local radian = angle * math.pi / 180
	
		sprite:setScale(0.8)
		sprite:setAnchorPoint(ccp(0.5,0.5))
		local time_spaw = 0.5
		local action_move_1 = CCMoveBy:create(time_spaw/2, ccp(math.sin(radian) * 2 *GamePlayConfig_Tile_Width/3 , math.cos(radian) * 2 *GamePlayConfig_Tile_Width/3  ))
		local action_scale = CCScaleTo:create(time_spaw/2,1)
		local action_spaw_1 = CCSpawn:createWithTwoActions(action_move_1, action_scale)
		
		local action_fadeout = CCFadeOut:create(time_spaw * 2)
		local action_move_2 = CCMoveBy:create(time_spaw * 2, ccp(math.sin(radian) * GamePlayConfig_Tile_Width/10 , math.cos(radian) * GamePlayConfig_Tile_Width/10  ))
		local action_scale_2 = CCScaleTo:create(time_spaw * 2, 0.5)
		local actionArray_spawn_2 = CCArray:create()
		actionArray_spawn_2:addObject(action_fadeout)
		actionArray_spawn_2:addObject(action_move_2)
		actionArray_spawn_2:addObject(action_scale_2)
		local action_spaw_2 = CCSpawn:create(actionArray_spawn_2)

		local actionArray = CCArray:create()
		actionArray:addObject(action_spaw_1)
		actionArray:addObject(action_spaw_2)

		sprite:runAction(CCSequence:create(actionArray))
		container:addChild(sprite)
	end
	local function callback( ... )
		-- body
		container:removeFromParentAndCleanup(true)
		if afterAnimationCallback and type(afterAnimationCallback) == "function" then 
			afterAnimationCallback()
		end
	end

	self:addChildAt(container,0)
	container:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.25), CCCallFunc:create(callback)))
end