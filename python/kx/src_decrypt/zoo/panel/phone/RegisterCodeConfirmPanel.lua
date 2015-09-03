require "zoo.panel.phone.PasswordSettingPanel"

local Button = require "zoo.panel.phone.Button"
local Title = require "zoo.panel.phone.Title"
local Input = require "zoo.panel.phone.Input"

RegisterCodeConfirmPanel = class(LoginAndRegisterPanel)

function RegisterCodeConfirmPanel.ctor()
end

function RegisterCodeConfirmPanel:onGetCodeSuccess(data)
	if self.isDisposed then
		return
	end
	self.countDown = data.countDown
	if self.scheduleScriptFuncID ~= nil then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.scheduleScriptFuncID)
		self.scheduleScriptFuncID = nil
	end

	self.scheduleScriptFuncID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function() self:updateCountDown() end,1,false)
	self:updateCountDown()
	self:registerSMS()

	DcUtil:UserTrack({ category='login', sub_category='login_account_get_code'})
end

function RegisterCodeConfirmPanel:onGetCode()

	local function onGetCodeError(errorCode, errorMsg)
		print("errorCode: ", errorCode)
		print("errMsg: ", errorMsg)
		local content = localize("error.tip.network.failure")
		if tonumber(errorCode) == 204 or tonumber(errorCode) == 206 then
			content = localize("phone.register.error.tip."..errorCode)
		end

		local function CommonTipCallback( ... )
			if self.isDisposed then
				return
			end

			if tonumber(errorCode) == 204 then --session timeout
				self:onCloseBtnTapped() --return back to the previous panel.
				return
			end

			self.btnGetCode:setEnabled(tonumber(errorCode) ~= 206)
			if tonumber(errorCode) == 206 then
				self:remove()

				OtherLoginPanel:create(self.preCloseCallback2, self):popout()
			end
		end

		CommonTip:showTip(content, "negative",CommonTipCallback, 2)
	end

	--clear the inbackgruond time first.
	_G.inBackgroundElapsedSeconds = 0

	local method = self.isRetrivePassword and "retrivePassword" or "register"
	local httpClient = HttpsClient:create(
		"regRequestCode", 
		{phoneNumber=self.phoneNumber, method = method}, 
		function(data) self:onGetCodeSuccess(data) end, 
		onGetCodeError
	)
	httpClient:setCancelCallback(function() self:resetCountDown() end)
	httpClient:setCustomizedOnError()
	httpClient:send()
	self.btnGetCode:setEnabled(false)
end

--verify code------------------------------
function RegisterCodeConfirmPanel:verifyCodeSuccess()
	self:remove()
	--local mode = self.isRetrivePassword and kModeRetrivePassword or kModeRegister
	print(" RegisterCodeConfirmPanel mode: ", tostring(self.mode))
	PasswordSettingPanel:create(function() 
			PhoneRegisterPanel:create(self.preCloseCallback, self.mode, self.phoneNumber, self):popout()
		end, nil, self.phoneNumber, self.mode, self):popout()
	
	local sub_cate = self.isRetrivePassword and 'login_account_find_password' or 'login_account_phone_register_step'
	DcUtil:UserTrack({ category='login', sub_category=sub_cate, step=2, place=self.place, where = self.where })
end

function RegisterCodeConfirmPanel:registerSMS()
	if __ANDROID then

		local mainActivity = luajava.bindClass("com.happyelements.hellolua.MainActivity")

		local function onSuccess(result)
			mainActivity:unRegisterSMSObserver()
			print("sms coming in lua: "..tostring(result))
			local startIndex, endIndex= string.find(result, "验证码为")
			print("sms coming in lua, startIndex: "..tostring(startIndex))
			if startIndex then
				local smsCode = string.sub(result, endIndex+1, endIndex+6)
				if self.input then
					self.input:setText(smsCode)
					self.btnNext:setEnabled(true)
				end
			end
	    end

	    local callback = luajava.createProxy("com.happyelements.android.InvokeCallback", {
	        onSuccess = onSuccess,
	        onError = nil,
	        onCancel = nil
	    })

	  	mainActivity:registerSMSObserver(callback)
	end

	--test code:
	-- setTimeOut(function()
	-- 		self.input:setText("123456")
	-- 		self.btnNext:setEnabled(true)
	-- 	end, 3)
end

function RegisterCodeConfirmPanel:unRegisterSMS()
	if __ANDROID then
		local mainActivity = luajava.bindClass("com.happyelements.hellolua.MainActivity")
		mainActivity:unRegisterSMSObserver()
	end
end

function RegisterCodeConfirmPanel:verifyRegisterCode()
	local function verifyCodeError(errorCode, errorMsg)
		print("errorCode: ", errorCode)
		print("errMsg: ", errorMsg)

		local content = localize("phone.register.error.tip."..errorCode)
		local callback = nil

		local function callback209()
			if self.isDisposed then
				return
			end
			if not self.scheduleScriptFuncID then --if it is not counting down
				self:resetCountDown()
			end
			self.input:openKeyBoard()
		end

		local function callback210()
			if self.isDisposed then
				return
			end
			self:resetCountDown()
			self.input:setText("")
			self.btnNext:setEnabled(false)
		end

		local function callback208()
			if self.isDisposed then
				return
			end
			self:resetCountDown()
			self.input:setText("")
			self.btnNext:setEnabled(false)
		end

		if tonumber(errorCode) == 209 then --verify code mismatch
			--content = localize("login.tips.content.3")
			callback = callback209
		elseif tonumber(errorCode) == 210 then --verify code mismatch too many times
			--content = localize("login.tips.content.4")
			callback = callback210
		elseif tonumber(errorCode) == 208 then --verify code expired
			--content = localize("login.tips.content.5")
			callback = callback208
		elseif tonumber(errorCode) == 28 then -- server response time out!
			--content = "服务器响应超时，请重试！"
		else
			--nothing to do.
		end

		CommonTip:showTip(content, "negative",callback, 2)
	end

	local httpClient = HttpsClient:create(
		"regVertifyCode", 
		{vertifyCode=self.registerCode}, 
		function(data) self:verifyCodeSuccess(data) end, 
		verifyCodeError
	)
	httpClient:send()

	self.btnGetCode:setEnabled(false)
end

function RegisterCodeConfirmPanel:resetCountDown()
	if self.isDisposed then
		return
	end
	self.countDown = -1
	if self.scheduleScriptFuncID ~= nil then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.scheduleScriptFuncID) 
		self.scheduleScriptFuncID = nil
	end
	self.btnGetCode:setText(localize("login.panel.button.16"))
	self.btnGetCode:setEnabled(true)
end

local function formatCountDown(countDownSeconds)
	local hours = math.floor(countDownSeconds/3600)
	local secs = countDownSeconds%3600
	local minutes = math.floor(secs/60)
	secs = secs%60

	if hours>0 then
		return string.format("%02d:%02d:%02d", hours, minutes, secs)
	end

	if minutes>0 then
		return string.format("%02d:%02d", minutes, secs)
	end

	return string.format("%02d", secs)
end

function RegisterCodeConfirmPanel:updateCountDown()
	if self.isDisposed then
		return
	end
	if _G.inBackgroundElapsedSeconds>0 then
		self.countDown = self.countDown - _G.inBackgroundElapsedSeconds
		_G.inBackgroundElapsedSeconds = 0
	end
	if self.countDown >= 0 then
		self.btnGetCode:setText(localize("login.panel.button.17", {num = formatCountDown(self.countDown)}))
		self.btnGetCode:setEnabled(false)
	else
		self:resetCountDown()
	end
	self.countDown = self.countDown - 1
end

function RegisterCodeConfirmPanel:init(closeCallback, phoneNumber, mode)
	self.ui	= self:buildInterfaceGroup("RegisterCodePanel")
	BasePanel.init(self, self.ui)

	self.phoneNumber = phoneNumber
	self.mode = mode
	self.isRetrivePassword = mode == kModeRetrivePassword
	self.closeCallback = closeCallback

	self:initTitle()

	local function onNext()
		--self:verifyCodeSuccess()

		self.registerCode = self.input:getText()
		print("RRR self.registerCode: "..tostring(self.registerCode))
		local codeMatch = string.find(self.input:getText(),"^%d%d%d%d%d%d$")
		print("RRR codeMatch: "..tostring(codeMatch))
		if not codeMatch or codeMatch~=1 then
			CommonTip:showTip(localize("login.tips.content.3"), "negative",function() self.input:openKeyBoard() end,2)
			return
		end

		self:verifyRegisterCode()
	end

	self.btnNext = Button:create(self:child("btnNext"), localize("login.panel.button.10"), onNext)
	self.btnNext:setEnabled(false)

	self.btnGetCode =  Button:create(self:child("btnGetCode"), 
		localize("login.panel.button.16"), 
		function() self:onGetCode() end)
	self:child("tipGetCode"):setString(localize("login.panel.intro.6", {num = self.phoneNumber}))
	self:onGetCode()

	self:initInput()
end

function RegisterCodeConfirmPanel:initTitle()
	local title = Title:create(self.ui:getChildByName("title"),true)
	title:setText(localize(self.isRetrivePassword and "login.panel.title.4" or "login.panel.title.3"))
	title:addEventListener(Title.Events.kBackTap,function( ... )

		local panel = PhoneConfirmPanel:create(
			function()
				self:onCloseBtnTapped()
				local sub_cate = self.isRetrivePassword and 'login_account_find_password_back' or 'login_account_phone_register_back'
				DcUtil:UserTrack({ category='login', sub_category=sub_cate, step=2, place=self.place, where = self.where})
			end, 
			nil)
		local contentKey = string.isEmpty(self.input:getText()) and "login.alert.content.4" or "login.alert.content.5" 
		local secondKey = string.isEmpty(self.input:getText()) and "login.panel.button.18" or "login.panel.button.13"
		panel:initLabel(localize(contentKey), localize("login.panel.button.12"), localize(secondKey))
		panel:popout()
	end)
end

function RegisterCodeConfirmPanel:initInput()
	
	local function onTextBegin()
		print("onTextBegin!!!!!!!!!!!!!!!")
	end

	local function onTextEnd()
		if self.input then
			local text = self.input:getText() or ""
	
			if text ~= "" then
				self.btnNext:setEnabled(true)
			end
		end
	end

	local function onTextChanged()
		if self.input then
			local text = self.input:getText() or ""

			if string.isEmpty(text) then
				self.btnNext:setEnabled(false)
			else
				self.btnNext:setEnabled(true)
			end
		end
	end

	local input = Input:create(self:child("textInput"), self)
	input:setText("")
	input:setFontColor(ccc3(180,94,16))
	input:setPlaceholderFontColor(ccc3(241, 208, 165))
	input:setMaxLength(6)
	input:setInputMode(kEditBoxInputModePhoneNumber)
	input:ad(kTextInputEvents.kBegan, onTextBegin)
	input:ad(kTextInputEvents.kEnded, onTextEnd)
	input:ad(kTextInputEvents.kChanged, onTextChanged)
	self.ui:addChild(input)
	input:setPlaceHolder(localize("login.panel.intro.5"))
	self.input = input
end

function RegisterCodeConfirmPanel:remove()
	if self.scheduleScriptFuncID ~= nil then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.scheduleScriptFuncID)
		self.scheduleScriptFuncID = nil
	end

	self:unRegisterSMS()

	LoginAndRegisterPanel.remove(self)
end

function RegisterCodeConfirmPanel:create(closeCallback, phoneNumber, mode, cloneStatePanel)
	local panel = RegisterCodeConfirmPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_register)
	panel:init(closeCallback, phoneNumber, mode)


	if cloneStatePanel then
		cloneStatePanel:cloneStateTo(panel)
		panel.preCloseCallback = cloneStatePanel.closeCallback
		panel.preCloseCallback2 = cloneStatePanel.preCloseCallback
	end
	return panel
end
