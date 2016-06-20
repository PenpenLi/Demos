local Input = require "zoo.panel.phone.Input"
local Title = require "zoo.panel.phone.Title"
local Button = require "zoo.panel.phone.Button"

SelectLoginPanel = class(BasePanel)

function SelectLoginPanel:create(phoneLoginInfo)
	local panel = SelectLoginPanel.new()
	panel:loadRequiredResource("ui/login.json")	
	panel:init(phoneLoginInfo)
	return panel
end


function SelectLoginPanel:init(phoneLoginInfo)
	self.phoneLoginInfo = phoneLoginInfo

	self.ui = self:buildInterfaceGroup("SelectLoginPanel")
	BasePanel.init(self, self.ui)

	local bounds = self.ui:getChildByName("bg"):getGroupBounds()
	self.size = bounds.size

	local title = Title:create(self.ui:getChildByName("title"),false)
	title:setTextMode(phoneLoginInfo.mode,true)--"账号登陆"
	-- title:addEventListener(Title.Events.kBackTap,function( ... )
	-- 	self:onKeyBackClicked()
	-- end)

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap,function( ... )
		self:remove()
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
        [PlatformAuthEnum.k360]   = 2,
        [PlatformAuthEnum.kWDJ]   = 3,
        [PlatformAuthEnum.kMI]    = 4,
        [PlatformAuthEnum.kWeibo] = 5,
        [PlatformAuthEnum.kPhone] = 6,
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

function SelectLoginPanel:onLoginIconTap( authEnum )
	if authEnum == PlatformAuthEnum.kPhone then
		local panel = PhoneLoginPanel:create(self.phoneLoginInfo)
		panel:setPhoneLoginCompleteCallback(self.phoneLoginCompleteCallback)
		panel:popout()
	else
		PopoutStack:clear()
		if self.selectCallback then 
			self.selectCallback(authEnum)
		end
	end
end

function SelectLoginPanel:popout( ... )
	PopoutStack:push(self,true,false)
end

function SelectLoginPanel:remove( ... )
	if self.backCallback then 
		PopoutStack:clear()
		self.backCallback()
	else
		PopoutStack:pop()
	end
end

function SelectLoginPanel:onKeyBackClicked()
	self:remove()
end

function SelectLoginPanel:setSelectSnsCallback( selectCallback )
	self.selectCallback = selectCallback
end
function SelectLoginPanel:setPhoneLoginCompleteCallback( phoneLoginCompleteCallback )
	self.phoneLoginCompleteCallback = phoneLoginCompleteCallback
end
function SelectLoginPanel:setBackCallback( backCallback )
	self.backCallback = backCallback
end