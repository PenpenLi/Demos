local NewQQMergePanel = class(BasePanel)

--source: 来源，1：账号系统，2：添加好友 
function NewQQMergePanel:create(source, title, message1, message2, message3)
	local panel = NewQQMergePanel.new()
	panel:loadRequiredResource("ui/account_confirm_panels.json")
	panel:init(source, title, message1, message2, message3)

	return panel
end

function NewQQMergePanel:init(source, title, message1, message2, message3)
	self.ui = self:buildInterfaceGroup("NewQQMergePanel"..source)
    BasePanel.init(self, self.ui)

    self.message1 = message1
    self.message2 = message2
    self.message3 = message3
    self.source = source

    self.title = self.ui:getChildByName("title")
    self.title:setPreferredSize(176, 63)
    self.title:setString(title)

    self:initCloseButton()
    self:initContent()
end

--localize("loading.tips.preloading.warnning.new1")
--localize("loading.tips.preloading.warnning.new2")
function NewQQMergePanel:initContent()
	self.ui:getChildByName("item1"):setString(self.message1)
	self.ui:getChildByName("item2"):setString(self.message2)
	self.ui:getChildByName("item3"):setString(self.message3)

	if self.source == 2 then
		self.ui:getChildByName("item4"):setString(localize("login.panel.warning.new4"))
		self.ui:getChildByName("subItem4"):setString(localize("login.panel.warning.detail4"))
	end

	local function onConfirm()
		self:onCloseBtnTapped()
		
        if self.okCallback then
            self.okCallback()
        end
	end

	local btnOK = GroupButtonBase:create(self.ui:getChildByName("btnSave"))
	btnOK:setString(Localization:getInstance():getText("add.step.panel.use.btn.txt"))
	btnOK:addEventListener(DisplayEvents.kTouchTap, onConfirm)
	--btnOK:setColorMode(kGroupButtonColorMode.orange)
end

function NewQQMergePanel:initCloseButton()
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

function NewQQMergePanel:onKeyBackClicked(...)
	BasePanel.onKeyBackClicked(self)
end

function NewQQMergePanel:popout()
	self:setPositionForPopoutManager()
	self.allowBackKeyTap = true
	PopoutManager:sharedInstance():add(self, true, false)
end

function NewQQMergePanel:popoutShowTransition()
	self.allowBackKeyTap = true
end

function NewQQMergePanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():remove(self, true)
end

function NewQQMergePanel:setOkCallback( okCallback )
	self.okCallback = okCallback
end

function NewQQMergePanel:setCancelCallback( cancelCallback )
	self.cancelCallback = cancelCallback
end

return NewQQMergePanel