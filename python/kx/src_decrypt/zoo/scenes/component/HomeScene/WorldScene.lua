
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
require "zoo.mission.panels.MissionTrunkLevelNodeBubble"


require "zoo.events.GamePlayEvents"

require "zoo.scenes.component.HomeScene.AnniversaryFloatButton"
--require "zoo.scenes.component.HomeScene.animation.AnniversaryTwoYearsAnimation"

---------------------------------------------------
-------------- WorldScene
---------------------------------------------------

assert(not WorldScene)
assert(WorldSceneScroller)
WorldScene = class(WorldSceneScroller)


local function buildPlane(context)
	--local backitemLayer = context.parallaxLayer:getChildByName("backitem")
	if WorldSceneShowManager:getInstance():isInAcitivtyTime() or true then

		local plane = Sprite:createWithSpriteFrameName("plane_0001")
		--star:setPositionX(-30)
		local plane_frames = SpriteUtil:buildFrames("plane_%04d", 1, 9)
		local plane_animate = SpriteUtil:buildAnimate(plane_frames, 1/24)
		plane:play(plane_animate, 0, 0, nil, false)
		context.planeAnimate = plane

		--context.backItemLayer:addChild(plane)
		local locationNode = context.levelToNode[UserManager:getInstance().user:getTopLevelId()]
		local posY = locationNode:getPositionY()
		--local ppp = buildPlane(self)
		plane:setPosition(ccp( 50 , posY ) )

		--plane:setPosition(ccp(200 , 200))
		--star1Layer:removeFromParentAndCleanup(false)

		return plane
	else
		--star1Layer:removeFromParentAndCleanup(true)
		return nil
	end
end



function WorldScene:init(homeScene, ...)
	assert(homeScene)
	assert(#{...} == 0)

	
	WorldSceneShowManager:getInstance()
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

	local backItemLayerParallax = config.worldScene_backItemParallax
	self.backItemLayerParallaxRatio = ccp(backItemLayerParallax, backItemLayerParallax)
	self.backItemLayer = Layer:create()
	self.maskedLayer:addParallaxChild(self.backItemLayer, 1, self.backItemLayerParallaxRatio, ccp(0,0))

	--------------2016春节星星----------------
	if WorldSceneShowManager:getInstance():isInAcitivtyTime() then 
		local star1Parallax = 0.007
		self.star1Parallax = ccp(star1Parallax, star1Parallax)
		local plistPath = "flash/scenes/homeScene/home_night/home_scene_star.plist"
		if __use_small_res then  
			plistPath = table.concat(plistPath:split("."),"@2x.")
		end
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
		local texture = CCSprite:createWithSpriteFrameName("home_scene_star.png"):getTexture()
		self.star1Layer = SpriteBatchNode:createWithTexture(texture)
		self.maskedLayer:addParallaxChild(self.star1Layer, 1, self.star1Parallax, ccp(0,0))
		if WorldSceneShowManager:getInstance():getShowType() == 2 then 
			self.star1Layer:setVisible(true)
		else
			self.star1Layer:setVisible(false)
		end
	end
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

	--------------2016春节烟花----------------
	if WorldSceneShowManager:getInstance():isInAcitivtyTime() then 
		local fireworkParallax = 0.001
		self.fireworkParallax = ccp(fireworkParallax, fireworkParallax)
		self.worldSceneFireworkLayer = SpringFireworkAnimation:create()
		self.maskedLayer:addParallaxChild(self.worldSceneFireworkLayer, 5, self.fireworkParallax, ccp(0,0))
	end
	------------------------------------------

	------------两周年活动浮空岛---------------
	self.floatIcons = {}
	local floatIconsLayer = Layer:create()
	self.floatIconsLayer = floatIconsLayer
	self.maskedLayer:addParallaxChild(floatIconsLayer, 5, ccp(1, 1), ccp(0, 0))
	-------------------------------------------

	-------------------------------
	--	Scale Small Layer 1
	-- --------------------------
	self.scaleTreeLayer1 = Layer:create()--藤蔓树（包含树干，分支树枝，关卡点，特效等）
	self.maskedLayer:addParallaxChild(self.scaleTreeLayer1, 6, ccp(1,1), ccp(0,0))

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
	self.treeNodeLayer = SpriteBatchNode:createWithTexture(texture)--关卡点所在的层
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
	self.scaleTreeLayer2 = Layer:create()--藤蔓树的同步上层（包含解锁云，解锁云动画，好友头像，引导等）
	self.maskedLayer:addParallaxChild(self.scaleTreeLayer2, 10, ccp(1,1), ccp(0,0))

	-- ------------------
	-- Locked Cloud Layer
	-- ------------------
	self.lockedCloudLayer = Layer:create()
	function self.lockedCloudLayer:getBatchNode( ... )
		if not self.batchNode then
			local cloudSpriteFrame = Sprite:createWithSpriteFrameName("home_clouds0000")
			local texture = cloudSpriteFrame:getTexture()
			self.batchNode = SpriteBatchNode:createWithTexture(texture)
			cloudSpriteFrame:dispose()

			self:addChild(self.batchNode)
		end

		return self.batchNode
	end

	-- 掩藏关卡显示 15-30关全3星开启 文案
	function self.lockedCloudLayer:getHiddenBranchTextBatchNode( ... )
		if not self.hiddenTextBatchNode then
			self.hiddenTextBatchNode = BMFontLabelBatch:create(
				"fnt/tutorial_white.png",
				"fnt/tutorial_white.fnt",
				10
			)
			self:addChild(self.hiddenTextBatchNode)
		end

		return self.hiddenTextBatchNode
	end

	function self.lockedCloudLayer:getHiddenBranchNumberBatchNode( ... )
		if not self.hiddenNumberBatchNode then
			self.hiddenNumberBatchNode = BMFontLabelBatch:create(
				"fnt/event_default_digits.png",
				"fnt/event_default_digits.fnt",
				10
			)
			self:addChild(self.hiddenNumberBatchNode)
		end

		return self.hiddenNumberBatchNode
	end
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

	----------------------
	-- Icon Button Layer
	-- ----------------------
	self.iconButtonLayer = Layer:create()
	self.scaleTreeLayer2:addChild(self.iconButtonLayer)

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


	local frontItemLayerParallax = config.worldScene_frontItemParallax
	self.frontItemLayerParallaxRatio = ccp(frontItemLayerParallax, frontItemLayerParallax)
	self.frontItemLayer = Layer:create()
	self.maskedLayer:addParallaxChild(self.frontItemLayer, 16, self.frontItemLayerParallaxRatio, ccp(0,0))

	--AnniversaryTwoYearsAnimation:init(self)
	-- ------------
	-- Init Layer
	-- ----------------
	WorldSceneShowManager:getInstance():changeCloudColor()
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
	self:buildBackItemLayer()
	self:buildFrontItemLayer()

	
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
	
	local function onSyncFinished(evt)
		print("WorldScene onSyncFinished Called !")
		if evt.data == SyncFinishReason.kRestoreData then
			self:onSyncFinished()
		end
	end

	GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kSyncFinished, onSyncFinished)

	-- ----------------------
	-- Register Script Handler
	-- ----------------------
	local function onEnterHandler(event)
		self:onEnterHandler(event)
	end
	self:registerScriptHandler(onEnterHandler)
	self.missionBubbles = {}

	-- 六一彩蛋
	EggsManager:showIfNecessary(self)
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
					self:playLevelPassed(self.levelPassedInfo.passedLevelId, self.levelPassedInfo.rewardsIdAndPos, self.levelPassedInfo.isPlayNextLevel, self.levelPassedInfo.jumpLevelPawn)
				else
					local node = self.levelToNode[levelId]
					print("node", node, levelId)
					if node and not node.isDisposed then node:playParticle() end
				end
				self.levelPassedInfo = nil
			end)
			if __IOS or __WIN32 then
				IosPayGuide:onSuccessiveLevelFailure(self.sourceLevelId)
			end
		end
		self.sourceLevelId = nil

		-- 设置完星星数需要解锁隐藏关
		if self.unlockHiddenBranchCloudBranchId then
			self:unlockHiddenBranchCloud(self.unlockHiddenBranchCloudBranchId)
			self.unlockHiddenBranchCloudBranchId = nil
		end

		self:updateAnniversaryFloatButton()
	end
end

function WorldScene:setIsTouched(isTouched)
	self.isTouched = isTouched
end

function WorldScene:onSyncFinished(...)
	assert(#{...} == 0)

	self:onSyncRefreshHiddenBranch()
	self:onSyncRefreshLevelNode()
	self:onSyncRefreshUnlockCloud()
	self:onSyncRefreshHomeSceneAndGuide()
end

function WorldScene:onSyncRefreshLevelNode()
	local metaModel = MetaModel:sharedInstance()
	local scores = UserManager:getInstance().scores
	local hiddenLevelIdList = MetaManager:getInstance():getHideAreaLevelIds()
	local waitToAddHiddenNodes = {}
	for i,v in ipairs(hiddenLevelIdList) do
		waitToAddHiddenNodes[v] = true
	end
	local shouldRemoveList = {}
	
	for k, v in pairs(self.levelToNode) do
		local levelId = v.levelId
		local ingredientCount = JumpLevelManager:getInstance():getLevelPawnNum(levelId) or 0
		local score = UserManager:getInstance():getUserScore(levelId)
		local isHiddenNode = LevelType:isHideLevel(levelId)
		local shouldRemove = isHiddenNode and not metaModel:isHiddenBranchCanShow(metaModel:getHiddenBranchIdByHiddenLevelId(levelId))
		

		if shouldRemove then
			v:removeFromParentAndCleanup(true)
			table.insert(shouldRemoveList, k)
			waitToAddHiddenNodes[levelId] = nil
		else
			if isHiddenNode then
				local hiddenBranchId = MetaModel:sharedInstance():getHiddenBranchIdByHiddenLevelId(levelId)
				local preHiddenLevelScore = UserManager.getInstance():getUserScore(levelId - 1)
				local isFirstFlowerInHiddenBranch = (MetaModel:sharedInstance():getHiddenBranchDataByHiddenLevelId(levelId) or {}).startHiddenLevel == levelId
				

				local star = -1
				if MetaModel:sharedInstance():isHiddenBranchCanOpen(hiddenBranchId) then
					if score and score.star > 0 then
						star = score.star
					elseif isFirstFlowerInHiddenBranch or (preHiddenLevelScore and preHiddenLevelScore.star > 0) then				
						star = 0
					end

					if star >= 0 then
						local function onNodeTouched(evt)
							self:onNodeViewTapped(evt)
						end
						if not v:hasEventListenerByName(DisplayEvents.kTouchTap) then
							v:addEventListener(DisplayEvents.kTouchTap, onNodeTouched, v)
						end
					else
						if v:hasEventListenerByName(DisplayEvents.kTouchTap) then
							v:removeEventListenerByName(DisplayEvents.kTouchTap)
						end
					end
				end
				v:setStar(star, false, false, false, false)

				waitToAddHiddenNodes[levelId] = nil
			else
				if score or v.levelId == UserManager:getInstance():getUserRef():getTopLevelId() then
					v:setStar(score and score.star or 0, ingredientCount, true, false, false)
					local function onNodeTouched(evt)
						self:onNodeViewTapped(evt)
					end
					if not v:hasEventListenerByName(DisplayEvents.kTouchTap) then
						v:addEventListener(DisplayEvents.kTouchTap, onNodeTouched, v)
					end
				elseif ingredientCount > 0 then
					print("hit no score and jump level", levelId)
					v:setStar(0, ingredientCount, true, false, false)
					local function onNodeTouched(evt)
						self:onNodeViewTapped(evt)
					end
					if not v:hasEventListenerByName(DisplayEvents.kTouchTap) then
						v:addEventListener(DisplayEvents.kTouchTap, onNodeTouched, v)
					end
				else
					v:setStar(-1, ingredientCount, true, false, false)
					if v:hasEventListenerByName(DisplayEvents.kTouchTap) then
						v:removeEventListenerByName(DisplayEvents.kTouchTap)
					end
				end
			end
		end
	end

	for k, v in pairs(waitToAddHiddenNodes) do
		self:buildHiddenNode(k)
	end

	for i, v in ipairs(shouldRemoveList) do
		self.levelToNode[v] = nil
	end
end

function WorldScene:onSyncRefreshHiddenBranch()
	local metaModel = MetaModel:sharedInstance()
	local branchList = metaModel:getHiddenBranchDataList()

	for index = 1, #branchList do
		if metaModel:isHiddenBranchCanShow(index) then
			if not self.hiddenBranchArray[index] then
				local branch = HiddenBranch:create(index, true, self.hiddenBranchLayer.refCocosObj:getTexture())
				self.hiddenBranchArray[index] = branch
				self.hiddenBranchLayer:addChild(branch)
				metaModel:markHiddenBranchOpen(index)

				if not metaModel:isHiddenBranchCanOpen(index) then
					branch:showCloud(
						self.lockedCloudLayer:getBatchNode(),
						self.lockedCloudLayer:getHiddenBranchTextBatchNode(),
						self.lockedCloudLayer:getHiddenBranchNumberBatchNode()
					)
				end

				branch:updateState()

				local function onHiddenBranchTapped(event)
					self:onHiddenBranchTapped(event)
				end

				branch:addEventListener(DisplayEvents.kTouchTap, onHiddenBranchTapped, index)
			end
		else
			if self.hiddenBranchArray[index] then
				self.hiddenBranchArray[index]:removeFromParentAndCleanup(true)
				self.hiddenBranchArray[index] = nil
				metaModel:markHiddenBranchClose(index)
			end
		end
	end
end

function WorldScene:onSyncRefreshUnlockCloud()
	local levelAreaDataArray = MetaModel:sharedInstance():getLevelAreaDataArray()
	local usrCurTopLevel = UserManager.getInstance():getUserRef():getTopLevelId()
	local batchNode = self.lockedCloudLayer:getBatchNode()

	local newArray, dirtyCloud = {}, false
	for i = 1, #levelAreaDataArray do
		local cloudInfo = levelAreaDataArray[i]
		local minNode = self.levelToNode[tonumber(cloudInfo.minLevel)]
		local cloud = table.find(self.lockedClouds, function(v)
				return v.id == tonumber(cloudInfo.id)
			end)
		if minNode and tonumber(cloudInfo.star) ~= 0 and tonumber(cloudInfo.minLevel) > usrCurTopLevel then
			if cloud then
				if cloud:ifCanWaitToOpen() then
					cloud:changeState(LockedCloudState.WAIT_TO_OPEN, false)
				else
					cloud:manualDisposeWaitToOpenSprites()
					cloud:changeState(LockedCloudState.STATIC, false)
				end
				table.insert(newArray, cloud)
			else
				local lockedCloud = LockedCloud:create(tonumber(cloudInfo.id), self.lockedCloudAnimLayer, batchNode.refCocosObj:getTexture())

				local startNodePos = self.trunks:getFlowerPos(lockedCloud:getStartNodeId())
				local lockedCloudSize = lockedCloud:getGroupBounds().size
				local halfDeltaWidth = (self.visibleSize.width - lockedCloudSize.width) / 2
				lockedCloud:setPositionX(self.visibleOrigin.x + halfDeltaWidth)
				lockedCloud:setPositionY(startNodePos.y + lockedCloudSize.height - 180)

				table.insert(newArray, lockedCloud)
				batchNode:addChild(lockedCloud)
				dirtyCloud = true
			end
		elseif cloud then
			cloud:removeFromParentAndCleanup(true)
			dirtyCloud = true
		end
	end
	self.lockedClouds = newArray

	if dirtyCloud then
		if self.levelAreaOpenedId ~= false then
			self.levelAreaOpenedId = (MetaManager:getInstance():getLevelAreaRefByLevelId(usrCurTopLevel) or {}).id or false
		end
		UserManager:getInstance().levelAreaOpenedId = false
	end

	local logic = AdvanceTopLevelLogic:create(usrCurTopLevel)
	logic:start()

	self:updateLevelData()
end

function WorldScene:onSyncRefreshHomeSceneAndGuide()
	print("WorldScene:onSyncFinished")
	self:updateUserIconPos(false)

	local scene = Director:sharedDirector():getRunningScene()
	if scene == HomeScene:sharedInstance() then
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

function WorldScene:getTouchedReward( worldPos )
	for k,v in pairs(self.hiddenBranchArray) do
		local reward = v:getRewardNode()
		if reward then
			if reward:hitTestPoint(worldPos, true) then
				return reward
			end
		end
	end
end

function WorldScene:getTouchedFloatIcon(worldPos)
	for _, floatIcon in pairs(self.floatIcons) do
		if floatIcon:hitTestPoint(worldPos, true) then
			return floatIcon
		end
	end
	return nil
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

	-- assert(self.currentStayBranchIndex)
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


			local batchNode = self.lockedCloudLayer:getBatchNode()

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
			batchNode:addChildAt(lockedCloud,0)
		end
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
		and (UserManager:getInstance():getUserScore(self.maxNormalLevelId) ~= nil
		and UserManager:getInstance():getUserScore(self.maxNormalLevelId).star > 0)
		or JumpLevelManager:getLevelPawnNum(self.maxNormalLevelId) > 0 then
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

function WorldScene:buildGradientBackground()
	local background = self.parallaxLayer:getChildByName("background")
	local winSize = CCDirector:sharedDirector():getWinSize()
	local posX = winSize.width / 2
	-- new bg
	local gradients = {
		{startColor="3d0378", endColor="3d0378", height=0},
		{startColor="3d0378", endColor="420ab4", height=19},
		{startColor="420ab4", endColor="3930eb", height=21},
		{startColor="3930eb", endColor="2572ff", height=23},
		{startColor="2572ff", endColor="13b1fc", height=22},
		{startColor="13b1fc", endColor="83dfef", height=15},
	}
	if WorldSceneShowManager:getInstance():isInAcitivtyTime() then 
		gradients = {
			{startColor="01b3ff", endColor="01b3ff", height=0},
			{startColor="01b3ff", endColor="01b3ff", height=19},
			{startColor="01b3ff", endColor="01b3ff", height=21},
			{startColor="01b3ff", endColor="01b3ff", height=23},
			{startColor="01b3ff", endColor="01b3ff", height=22},
			{startColor="01b3ff", endColor="acf5da", height=15},
		}
	end
	if WorldSceneShowManager:getInstance().showType == 2 then
		gradients = {
			{startColor="474edd", endColor="474edd", height=0},
			{startColor="474edd", endColor="4b43cc", height=19},
			{startColor="4b43cc", endColor="4e3bbe", height=21},
			{startColor="4e3bbe", endColor="5133b2", height=23},
			{startColor="5133b2", endColor="542ba6", height=22},
			{startColor="542ba6", endColor="591f93", height=15},
		}
	end
	local bgColor = self:buildBackgroundLayer(gradients)
	
	bgColor:setAnchorPoint(ccp(0.5, 0))
	bgColor:ignoreAnchorPointForPosition(false)
	bgColor:setPositionX(posX)
	bgColor.name = "background"
	self.gradientBackgroundLayer:addChild(bgColor)
end

-- 创建多重渐变色的天空背景
function WorldScene:buildBackgroundLayer(gradients)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local topLevel = MetaManager:getInstance():getMaxNormalLevelByLevelArea()
	local topLevelPos = self.trunks:getFlowerPos(topLevel)
	local config = UIConfigManager:sharedInstance():getConfig()

	local width = winSize.width + self:getHorizontalScrollRange() * self.gradientBackgroundParallaxRatio.x + 10
	local height = topLevelPos.y * config.worldScene_foregroundParallax * config.worldScene_backgroundParallax + 650

	local originHeight = 0
	for _, v in pairs(gradients) do
		originHeight = originHeight + v.height
	end
	local heightScale = 30 --height / originHeight
	if height > originHeight * heightScale then
		-- 将最上面的一个渐变(纯色)拉伸
		gradients[1].height = gradients[1].height + height - originHeight * heightScale
	end
	local bgLayer = Layer:create()
	bgLayer:setContentSize(CCSizeMake(width, height))

	local offsetPosY = 0
	for index = #gradients, 1, -1 do
		local gradient = gradients[index]
		local layerHeight = gradient.height * heightScale
		if layerHeight > 0 then
			local lg = LayerGradient:createWithColor(hex2ccc3(gradient.startColor), hex2ccc3(gradient.endColor))
			lg:changeWidthAndHeight(width, layerHeight+1) -- +1让最后一个像数与下一个渐变的第一个像数重合
			lg:setPosition(ccp(0, offsetPosY))
			bgLayer:addChild(lg)

			offsetPosY = offsetPosY + layerHeight
		end
	end
	return bgLayer
end



function WorldScene:buildBackItemLayer()

	--local balloon = AnniversaryTwoYearsAnimation:buildBalloon()

	--self.backItemLayer:addChild(  balloon  )

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
	if WorldSceneShowManager:getInstance():getShowType() == 2 then
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
	if WorldSceneShowManager:getInstance():getShowType() == 2 then
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

function WorldScene:buildFrontItemLayer(...)
	--local plane = AnniversaryTwoYearsAnimation:buildPlane()

	--self.frontItemLayer:addChild( plane )
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
	local button = HomeScene:sharedInstance().starRewardButton
	if button then
		local layer = button:getParent()
		button:removeFromParentAndCleanup(false)
		layer:addChild(button)
	end
	local button = HomeScene:sharedInstance().inviteFriendBtn
	if button then
		local layer = button:getParent()
		button:removeFromParentAndCleanup(false)
		layer:addChild(button)
	end

	WorldMapOptimizer:getInstance():update()
end


function WorldScene:buildCloudLayer(...)
	assert(#{...} == 0)

	local cloudLayer3 = self.parallaxLayer:getChildByName("cloud3")
	assert(cloudLayer3)
	if WorldSceneShowManager:getInstance():getShowType() == 2 then
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
		-- if metaModel:isHiddenBranchCanOpen(index) then
		if metaModel:isHiddenBranchCanShow(index) then
			local branch = HiddenBranch:create(index, true, self.hiddenBranchLayer.refCocosObj:getTexture())
			self.hiddenBranchArray[index] = branch
			self.hiddenBranchLayer:addChild(branch)
			metaModel:markHiddenBranchOpen(index)

			if not metaModel:isHiddenBranchCanOpen(index) then
				branch:showCloud(
					self.lockedCloudLayer:getBatchNode(),
					self.lockedCloudLayer:getHiddenBranchTextBatchNode(),
					self.lockedCloudLayer:getHiddenBranchNumberBatchNode()
				)
			end

			branch:updateState()

			local function onHiddenBranchTapped(event)
				self:onHiddenBranchTapped(event)
			end

			branch:addEventListener(DisplayEvents.kTouchTap, onHiddenBranchTapped, index)
		end
	end

	local function showCloudLabel( ... )
		for k,v in pairs(self.hiddenBranchArray) do
			v:showCloudLabel()
		end
	end
	local function hideCloudLabel( ... )
		for k,v in pairs(self.hiddenBranchArray) do
			v:hideCloudLabel()
		end
	end

	local cloudLabelIsShow = false
	self:addEventListener(WorldSceneScrollerEvents.BRANCH_MOVING_STARTED,function( ... )
		if not cloudLabelIsShow and self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_ORIGIN then
			showCloudLabel()
			cloudLabelIsShow = true
		end
	end)
	self:addEventListener(WorldSceneScrollerEvents.START_SCROLLED_TO_RIGHT,function( ... )
		if not cloudLabelIsShow then
			showCloudLabel()
			cloudLabelIsShow = true
		end
	end)
	self:addEventListener(WorldSceneScrollerEvents.START_SCROLLED_TO_LEFT,function( ... )
		if not cloudLabelIsShow then
			showCloudLabel()
			cloudLabelIsShow = true
		end
	end)
	self:addEventListener(WorldSceneScrollerEvents.SCROLLED_TO_ORIGIN, function( ... )
		if cloudLabelIsShow then
			hideCloudLabel()
			cloudLabelIsShow = false
		end
	end)


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
			nodeView:setStar(curLevelScore.star, 0, false, false, false)
		else
			local ingredientCount = JumpLevelManager:getInstance():getLevelPawnNum(id)
			nodeView:setStar(0, ingredientCount, false, false, false)
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
		nodeView:addEventListener(WorldMapNodeViewEvents.OPENED_WITH_JUMP, onGetNewStarLevel)
		
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

	if not MetaModel:sharedInstance():isHiddenBranchCanShow(hiddenBranchId) then
		return
	end

	if MetaModel:sharedInstance():isHiddenBranchDesign(hiddenBranchId) then
		return
	end

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

	local star = -1
	if MetaModel:sharedInstance():isHiddenBranchCanOpen(hiddenBranchId) then
		if hiddenLevelScore and hiddenLevelScore.star > 0 then
			star = hiddenLevelScore.star
		elseif isFirstFlowerInHiddenBranch or (preHiddenLevelScore and preHiddenLevelScore.star > 0) then				
			star = 0
		end

		if star >= 0 then
			local function onNodeViewTapped_inner(event)
				self:onNodeViewTapped(event)
			end
			nodeView:addEventListener(DisplayEvents.kTouchTap, onNodeViewTapped_inner, nodeView)
		end
	end

	local function onGetNewStarLevel(event)
		self:onGetNewStarLevel(event)
	end
	nodeView:addEventListener(WorldMapNodeViewEvents.OPENED_WITH_NEW_STAR, onGetNewStarLevel)


	self.treeNodeLayer:addChild(nodeView)
	nodeView:setStar(star, false, false, false, false)
	nodeView:updateView(false, false)

	return nodeView

	-- nodeView:setStar(0, 0, false, false, false)

	-- local hiddenBranchCanOpen = MetaModel:sharedInstance():isHiddenBranchCanOpen(hiddenBranchId)
	-- if hiddenBranchCanOpen then
	-- 	if isFirstFlowerInHiddenBranch or (preHiddenLevelScore and preHiddenLevelScore.star > 0) then
	-- 		nodeView = WorldMapNodeView:create(false, id, self.playFlowerAnimLayer, self.flowerLevelNumberBatchLayer, self.treeNodeLayer.refCocosObj:getTexture())
	-- 		self.levelToNode[id] = nodeView

	-- 		local indexInBranch = id - hiddenBranchData.startHiddenLevel + 1
	-- 		local posX = 0
	-- 		local posY = 0
	-- 		local rightBranchOffsetX = {150, 300, 450}
	-- 		local rightBranchOffsetY = {80, 150, 160}
	-- 		local leftBranchOffsetX = {-150, -300, -450}
	-- 		local leftBranchOffsetY = {80, 150, 160}
	-- 		if hiddenBranchData.type == "1" then
	-- 			posX = hiddenBranchData.x + rightBranchOffsetX[indexInBranch]
	-- 			posY = hiddenBranchData.y + rightBranchOffsetY[indexInBranch]
	-- 		elseif hiddenBranchData.type == "2" then
	-- 			posX = hiddenBranchData.x + leftBranchOffsetX[indexInBranch]
	-- 			posY = hiddenBranchData.y + leftBranchOffsetY[indexInBranch]
	-- 		end
	-- 		nodeView:setPosition(ccp(posX, posY))

	-- 		-- Init Hidden Node View Star State
	-- 		if hiddenLevelScore and hiddenLevelScore.star > 0 then
	-- 			nodeView:setStar(hiddenLevelScore.star, 0, false, false, false)
	-- 		else
	-- 			-- Is The Top Hidden Level
	-- 			nodeView:setStar(0, 0, false, false, false)
	-- 		end
	-- 	end
	-- end

	-- if nodeView then
	-- 	self.treeNodeLayer:addChild(nodeView)
	-- 	nodeView:updateView(false, false)

	-- 	-- --------------------
	-- 	-- Add Event Listener
	-- 	-- ---------------------
	-- 	local context = self
	-- 	local function onNodeViewTapped_inner(event)
	-- 		context:onNodeViewTapped(event)
	-- 	end

	-- 	local function onGetNewStarLevel(event)
	-- 		context:onGetNewStarLevel(event)
	-- 	end

	-- 	nodeView:addEventListener(WorldMapNodeViewEvents.OPENED_WITH_NEW_STAR, onGetNewStarLevel)
	-- 	nodeView:addEventListener(DisplayEvents.kTouchTap, onNodeViewTapped_inner, nodeView)

	-- 	return nodeView
	-- end
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
				jumpLevelPawn = gameResult.jumpLevelPawn,
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

	local function onSendUnlockMsgFailed(errorCode)
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..errorCode), "negative")
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
	if self.levelAreaOpenedId ~= newLevelAreaOpenedId and newLevelAreaOpenedId ~= false then
		self.levelAreaOpenedId = newLevelAreaOpenedId
		GamePlayEvents.dispatchAreaOpenIdChangeEvent(newLevelAreaOpenedId)
	end
end

function WorldScene:onAreaUnlocked( areaId )
	self:updateLevelData()
	self:updateUserIconPos(false)
	local cloud, index = table.find(self.lockedClouds, function(v)
			return v.id == areaId
		end)
	table.remove(self.lockedClouds, index)
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
				topLevelNode:setStar(0, 0, true, true, callback)
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

		local function showMissionTrunkLevelNodeBubble()
			--self:buildMissionBubble(self.topLevelId)
		end

		local chain = CallbackChain:create()
		chain:appendFunc(setTopLevelNodeStarWrapper)
		chain:appendFunc(moveUserIconToNodeWrapper)
		chain:appendFunc(showMissionTrunkLevelNodeBubble)
		chain:call()

		self:updateAllFloatIconPos()
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

function WorldScene:playLevelPassed(passedLevelId, rewardsIdAndPos, isPlayNextLevel, jumpLevelPawn, ...)
	assert(type(passedLevelId) 	== "number")
	assert(type(rewardsIdAndPos)	== "table")
	assert(type(isPlayNextLevel) 	== "boolean")
	assert(#{...} == 0)

	if not jumpLevelPawn  then
		jumpLevelPawn = 0
	end

	-- fix
	self:setTouchEnabled(true, 0, true)

	-- end fix

	print("WorldScene:levelPassedCallback Called !")

	self.homeScene:onLevelPassed(passedLevelId)

	-- Get Correspond Node View , And Star Level
	local node = self.levelToNode[passedLevelId]
	if not node then
		return
	end
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
				local anim = FlyLevelNodeCoinAnimation:create(v.num)
				anim:setWorldPosition(pos)
				anim:setFinishCallback(onFinish)
				anim:play()
				-- HomeSceneFlyToAnimation:sharedInstance():levelNodeCoinAnimation(pos, onFinish)
			elseif v.itemId == ItemType.ENERGY_LIGHTNING then
				local function onFinish()
					local scene = HomeScene:sharedInstance()
					if not scene or scene.isDisposed then return end
					scene:checkDataChange()
					local button = scene.energyButton
					if not button or button.isDisposed then return end
					button:updateView()
				end
				local anim = FlyLevelNodeEnergyAnimation:create(v.num)
				anim:setWorldPosition(pos)
				anim:setFinishCallback(onFinish)
				anim:play()
				-- HomeSceneFlyToAnimation:sharedInstance():levelNodeEnergyAnimation(pos, onFinish)
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
	local isJumpLevel = JumpLevelManager:getLevelPawnNum(passedLevelId) > 0

	if levelScoreRef or isJumpLevel then
		local newStar
		if not isJumpLevel then
			newStar = levelScoreRef.star
		else
			newStar = 0
		end

		-- Update Node's Star Level
		local function updateNodeViewStar(callback)
			if jumpLevelPawn and jumpLevelPawn > 0 then
				node:setStar(newStar, jumpLevelPawn, true, true, callback)
			elseif newStar > oldStar then
				node:setStar(newStar, 0, true, true, callback)
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
					if not PopoutManager:haveWindowOnScreen() then
						self:startLevel(UserManager:getInstance().user:getTopLevelId())
					end
				end
			end
			
			self.homeScene:checkDataChange()
			if isPlayNextLevel then 
				self:updateUserIconPos(onUserIconMoveAnimFinished)
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
		
		-- 
		startGamePanel:setOnClosePanelCallback(function( ... )
			if self.unlockHiddenBranchCloudBranchId then
				self:unlockHiddenBranchCloud(self.unlockHiddenBranchCloudBranchId)
				self.unlockHiddenBranchCloudBranchId = nil
			end
		end)

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

	-- 保证当前星数跟分数一致
	local score = UserManager:getInstance():getUserScore(levelId)
	local levelMapMeta = LevelMapManager.getInstance():getMeta(levelId)
	local levelRewardMeta = MetaManager.getInstance():getLevelRewardByLevelId(levelId)

	if score and score.star >= 0 then
		-- score.star = 0
		local newStar = levelMapMeta:getStar(score.score)
		if newStar > score.star then
			local function onSuccess( evt )

				DcUtil:UserTrack({ category="stage", sub_category="repair_stage_star" })

				local newStar = evt.data.star
				local score = UserManager:getInstance():getUserScore(levelId)
				local deltaStar = newStar - score.star 

				if newStar <= score.star then
					return
				end
				-- 
				score.star = newStar
				UserManager:getInstance():removeUserScore(levelId)
				UserManager:getInstance():addUserScore(score)
				UserService:getInstance():removeUserScore(levelId)
				UserService:getInstance():addUserScore(score)

				if LevelType:isMainLevel(levelId) then
					local curNormalStar = UserManager:getInstance().user:getStar()
					local newNormalStar = curNormalStar + deltaStar
					UserManager:getInstance().user:setStar(newNormalStar)
					UserService.getInstance().user:setStar(newNormalStar)
				elseif LevelType:isHideLevel(levelId) then
					local curHideStar = UserManager:getInstance().user:getHideStar()
					local newHideStar = curHideStar + deltaStar
					UserManager:getInstance().user:setHideStar(newHideStar)
					UserService.getInstance().user:setHideStar(newHideStar)
				end

				HomeScene:sharedInstance().starButton:updateView()

				local nodeView = self.levelToNode[levelId]
				if nodeView then
					nodeView:setStar(newStar, false, false, false, false)
					nodeView:updateView(false, false)
				end

				local curStarReward = false
				if newStar == 1 then
					curStarReward = levelRewardMeta.oneStarReward 
				elseif newStar == 2 then
					curStarReward = levelRewardMeta.twoStarReward
				elseif newStar == 3 then
					curStarReward = levelRewardMeta.threeStarReward
				elseif newStar == 4 then
					curStarReward = levelRewardMeta.fourStarReward
				end

				if curStarReward then
					for k,v in pairs(curStarReward) do
						if v.itemId == 10011 then
							UserManager:getInstance():addRewards({v})
							UserService:getInstance():addRewards({v})
						end
					end
				end

				Localhost:flushCurrentUserData()

				if LevelType:isMainLevel(levelId) then
					local branchId = MetaModel:sharedInstance():getHiddenBranchIdByNormalLevelId(levelId)
					if branchId and MetaModel:sharedInstance():isHiddenBranchCanOpen(branchId) then
						if self.hiddenBranchArray[branchId] and self.hiddenBranchArray[branchId]:isClosed() then
							self.unlockHiddenBranchCloudBranchId = branchId
						end
					end
				end
			end

			local http = SetLevelStarHttp.new()
			http:ad(Events.kComplete, onSuccess)
			http:load(levelId,newStar)
		end
	end
end

function WorldScene:moveTopLevelNodeToCenter( animFinishCallback )

	if not animFinishCallback then animFinishCallback = false end
	-- body
	if self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_LEFT or
			self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_RIGHT then
			self:addEventListener(WorldSceneScrollerEvents.SCROLLED_FOR_TUTOR, function ()
				self:removeEventListenerByName(WorldSceneScrollerEvents.SCROLLED_FOR_TUTOR)
				self:moveNodeToCenter(self.topLevelId, animFinishCallback)
			end)
		self:scrollToOrigin()
	else
		self:moveNodeToCenter(self.topLevelId, animFinishCallback)
	end
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

function WorldScene:showLadybugFourStarGuid( levelId )
	-- body
	local node = self.levelToNode[levelId]
	local size = node:getGroupBounds().size
	local pos_to = node:getPosition()
	local function flyAwayCallback( ... )
		-- body
		if self.ladybugFourStar then 
			self.ladybugFourStar:removeFromParentAndCleanup(true)
			self.ladybugFourStar = nil
		end
	end
	flyAwayCallback()
	local txt = Localization:getInstance():getText("fourstar_this_stage_tips_2")
	local xDelta = 2*size.width /3
	if WorldSceneShowManager:getInstance():isInAcitivtyTime() then 
		xDelta = 1*size.width /2
	end
	local sprite = LadybugFourStarAnimationInLevelNode:create( ccp(pos_to.x + xDelta, pos_to.y - size.height/2), 200,
		LadyBugFourStarAnimationType.kScaleWithoutBtn, txt, flyAwayCallback)

	self.scaleTreeLayer1:addChild(sprite)
	self.ladybugFourStar = sprite
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

	local function verticalScroll( ... )
		local node = self.levelToNode[levelId]
		assert(node)

		if not node then 
			if animFinishCallback then animFinishCallback() end
			return
		end

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

	if LevelType:isMainLevel(levelId) and self.scrollHorizontalState ~= WorldSceneScrollerHorizontalState.STAY_IN_ORIGIN then
		self:scrollToOrigin()
		local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1),CCCallFunc:create(verticalScroll))
		self.maskedLayer:runAction(seq)
	else
		verticalScroll()
	end
end

function WorldScene:buildMissionBubble(level)
	
	if not level then level = self.topLevelId end

	local node = self.levelToNode[level]
	assert(node)

	local nodePosition = node:getPosition()
	local targetPos = ccp(nodePosition.x, nodePosition.y + 0)

	if not self.missionBubbles[level] then
		self.missionBubbles[level] = MissionTrunkLevelNodeBubble:create()
		self.friendPictureLayer:addChild(self.missionBubbles[level])
	end
	local bubble = self.missionBubbles[level]
	bubble:setPosition( ccp( targetPos.x + 1 , targetPos.y - 72 ) )
	bubble:setScale(0.8)
end

function WorldScene:clearMissionBubble(level)
	if self.missionBubbles[level] and self.missionBubbles[level]:getParent() then
		self.missionBubbles[level]:removeFromParentAndCleanup(true)
		self.missionBubbles[level] = nil
	end
end

function WorldScene:clearAllMissionBubble()
	if self.missionBubbles then
		for k,v in pairs(self.missionBubbles) do
			if v:getParent() then
				v:removeFromParentAndCleanup(true)
			end
		end

		self.missionBubbles = {}
	end
end

function WorldScene:checkMissionBubbleShow(level)
	if self.missionBubbles[level] then
		return true
	else
		return false
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

function WorldScene:scrollToBranch( branchId,callback )

	local curBranchData = MetaModel:sharedInstance():getHiddenBranchDataByBranchId(branchId)

	local function onVerticalScrollComplete()
		self.currentStayBranchIndex = branchId
		if tonumber(curBranchData.type) == 1 then
			self:scrollToRight()
		elseif tonumber(curBranchData.type) == 2 then
			self:scrollToLeft()
		end

		self:runAction(CCSequence:createWithTwoActions(
			CCDelayTime:create(0.5),
			CCCallFunc:create(function( ... )
				if callback then
					callback()
				end
			end)
		))
	end

	local branchPos = self.hiddenBranchLayer:convertToWorldSpace(ccp(0, curBranchData.y))
	local branchPos = self.maskedLayer:convertToNodeSpace(branchPos)
	local targetY = branchPos.y - Director:sharedDirector():getVisibleOrigin().y
	local function verticalScroll()
		self:verticalScrollTo(targetY, onVerticalScrollComplete)
	end

	if self.scrollHorizontalState ~= WorldSceneScrollerHorizontalState.STAY_IN_ORIGIN then
		self:scrollToOrigin()
		self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(verticalScroll)))
	else
		verticalScroll()
	end
end

function WorldScene:unlockHiddenBranchCloud( branchId )
	if not self.hiddenBranchArray[branchId] then
		return
	end

	if not self.hiddenBranchArray[branchId]:isClosed() then
		return
	end

	self:scrollToBranch(branchId,function( ... )

		local hiddenBranchData = MetaModel:sharedInstance():getHiddenBranchDataByBranchId(branchId)
		local nodeView = self.levelToNode[hiddenBranchData.startHiddenLevel]
		if nodeView then
			nodeView:setStar(0, false, false, false, false)
			nodeView:updateView(true, false)
			local function onNodeViewTapped_inner(event)
				self:onNodeViewTapped(event)
			end
			nodeView:addEventListener(DisplayEvents.kTouchTap, onNodeViewTapped_inner, nodeView)					
		end

		self.hiddenBranchArray[branchId]:updateState()

	end)
end

function WorldScene:onGetNewStarLevel(event, ...)
	-- assert(event)
	-- assert(event.name == WorldMapNodeViewEvents.OPENED_WITH_NEW_STAR)
	-- assert(event.data)
	-- assert(#{...} == 0)

	local changedLevelId = event.data
	local branchDataList = MetaModel:sharedInstance():getHiddenBranchDataList()

	local function unlockHiddenBranch(branchId)
		-- If Exist A Hidden Branch Based On This Normal Level
		if branchId then
			if not self.hiddenBranchArray[branchId] or WorldSceneShowManager:getInstance():getHideBranchOpenFlag() then
				WorldSceneShowManager:getInstance():setHideBranchOpenFlag(false)
				-- Check If This Hidden Branch Can Open
				-- if MetaModel:sharedInstance():isHiddenBranchCanOpen(branchId) then
				if MetaModel:sharedInstance():isHiddenBranchCanShow(branchId) then 
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
						
						if not MetaModel:sharedInstance():isHiddenBranchCanOpen(branchId) then
							newBranch:showCloud(
								self.lockedCloudLayer:getBatchNode(),
								self.lockedCloudLayer:getHiddenBranchTextBatchNode(),
								self.lockedCloudLayer:getHiddenBranchNumberBatchNode()
							)
						end

						newBranch:playOpenAnim(self.hiddenBranchAnimLayer)
					end

					self:setTouchEnabled(false)
					self.isUnlockingHiddenBranch = true
					self:scrollToBranch(branchId,createNewBranch)

					-- Cookie.getInstance():write(CookieKey.kUnlockHiddenArea, "true")
				end
			end
		end
	end

	if LevelType:isMainLevel(changedLevelId) then
		local branchId = MetaModel:sharedInstance():getHiddenBranchIdByNormalLevelId(changedLevelId)
		if not self.hiddenBranchArray[branchId] then
			unlockHiddenBranch(branchId)
		else
			if MetaModel:sharedInstance():isHiddenBranchCanOpen(branchId) then
				self:unlockHiddenBranchCloud(branchId)
			else
				self.hiddenBranchArray[branchId]:updateState()
			end
		end
	elseif LevelType:isHideLevel(changedLevelId) then
		local hiddenBranchData = MetaModel:sharedInstance():getHiddenBranchDataByHiddenLevelId(changedLevelId)
		local endHiddenLevel = hiddenBranchData.endHiddenLevel
		local nextHiddenLevelOnSameBranch = changedLevelId + 1

		local branchId = MetaModel:sharedInstance():getHiddenBranchIdByHiddenLevelId(changedLevelId)
		self.hiddenBranchArray[branchId]:updateState()

		if changedLevelId < endHiddenLevel then
			local nodeView = self.levelToNode[nextHiddenLevelOnSameBranch]
			if nodeView and nodeView:getStar() < 0 then
				nodeView:setStar(0, false, false, false, false)
				nodeView:updateView(true, false)
				local function onNodeViewTapped_inner(event)
					self:onNodeViewTapped(event)
				end
				nodeView:addEventListener(DisplayEvents.kTouchTap, onNodeViewTapped_inner, nodeView)
			end
		else
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

	for headHiddenLevel=curBranchData.startHiddenLevel,curBranchData.endHiddenLevel do
		local nodeView = self:buildHiddenNode(headHiddenLevel)
	end

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
			self:dispatchEvent(Event.new(WorldSceneScrollerEvents.GAME_INIT_ANIME_FIN))
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
			self.friendsInitiated = true
			GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(MessageCenterPushEvents.kFriendsSynced))
			GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(MessageCenterPushEvents.kInitPushEnergyRequestTask))

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

function WorldScene:getCurrentAreaId( ... )
	-- body
	local min_y = 0 
	local max_y = self.winSize.height 
	local levelList = {}
	local maxCount = 0
	local maxArea = 0
	for k, v in pairs(self.levelToNode) do 
		local node_pos = v:getPosition()
		local node_y = self.treeNodeLayer:convertToWorldSpace(ccp(node_pos.x, node_pos.y)).y
		if node_y > min_y and node_y < max_y and k < 10000 then
			-- print(node_y, min_y, max_y, k) 
			local areaId = math.ceil(k / 15)
			if not levelList[areaId] then
				levelList[areaId] = 0
			end

			levelList[areaId] = levelList[areaId] + 1
			if maxArea == 0 then
				maxArea = areaId
				maxCount = levelList[areaId]
			elseif levelList[areaId] > maxCount then 
				maxArea = areaId
				maxCount = levelList[areaId]
			end

		end
	end

	return maxArea
end

function WorldScene:addFloatIcon(floatIcon)
	local function onFloatIconTapped(event)
		if self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_ORIGIN then
			if floatIcon:getFloatType() == FloatIconType.kRight then
				self:scrollToRight()
			elseif floatIcon:getFloatType() == FloatIconType.kLeft then
				self:scrollToLeft()
			end
			local dcData = {game_type="stage", game_name="two_year_anniversary", category="other", sub_category="two_year_anniversary_change"}
			DcUtil:log(109, dcData)
		elseif self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_RIGHT 
			or self.scrollHorizontalState == WorldSceneScrollerHorizontalState.STAY_IN_LEFT then
			-- self:scrollToOrigin()
		end
	end
	floatIcon:addEventListener(DisplayEvents.kTouchTap, onFloatIconTapped)

	self.floatIconsLayer:addChild(floatIcon)
	table.insert(self.floatIcons, floatIcon)

	self:updateFloatIconPos(floatIcon)
end

function WorldScene:updateAllFloatIconPos()
	for _, v in pairs(self.floatIcons) do
		self:updateFloatIconPos(v)
	end
end

function WorldScene:updateFloatIconPos(floatIcon)
	if floatIcon and not floatIcon.isDisposed then
		local checks = {topLevelId = UserManager:getInstance().user:getTopLevelId()}
		if not floatIcon:checkVisible(checks) then
			floatIcon:setVisible(false)
			return
		else
			floatIcon:setVisible(true)
		end

		if floatIcon:getPosType() == FloatIconPositionType.kTopLevel then
			local topLevelId = topLevelId or self.topLevelId
			local locationNode = self.levelToNode[topLevelId]

			if locationNode then
				local posY = locationNode:getPositionY()

				local levelIdInArea = topLevelId % 15
				if levelIdInArea == 0 then levelIdInArea = 15 end
				-- 计算最高位置限制
				local maxPosY = self.levelToNode[topLevelId - levelIdInArea + 15]:getPositionY() - 590
				posY = math.min(posY, maxPosY)
				-- 计算最低位置限制
				local hiddenBranchId = MetaModel:sharedInstance():getHiddenBranchIdByNormalLevelId(topLevelId - levelIdInArea)
				if hiddenBranchId then
					local minPosY = posY

					-- print(">>>>>>>>>>", floatIcon:getFloatType(), hiddenBranchId)
					if floatIcon:getFloatType() == FloatIconType.kRight and hiddenBranchId % 2 == 1 then -- 右边的隐藏关
						minPosY = self.levelToNode[topLevelId - levelIdInArea]:getPositionY() + 400
					elseif floatIcon:getFloatType() == FloatIconType.kLeft and hiddenBranchId % 2 == 0 then -- 左边的隐藏关
						minPosY = self.levelToNode[topLevelId - levelIdInArea]:getPositionY() + 400
					end
					posY = math.max(posY, minPosY)
				end
				floatIcon:setPosition(ccp(floatIcon:getPositionX(), posY))
			else
				floatIcon:setVisible(false)
			end			
		end
	end
end

function WorldScene:updateAnniversaryFloatButton()
	if not self.anniversaryFloatButton and UserManager:getInstance().user:getTopLevelId() >= 20 then
		if AnniversaryFloatButton and AnniversaryFloatButton:isSupport() and AnniversaryFloatButton:isInAcitivtyTime() then
			local floatIcon = AnniversaryFloatButton:create(FloatIconType.kRight, FloatIconPositionType.kTopLevel)
			self.anniversaryFloatButton = floatIcon

			self.anniversaryFloatButton:setAnchorPoint(ccp(0.5, 0.5))
			self.anniversaryFloatButton:ignoreAnchorPointForPosition(false)

			floatIcon:setPositionXY(820, 0)

			self:addFloatIcon(floatIcon)
		end
	end
end
