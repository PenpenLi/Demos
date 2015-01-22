
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014Äê01ÔÂ 1ÈÕ 14:34:30
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- InviteBtn
---------------------------------------------------

assert(not InviteBtn)
assert(BasePanel)
InviteBtn = class(BasePanel)

function InviteBtn:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	-----------------
	-- Init Base Class
	-- ----------------
	BasePanel.init(self, ui)

	-----------------
	-- Get UI Componenet
	-- -----------------
	self.buttonRes = self.ui:getChildByName("button")
	
	-------------------
	-- Create UI Componenet
	-- --------------------
	self.button	= ButtonWithShadow:create(self.buttonRes)

	--------
	-- Init
	-- ------
	self.ui:setTouchEnabled(true, 0, true)
	self.ui:setButtonMode(true)

	self.button.ui:setButtonMode(false)
	self.button.ui:setTouchEnabled(false)
end


function InviteBtn:setString(str, ...)
	assert(#{...} == 0)

	self.button:setString(str)
end

function InviteBtn:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newInviteBtn = InviteBtn.new()
	newInviteBtn:init(ui)
	return newInviteBtn
end
