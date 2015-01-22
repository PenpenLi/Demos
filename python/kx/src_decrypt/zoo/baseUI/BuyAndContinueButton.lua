
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ17ÈÕ 17:30:25
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- BuyAndContinueButton
---------------------------------------------------

assert(not BuyAndContinueButton)
assert(BaseUI)
BuyAndContinueButton = class(BaseUI)

function BuyAndContinueButton:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	-- Init Base Class
	BaseUI.init(self, ui)

	-- Get Child By Name
	self.greenHighlight	= self.ui:getChildByName("greenHighlight")
	self.blueHighlight	= self.ui:getChildByName("blueHighlight")

	self.windmillNumberLabelPh	= self.ui:getChildByName("numberLabel")
	self.windmillNumberLabelRect	= self.ui:getChildByName("numberLabel_fontSize")

	self.labelPh			= self.ui:getChildByName("label")
	self.labelRect			= self.ui:getChildByName("label_fontSize")

	self.blueBtnBg			= self.ui:getChildByName("blueBtnBg")
	self.greenBtnBg			= self.ui:getChildByName("greenBtnBg")
	self.windmill			= self.ui:getChildByName("windmill")

	assert(self.windmillNumberLabelPh)
	assert(self.labelPh)
	assert(self.windmill)

	--------------------------
	-- Create UI Componenet
	------------------------
	self.label			= TextField:createWithUIAdjustment(self.labelRect, self.labelPh)
	self.windmillNumberLabel	= TextField:createWithUIAdjustment(self.windmillNumberLabelRect, self.windmillNumberLabelPh)

	self.ui:addChild(self.label)
	self.ui:addChild(self.windmillNumberLabel)

	-------------------
	-- Init UI Conponent
	-- -------------------
	-- Default Blue Btn
	if self.blueHighlight and self.greenHighlight then
		self.greenHighlight:setVisible(false)
	end

	if self.blueBtnBg and self.greenBtnBg then
		self.greenBtnBg:setVisible(false)
	end

	if self.blueBtnBg and self.blueBtnBg:is(Scale9SpriteColorAdjust) then
		self.blueBtnBg:adjustColor(kColorBlueConfig[1],kColorBlueConfig[2],kColorBlueConfig[3],kColorBlueConfig[4])
		self.blueBtnBg:applyAdjustColorShader()
	end

	self.ui:setTouchEnabled(true, 0, true)
	--self.ui:setButtonMode(true)
	self:createAnimation()
end

function BuyAndContinueButton:createAnimation()
	local startButton = self.ui --:getChildByName("btnWithoutShadow")
	local deltaTime = 0.9
	local animations = CCArray:create()
	animations:addObject(CCScaleTo:create(deltaTime, 0.98, 1.03))
	animations:addObject(CCScaleTo:create(deltaTime, 1.01, 0.96))
	animations:addObject(CCScaleTo:create(deltaTime, 0.98,1.03))
	animations:addObject(CCScaleTo:create(deltaTime, 1,1))
	startButton:runAction(CCRepeatForever:create(CCSequence:create(animations)))

	local btnWithoutShadow = startButton:getChildByName("blueBtnBg")
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

function BuyAndContinueButton:hideWindmill(showMoneyMark, ...)
	assert(#{...} == 0)

	-- self.windmillNumberLabel:setVisible(false)
	self.windmill:setVisible(false)
	if showMoneyMark then self.showMoneyMark = true end
end

function BuyAndContinueButton:setWindmillNumber(number, ...)
	assert(type(number) == "number")
	assert(#{...} == 0)

	if self.isDisposed then return end

	if self.windmillNumber ~= number then
		self.windmillNumber = number
		if self.showMoneyMark then
			self.windmillNumberLabel:setString(Localization:getInstance():getText("buy.gold.panel.money.mark") .. tostring(number))
		else
			self.windmillNumberLabel:setString(tostring(number))
		end
	end
end

function BuyAndContinueButton:setLabel(labelString, ...)
	assert(type(labelString) == "string")
	assert(#{...} == 0)

	if self.labelString ~= labelString then
		self.labelString = labelString
		self.label:setString(labelString)
	end
	--self.label:setToParentCenterVertical()
end

function BuyAndContinueButton:setBtnBlue(...)
	assert(#{...} == 0)

	if self.blueHighlight then self.blueHighlight:setVisible(true) end
	if self.blueBtnBg then self.blueBtnBg:setVisible(true) end
	if self.greenHighlight then self.greenHighlight:setVisible(false) end
	if self.greenBtnBg then self.greenBtnBg:setVisible(false) end
end

function BuyAndContinueButton:setBtnGreen(...)
	assert(#{...} == 0)

	if self.greenHighlight then self.greenHighlight:setVisible(true) end
 	if self.greenBtnBg then self.greenBtnBg:setVisible(true) end
	if self.blueHighlight then self.blueHighlight:setVisible(false) end
	if self.blueBtnBg then self.blueBtnBg:setVisible(false) end
end

function BuyAndContinueButton:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newBuyAndContinueButton = BuyAndContinueButton.new()
	newBuyAndContinueButton:init(ui)
	return newBuyAndContinueButton
end
