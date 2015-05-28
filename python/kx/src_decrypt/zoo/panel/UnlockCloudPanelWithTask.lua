require "zoo.panel.basePanel.panelAnim.PanelPopRemoveAnim"
require "zoo.panel.component.unlockCloudPanel.FriendItem"
require "zoo.baseUI.BuyAndContinueButton"
require 'zoo.panel.MoreStarPanel'

UnlockCloudPanelWithTask = class(BasePanel)
function UnlockCloudPanelWithTask:create(lockedCloudId, totalStar, neededStar, cloudCanOpenCallback, unlockAreaLevelId)
	local panel = UnlockCloudPanelWithTask.new()
	panel:loadRequiredResource(PanelConfigFiles.unlock_cloud_panel_new)
	panel.ui = panel:buildInterfaceGroup('unlock_task_panel')
	panel:init(lockedCloudId, totalStar, neededStar, cloudCanOpenCallback, unlockAreaLevelId)
	return panel
end

function UnlockCloudPanelWithTask:getAgreedFriendIds(...)
	assert(#{...} == 0)

	local function onHttpFinished()

		local unlockFriendInfos = UserManager:getInstance().unlockFriendInfos
		assert(unlockFriendInfos)

		-- Get Current Area 's Friend Ids
		for k,v in pairs(unlockFriendInfos) do
			if v.id == self.lockedCloudId then
				self.curAreaFriendIds = v.friendUids
				self:updateView()
				break
			else

			end
		end
	end

	local http = GetUnlockFriendHttp.new()
	http:addEventListener(Events.kComplete, onHttpFinished)
	http:load()
end

function UnlockCloudPanelWithTask:init( lockedCloudId, totalStar, neededStar, cloudCanOpenCallback, unlockAreaLevelId )
	-- body
	BasePanel.init(self, self.ui)
	--data
	self.curAreaFriendIds	= {}

	self.lockedCloudId = lockedCloudId
	self.totalStar = totalStar
	self.neededStar = neededStar
	self.cloudCanOpenCallback = cloudCanOpenCallback
	self.unlockAreaLevelId = unlockAreaLevelId

	self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED			= 1
	self.BTN_TAPPED_STATE_ASK_FRIEND_BTN_TAPPED	= 2
	self.BTN_TAPPED_STATE_NONE				= 3
	self.btnTappedState					= self.BTN_TAPPED_STATE_NONE

	self:initNormalPanel()
	self:initFriendArea()
	self:initTaskArea()
	self:initStarArea()
	self:initPayArea()
end

function UnlockCloudPanelWithTask:initNormalPanel( ... )
	-- body
	self.closeBtnRes		= self.ui:getChildByName("closeBtn")
	self.panelTitle = TextField:createWithUIAdjustment(self.ui:getChildByName("panelTitleSize"), self.ui:getChildByName("panelTitle"))
	self.ui:addChild(self.panelTitle)
	local titleKey			= "unlock.cloud.panel.title"
	local titleValue		= Localization:getInstance():getText(titleKey)
	self.panelTitle:setString(titleValue)
	local function onCloseBtnTapped()
		self:onCloseBtnTapped()
	end
	self.closeBtnRes:setTouchEnabled(true)
	self.closeBtnRes:setButtonMode(true)
	self.closeBtnRes:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)
end

function UnlockCloudPanelWithTask:updateView(...)
	assert(#{...} == 0)

	if self.isDisposed then return end
	for index,friendId in ipairs(self.curAreaFriendIds) do
		if self.friendItems[index] then
			self.friendItems[index]:setFriend(friendId)
		end
	end

	-- --------------------------------
	-- Update BuyAndContinueButton State
	-- -------------------------------
	if #self.curAreaFriendIds >= 3 then
		local askFriendBtnLabelKey	= "unlock.cloud.panel.use.friend.unlock"
		local askFriendBtnLabelValue	= Localization:getInstance():getText(askFriendBtnLabelKey, {})
		self.askFriendBtn:setString(askFriendBtnLabelValue)
		self.askFriendBtn:setColorMode(kGroupButtonColorMode.green)
	end
end

function UnlockCloudPanelWithTask:initFriendArea( ... )
	-- body
	self:getAgreedFriendIds()
	local friend_area = self.ui:getChildByName("friend_area")
	self.friendItem1	= FriendItem:create(friend_area:getChildByName("friendItem1"))
	self.friendItem2	= FriendItem:create(friend_area:getChildByName("friendItem2"))
	self.friendItem3	= FriendItem:create(friend_area:getChildByName("friendItem3"))

	self.friendItems = {self.friendItem1, self.friendItem2, self.friendItem3}

	self.askFriendBtn	= GroupButtonBase:create(friend_area:getChildByName("btn"))
	local askFriendBtnLabelKey	= "unlock.cloud.panel.button.request.friend"
	local askFriendBtnLabelValue	= Localization:getInstance():getText(askFriendBtnLabelKey, {})
	self.askFriendBtn:setString(askFriendBtnLabelValue)

	local function onAskFriendBtnTapped()
		if PrepackageUtil:isPreNoNetWork() then
			PrepackageUtil:showInGameDialog()
		else
			self:onAskFriendBtnTapped()
		end
	end
	self.askFriendBtn:addEventListener(DisplayEvents.kTouchTap, onAskFriendBtnTapped)

end

function UnlockCloudPanelWithTask:initTaskArea( ... )
	-- body
	self.taskPart = self.ui:getChildByName("task_area")
	self.taskBtn = GroupButtonBase:create(self.taskPart:getChildByName("button"))
	self.taskBtn:setString(Localization:getInstance():getText("unlock.cloud.panel.play.button", {}))

	self.taskPart:getChildByName("text"):setString(Localization:getInstance():getText("unlock.cloud.panel.play.desc", {}))
	self.taskBtn:ad(DisplayEvents.kTouchTap, function( ... )
		-- body
		self:onTaskBtnTap()
	end)
end

function UnlockCloudPanelWithTask:initStarArea( ... )
	-- body
	self.starPart = self.ui:getChildByName("star_area")
	self.starNumLabel = TextField:createWithUIAdjustment(self.starPart:getChildByName("starSize"), self.starPart:getChildByName("starNum"))
	self.starPart:addChild(self.starNumLabel)
	self.starNumLabel:setString(self.totalStar .. "/" .. self.neededStar)

	self.moreStarBtn = GroupButtonBase:create(self.starPart:getChildByName('button'))
	self.moreStarBtn:setString(Localization:getInstance():getText('recall_text_10'))
	self.moreStarBtn:ad(DisplayEvents.kTouchTap, function () self:onMoreStarBtnTapped() end)
end

function UnlockCloudPanelWithTask:initPayArea( ... )
	-- body
	self.moneyPart = self.ui:getChildByName("pay_area")
	-- self.moneyNumLabel = self.moneyPart:getChildByName("moneyNum")
	-- self.moneyNumLabel =  TextField:createWithUIAdjustment(self.moneyPart:getChildByName("moneySize"), self.moneyPart:getChildByName("moneyNum"))
	-- self.moneyPart:addChild(self.moneyNumLabel)
	local goodsMeta = MetaManager.getInstance():getGoodMetaByItemID(self.lockedCloudId)

	self.useWindmillBtn = ButtonIconNumberBase:create(self.moneyPart:getChildByName('button'))
	self.useWindmillBtn:setColorMode(kGroupButtonColorMode.blue)
	self.useWindmillBtn:setString(Localization:getInstance():getText('unlock.cloud.panel.button.unlock'))
	self.useWindmillBtn:ad(DisplayEvents.kTouchTap, function () self:onUseWindmillBtnTapped() end)

	if __ANDROID then -- ANDROID
		self.useWindmillBtn:setIcon(nil)
		local text = string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), goodsMeta.rmb / 100)
		self.useWindmillBtn:setNumber(text)
		-- self.moneyNumLabel:setString(text)
	else 
		self.useWindmillBtn:setIconByFrameName('ui_images/ui_image_coin_icon_small0000')
		self.useWindmillBtn:setNumber(goodsMeta.qCash)
		-- self.moneyNumLabel:setString(goodsMeta.qCash)
	end
end

function UnlockCloudPanelWithTask:popout(animFinishCallback, ...)
	self.allowBackKeyTap = true

	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
	self:setToScreenCenterVertical()
	self:setToScreenCenterHorizontal()
	self:tryShowGuide()
end

function UnlockCloudPanelWithTask:onEnterForeGround()
	if self.isDisposed then return end
	if self.onEnterForeGroundCallback and type(self.onEnterForeGroundCallback) == "function" then 
		self.onEnterForeGroundCallback()
	end
end

function UnlockCloudPanelWithTask:tryRemoveGuide()
	if self.armature and not self.armature.isDisposed then
		self.armature:removeFromParentAndCleanup(true)
		self.armature = nil
	end
end

function UnlockCloudPanelWithTask:tryShowGuide()
	local hasFirstPopout = CCUserDefault:sharedUserDefault():getBoolForKey('panel.unlockCloud.hasRunGuide')
	if hasFirstPopout then
		return
	end

	local armature = CommonSkeletonAnimation:createTutorialMoveIn2()
	local animation = armature:getAnimation()
	
	local function onAnimationEvent( eventType )
		if armature:hn(eventType) then armature:dp(Event.new(eventType, nil, ret)) end
	end 
	if animation then animation:registerScriptHandler(onAnimationEvent) end

	local function animationCallback()
		if self.isDisposed then return end
		self:tryRemoveGuide()
	end
	armature:removeAllEventListeners()
	armature:addEventListener(kAnimationEvents.kComplete, animationCallback)

	local askFriend = (FriendManager.getInstance():getFriendCount() >= 3)

	local taskBtnWorldPos = self.taskBtn:getParent():convertToWorldSpace(self.taskBtn:getPosition())
	local askFriendBtnWorldPos = self.askFriendBtn:getParent():convertToWorldSpace(self.askFriendBtn:getPosition())

	local scene = Director:sharedDirector():getRunningScene()
	if not scene then return end

	scene:addChild(armature)
	self.armature = armature
	if askFriend then
		local pos = ccp(askFriendBtnWorldPos.x + 140, askFriendBtnWorldPos.y + 110)
		armature:setPosition(pos)
	else
		local pos = ccp(taskBtnWorldPos.x + 140, taskBtnWorldPos.y + 110)
		armature:setPosition(pos)
	end

	CCUserDefault:sharedUserDefault():setBoolForKey('panel.unlockCloud.hasRunGuide', true)

end

function UnlockCloudPanelWithTask:onCloseBtnTapped()
	if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
		self.btnTappedState = self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED
	else
		return
	end
	self:remove(false)
end

function UnlockCloudPanelWithTask:onMoreStarBtnTapped()
	self:onCloseBtnTapped()
	PopoutManager:sharedInstance():remove(self, true)
	local panel = MoreStarPanel:create()
	panel:popout()
end

function UnlockCloudPanelWithTask:remove(animFinishCallback, ...)
	if not self.isDisposed then 
		PopoutManager:sharedInstance():removeWithBgFadeOut(self, animFinishCallback, true)
		self:tryRemoveGuide()
	end
end

function UnlockCloudPanelWithTask:onAskFriendBtnTapped(...)
	assert(#{...} == 0)
	if __IOS_FB and not SnsProxy:isShareAvailable() then 
		CommonTip:showTip(Localization:getInstance():getText("error.tip.facebook.login"), "negative",nil,2)
		return
	end

	self:tryRemoveGuide()
	if #self.curAreaFriendIds >= 3 then

		if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
			self.btnTappedState = self.BTN_TAPPED_STATE_ASK_FRIEND_BTN_TAPPED
		else
			return
		end

		self:sendUnlockMsg()
	else
		self:chooseUnlockFriend()
	end
end

function UnlockCloudPanelWithTask:sendUnlockMsg()
	local function onSendUnlockMsgSuccess(event)
		-- Remove Self 
		print("onSendUnlockMsgSuccess Called !")

		local function onRemoveSelfFinish()
			self.cloudCanOpenCallback()
			print("onRemoveSelfFinish Called !")
		end

		self:remove(onRemoveSelfFinish)
	end

	local function onSendUnlockMsgFailed(event)
		self.btnTappedState = self.BTN_TAPPED_STATE_NONE
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative")
	end

	local function onSendUnlockMsgCanceled(event)
		self.btnTappedState = self.BTN_TAPPED_STATE_NONE
	end

	local logic = UnlockLevelAreaLogic:create(self.lockedCloudId)
	logic:setOnSuccessCallback(onSendUnlockMsgSuccess)
	logic:setOnFailCallback(onSendUnlockMsgFailed)
	logic:setOnCancelCallback(onSendUnlockMsgCanceled)
	logic:start(UnlockLevelAreaLogicUnlockType.USE_FRIEND, {})
end

function UnlockCloudPanelWithTask:chooseUnlockFriend()
	-- On Friend Choosed
	local function onFriendChoose(friendIds)

		local function onSendFriendRequestSuccess(evt)
			print("onSendFriendRequestSuccess Called !")
			DcUtil:requestUnLockCloud(self.lockedCloudId ,#friendIds)
			local tipKey	= "unlock.cloud.panel.request.friend.success"
			local tipValue	= Localization:getInstance():getText(tipKey)
			CommonTip:showTip(tipValue, "positive")
		end

		local function onSendFriendRequestFail(evt)
			print("onSendFriendRequestFail Called !")

			local tipKey	= "error.tip."..tostring(evt.data)
			local tipValue	= Localization:getInstance():getText(tipKey)
			CommonTip:showTip(tipValue, "negative")
		end

		if not friendIds or #friendIds == 0 then
			CommonTip:showTip(Localization:getInstance():getText("unlock.cloud.panel.request.friend.noselect"), "negative")
			return
		end

		local logic = UnlockLevelAreaLogic:create(self.lockedCloudId)
		logic:setOnSuccessCallback(onSendFriendRequestSuccess)
		logic:setOnFailCallback(onSendFriendRequestFail)
		if __IOS_FB then
			if SnsProxy:isShareAvailable() then
				local callback = {
					onSuccess = function(result)
						logic:start(UnlockLevelAreaLogicUnlockType.REQUEST_FRIEND_TO_HELP, friendIds)
						DcUtil:logSendRequest("request",result.id,"request_uplock_area_help")
					end,
					onError = function(err)
						print("failed")
					end
				}

				local profile = UserManager.getInstance().profile
				local userName = ""
				if profile and profile:haveName() then
					userName = profile:getDisplayName()
				end
				
				local reqTitle = Localization:getInstance():getText("facebook.request.unlock.title", {user=userName})
				local reqMessage = Localization:getInstance():getText("facebook.request.unlock.message", {user=userName})
				
				local snsIds = FriendManager.getInstance():getFriendsSnsIdByUid(friendIds)
				SnsProxy:sendRequest(snsIds, reqTitle, reqMessage, false, FBRequestObject.ULOCK_AREA_HELP, callback)
			end
		else
			logic:start(UnlockLevelAreaLogicUnlockType.REQUEST_FRIEND_TO_HELP, friendIds)
		end	
	end

	-- Pop Out Choose Friend Panel
	self.curAreaFriendIds = self.curAreaFriendIds or {}
	local panel = ChooseFriendPanel:create(onFriendChoose, self.curAreaFriendIds)
	panel:popout()
end


function UnlockCloudPanelWithTask:onUseWindmillBtnTapped(...)
	assert(#{...} == 0)

	-- Send Message Unlock The Cloud
	local function onSendUnlockMsgSuccess()

		-- Remove Self 
		self.onEnterForeGroundCallback  = nil
		local function onRemoveSelfFinish()
			self.cloudCanOpenCallback()
		end

		self:remove(onRemoveSelfFinish)
	end

	local function onSendUnlockMsgFailed()
		--print("use gold unlock cloud failed !")
		self.onEnterForeGroundCallback  = nil
		local failTxtKey
		if __ANDROID then failTxtKey = "unlock.cloud.panel.use.rmb.unlock.failed" -- ANDROID
		else failTxtKey = "unlock.cloud.panel.use.gold.unlock.failed" end -- IOS and PC
		local failTxtValue	= Localization:getInstance():getText(failTxtKey, {})
		CommonTip:showTip(failTxtValue)
		-- self.useWindmillBtn.ui:setTouchEnabled(true)
		self.useWindmillBtn:setEnabled(true)
	end

	local function onSendUnlockMsgCanceled()
		-- self.useWindmillBtn.ui:setTouchEnabled(true)
		
		self.onEnterForeGroundCallback  = nil
		if not self or self.isDisposed then return end
		self.useWindmillBtn:setEnabled(true)
	end

	-- self.useWindmillBtn.ui:setTouchEnabled(false)
	self.useWindmillBtn:setEnabled(false)

 	if __ANDROID then -- ANDROID
 		local logic = UnlockLevelAreaLogic:create(self.lockedCloudId)
		logic:setOnSuccessCallback(onSendUnlockMsgSuccess)
		logic:setOnFailCallback(onSendUnlockMsgFailed)
		logic:setOnCancelCallback(onSendUnlockMsgCanceled)
		logic:start(UnlockLevelAreaLogicUnlockType.USE_WINDMILL_COIN, {})
		self.onEnterForeGroundCallback = onSendUnlockMsgCanceled
	else -- else, on IOS and PC we use gold!
		-- Get Current Cash
		-- Check If Has Enough QCash
		local curCash	= UserManager:getInstance().user.cash
		local goodMeta	= MetaManager.getInstance():getGoodMetaByItemID(self.lockedCloudId)

		--self.useWindmillBtn.ui:setTouchEnabled(false)

		if curCash < goodMeta.qCash then
			-- Not Has Enough Gold
			-- Pop Out The Buy Gold Panel

			local function createGoldPanel()
				local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
				if index ~= 0 then
					local panel = createMarketPanel(index)
					panel:addEventListener(kPanelEvents.kClose, onSendUnlockMsgCanceled)
					panel:popout()
				else onSendUnlockMsgCanceled() end
			end
			local text = {
				tip = Localization:getInstance():getText("buy.prop.panel.tips.no.enough.cash"),
				yes = Localization:getInstance():getText("buy.prop.panel.yes.buy.btn"),
				no = Localization:getInstance():getText("buy.prop.panel.not.buy.btn"),
			}
			CommonTipWithBtn:setShowFreeFCash(true)
			CommonTipWithBtn:showTip(text, "negative", createGoldPanel, onSendUnlockMsgCanceled)
		else
			local logic = UnlockLevelAreaLogic:create(self.lockedCloudId)
			logic:setOnSuccessCallback(onSendUnlockMsgSuccess)
			logic:setOnFailCallback(onSendUnlockMsgFailed)
			logic:setOnCancelCallback(onSendUnlockMsgCanceled)
			logic:start(UnlockLevelAreaLogicUnlockType.USE_WINDMILL_COIN, {})
		end
	end
end

function UnlockCloudPanelWithTask:onTaskBtnTap( ... )
	-- body
	self:onCloseBtnTapped()
	print(self.unlockAreaLevelId)
	local startGamePanel = StartGamePanel:create(self.unlockAreaLevelId, GameLevelType.kTaskForUnlockArea)
	startGamePanel:popout(false)
end