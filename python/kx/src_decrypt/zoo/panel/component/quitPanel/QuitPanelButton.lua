
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ31ÈÕ 10:17:43
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- QuitPanelButton
---------------------------------------------------

assert(not QuitPanelButton)
assert(BaseUI)
QuitPanelButton = class(BaseUI)

function QuitPanelButton:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	---------------
	-- Init Base Class
	-- ----------------
	BaseUI.init(self, ui)

	----------------
	-- Get UI Resource
	-- ---------------
	self.helpIcon	= self.ui:getChildByName("helpIcon")
	self.quitIcon	= self.ui:getChildByName("quitIcon")
	self.replayIcon	= self.ui:getChildByName("replayIcon")

	self.buttonRes	= self.ui:getChildByName("button")

	assert(self.helpIcon)
	assert(self.quitIcon)
	assert(self.replayIcon)
	assert(self.buttonRes)

	-------------
	-- Init UI 
	-- ----------
	self.helpIcon:setVisible(false)
	self.quitIcon:setVisible(false)
	self.replayIcon:setVisible(false)

	self.ui:setButtonMode(true)
	self.ui:setTouchEnabled(true)

	-----------------
	-- Create UI Component
	-- -------------------
	self.button	= ButtonWithShadow:create(self.buttonRes)
	self.button.ui:setButtonMode(false)
	self.button.ui:setTouchEnabled(false)
end

function QuitPanelButton:setString(string, ...)
	assert(#{...} == 0)

	self.button:setString(string)
end

function QuitPanelButton:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newQuitPanelButton = QuitPanelButton.new()
	newQuitPanelButton:init(ui)
	return newQuitPanelButton
end
