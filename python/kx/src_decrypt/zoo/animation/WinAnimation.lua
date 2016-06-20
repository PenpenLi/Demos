-------------------------------------------------------------------------
--  Class include: WinAnimation, TimebackAnimation, AddEnergyAnimation, CommonSkeletonAnimation
-------------------------------------------------------------------------

require "hecore.display.Director"
require "hecore.display.ArmatureNode"

--
-- WinAnimation ---------------------------------------------------------
--
WinAnimation = class(CocosObject)

--defined position in flash
local animal_positions = {
	huanxiong_anime = {x=253.35, y=10.65},
	thre_anime = {x=97.4, y=16.85},
	chicken = {x=-196.5, y=-26.7},
	bear12 = {x=-268.3, y=-46.45},
	["energy_animation_spring2016/huanxiong_anime"] = {x=253.35, y=10.65},
	["energy_animation_spring2016/thre_anime"] = {x=97.4, y=16.85},
	["energy_animation_spring2016/chicken"] = {x=-196.5, y=-26.7},
	["energy_animation_spring2016/bear12"] = {x=-268.3, y=-46.45},
}

function WinAnimation:create(isActivity)
	local container = WinAnimation.new(CCNode:create())
	container:initialize(isActivity)
	return container
end

local function createAnimal( name, parent )
	local position = animal_positions[name]
	local node = ArmatureNode:create(name)
	node.name = name
	node:setAnimationScale(2.5)
	node:playByIndex(0)
	node:setPosition(ccp(position.x, -position.y))
	node:setVisible(false)
	parent:addChild(node)
	return node
end
function WinAnimation:initialize(isActivity)
	if isActivity then
		self.thre_anime = createAnimal("energy_animation_spring2016/thre_anime", self)
		self.huanxiong_anime = createAnimal("energy_animation_spring2016/huanxiong_anime", self)
		self.bear12 = createAnimal("energy_animation_spring2016/bear12", self)
		self.chicken = createAnimal("energy_animation_spring2016/chicken", self)
	else
		self.thre_anime = createAnimal("thre_anime", self)
		self.huanxiong_anime = createAnimal("huanxiong_anime", self)
		self.bear12 = createAnimal("bear12", self)
		self.chicken = createAnimal("chicken", self)
	end

	local hitArea = CocosObject:create()
	hitArea.name = kHitAreaObjectName
	hitArea:setContentSize(CCSizeMake(703.05, 211.84))
	self:addChild(hitArea)
end

local function fadeIn( object, delay )
	local position = animal_positions[object.name]
	local move = CCEaseBackOut:create(CCMoveTo:create(0.5, ccp(position.x, -position.y)))
	object:setPosition(ccp(position.x, -position.y - 200))
	object:setVisible(true)
	object:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delay), move))
end 
function WinAnimation:play(delayTime)
	delayTime = delayTime or 0
	fadeIn(self.huanxiong_anime, delayTime)
	fadeIn(self.chicken, delayTime + 0.2)
	fadeIn(self.bear12, delayTime + 0.28)
	fadeIn(self.thre_anime, delayTime + 0.33)
end


--
-- TimebackAnimation ---------------------------------------------------------
--
TimebackAnimation = class(CocosObject)

function TimebackAnimation:create(onAnimationFinishCallback)
	local container = CocosObject:create()
	
	local hole = ParticleSystemQuad:create("particle/time_back_hole.plist")
	hole:setAutoRemoveOnFinish(true)
	hole:setPosition(ccp(0,0))
	container:addChild(hole)

	FrameLoader:loadArmature( "skeleton/timeback_animation" )
	local node = ArmatureNode:create("back_clock_anime")
	node:playByIndex(0)
	node:setAnimationScale(0.75)
	container:addChild(node)
	CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename("skeleton/timeback_animation/texture.png"))

	local function onAnimationFinish()
		container:removeFromParentAndCleanup(true)
		if onAnimationFinishCallback ~= nil then onAnimationFinishCallback() end
	end 

	local spawn = CCArray:create()
	spawn:addObject(CCFadeIn:create(0.5))
	spawn:addObject(CCEaseElasticOut:create(CCMoveTo:create(0.5, ccp(0, 120))))

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.3))
	array:addObject(CCSpawn:create(spawn)) 
	array:addObject(CCDelayTime:create(1.5))
	array:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(0.25), CCScaleTo:create(0.25, 1.5)))
	array:addObject(CCDelayTime:create(0.3))
	array:addObject(CCCallFunc:create(onAnimationFinish))

	local fntFile = "fnt/backward.fnt"
	if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/backward.fnt" end
	local label = BitmapText:create(Localization:getInstance():getText("button.timeback"), fntFile)
	label:setOpacity(0)
	label:runAction(CCSequence:create(array))
	container:addChild(label)

	return container
end


--
-- AddEnergyAnimation ---------------------------------------------------------
--
AddEnergyAnimation = class(CocosObject)
function AddEnergyAnimation:create()
	local container = CocosObject:create()
	local node = ArmatureNode:create("huanxiong_sad_loop_anime")
	node:playByIndex(0)
	node:setAnimationScale(1.25)
	container:addChild(node)
	return container
end

WeeklyRaceAddEnergyAnimation = class(CocosObject)
function WeeklyRaceAddEnergyAnimation:create()
	local container = CocosObject:create()
	local node = ArmatureNode:create("tutorial_upzhousai")
	node:playByIndex(0)
	node:setScale(0.8)
	container:addChild(node)
	container:setScaleX(-1)
	node:setAnchorPoint(ccp(0.5, 0.5))
	return container
end

--加五步面板的小浣熊动画
AddFiveStepAnimation = class(CocosObject)
function AddFiveStepAnimation:create()
	local container = CocosObject:create()
	local node = ArmatureNode:create("huanxiong_point_to_anime")
	node:playByIndex(0)
	node:setAnimationScale(1.25)
	container:addChild(node)
	return container
end
--
-- CommonSkeletonAnimation ---------------------------------------------------------
--
CommonSkeletonAnimation = class()
function CommonSkeletonAnimation:createTutorialUp()
	local node = ArmatureNode:create("tutorial_up")
	node:playByIndex(0)
	node:setAnimationScale(1.25)
	return node
end
function CommonSkeletonAnimation:createTutorialDown()
	local node = ArmatureNode:create("tutorial_down")
	node:playByIndex(0)
	node:setAnimationScale(1.25)
	return node
end
function CommonSkeletonAnimation:createTutorialNormal()
	local node = ArmatureNode:create("tutorial_normal")
	node:playByIndex(0)
	node:setAnimationScale(1.25)
	return node
end
function CommonSkeletonAnimation:createTutorialMoveIn2()
	local node = ArmatureNode:create("movein_tutorial_2")
	node:playByIndex(0)
	node:setAnimationScale(1.25)
	return node
end
function CommonSkeletonAnimation:createTutorialMoveIn()
	local node = ArmatureNode:create("movein_tutorial")
	node:playByIndex(0)
	node:setAnimationScale(1.25)
	return node
end
function CommonSkeletonAnimation:createFailAnimation()
	local container = CocosObject:create()
	local character = ArmatureNode:create("fail_animation")
	character:playByIndex(0)
	character:setAnimationScale(1.25)
	container:addChild(character)

	local function createBird()
		local bird = ArmatureNode:create("bird_fly_animation")
		bird:playByIndex(0)
		bird:setAnimationScale(1.25)
		container:addChild(bird)
	end
	createBird()

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(CCCallFunc:create(createBird))
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(CCCallFunc:create(createBird))
	container:runAction(CCSequence:create(array))
	return container
end

kTutorialPropAnimation = {}
kTutorialPropAnimation["10001"] = "reflash_anime"
kTutorialPropAnimation["10015"] = "reflash_anime"

kTutorialPropAnimation["10005"] = "magic_anime"
kTutorialPropAnimation["10019"] = "magic_anime"

kTutorialPropAnimation["10010"] = "hammer_anime"
kTutorialPropAnimation["10026"] = "hammer_anime"

kTutorialPropAnimation["10002"] = "back_anime"
kTutorialPropAnimation["10003"] = "change_anime"
kTutorialPropAnimation["10004"] = "add5_anime"
kTutorialPropAnimation["10018"] = "add3_anime"
kTutorialPropAnimation["10007"] = "line_boomb_anime"
kTutorialPropAnimation["10052"] = "octopus_anime"
kTutorialPropAnimation["10053"] = "octopus_anime"
kTutorialPropAnimation["10055"] = "random_bird_anime"
kTutorialPropAnimation["10056"] = "broom_anime"

if __IOS_FB then
	kTutorialPropAnimation["10004"] = "add5_anime_zh_TW"
	kTutorialPropAnimation["10018"] = "add3_anime_zh_TW"
end

function CommonSkeletonAnimation:creatTutorialAnimation(propId) 
	local propName = kTutorialPropAnimation[tostring(propId)]
	if propName then
		local node = ArmatureNode:create(propName)
		node:setAnimationScale(1.25)
		node:playByIndex(0)
		node.playAnimation = function( self )
			node:playByIndex(0, 0)
		end
		node.stopAnimation = function ( self )
			node:gotoAndStopByIndex(0, 0)
		end
		node:update(0.001)
		node:stop()
		return node
	else return nil end
end