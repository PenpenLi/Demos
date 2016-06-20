local NewCrossDevicePanel = class(BasePanel)

--source: 来源，1：账号系统，2：添加好友 
function NewCrossDevicePanel:create(source)
	local panel = NewCrossDevicePanel.new()
	panel:loadRequiredResource("ui/account_confirm_panels.json")
	panel:init(source)

	return panel
end

function NewCrossDevicePanel:init(source)
	self.ui = self:buildInterfaceGroup("CrossDevicePanel"..source)
    BasePanel.init(self, self.ui)

    self.source = source

    self.title = self.ui:getChildByName("title")
    self.title:setPreferredSize(333, 63)
    self.title:setString("跨平台登录须知")

    self:initCloseButton()
    self:initContent()
end

function NewCrossDevicePanel:initContent()
	self.ui:getChildByName("item1"):setString(localize("login.panel.warning.new1"))
	self.ui:getChildByName("subItem1"):setString(localize("login.panel.warning.detail1"))

	self.ui:getChildByName("item2"):setString(localize("login.panel.warning.new2"))
	self.ui:getChildByName("subItem2"):setString(localize("login.panel.warning.detail2"))

	self.ui:getChildByName("item3"):setString(localize("login.panel.warning.new3"))

	if self.source == 2 then
		self.ui:getChildByName("item4"):setString(localize("login.panel.warning.new4"))
		self.ui:getChildByName("subItem4"):setString(localize("login.panel.warning.detail4"))
	end

	self.ui:getChildByName("label_agree"):setString(localize("login.panel.warning.2"))
	self.ui:getChildByName("tip"):getChildByName("content"):setString(localize("login.panel.warning.new.tip"))

	local errorTip = self.ui:getChildByName("error_tip")
	errorTip:setString(Localization:getInstance():getText("login.panel.warning.3"))
	errorTip:setVisible(false)

	local checkBox = self.ui:getChildByName("checkbox")
	function checkBox:isCheck( ... )
		return self:getChildByName("iconCheck"):isVisible()
	end
	checkBox:getChildByName("iconCheck"):setVisible(false)
	checkBox:setTouchEnabled(true)
	checkBox:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if not checkBox:isCheck() then
			errorTip:setVisible(false)
		end
		checkBox:getChildByName("iconCheck"):setVisible(not checkBox:isCheck())
	end)

	local function onConfirm()
		if not checkBox:isCheck() then
			errorTip:setVisible(true)
			CommonTip:showTip(Localization:getInstance():getText("login.panel.warning.4"), "negative", nil, 3)
			return
		end

		self:onCloseBtnTapped()

        if self.okCallback then
            self.okCallback()
        end
	end

	local btnOK = GroupButtonBase:create(self.ui:getChildByName("btnOK"))
	btnOK:setString(Localization:getInstance():getText("button.ok"))
	btnOK:addEventListener(DisplayEvents.kTouchTap, onConfirm)
end

function NewCrossDevicePanel:initCloseButton()
	self.closeBtn = self.ui:getChildByName("btnClose")
    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:addEventListener(DisplayEvents.kTouchTap, 
        function() 
            self:onCloseBtnTapped()

            if self.cancelCallback then
            	self.cancelCallback()
            end
        end)
end

function NewCrossDevicePanel:onKeyBackClicked(...)
	BasePanel.onKeyBackClicked(self)
end

function NewCrossDevicePanel:popout()
	self:setScale(0.96)
	self:setPositionForPopoutManager()
	self:setPositionY(self:getPositionY() - 3)
	self.allowBackKeyTap = true
	PopoutManager:sharedInstance():add(self, true, false)

end

function NewCrossDevicePanel:popoutShowTransition()
	self.allowBackKeyTap = true
end

function NewCrossDevicePanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():remove(self, true)
end

function NewCrossDevicePanel:setOkCallback( okCallback )
	self.okCallback = okCallback
end

function NewCrossDevicePanel:setCancelCallback( cancelCallback )
	self.cancelCallback = cancelCallback
end

return NewCrossDevicePanel