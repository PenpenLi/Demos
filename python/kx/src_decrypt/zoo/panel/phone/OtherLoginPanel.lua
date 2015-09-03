local Input = require "zoo.panel.phone.Input"
local Title = require "zoo.panel.phone.Title"
local Button = require "zoo.panel.phone.Button"

OtherLoginPanel = class(BasePanel)

function OtherLoginPanel:create( closeCallback,cloneStatePanel )
	local panel = OtherLoginPanel.new()
	panel:loadRequiredResource("ui/login.json")	
	panel:init(closeCallback)
	if cloneStatePanel then 
		cloneStatePanel:cloneStateTo(panel)
	end
	return panel
end


function OtherLoginPanel:init( closeCallback )
	self.ui = self:buildInterfaceGroup("OtherLoginPanel")
	BasePanel.init(self, self.ui)

	self.closeCallback = closeCallback

	local bounds = self.ui:getChildByName("bg"):getGroupBounds()
	self.size = bounds.size

	self.title = Title:create(self.ui:getChildByName("title"),false)
	-- self.title:addEventListener(Title.Events.kBackTap,function( ... )
	-- 	self:onKeyBackClicked()
	-- end)

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap,function( ... )
		self:onKeyBackClicked()
	end)



	local icons = {}
	-- 
	local authConfigs = {}
	for _,v in pairs(PlatformConfig:getAuthConfigs()) do
		if v ~= PlatformAuthEnum.kGuest then
			table.insert(authConfigs,v) 
		end
	end

    local order = {
        [PlatformAuthEnum.kQQ]    = 1,
        [PlatformAuthEnum.kPhone] = 2,
        [PlatformAuthEnum.kWeibo] = 3,
        [PlatformAuthEnum.k360]   = 4,
        [PlatformAuthEnum.kWDJ]   = 5,
        [PlatformAuthEnum.kMI]    = 6,
    }
    table.sort(authConfigs,function(a,b) return order[a] < order[b] end)

	local bigIconContainer = self.ui:getChildByName("bigIconContainer")
	local oneMiniIconContainer = self.ui:getChildByName("oneMiniIconContainer")
	local twoMiniIconContainer = self.ui:getChildByName("twoMiniIconContainer")

	bigIconContainer:setChildrenVisible(false,false)
	oneMiniIconContainer:setChildrenVisible(false,false)
	twoMiniIconContainer:setChildrenVisible(false,false)

	local function buildIcon( isBig,authorType,boundingBox )
		local icon = nil
		if isBig then
			icon = self:buildInterfaceGroup("login/icon/icon_" .. PlatformAuthDetail[authorType].name)
		else
			icon = self:buildInterfaceGroup("login/icon/mini_icon_" .. PlatformAuthDetail[authorType].name)
		end
		icon:setPositionX(boundingBox:getMidX())
		icon:setPositionY(boundingBox:getMidY())
		icon:setTouchEnabled(true)
		icon:setButtonMode(true)
		icon:addEventListener(DisplayEvents.kTouchTap,function( ... )
			self:onLoginIconTap(authorType)
		end)
		self.ui:addChild(icon)
	end
	
	local boundingBox = bigIconContainer:getChildByName("1"):boundingBox()
	buildIcon(true,authConfigs[1],boundingBox)

	if #authConfigs == 2 then
		local boundingBox = oneMiniIconContainer:getChildByName("1"):boundingBox()
		buildIcon(false,authConfigs[2],boundingBox)
	elseif #authConfigs > 2 then
		for i=2,3 do
			local boundingBox = twoMiniIconContainer:getChildByName(tostring(i-1)):boundingBox()
			buildIcon(false,authConfigs[i],boundingBox)
		end
	end

end

function OtherLoginPanel:onLoginIconTap( authEnum )
	self:remove()

	if self.action == "ChangeAccountMode" then 
		DcUtil:UserTrack({ category='login', sub_category='login_switch_account_type',object=authEnum })
	else
		DcUtil:UserTrack({ category='login', sub_category='login_account_type',object=authEnum })
   	end

   	print("self.action: ", self.action)
	if authEnum == PlatformAuthEnum.kPhone then
		local lastLoginPhoneNumber = Localhost:getLastLoginPhoneNumber()
		local panel = nil
		if string.len(lastLoginPhoneNumber) > 0 then
			panel = PhoneLoginPanel:create(function( ... )
				OtherLoginPanel:create(self.closeCallback,self):popout()
			end,nil)
			panel:setPhoneNumber(lastLoginPhoneNumber)
			panel:setMode(self.mode)

			if self.action == "ChangeAccountMode" then 
				DcUtil:UserTrack({ category='login', sub_category='login_switch_account_phone_login' })			
			else
				DcUtil:UserTrack({ category='login', sub_category='login_account_phone_login', place = 1})
			end
		else
			panel = PhoneRegisterPanel:create(function(...)
				OtherLoginPanel:create(self.closeCallback,self):popout()
			end, kModeRegister, nil, nil)
			panel:setMode(kModeRegister)
			panel:setPreCloseCallback(self.closeCallback)
			print("after set mode: ", panel.mode)
			panel:setWhere(self.action == "ChangeAccountMode" and 2 or 1)
			print("PhoneRegisterPanel.where: ", panel.where)

			if self.action == "ChangeAccountMode" then 
				DcUtil:UserTrack({ category='login', sub_category='login_switch_account_phone_register' })
			else
				DcUtil:UserTrack({ category='login', sub_category='login_account_phone_register', place = 1})			
			end
		end

		panel:setSelectSnsCallback(self.selectCallback)
		panel:setPhoneLoginCompleteCallback(self.phoneLoginCompleteCallback)
		panel:setAction(self.action)
		panel:setPlace(1)
		panel:popout()
	else
		if self.selectCallback then 
			self.selectCallback(authEnum)
		end
	end


end

function OtherLoginPanel:popout( ... )

	PopoutManager:sharedInstance():add(self,true,false)

	local visibleSize = Director.sharedDirector():getVisibleSize()
	local visibleOrigin = Director:sharedDirector():getVisibleOrigin()

	local bounds = self.ui:getChildByName("bg"):getGroupBounds()

	self.position = ccp(
		visibleSize.width/2 - bounds.size.width/2,
		-visibleSize.height/2 + bounds.size.height/2
	)
	self:setPositionX(self.position.x)
	self:setPositionY(self.position.y)

end

function OtherLoginPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self)
end

function OtherLoginPanel:onKeyBackClicked()
	self:remove()

	if self.closeCallback then 
		self.closeCallback()
	end

end

function OtherLoginPanel:setSelectSnsCallback( selectCallback )
	self.selectCallback = selectCallback
end
function OtherLoginPanel:setPhoneLoginCompleteCallback( phoneLoginCompleteCallback )
	self.phoneLoginCompleteCallback = phoneLoginCompleteCallback
end 

function OtherLoginPanel:setAction( action )
	self.action = action
	if action == "ChangeAccountMode" then
		self.title:setText(Localization:getInstance():getText("login.panel.title.2"))--切换账号
	else
		self.title:setText(Localization:getInstance():getText("login.panel.title.1"))--"账号登陆"
	end
end

function OtherLoginPanel:setMode( mode )
	self.mode = mode
end

function OtherLoginPanel:setPlace( place )
	self.place = place
end

function OtherLoginPanel:setWhere( where )
-- 1=点手机号登录弹出 
-- 2=点切换手机号登录时弹出 
	self.where = where
end

function OtherLoginPanel:cloneStateTo( panel )
	assert(panel:is(OtherLoginPanel))

	panel:setSelectSnsCallback(self.selectCallback)
	panel:setPhoneLoginCompleteCallback(self.phoneLoginCompleteCallback)

	--[[if self.mode then
		panel:setMode(self.mode)
	else
		print("mode from previous panel is nil!!!!!!!!!!!!!!!!!!!!")
	end]]--
	panel:setPlace(self.place)
	panel:setWhere(self.where)
	panel:setAction(self.action)
end