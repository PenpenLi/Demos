
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014年01月 5日 19:50:16
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

---------------------------------------------------
-------------- MessageButton
---------------------------------------------------

assert(not MessageButton)
assert(IconButtonBase)

MessageButton = class(IconButtonBase)

function MessageButton:ctor( ... )
	self.id = "MessageButton"
    self.playTipPriority = 40
end
function MessageButton:playHasNotificationAnim(...)
    IconButtonManager:getInstance():addPlayTipIcon(self)
end

function MessageButton:stopHasNotificationAnim(...)
    IconButtonManager:getInstance():removePlayTipIcon(self)
end


function MessageButton:init(...)
	assert(#{...} == 0)

	-- Get Resource 
	self.ui	= ResourceManager:sharedInstance():buildGroup("messageIcon")

	-- Init Base Class
	--BaseUI.init(self, self.ui)
	IconButtonBase.init(self, self.ui)

	-----------------------
	-- Get UI Componenet
	-- -------------------
	
	-- self.wrapper Is Declared In Base Class IconButtonBase
	self.ring = self.wrapper:getChildByName("ring")
	self.numberLabel	= self.wrapper:getChildByName("numberLabel")
	assert(self.numberLabel)
	self.labelPos = self.numberLabel:getPositionY()
	self.fontSize = self.numberLabel:getFontSize()

	----------------
	-- Update UI
	-- --------------
	local requestNumber = UserManager:getInstance().requestNum
	if requestNumber > 99 then
		self.numberLabel:setPositionY(self.labelPos - 4)
		self.numberLabel:setFontSize(self.fontSize - 8)
		self.numberLabel:setString("99+")
	else
		self.numberLabel:setPositionY(self.labelPos)
		self.numberLabel:setFontSize(self.fontSize)
		self.numberLabel:setString(requestNumber)
	end
		
	if requestNumber > 0 then
		self.ring:setVisible(true)
		self.numberLabel:setVisible(true)
	else
		self.ring:setVisible(false)
		self.numberLabel:setVisible(false)
	end

	local tipLabelTxtKey	= "message.center.coin.new.mail.tips"
	local tipLabelTxtValue	= Localization:getInstance():getText(tipLabelTxtKey, {})

	--print("type: " .. type(tipLabelTxtValue))
	--print(tostring(tipLabelTxtValue))
	--debug.debug()

	self:setTipString(tipLabelTxtValue)

	--------------------------
	-- Notification Anim
	-- --------------------
	if requestNumber > 0 then
		self:playHasNotificationAnim()
	end
end

function MessageButton:updateView(...)
	assert(#{...} == 0)

	local requestNumber = UserManager:getInstance().requestNum
	if requestNumber > 99 then
		self.numberLabel:setPositionY(self.labelPos - 4)
		self.numberLabel:setFontSize(self.fontSize - 8)
		self.numberLabel:setString("99+")
	else
		self.numberLabel:setPositionY(self.labelPos)
		self.numberLabel:setFontSize(self.fontSize)
		self.numberLabel:setString(requestNumber)
	end

	if requestNumber > 0 then
		self.ring:setVisible(true)
		self.numberLabel:setVisible(true)
		self:playHasNotificationAnim()
	else
		self.ring:setVisible(false)
		self.numberLabel:setVisible(false)
		self:stopHasNotificationAnim()
	end
end

function MessageButton:create(...)
	assert(#{...} == 0)

	local newMessageButton = MessageButton.new()
	newMessageButton:init()
	return newMessageButton
end
