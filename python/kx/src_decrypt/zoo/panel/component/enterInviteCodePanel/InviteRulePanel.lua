
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014Äê01ÔÂ 1ÈÕ 14:53:58
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- InviteRulePanel
---------------------------------------------------

assert(not InviteRulePanel)
assert(BasePanel)
InviteRulePanel = class(BasePanel)

function InviteRulePanel:init(...)
	assert(#{...} == 0)

	----------------------
	-- Get UI Componenet
	-- -----------------
	self.ui	= self:buildInterfaceGroup("inviteRulePanel")--ResourceManager:sharedInstance():buildGroup("inviteRulePanel")

	--------------------
	-- Init Base Class
	-- --------------
	BasePanel.init(self, self.ui)

	-------------------
	-- Get UI Componenet
	-- -----------------
	self.desLabel		= self.ui:getChildByName("desLabel")
	self.confirmBtnRes	= self.ui:getChildByName("confirmBtn")

	assert(self.desLabel)
	assert(self.confirmBtnRes)

	--------------------
	-- Create UI Componenet
	-- ----------------------
	self.confirmBtn		= GroupButtonBase:create(self.confirmBtnRes)

	--------------
	-- Init UI
	-- ----------
	self.ui:setTouchEnabled(true, 0, true)

	----------------
	-- Update View
	-- --------------
	
	-- Panel Title
	local panelTitleKey	= "invite.friend.panel.rule02"
	local panelTitleValue	= Localization:getInstance():getText(panelTitleKey, {})
	self.panelTitle = TextField:createWithUIAdjustment(self.ui:getChildByName("panelTitleSize"), self.ui:getChildByName("panelTitle"))
	self.ui:addChild(self.panelTitle)
	self.panelTitle:setString(panelTitleValue)

	-- Description Label
	local desLabelKey	= "invite.friend.panel.rule.desc"
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then 
		desLabelKey	= "invite.friend.panel.rule.mitalk.desc"
	-- elseif PlatformConfig:isPlatform(PlatformNameEnum.k360) then
	-- 	desLabelKey	= "invite.friend.panel.rule.360.desc"
	end
	local desLabelValue	= Localization:getInstance():getText(desLabelKey, {n = "\n"})
	self.desLabel:setString(desLabelValue)

	-- Confirm Button
	
	local confirmBtnKey	= "button.ok"
	local confirmBtnValue	= Localization:getInstance():getText(confirmBtnKey, {})
	self.confirmBtn:setString(confirmBtnValue)
	self.confirmBtn:useBubbleAnimation()
	----------------------
	-- Add Event Listener
	-- -------------------
	
	local function onConfirmBtnTapped(event)
		self:onConfirmBtnTapped(event)
	end
	self.confirmBtn:addEventListener(DisplayEvents.kTouchTap, onConfirmBtnTapped)
end

function InviteRulePanel:onConfirmBtnTapped(event, ...)
	assert(#{...} == 0)

	self:onCloseBtnTapped()
end

function InviteRulePanel:popout(...)
	assert(#{...} == 0)

	PopoutManager:sharedInstance():add(self, true, false)
	self:setToScreenCenterHorizontal()
	self:setToScreenCenterVertical()
	self.allowBackKeyTap = true
end

function InviteRulePanel:onCloseBtnTapped(...)
	assert(#{...} == 0)

	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self, true)
end

function InviteRulePanel:create(...)
	assert(#{...} == 0)

	local newInviteRulePanel = InviteRulePanel.new()
	newInviteRulePanel:loadRequiredResource(PanelConfigFiles.panel_game_setting)
	newInviteRulePanel:init()
	return newInviteRulePanel
end
function InviteRulePanel:loadRequiredResource( panelConfigFile )
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end

