
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ29ÈÕ 15:12:09
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- UseAddStepBtn
---------------------------------------------------

require "zoo.baseUI.BuyAndContinueButton"
require "zoo.baseUI.ButtonWithShadow"

assert(not UseAddStepBtn)
assert(BaseUI)
UseAddStepBtn = class(BaseUI)

function UseAddStepBtn:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	-----------
	-- Init Base Class
	-- ---------------
	BaseUI.init(self, ui)

	---------------
	-- Get UI Component
	-- ----------------
	self.buyAndContinueButton = self.ui:getChildByName("buyAndContinueBtn")
	self.btnWithShadow = self.ui:getChildByName("btnWithShadow")
	self.discount = self.ui:getChildByName("discount")
	self.discountNum = self.discount:getChildByName("num")
	self.discountText = self.discount:getChildByName("text")
	self.redCircle = self.ui:getChildByName("redCircle")
	self.numberLabel = self.ui:getChildByName("numberLabel")

	assert(self.buyAndContinueButton)
	assert(self.btnWithShadow)
	assert(self.discount)
	assert(self.discountNum)
	assert(self.discountText)
	assert(self.redCircle)
	assert(self.numberLabel)

	self.buyAndContinueButton = BuyAndContinueButton:create(self.buyAndContinueButton)
	self.btnWithShadow = ButtonWithShadow:create(self.btnWithShadow)

	----------------------
	-- Craete UI Componenet
	-- ----------------
	self.buyAndContinueButton.ui:setTouchEnabled(false)
	self.buyAndContinueButton.ui:setButtonMode(false)
	self.buyAndContinueButton:setLabel(Localization:getInstance():getText("add.step.panel.use.btn.txt"))
	self.btnWithShadow.ui:setTouchEnabled(false)
	self.btnWithShadow.ui:setButtonMode(false)
	self.btnWithShadow:setString(Localization:getInstance():getText("add.step.panel.use.btn.txt"))
	self.discountText:setString(Localization:getInstance():getText("buy.gold.panel.discount"))
	self.ui:setTouchEnabled(true, 0, true)
	self.ui:setButtonMode(true)

	self.fontSize = self.numberLabel:getFontSize()
	self.labelPos = self.numberLabel:getPositionY()
end

function UseAddStepBtn:hideWindmill()
	self.buyAndContinueButton:hideWindmill(true)
end

function UseAddStepBtn:setBuyAndContinue(price, discount)
	self.buyAndContinueButton.ui:setVisible(true)
	self.buyAndContinueButton:setWindmillNumber(price)
	self.btnWithShadow.ui:setVisible(false)
	self.redCircle:setVisible(false)
	self.numberLabel:setVisible(false)

	discount = discount or 10
	if discount < 10 then
		self.discountNum:setString(discount)
		self.discount:setVisible(true)
	else
		self.discount:setVisible(false)
	end
end

function UseAddStepBtn:setButtonWithShadow(number)
	self.btnWithShadow.ui:setVisible(true)
	self.redCircle:setVisible(true)
	if number > 99 then
		self.numberLabel:setPositionY(self.labelPos - 4)
		self.numberLabel:setFontSize(self.fontSize - 8)
		self.numberLabel:setString("99+")
	else
		self.numberLabel:setPositionY(self.labelPos)
		self.numberLabel:setFontSize(self.fontSize)
		self.numberLabel:setString(number)
	end
	self.numberLabel:setVisible(true)
	self.buyAndContinueButton.ui:setVisible(false)
	self.discount:setVisible(false)
end

function UseAddStepBtn:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newUseAddStepBtn = UseAddStepBtn.new()
	newUseAddStepBtn:init(ui)
	return newUseAddStepBtn
end
