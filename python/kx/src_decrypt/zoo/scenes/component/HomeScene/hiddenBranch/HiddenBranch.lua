

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月25日 16:53:37
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com


---------------------------------------------------
-------------- HiddenBranch
---------------------------------------------------

assert(not HiddenBranchDirection)
HiddenBranchDirection = {
	LEFT	= 1,
	RIGHT	= 2
}

local function checkHiddenBranchDirection(dir)
	assert(dir)

	assert(dir == HiddenBranchDirection.LEFT or
		dir == HiddenBranchDirection.RIGHT)
end

------------------------------------------
-------- Event
---------------------------

assert(not HiddenBranchEvent)

HiddenBranchEvent = 
{
	OPEN_ANIM_FINISHED	= "HiddenBranchEvent.OPEN_ANIM_FINISHED"
}

HiddenBranch = class(Sprite)

function HiddenBranch:init(branchId, initialOpened, texture, ...)
	assert(branchId)
	assert(initialOpened ~= nil)
	assert(type(initialOpened) == "boolean")
	assert(#{...} == 0)

	self.resourceManager = ResourceManager:sharedInstance()

	-- --------------
	-- Init Base Class
	-- ----------------
	local sprite = CCSprite:create()
	self:setRefCocosObj(sprite)
	self.refCocosObj:setTexture(texture)
	
	-- -----------
	-- Get Data
	-- ------------
	self.metaModel = MetaModel:sharedInstance()
	self.branchDataList = self.metaModel:getHiddenBranchDataList()

	self.branchId = branchId

	-- Direction
	self.direction = false
	if tonumber(self.branchDataList[self.branchId].type) == 1 then
		self.direction = HiddenBranchDirection.RIGHT
	elseif tonumber(self.branchDataList[self.branchId].type) == 2 then
		self.direction = HiddenBranchDirection.LEFT
	else
		assert(false)
	end

	-- Position
	self.curBranchData = self.branchDataList[self.branchId]

	local posX = self.curBranchData .x
	local posY = self.curBranchData .y
	self:setPosition(ccp(posX, posY))

	-- ------------
	-- Update View
	-- -------------
	local branch = HiddenBranchAnimation:createStatic()
	self.branch = branch
	self:addChild(branch)

	if self.direction == HiddenBranchDirection.LEFT then
		branch:setScaleX(-1)
	end

	if not initialOpened then
		self.branch:setVisible(false)
	end

	if not self.metaModel:isHiddenBranchDesign(self.branchId) and not self:isRewardReceived() then
		self:showReward()
	end

	function self:hitTestPoint( worldPosition, useGroupTest )
		local bounds = self:getGroupBounds()

		bounds = CCRectMake(
			bounds.origin.x,
			bounds.origin.y - 100,
			bounds.size.width,
			bounds.size.height + 100
		)

		return bounds:containsPoint(worldPosition)
 	end

end

function HiddenBranch:showReward( ... )
	
	if self.reward then
		return
	end

	self.reward = Sprite:createEmpty()

	local root = Sprite:createWithSpriteFrameName("hide_reward_root0000")
	local bubble = Sprite:createWithSpriteFrameName("hide_reward_bubble0000")
	local highlight = Sprite:createWithSpriteFrameName("hide_reward_box_highlight0000")
	local box = Sprite:createWithSpriteFrameName("hide_reward_box0000")

	if self.direction == HiddenBranchDirection.LEFT then
		bubble:setFlipX(true)
		box:setFlipX(true)
	end

	self.reward:setTexture(root:getTexture())
	for _,v in pairs({bubble,box,highlight,root}) do
		self.reward:addChild(v)
	end

	root:setAnchorPoint(ccp(0.5,0))
	bubble:setAnchorPoint(ccp(0.5,0))
	box:setAnchorPoint(ccp(0.478,0))
	highlight:setAnchorPoint(ccp(0.5,0))

	root:setRotation(15)
	bubble:setRotation(12.4)
	box:setRotation(11.9)
	highlight:setRotation(11.9)

	bubble:setPositionY(20)
	box:setPositionY(25)
	highlight:setPositionY(20)
	
	self.reward:setPositionX(400)
	self.reward:setPositionY(190)

	highlight:setVisible(false)


	function self.reward:showHighlight( ... )
		if self.isDisposed then
			return
		end

		highlight:setVisible(true)
		highlight:runAction(CCRepeatForever:create(
			CCSequence:createWithTwoActions(
				CCFadeOut:create(12/24),
				CCFadeIn:create(12/24)
			)
		))
	end
	function self.reward:isShowHighlight( ... )
		if self.isDisposed then
			return
		end

		return highlight:isVisible()		
	end


	function self.reward:playOpenAnim( ... )
		if self.isDisposed then
			return
		end

		root:stopAllActions()
		local rootActions = CCArray:create()
		root:setScaleX(0.08)
		root:setScaleY(0.23)
		rootActions:addObject(CCScaleTo:create(3/24,0.78,1.00))
		rootActions:addObject(CCScaleTo:create(2/24,0.78,1.21))
		rootActions:addObject(CCScaleTo:create(2/24,1.00,1.00))
		root:runAction(CCSequence:create(rootActions))

		box:stopAllActions()
		local boxActions = CCArray:create()
		box:setVisible(false)
		boxActions:addObject(CCDelayTime:create(7/24))
		boxActions:addObject(CCShow:create())
		box:setScaleX(0.29)
		box:setScaleY(0.29)
		boxActions:addObject(CCScaleTo:create(2/24,1.30,1.29))
		boxActions:addObject(CCScaleTo:create(2/24,1.33,0.74))
		boxActions:addObject(CCScaleTo:create(2/24,1.00,1.00))
		box:runAction(CCSequence:create(boxActions))

		bubble:stopAllActions()
		local bubbleActions = CCArray:create()
		bubble:setVisible(false)
		bubbleActions:addObject(CCDelayTime:create(2/24))
		bubbleActions:addObject(CCShow:create())
		bubble:setScaleX(0.17)
		bubble:setScaleY(0.17)
		bubbleActions:addObject(CCScaleTo:create(5/24,0.92,1.00))
		bubbleActions:addObject(CCScaleTo:create(2/24,1.00,1.59))
		bubbleActions:addObject(CCScaleTo:create(2/24,1.18,0.91))
		bubbleActions:addObject(CCScaleTo:create(2/24,0.92,1.09))
		bubbleActions:addObject(CCScaleTo:create(2/24,1.09,0.90))
		bubbleActions:addObject(CCScaleTo:create(2/24,1.00,1.00))
		bubble:runAction(CCSequence:create(bubbleActions))		
	end

	function self.reward:playReceiveAnim( callback )
		if self.isDisposed then
			return
		end

		bubble:setVisible(false)
		root:setVisible(false)
		highlight:setVisible(false)

		self:runAction(CCSequence:createWithTwoActions(
			HiddenBranchAnimation:buildReceiveAnim(self,box),
			CCCallFunc:create(function( ... )
				if callback then
					callback()
				end
			end)
		))
	end

	self.reward:addEventListener(DisplayEvents.kTouchTap, function( ... )
		self:onRewardTapped()
	end)


	self.branch:addChild(self.reward)
end

function HiddenBranch:getRewardNode( ... )
	return self.reward
end

function HiddenBranch:onRewardTapped( ... )
	if not self.reward or self.reward.isDisposed then
		return
	end

	if not self:hasEndPassed() then	
		local runningScene = Director:sharedDirector():getRunningScene()
		if runningScene then
			local tipPanel = BoxRewardTipPanel:create({ rewards=self.curBranchData.hideReward })

			local levelText = tostring(LevelMapManager.getInstance():getLevelDisplayName(self.curBranchData.endHiddenLevel))
			tipPanel:setTipString(Localization:getInstance():getText("hide_stage_tips4",{replace=levelText}))

			runningScene:addChild(tipPanel)
			local bounds = self.reward:getGroupBounds()
			local distance = bounds.size.width/2
			local pos = {x=bounds:getMidX(),y=bounds:getMidY()}
			tipPanel:setArrowPointPositionInWorldSpace(distance,pos.x,pos.y)
		end
	else

		local bounds = self.reward:getBounds()
		local posX = bounds:getMidX()
		local posY = bounds:getMidY()
		
		local function onSuccess( evt )
			self.reward:removeEventListenerByName(DisplayEvents.kTouchTap)

			self.reward:playReceiveAnim(function( ... )
				if self.reward then
					self.reward:removeFromParentAndCleanup(true)
					self.reward = nil
				end
			end)

			UserManager:getInstance():addRewards(evt.data.rewards)
			UserService:getInstance():addRewards(evt.data.rewards)
			HomeScene:sharedInstance():checkDataChange()
			self:setRewardReceived()

			DcUtil:UserTrack({ category="hide", sub_category="get_hide_stage", t1=self.branchId })


			setTimeOut(function( ... )
				local anim = FlyItemsAnimation:create(evt.data.rewards)
				anim:setWorldPosition(ccp(posX,posY + 30))
				anim:play()
			end,0.3)
		end
		local function onFail( evt ) 
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
		end

	 	local http = GetHideAreaRewardsHttp.new(true)
 		http:ad(Events.kComplete, onSuccess)
		http:ad(Events.kError, onFail)
	 	http:syncLoad(self.branchId)
	end
end

function HiddenBranch:showCloud( cloudBathNode,textBatchNode,numberBathNode )
	if self.cloud then
		return
	end

	local curBranchData = self.curBranchData

	self.cloud = Sprite:createEmpty()
	
	local cloudSprite = Sprite:createWithSpriteFrameName("hide_cloud0000")
	cloudSprite:setPositionX(cloudSprite:getContentSize().width/2)
	cloudSprite:setPositionY(cloudSprite:getContentSize().height/2)
	cloudSprite:setAnchorPoint(ccp(0.5,0.5))
	if self.direction == HiddenBranchDirection.LEFT then
		cloudSprite:setFlipX(true)
	end 

	local titleSprite = Sprite:createWithSpriteFrameName("hide_cloud_title0000")
	titleSprite:setAnchorPoint(ccp(0.5,0.5))
	if self.direction == HiddenBranchDirection.LEFT then
		titleSprite:setPositionX(cloudSprite:getContentSize().width/2 - 25)
		titleSprite:setPositionY(cloudSprite:getContentSize().height - 45)		
	else
		titleSprite:setPositionX(cloudSprite:getContentSize().width/2 + 25)
		titleSprite:setPositionY(cloudSprite:getContentSize().height - 45)
	end
	self.cloud.title = titleSprite

	self.cloud:setContentSize(cloudSprite:getContentSize())
	self.cloud:setTexture(cloudSprite:getTexture())

	self.cloud:addChild(cloudSprite)
	self.cloud:addChild(titleSprite)

	self.cloud:setAnchorPoint(ccp(0.5,0.5))

	if self.direction == HiddenBranchDirection.LEFT then
		self.cloud:setPositionX(self:getPositionX() - 330)
		self.cloud:setPositionY(self:getPositionY())
	else
		self.cloud:setPositionX(self:getPositionX() + 330)
		self.cloud:setPositionY(self:getPositionY())
	end

	cloudBathNode:addChild(self.cloud)

	if self.metaModel:isHiddenBranchDesign(self.branchId) then
		-- hide_stage_tips2
		local label = textBatchNode:createLabel(Localization:getInstance():getText("hide_stage_tips3"))
		label:setColor(ccc3(0x0F,0x5B,0x70))
		label:setAnchorPoint(ccp(0.5,0.5))
		label:setScale(0.8)
		if self.direction == HiddenBranchDirection.LEFT then
			label:setPositionX(self.cloud:getPositionX() - 20)
			label:setPositionY(self.cloud:getPositionY())		
		else
			label:setPositionX(self.cloud:getPositionX() + 20)
			label:setPositionY(self.cloud:getPositionY())
		end
		textBatchNode:addChild(label)
		self.cloud.label = label
	else
		-- 
		local startNormalLevel = curBranchData.startNormalLevel
		local endNormalLevel = curBranchData.endNormalLevel

		-- x关全部3星开启（x）
		local label = textBatchNode:createLabel(Localization:getInstance():getText(
			"hide_stage_tips1",
			{ replace1=startNormalLevel,replace2=endNormalLevel }
		))
		label:setScale(0.8)
		label:setColor(ccc3(0x0F,0x5B,0x70))
		label:setAnchorPoint(ccp(0.5,0))
		if self.direction == HiddenBranchDirection.LEFT then
			label:setPositionX(self.cloud:getPositionX() - 20)
			label:setPositionY(self.cloud:getPositionY())		
		else
			label:setPositionX(self.cloud:getPositionX() + 20)
			label:setPositionY(self.cloud:getPositionY())
		end
		textBatchNode:addChild(label)
		self.cloud.label = label

		local number = Sprite:createEmpty()
		number:setTexture(numberBathNode.refCocosObj:getTexture())
		number.refCocosObj:setCascadeOpacityEnabled(true)
			
		local num = endNormalLevel - startNormalLevel + 1
		local number2 = numberBathNode:createLabel("/ " .. num )
		number2:setAnchorPoint(ccp(0,1))
		number2:setPositionX(0)
		number:addChild(number2)

		number:setScale(1.3)
		numberBathNode:addChild(number)	
		self.cloud.number = number

		if self.direction == HiddenBranchDirection.LEFT then
			number:setPositionX(self.cloud:getPositionX() - 40)
			number:setPositionY(self.cloud:getPositionY())
		else
			number:setPositionX(self.cloud:getPositionX())
			number:setPositionY(self.cloud:getPositionY() - 10)
		end

		local guanSprite = Sprite:createWithSpriteFrameName("hide_cloud_guan0000")
		guanSprite:setAnchorPoint(ccp(0,0))
		self:runAction(CCCallFunc:create(function( ... )
			local worldPos = number:convertToWorldSpace(ccp(number2:boundingBox():getMaxX(),number2:boundingBox():getMinY()))
			local localPos = self.cloud:convertToNodeSpace(worldPos)
			guanSprite:setPositionX(localPos.x + 5)
			guanSprite:setPositionY(localPos.y + 11)
		end))
		self.cloud:addChild(guanSprite)
		self.cloud.guang = guanSprite

		function number:setVisible( isVisible )
			if self.isDisposed then
				return
			end
			Sprite.setVisible(self,isVisible)
			guanSprite:setVisible(isVisible)
		end
	end


	function self.cloud:updateStar( ... )
		if self.isDisposed then
			return
		end
		if not self.number then
			return
		end

		if self.number1 then
			self.number1:removeFromParentAndCleanup(true)
		end

		local totalScore = 0
		local startNormalLevel = curBranchData.startNormalLevel
		local endNormalLevel = curBranchData.endNormalLevel
		for index = startNormalLevel, endNormalLevel do
			local score = UserManager.getInstance():getUserScore(index)
			if score and score.star >= 3 then
				totalScore = totalScore + 1
			end
		end

		self.number1 = numberBathNode:createLabel(tostring(totalScore) .. " ")
		self.number1:setAnchorPoint(ccp(1,1))
		self.number1:setPositionX(0)
		self.number1:setColor(ccc3(0xFF,0xFF,0x00))
		self.number:addChild(self.number1)
	end

	function self.cloud:setVisible( isVisible )
		if self.isDisposed then
			return
		end
		Sprite.setVisible(self,isVisible)

		if self.label then
			self.label:setVisible(isVisible)
		end

		if self.number then
			self.number:setVisible(isVisible)
		end

		cloudSprite:setVisible(isVisible)
	end

	function self.cloud:playOpenAnim( ... )
		if self.isDisposed then
			return
		end
		titleSprite:setVisible(false)
		if self.label then
			self.label:setVisible(false)
		end
		if self.number then
			self.number:setVisible(false)
		end
		
		cloudSprite:setScaleX(0.21)
		cloudSprite:setScaleY(0.21)
		cloudSprite:setOpacity(0)

		local actions = CCArray:create()
		actions:addObject(CCSpawn:createWithTwoActions(
			 CCScaleTo:create(10/24,1,1),
			 CCFadeIn:create(10/24)
		))
		actions:addObject(CCCallFunc:create(function( ... )
			titleSprite:setVisible(true)
			if self.label then
				self.label:setVisible(true)
			end
			if self.number then
				self.number:setVisible(true)
			end
		end))
		actions:addObject(CCScaleTo:create(2/24,1.13,1.05))
		actions:addObject(CCScaleTo:create(3/24,1,1))

		cloudSprite:runAction(CCSequence:create(actions))
	end

	local branch = self.branch
	function self.cloud:playUnLockAnim( callback )
		if self.isDisposed or branch.isDisposed then
			return
		end

		titleSprite:setVisible(false)
		if self.label then
			self.label:setVisible(false)
		end
		if self.number then
			self.number:setVisible(false)
		end

		local cloudActions = CCArray:create()
		cloudActions:addObject(CCScaleTo:create(5/24,0.56,0.65))
		cloudActions:addObject(CCCallFunc:create(function( ... )
			cloudSprite:setVisible(false)
		end))
		cloudSprite:runAction(CCSequence:create(cloudActions))

		self:runAction(CCSequence:createWithTwoActions(
			HiddenBranchAnimation:buildUnlockAnim(self,branch),
			CCCallFunc:create(function( ... )
				if callback then
					callback()
				end
			end)
		))
	end

	self.cloud:updateStar()
	self.cloud.title:setVisible(false)
	self.cloud.label:setVisible(false)
	if self.cloud.number then
		self.cloud.number:setVisible(false)
	end
	if self.cloud.guang then
		self.cloud.guang:setVisible(false)
	end
end


function HiddenBranch:showCloudLabel( ... )
	if not self.cloud then
		return
	end

	local function fadeIn( ui )
		ui:stopAllActions()
		ui:setVisible(true)
		ui:runAction(CCFadeIn:create(0.5))
	end

	fadeIn(self.cloud.title)
	fadeIn(self.cloud.label)
	if self.cloud.number then
		fadeIn(self.cloud.number)
	end
	if self.cloud.guang then
		fadeIn(self.cloud.guang)
	end
end

function HiddenBranch:hideCloudLabel( ... )
	if not self.cloud then
		return
	end

	local function fadeOut( ui )
		-- ui:stopAllActions()
		-- ui:runAction(CCFadeOut:create(0.5))
		ui:setVisible(false)
	end

	fadeOut(self.cloud.title)
	fadeOut(self.cloud.label)
	if self.cloud.number then
		fadeOut(self.cloud.number)
	end
	if self.cloud.guang then
		fadeOut(self.cloud.guang)
	end
end


function HiddenBranch:getDirection(...)
	assert(#{...} == 0)

	return self.direction
end

function HiddenBranch:playOpenAnim(animLayer)
	local animBranch = nil 

	if self.cloud then
		self.cloud:setVisible(false)
	end

	local function onAnimComplete()
		animBranch:removeFromParentAndCleanup(true)
		self.branch:setVisible(true)
		self:dp(Event.new(HiddenBranchEvent.OPEN_ANIM_FINISHED, self.branchId, self))

		if self.reward then
			self.reward:playOpenAnim()
		end

		if self.cloud then
			self.cloud:setVisible(true)
			self.cloud:playOpenAnim()
		end

	end

	local manualAdjustX = 0
	local manualAdjustY = 0

	animBranch = HiddenBranchAnimation:createAnim(onAnimComplete)
	animBranch:setPosition(ccp(self:getPositionX() + manualAdjustX, self:getPositionY() + manualAdjustY))

	animLayer:addChild(animBranch)
	
	if self.direction == HiddenBranchDirection.LEFT then
		animBranch:setScaleX(-1)
	end
end

function HiddenBranch:isClosed( ... )
	return self.cloud ~= nil
end

function HiddenBranch:create(branchId, initialOpened, texture, ...)
	assert(branchId)
	assert(initialOpened ~= nil)
	assert(type(initialOpened) == "boolean")
	assert(#{...} == 0)

	local newHiddenBranch = HiddenBranch.new()
	newHiddenBranch:init(branchId, initialOpened, texture)
	return newHiddenBranch
end



function HiddenBranch:updateState( ... )
	if self.cloud then
		self.cloud:updateStar()

		if MetaModel:sharedInstance():isHiddenBranchCanOpen(self.branchId) then
			self.cloud:playUnLockAnim(function( ... )
				if self.cloud then
					self.cloud:removeFromParentAndCleanup(true)
					self.cloud = nil
				end
			end)
		end
	end

	if self.reward then
		if self:hasEndPassed() and not self.reward:isShowHighlight() then
			self.reward:showHighlight()

			local uid = UserManager.getInstance().uid
			local data = Localhost:readLocalBranchDataByBranchId(uid,self.branchId)
			if not data.canRewardTime then
				data.canRewardTime = Localhost:time()
				Localhost:writeLocalLevelDataByBranchId(uid,self.branchId,data)
			end
		end
	end

end


function HiddenBranch:hasEndPassed( ... )
	local endHiddenLevel = self.curBranchData.endHiddenLevel
	return UserManager.getInstance():hasPassedLevel(endHiddenLevel)
end

function HiddenBranch:isRewardReceived( ... )
	return UserManager:getInstance():getUserExtendRef():isHideAreaRewardReceived(self.branchId)
end

function HiddenBranch:setRewardReceived( ... )
	UserManager:getInstance():getUserExtendRef():setHideAreaRewardReceived(self.branchId)
	Localhost:flushCurrentUserData()
end