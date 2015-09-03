require "zoo.net.HttpsClient"
require "zoo.panel.phone.PhoneConfirmPanel"
require "zoo.panel.phone.RegisterCodeConfirmPanel"
require "zoo.util.UdidUtil"

local Button = require "zoo.panel.phone.Button"
local Title = require "zoo.panel.phone.Title"
local Input = require "zoo.panel.phone.Input"

PhoneRegisterPanel = class(LoginAndRegisterPanel)

local function isRegisterMode(mode)
	return mode == kModeRegister or mode == kModeRegisterInGame
end

function PhoneRegisterPanel:init(closeCallback, mode, initPhoneNumber)
	self.ui	= self:buildInterfaceGroup("PhoneRegisterPanel")
	BasePanel.init(self, self.ui)

	self.phoneNumber = initPhoneNumber
	self.mode = mode
	self.isRetrivePassword = mode == kModeRetrivePassword
	self.closeCallback = closeCallback

	self:initTitle()

	local function onCheck()
		self.iconCheck:setVisible(not self.iconCheck:isVisible())
		if self.iconCheck:isVisible() then
			self.errorTip:setVisible(false)
		end
	end

	self.checkBox = self:createTouchButton("checkBox", onCheck)
	self.iconCheck = self.checkBox:getChildByName("iconCheck")

	local function onLink()
		PreloadingSceneUI.showUserAgreement()
	end

	self.linkContract = self:createTouchButton("linkContract", onLink)

	local function confirmPhoneNumber()
		self:remove()

		print("phoneNumber: ", self.phoneNumber)
		RegisterCodeConfirmPanel:create(function()
				PhoneRegisterPanel:create(self.closeCallback, self.mode, self.phoneNumber, self):popout()
			end,
			self.phoneNumber, self.mode, self):popout()
		local sub_cate = self.isRetrivePassword and 'login_account_find_password' or 'login_account_phone_register_step'
		DcUtil:UserTrack({ category='login', sub_category=sub_cate, step=1, place=self.place, where = self.where })
		print(sub_cate..tostring(":"), " where: "..self.where, " place: "..self.place)
	end

	local function onNext()
		print("btnNext clicked!!!!!!!!!!", self.input:getText())
		if string.isEmpty(self.input:getText()) then
			CommonTip:showTip(localize("login.panel.intro.13"), "negative",nil,2)
			self.btnNext:setEnabled(false)
			return
		end

		if not self.input:validatePhone() then
			return
		end

		local function openPhoneConfirm()
			local panel = PhoneConfirmPanel:create(nil, confirmPhoneNumber)
			panel:initLabel(localize("login.alert.content.3"), 
				localize("button.cancel"),--"取消" , 
				localize("login.panel.button.11"))
			panel:setPhoneNumber(self.input:getText())
			panel.btnCancel:setColor(kColorGreyConfig)
			panel:popout()
		end

		local function onCheckRetrivePassword(responseData)
			if self.isDisposed then
				return
			end
			HttpsClient.setSessionId(responseData.sessionId)

			if not responseData.isPhoneRegistered then
				local panel = PhoneConfirmPanel:create(function() self.input:openKeyBoard() end, 
					function()
						self:remove()
						PhoneRegisterPanel:create(self.closeCallback, kModeRegister, self.phoneNumber, self):popout()
					end)
				panel:initLabel(localize("login.alert.content.11"),localize("login.panel.button.14"), localize("login.panel.button.20"))
				panel:popout()
			else
				openPhoneConfirm()
			end
		end

		local function onCheckRegisterPhone(responseData)
			if self.isDisposed then
				return
			end
			HttpsClient.setSessionId(responseData.sessionId)

			local function login()
				self:remove()
				print("PhoneRegisterPanel.place: "..tostring(self.place))
				local panel = PhoneLoginPanel:create(self.preCloseCallback, self)
				panel:setPhoneNumber(self.phoneNumber)
				panel:setMode(self.mode)
				panel:setPhoneLoginCompleteCallback(function(openId, phoneNumber)
					if self.phoneLoginCompleteCallback then
						self.phoneLoginCompleteCallback(openId,phoneNumber)
					end
				end)
				DcUtil:UserTrack({ category='login', sub_category='login_account_phone_login', place = 2})
				panel:popout()
				print("PhoneLoginPanel.place: "..tostring(self.place))
			end
			
			if responseData.isPhoneRegistered then
				local panel = PhoneConfirmPanel:create(function() self.input:openKeyBoard() end, login)
				panel:initLabel(localize("login.alert.content.2"),localize("login.panel.button.14"), localize("login.panel.button.15"))
				panel:popout()
			else
				if isRegisterMode(self.mode) and not self.iconCheck:isVisible()  then
					CommonTip:showTip(localize("login.tips.content.2"), "negative",
						function() self.errorTip:setVisible(true) end
						,2)
					return
				end

				openPhoneConfirm()
			end
		end

		local function onCheckError(errorCode, errMsg)
			print("errorCode: ", errorCode)
			print("errMsg: ", errMsg)
			CommonTip:showTip(localize("phone.register.error.tip."..errorCode), "negative",nil,2)
		end

		local function verifyPhoneRegistered()
			local onCheckSuccessCallback = self.isRetrivePassword and onCheckRetrivePassword or onCheckRegisterPhone
			self:sendVerifyPhoneRequest(onCheckSuccessCallback, onCheckError)
		end

		if self.mode == kModeRegisterInGame and UserManager.getInstance().profile:isSNSBound() then
			self:verifyPhoneBound(verifyPhoneRegistered)
		else
			verifyPhoneRegistered()
		end
	end

	self.btnNext = Button:create(self.ui:getChildByName("btnNext"), localize("login.panel.button.10"), onNext)
	self.btnNext:setEnabled(not string.isEmpty(self.phoneNumber))

	self.ui:getChildByName("tipConcact"):setString(localize("login.panel.intro.2"))
	self.linkContract:getChildByName("text"):setString(localize("login.panel.intro.3"))
	self.errorTip = self.ui:getChildByName("errorTip"):setString(localize("login.panel.intro.4"))
	self.errorTip:setVisible(false)

	self.linkContract:setVisible(not self.isRetrivePassword)
	self:child("tipConcact"):setVisible(not self.isRetrivePassword)
	self.checkBox:setVisible(not self.isRetrivePassword)

	self:initInput()
	self:setAccountTip()
end

function PhoneRegisterPanel:setAccountTip()
	self:child("tipAccount"):setVisible(false)
end

function PhoneRegisterPanel:sendVerifyPhoneRequest(onSuccess, onError)
		--to check the phone number.
	local udid = __WIN32 and "thisisamockudid" or UdidUtil:getUdid()

	local method = self.isRetrivePassword and "retrivePassword" or "register"
	local httpClient = HttpsClient:create(
		"regVertifyPhoneNumber", 
		{phoneNumber = self.input:getText(), udid = udid, method = method}, 
		onSuccess, 
		onError
	)
	httpClient:send()
end

function PhoneRegisterPanel:verifyPhoneBound(onSuccess)
	--to check the phone number.

	local function onCheckSuccess(responseData)

		if responseData.isPhoneBound then
			local tipStr = localize("setting.alert.content.2", 
                                    {account = "手机号", 
                                     account1 = "手机号",
                                     account2 =  "手机号"
                                    })

			local panel = AccountConfirmPanel:create()
			panel:initLabel(tipStr, "知道了")
			panel:popout()
			panel.allowBackKeyTap = false
		else
			if onSuccess then
				onSuccess()
			end
		end
	end

	local function onCheckError(errorCode, errMsg)
		print("errorCode: ", errorCode)
		print("errMsg: ", errMsg)
		CommonTip:showTip(localize("phone.register.error.tip."..errorCode), "negative",nil,2)
	end

	local udid = __WIN32 and "thisisamockudid" or UdidUtil:getUdid()

	local httpClient = HttpsClient:create("vertifyBindingPhoneNumber", {phoneNumber = self.input:getText(), udid = udid}, onCheckSuccess, onCheckError)
	httpClient:send()
end

function PhoneRegisterPanel:initTitle()
	local title = Title:create(self.ui:getChildByName("title"),true)
	title:setText(localize(self.isRetrivePassword and "login.panel.title.4" or "login.panel.title.3"))
	title:addEventListener(Title.Events.kBackTap,function( ... )
		local confirmPanel = PhoneConfirmPanel:create(function()
			self:onCloseBtnTapped()

			local sub_cate = self.isRetrivePassword and 'login_account_find_password_back' or 'login_account_phone_register_back'
			DcUtil:UserTrack({ category='login', sub_category=sub_cate, step=1, place=self.place, where = self.where })
		end, 
		function() 
			self.input:openKeyBoard()
		end)
		local contentKey = self.isRetrivePassword and "login.alert.content.10" or "login.alert.content.1"
		confirmPanel:initLabel(localize(contentKey), localize("login.panel.button.12"), localize("login.panel.button.13"))
		confirmPanel:popout()
	end)
end

function PhoneRegisterPanel:initInput()
	
	local function onTextBegin()
		print("onTextBegin!!!!!!!!!!!!!!!")
	end

	local function onTextEnd()
		print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
		if self.input then
			local text = self.input:getText() or ""
			if text ~= "" then
				self.btnNext:setEnabled(true)
				self.phoneNumber = self.input:getText()
				print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
			end
		end
	end

	local function onTextChanged()
		if self.input then
			local text = self.input:getText() or ""
			he_log_info("current text: "..tostring(text))

			if string.isEmpty(text) then
				self.btnNext:setEnabled(false)
			else
				self.btnNext:setEnabled(true)
			end
		end
	end

	local input = Input:create(self.ui:getChildByName("textPhone"), self)
	input:setText(self.phoneNumber or "")
	input:setFontColor(ccc3(180,94,16))
	input:setPlaceholderFontColor(ccc3(241, 208, 165))
	input:setMaxLength(11)
	input:setInputMode(kEditBoxInputModePhoneNumber)
	input:ad(kTextInputEvents.kBegan, onTextBegin)
	input:ad(kTextInputEvents.kEnded, onTextEnd)
	input:ad(kTextInputEvents.kChanged, onTextChanged)
	self.ui:addChild(input)
	input:setPlaceHolder(localize("login.panel.intro.13"))
	self.input = input
end

function PhoneRegisterPanel:create(closeCallback, mode, initPhoneNumber, cloneStatePanel)
	local panel = PhoneRegisterPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_register)
	panel:init(closeCallback, mode, initPhoneNumber)

	print("PhoneRegisterPanel.mode before clone: ", panel.mode)
	if cloneStatePanel then
		print("cloneStatePanel: ", cloneStatePanel.mode)
		cloneStatePanel:cloneStateTo(panel)
		panel.preCloseCallback = cloneStatePanel.closeCallback
		print("PhoneRegisterPanel.mode after clone: ", panel.mode)
	end

	print("panel.loadRequiredResource", tostring(panel.loadRequiredResource))

	return panel
end
