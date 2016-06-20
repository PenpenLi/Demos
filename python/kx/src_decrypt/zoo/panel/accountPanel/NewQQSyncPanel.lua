local NewQQSyncPanel = class(BasePanel)

--source: 来源，1：账号系统，2：添加好友 
function NewQQSyncPanel:create(source, title, message1, message2)
	local panel = NewQQSyncPanel.new()
	panel:loadRequiredResource("ui/account_confirm_panels.json")
	panel:init(source, title, message1, message2)

	return panel
end

function NewQQSyncPanel:init(source, title, message1, message2)
	self.ui = self:buildInterfaceGroup("NewQQSyncPanel"..source)
    BasePanel.init(self, self.ui)

    self.message1 = message1
    self.message2 = message2
    self.source = source

    self.title = self.ui:getChildByName("title")
    self.title:setPreferredSize(176, 63)
    self.title:setString(title)

    self:initCloseButton()
    self:initContent()
end

--localize("loading.tips.preloading.warnning.new1")
--localize("loading.tips.preloading.warnning.new2")
function NewQQSyncPanel:initContent()
	self.ui:getChildByName("item1"):setString(self.message1)
	self.ui:getChildByName("item2"):setString(self.message2)

	if self.source == 2 then
		self.ui:getChildByName("item3"):setString(localize("login.panel.warning.new4"))
		self.ui:getChildByName("subItem3"):setString(localize("login.panel.warning.detail4"))
	end

	local function onConfirm()
		self:onCloseBtnTapped()

        if self.okCallback then
            self.okCallback()
        end
	end

	local btnOK = GroupButtonBase:create(self.ui:getChildByName("btnContinue"))
	btnOK:setString(Localization:getInstance():getText("add.step.panel.use.btn.txt"))
	btnOK:addEventListener(DisplayEvents.kTouchTap, onConfirm)
	btnOK:setColorMode(kGroupButtonColorMode.orange)

	local btnSave = GroupButtonBase:create(self.ui:getChildByName("btnSave"))

	local function onSyncFinished()
		CommonTip:showTip("已为您成功保存关卡数据！", "positive",nil, 2)
		btnSave:setString("数据已保存")
		btnSave:setEnabled(false)
	end

	local function onSyncError(errorCode)
		errorCode = tonumber(errorCode) or -1
		if errorCode <= 10 then
			CommonTip:showTip("同步关卡数据失败！", "negative", nil, 2)
		end
	end
	
	local function onSave()
		SyncManager.getInstance():sync(onSyncFinished, onSyncError, kRequireNetworkAlertAnimation.kDefault)
	end

	local cachedHttpList = UserService.getInstance():getCachedHttpData()
	if cachedHttpList and #cachedHttpList > 0 then
		btnSave:setString(localize("loading.tips.preloading.warnning.btn1"))
		btnSave:addEventListener(DisplayEvents.kTouchTap, onSave)
	else
		btnSave:setString(localize("button.cancel"))
		btnSave:addEventListener(DisplayEvents.kTouchTap, function() 
					self:onCloseBtnTapped()
					
					if self.cancelCallback then
						self.cancelCallback()
					end
			end)
	end
end

function NewQQSyncPanel:initCloseButton()
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

function NewQQSyncPanel:onKeyBackClicked(...)
	BasePanel.onKeyBackClicked(self)
end

function NewQQSyncPanel:popout()
	self:setPositionForPopoutManager()
	self.allowBackKeyTap = true
	PopoutManager:sharedInstance():add(self, true, false)
end

function NewQQSyncPanel:popoutShowTransition()
	self.allowBackKeyTap = true
end

function NewQQSyncPanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():remove(self, true)
end

function NewQQSyncPanel:setOkCallback( okCallback )
	self.okCallback = okCallback
end

function NewQQSyncPanel:setCancelCallback( cancelCallback )
	self.cancelCallback = cancelCallback
end

return NewQQSyncPanel