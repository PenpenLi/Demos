
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ23ÈÕ 11:50:50
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- FriendPicture
---------------------------------------------------

assert(not FriendPicture)
FriendPicture = class(BaseUI)


FriendPictureAnimDirection = {
	LEFT	= 1,
	RIGHT	= 2
}

local function checkFriendPictureAnimDirection(direction, ...)
	assert(direction)
	assert(#{...} == 0)

	assert(direction == FriendPictureAnimDirection.LEFT or
		direction == FriendPictureAnimDirection.RIGHT)
end

function FriendPicture:init(uiGroup, friendId, friendInfo,  ...)
	assert(type(friendId) == "number")
	assert(#{...} == 0)

	-- Get UI Resource
	self.ui	= uiGroup

	------------
	-- Init Base Class
	-- ------------
	BaseUI.init(self, self.ui)

	-------------
	-- Data
	-- -------
	self.friendId	= friendId
	self.friendRef	= FriendManager.getInstance().friends[tostring(self.friendId)]

	-- temp fix

	-- print('FriendPicture', type(friendInfo), table.tostring(friendInfo))

	if friendInfo ~= nil then self.friendRef = friendInfo end

	-- end of fix

	assert(self.friendRef)

	self.totalStar = tonumber(self.friendRef.star) + tonumber(self.friendRef.hideStar)
	local name = self.friendRef.name
	if name == nil or name == "" then name = friendId end
	self.name	= name

	self.SHOW_STATE_HIDDED	= 1
	self.SHOW_STATE_SHOWED	= 2
	self.showState		= self.SHOW_STATE_HIDDED

	-------------------
	-- Get UI Resource
	-- -----------------
	self.friendIcon		= self.ui:getChildByName("friendIcon")
	self.friendNameAndStar	= self.ui:getChildByName("friendNameAndStar")
	assert(self.friendIcon)
	assert(self.friendNameAndStar)

	--self.picMask	= self.friendIcon:getChildByName("picMask")
	self.defaultPic	= self.friendIcon:getChildByName("defaultPic")
	--assert(self.picMask)
	assert(self.defaultPic)

	self.nameLabel		= self.friendNameAndStar:getChildByName("nameLabel")
	self.starNumberLabel	= self.friendNameAndStar:getChildByName("starNumberLabel")
	self.rightBg		= self.friendNameAndStar:getChildByName("rightBg")
	assert(self.nameLabel)
	assert(self.starNumberLabel)
	assert(self.rightBg)

	-------------------------
	-- Get Data About UI
	-- ----------------------
	self.friendNameAndStarWidth	= self.friendNameAndStar:getGroupBounds().size.width
	self.friendNameAndStarHeight	= self.friendNameAndStar:getGroupBounds().size.height

	self.friendIconWidth	= self.friendIcon:getGroupBounds().size.width
	self.friendIconHeight	= self.friendIcon:getGroupBounds().size.height

	---------------------------------
	-- Create User Picture's Clipping
	-- ------------------------------
	

	local framePosX = self.defaultPic:getPositionX()
	local framePosY = self.defaultPic:getPositionY()
	local gbSize = self.defaultPic:getGroupBounds(self.friendIcon).size -- self.defaultPic:getContentSize()
	local frameSize = {width = gbSize.width, height = gbSize.height}
	local function onImageLoadFinishCallback(clipping)
		if self.isDisposed then return end
		local clippingSize = clipping:getContentSize()
		local scale = frameSize.width/clippingSize.width
		clipping:setScale(scale*0.95)
		clipping:setPosition(ccp(framePosX + frameSize.width/2, framePosY - frameSize.height/2))
		self.friendIcon:addChild(clipping)
		--self.picMask:removeFromParentAndCleanup(true)
		self.defaultPic:removeFromParentAndCleanup(true)
	end
	HeadImageLoader:create(self.friendRef.uid, self.friendRef.headUrl,onImageLoadFinishCallback)
	
	------------------------------------
	-- Create friendNameAndStar Clipping
	-- ------------------------------
	local friendNameAndStarSize	= self.friendNameAndStar:getGroupBounds().size

	-- local mask	= LayerColor:create()
	-- mask:setColor(ccc3(255,0,0))
	-- mask:changeWidthAndHeight(friendNameAndStarSize.width, friendNameAndStarSize.height)
	-- mask:setPosition(ccp(0, -friendNameAndStarSize.height))
	-- local cppClipping 	= CCClippingNode:create(mask.refCocosObj)
	-- local friendNameAndStarClipping		= ClippingNode.new(cppClipping)

	local friendNameAndStarClipping = SimpleClippingNode:create()
	-- friendNameAndStarClipping:setRecalcPosition(true)
	friendNameAndStarClipping:setContentSize(CCSizeMake(friendNameAndStarSize.width, friendNameAndStarSize.height))
	-- friendNameAndStarClipping:setPosition(ccp(0, -friendNameAndStarSize.height))
	friendNameAndStarClipping:setPosition(ccp(0, 0))
	self.friendNameAndStarClipping		= friendNameAndStarClipping

	local friendNameAndStarPosX	= self.friendNameAndStar:getPositionX()
	local friendNameAndStarPosY	= self.friendNameAndStar:getPositionY()
	self.friendNameAndStarResInitPosX	= friendNameAndStarPosX
	

	self.friendNameAndStar:removeFromParentAndCleanup(false)
	self.friendNameAndStar:setPosition(ccp(0,friendNameAndStarSize.height))
	friendNameAndStarClipping:addChild(self.friendNameAndStar)

	friendNameAndStarClipping:setPosition(ccp(friendNameAndStarPosX, friendNameAndStarPosY - friendNameAndStarSize.height))
	self.ui:addChild(friendNameAndStarClipping)

	----------------
	-- Show/Hide Pos
	-- --------------
	self.friendNameAndStarRightExpanPosX = 0
	self.friendNameAndStarRightExpanPosY = friendNameAndStarSize.height
	-- self.friendNameAndStarRightExpanPosY = 0
	self.friendNameAndStarRightHidePosX	= -self.friendNameAndStarWidth
	self.friendNameAndStarRightHidePosY	= friendNameAndStarSize.height
	-- self.friendNameAndStarRightHidePosY = 0

	self.friendNameAndStarLeftExpanPosX	= 0
	self.friendNameAndStarLeftExpanPosY	= friendNameAndStarSize.height
	-- self.friendNameAndStarLeftExpanPosY = 0
	self.friendNameAndStarLeftHidePosX	= self.friendNameAndStarWidth
	self.friendNameAndStarLeftHidePosY	= friendNameAndStarSize.height
	-- self.friendNameAndStarLeftHidePosY = 0

	---------------------------------
	-- Re Position 	FriendIcon To Top
	-- -----------------------------
	self.friendIcon:removeFromParentAndCleanup(false)
	self.ui:addChild(self.friendIcon)

	self.STATE_EXPANDED_RIGHT	= 1
	self.STATE_EXPANDED_LEFT	= 2
	self.STATE_HIDE			= 3
	self.nameAndStarShowState	= self.STATE_HIDE
	--self.nameAndStarShowState	= self.STATE_EXPANDED_LEFT
	self:setNameAndStarHide()

	self.ANIM_DIRECTION_RIGHT	= 1
	self.ANIM_DIRECTION_LEFT	= 2
	self.curResDirection		= self.ANIM_DIRECTION_RIGHT

	---------------
	-- Update View
	-- ----------
	self.nameLabel:setString(HeDisplayUtil:urlDecode(self.name))
	self.starNumberLabel:setString(self.totalStar)

	------------
	-- Block Touch Behind
	------------
	--self.friendIcon:setTouchEnabled(true, 0, true)
	--self.friendNameAndStar:setTouchEnabled(true, 0, true)
end

function FriendPicture:getFriendId(...)
	assert(#{...} == 0)

	return self.friendId
end

function FriendPicture:getFriendIconSize(...)
	assert(#{...} == 0)

	local size = self.friendIcon:getGroupBounds().size
	size = {width = size.width, height = size.height}
	return size
end

function FriendPicture:setNameAndStarHide(...)
	assert(#{...} == 0)
	self.friendNameAndStar:setPositionX(self.friendNameAndStarRightHidePosX)
end

function FriendPicture:getExpandedWidth(...)
	assert(#{...} == 0)

	return self.friendNameAndStarResInitPosX + self.friendNameAndStarWidth
end

function FriendPicture:setSelfTouchEnable(...)
	assert(#{...} == 0)

	local function onFriendIconTapped()

		if self.showState == self.SHOW_STATE_HIDDED then
			self:playShowNameAndStarAnim(FriendPictureAnimDirection.RIGHT, false)

		elseif self.showState == self.SHOW_STATE_SHOWED then
			self:playHideNameAndStarAnim(false)

		end
	end

	self.friendIcon:setTouchEnabled(true, 0, true)
	self.friendIcon:addEventListener(DisplayEvents.kTouchTap, onFriendIconTapped)
end

function FriendPicture:playHideNameAndStarAnim(animFinishCallback, ...)
	print("FriendPicture:playHideNameAndStarAnim")
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	self.showState	= self.SHOW_STATE_HIDDED

	local hideTime = 0.1

	self.friendNameAndStar:stopAllActions()

	local animDirection = false
	if self.nameAndStarShowState == self.STATE_EXPANDED_LEFT then
		animDirection = FriendPictureAnimDirection.LEFT
	elseif self.nameAndStarShowState == self.STATE_EXPANDED_RIGHT then
		animDirection = FriendPictureAnimDirection.RIGHT
	elseif self.nameAndStarShowState == self.STATE_HIDE then

		-- Return
		if animFinishCallback then
			animFinishCallback()
		end

		return
	else
		assert(false)
	end

	----------------------------
	-- Adjust Resource Direction
	-- --------------------------
	if animDirection == FriendPictureAnimDirection.LEFT then
		if self.curResDirection == self.ANIM_DIRECTION_RIGHT then
			self.rightBg:setScaleX(-1)
			self.rightBg:setPositionX(self.friendNameAndStarWidth)
			self.curResDirection = self.ANIM_DIRECTION_LEFT
		end
	elseif animDirection == FriendPictureAnimDirection.RIGHT then
		if self.curResDirection == self.ANIM_DIRECTION_LEFT then
			self.rightBg:setScaleX(1)
			self.rightBg:setPositionX(0)
			self.curResDirection = self.ANIM_DIRECTION_RIGHT
		end
	end

	-- Init Action
	local function initActionFunc()
		-- Put To Show Pos
		if animDirection == FriendPictureAnimDirection.LEFT then
			self.friendNameAndStar:setPositionX(self.friendNameAndStarLeftExpanPosX)
		elseif animDirection == FriendPictureAnimDirection.RIGHT then
			self.friendNameAndStar:setPositionX(self.friendNameAndStarRightExpanPosX)
		else
			assert(false)
		end
	end
	local initAction = CCCallFunc:create(initActionFunc)

	-- Hide Action
	
	local moveTo = false

	if animDirection == FriendPictureAnimDirection.LEFT then
		moveTo = CCMoveTo:create(hideTime, ccp(self.friendNameAndStarLeftHidePosX, self.friendNameAndStarLeftHidePosY))
	elseif animDirection == FriendPictureAnimDirection.RIGHT then
		moveTo = CCMoveTo:create(hideTime, ccp(self.friendNameAndStarRightHidePosX, self.friendNameAndStarRightHidePosY))
	else
		assert(false)
	end

	local ease	= CCEaseSineIn:create(moveTo)

	-- Anim Finish
	local function animFinishFunc()
		self.friendNameAndStar:setVisible(false)
		if animFinishCallback then
			animFinishCallback()
		end
	end
	local finishAction = CCCallFunc:create(animFinishFunc)

	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(initAction)
	actionArray:addObject(ease)
	actionArray:addObject(finishAction)

	-- Seq
	local seq = CCSequence:create(actionArray)
	local target = CCTargetedAction:create(self.friendNameAndStar.refCocosObj, seq)
	self.friendNameAndStar:runAction(target)
end

function FriendPicture:playShowNameAndStarAnim(animDirection, animFinishCallback, ...)
	print("FriendPicture:playShowNameAndStarAnim")
	checkFriendPictureAnimDirection(animDirection)
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	self.showState = self.SHOW_STATE_SHOWED

	-- Show Time
	local showTime = 0.1

	-- Stop Previous Anim
	self.friendNameAndStar:stopAllActions()

	----------------------------
	-- Adjust Resource Direction
	-- --------------------------
	if animDirection == FriendPictureAnimDirection.LEFT then

		self.nameAndStarShowState = self.STATE_EXPANDED_LEFT
		print("LEFT", self.friendNameAndStarClipping:getPositionX(), -self.friendNameAndStarResInitPosX - self.friendNameAndStarWidth)
		if self.curResDirection == self.ANIM_DIRECTION_RIGHT then
			self.rightBg:setScaleX(-1)
			self.rightBg:setPositionX(self.friendNameAndStarWidth)
			self.curResDirection = self.ANIM_DIRECTION_LEFT

			self.friendNameAndStarClipping:setPositionX(-self.friendNameAndStarResInitPosX - self.friendNameAndStarWidth)
		end
	elseif animDirection == FriendPictureAnimDirection.RIGHT then

		self.nameAndStarShowState = self.STATE_EXPANDED_RIGHT
		print("RIGHT", self.friendNameAndStarClipping:getPositionX(), self.friendNameAndStarResInitPosX)
		if self.curResDirection == self.ANIM_DIRECTION_LEFT then
			self.rightBg:setScaleX(1)
			self.rightBg:setPositionX(0)
			self.curResDirection = self.ANIM_DIRECTION_RIGHT

			self.friendNameAndStarClipping:setPositionX(self.friendNameAndStarResInitPosX)
		end
	else
		assert(false)
	end

	-- Init Action
	local function initActionFunc()
		-- Put To hide Pos
		if animDirection == FriendPictureAnimDirection.LEFT then
			self.friendNameAndStar:setPositionX(self.friendNameAndStarLeftHidePosX)
		elseif animDirection == FriendPictureAnimDirection.RIGHT then
			self.friendNameAndStar:setPositionX(self.friendNameAndStarRightHidePosX)
		else
			assert(false)
		end
		self.friendNameAndStar:setVisible(true)
	end
	local initAction = CCCallFunc:create(initActionFunc)

	-- show Action
	local moveTo = false
	if animDirection == FriendPictureAnimDirection.LEFT then
		moveTo = CCMoveTo:create(showTime, ccp(self.friendNameAndStarLeftExpanPosX, self.friendNameAndStarLeftExpanPosY))
	elseif animDirection == FriendPictureAnimDirection.RIGHT then
		moveTo = CCMoveTo:create(showTime, ccp(self.friendNameAndStarRightExpanPosX, self.friendNameAndStarRightExpanPosY))
	end
	local ease	= CCEaseSineIn:create(moveTo)

	-- Anim Finish
	local function animFinishFunc()

		if animFinishCallback then
			animFinishCallback()
		end
	end
	local finishAction = CCCallFunc:create(animFinishFunc)

	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(initAction)
	actionArray:addObject(ease)
	actionArray:addObject(finishAction)

	-- Seq
	local seq = CCSequence:create(actionArray)

	self.friendNameAndStar:runAction(seq)
end

function FriendPicture:setRecalcMaskPosition(value)
	self.friendNameAndStarClipping:setRecalcPosition(value)
end

function FriendPicture:setPosition(position)
	BaseUI.setPosition(self, ccp(position.x, position.y))
	self.friendNameAndStarClipping:doRecalcPosition()
	-- local friendNameAndStarPosX	= self.friendNameAndStar:getPositionX()
	-- local friendNameAndStarPosY	= self.friendNameAndStar:getPositionY()
	-- local friendNameAndStarSize	= self.friendNameAndStar:getGroupBounds().size

	-- self.friendNameAndStarClipping:setPosition(ccp(friendNameAndStarPosX, friendNameAndStarPosY - friendNameAndStarSize.height))
	-- print("setPosition")
	-- debug.debug()
end

function FriendPicture:setPositionX(x)
	BaseUI.setPositionX(self, x)
	self.friendNameAndStarClipping:doRecalcPosition()
	-- local friendNameAndStarPosX	= self.friendNameAndStar:getPositionX()

	-- self.friendNameAndStarClipping:setPositionX(friendNameAndStarPosX)
	-- print("setPositionX")
	-- debug.debug()
end

function FriendPicture:create(friendId, friendInfo, ...)
	assert(type(friendId) == "number")
	assert(#{...} == 0)

	ResourceManager:sharedInstance():addJsonFile("flash/scenes/homeScene/homeScene.json")
	local uiGroup = ResourceManager:sharedInstance():buildGroup("friendPicture")

	return FriendPicture:createWithGroup(uiGroup, friendId, friendInfo)
end

function FriendPicture:createWithGroup(uiGroup, friendId, friendInfo, ...)
	assert(uiGroup)

	local newFriendPicture = FriendPicture.new()
	newFriendPicture:init(uiGroup, friendId, friendInfo)
	return newFriendPicture
end