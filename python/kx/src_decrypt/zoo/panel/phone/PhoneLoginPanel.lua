local LOGIN_PASSWORD_MISMATCH = 213 --密码错误
local LOGIN_PASSWORD_MISMATCH_ERROR = 214 -- 次数太多
local PHONE_NUMBER_NOT_REGISTED = 201
local INVALID_PHONE_NUMBER = 203

local visibleSize = Director.sharedDirector():getVisibleSize()
local visibleOrigin = Director:sharedDirector():getVisibleOrigin()

-- require "zoo.net.Https"
require "zoo.net.HttpsClient"
require "zoo.panel.phone.OtherLoginPanel"
--require "zoo.panel.phone.PhoneRegisterPanel"
require "zoo.panel.phone.PhoneConfirmPanel"

local Input = require "zoo.panel.phone.Input"
local Title = require "zoo.panel.phone.Title"
local Button = require "zoo.panel.phone.Button"

PhoneLoginDropDownPanel = class(BasePanel)
function PhoneLoginDropDownPanel:create( phoneNumber, pos )
	local panel = PhoneLoginDropDownPanel.new()
	panel:loadRequiredResource("ui/login.json")
	panel:init(phoneNumber,pos)
	return panel
end
-- function PhoneLoginDropDownPanel:loadRequiredJson( panelConfigFile )
-- 	-- self.panelConfigFile = panelConfigFile
-- 	self.builder = InterfaceBuilder:create(panelConfigFile)
-- end
function PhoneLoginDropDownPanel:init( phoneNumber,pos )
	self.ui = self:buildInterfaceGroup("login/drowDownPanel")
	BasePanel.init(self, self.ui)
	
	self.size = self.ui:getChildByName("bg"):getGroupBounds().size

	self:updatePostion(pos)

	local function onTouch( eventType, x, y )
		if eventType == "began" then
			local leftBottom = self.ui:convertToWorldSpace(ccp(0,-self.size.height))
			local rightTop = self.ui:convertToWorldSpace(ccp(self.size.width,0))

			if not (x > leftBottom.x and x < rightTop.x and y > leftBottom.y and y < rightTop.y) then
				self:onKeyBackClicked()
				-- return true
			end
		end
		return true
	end
	local touchLayer = CCLayer:create()
	touchLayer:registerScriptTouchHandler(onTouch,false,0,true)
	touchLayer:setTouchEnabled(true)
	self.ui:addChild(CocosObject.new(touchLayer))

	local phoneList = Localhost:readCachePhoneListData()
	if string.len(phoneNumber) == 11 then 
		table.removeValue(phoneList,phoneNumber)
		table.insert(phoneList,1,phoneNumber)
	end 
	self.cells = {}
	for i,v in ipairs(phoneList) do
		local cell = self:buildInterfaceGroup("login/drowDownItem")
		
		cell:getChildByName("text1"):setVisible(i == 1)
		cell:getChildByName("bg1"):setVisible(i == 1)
		cell:getChildByName("text2"):setVisible(i ~= 1)
		cell:getChildByName("bg2"):setVisible(i ~= 1)

		cell:getChildByName("text1"):setVerticalAlignment(kCCVerticalTextAlignmentCenter)
		cell:getChildByName("text2"):setVerticalAlignment(kCCVerticalTextAlignmentCenter)

		cell:getChildByName("text1"):setAnchorPoint(ccp(0,0.5))		
		cell:getChildByName("text2"):setAnchorPoint(ccp(0,0.5))

		cell:getChildByName("text1"):setPositionY(-cell:getGroupBounds().size.height/2)
		cell:getChildByName("text2"):setPositionY(-cell:getGroupBounds().size.height/2)

		if i == 1 then 
			cell:getChildByName("text1"):setString(v)
		else
			cell:getChildByName("text2"):setString(v)
		end
		cell:setTouchEnabled(true)
		cell:addEventListener(DisplayEvents.kTouchTap,function( ... )
			self:remove()
			if self.selectCompleteCallback then 
				self.selectCompleteCallback(v)
			end
		end)
		table.insert(self.cells,cell)
	end

	local listView = self:buildListView(self.size.width,self.size.height - 3)
	listView:setPositionY(-1)
	self.ui:addChild(listView)

end

function PhoneLoginDropDownPanel:updatePostion( pos )
	self:setPositionX(pos.x + visibleOrigin.x)
	self:setPositionY(-visibleSize.height + pos.y - visibleOrigin.y)
end

function PhoneLoginDropDownPanel:popout( ... )
	PopoutManager:sharedInstance():add(self,false,true)
end
function PhoneLoginDropDownPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self)
end
function PhoneLoginDropDownPanel:onKeyBackClicked( ... )
	self:remove()
	if self.selectCompleteCallback then 
		self.selectCompleteCallback(nil)
	end
end
function PhoneLoginDropDownPanel:buildListView(width,height)
	local layout = VerticalTileLayout:create(width)
	layout:setItemVerticalMargin(0)
	for k, v in pairs(self.cells) do 
		local item = ItemInClippingNode:create()
		item:setContent(v)
		-- v:setAnchorPoint(ccp(0, 0))
		item:setHeight(height/3)
		item:setParentView(container)
		layout:addItem(item)
	end

	local layoutHeight = layout:getHeight()
	if layoutHeight > height then		
		local container = VerticalScrollable:create(width, height, true, false)
		container:setContent(layout)
		return container
	else
		return layout
	end
end
function PhoneLoginDropDownPanel:setSelectCompleteCallback( selectCompleteCallback )
	self.selectCompleteCallback = selectCompleteCallback
end



PhoneLoginPanel = class(BasePanel)

function PhoneLoginPanel:ctor( ... )
	self:setPlace(1)
end

function PhoneLoginPanel:create( closeCallback,cloneStatePanel )
	local panel = PhoneLoginPanel.new()
	panel:loadRequiredResource("ui/login.json")	
	panel:init( closeCallback )

	if cloneStatePanel then 
		cloneStatePanel:cloneStateTo(panel)
	end
	return panel
end

function PhoneLoginPanel:cloneStateTo( panel )
	assert(panel:is(PhoneLoginPanel))

	panel:setPhoneLoginCompleteCallback(self.phoneLoginCompleteCallback)
	panel:setSelectSnsCallback(self.selectSnsCallback)

	--[[if self.mode then
		panel:setMode(self.mode)
	else
		print("mode from previous panel is nil!!!!!!!!!!!!!!!!!!!!")
	end]]--
	panel:setPlace(self.place)
	panel:setWhere(self.where)
	panel:setAction(self.action)

	if self.isShowCloseButton and panel.showCloseButton then 
		panel:showCloseButton()
	end

	if self.phoneNumber and panel.setPhoneNumber then
		panel:setPhoneNumber(self.phoneNumber)
	end
end


function PhoneLoginPanel:init( closeCallback )
	self.ui = self:buildInterfaceGroup("PhoneLoginPanel")
	BasePanel.init(self, self.ui)

	self.closeCallback = closeCallback

	self.title = Title:create(self.ui:getChildByName("title"),true)
	self.title:addEventListener(Title.Events.kBackTap,function( ... )
		
		local function onCancel( ... )
			-- body
		end
		local function onConfirm( ... )
			self:onKeyBackClicked()
		end

		local confirmPanel = PhoneConfirmPanel:create(onConfirm,onCancel,onCancel)
		confirmPanel:initLabel(
			-- 点击“返回”将中断登录，是否确定中断登录？
			Localization:getInstance():getText("login.alert.content.7"),
			-- 确定返回
			Localization:getInstance():getText("login.panel.button.12"),
			-- 继续登录
			Localization:getInstance():getText("login.panel.button.22")
		)
		
		confirmPanel:popout()

	end)

	self.closeBtn = self.ui:getChildByName("closeBtn")
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:setVisible(false)
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if self.closeBtn:isVisible() then
			self:onKeyBackClicked()
		end
	end)

	self.phoneInput = Input:create(self.ui:getChildByName("phone"),self)

	local function onBeganInput()
		if self.isDisposed then
			return
		end

		if self.drowDownPanel then
			self.drowDownPanel:remove()
			self.drowDownPanel = nil;
		end
	end

	self.phoneInput:setPlaceHolder(Localization:getInstance():getText("login.panel.intro.13"))--"请输入您的手机号"
	self.phoneInput:setMaxLength(11)
	self.phoneInput:setInputMode(kEditBoxInputModePhoneNumber)
	self.phoneInput:addEventListener(kTextInputEvents.kChanged,function( ... )
		self.phoneNumber = self.phoneInput:getText()
		self:updateLoginButton()
	end)
	self.phoneInput:addEventListener(kTextInputEvents.kBegan,function( ... )
		setTimeOut(onBeganInput, 0.2)
	end)
	local phoneList = Localhost:readCachePhoneListData()
	if #phoneList == 0 then
		self.ui:runAction(CCCallFunc:create(function() self.phoneInput:openKeyBoard() end))
	end

	self.ui:addChild(self.phoneInput)
	self.passwordInput = Input:create(self.ui:getChildByName("password"),self)
	self.passwordInput:setPlaceHolder(Localization:getInstance():getText("login.panel.intro.14"))--"请输入您的密码"
	self.ui:addChild(self.passwordInput)
	self.passwordInput:setInputFlag(kEditBoxInputFlagPassword)
	self.passwordInput:addEventListener(kTextInputEvents.kChanged,function( ... )
		self:updateLoginButton()
	end)
	self.passwordInput:addEventListener(kTextInputEvents.kBegan,function( ... )
		setTimeOut(onBeganInput, 0.2)
	end)

	self.dropDownPos = self.ui:getChildByName("dropDownPos")
	self.dropDownPos:setVisible(false)
	self.dropDownButton = self.ui:getChildByName("dropDownButton")
	self.dropDownButton:setTouchEnabled(true)
	self.dropDownButtonArrow = self.dropDownButton:getChildByName("arrow")

	self.dropDownButtonArrow:setRotation(180)
	self.dropDownButton:addEventListener(DisplayEvents.kTouchTap,function( ... )
		-- if self.dropDownButtonArrow:getRotation() == 0 then 
		-- 	return
		-- end
		if self.phoneInput.inputBegan or self.passwordInput.inputBegan then
			print("dropdown return!!!!!!!!!!!")
			return
		end

		self.dropDownButtonArrow:setRotation(0)
		local pos = self.ui:convertToWorldSpace(self.dropDownPos:getPosition())
		self.drowDownPanel = PhoneLoginDropDownPanel:create(self.phoneNumber or "",pos)
		self.drowDownPanel:setSelectCompleteCallback(function ( phoneNumber )

			self.dropDownButtonArrow:setRotation(180)
			if phoneNumber then
				if self.phoneNumber~=phoneNumber then
					self.passwordInput:setText("")
				end
				self.phoneInput:setText(phoneNumber)
				self.phoneNumber = phoneNumber
			end
			self.drowDownPanel = nil
		end)
		self.drowDownPanel:popout()
	end)

	local button = Button:create(self.ui:getChildByName("button"))
	button:setText(Localization:getInstance():getText("login.panel.button.19"))--登录
	button:setTouchEnabled(true)
	button:addEventListener(DisplayEvents.kTouchTap,function( ... )
		self:onLoginTapped()
	end)
	self.btnLogin = button

	local quickRegister = self.ui:getChildByName("quickRegister")
	quickRegister:setTouchEnabled(true)
	quickRegister:setButtonMode(true)
	quickRegister:getChildByName("text"):setString(Localization:getInstance():getText("login.panel.button.20"))--"快速注册"
	quickRegister:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if quickRegister:isVisible() then
			self:onQuickRegisterTap()
			DcUtil:UserTrack({ category='login', sub_category='login_account_phone_register',place=1 })
		end
	end)

	local forgetPassword = self.ui:getChildByName("forgetPassword")
	forgetPassword:setTouchEnabled(true)
	forgetPassword:setButtonMode(true)
	forgetPassword:getChildByName("text"):setString(Localization:getInstance():getText("login.panel.button.21")) --找回密码
	forgetPassword:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if forgetPassword:isVisible() then
			self:onForgetPasswordTap(self.phoneNumber)
		end
	end)

	self.quickRegister = quickRegister
	self.forgetPassword = forgetPassword
	self:updateLoginButton()
	-- local https = Https.new("phoneLogin")
	-- https:addEventListener(Events.kComplete, function( evt )
	-- 	print("https Events.kComplete")
	-- 	print(table.tostring(evt.data))
	-- end)
	-- https:addEventListener(Events.kError, function( evt )
	-- 	print("https Events.kError")
	-- 	print(table.tostring(evt.data))
	-- end)
	-- https:load()

	local scene = Director:sharedDirector():getRunningScene()

	self.quickRegister:setVisible(scene.name == "PreloadingScene")
	self.forgetPassword:setVisible(scene.name == "PreloadingScene")
end

function PhoneLoginPanel:updateLoginButton()
	self.btnLogin:setEnabled(not string.isEmpty(self.phoneNumber) and not string.isEmpty(self.passwordInput:getText()))
end

function PhoneLoginPanel:setPosition( pos )
	BasePanel.setPosition(self,pos)
	if self.drowDownPanel then
		local pos = self.ui:convertToWorldSpace(self.dropDownPos:getPosition())
		self.drowDownPanel:updatePostion(pos)
	end
end

function PhoneLoginPanel:onLoginTapped( ... )

	DcUtil:UserTrack({ category='login', sub_category='login_account_login',object=1, place = self.place })

	local phoneNumber = self.phoneInput:getText()
	local password = self.passwordInput:getText()

	if string.len(phoneNumber) <= 0 then
		--"请输入您的手机号"
		CommonTip:showTip(Localization:getInstance():getText("login.panel.intro.13")) 
		return
	end
	if string.len(password) <= 0 then
		-- "请输入您的密码"
		CommonTip:showTip(Localization:getInstance():getText("login.panel.intro.14"))
		return		
	end

	local function onSuccess( data )
		if self.isDisposed then
			return
		end

		self:remove()
	
		-- CommonTip:showTip("登录成功！","positive",nil,3)

		if self.phoneLoginCompleteCallback then
			self.phoneLoginCompleteCallback(data.openId,phoneNumber)
		end
	end

	local function onError( errorCode, errorMsg, data )
		if self.isDisposed then
			return
		end

		if errorCode == LOGIN_PASSWORD_MISMATCH then
			local remainCount = tonumber(data.remainCount) or 0
			if remainCount <= 0 then
				errorCode = LOGIN_PASSWORD_MISMATCH_ERROR
			end
		end
		if errorCode == LOGIN_PASSWORD_MISMATCH then 
			self:popoutWrongPasswordPanel(phoneNumber,data.remainCount)
		elseif errorCode == LOGIN_PASSWORD_MISMATCH_ERROR then
			self:popoutLockAccountPanel(phoneNumber)
		elseif errorCode == PHONE_NUMBER_NOT_REGISTED then 
			self:popoutNoRegistedPanel(phoneNumber)
		elseif errorCode == INVALID_PHONE_NUMBER then
			CommonTip:showTip(localize("phone.register.error.tip."..errorCode))
		else
			CommonTip:showTip(localize("phone.register.error.tip."..errorCode))
		end
	end

	local httpsClient = HttpsClient:create(
		"phoneLogin",
		{ phoneNumber = phoneNumber,password = HeMathUtils:md5(password)},
		onSuccess,
		onError
	)
	httpsClient:send()
end

function PhoneLoginPanel:onQuickRegisterTap(phoneNumber)

	DcUtil:UserTrack({ category='login', sub_category='login_account_login',object=2 , place = self.place})

	self:remove()
	local panel = PhoneRegisterPanel:create(function( ... )
		PhoneLoginPanel:create(self.closeCallback,self):popout()
	end,kModeRegister,phoneNumber or "", nil)
	panel:setMode(kModeRegister)
	panel:setPlace(self.place)
	panel:setPreCloseCallback(self.closeCallback)
	panel:setWhere(self.action == "ChangeAccountMode" and 2 or 1)
	panel:setPhoneLoginCompleteCallback(self.phoneLoginCompleteCallback)
	panel:setSelectSnsCallback(self.selectSnsCallback)
	panel:popout()
	print("PhoneLoginPanel:onQuickRegisterTap: ", self.place)
end

function PhoneLoginPanel:onForgetPasswordTap(phoneNumber)

	DcUtil:UserTrack({ category='login', sub_category='login_account_login',object=3, place = self.place })

	self:remove()
	local panel = PhoneRegisterPanel:create(function( ... )
		PhoneLoginPanel:create(self.closeCallback,self):popout()
	end,kModeRetrivePassword,phoneNumber or "", nil)
	panel:setMode(kModeRetrivePassword)
	panel:setPlace(self.place)
	panel:setPreCloseCallback(self.closeCallback)
	panel:setWhere(self.action == "ChangeAccountMode" and 2 or 1)
	panel:setPhoneLoginCompleteCallback(self.phoneLoginCompleteCallback)
	panel:setSelectSnsCallback(self.selectSnsCallback)
	panel:popout()
	print("PhoneLoginPanel:onForgetPasswordTap: ", self.place)
end

function PhoneLoginPanel:popoutWrongPasswordPanel( phoneNumber,remainCount )
	local function onGotPassword( ... )
		self:onForgetPasswordTap(phoneNumber)
	end

	local function onCancel( ... )
	end


	local confirmPanel = PhoneConfirmPanel:create(onGotPassword,onCancel,onCancel)
	confirmPanel:initLabel(
		-- "您输入的手机号或密码不正确，请确认后重新输入（还可输入5次）",
		Localization:getInstance():getText("login.alert.content.8",{num=remainCount}),
		-- "找回密码",
		Localization:getInstance():getText("login.panel.button.21"),
		-- "返回修改"
		Localization:getInstance():getText("login.panel.button.14")
	)
	confirmPanel:popout()
end

function PhoneLoginPanel:popoutLockAccountPanel( phoneNumber )
	local function onGotPassword( ... )
		self:onForgetPasswordTap(phoneNumber)
	end

	local function onCancel( ... )
	end


	local confirmPanel = PhoneConfirmPanel:create(onGotPassword, onCancel, onCancel)
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

function PhoneLoginPanel:popoutNoRegistedPanel( phoneNumber )
	local function onRegister( ... )
		self:onQuickRegisterTap(phoneNumber)
		DcUtil:UserTrack({ category='login', sub_category='login_account_phone_register',place=2 })
	end
	local function onCancel( ... )
	end

	local confirmPanel = PhoneConfirmPanel:create(onCancel,onRegister,onCancel)
	confirmPanel:initLabel(
		-- 该手机号尚未注册过消消乐
		Localization:getInstance():getText("login.alert.content.11"),
		-- "返回修改"
		Localization:getInstance():getText("login.panel.button.14"),
		-- 
		Localization:getInstance():getText("login.panel.button.20")
	)
	confirmPanel:popout()

end

function PhoneLoginPanel:popout( ... )

	PopoutManager:sharedInstance():add(self,true,false)

	local bounds = self.ui:getChildByName("bg"):getGroupBounds()

	self:setPosition(ccp(
		visibleSize.width/2 - bounds.size.width/2,
		-visibleSize.height/2 + bounds.size.height/2
	))

end


function PhoneLoginPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self)
end

function PhoneLoginPanel:onKeyBackClicked()

	self:remove()
	if self.closeCallback then 
		self.closeCallback()
	end
end

function PhoneLoginPanel:setPhoneLoginCompleteCallback( phoneLoginCompleteCallback )
	self.phoneLoginCompleteCallback = phoneLoginCompleteCallback
end 
function PhoneLoginPanel:setSelectSnsCallback( selectSnsCallback )
	self.selectSnsCallback = selectSnsCallback
end

function PhoneLoginPanel:setAction( action )
	self.action = action
	if action == "ChangeAccountMode" then
		self.title:setText(Localization:getInstance():getText("login.panel.title.2")) --切换账号
	else
		self.title:setText(Localization:getInstance():getText("login.panel.button.2"))--手机号登录
	end
end

function PhoneLoginPanel:setMode( mode )
	self.mode = mode
end

function PhoneLoginPanel:showCloseButton( ... )
	self.isShowCloseButton = true
	self.closeBtn:setVisible(true)
	self.title:setHasBackLink(false)
end

function PhoneLoginPanel:setPhoneNumber( phoneNumber )
	self.phoneNumber = phoneNumber
	self.phoneInput:setText(phoneNumber)
end

function PhoneLoginPanel:setPlace( place )
	self.place = place
end

function PhoneLoginPanel:setWhere( where )
-- 1=点手机号登录弹出 
-- 2=点切换手机号登录时弹出 
	self.where = where
end