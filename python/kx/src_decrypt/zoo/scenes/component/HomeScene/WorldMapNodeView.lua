
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年08月22日 10:55:38
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panel.StartGamePanel"
require "hecore.ui.PopoutManager"
require "zoo.animation.Flowers"

---------------------------------------------------
-------------- WorldMapNodeView
---------------------------------------------------

assert(not WorldMapNodeViewEvents)

WorldMapNodeViewEvents = 
{
	-- When self.star Changed To 0 From -1
	FLOWER_OPENED_WITH_NO_STAR	= "WorldMapNodeViewEvents.FLOWER_OPENED_WITH_NO_STAR",

	-- When self.star Changed Frome 0 To 1,2,3,4
	FIRST_OPENED_WITH_STAR		= "WorldMapNodeViewEvents.FIRST_OPENED_WITH_STAR",

	-- When User Replay This Level And Get A New Star Level
	OPENED_WITH_NEW_STAR		= "WorldMapNodeViewEvents.OPENED_WITH_NEW_STAR"
}


assert(not WorldMapNodeView)
assert(BaseUI)

WorldMapNodeView = class(CocosObject)

function WorldMapNodeView:ctor(...)
	assert(#{...} == 0)
end

function WorldMapNodeView:init(isNormalFlower, levelId, playAnimLayer, bmFontBatchLayer, texture, ...)
	assert(isNormalFlower ~= nil)
	assert(type(isNormalFlower) == "boolean")
	assert(levelId)
	assert(playAnimLayer)
	assert(bmFontBatchLayer)
	assert(#{...} == 0)

	local sprite = CCSprite:create()
	self:setRefCocosObj(sprite)

	-- ----------------------------------------
	-- Set Texture For Used In CCSpriteBatchNode
	--------------------------------------------
	self.refCocosObj:setTexture(texture)

	-- Resource
	self.resourceManager	= ResourceManager:sharedInstance()

	---------------
	---- Data 
	----------------
	self.playAnimLayer	= playAnimLayer
	self.bmFontBatchLayer	= bmFontBatchLayer
	self.firstOpenWithStar	= nil
	self.isNormalFlower	= isNormalFlower
	self.levelId		= levelId
	self.levelDisplayName = tostring(LevelMapManager.getInstance():getLevelDisplayName(self.levelId))

	self.oldStar		= false
	self.star		= false
	self:setStar(-1,false, false, false)

	self.childrenAddedToAnimLayer = {}

	self.flowerRes = false
end

function WorldMapNodeView:setStar(star, updateView, playAnimInLogic, animFinishCallback, ...)
	assert(type(star) == "number")
	assert(type(updateView) == "boolean")
	assert(type(playAnimInLogic) == "boolean")
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)
	
	assert(star >= -1)
	assert(star <= 4)

	if self.star ~= star then
		self.oldStar 	= self.star
		self.star 	= star

		if updateView then
			self:updateView(playAnimInLogic, animFinishCallback)
		else
			if animFinishCallback then
				animFinishCallback()
			end
		end
	else
		if animFinishCallback then
			animFinishCallback()
		end
	end
end

function WorldMapNodeView:getStar(...)
	assert(#{...} == 0)

	return self.star
end

function WorldMapNodeView:getFlowerRes(...)
	assert(#{...} == 0)

	return self.flowerRes
end

function WorldMapNodeView:getLevelId(...)
	assert(#{...} == 0)

	return self.levelId
end

function WorldMapNodeView:addChildToPlayAnimLayer(sprite, ...)
	assert(#{...} == 0)

	table.insert(self.childrenAddedToAnimLayer, sprite)

	local selfPosInPlayAnimLayer = self:getSelfPositionInPlayAnimLayer()

	local manualAdjustX = 3
	local manualAdjustY = 0

	sprite:setPosition(ccp(selfPosInPlayAnimLayer.x + manualAdjustX, selfPosInPlayAnimLayer.y + manualAdjustY))
	self.playAnimLayer:addChild(sprite)
end

function WorldMapNodeView:addLevelLabel(...)
	assert(#{...} == 0)

	if not self.isLevelLabelAdded then
		self.isLevelLabelAdded = true

		local selfPosInPlayAnimLayer = self:getSelfPositionInPlayAnimLayer()
		self.manualAdjustLabelPosX	= 0
		self.manualAdjustLabelPosY = -38
		
		local manualAdjustX = self.manualAdjustLabelPosX
		local manualAdjustY = self.manualAdjustLabelPosY

		local label = self.bmFontBatchLayer:createLabel(self.levelDisplayName)
		label:setAnchorPoint(ccp(0.5, 0))

		label:setPosition(ccp(selfPosInPlayAnimLayer.x + manualAdjustX, selfPosInPlayAnimLayer.y + manualAdjustY ))
		self.bmFontBatchLayer:addChild(label)
	end
end

function WorldMapNodeView:cleanChildrenAddedToAnimLayer(...)
	assert(#{...} == 0)

	for k,v in ipairs(self.childrenAddedToAnimLayer) do
		v:removeFromParentAndCleanup(true)
	end

	self.childrenAddedToAnimLayer = {}
end

function WorldMapNodeView:updateView(playAnimInLogic, animFinishCallback, ...)
	assert(playAnimInLogic ~= nil)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	-- Clean
	self:removeChildren(true)
	self.flowerRes = false
	self:cleanChildrenAddedToAnimLayer()
	
	-----------------------------------
	------ Play Animation And 
	------- Create Display
	-----------------------------------
	if self.star == -1 then
		-- Flower Closed
		-- When User Not Reached This Level
		local flower = Sprite:createWithSpriteFrameName(kFlowers.flowerSeed.."0000")
		flower:setAnchorPoint(ccp(0.5, 1))
		self.flowerRes = flower
		self:addChild(flower)
	elseif self.star == 0 then
		-- Flower Open
		-- When User Stand On This Level , But Not Pass This Level
		if playAnimInLogic then
			self:playFlowerOpenAnimation(animFinishCallback)
		else
			self:flowerOpen()
		end

	elseif self.star >= 1 or  self.star <= 4 then
		-- Flower Has Star
		-- After User Finish This Level

		self.firstOpenWithStar = false

		if not self.firstEnterThere then
			self.firstEnterThere = true

			self.firstOpenWithStar = true
		end

		if playAnimInLogic then
			self:playFlowerOpenWithStarAnimation(animFinishCallback)
		else
			self:flowerOpenWithStar()
		end
	else
		assert(false)
	end

	--------------------
	--- Label
	-------------------
	
	self:addLevelLabel()
end

function WorldMapNodeView:playParticle()
	local particles = ParticleSystemQuad:create("particle/flower_glow.plist")
	particles:setAutoRemoveOnFinish(true)
	particles:setPosition(ccp(self:getPositionX(), self:getPositionY() - 80))
	self.playAnimLayer:addChild(particles)

	local arr = CCArray:create()
    arr:addObject(CCEaseSineOut:create(CCRotateTo:create(0.1, -18)))
    arr:addObject(CCEaseSineIn:create(CCRotateTo:create(0.1, 0)))
    arr:addObject(CCEaseSineOut:create(CCRotateTo:create(0.1, 15)))
    arr:addObject(CCEaseSineIn:create(CCRotateTo:create(0.1, 0)))
    arr:addObject(CCEaseSineOut:create(CCRotateTo:create(0.1, -12)))
    arr:addObject(CCEaseSineIn:create(CCRotateTo:create(0.1, 0)))
    arr:addObject(CCEaseSineOut:create(CCRotateTo:create(0.1, 9)))
    arr:addObject(CCEaseSineIn:create(CCRotateTo:create(0.1, 0)))
    arr:addObject(CCEaseSineOut:create(CCRotateTo:create(0.1, -4)))
    arr:addObject(CCEaseSineIn:create(CCRotateTo:create(0.1, 0)))
    arr:addObject(CCEaseSineOut:create(CCRotateTo:create(0.1, 2)))
    arr:addObject(CCEaseSineIn:create(CCRotateTo:create(0.1, 0)))
    self:runAction(CCSequence:create(arr))
end

-------------------------------------------------
-------- Flower Open With No Star
-------- That's self.star = 0
-------------------------------------------------

function WorldMapNodeView:getSelfPositionInPlayAnimLayer(...)
	assert(#{...} == 0)

	-- Convert Self Position To self.playAnimLayer's Space
	local parent = self:getParent()
	assert(parent)
	local selfPos	= self:getPosition()
	local toWorldPos = parent:convertToWorldSpace(ccp(selfPos.x, selfPos.y))
	local toPlayAnimLayerPos = self.playAnimLayer:convertToNodeSpace(ccp(toWorldPos.x, toWorldPos.y))
	
	return toPlayAnimLayerPos
end

function WorldMapNodeView:playFlowerOpenAnimation(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)
	
	local glowAnimation = Flowers:buildGlowEffect(kFlowers.flowerStar0)
	self:addChildToPlayAnimLayer(glowAnimation)

	local function onAnimFinished()

		glowAnimation:removeFromParentAndCleanup(true)

		-- Use The Static Picture To Replace Animation
		self:flowerOpen()

		if animFinishCallback then
			animFinishCallback()
		end

		self:dispatchEvent(Event.new(WorldMapNodeViewEvents.FLOWER_OPENED_WITH_NO_STAR, self.levelId))
	end
	glowAnimation:addEventListener(Events.kComplete, onAnimFinished)

	-- Play THe Anim
	glowAnimation:bloom()
end

function WorldMapNodeView:flowerOpen(...)
	assert(#{...} == 0)

	local selfPosInPlayAnimLayer = self:getSelfPositionInPlayAnimLayer()
	local flower = Sprite:createWithSpriteFrameName(kFlowers.flowerStar0.."0000")
	flower:setAnchorPoint(ccp(0.5, 1))

	assert(flower)
	self.flowerRes = flower
	self:addChild(flower)

	-------------------
	----- Background Animation
	--------------------------
	local shadowGlow = Sprite:createWithSpriteFrameName("flowerShineCircle0000")
	shadowGlow:setVisible(false)
	
	local glowSprite = Sprite:createWithSpriteFrameName("flowerShineCircle0000")

	local animationTime = 1
	local breatheLamp = CCArray:create()
	breatheLamp:addObject(CCScaleTo:create(animationTime, 1.15, 1)) 
	breatheLamp:addObject(CCDelayTime:create(0.3))
	breatheLamp:addObject(CCScaleTo:create(animationTime, 0.85, 0.7 )) 
	local seq = glowSprite:runAction(CCSequence:create(breatheLamp))


	self:addChildToPlayAnimLayer(shadowGlow)
	self:addChildToPlayAnimLayer(glowSprite)

	-- -----------------------------------------------
	-- Adjust Position After Added To Animation Layer
	-- ---------------------------------------------------
	local flowerSize = flower:getContentSize()
	
	local manualAdjustY = -20
	local manualAdjustX = -3

	-- Adjust Shadow Glow Pos
	local curPosX	= shadowGlow:getPositionX()
	local curPosY	= shadowGlow:getPositionY()
	local newPosX	= curPosX + manualAdjustX
	local newPosY	= curPosY - flowerSize.height / 2 + manualAdjustY
	shadowGlow:setPosition(ccp(newPosX, newPosY))

	-- Adjust Glow Sprite Pos
	local curPosX = glowSprite:getPositionX()
	local curPosY = glowSprite:getPositionY()
	local newPosX = curPosX + manualAdjustX
	local newPosY = curPosY - flowerSize.height / 2 + manualAdjustY
	glowSprite:setPosition(ccp(newPosX, newPosY))

	glowSprite:runAction(CCRepeatForever:create(seq))
end

--------------------------------------------------------
-------- Flower Open With Star
-------- That's self.star >= 1
----------------------------------------------------

function WorldMapNodeView:flowerOpenWithStar(...)
	assert(#{...} == 0)

	assert(self.star >=1 and self.star <=4)

	local flowerWithStar = false

	if self.isNormalFlower then
		flowerWithStar = Sprite:createWithSpriteFrameName(kFlowers["flowerStar"..self.star].."0000")
	else
		flowerWithStar = Sprite:createWithSpriteFrameName(kFlowers["hiddenFlower"..self.star].. "0000")
	end

	flowerWithStar:setAnchorPoint(ccp(0.5, 1))
	assert(flowerWithStar)
	self.flowerRes = flowerWithStar
	self:addChild(flowerWithStar)
	self:buildStar()
end

function WorldMapNodeView:playFlowerOpenWithStarAnimation(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)
	
	local glowAnimation = false

	if self.isNormalFlower then
		glowAnimation = Flowers:buildGlowEffect(kFlowers["flowerStar" .. self.star])
	else
		glowAnimation = Flowers:buildGlowEffect(kFlowers["hiddenFlower".. self.star])
	end

	self:addChildToPlayAnimLayer(glowAnimation)

	local function onAnimFinished()

		glowAnimation:removeFromParentAndCleanup(true)
		self:flowerOpenWithStar()
		self:playFlyingNewStarAnim()

		if animFinishCallback then
			animFinishCallback()
		end

		if self.firstOpenWithStar then
			self.firstOpenWithStar = false
			self:dispatchEvent(Event.new(WorldMapNodeViewEvents.FIRST_OPENED_WITH_STAR, self.levelId))
		end

		self:dispatchEvent(Event.new(WorldMapNodeViewEvents.OPENED_WITH_NEW_STAR, self.levelId))
	end

	glowAnimation:addEventListener(Events.kComplete, onAnimFinished)
	glowAnimation:bloom()
end

function WorldMapNodeView:playFlyingNewStarAnim(...)
	assert(#{...} == 0)

	-- Fly Which Star, Based On The self.oldStar And self.star Variable

	local actionArray = CCArray:create()

	local startTime		= 0
	local delayTimePerStar	= 0.1
	local moveToTime	= 0.8

	if not self.oldStar then
		self.oldStar = 0
	end

	--if self.oldStar and 
	if self.oldStar >= 0 and self.oldStar <= 3 and
		self.oldStar ~= self.star then

		for k = self.oldStar+1, self.star do

			-- ---------------------
			-- Create Star Resource
			-- ---------------------
			local starSpriteFrameName = nil
			if self.isNormalFlower then
				starSpriteFrameName = "flowerStar"
			else
				starSpriteFrameName = "hiddenFlowerStar"
			end

			local starRes = Sprite:createWithSpriteFrameName(starSpriteFrameName .. k .. "0000")
			starRes:setVisible(false)
			HomeScene:sharedInstance():addChild(starRes)

			-- Get Star Position In Self
			-- Note: Must Called Function buildStar First !
			local star 		= self.stars[k]
			-- Convert Pos To World Space
			local starPos			= star:getPosition()
			local starParent		= star:getParent()
			local starPosInWorldSpace	= starParent:convertToWorldSpace(ccp(starPos.x, starPos.y))
			-- Convert Pos To HomeScene Space
			local starPosInHomeScene 	= HomeScene:sharedInstance():convertToNodeSpace(starPosInWorldSpace)

			----------------------------------------------
			-- Get HomeScene Star Bubble's Star Position
			-- ---------------------------------------------
			local homeSceneStar			= HomeScene:sharedInstance().starButton.starIcon
			local homeSceneStarParent		= homeSceneStar:getParent()
			-- Convert To World Space
			local homeSceneStarPos			= homeSceneStar:getPosition()
			local homeSceneStarPosInWorldSpace	= homeSceneStarParent:convertToWorldSpace(ccp(homeSceneStarPos.x, homeSceneStarPos.y))
			-- Convert To Home Scene Space
			local homeSceneStarPosInHomeScene	= HomeScene:sharedInstance():convertToNodeSpace(homeSceneStarPosInWorldSpace)

			starRes:setPosition(ccp(starPosInHomeScene.x, starPosInHomeScene.y))

			-- Delay
			local delay	= CCDelayTime:create(startTime)
			startTime = startTime + delayTimePerStar

			-- Init Action 
			local function initActionFunc()
				starRes:setVisible(true)
			end
			local initAction = CCCallFunc:create(initActionFunc)

			-- Move To Action
			--local moveTo 		= CCMoveTo:create(moveToTime, ccp(homeSceneStarPosInHomeScene.x, homeSceneStarPosInHomeScene.y))
			local curPos		= starRes:getPosition()
			local distance		= ccpDistance(ccp(homeSceneStarPosInHomeScene.x, homeSceneStarPosInHomeScene.y), curPos)
			local bezierTo		= HeBezierTo:create(moveToTime, ccp(homeSceneStarPosInWorldSpace.x, homeSceneStarPosInHomeScene.y), false, distance * 0.15)
			local easeBezier	= CCEaseOut:create(bezierTo, 0.3)

			local targetMoveTo	= CCTargetedAction:create(starRes.refCocosObj, easeBezier)

			local scaleLarge	= CCScaleTo:create(moveToTime, 1.5)
			local targetScale	= CCTargetedAction:create(starRes.refCocosObj, scaleLarge)

			local spawn = CCSpawn:createWithTwoActions(targetMoveTo, targetScale)

			-- Anim Finish Callback
			local function animFinishCallbackFunc()
				starRes:removeFromParentAndCleanup(true)
				HomeScene:sharedInstance().starButton:playHighlightAnim()

				if k == self.star then
					HomeScene:sharedInstance().starButton:playBubbleSkewAnim()
					HomeScene:sharedInstance().starButton:updateView()
				end
			end
			local animFinishCallbackAction = CCCallFunc:create(animFinishCallbackFunc)

			-- Action Array
			local individualStarActionArray = CCArray:create()
			individualStarActionArray:addObject(delay)
			individualStarActionArray:addObject(initAction)
			individualStarActionArray:addObject(spawn)
			individualStarActionArray:addObject(animFinishCallbackAction)
			-- Seq 
			local seq = CCSequence:create(individualStarActionArray)
			actionArray:addObject(seq)
		end

		local spawn = CCSpawn:create(actionArray)
		self:runAction(spawn)
	end
end

---------------------------------------
---- Build Star
----------------------------------
function WorldMapNodeView:buildStar(...)
	assert(#{...} == 0)

	local stars = {}
	self.stars = stars

	local leftMostX	= -(self.star * 22) / 2 + 12

	self.starContainerPosY	= -138
	local starWidthPadding 	= 0
	local starSpriteFrameName = nil

	if self.isNormalFlower then
		starSpriteFrameName = "flowerStar"
	else
		starSpriteFrameName = "hiddenFlowerStar"
	end

	for index = 1, self.star do
		local runningScene = Director:getRunningScene()
		local star = Sprite:createWithSpriteFrameName(starSpriteFrameName .. index .. "0000")
		assert(star)

		star:setPositionX(leftMostX)
		star:setPositionY(self.starContainerPosY)

		local starWidth = star:getGroupBounds(self).size.width
		leftMostX = leftMostX + starWidth + starWidthPadding

		stars[#stars + 1] = star
		self:addChild(star)
	end
end

function WorldMapNodeView:create(isNormalFlower, levelId, playAnimLayer, bmFontBatchLayer, texture, ...)
	assert(isNormalFlower ~= nil)
	assert(type(isNormalFlower) == "boolean")
	assert(levelId)
	assert(playAnimLayer)
	assert(bmFontBatchLayer)
	assert(#{...} == 0)

	local newWorldMapNodeView = WorldMapNodeView.new()
	newWorldMapNodeView:init(isNormalFlower, levelId, playAnimLayer, bmFontBatchLayer, texture)
	return newWorldMapNodeView
end

function WorldMapNodeView:getAnimationCenter()
	local pos = self:getPosition()
	return ccp(pos.x, pos.y - 80)
end