
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ17ÈÕ 11:46:00
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com


---------------------------------------------------
-------------- UserPicture
---------------------------------------------------

assert(not UserPicture)
assert(BaseUI)
UserPicture = class(BaseUI)


function UserPicture:init(...)
	assert(#{...} == 0)

	-- Get UI Resource 
	self.ui = ResourceManager:sharedInstance():buildGroup("newUserIcon")

	-- ----------
	-- Init Base
	-- ----------
	BaseUI.init(self, self.ui)

	-- ---------------
	-- Get UI Component
	-- ----------------
	self.newUserIcon	= self.ui:getChildByName("newUserIcon")
	self.label		= self.newUserIcon:getChildByName("label")
	self.userIcon		= self.newUserIcon:getChildByName("userIcon")

	assert(self.newUserIcon)
	assert(self.label)
	assert(self.userIcon)

	self.userIcon:setVisible(false)
	self:updateProfile()

	local labelKey		= "user.picture"
	local labelValue	= Localization:getInstance():getText(labelKey, {})
	self.label:setString(labelValue)

	local function onUpdateProfile( evt )
		self:updateProfile()
	end
	GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kProfileUpdate, onUpdateProfile)
end

function UserPicture:updateProfile()
	local profile = UserManager.getInstance().profile
	if profile and profile.headUrl ~= self.headUrl then
		if self.clipping then self.clipping:removeFromParentAndCleanup(true) end
		local framePos = self.userIcon:getPosition()
		local frameSize = self.userIcon:getContentSize()
		local function onImageLoadFinishCallback(clipping)
			local clippingSize = clipping:getContentSize()
			local iconSize = self.userIcon:getContentSize()
			local scale = frameSize.width/clippingSize.width
			-- clipping:setScale(scale*0.95)
			clipping:setScale(scale)
			clipping:setPosition(ccp(framePos.x + frameSize.width/2, framePos.y - frameSize.height/2))
			self.newUserIcon:addChild(clipping)
			self.clipping = clipping
			self.headUrl = profile.headUrl	
		end
		HeadImageLoader:create(profile.uid, profile.headUrl, onImageLoadFinishCallback)
	end
end

function UserPicture:setLabelVisible(visible, ...)
	assert(type(visible) == "boolean")
	assert(#{...} == 0)

	self.label:setVisible(visible)
end

function UserPicture:create(...)
	assert(#{...} == 0)

	local newUserPicture = UserPicture.new()
	newUserPicture:init()
	return newUserPicture
end
