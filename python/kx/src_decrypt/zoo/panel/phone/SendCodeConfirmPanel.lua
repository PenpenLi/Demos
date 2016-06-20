local Button = require "zoo.panel.phone.Button"
require "zoo.panel.phone.PhoneLoginInfo"

SendCodeConfirmPanel = class(BasePanel)

function SendCodeConfirmPanel:create(phone,isPhoneBound,mode)
	local panel = SendCodeConfirmPanel.new()
	panel:loadRequiredResource("ui/login.json")
	panel:init(phone,isPhoneBound,mode)

	return panel
end

function SendCodeConfirmPanel:init( phone,isPhoneBound,mode )
	self.ui	= self:buildInterfaceGroup("SendCodeConfirmPanel")
	BasePanel.init(self, self.ui)

	if mode == PhoneLoginMode.kBindingOldLogin then
		self.ui:getChildByName("content"):setString(
			Localization:getInstance():getText("login.alert.content.13")
		)		
	else
		self.ui:getChildByName("content"):setString(
			Localization:getInstance():getText("login.alert.content.3")
		)
	end
	self.ui:getChildByName("phone"):setString(tostring(phone))

	if not isPhoneBound then
		self.ui:getChildByName("createAccountTip"):setString(
			Localization:getInstance():getText("login.alert.content.12")
		)
	end

	local okButton = Button:create(self.ui:getChildByName("okBtn"))
	okButton:setText(Localization:getInstance():getText("login.panel.button.11"))
	okButton:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if self.okCallback then
			self.okCallback()
		end
		self:remove()
	end)

	local cancelButton = Button:create(self.ui:getChildByName("cancelBtn"))
	cancelButton:setColor(kColorGreyConfig)--{0.5546,0.1072,0.0531,0.3406})
	cancelButton:setText(Localization:getInstance():getText("button.cancel"))
	cancelButton:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if self.cancelCallback then
			self.cancelCallback()
		end
		self:remove()
	end)
end


function SendCodeConfirmPanel:setOkCallback( okCallback )
	self.okCallback = okCallback
end

function SendCodeConfirmPanel:setCancelCallback( cancelCallback )
	self.cancelCallback = cancelCallback
end

local visibleSize = Director.sharedDirector():getVisibleSize()
function SendCodeConfirmPanel:popout( ... )
	local bounds = self.ui:getChildByName("bg"):getGroupBounds()

	self:setPosition(ccp(
		visibleSize.width/2 - bounds.size.width/2,
		-visibleSize.height/2 + bounds.size.height/2
	))

	PopoutManager:add(self, true, false)
end

function SendCodeConfirmPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self, true)
end