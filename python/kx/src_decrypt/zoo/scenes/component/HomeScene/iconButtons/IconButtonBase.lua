
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
	self.wrapperWidth	= self.wrapperSize.width
	self.wrapperHeight	= self.wrapperSize.height

	-- Scale Small
	local config 	= UIConfigManager:sharedInstance():getConfig()
	local uiScale	= config.homeScene_uiScale
	--self:setScale(uiScale)

	self.iconPos			= IconButtonBasePos.RIGHT

	self.tip		= false

	self.tipOriginalWidth		= false
	self.tipOriginalHeight		= false

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

end

function IconButtonBase:setTipString(str, ...)
	assert(type(str) == "string")
	assert(#{...} == 0)

	self.tipLabelTxt	= str
	if self.tip then

		local tipLabel	= self.tip:getChildByName("label")
		tipLabel:setString(str)

		---- Adjust Bg Size, According To Text Width
		--self.tipLabelSize = tipLabel:getContentSize()
		--local tipLeftExceedTxtWidth	= 34
		--local tipRightExceedTxtWidth	= 20
		--local newTipWidth		= self.tipLabelSize.width + tipLeftExceedTxtWidth + tipRightExceedTxtWidth 
		--if newTipWidth < self.tipOriginalWidth then
		--	newTipWidth = self.tipOriginalWidth
		--end
		--self.tip:getChildByName("scale9Bg"):setPreferredSize(CCSizeMake(newTipWidth, self.tipOriginalHeight))
	end
end

function IconButtonBase:delayCreateTip(...)
	assert(#{...} == 0)

	if not self.tip	then
	
		-- Get UI
		self.tip	= ResourceManager:sharedInstance():buildGroup("iconTip")
		self.ui:addChild(self.tip)

		-- Calculate Tip Pos
		local tipSize	= self.tip:getGroupBounds().size
		self.tipOriginalWidth	= tipSize.width
		self.tipOriginalHeight	= tipSize.height

		self.wrapperSize	= self.wrapper:getGroupBounds().size
		local deltaHeight	= self.wrapperSize.height - tipSize.height
		self.tipPos		= ccp(self.wrapperSize.width + self.tipLeftMarginToIconBtn,
						-deltaHeight / 2)

		self.tip:setPosition(self.tipPos)
		self:setTipString(self.tipLabelTxt)
		self.tip:setVisible(false)
	end

	return self.tip
end

function IconButtonBase:delayCreateTipLeft(...)

	if not self.tip	then
	
		-- Get UI
		--self.tip	= ResourceManager:sharedInstance():buildGroup("iconTip")
		self.tip	= ResourceManager:sharedInstance():buildGroup("iconTipLeft")
		self.ui:addChild(self.tip)

		-- Calculate Tip Pos
		local tipSize	= self.tip:getGroupBounds().size
		self.tipOriginalWidth	= tipSize.width
		self.tipOriginalHeight	= tipSize.height

		self.wrapperSize	= self.wrapper:getGroupBounds().size
		local deltaHeight	= self.wrapperSize.height - tipSize.height
		self.tipPos		= ccp(-tipSize.width - self.tipLeftMarginToIconBtn,
						-deltaHeight / 2)

		self.tip:setPosition(self.tipPos)
		self:setTipString(self.tipLabelTxt)
		self.tip:setVisible(false)
	end

	return self.tip
end

function IconButtonBase:_createIconAction(...)
	assert(#{...} == 0)

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

function IconButtonBase:_createShiftingTipAction(...)
	assert(#{...} == 0)

	local secondPerFrame 	= 1 / 60
	local tip		= self:delayCreateTip()

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

function IconButtonBase:_createShiftingTipActionLeft(...)
	assert(#{...} == 0)

	print("IconButtonBase:_createShiftingTipActionLeft Called !")

	local secondPerFrame 	= 1 / 60
	--local tip		= self:delayCreateTip()
	local tip		= self:delayCreateTipLeft()

	-- Init Action
	local function initActionFunc()
		tip:setVisible(true)
		tip:setPosition(ccp(self.tipPos.x, self.tipPos.y))
	end
	local initAction	= CCCallFunc:create(initActionFunc)

	---- Shifting Action
	--local moveTo1	= CCMoveTo:create(secondPerFrame * (12-1), 	ccp(self.tipPos.x + 7.15 - 3.15, self.tipPos.y))
	--local moveTo2	= CCMoveTo:create(secondPerFrame * (22 - 12),	ccp(self.tipPos.x - 8.85 - 3.15, self.tipPos.y))
	--local moveTo3	= CCMoveTo:create(secondPerFrame * (32 - 22),	ccp(self.tipPos.x - 6.75 - 3.15, self.tipPos.y))
	--local moveTo4	= CCMoveTo:create(secondPerFrame * (50 - 32),	ccp(self.tipPos.x + 3.15 - 3.15, self.tipPos.y))
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

	----
	--local testdelay = CCDelayTime:create(0)
	--tip:setVisible(true)
	--return testdelay
end

function IconButtonBase:setTipPosition(pos, ...)
	self.iconPos = pos
end

function IconButtonBase:playHasNotificationAnim(...)
	self:playOnlyIconAnim()
	self:playOnlyTipAnim()
end
function IconButtonBase:stopHasNotificationAnim(...)
	self:stopOnlyIconAnim()
	self:stopOnlyTipAnim()
end

function IconButtonBase:playOnlyIconAnim( ... )
	self:stopOnlyIconAnim()

	local action = CCRepeatForever:create(self:_createIconAction())
	action:setTag(100)
	self:runAction(action)
end

function IconButtonBase:playOnlyTipAnim(...)
	self:stopOnlyTipAnim()

	local tipAnim = nil
	if self.iconPos == IconButtonBasePos.LEFT then
		tipAnim	= self:_createShiftingTipActionLeft()
	elseif self.iconPos == IconButtonBasePos.RIGHT then
		tipAnim	= self:_createShiftingTipAction()
	end

	local action	= CCRepeatForever:create(tipAnim)
	action:setTag(200)
	self:runAction(action)
end



function IconButtonBase:stopOnlyIconAnim( ... )
	self:stopActionByTag(100)
	self.wrapper:setScale(1)
end

function IconButtonBase:stopOnlyTipAnim( ... )
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