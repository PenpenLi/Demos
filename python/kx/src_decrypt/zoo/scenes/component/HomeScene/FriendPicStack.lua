
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ23ÈÕ 11:59:04
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com
--

require "zoo.scenes.component.HomeScene.FriendPicture"

---------------------------------------------------
-------------- FriendPicStack
---------------------------------------------------

FriendPicStackState = {
	FRIEND_PIC_SHOW_STATE_EXPANDED	= 1,
	FRIEND_PIC_SHOW_STATE_HIDEED	= 2,
	FRIEND_PIC_SHOW_STATE_IN_ANIMATING	= 3,
}

function checkFriendPicStackState(state, ...)
	assert(#{...} == 0)

	assert(state == FriendPicStackState.FRIEND_PIC_SHOW_STATE_EXPANDED or
		state == FriendPicStackState.FRIEND_PIC_SHOW_STATE_HIDEED)
end

assert(not FriendPicStack)
assert(Layer)
FriendPicStack = class(Layer)

function FriendPicStack:init(levelId, userPicture, ...)
	assert(#{...} == 0)

	-- -----------
	-- Init Base Class
	-- --------------
	Layer.initLayer(self)

	----------
	-- Data
	-- --------
	self.levelId 		= levelId
	self.userPicture	= userPicture

	-- Added Friend Pic
	self.friendPics = {}
	self.deltaY	= 10

	------------------
	-- Callback Function
	-- ----------------
	self.expanHideCallback = false

	--self.FRIEND_PIC_SHOW_STATE_EXPANDED	= 1
	--self.FRIEND_PIC_SHOW_STATE_HIDEED	= 2
	self.FRIEND_PIC_SHOW_STATE_EXPANDED	= FriendPicStackState.FRIEND_PIC_SHOW_STATE_EXPANDED
	self.FRIEND_PIC_SHOW_STATE_HIDEED	= FriendPicStackState.FRIEND_PIC_SHOW_STATE_HIDEED

	self.friendPicShowState			= self.FRIEND_PIC_SHOW_STATE_HIDEED

	local function onTapped()
		self:onTapped()
	end
end

function FriendPicStack:isHitted(worldPos, ...)
	assert(worldPos)
	assert(#{...} == 0)

	if self.friendPicShowState == FriendPicStackState.FRIEND_PIC_SHOW_STATE_EXPANDED then
		return self:hitTestPoint(worldPos, true)

	elseif self.friendPicShowState == FriendPicStackState.FRIEND_PIC_SHOW_STATE_HIDEED then

		for k,v in pairs(self.friendPics) do
			if v.friendIcon:hitTestPoint(worldPos, true) then
				return true
			end
		end

		return false
	end
end

function FriendPicStack:getShowState(...)
	assert(#{...} == 0)

	return self.friendPicShowState
end

function FriendPicStack:onTapped(...)
	assert(#{...} == 0)

	----------------------------------
	-- Check If Conflict With Top Level
	-- -----------------------------
	local topLevel = UserManager:getInstance().user:getTopLevelId()

	if self.friendPicShowState == self.FRIEND_PIC_SHOW_STATE_EXPANDED then
		self.friendPicShowState	= self.FRIEND_PIC_SHOW_STATE_HIDEED

		-- Stop Previous Action
		self:stopAllActions()

		if self.expanHideCallback then
			self.expanHideCallback(self, FriendPicStackState.FRIEND_PIC_SHOW_STATE_HIDEED)
		end

		local function onAnimFinish()
			self.friendPicShowState = self.FRIEND_PIC_SHOW_STATE_HIDEED
		end

		self:playHideFriendPicsAnim(false)

	elseif self.friendPicShowState == self.FRIEND_PIC_SHOW_STATE_HIDEED then
		self.friendPicShowState	= self.FRIEND_PIC_SHOW_STATE_EXPANDED

		-- Stop Previosu
		self:stopAllActions()
		
		-- Position Self To Top
		local selfParent = self:getParent()
		self:removeFromParentAndCleanup(false)
		selfParent:addChild(self)

		if self.expanHideCallback then
			self.expanHideCallback(self, FriendPicStackState.FRIEND_PIC_SHOW_STATE_EXPANDED)
		end

		local function onAnimFinish()
			self.friendPicShowState = self.FRIEND_PIC_SHOW_STATE_EXPANDED
		end

		if topLevel == self.levelId then

			self:playExpandFriendPicsAnim(onAnimFinish, true)

			-- ---------------------
			-- Position User Picture TOp
			-- ----------------------------
			local userPictureParent = self.userPicture:getParent()
			self.userPicture:removeFromParentAndCleanup(false)
			userPictureParent:addChild(self.userPicture)
		else
			self:playExpandFriendPicsAnim(onAnimFinish, false)
		end

	elseif self.friendPicShowState == self.FRIEND_PIC_SHOW_STATE_IN_ANIMATING then
		-- Do  Nothing

	else
		assert(false)
	end
		
end

function FriendPicStack:addFriendId(friendId, ...)
	assert(type(friendId) == "number")
	assert(#{...} == 0)
	
	local friendPic = self:getFriendPicById(friendId)

	if friendPic then
		friendPic.cleanFlag = false
	else
		local newFriendPic = FriendPicture:create(friendId)
		newFriendPic.cleanFlag = false

		-- Add To Self
		self:addChild(newFriendPic)
		table.insert(self.friendPics, newFriendPic)

		-- Re Position All FriendPicture
		self:repositionFriendPics()
	end
end

function FriendPicStack:removeFriendId(friendId, ...)
	assert(type(friendId) == "number")
	assert(#{...} == 0)

	--if not self.friendPics[friendId] then
	--	return
	local friendPic 	= self:getFriendPicById(friendId)
	local friendPicIndex	= self:getFriendPicIndexById(friendId)

	if not friendPic then
		return
	else
		friendPic:removeFromParentAndCleanup(true)
		table.remove(self.friendPics, friendPicIndex)
	end
end

function FriendPicStack:setExpanHideCallback(callback, ...)
	assert(type(callback) == "function")
	assert(#{...} == 0)

	self.expanHideCallback = callback
end

function FriendPicStack:getLevelId(...)
	assert(#{...} == 0)

	return self.levelId
end

function FriendPicStack:getFriendPicById(id, ...)
	assert(type(id) == "number")
	assert(#{...} == 0)

	for k,v in pairs(self.friendPics) do

		if v:getFriendId() == id then
			return v
		end
	end
end

function FriendPicStack:getFriendPicIndexById(id, ...)
	assert(type(id) == "number")
	assert(#{...} == 0)

	for k,v in pairs(self.friendPics) do
		if v:getFriendId() == id then
			return k
		end
	end
end

function FriendPicStack:repositionFriendPics(...)
	assert(#{...} == 0)

	local deltaY	= self.deltaY
	local startY	= 0
	local count = #self.friendPics
	local low = count - 4
	if low < 0 then low = 0 end
	for index = count, low + 1, -1 do
		self.friendPics[index]:setPositionY(startY)
		self.friendPics[index].foldedPosY = startY
		startY = startY + deltaY
	end

	for index = low, 1, -1 do 
		self.friendPics[index]:setPositionY(0)
		self.friendPics[index].foldedPosY = 0
	end

	-- for index = #self.friendPics,1,-1 do
	-- 	self.friendPics[index]:setPositionY(startY)
	-- 	startY = startY + deltaY
	-- end
end

function FriendPicStack:playExpandFriendPicsAnim(animFinishCallback, expandOneExtra, ...)
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(type(expandOneExtra) == "boolean")
	assert(#{...} == 0)

	self:stopAllActions()
	
	local friendPictureHeight = false
	local animTime	= 0.2

	local actionArray = CCArray:create()

	for index,v in ipairs(self.friendPics) do

		if not friendPictureHeight then
			friendPictureHeight = self.friendPics[index]:getGroupBounds().size.height - 20
		end

		local destPosY = false

		if expandOneExtra then
			destPosY	= (#self.friendPics - index + 1) * (friendPictureHeight - self.deltaY - 15)	- 15 -- ( The las -15 Is To Move All Pic 15 Pixel Below)
		else
			destPosY	= (#self.friendPics - index) * (friendPictureHeight - self.deltaY - 15)	-- 15 is the Bottom Angle's Height
			--destPosY	= (#self.friendPics - index + 1) * (friendPictureHeight - self.deltaY - 15)
		end

		local moveTo	= CCMoveTo:create(animTime, ccp(0, destPosY))
		local target	= CCTargetedAction:create(self.friendPics[index].refCocosObj, moveTo)

		local function expanFunc()
			if not self.friendPics or not self.friendPics[index] then return end
			-- --------------------------------------------
			-- Check If Expan Right Will Exceed The Screen
			-- -------------------------------------------
			local visibleOrigin 	= CCDirector:sharedDirector():getVisibleOrigin()
			local visibleSize	= CCDirector:sharedDirector():getVisibleSize()

			-- FriendPicture Expaned Width
			local expandedWidth = self.friendPics[index]:getExpandedWidth()

			local selfPosX = self:getPositionX()
			-- Convert To WorldPos
			local parent 		= self:getParent()
			local posXInWorldSpace	= parent:convertToWorldSpace(ccp(selfPosX, 0))

			local function onFinish() 
				-- fix: will set false when hide animation completes
				-- see onFinish() in playHideFriendPicsAnim()
				--self.friendPics[index]:setRecalcMaskPosition(false) 
			end
			self.friendPics[index]:setRecalcMaskPosition(true)
			if posXInWorldSpace.x + expandedWidth > visibleOrigin.x + visibleSize.width then
				-- Exceed Right Screen
				self.friendPics[index]:playShowNameAndStarAnim(FriendPictureAnimDirection.LEFT, onFinish)
			else
				-- Not Exceed Right Screen
				self.friendPics[index]:playShowNameAndStarAnim(FriendPictureAnimDirection.RIGHT, onFinish)
			end
		end
		local expanAction = CCCallFunc:create(expanFunc)

		local seq = CCSequence:createWithTwoActions(target, expanAction)

		actionArray:addObject(seq)
	end

	local spawn = CCSpawn:create(actionArray)

	-- Anim Finish Callback
	local function animFinishFunc()
		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishAction = CCCallFunc:create(animFinishFunc)

	-- Seq
	local seq = CCSequence:createWithTwoActions(spawn, animFinishAction)

	self:runAction(seq)
end

function FriendPicStack:playHideFriendPicsAnim(animFinishCallback, ...)
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	self:stopAllActions()

	if #self.friendPics < 1 then return end

	local animTime = 0.2
	local actionArray = CCArray:create()
	for index,v in ipairs(self.friendPics) do
		local function onFinish() self.friendPics[index]:setRecalcMaskPosition(false) end
		local function hideFunc()
			self.friendPics[index]:setRecalcMaskPosition(true)
			self.friendPics[index]:playHideNameAndStarAnim(onFinish)
		end
		local hideAction = CCCallFunc:create(hideFunc)
		local destPosY = v.foldedPosY
		local moveTo 	= CCMoveTo:create(animTime, ccp(0, destPosY))
		local target	= CCTargetedAction:create(self.friendPics[index].refCocosObj, moveTo)
		local seq = CCSequence:createWithTwoActions(hideAction, target)
		actionArray:addObject(seq)
	end
	local spawn = CCSpawn:create(actionArray)

	local function animFinishFunc()
		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishAction = CCCallFunc:create(animFinishFunc)
	local seq = CCSequence:createWithTwoActions(spawn, animFinishAction)
	self:runAction(seq)
end

function FriendPicStack:setFriendPicsCleanFlag(...)
	assert(#{...} == 0)

	for k,v in pairs(self.friendPics) do
		v.cleanFlag = true
	end
end

function FriendPicStack:cleanFriendPicsBasedOnCleanFlag(...)
	assert(#{...} == 0)

	for k,v in pairs(self.friendPics) do

		if v.cleanFlag then
			self:removeFriendId(v:getFriendId())
		end
	end
end

function FriendPicStack:create(levelId, userPicture, ...)
	assert(type(levelId) == "number")
	assert(userPicture)
	assert(#{...} == 0)

	local newFriendPicStack = FriendPicStack.new()
	newFriendPicStack:init(levelId, userPicture)
	return newFriendPicStack
end
