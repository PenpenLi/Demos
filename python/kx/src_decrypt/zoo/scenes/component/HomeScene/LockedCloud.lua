
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê09ÔÂ 9ÈÕ 13:47:28
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.baseUI.BaseUI"
require "zoo.panelBusLogic.UnlockLevelAreaLogic"
require "zoo.panelBusLogic.IsLockedCloudCanWaitToOpenLogic"

require "zoo.panel.UnlockCloudPanel"
require "zoo.panel.RequireNetworkAlert"
require "zoo.panel.recall.RecallFriendUnlockPanel"
require "zoo.panel.recall.RecallLevelUnlockPanel"
require "zoo.panel.recall.RecallItemPanel"



---------------------------------------------------
-------------- LockedCloud
---------------------------------------------------

LockedCloud = class(Sprite)

assert(not LockedCloudState)
LockedCloudState = {

	STATIC		= 1,
	WAIT_TO_OPEN	= 2,
	OPENING		= 3
}

local function checkLockedCloudState(state, ...)
	assert(state)
	assert(#{...} == 0)

	assert(state == LockedCloudState.STATIC or
		state == LockedCloudState.WAIT_TO_OPEN or
		state == LockedCloudState.OPENING)
end

--function LockedCloud:init(lockedCloudId, ...)
function LockedCloud:init(lockedCloudId, animLayer, texture, ...)
	assert(type(lockedCloudId) == "number")
	assert(animLayer)
	assert(texture)
	assert(#{...} == 0)

	-- ----------------
	-- Init Base Class
	-- ---------------
	local sprite = CCSprite:create()
	self:setRefCocosObj(sprite)
	self.refCocosObj:setTexture(texture)

	-- -----
	-- Data
	-- ------
	self.id 		= lockedCloudId
	self.cloudLock 		= false
	self.animLayer		= animLayer		-- Used For Play Animation, Because Static Clould Can Batch, Other Anim Has Problem In Batch
	self.selfAnimated	= Layer:create()	-- Represetn Self In self.animLayer

	-----------------
	-- Data About UI
	-- ------------
	self.staticCloudWidth	= false
	self.staticCloudHeight	= false

	-- ------------
	-- Update View
	-- -----------
	-- Initial State
	-- Check Current State 
	-- If User's Top Level Is One Level Before Cur Lock Area's Start Level
	-- And User's TOp Level Has Star ( Means User Complete That Level )
	-- Then Is The Time To Show Lock 
	
	-- Data For Center Self Sprite
	self.staticSpriteWidth 		= false
	self.waitToOpenSpriteWidth	= false
	self.openingSpriteWidth		= false

	if self:ifCanWaitToOpen() then
		self:changeToStateWaitToOpen()
	else
		self:changeToStateStatic()
	end

	-------------
	--- Init Position 
	---------------
	-- Get Position Y Based On Node Position
	-- Get Start Node Id In Cur Level Area
	local curLevelAreaData = MetaModel:sharedInstance():getLevelAreaDataById(self.id)
	local curStartNodeId = tonumber(curLevelAreaData.minLevel)
	assert(curStartNodeId)
	self.startNodeId = curStartNodeId
end

function LockedCloud:getStartNodeId(...)
	assert(#{...} == 0)

	return self.startNodeId
end

-------------------------
---- Change State
------------------------

function LockedCloud:changeState(newState, animFinishCallback, ...)
	assert(newState)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)
	checkLockedCloudState(newState)

	-- ---------------------
	-- End Previous State
	-- ----------------------
	if self.state == LockedCloudState.STATIC then
		self:endStateStatic()
	elseif self.state == LockedCloudState.WAIT_TO_OPEN then
		self:endStateWaitToOpen()
	else
		assert(false)
	end

	-- --------------
	-- Enter New State
	-- ----------------
	if newState == LockedCloudState.STATIC then
		self:changeToStateStatic()
	elseif newState == LockedCloudState.WAIT_TO_OPEN then
		self:changeToStateWaitToOpen()
	elseif newState == LockedCloudState.OPENING then
		self:changeToStateOpening(animFinishCallback)
	end
end

------------------------
--------- State Static
-----------------------

function LockedCloud:changeToStateStatic(...)
	assert(#{...} == 0)

	self.state = LockedCloudState.STATIC
	
	self.lockedCloud = Clouds:buildStatic()

	-- Set Self Texture
	local texture = self.lockedCloud:getTexture()
	self:setTexture(texture)

	local size = self.lockedCloud:getGroupBounds().size
	self.lockedCloud:setPosition(ccp(size.width/2, -size.height/2))

	--self.ui:addChild(self.lockedCloud)
	self:addChild(self.lockedCloud)
end

function LockedCloud:endStateStatic(...)
	assert(#{...} == 0)
	assert(self.state == LockedCloudState.STATIC)

	self.lockedCloud:removeFromParentAndCleanup(true)
	self.lockedCloud = nil
end

----------------------------------------------
----- State: Wait_To_Open
-------------------------------------------

function LockedCloud:changeToStateWaitToOpen(...)
	assert(#{...} == 0)
	-- -------------------
	-- Add Event Listener
	-- ----------------------

	if self.state == LockedCloudState.WAIT_TO_OPEN then
		return 
	end

	local function onLockedCloudTapped(event, ...)
		assert(event)
		assert(#{...} == 0)

		self:onLockedCloudTapped(event)
	end
	self:addEventListener(DisplayEvents.kTouchTap, onLockedCloudTapped)

	self.state = LockedCloudState.WAIT_TO_OPEN

	if not self.lock then

		self.lock		= Clouds:buildLock()
	end 
	if not self.waitedCloud then 
		self.waitedCloud	= Clouds:buildWait()
	end

	-- Set Self Texture
	local texture = self.waitedCloud:getTexture()
	self:setTexture(texture)

	self.waitedCloud:addChild(self.lock)
	self:addChild(self.waitedCloud)

	local size	= self:getGroupBounds().size
	self.waitedCloud:setPosition(ccp(size.width/2 -16, -size.height/2 -12))

	self.lock:wait()
	self.waitedCloud:wait()

	-- Below Code Is Same AS Code In HomeScene, When Initially Create The LockedCloud And
	-- Center It . For Adjust THe Wait To Open Anim Stay The Same Center Position As The Static Cloud
	
	-- Center It Horizontal
	local visibleSize 	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local deltaWidth	= visibleSize.width - size.width 
	local halfDeltaWidth	= deltaWidth / 2
	self:setPositionX(visibleOrigin.x + halfDeltaWidth)

	local manualAdjustPosY	= - 10 - 5 - 5 -5 + 2
	self:setPositionY(self:getPositionY() + manualAdjustPosY)
end

-- Over Ride The setPositionX Function In CocosObject, 
-- For Update The self.selfAnimated Position 
function LockedCloud:setPositionX(x, ...)
	assert(type(x) == "number")
	assert(#{...} == 0)

	CocosObject.setPositionX(self, x)
	self.selfAnimated:setPositionX(x)
end

-- Same As LockedCloud:setPositionX
function LockedCloud:setPositionY(y, ...)
	assert(type(y) == "number")
	assert(#{...} == 0)

	CocosObject.setPositionY(self, y)
	self.selfAnimated:setPositionY(y)
end

function LockedCloud:endStateWaitToOpen(...)
	assert(#{...} == 0)
	assert(self.state == LockedCloudState.WAIT_TO_OPEN)

	-- Do Nothing
end

------------------------------------------------
--------- State: Opening
--------------------------------------------

function LockedCloud:changeToStateOpening(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	local animWaitToFinish = 2

	local function cloudAnimFinished()

		animWaitToFinish = animWaitToFinish - 1

		if animWaitToFinish == 0 then
			self:removeChildren(true)

			-- Callback
			if animFinishCallback then
				animFinishCallback()
			end
		end
	end

	local function lockAnimFinished()

		animWaitToFinish = animWaitToFinish - 1

		if animWaitToFinish == 0 then
			self:removeChildren(true)

			-- Callback
			if animFinishCallback then
				animFinishCallback()
			end
		end
	end

	self.lock:addEventListener(Events.kComplete, lockAnimFinished)

	-- Fade Out
	self.waitedCloud:fadeOut(cloudAnimFinished)
	self.lock:fadeOut(lockAnimFinished)
end

function LockedCloud:endStateOpening(...)
	assert(#{...} == 0)
	assert(self.state == LockedCloudState.OPENING)
end

function LockedCloud:unlockCloud(  )
	-- body
	if self.state == LockedCloudState.WAIT_TO_OPEN then
		local function onOpeningAnimFinished()
			local runningScene = HomeScene:sharedInstance()
			runningScene:checkDataChange()
			runningScene.starButton:updateView()
			runningScene.goldButton:updateView()
			runningScene.worldScene:onAreaUnlocked(self.id)
		end
		self:removeAllEventListeners()
		self:changeState(LockedCloudState.OPENING, onOpeningAnimFinished)
	end
end
---------------------------------------------------
---------- Event handler
-----------------------------------------------

function LockedCloud:onLockedCloudTapped(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchTap)
	assert(#{...} == 0)

	if self.state == LockedCloudState.STATIC then
		-- DO Nothing
	elseif self.state == LockedCloudState.WAIT_TO_OPEN then

		local function onSuccessCallback()

			print("LockedCloud:onLockedCloudTapped Called ! onSuccessCallback !")

			local function onOpeningAnimFinished()
				local runningScene = HomeScene:sharedInstance()
				runningScene:checkDataChange()
				runningScene.starButton:updateView()
				runningScene.goldButton:updateView()
				runningScene.worldScene:onAreaUnlocked(self.id)
			end
			self:removeAllEventListeners()
			self:changeState(LockedCloudState.OPENING, onOpeningAnimFinished)
		end

		local function onHasNotEnoughStarCallback(userTotalStar, neededStar, ...)
			assert(type(userTotalStar)	== "number")
			assert(type(neededStar)		== "number")

			-- local function onUserLogin()
			-- 	local unlockCloudPanel = nil
			-- 	if RecallManager.getInstance():getFinalRewardState() == RecallRewardType.AREA_SHORT or
			-- 	   RecallManager.getInstance():getFinalRewardState() == RecallRewardType.AREA_MIDDLE then 
			-- 		unlockCloudPanel = RecallLevelUnlockPanel:create(self.id, userTotalStar, neededStar, onSuccessCallback)
			-- 	elseif RecallManager.getInstance():getFinalRewardState() == RecallRewardType.AREA_LONG then 
			-- 		unlockCloudPanel = RecallFriendUnlockPanel:create(self.id, userTotalStar, neededStar, onSuccessCallback)
			-- 	else 
			-- 		unlockCloudPanel = UnlockCloudPanel:create(self.id, userTotalStar, neededStar, onSuccessCallback)
			-- 	end
			-- 	if unlockCloudPanel then unlockCloudPanel:popout(false) end
			-- end
			-- if RequireNetworkAlert:popout(onUserLogin) then
				local unlockCloudPanel = nil
				if RecallManager.getInstance():getFinalRewardState() == RecallRewardType.AREA_SHORT or
				   RecallManager.getInstance():getFinalRewardState() == RecallRewardType.AREA_MIDDLE then 
					unlockCloudPanel = RecallLevelUnlockPanel:create(self.id, userTotalStar, neededStar, onSuccessCallback)
				elseif RecallManager.getInstance():getFinalRewardState() == RecallRewardType.AREA_LONG then 
					unlockCloudPanel = RecallFriendUnlockPanel:create(self.id, userTotalStar, neededStar, onSuccessCallback)
				else 
					unlockCloudPanel = UnlockCloudPanel:create(self.id, userTotalStar, neededStar, onSuccessCallback)
				end
				if unlockCloudPanel then unlockCloudPanel:popout(false) end

				-- Update Frinds Info
				HomeScene:sharedInstance():updateFriends()
			-- end
		end

		local function onFailCallback(evt)
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..evt.data), "negative")
		end

		local user = UserManager:getInstance().user

		-- if user:getTopLevelId() == 15 or RequireNetworkAlert:popout() then
		local unlockLevelAreaLogic = UnlockLevelAreaLogic:create(self.id)
		unlockLevelAreaLogic:setOnSuccessCallback(onSuccessCallback)
		unlockLevelAreaLogic:setOnFailCallback(onFailCallback)
		unlockLevelAreaLogic:setOnHasNotEnoughStarCallback(onHasNotEnoughStarCallback)
		unlockLevelAreaLogic:start(UnlockLevelAreaLogicUnlockType.USE_STAR, {})	-- Dafult Show COmmunicating Tip And Block The Input
		-- end

	elseif self.state == LockedCloudState.OPENING then
		-- Do Nothing
	end
end

function LockedCloud:ifCanWaitToOpen(...)
	assert(#{...} == 0)
	
	local logic = IsLockedCloudCanWaitToOpenLogic:create(self.id)
	return logic:start()
end

function LockedCloud:create(lockedCloudId, animLayer, texture, ...)
	assert(type(lockedCloudId) == "number")
	assert(animLayer)
	assert(texture)
	assert(#{...} == 0)

	local newLockedCloud = LockedCloud.new()
	newLockedCloud:init(lockedCloudId, animLayer, texture)
	return newLockedCloud
end
