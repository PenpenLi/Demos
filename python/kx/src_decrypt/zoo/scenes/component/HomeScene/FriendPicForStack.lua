
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ23ÈÕ 11:50:50
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- FriendPicForStack
---------------------------------------------------

FriendPicForStack = class()


FriendPicForStackAnimDirection = {
	LEFT	= 1,
	RIGHT	= 2
}

local function checkFriendPicForStackAnimDirection(direction, ...)
	assert(direction)
	assert(#{...} == 0)

	assert(direction == FriendPicForStackAnimDirection.LEFT or
		direction == FriendPicForStackAnimDirection.RIGHT)
end

function FriendPicForStack:create(friendId, friendInfo, ...)
	assert(type(friendId) == "number")
	assert(#{...} == 0)

	local newFriendPicForStack = FriendPicForStack.new()
	newFriendPicForStack:init(friendId, friendInfo)
	return newFriendPicForStack
end

function FriendPicForStack:dispose()
	self.ui:dispose()
end

function FriendPicForStack:init(friendId, friendInfo,  ...)
	assert(type(friendId) == "number")
	assert(#{...} == 0)

	ResourceManager:sharedInstance():addJsonFile("flash/scenes/homeScene/homeScene.json")
	self.ui = ResourceManager:sharedInstance():buildGroup("friendPictureForStack")

	-------------
	-- Data
	-- -------
	self.friendId	= friendId
	self.friendRef	= FriendManager.getInstance().friends[tostring(self.friendId)]

	-- temp fix

	-- print('FriendPicForStack', type(friendInfo), table.tostring(friendInfo))

	if friendInfo ~= nil then self.friendRef = friendInfo end

	-- end of fix

	assert(self.friendRef)

	self.totalStar = tonumber(self.friendRef.star) + tonumber(self.friendRef.hideStar)
	local name = self.friendRef.name
	if name == nil or name == "" then name = friendId end
	self.name	= name

	self.SHOW_STATE_HIDDED	= 1
	self.SHOW_STATE_SHOWED	= 2
	self.HIDDEN_DELTA = 10
	self.SHOW_DELTA = 95
	self.showState		= self.SHOW_STATE_HIDDED

	-------------------
	-- Get UI Resource
	-- -----------------
	self.iconBg = self.ui:getChildByName("iconBg")
	self.defaultPic = self.ui:getChildByName("defaultPic")
	self.picTop = self.ui:getChildByName("top")
	self.nameLabel = self.ui:getChildByName("nameLabel")
	self.starIcon = self.ui:getChildByName("starIcon")
	self.starNumberLabel = self.ui:getChildByName("starNumberLabel")
	self.rightBg = self.ui:getChildByName("rightBg")

	self.size = self.rightBg:getContentSize()
	self.size = {width = self.size.width, height = self.size.height}
	self.rightBgOriginX = self.rightBg:getPositionX()

	self.rightBg:setPositionX(self.rightBgOriginX - self.size.width)
	self.starIcon:setPositionX(self.starIcon:getPositionX() - self.size.width)
	self.nameLabel:setPositionX(self.nameLabel:getPositionX() - self.size.width)
	self.nameLabel:setString(self.name)
	self.starNumberLabel:setPositionX(self.starNumberLabel:getPositionX() - self.size.width)
	self.starNumberLabel:setString(self.totalStar)

	local framePos = self.defaultPic:getPosition()
	
	local frameSize = self.defaultPic:getGroupBounds(self.ui).size
	frameSize = {width = frameSize.width, height = frameSize.height}
	local function onImageLoadFinishCallback(clipping)
		if self.isDisposed then return end
		local clippingSize = clipping:getContentSize()
		clipping:setScaleX(frameSize.width / clippingSize.width)
		clipping:setScaleY(frameSize.height / clippingSize.height)
		clipping:setPositionXY(self.defaultPic:getPositionX() + frameSize.width / 2, self.defaultPic:getPositionY() - frameSize.height / 2)
		clipping:setVisible(self.defaultPic:isVisible())
		self.defaultPic:getParent():addChild(clipping)
		self.defaultPic:removeFromParentAndCleanup(true)
		self.defaultPic = clipping
	end
	HeadImageLoader:create(self.friendRef.uid, self.friendRef.headUrl, onImageLoadFinishCallback)
end

function FriendPicForStack:getFriendId(...)
	assert(#{...} == 0)

	return self.friendId
end

function FriendPicForStack:getFriendIconSize(...)
	assert(#{...} == 0)

	local size = self.friendIcon:getGroupBounds().size
	size = {width = size.width, height = size.height}
	return size
end

function FriendPicForStack:setNameAndStarHide(...)
	assert(#{...} == 0)
	self.friendNameAndStar:setPositionX(self.friendNameAndStarRightHidePosX)
end

function FriendPicForStack:getExpandedWidth(...)
	assert(#{...} == 0)

	return self.friendNameAndStarResInitPosX + self.friendNameAndStarWidth
end

-- return {
-- 		clipping = self.clipping,
-- 		bgAndStar = self.bgStarBatch,
-- 		star = self.starBatch,
-- 		name = self.nameLayer,
-- 		picBg = self.picBgBatch,
-- 		head = self.headLayer,
-- 	}

function FriendPicForStack:addToStack(stack)
	local list = stack:getLayerList()

	self.iconBg:removeFromParentAndCleanup(false)
	list.picBg:addChild(self.iconBg)
	self.defaultPic:removeFromParentAndCleanup(false)
	list.head:addChild(self.defaultPic)
	self.picTop:removeFromParentAndCleanup(false)
	list.picTop:addChild(self.picTop)
	self.rightBg:removeFromParentAndCleanup(false)
	list.bgAndStar:addChild(self.rightBg)
	self.starIcon:removeFromParentAndCleanup(false)
	list.bgAndStar:addChild(self.starIcon)
	self.nameLabel:removeFromParentAndCleanup(false)
	list.name:addChild(self.nameLabel)
	self.starNumberConcreteLabel = list.star:createLabel(self.starNumberLabel:getString())
	self.starNumberConcreteLabel:setAnchorPoint(ccp(0, 1))
	local tSize = self.starNumberLabel:getDimensions()
	local size = self.starNumberConcreteLabel:getContentSize()
	self.starNumberLabel:setScale(tSize.height / size.height)
	self.starNumberConcreteLabel:setPositionX(self.starNumberLabel:getPositionX() + (tSize.width - size.width * self.starNumberConcreteLabel:getScale()) / 2)
	self.starNumberConcreteLabel:setPositionY(self.starNumberLabel:getPositionY() - (tSize.height - size.height * self.starNumberConcreteLabel:getScale()) / 2)
	list.star:addChild(self.starNumberConcreteLabel)
end

function FriendPicForStack:removeFromStack(stack)
	self.iconBg:removeFromParentAndCleanup(false)
	self.ui:addChild(self.iconBg)
	self.defaultPic:removeFromParentAndCleanup(false)
	self.ui:addChild(self.defaultPic)
	self.picTop:removeFromParentAndCleanup(false)
	self.ui:addChild(self.picTop)
	self.rightBg:removeFromParentAndCleanup(false)
	self.ui:addChild(self.rightBg)
	self.starIcon:removeFromParentAndCleanup(false)
	self.ui:addChild(self.starIcon)
	self.nameLabel:removeFromParentAndCleanup(false)
	self.ui:addChild(self.nameLabel)
	self.starNumberConcreteLabel:removeFromParentAndCleanup(true)
end

function FriendPicForStack:reposition(indexFromBottom)
	local originDelta = self.starNumberConcreteLabel:getPositionY() - self.starNumberLabel:getPositionY()
	local delta = self.HIDDEN_DELTA
	if self.showState == self.SHOW_STATE_SHOWED then
		delta = self.SHOW_DELTA
	end
	if indexFromBottom <= 4 then
		self.iconBg:setPositionY(self.iconBg:getPositionY() - originDelta + (indexFromBottom - 1) * delta)
		self.iconBg:setVisible(true)
		self.defaultPic:setPositionY(self.defaultPic:getPositionY() - originDelta + (indexFromBottom - 1) * delta)
		self.defaultPic:setVisible(indexFromBottom <= 1)
		self.picTop:setPositionY(self.picTop:getPositionY() - originDelta + (indexFromBottom - 1) * delta)
		self.picTop:setVisible(true)
		self.rightBg:setPositionY(self.rightBg:getPositionY() - originDelta + (indexFromBottom - 1) * delta)
		self.rightBg:setVisible(true)
		self.starIcon:setPositionY(self.starIcon:getPositionY() - originDelta + (indexFromBottom - 1) * delta)
		self.starIcon:setVisible(true)
		self.nameLabel:setPositionY(self.nameLabel:getPositionY() - originDelta + (indexFromBottom - 1) * delta)
		self.nameLabel:setVisible(true)
		self.starNumberConcreteLabel:setPositionY(self.starNumberConcreteLabel:getPositionY() - originDelta + (indexFromBottom - 1) * delta)
		self.starNumberConcreteLabel:setVisible(true)
	else
		self.iconBg:setPositionY(self.iconBg:getPositionY() - originDelta + 4 * delta)
		self.iconBg:setVisible(false)
		self.defaultPic:setPositionY(self.defaultPic:getPositionY() - originDelta + 4 * delta)
		self.defaultPic:setVisible(false)
		self.picTop:setPositionY(self.picTop:getPositionY() - originDelta + 4 * delta)
		self.picTop:setVisible(false)
		self.rightBg:setPositionY(self.rightBg:getPositionY() - originDelta + 4 * delta)
		self.rightBg:setVisible(false)
		self.starIcon:setPositionY(self.starIcon:getPositionY() - originDelta + 4 * delta)
		self.starIcon:setVisible(false)
		self.nameLabel:setPositionY(self.nameLabel:getPositionY() - originDelta + 4 * delta)
		self.nameLabel:setVisible(false)
		self.starNumberConcreteLabel:setPositionY(self.starNumberConcreteLabel:getPositionY() - originDelta + 4 * delta)
		self.starNumberConcreteLabel:setVisible(false)
	end
end

function FriendPicForStack:playHideNameAndStarAnim(index, animFinishCallback)
	local originDelta = self.starNumberConcreteLabel:getPositionY() - self.starNumberLabel:getPositionY()
	self.iconBg:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.2, ccp(self.iconBg:getPositionX(),
		self.iconBg:getPositionY() - originDelta + (index <= 4 and index - 1 or 4) * self.HIDDEN_DELTA)), CCCallFunc:create(function()
			self.iconBg:setVisible(index <= 4)
			self.defaultPic:setVisible(index <= 1)
			self.picTop:setVisible(index <= 4)
			self.rightBg:setVisible(index <= 4)
			self.starIcon:setVisible(index <= 4)
			self.nameLabel:setVisible(index <= 4)
			self.starNumberConcreteLabel:setVisible(index <= 4)

			if animFinishCallback then animFinishCallback() end
		end)))
	self.defaultPic:runAction(CCMoveTo:create(0.2, ccp(self.defaultPic:getPositionX(),
		self.defaultPic:getPositionY() - originDelta + (index <= 4 and index - 1 or 4) * self.HIDDEN_DELTA)))
	self.picTop:runAction(CCMoveTo:create(0.2, ccp(self.picTop:getPositionX(),
		self.picTop:getPositionY() - originDelta + (index <= 4 and index - 1 or 4) * self.HIDDEN_DELTA)))
	self.rightBg:runAction(CCMoveTo:create(0.2, ccp(self.rightBg:getPositionX() - self.size.width,
		self.rightBg:getPositionY() - originDelta + (index <= 4 and index - 1 or 4) * self.HIDDEN_DELTA)))
	self.starIcon:runAction(CCMoveTo:create(0.2, ccp(self.starIcon:getPositionX() - self.size.width,
		self.starIcon:getPositionY() - originDelta + (index <= 4 and index - 1 or 4) * self.HIDDEN_DELTA)))
	self.nameLabel:runAction(CCMoveTo:create(0.2, ccp(self.nameLabel:getPositionX() - self.size.width,
		self.nameLabel:getPositionY() - originDelta + (index <= 4 and index - 1 or 4) * self.HIDDEN_DELTA)))
	self.starNumberConcreteLabel:runAction(CCMoveTo:create(0.2, ccp(self.starNumberConcreteLabel:getPositionX() - self.size.width,
		self.starNumberConcreteLabel:getPositionY() - originDelta + (index <= 4 and index - 1 or 4) * self.HIDDEN_DELTA)))

	self.iconBg:setVisible(true)
	self.defaultPic:setVisible(true)
	self.picTop:setVisible(true)
	self.rightBg:setVisible(true)
	self.starIcon:setVisible(true)
	self.nameLabel:setVisible(true)
	self.starNumberConcreteLabel:setVisible(true)
end

function FriendPicForStack:playShowNameAndStarAnim(index, animFinishCallback)
	local originDelta = self.starNumberConcreteLabel:getPositionY() - self.starNumberLabel:getPositionY()
	local arr = CCArray:create()
	arr:addObject(CCMoveTo:create(0.2, ccp(self.iconBg:getPositionX(), self.iconBg:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA)))
	arr:addObject(CCDelayTime:create(0.1))
	arr:addObject(CCCallFunc:create(function()
			self.iconBg:setVisible(index < 16)
			self.defaultPic:setVisible(index < 16)
			self.picTop:setVisible(index < 16)
			self.rightBg:setVisible(index < 16)
			self.starIcon:setVisible(index < 16)
			self.nameLabel:setVisible(index < 16)
			self.starNumberConcreteLabel:setVisible(index < 16)

			if animFinishCallback then animFinishCallback() end
		end))
	self.iconBg:runAction(CCSequence:create(arr))
	self.defaultPic:runAction(CCMoveTo:create(0.2, ccp(self.defaultPic:getPositionX(),
		self.defaultPic:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA)))
	self.picTop:runAction(CCMoveTo:create(0.2, ccp(self.picTop:getPositionX(),
		self.picTop:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA)))
	self.rightBg:runAction(CCSequence:createWithTwoActions(
		CCMoveTo:create(0.2, ccp(self.rightBg:getPositionX(),
		self.rightBg:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA)),
		CCMoveTo:create(0.1, ccp(self.rightBg:getPositionX() + self.size.width,
		self.rightBg:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA))))
	self.starIcon:runAction(CCSequence:createWithTwoActions(
		CCMoveTo:create(0.2, ccp(self.starIcon:getPositionX(),
		self.starIcon:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA)),
		CCMoveTo:create(0.1, ccp(self.starIcon:getPositionX() + self.size.width,
		self.starIcon:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA))))
	self.nameLabel:runAction(CCSequence:createWithTwoActions(
		CCMoveTo:create(0.2, ccp(self.nameLabel:getPositionX(),
		self.nameLabel:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA)),
		CCMoveTo:create(0.1, ccp(self.nameLabel:getPositionX() + self.size.width,
		self.nameLabel:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA))))
	self.starNumberConcreteLabel:runAction(CCSequence:createWithTwoActions(
		CCMoveTo:create(0.2, ccp(self.starNumberConcreteLabel:getPositionX(),
		self.starNumberConcreteLabel:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA)),
		CCMoveTo:create(0.1, ccp(self.starNumberConcreteLabel:getPositionX() + self.size.width,
		self.starNumberConcreteLabel:getPositionY() - originDelta + (index - 1) * self.SHOW_DELTA))))
	
	self.iconBg:setVisible(true)
	self.defaultPic:setVisible(true)
	self.picTop:setVisible(true)
	self.rightBg:setVisible(true)
	self.starIcon:setVisible(true)
	self.nameLabel:setVisible(true)
	self.starNumberConcreteLabel:setVisible(true)
end