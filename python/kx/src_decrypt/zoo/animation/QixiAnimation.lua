QixiAnimation = class()

QixiBossAnimationEnum = 
{
	kHippoWalk = "hippo_walk",
	kFoxWalk   = "fox_walk",
	kHippoWait = "hippo_wait",
	kFoxWait   = "fox_wait",
	kHippoHit  = "hippo_hit",
	kFoxHit    = "fox_hit",
	kFoxCast   = "fox_cast",
	kBossMeeting = "boss_meeting"
}

QixiBossEnum =
{
	kHippo = "hippo",
	kFox   = "fox",
}

QixiBossState = 
{
	kWalk = "walk",
	kWait = "wait",
	kHit  = "hit",
	kCast = "cast",
}

QixiBossAnimationConfig = {
	[QixiBossAnimationEnum.kHippoWalk] = { scaleX = -0.7, scaleY = 0.7},
	[QixiBossAnimationEnum.kFoxWalk]   = { scaleX =  0.53, scaleY = 0.53},
	[QixiBossAnimationEnum.kHippoWait] = { scaleX = -0.7, scaleY = 0.7},
	[QixiBossAnimationEnum.kFoxWait]   = { scaleX = 0.53, scaleY = 0.53},
	[QixiBossAnimationEnum.kHippoHit]  = { scaleX = -0.7, scaleY = 0.7},
	[QixiBossAnimationEnum.kFoxHit]    = { scaleX = 0.53, scaleY = 0.53},
	[QixiBossAnimationEnum.kFoxCast]   = { scaleX = 0.53, scaleY = 0.53},
	[QixiBossAnimationEnum.kBossMeeting]   = { scaleX = 0.7,    scaleY = 0.7},
}

local _instance = nil

function QixiAnimation:getInstance()
	if not _instance then
		_instance = QixiAnimation.new()
	end

	return _instance
end

local function getRealPlistPath(path)
	local plistPath = path
	if __use_small_res then  
		plistPath = table.concat(plistPath:split("."),"@2x.")
	end

	return plistPath
end

function QixiAnimation:init()
	FrameLoader:loadArmature( "skeleton/qixi_boss_animation")
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(getRealPlistPath("flash/dig_block.plist"))
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(getRealPlistPath("flash/qixi_boss.plist"))
	self.initialized = true
end

function QixiAnimation:dispose()
	CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename("skeleton/qixi_boss_animation/texture.png"))
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(getRealPlistPath("flash/dig_block.plist"))
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(getRealPlistPath("flash/qixi_boss.plist"))
	self.initialized = false
end

function QixiAnimation:createStarShinningAnimation()
	if not self.initialized then
		self:init()
	end

	local star = Sprite:createWithSpriteFrameName("star_shinning_0000")

	local star_shinning_frames = SpriteUtil:buildFrames("star_shinning_%04d", 0, 18)
	local star_shinning_animate = SpriteUtil:buildAnimate(star_shinning_frames, 1/30)
	star:play(star_shinning_animate, 0, 0, nil, false)

	return star
end

function QixiAnimation:createAnimation(name)
	if not self.initialized then
		self:init()
	end

	local node = ArmatureNode:create(name)
	node:playByIndex(0)

	node:setScaleX(QixiBossAnimationConfig[name].scaleX)
	node:setScaleY(QixiBossAnimationConfig[name].scaleY)
	return node
end

function QixiAnimation:createStarParticle()
	
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("flash/qixi_boss.plist")

	local container = CocosObject:create()

	local bg = Sprite:createWithSpriteFrameName("gland")
	local width = bg:getContentSize().width
	local height = bg:getContentSize().height
	bg:setPositionXY(width/2, height/2)
	container:addChild(bg)

	local node = ClippingNode:create(CCRectMake(0,0,237,158))
	local starLine = ParticleSystemQuad:create("particle/star5.plist")
	starLine:setAutoRemoveOnFinish(true)
	starLine:setPosition(ccp(237/2, 158/2))
	node:addChild(starLine)

	node:setPositionXY(15, 20)
	container:addChild(node)

	return container
end

function QixiAnimation:playBossMeetingAnimation(diamondCount, diamondTargetPos, propCount, propTargetPos, completeCallback)
	local winSize = Director:sharedDirector():getVisibleSize()
	local origin = Director:sharedDirector():getVisibleOrigin()
	local scene = Director:sharedDirector():getRunningScene()
	local container = Layer:create()
    container:setTouchEnabled(true, 0, true)
    container:setPositionXY(origin.x, origin.y)
	scene:addChild(container)

    local greyCover = LayerColor:create()
    greyCover:setColor(ccc3(0,0,0))
    greyCover:setOpacity(150)
    greyCover:setContentSize(CCSizeMake(winSize.width, winSize.height))
    greyCover:setPosition(ccp(0, 0))
    container:addChild(greyCover)

    diamondTargetPos = diamondTargetPos or ccp(winSize.width/2, winSize.height)
    diamondCount = diamondCount or 20
    local diamonds = {}
    for i=1, diamondCount do

    	local diamond = Sprite:createWithSpriteFrameName("dig_jewel_qixi_0000")
		diamond:setPositionXY(winSize.width/2, winSize.height/2 + 50)
		diamond:setScale(0.5)
		diamond:setVisible(false)
		container:addChild(diamond)
		table.insert(diamonds, diamond)
    end

	local boss_meeting = QixiAnimation:getInstance():createAnimation(QixiBossAnimationEnum.kBossMeeting)
	local size = boss_meeting:getGroupBounds().size
	print("boss_meeting size: ", size.width, size.height)

	local targetRect = CCRectMake(winSize.width/2 - 100, winSize.height/2 - size.height, 200, 100)
	local targetPoints = {}

	local function isValidPoint(point, minDistance)
		if not targetPoints or #targetPoints ==0 then
			return true
		end

		for i,v in ipairs(targetPoints) do
			local diffPoint = ccp(point.x - v.x, point.y - v.y)
			if math.pow(diffPoint.x , 2) + math.pow(diffPoint.y, 2) > minDistance*minDistance then
				return false
			end 
		end

		return true
	end

	local function randomTargetPoint()
		local point = ccp(targetRect.origin.x + math.random(0, 200), targetRect.origin.y + math.random(0, 100))
		local count = 0

		while count < 5 and not isValidPoint(point, 10) do
	
			count = count + 1
			point = ccp(targetRect.origin.x + math.random(0, 200), targetRect.origin.y + math.random(0, 100))
		end

		table.insert(targetPoints, point)
		return point
	end

	local function onComplete()
		local function onAllFlyComplete()
			print("allDiamond fly completed!!!!!!!!!")
			container:removeFromParentAndCleanup(true)
		end
		for i=1, diamondCount do
			local diamond = diamonds[i]
			diamond:setVisible(true)

			local unitOffsetX = winSize.width/3
			local points = CCPointArray:create(4)
			if i%2==0 then
				points:addControlPoint(ccp(winSize.width/2 , winSize.height/2 + size.height/2))
				points:addControlPoint(ccp(winSize.width/2 - unitOffsetX/2, winSize.height/2 + size.height))
				points:addControlPoint(ccp(winSize.width/2 - unitOffsetX, winSize.height/2))
				points:addControlPoint(ccp(winSize.width/2 - unitOffsetX/2, winSize.height/2 - size.height/2))
			else
				points:addControlPoint(ccp(winSize.width/2 , winSize.height/2 + size.height/2))
				points:addControlPoint(ccp(winSize.width/2 + unitOffsetX/2, winSize.height/2 + size.height))
				points:addControlPoint(ccp(winSize.width/2 + unitOffsetX, winSize.height/2))
				points:addControlPoint(ccp(winSize.width/2 + unitOffsetX/2, winSize.height/2 - size.height/2))	
			end

			local target = randomTargetPoint()
			points:addControlPoint(ccp(target.x, target.y))

			local actions = CCArray:create()
			actions:addObject(CCDelayTime:create(i*0.2))
			actions:addObject(CCCardinalSplineTo:create(3, points, 0))
			actions:addObject(CCMoveTo:create(0.5, diamondTargetPos))
			actions:addObject(CCCallFunc:create(function() 
				if completeCallback then
					completeCallback()
				end
			 end))
			if i == diamondCount then
				actions:addObject(CCCallFunc:create(onAllFlyComplete))
			end
			diamond:runAction(CCSequence:create(actions))
		end
	end

	boss_meeting:setPositionXY(winSize.width/2, winSize.height/2 + size.height/2)
	boss_meeting:addEventListener(ArmatureEvents.COMPLETE, onComplete)
	container:addChild(boss_meeting)
end

----
----  qixi_boss implementation
----

QixiBoss = class(CocosObject)

function QixiBoss:create()
  return QixiBoss.new(CCNode:create())
end

function QixiBoss:build(name, state, stateCompleteCallback)
	local boss = QixiBoss:create()
	local bossState = state or QixiBossState.kWait
	boss:init(name, bossState, stateCompleteCallback)

	return boss
end

function QixiBoss:setStateCompleteCallback(callback)
	self.animation:removeAllEventListeners()
	self.stateCompleteCallback = callback

	local function animationCallback()
		if not self.isDisposed and self.stateCompleteCallback then
			self.stateCompleteCallback(self.state)
		end
	end

	self.animation:addEventListener(ArmatureEvents.COMPLETE, animationCallback)
end

function QixiBoss:init(name, state, stateCompleteCallback)
	self.name = name
	self.state = state

	self.animation = QixiAnimation:getInstance():createAnimation(name.."_"..state)
	self:addChild(self.animation)

	self:setStateCompleteCallback(stateCompleteCallback)
end

function QixiBoss:setState(state, stateCompleteCallback)
	if self.state~= state then
		self.state = state
		self.animation:removeAllEventListeners()
		self.animation:removeFromParentAndCleanup(true)

		self:init(self.name, state, stateCompleteCallback)
	else
		self:play()
	end
end

function QixiBoss:playWait()
	self:stopAllActions()
	self.cachedActions = {}
	
	self:setState(QixiBossState.kWait)
	self:setStateCompleteCallback(function() 
		print("wait played completed!!!!!!!")
		self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(5), 
					   								   CCCallFunc:create(function() self:play() end)))
	end)
end

function QixiBoss:playCast()
	self:stopAllActions()
	self.cachedActions = {}
	self:setState(QixiBossState.kCast)
end

function QixiBoss:playHit(distance, duration, completeCallback)
	self:stopAllActions()
	if not self.cachedActions then
		self.cachedActions = {}
	end
	table.insert(self.cachedActions, {distance = distance, duration = duration, callback = completeCallback})

	local function createAction(actionData)
		local action1 = CCMoveBy:create(actionData.duration, ccp(actionData.distance, 0))
		local action2 = CCCallFunc:create(function()  
				--execute the current action completeCallback
				if actionData.callback then
					actionData.callback()
				end

				--remove the first action
				table.remove(self.cachedActions, 1)

				--execute the next action in the list, if there is one.
				if #self.cachedActions > 0 then
					self:runAction( createAction(self.cachedActions[1]) )
				else
					self:playWait()
				end
			end)
		return CCSequence:createWithTwoActions(action1, action2)
	end

	if self.state ~= QixiBossState.kHit and self.state ~= QixiBossState.kWalk then
		self:setState(QixiBossState.kHit)
		self:setStateCompleteCallback(function() 
			self:setState(QixiBossState.kWalk)
			print("cachedAction: ", self.cachedActions[1])
			self:runAction(createAction(self.cachedActions[1]))
		 end)
	end
end


function QixiBoss:play()
	self.animation:playByIndex(0)
end


