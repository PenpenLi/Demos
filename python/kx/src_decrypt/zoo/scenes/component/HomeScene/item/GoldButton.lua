
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月 1日 20:11:06
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

---------------------------------------------------
-------------- GoldButton
---------------------------------------------------

assert(not GoldButton)
assert(IconButtonBase)

GoldButton = class(IconButtonBase)

function GoldButton:ctor()
end

function GoldButton:init(...)
	assert(#{...} == 0)

	-- Get UI Resource
	self.ui	= ResourceManager:sharedInstance():buildGroup("newGoldButton")
	assert(self.ui)

	-- ---------
	-- Init Base
	-- ---------
	IconButtonBase.init(self, self.ui)

	-- -------------
	-- Get UI Resource
	-- -------------
	self.glow = self.ui:getChildByName("glow");
	self.numberLabelPlaceholder	= self.wrapper:getChildByName("numberLabel")
	self.bubbleItemRes	= self.wrapper:getChildByName("bubbleItem")
	self.goldIcon = self.bubbleItemRes:getChildByName("placeHolder")
	if not self.goldIcon then debug.debug() end

	self.iconPos = IconButtonBasePos.LEFT

	assert(self.numberLabelPlaceholder)
	assert(self.bubbleItemRes)
	assert(self.glow);

	-----------------
	-- Init UI Component
	-- ------------------
	self.numberLabelPlaceholder:setVisible(false)
	self.glow:setVisible(false);
	-- Scale Small
	local config 	= UIConfigManager:sharedInstance():getConfig()
	local uiScale	= config.homeScene_uiScale
	self:setScale(uiScale)


	-------------------
	-- Get Data About UI 
	-- -----------------
	self.onTappedCallback	= false
	local placeholderPos 		= self.numberLabelPlaceholder:getPosition()
	local placeholderPreferredSize	= self.numberLabelPlaceholder:getPreferredSize()

	self.placeholderPreferredSize	= placeholderPreferredSize
	self.placeholderPos		= placeholderPos

	--------------------
	-- Craete UI Componenet
	-- --------------------
	self.bubbleItem = HomeSceneBubbleItem:create(self.bubbleItemRes)

	-- Clipping The Bubble
	local stencil		= LayerColor:create()
	stencil:setColor(ccc3(255,0,0))
	stencil:changeWidthAndHeight(132, 72.95 + 30)
	stencil:setPosition(ccp(0, -72.95))
	local cppClipping	= CCClippingNode:create(stencil.refCocosObj)
	local luaClipping	= ClippingNode.new(cppClipping)
	stencil:dispose()
	
	self.ui:addChild(luaClipping)
	self.bubbleItem:removeFromParentAndCleanup(false)
	luaClipping:addChild(self.bubbleItem)

	-- Monospace Label
	local charWidth		= 35
	local charHeight	= 35
	local charInterval	= 16
	local fntFile		= "fnt/hud.fnt"
	self.numberLabel	= LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self.numberLabel:setAnchorPoint(ccp(0,1))
	self.ui:addChild(self.numberLabel)

	self.numberLabel:setPosition(ccp(placeholderPos.x, placeholderPos.y))

	-- -------------
	-- Data
	-- ------------
	he_log_warning("mock gold number !")
	self.goldNumber	= UserManager:getInstance().user:getCash()

	----------------
	---- Update View
	--------------
	self:updateView()

	-- ----------------------------------
	-- Add Scheduler To Check Data Change
	-- -----------------------------------
	local function perFrameCallback()
		self.userRef	= UserManager.getInstance().user
		self:setGoldNumber(self.userRef:getCash())
	end
	 CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(perFrameCallback, 1/60, false)

	-- ---------------------------------
	-- Add Event Listener
	-- ---------------------------------
	local function onTapped(event)
		self:onTapped(event)
	end

	self.ui:setTouchEnabled(true, 0, true)
	self.ui:addEventListener(DisplayEvents.kTouchTap, onTapped)
end

function GoldButton:playHighlightAnim(...)
	assert(#{...} == 0)

	local highlightRes = ResourceManager:sharedInstance():buildSprite("goldHighlightWrapper")
	self.bubbleItem:playHighlightAnim(highlightRes)
end

function GoldButton:centerLabel(...)
	assert(#{...} == 0)

	local curLabelPos 	= self.numberLabel:getPosition()
	local curLabelSize	= self.numberLabel:getContentSize()

	local deltaWidth	= self.placeholderPreferredSize.width - curLabelSize.width
	self.numberLabel:setPositionX(self.placeholderPos.x + deltaWidth/2)
	

	local deltaHeight	= self.placeholderPreferredSize.height - curLabelSize.height
	self.numberLabel:setPositionY(self.placeholderPos.y - deltaHeight/2)
end

function GoldButton:onTapped(event, ...)
	assert(#{...} == 0)

	if self.onTappedCallback then
		self.onTappedCallback()
	end
end

function GoldButton:setOnTappedCallback(onTappedCallback, ...)
	assert(type(onTappedCallback) == "function")
	assert(#{...} == 0)

	self.onTappedCallback = onTappedCallback
end

function GoldButton:setGoldNumber(number, ...)
	assert(number)
	assert(#{...} == 0)

	if self.goldNumber == number then
		return
	else
		self.goldNumber = number
	end
end

function GoldButton:updateView(...)
	assert(#{...} == 0)

	local delay = CCDelayTime:create(2/30)

	local function callFunc()
		self.numberLabel:setString(tostring(self.goldNumber))
		self:centerLabel()
	end
	local callFuncAction = CCCallFunc:create(callFunc)

	local seq = CCSequence:createWithTwoActions(delay, callFuncAction)
	self:runAction(seq)
end

function GoldButton:create(...)
	assert(#{...} == 0)

	local newGoldButton = GoldButton.new()
	newGoldButton:init()
	
	return newGoldButton
end

function GoldButton:delayCreateTipLeft(...)
	self.tip = IconButtonBase.delayCreateTipLeft(self);
	self.tipPos = ccp(self.tipPos.x - 50, self.tipPos.y);
	self.tip.setPosition(self.tipPos);

	self.tip:setScale(self.tip:getScale()/self:getScale())

	return self.tip;
end

function GoldButton:playOnlyTipAnim( ... )
	IconButtonBase.playOnlyTipAnim(self);
	self.glow:setVisible(true);

	local animationTime = 0.5;
	local fadeIn = CCEaseSineInOut:create(CCFadeIn:create(animationTime))
	local fadeOut = CCEaseSineInOut:create(CCFadeOut:create(animationTime))
	local seq = CCSequence:createWithTwoActions(fadeIn, fadeOut)
	assert(self.glow);
	self.glow:runAction(CCRepeatForever:create(seq))
	self:setTipString(Localization:getInstance():getText("buy.gold.icon.tip"));
end

function GoldButton:getFlyToPosition()
	local pos = self.goldIcon:getPosition()
	local size = self.goldIcon:getGroupBounds().size
	return self.bubbleItemRes:convertToWorldSpace(ccp(pos.x, pos.y))
end

function GoldButton:getFlyToSize()
	local size = self.goldIcon:getGroupBounds().size
	size.width, size.height = size.width, size.height
	return size
end

function GoldButton:stopHasNotificationAnim(...)
	IconButtonBase.stopHasNotificationAnim(self);
	self.glow:stopAllActions();
	self.glow:setVisible(false);

	if self.onTappedCallback then
		self.onTappedCallback()
	end
	print("stopHasNotificationAnim in goldbutton called!");
end