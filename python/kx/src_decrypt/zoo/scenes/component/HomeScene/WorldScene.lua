
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年11月14日 13:45:54
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.scenes.component.HomeScene.Trunks"
require "zoo.scenes.component.HomeScene.UserPicture"
require "zoo.scenes.component.HomeScene.FriendPicStack"
require "zoo.scenes.component.HomeScene.TreeTopLockedCloud"
require "zoo.scenes.component.HomeScene.interaction.WorldSceneBranchInteractionController"
require "zoo.scenes.component.HomeScene.interaction.WorldSceneTrunkInteractionController"
require "zoo.scenes.component.HomeScene.WorldMapOptimizer"
require "zoo.scenes.component.HomeSceneFlyToAnimation"

require "zoo.events.GamePlayEvents"

---------------------------------------------------
-------------- WorldScene
---------------------------------------------------

assert(not WorldScene)
assert(WorldSceneScroller)
WorldScene = class(WorldSceneScroller)

function WorldScene:init(homeScene, ...)
	assert(homeScene)
	assert(#{...} == 0)

	WorldSceneShowManager.getInstance()
	-----------------
	-- Init Base Class
	-- --------------
	WorldSceneScroller.init(self)
	WorldMapOptimizer:getInstance():init(self)

	-- Data
	self.metaModel = MetaModel:sharedInstance()

	-- System State
	self.homeScene = homeScene
	self.winSize = CCDirector:sharedDirector():getWinSize()
	self.visibleSize = CCDirector:sharedDirector():getVisibleSize()
	self.visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	self.contentScaleFactor = CCDirector:sharedDirector():getContentScaleFactor()

	-- Parallax Config
	local config = UIConfigManager:sharedInstance():getConfig()

	-- ---------------
	-- Create Layer
	-- ---------------
	-- maskedLayer Is The Parent Layer For All 
	-- Other Layer Used To Scroll All 
	self.maskedLayer = ParallaxNode:create()
	self:addChild(self.maskedLayer)
	self.maskedLayer:setPositionY(self.visibleOrigin.y)


	-- ------------------
	-- Gradient Background
	-- --------------------
	local backgroundParallax = config.worldScene_backgroundParallax
	assert(backgroundParallax)
	self.gradientBackgroundParallaxRatio = ccp(backgroundParallax, backgroundParallax)
	self.gradientBackgroundLayer = Layer:create()
	self.maskedLayer:addParallaxChild(self.gradientBackgroundLayer, 0, self.gradientBackgroundParallaxRatio, ccp(0,0))

	-- 主界面星星先关（春节用 已过期）
	-- local star1Parallax = 0.007
	-- self.star1Parallax = ccp(star1Parallax, star1Parallax)
	-- local plistPath = "flash/scenes/homeScene/home_night/home_scene_star.plist"
	-- if __use_small_res then  
	-- 	plistPath = table.concat(plistPath:split("."),"@2x.")
	-- end
	-- CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
	-- local texture = CCSprite:createWithSpriteFrameName("home_scene_star.png"):getTexture()
	-- self.star1Layer = SpriteBatchNode:createWithTexture(texture)
	-- self.maskedLayer:addParallaxChild(self.star1Layer, 1, self.star1Parallax, ccp(0,0))
	-- if WorldSceneShowManager.getInstance():getShowType() == 2 then 
	-- 	self.star1Layer:setVisible(true)
	-- else
	-- 	self.star1Layer:setVisible(false)
	-- end

	------------------------------
	-- Some Cloud 1 Change Layer
	-- ---------------------------
	local cloudLayer1Parallax = config.worldScene_cloudLayer1Parallax
	self.cloudLayer1Parallax = ccp(cloudLayer1Parallax, cloudLayer1Parallax)
	self.cloudLayer1Layer = Layer:create()
	self.maskedLayer:addParallaxChild(self.cloudLayer1Layer, 2, self.cloudLayer1Parallax, ccp(0,0))

	----------------------
	---- Cloud 2 Layer
	-------------------
	local cloudLayer2Parallax = config.worldScene_cloudLayer2Parallax
	assert(cloudLayer2Parallax)
	self.cloudLayer2Parallax = ccp(cloudLayer2Parallax, cloudLayer2Parallax)
	self.cloudLayer2 = Layer:create()
	self.maskedLayer:addParallaxChild(self.cloudLayer2, 3, self.cloudLayer2Parallax, ccp(0,0))

	-----------------------------
	----- Cloud Layer 
	----- Parallax Layer
	----- Used To Contain The Background Cloud
	--------------------------
	local cloudParallax = config.worldScene_cloudParallax
	self.cloudParallaxRatio = ccp(cloudParallax, cloudParallax)
	self.cloudLayer = Layer:create()
	self.maskedLayer:addParallaxChild(self.cloudLayer, 4, self.cloudParallaxRatio, ccp(0,0))
	self.cloudContainer = Layer:create()

	self.cloudLayer:addChild(self.cloudContainer)

	-----------------------
	-- Scale Small Layers
	-- ---------------------
	self.scaleOutButPreserveInnerLayers = {}

	-------------------------------
	--	Scale Small Layer 1
	-- --------------------------
	self.scaleTreeLayer1 = Layer:create()
	self.maskedLayer:addParallaxChild(self.scaleTreeLayer1, 5, ccp(1,1), ccp(0,0))

	---------------------
	--- Hidden Branch Layer
	------------------------
	self.hiddenBranchArray = {}

	local hiddenBranchSpriteFrame = Sprite:createWithSpriteFrameName("hide_branch10000")
	local hiddenBranchTexture = hiddenBranchSpriteFrame:getTexture()
	self.hiddenBranchLayer = SpriteBatchNode:createWithTexture(hiddenBranchTexture)
	hiddenBranchSpriteFrame:dispose()
	self.scaleTreeLayer1:addChild(self.hiddenBranchLayer)

	self.hiddenBranchAnimLayer = Layer:create()
	self.scaleTreeLayer1:addChild(self.hiddenBranchAnimLayer)

	-- ---------
	-- Tree Layer
	-- -----------
	self.treeContainer = Layer:create()
	self.trunks = false
	self.scaleTreeLayer1:addChild(self.treeContainer)

	------------------------------
	---- Fower Play Anim Layer 
	------------------------------
	-- Because Animation Texture Add Different, So Can't Add To CCSpriteBatchNode
	-- So, Dedicate A Layer For This
	self.playFlowerAnimLayer = Layer:create()
	self.scaleTreeLayer1:addChild(self.playFlowerAnimLayer)

	---------------------------------
	---- Tree Flower Layer (Tree Node Layer) , Batch Node
	---------------------------------
	local flowerSpriteFrame = Sprite:createWithSpriteFrameName("normalFlowerAnim00000")
	local texture = flowerSpriteFrame:getTexture()
	self.treeNodeLayer = SpriteBatchNode:createWithTexture(texture)
	flowerSpriteFrame:dispose()
	self.treeNodeLayer.touchEnabled = false
	self.scaleTreeLayer1:addChild(self.treeNodeLayer)

	self.levelToNode = {}

	---------------------------------------
	-- Flower Level Number Batch Layer
	-- --------------------------------------------
	self.flowerLevelNumberBatchLayer = BMFontLabelBatch:create("fnt/level_seq_n_energy_cd.png", "fnt/level_seq_n_energy_cd.fnt", 100)
	self.flowerLevelNumberBatchLayer.name = "flowerLevelNumberBatchLayer"
	self.scaleTreeLayer1:addChild(self.flowerLevelNumberBatchLayer)
	table.insert(self.scaleOutButPreserveInnerLayers, self.flowerLevelNumberBatchLayer)

	------------------------------
	--- Explore Cloud Button Layer
	-----------------------------
	self.currentStayBranchIndex = false

	----------------------------
	-- Scale Small Layer 2
	-- ------------------------
	self.scaleTreeLayer2 = Layer:create()
	self.maskedLayer:addParallaxChild(self.scaleTreeLayer2, 10, ccp(1,1), ccp(0,0))

	-- ------------------
	-- Locked Cloud Layer
	-- ------------------
	self.lockedCloudLayer = Layer:create()
	self.scaleTreeLayer2:addChild(self.lockedCloudLayer)

	self.lockedCloudAnimLayer = Layer:create()
	self.scaleTreeLayer2:addChild(self.lockedCloudAnimLayer)
	self.lockedClouds = {}

	----------------------
	-- Friend Picture Layer
	-- ----------------------
	self.friendPictureLayer = Layer:create()
	self.scaleTreeLayer2:addChild(self.friendPictureLayer)

	self.levelFriendPicStacksByLevelId = {}
	self.levelFriendPicStacks = {}

	self.guideLayer = Layer:create()
	self.scaleTreeLayer2:addChild(self.guideLayer)

	----------------------
	-- Foreground Layer
	-- --------------------
	local foregroundParallax = config.worldScene_foregroundParallax
	assert(foregroundParallax)
	self.foregroundParallax = ccp(foregroundParallax, foregroundParallax)
	self.foregroundLayer = Layer:create()
	self.maskedLayer:addParallaxChild(self.foregroundLayer, 15, self.foregroundParallax, ccp(0,0))

	-- ------------
	-- Init Layer
	-- ----------------
	WorldSceneShowManager.getInstance():changeCloudColor()
	local parallaxLayer = ResourceManager:sharedInstance():buildGroup("parallax")
	self.parallaxLayer = parallaxLayer

	self:buildTreeContainer()
	self:buildGradientBackground()
	self:buildStarLayer()
	self:buildcloudLayer1()
	self:buildcloudLayer2()
	self:buildCloudLayer()

	self:buildHiddenBranch()
	self:buildNodeView()
	self:buildLockedCloudLayer()
	self:buildForegroundLayer()

	---------------------------------
	-- Scale The scaleTreeLayers
	-- ------------------------------
	local config = UIConfigManager:sharedInstance():getConfig()
	local scaleRate = config.homeScene_treeScale
	
	-- -----------------------------------------------------------
	-- Set top Scrollable Range For Base Class WorldSceneScroller
	-- -----------------------------------------------------------
	local topestNormalNode = self.levelToNode[self.maxNormalLevelId]
	local topestNormalNodePosY = topestNormalNode:getPositionY() + 400

	self:setTopScrollRange(topestNormalNodePosY) 
	self.maskedLayer:setPositionY(self.visibleOrigin.y - self.belowScrollRangeY)

	-- ---------------
	-- User Picture
	-- ---------------
	self.userIcon = UserPicture:create()
	assert(self.userIcon)

	self.userIconDeltaPosY = 0
	self.userIconMovingSpeed = 300	-- pixels per second

	-- Get User Top Level
	local topLevelId = UserManager.getInstance().user:getTopLevelId()
	self.topLevelId = topLevelId
	if topLevelId == 0 then topLevelId = 1 end;

	self.levelAreaOpenedId	= UserManager.getInstance().levelAreaOpenedId

	local topLevelNode = self.levelToNode[topLevelId]
	assert(topLevelNode)
	self.userIconLevelId = self.topLevelId

	-- Set User Pic To Top Level Node Postion
	local topLevelNodePos = topLevelNode:getPosition()
	self.userIcon:setPosition(ccp(topLevelNodePos.x, topLevelNodePos.y + self.userIconDeltaPosY))
	self.friendPictureLayer:addChild(self.userIcon)

	--------------------
	-- Friend Pictures
	-- -----------------
	local friendIds = UserManager:getInstance().friendIds
	local friends = FriendManager.getInstance().friends

	-----------------------------
	---- Add Event Listener To Update View When Data Change 
	-----------------------------------------------
	-- self.homeScene:addEventListener(HomeSceneEvents.USERMANAGER_TOP_LEVEL_ID_CHANGE, self.onTopLevelChange, self)
	-- self.homeScene:addEventListener(HomeSceneEvents.USERMANAGER_LEVEL_AREA_OPENED_ID_CHANGE, self.onLevelAreaOpenedIdChange, self)

	-- 
	local function passLevelCallback(evt)
		assert(evt, "evt cannot be nil")
		print("passLevelCallback",table.tostring(evt))
		self:onLevelPassed(evt.data)
	end
	GamePlayEvents.addPassLevelEvent(passLevelCallback)

	local function onTopLevelChange(evt)
		self:onTopLevelChange(evt.data)
	end
	GamePlayEvents.addTopLevelChangeEvent(onTopLevelChange)

	local function onAreaOpenIdChange(evt)
		print("onAreaOpenIdChange",table.tostring(evt))
		local newAreaId = evt.data
		self:onAreaOpenIdChange(newAreaId)
	end
	GamePlayEvents.addAreaOpenIdChangeEvent(onAreaOpenIdChange)

	------------------------------------------
	--- Used To Check Which Flower Is Tapped
	------------------------------------------
	self:setTouchEnabled(true, 0 , true)

	self.touchState = false
	self.touchedNode = false
	self.touchedLockedCloud = false

	parallaxLayer:dispose()

	----------------------------------------
	-- Add Event Listener To Update The Flower Stars, 
	-- After Local Synced With Server
	---------------------------------------
	self.trunkInteractionController = WorldSceneTrunkInteractionController:create(self)
	self.branchInteractionController = WorldSceneBranchInteractionController:create(self)
	self:setInteractionController(self.trunkInteractionController)
	
	local function onSyncFinished()
		print("WorldScene onSyncFinished Called !")
		self:onSyncFinished()
	end

	GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kSyncFinished, onSyncFinished)

	-- ----------------------
	-- Register Script Handler
	-- ----------------------
	local function onEnterHandler(event)
		self:onEnterHandler(event)
	end
	self:registerScriptHandler(onEnterHandler)
end

function WorldScene:setEnterFromGamePlay(levelId)
	self.sourceLevelId = levelId
end

function WorldScene:onEnterHandler(event, ...)
	assert(#{...} == 0)
	print(">>>>> self.levelPassedInfo", table.tostring(self.levelPassedInfo))

	if event == "enter" then
		self.isTouched = false
		local levelType = nil
		-- if self.levelPassedInfo then levelType = self.levelPassedInfo.levelType end
		-- local levelInWorldScene = levelType == GameLevelType.kMainLevel or levelType == GameLevelType.kHiddenLevel
		if self.sourceLevelId then
			local levelId = self.sourceLevelId
			self:moveNodeToCenter(levelId, function()
				if self.levelPassedInfo then
					self:playLevelPassed(self.levelPassedInfo.passedLevelId, self.levelPassedInfo.rewardsIdAndPos, self.levelPassedInfo.isPlayNextLevel)
				else
					local node = self.levelToNode[levelId]
					print("node", node, levelId)
					if node and not node.isDisposed then node:playParticle() end
				end
				self.levelPassedInfo = nil
			end)
		end
		self.sourceLevelId = nil
	end
end

function WorldScene:setIsTouched(isTouched)
	self.isTouched = isTouched
end

function WorldScene:onSyncFinished(...)
	assert(#{...} == 0)

	self:updateLevelData()
	--------------------------
	-- Update Node Score
	-- --------------------
	local scores = UserManager:getInstance().scores
	local lastPassedLevel = UserManager:getInstance().lastPassedLevel

	for k,v in pairs(scores) do
		local levelId = v.levelId
		local star = v.star
		local node = self.levelToNode[levelId]

		if node then
			-- Node Exist , Need To Update IT's Star
			if tostring(levelId) ~= tostring(lastPassedLevel) then
				node:setStar(star, true, false, false)
				local function onNodeTouched(evt)
					self:onNodeViewTapped(evt)
				end
				if star > 0 and not node:hasEventListenerByName(DisplayEvents.kTouchTap) then
					node:addEventListener(DisplayEvents.kTouchTap, onNodeTouched, node)
				end
			end
		end
	end

	local remain = {}
	local topLevel = UserManager:getInstance().user:getTopLevelId()
	for k, v in ipairs(self.lockedClouds) do
		local cloud = MetaModel:sharedInstance():getLevelAreaDataById(v.id)
		if cloud and tonumber(cloud.minLevel) <= topLevel then
			v:removeFromParentAndCleanup(true)
		else
			v:updateState()
			table.insert(remain, v)
		end
	end
	self.lockedClouds = remain

	local logic = AdvanceTopLevelLogic:create(topLevel)
	logic:start()

	print("WorldScene:onSyncFinished")
	local scene = Director:sharedDirector():getRunningScene()
	if scene == HomeScene:sharedInstance() then
		self:updateUserIconPos(false)
		self:refreshTopAreaCloudState()
		if GameGuide then
			GameGuide:sharedInstance():forceStopGuide()
			GameGuide:sharedInstance():tryStartGuide()
		end
	end
end

function WorldScene:getTouchedNode(worldPos, ...)
	assert(worldPos)
	assert(type(worldPos.x) == "number")
	assert(type(worldPos.y) == "number")
	assert(#{...} == 0)

	------ Convert Global Position To Self Space
	--local nodeSpacePoint = self:convertToNodeSpace(ccp(worldPos.x, worldPos.y))

	-- Get Node Layer's Children
	local childrenList = self.treeNodeLayer:getChildrenList()

	for k,v in pairs(childrenList) do

		if v:hasEventListenerByName(DisplayEvents.kTouchTap) then

			local flowerRes = v:getFlowerRes()
			
			if flowerRes then
				if flowerRes:hitTestPoint(worldPos, true) then
					return v
				end
			end
		end
	end
end

function WorldScene:getTouchedLockedCloud(worldPos, ...)
	assert(#{...} == 0)

	------ Convert Global Position To Self Space
	--local nodeSpacePoint = self:convertToNodeSpace(ccp(worldPos.x, worldPos.y))

	for k,v in pairs(self.lockedClouds) do

		if v:hasEventListenerByName(DisplayEvents.kTouchTap) then

			if v:hitTestPoint(worldPos, true) then
				return v
			end
		end
	end
end

function WorldScene:getTouchedFriendStack(worldPos, ...)
	assert(#{...} == 0)

	for k,v in pairs(self.levelFriendPicStacks) do
		--if v.stack:hitTestPoint(worldPos, true) then
		if v.stack:isHitted(worldPos) then
			return v.stack
		end
	end
end

function WorldScene:getTouchedBranch(worldPos)
	for k,v in pairs(self.hiddenBranchArray) do
		if v:hasEventListenerByName(DisplayEvents.kTouchTap) then
			if v:hitTestPoint(worldPos, true) then
				return v
			end
		end
	end
end

--------------------------
--- Touch Event Handler
---------------------------

function WorldScene:onScrolledToLeftOrRight(event, ...)
	assert(event)
	assert(event.name == WorldSceneScrollerEvents.SCROLLED_TO_LEFT or event.name == WorldSceneScrollerEvents.SCROLLED_TO_RIGHT)
	assert(#{...} == 0)

	self:checkInteractionStateChange()
end

function WorldScene:onScrolledToOrigin(event, ...)
	assert(event)
	assert(event.name == WorldSceneScrollerEvents.SCROLLED_TO_ORIGIN)
	assert(#{...} == 0)

	assert(self.currentStayBranchIndex)
	self.currentStayBranchIndex = false

	self:checkInteractionStateChange()
	GameGuide:sharedInstance():tryStartGuide()
end

-- check interaction controller state change 
function WorldScene:checkInteractionStateChange( )
	if self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_LEFT or  
		self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_RIGHT 
		then
		self:setInteractionController(self.branchInteractionController)
	elseif self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_ORIGIN then
		self:setInteractionController(self.trunkInteractionController)
	end
end

function WorldScene:setInteractionController(targetController)
	if self.currentController ~= targetController then
		if self.currentController then
			self.currentController:unregister()
		end
		self.currentController = targetController
		self.currentController:register()
	end
end

function WorldScene:setTouchEnabled(flag)
	if flag then
		Layer.setTouchEnabled(self, true, 1, true)
	else
		Layer.setTouchEnabled(self, false)
	end
end

function WorldScene:buildLockedCloudLayer(...)
	assert(#{...} == 0)

	-- Delay Create The Batch Node
	local batchNode = false

	-- Get Data
	local metaModel = MetaModel:sharedInstance()
	local levelAreaDataArray = metaModel:getLevelAreaDataArray()
	assert(levelAreaDataArray)

	local lockedCloudNumber = #levelAreaDataArray

	for index = 1,lockedCloudNumber do

		-- Get Locked Cloud Info
		local lockedCloudInfo = levelAreaDataArray[index]
		assert(lockedCloudInfo)
		assert(lockedCloudInfo.minLevel)
		assert(lockedCloudInfo.star)

		local lockedCloudLevel = tonumber(lockedCloudInfo.minLevel)
		local lockedCloudNeedStar = tonumber(lockedCloudInfo.star)

		-- Get Locked Cloud Position From Level Node
		local startLevelNode = self.levelToNode[lockedCloudLevel]

		-- If Has No Corresponding Node View Or
		-- Not Has A Star Limit
		-- Or Is Less Than The User's Current Top Level
		-- Then Not Create A Locked Cloud

		local usrCurTopLevel = UserManager.getInstance().user:getTopLevelId()
		assert(usrCurTopLevel)

		if startLevelNode ~= nil  and 
			lockedCloudNeedStar ~= 0 and 
			lockedCloudLevel > usrCurTopLevel then

			-- Delay Create The Batch Node
			if not batchNode then
				-- batchNode = Layer:create()
				local cloudSpriteFrame = Sprite:createWithSpriteFrameName("home_clouds0000")
				local texture = cloudSpriteFrame:getTexture()
				batchNode = SpriteBatchNode:createWithTexture(texture)
				cloudSpriteFrame:dispose()
			end

			-- ---------------------
			-- Create Locked Cloud
			-- --------------------
			local lockedCloudId = tonumber(levelAreaDataArray[index].id)
			local lockedCloud = LockedCloud:create(lockedCloudId, self.lockedCloudAnimLayer, batchNode.refCocosObj:getTexture())

			-- -----------------------
			-- Get Start Node Id And
			-- Set Position
			-- ----------------------
			local startNodeId = lockedCloud:getStartNodeId()
			local startNodePos = self.trunks:getFlowerPos(startNodeId)
			local lockedCloudSize = lockedCloud:getGroupBounds().size

			-- Center It Horizontal
			local deltaWidth = self.visibleSize.width - lockedCloudSize.width 
			local halfDeltaWidth = deltaWidth / 2
			lockedCloud:setPositionX(self.visibleOrigin.x + halfDeltaWidth)

			-- Set Pos Y
			local manualAdjust = -180

			lockedCloud:setPositionY(startNodePos.y + lockedCloudSize.height + manualAdjust) 

			table.insert(self.lockedClouds, lockedCloud)
			batchNode:addChild(lockedCloud)
		end
	end

	if batchNode then
		self.lockedCloudLayer:addChild(batchNode)
	end

	-- -----------------------
	-- Build Top Tree Cloud
	-- -----------------------
	local topestNormalNode = self.levelToNode[self.maxNormalLevelId]
	local cloud = TreeTopLockedCloud:create()
	local cloudSize = cloud:getGroupBounds().size
	cloud:setPositionY(topestNormalNode:getPositionY() + cloudSize.height)
	self.lockedCloudLayer:addChild(cloud)
	cloud:setToScreenCenterHorizontal()
	self.topAreaCloud = cloud

	self:refreshTopAreaCloudState()
end

function WorldScene:refreshTopAreaCloudState()
	if UserManager.getInstance().user:getTopLevelId() == self.maxNormalLevelId 
		and UserManager:getInstance():getUserScore(self.maxNormalLevelId) ~= nil
		and UserManager:getInstance():getUserScore(self.maxNormalLevelId).star > 0 then
		self.topAreaCloud:playAnim()
		return true
	end
	return false
end

function WorldScene:getLockedCloudById(lockedCloudId, ...)
	assert(type(lockedCloudId) == "number")
	assert(#{...} == 0)

	for index,v in pairs(self.lockedClouds) do

		if v.id == lockedCloudId then
			return v
		end
	end
end

function WorldScene:buildGradientBackground(...)
	assert(#{...} == 0)
	
	local background = self.parallaxLayer:getChildByName("background")
	assert(background)

	local winSize = CCDirector:sharedDirector():getWinSize()
	local size = background:getGroupBounds().size
	local posX = winSize.width / 2

	local spriteWidth = __use_small_res and 3 or 4
	local scaleX = (winSize.width + self:getHorizontalScrollRange() * self.gradientBackgroundParallaxRatio.x + 10) / spriteWidth
	self.gradientBackgroundLayer.childScaleX = scaleX

	if WorldSceneShowManager.getInstance().showType == 2 then
		local s1 = Sprite:createWithSpriteFrameName("home_color2.png")
		s1:setScaleX(scaleX)
		s1:setAnchorPoint(ccp(0.5, 0))
		s1:setPositionX(posX)
		self.gradientBackgroundLayer:addChild(s1)

		local s2 = Sprite:createWithSpriteFrameName("home_color1.png")
		s2:setScaleX(scaleX)
		s2:setAnchorPoint(ccp(0.5, 0))
		s2:setPositionX(posX)
		s2:setPositionY(s1:getContentSize().height)
		self.gradientBackgroundLayer:addChild(s2)
	elseif WorldSceneShowManager.getInstance().showType == 1 then
		local sprite = Sprite:createWithSpriteFrameName("home_color.png")
		sprite:setScaleX(scaleX)
		sprite:setAnchorPoint(ccp(0.5, 0))
		sprite:setPositionX(posX)
		sprite:setScaleY(2.5)
		sprite.name = "background"
		self.gradientBackgroundLayer:addChild(sprite)
	end

end

-- 主界面星星先关（春节用 已过期）
function WorldScene:buildStarLayer()
	local star1Layer = self.parallaxLayer:getChildByName("star1")
	if WorldSceneShowManager:getInstance():isInAcitivtyTime() then
		local groupBounds = star1Layer:getGroupBounds().size
		assert(star1Layer)
		math.randomseed(os.time())
		for i=1,80 do
			local star = star1Layer:getChildByName("star"..i)
			if star then 		
				local scale = star:getScaleX()
				local pos = star:getPosition()
				local alpha = math.random(5, 10)/10
				local realStar = Sprite:createWithSpriteFrameName("home_scene_star.png")
				realStar:setScale(scale)
				realStar:setPosition(ccp(pos.x,pos.y+groupBounds.height+200))
				realStar:setAlpha(alpha)
				self.star1Layer:addChild(realStar)
			end
		end
		star1Layer:removeFromParentAndCleanup(false)
	else
		star1Layer:removeFromParentAndCleanup(true)
	end
end

function WorldScene:buildcloudLayer1(...)
	assert(#{...} == 0)

	local cloudLayer1 = self.parallaxLayer:getChildByName("cloud1")
	assert(cloudLayer1)
	if WorldSceneShowManager.getInstance():getShowType() == 2 then
		for i=1, 4 do
			local cloud = cloudLayer1:getChildByName("cloud"..i)
			if i == 3 then 
				cloud:setAlpha(0.7)
			else
				cloud:setAlpha(0.5)
			end
		end
	end
	
	cloudLayer1:removeFromParentAndCleanup(false)
	self.cloudLayer1Layer:addChild(cloudLayer1)
end

function WorldScene:buildcloudLayer2(...)
	assert(#{...} == 0)

	local cloudLayer2 = self.parallaxLayer:getChildByName("cloud2")
	assert(cloudLayer2)
	if WorldSceneShowManager.getInstance():getShowType() == 2 then
		for i=1, 2 do
			local cloud = cloudLayer2:getChildByName("cloud"..i)
			cloud:setAlpha(0.7)
		end
	end

	cloudLayer2:removeFromParentAndCleanup(false)
	self.cloudLayer2:addChild(cloudLayer2)
end

function WorldScene:buildForegroundLayer(...)
	assert(#{...} == 0)
	
	local foreground = self.parallaxLayer:getChildByName("foreground")
	foreground:removeFromParentAndCleanup(false)

	self.foregroundLayer:addChild(foreground)
end

function WorldScene:buildFriendPicture(...)
	assert(#{...} == 0)

	print("WorldScene:buildFriendPicture Called !")

	local friendIds = UserManager:getInstance().friendIds
	local friends = FriendManager.getInstance().friends

	-- 当自己的头像 和 被点击的 friend stack 处在同一关的时候。
	-- friend stack 展开和收缩的时候，自己头像上的 “你” 的字样要 相应的消失和展现
	local function onFriendPicStackStateChange(friendPicStack, newState, ...)
		assert(type(friendPicStack) == "table")
		checkFriendPicStackState(newState)
		assert(#{...} == 0)

		local friendPicStackLevelId = friendPicStack:getLevelId()
		local topLevel = UserManager:getInstance().user:getTopLevelId()

		if topLevel == friendPicStackLevelId then
			
			if newState == FriendPicStackState.FRIEND_PIC_SHOW_STATE_EXPANDED then
				if self.userIcon then
					self.userIcon:setLabelVisible(false)
				end
			elseif newState == FriendPicStackState.FRIEND_PIC_SHOW_STATE_HIDEED then
				if self.userIcon then
					self.userIcon:setLabelVisible(true)
				end
			end
		end
	end

	----------------------------------
	-- Set The Friend Stack Clean Flag
	------------------------------------
	for k,v in pairs(self.levelFriendPicStacksByLevelId) do
		v:setFriendPicsCleanFlag()
	end

	for k,v in pairs(friendIds) do
		assert(type(v) == "string")
		assert(friends[v])

		local friendLevel = false
		local levelNode = false

		if friends[v] then
			friendLevel = friends[v].topLevelId
		end
		--assert(type(friendLevel) == "number")

		if friendLevel then
			levelNode = self.levelToNode[friendLevel]
		end

		if levelNode then

			if not self.levelFriendPicStacksByLevelId[friendLevel] then

				local friendPicStack = FriendPicStack:create(friendLevel, self.userIcon)
				friendPicStack:setExpanHideCallback(onFriendPicStackStateChange)

				self.levelFriendPicStacksByLevelId[friendLevel] = friendPicStack
				table.insert(self.levelFriendPicStacks, {stack = friendPicStack, levelId = friendLevel})

				local nodePos = levelNode:getPosition()

				local manualAdjustPosY = self.userIconDeltaPosY + 10
				friendPicStack:setPosition(ccp(nodePos.x-2, nodePos.y + manualAdjustPosY))
				self.friendPictureLayer:addChild(friendPicStack)
				WorldMapOptimizer:getInstance():buildCache(friendPicStack , 2)
				if __WP8 and self.visibleSize and self.visibleOrigin and self.maskedLayer then
					local childPositionY = self.maskedLayer:getPositionY() + friendPicStack:getPositionY()
					local canShow = childPositionY > self.visibleOrigin.y and childPositionY < self.visibleOrigin.y + self.visibleSize.height
					if canShow and not friendPicStack:isVisible() then
						friendPicStack:setVisible(true)
					elseif not canShow and friendPicStack:isVisible() then
						friendPicStack:setVisible(false)
					end
				end
			end

			self.levelFriendPicStacksByLevelId[friendLevel]:addFriendId(tonumber(friends[v].uid))
		end
	end


	---------------------------
	-- Clean Friend Stack By Clean Flag
	-- -----------------------------

	for k,v in pairs(self.levelFriendPicStacksByLevelId) do
		v:cleanFriendPicsBasedOnCleanFlag()
	end

	-- --------------------------------
	-- Sort FriendPicStack's By Level Id
	-- --------------------------------
	local function sortByLevelId(para1, para2)

		if para1.levelId < para2.levelId then
			return true
		end

		return false
	end

	table.sort(self.levelFriendPicStacks, sortByLevelId)

	for index = #self.levelFriendPicStacks,1,-1 do
	--for index = 1,#self.
		self.levelFriendPicStacks[index].stack:removeFromParentAndCleanup(false)
		self.friendPictureLayer:addChild(self.levelFriendPicStacks[index].stack)
	end


	----------------------------
	-- Set User Picture To Top
	-- -----------------------
	local userIconParent = self.userIcon:getParent()
	self.userIcon:removeFromParentAndCleanup(false)
	userIconParent:addChild(self.userIcon)
end


function WorldScene:buildCloudLayer(...)
	assert(#{...} == 0)

	local cloudLayer3 = self.parallaxLayer:getChildByName("cloud3")
	assert(cloudLayer3)
	if WorldSceneShowManager.getInstance():getShowType() == 2 then
		for i=1, 3 do
			local cloud = cloudLayer3:getChildByName("cloud"..i)
			cloud:setAlpha(0.9)
		end
	end

	cloudLayer3:removeFromParentAndCleanup(false)
	self.cloudContainer:addChild(cloudLayer3)
end

function WorldScene:buildTreeContainer(...)
	assert(#{...} == 0)

	local numNormalLevel = MetaManager.getInstance():getMaxNormalLevelByLevelArea()
	local trunks = Trunks:create(numNormalLevel)
	self.trunks = trunks

	--self.trunks:setVisible(false)
	self.treeContainer:addChild(trunks)
end

function WorldScene:buildHiddenBranch(...)
	assert(#{...} == 0)
	
	local metaModel = MetaModel:sharedInstance()
	local branchList = metaModel:getHiddenBranchDataList()
	for index = 1, #branchList do
		if metaModel:isHiddenBranchCanOpen(index) then
			local branch = HiddenBranch:create(index, true, self.hiddenBranchLayer.refCocosObj:getTexture())
			self.hiddenBranchArray[index] = branch
			self.hiddenBranchLayer:addChild(branch)
			metaModel:markHiddenBranchOpen(index)

			local function onHiddenBranchTapped(event)
				self:onHiddenBranchTapped(event)
			end

			branch:addEventListener(DisplayEvents.kTouchTap, onHiddenBranchTapped, index)
		end
	end
end

function WorldScene:buildNodeView(...)
	assert(#{...} == 0)

	self.maxNormalLevelId = MetaManager.getInstance():getMaxNormalLevelByLevelArea()
	for normalLevelId = 1, self.maxNormalLevelId do
		self:buildNormalNode(normalLevelId)
	end

	local hiddenLevelIdList = MetaManager.getInstance():getHideAreaLevelIds()
	for i, hiddenLevelId in ipairs(hiddenLevelIdList) do
		self:buildHiddenNode(hiddenLevelId)
	end
end

function WorldScene:buildNormalNode(levelId)
	local userTopLevelId = tonumber(UserManager.getInstance().user:getTopLevelId())
	if userTopLevelId == nil or userTopLevelId < 1 then userTopLevelId = 1 end

	local nodeView

	local id = levelId
	if not LevelType:isMainLevel(levelId) then return end

	nodeView = WorldMapNodeView:create(true, id, self.playFlowerAnimLayer, self.flowerLevelNumberBatchLayer, self.treeNodeLayer.refCocosObj:getTexture())

	self.levelToNode[id] = nodeView

	local pos = self.trunks:getFlowerPos(tonumber(levelId))
	nodeView:setPositionXY(pos.x, pos.y)

	if id <= userTopLevelId then
		local curLevelScore = UserManager.getInstance():getUserScore(id)
		if curLevelScore and curLevelScore.star > 0 then
			nodeView:setStar(curLevelScore.star, false, false, false)
		else
			nodeView:setStar(0, false, false, false)
		end
	end

	if nodeView then
		self.treeNodeLayer:addChild(nodeView)
		nodeView:updateView(false, false)
		WorldMapOptimizer:getInstance():buildCache(nodeView , 1)

		local context_self_nodeview = self
		local function onNodeViewTapped_inner(event)
			context_self_nodeview:onNodeViewTapped(event)
		end

		local function onLevelCanPlay(event, ...)
			assert(event)
			assert(event.name == WorldMapNodeViewEvents.FLOWER_OPENED_WITH_NO_STAR)
			assert(event.data)
			assert(#{...} == 0)

			local levelId = event.data
			local node = self.levelToNode[levelId]
			if node then
				node:addEventListener(DisplayEvents.kTouchTap, onNodeViewTapped_inner, node)
			end
		end

		local function onGetNewStarLevel(event)
			self:onGetNewStarLevel(event)
		end

		nodeView:addEventListener(WorldMapNodeViewEvents.FLOWER_OPENED_WITH_NO_STAR, onLevelCanPlay)
		nodeView:addEventListener(WorldMapNodeViewEvents.OPENED_WITH_NEW_STAR, onGetNewStarLevel)
		
		if id <= userTopLevelId then
			nodeView:addEventListener(DisplayEvents.kTouchTap, onNodeViewTapped_inner, nodeView)
		end
	end
end

function WorldScene:buildHiddenNode(levelId)
	local nodeView
	local id = levelId
	if not LevelType:isHideLevel(levelId) then return end

	local hiddenLevelScore = UserManager.getInstance():getUserScore(id)
	local preHiddenLevelScore = UserManager.getInstance():getUserScore(id - 1)

	local hiddenBranchId = MetaModel:sharedInstance():getHiddenBranchIdByHiddenLevelId(id)
	assert(hiddenBranchId)

	local isFirstFlowerInHiddenBranch = false
	local hiddenBranchData = MetaModel:sharedInstance():getHiddenBranchDataByHiddenLevelId(id)
	assert(hiddenBranchData)
	if hiddenBranchData.startHiddenLevel == id then
		isFirstFlowerInHiddenBranch = true
	end

	local hiddenBranchCanOpen = MetaModel:sharedInstance():isHiddenBranchCanOpen(hiddenBranchId)
	if hiddenBranchCanOpen then
		if isFirstFlowerInHiddenBranch or (preHiddenLevelScore and preHiddenLevelScore.star > 0) then
			nodeView = WorldMapNodeView:create(false, id, self.playFlowerAnimLayer, self.flowerLevelNumberBatchLayer, self.treeNodeLayer.refCocosObj:getTexture())
			self.levelToNode[id] = nodeView

			local indexInBranch = id - hiddenBranchData.startHiddenLevel + 1
			local posX = 0
			local posY = 0
			local rightBranchOffsetX = {150, 300, 450}
			local rightBranchOffsetY = {80, 150, 160}
			local leftBranchOffsetX = {-150, -300, -450}
			local leftBranchOffsetY = {80, 150, 160}
			if hiddenBranchData.type == "1" then
				posX = hiddenBranchData.x + rightBranchOffsetX[indexInBranch]
				posY = hiddenBranchData.y + rightBranchOffsetY[indexInBranch]
			elseif hiddenBranchData.type == "2" then
				posX = hiddenBranchData.x + leftBranchOffsetX[indexInBranch]
				posY = hiddenBranchData.y + leftBranchOffsetY[indexInBranch]
			end
			nodeView:setPosition(ccp(posX, posY))

			-- Init Hidden Node View Star State
			if hiddenLevelScore and hiddenLevelScore.star > 0 then
				nodeView:setStar(hiddenLevelScore.star, false, false, false)
			else
				-- Is The Top Hidden Level
				nodeView:setStar(0, false, false, false)
			end
		end
	end

	if nodeView then
		self.treeNodeLayer:addChild(nodeView)
		nodeView:updateView(false, false)

		-- --------------------
		-- Add Event Listener
		-- ---------------------
		local context = self
		local function onNodeViewTapped_inner(event)
			context:onNodeViewTapped(event)
		end

		local function onGetNewStarLevel(event)
			context:onGetNewStarLevel(event)
		end

		nodeView:addEventListener(WorldMapNodeViewEvents.OPENED_WITH_NEW_STAR, onGetNewStarLevel)
		nodeView:addEventListener(DisplayEvents.kTouchTap, onNodeViewTapped_inner, nodeView)

		return nodeView
	end
end

----------------------------------------------------------
------- Event Listener About Data Change
--------------------------------------------------------

function WorldScene:onLevelPassed(gameResult)
	assert(gameResult, "gameResult cannot be nil")
	self.levelPassedInfo = nil
	if gameResult then
		if gameResult.levelType == GameLevelType.kMainLevel 
				or gameResult.levelType == GameLevelType.kHiddenLevel then
			self.levelPassedInfo = {
				passedLevelId = gameResult.levelId,
				rewardsIdAndPos = gameResult.rewardsIdAndPos,
				isPlayNextLevel = gameResult.isPlayNextLevel,
			}

			self:updateLevelData()
		elseif gameResult.levelType == GameLevelType.kTaskForRecall then
			self:recallTaskLevelUnlock()
			self.homeScene:updateCoin()
		elseif gameResult.levelType == GameLevelType.kTaskForUnlockArea then 
			self:unlockAreaByTask(gameResult.levelId)
			self.homeScene:updateCoin()
		else -- 其他关卡结束后需要更新银币数量
			self.homeScene:updateCoin()
		end
	end
end

function WorldScene:unlockAreaByTask( levelId )
	-- body
	local areaId = MetaManager:getInstance():getAreaIdByTaskLevelId(levelId)
	local function onSendUnlockMsgSuccess( ... )
				-- body
		local user =  UserService:getInstance().user
		local minLevelId = user:getTopLevelId() + 1
		user:setTopLevelId(minLevelId)
		local lockedClouds = HomeScene:sharedInstance().worldScene.lockedClouds
		for k, v in pairs(lockedClouds) do 
			if v.id == areaId then
				v:unlockCloud()
			end
		end

		if NetworkConfig.writeLocalDataStorage then 
	        Localhost:getInstance():flushCurrentUserData() 
	    end
	end
	local logic = UnlockLevelAreaLogic:create(areaId)
	logic:setOnSuccessCallback(onSendUnlockMsgSuccess)
	logic:start(UnlockLevelAreaLogicUnlockType.USE_UNLOCK_AREA_LEVEL, {})
end

function WorldScene:recallTaskLevelUnlock()
	local lockedCloudId = RecallManager.getInstance():getNeedUnlockAreaId()

	if not lockedCloudId then
		print("recallTaskLevelUnlock *** lockedCloudId is not exist !!!") 
		return 
	end 

	local function onSendUnlockMsgSuccess(event) 
		print("recallTaskLevelUnlock *** onSendUnlockMsgSuccess Called !")

		local function onOpeningAnimFinished()
			local runningScene = HomeScene:sharedInstance()
			runningScene:checkDataChange()
			runningScene.starButton:updateView()
			runningScene.goldButton:updateView()
			runningScene.worldScene:onAreaUnlocked(lockedCloudId)
		end
		local currentCloud = self:getLockedCloudById(lockedCloudId)
		if currentCloud then 
			currentCloud:removeAllEventListeners()
			currentCloud:changeState(LockedCloudState.OPENING, onOpeningAnimFinished)
			--解锁成功 重置下推送召回功能的流失状态
			RecallManager.getInstance():resetRecallRewardState()
		end
	end

	local function onSendUnlockMsgFailed(event)
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative")
	end

	local function onSendUnlockMsgCanceled(event)
		print("recallTaskLevelUnlock *** onSendUnlockMsgCanceled Called !")
	end

	local logic = UnlockLevelAreaLogic:create(lockedCloudId)
	logic:setOnSuccessCallback(onSendUnlockMsgSuccess)
	logic:setOnFailCallback(onSendUnlockMsgFailed)
	logic:setOnCancelCallback(onSendUnlockMsgCanceled)
	logic:start(UnlockLevelAreaLogicUnlockType.USE_TASK_LEVEL, {})	
end

function WorldScene:onTopLevelChange( topLevelId )
	-- self.topLevelId = topLevelId
	print("dispatchEvent USERMANAGER_TOP_LEVEL_ID_CHANGE")
	self.homeScene:dispatchEvent(Event.new(HomeSceneEvents.USERMANAGER_TOP_LEVEL_ID_CHANGE))
end

function WorldScene:updateLevelData( ... )
	-- Check  topLevelId
	local newTopLevelId = UserManager.getInstance().user:getTopLevelId()
	if self.topLevelId ~= newTopLevelId then
		self.topLevelId = newTopLevelId
		GamePlayEvents.dispatchTopLevelChangeEvent(newTopLevelId)
	end

	local newLevelAreaOpenedId = UserManager.getInstance().levelAreaOpenedId
	if self.levelAreaOpenedId ~= newLevelAreaOpenedId then
		self.levelAreaOpenedId = newLevelAreaOpenedId
		GamePlayEvents.dispatchAreaOpenIdChangeEvent(newLevelAreaOpenedId)
	end
end

function WorldScene:onAreaUnlocked( areaId )
	self:updateLevelData()
	self:updateUserIconPos(false)
end

function WorldScene:onAreaOpenIdChange( areaId )
	print(">>>> WorldScene:onAreaOpenIdChange")

	local lockedCloudToControl = self:getLockedCloudById(areaId)
	assert(lockedCloudToControl)
	if lockedCloudToControl and not lockedCloudToControl.isDisposed then
		lockedCloudToControl:changeState(LockedCloudState.WAIT_TO_OPEN, false)
	end

	self:dispatchEvent(Event.new(HomeSceneEvents.USERMANAGER_LEVEL_AREA_OPENED_ID_CHANGE, areaId))
end

-- function WorldScene.onTopLevelChange(event, ...)
-- 	assert(event)
-- 	assert(event.name == HomeSceneEvents.USERMANAGER_TOP_LEVEL_ID_CHANGE)
-- 	assert(event.context)
-- 	assert(#{...} == 0)

-- 	local self = event.context
-- end

function WorldScene:updateUserIconPos(finishCallback, ...)
	assert(#{...} == 0)

	print("WorldScene:updateUserIconPos Called !")
	if self.userIconLevelId ~= self.topLevelId then
		self.userIconLevelId = self.topLevelId

		local topLevelNode = self.levelToNode[self.topLevelId]
		assert(topLevelNode)
		
		-- Set Top Level Open
		local function setTopLevelNodeStarWrapper(callback)
			if topLevelNode:getStar() < 1 then
				topLevelNode:setStar(0, true, true, callback)
			else
				callback()
			end
		end

		-- ----------------------------------
		-- Move User Icon To Top Level Node
		-- ----------------------------------
		local function moveUserIconToNodeWrapper()
			self:moveUserIconToNode(self.topLevelId, finishCallback)
		end

		local chain = CallbackChain:create()
		chain:appendFunc(setTopLevelNodeStarWrapper)
		chain:appendFunc(moveUserIconToNodeWrapper)
		chain:call()
	end
end

function WorldScene.onLevelAreaOpenedIdChange(event, ...)
	assert(event)
	assert(event.name == HomeSceneEvents.USERMANAGER_LEVEL_AREA_OPENED_ID_CHANGE)
	assert(type(event.data) == "number")
	assert(event.context)
	assert(#{...} == 0)

	local self = event.context
	local levelAreaOpenedId = event.data

	local lockedCloudToControl = self:getLockedCloudById(levelAreaOpenedId)
	assert(lockedCloudToControl)
	if lockedCloudToControl and not lockedCloudToControl.isDisposed then
		lockedCloudToControl:changeState(LockedCloudState.WAIT_TO_OPEN, false)
	end
end

----------------------------------------------------------
------ 		Node View Event Listener
----------------------------------------------------------

function WorldScene:playLevelPassed(passedLevelId, rewardsIdAndPos, isPlayNextLevel, ...)
	assert(type(passedLevelId) 	== "number")
	assert(type(rewardsIdAndPos)	== "table")
	assert(type(isPlayNextLevel) 	== "boolean")
	assert(#{...} == 0)

	-- fix
	self:setTouchEnabled(true, 0, true)

	-- end fix

	print("WorldScene:levelPassedCallback Called !")

	self.homeScene:onLevelPassed(passedLevelId)

	-- Get Correspond Node View , And Star Level
	local node = self.levelToNode[passedLevelId]
	local oldStar = node:getStar()
	assert(oldStar >= 0)

	local function playRewardAnimation(callback)
		------------------------------
		-- Play The Reward Item Anim
		-- ---------------------------
		if not node or node.isDisposed then return end
		local pos = node:getAnimationCenter()
		local parent = node:getParent()
		pos = parent:convertToWorldSpace(ccp(pos.x, pos.y))
		local itemTable = {}
		for k, v in pairs(rewardsIdAndPos) do
			if v.itemId == ItemType.COIN then
				local function onFinish()
					local scene = HomeScene:sharedInstance()
					if not scene or scene.isDisposed then return end
					scene:checkDataChange()
					local button = scene.coinButton
					if not button or button.isDisposed then return end
					button:updateView()
				end
				HomeSceneFlyToAnimation:sharedInstance():levelNodeCoinAnimation(pos, onFinish)
			elseif v.itemId == ItemType.ENERGY_LIGHTNING then
				local function onFinish()
					local scene = HomeScene:sharedInstance()
					if not scene or scene.isDisposed then return end
					scene:checkDataChange()
					local button = scene.energyButton
					if not button or button.isDisposed then return end
					button:updateView()
				end
				HomeSceneFlyToAnimation:sharedInstance():levelNodeEnergyAnimation(pos, onFinish)
			else
				table.insert(itemTable, v.itemId)
			end
		end
		if #itemTable > 0 then 
			HomeSceneFlyToAnimation:sharedInstance():levelNodeJumpToBagAnimation(itemTable, pos, callback)
		else 
			if callback and type(callback) == "function" then callback() end
		end
	end

	-- Get New Star
	local levelScoreRef = UserManager:getInstance():getUserScore(passedLevelId)
	--assert(levelScoreRef)

	if levelScoreRef then
		local newStar = levelScoreRef.star

		-- Update Node's Star Level
		local function updateNodeViewStar(callback)
			if newStar > oldStar then
				--function WorldMapNodeView:setStar(star, updateView, playAnimInLogic, animFinishCallback, ...)
				node:setStar(newStar, true, true, callback)
			else
				node:playParticle()
				callback()
			end
		end

		-- Check If User's Top Level Is Changed
		local function checkTopLevelChange()
			-- open start panel as anim finished while no window nor ladybug anim on screen
			local function onUserIconMoveAnimFinished()
				if not self.isUnlockingHiddenBranch then 
					self:startLevel(UserManager:getInstance().user:getTopLevelId())
				end
			end

			self.homeScene:checkDataChange()
			if isPlayNextLevel then self:updateUserIconPos(onUserIconMoveAnimFinished)
			else self:updateUserIconPos(false) end
			self:refreshTopAreaCloudState()
		end

		local chain = CallbackChain:create()
		chain:appendFunc(updateNodeViewStar)
		chain:appendFunc(playRewardAnimation)
		chain:appendFunc(checkTopLevelChange)
		chain:call()
	else
		-- Note: Passed Level Has No Score, This Condition May Occur When Sync The Data With Server.
		-- Specific Reason To Cause This Problem, Is Not Clear.

		-- Check If User's Top Level Is Changed
		self.homeScene:checkDataChange()
		self:updateUserIconPos(false)
		playRewardAnimation()
	end
end

function WorldScene:startLevel(levelId)
	print("[INFO] WorldScene:startLevel:", levelId)
	if not PopoutManager:sharedInstance():haveWindowOnScreen()
			and not HomeScene:sharedInstance().ladyBugOnScreen then
		local levelType = LevelType:getLevelTypeByLevelId(levelId)
		local startGamePanel = StartGamePanel:create(levelId, levelType)
		startGamePanel:popout(false)
	end
end

function WorldScene:onNodeViewTapped(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchTap)
	assert(event.context)
	assert(#{...} == 0)

	local nodeView = event.context
	local levelId = nodeView:getLevelId()

	-- ------------------------
	-- Create Start Game Panel
	-- ------------------------
	print("WorldSceneScroller:onNodeViewTapped  "..levelId);

	self:startLevel(levelId)

	print("WorldSceneScroller:onNodeViewTapped end")
end

function WorldScene:moveTopLevelNodeToCenter( animFinishCallback )

	if not animFinishCallback then animFinishCallback = false end
	-- body
	if self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_LEFT or
			self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_RIGHT then
		self:scrollToOrigin()
	end
	self:moveNodeToCenter(self.topLevelId, animFinishCallback)
end

function WorldScene:moveCloudLockToCenter(cloudId, animFinishCallback)

	local actionArray = CCArray:create()
	local cloud
	for k,v in pairs(self.lockedClouds) do
		if v.id == cloudId then
			cloud = v
			break
		end
	end
	if not cloud then 
		if animFinishCallback then animFinishCallback() end
		return 
	end

	local targetNodePosInWorld = cloud:getParent():convertToWorldSpace(cloud:getPosition())

	local visibleOrigin = Director:sharedDirector():getVisibleOrigin()
	local visibleSize = Director:sharedDirector():getVisibleSize()

	
	local function onMoveToFinishedFunc()
		-- debug.debug()
		self:setScrollable(true)
		if animFinishCallback then animFinishCallback() end
		WorldMapOptimizer:getInstance():update()
	end

	print(visibleOrigin.y, visibleSize.height, targetNodePosInWorld.y)
	local deltaMoveDistance = (visibleOrigin.y + visibleSize.height / 2) - (targetNodePosInWorld.y - visibleOrigin.y) + cloud:getGroupBounds().size.height / 2
	local function initMoveMaskLayerFunc()
		self:setScrollable(false)
	end
	local initMoveMaskLayerAction = CCCallFunc:create(initMoveMaskLayerFunc)
	actionArray:addObject(initMoveMaskLayerAction)
	-- delay for 0.1 sec to avoid parallax node error
	actionArray:addObject(CCDelayTime:create(0.1))
	actionArray:addObject(CCMoveBy:create(1.5, ccp(0, deltaMoveDistance)))


	---------------
	-- Move To Finished
	-- --------------

	local onMoveToFinishedAction = CCCallFunc:create(onMoveToFinishedFunc)
	actionArray:addObject(onMoveToFinishedAction)
	local seq = CCSequence:create(actionArray)
	self.maskedLayer:stopAllActions()
	self.maskedLayer:runAction(seq)

end

function WorldScene:moveNodeToCenter(levelId, animFinishCallback, ...)
	if PublishActUtil:isGroundPublish() then 
		return
	end
	print("WorldScene:moveNodeToCenter")
	-- debug.debug()
	assert(type(levelId) == "number")
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	local node = self.levelToNode[levelId]
	assert(node)

	local nodePosition = node:getPosition()
	local actionArray = CCArray:create()

	local nodeParent = node:getParent()
	local targetNodePosInWorld = nodeParent:convertToWorldSpace(ccp(nodePosition.x, nodePosition.y))

	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()

	he_log_warning("need adapt the screen resolution ?? ")
	local distanceToVisibleTopTriggerTrunkMove = visibleSize.height * 0.3
	-- local distanceToVisibleTopTrunkMoveTo = visibleSize.height * 0.5
	
	local function onMoveToFinishedFunc()
		-- debug.debug()
		self:setScrollable(true)
		if animFinishCallback then animFinishCallback() end
		WorldMapOptimizer:getInstance():update()
	end

	if targetNodePosInWorld.y > visibleOrigin.y + visibleSize.height - distanceToVisibleTopTriggerTrunkMove or targetNodePosInWorld.y < visibleOrigin.y + distanceToVisibleTopTriggerTrunkMove then

		local deltaMoveDistance = (visibleOrigin.y + visibleSize.height - distanceToVisibleTopTriggerTrunkMove) - targetNodePosInWorld.y
		if targetNodePosInWorld.y < visibleOrigin.y + distanceToVisibleTopTriggerTrunkMove then
			deltaMoveDistance = visibleOrigin.y + distanceToVisibleTopTriggerTrunkMove - targetNodePosInWorld.y
		end

		-- ------------
		-- Init Action
		-- -----------
		local function initMoveMaskLayerFunc()
			self:setScrollable(false)
		end
		local initMoveMaskLayerAction = CCCallFunc:create(initMoveMaskLayerFunc)
		actionArray:addObject(initMoveMaskLayerAction)
		-- delay for 0.1 sec to avoid parallax node error
		actionArray:addObject(CCDelayTime:create(0.1))

		-- ----------
		-- Move To
		-- -----------

		if not self.isUnlockingHiddenBranch then
			actionArray:addObject(CCMoveBy:create(0.8, ccp(0, deltaMoveDistance)))
		end

		---------------
		-- Move To Finished
		-- --------------

		local onMoveToFinishedAction = CCCallFunc:create(onMoveToFinishedFunc)
		actionArray:addObject(onMoveToFinishedAction)
		local seq = CCSequence:create(actionArray)
		self.maskedLayer:stopAllActions()
		self.maskedLayer:runAction(seq)
	else
		-- if animFinishCallback then animFinishCallback() end
		self.maskedLayer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(onMoveToFinishedFunc)))
	end
end

function WorldScene:moveUserIconToNode(levelId, animFinishCallback, ...)
	assert(type(levelId) == "number")
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	print("WorldScene:moveUserIconToNode Called !")
	print("levelId: " .. levelId)

	local node = self.levelToNode[levelId]
	assert(node)

	local nodePosition = node:getPosition()
	local targetPos = ccp(nodePosition.x, nodePosition.y + self.userIconDeltaPosY)
	local curPos = self.userIcon:getPosition()
	local distance = ccpDistance(targetPos, curPos)
	local time = distance / self.userIconMovingSpeed

	if time > 2 then
		time = 2
	end

	------------------------------
	-- Block User Scroll THe Trunk 
	-- ------------------------------

	local actionArray = CCArray:create()

	-------------------------------
	-- Move THe Trunk If The Target Pos Is High
	-- ---------------------------------------
	-- Convert Target Node Pos To World Scene
	local nodeParent = node:getParent()
	local targetNodePosInWorld = nodeParent:convertToWorldSpace(ccp(nodePosition.x, nodePosition.y))

	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()

	he_log_warning("need adapt the screen resolution ?? ")
	local distanceToVisibleTopTriggerTrunkMove = 200
	local distanceToVisibleTopTrunkMoveTo = 500

	if targetNodePosInWorld.y > visibleOrigin.y + visibleSize.height - distanceToVisibleTopTriggerTrunkMove then

		local deltaMoveDistance = (visibleOrigin.y + visibleSize.height - distanceToVisibleTopTrunkMoveTo) - targetNodePosInWorld.y

		-- ------------
		-- Init Action
		-- -----------
		local function initMoveMaskLayerFunc()
			self:setScrollable(false)
		end
		local initMoveMaskLayerAction = CCCallFunc:create(initMoveMaskLayerFunc)
		actionArray:addObject(initMoveMaskLayerAction)

		-- ----------
		-- Move To
		-- -----------

		if not self.isUnlockingHiddenBranch then
			self.maskedLayer.moving = true
			local moveBy = CCMoveBy:create(time, ccp(0, deltaMoveDistance))
			local targetMoveBy = CCTargetedAction:create(self.maskedLayer.refCocosObj, moveBy)
			actionArray:addObject(targetMoveBy)
		end

		---------------
		-- Move To Finished
		-- --------------
		local function onMoveToFinishedFunc()
			self:setScrollable(true)
			self.maskedLayer.moving = nil
			WorldMapOptimizer:getInstance():update()
		end
		local onMoveToFinishedAction = CCCallFunc:create(onMoveToFinishedFunc)
		actionArray:addObject(onMoveToFinishedAction)
	end

	-------------------
	-- Move User Icon
	-- ----------------

	-- Set User Icon To Top
	local userIconParent = self.userIcon:getParent()
	self.userIcon:removeFromParentAndCleanup(false)
	userIconParent:addChild(self.userIcon)
	
	-- Move To
	local moveToAction = CCMoveTo:create(time, targetPos)
	local targetMoveToAction = CCTargetedAction:create(self.userIcon.refCocosObj, moveToAction)
	actionArray:addObject(targetMoveToAction)

	-- Callback
	local function animFinish()
		if animFinishCallback then
			animFinishCallback()
		end
		PrepackageUtil:LevelUpShowTipToNetWork()
		WorldMapOptimizer:getInstance():update()
	end
	local animFinishAction = CCCallFunc:create(animFinish)
	actionArray:addObject(animFinishAction)

	-- Seq
	local seq = CCSequence:create(actionArray)
	---- Seq 
	--local seq = CCSequence:createWithTwoActions(moveToAction, animFinishAction)

	self.userIcon:runAction(seq)

end

function WorldScene:onGetNewStarLevel(event, ...)
	assert(event)
	assert(event.name == WorldMapNodeViewEvents.OPENED_WITH_NEW_STAR)
	assert(event.data)
	assert(#{...} == 0)

	local changedLevelId = event.data
	local branchDataList = MetaModel:sharedInstance():getHiddenBranchDataList()

	local function unlockHiddenBranch(branchId)
		-- If Exist A Hidden Branch Based On This Normal Level
		if branchId then
			if not self.hiddenBranchArray[branchId] or WorldSceneShowManager.getInstance():getHideBranchOpenFlag() then
				WorldSceneShowManager.getInstance():setHideBranchOpenFlag(false)
				-- Check If This Hidden Branch Can Open
				if MetaModel:sharedInstance():isHiddenBranchCanOpen(branchId) then
					local function onHiddenBranchTapped(event)
						self:onHiddenBranchTapped(event)
					end

					local function createNewBranch()

						if GameGuide then GameGuide:sharedInstance():forceStopGuide() end
						local newBranch = HiddenBranch:create(branchId, false, self.hiddenBranchLayer.refCocosObj:getTexture())
						self.hiddenBranchArray[branchId] = newBranch
						self.hiddenBranchLayer:addChild(newBranch)
						MetaModel:sharedInstance():markHiddenBranchOpen(branchId)

						newBranch:addEventListener(HiddenBranchEvent.OPEN_ANIM_FINISHED, self.onHiddenBranchOpenAnimFinished, self)
						newBranch:addEventListener(DisplayEvents.kTouchTap, onHiddenBranchTapped, branchId)
						newBranch:playOpenAnim(self.hiddenBranchAnimLayer)
					end

					local curBranchData = branchDataList[branchId]

					local function onVerticalScrollComplete()
						self.currentStayBranchIndex = branchId
						if tonumber(curBranchData.type) == 1 then
							self:scrollToRight()
						elseif tonumber(curBranchData.type) == 2 then
							self:scrollToLeft()
						end

						self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(createNewBranch)))
					end

					self:setTouchEnabled(false)
					self.isUnlockingHiddenBranch = true

					local branchPos = self.hiddenBranchLayer:convertToWorldSpace(ccp(0, curBranchData.y))
					local branchPos = self.maskedLayer:convertToNodeSpace(branchPos)
					local targetY = branchPos.y + 200
					local function verticalScroll()
						self:verticalScrollTo(targetY, onVerticalScrollComplete)
					end

					if self.scrollHorizontalState ~= WorldSceneScrollerHorizontalState.STAY_IN_ORIGIN then
						self:scrollToOrigin()
						self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(verticalScroll)))
					else
						verticalScroll()
					end
					-- Cookie.getInstance():write(CookieKey.kUnlockHiddenArea, "true")
				end
			end
		end
	end

	if LevelType:isMainLevel(changedLevelId) then
		local branchId = MetaModel:sharedInstance():getHiddenBranchIdByNormalLevelId(changedLevelId)
		unlockHiddenBranch(branchId)
	elseif LevelType:isHideLevel(changedLevelId) then
		local hiddenBranchData = MetaModel:sharedInstance():getHiddenBranchDataByHiddenLevelId(changedLevelId)
		local endHiddenLevel = hiddenBranchData.endHiddenLevel
		local nextHiddenLevelOnSameBranch = changedLevelId + 1

		if changedLevelId < endHiddenLevel and not self.levelToNode[nextHiddenLevelOnSameBranch] then
			local nodeView = self:buildHiddenNode(nextHiddenLevelOnSameBranch)
		else
			local branchId = MetaModel:sharedInstance():getHiddenBranchIdByHiddenLevelId(changedLevelId)
			local dependedBranch = MetaModel:sharedInstance():getHiddenBranchIdByDependingBranch(branchId)
			unlockHiddenBranch(dependedBranch)
		end
	end
end

function WorldScene:showHiddenAreaIntroduction()
	local localRecord = Cookie.getInstance():read(CookieKey.kHiddenAreaIntroduction)
	if not localRecord then
		local panel = HiddenBranchIntroductionPanel:create()
		PopoutQueue:sharedInstance():push(panel)
	end
end

function WorldScene.onHiddenBranchOpenAnimFinished(event, ...)
	assert(event)
	assert(event.name == HiddenBranchEvent.OPEN_ANIM_FINISHED)
	assert(event.data)
	assert(event.context)
	assert(#{...} == 0)


	local self = event.context
	local branchId = event.data

	local branchDataList = self.metaModel:getHiddenBranchDataList()
	local curBranchData = branchDataList[branchId]
	
	local headHiddenLevel = curBranchData.startHiddenLevel

	local nodeView = self:buildHiddenNode(headHiddenLevel)

	self:setTouchEnabled(true)
	self.isUnlockingHiddenBranch = false
	self:showHiddenAreaIntroduction()

	local hiddenStar = 0
	for i = curBranchData.startHiddenLevel, curBranchData.endHiddenLevel do
		hiddenStar = hiddenStar + 3
	end
						
	HomeScene:sharedInstance().starButton:playChangeTotalStarAnim(hiddenStar)
end

function WorldScene:onHiddenBranchTapped(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchTap)
	assert(event.context)
	assert(#{...} == 0)

	-- Check Which ExploreCloud Clicked 
	local branchIndex = event.context
	self.currentStayBranchIndex = branchIndex
	local branch = self.hiddenBranchArray[branchIndex]

	-- If Not Scrolled Horizontal Yet
	-- Based On Selected Branch Direction 
	-- Scroll Horizontally Left Or Right
	if self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_ORIGIN then

		-- Check Branch Direction
		local direction = branch:getDirection()

		if direction == HiddenBranchDirection.LEFT then
			self:scrollToLeft()
		elseif direction == HiddenBranchDirection.RIGHT then
			self:scrollToRight()
		else
			assert(false)
		end
	elseif self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_RIGHT 
		or self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_LEFT then

		-- When Tapped In Already Scrolled To Left Or Right
		-- Scroll Back To The Origin Position
		self:scrollToOrigin()
	end
end

function WorldScene:playOnEnterCenterUserPosAnim(...)
	assert(#{...} == 0)

	---------------
	-- Get Config
	-- ------------
	local config = UIConfigManager:sharedInstance():getConfig()
	local linearVelocity = config.worldScene_velocity
	assert(linearVelocity)

	local topLevelBelowScreenCenter = config.worldScene_topLevelBelowScreenCenter
	assert(topLevelBelowScreenCenter)

	-- Get Usr Top Level Pos
	local topLevelId = UserManager.getInstance().user:getTopLevelId()
	local topLevelNode = self.levelToNode[topLevelId]
	assert(topLevelNode)
	if not topLevelNode then return end

	local curTopLevelNodePosY = topLevelNode:getPositionY()
	-- Convert Top Level Node's Pos TO World/Scene Space
	local topLevelNodeParent = topLevelNode:getParent()
	local curTopLevelNodePosYInWorldSpace = topLevelNodeParent:convertToWorldSpace(ccp(0, curTopLevelNodePosY))

	-- Get Screen Visible Rect
	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	-- Get Center Y In Screen
	local centerYInScreen = visibleOrigin.y * 2 + visibleSize.height / 2

	-- Ensure When User Has Top Level Id == 1, Not Scroll The Tree
	if curTopLevelNodePosYInWorldSpace.y < centerYInScreen + 200 then
		if __WP8 and self.checkFriendVisible then self:checkFriendVisible() end
		return
	end

	-- --------------------------------------
	-- Get The maskedLayer Pos Should Have
	-- -------------------------------------
	--local newMaskedLayerPosY = centerYInScreen - topLevelBelowScreenCenter - curTopLevelNodePosY
	local newMaskedLayerPosY = centerYInScreen - topLevelBelowScreenCenter - curTopLevelNodePosYInWorldSpace.y
	local newMaskedLayerPosX = self.maskedLayer:getPositionX()

	-- Check Whether newMaskedLayerPosY Out Of Range
	local whetherInRange = self:checkSceneOutRange(newMaskedLayerPosY)

	if whetherInRange == CheckSceneOutRangeConstant.IN_RANGE then
		-- Do Nothing
	elseif whetherInRange == CheckSceneOutRangeConstant.BOTTOM_OUT_OF_RANGE then
		newMaskedLayerPosY = self:getMinMaskedLayerY()
	elseif whetherInRange == CheckSceneOutRangeConstant.TOP_OUT_OF_RANGE then
		newMaskedLayerPosY = self:getMaxMaskedLayerY()
	else
		assert(false, "not possible !")
	end


	-- Move To Initial 
	local bottomPos = self:getMaxMaskedLayerY()
	self.maskedLayer:setPositionY(bottomPos)

	if initialMaskedLayerPosY ~= newMaskedLayerPosY then

		-- Disable Scrollable
		self:setScrollable(false)
		
		-- Move TO
		local startPosY = self.maskedLayer:getPositionY()
		local destPosY = newMaskedLayerPosY

		local max = self:getMinMaskedLayerY()
		local deltaLength = -(destPosY - startPosY)
		local percent = math.abs(deltaLength/max)
		local time = 12 * percent  --deltaLength / linearVelocity

		local minTime = 0.3
		if time > 1.8 then time = 1.8 end
		if time < minTime then time = minTime end

		local moveTo = CCMoveTo:create(time, ccp(newMaskedLayerPosX, newMaskedLayerPosY))
		local ease = moveTo
		if time <= minTime then
			ease = CCEaseSineOut:create(moveTo)
		elseif time > minTime and time < 0.65 then
			ease = CCEaseOut:create(moveTo, 2)
		else
			ease = CCEaseExponentialOut:create(moveTo)
		end

		-- Finish Callback
		local function animFinish()
			self:setScrollable(true)
			if __WP8 and self.checkFriendVisible then self:checkFriendVisible() end
			WorldMapOptimizer:getInstance():firstUpdate()
		end
		local moveToFinishCallback = CCCallFunc:create(animFinish)

		local array = CCArray:create()
		array:addObject(CCDelayTime:create(0.04))
		array:addObject(ease)
		array:addObject(moveToFinishCallback)
		self.maskedLayer:runAction(CCSequence:create(array))
	end
end

function WorldScene:create(homeScene, ...)
	assert(homeScene)
	assert(#{...} == 0)

	local newWorldScene = WorldScene.new()
	newWorldScene:init(homeScene)
	return newWorldScene
end

function WorldScene:sendFriendHttp(onSuccessCallback, ...)
	assert(false == onSuccessCallback or type(onSuccessCallback) == "function")
	assert(#{...} == 0)

	local function onGetFriendsIdEnd()
	
		local function onSuccess()
			self.lastGetFriendTime = Localhost:time()

			if onSuccessCallback then
				onSuccessCallback()
			end
		end

		local function onFailed(event)
			assert(event)
			assert(event.name == Events.kError)

			local err = event.data

			local errorMessage = "WorldScene:sendFriendHttp Failed !!\n"
			errorMessage = "errorMessage:" .. err
			-- assert(false, errorMessage)
		end

		---------------------------
		-- Second Refresh Friend Infos
		-- ---------------------------
		local http = FriendHttp.new()
		http:addEventListener(Events.kComplete, onSuccess)
		http:addEventListener(Events.kError, onFailed)

		local friendIds = UserManager:getInstance().friendIds
		
		http:load(true, friendIds)
	end

	-----------------------
	-- First Refresh Friend Ids
	-- -------------------------
	local function onUserLogin()
		if not __IOS_FB then -- facebook不走getFriends
			if (self.lastGetFriendTime or 0) + 30 * 60 * 1000 < Localhost:time() then
				local http = GetFriendsHttp.new()
				http:addEventListener(Events.kComplete, onGetFriendsIdEnd)
				http:addEventListener(Events.kError, onGetFriendsIdEnd)
				http:load()
			end
		end
	end
	RequireNetworkAlert:callFuncWithLogged(onUserLogin, nil, kRequireNetworkAlertAnimation.kNoAnimation)
end