
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014年01月 6日 16:11:27
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com


---------------------------------------------------
-------------- InviteFriendButton
---------------------------------------------------

assert(not InviteFriendButton)
assert(IconButtonBase)

InviteFriendButton = class(IconButtonBase)

function InviteFriendButton:init(...)
	assert(#{...} == 0)

	self.ui	= ResourceManager:sharedInstance():buildGroup("finalInviteFriendIcon")

	-- Init Base Class
	IconButtonBase.init(self, self.ui)
	local sprite = nil
	if PlatformConfig:isPlatform(PlatformNameEnum.k360) and
		not CCUserDefault:sharedUserDefault():getBoolForKey("invite.friend.new.tag") then
		sprite = Sprite:createWithSpriteFrameName("marketButton_new0000")
		local sSize = sprite:getContentSize()
		local bSize = self:getGroupBounds().size
		sprite:setPositionXY(bSize.width / 2 - sSize.width / 2, bSize.height - sSize.height / 2)
		self.wrapper:addChild(sprite)
	end

	local icon = self.wrapper:getChildByName("Layer 1")
	local icon_tw = self.wrapper:getChildByName("Layer 1_tw")
	if icon and icon_tw then 
		icon:setVisible(not _G.useTraditionalChineseRes)
		icon_tw:setVisible(_G.useTraditionalChineseRes)
	end

	local function onClick()
		if sprite then
			sprite:removeFromParentAndCleanup(true)
			sprite = nil
			CCUserDefault:sharedUserDefault():setBoolForKey("invite.friend.new.tag", true)
		end
	end

	self.wrapper:setTouchEnabled(true, 0, true)
	if sprite then
		self.wrapper:addEventListener(DisplayEvents.kTouchTap, onClick)
	end
end

function InviteFriendButton:create(...)
	assert(#{...} == 0)

	local newInviteFriendButton = InviteFriendButton.new()
	newInviteFriendButton:init()
	return newInviteFriendButton
end

