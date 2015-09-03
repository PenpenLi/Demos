require "zoo.panel.phone.ChangeBindingCodePanel"
require "zoo.panel.phone.AccountConfirmPanel"

local Button = require "zoo.panel.phone.Button"
local Title = require "zoo.panel.phone.Title"
local Input = require "zoo.panel.phone.Input"

PhoneChangeBindingPanel = class(PhoneRegisterPanel)

function PhoneChangeBindingPanel.ctor()

end

function PhoneChangeBindingPanel:initTitle()
	local title = Title:create(self.ui:getChildByName("title"),true)
	title:setText(localize("login.panel.title.5"))
	title:addEventListener(Title.Events.kBackTap,function( ... )

		self:onCloseBtnTapped()

		local sub_cate = 'login_account_change_binding_back'
		DcUtil:UserTrack({ category='login', sub_category=sub_cate, step=2, place=self.place })

		--local confirmPanel = PhoneConfirmPanel:create(function()
		--end, nil)
		--confirmPanel:initLabel("是否中断更改绑定？", localize("login.panel.button.12"), localize("login.panel.button.13"))
		--confirmPanel:popout()
	end)
end

function PhoneChangeBindingPanel:setAccountTip()
	self.input:setPlaceHolder(localize("login.panel.intro.19"))
end

function PhoneChangeBindingPanel:sendVerifyPhoneRequest()
	--to check the phone number.

	local function onCheckSuccess(responseData)
		HttpsClient.setSessionId(responseData.sessionId)

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
			if not self.iconCheck:isVisible()  then
				CommonTip:showTip(localize("login.tips.content.2"), "negative",
						function() self.errorTip:setVisible(true) end
						,2)
				return
			end

			local function confirmPhoneNumber()
				self:remove()

				local panel = ChangeBindingCodePanel:create(
					function() PhoneChangeBindingPanel:create(self.closeCallback,self.successCallback, self.phoneNumber, self):popout() end,
					self.successCallback,
					self.phoneNumber,
					self)
				panel:popout()
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

			openPhoneConfirm()
		end
	end

	local function onCheckError(errorCode, errMsg)
		print("errorCode: ", errorCode)
		print("errMsg: ", errMsg)
		CommonTip:showTip(localize("phone.register.error.tip."..errorCode), "negative",nil,2)
	end

	local udid = __WIN32 and "thisisamockudid" or UdidUtil:getUdid()

	local httpClient = HttpsClient:create(
		"vertifyBindingPhoneNumber", 
		{phoneNumber = self.input:getText(), udid = udid, rebinding = "true"}, 
		onCheckSuccess, 
		onCheckError
	)
	httpClient:send()
end

function PhoneChangeBindingPanel:create(closeCallback, successCallback, initPhoneNumber, cloneStatePanel)
	print("PhoneChangeBindingPanel created!!!!!!!!!!!!")
	local panel = PhoneChangeBindingPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_register)
	panel:init(closeCallback,kModeChangeBinding, initPhoneNumber)
	panel.successCallback = successCallback

	if cloneStatePanel then
		cloneStatePanel:cloneStateTo(panel)
		panel.preCloseCallback = cloneStatePanel.closeCallback
	end

	return panel
end