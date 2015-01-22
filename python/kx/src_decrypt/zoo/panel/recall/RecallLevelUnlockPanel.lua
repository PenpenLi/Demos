require "zoo.panel.basePanel.panelAnim.PanelPopRemoveAnim"
require "zoo.panel.component.unlockCloudPanel.FriendItem"
require "zoo.baseUI.BuyAndContinueButton"
require 'zoo.panel.MoreStarPanel'
require "zoo.panel.recall.RecallLevelTipPanel"
require "zoo.panel.recall.BeginRecallGameButton"

RecallLevelUnlockPanel = class(BasePanel)
local tipPanelHasPop = false

function RecallLevelUnlockPanel:init(lockedCloudId, totalStar, neededStar, cloudCanOpenCallback)
	BasePanel.init(self, self.ui)
	-- Data
	self.lockedCloudId		= lockedCloudId
	self.totalStar			= totalStar
	self.neededStar			= neededStar
	self.cloudCanOpenCallback = cloudCanOpenCallback

	self.curAreaFriendIds	= {}
	-- Get Agreed Friend Ids
	self:getAgreedFriendIds()

	self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED			= 1
	self.BTN_TAPPED_STATE_ASK_FRIEND_BTN_TAPPED	= 2
	self.BTN_TAPPED_STATE_NONE				= 3
	self.btnTappedState					= self.BTN_TAPPED_STATE_NONE

	-- Get UI Resource
	self.closeBtnRes = self.ui:getChildByName("closeBtn")
	local function onCloseBtnTapped()
		if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
			self.btnTappedState = self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED
		else
			return
		end
		self:remove(false)
	end
	self.closeBtnRes:setTouchEnabled(true)
	self.closeBtnRes:setButtonMode(true)
	self.closeBtnRes:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)
	
	self.panelTitle = TextField:createWithUIAdjustment(self.ui:getChildByName("panelTitleSize"), self.ui:getChildByName("panelTitle"))
	self.ui:addChild(self.panelTitle)
	self.panelTitle:setString(Localization:getInstance():getText("unlock.cloud.panel.title"))

	self:initBeginPart()
	self:initFriendPart()
	self:initStarPart()
	self:initMoneyPart()
	self:setButtonTouchEnable(false)
end

function RecallLevelUnlockPanel:setButtonTouchEnable(isEnabled)
	self.closeBtnRes:setTouchEnabled(isEnabled)
	self.beginButton:setEnabled(isEnabled, true)
	self.useWindmillBtn:setEnabled(isEnabled, true)
	self.moreStarBtn:setEnabled(isEnabled, true)
end

function RecallLevelUnlockPanel:initBeginPart()
	self.beginPart = self.ui:getChildByName("beginPart")

	self.levelIcon = self.beginPart:getChildByName("levelIcon")
	local iconPos = self.levelIcon:getPosition()
	local iconSize = self.levelIcon:getContentSize()
	self.levelIcon:setAnchorPoint(ccp(0.5,0.5))
	self.levelIcon:setPosition(ccp(iconPos.x+iconSize.width/2,iconPos.y-iconSize.height/2))
	self.levelIcon:setScale(0.2)
	local sequenceArr = CCArray:create()
	--sequenceArr:addObject(CCDelayTime:create(0.1))
	--CCEaseElasticOut
	sequenceArr:addObject(CCEaseBounceOut:create(CCScaleTo:create(0.5, 1)))
	sequenceArr:addObject(CCDelayTime:create(1))
	local function endCallBack()
		if not tipPanelHasPop then
			tipPanelHasPop = true
			self:showTipPanel()
		else
			self:showButtonAnimation()
		end
	end
	sequenceArr:addObject(CCCallFunc:create(endCallBack))
	self.levelIcon:stopAllActions();
	self.levelIcon:runAction(CCSequence:create(sequenceArr));

	local function onBeginButtonTap(event)
		if RecallManager.getInstance():getFinalRewardState() ~= RecallRewardType.AREA_SHORT and 
		   RecallManager.getInstance():getFinalRewardState() ~= RecallRewardType.AREA_MIDDLE then 
		   CommonTip:showTip(Localization:getInstance():getText("区域已解锁！"))
		   self:onCloseBtnTapped()
		   return 
		end
		self:onBeginButtonTap(event)
		GamePlayMusicPlayer:playEffect(GameMusicType.kClickCommonButton)
	end
	self.beginTipLabel = self.beginPart:getChildByName("tipLabel")
	self.beginTipLabel:setString(Localization:getInstance():getText("成功过关即可解锁关卡！"))

	self.beginButtonRes = self.beginPart:getChildByName("beginBtn")
	self.beginButton = GroupButtonBase:create(self.beginButtonRes)
	self.beginButton:setColorMode(kGroupButtonColorMode.blue)
	self.beginButton:setString(Localization:getInstance():getText("start.game.panel.start.btn.txt"))
	--self.beginButton.ui:setTouchEnabled(true)
	self.beginButton:ad(DisplayEvents.kTouchTap, onBeginButtonTap)
end

function RecallLevelUnlockPanel:onBeginButtonTap()
	self:onCloseBtnTapped()
	local levelId = RecallManager.getInstance():getAreTaskLevelId()
	local selectedItemsData = {}
	local levelType = LevelType:getLevelTypeByLevelId(levelId)
	print("levelId============================================",levelId)
	print("levelType============================================",levelType)
	if levelId%2==0 then 
		DcUtil:UserTrack({category = "recall", sub_category = "push_start_task", id = 5})
	else
		DcUtil:UserTrack({category = "recall", sub_category = "push_start_task", id = 3})
	end
	local startLevelLogic = StartLevelLogic:create(self, levelId, levelType, selectedItemsData, true)
	startLevelLogic:start(true)
end

function RecallLevelUnlockPanel:initFriendPart()
	self.friendPart = self.ui:getChildByName("friendPart")
	self.desLabel1 = self.friendPart:getChildByName("titleText")
	self.desLabel1:setString(Localization:getInstance():getText("可以请三位好友帮忙"))

	self.friendItem1 = FriendItem:create(self.friendPart:getChildByName("friendItem1"))
	self.friendItem2 = FriendItem:create(self.friendPart:getChildByName("friendItem2"))
	self.friendItem3 = FriendItem:create(self.friendPart:getChildByName("friendItem3"))
	self.friendItems = {self.friendItem1, self.friendItem2, self.friendItem3}

	self.askFriendBtn	= GroupButtonBase:create(self.friendPart:getChildByName("askFriendBtn"))
	--local askFriendBtnLabelKey	= "unlock.cloud.panel.button.request.friend"
	local askFriendBtnLabelValue	= Localization:getInstance():getText("好友帮忙")
	self.askFriendBtn:setString(askFriendBtnLabelValue)

	local function onAskFriendBtnTapped()
		if PrepackageUtil:isPreNoNetWork() then
			PrepackageUtil:showInGameDialog()
		else
			if RecallManager.getInstance():getFinalRewardState() ~= RecallRewardType.AREA_SHORT and 
			   RecallManager.getInstance():getFinalRewardState() ~= RecallRewardType.AREA_MIDDLE then 
			   CommonTip:showTip(Localization:getInstance():getText("区域已解锁！"))
			   self:onCloseBtnTapped()
			   return 
			end
			self:onAskFriendBtnTapped()
		end
	end
	self.askFriendBtn:addEventListener(DisplayEvents.kTouchTap, onAskFriendBtnTapped)
end

function RecallLevelUnlockPanel:initStarPart()
	self.starPart = self.ui:getChildByName("starPart")
	self.starPartTitle = self.starPart:getChildByName("titleText")
	self.starPartTitle:setString(Localization:getInstance():getText("more.star.btn.txt", {}))

	self.starNumLabel = self.starPart:getChildByName("starNum")
	self.starNumLabel:setString(self.totalStar .. "/" .. self.neededStar)

	self.moreStarBtn = GroupButtonBase:create(self.starPart:getChildByName('button'))
	self.moreStarBtn:setString(Localization:getInstance():getText('获得星星'))
	self.moreStarBtn:ad(DisplayEvents.kTouchTap, function () self:onMoreStarBtnTapped() end)
end

function RecallLevelUnlockPanel:initMoneyPart()
	self.moneyPart = self.ui:getChildByName("moneyPart")
	self.moneyPartTitle = self.moneyPart:getChildByName("titleText")
	if __ANDROID then
		self.moneyPartTitle:setString(Localization:getInstance():getText("一元解锁"))
	else
		self.moneyPartTitle:setString(Localization:getInstance():getText("风车币解锁"))
	end

	self.moneyNumLabel = self.moneyPart:getChildByName("moneyNum")
	local goodsMeta = MetaManager.getInstance():getGoodMetaByItemID(self.lockedCloudId)

	self.useWindmillBtn = ButtonIconNumberBase:create(self.moneyPart:getChildByName('button'))
	self.useWindmillBtn:setColorMode(kGroupButtonColorMode.blue)
	self.useWindmillBtn:setString(Localization:getInstance():getText('unlock.cloud.panel.button.unlock'))
	self.useWindmillBtn:ad(DisplayEvents.kTouchTap, function () self:onUseWindmillBtnTapped() end)

	if __ANDROID then -- ANDROID
		self.useWindmillBtn:setIcon(nil)
		local text = Localization:getInstance():getText("buy.gold.panel.money.mark") .. tostring(goodsMeta.rmb / 100)
		self.useWindmillBtn:setNumber(text)
		self.moneyNumLabel:setString(text)
	else 
		self.useWindmillBtn:setIconByFrameName('ui_images/ui_image_coin_icon_small0000')
		self.useWindmillBtn:setNumber(goodsMeta.qCash)
		self.moneyNumLabel:setString(goodsMeta.qCash)
	end
end

function RecallLevelUnlockPanel:onUseWindmillBtnTapped()
	if RecallManager.getInstance():getFinalRewardState() ~= RecallRewardType.AREA_SHORT and 
	   RecallManager.getInstance():getFinalRewardState() ~= RecallRewardType.AREA_MIDDLE then 
	   CommonTip:showTip(Localization:getInstance():getText("区域已解锁！"))
	   self:onCloseBtnTapped()
	   return 
	end
	-- Send Message Unlock The Cloud
	local function onSendUnlockMsgSuccess()

		-- Remove Self 
		local function onRemoveSelfFinish()
			self.cloudCanOpenCallback()
		end

		self:remove(onRemoveSelfFinish)
	end

	local function onSendUnlockMsgFailed()
		--print("use gold unlock cloud failed !")
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


function RecallLevelUnlockPanel:onAskFriendBtnTapped()
	if __IOS_FB and not SnsProxy:isShareAvailable() then 
		CommonTip:showTip(Localization:getInstance():getText("error.tip.facebook.login"), "negative",nil,2)
		return
	end

	if #self.curAreaFriendIds >= 3 then

		if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
			self.btnTappedState = self.BTN_TAPPED_STATE_ASK_FRIEND_BTN_TAPPED
		else
			return
		end

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

	else
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
end

function RecallLevelUnlockPanel:onCloseBtnTapped()
	if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
		self.btnTappedState = self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED
	else
		return
	end
	self:remove(false)
end

function RecallLevelUnlockPanel:updateView()
	if self.isDisposed then return end
	for index,friendId in ipairs(self.curAreaFriendIds) do
		if self.friendItems[index] then
			self.friendItems[index]:setFriend(friendId)
		end
	end
	-- Update BuyAndContinueButton State
	if #self.curAreaFriendIds >= 3 then
		local askFriendBtnLabelKey	= "unlock.cloud.panel.use.friend.unlock"
		local askFriendBtnLabelValue	= Localization:getInstance():getText(askFriendBtnLabelKey, {})
		self.askFriendBtn:setString(askFriendBtnLabelValue)
		self.askFriendBtn:setColorMode(kGroupButtonColorMode.green)
	end
end

function RecallLevelUnlockPanel:getAgreedFriendIds()
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

function RecallLevelUnlockPanel:popout()
	self.allowBackKeyTap = true
	PopoutQueue.sharedInstance():push(self)
end

function RecallLevelUnlockPanel:popoutShowTransition()
	self:setToScreenCenterVertical()
	self:setToScreenCenterHorizontal()
end

function RecallLevelUnlockPanel:showTipPanel()
	local tipPanel = RecallLevelTipPanel:create(self)
	tipPanel:popout()
end

function RecallLevelUnlockPanel:showButtonAnimation()
	self:setButtonTouchEnable(true)
	if self.beginButton then 
		local animations = CCArray:create()
		local currentScaleX = self.beginButtonRes:getScaleX()
		local biggerSize = currentScaleX * 1.1
		local smallerSize = currentScaleX * 0.9
		animations:addObject(CCEaseSineOut:create(CCScaleTo:create(0.1, biggerSize)))
		animations:addObject(CCEaseSineOut:create(CCScaleTo:create(0.3, currentScaleX)))
		animations:addObject(CCEaseSineOut:create(CCScaleTo:create(0.1, biggerSize)))
		animations:addObject(CCEaseSineOut:create(CCScaleTo:create(0.3, currentScaleX)))
		animations:addObject(CCEaseSineOut:create(CCScaleTo:create(0.1, biggerSize)))
		animations:addObject(CCEaseSineOut:create(CCScaleTo:create(0.3, currentScaleX)))
		animations:addObject(CCDelayTime:create(5))
		self.beginButtonRes:stopAllActions()
		self.beginButtonRes:runAction(CCRepeatForever:create(CCSequence:create(animations)))
	end
end

function RecallLevelUnlockPanel:setToScreenCenterHorizontal()
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfWidth		= 630

	local deltaWidth	= visibleSize.width - selfWidth
	local halfDeltaWidth	= deltaWidth / 2
	local hCenterXInScreen = visibleOrigin.x + halfDeltaWidth

	local parent		= self:getParent()
	assert(parent)

	local posXInParent	= parent:convertToNodeSpace(ccp(hCenterXInScreen, 0))
	self:setPositionX(posXInParent.x)
end

function RecallLevelUnlockPanel:remove(animFinishCallback)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")

	-- if not self.isDisposed then 
	-- 	PopoutManager:sharedInstance():removeWithBgFadeOut(self, animFinishCallback, true)
	-- end
	
	if type(animFinishCallback) == "function" then 
		animFinishCallback()
	end
	PopoutManager:sharedInstance():remove(self, true)
end

function RecallLevelUnlockPanel:onMoreStarBtnTapped()
	self:onCloseBtnTapped()
	PopoutManager:sharedInstance():remove(self, true)
	local panel = MoreStarPanel:create()
	panel:popout()
end

function RecallLevelUnlockPanel:create(lockedCloudId, totalStar, neededStar, cloudCanOpenCallback)
	assert(type(lockedCloudId) == "number")
	assert(type(totalStar) == "number")
	assert(type(neededStar) == "number")
	assert(type(cloudCanOpenCallback) == "function")
	
	--设定任务关卡解锁区域id
	RecallManager.getInstance():setNeedUnlockAreaId(lockedCloudId)

	local panel = RecallLevelUnlockPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.unlock_cloud_panel_new)
	panel.ui = panel:buildInterfaceGroup('RecallLevelUnlockPanel')
	
	-- local jasonFile = "ui/unlock_cloud_panel_new.json"
	-- LayoutBuilder:deleteConfig(jasonFile)
	-- ResourceManager:sharedInstance():addJsonFile(jasonFile)
	-- panel.ui = ResourceManager:sharedInstance():buildGroup("RecallLevelUnlockPanel")

	panel:init(lockedCloudId, totalStar, neededStar, cloudCanOpenCallback)
	return panel
end

