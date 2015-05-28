
WorldSceneShowManager = class()
local instance = nil

local ShowType = {NORMAL = 1,
				  SPRING_NIGHT = 2,
				 }
local FlowerType = {NORMAL = 1,
				  	SPRING = 2,
				 }
function WorldSceneShowManager:ctor()
	self.showType = ShowType.NORMAL
	self.flowerType = FlowerType.NORMAL
	self.needRunTimeChange = false
	self.hideBranchFlag = false
	self.scheduledId = nil
	self.startActivityTime = {year=2015, month=01, day=31, hour=0, min=0, sec=0}
	self.endActivityTime = {year=2015, month=03, day=5, hour=23, min=59, sec=59}
end

local function now()
	return os.time() + (__g_utcDiffSeconds or 0)
end

local function getDayStartTimeByTS(ts)
	local utc8TimeOffset = 57600 -- (24 - 8) * 3600
	local oneDaySeconds = 86400 -- 24 * 3600
	return ts - ((ts - utc8TimeOffset) % oneDaySeconds)
end

function WorldSceneShowManager.getInstance()
	if not instance then
		instance = WorldSceneShowManager.new()
		instance:init()
	end
	return instance
end

--2015.3.6活动关闭 直接return false
function WorldSceneShowManager:isInAcitivtyTime()
	-- return now() >= os.time(self.startActivityTime) and now() <= os.time(self.endActivityTime)
	return false
end

function WorldSceneShowManager:init()
	if not self:isInAcitivtyTime() then
		return  
	else
		self.flowerType = FlowerType.SPRING
	end
	--关卡花替换
	if self.flowerType == FlowerType.SPRING then 
		local plistPath = "flash/scenes/flowers/flower_effects_night.plist"
		if __use_small_res then  
			plistPath = table.concat(plistPath:split("."),"@2x.")
		end
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
	end

	-- 替换活动中心图标
	local plistPath = "flash/scenes/homeScene/activitySpringFestival_icon.plist"
	if __use_small_res then  
		plistPath = table.concat(plistPath:split("."),"@2x.")
	end
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)

	--藤蔓等素材替换
	local dayStartTime = getDayStartTimeByTS(now()) 
	local morningStartTime = dayStartTime + 6 * 3600 
	local evenigStartTime = dayStartTime + 18 *3600

	local function scheduledFunc()
		if not self:checkLevelLimit() then return end
		
		self.hideBranchFlag = false
		local showType = nil
		if now() >= morningStartTime and now() < evenigStartTime then 
			showType = ShowType.NORMAL
		elseif now() >= os.time(self.endActivityTime) then 
			showType = ShowType.NORMAL
			self:runtimeRusumeFlower()
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
		self.scheduledId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(scheduledFunc, 60, false)
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

		-- 活动中心图标
		local plistPath = "flash/scenes/homeScene/home_icon.plist"
		if __use_small_res then  
			plistPath = table.concat(plistPath:split("."),"@2x.")
		end
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(plistPath)
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)

		local homeScene = HomeScene:sharedInstance()
		if homeScene.activityButton then
			if homeScene.activityButton == true then
				return
			end
			homeScene.rightRegionLayoutBar:removeItem(homeScene.activityButton,true)
			homeScene.activityButton = nil
			homeScene:buildActivityButton()
		end
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
	local plistPath = "materials/trunkRoot.plist"
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
	local plistPath = {"materials/home_color.plist"}
	if self.showType == ShowType.SPRING_NIGHT then 
		plistPath = {"materials/springNight/home_color1.plist", "materials/springNight/home_color2.plist"}
	end
	if __use_small_res then  
		for i, v in ipairs(plistPath) do
			plistPath[i] = table.concat(v:split("."),"@2x.")
		end
	end

	for i, v in ipairs(plistPath) do
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(v)
	end
	
	if self.needRunTimeChange then 
		local container = HomeScene:sharedInstance().worldScene.gradientBackgroundLayer
		local bg = container:getChildAt(0)
		local scaleX = container.childScaleX
		local winSize = CCDirector:sharedDirector():getWinSize()
		local posX = winSize.width / 2
		container:removeChildren(true)

		if self.showType == ShowType.SPRING_NIGHT then
			local s1 = Sprite:createWithSpriteFrameName("home_color2.png")
			s1:setScaleX(scaleX)
			s1:setAnchorPoint(ccp(0.5, 0))
			s1:setPositionX(posX)
			container:addChild(s1)

			local s2 = Sprite:createWithSpriteFrameName("home_color1.png")
			s2:setScaleX(scaleX)
			s2:setAnchorPoint(ccp(0.5, 0))
			s2:setPositionX(posX)
			s2:setPositionY(s1:getContentSize().height)
			container:addChild(s2)
		elseif self.showType == ShowType.NORMAL then
			local sprite = Sprite:createWithSpriteFrameName("home_color.png")
			sprite:setScaleX(scaleX)
			sprite:setAnchorPoint(ccp(0.5, 0))
			sprite:setPositionX(posX)
			sprite:setScaleY(2.5)
			sprite.name = "background"
			container:addChild(sprite)
		end
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