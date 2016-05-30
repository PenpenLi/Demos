
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê10ÔÂ23ÈÕ  0:32:42
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.common.FlashAnimBuilder"

---------------------------------------------------
-------------- BubbleItem
---------------------------------------------------

BubbleItem = class(BaseUI)

function BubbleItem:init(ui, itemType, ...)
	--assert(ui ~= nil)
	assert(ui)
	assert(type(itemType) == "number")
	assert(#{...} == 0)

	self.ui = ui

	if not self.ui then
		self.ui = ResourceManager:sharedInstance():buildGroup("common/bubbleItem")
	end

	--------------
	-- Init Base
	-- -----------
	BaseUI.init(self, self.ui)

	--------------
	-- Get UI Resouece
	-- --------------
	self.numberLabel	= self.ui:getChildByName("numberLabel")
	self.numberBg		= self.ui:getChildByName("numberBg")


	self.bubble		= self.ui:getChildByName("bubble")
	self.itemPlaceholder	= self.ui:getChildByName("itemPlaceholder")

	assert(self.numberLabel)
	assert(self.numberBg)
	assert(self.bubble)
	assert(self.itemPlaceholder)

	----------------
	--- Get Data About UI
	----------------------
	self.itemPlaceholderPos 	= self.itemPlaceholder:getPosition()
	self.itemPlaceholderSize	= self.itemPlaceholder:getGroupBounds().size
	self.itemPlaceholderSize	= {width = self.itemPlaceholderSize.width, height = self.itemPlaceholderSize.height}

	self.bubbleOriginScaleX	= self.bubble:getScaleX()
	self.bubbleOriginScaleY	= self.bubble:getScaleY()

	self.centerX	= self.itemPlaceholderPos.x + self.itemPlaceholderSize.width / 2
	self.centerY	= self.itemPlaceholderPos.y - self.itemPlaceholderSize.height / 2

	-- ----------
	-- Get Data
	-- -----------
	self.itemType		= itemType
	self.isNumberVisible	= true
	
	self.BUBBLE_ANIM_STATE_NONE			= 1
	self.BUBBLE_ANIM_STATE_NORMAL_ANIM_PLAYING	= 2
	self.BUBBLE_ANIM_STATE_EXPLODED_ANIM_PLAYING	= 3
	self.BUBBLE_ANIM_STATE_TOUCHED_ANIM_PLAYING	= 4
	self.bubbleAnimState				= self.BUBBLE_ANIM_STATE_NONE


	self.itemNumberChangeCallback = false

	------------------
	-- Get Item Number
	-- --------------
	self.itemNumber	= UserManager:getInstance():getUserPropNumber(self.itemType)

	-----------------
	---- Init UI Resource
	--------------------
	self.itemPlaceholder:setVisible(false)

	if self.itemNumber == 0 then
		self:setNumberVisible(false)
	end

	-- -------------
	-- Update View
	-- -------------
	self.itemRes	= ResourceManager:sharedInstance():buildItemSprite(self.itemType)

	local itemResSize	= self.itemRes:getGroupBounds().size
	local halfDeltaWidth 	= (self.itemPlaceholderSize.width - itemResSize.width) / 2
	local halfDeltaHeight	= (self.itemPlaceholderSize.height - itemResSize.height) / 2
	local centerPosX	= self.itemPlaceholderPos.x + halfDeltaWidth
	local centerPosY	= self.itemPlaceholderPos.y - halfDeltaHeight

	local manualAdjustX	= -5
	local manualAdjustY	= 0

	centerPosX = centerPosX + manualAdjustX
	centerPosY = centerPosY + manualAdjustY

	self.itemRes:setPosition(ccp(centerPosX, centerPosY))
	self.ui:addChild(self.itemRes)

	self.itemRes:setAnchorPointCenterWhileStayOrigianlPosition()

	-- Set Number Label
	self.fontSize = self.numberLabel:getFontSize()
	self.labelPos = self.numberLabel:getPositionY()
	if self.itemNumber > 99 then
		self.numberLabel:setPositionY(self.labelPos - 4)
		self.numberLabel:setFontSize(self.fontSize - 8)
		self.numberLabel:setString("99+")
	else
		self.numberLabel:setPositionY(self.labelPos)
		self.numberLabel:setFontSize(self.fontSize)
		self.numberLabel:setString(self.itemNumber)
	end

	--------------------
	-- Animation Data
	-- ------------------
	local data = {}
	self.data = data

	data[1] = {}
	data[1][1]	= {	28.95,	-4.50,	1.047,	1.047,	7}
	data[1][2]	= {	27.20,	4.75,	0.283,	0.283,	13}
	
	data[2] = {}
	data[2][1]	= {	7.55,	-19.40,	1.309,	1.309,	7}
	data[2][2]	= {	-2.20,	-14.85,	0.244,	0.244,	13}

	data[3]	= {}
	data[3][1]	= {	7.80,	-26.05,	0.566,	0.566,	7}
	data[3][2]	= {	0,	-25.55,	0.22,	0.22,	12}

	data[4] = {}
	data[4][1]	= {	9.0,	-45.90,	0.566,	0.566,	7}
	data[4][2]	= {	3.9,	-48.25,	0.178,	0.178,	12}

	data[5]	= {}
	data[5][1]	= {	9.7,	-51.20,	0.861,	0.861,	7}
	data[5][2]	= {	4.25,	-57.15,	0.209,	0.209,	12}

	data[6]	= {}
	data[6][1]	= {	37.5,	-62.7,	0.387,	0.387,	7}
	data[6][2]	= {	38.10,	-68.25,	0.278,	0.278,	11}

	data[7] = {}
	data[7][1]	= {	57.85,	-57.80,	1.309,	1.309,	7}
	data[7][2]	= {	65.40,	-65.35,	0.244,	0.244,	13}

	data[8] = {}
	data[8][1]	= {	60.45,	-51.20,	0.566,	0.566,	7}
	data[8][2]	= {	65.9,	-54.80,	0.275,	0.275,	12}

	data[9] = {}
	data[9][1]	= {	61.40,	-35.90,	0.387,	0.387,	7}
	data[9][2]	= {	66.45,	-36,	0.265,	0.265,	12}

	data[10] = {}
	data[10][1]	= {	62.40,	-10.25,	0.861,	0.861,	7}
	data[10][2]	= {	69.45,	-4.35,	0.276,	0.276,	13}

	------------------------------------------------------------
	------------------------------------------------------------

	data[11] = {}
	data[11][1] = { 32.15,	1.05,	1.413, 1.413,	7}
	data[11][2] = {	30.25,	19.30,	0.564,	0.564,	13}

	data[12] = {}
	data[12][1] = {	11.20,	-9.80,	0.973,	0.973,	7}
	data[12][2] = {	2.15,	-1.05,	0.421,	0.421,	13}

	data[13] = {}
	data[13][1] = { 7.30,	-10.70,	0.447,	0.447,	7}
	data[13][2] = { 1.55,	-6.05,	0.291,	0.291,	13}

	data[14] = {}
	data[14][1] = {	-2.65,	-30,	1.413,	1.413,	7}
	data[14][2] = {-18.55,	-27.50,	0.38,	0.38,	15}

	data[15] = {}
	data[15][1] = {-4.25,	-40.05,	0.424,	0.424,	7}
	data[15][2] = {-15.55,	-39.60,	0.181,	0.181,	13}

	data[16] = {}
	data[16][1] = {-7.30,	-42.30,	0.785,	0.785,	7}
	data[16][2] = {-14.80,	-43.25,	0.273,	0.273,	14}

	data[17] = {}
	data[17][1] = { -0.20,	-57.15,	0.424,	0.424,	7}
	data[17][2] = {-5,	-59.55,	0.255,	0.255,	13}

	data[18] = {}
	data[18][1] = {14.05,	-68.45,	1.031,	1.031,	7}
	data[18][2] = {8.65,	-76.20,	0.318,	0.318,	14}

	data[19] = {}
	data[19][1] = {65.35,	-56.55,	2.025, 2.025, 7}
	data[19][2] = {81.20,	-69.30,	0.438, 0.438, 15}

	data[20] = {}
	data[20][1] = {74.8,	-47.55,	0.447, 0.447,	7}
	data[20][2] = {82.55,	-49.70,	0.291,	0.291,	13}

	data[21] = {}
	data[21][1] = {72.65,	-19.65,	1.054, 1.054,	7}
	data[21][2] = {83.15,	-16.25,	0.302, 0.302,	13}

	data[22] = {}
	data[22][1] = {62.05,	-17.60,	0.608,	0.608,	7}
	data[22][2] = {67.80,	-12.60,	0.362,	0.362,	12}

	data[23] = {}
	data[23][1] = {66.85,	-8.30,	1.50,	1.50,	7}
	data[23][2] = {76.85,	-2.75,	0.52,	0.52,	14}

	data[24] = {}
	data[24][1] = {42.80,	-8.30,	0.608,	0.608,	7}
	data[24][2] = {44.35,	10.0,	0.412,	0.412,	14}



	self:playNumberAnimation()
end

function BubbleItem:getItemRes(...)
	assert(#{...} == 0)
	
	return self.itemRes
end

function BubbleItem:playNumberAnimation()
	local function setAnchorPointWhileStayOriginalPosition(ui, newAnchorPoint)
		local selfSize		= ui:getGroupBounds().size
		local originalAnchorX	= ui:getAnchorPoint().x
		local originalAnchorY	= ui:getAnchorPoint().y
		local deltaAnchorX = newAnchorPoint.x - originalAnchorX
		local deltaAnchorY = newAnchorPoint.y - originalAnchorY
		local deltaDistanceX	= selfSize.width * deltaAnchorX
		local deltaDistanceY	= selfSize.height * deltaAnchorY
		ui:setAnchorPoint(ccp(newAnchorPoint.x, newAnchorPoint.y))
		local curPosX		= ui:getPositionX()
		local curPosY		= ui:getPositionY()
		local newPosX		= curPosX + deltaDistanceX
		local newPosY		= curPosY + deltaDistanceY
		ui:setPosition(ccp(newPosX, newPosY))

	end

	local function getAction (baseScale)
		local expand1 = CCScaleTo:create(4/24, 1.2 * baseScale)
	    local shrink1 = CCScaleTo:create(4/24, 1 * baseScale)
	    local expand2 = CCScaleTo:create(4/24, 1.2 * baseScale)
	    local shrink2 = CCScaleTo:create(4/24, 1 * baseScale)
	    local delay = CCDelayTime:create(25/24)
	    local actions = CCArray:create()
	    actions:addObject(expand1)
	    actions:addObject(shrink1)
	    actions:addObject(expand2)
	    actions:addObject(shrink2)
	    actions:addObject(delay)
	    local repeatAction = CCRepeatForever:create(CCSequence:create(actions))
	    return repeatAction
	end
	-- print(self.numberBg:getAnchorPoint().x, self.numberBg:getAnchorPoint().y)
	-- print(self.numberLabel:getAnchorPoint().x, self.numberLabel:getAnchorPoint().y)
	setAnchorPointWhileStayOriginalPosition(self.numberBg, ccp(0.5, 0.5))
	setAnchorPointWhileStayOriginalPosition(self.numberLabel, ccp(0.5, 0.5))
	self.labelPos = self.numberLabel:getPositionY()
	self.numberBg:runAction(getAction(1.5))
	self.numberLabel:runAction(getAction(1))
end

function BubbleItem:updateItemNumber(...)
	assert(#{...} == 0)

	local newNumber = UserManager:getInstance():getUserPropNumber(self.itemType)

	print("newNumber: " .. newNumber)

	if self.itemNumber ~= newNumber then

		self.itemNumber = newNumber
		if self.itemNumber > 99 then
			self.numberLabel:setPositionY(self.labelPos - 4)
			self.numberLabel:setFontSize(self.fontSize - 8)
			self.numberLabel:setString("99+")
		else
			self.numberLabel:setPositionY(self.labelPos)
			self.numberLabel:setFontSize(self.fontSize)
			self.numberLabel:setString(self.itemNumber)
		end
		

		if self.itemNumberChangeCallback then
			self.itemNumberChangeCallback(self.itemNumber)
		end
	end


	if self.itemNumber == 0 then
		self:setNumberVisible(false)
	else
		self:setNumberVisible(true)
	end
end

function BubbleItem:registerItemNumberChangeCallback(callback, ...)
	assert(type(callback) == "function")
	assert(#{...} == 0)

	self.itemNumberChangeCallback = callback
end

function BubbleItem:restorBubbleToOriginSize(...)
	assert(#{...} == 0)

	self.bubble:setScaleX(self.bubbleOriginScaleX)
	self.bubble:setScaleY(self.bubbleOriginScaleY)
end

function BubbleItem:getItemNumber(...)
	assert(#{...} == 0)

	assert(self.itemNumber)
	return self.itemNumber
end

function BubbleItem:getItemType(...)
	assert(#{...} == 0)

	assert(self.itemType)
	return self.itemType
end

function BubbleItem:setNumberVisible(visible, ...)
	assert(type(visible) == "boolean")
	assert(#{...} == 0)

	self.isNumberVisible = visible

	if visible then
		self.numberLabel:setVisible(true)
		self.numberBg:setVisible(true)
	else
		self.numberLabel:setVisible(false)
		self.numberBg:setVisible(false)
	end
end

function BubbleItem:getItemIconShrinkEnlargeAction(...)
	assert(#{...} == 0)

	if not self.itemRes then
		local emptyAction = CCDelayTime:create(0)
		return emptyAction
	end

	-- Init Anim Start State
	local function initAnim()
		self.itemRes:setScale(1)
	end
	local initAnimAction = CCCallFunc:create(initAnim)

	local t1 = CCScaleTo:create(4/30.0, 0.7, 0.7)
	local t2 = CCScaleTo:create(7/30.0, 1.5, 1.5)
	local t3 = CCScaleTo:create(3/30.0, 1.2, 1.2)
	local t4 = CCScaleTo:create(2/30.0, 1.4, 1.4)
	local t5 = CCScaleTo:create(1/30.0, 1.3, 1.3)

	local actionArray = CCArray:create()
	actionArray:addObject(initAnimAction)
	actionArray:addObject(t1)
	actionArray:addObject(t2)
	actionArray:addObject(t3)
	actionArray:addObject(t4)
	actionArray:addObject(t5)

	-- Seq
	local seq = CCSequence:create(actionArray)
	local targetSeq = CCTargetedAction:create(self.itemRes.refCocosObj, seq)

	return targetSeq
end

function BubbleItem:getBubbleExplodedActionNew(...)
	assert(#{...} == 0)

	if not self.bubbleExplodedNew then
		self.bubbleExplodedNew = ResourceManager:sharedInstance():buildGroup("common/bubbleExplodedNew")
		self.ui:addChild(self.bubbleExplodedNew)
	end

	self.bubbleExplodedNew:setScaleX(248.05 / 103.35)
	self.bubbleExplodedNew:setScaleY(238.30 / 99.30)

	local bubbleExploded = self.bubbleExplodedNew

	-- Get Bubble Exploded  
	local bubbleClips = {}

	for index = 1,24 do
		local bubbleClip = bubbleExploded:getChildByName(tostring(index))
		assert(bubbleClip)
		bubbleClips[index] = bubbleClip
		bubbleClip:setVisible(false)
	end

	local data = self.data
	--self.data = data

	local bubbleClipsActionArray = CCArray:create()

	local manualAdjustFrameIndex = -1

	for index = 1,24 do

		local bubbleClipAnimInfo = {

			secondPerFrame = 1 / 36,
			--secondPerFrame = 1 / 24,
			--secondPerFrame = 1,

			object = {
				node = bubbleClips[index],
				deltaScaleX	= 1,
				deltaScaleY	= 1,
				originalScaleX = 1,
				originalScaleY = 1,
			},

			keyFrames = {
				{ tweenType = "delay", frameIndex = 1},

				{ tweenType = "normal", frameIndex = data[index][1][5] + manualAdjustFrameIndex, x = data[index][1][1], y = data[index][1][2], sx = data[index][1][3], sy = data[index][1][4]},
				{ tweenType = "static", frameIndex = data[index][2][5] + manualAdjustFrameIndex, x = data[index][2][1], y = data[index][2][2], sx = data[index][2][3], sy = data[index][2][4]}
			}
		}

		local bubbleClipAction = FlashAnimBuilder:sharedInstance():buildTimeLineAction(bubbleClipAnimInfo)
		
		local function hideBubbleClip()
			bubbleClips[index]:setVisible(false)
			bubbleClips[index]:setPosition(ccp(data[index][1][1], data[index][1][2]))
		end
		local hideBubbleClipAction = CCCallFunc:create(hideBubbleClip)

		local bubbleClipAction = CCSequence:createWithTwoActions(bubbleClipAction, hideBubbleClipAction)
		bubbleClipsActionArray:addObject(bubbleClipAction)
	end

	-- Spawn
	local bubbleClipsAction = CCSpawn:create(bubbleClipsActionArray)
	
	----------------------
	-- Bubble Animation
	-- --------------------

	local bubbleAnimInfo = {
		secondPerFrame = 1 / 36,
		--secondPerFrame = 1 / 2,
		--secondPerFrame = 1/24,
		--secondPerFrame = 1,

		object = {
			node = self.bubble,
			deltaScaleX = 180 / 74.15,
			deltaScaleY = 180 / 74.05,
			originalScaleX = 1,
			originalScaleY = 1,
		},

		keyFrames = {
			--{ tweenType = "normal", frameIndex = 1, x = 0,		y = -0,		sx = 1,		sy = 1 },
			--{ tweenType = "static", frameIndex = 2, x = 16.65,	y = -15.40,	sx = 0.57,	sy = 0.60},
			--{ tweenType = "normal", frameIndex = 3, x = 12.95,	y = -13.90,	sx = 0.666,	sy = 0.640},
			--{ tweenType = "static", frameIndex = 6, x = 0.7,	y = -2.15,	sx = 0.982,	sy = 0.944},
			{ tweenType = "normal", frameIndex = 1, x = 0,	 	y = 0,		sx = 1,		sy = 1},
			{ tweenType = "static", frameIndex = 5, x = -9.05,	y = 7.15,	sx = 1.232,	sy = 1.184 },
			{ tweenType = "delay", frameIndex = 6}
		}
	}

	local bubbleAnim = FlashAnimBuilder:sharedInstance():buildTimeLineAction(bubbleAnimInfo)

	-- Bubble Anim Finish Callback
	local function bubbleAnimFinish()
		self.bubble:setVisible(false)
	end
	local bubbleAnimFinishCallback = CCCallFunc:create(bubbleAnimFinish)

	-- Bubble Anim
	local bubbleAnim = CCSequence:createWithTwoActions(bubbleAnim, bubbleAnimFinishCallback)


	local spawn = CCSpawn:createWithTwoActions(bubbleClipsAction, bubbleAnim)
	return spawn
end

function BubbleItem:playBubbleExplodedAnimNew(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	-- ---------------------------
	-- Stop Previous Bubble Action
	-- ---------------------------
	self:stopBubbleAnim()

	-- -------------------
	-- Bubble Exploded Anim
	-- --------------------
	local explodedAction = self:getBubbleExplodedActionNew()

	-------------------
	-- Item Icon Anim
	-- ----------------
	local itemShrinkEnlargeAction	= self:getItemIconShrinkEnlargeAction()
	local targetedItemAction	= CCTargetedAction:create(self.itemRes.refCocosObj, itemShrinkEnlargeAction)

	----------
	-- Spawn
	-- --------
	local actionArray = CCArray:create()
	actionArray:addObject(explodedAction)
	actionArray:addObject(targetedItemAction)

	local spawn = CCSpawn:create(actionArray)

	---------------
	-- Anim Finish
	-- ----------
	local function animFinishFunc()

		assert(self.bubbleAnimState == self.BUBBLE_ANIM_STATE_EXPLODED_ANIM_PLAYING)
		self.bubbleAnimState = self.BUBBLE_ANIM_STATE_NONE

		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishAction = CCCallFunc:create(animFinishFunc)

	-------
	-- Seq 
	-- ----
	local seq = CCSequence:createWithTwoActions(spawn, animFinishAction)

	-- Run Action
	assert(self.bubbleAnimState == self.BUBBLE_ANIM_STATE_NONE)
	self.bubbleAnimState = self.BUBBLE_ANIM_STATE_EXPLODED_ANIM_PLAYING
	self.bubble:runAction(seq)
end

function BubbleItem:stopBubbleAnim(...)
	assert(#{...} == 0)

	if self.bubbleAnimState == self.BUBBLE_ANIM_STATE_NONE then
		--assert(false)
	elseif self.bubbleAnimState ==  self.BUBBLE_ANIM_STATE_NORMAL_ANIM_PLAYING then
		self:stopBubbleNormalAnim()
	elseif self.bubbleAnimState == self.BUBBLE_ANIM_STATE_EXPLODED_ANIM_PLAYING then
		self:stopBubbleExplodedAnim()
	elseif self.bubbleAnimState == self.BUBBLE_ANIM_STATE_TOUCHED_ANIM_PLAYING then
		self:stopBubbleTouchedAnim()
	end
end

function BubbleItem:getBubbleNormalAnim(...)
	assert(#{...} == 0)

	-- Action Translated From PC dialog.fla File
	-- See Animal/animal/art/dialog.fla, GameIntroducePanel MovieClip For Detail

	local animationInfo = {

		secondPerFrame = 1 / 24,

		object = {
			node = self.bubble,
			--originalWidth	= 67.05,
			--originalHeight	= 67.05
			deltaScaleX	= 180 / 67.05,		-- Scale The The Animation Data To Match Cur Object Size
			deltaScaleY	= 180 / 67.05,			
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

function BubbleItem:getBubbleTouchedAnim(...)
	assert(#{...} == 0)

	-- Action Translated From PC dialog.fla File
	-- See Animal/animal/art/dialog.fla, GameIntroducePanel MovieClip For Detail
	local animationInfo = {

		--secondPerFrame = 1 / 24,
		secondPerFrame = 0.6 / 20,

		object	= {
			node		= self.bubble,
			deltaScaleX	= 180 / 81.35,
			deltaScaleY	= 180 / 81.25,
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

function BubbleItem:playBubbleExplodedAnim(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	self:playBubbleExplodedAnimNew(animFinishCallback)
end

function BubbleItem:stopBubbleExplodedAnim(...)
	assert(#{...} == 0)

	assert(self.bubbleExplodedNew)

	for index = 1,24 do

		local bubbleClip = self.bubbleExplodedNew:getChildByName(tostring(index))
		assert(bubbleClip)

		bubbleClip:setVisible(false)
		bubbleClip:setPosition(ccp(self.data[index][1][1], self.data[index][1][2]))
	end

	self.bubble:stopAllActions()
	self.bubbleAnimState = self.BUBBLE_ANIM_STATE_NONE
end

function BubbleItem:playBubbleTouchedAnim(forever, animFinishCallback, ...)
	assert(type(forever) == "boolean")
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	---------------------
	-- Stop Previous Bubble Anim
	-- -----------------------
	self:stopBubbleAnim()

	-- Get Anim Action
	local bubbleTouchedAnim = self:getBubbleTouchedAnim()

	if forever then
		-- Repeate Forever
		bubbleTouchedAnim = CCRepeatForever:create(bubbleTouchedAnim)
	else
		-- Not Repeat Forever
		-- Anim Finish Callback
		local function callback()

			assert(self.bubbleAnimState == self.BUBBLE_ANIM_STATE_TOUCHED_ANIM_PLAYING)
			self.bubbleAnimState = self.BUBBLE_ANIM_STATE_NONE

			if animFinishCallback then
				animFinishCallback()
			end
		end
		local callbackAction = CCCallFunc:create(callback)

		local seq = CCSequence:createWithTwoActions(bubbleTouchedAnim, callbackAction)
		bubbleTouchedAnim = seq
	end
	
	assert(self.bubbleAnimState == self.BUBBLE_ANIM_STATE_NONE)
	self.bubbleAnimState = self.BUBBLE_ANIM_STATE_TOUCHED_ANIM_PLAYING
	self.bubble:runAction(bubbleTouchedAnim)
end

function BubbleItem:stopBubbleTouchedAnim(...)
	assert(#{...} == 0)
	
	self.bubble:stopAllActions()
	self.bubbleAnimState = self.BUBBLE_ANIM_STATE_NONE
end

function BubbleItem:playBubbleNormalAnim(repeatForever, ...)
	assert(type(repeatForever) == "boolean")
	assert(#{...} == 0)

	--------------------------
	-- Stop Previous Bubble Anim
	-- ----------------------
	self:stopBubbleAnim()

	self.itemRes:setScale(1)

	local bubbleNormalAnim = self:getBubbleNormalAnim()

	if repeatForever then
		bubbleNormalAnim = CCRepeatForever:create(bubbleNormalAnim)
	end

	assert(self.bubbleAnimState == self.BUBBLE_ANIM_STATE_NONE)
	self.bubbleAnimState = self.BUBBLE_ANIM_STATE_NORMAL_ANIM_PLAYING
	self.bubble:runAction(bubbleNormalAnim)
end

function BubbleItem:stopBubbleNormalAnim(...)
	assert(#{...} == 0)

	self.bubble:stopAllActions()
	self.bubbleAnimState = self.BUBBLE_ANIM_STATE_NONE
end

function BubbleItem:create(ui, itemType, ...)
	assert(ui ~= nil)
	assert(type(itemType) == "number")
	assert(#{...} == 0)

	local newBubbleItem = BubbleItem.new()
	newBubbleItem:init(ui, itemType)
	return newBubbleItem
end

function BubbleItem:hideNumber()
	self.numberLabel:setVisible(false)
	self.numberBg:setVisible(false)
end