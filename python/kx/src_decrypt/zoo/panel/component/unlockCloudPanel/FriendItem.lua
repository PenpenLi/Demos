
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年12月 4日 20:38:05
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- FriendItem
---------------------------------------------------

assert(not FriendItem)
assert(BaseUI)

FriendItem = class(BaseUI)

function FriendItem:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	self.ui = ui
	-- ---------------
	--  Init Base Class
	--  ------------
	BaseUI.init(self, ui)

	--------------
	-- Get UI Component
	-- ---------------
	self.bg = self.ui:getChildByName("_bg");
	self.label		= self.ui:getChildByName("nameLabel")
	self.nameLabelBg = self.ui:getChildByName("_nameBg")

	assert(self.label)

	---------------
	-- Get Data About UI
	-- ----------------

	self.defaultImageWidth	= 96;
	self.defaultImageHeight	= 96;

	-----------------
	-- Init UI Componenet
	-- ------------------
	local defaultFriendNameKey  	= "unlock.cloud.panel.default.friend.name"
	local defaultFriendNameValue	= Localization:getInstance():getText(defaultFriendNameKey, {})
	self.label:setString(defaultFriendNameValue)
end

function FriendItem:setFriend(friendId, ...)
	assert(type(friendId) == "string")
	assert(#{...} == 0)

	if self.isDisposed then
		return
	end

	local friendRef	= FriendManager.getInstance().friends[friendId]

	if friendRef then
		local function onImageLoadFinishCallback(image)
			if self.isDisposed then return end
			local newImageSize = image:getContentSize()
			local manualAdjustDefaultImageWidth 	= 0
			local manualAdjustDefaultImageHeight	= 0
			local neededScaleX = (self.defaultImageWidth + manualAdjustDefaultImageWidth) / newImageSize.width
			local neededScaleY = (self.defaultImageHeight + manualAdjustDefaultImageHeight) / newImageSize.height
			image:setScaleX(neededScaleX)
			image:setScaleY(neededScaleY)
			local bgSize = self.bg:getContentSize();
			image:setPosition(ccp(bgSize.width/2-4, bgSize.height/2+2))
			self.bg:addChild(image)
		end
		HeadImageLoader:create(friendRef.uid, friendRef.headUrl, onImageLoadFinishCallback)

		if friendRef.name and string.len(friendRef.name) > 0 then
			self.label:setString(HeDisplayUtil:urlDecode(tostring(friendRef.name)))
		else
			self.label:setString(tostring(friendId))
		end

	else
		self.label:setString(tostring(friendId))
	end
end

function FriendItem:setVisible(isVisible)
	self.label:setVisible(isVisible)
	self.bg:setVisible(isVisible)
	self.nameLabelBg:setVisible(isVisible)
end

function FriendItem:setNameVisible(isVisible)
	self.label:setVisible(isVisible)
	self.nameLabelBg:setVisible(isVisible)
end

function FriendItem:setName(friendName)
	local name = friendName or "unlock.cloud.panel.default.friend.name"
	local nameValue	= Localization:getInstance():getText(name, {})
	self.label:setString(nameValue)
end

function FriendItem:setNameColor()
	-- body
end

function FriendItem:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newFriendItem = FriendItem.new()
	newFriendItem:init(ui)
	return newFriendItem
end
