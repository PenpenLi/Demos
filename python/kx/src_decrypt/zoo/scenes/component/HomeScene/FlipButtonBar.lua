

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê09ÔÂ23ÈÕ 17:34:37
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com


require "zoo.scenes.component.gameplayScene.ToolButton"


assert(not FlipButtonBarState)

FlipButtonBarState = {
	CLOSED	= 1,
	OPENING	= 2,
	OPENED	= 3,
	CLOSING	= 4
}


---------------------------------------------------
-------------- FlipButtonBar
---------------------------------------------------

assert(not FlipButtonBar)
assert(RegionLayoutBar)
FlipButtonBar = class(RegionLayoutBar)

function FlipButtonBar:ctor()
end
function FlipButtonBar:dispose()
	if self.toolBarOpenAction then
		self.toolBarOpenAction:release()
		self.toolBarOpenAction = nil
	end
	if self.toolBarCloseAction then
		self.toolBarCloseAction:release()
		self.toolBarCloseAction = nil
	end

	RegionLayoutBar.dispose(self)
end

function FlipButtonBar:init(...)
	assert(#{...} == 0)

	-- Get Screen Size
	self.visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	self.visibleSize	= CCDirector:sharedDirector():getVisibleSize()

	local oneItemWidth	= 140

	-- Init Base
	RegionLayoutBar.init(self, self.visibleSize.width - oneItemWidth , self.visibleSize.height, LayoutBarAlign.HORIZONTAL_CENTER, LayoutBarAlign.BOTTOM, LayoutBarDirection.HORIZONTAL)

	self:setPosition(ccp(self.visibleOrigin.x + oneItemWidth, self.visibleOrigin.y + self.visibleSize.height))

	-- -----------------------------
	-- Create Flip Button Component
	-- ------------------------------
	self.tool1 = ToolButton:create(ToolButtonToolType.EXCHANGE)
	self:addItem(self.tool1)

	self.tool2 = ToolButton:create(ToolButtonToolType.EXCHANGE)
	self:addItem(self.tool2)

	self.tool3 = ToolButton:create(ToolButtonToolType.EXCHANGE)
	self:addItem(self.tool3)

	self.tool4 = ToolButton:create(ToolButtonToolType.EXCHANGE)
	self:addItem(self.tool4)


	---------------------------
	---- Init Button
	-----------------------
	self.tool1:flipToBack(0, 90)
	self.tool2:flipToBack(0, 90)
	self.tool3:flipToBack(0, 90)


	----------------------------
	-- Construct Open Animation
	--------------------------
	local tool4CloseAction	= self.tool4:getFlipToBackAction(0.5, 90)

	local tool3Delay	= CCDelayTime:create(0.5 * 1)
	local tool3OpenAction	= self.tool3:getFlipToFrontAction(0.5, 90)
	local tool3Seq		= CCSequence:createWithTwoActions(tool3Delay, tool3OpenAction)

	local tool2Delay	= CCDelayTime:create(0.5 * 2)
	local tool2OpenAction	= self.tool2:getFlipToFrontAction(0.5, 90)
	local tool2Seq		= CCSequence:createWithTwoActions(tool2Delay, tool2OpenAction)

	local tool1Delay	= CCDelayTime:create(0.5 * 3)
	local tool1OpenAction	= self.tool1:getFlipToFrontAction(0.5, 90)
	local tool1Seq		= CCSequence:createWithTwoActions(tool1Delay, tool1OpenAction)


	local actionArray = CCArray:create()
	actionArray:addObject(tool4CloseAction)
	actionArray:addObject(tool3Seq)
	actionArray:addObject(tool2Seq)
	actionArray:addObject(tool1Seq)

	self.toolBarOpenAction = CCSpawn:create(actionArray)
	self.toolBarOpenAction:retain()

	---------------------------
	---- Construct Close Animation
	-----------------------------
	local tool1CloseAction	= self.tool1:getFlipToBackAction(0.5, 90)

	local tool2Delay	= CCDelayTime:create(0.5 * 1)
	local tool2CloseAction	= self.tool2:getFlipToBackAction(0.5, 90)
	local tool2Seq		= CCSequence:createWithTwoActions(tool2Delay, tool2CloseAction)

	local tool3Delay	= CCDelayTime:create(0.5 * 2)
	local tool3CloseAction	= self.tool3:getFlipToBackAction(0.5, 90)
	local tool3Seq		= CCSequence:createWithTwoActions(tool3Delay, tool3CloseAction)

	local tool4Delay	= CCDelayTime:create(0.5 * 3)
	local tool4OpenAction	= self.tool4:getFlipToFrontAction(0.5, 90)
	local tool4Seq		= CCSequence:createWithTwoActions(tool4Delay, tool4OpenAction)

	local actionArray = CCArray:create()
	actionArray:addObject(tool1CloseAction)
	actionArray:addObject(tool2Seq)
	actionArray:addObject(tool3Seq)
	actionArray:addObject(tool4Seq)

	self.toolBarCloseAction	= CCSpawn:create(actionArray)
	self.toolBarCloseAction:retain()

	-----------------------------
	---- Data About 
	-------------------------
	
	self.curState = FlipButtonBarState.CLOSED

	------------------------------
	---- Add Event Listener
	------------------------------
	local function onTool4Tapped(event)
		self:onTool4Tapped(event)
	end

	self.tool4:addEventListener(DisplayEvents.kTouchTap, onTool4Tapped)
end


function FlipButtonBar:onTool4Tapped(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchTap)
	assert(#{...} == 0)

	local function finishedCallback()

		if self.curState == FlipButtonBarState.CLOSING then

			self.curState = FlipButtonBarState.CLOSED

		elseif self.curState == FlipButtonBarState.OPENING then

			self.curState = FlipButtonBarState.OPENED
		else 
			assert(false)
		end
	end

	local callback = CCCallFunc:create(finishedCallback)


	if self.curState == FlipButtonBarState.CLOSED then
		self.curState = FlipButtonBarState.OPENING

		local seq = CCSequence:createWithTwoActions(self.toolBarOpenAction, callback)
		self:runAction(seq)


	elseif self.curState == FlipButtonBarState.OPENING then

	elseif self.curState == FlipButtonBarState.OPENED then
		self.curState = FlipButtonBarState.CLOSING

		local seq = CCSequence:createWithTwoActions(self.toolBarCloseAction, callback)
		self:runAction(seq)
		
	elseif self.curState == FlipButtonBarState.CLOSING then

	else 
		assert(false)
	end
end

function FlipButtonBar:create(...)
	assert(#{...} == 0)

	local newFlipButtonBar = FlipButtonBar.new()
	newFlipButtonBar:init()
	return newFlipButtonBar
end
