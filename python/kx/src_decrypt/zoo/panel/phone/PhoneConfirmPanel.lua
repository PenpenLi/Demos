local Button = require "zoo.panel.phone.Button"

PhoneConfirmPanel = class(BasePanel)

kColorBlueConfig2 = {0.5546,0.1072,0.0531,0.3406}

function PhoneConfirmPanel:ctor()
end

function PhoneConfirmPanel:init(firstCallback, secondCallback, backCallback)
	self.ui	= self:buildInterfaceGroup("PhoneConfirmPanel")

	BasePanel.init(self, self.ui)

	self.btnCancel = Button:create(self:child("btnCancel"), "", function( ... )
		self:remove()
		if firstCallback then 
			firstCallback()
		end
	end)
	self.btnCancel:setColor(kColorBlueConfig2)
	
	self.btnConfirm = Button:create(self:child("btnConfirm"), "", function( ... )
		self:remove()
		if secondCallback then 
			secondCallback()
		end
	end)
	self.btnConfirm:setColorMode(kGroupButtonColorMode.green)

	self.backCallback = backCallback
end

function PhoneConfirmPanel:setOneButtonMode()
	self.btnCancel:setVisible(false)

	local btnSize = self.btnConfirm.ui:getGroupBounds().size
	local panelSize = self.ui:getGroupBounds().size

	self.btnConfirm.ui:setPositionX(panelSize.width/2)
end

function PhoneConfirmPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self, true)
end

function PhoneConfirmPanel:onCloseBtnTapped()
	self.allowBackKeyTap = false
	self:remove()

	if self.backCallback then
		self.backCallback()
	end
end

function PhoneConfirmPanel:initLabel(content, firstLabel, secondLabel)
	self.btnCancel:setText(firstLabel)
	self.btnConfirm:setText(secondLabel)

	self.ui:getChildByName("content"):setString(content)
end

function PhoneConfirmPanel:setPhoneNumber(phoneNumber)
	if phoneNumber then
		self.ui:getChildByName("txtPhoneNO"):setString(phoneNumber)
	end
end

function PhoneConfirmPanel:popout()
	PopoutManager:sharedInstance():add(self, true, false)
	self.allowBackKeyTap = true
	self:setToScreenCenter()
end

function PhoneConfirmPanel:create(firstCallback, secondCallback, backCallback)
	local panel = PhoneConfirmPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_register)
	panel:init(firstCallback, secondCallback, backCallback)

	return panel
end

