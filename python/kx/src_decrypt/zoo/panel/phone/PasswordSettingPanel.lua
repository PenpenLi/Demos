local Button = require "zoo.panel.phone.Button"
local Title = require "zoo.panel.phone.Title"
local Input = require "zoo.panel.phone.Input"

PasswordSettingPanel = class(LoginAndRegisterPanel)

kModeRegister = 1
kModeRetrivePassword = 2
kModeChangeBinding = 3
kModeDisposeBinding = 4
kModeRegisterInGame = 5

local DCSuccessSubCategory = {
	[kModeRegister] = "login_account_phone_register_step",
	[kModeRetrivePassword] = "login_account_find_password",
	[kModeChangeBinding] = "login_account_change_binding",
	[kModeRegisterInGame] = "login_account_phone_register_step",
}

local SuccessTipContent = {
	[kModeRegister] = "login.tips.content.11",
	[kModeRetrivePassword] = "login.tips.content.12",
	[kModeChangeBinding] = "setting.tips.content.1",
	[kModeRegisterInGame] = "login.tips.content.11",
}

local PasswordSettingPanelTitle = {
	[kModeRegister] = localize("login.panel.title.3"),
	[kModeRetrivePassword] = localize("login.panel.title.4"),
	[kModeChangeBinding] = localize("login.panel.title.5"),
	[kModeRegisterInGame] = localize("login.panel.title.3"),
}

local DCReturnSubCategory = {
	[kModeRegister] = "login_account_phone_register_back",
	[kModeRetrivePassword] = "login_account_find_password_back",
	[kModeChangeBinding] = "login_account_change_binding_back",
	[kModeRegisterInGame] = "login_account_phone_register_back",
}

local ReturnTipContent = {
	[kModeRegister] = localize("login.alert.content.6"),
	[kModeRetrivePassword] = localize("login.alert.content.10"),
	[kModeChangeBinding] = "是否确定终止更换绑定？",
	[kModeRegisterInGame] = localize("login.alert.content.6"),
}

local PlaceHolderContent = {
	[kModeRegister] = localize("login.panel.intro.14"),
	[kModeRetrivePassword] = localize("login.panel.intro.15"),
	[kModeChangeBinding] = localize("login.panel.intro.20"),
	[kModeDisposeBinding] = localize("login.panel.intro.14"),
	[kModeRegisterInGame] = localize("login.panel.intro.14"),
}


function PasswordSettingPanel.ctor()
end

function PasswordSettingPanel:verifyCodeError(errorCode, errorMsg)
	print("errorCode: ", errorCode)
	print("errMsg: ", errorMsg)
	local function onErrorTip()
		if tonumber(errorCode) == 204 then --session timeout
			self:onCloseBtnTapped() --return back to the previous panel.
		end
	end
	CommonTip:showTip(localize("phone.register.error.tip."..errorCode), "negative",onErrorTip,2)
end

function PasswordSettingPanel:setPasswordSuccess(data)
	print("setPasswordSuccess: "..tostring(self.mode))
	if self.mode == kModeChangeBinding then
		self:remove()
		if self.successCallback then
			self.successCallback(data.openId, self.phoneNumber)
		end
		return
	end

	if self.mode == kModeRegister or self.mode == kModeRetrivePassword  or self.mode == kModeRegisterInGame then
		self:remove()
		if self.phoneLoginCompleteCallback then
			self.phoneLoginCompleteCallback(data.openId, self.phoneNumber)
			print("phoneLoginCompleteCallback called!!!!!!!!!!!!!!!!!")
		else
			CommonTip:showTip(localize(SuccessTipContent[self.mode], {num = self.phoneNumber}), "positive",nil,2)
			print("phoneLoginCompleteCallback is null!!!!!!!!!!!!!!!!!")
		end

		local sub_cate = DCSuccessSubCategory[self.mode]
		DcUtil:UserTrack({ category='login', sub_category=sub_cate, step = 3, place=self.place, where = self.where })
	end
end

function PasswordSettingPanel:init(closeCallback, phoneNumber, mode)
	self.ui	= self:buildInterfaceGroup("PasswordSettingPanel")
	BasePanel.init(self, self.ui)

	self.phoneNumber = phoneNumber
	self.mode = mode
	self.closeCallback = closeCallback

	self:initTitle()

	local function onConfirm()
		self.password = self.input:getText()
		self:sendConfirmRequest()
	end

	self.btnNext = Button:create(self:child("btnConfirm"), localize("login.panel.button.11"), onConfirm)
	self.btnNext:setEnabled(false)
	
	self:initInput()
	self:setPasswordTip()
end

function PasswordSettingPanel:setPasswordTip()
	self:child("tipPassword"):setString(localize("login.panel.intro.9"))
end

function PasswordSettingPanel:sendConfirmRequest()

	local function CommonTipCallback( ... )
		if self.isDisposed then
			return
		end
		self.input:openKeyBoard()
	end

	if  not self.password or #self.password < 8 then
		CommonTip:showTip(localize("login.tips.content.7"), "negative",CommonTipCallback,2)
		return
	end

	--[[local codeMatch = string.find(self.input:getText(),"%w*%l+%w*")
	if not codeMatch the
		CommonTip:showTip(localize("login.tips.content.9"), "negative",CommonTipCallback,2)
		return
	end

	codeMatch = string.find(self.input:getText(),"%w*%u+%w*")
	if not codeMatch then
		CommonTip:showTip(localize("login.tips.content.8"), "negative",CommonTipCallback,2)
		return
	end

	codeMatch = string.find(self.input:getText(),"%w*%d+%w*")
	if not codeMatch then
		CommonTip:showTip(localize("login.tips.content.10"), "negative",CommonTipCallback,2)
		return
	end]]--

	local uid = UserManager:getInstance().user.uid
	local loginInfo = Localhost.getInstance():getLastLoginUserConfig()
	local udid = __WIN32 and "8248" or UdidUtil:getUdid()

	local function onSuccess( data )
		if self.isDisposed then
			return
		end
		self:setPasswordSuccess(data)
	end

	local function onError(errorCode, errorMsg)
		if self.isDisposed then
			return
		end

		self:verifyCodeError(errorCode, errorMsg)
	end

	local httpClient = HttpsClient:create(
		"regSetPassword",
		{password= HeMathUtils:md5(self.password), udid = udid, uid = loginInfo.uid, sk = udid}, 
		onSuccess, 
		onError
	)
	httpClient:send()
end

function PasswordSettingPanel:initTitle()
	local title = Title:create(self.ui:getChildByName("title"),true)
	print("self.mode: ", self.mode, self)
	print("title: ", PasswordSettingPanelTitle[self.mode])

	title:setText(PasswordSettingPanelTitle[self.mode])
	title:addEventListener(Title.Events.kBackTap,function( ... )

		print("in click title self.mode: ", tostring(self.mode), self)
		if self.mode == kModeChangeBinding then
			self:onCloseBtnTapped()
			local sub_cate = DCReturnSubCategory[self.mode]
			DcUtil:UserTrack({ category='login', sub_category=sub_cate, step=3, place=self.place, where = self.where })
		else
			print("self.mode: "..tostring(self.mode))
			local confirmPanel = PhoneConfirmPanel:create(function()
				self:onCloseBtnTapped()
				local sub_cate = DCReturnSubCategory[self.mode]
				DcUtil:UserTrack({ category='login', sub_category=sub_cate, step=3, place=self.place, where = self.where })
			end, nil)
			confirmPanel:initLabel(ReturnTipContent[self.mode], localize("login.panel.button.12"), localize("login.panel.button.13"))
			confirmPanel:popout()
		end

	end)
end

function PasswordSettingPanel:initInput()

	local function showErrorTip(tip)
		cancelTimeOut(self.timeOutID)
		self:child("pwdErrorTip"):setString(tip)
		self:child("pwdErrorTip"):setVisible(true)

		self.timeOutID = setTimeOut(function() self:child("pwdErrorTip"):setVisible(false) end, 3)
	end

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

		local codeMatch = string.find(password," ")
		if codeMatch and codeMatch >=1 then
			showErrorTip(localize("login.panel.intro.11"))
			self.btnNext:setEnabled(false)
			return
		end

		codeMatch = string.find(password,"[^%w-_]")
		if codeMatch and codeMatch>=1 then
			showErrorTip(localize("login.panel.intro.10"))
			self.btnNext:setEnabled(false)
			return
		end

		if password and #password > 14 then
			showErrorTip(localize("login.panel.intro.12"))
			self.btnNext:setEnabled(false)
			return
		end

		self:child("pwdErrorTip"):setVisible(false)
		cancelTimeOut(self.timeOutID)

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
	input:setPlaceHolder(PlaceHolderContent[self.mode])
	self.input = input
end

function PasswordSettingPanel:remove()
	cancelTimeOut(self.timeOutID)
	LoginAndRegisterPanel.remove(self)
end

function PasswordSettingPanel:create(closeCallback, successCallback, phoneNumber, mode, cloneStatePanel)
	local panel = PasswordSettingPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_register)
	panel:init(closeCallback, phoneNumber, mode)
	print("mode in the password: ", tostring(mode))
	panel.successCallback = successCallback

	if cloneStatePanel then
		cloneStatePanel:cloneStateTo(panel)
	end

	return panel
end