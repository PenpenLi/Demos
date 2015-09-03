require "zoo.panel.phone.PhoneLoginPanel"
require "zoo.panel.phone.OtherLoginPanel"
local Button = require "zoo.panel.phone.Button"
local Title = require "zoo.panel.phone.Title"

LoginAndRegisterPanel = class(BasePanel)

kColorOrangeConfig2 = {-0.3835, 0.5751, 0.2660, 0}

function LoginAndRegisterPanel:ctor()
	self:setPlace(1)
	self:setWhere(1)
end

function LoginAndRegisterPanel:init( closeCallback )
	self.ui	= self:buildInterfaceGroup("LoginAndRegisterPanel")

	BasePanel.init(self, self.ui)

	self.closeCallback = closeCallback

	self.title = Title:create(self.ui:getChildByName("title"),false)

	local function onClose()
		self:onCloseBtnTapped()
	end
	self.btnClose = self:createTouchButton("btnClose", onClose)

	local function onConfirmReturn()
	end

	local function onRegister()
		self:remove()
		print("about to show the register panel!")
		local loginInfo = Localhost.getInstance():getLastLoginUserConfig()
		print("local userLogin: "..tostring(loginInfo.uid)..", sk:"..tostring(loginInfo.sk))
		PhoneRegisterPanel:create(function(...) 
			LoginAndRegisterPanel:create(self.closeCallback,self):popout() end, kModeRegister, nil, self):popout()

		if self.mode == "ChangeAccountMode" then
			DcUtil:UserTrack({ category='login', sub_category='login_click_phone_register_switch'})
		else
			DcUtil:UserTrack({ category='login', sub_category='login_click_phone_register'})
		end
	end
	self.btnRegister = Button:create(self.ui:getChildByName("btnRegister"), localize("login.panel.button.1"), onRegister)

	local function onLogin()
		self:remove()

		local showSelfCallback = function( ... )
			LoginAndRegisterPanel:create(self.closeCallback,self):popout()
		end
		print("about to show the login panel: "..tostring(showSelfCallback))

		local phoneLoginPanel =	PhoneLoginPanel:create(showSelfCallback)
		phoneLoginPanel:setPhoneLoginCompleteCallback(self.phoneLoginCompleteCallback)
		phoneLoginPanel:setMode(self.mode)
		phoneLoginPanel:popout()

		if self.mode == "ChangeAccountMode" then
			DcUtil:UserTrack({ category='login', sub_category='login_click_phone_login_switch'})
		else
			DcUtil:UserTrack({ category='login', sub_category='login_click_phone_login'})
		end

	end
	self.btnLogin = Button:create(self.ui:getChildByName("btnLogin"), localize("login.panel.button.2"), onLogin)
	self.btnLogin:setColor(kColorOrangeConfig2)

	local function onLinkOther()
		self:remove()

		local otherLoginPanel = OtherLoginPanel:create(function( ... )
			LoginAndRegisterPanel:create(self.closeCallback,self):popout()
		end)
		otherLoginPanel:setSelectSnsCallback(self.selectSnsCallback)
		otherLoginPanel:setMode(self.mode)
		otherLoginPanel:popout()

		if self.mode == "ChangeAccountMode" then 
			DcUtil:UserTrack({ category='login', sub_category='login_click_other_switch'})
		else
			DcUtil:UserTrack({ category='login', sub_category='login_click_other'})
		end

	end
	self.linkOtherLogin = Button:create(self.ui:getChildByName("linkOtherLogin"), localize("login.panel.button.3"), onLinkOther, true)
	self.linkOtherLogin:setVisible(PlatformConfig:isMultipleAuthConfig())
end

function LoginAndRegisterPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self, true)
end

function LoginAndRegisterPanel:onCloseBtnTapped()
	self.allowBackKeyTap = false
	self:remove()

	if self.closeCallback then 
		self.closeCallback()
	end
end

function LoginAndRegisterPanel:popout()
	PopoutManager:sharedInstance():add(self, true, false)
	self.allowBackKeyTap = true
	self:setToScreenCenter()
end

function LoginAndRegisterPanel:create( closeCallback,cloneStatePanel )
	local panel = LoginAndRegisterPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_register)
	panel:init(closeCallback)

	if cloneStatePanel then 
		cloneStatePanel:cloneStateTo(panel)
	end

	return panel
end

function LoginAndRegisterPanel:cloneStateTo( panel )
	panel:setPhoneLoginCompleteCallback(self.phoneLoginCompleteCallback)
	panel:setSelectSnsCallback(self.selectSnsCallback)
	if self.mode then
		panel:setMode(self.mode)
	else
		print("mode from previous panel is nil!!!!!!!!!!!!!!!!!!!!")
	end
	panel:setPlace(self.place)
	panel:setWhere(self.where)
	panel:setAction(self.action)
end

function LoginAndRegisterPanel:setPhoneNumber(phoneNumber)
	--to be overrided
end

function LoginAndRegisterPanel:setPhoneLoginCompleteCallback( phoneLoginCompleteCallback )
	self.phoneLoginCompleteCallback = phoneLoginCompleteCallback
end
function LoginAndRegisterPanel:setSelectSnsCallback( selectSnsCallback )
	self.selectSnsCallback = selectSnsCallback
end

function LoginAndRegisterPanel:setPreCloseCallback( preCloseCallback )
	self.preCloseCallback = preCloseCallback
end

function LoginAndRegisterPanel:setAction( action )
	if not self.title then
		return
	end
	self.action = action
	if action == "ChangeAccountMode" then
		self.title:setText(localize("login.panel.title.2"))--切换账号
	else
		self.title:setText(localize("login.panel.title.1"))
	end
end

function LoginAndRegisterPanel:setPlace( place )
-- 1=游戏开始界面 
-- 2=游戏内 
	self.place = place
end

function LoginAndRegisterPanel:setWhere( where )
-- 1=点手机号登录弹出 
-- 2=点切换手机号登录时弹出 
	self.where = where
end

function LoginAndRegisterPanel:setMode( mode )
	self.mode = mode
	print("===============set mode called: ", self.mode, self)
end