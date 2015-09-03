local Button = require "zoo.panel.phone.Button"

AccountConfirmPanel = class(BasePanel)

function AccountConfirmPanel:ctor()
end

function AccountConfirmPanel:init(confirmCallback)
	self.ui	= self:buildInterfaceGroup("AccountConfirmPanel")
	BasePanel.init(self, self.ui)
	
	self.btnConfirm = Button:create(self:child("btnConfirm"), "", function( ... )
		self:remove()
		if confirmCallback then 
			confirmCallback()
		end
	end)

	self.backCallback = backCallback
end

function AccountConfirmPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self, true)
end

function AccountConfirmPanel:onCloseBtnTapped()
	self.allowBackKeyTap = false
	self:remove()
end

function AccountConfirmPanel:initLabel(content, label)
	self.btnConfirm:setText(label)

	self.ui:getChildByName("content"):setString(content)
end

function AccountConfirmPanel:popout()
	PopoutManager:sharedInstance():add(self, true, false)
	self.allowBackKeyTap = true
	self:setToScreenCenter()
end

function AccountConfirmPanel:create(confirmCallback)
	local panel = AccountConfirmPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_register)
	panel:init(confirmCallback)

	return panel
end

