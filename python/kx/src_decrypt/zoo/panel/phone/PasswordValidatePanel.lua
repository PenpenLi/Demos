require "zoo.panel.phone.PhoneChangeBindingPanel"

local Button = require "zoo.panel.phone.Button"
local Title = require "zoo.panel.phone.Title"
local Input = require "zoo.panel.phone.Input"

PasswordValidatePanel  = class(PasswordSettingPanel)

local LOGIN_PASSWORD_MISMATCH = 213 --密码错误
local LOGIN_PASSWORD_MISMATCH_ERROR = 214 -- 次数太多
local PHONE_NUMBER_NOT_REGISTED = 201
local INVALID_PHONE_NUMBER = 203

local TitlePasswordValidate = {
	[kModeChangeBinding] = localize("login.panel.title.5"),
	[kModeDisposeBinding] = "解除绑定",
}

local ReturnTipContent = {
	[kModeChangeBinding] = "您是否确定取消更改绑定吗？",
	[kModeDisposeBinding] = "您是否确定取消解除绑定吗？",
}

function PasswordValidatePanel.ctor()

end

function PasswordValidatePanel:initTitle()
	local title = Title:create(self.ui:getChildByName("title"),true)
	title:setText(TitlePasswordValidate[self.mode])
	title:addEventListener(Title.Events.kBackTap,function( ... )

		self:onCloseBtnTapped()
		local sub_cate = 'login_account_change_binding_back'
		DcUtil:UserTrack({ category='login', sub_category=sub_cate, step=1, place=self.place })

		--local confirmPanel = PhoneConfirmPanel:create(function()
		--end, nil)
		--confirmPanel:initLabel(ReturnTipContent[self.mode], localize("login.panel.button.12"), localize("login.panel.button.13"))
		--confirmPanel:popout()
	end)
end

function PasswordValidatePanel:validatePasswordSuccess(data)
		--to show the phone input panel.
	if self.mode == kModeChangeBinding then
		local sub_cate = 'login_account_change_binding'
		DcUtil:UserTrack({ category='login', sub_category=sub_cate, step=1, place=self.place })
		if self.mode == kModeChangeBinding then
			local panel = PhoneChangeBindingPanel:create(self.closeCallback,self.successCallback, nil, self)
			panel:popout()
		end
		return
	end

	if self.mode == kModeDisposeBinding then
		if self.successCallback then
			self.successCallback()
		end

		--[[local function onSuccess()
			local loginInfo = Localhost.getInstance():getLastLoginUserConfig()
			Localhost.getInstance():deleteUserDataByUserID( loginInfo.uid )
			Localhost.getInstance():deleteLastLoginUserConfig()
			UdidUtil:clearUdid()
		end

		local function onError(err)
			CommonTip:showTip("解除绑定失败！", "negative",nil,2)
		end

		local http = DisposeBindingHttp.new()
		http:load({PlatformAuthDetail[PlatformAuthEnum.kPhone].name})
		http:ad(Events.kComplete, onSuccess)
		http:ad(Events.kError, onError)]]--
	end
end

function PasswordValidatePanel:onForgetPasswordTap()
	self:remove()
	print("PasswordValidatePanel.place: ", self.place)
	local panel = PhoneRegisterPanel:create(function( ... )
		PasswordValidatePanel:create(self.closeCallback, self.successCallback, self.phoneNumber, self.mode, self):popout()
	end,kModeRetrivePassword)
	panel:setPlace(self.place)
	panel:popout()
	print("PasswordValidatePanel->PhoneRegisterPanel, place:", panel.place)
end

function PasswordValidatePanel:popoutWrongPasswordPanel( remainCount )
	local function onGotPassword( ... )
		self:onForgetPasswordTap()
	end

	local function onCancel( ... )
		self.input:openKeyBoard()
	end

	local confirmPanel = PhoneConfirmPanel:create(onGotPassword,onCancel,onCancel)
	confirmPanel:initLabel(
		-- "您输入的手机号或密码不正确，请确认后重新输入（还可输入5次）",
		Localization:getInstance():getText("login.alert.content.8", {num = remainCount}),
		-- "找回密码",
		Localization:getInstance():getText("login.panel.button.21"),
		-- "返回修改"
		Localization:getInstance():getText("login.panel.button.14")
	)
	confirmPanel:popout()
end

function PasswordValidatePanel:popoutLockAccountPanel( ... )
	local function onGotPassword( ... )
		self:onForgetPasswordTap()
	end

	local function onCancel( ... )
	end


	local confirmPanel = PhoneConfirmPanel:create(onGotPassword, onCancel,onCancel)
	confirmPanel:initLabel(
		-- "当前账号已锁定，今天24点前不可登录。您可选择“找回密码”重新设置密码。",
		Localization:getInstance():getText("login.alert.content.9"),
		-- "找回密码",
		Localization:getInstance():getText("login.panel.button.21"),
		-- "返回修改"
		Localization:getInstance():getText("login.panel.button.14")
	)
	confirmPanel:popout()
end

function PasswordValidatePanel:setPasswordTip()
	self:child("tipPassword"):setString("")
end

function PasswordValidatePanel:sendConfirmRequest()

	local function onSuccess( data )

		HttpsClient.setSessionId(data.sessionId)
		self:remove()
		self:validatePasswordSuccess(data)
	end

	local function onError( errorCode, errorMsg ,data)
		if errorCode == LOGIN_PASSWORD_MISMATCH then
			local remainCount = tonumber(data.remainCount) or 0
			if remainCount <= 0 then
				errorCode = LOGIN_PASSWORD_MISMATCH_ERROR
			end
		end
		if errorCode == LOGIN_PASSWORD_MISMATCH then 
			self:popoutWrongPasswordPanel(data.remainCount)
		elseif errorCode == LOGIN_PASSWORD_MISMATCH_ERROR then
			self:popoutLockAccountPanel()
		elseif errorCode == PHONE_NUMBER_NOT_REGISTED then 
			-- 手机号没注册
			CommonTip:showTip(localize("phone.register.error.tip."..errorCode), "negative",nil,2)
		elseif errorCode == INVALID_PHONE_NUMBER then
			-- 密码
			CommonTip:showTip(localize("phone.register.error.tip."..errorCode), "negative",nil,2)
		end
	end

	local udid = __WIN32 and "thisisamockudid" or UdidUtil:getUdid()
	local loginInfo = Localhost.getInstance():getLastLoginUserConfig()
	local httpsClient = HttpsClient:create(
		"phoneLogin",
		{ phoneNumber = self.phoneNumber,password = HeMathUtils:md5(self.password), udid = udid, uid = loginInfo.uid, rebinding = "true"},
		onSuccess,
		onError
	)
	httpsClient:send()
end

function PasswordValidatePanel:initInput()

	local function onTextBegin()
		print("onTextBegin!!!!!!!!!!!!!!!")
	end

	local function onTextEnd()
		if self.input then
			local text = self.input:getText() or ""
		end
	end

	local function onTextChanged()
		he_log_info("text chagned!!!!!!")
		he_log_info("current text: "..tostring(self.input:getText()))

		local password = self.input:getText()

		if string.isEmpty(password) then
			self.btnNext:setEnabled(false)
			return
		end

		self.btnNext:setEnabled(true)
		he_log_info("current text valid: "..tostring(self.input:getText()))
	end

	local textPWD = self:child("textInput");
	textPWD:setAnchorPoint(ccp(0,1))
	local input = Input:create(textPWD, self)
	input:setText("")
	input:setMaxLength(14)
	input:setInputMode(kEditBoxInputModeAny)
	input:setInputFlag(kEditBoxInputFlagPassword)
	input:ad(kTextInputEvents.kBegan, onTextBegin)
	input:ad(kTextInputEvents.kEnded, onTextEnd)
	input:ad(kTextInputEvents.kChanged, onTextChanged)
	self.ui:addChild(input)
	input:setPlaceHolder(localize("login.panel.intro.18"))
	self.input = input
end

function PasswordValidatePanel:create(closeCallback, successCallback, phoneNumber, mode, cloneStatePanel)
	local panel = PasswordValidatePanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_register)
	panel:init(closeCallback, phoneNumber, mode)
	panel.successCallback = successCallback

	if cloneStatePanel then
		cloneStatePanel:cloneStateTo(panel)
	end

	return panel
end