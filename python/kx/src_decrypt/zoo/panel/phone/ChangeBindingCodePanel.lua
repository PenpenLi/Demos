ChangeBindingCodePanel = class(RegisterCodeConfirmPanel)

local Button = require "zoo.panel.phone.Button"
local Title = require "zoo.panel.phone.Title"
local Input = require "zoo.panel.phone.Input"

function ChangeBindingCodePanel.ctor()
end


function ChangeBindingCodePanel:initTitle()
	local title = Title:create(self.ui:getChildByName("title"),true)
	title:setText(localize("login.panel.title.5"))
	title:addEventListener(Title.Events.kBackTap,function( ... )

		self:onCloseBtnTapped()
		local sub_cate = 'login_account_change_binding_back'
		DcUtil:UserTrack({ category='login', sub_category=sub_cate, step = 3})

		--local panel = PhoneConfirmPanel:create(
		--	function()
		--	end, 
		--	nil)
		--panel:initLabel("是否中断更改绑定？", localize("login.panel.button.12"), localize("login.panel.button.18"))
		--panel:popout()
	end)
end

function ChangeBindingCodePanel:onGetCode()

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
			self.btnGetCode:setEnabled(tonumber(errorCode) ~= 206)

			if tonumber(errorCode) == 204 then --session timeout
				self:onCloseBtnTapped() --return back to the previous panel.
			end

			if tonumber(errorCode) == 206 then --send too many times, over limit!
				self:remove()
				--LoginAndRegisterPanel:create(self.preCloseCallback2, self):popout()
			end
		end
		CommonTip:showTip(content,"negative",CommonTipCallback, 2)
	end

	local httpClient = HttpsClient:create(
		"regRequestCode", 
		{phoneNumber=self.phoneNumber, method = "changeBinding"}, 
		function(data) self:onGetCodeSuccess(data) end, 
		onGetCodeError
	)
	httpClient:send()
	httpClient:setCustomizedOnError()
	self.btnGetCode:setEnabled(false)
end

--verify code------------------------------
function ChangeBindingCodePanel:verifyCodeSuccess()

	local sub_cate =  'login_account_change_binding'
	DcUtil:UserTrack({ category='login', sub_category=sub_cate, step = 3})

	--[[local panel = PhoneConfirmPanel:create()
	panel:initLabel("您已经成功更换手机号！当前消消乐号不可再次更换手机号~", "确定", "取消")
	panel:setOneButtonMode()
	panel:popout()]]--
	self:remove()
	PasswordSettingPanel:create(self.closeCallback,self.successCallback, self.phoneNumber, kModeChangeBinding, self):popout()
end

function ChangeBindingCodePanel:create(closeCallback, successCallback, phoneNumber, cloneStatePanel)
	local panel = ChangeBindingCodePanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_register)
	panel:init(closeCallback, phoneNumber, false)
	panel.successCallback = successCallback

	if cloneStatePanel then
		cloneStatePanel:cloneStateTo(panel)
		panel.preCloseCallback = cloneStatePanel.closeCallback
	end
	return panel
end