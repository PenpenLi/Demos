require "zoo.animation.SpringFireworkAnimation"

WorldSceneShowManager = class()
local instance = nil

local ShowType = {NORMAL = 1,
				  SPRING_NIGHT = 2,
				 }
local FlowerType = {NORMAL = 1,
				  	SPRING = 2,
				 }

local startActivityTime = {year=2015, month=01, day=31, hour=0, min=0, sec=0}
local endActivityTime = {year=2026, month=03, day=5, hour=23, min=59, sec=59}
local hasPlaySringMusic = false

function WorldSceneShowManager:ctor()
	self.showType = ShowType.NORMAL
	self.flowerType = FlowerType.NORMAL
	self.needRunTimeChange = false
	self.hideBranchFlag = false
	self.scheduledId = nil

	self.startFireworkTime = {year=2016, month=02, day=07, hour=18, min=30, sec=0}
	self.endFireworkTime = {year=2016, month=02, day=09, hour=6, min=30, sec=0}
end

local function now()
	return os.time() + (__g_utcDiffSeconds or 0)
end

local function getDayStartTimeByTS(ts)
	local utc8TimeOffset = 57600 -- (24 - 8) * 3600
	local oneDaySeconds = 86400 -- 24 * 3600
	return ts - ((ts - utc8TimeOffset) % oneDaySeconds)
end

function WorldSceneShowManager:getInstance()
	if not instance then
		instance = WorldSceneShowManager.new()
		instance:init()
	end
	return instance
end

--1.31开始 春节主题关闭
function WorldSceneShowManager:isInAcitivtyTime()
	-- return now() >= os.time(startActivityTime) and now() <= os.time(endActivityTime)
	return false
end

function WorldSceneShowManager:isInFireworkTime()
	local nowTime = now()
	if nowTime >= os.time(self.startFireworkTime) and nowTime <= os.time(self.endFireworkTime) then 
		local dayStartTime = getDayStartTimeByTS(now()) 
		local morningStartTime = dayStartTime + 6.5 * 3600 
		local evenigStartTime = dayStartTime + 18.5 *3600
		if nowTime >= morningStartTime and nowTime < evenigStartTime then
			return false
		else
			return true
		end
	else
		return false
	end
end

--这里可以限定下是否是某个版本
function WorldSceneShowManager:isRightGameVersion()
	-- if _G.bundleVersion then 
	-- 	local numVersion = tonumber(_G.bundleVersion:split(".")[2])
	-- 	if numVersion == 30 then 
	-- 		return true
	-- 	end
	-- end
	return false
end

function WorldSceneShowManager:init()
	if not self:isInAcitivtyTime() then
		return  
	else
		self.flowerType = FlowerType.SPRING
	end

	--白天效果也有变化的 在这里提前声明下
	self:changeFlower()
	self:changeTrunkRoot()

	-- 替换活动中心图标
	-- local plistPath = "flash/scenes/homeScene/activitySpringFestival_icon.plist"
	-- if __use_small_res then  
	-- 	plistPath = table.concat(plistPath:split("."),"@2x.")
	-- end
	-- CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
	-- CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)

	--藤蔓等素材替换
	local dayStartTime = getDayStartTimeByTS(now()) 
	local morningStartTime = dayStartTime + 6.5 * 3600 
	local evenigStartTime = dayStartTime + 18.5 *3600

	local function scheduledFunc()
		-- if not self:checkLevelLimit() then return end
		
		if self:isInFireworkTime() then 
			self:showLongTimeFirework()
		else
			self:stopLongTimeFirework()
		end

		self.hideBranchFlag = false
		local showType = nil
		if now() >= os.time(endActivityTime) then 
			showType = ShowType.NORMAL
			self:runtimeRusumeTrunkRoot()
			self:runtimeRusumeFlower()
		elseif now() >= morningStartTime and now() < evenigStartTime then 
			showType = ShowType.NORMAL
		else
			showType = ShowType.SPRING_NIGHT
		end
		-----------test----------------
		-- if self.showType == ShowType.NORMAL then 
		-- 	showType = ShowType.SPRING_NIGHT
		-- else
		-- 	showType = ShowType.NORMAL
		-- end
		---------------------------------
		if showType ~= self.showType then 
			self.showType = showType
			local homeScene = HomeScene:sharedInstance()
			local oldWorldScene = homeScene.worldScene
			if homeScene:contains(oldWorldScene) then 
				self.needRunTimeChange = true
			end
			self:changeHomeColor()
			self:showNightStar()
			self:changeFlower()
			self:changeTrunk()
			self:changeTrunkRoot()
			self:changeIntermediate()
			self:changeTrunkRootBackCloud()
			self:changeStaticHideBranch()
			self.hideBranchFlag = true
			CCTextureCache:sharedTextureCache():removeUnusedTextures()
		end
	end

	if not self.scheduledId then
		self.scheduledId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(scheduledFunc, 30, false)
	end
	scheduledFunc()
end

function WorldSceneShowManager:checkLevelLimit()
	local user = UserManager:getInstance():getUserRef()
	if user then 
		if user:getTopLevelId() < 20 then 
			return false
		end
	else
		return false
	end
	return true
end

function WorldSceneShowManager:changeFlower()
	if self.flowerType == FlowerType.SPRING then 
		local plistPath = "flash/scenes/flowers/flower_night/flower_effects_spring_day.plist"
		if self.showType == ShowType.SPRING_NIGHT then 
			plistPath = "flash/scenes/flowers/flower_night/flower_effects_spring_night.plist"
		end
		if __use_small_res then  
			plistPath = table.concat(plistPath:split("."),"@2x.")
		end
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
		
		if self.needRunTimeChange then  
			local worldScene = HomeScene:sharedInstance().worldScene
			local texture = CCSprite:createWithSpriteFrameName("normalFlowerAnim00000"):getTexture()
			worldScene.treeNodeLayer.refCocosObj:setTexture(texture)
			for k,v in pairs(worldScene.levelToNode) do
				v.refCocosObj:setTexture(texture)
				v:removeChildren(true)
				
				local flowerFrameName = "flowerSeed0000"
				if v.star == 0 then
					flowerFrameName = "normalFlowerAnim00000"
					if v.isJumpLevel then 
						flowerFrameName = "jumpedFlower0000"
					end
				elseif v.star >= 1 and v.star <= 4 then
					if v.isNormalFlower then 
						flowerFrameName = "normalFlowerAnim".. v.star .. "0000"
					else
						flowerFrameName = "hiddenFlowerAnim".. v.star .. "0000"
					end
				end

				v.flowerRes = Sprite:createWithSpriteFrameName(flowerFrameName)
				v.flowerRes:setAnchorPoint(ccp(0.5, 1))
				v:addChild(v.flowerRes)

				v:buildStar()
			end
		end
	end
end

function WorldSceneShowManager:runtimeRusumeFlower()
	if self.flowerType == FlowerType.SPRING then 
		self.flowerType = FlowerType.NORMAL

		local plistPath = "flash/scenes/flowers/flower_effects.plist"
		local worldScene = HomeScene:sharedInstance().worldScene
		if __use_small_res then  
			plistPath = table.concat(plistPath:split("."),"@2x.")
		end
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)

		local texture = CCSprite:createWithSpriteFrameName("normalFlowerAnim00000"):getTexture()
		worldScene.treeNodeLayer.refCocosObj:setTexture(texture)
		for k,v in pairs(worldScene.levelToNode) do
			v.refCocosObj:setTexture(texture)
			v:removeChildren(true)
			
			local flowerFrameName = "flowerSeed0000"
			if v.star == 0 then
				flowerFrameName = "normalFlowerAnim00000"
				if v.isJumpLevel then 
					flowerFrameName = "jumpedFlower0000"
				end
			elseif v.star >= 1 and v.star <= 4 then
				if v.isNormalFlower then 
					flowerFrameName = "normalFlowerAnim".. v.star .. "0000"
				else
					flowerFrameName = "hiddenFlowerAnim".. v.star .. "0000"
				end
			end

			v.flowerRes = Sprite:createWithSpriteFrameName(flowerFrameName)
			v.flowerRes:setAnchorPoint(ccp(0.5, 1))
			v:addChild(v.flowerRes)

			v:buildStar()
		end

		-- -- 活动中心图标
		-- local plistPath = "flash/scenes/homeScene/home_icon.plist"
		-- if __use_small_res then  
		-- 	plistPath = table.concat(plistPath:split("."),"@2x.")
		-- end
		-- CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
		-- CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)

		-- local homeScene = HomeScene:sharedInstance()
		-- if homeScene.activityButton then
		-- 	if homeScene.activityButton == true then
		-- 		return
		-- 	end
		-- 	homeScene.rightRegionLayoutBar:removeItem(homeScene.activityButton,true)
		-- 	homeScene.activityButton = nil
		-- 	homeScene:buildActivityButton()
		-- end
	end
end

function WorldSceneShowManager:runtimeRusumeTrunkRoot()
	local plistPath = "materials/trunkRoot.plist"
	if __use_small_res then  
		plistPath = table.concat(plistPath:split("."),"@2x.")
	end
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
	
	if self.needRunTimeChange then 
		local sprite = HomeScene:sharedInstance().worldScene.trunks.branchRoot
		sprite.refCocosObj:setTexture(CCSprite:createWithSpriteFrameName("trunkRoot.png"):getTexture())	
	end
end

function WorldSceneShowManager:getHideBranchOpenFlag()
	return self.hideBranchFlag
end

function WorldSceneShowManager:setHideBranchOpenFlag(flag)
	self.hideBranchFlag = flag
end

function WorldSceneShowManager:getShowType()
	return self.showType
end

function WorldSceneShowManager:changeTrunkRoot()
	local plistPath = "materials/springDay/trunkRoot.plist"
	if self.showType == ShowType.SPRING_NIGHT then 
		plistPath = "materials/springNight/trunkRoot.plist"
	end
	if __use_small_res then  
		plistPath = table.concat(plistPath:split("."),"@2x.")
	end
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)

	if self.needRunTimeChange then  
		local sprite = HomeScene:sharedInstance().worldScene.trunks.branchRoot
		sprite.refCocosObj:setTexture(CCSprite:createWithSpriteFrameName("trunkRoot.png"):getTexture())	
	end
end

function WorldSceneShowManager:changeIntermediate()
	local plistPath = "materials/intermediate.plist"
	if self.showType == ShowType.SPRING_NIGHT then 
		plistPath = "materials/springNight/intermediate.plist"
	end
	if __use_small_res then  
		plistPath = table.concat(plistPath:split("."),"@2x.")
	end
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
	
	if self.needRunTimeChange then 
		local sprite = HomeScene:sharedInstance().worldScene.trunks.intermediateSprite
		sprite.refCocosObj:setTexture(CCSprite:createWithSpriteFrameName("intermediate.png"):getTexture())	
	end
end

function WorldSceneShowManager:changeTrunkRootBackCloud()
	local plistPath = "materials/trunkRootBackCloud.plist"
	if self.showType == ShowType.SPRING_NIGHT then 
		plistPath = "materials/springNight/trunkRootBackCloud.plist"
	end
	if __use_small_res then  
		plistPath = table.concat(plistPath:split("."),"@2x.")
	end
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
	
	if self.needRunTimeChange then 
		local sprite = HomeScene:sharedInstance().worldScene.trunks.trunkRootCloudSprite
		sprite.refCocosObj:setTexture(CCSprite:createWithSpriteFrameName("trunkRootBackCloud.png"):getTexture())	
	end
end

function WorldSceneShowManager:changeTrunk()
	local plistPath = "materials/trunk.plist"
	if self.showType == ShowType.SPRING_NIGHT then 
		plistPath = "materials/springNight/trunk.plist"
	end
	if __use_small_res then  
		plistPath = table.concat(plistPath:split("."),"@2x.")
	end
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
	
	if self.needRunTimeChange then
		local trunks = HomeScene:sharedInstance().worldScene.trunks
		local bottomAvailabelY = trunks.bottomAvailabelY
		local batchNode = nil
		for index = 1,trunks.trunkNumber do

			local tree = Sprite:createWithSpriteFrameName("trunk.png")
			assert(tree)
			tree:setAnchorPoint(ccp(0,1))
	    
		    if __WP8 then 
		      bottomAvailabelY = bottomAvailabelY - 1
		      if index == 1 then
		        tree:getTexture():setAliasTexParameters()
		      end
		    end
			
		    local rect = tree:getGroupBounds()
			local treeHeight = rect.size.height
			bottomAvailabelY = bottomAvailabelY + treeHeight + 0
			local y = bottomAvailabelY
			
			local posX = 105
			tree:setPosition(ccp(posX, y))

			trunks.trunksPos[index] = {x=posX, y=y}

			-- Delay Create Batch Node
			if not batchNode then
				local texture = tree:getTexture()
				batchNode = SpriteBatchNode:createWithTexture(texture)
			end

			batchNode.name = "batchNode"
			batchNode:addChild(tree)
		end
		local oldBatchNode = trunks:getChildByName("batchNode")
		local oldIndex = trunks:getChildIndex(oldBatchNode)
		oldBatchNode:removeFromParentAndCleanup(true)

		if batchNode then
			trunks:addChildAt(batchNode, oldIndex)
		end

		HomeScene:sharedInstance().worldScene.trunks = trunks
	end
end

function WorldSceneShowManager:changeHomeColor()
	if self.needRunTimeChange then 
		local container = HomeScene:sharedInstance().worldScene.gradientBackgroundLayer
		local winSize = CCDirector:sharedDirector():getWinSize()
		local posX = winSize.width / 2
		container:removeChildren(true)

		local gradients = {
			{startColor="01b3ff", endColor="01b3ff", height=0},
			{startColor="01b3ff", endColor="01b3ff", height=19},
			{startColor="01b3ff", endColor="01b3ff", height=21},
			{startColor="01b3ff", endColor="01b3ff", height=23},
			{startColor="01b3ff", endColor="01b3ff", height=22},
			{startColor="01b3ff", endColor="acf5da", height=15},
		}
		if self.showType == ShowType.SPRING_NIGHT then
			gradients = {
				{startColor="474edd", endColor="474edd", height=0},
				{startColor="474edd", endColor="4b43cc", height=19},
				{startColor="4b43cc", endColor="4e3bbe", height=21},
				{startColor="4e3bbe", endColor="5133b2", height=23},
				{startColor="5133b2", endColor="542ba6", height=22},
				{startColor="542ba6", endColor="591f93", height=15},
			}
		end
		local bgColor = HomeScene:sharedInstance().worldScene:buildBackgroundLayer(gradients)
		bgColor:setAnchorPoint(ccp(0.5, 0))
		bgColor:ignoreAnchorPointForPosition(false)
		bgColor:setPositionX(posX)
		bgColor.name = "background"
		container:addChild(bgColor)
	end
end

function WorldSceneShowManager:showNightStar()
	if self.needRunTimeChange then 
		local context = HomeScene:sharedInstance().worldScene
		if self.showType == ShowType.SPRING_NIGHT then 
			context.star1Layer:setVisible(true)
		else
			context.star1Layer:setVisible(false)
		end
	end
end

function WorldSceneShowManager:changeCloudColor()
	local plistPath = "flash/scenes/homeScene/home.plist"
	if self.showType == ShowType.SPRING_NIGHT then 
		plistPath = "flash/scenes/homeScene/home_night/home.plist"
	end
	if __use_small_res then  
		plistPath = table.concat(plistPath:split("."),"@2x.")
	end
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
end

function WorldSceneShowManager:changeStaticHideBranch()
	local plistPath = "flash/scenes/flowers/branch.plist"
	if self.showType == ShowType.SPRING_NIGHT then 
		plistPath = "flash/scenes/flowers/branch_night/branch.plist"
	end
	if __use_small_res then  
		plistPath = table.concat(plistPath:split("."),"@2x.")
	end
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
	
	if self.needRunTimeChange then
		local context = HomeScene:sharedInstance().worldScene
		local texture = CCSprite:createWithSpriteFrameName("hide_branch10000"):getTexture()
		local oldLayer = context.hiddenBranchLayer
		local oldIndex = context.scaleTreeLayer1:getChildIndex(oldLayer)
		context.scaleTreeLayer1:removeChild(oldLayer)

		context.hiddenBranchLayer = SpriteBatchNode:createWithTexture(texture)
		context.scaleTreeLayer1:addChildAt(context.hiddenBranchLayer, oldIndex)
		self:buildHiddenBranch(context, texture)
	end
end

function WorldSceneShowManager:buildHiddenBranch(context, texture)
	local metaModel = MetaModel:sharedInstance()
	local branchList = metaModel:getHiddenBranchDataList()
	for index = 1, #branchList do
		if metaModel:isHiddenBranchCanOpen(index) then
			local branch = HiddenBranch:create(index, true, texture)
			context.hiddenBranchArray[index] = branch
			context.hiddenBranchLayer:addChild(branch)
			metaModel:markHiddenBranchOpen(index)

			local function onHiddenBranchTapped(event)
				context:onHiddenBranchTapped(event)
			end

			branch:addEventListener(DisplayEvents.kTouchTap, onHiddenBranchTapped, index)
		end
	end
end

function WorldSceneShowManager:showLongTimeFirework()
	local homeScene = HomeScene:sharedInstance()
	if homeScene then 
		local worldScene = homeScene.worldScene
		if homeScene.worldScene then 
			if homeScene.homeSceneSnowBg then 
				homeScene.homeSceneSnowBg:removeFromParentAndCleanup(true)
				homeScene.homeSceneSnowBg = nil
			end
			if homeScene.worldScene.worldSceneFireworkLayer then 
				homeScene.worldScene.worldSceneFireworkLayer:playLongTimeFirework()
			end
		end
	end
end

function WorldSceneShowManager:stopLongTimeFirework()
	local homeScene = HomeScene:sharedInstance()
	if homeScene then 
		local worldScene = homeScene.worldScene
		if homeScene.worldScene then 
			if homeScene.worldScene.worldSceneFireworkLayer then 
				homeScene.worldScene.worldSceneFireworkLayer:stopLongTimeFirework()
			end
		end
	end
end

function WorldSceneShowManager:showPassLevelFirework(levelId)
	-- if not levelId then return end
	-- if self:isInAcitivtyTime() then 
	-- 	local levelNode = HomeScene:sharedInstance().worldScene.levelToNode[levelId]
	-- 	if levelNode and HomeScene:sharedInstance().homeSceneFireworkLayer then 
	-- 		local worldPos = levelNode:getParent():convertToWorldSpace(levelNode:getPosition())
	-- 		local index = 1
	-- 		local function timerFunc()
	-- 			local fireworkInfo = {}
	-- 			fireworkInfo.fireworkType = index
	-- 			fireworkInfo.fireworkScale = 1
	-- 			fireworkInfo.fromPos = ccp(worldPos.x, worldPos.y - 200)
	-- 			local xDelta = 0
	-- 			local yDelta = 75
	-- 			if index == 1 then 
	-- 				xDelta = -125
	-- 				yDelta = 25
	-- 			elseif index == 3 then 
	-- 				xDelta = 100
	-- 				yDelta = -25
	-- 			end
	-- 			fireworkInfo.endPos = ccp(worldPos.x + (index-2)* 125, worldPos.y + yDelta)

	-- 			HomeScene:sharedInstance().homeSceneFireworkLayer:playPassLevelFirework(fireworkInfo)
	-- 			if index == 3 then 
	-- 				if self.fireworkSchedule then 
	-- 					Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.fireworkSchedule)
	-- 				end
	-- 				self.fireworkSchedule = nil
	-- 			end
	-- 			index = index+1
	-- 		end
	-- 		if not self.fireworkSchedule then 
	-- 			self.fireworkSchedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerFunc, 0.3, false)
	-- 			GamePlayMusicPlayer:playEffect(GameMusicType.kSpringFireworkTriple)
	-- 		end
	-- 	end
	-- end
end

--那个春字晃动的动画
function WorldSceneShowManager:buildIconShockAnimation()
    local actions = CCArray:create()
    actions:addObject(CCRotateBy:create(0.05, -7))
    actions:addObject(CCRotateBy:create(0.10, 14))
    actions:addObject(CCRotateBy:create(0.10, -14))
    actions:addObject(CCRotateBy:create(0.10, 14))
    actions:addObject(CCRotateBy:create(0.05, -7))
    actions:addObject(CCDelayTime:create(3.5))
    local repeatAction = CCRepeatForever:create(CCSequence:create(actions))
    return repeatAction
end

function WorldSceneShowManager:getHasPlaySpringMusic()
	return hasPlaySringMusic
end

function WorldSceneShowManager:setHasPlaySpringMusic(hasPlayed)
	hasPlaySringMusic = hasPlayed
end