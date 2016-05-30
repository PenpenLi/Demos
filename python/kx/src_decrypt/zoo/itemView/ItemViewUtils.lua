ItemViewUtils = class{}
local kCharacterAnimationTime = 1/30
function ItemViewUtils:buildLight(iceLevel, gameModeId)	--冰层
	if iceLevel == 0 then return nil end;
	local str_temp
	if gameModeId == GameModeTypeId.SEA_ORDER_ID then
		str_temp = string.format("Light_sea_order_%d.png",iceLevel)
	else
		str_temp = string.format("Light%d.png",iceLevel)
	end
	
	return Sprite:createWithSpriteFrameName(str_temp);
end

function ItemViewUtils:buildTileBlocker( state, isReverseSide )
	-- body
	local tileBlocker = TileBlocker:create(state, isReverseSide)
	return tileBlocker

end

function ItemViewUtils:buildMonsterFootAnimation(boardView, callback )
	-- body
	local time = 1.5
	local container = Sprite:createEmpty()
	
	local function animationCallback()
		if callback then callback() end
	end

	local function animationStart( ... )
		-- body
		local bright = Sprite:createWithSpriteFrameName("foot_bright")
		local dark = Sprite:createWithSpriteFrameName("foot_dark")
		container:addChild(dark)
		container:addChild(bright)

		bright:setScale(2.349)
		local arr_bright = CCArray:create()
		arr_bright:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(time * 5/35), CCScaleTo:create(time * 5/35, 1.175)))
		arr_bright:addObject(CCDelayTime:create(time * 3/35))
		arr_bright:addObject(CCScaleTo:create(time * 4/35, 1.41))
		arr_bright:addObject(CCScaleTo:create(time * 5/35, 1.175))
		arr_bright:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(time * 18/35), CCScaleTo:create(time * 18/35, 2)) )
		bright:runAction(CCSequence:create(arr_bright))

		dark:setScale(3.156)
		local arr_dark = CCArray:create()
		arr_dark:addObject(CCScaleTo:create(time * 5/35, 1.578))
		arr_dark:addObject(CCScaleTo:create(time * 8/35, 1.736))
		arr_dark:addObject(CCScaleTo:create(time * 7/35, 1.578))
		arr_dark:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create( time * 15/35), CCScaleTo:create(time * 15/35, 2)) )
		arr_dark:addObject(CCCallFunc:create(animationCallback))
		dark:runAction(CCSequence:create(arr_dark))

		boardView:viberate()

	end

	container:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.5), CCCallFunc:create(animationStart)))

	return container
end

function ItemViewUtils:buildLighttAction(callback)
	local pattern = "Light1%04d.png"
	local sprite = Sprite:createWithSpriteFrameName("Light10001.png")

	local frames = SpriteUtil:buildFrames(pattern, 0, 17)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	local function onRepeatFinishCallback_Ice()
		sprite:dp(Event.new(Events.kComplete, nil, sprite));
		sprite:removeFromParentAndCleanup(true);
		if callback then callback() end
	end
	sprite:play(animate, 0, 1, onRepeatFinishCallback_Ice)
	return sprite;
end

function ItemViewUtils:buildLockAction()
	local pattern = "Lock%04d.png"
	local sprite = Sprite:createWithSpriteFrameName("Lock0001.png")

	local frames = SpriteUtil:buildFrames(pattern, 0, 39)
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	local function onRepeatFinishCallback_Lock()
		sprite:dp(Event.new(Events.kComplete, nil, sprite));
		sprite:removeFromParentAndCleanup(true);
	end
	sprite:play(animate, 0, 1, onRepeatFinishCallback_Lock)
	return sprite;
end

function ItemViewUtils:buildSnowAction(snowLevel)
	local pattern = string.format("frosting%d", snowLevel)
	local str_temp = "%04d.png"
	pattern = pattern..str_temp
	local sprite = Sprite:createWithSpriteFrameName(string.format("frosting%d0000.png", snowLevel))

	local frames = SpriteUtil:buildFrames(pattern, 0, GamePlayConfig_SnowDeleted_Action_Count[snowLevel])
	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)

	local function onRepeatFinishCallback_Snow()
		sprite:dp(Event.new(Events.kComplete, nil, sprite))
		sprite:removeFromParentAndCleanup(true);
	end
	sprite:play(animate, 0, 1, onRepeatFinishCallback_Snow)
	return sprite

end

function ItemViewUtils:buildCrystal(colortype)
	if colortype == 0 then return nil end;
	local colorIndex = AnimalTypeConfig.convertColorTypeToIndex(colortype)
	local str_temp = string.format("CrystalBall%02d.png", colorIndex)
	return Sprite:createWithSpriteFrameName(str_temp);
end

function ItemViewUtils:buildGift(colortype)
	if colortype == 0 then return nil end
	local colorIndex = AnimalTypeConfig.convertColorTypeToIndex(colortype)
	local str_temp = string.format("gift%d.png", colorIndex)
	return Sprite:createWithSpriteFrameName(str_temp)
end

function ItemViewUtils:buildSnow(snowLevel)
	if snowLevel == 0 then return nil end;
	local str_temp = string.format("frosting%d.png",snowLevel)
	return Sprite:createWithSpriteFrameName(str_temp);
end

function ItemViewUtils:buildLocker(cageLevel)
	if cageLevel == 0 then return nil end;
	local str_temp = string.format("Lock%d.png",cageLevel)
	return Sprite:createWithSpriteFrameName(str_temp);
end

function ItemViewUtils:buildBeanpod(itemShowType)
	return TileBeanpod:create(itemShowType)
end

function ItemViewUtils:buildAnimalStatic(colortype)
	local colorIndex = AnimalTypeConfig.convertColorTypeToIndex(colortype)
	local str_temp = string.format("StaticItem%02d.png", colorIndex)
	return Sprite:createWithSpriteFrameName(str_temp);
end

function ItemViewUtils:buildFurball(furballType)
	local name
	if furballType == GameItemFurballType.kGrey then
		name = "ball_grey"
	elseif furballType == GameItemFurballType.kBrown then
		name = "ball_brown"
	end
	local furballsprite = TileCuteBall:create(name)
	return furballsprite
end

function ItemViewUtils:buildSand(sandLevel)
	local sprite = TileSand:createIdleSand()
	return sprite
end

function ItemViewUtils:buildSelectBorder()
	local view = Sprite:createWithSpriteFrameName("tile_select_0000.png")
	local frames = SpriteUtil:buildFrames("tile_select_%04d.png", 0, 30)
	local animate = SpriteUtil:buildAnimate(frames, 1 / 30)
	view:play(animate)
	return view
end

function ItemViewUtils:buildMonsterFrosting(frostingType)
	local view = TileMonsterFrosting:create(frostingType)
	return view
end

function ItemViewUtils:createQuestionMark(colortype)
	if colortype == 0 then return nil end
	local view = TileQuestionMark:create(colortype)
	return view
end