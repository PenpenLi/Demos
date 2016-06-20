
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ25ÈÕ 15:00:38
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panel.component.ladyBugPanel.LadyBugRewardItem"
require "hecore.utils"
require "zoo.panelBusLogic.GetLadyBugRewardsLogic"
require "zoo.panelBusLogic.buyGoodsLogic.BuyReopenLadybugTaskGoods"
---------------------------------------------------
-------------- LadyBugTaskItem
---------------------------------------------------

assert(not LadyBugTaskItem)
LadyBugTaskItem = class(BaseUI)

function LadyBugTaskItem:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end

function LadyBugTaskItem:init(taskId, ...)
	assert(type(taskId) == "number")
	assert(#{...} == 0)

	self.ui	= self.builder:buildGroup("ladyBugRewardItem") --ResourceManager:sharedInstance():buildGroup("ladyBugRewardItem")

	---------------
	-- Init Base Class
	-- --------------
	BaseUI.init(self, self.ui)

	-----------------
	-- Get UI Resource
	-- -------------
	self.reOpenBtnRes		= self.ui:getChildByName("reOpenBtn")
	--self.dayLabel			= self.ui:getChildByName("dayLabel")
	self.checkIcon			= self.ui:getChildByName("checkIcon")
	self.blackMask			= self.ui:getChildByName("blackMask")
	self.countDownLabel		= self.ui:getChildByName("countDownLabel")
	self.notOpenLabel		= self.ui:getChildByName("notOpenLabel")
	self.missionDesLabel		= self.ui:getChildByName("missionDesLabel")
	self.timeWaitOpenLabel		= self.ui:getChildByName("timeWaitOpenLabel")
	self.timeWaitReceiveLabel	= self.ui:getChildByName("timeWaitReceiveLabel")

	self.reward1PhRes		= self.ui:getChildByName("reward1Ph")
	self.reward2PhRes		= self.ui:getChildByName("reward2Ph")

	assert(self.reOpenBtnRes)
	--assert(self.dayLabel)
	assert(self.checkIcon)
	assert(self.blackMask)
	assert(self.countDownLabel)
	assert(self.notOpenLabel)
	assert(self.missionDesLabel)
	assert(self.timeWaitOpenLabel)
	assert(self.timeWaitReceiveLabel)

	assert(self.reward1PhRes)
	assert(self.reward2PhRes)

	------------------------
	-- Create UI Component
	-- --------------------
	self.reward1	= LadyBugRewardItem:create(self.reward1PhRes)
	self.reward2	= LadyBugRewardItem:create(self.reward2PhRes)
	self.rewardItems = {self.reward1, self.reward2}

	-- Create Button
	--self.reOpenBtn	= BuyAndContinueButton:create(self.reOpenBtnRes)
	self.reOpenBtn		= ButtonIconNumberBase:create(self.reOpenBtnRes)
	self.reOpenBtn:setColorMode(kGroupButtonColorMode.blue)
	self.reOpenBtn:useStaticLabel(28)
	self.reOpenBtn:useStaticNumberLabel(28)
	self.reOpenBtn:setIconByFrameName('ui_images/ui_image_coin_icon_small0000')
	-- self.reOpenBtn:setTouchEnabled(true)

	-- Create Day Label Pictuer
	local dayLabelPic	= self.builder:buildGroup("day" .. taskId)--ResourceManager:sharedInstance():buildGroup("day" .. taskId)
	assert(dayLabelPic)
	self.ui:addChild(dayLabelPic)

	----------------
	-- Init UI Resource
	-- -----------------
	self.reOpenBtn:setVisible(false)
	self.checkIcon:setVisible(false)
	self.blackMask:setVisible(false)
	self.countDownLabel:setVisible(false)
	self.notOpenLabel:setVisible(false)
	self.timeWaitOpenLabel:setVisible(false)
	self.timeWaitReceiveLabel:setVisible(false)
	self.missionDesLabel:setVisible(false)

	self.reward1:setVisible(false)
	self.reward2:setVisible(false)

	----------------------
	-- Get Data About UI
	-- ------------------
	local originColor		= self.missionDesLabel:getColor()
	self.missionDesLabelOriginColor	= ccc3(originColor.r, originColor.g, originColor.b)

	---------
	-- Data
	-- ------
	self.taskId	= taskId

	-- Data About Task
	-- Task State
	self.oldTaskState	= LadyBugMissionState.NONE

	local taskMeta	= MetaManager.getInstance():ladybugReward_getLadyBugRewardMeta(self.taskId)
	self.taskMeta	= taskMeta
	assert(taskMeta)

	-- Task Type
	local goalType	= taskMeta.goalType[1].itemId
	local goalValue	= taskMeta.goalType[1].num
	self.taskType	= goalType
	self.taskValue	= goalValue

	-- Reward
	local index = 1
	for k,v in pairs(self.taskMeta.missionReward) do
		self.rewardItems[index]:setReward(v.itemId, v.num)
		index = index + 1
	end

	--------------------
	-- Update View
	-- ----------------
	local dayLabelKey	= "lady.bug.panel.day"
	local dayLabelValue	= Localization:getInstance():getText(dayLabelKey, {day = self.taskId})
	--self.dayLabel:setString(dayLabelValue)

	self:updateMissionDesLabel()
	self:update()

	-- Set Reopen Btn Label
	local goodsMeta		= MetaManager.getInstance():getGoodMetaByItemID(ItemType.REOPEN_LADYBUG_TASK)
	local qCashNeededToBuy	= goodsMeta.qCash

	-- local goldNumLabel	= self.reOpenBtn:getChildByName("goldNumLabel")
	-- goldNumLabel:setString(qCashNeededToBuy)
	self.reOpenBtn:setNumber(qCashNeededToBuy)
	
	local reOpenBtnKey	= "lady.bug.panel.restart.task.btn"
	local reOpenBtnValue	= Localization:getInstance():getText(reOpenBtnKey, {})
	-- local label		= self.reOpenBtn:getChildByName("label")
	-- label:setString(reOpenBtnValue)
	self.reOpenBtn:setString(reOpenBtnValue)

	----------------------
	-- Add Event Listener
	-- ------------------
	local function onItemTapped()
		self:onItemTapped()
	end

	self.reward1.ui:setTouchEnabled(true)
	-- self.reward1.ui:setTouchEnabledWithMoveInOut(true, 0, false) -- God Wan
	self.reward1.ui:addEventListener(DisplayEvents.kTouchTap, onItemTapped)
	-- self.reward1.ui:addEventListener(DisplayEvents.kTouchMoveIn, onItemTapped) -- God Wan

	self.reward2.ui:setTouchEnabled(true)
	-- self.reward2.ui:setTouchEnabledWithMoveInOut(true, 0, false) -- God Wan
	self.reward2.ui:addEventListener(DisplayEvents.kTouchTap, onItemTapped)
	-- self.reward2.ui:addEventListener(DisplayEvents.kTouchMoveIn, onItemTapped) -- God Wan

	-- Re Open Btn
	local function onReOpenBtnTapped()
		self:onReOpenBtnTapped()
	end
	--self.reOpenBtn.ui:addEventListener(DisplayEvents.kTouchTap, onReOpenBtnTapped)
	self.reOpenBtn:addEventListener(DisplayEvents.kTouchTap, onReOpenBtnTapped)
end

function LadyBugTaskItem:onItemTapped(...)
	assert(#{...} == 0)

	if self.oldTaskState == LadyBugMissionState.FINISHED_WAIT_RECEIVE_REWARD then
		-- print("LadyBugTaskItem:onItemTapped Called !")

		local function getReward()

			-- Block Multi Tap
			if not self.onItemTappedCalled then
				self.onItemTappedCalled = true

				local function onSuccessCallback()
					-- Play Flying Anim
					-- Hide The Item					

					local homeScene = HomeScene:sharedInstance()
					homeScene:checkDataChange()

					if self.isDisposed then return end

					for k,v in pairs(self.rewardItems) do
						v:setVisible(false)
					end
					--homeScene.coinButton:updateView()

					--self:changeToStateFinishedAndReceivedReward()
					self.reward1.ui:setTouchEnabled(false)
					self.reward2.ui:setTouchEnabled(false)
					self:playFlyingRewardAnim()

					self:changeToStateFinishedAndReceivedReward()
					LadyBugMissionManager:sharedInstance():cancelNotificationToday(self.taskId)
					LadyBugMissionManager:sharedInstance():activateMissionRewardCallback(self.taskId)
				end

				local function onFailedCallback(evt)
					--self.getLadyBugRewardSended = false
					self.onItemTappedCalled = false

					local getRewardFailedKey 	= "error.tip."..evt.data
					local getRewardFailedValue	= Localization:getInstance():getText(getRewardFailedKey, {})
					CommonTip:showTip(getRewardFailedValue)
				end

				-- local logic = GetLadyBugRewardsLogic:create(self.taskId)
				-- logic:start(true, onSuccessCallback, onFailedCallback)

				local logic = GetLadyBugRewardsLogic:create(self.taskId)
				logic:start(true, onSuccessCallback, onFailedCallback)
			else

			end
		end

		RequireNetworkAlert:callFuncWithLogged(getReward)
	end
end

function LadyBugTaskItem:onReOpenBtnTapped(...)
	assert(#{...} == 0)
	-- print("LadyBugTaskItem:onReOpenBtnTapped Called !")

	local function startBuyOpenLogic()

		-- Check If Has Enough Gold
		local curCash	= UserManager:getInstance().user.cash
		local goodsMeta	= MetaManager.getInstance():getGoodMetaByItemID(ItemType.REOPEN_LADYBUG_TASK)
		local goodsCash	= goodsMeta.qCash

		-- self.reOpenBtn:setTouchEnabled(false)
		self.reOpenBtn:setEnabled(false)

		local function enableTouch()
			self.reOpenBtn:setEnabled(true)
		end

		if curCash < goodsCash then
			-- Not Has Enough Gold
			-- Pop Out The Buy Gold Panel

			local function createGoldPanel()
				local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
				if index ~= 0 then
					local panel = createMarketPanel(index)
					panel:addEventListener(kPanelEvents.kClose, enableTouch)
					panel:popout()
				else enableTouch() end
			end
			GoldlNotEnoughPanel:create(createGoldPanel, enableTouch):popout()
		else

			local function onSuccess()
				-- print("LadyBugTaskItem:onReOpenBtnTapped onSuccess !")
				local bounds = self.reOpenBtnRes:getGroupBounds()
				self.reOpenBtn:playFloatAnimation(
					'-'..tostring(goodsCash),
					function()
						if self and self.isDisposed==false then
							self.reOpenBtn:setVisible(false)
						end
					end
				)
				HomeScene:sharedInstance().goldButton:updateView()
				-- self.reOpenBtn:setVisible(false)
			end

			local function onFailed(errorCode)
				-- print("LadyBugTaskItem:onReOpenBtnTapped onFailed !!")
				CommonTip:showTip(Localization:getInstance():getText("error.tip."..errorCode), "negative")
				enableTouch()
			end

			local buyReopenLogic = BuyReopenLadybugTaskGoods:create(self.taskId)
			buyReopenLogic:start(true, onSuccess, onFailed)
		end
	end

	RequireNetworkAlert:callFuncWithLogged(startBuyOpenLogic)
end

function LadyBugTaskItem:playFlyingRewardAnim(...)
	
	for index,v in ipairs(self.taskMeta.missionReward) do
		local anim = FlyItemsAnimation:create({v})
		local bounds = self.rewardItems[index].item:getGroupBounds()
		anim:setWorldPosition(ccp(bounds:getMidX(),bounds:getMidY()))
		anim:play()
	end
end

function LadyBugTaskItem:changeToStateNotOpenedYet(...)
	-- print('changeToStateNotOpenedYet')
	assert(#{...} == 0)

	--self.blackMask:setVisible(true)
	self.notOpenLabel:setVisible(true)

	local notOpenLabelKey	= "lady.bug.panel.not.opened.yet"
	local notOpenLabelValue	= Localization:getInstance():getText(notOpenLabelKey, {})
	self.notOpenLabel:setString(notOpenLabelValue)
end

function LadyBugTaskItem:changeToStateWaitTimeToOpen(...)
	-- print('changeToStateWaitTimeToOpen')
	assert(#{...} == 0)

	self.blackMask:setVisible(true)
	self.timeWaitOpenLabel:setVisible(true)

	local taskTime	= LadyBugMissionManager:sharedInstance():getTaskTime(self.taskId)
	local hmsFormat	= convertSecondToHHMMSSFormat(taskTime)
	local timeWaitOpenLabelKey	= "lady.bug.panel.time.to.open"
	local timeWaitOpenLabelValue	= Localization:getInstance():getText(timeWaitOpenLabelKey, {time = hmsFormat})
	self.timeWaitOpenLabel:setString(timeWaitOpenLabelValue)

	self.reward1:setVisible(true)
	self.reward2:setVisible(true)

	self.missionDesLabel:setVisible(true)
end

function LadyBugTaskItem:changeToStateOpened(...)
	-- print('changeToStateOpened')
	assert(#{...} == 0)

	-- ------------
	-- Task Reward
	-- ------------
	self.reward1:setVisible(true)
	self.reward2:setVisible(true)

	self.countDownLabel:setVisible(true)

	-- Update Time
	local taskTime = LadyBugMissionManager:sharedInstance():getTaskTime(self.taskId)
	local hmsFormat = convertSecondToHHMMSSFormat(taskTime)
	
	local countDownLabelKey		= "lady.bug.panel.time.to.end"
	local countDownLabelValue	= Localization:getInstance():getText(countDownLabelKey, {time = hmsFormat})
	self.countDownLabel:setString(countDownLabelValue)

	---------------
	-- Mission Des
	-- ------------
	self.missionDesLabel:setVisible(true)
end

function LadyBugTaskItem:changeToStateNotOpenButFinished(...)
	-- print('changeToStateNotOpenButFinished')
	assert(#{...} == 0)

	self.blackMask:setVisible(true)
	self.timeWaitReceiveLabel:setVisible(true)

	local taskTime	= LadyBugMissionManager:sharedInstance():getTaskTime(self.taskId)
	local hmsFormat	= convertSecondToHHMMSSFormat(taskTime)

	local timeWaitReceiveLabelKey	= "lady.bug.panel.time.to.receive.reward"
	local timeWaitReceiveLabelValue	= Localization:getInstance():getText(timeWaitReceiveLabelKey, {time = hmsFormat})
	self.timeWaitReceiveLabel:setString(timeWaitReceiveLabelValue)

	self.reward1:setVisible(true)
	self.reward2:setVisible(true)
	self.missionDesLabel:setVisible(true)
end

function LadyBugTaskItem:changeToStateFinishedWaitReceiveReward(...)
	-- print('changeToStateFinishedWaitReceiveReward')
	assert(#{...} == 0)

	-- ------------
	-- Task Reward
	-- ------------
	self.reward1:setVisible(true)
	self.reward2:setVisible(true)

	--self.reward1:playBubbleNormalAnim()
	--self.reward2:playBubbleNormalAnim()
	self.reward1:playBubbleTouchedAnimForever()
	self.reward2:playBubbleTouchedAnimForever()

	---------------
	-- Mission Des
	-- ------------
	self.missionDesLabel:setVisible(true)

	--679F2D
	--103 159 45
	self.missionDesLabel:setColor(ccc3(103, 159, 45))
end

function LadyBugTaskItem:changeToStateFinishedAndReceivedReward(...)
	-- print('changeToStateFinishedAndReceivedReward')
	assert(#{...} == 0)

	self.missionDesLabel:setVisible(true)
	self.checkIcon:setVisible(true)

	--679F2D
	--103 159 45
	self.missionDesLabel:setColor(ccc3(103, 159, 45))
end

function LadyBugTaskItem:changeToStateNotFinishedInTimeClose(...)
	-- print('changeToStateNotFinishedInTimeClose')
	assert(#{...} == 0)

	-- ------------
	-- Task Reward
	-- ------------
	self.reward1:setVisible(true)
	self.reward2:setVisible(true)

	self.missionDesLabel:setVisible(true)
	self.blackMask:setVisible(true)
	self.reOpenBtn:setEnabled(true)
	self.reOpenBtn:setVisible(true)
end

function LadyBugTaskItem:changeToStateNotFinishedInTimeCloseForce()
	self.reward1:setVisible(true)
	self.reward2:setVisible(true)
	self.missionDesLabel:setVisible(true)
	self.blackMask:setVisible(true)
	self.reOpenBtn:setEnabled(false)
	self.reOpenBtn:setVisible(true)
end

function LadyBugTaskItem:updateStateOpened(...)
	-- print('updateStateOpened')
	assert(#{...} == 0)

	-- Update Time
	local taskTime = LadyBugMissionManager:sharedInstance():getTaskTime(self.taskId)
	local hmsFormat = convertSecondToHHMMSSFormat(taskTime)

	local countDownLabelKey		= "lady.bug.panel.time.to.end"
	local countDownLabelValue	= Localization:getInstance():getText(countDownLabelKey, {time = hmsFormat})
	self.countDownLabel:setString(countDownLabelValue)
end

function LadyBugTaskItem:updateStateNotOpenButFinished(...)
	-- print('updateStateNotOpenButFinished')
	assert(#{...} == 0)

	-- Update Time Wait Open Label
	local taskTime	= LadyBugMissionManager:sharedInstance():getTaskTime(self.taskId)
	local hmsFormat	= convertSecondToHHMMSSFormat(taskTime)

	local timeWaitReceiveLabelKey	= "lady.bug.panel.time.to.receive.reward"
	local timeWaitReceiveLabelValue	= Localization:getInstance():getText(timeWaitReceiveLabelKey, {time = hmsFormat})
	self.timeWaitReceiveLabel:setString(timeWaitReceiveLabelValue)
end

function LadyBugTaskItem:updateStateWaitTimeToOpen(...)
	-- print('updateStateWaitTimeToOpen')
	assert(#{...} == 0)
	
	-- Update Time Wait Open Label
	local taskTime	= LadyBugMissionManager:sharedInstance():getTaskTime(self.taskId)
	local hmsFormat	= convertSecondToHHMMSSFormat(taskTime)

	local timeWaitOpenLabelKey	= "lady.bug.panel.time.to.open"
	local timeWaitOpenLabelValue	= Localization:getInstance():getText(timeWaitOpenLabelKey, {time = hmsFormat})
	self.timeWaitOpenLabel:setString(timeWaitOpenLabelValue)
end

function LadyBugTaskItem:update(...)
	assert(#{...} == 0)

	-- Task State
	local taskState = LadyBugMissionManager:sharedInstance():getTaskState(self.taskId)
	-- print('task id', self.taskId)

	if self.oldTaskState ~= taskState then

		if self.oldTaskState == LadyBugMissionState.NOT_OPENED_YET then
			self:cleanupStateNotOpenedYet()

		elseif self.oldTaskState == LadyBugMissionState.WAIT_TIME_TO_OPEN then
			self:cleanupStateWaitTimeToOpen()

		elseif self.oldTaskState == LadyBugMissionState.OPENED then
			self:cleanupStateOpened()

		elseif self.oldTaskState == LadyBugMissionState.FINISHED_WAIT_RECEIVE_REWARD then
			self:cleanupStateFinishedWaitReceiveReward()

		elseif self.oldTaskState == LadyBugMissionState.FINISHED_AND_RECEIVED_REWARD then
			self:cleanupStateFinishedAndReceiveReward()

		elseif self.oldTaskState == LadyBugMissionState.NOT_FINISHED_IN_TIME_CLOSE then
			self:cleanupStateNotFinishInTimeClose()

		elseif self.oldTaskState == LadyBugMissionState.NOT_OPEN_BUT_FINISHED then
			self:cleanupStateNotOpenButFinished()

		elseif self.oldTaskState == LadyBugMissionState.NONE then
			-- Do Nothing
		else
			---- print("self.oldTaskState" .. tostring(self.oldTaskState))
			--debug.debug()
			--assert(false, tostring(self.oldTaskState))
		end

		self.oldTaskState = taskState

		if taskState == LadyBugMissionState.NOT_OPENED_YET then
			self:changeToStateNotOpenedYet()
		elseif taskState == LadyBugMissionState.WAIT_TIME_TO_OPEN then
			self:changeToStateWaitTimeToOpen()
		elseif taskState == LadyBugMissionState.OPENED then
			self:changeToStateOpened()
		elseif taskState == LadyBugMissionState.FINISHED_WAIT_RECEIVE_REWARD then
			self:changeToStateFinishedWaitReceiveReward()
		elseif taskState == LadyBugMissionState.FINISHED_AND_RECEIVED_REWARD then
			self:changeToStateFinishedAndReceivedReward()
		elseif taskState == LadyBugMissionState.NOT_FINISHED_IN_TIME_CLOSE then
			self:changeToStateNotFinishedInTimeClose()
		elseif taskState == LadyBugMissionState.NOT_FINISHED_IN_TIME_CLOSE_FORCE then
			self:changeToStateNotFinishedInTimeCloseForce()
		elseif taskState == LadyBugMissionState.NOT_OPEN_BUT_FINISHED then
			self:changeToStateNotOpenButFinished()
		else
			---- print("taskState: " .. tostring(taskState))
			--debug.debug()
			--assert(false, tostring(taskState))
		end

	else
		--if self.taskId == 2 then
		--	-- print("self.oldTaskState == taskState")
		--	LadyBugMissionManager:-- printLadyBugMissionState(self.oldTaskState)
		--end

		if taskState == LadyBugMissionState.NOT_OPENED_YET then
			-- Do Nothing
		elseif taskState == LadyBugMissionState.WAIT_TIME_TO_OPEN then
			self:updateStateWaitTimeToOpen()

		elseif taskState == LadyBugMissionState.OPENED then
			self:updateStateOpened()

		elseif taskState == LadyBugMissionState.FINISHED_WAIT_RECEIVE_REWARD then

		elseif taskState == LadyBugMissionState.FINISHED_AND_RECEIVED_REWARD then

		elseif taskState == LadyBugMissionState.NOT_FINISHED_IN_TIME_CLOSE then

		elseif taskState == LadyBugMissionState.NOT_FINISHED_IN_TIME_CLOSE_FORCE then

		elseif taskState == LadyBugMissionState.NOT_OPEN_BUT_FINISHED then
			self:updateStateNotOpenButFinished()

		else
			-- print("taskState: " .. tostring(taskState))
			-- debug.debug()
			assert(false, tostring(taskState))
		end
	end
end

function LadyBugTaskItem:cleanupStateNotOpenedYet(...)
	-- print('cleanupStateNotOpenedYet')
	assert(#{...} == 0)

	self.blackMask:setVisible(false)
	self.notOpenLabel:setVisible(false)
end

function LadyBugTaskItem:cleanupStateWaitTimeToOpen(...)
	-- print('cleanupStateWaitTimeToOpen')
	assert(#{...} == 0)

	self.blackMask:setVisible(false)
	self.timeWaitOpenLabel:setVisible(false)
	self.reward1:setVisible(false)
	self.reward2:setVisible(false)
	self.missionDesLabel:setVisible(false)
end

function LadyBugTaskItem:cleanupStateOpened(...)
	-- print('cleanupStateOpened')
	assert(#{...} == 0)

	self.reward1:setVisible(false)
	self.reward2:setVisible(false)
	self.countDownLabel:setVisible(false)

	self.missionDesLabel:setVisible(false)
end

function LadyBugTaskItem:cleanupStateNotOpenButFinished(...)
	-- print('cleanupStateNotOpenButFinished')
	assert(#{...} == 0)

	self.blackMask:setVisible(false)
	self.timeWaitReceiveLabel:setVisible(false)


	self.reward1:setVisible(false)
	self.reward2:setVisible(false)

	self.missionDesLabel:setColor(ccc3(self.missionDesLabelOriginColor.r,
						self.missionDesLabelOriginColor.g,
						self.missionDesLabelOriginColor.b))
	
end

function LadyBugTaskItem:cleanupStateFinishedWaitReceiveReward(...)
	-- print('cleanupStateFinishedWaitReceiveReward')
	assert(#{...} == 0)

	self.reward1:setVisible(false)
	self.reward2:setVisible(false)

	self.missionDesLabel:setColor(ccc3(self.missionDesLabelOriginColor.r,
						self.missionDesLabelOriginColor.g,
						self.missionDesLabelOriginColor.b))

	self.missionDesLabel:setVisible(false)
end

function LadyBugTaskItem:cleanupStateFinishedAndReceiveReward(...)
	-- print('cleanupStateFinishedAndReceiveReward')
	assert(#{...} == 0)

	self.missionDesLabel:setVisible(false)
	self.checkIcon:setVisible(false)

	self.missionDesLabel:setColor(ccc3(self.missionDesLabelOriginColor.r,
						self.missionDesLabelOriginColor.g,
						self.missionDesLabelOriginColor.b))
end

function LadyBugTaskItem:cleanupStateNotFinishInTimeClose(...)
	-- print('cleanupStateNotFinishInTimeClose')
	assert(#{...} == 0)

	self.reward1:setVisible(false)
	self.reward2:setVisible(false)

	self.missionDesLabel:setVisible(false)
	self.blackMask:setVisible(false)
	self.reOpenBtn:setVisible(false)
end

function LadyBugTaskItem:updateMissionDesLabel(...)
	assert(#{...} == 0)

	-- Get Data About Mission
	if self.taskType == 1 then
		-- Pass Which Level
		local missionDesLabelKey	= "lady.bug.panel.pass.level.mission"
		local missionDesLabelValue	= Localization:getInstance():getText(missionDesLabelKey, {level = self.taskValue})
		self.missionDesLabel:setString(missionDesLabelValue)

	elseif self.taskType == 2 then
		-- Three Star Pass Which Level

		local missionDesLabelKey	= "lady.bug.panel.three.star.pass.level.mission"
		local missionDesLabelValue	= Localization:getInstance():getText(missionDesLabelKey, {level = self.taskValue})
		self.missionDesLabel:setString(missionDesLabelValue)

	elseif self.taskType == 3 then
		-- Get The Fruit, 
		local missionDesLabelKey	= "lady.bug.panel.pass.level.get.fruit.mission"
		local missionDesLabelValue	= Localization:getInstance():getText(missionDesLabelKey, {level = self.taskValue})
		self.missionDesLabel:setString(missionDesLabelValue)
	end
end

function LadyBugTaskItem:create(taskId, ...)
	assert(type(taskId) == "number")
	assert(#{...} == 0)

	local newLadyBugTaskItem = LadyBugTaskItem.new()
	newLadyBugTaskItem:loadRequiredResource(PanelConfigFiles.lady_bug_panel)
	newLadyBugTaskItem:init(taskId)
	return newLadyBugTaskItem
end
