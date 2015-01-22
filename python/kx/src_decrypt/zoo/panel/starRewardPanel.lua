
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ23ÈÕ 11:27:34
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

--require "zoo.panelBusLogic.GetStarRewardsLogic"
require "zoo.panel.basePanel.panelAnim.IconPanelShowHideAnim"
require "zoo.panelBusLogic.GetStarRewardsLogic"
require 'zoo.panel.MoreStarPanel'

---------------------------------------------------
-------------- StarRewardItem
---------------------------------------------------

assert(not StarRewardItem)
assert(BaseUI)
StarRewardItem = class(BaseUI)

function StarRewardItem:init(ui, itemId, itemNumber, ...)
	assert(ui)
	assert(type(itemId) == "number")
	assert(type(itemNumber) == "number")
	assert(#{...} == 0)

	------------------
	-- Init Base Class
	-- ---------------
	BaseUI.init(self, ui)

	-----------------
	-- Get UI Resource
	-- ---------------
	self.numberLabel	= self.ui:getChildByName("numberLabel")
	self.numberLabelFontSize = self.ui:getChildByName("numberLabel_fontSize")
	self.numberLabel = TextField:createWithUIAdjustment(self.numberLabelFontSize, self.numberLabel)
	self.itemNameLabel	= self.ui:getChildByName("itemNameLabel")
	self.itemPh		= self.ui:getChildByName("itemPh")

	assert(self.numberLabel)
	assert(self.itemNameLabel)
	assert(self.itemPh)

	---------
	-- Data
	-- -------
	self.itemId	= itemId
	self.itemNumber	= itemNumber
	

	-----------------
	-- Get Data About itemPh
	-- -------------------
	self.itemPhPos	= self.itemPh:getPosition()
	self.itemPhSize	= self.itemPh:getGroupBounds().size
	self.itemPh:setVisible(false)

	-------------
	-- Create Item Icon
	-- -----------------
	
	if self.itemId > 0 then
		local itemRes	= ResourceManager:sharedInstance():buildItemGroup(self.itemId)
		self.itemRes	= itemRes
		self.ui:addChild(itemRes)

		--------------------------------
		-- Resize And Position Item Res
		-- ---------------------------
		-- Resize
		local itemResSize	= itemRes:getGroupBounds().size
		local neededScaleX	= self.itemPhSize.width / itemResSize.width
		local neededScaleY	= self.itemPhSize.height / itemResSize.height

		local smallestScale = neededScaleX
		if neededScaleX > neededScaleY then
			smallestScale = neededScaleY
		end

		itemRes:setScaleX(smallestScale)
		itemRes:setScaleY(smallestScale)

		-- Reposition
		local itemResSize	= itemRes:getGroupBounds().size
		local deltaWidth	= self.itemPhSize.width - itemResSize.width
		local deltaHeight	= self.itemPhSize.height - itemResSize.height
		
		itemRes:setPosition(ccp( self.itemPhPos.x + deltaWidth/2, 
					self.itemPhPos.y - deltaHeight/2))

		----------------
		-- Update View
		-- --------------
		local itemNameKey	= "prop.name." .. self.itemId
		local itemNameValue	= Localization:getInstance():getText(itemNameKey, {})
		self.itemNameLabel:setString(itemNameValue)

		self.numberLabel:removeFromParentAndCleanup(false)
		self.ui:addChild(self.numberLabel)

		self.numberLabel:setString("x" .. self.itemNumber)
	end
end

function StarRewardItem:create(ui, itemId, itemNumber, ...)
	assert(ui)
	assert(type(itemId) == "number")
	assert(type(itemNumber) == "number")
	assert(#{...} == 0)

	local newStarRewardItem = StarRewardItem.new()
	newStarRewardItem:init(ui, itemId, itemNumber)
	return newStarRewardItem
end

---------------------------------------------------
-------------- StarRewardPanel
---------------------------------------------------

assert(not StarRewardPanel)
assert(BasePanel)
StarRewardPanel = class(BasePanel)

function StarRewardPanel:init(starRewardBtnPosInWorldSpace, ...)
	assert(starRewardBtnPosInWorldSpace)
	assert(#{...} == 0)

	self.ui		= self:buildInterfaceGroup("starRewardPanel")

	-----------
	-- init Base Class
	-- ---------------
	BasePanel.init(self, self.ui)

	-------------------
	-- Get UI Resource
	-- ----------------
	self.rewardDesLabel	= self.ui:getChildByName("rewardDesLabel")
	self.closeBtn		= self.ui:getChildByName("closeBtn")
	self.getBtnRes		= self.ui:getChildByName("getBtn")
	self.rewardItemRes	= self.ui:getChildByName("rewardItem")
	self.moreStarDesc = self.ui:getChildByName('moreStarDesc')
	self.title = self.ui:getChildByName("title")
	self.moreStarDesc:setVisible(false)
	self.star = self.ui:getChildByName('_star')
	self.bg = self.ui:getChildByName("_scaleBoard")
	self.star:setVisible(false)

	assert(self.rewardDesLabel)
	assert(self.closeBtn)
	assert(self.getBtnRes)
	assert(self.rewardItemRes)

	---------
	-- Data
	-- --------
	-- Get Current Star
	local curTotalStar 	= UserManager:getInstance().user:getTotalStar()
	self.curTotalStar	= curTotalStar
	local userExtend 	= UserManager:getInstance().userExtend

	self.starRewardBtnPosInWorldSpace	= starRewardBtnPosInWorldSpace

	-- Get RewardLevelMeta 
	he_log_warning("reform !")
	local nearestStarRewardLevelMeta	= MetaManager.getInstance():starReward_getRewardLevel(curTotalStar)
	local nextRewardLevelMeta		= MetaManager.getInstance():starReward_getNextRewardLevel(curTotalStar)
	local rewardLevelToPushMeta 		= false

	if nearestStarRewardLevelMeta then

		rewardLevelToPush = userExtend:getFirstNotReceivedRewardLevel(nearestStarRewardLevelMeta.id)

		if rewardLevelToPush then
			-- Has Reward Level
			rewardLevelToPushMeta = MetaManager.getInstance():starReward_getStarRewardMetaById(rewardLevelToPush)
		else
			-- All Reward Level Has Received
		end
	end

	if not rewardLevelToPushMeta then
		-- If Has Next Reward Level, Show It
		if nextRewardLevelMeta then
			rewardLevelToPushMeta = nextRewardLevelMeta
		end
	end

	self.rewardLevelToPushMeta =  rewardLevelToPushMeta

	local itemId		= 0
	local itemNumber	= 0

	if rewardLevelToPushMeta then
		assert(rewardLevelToPushMeta)
		print(rewardLevelToPushMeta.reward[1].num)
		print(rewardLevelToPushMeta.reward[1].itemId)

		itemId		= rewardLevelToPushMeta.reward[1].itemId
		itemNumber	= rewardLevelToPushMeta.reward[1].num
	end

	self.closeCallback	= false

	-----------
	-- FLag 
	-- ------
	self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED	= 1
	self.BTN_TAPPED_STATE_GET_BTN_TAPPED	= 2
	self.BTN_TAPPED_STATE_NONE		= 3
	self.btnTappedState			= self.BTN_TAPPED_STATE_NONE
	
	-----------------------
	-- Create UI Component
	-- -------------------
	self.rewardItem	= StarRewardItem:create(self.rewardItemRes, itemId, itemNumber)
	self.getBtn	= GroupButtonBase:create(self.getBtnRes)

	---------------------
	-- Create Show/Hide Anim
	-- ------------------
	self.showHideAnim	= IconPanelShowHideAnim:create(self, self.starRewardBtnPosInWorldSpace)

	----------------
	-- Update View
	-- --------------

	self.title:setText(Localization:getInstance():getText("star.reward.panel.title"))
	local size = self.title:getContentSize()
	self.title:setPositionX((self.bg:getGroupBounds().size.width - size.width) / 2)
	
	if rewardLevelToPushMeta then
		local rewardDesLabelKey		= "star.reward.panel.reward.des"
		local rewardDesLabelValue	= Localization:getInstance():getText(rewardDesLabelKey, {star_number = rewardLevelToPushMeta.starNum})
		self.rewardDesLabel:setString(rewardDesLabelValue)
	end
	
	local getBtnLabelKey	= "star.reward.panel.get.btn.label"
	local getBtnLabelValue	= Localization:getInstance():getText(getBtnLabelKey, {})
	self.getBtn:setString(getBtnLabelValue)

	self.getBtn:setColorMode(kGroupButtonColorMode.green)
	self.getBtn:useBubbleAnimation()
	self.getBtn:setPositionY(self.getBtn:getPositionY() - 25)

	if rewardLevelToPushMeta then
		if curTotalStar < rewardLevelToPushMeta.starNum then
			local scores = UserManager:getInstance():getScoreRef()
			local counter = 0
			for k, v in pairs(scores) do 
				if LevelType:isMainLevel(v.levelId) and v.star < 3 and v.star > 0 then
					counter = counter + 1
				end
			end
			if counter > 0 then
				self.getBtn:setString(Localization:getInstance():getText('more.star.btn.txt'))
				self.getBtn:setColorMode(kGroupButtonColorMode.blue)
				--self.getBtn.background:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0.5))
				--self.getBtn.background:setScaleX(1.3)
				self.moreStarDesc:setString(Localization:getInstance():getText('more.star.star.reward.desc', {num = rewardLevelToPushMeta.starNum - curTotalStar}))
				self.moreStarDesc:setVisible(true)
				self.star:setVisible(true)
				self.getBtn:setPositionY(self.getBtn:getPositionY() + 25)
			else
				self.getBtn:setEnabled(false)
			end
		end
	else
		self.getBtn:setEnabled(false)
	end
	
	-------------------------
	-- Add Event Listener
	-- -------------------
	local function onCloseBtnTapped(event)
		self:onCloseBtnTapped(event)
	end
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)

	local function onGetBtnTapped()
		print("EventListener onGetBtnTapped")
		self:onGetBtnTapped()
	end
	self.getBtn:addEventListener(DisplayEvents.kTouchTap, onGetBtnTapped)
end

function StarRewardPanel:registerCloseCallback(closeCallback, ...)
	assert(type(closeCallback) == "function")
	assert(#{...} == 0)

	self.closeCallback = closeCallback
end

function StarRewardPanel:onGetBtnTapped(event, ...)
	assert(#{...} == 0)

	print("StarRewardPanel:onGetBtnTapped", self.getBtn.isEnabled)
	if false == self.getBtn.isEnabled then
		return
	end


	local function getReward()
		self:getReward()
	end

	if self.rewardLevelToPushMeta and self.curTotalStar < self.rewardLevelToPushMeta.starNum then

		self:popoutMoreStarPanel()
	else
		if RequireNetworkAlert:popout() then
			print("RequireNetworkAlert:popout()")
			self:getReward()
		end
	end

end

function StarRewardPanel:popoutMoreStarPanel()
	PopoutManager:sharedInstance():remove(self, true)
	local panel = MoreStarPanel:create()
	panel:popout()
end

function StarRewardPanel:getReward(...)
	assert(#{...} == 0)
	print("StarRewardPanel:getReward")

	local function onSendGetRewardMsgSuccess(event)

		print("StarRewardPanel:onGetBtnTapped Called ! onSendGetRewardMsgSuccess ")
		if self.isDisposed then
			return
		end

		-- Play The Flying Reward Anim
		print("StarRewardPanel:onGetBtnTapped onSendGetRewardMsgSuccess Called !")

		local rewardIds = {}
		local rewardAmounts = {}

		if type(event.data) == "table" and type(event.data.rewardItems) == "table" then
			for k1,v1 in pairs(event.data.rewardItems) do
				local itemId 		= v1.itemId
				local itemNumber	= v1.num
				table.insert(rewardIds, itemId)
				table.insert(rewardAmounts, itemNumber)
			end
		end

		local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds, rewardAmounts)
		print("number of anims : " .. #anims)

		-- Get Item Pos In World Space
		local itemResPosInWorld = self.rewardItem.itemRes:getPositionInWorldSpace()
		self.rewardItem.itemRes:setVisible(false)
		anims[1]:setPosition(ccp(itemResPosInWorld.x, itemResPosInWorld.y))

		-- Get Item Size
		local  itemResScale	= self.rewardItem.itemRes:getScale()
		anims[1]:setScale(itemResScale)

		local function onAnimFinished()

			if self.isDisposed then
				return
			end

			local delay = CCDelayTime:create(0.3)

			local function removeSelf()
				self:remove()
			end
			local callAction = CCCallFunc:create(removeSelf)

			local seq = CCSequence:createWithTwoActions(delay, callAction)
			self:runAction(seq)
		end

		--------------------------------------------------------
		-- number-decreasing animation
		--------------------------------------------------------
		local item = self.rewardItem
		local label = item.numberLabel
		local num = item.itemNumber
		local interval = 0.2 -- the same value from function HomeScene:createFlyToBagAnimation
		local function __decreaseNumber()
			if num >= 1 then
				num = num - 1
				-- trible reference checks
				if label and not label.isDisposed and label.refCocosObj then 
					label:setString('x'..num)
					setTimeOut(__decreaseNumber, interval)
				end
			end
		end
		setTimeOut(__decreaseNumber, interval)

		anims[1]:playFlyToAnim(onAnimFinished)
	end

	local function onSendGetRewardMsgFail(evt)
		print("onSendGetRewardMsgFail")

		if self.isDisposed then
			return
		end

		self.getBtn:setEnabled(true)
		
		local code
		if evt and evt.data then code = tonumber(evt.data) end
		-- CommonTip, change error tip
		if code then 
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..code), "negative")
		else
			local networkType = MetaInfo:getInstance():getNetworkInfo();
			local errorCode = "-2";
			if networkType and networkType==-1 then 
				errorCode = "-6";
			end
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..errorCode), "negative")
		end
	end

	local function onSendGetRewardMsgCancel()
		print("onSendGetRewardMsgCancel")
		if self.isDisposed then
			return
		end

		self.getBtn:setEnabled(true)
	end

	print("send SyncGetStarRewardLogic")
	self.getBtn:setEnabled(false)
	local rewardLevel = self.rewardLevelToPushMeta.id
	local logic	= GetStarRewardsLogic:create(rewardLevel)
	logic:setSuccessCallback(onSendGetRewardMsgSuccess)
	logic:setFailCallback(onSendGetRewardMsgFail)
	logic:setCancelCallback(onSendGetRewardMsgCancel)
	logic:start()	-- Default Show The Communicating Tip, And Block The Touch
end

function StarRewardPanel:onEnterHandler(event, ...)
	assert(#{...} == 0)

	if event == "enter" then

		local function onShowAnimFinished()
			self.allowBackKeyTap = true
		end

		self.showHideAnim:playShowAnim(onShowAnimFinished)
	end
end


function StarRewardPanel:popout(...)
	assert(#{...} == 0)

	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
end

function StarRewardPanel:remove(...)
	assert(#{...} == 0)
	print("StarRewardPanel:remove Called !")

	if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then 
		self.btnTappedState = self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED
	else
		return
	end

	local function onHideAnimFinished()
		PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)

		if self.closeCallback then
			self.closeCallback()
		end
	end
	
	self.showHideAnim:playHideAnim(onHideAnimFinished)
end

function StarRewardPanel:onCloseBtnTapped(event, ...)

	if not self.isOnCloseBtnTappedCalled then
		self.isOnCloseBtnTappedCalled = true

		self:remove()
	end
end


function StarRewardPanel:create(starRewardBtnPosInWorldSpace, ...)
	assert(starRewardBtnPosInWorldSpace)
	assert(#{...} == 0)

	local newStarRewardPanel = StarRewardPanel.new()
	newStarRewardPanel:loadRequiredResource(PanelConfigFiles.star_reward_panel)
	newStarRewardPanel:init(starRewardBtnPosInWorldSpace)
	return newStarRewardPanel
end
