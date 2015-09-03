

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月17日 10:03:11
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.baseUI.BaseUI"

require "zoo.gameGuide.GameGuide"

---------------------------------------------------
-------------- BasePanel
---------------------------------------------------

assert(not BasePanel)
assert(BaseUI)
BasePanel = class(BaseUI)

kPanelEvents = {
	kClose = "kPanelEvents.kClose",
	kButton = "kPanelEvents.kButton",
	kUpdate = "kPanelEvents.kUpdate",
}

function BasePanel:init(ui, panelName, ...)
	assert(ui ~= nil)
	--assert(panelName == false or type(panelName) == "string")
	assert(#{...} == 0)

	self.panelName		= "noName"
	self.allowBackKeyTap	= false		-- Flag To Indicate Panel Showed And Fixed

	if panelName then
		self.panelName = panelName
	end

	-- Init Base
	BaseUI.init(self, ui)

	---- OnEnter Event
	local function onEnterHandler(event, ...)
		assert(event)
		assert(#{...} == 0)

		self:onEnterHandler(event)
	end
	self:registerScriptHandler(onEnterHandler)
end

function BasePanel:dispose()
	if type(self.unloadRequiredResource) == "function" then self:unloadRequiredResource() end
	BaseUI.dispose(self)
end

function BasePanel:loadRequiredResource( panelConfigFile )
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:createWithContentsOfFile(panelConfigFile)
end
function BasePanel:loadRequiredJson( panelConfigFile )
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end
function BasePanel:unloadRequiredResource()
	if self.panelConfigFile then
		InterfaceBuilder:unloadAsset(self.panelConfigFile)
	end
end

function BasePanel:buildInterfaceGroup( groupName )
	if self.builder then return self.builder:buildGroup(groupName)
	else return nil end
end

function BasePanel:scaleAccordingToResolutionConfig(...)
	assert(#{...} == 0)

	-- Config
	local config 		= UIConfigManager:sharedInstance():getConfig()
	local panelScale	= config.panelScale

	self:setScale(panelScale)
end

function BasePanel:onKeyBackClicked(...)
	assert(#{...} == 0)

	print("BasePanel:onKeyBackClicked !", self.allowBackKeyTap, self.onCloseBtnTapped)
	if self.allowBackKeyTap then

		if self.onCloseBtnTapped then
			self:onCloseBtnTapped()
		end
	end
end

function BasePanel:onEnterHandler(event, ...)
	assert(event)
	assert(#{...} == 0)

	if event == "enter" then
		if GameGuide then
			GameGuide:sharedInstance():onPopup(self)
		end
	elseif event == "exit" then
		if GameGuide then
			GameGuide:sharedInstance():onPopdown(self)
		end
	end
end

function BasePanel:setPositionForPopoutManager()
	local vSize = CCDirector:sharedDirector():getVisibleSize()
	local wSize = CCDirector:sharedDirector():getWinSize()
	local vOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local posAdd = wSize.height - vSize.height - vOrigin.y
	self:setPosition(ccp(self:getHCenterInScreenX(), -(vSize.height - self:getVCenterInScreenY() + posAdd)))
end

function BasePanel:popoutShowTransition()
end

function BasePanel:child(name)
	return self.ui:getChildByName(name)
end

function BasePanel:createTouchButton(name, onTapped)
	local btn = self.ui:getChildByName(name)
	btn:setTouchEnabled(true)
	btn:setButtonMode(true)
	btn:ad(DisplayEvents.kTouchTap, onTapped)

	return btn
end
