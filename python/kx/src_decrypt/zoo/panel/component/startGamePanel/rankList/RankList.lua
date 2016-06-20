
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月12日 16:11:48
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panel.component.startGamePanel.rankList.RankListItem"
require "zoo.panel.component.startGamePanel.rankList.RankListCache"
require "hecore.ui.TableView"
require "zoo.panel.component.startGamePanel.rankList.RankListButton"
require "zoo.panel.component.startGamePanel.rankList.GetMoreButton"

------------------------------------------------------
------	Rank List Table View Render
------	
------  When Table View Need To Show A Cell, This Class Will Be Called !
------  Then This Class Will Call RankListCache's Function To Get The Data.
------
------  When Requested Data Is In The Cache, Return Imemedately.
------  When Requested Data Is Not In The Cache, Return Nil, And Send Message To The Server.
------		After A While, When The Data Return From Server, A Call Back Function Will Called.
------		This Callback Then Call Table View's reloadData Function
---------------------------------------------

-- -------------------
-- Need Information: 
-- 	Rank Index
-- 	User Name
-- 	User Score
-- 	User Picture
-----------------------

--------------------------------------------
-----	Rank List Table View Render
---------------------------------------------

assert(not RankListTableViewRender)
RankListTableViewRender = class(TableViewRenderer)

function RankListTableViewRender:init(rankListDataCache, cacheRankType, useSpecialActivityUI, ...)
	assert(rankListDataCache)
	assert(cacheRankType)
	RankListCacheRankType.checkRankType(cacheRankType)
	assert(#{...} == 0)

	self.rankListDataCache	= rankListDataCache
	self.cacheRankType	= cacheRankType
	self.useSpecialActivityUI = useSpecialActivityUI

	self.rankListItems = {}
end
function RankListTableViewRender:dispose(  )
	if not self.isDisposed then
		for k,v in pairs(self.rankListItems) do
			v:dispose()
		end
		self.isDisposed = true
	end
end


function RankListTableViewRender:create(rankListDataCache, cacheRankType, width, height, useSpecialActivityUI, ...)
	assert(rankListDataCache)
	assert(cacheRankType)
	RankListCacheRankType.checkRankType(cacheRankType)
	assert(type(width) == "number")
	assert(type(height) == "number")
	assert(#{...} == 0)

	local render = RankListTableViewRender.new(width, height)
	render:init(rankListDataCache, cacheRankType, useSpecialActivityUI)
	return render
end

function RankListTableViewRender:buildCell(cell, index, ...)
	assert(cell)
	assert(type(index) == "number")
	assert(#{...} == 0)

	local numberOfCells	= self:numberOfCells()
	local rankListItemRes	= false

	if self.useSpecialActivityUI then
		local builder = InterfaceBuilder:createWithContentsOfFile(PanelConfigFiles.panel_game_start_activity)
		rankListItemRes 	= builder:buildGroup("Spring2016UI/rankListItem")
	else
		rankListItemRes 	= ResourceManager:sharedInstance():buildGroup("rankListItem")
	end
	local rankListItem	= RankListItem:create(rankListItemRes)
	self.rankListItems[index + 1] = rankListItem

	-- TODO: check for wrong in getGroupBounds
	local rankListItemHeight = 80
	-- local rankListItemHeight = rankListItem:getGroupBounds().size.height
	rankListItem:setPosition(ccp(0, rankListItemHeight))
	cell.refCocosObj:addChild(rankListItem.refCocosObj)

	rankListItem:releaseCocosObj()
end

function RankListTableViewRender:getContentSize(tableView, index, ...)
	assert(tableView)
	assert(type(index) == "number")
	assert(#{...} == 0)

	local numberOfCells = self:numberOfCells()
	return CCSizeMake(self.width, self.height)
end

function RankListTableViewRender:setData(rawCocosObj, index, ...)
	assert(rawCocosObj)
	assert(index)
	assert(#{...} == 0)
	if self.isDisposed then return end

	index = index + 1

	-- Get RankListItem To Set Data
	local rankListItemToControl = self.rankListItems[index]
	assert(rankListItemToControl)

	-- Get Data, And Update View
	local data = self.rankListDataCache:getCurCachedRankList(self.cacheRankType, index)
	assert(data)
	local userName = data.name
	if userName == nil or data.name == "" then userName = tostring(data.uid) end
	local uid = UserManager:getInstance():getUserRef().uid
	rankListItemToControl:setData(index, userName, data.score, data.headUrl, uid == data.uid)
end

function RankListTableViewRender:numberOfCells(...)
	assert(#{...} == 0)

	local cachedDataLength = self.rankListDataCache:getCurCachedRankListLength(self.cacheRankType)
	return cachedDataLength
end


---------------------------------------------------
-------------- RankList
---------------------------------------------------

assert(not RankList)
assert(BaseUI)
RankList = class(BaseUI)

function RankList:init(levelId, panelWithRank, useSpecialActivityUI, ...)
	assert(levelId)
	assert(#{...} == 0)

	self.visibleSize		= CCDirector:sharedDirector():getVisibleSize()

	-- ----------------
	-- Get UI Resource
	-- ----------------
	self.useSpecialActivityUI = useSpecialActivityUI
	if self.useSpecialActivityUI then
		self.builder = InterfaceBuilder:createWithContentsOfFile(PanelConfigFiles.panel_game_start_activity)
		self.ui = self.builder:buildGroup("Spring2016UI/newRankListPanel")
	else
		self.ui	= ResourceManager:sharedInstance():buildGroup("newRankListPanel")
	end

	-- -------------------
	-- Pattern in activity version
	-- -------------------
	if self.useSpecialActivityUI then
		local pattern = self.ui:getChildByName("pattern")
		pattern:removeFromParentAndCleanup(false)

		local childList = {}
		pattern:getVisibleChildrenList(childList)
		if #childList > 0 then
			local batch = SpriteBatchNode:createWithTexture(childList[1]:getTexture())
			for i,v in ipairs(childList) do
				v:removeFromParentAndCleanup(false)
				batch:addChild(v)
			end
			batch:setPositionXY(pattern:getPositionX(), pattern:getPositionY())
			pattern:dispose()
			pattern = batch
		end
		
		local mask = self.ui:getChildByName("mask")
		local maskPosition = {x = mask:getPositionX(), y = mask:getPositionY()}
		local maskIndex = self.ui:getChildIndex(mask)
		mask:removeFromParentAndCleanup(false)
		local clip = ClippingNode.new(CCClippingNode:create(mask.refCocosObj))
		clip:setAlphaThreshold(0.7)
		self.ui:addChildAt(clip, maskIndex)
		pattern:setPositionXY(pattern:getPositionX() - maskPosition.x, pattern:getPositionY())
		clip:addChild(pattern)
	end

	-- ----------------
	-- Init Base
	-- ----------------
	BaseUI.init(self, self.ui)

	---------------
	-- Data
	-- ------------
	self.levelId 		= levelId
	self.panelWithRank	= panelWithRank
	self.popouted = false
	self.serverRankInitialDataReady = false

	-- ----------------
	-- Get UI Resource
	-- ----------------
	
	self.rankLabelWrapper	= self.ui:getChildByName("rankLabelWrapper")

	self.myRankLabel		= self.rankLabelWrapper:getChildByName("myRankLabel")
	self.rankNumLabel		= self.rankLabelWrapper:getChildByName("rankNumLabel")
	--self.notHaveRankLabel		= self.rankLabelWrapper:getChildByName("notHaveRankLabel")

	self.rankListItemPh	= self.ui:getChildByName("rankListItemPh")
	self.friendRankBtnRes	= self.ui:getChildByName("friendRankBtn")
	self.serverRankBtnRes	= self.ui:getChildByName("serverRankBtn")
	self.scale9Bg		= self.ui:getChildByName("scale9Bg")
	self.rankListItemBg	= self.ui:getChildByName("rankListItemBg")

	self.addFriendBtn	= self.ui:getChildByName("addFriendBtn")
	self.noNetworkLabel	= self.ui:getChildByName("noNetworkLabel")

	assert(self.rankLabelWrapper)
	assert(self.myRankLabel)
	assert(self.rankNumLabel)
	--assert(self.notHaveRankLabel)

	assert(self.rankListItemPh)
	assert(self.friendRankBtnRes)
	assert(self.serverRankBtnRes)
	assert(self.scale9Bg)
	assert(self.rankListItemBg)

	assert(self.addFriendBtn)
	assert(self.noNetworkLabel)

	----------------------
	---- Init UI Resource
	----------------------
	self.rankListItemPh:setVisible(false)

	self.myRankLabel:setVisible(false)
	self.rankNumLabel:setVisible(false)
	--self.notHaveRankLabel:setVisible(false)
	self.rankLabelWrapper:setScale(1)

	-- Hide No Network Label
	self.noNetworkLabel:setVisible(false)

	--- Update UI
	local noNetWorkLabelKey		= "rank.list.no.network"
	local noNetWorkLabelValue	= Localization:getInstance():getText(noNetWorkLabelKey, {})
	self.noNetworkLabel:setString(noNetWorkLabelValue)

	-- ----------------- 
	-- -- Get Data About UI
	-- ------------------
	local rankListItemPhPos		= self.rankListItemPh:getPosition()
	local rankListItemWidth		= ResourceManager:sharedInstance():getGroupWidth("rankListItem")
	-- TODO: check for wrong in getGroupBounds
	local rankListItemHeight	= 80
	-- local rankListItemHeight	= ResourceManager:sharedInstance():getGroupHeight("rankListItem")

	local rankLabelKey	= "rank.list.my.rank"
	local rankLabelValue	= Localization:getInstance():getText(rankLabelKey, {})
	--self.rankLabelValue	= rankLabelValue
	-- Mocke
	--self.rankLabelValue	= "我的排名："
  rankLabelValue = rankLabelValue:gsub("：", ":  ")
	self.myRankLabel:setString(rankLabelValue)


	local notHaveRankLabelKey	= ""
	local notHaveRankLabelValue	= Localization:getInstance():getText(notHaveRankLabelKey, {})
	-- Mock
	he_log_warning("use mock data !")
	local notHaveRankLabelValue	= "没有获得排名"
	--self.notHaveRankLabel:setString(notHaveRankLabelValue)

	--------------
	-- Data
	-- -------
	--self.isFriendRankHasData = false
	--self.isServerRankHasData = false
	self.isFriendRankHasData = true
	self.isServerRankHasData = true

	-- --------------------
	-- Create Component
	-- -----------------
	local function onServerBtnTapped()
		self:onServerBtnTapped()
	end

	local function onFriendBtnTapped()
		self:onFriendBtnTapped()
	end

	self.serverRankBtn	= RankListButton:create(self.serverRankBtnRes, onServerBtnTapped)
	self.friendRankBtn	= RankListButton:create(self.friendRankBtnRes, onFriendBtnTapped)

	-- Init Button State
	local serverRankBtnKey		= "rank.list.server.rank"
	local serverRankBtnValue	= Localization:getInstance():getText(serverRankBtnKey, {})
	self.serverRankBtn:setString(serverRankBtnValue)

	self.serverRankBtn:setToUntappedState()

	local friendRankBtnKey		= "rank.list.friend.rank"
	local friendRankBtnValue	= Localization:getInstance():getText(friendRankBtnKey, {})
	self.friendRankBtn:setString(friendRankBtnValue)
	
	-- --------------------
	-- Create Rank List Data Cache
	-- ------------------------
	-- Rank List Data Cache Is The Data Source For Server/Friend Rank List
	

	-- On Cache Data Change Callback
	-- To Reload Data And Keep The Scroll Position Not Changed
	local function onRankListCachedDataChange(rankType, ...)
		RankListCacheRankType.checkRankType(rankType)
		assert(#{...} == 0)

		--he_log_warning("check if disposed")
		if self.serverRankListTableView.isDisposed then
			return
		end

		if rankType == RankListCacheRankType.SERVER then

			self.isServerRankHasData = true
			self.serverRankListTableView:reloadData()
			self:updateWhenDataChange()

		elseif rankType == RankListCacheRankType.FRIEND then

			local curFriendRank = UserManager:getInstance().selfNumberInFriendRank[self.levelId]
			if self.panelWithRank.panelName == "levelSuccessPanel" then
				--ShareManager:setShareData(ShareManager.ConditionType.FRIEND_RANK, curFriendRank)
				AchievementManager:onDataUpdate( AchievementManager.FRIEND_RANK, curFriendRank )
				if self.rankListCache and self.rankListCache.friendRankList then
					--ShareManager:setShareData(ShareManager.ConditionType.FRIEND_RANK_LIST, self.rankListCache.friendRankList)
					--ShareManager:setShareData(ShareManager.ConditionType.PASS_FRIEND_NUM, #self.rankListCache.friendRankList - 1)
					AchievementManager:onDataUpdate( AchievementManager.FRIEND_RANK_LIST, self.rankListCache.friendRankList )
					AchievementManager:onDataUpdate( AchievementManager.PASS_FRIEND_NUM, #self.rankListCache.friendRankList - 1 )
				end
				--ShareManager:shareWithID(ShareManager.FRIST_RANK_FRIEND)
				--ShareManager:shareWithID(ShareManager.SCORE_OVER_FRIEND)
				--ShareManager:shareWithID(ShareManager.LEVEL_OVER_FRIEND)
			end

			self.isFriendRankHasData = true
			self.friendRankListTableView:reloadData()
			self:updateWhenDataChange()
		else 
			assert(false)
		end
	end

	-- On Get Server Rank List Failed
	local function onGetServerRankFailed()
		print("onGetServerRankFailed Called !")

		if self.isDisposed then
			return
		end

		self.isServerRankHasData = false
		--self.noNetworkLabel:setVisible(true)
		self:updateNoNetWorkLabel()
	end

	-- On Get Friend Rank List Failed
	local function onGetFriendRankFailed()
		print("onGetFriendRankFailed Called !")

		self.isFriendRankHasData = false
		self:updateNoNetWorkLabel()
		--self.noNetworkLabel:setVisible(true)
	end

	local hiddenRankList = self.panelWithRank.hiddenRankList
	self.rankListCache = RankListCache:create(self.levelId, onRankListCachedDataChange, hiddenRankList)
	self.rankListCache:setGetFriendRankFailedCallback(onGetFriendRankFailed)
	self.rankListCache:setGetServerRankFailedCallback(onGetServerRankFailed)

	-- ------------------------
	-- Create Server Rank List
	--------------------------
	
	local function onServerRankListItemTouched(event)
		self:onServerRankListItemTouched(event)
	end
	
	local size = self.rankListItemBg:getGroupBounds().size
	self.serverRankListTableViewRender	= RankListTableViewRender:create(self.rankListCache, RankListCacheRankType.SERVER,
		rankListItemWidth, rankListItemHeight, useSpecialActivityUI)
	-- self.serverRankListTableView		= TableView:create(self.serverRankListTableViewRender, rankListItemWidth, rankListItemHeight * 6.8)
	self.serverRankListTableView		= TableView:create(self.serverRankListTableViewRender, rankListItemWidth, size.height - 25)
	--self.serverRankListTableView:setTouchEnabled(false)

	--------------------
	-- Craete Friend Rank List
	-- -----------------
	self.friendRankListTableViewRender	= RankListTableViewRender:create(self.rankListCache, RankListCacheRankType.FRIEND,
		rankListItemWidth, rankListItemHeight, useSpecialActivityUI)
	-- self.friendRankListTableView		= TableView:create(self.friendRankListTableViewRender, rankListItemWidth, rankListItemHeight * 6.8)
	self.friendRankListTableView		= TableView:create(self.friendRankListTableViewRender, rankListItemWidth, size.height - 25)
	--elf.friendRankListTableView:setTouchEnabled(false)
	
	--------------------
	--- Cache Load Initial Data
	---------------------------
	--self.rankListCache:loadInitialData()
	self.rankListCache:loadInitialFriendRank()

	----------------------
	--- Set Rank List Position
	----------------------------
	local rankListTableViewPosX = rankListItemPhPos.x
	local rankListTableViewPosY = rankListItemPhPos.y - self.serverRankListTableView:getViewSize().height
	
	self.serverRankListTableView:setPosition(ccp(rankListTableViewPosX, rankListTableViewPosY))
	self.ui:addChild(self.serverRankListTableView)

	self.friendRankListTableView:setPosition(ccp(rankListTableViewPosX, rankListTableViewPosY))
	self.ui:addChild(self.friendRankListTableView)

	-----------------
	-- Initial State
	-- -----------
	self.serverRankListTableView:setVisible(false)

	self:setTableViewTouchEnable(false)

	---------------
	-- Add Event Listener
	-- ------------------

	local function onAddFriendBtnTapped()
		self:onAddFriendButtonTapped()
	end
	
	if PrepackageUtil:isPreNoNetWork() then
		self.addFriendBtn:setVisible(false)
	else
		self.addFriendBtn:setTouchEnabled(true)
		self.addFriendBtn:setButtonMode(true)
		self.addFriendBtn:addEventListener(DisplayEvents.kTouchTap, onAddFriendBtnTapped)
	end
end

function RankList:setButtonsEnable(enable)
	if self.addFriendBtn then
		self.addFriendBtn:setTouchEnabled(false)
	end
end

function RankList:onAddFriendButtonTapped(...)
	assert(#{...} == 0)

	print("RankList:onAddFriendButtonTapped Called !")
	if __IOS_FB then
		SnsProxy:inviteFriends(nil)
	else
		local addFriendBtnPosInWorldSpace	= self.addFriendBtn:getPositionInWorldSpace()
		
		-- Pop The Add Friend Panel
		local panel = require("zoo.panel.addfriend.NewAddFriendPanel"):create(addFriendBtnPosInWorldSpace)
		-- panel:popout()
		--local panel = AddFriendPanel:create(addFriendBtnPosInWorldSpace)
		--local selfParent = self:getParent():setRankListPanelTouchDisable()
		self.panelWithRank:setRankListPanelTouchDisable()
		if panel then 
			--panel:popout()
		end
	end	
end

-- Called By PanelWithRankExchangeAnim / PanelWithRankPopRemoveAnim, When This Rank List Is 
-- About To Poping Out
function RankList:prePopoutCallback(...)
	assert(#{...} == 0)

	--self.popouted = true

	--if self.serverRankInitialDataReady then
	--	local oldContentHeight = self.serverRankListTableView:getContentSize().height
	--	local oldContentOffsetX	= self.serverRankListTableView:getContentOffset().x
	--	local oldContentOffsetY = self.serverRankListTableView:getContentOffset().y
	--	self.serverRankListTableView:reloadData()
	--	local newContentHeight = self.serverRankListTableView:getContentSize().height
	--	if newContentHeight == oldContentHeight then
	--		self.serverRankListTableView:setContentOffset(ccp(oldContentOffsetX, oldContentOffsetY))
	--	else
	--		local offset = ccp(oldContentOffsetX, oldContentOffsetY - (newContentHeight - oldContentHeight))
	--		self.serverRankListTableView:setContentOffset(ccp(offset.x, offset.y))
	--	end
	--end
end

function RankList:postPopoutCallback(...)
	assert(#{...} == 0)

	self:setTableViewTouchEnable(true)

	-- Load The User Head Picture

end


function RankList:updateNoNetWorkLabel(...)
	assert(#{...} == 0)

	if self.isDisposed then
		return
	end

	if self.serverRankListTableView:isVisible() then

		if self.isServerRankHasData then
			self.noNetworkLabel:setVisible(false)
		else
			self.noNetworkLabel:setVisible(true)
		end
	end

	if self.friendRankListTableView:isVisible() then

		if self.isFriendRankHasData then
			self.noNetworkLabel:setVisible(false)
		else
			self.noNetworkLabel:setVisible(true)
		end
	end
end


function RankList:updateWhenDataChange(...)
	assert(#{...} == 0)

	if self.isDisposed then
		return
	end

	-- When Server Rank Is Visible
	if self.serverRankListTableView:isVisible() then
		self:changeLabelToServerRank()
	end

	-- Or Friend Rank Is Visibel
	if self.friendRankListTableView:isVisible() then
		self:changeLabelToFriendRank()
	end

	self:updateNoNetWorkLabel()
end

function RankList:createLineStar(width, height)
	local textureSprite = Sprite:createWithSpriteFrameName("win_star_shine0000")
	local container = SpriteBatchNode:createWithTexture(textureSprite:getTexture())
	for i = 1, 15 do
		local sprite = Sprite:createWithSpriteFrameName("win_star_shine0000")
		sprite:setPosition(ccp(width*math.random(), height*math.random()))
		sprite:setOpacity(0)
		sprite:setScale(0)
		sprite:runAction(CCRepeatForever:create(CCRotateBy:create(0.1 + math.random()*0.3, 150)))
		local scaleTo = 0.3 + math.random() * 0.8
		local fadeInTime, fadeOutTime = 0.4, 0.4
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(math.random()*0.5))
		array:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(fadeInTime), CCScaleTo:create(fadeInTime, scaleTo)))
		array:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(fadeOutTime), CCScaleTo:create(fadeOutTime, 0)))
		sprite:runAction(CCSequence:create(array))
		container:addChild(sprite)
	end
	local function onAnimationFinished() container:removeFromParentAndCleanup(true) end
	container:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.3), CCCallFunc:create(onAnimationFinished)))
	textureSprite:dispose()
	return container
end

function RankList:playChangeRankAnim(oldNumber, newNumber, animFinishCallback, ...)
	--assert(type(oldNumber) == "number")
	--assert(type(newNumber) == "number")
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	-- Cur Rank 
	--local oldRank	= UserManager:getInstance().selfOldNumberInFriendRank[self.levelId]
	--local curRank	= UserManager:getInstance().selfNumberInFriendRank[self.levelId]
	
	local oldRank	= oldNumber
	local curRank	= newNumber

	print("type(oldRank): " .. type(oldRank))
	print("type(curRank): " .. type(curRank))
	print("oldRank: " .. tostring(oldRank))
	print("curRank: " .. tostring(curRank))

	self.myRankLabel:setVisible(false)
	self.rankNumLabel:setVisible(false)
	--self.notHaveRankLabel:setVisible(false)
	if self.rankLabelWrapper:numberOfRunningActions() ~= 0 then
		self.rankLabelWrapper:stopAllActions()
	end
	self.rankLabelWrapper:setScale(1)

	-- New Rank Reached
	if curRank ~= oldRank then

		if not oldRank then
			oldRank = curRank
		end

		----------------------------------
		-- Get A New Rank, Create And Play The Anim
		-- -------------------------------------------
		local actionArray 	= CCArray:create()

		-- Enlarge Label
		local enlargeAction	= CCScaleTo:create(0.3, 1.5)
		local easeLargeAction	= CCEaseSineIn:create(enlargeAction)
		local targetEaseLarge	= CCTargetedAction:create(self.rankLabelWrapper.refCocosObj, easeLargeAction)
		actionArray:addObject(targetEaseLarge)

		self.rankNumLabel:setString(tostring(oldRank))

		if curRank < oldRank then
			-- Advance In Rank Play The Anim
			-- Change Rank Label Number
			self.myRankLabel:setVisible(true)
			self.rankNumLabel:setVisible(true)

			for index = oldRank,curRank,-1 do
				-- Delay A Little
				local delay = CCDelayTime:create(0.08)

				-- Change The Rank Number
				local function changeRank()
					self.rankNumLabel:setString(tostring(index))
				end
				local changeRankAction = CCCallFunc:create(changeRank)

				local seq = CCSequence:createWithTwoActions(delay, changeRankAction)
				actionArray:addObject(seq)
			end

			local seq = CCSequence:create(actionArray)

			---------------------------------------
			--- Shining Anim
			---------------------------------------

			local rankLabelWrapperPos	= self.rankLabelWrapper:getPosition()
			local shining = self:createLineStar(274, 55)
			
			shining:setPosition(ccp(rankLabelWrapperPos.x, rankLabelWrapperPos.y))
			self.ui:addChild(shining)

			self.rankLabelWrapper:runAction(seq)
		else
			-- Not Advance In Rank
			if not curRank then
				-- Not Get A Rank
				he_log_warning("hard coded not have a rank text!")
				--self.notHaveRankLabel:setVisible(true)
			else
				self.myRankLabel:setVisible(true)
				self.rankNumLabel:setVisible(true)
				self.rankNumLabel:setString(curRank)
			end
		end
	else
		-- -------------------
		-- Not Get A New Rank
		-- --------------------

		if not curRank then
			-- Not Get A Rank
			--self.notHaveRankLabel:setVisible(true)
		else
			self.myRankLabel:setVisible(true)
			self.rankNumLabel:setVisible(true)
			self.rankNumLabel:setString(curRank)
		end
	end
end

function RankList:onServerBtnTapped(...)
	assert(#{...} == 0)

	--if self.isServerRankHasData then
	if not self.isOnServerBtnTappedCalled then
		self.isOnServerBtnTappedCalled = true

		self.rankListCache:loadInitialServerRank()
	else

	end

	------------------
	--- Exchange Table View
	--------------------
	self.serverRankListTableView:setVisible(true)
	self.friendRankListTableView:setVisible(false)

	-- Reset Friend Rank Btn State
	self.friendRankBtn:setToUntappedState()

	-- Show Self Rank
	self:changeLabelToServerRank()

	-- Show Or Hide "Has No NetWork Label"
	self:updateNoNetWorkLabel()
end

function RankList:onFriendBtnTapped(...)
	assert(#{...} == 0)

	------------------
	--- Exchange Table View
	--------------------
	self.serverRankListTableView:setVisible(false)
	self.friendRankListTableView:setVisible(true)

	-- Reset Server Rank Btn State
	self.serverRankBtn:setToUntappedState()

	-- Show Self Rank
	self:changeLabelToFriendRank()

	-- Show Or Hide "Has No NetWork Label"
	self:updateNoNetWorkLabel()
end

function RankList:changeLabelToServerRank(...)
	assert(#{...} == 0)

	-- Cur Server Rank
	local oldServerRank = UserManager:getInstance().selfOldNumberInServerRank[self.levelId]
	local curServerRank = UserManager:getInstance().selfNumberInServerRank[self.levelId]

	print("RankList:changeLabelToServerRank Called !")

	self:playChangeRankAnim(oldServerRank, curServerRank, false)
end

function RankList:changeLabelToFriendRank(...)
	assert(#{...} == 0)

	-- Cur Self Rank In Friend 
	local oldFriendRank = UserManager:getInstance().selfOldNumberInFriendRank[self.levelId]
	local curFriendRank = UserManager:getInstance().selfNumberInFriendRank[self.levelId]

	print("RankList:changeLabelToFriendRank Called !")
	print("oldFriendRank: " .. tostring(oldFriendRank))
	print("curFriendRank: " .. tostring(curFriendRank))

	self:playChangeRankAnim(oldFriendRank, curFriendRank, false)
end

function RankList:setTableViewTouchEnable(bool, ...)
	assert(type(bool) == "boolean")
	assert(#{...} == 0)

	self.serverRankListTableView:setTouchEnabled(bool)
	self.friendRankListTableView:setTouchEnabled(bool)
end

function RankList:setTableViewBounceable(bounceable, ...)
	assert(type(bounceable) == "boolean")
	assert(#{...} == 0)

	self.serverRankListTableView:setBounceable(bounceable)
	self.friendRankListTableView:setBounceable(bounceable)
end

function RankList:getVisibleRankListTableView(...)
	assert(#{...} == 0)

	local result = false

	if self.friendRankListTableView:isVisible() then
		result = self.friendRankListTableView
	elseif self.serverRankListTableView:isVisible() then
		result = self.serverRankListTableView
	else
		assert(false)
	end

	return result
end

function RankList:getScale9Bg(...)
	assert(#{...} == 0)

	return self.scale9Bg
end

function RankList:getRankListItemBg(...)
	assert(#{...} == 0)

	return self.rankListItemBg
end

function RankList:create(levelId, panelWithRank, useSpecialActivityUI, ...)
	assert(levelId)
	assert(panelWithRank)
	assert(#{...} == 0)

	local newRankList = RankList.new()
	newRankList:init(levelId, panelWithRank, useSpecialActivityUI)
	return newRankList
end


function RankList:dispose()
	self.serverRankListTableViewRender:dispose()
	self.friendRankListTableViewRender:dispose()
	BasePanel.dispose(self)
	if self.builder then
		self.builder:unloadAsset(PanelConfigFiles.panel_game_start_activity)
	end
end
