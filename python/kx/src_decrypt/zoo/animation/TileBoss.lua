TileBoss = class(CocosObject)

local kCharacterAnimationTime = 1/30
local animationList = table.const
{
	kNone = 0,
	kNormal = 1,
	kDestroy = 2,
	kDisappear = 3,
	kComeout = 4,
	kHit = 5,
	kCast = 6,
}

--使用的boss类型，方便换皮
BossType = table.const
{
	kRabbit = 
	{	name = 'rabbit',
		normal = {name = 'boss_rabbit_normal', frame = 35},
		hit = {name = 'boss_rabbit_hit', frame = 40},
		destroy = {name = 'boss_rabbit_destroy', frame = 25},
		cage = {name = 'boss_cage', frame = 1}
	},
	kPanda  = 
	{	
		name = 'panda',
		normal = {name = 'boss_panda_normal', frame = 40},
		hit = {name = 'boss_panda_hit', frame = 40},
		destroy = {name = 'boss_panda_destroy', frame = 33},
		cage = nil,
		zzz = {name = 'boss_panda_zzz', frame = 1}
	}, -- 国庆活动
	kTurkey = 
	{	name = 'turkey',
		normal = {name = 'boss_turkey_normal', frame = 65},
		hit = {name = 'boss_turkey_hit', frame = 30},
		destroy = {name = 'boss_turkey_destroy', frame = 30},
		cage = nil,
	},
	kSheep = 
	{
		name = 'sheep',
		normal = {name = 'boss_sheep_normal', frame = 40},
		hit = {name = 'boss_sheep_hit', frame = 40},
		destroy = {name = 'boss_sheep_destroy', frame = 26},
		cast = {name = 'boss_sheep_cast', frame = 40},

	},
	kCat = {
		name = 'cat',
		normal = {name = 'boss_cat_normal', frame = 38},
		hit = {name = 'boss_cat_hit', frame = 40},
		cast = {name = 'boss_cat_cast', frame = 40},
		destroy = {name = 'boss_cat_destroy', frame = 26},
	},
}

OFFSET_Y = 2 -- 10
OFFSET_X = 1

function TileBoss:create(bossType)
	local node = TileBoss.new(CCNode:create())
	node.bossType = bossType or BossType.kRabbit
	-- node.bossType = BossType.kPanda
	node.name = "tile_boss_"..node.bossType.name
	node.currentAnimation = animationList.kNone
	node:initBoss()
	return node
end

function TileBoss:initBoss( ... )
	-- body
	local bg = Sprite:createWithSpriteFrameName("boss_bg_cloud")
	self:addChild(bg)
	self.bg = bg
	self.bg:setPosition(ccp(-2, 3))

	if self.bossType.normal then
		local boss = Sprite:createWithSpriteFrameName(self.bossType.normal.name.."_0000")
		self:addChild(boss)
		self.boss = boss
		self.boss:setPosition(ccp(0 - 1, OFFSET_Y))
	end

	if self.bossType.cage then
		local cage = Sprite:createWithSpriteFrameName(self.bossType.cage.name)
		cage:setAnchorPoint(ccp(0.5, 0))
		cage:setPosition(ccp(0, -cage:getGroupBounds().size.height/2 + OFFSET_Y))
		self:addChild(cage)
		self.cage = cage
	end

	local fg = Sprite:createWithSpriteFrameName("boss_fg_cloud")
	self:addChild(fg)
	local size = fg:getGroupBounds().size
	fg:setPosition(ccp(0, -(GamePlayConfig_Tile_Height - size.height/2)))
	self.fg = fg

	self:createBloodBar()

	self:normal()
end

function TileBoss:createBloodBar()
	local blood = Sprite:createEmpty()

	local dangerBg = Sprite:createWithSpriteFrameName("boss_blood_danger_0000")
	dangerBg:setAnchorPoint(ccp(0.5, 0.5))
	dangerBg:setScaleY(0.9)
	dangerBg:setScaleX(1)
	dangerBg:setPosition(dangerBg:getGroupBounds().size.width / 2 - 6, -1)
    blood:addChild(dangerBg)
    dangerBg:setOpacity(0)
    self.dangerBg = dangerBg

	local bloodbg = Sprite:createWithSpriteFrameName("boss_blood_bar_0000")
	bloodbg:setAnchorPoint(ccp(0, 0.5))
	blood:addChild(bloodbg)

	local bloodfg_mask = Sprite:createWithSpriteFrameName("boss_blood_bar_0001")
	local bloodfg = Sprite:createWithSpriteFrameName("boss_blood_bar_0001")
	clipingnode = ClippingNode.new(CCClippingNode:create(bloodfg_mask.refCocosObj))
	clipingnode:setPositionX(0)
	clipingnode:setAlphaThreshold(0.98)
	bloodfg_mask:setAnchorPoint(ccp(0, 0.5))
	bloodfg:setAnchorPoint(ccp(0, 0.5))
	clipingnode:addChild(bloodfg)




	blood:addChild(clipingnode)
	self:addChild(blood)
	self.bloodBar = bloodfg
	bloodfg:setPosition(OFFSET_X, 0)
	self.bloodBarWidth = bloodfg:getGroupBounds().size.width

	local pos_x = -self.bloodBarWidth /2
	local pos_y = -GamePlayConfig_Tile_Height * 3 /4
	blood:setPosition(ccp(pos_x - 2, pos_y))
	self.blood = blood
end

--------------------
--percent = [0,1]
--------------------
function TileBoss:setBloodPercent(percent, isPlayAnimation)
	if self.bloodBar and percent then
		self.bloodBar:stopAllActions()
		if isPlayAnimation then
			self.bloodBar:runAction(CCMoveTo:create(0.5, ccp((percent - 1) * self.bloodBarWidth + OFFSET_X, 0)))
		else
			self.bloodBar:setPosition(ccp((percent - 1) * self.bloodBarWidth + OFFSET_X, 0))
		end
		if percent <= 0.3 then
			self:playDangerEffect()
		end
		
	end
end

function TileBoss:normal()

	if self.currentAnimation == animationList.kNormal then return end
	self:reset()
	self.currentAnimation = animationList.kNormal
	local function action_callback()
		local frames = SpriteUtil:buildFrames(self.bossType.normal.name.."_%04d", 0, self.bossType.normal.frame)
		local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
		if self.boss then 
			self.boss:play(animate, 0, 1)
			self.boss:setPositionY(OFFSET_Y)
		end
	end
	self.boss:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions( CCDelayTime:create(2.5), CCCallFunc:create(action_callback))))
	action_callback()

	if self.bossType.zzz and not self.zzz then
		local zzz = self:createZZZ()
		zzz:setPosition(ccp(70, 80))
		self.boss:addChild(zzz)
		self.zzz = zzz
	end
end

function TileBoss:destroy(callback)

	local function animationComplete()
		if callback then callback() end
	end
	self:reset()
	self.currentAnimation = animationList.kDestroy
	self:createDestroyAnimation(animationComplete)
	
end

function TileBoss:cast(callback)
	local function animationComplete()
		if callback then callback() end
		self:normal()
	end
	self:reset()
	self.currentAnimation = animationList.kDestroy
	self:createCastingAnimation(animationComplete)
end

function TileBoss:createCastingAnimation(animationComplete)
	local frames = SpriteUtil:buildFrames(self.bossType.cast.name.."_%04d", 0, self.bossType.hit.frame)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	self.boss:play(animate, 0, 1, animationComplete)
	if self.bossType == BossType.kCat then
		self.boss:setPosition(ccp(3, OFFSET_Y + 5))
	end

	local action_delay = CCDelayTime:create(0.6)
	local height = self.fg:getGroupBounds().size.height/2
	local action_jump = CCJumpBy:create(0.3, ccp(0, 0), height, 1)
	self.fg:runAction(CCSequence:createWithTwoActions(action_delay, action_jump))

	local max = 5
	local offset_angle = 30
	local pos_list = {ccp(-70, 70), ccp(-70, 35), ccp(-70, 0), ccp(70, 0), ccp(70, 20)}
	local scale_list = {1, 0.5, 0.7, 0.5, 0.4}

	self.star = Sprite:createEmpty()
	self:addChild(self.star)
	for k = 1, max do
		local star = Sprite:createWithSpriteFrameName("boss_star")
		local function actionRemove()
			if star then star:removeFromParentAndCleanup(true) end
		end

		local angle = (k - max/2) * offset_angle
		local move_action = CCEaseOut:create(CCMoveTo:create(0.5, pos_list[k]), 2) 
		local arr_move = CCArray:create()
		arr_move:addObject(CCFadeIn:create(0.1))
		arr_move:addObject(CCDelayTime:create(0.2))
		arr_move:addObject(CCFadeOut:create(0.2))
		local fade_action = CCSequence:create(arr_move)
		local action = CCSpawn:createWithTwoActions(move_action, fade_action)
		local arr = CCArray:create()
		arr:addObject(CCDelayTime:create(0.6))
		arr:addObject(action)
		arr:addObject(CCCallFunc:create(actionRemove))
		star:runAction(CCSequence:create(arr))
		self.star:addChild(star)
		local size = self.fg:getGroupBounds().size
		star:setPosition(ccp(0, -(GamePlayConfig_Tile_Height - size.height/2)))
		star:setOpacity(0)
		star:setScale(scale_list[k])
	end
end

function TileBoss:addClippingNode()
	local clippingnode = ClippingNode:create(CCRectMake(0, 0, GamePlayConfig_Tile_Width * 2,GamePlayConfig_Tile_Height * 2))
	clippingnode:setPosition(ccp(-GamePlayConfig_Tile_Width, -GamePlayConfig_Tile_Height) )
	self.clippingnode = clippingnode
	self:addChild(clippingnode)

	local container = Sprite:createEmpty()
	clippingnode:addChild(container)
	self.container = container
	container:setPosition(ccp(GamePlayConfig_Tile_Width, GamePlayConfig_Tile_Height))

	if self.boss then 
		self.boss:removeFromParentAndCleanup(false)
		self.container:addChild(self.boss)
	end

	if self.cage then
		self.cage:removeFromParentAndCleanup(false)
		self.container:addChild(self.cage)
	end

	if self.fg then
		self.fg:removeFromParentAndCleanup(false)
		self.container:addChild(self.fg)
	end

	if self.blood then 
		self.blood:removeFromParentAndCleanup(false)
	end
end

function TileBoss:removeClippingnode()
	if self.boss then 
		self.boss:removeFromParentAndCleanup(false)
		self:addChild(self.boss)
	end

	if self.cage then
		self.cage:removeFromParentAndCleanup(false)
		self:addChild(self.cage)
	end

	if self.fg then
		self.fg:removeFromParentAndCleanup(false)
		self:addChild(self.fg)
	end

	if self.blood then 
		self:addChild(self.blood)
	end

	self.clippingnode:removeFromParentAndCleanup(true)
	self.container = nil
	self.clippingnode = nil
end


function TileBoss:disappear(callback)
	local function animationComplete()
		self:removeClippingnode()
		if callback then callback() end
	end 
	self:addClippingNode()
	self.currentAnimation = animationList.kDisappear
	self:createDisAppearAnimation(animationComplete)

end

function TileBoss:comeout(callback)
	local function animationComplete()
		self:removeClippingnode()
		self:normal()
		if callback then callback() end
	end
	self:addClippingNode()
	self.currentAnimation = animationList.kComeout
	self:createComeoutAnimation(animationComplete)
end


function TileBoss:hit( callback )
	-- body
	local function animationComplete()
		if callback then callback() end
		self:normal()
	end

	if self.currentAnimation == animationList.kHit then
		if callback then callback() end
	else
		self:reset()
		self.currentAnimation = animationList.kHit
		self:createHitAnimation(animationComplete)
	end
end

function TileBoss:createComeoutAnimation(animationComplete)
	local function callback()
		if animationComplete then animationComplete() end
	end
	self.container:setPosition(ccp(GamePlayConfig_Tile_Width, 3*GamePlayConfig_Tile_Height))
	self.container:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.6, ccp(GamePlayConfig_Tile_Width, GamePlayConfig_Tile_Height)), CCCallFunc:create(callback)))

	self.bg:setOpacity(0)
	self.bg:runAction(CCFadeOut:create(0.6))
end

function TileBoss:createDisAppearAnimation(animationComplete)
	local function callback()
		self.container:setPosition(ccp(GamePlayConfig_Tile_Width, GamePlayConfig_Tile_Height))
		if animationComplete then animationComplete() end
	end
	self.container:runAction(CCSequence:createWithTwoActions(CCMoveBy:create(0.6, ccp(0, -2*GamePlayConfig_Tile_Height)), CCCallFunc:create(callback)))
end


function TileBoss:createHitAnimation(animationComplete)
	local frames = SpriteUtil:buildFrames(self.bossType.hit.name.."_%04d", 0, self.bossType.hit.frame)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	if self.bossType == BossType.kTurkey then
		self.boss:setPositionY(OFFSET_Y + 7)
	elseif self.bossType == BossType.kCat then
		self.boss:setPosition(ccp(3, OFFSET_Y + 5))
	end
	self.boss:play(animate, 0, 1, animationComplete)

	local action_delay = CCDelayTime:create(0.6)
	local height = self.fg:getGroupBounds().size.height/2
	local action_jump = CCJumpBy:create(0.3, ccp(0, 0), height, 1)
	self.fg:runAction(CCSequence:createWithTwoActions(action_delay, action_jump))

	local max = 5
	local offset_angle = 30
	local pos_list = {ccp(-70, 70), ccp(-70, 35), ccp(-70, 0), ccp(70, 0), ccp(70, 20)}
	local scale_list = {1, 0.5, 0.7, 0.5, 0.4}

	self.star = Sprite:createEmpty()
	self:addChild(self.star)
	for k = 1, max do
		local star = Sprite:createWithSpriteFrameName("boss_star")
		local function actionRemove()
			if star then star:removeFromParentAndCleanup(true) end
		end

		local angle = (k - max/2) * offset_angle
		local move_action = CCEaseOut:create(CCMoveTo:create(0.5, pos_list[k]), 2) 
		local arr_move = CCArray:create()
		arr_move:addObject(CCFadeIn:create(0.1))
		arr_move:addObject(CCDelayTime:create(0.2))
		arr_move:addObject(CCFadeOut:create(0.2))
		local fade_action = CCSequence:create(arr_move)
		local action = CCSpawn:createWithTwoActions(move_action, fade_action)
		local arr = CCArray:create()
		arr:addObject(CCDelayTime:create(0.6))
		arr:addObject(action)
		arr:addObject(CCCallFunc:create(actionRemove))
		star:runAction(CCSequence:create(arr))
		self.star:addChild(star)
		local size = self.fg:getGroupBounds().size
		star:setPosition(ccp(0, -(GamePlayConfig_Tile_Height - size.height/2)))
		star:setOpacity(0)
		star:setScale(scale_list[k])
	end

	if self.bossType.cage then
		local cage_time = 0.1
		local cage_ang = 2.5
		local cage_scale = 0.95
		local action_delay = CCDelayTime:create(cage_time/2)
		local action_rotation_l = CCSpawn:createWithTwoActions(CCScaleTo:create(cage_time/2, cage_scale), CCRotateTo:create(cage_time, -2.2))
		local action_rotation_2 = CCSpawn:createWithTwoActions(CCScaleTo:create(cage_time/2, 1), CCRotateTo:create(cage_time, 0))
		local action_rotation_3 = CCSpawn:createWithTwoActions(CCScaleTo:create(cage_time/2, cage_scale), CCRotateTo:create(cage_time, 2))
		local action_rotation_4 = CCSpawn:createWithTwoActions(CCScaleTo:create(cage_time, 1), CCRotateTo:create(cage_time, -0.2))
		local action_rotation_5= CCSpawn:createWithTwoActions(CCScaleTo:create(cage_time, cage_scale), CCRotateTo:create(cage_time, -2.9))
		local action_rotation_6= CCSpawn:createWithTwoActions(CCScaleTo:create(cage_time, 1), CCRotateTo:create(cage_time, 0))
		local action_rotation_7= CCSpawn:createWithTwoActions(CCScaleTo:create(cage_time,cage_scale), CCRotateTo:create(cage_time, 2.6))
		local action_rotation_8= CCSpawn:createWithTwoActions(CCScaleTo:create(cage_time, 1), CCRotateTo:create(cage_time, 0.3))
		local action_rotation_9= CCSpawn:createWithTwoActions(CCScaleTo:create(cage_time,cage_scale), CCRotateTo:create(cage_time, -2.3))
		local action_rotation_10 = CCSpawn:createWithTwoActions(CCScaleTo:create(cage_time, 1), CCRotateTo:create(cage_time, 0))
		
		local cage_arr = CCArray:create()
		cage_arr:addObject(action_delay)
		cage_arr:addObject(action_rotation_l)
		cage_arr:addObject(action_rotation_2)
		cage_arr:addObject(action_rotation_3)
		cage_arr:addObject(action_rotation_4)
		cage_arr:addObject(action_rotation_5)
		cage_arr:addObject(action_rotation_6)
		cage_arr:addObject(action_rotation_7)
		cage_arr:addObject(action_rotation_8)
		cage_arr:addObject(action_rotation_9)
		cage_arr:addObject(action_rotation_10)
		local cage_action = CCSequence:create(cage_arr) 
		self.cage:runAction(cage_action)
	end
end

function TileBoss:createDestroyAnimation(animationComplete)
	--rabbit
	local function completeCallback()
		local arr = CCArray:create()
		arr:addObject(CCScaleTo:create(0.3, 0.2))
		arr:addObject(CCMoveBy:create(0.3, ccp(-GamePlayConfig_Tile_Width, GamePlayConfig_Tile_Height * 3)))
		arr:addObject(CCRotateTo:create(0.3, -30))
		local action_callback = CCCallFunc:create(animationComplete)
		local action = CCSequence:createWithTwoActions(CCSpawn:create(arr), action_callback)
		self.boss:runAction(action)
		if self.bossType == BossType.kTurkey then
			self.boss:setPositionY(OFFSET_Y + 25)
		end
	end

	local frames = SpriteUtil:buildFrames(self.bossType.destroy.name.."_%04d", 0, self.bossType.destroy.frame)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	-- 春节boss增加的offset 下次删掉
	self.boss:setPositionY(self.boss:getPositionY()+25)
	self.boss:play(animate, 0, 1, completeCallback)

	--bg_cloud
	self.bg:runAction(CCFadeOut:create(0.3))
	self.bg_animation = Sprite:createEmpty()
	self:addChildAt(self.bg_animation,1)
	for k = 1, 8 do 
		local sprite = Sprite:createWithSpriteFrameName("dig_cloud_0000")
		local angle = (k-1) * 360/8   ----------角度
		local radian = angle * math.pi / 180
		sprite:setScale(1)
		sprite:setAnchorPoint(ccp(0.5,0.5))
		local time_spaw = 0.5
		local action_move_1 = CCMoveBy:create(time_spaw*0.5, ccp(math.sin(radian) * 2 *GamePlayConfig_Tile_Width/2 , math.cos(radian) * 2 *GamePlayConfig_Tile_Width/2  ))
		local action_scale = CCScaleTo:create(time_spaw*0.5,1.2)
		local action_spaw_1 = CCSpawn:createWithTwoActions(action_move_1, action_scale)
		
		local action_fadeout = CCFadeOut:create(time_spaw * 1.6)
		local action_move_2 = CCMoveBy:create(time_spaw * 1.6, ccp(math.sin(radian) * GamePlayConfig_Tile_Width/5 , math.cos(radian) * GamePlayConfig_Tile_Width/5  ))
		local action_scale_2 = CCScaleTo:create(time_spaw * 1.6, 0.8)
		local actionArray_spawn_2 = CCArray:create()
		actionArray_spawn_2:addObject(action_fadeout)
		actionArray_spawn_2:addObject(action_move_2)
		actionArray_spawn_2:addObject(action_scale_2)
		local action_spaw_2 = CCSpawn:create(actionArray_spawn_2)

		local actionArray = CCArray:create()
		actionArray:addObject(CCDelayTime:create(0.2))
		actionArray:addObject(action_spaw_1)
		actionArray:addObject(action_spaw_2)

		sprite:runAction(CCSequence:create(actionArray))
		self.bg_animation:addChild(sprite)
	end

	--fg_cloud
	local fg_arr = CCArray:create()
	fg_arr:addObject(CCScaleTo:create(0.2, 1))
	fg_arr:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.4, 2), CCFadeOut:create(0.2)))
	self.fg:runAction(CCSequence:create(fg_arr))
	
	if self.bossType.cage then
		--cage
		local cage_arr = CCArray:create()
		cage_arr:addObject(CCScaleTo:create(0.2,0.8))
		cage_arr:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.4, 2), CCFadeOut:create(0.2)))
		self.cage:runAction( CCSequence:create(cage_arr))
	end

	--bg_star
	local bg_star = Sprite:createWithSpriteFrameName("boss_bg_star")
	bg_star:setScale(0.6)
	bg_star:setOpacity(0)
	self:addChild(bg_star)
	self.bg_star = bg_star

	local bg_star_arr = CCArray:create()
	bg_star_arr:addObject(CCDelayTime:create(0.2))
	bg_star_arr:addObject(CCFadeIn:create(0.1))
	bg_star_arr:addObject(CCScaleTo:create(0.1))

	local bg_scale = CCSequence:createWithTwoActions(CCScaleTo:create(0.2, 1.46), CCScaleTo:create(0.4, 2.07))
	bg_star_arr:addObject(CCSpawn:createWithTwoActions(bg_scale, CCFadeOut:create(0.6)))
	self.bg_star:runAction(CCSequence:create(bg_star_arr))
end

function TileBoss:reset()
	if self.cage then 
		self.cage:stopAllActions()
		self.cage:setScale(1)
		self.cage:setRotation(0)
		self.cage:setOpacity(255)
	end

	if self.fg then 
		self.fg:stopAllActions()
		self.fg:setScale(1)
		local size = self.fg:getGroupBounds().size
		self.fg:setPosition(ccp(0, -(GamePlayConfig_Tile_Height - size.height/2)))
		self.fg:setOpacity(255)
	end

	if self.boss then 
		self.boss:stopAllActions()
		self.boss:setPosition(ccp(0,OFFSET_Y))
		self.boss:setScale(1)
		self.boss:setRotation(0)
	end

	if self.zzz then
		self.zzz:removeFromParentAndCleanup(true)
		self.zzz = nil
	end

	if self.star then
		self.star:removeFromParentAndCleanup(true)
		self.star = nil
	end

	if self.bg then 
		self.bg:setOpacity(255)
	end

	if self.bg_animation then
		self.bg_animation:removeFromParentAndCleanup(true)
		self.bg_animation = nil
	end

	if self.bg_star then 
		self.bg_star:removeFromParentAndCleanup(true)
		self.bg_star = nil
	end

end

function TileBoss:createZZZ()
	local fps = 30
	local function getZZZ(delay)
		local zzz = Sprite:createWithSpriteFrameName(self.bossType.zzz.name..'_0000')
		local function remove()
			if zzz then zzz:removeFromParentAndCleanup(true) end
		end

		local a = CCArray:create()
		a:addObject(CCFadeTo:create(11/fps, 255))
		a:addObject(CCMoveBy:create(11/fps, ccp(10, 4)))
		a:addObject(CCScaleTo:create(11/fps, 104/129))
		local b = CCArray:create()
		b:addObject(CCFadeTo:create(19/fps, 0))
		b:addObject(CCMoveBy:create(19/fps, ccp(20, 4)))
		b:addObject(CCScaleTo:create(19/fps, 58/129))
		local a_action = CCArray:create()
		a_action:addObject(CCDelayTime:create(delay))
		a_action:addObject(CCSpawn:create(a))
		a_action:addObject(CCSpawn:create(b))
		a_action:addObject(CCCallFunc:create(remove))
		zzz:runAction(CCSequence:create(a_action))
		return zzz
	end

	local node = CocosObject:create()
	local function playOnce()
		local delay = 0
		local interval = 12/fps
		for i=1, 3 do 
			local zzz = getZZZ(delay)
			zzz:setOpacity(0)
			node:addChild(zzz)
			delay = delay + interval
		end
	end

	local nodeAction = CCRepeatForever:create(CCSequence:createWithTwoActions(CCCallFunc:create(playOnce), CCDelayTime:create(2)))
	node:runAction(nodeAction)
	return node	
end

function TileBoss:playDangerEffect()
	if not self.isInDanger then
		local action = CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeIn:create(1), CCFadeOut:create(1)))
		self.dangerBg:runAction(action)
		self.isInDanger = true
	end
end