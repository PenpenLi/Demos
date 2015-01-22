RabbitStartGameTimeWarningPanel = class(BasePanel)

function RabbitStartGameTimeWarningPanel:create(onConfirmCallback, onCancelCallback)
	local instance = RabbitStartGameTimeWarningPanel.new()
    instance:loadRequiredJson(PanelConfigFiles.panel_rabbit_weekly_v2)
    instance:init(onConfirmCallback, onCancelCallback)
    return instance
end

function RabbitStartGameTimeWarningPanel:init(onConfirmCallback, onCancelCallback)
	self.onConfirmCallback = onConfirmCallback
	self.onCancelCallback = onCancelCallback

	local ui = self:buildInterfaceGroup('startMatchTimeWarningPanel')
	BasePanel.init(self, ui)

	self.okBtn = GroupButtonBase:create(ui:getChildByName('okBtn'))
	self.cancelBtn = GroupButtonBase:create(ui:getChildByName('cancelBtn'))
	self.checkbox = ui:getChildByName('checkbox')
	self.checkbox.selected = self.checkbox:getChildByName("selected")

	ui:getChildByName("text"):setString(Localization:getInstance():getText("weekly.race.rabbit.start.tip1"))

	self.cancelBtn:setColorMode(kGroupButtonColorMode.orange)
	self.cancelBtn:setString("取消")
	local function onCancelBtnTapped(evt)
		self:onCloseBtnTapped()
		if self.onCancelCallback then self.onCancelCallback() end
	end
	self.cancelBtn:ad(DisplayEvents.kTouchTap, onCancelBtnTapped)

	self.okBtn:setColorMode(kGroupButtonColorMode.blue)
	self.okBtn:setString("继续")
	local function onOKBtnTapped(evt)
		self:onCloseBtnTapped()
		if self.onConfirmCallback then self.onConfirmCallback() end
	end
	self.okBtn:ad(DisplayEvents.kTouchTap, onOKBtnTapped)

	-- 默认选择
	RabbitWeeklyManager:setTimeWarningDisabled(true)
	self.checkbox.isSelected = true
	self.checkbox.selected:setVisible(true)

	self.checkbox:getChildByName("text"):setString(Localization:getInstance():getText("weekly.race.rabbit.start.tip2"))
	self.checkbox:setTouchEnabled(true)
	local function onCheckboxTapped(evt)
		self:onCheckboxTapped()
	end
	self.checkbox:ad(DisplayEvents.kTouchTap, onCheckboxTapped)
end

function RabbitStartGameTimeWarningPanel:popout( onCloseCallback )
	PopoutManager:sharedInstance():addChildWithBackground(self, ccc3(0, 0, 0), 255 * 0.7)
    self.allowBackKeyTap = true
    self.onCloseCallback = onCloseCallback
end

function RabbitStartGameTimeWarningPanel:onCheckboxTapped()
	self.checkbox.isSelected = not self.checkbox.isSelected
	RabbitWeeklyManager:setTimeWarningDisabled(self.checkbox.isSelected)
	self.checkbox.selected:setVisible(self.checkbox.isSelected)
end

function RabbitStartGameTimeWarningPanel:dispose( ... )
	BaseUI.dispose(self)
end

function RabbitStartGameTimeWarningPanel:onCloseBtnTapped()
    PopoutManager:sharedInstance():remove(self, true)
    self.allowBackKeyTap = false
    if self.onCloseCallback then self.onCloseCallback() end
end

function RabbitStartGameTimeWarningPanel:onKeyBackClicked(...)
	assert(#{...} == 0)
	if self.allowBackKeyTap then
		if self.onCloseBtnTapped then self:onCloseBtnTapped() end
		if self.onCancelCallback then self.onCancelCallback() end
	end
end
