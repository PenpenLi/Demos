
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014年01月 1日 21:08:06
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panelBusLogic.GetInviteFriendsRewardLogic"
require "zoo/panel/component/common/BoxRewardTipPanel"

---------------------------------------------------
-------------- InvitedFriendItem
---------------------------------------------------

assert(not InvitedFriendItem)
assert(BaseUI)
InvitedFriendItem = class(BaseUI)

function InvitedFriendItem:init(layerToShowTip, ...)
	assert(#{...} == 0)

	-- Get UI
	-- self.ui	= ResourceManager:sharedInstance():buildGroup("invitedFriendItem")
	self.ui	= self.builder:buildGroup("invitedFriendItem")

	-- ----------------
	-- Init Base Class
	-- ---------------
	BaseUI.init(self, self.ui)

	------------
	-- Data
	-- ----------
	self.layerToShowTip = layerToShowTip

	-- -------------------
	-- Get UI Resource
	-- -----------------
	
	self.level1Box	= self.ui:getChildByName("level1Box")
	self.level2Box	= self.ui:getChildByName("level2Box")
	self.level3Box	= self.ui:getChildByName("level3Box")
	self.level4Box	= self.ui:getChildByName("level4Box")

	self.userPic	= self.ui:getChildByName("userPic")
	self.yellowBall	= self.ui:getChildByName("yellowBall")
	self.levelBoxs	= {self.level1Box, self.level2Box, self.level3Box, self.level4Box}

	self.level1BoxOpened	= self.ui:getChildByName("level1BoxOpened")
	self.level2BoxOpened	= self.ui:getChildByName("level2BoxOpened")
	self.level3BoxOpened	= self.ui:getChildByName("level3BoxOpened")
	self.level4BoxOpened	= self.ui:getChildByName("level4BoxOpened")
	self.levelBoxsOpened	= {self.level1BoxOpened, self.level2BoxOpened, self.level3BoxOpened, self.level4BoxOpened}


	self.notInvitedTxt = self.ui:getChildByName('notInvitedTxt')
	self.box1Label = self.ui:getChildByName('box1Label')
	self.box2Label = self.ui:getChildByName('box2Label')
	self.box3Label = self.ui:getChildByName('box3Label')
	self.box4Label = self.ui:getChildByName('box4Label')
	
	if self.notInvitedTxt then self.notInvitedTxt:setString(Localization:getInstance():getText("invite.friend.panel.not.invited")) end
	if self.box1Label then self.box1Label:setString(Localization:getInstance():getText("invite.friend.panel.invite.success")) end
	if self.box2Label then self.box2Label:setString(Localization:getInstance():getText("invite.friend.panel.friend.level18")) end
	if self.box3Label then self.box3Label:setString(Localization:getInstance():getText("invite.friend.panel.friend.level46")) end
	if self.box4Label then self.box4Label:setString(Localization:getInstance():getText("invite.friend.panel.friend.level75")) end

	--self.progressBarRes	= self.ui:getChildByName("progressBar")

	assert(self.level1Box)
	assert(self.level2Box)
	assert(self.level3Box)
	assert(self.level4Box)

	assert(self.level1BoxOpened)
	assert(self.level2BoxOpened)
	assert(self.level3BoxOpened)
	assert(self.level4BoxOpened)

	assert(self.userPic)
	assert(self.yellowBall)
	--assert(self.progressBarRes)

	---------------------
	-- Init UI Componenet
	-- -----------------
	self.level1BoxOpened:setVisible(false)
	self.level2BoxOpened:setVisible(false)
	self.level3BoxOpened:setVisible(false)
	self.level4BoxOpened:setVisible(false)

	------------------------
	-- Create UI Componenet
	-- ---------------------
	--self.progressBar	= HomeSceneItemProgressBar:create(self.progressBarRes, 50, 100)

	---------------------
	-- Data About UI
	-- ---------------
	self.friendPicInitPosX	= self.userPic:getPositionX()
	self.friendPicInitPosY	= self.userPic:getPositionY()
	self.friendPicWidth	= self.userPic:getGroupBounds().size.width
	self.friendPicHeight	= self.userPic:getGroupBounds().size.height

	self.box1PosX		= self.level1Box:getPositionX()
	self.box2PosX		= self.level2Box:getPositionX()
	self.box3PosX		= self.level3Box:getPositionX()
	self.box4PosX		= self.level4Box:getPositionX()
	self.box1Width		= self.level1Box:getGroupBounds().size.width
	self.box2Width		= self.level2Box:getGroupBounds().size.width
	self.box3Width		= self.level3Box:getGroupBounds().size.width
	self.box4Width		= self.level4Box:getGroupBounds().size.width

	self.boxPosXs 	= { self.box1PosX, self.box2PosX, self.box3PosX, self.box4PosX}
	self.boxWidths	= { self.box1Width, self.box2Width, self.box3Width, self.box4Width}

	self.initialYellowBallWidth	= self.yellowBall:getContentSize().width
	self.initialYellowBallHeight	= self.yellowBall:getContentSize().height

	------------------
	-- Get Data About Reward
	-- ---------------------
	
	local inviteReward = MetaManager.getInstance().invite_reward
	self.box1Level	= MetaManager.getInstance():inviteReward_getInviteRewardMetaById(2).condition[1].num
	self.box2Level	= MetaManager.getInstance():inviteReward_getInviteRewardMetaById(3).condition[1].num
	self.box3Level	= MetaManager.getInstance():inviteReward_getInviteRewardMetaById(4).condition[1].num
	self.box4Level	= MetaManager.getInstance():inviteReward_getInviteRewardMetaById(5).condition[1].num

	self.boxLevelNumbers = {0, self.box2Level, self.box3Level, self.box4Level}

	---------------------
	-- Add Event Listener
	-- -------------------
	
	local function onLevelBoxTapped(event)
		self:onLevelBoxTapped(event)
	end
	
	self.level1Box:setTouchEnabled(true, 0, false)
	self.level1Box:addEventListener(DisplayEvents.kTouchTap, onLevelBoxTapped, 1)

	self.level2Box:setTouchEnabled(true, 0, false)
	self.level2Box:addEventListener(DisplayEvents.kTouchTap, onLevelBoxTapped, 2)

	self.level3Box:setTouchEnabled(true, 0, false)
	self.level3Box:addEventListener(DisplayEvents.kTouchTap, onLevelBoxTapped, 3)

	self.level4Box:setTouchEnabled(true, 0, false)
	self.level4Box:addEventListener(DisplayEvents.kTouchTap, onLevelBoxTapped, 4)
end

function InvitedFriendItem:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end


function InvitedFriendItem:update(data, isPlayAnim, ...)
	assert(data)
	assert(type(isPlayAnim) == "boolean")
	assert(#{...} == 0)

	if isPlayAnim then
		--self:updateWithAnim(data)
		self:updateWithoutAnim(data)
	else
		--self:updateWithAnim(data)
		self:updateWithoutAnim(data)
	end
end


function InvitedFriendItem:updateProfile( selfInfo )
	if selfInfo and not self.clipping then
		local function onImageLoadFinishCallback(clipping)
			-- local holderSize = self.userPic:getContentSize()
			-- local clippSize = clipping:getContentSize()
			clipping:setAnchorPoint(ccp(0, -0.73))
			clipping:setPosition(ccp(1, 4))
			self.clipping = clipping
		end
		HeadImageLoader:create(selfInfo.name, selfInfo.headUrl, onImageLoadFinishCallback)
		-- self.userPic:addChild(self.clipping)
	end
end

function InvitedFriendItem:updateWithoutAnim(data, ...)
	assert(data)
	assert(#{...} == 0)

	-- laskRewardId	= 0, 1, 3,
	-- friendUid	= "123"
	-- invite	= false / true

	---- If Not Invited
	if not data.invite then
		return
	end

	-- If Invited, But Not Arrive, then Return
	if data.friendUid == "0" then
		return
	end

	print("InvitedFriendItem:updateWithoutAnim Called !")
	print(data.friendUid)
	
	self.data = data

	-- ----------------
	-- Get Self Info
	-- ----------------
	-- local selfInfo = FriendManager.getInstance().friends[data.friendUid]
	FriendManager.getInstance().invitedFriends = FriendManager.getInstance().invitedFriends or {}
	local selfInfo = FriendManager.getInstance().invitedFriends[data.friendUid]

	if not selfInfo then
		return
	end

	-- if invited, do not show 'notInvited' Text
	self.notInvitedTxt:setVisible(false)

	-------------------------------------------------------------
	-- Create A FriendPicture To Replace The Default self.userPic
	-- -------------------------------------------------------------
	self.userPic:setVisible(false)

	self.userPic = FriendPicture:create(tonumber(data.friendUid), selfInfo)
	self.userPic:setSelfTouchEnable()
	self.userPic:setRecalcMaskPosition(true)

	-- 调整新创建的 self.userPic 的大小
	local deltaWidthRatio	= 0.5
	local deltaHeightRatio	= 0.5
	self.userPic:setScaleX(deltaWidthRatio)
	self.userPic:setScaleY(deltaHeightRatio)

	self.userPic:setPosition(ccp(self.friendPicInitPosX, self.friendPicInitPosY))
	self.ui:addChild(self.userPic)


	-- Get Top Level
	local topLevel	= selfInfo.topLevelId
	self.topLevel	= topLevel

	-- Set The User Pic Location
	self:positionUserPic(topLevel)
	self:updateProfile(selfInfo)

	-- Update Each Box State
	self:updateBoxState()
end

function InvitedFriendItem:positionUserPic(friendLevel, ...)
	assert(type(friendLevel) == "number")
	assert(#{...} == 0)
	if self.isDisposed then return end

	-------------------------------------------
	-- Cur User Pic Should Between Which Two Box
	-- ----------------------------------------
	
	local afterWhichBox = 0

	for index,v in ipairs(self.boxLevelNumbers) do
		if friendLevel >= v then
			afterWhichBox = index
		end
	end

	local sectionInitPos 	= false
	local sectionLength	= false

	local deltaLevel	= false
	local sectionLevels	= false


	-- Between Which Section:
	---	Box1			Box 2			Box3		Box4
	---------|---- a section -------|------ a section -----|---- a section---|
	-----  Need Enter		18			46		75

	if afterWhichBox == 1  or 
		afterWhichBox == 2 or
		afterWhichBox == 3 then

		sectionInitPos	= self.boxPosXs[afterWhichBox] + self.boxWidths[afterWhichBox]/2
		sectionLength	= self.boxPosXs[afterWhichBox + 1] + self.boxWidths[afterWhichBox + 1]/2 - sectionInitPos
		deltaLevel	= friendLevel - self.boxLevelNumbers[afterWhichBox]
		sectionLevels	= self.boxLevelNumbers[afterWhichBox + 1] - self.boxLevelNumbers[afterWhichBox] + 1

	elseif afterWhichBox == 4 then

		deltaLevel 	= friendLevel - self.box3Level
		sectionInitPos	= self.box3PosX + self.box3Width/2
		sectionLength	= (self.box4PosX + self.box4Width/2) - sectionInitPos
		sectionLevels	= self.boxLevelNumbers[4] - self.boxLevelNumbers[3] + 1
	end

	local percentage = deltaLevel / sectionLevels
	if percentage > 1 then
		percentage = 1
	end

	local newPosX	= sectionInitPos + sectionLength * percentage
	self.userPic:setPositionX(newPosX)

	---------------------------------
	-- Set The Progress Bar Percentage
	-- ----------------------------------
	local deltaX	= newPosX - self.friendPicInitPosX + self.friendPicWidth/2
	self.yellowBall:setPreferredSize(CCSizeMake(deltaX, self.initialYellowBallHeight))
end

function InvitedFriendItem:updateBoxState(...)
	assert(#{...} == 0)

	local state = self.data
	local lastRewardId = state.lastRewardId

	print("lastRewardId: " .. lastRewardId)

	local bitMask = 2

	for index = 1, 4 do

		bitMask = bitMask * 2

		-- If Already Received The Reward
		if bit.band(lastRewardId, bitMask) > 0 then
			self:setBoxOpenedByIndex(index)
		else

		end
	end
end

function InvitedFriendItem:sendReceiveRewardMsg(rewardId, onSuccessCallback, ...)
	assert(type(rewardId) == "number")
	assert(type(onSuccessCallback) == "function")
	assert(#{...} == 0)

	local function onSuccess(event)
		assert(event)
		assert(event.name == Events.kComplete)

		onSuccessCallback()
	end

	local function onFail()
		assert(false)
	end

	local http = GetInviteFriendsReward.new(true)
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFail)
	local friendId = self.data.friendUid
	http:load(friendId, rewardId)

	print("InvitedFriendItem:sendReceiveRewardMsg Called ! friendId: " .. friendId .. "\t rewardId: " .. rewardId)
end

function InvitedFriendItem:setBoxOpenedByIndex(boxIndex, ...)
	assert(type(boxIndex) == "number")
	assert(#{...} == 0)

	-- Opened Box
	if self.levelBoxsOpened[boxIndex] and not self.levelBoxsOpened[boxIndex].isDisposed then
		self.levelBoxsOpened[boxIndex]:setVisible(true)
	end

	-- Closed Box
	if self.levelBoxs[boxIndex] and not self.levelBoxs[boxIndex].isDisposed then
		self.levelBoxs[boxIndex]:setVisible(false)
	end
end

function InvitedFriendItem:onLevelBoxTapped(event, ...)
	assert(event)
	assert(event.context)
	assert(#{...} == 0)

	local tappedBoxIndex	= event.context
	local levelBoxOpened 	= self.levelBoxs[tappedBoxIndex]
	
	---------------------------------------
	-- Receive The Reward Of Show The Reward Tip
	-- ----------------------------------------

	print("InvitedFriendItem:onLevelBoxTapped Called !")

	print("self.topLevel: " .. tostring(self.topLevel))


	-- Check If Can Receive The Reward
	if self.topLevel and self.topLevel > self.boxLevelNumbers[tappedBoxIndex] then
		-- Receive The Reward

		local function onSendReceiveRewardSuccess()
			print("receive reward success !!!")
			if self.isDisposed then return end
			self:setBoxOpenedByIndex(tappedBoxIndex)


			------------------
			-- Update
			-- -------------
			HomeScene:sharedInstance():checkDataChange()

			-- Play Reward Anim
			local rewardId = tappedBoxIndex + 1
			local boxReward = MetaManager.getInstance():inviteReward_getInviteRewardMetaById(rewardId)

			print("InvitedFriendItem:playOpenAnim Called !")
			print(table.tostring(boxReward))
			--debug.debug()


			-- Play Flying Reward Anim
			local rewardIds = {}
			for k,v in pairs(boxReward.rewards) do
				table.insert(rewardIds, v.itemId)
			end

			print("reawrd ids:")
			print(table.tostring(rewardIds))

			--local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds)
			--for k,v in pairs(anims) do
			--	v:playFlyToAnim(false)
			--end

			local pos = levelBoxOpened:getPosition()
			self:playRewardAnim(boxReward.rewards, levelBoxOpened)
		end

		local rewardId = tappedBoxIndex + 1
		self:sendReceiveRewardMsg(rewardId, onSendReceiveRewardSuccess)
	else
		---------------------------
		-- Set The Box Reward Tip
		-- -------------------------
		local metaId 		= tappedBoxIndex + 1
		local inviteRewardMeta	= MetaManager.getInstance():inviteReward_getInviteRewardMetaById(metaId)

		local rewardConditionType	= inviteRewardMeta.condition.itemId
		local rewardConditionValue	= inviteRewardMeta.condition.num

		local tipPanel = BoxRewardTipPanel:create(inviteRewardMeta)

		-------------------------
		-- Update Tip
		-- ---------------------
		
		if tappedBoxIndex == 1 then
			
			print("tappedBoxIndex == 1")
			local tipTxtKey		= "invite.friend.panel.need.friend.enter.tip"
			local tipTxtValue	= Localization:getInstance():getText(tipTxtkey)

			tipPanel:setTipString(tipTxtValue)
		else

			if self.topLevel then
				local boxLevel 		= self.boxLevelNumbers[tappedBoxIndex]
				local curLevel		= self.topLevel
				local deltaLevel	= boxLevel - curLevel + 1

				local tipTxtkey		= "invite.friend.panel.rule.tips"
				local tipTxtValue	= Localization:getInstance():getText(tipTxtkey, {num = deltaLevel})

				--tipPanel:setTipString("hello, test !")
				tipPanel:setTipString(tipTxtValue)
			else
				--tipPanel
			end
		end
		self.layerToShowTip:addChild(tipPanel)

		local tappedBoxPos 		= levelBoxOpened:getPosition()
		local tappedBoxPosInWorldPos 	= self.ui:convertToWorldSpace(ccp(tappedBoxPos.x, tappedBoxPos.y))

		local tappedBoxSize		= levelBoxOpened:getGroupBounds().size
		tappedBoxPosInWorldPos.x 	= tappedBoxPosInWorldPos.x + tappedBoxSize.width / 2
		tappedBoxPosInWorldPos.y	= tappedBoxPosInWorldPos.y - tappedBoxSize.height / 2

		local enlargeRestoreAction = EnlargeRestore:create(levelBoxOpened, tappedBoxSize, 1.25, 0.1, 0.1)
		if levelBoxOpened:numberOfRunningActions() == 0 then
			levelBoxOpened:runAction(enlargeRestoreAction)
		end

		tipPanel:setArrowPointPositionInWorldSpace(tappedBoxSize.width/2, tappedBoxPosInWorldPos.x, tappedBoxPosInWorldPos.y)
	end
end

function InvitedFriendItem:playRewardAnim(rewards, boxOpened, ...)
	--local sSize = self.signed[self.signedDay]:getGroupBounds().size
	local sSize = boxOpened:getGroupBounds().size

	-- local home = Director:sharedDirector():getRunningScene()
	local home = HomeScene:sharedInstance()
	--local reward = self.markRewards[self.signedDay].rewards
	--local rType = self.markRewards[self.signedDay].type
	--local pos = self.signed[self.signedDay]:getPosition()
	local pos = boxOpened:getPosition()
	pos = boxOpened:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
	--print(pos.x, pos.y)
	local vSize = Director:sharedDirector():getVisibleSize()
	home:checkDataChange()
	--if rType == 2 then
		local count = 0
		local width, spare = 60, 30
		local fullWidth = #rewards * (width + spare) - spare
		local startPosX = pos.x - fullWidth / 2
		if startPosX < 0 then startPosX = 0
		elseif startPosX + fullWidth >= vSize.width then
			startPosX = pos.x - fullWidth
		end
		print(startPosX, fullWidth, vSize.width, startPosX + fullWidth)
		for __, v in ipairs(rewards) do
			count = count + 1

			local anim = FlyItemsAnimation:create({v})
			anim:setWorldPosition(ccp(startPosX + (count - 1) * (width + spare),pos.y - 10))
			anim:play()
			
		end
	--else
	--	local coins = home:createFlyingCoinAnim()
	--	if not self.coinSize then self.coinSize = coins:getGroupBounds().size end
	--	coins:setPosition(ccp(pos.x - self.coinSize.width / 3, pos.y + self.coinSize.height / 2))
	--	coins:playFlyToAnim(false, false)
	--end
end

he_log_warning("duplicate code, need reform later !!!")

function InvitedFriendItem:create(layerToShowTip, ...)
	assert(layerToShowTip)
	assert(#{...} == 0)

	local newInvitedFriendItem = InvitedFriendItem.new()
	newInvitedFriendItem:loadRequiredResource(PanelConfigFiles.invite_friend_reward_panel)
	newInvitedFriendItem:init(layerToShowTip)
	return newInvitedFriendItem
end
