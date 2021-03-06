
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014年01月 6日 11:00:24
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

-- require "zoo.scenes.component.HomeScene.animation.AlignToScreenEdge"

IconButtonBasePos	= {
	LEFT	= 1,
	RIGHT	= 2,
}
---------------------------------------------------
-------------- IconButtonBase
---------------------------------------------------

assert(not IconButtonBase)
assert(BaseUI)
IconButtonBase = class(BaseUI)

function IconButtonBase:ctor( ... )
	self.playTipPriority = 10000
	self.tipState = IconTipState.kNormal
end

function IconButtonBase:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	-- Init Base Class
	BaseUI.init(self, ui)
	
	-- For Play The Jump Anim Which Require Anchor Point (0.5, 0) 
	self.wrapper	= self.ui:getChildByName("wrapper")
	assert(self.wrapper)

	------------------
	-- Get Data About UI
	-- --------------------
	self.wrapperSize	= self.wrapper:getGroupBounds().size
	self.wrapperSize	= {width = self.wrapperSize.width, height = self.wrapperSize.height}
	self.wrapperWidth	= self.wrapperSize.width
	self.wrapperHeight	= self.wrapperSize.height

	-- Scale Small
	local config 	= UIConfigManager:sharedInstance():getConfig()
	local uiScale	= config.homeScene_uiScale
	--self:setScale(uiScale)

	self.iconPos			= IconButtonBasePos.RIGHT

	self.tip		= false

	self.tipOriginalWidth = 200
	self.tipOriginalHeight = 45

	self.tipLeftMarginToIconBtn	= 20
	self.tipPos			= false
	self.tipLabelTxt		= "default tip text"
	self.tipLabelSize		= false

	------------------
	-- Add Event Listener
	-- ------------------
	local function onTouch()
		if self.id and not IconButtonManager:getInstance():todayIsShow(self) then 
			IconButtonManager:getInstance():writeShowTimeInQueue(self)
			IconButtonManager:getInstance().clickReplaceScene = self.clickReplaceScene
		end
		self:stopHasNotificationAnim()
	end
	self.wrapper:setTouchEnabled(true, 0, true)
	self.wrapper:ad(DisplayEvents.kTouchTap, onTouch)

	if __ANDROID then
		local function refreshTexture()
			if self.isDisposed then
				GlobalEventDispatcher:getInstance():removeEventListener(kGlobalEvents.kEnterForeground, refreshTexture)
				return
			end
			self:runAction(CCCallFunc:create(function()
				if self.isDisposed then return end
				if self.tip then
					if self.tipLabel then
						self.tipLabel:setString(self.tipLabelTxt)
					end
				end
			end))
		end
		GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kEnterForeground, refreshTexture)
	end
end

function IconButtonBase:setTipString(str)
	assert(type(str) == "string")
	self.tipLabelTxt = str
	if self.tip then
		if self.tipLabel and self.tip:contains(self.tipLabel) then 
			self.tipLabel:removeFromParentAndCleanup(true)
			self.tipLabel = nil
		end
		self.tipLabel = TextField:create(str, nil, 20)
		self.tipLabel:setColor(ccc3(147, 71, 9))
		self.tip:addChild(self.tipLabel)

		local tipLabelSize = self.tipLabel:getContentSize()
		local tipLeftExceedTxtWidth	= 10
		local tipRightExceedTxtWidth = 10
		local newTipWidth = tipLabelSize.width + tipLeftExceedTxtWidth + tipRightExceedTxtWidth 

		self.tip:getChildByName("tipBg"):setPreferredSize(CCSizeMake(newTipWidth, self.tipOriginalHeight))
		local tipArrow = self.tip:getChildByName("tipArrow")

		if _G.__use_small_res then 
			local arrowSize = tipArrow:getContentSize()
			local scale = self.tipOriginalHeight/arrowSize.height
			tipArrow:setScale(scale)
		end

		if self.iconPos == IconButtonBasePos.LEFT then
			self.tipLabel:setPosition(ccp(tipLabelSize.width/2 + tipLeftExceedTxtWidth,-self.tipOriginalHeight/2))

			local tipArrowPos = ccp(178, 0)
			local posXDelta = newTipWidth - 200
			tipArrow:setPosition(ccp(tipArrowPos.x + posXDelta, tipArrowPos.y))

			self.tipPos = self:getTipPos()
			self.tip:setPosition(self.tipPos)
		elseif self.iconPos == IconButtonBasePos.RIGHT then
			local tipArrowPos = ccp(0, 0)
			tipArrow:setPosition(ccp(tipArrowPos.x, tipArrowPos.y))

			self.tipLabel:setPosition(ccp(tipLabelSize.width/2 + tipLeftExceedTxtWidth + 23,-self.tipOriginalHeight/2))
		end
	end
end

function IconButtonBase:getTipPos()
	local tipSize = self.tip:getGroupBounds().size

	local tipPos = nil
	if self.iconPos == IconButtonBasePos.LEFT then
		self.wrapperSize = self.wrapper:getGroupBounds().size
		local deltaHeight = self.wrapperSize.height - tipSize.height
		tipPos = ccp(-tipSize.width - self.tipLeftMarginToIconBtn, -deltaHeight / 2)
	elseif self.iconPos == IconButtonBasePos.RIGHT then
		self.wrapperSize = self.wrapper:getGroupBounds().size
		local deltaHeight = self.wrapperSize.height - tipSize.height
		tipPos = ccp(self.wrapperSize.width + self.tipLeftMarginToIconBtn, -deltaHeight / 2)
	end
	return tipPos
end

function IconButtonBase:delayCreateTipRight()
	if not self.tip	then
		self.tip = ResourceManager:sharedInstance():buildGroup("tip/tipRight")
		self.ui:addChild(self.tip)

		self.tipPos	= self:getTipPos()
		self.tip:setPosition(self.tipPos)

		self:setTipString(self.tipLabelTxt)
		self.tip:setVisible(false)
	end

	return self.tip
end

function IconButtonBase:delayCreateTipLeft()
	if not self.tip	then
		self.tip = ResourceManager:sharedInstance():buildGroup("tip/tipLeft")
		self.ui:addChild(self.tip)

		self.tipPos	= self:getTipPos()
		self.tip:setPosition(self.tipPos)

		self:setTipString(self.tipLabelTxt)
		self.tip:setVisible(false)
	end

	return self.tip
end

function IconButtonBase:_createIconAction()
	local secondPerFrame	= 1 / 60

	-- Init Action
	local function initActionFunc()
		self.wrapper:setScale(1)
	end
	local initAction = CCCallFunc:create(initActionFunc)

	local scale1	= CCScaleTo:create(secondPerFrame * (13 - 1), 1.076,	0.875)
	local scale2	= CCScaleTo:create(secondPerFrame * (25 - 13),  0.911, 1.12)
	local scale3	= CCScaleTo:create(secondPerFrame * (36 - 25),  0.981, 1.024)
	local scale4	= CCScaleTo:create(secondPerFrame * (50 - 36),  1, 1)

	local actionArray = CCArray:create()
	actionArray:addObject(scale1)
	actionArray:addObject(scale2)
	actionArray:addObject(scale3)
	actionArray:addObject(scale4)

	local seq 	= CCSequence:create(actionArray)
	local targetSeq	= CCTargetedAction:create(self.wrapper.refCocosObj, seq)
	return targetSeq
end

function IconButtonBase:_createShiftingTipActionRight()
	local secondPerFrame 	= 1 / 60
	local tip		= self:delayCreateTipRight()

	-- Init Action
	local function initActionFunc()
		tip:setVisible(true)
		tip:setPosition(ccp(self.tipPos.x, self.tipPos.y))
	end
	local initAction	= CCCallFunc:create(initActionFunc)

	-- Shifting Action
	local moveTo1	= CCMoveTo:create(secondPerFrame * (12-1), 	ccp(self.tipPos.x + 7.15 - 3.15, self.tipPos.y))
	local moveTo2	= CCMoveTo:create(secondPerFrame * (22 - 12),	ccp(self.tipPos.x - 8.85 - 3.15, self.tipPos.y))
	local moveTo3	= CCMoveTo:create(secondPerFrame * (32 - 22),	ccp(self.tipPos.x - 6.75 - 3.15, self.tipPos.y))
	local moveTo4	= CCMoveTo:create(secondPerFrame * (50 - 32),	ccp(self.tipPos.x + 3.15 - 3.15, self.tipPos.y))
	
	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(initAction)
	actionArray:addObject(moveTo1)
	actionArray:addObject(moveTo2)
	actionArray:addObject(moveTo3)
	actionArray:addObject(moveTo4)

	local seq = CCSequence:create(actionArray)
	local targetSeq	= CCTargetedAction:create(tip.refCocosObj, seq)

	return targetSeq
end

function IconButtonBase:_createShiftingTipActionLeft()
	print("IconButtonBase:_createShiftingTipActionLeft Called !")

	local secondPerFrame 	= 1 / 60
	local tip		= self:delayCreateTipLeft()

	-- Init Action
	local function initActionFunc()
		tip:setVisible(true)
		tip:setPosition(ccp(self.tipPos.x, self.tipPos.y))
	end
	local initAction	= CCCallFunc:create(initActionFunc)

	-- Shifting Action
	local moveTo1	= CCMoveTo:create(secondPerFrame * (12-1), 	ccp(self.tipPos.x - (7.15 - 3.15	), self.tipPos.y))
	local moveTo2	= CCMoveTo:create(secondPerFrame * (22 - 12),	ccp(self.tipPos.x + (8.85 + 3.15	), self.tipPos.y))
	local moveTo3	= CCMoveTo:create(secondPerFrame * (32 - 22),	ccp(self.tipPos.x + (6.75 + 3.15	), self.tipPos.y))
	local moveTo4	= CCMoveTo:create(secondPerFrame * (50 - 32),	ccp(self.tipPos.x - (3.15 - 3.15	), self.tipPos.y))
	
	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(initAction)
	actionArray:addObject(moveTo1)
	actionArray:addObject(moveTo2)
	actionArray:addObject(moveTo3)
	actionArray:addObject(moveTo4)

	local seq = CCSequence:create(actionArray)
	local targetSeq	= CCTargetedAction:create(tip.refCocosObj, seq)

	return targetSeq
end

function IconButtonBase:setTipPosition(pos, ...)
	self.iconPos = pos
end

function IconButtonBase:playHasNotificationAnim(...)
	self:playOnlyIconAnim()
	self:playOnlyTipAnim()
end
function IconButtonBase:stopHasNotificationAnim()
	self:stopOnlyIconAnim()
	self:stopOnlyTipAnim()
end

function IconButtonBase:playOnlyIconAnim()
	self:stopOnlyIconAnim()

	local action = CCRepeatForever:create(self:_createIconAction())
	action:setTag(100)
	self:runAction(action)
end

function IconButtonBase:playOnlyTipAnim()
	self:stopOnlyTipAnim()

	local tipAnim = nil
	if self.iconPos == IconButtonBasePos.LEFT then
		tipAnim	= self:_createShiftingTipActionLeft()
	elseif self.iconPos == IconButtonBasePos.RIGHT then
		tipAnim	= self:_createShiftingTipActionRight()
	end

	local action	= CCRepeatForever:create(tipAnim)
	action:setTag(200)
	self:runAction(action)
end



function IconButtonBase:stopOnlyIconAnim()
	self:stopActionByTag(100)
	self.wrapper:setScale(1)
end

function IconButtonBase:stopOnlyTipAnim()
	self:stopActionByTag(200)
	if self.tip then
		self.tip:removeFromParentAndCleanup(true)
		self.tip = nil
	end
end

function IconButtonBase:getGroupBounds(...)
	assert(#{...} == 0)

	local result = {}
	result.size = CCSizeMake(self.wrapperWidth, self.wrapperHeight)
	return result
end


function IconButtonBase:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newIconButtonBase = IconButtonBase.new()
	newIconButtonBase:init(ui)
	return newIconButtonBase
end

-- ----------------------
-- the fllowing functions are removed from cloudbutton
-- ------------------------
-- function IconButtonBase:alignToScreenRight(...)
-- 	assert(#{...} == 0)

-- 	if not self.originalPositionX then
-- 		self.originalPositionX	= self:getPositionX()
-- 		self.originalPositionY	= self:getPositionY()
-- 	end

-- 	self.alignToScreenEdge:alignToRight(0.2)
-- end

-- function IconButtonBase:alignToScreenLeft(...)
-- 	assert(#{...} == 0)

-- 	if not self.originalPositionX then
-- 		self.originalPositionX	= self:getPositionX()
-- 		self.originalPositionY	= self:getPositionY()
-- 	end

-- 	self.alignToScreenEdge:alignToLeft(0.2)
-- end

-- function IconButtonBase:restoreToOriginalPosition(...)
-- 	assert(#{...} == 0)

-- 	assert(self.originalPositionX)
-- 	assert(self.originalPositionY)

-- 	local moveToAction	= CCMoveTo:create(0.5, ccp(self.originalPositionX, self.originalPositionY))
-- 	self:stopAllActions()
-- 	self:runAction(moveToAction)
-- end
function IconButtonBase:showWeeklyBtnTutor(key, textKey)
	local scene = HomeScene:sharedInstance()
	local layer = Layer:create()
	local pos = self:getPosition()
	local parent = self:getParent()
	local position = parent:convertToWorldSpace(pos)
	local mask = GameGuideUI:mask(0xCC, 1, ccp(position.x - 10, position.y - self.wrapperHeight - 20),
		nil, true, self.wrapperWidth + 20, self.wrapperHeight + 20, false)
	mask:stopAllActions()
	mask.setFadeIn(0.3, 0.4)
	local function onTimeOut()
		local function onTouch()
			layer:removeFromParentAndCleanup(true)
			CCUserDefault:sharedUserDefault():setBoolForKey(key, true)
			CCUserDefault:sharedUserDefault():flush()
		end
		mask:addEventListener(DisplayEvents.kTouchTap, onTouch)
	end
	mask:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(touchDelay), CCCallFunc:create(onTimeOut)))
	layer:addChild(mask)
	local action = {text = textKey, maskPos = ccp(536, 940), multRadius=1.1 ,
				panType = "up", panAlign = "winY", panPosY = 600,
				maskDelay = 0.3,maskFade = 0.4 ,panDelay = 0.5, touchDelay = 1}
	local panel = GameGuideUI:panelS(nil, action, true)
	layer:addChild(panel)
	scene.guideLayer:addChild(layer)
end
