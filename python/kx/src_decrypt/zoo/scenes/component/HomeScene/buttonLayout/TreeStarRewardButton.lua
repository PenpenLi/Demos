
TreeStarRewardButton = class(BaseUI)

function TreeStarRewardButton:ctor()
	
end

function TreeStarRewardButton:init()
	self.ui	= ResourceManager:sharedInstance():buildGroup("treeStarRewardBtn")
	BaseUI.init(self, self.ui)

	self.bgNormal = self.ui:getChildByName("bg1")
	self.bgLight = self.ui:getChildByName("bg2")
	self.iconLight = self:addLayerColorWrapper(self.ui:getChildByName("iconLight"), ccp(0.5, 0.5))

	self.itemPh = self.ui:getChildByName("itemPh")
	self.itemPhZOrder = self.itemPh:getZOrder()
	self.itemPhPos	= self.itemPh:getPosition()
	-- self.itemPhSize	= self.itemPh:getGroupBounds().size
	self.itemPh:setVisible(false)

	self.numberLabel = self.ui:getChildByName("numberLabel")

	local wrapperSize = self.bgNormal:getContentSize()
	self.wrapper = LayerColor:create()
    self.wrapper:setColor(ccc3(255,0,0))
    self.wrapper:setOpacity(0)
    self.wrapper:setContentSize(CCSizeMake(wrapperSize.width, wrapperSize.height))
    self.wrapper:setPosition(ccp(-wrapperSize.width/2, 0))
	self.wrapper:setTouchEnabled(true, 0, true)
	self.ui:addChild(self.wrapper)

	self:update()
end

function TreeStarRewardButton:addLayerColorWrapper(ui,anchorPoint)
	local size = ui:getGroupBounds().size
	local pos = ui:getPosition()
	local layer = LayerColor:create()
    layer:setColor(ccc3(0,0,0))
    layer:setOpacity(0)
    layer:setContentSize(CCSizeMake(size.width, size.height))
    layer:setAnchorPoint(anchorPoint)
    layer:setPosition(ccp(pos.x, pos.y-size.height))
    
    local uiParent = ui:getParent()
    local index = uiParent:getChildIndex(ui)
    ui:removeFromParentAndCleanup(false)
    ui:setPosition(ccp(0,size.height))
    layer:addChild(ui)
    uiParent:addChildAt(layer, index)

    return layer
end

function TreeStarRewardButton:update()
	local rewardLevelToPushMeta = StarRewardModel:getInstance():update().currentPromptReward
	if rewardLevelToPushMeta then
		local curTotalStar = UserManager:getInstance().user:getTotalStar()
		if curTotalStar >= rewardLevelToPushMeta.starNum then
			self:updateLightShow(true)
		else
			self:updateLightShow(false)
		end
	else
		self:updateLightShow(false)
	end

	self:updateItemShow()
end

function TreeStarRewardButton:updateLightShow(showLight)
	self.iconLight:stopAllActions()
	self.iconLight:setScale(1)
	if showLight then 
		-- self.bgLight:setVisible(true)
		self.iconLight:setVisible(true)	

		self.iconLight:runAction(CCScaleTo:create(0.2, 1.7))
		self.iconLight:runAction(CCRepeatForever:create(CCRotateBy:create(0.1, 9)))
	else
		-- self.bgLight:setVisible(false)	
		self.iconLight:setVisible(false)
	end
end

function TreeStarRewardButton:updateItemShow()
	local itemId, itemNumber = self:getRewardItemInfo()
	if self.itemId and self.itemId == itemId then 
		return 
	end
	self.itemId = itemId

	if self.itemId > 0 then
		if self.itemRes then 
			self.itemRes:removeFromParentAndCleanup(true)
			self.itemRes = nil
		end
		self.numberLabel:setString("")

		local itemRes = ResourceManager:sharedInstance():buildItemGroup(self.itemId)
		self.itemRes = itemRes
		self.ui:addChildAt(itemRes, self.itemPhZOrder)

		local itemPhSize	= self.itemPh:getGroupBounds().size
		local itemResSize	= itemRes:getGroupBounds().size
		local neededScaleX	= itemPhSize.width / itemResSize.width
		local neededScaleY	= itemPhSize.height / itemResSize.height

		local smallestScale = neededScaleX
		if neededScaleX > neededScaleY then
			smallestScale = neededScaleY
		end
		itemRes:setScaleX(smallestScale)
		itemRes:setScaleY(smallestScale)

		-- Reposition
		local itemResSize2	= itemRes:getGroupBounds().size
		local deltaWidth	= itemPhSize.width - itemResSize2.width
		local deltaHeight	= itemPhSize.height - itemResSize2.height
		
		itemRes:setPosition(ccp( self.itemPhPos.x + deltaWidth/2, 
					self.itemPhPos.y - deltaHeight/2))

		self.numberLabel:setString("x" .. itemNumber)
	end
end

function TreeStarRewardButton:getRewardItemInfo()
	local curTotalStar = UserManager:getInstance().user:getTotalStar()
	local userExtend = UserManager:getInstance().userExtend
	local nearestStarRewardLevelMeta = MetaManager.getInstance():starReward_getRewardLevel(curTotalStar)
	local nextRewardLevelMeta = MetaManager.getInstance():starReward_getNextRewardLevel(curTotalStar)
	local rewardLevelToPushMeta = false

	if nearestStarRewardLevelMeta then
		local rewardLevelToPush = userExtend:getFirstNotReceivedRewardLevel(nearestStarRewardLevelMeta.id)
		if rewardLevelToPush then
			-- Has Reward Level
			rewardLevelToPushMeta = MetaManager.getInstance():starReward_getStarRewardMetaById(rewardLevelToPush)
		else
			-- All Reward Level Has Received
		end
	end

	if not rewardLevelToPushMeta then
		-- If Has Next Reward Level, Show It
		if nextRewardLevelMeta then
			rewardLevelToPushMeta = nextRewardLevelMeta
		end
	end

	local itemId = 0
	local itemNumber = 0
	if rewardLevelToPushMeta then
		print(rewardLevelToPushMeta.reward[1].num)
		print(rewardLevelToPushMeta.reward[1].itemId)

		itemId = rewardLevelToPushMeta.reward[1].itemId
		itemNumber = rewardLevelToPushMeta.reward[1].num
	end

	return itemId, itemNumber
end

function TreeStarRewardButton:create()
	local btn = TreeStarRewardButton.new()
	btn:init()
	return btn	
end
