
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年12月13日 20:33:34
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- ButtonWithShadow
---------------------------------------------------

assert(not ButtonWithShadow)
ButtonWithShadow = class(BaseUI)

function ButtonWithShadow:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	self.ui = ui

	------------------
	-- Init Base Class
	-- ------------
	BaseUI.init(self, ui)

	-------------------
	-- Get UI Component
	-- ----------------

	self.highlights = {}
	self.bgs	= {}

	-- Get Label
	-- self.ui:debugPrintAllChildren()
	self.labelPh		= self.ui:getChildByName("label")
	self.labelAdjustRect	= self.ui:getChildByName("label_fontSize")

	assert(self.labelPh)
	--assert(self.labelAdjustRect)

	self.label	= TextField:createWithUIAdjustment(self.labelAdjustRect, self.labelPh) 
	self.ui:addChild(self.label)

	-- Get Each Color
	self.greenHighlight	= self.ui:getChildByName("greenHighlight")
	self.blueHighlight	= self.ui:getChildByName("blueHighlight")
	self.yellowHighlight	= self.ui:getChildByName("yellowHighlight")
	self.greyHighlight	= self.ui:getChildByName("greyHightlight")

	if self.greenHighlight	then	table.insert(self.highlights, self.greenHighlight)	end
	if self.blueHighlight	then	table.insert(self.highlights, self.blueHighlight)	end
	if self.yellowHighlight	then	table.insert(self.highlights, self.yellowHighlight)	end
	if self.greyHighlight	then	table.insert(self.highlights, self.greyHighlight) 	end

	self.greenBg		= self.ui:getChildByName("greenBg")
	self.blueBg		= self.ui:getChildByName("blueBg")
	self.yellowBg		= self.ui:getChildByName("yellowBg")
	self.greyBg		= self.ui:getChildByName("greyBg")

	if self.greenBg		then	table.insert(self.bgs, self.greenBg)	end
	if self.blueBg		then	table.insert(self.bgs, self.blueBg)	end
	if self.yellowBg	then	table.insert(self.bgs, self.yellowBg)	end
	if self.greyBg		then	table.insert(self.bgs, self.greyBg)	end

	self.ui:setTouchEnabled(true, 0, true)
	ui:setButtonMode(true)

	----------
	-- Data
	-- --------

	if self.blueBg and self.blueBg:is(Scale9SpriteColorAdjust) then
		self.blueBg:adjustColor(kColorBlueConfig[1],kColorBlueConfig[2],kColorBlueConfig[3],kColorBlueConfig[4])
		self.blueBg:applyAdjustColorShader()
	end

	self.curColor	= "default"
end


function ButtonWithShadow:createAnimation(backgroundName)
	local startButton = self.ui --:getChildByName("btnWithoutShadow")
	startButton:setButtonMode(false)
	local deltaTime = 0.9
	local animations = CCArray:create()
	animations:addObject(CCScaleTo:create(deltaTime, 0.98, 1.03))
	animations:addObject(CCScaleTo:create(deltaTime, 1.01, 0.96))
	animations:addObject(CCScaleTo:create(deltaTime, 0.98,1.03))
	animations:addObject(CCScaleTo:create(deltaTime, 1,1))
	startButton:runAction(CCRepeatForever:create(CCSequence:create(animations)))

	backgroundName = backgroundName or "greenBtnBg"
	local btnWithoutShadow = startButton:getChildByName(backgroundName)
	local function __onButtonTouchBegin( evt )
		if btnWithoutShadow and not btnWithoutShadow.isDisposed then
			btnWithoutShadow:setOpacity(200)
		end
	end
	local function __onButtonTouchEnd( evt )
		if btnWithoutShadow and not btnWithoutShadow.isDisposed then
			btnWithoutShadow:setOpacity(255)
		end
	end
	startButton:addEventListener(DisplayEvents.kTouchBegin, __onButtonTouchBegin)
	startButton:addEventListener(DisplayEvents.kTouchEnd, __onButtonTouchEnd)
end

function ButtonWithShadow:_hideAllBg(...)
	assert(#{...} == 0)

	for k,v in ipairs(self.highlights) do
		v:setVisible(false)
	end
end

function ButtonWithShadow:_hideAllHighlight(...)
	assert(#{...} == 0)

	for k,v in ipairs(self.bgs) do
		v:setVisible(false)
	end
end

function ButtonWithShadow:changeToColor(color, ...)
	assert(type(color) == "string")
	assert(#{...} == 0)

	local lowerColor = string.lower(color)

	self:_hideAllBg()
	self:_hideAllHighlight()

	if lowerColor == "green" then
		if self.greenHightlight then self.greenHightlight:setVisible(true) end
		if self.greenBg		then self.greenBg:setVisible(true) end
		self.curColor = "green"
		self.normalColor = self.curColor

	elseif lowerColor == "blue" then
		if self.blueHighlight	then self.blueHighlight:setVisible(true) end
		if self.blueBg		then self.blueBg:setVisible(true) end
		self.curColor = "blue"
		self.normalColor = self.curColor

	elseif lowerColor == "yellow" then
		if self.yellowHighlight then self.yellowHighlight:setVisible(true) end
		if self.yellowBg	then self.yellowBg:setVisible(true)	end
		self.curColor = "yellow"
		self.normalColor = self.curColor

	elseif lowerColor == "grey" then
		if self.greyHighlight	then self.greyHighlight:setVisible(true) end
		if self.greyBg		then self.greyBg:setVisible(true)	end
		self.curColor = "grey"

	end
end

function ButtonWithShadow:addEventListener(event, func, context)
	self.ui:addEventListener(event, func, context)
end

function ButtonWithShadow:enable(enable)
	if not enable then 
		self:changeToColor('grey') 
	elseif self.normalColor then
		self:changeToColor(self.normalColor)
	end

	self.ui:setTouchEnabled(enable, 0, enable)
	self.ui:setButtonMode(enable)
end

function ButtonWithShadow:getColor(...)
	assert(#{...} == 0)

	return self.curColor
end

function ButtonWithShadow:setString(str, ...)
	assert(type(str) == "string")
	assert(#{...} == 0)

	if self.label and self.label.refCocosObj then
		self.label:setString(str)
	end
	--self.label:setToParentCenterHorizontal()
	--self.label:setToParentCenterVertical()
end

function ButtonWithShadow:getLabel(...)
	assert(#{...} == 0)

	return self.label
end

function ButtonWithShadow:manualAdjustBtnPos(dx, dy, ...)
	assert(type(dx) == "number")
	assert(type(dy) == "number")
	assert(#{...} == 0)

	local curPos	= self.label:getPosition()
	self.label:setPosition(ccp(curPos.x + dx, curPos.y + dy))
end

function ButtonWithShadow:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newButtonWithShadow = ButtonWithShadow.new()
	newButtonWithShadow:init(ui)
	return newButtonWithShadow
end
