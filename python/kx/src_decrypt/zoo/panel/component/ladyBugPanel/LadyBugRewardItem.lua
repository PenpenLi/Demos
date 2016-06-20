
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ26ÈÕ 13:52:30
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- LadyBugRewardItem
---------------------------------------------------

assert(not LadyBugRewardItem)
LadyBugRewardItem = class(BaseUI)

function LadyBugRewardItem:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	-------------
	-- Init Base
	-- ----------
	BaseUI.init(self, ui)

	---------------------
	-- Get UI Resource
	-- -----------------
	self.numberLabel	= self.ui:getChildByName("numberLabel")
	self.numberLabelRect	= self.ui:getChildByName("numberLabel_fontSize")

	self.itemPh		= self.ui:getChildByName("itemPh")
	self.bubbleBg		= self.ui:getChildByName("bubbleBg")

	assert(self.numberLabel)
	assert(self.itemPh)
	assert(self.bubbleBg)

	----------------
	-- Create UI Componenet
	-- --------------------
	self.numberLabel = TextField:createWithUIAdjustment(self.numberLabelRect, self.numberLabel)
	self.ui:addChild(self.numberLabel)

	---------------------
	-- Init UI Resource
	-- ----------------
	self.itemPh:setVisible(false)

	-----------------
	-- Get Data About UI
	-- ------------------
	self.itemPhSize	= self.itemPh:getGroupBounds().size
	self.itemPhSize	= {width = self.itemPhSize.width, height = self.itemPhSize.height}
	self.itemPhPos	= self.itemPh:getPosition()
end

function LadyBugRewardItem:getBubbleNormalAnim(...)
	assert(#{...} == 0)

	local animationInfo = {

		secondPerFrame = 1 / 24,

		object = {
			node = self.bubbleBg,
			deltaScaleX	= 114.75 / 67.05,
			deltaScaleY	= 114.60 / 67.05,
			originalScaleX	= 1,	-- The Base To Apply The Scale
			originalScaleY	= 1
		},

		keyFrames = {
			-- 1
			{ tweenType = "normal",  x = -4.35, y = 4.40, sx = 1.089, sy = 1.089, frameIndex = 1},
			-- 2
			{ tweenType = "normal",  x = -2.60, y = 4.40, sx = 1.041, sy = 1.089, frameIndex = 11},
			-- 3
			{ tweenType = "normal",  x = -4.35, y = 2.70, sx = 1.089, sy = 1.054, frameIndex = 21},
			-- 4
			{ tweenType = "static",  x = -4.35, y = 4.40, sx = 1.089, sy = 1.089, frameIndex = 26}
		}
	}

	local bubbleAction = FlashAnimBuilder:sharedInstance():buildTimeLineAction(animationInfo)
	return bubbleAction
end

function LadyBugRewardItem:getBubbleTouchedAnim(...)
	assert(#{...} == 0)

	local animationInfo = {

		--secondPerFrame = 1 / 24,
		secondPerFrame = 0.6 / 20,

		object	= {
			node		= self.bubbleBg,
			deltaScaleX	= 120 / 81.25,
			deltaScaleY	= 114.60 / 81.25,
			originalScaleX	= 1,
			originalScaleY	= 1
		},

		keyFrames = {
			{ tweenType = "normal", frameIndex = 1, x = -4.10, y = 4.30,	sx = 1.097, sy = 1.097},
			{ tweenType = "normal", frameIndex = 6, x = -7.35, y = 9.0,	sx = 1.18, sy = 1.266},
			{ tweenType = "normal", frameIndex = 9, x = -9.40, y = 4.0,	sx = 1.246, sy = 1.091},
			{ tweenType = "normal", frameIndex = 11,x = -1.95, y = 1.05,	sx = 1.004, sy = 0.995},
			{ tweenType = "normal", frameIndex = 15,x = -6.60, y = 7.80,	sx = 1.162, sy = 1.195},
			{ tweenType = "normal", frameIndex = 17,x = -3.85, y = 1.70,	sx = 1.10, sy = 1,005},
			{ tweenType = "static", frameIndex = 20,x = -4.25, y = 4.20,	sx = 1.081, sy = 1.083}
		}
	}

	local bubbleAction = FlashAnimBuilder:sharedInstance():buildTimeLineAction(animationInfo)
	return bubbleAction
end

function LadyBugRewardItem:playBubbleNormalAnim(...)
	assert(#{...} == 0)

	-- --------------------------
	-- Stop Previous Bubble Anim
	-- --------------------------
	self:stopBubbleNormalAnim()
	self.bubbleBg:setScale(1)

	local bubbleNormalAnim = self:getBubbleNormalAnim()
	local repeatForever = CCRepeatForever:create(bubbleNormalAnim)

	self.bubbleBg:runAction(repeatForever)
end

function LadyBugRewardItem:playBubbleTouchedAnimForever(...)
	assert(#{...} == 0)

	-- --------------------------
	-- Stop Previous Bubble Anim
	-- --------------------------
	self:stopBubbleNormalAnim()
	self.bubbleBg:setScale(1)
	self.item:setScale(self.itemOriginalScale)

	-- Buble Touched Anim
	local bubbleTouchedAnim		= self:getBubbleTouchedAnim()
	
	-- Bubble Normal Anim
	local bubbleNormalAnim 		= self:getBubbleNormalAnim()

	local bubbleNormalAnimTime	= (1 / 24) * (26 - 1)

	-- Enlarge And Reset Size
	

	local initialDelay	= CCDelayTime:create(bubbleNormalAnimTime*0.5)
	local scaleLarge	= CCScaleTo:create(bubbleNormalAnimTime*0.3, 1.4 * self.itemOriginalScale)
	local scaleOriginal	= CCScaleTo:create(bubbleNormalAnimTime*0.2, 1 * self.itemOriginalScale)

	local actionArray	= CCArray:create()
	actionArray:addObject(initialDelay)
	actionArray:addObject(scaleLarge)
	actionArray:addObject(scaleOriginal)
	local scaleSeq		= CCSequence:create(actionArray)
	local targetScale	= CCTargetedAction:create(self.item.refCocosObj, scaleSeq)

	local bubbleNormalAndItemScale	= CCSpawn:createWithTwoActions(bubbleNormalAnim, targetScale)

	-- Seq
	local seq = CCSequence:createWithTwoActions(bubbleTouchedAnim, bubbleNormalAndItemScale)

	-- Repeate Forever
	local seqForever	= CCRepeatForever:create(seq)
	self.bubbleBg:runAction(seqForever)
end

function LadyBugRewardItem:stopBubbleNormalAnim(...)
	assert(#{...} == 0)

	self.bubbleBg:stopAllActions()
end

function LadyBugRewardItem:setReward(itemId, itemNumber, ...)
	assert(type(itemId) == "number")
	assert(type(itemNumber) == "number")
	assert(#{...} == 0)


	self.itemId = itemId
	self.itemNumber = itemNumber

	--local item 	= ResourceManager:sharedInstance():buildItemGroup(itemId)
	local item	= ResourceManager:sharedInstance():buildItemSprite(itemId)
	self.item	= item
	item:setAnchorPoint(ccp(0.5, 0.5))

	local itemSize		= item:getGroupBounds().size
	local itemSizeOrigin	= CCSizeMake(itemSize.width, itemSize.height)

	-- Scale item size
	local deltaScaleY = self.itemPhSize.height / itemSize.height
	self.itemOriginalScale	= deltaScaleY
	item:setScaleX(deltaScaleY)
	item:setScaleY(deltaScaleY)


	local itemSize		= item:getGroupBounds().size
	local deltaWidth	= self.itemPhSize.width - itemSize.width
	local deltaHeight	= self.itemPhSize.height - itemSize.height

	local manualAdjustPosX	= 0
	local manualAdjustPosY	= 0
	--item:setPosition(ccp(self.itemPhPos.x + deltaWidth/2 + manualAdjustPosX, self.itemPhPos.y - deltaHeight/2))
	item:setPosition(ccp(self.itemPhPos.x + self.itemPhSize.width/2 + manualAdjustPosX,
				self.itemPhPos.y - self.itemPhSize.height/2 + manualAdjustPosY)) 
	self.ui:addChild(item)

	-- Get Data About Item
	--local newSize	= CCSizeMake(itemSizeOrigin.width * deltaScaleY, itemSizeOrigin.height * deltaScaleY)
	--self.itemWidth	= newSize.width
	--self.itemHeight	= newSize.height
	self.itemWidth		= itemSizeOrigin.width * deltaScaleY
	self.itemHeight		= itemSizeOrigin.height * deltaScaleY

	-------------------------
	-- Reposition Label To Top
	-- ----------------------
	self.numberLabel:removeFromParentAndCleanup(false)
	self.ui:addChild(self.numberLabel)
	self.numberLabel:setString("x" .. itemNumber)
end

function LadyBugRewardItem:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newLadyBugRewardItem = LadyBugRewardItem.new()
	newLadyBugRewardItem:init(ui)
	return newLadyBugRewardItem
end
