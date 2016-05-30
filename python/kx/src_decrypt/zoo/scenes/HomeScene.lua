-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年08月27日 15:32:36
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

assert(not HomeSceneEvents)
HomeSceneEvents = {
	-- Event For Notify Data Change
	USERMANAGER_TOP_LEVEL_ID_CHANGE 	= "HomeSceneEvents.USERMANAGER_TOP_LEVEL_ID_CHANGE",
	USERMANAGER_COIN_CHANGE			= "HomeSceneEvents.USERMANAGER_COIN_CHANGE",
	USERMANAGER_CASH_CHANGE			= "HomeSceneEvents.USERMANAGER_CASH_CHANGE",
	USERMANAGER_LEVEL_AREA_OPENED_ID_CHANGE = "HomeSceneEvents.USERMANAGER_LEVEL_AREA_OPENED_ID_CHANGE",
	USERMANAGER_TOTAL_STAR_NUMBER_CHANGE	= "HomeSceneEvents.USERMANAGER_TOTAL_STAR_NUMBER_CHANGE",
	USERMANAGER_ENERGY_CHANGE		= "HomeSceneEvents.USERMANAGER_ENERGY_CHANGE"
}

OpenUrlEvents = {
	kActivityShare = "OpenUrlEvents.kActivityShare",
}

require "hecore.ui.LayoutBuilder"

require "zoo.model.MetaModel"
require "zoo.scenes.component.HomeScene.WorldSceneScroller"
require "zoo.scenes.component.HomeScene.WorldMapNodeView"
require "zoo.baseUI.ScreenLayoutBar"
require "zoo.scenes.component.HomeScene.item.CoinButton"
require "zoo.scenes.component.HomeScene.item.GoldButton"
require "zoo.scenes.component.HomeScene.item.EnergyButton"
require "zoo.scenes.component.HomeScene.item.StarButton"
require "zoo.scenes.component.HomeScene.item.QQStarRewardButton"
require "zoo.scenes.component.HomeScene.GiftButton"
require "zoo.scenes.component.HomeScene.StarRewardButton"
require "zoo.scenes.component.HomeScene.LadybugButton"
require "zoo.scenes.component.HomeScene.CDKeyButton"
require "zoo.scenes.component.HomeScene.TempActivityButton"
require "zoo.scenes.component.HomeScene.iconButtons.MessageButton"
-- require "zoo.scenes.component.HomeScene.iconButtons.ExchangeButton"
-- require "zoo.scenes.component.HomeScene.iconButtons.InviteFriendButton"
require "zoo.scenes.component.HomeScene.buttonLayout.TreeInviteFriendButton"
require "zoo.scenes.component.HomeScene.buttonLayout.TreeStarRewardButton"
require "zoo.scenes.component.HomeScene.buttonLayout.TreeMailButton"
require "zoo.scenes.component.HomeScene.iconButtons.MarkButton"
require "zoo.scenes.component.HomeScene.iconButtons.MissionButton"
require "zoo.panel.CommonTipWithBtn"


require "zoo.scenes.component.HomeScene.SignUpButton"
require "zoo.panel.EnergyPanel"
require "zoo.panel.LevelSuccessPanel"
require "zoo.panel.LevelFailPanel"
require "zoo.panel.EndGamePropShowPanel"
require "zoo.panel.CDKeyPanel"
require "zoo.panel.CollectInfoPanel"
require "zoo.panel.CDkeyRewardPanel"

require "zoo.panel.LadyBugPanel"

require "zoo.UIConfigManager"
require "zoo.scenes.component.HomeScene.WorldScene"

require "zoo.common.CommonAction"
require "zoo.scenes.component.HomeScene.FriendPicture"

require "zoo.panel.starRewardPanel"
require "zoo.panel.QQStarRewardPanel"

require "zoo.net.Http"
require "zoo.gameGuide.GameGuide"
require "zoo.panel.MarkPanel"
require "zoo.panel.AddFriendPanel"
require "zoo.panel.BeginnerPanel"
require "zoo.panel.ExchangeCodePanel"
require "zoo.mission.panels.MissionPanel"

require "zoo.panel.EnterInviteCodePanel"
require "zoo.scenes.MessageCenterScene"
require "zoo.data.MaintenanceManager"

require 'zoo.panel.BagPanel'
require 'zoo.scenes.component.HomeScene.BagButton'
require 'zoo.scenes.component.HomeScene.FriendButton'
require 'zoo.scenes.component.HomeScene.MarketButton'
require 'zoo.scenes.component.HomeScene.UpdateButton'
require "zoo.scenes.component.HomeScene.FruitTreeButton"

require 'zoo.panel.component.friendRankingPanel.FriendRankingPanel'
require "zoo.data.FreegiftManager"
require 'zoo.panel.WdjInviteRewardPanel'
require 'zoo.panel.MarketPanel'
require "zoo.util.UrlParser"
require "zoo.panelBusLogic.InvitedAndRewardLogic"
require "zoo.panel.PrePropRemindPanel"
require "zoo.util.Cookie"

require "zoo.scenes.component.HomeSceneFlyToAnimation"
require 'zoo.data.MarketManager'

require 'zoo.scenes.component.HomeScene.FishPromotionButton'

require "zoo.scenes.component.HomeScene.ActivityButton"
require "zoo.scenes.component.HomeScene.ActivityIconButton"
require "zoo.util.ActivityUtil"
require "zoo.scenes.ActivityScene"
require "zoo.util.ActivityUpdateFlags"

require "zoo.scenes.FruitTreeScene"
require "zoo.panel.GiveBackPanel"
require "zoo.data.WeeklyRaceManager"
require 'zoo.scenes.component.HomeScene.WeeklyRaceButton'
require "zoo.util.PushActivity"
require 'zoo.scenes.component.HomeScene.buttonLayout.HomeSceneSettingButton'

require "zoo.scenes.component.HomeScene.TimeLimitButton"
require "zoo.panel.TimeLimitPanel"

require "zoo.animation.LadybugFourStarAnimation"
require "zoo.panel.CoinInfoPanel"
require "zoo.webviewhandler.webviewhandler"
require "zoo.mission.MissionLogic"

require 'zoo.common.LeaderBoardSubmitUtil'

-- require "zoo.data.RabbitWeeklyManager"
-- require "zoo.scenes.component.HomeScene.RabbitWeeklyButton"

require "zoo.panel.seasonWeekly.SeasonWeeklyRaceManager"
-- require "zoo.panel.seasonWeekly.SummerWeeklyPanel"
-- require "zoo.panel.seasonWeekly.AutumnWeeklyPanel"
require "zoo.panel.seasonWeekly.WinterWeeklyPanel"
require "zoo.scenes.component.HomeScene.iconButtons.SummerWeeklyButton"

require "zoo.panel.ConsumeHistoryPanel"
require "zoo.panel.ConsumeTipPanel"

require "zoo.panel.EnterContactInfoPanel"

require "zoo.panel.TurnTablePanel"
require "zoo.panel.InnerNotiPanel"
require "zoo.panel.recall.RecallFriendUnlockPanel"
require "zoo.panel.recall.RecallLevelUnlockPanel"
require "zoo.panel.recall.RecallItemPanel"
require "zoo.scenes.component.HomeScene.QQStarRewardLogic"
require 'zoo.scenes.component.HomeScene.buttonLayout.ButtonsBarEventDispatcher'
require 'zoo.scenes.component.HomeScene.buttonLayout.HomeSceneButtonsManager'
require 'zoo.scenes.component.HomeScene.buttonLayout.HideAndShowButton'
require 'zoo.scenes.component.HomeScene.buttonLayout.HomeSceneButtonsBar'
require 'zoo.data.FourStarManager'

require 'zoo.panel.messageCenter.MessageCenterHelper'
require 'zoo.panel.messageCenter.QQLoginReward'
require 'zoo.panelBusLogic.UnlockMessageLogic'
require "zoo.mission.MissionLogic"
require "zoo.panelBusLogic.SeasonWeeklyMatchHelpLogic"

require "zoo.scenes.component.HomeScene.popoutQueue.HomeScenePopoutQueue"

require "zoo.animation.SnowFlyAnimationTwo"
require "zoo.scenes.component.HomeScene.ApplePaycodeButton"
require "zoo.panel.ApplePaycodePanel"

require "zoo.scenes.component.HomeScene.flyToAnimation.FlyItemsAnimation"
require 'zoo.scenes.component.HomeScene.iconButtons.AliKfPromoButton'

require "zoo.panel.androidSalesPromotion.AndroidSalesManager"

-- 六一活动
require "zoo.eggs.EggsManager"

---------------------------------------------------
-------------- HomeScene
---------------------------------------------------

HomeScene = class(Scene)

function HomeScene:onInit(Scene, ...)

	assert(#{...} == 0)
	
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local topScreenPosY 	= visibleOrigin.y + visibleSize.height
	local rightScreenPosX	= visibleOrigin.x + visibleSize.width

	-- Data Model
	self.metaModel			= MetaModel:sharedInstance()

	----------------------
	-- WorldSceneScroller
	-- -------------------
	self.worldScene = WorldScene:create(self)
	self:addChild(self.worldScene)
 	if not (PrepackageUtil:isPreNoNetWork() or StarRewardModel:getInstance():update().allMissionComplete) then
 		if PlatformConfig:isPlatform(PlatformNameEnum.kQQ) then
			QQStarRewardLogic:getInstance():init(self)
		end
 	end
	
 	------------2016春节------------
	if WorldSceneShowManager:getInstance():isInAcitivtyTime() then 
		if not WorldSceneShowManager:getInstance():isInFireworkTime() then 
			math.randomseed(os.time())
			if math.random() > 0.3 then 
				local plistPath = "flash/scenes/homeScene/home_night/spring_2016_snow.plist"
				if __use_small_res then  
					plistPath = table.concat(plistPath:split("."),"@2x.")
				end
				CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plistPath)
				self.homeSceneSnowBg = SnowFlyAnimationTwo:create()
				self:addChild(self.homeSceneSnowBg)
			end
		end
	end

	if WorldSceneShowManager:getInstance():isInAcitivtyTime() then
		self.homeSceneFireworkLayer = SpringFireworkAnimation:create()
		self:addChild(self.homeSceneFireworkLayer)
	end
 	--------------------------------

	------------------------------------
	---- Buttons With Cloud Background
	---- On Screen Top
	------------------------------------
	self.energyButton	= EnergyButton:create(self)
	self.coinButton		= CoinButton:create(self)
	self.starButton		= StarButton:create()
	self.goldButton		= GoldButton:create()

	self:addChild(self.energyButton)
	self:addChild(self.coinButton)
	self:addChild(self.starButton)
	self:addChild(self.goldButton)

	

	self.energyButton:setPositionX(visibleOrigin.x + 10)
	self.energyButton:setPositionY(topScreenPosY - 15)

	self.starButton:setPositionX(visibleOrigin.x + 10)
	self.starButton:setPositionY(topScreenPosY - 140)

	local coinButtonSizeWidth = 112
	self.coinButton:setPositionX(rightScreenPosX - coinButtonSizeWidth)
	self.coinButton:setPositionY(topScreenPosY - 15)

	self.goldButton:setPositionX(rightScreenPosX - coinButtonSizeWidth)
	self.goldButton:setPositionY(topScreenPosY - 140)



	--------------------------
	-- Left Screen Bar
	-- -----------------------
	local layoutBarWidth		= visibleSize.width
	local layoutBarHeight		= visibleSize.height - 263
	local leftRegionLayoutBar	= RegionLayoutBar:create(layoutBarWidth, layoutBarHeight, LayoutBarAlign.LEFT, LayoutBarAlign.TOP, LayoutBarDirection.VERTICAL)
	self.leftRegionLayoutBar	= leftRegionLayoutBar

	leftRegionLayoutBar:setPosition(ccp(visibleOrigin.x, visibleOrigin.y + layoutBarHeight))
	self:addChild(leftRegionLayoutBar)

	----------------------
	-- Right Screen Bar
	-- ------------------
	local layoutBarWidth		= visibleSize.width
	local layoutBarHeight		= visibleSize.height - 263
	local rightRegionLayoutBar	= RegionLayoutBar:create(layoutBarWidth, layoutBarHeight, LayoutBarAlign.RIGHT, LayoutBarAlign.TOP, LayoutBarDirection.VERTICAL)
	self.rightRegionLayoutBar	= rightRegionLayoutBar
	
	rightRegionLayoutBar:setPosition(ccp(visibleOrigin.x, visibleOrigin.y + layoutBarHeight))
	self:addChild(rightRegionLayoutBar)

	-------------------------
	-- Star Reward Button
	-- ------------------------
	if not (PrepackageUtil:isPreNoNetWork() or StarRewardModel:getInstance():update().allMissionComplete) then

		if PlatformConfig:isPlatform(PlatformNameEnum.kQQ) then
			if QQStarRewardLogic:getInstance():isOldUser() then
				QQStarRewardLogic:getInstance():createFalseButton()
			end
		else
			-- 2016-03-18 删除入口
			-- self:createStarRewardButton(leftRegionLayoutBar)
			local function onTotalStarNumberChange()
				-- self:createStarRewardButton(leftRegionLayoutBar)
				self:createInviteFriendButton()
			end
			self:addEventListener(HomeSceneEvents.USERMANAGER_TOTAL_STAR_NUMBER_CHANGE, onTotalStarNumberChange)
		end
	end
	-------------------------------------
	-- Invite Friend Button
	-- -------------------------------
	self:createInviteFriendButton()

	------------------------------
	-- Message Button
	-- -------------------------
	local function shouldHideMessageButton()
		local PanelConfig = require 'zoo.panel.messageCenter.PanelConfig'
		local tabConfig, pageConfig = PanelConfig:getConfig()
		return #tabConfig == 0 
	end

	local function buildMessageButton()
		if self.messageButton then return end
		local function onMessageBtnTapped()
			DcUtil:iconClick("click_letters_icon")

			local function message_callback(result, evt)
				if result == "success" then
					if self.messageButton then
						self.messageButton:updateView()
					end
					Director:sharedDirector():pushScene(MessageCenterScene:create())
				else
					local message = ''
					local err_code = tonumber(evt.data)
					if err_code then message = Localization:getInstance():getText("error.tip."..err_code) end
					CommonTip:showTip(message, "negative")
				end
			end
			FreegiftManager:sharedInstance():update(true, message_callback)
		end

		if DengchaoPushEnergy.isInActTime() then
			self.messageButton = TreeMailButton:create(true)
		else
			self.messageButton = TreeMailButton:create()
		end
		local goldButtonIndex = self:getChildIndex(self.goldButton)
		if goldButtonIndex then 
			self:addChildAt(self.messageButton, goldButtonIndex+1)
		else
			self:addChild(self.messageButton)
		end
		local coinButtonSizeWidth = 200
		self.messageButton:setPositionX(rightScreenPosX - coinButtonSizeWidth)
		self.messageButton:setPositionY(topScreenPosY + 5)
		self.messageButton.wrapper:addEventListener(DisplayEvents.kTouchTap, onMessageBtnTapped)
		if shouldHideMessageButton() then
			self.messageButton:setVisible(false)
			self.messageButton.wrapper:setTouchEnabled(false)
		end
	end

	local function initMessageButton()

		if (not PrepackageUtil:isPreNoNetWork() ) and UserManager:getInstance().requestNum > 0 then
			buildMessageButton()
		else
			if shouldHideMessageButton() then
				HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMail, false)
			else
				HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMail, true)
			end		
		end
	end
	GlobalEventDispatcher:getInstance():addEventListener(MessageCenterPushEvents.kFriendsSynced, initMessageButton)
	

	local function onMessageCountUpdate()
		local count = UserManager:getInstance().requestNum
		if count <= 0 then
			HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMail, true)
			if self.messageButton and self:contains(self.messageButton) then
				HomeSceneButtonsManager.getInstance():flyToBtnGroupBar(HomeSceneButtonType.kMail, self.messageButton, function ()
					if not self.messageButton then return end
					self.messageButton:setVisible(false)
					self.messageButton.wrapper:setTouchEnabled(false)
					self.hideAndShowBtn:setEnable(false)
				end,function ()
					if not self.messageButton then return end
					self.hideAndShowBtn:playAni(function ()
						self.hideAndShowBtn:setEnable(true)
						HomeSceneButtonsManager.getInstance():showButtonHideTutor()
					end)
					self:removeChild(self.messageButton, false)
					self.messageButton = nil
					if shouldHideMessageButton() then
						HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMail, false)
					end
				end)
			end
		else
			if not shouldHideMessageButton() then
				HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMail, false)
				if self.messageButton and self:contains(self.messageButton) then
					self.messageButton:updateView()
				else
					buildMessageButton()
				end
			else
				HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMail, false)
				if self.messageButton then
					self.messageButton:setVisible(false)
					self.messageButton.wrapper:setTouchEnabled(false)
				end
			end
		end
	end
	GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kMessageCenterUpdate, onMessageCountUpdate)
	
	-- -------------------
	-- Gold
	-- -------------------
	local function popBuyGoldPanel(evt)
		DcUtil:iconClick("click_gold_icon")
		local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
		if index ~= 0 then
			if SupperAppManager:checkEntry() == true then
				DcUtil:UserTrack({ category='activity', sub_category='push_1_2'})
			end
			self:popoutMarketPanelByIndex(index)
			GamePlayMusicPlayer:playEffect(GameMusicType.kClickBubble)
		end
	end

	local function isGoldButtonTipShowed()
		return CCUserDefault:sharedUserDefault():getBoolForKey("gold.button.tip.showed")
	end

	self.goldButton:setOnTappedCallback(popBuyGoldPanel)
	local userLevel = UserManager:getInstance():getUserRef():getTopLevelId()
	if userLevel >= 10 and not isGoldButtonTipShowed() then
		self.goldButton:playHasNotificationAnim()
		CCUserDefault:sharedUserDefault():setBoolForKey("gold.button.tip.showed", true)
		CCUserDefault:sharedUserDefault():flush()
	end

	-- -------------------------
	-- Lady Bug Button
	-- --------------------------
	if LadyBugMissionManager:sharedInstance():isMissionStarted() and not self.ladybugButton then
		-- -----------------------------------
		-- Create The Lady Bug Button 
		-- ------------------------------------
		local function onLadyBugBtnTapped()
			print("onLadyBugBtnTapped Called !")
			self:popoutLadyBugPanel()
		end

		self.ladybugButton	= LadybugButton:create()
		self.leftRegionLayoutBar:addItem(self.ladybugButton)
		self.ladybugButton.wrapper:addEventListener(DisplayEvents.kTouchTap, onLadyBugBtnTapped)
	end

	local function onTopLevelChangeCallback(event) 
		self:onTopLevelChange()
	end 
	self:addEventListener(HomeSceneEvents.USERMANAGER_TOP_LEVEL_ID_CHANGE, onTopLevelChangeCallback)

	--右下角+按钮
	local function onHideAndShowBtnTapped()
		DcUtil:iconClick("click_right_bill_icon")

		self:showButtonGroup()
	end
	self.hideAndShowBtn = HideAndShowButton:create(ResourceManager:sharedInstance():buildGroup("buttonGroupBtn"))
	local btnSize = self.hideAndShowBtn:getGroupBounds().size
	local _x = visibleOrigin.x + visibleSize.width - btnSize.width + 40
	local _y = visibleOrigin.y + btnSize.height - 35
	self.hideAndShowBtn:setPosition(ccp(_x, _y))
	self:addChild(self.hideAndShowBtn.ui)
	self.hideAndShowBtn:ad(DisplayEvents.kTouchTap, onHideAndShowBtnTapped)

	--------------------
	---- 左下角设置按钮
	----------------------
	self.settingButton = HideAndShowButton:create(ResourceManager:sharedInstance():buildGroup("homeSceneSettingBtn"))
	self:addChild(self.settingButton.ui)
	self.settingButton:ad(DisplayEvents.kTouchTap, function () self:showSettingButton() end)

	self.settingButton.updateDotTipStatus = function (context)
		local dotTipVisible = false

		if not BindPhoneGuideLogic:hasPersonalGuidePlayed() then
	        dotTipVisible = true
	    end
	    context.ui:getChildByName('blueBtn'):getChildByName("dot"):setVisible(dotTipVisible)
	end
	self.settingButton:updateDotTipStatus()

	local manualAdjustX	= -5
	local manualAdjustY	= 14

	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local pauseBtnPosX	=  visibleOrigin.x + manualAdjustX
	local pauseBtnPosY	= visibleOrigin.y + self.settingButton.ui:getGroupBounds().size.height + manualAdjustY

	self.settingButton.ui:setPosition(ccp(pauseBtnPosX, pauseBtnPosY))

	--------------------
	---- Bag Button
	--------------------
	HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kBag, true)

	--------------------
	---- Friend Ranking Button
	--------------------
	if not (PrepackageUtil:isPreNoNetWork() or __IOS_FB )then
		HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kFriends, true)
	end

	-- --------------------
	-- ---- Market Panel Button
	-- --------------------
	local function onMarketButtonTapped(event)
		-- DcUtil:iconClick("click_shop_icon")
		self.marketButton.wrapper:setTouchEnabled(false)
		self.marketButton:runAction(CCCallFunc:create(function()

			local index, showFree = self:checkJiFenView()
			self:popoutMarketPanelByIndex(index, showFree)
			self.marketButton.wrapper:setTouchEnabled(true, 0, true)
		end))
	end
	self.marketButton = MarketButton:create()
	local btnSize = self.marketButton:getGroupBounds().size
	local x = visibleOrigin.x + visibleSize.width - btnSize.width - 95
	local y = visibleOrigin.y + btnSize.height - 38
	local marketButtonPosition = nil
	if __IOS_FB then
		marketButtonPosition = ccp(x + 120, y)
	else
		marketButtonPosition = ccp(x, y)
	end
	self.marketButton:setPosition(marketButtonPosition)
	self:addChild(self.marketButton)
	self.marketButton.wrapper:addEventListener(DisplayEvents.kTouchTap, onMarketButtonTapped)
	self.marketButton:showDiscount(MarketManager:sharedInstance():shouldShowMarketButtonDiscount())
	self.marketButton:showNew(MarketManager:sharedInstance():shouldShowMarketButtonNew())

	

	-- -------------------------
	-- Add Event Listener
	-- ---------------------
	local function popEnergyPanel(event)
		DcUtil:iconClick("click_energy_icon")

		GamePlayMusicPlayer:playEffect(GameMusicType.kClickBubble)
		local energyPanel = EnergyPanel:create(false)
		energyPanel:popout(false)
	end
	self.energyButton:setOnTappedCallback(popEnergyPanel)

	local function popCoinInfoPanel(evt)
		DcUtil:UserTrack({category = "ui", sub_category = "click_main_ui_silver_coin_button"}, true)
		local panel = CoinInfoPanel:create()
		panel:popout()
	end
	self.coinButton:setOnTappedCallback(popCoinInfoPanel)



	-------------------------------------------
	---- Register The Interest Data 
	---- For Check Data Change And Update View 
	-------------------------------------------
	self:registerInterestData()

	--------------------------
	-- Register Script Handler
	-- ----------------------
	local function onEnterHandler(event)
		self:onEnterHandler(event)
	end
	self:registerScriptHandler(onEnterHandler)

	DcUtil:up(200)

	local config = {
		energyButton = self.energyButton,
		starButton = self.starButton,
		coinButton = self.coinButton,
		bagButton = self.hideAndShowBtn,
		goldButton = self.goldButton,
	}
	HomeSceneFlyToAnimation:sharedInstance():init(config)

	--------------------
	---- TempActivity Button
	---- init at last 
	----------------------
	if PublishActUtil:isGroundPublish() then
		self:buildTempActivityBtn()
	end

	local function onSyncFinished()
		print("HomeScene onSyncFinished Called !")
		self:onSyncFinished()
	end
	GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kSyncFinished, onSyncFinished)
	local function onUserLogin()
		self:onUserLogin()
	end
	GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kUserLogin, onUserLogin)

	if (__ANDROID or __IOS or __WIN32) and MaintenanceManager:getInstance():isEnabled("ConsumeDetailPanel") then 
		GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kConsumeComplete, function(evt)
			ConsumeTipPanel:create(evt.data.props):popout()
		end)
	end

	local layer = Layer:create()
	self.guideLayer = layer
	self:addChild(layer)

	--每日首次登陆 上传下积分
	if __IS_TOTAY_FIRST_LOGIN then 
		local newTotalStarNumber = UserManager.getInstance().user:getStar() + UserManager.getInstance().user:getHideStar()
		LeaderBoardSubmitUtil.submitTotalStars(newTotalStarNumber)
	end
	he_log_info("auto_test_tap_login")


	GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kDefaultPaymentTypeAutoChange, function() self:onDefaultPaymentTypeAutoChange() end)

	self:buildJiFenEntry()

	if SnsProxy and __ANDROID then
		SnsProxy:configQQWallet()
	end
end

function HomeScene:canDcUserInfo()
	local lastDcTime = CCUserDefault:sharedUserDefault():getStringForKey("custom.userinfo.dc.time")
	if lastDcTime == "" then lastDcTime = 0 end
	local lastStartTime = math.floor(tonumber(lastDcTime) / 3600 / 24)

	local curTimeInSec = Localhost:timeInSec()
	local nowStartTime = math.floor(curTimeInSec / 3600 / 24)

	if lastStartTime ~= nowStartTime then
		CCUserDefault:sharedUserDefault():setStringForKey("custom.userinfo.dc.time", tostring(curTimeInSec))
		return true
	end
	return false
end

function HomeScene:dcUserInfo()
	if not self:canDcUserInfo() then return end
	local pcManager = PersonalCenterManager
	local snsInfo = UserManager.getInstance().profile:getSnsInfo(PlatformAuthEnum.kPhone)
	local keyt
	if snsInfo then
		keyt = snsInfo.snsName
	end
	local defaultPaymentType
	if __ANDROID then 
		defaultPaymentType = PaymentManager.getInstance():getDefaultPayment()
	end

	local isBackgroundMusicOpen = GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen
	local isMusicOpen = GamePlayMusicPlayer:getInstance().IsMusicOpen
	local isMessageOpen = CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification")

	local userData = {
		name = HeDisplayUtil:urlEncode(pcManager:getData(pcManager.NAME)),
		sex = pcManager:getData(pcManager.SEX),
		age = pcManager:getData(pcManager.AGE),
		star_sign = pcManager:getData(pcManager.CONSTELLATION),
		friend_num = FriendManager.getInstance():getFriendCount(),
		keyt = keyt or "",
		default_type = defaultPaymentType,
		music1 = isBackgroundMusicOpen and "1" or "0",
		music2 = isMusicOpen and "1" or "0",
		message = isMessageOpen and "1" or "0",
	}
	local callbackHanler = function(response)
        if response.httpCode == 200 then
            if type(response) == "table" and type(response.body) == "string" then
                local tab = table.deserialize(response.body)
                if type(tab) == "table" then
                    userData["country"] = tostring(tab.country)
                    userData["province"] = tostring(tab.province)
                    userData["city"] = tostring(tab.city)
                    userData["district"] = tostring(tab.district)
                    userData["isp"] = tostring(tab.isp)
                end
            end   
        end

        DcUtil:userInfo( userData )
    end

    local request = HttpRequest:createPost("http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json")
    local timeout = 1
    local connection_timeout = 1

    if __WP8 then 
        timeout = 30
        connection_timeout = 5
    end

    request:setConnectionTimeoutMs(connection_timeout * 1000)
    request:setTimeoutMs(timeout * 1000)
    HttpClient:getInstance():sendRequest(callbackHanler, request)

    local isQQLogin = SnsProxy:getAuthorizeType() == PlatformAuthEnum.kQQ
    local friend = {}
    if isQQLogin then
    	local snsFriendIds = FriendManager.getInstance().snsFriendIds
    	for uid,fid in pairs(snsFriendIds) do
    		local f = FriendManager.getInstance():getFriendInfo(uid)
    		if f then
    			friend[tostring(uid)] = true
    		end
    	end
	end

	local friend_txt = ""

	for uid,_ in pairs(friend) do
		if friend_txt == "" then
			friend_txt = uid
		else
			friend_txt = friend_txt.."_"..uid
		end
	end

	local friend_xxl = ""

	local friends = FriendManager.getInstance().friends
	for uid,fid in pairs(friends) do
		local u = tostring(uid)
		if friend[tostring(u)] ~= true then
			if friend_xxl == "" then
				friend_xxl = u
			else
				friend_xxl = friend_xxl.."_"..u
			end
		end
	end

	local qqUserFriData = {
    	friend_num = FriendManager.getInstance():getFriendCount(),
    	friend = friend_txt,
    	friend_xxl = friend_xxl,
	}
	DcUtil:qqUserFri( qqUserFriData )
end

function HomeScene:shutdownJiFenEntry( ... )
	if self.goldButtonFree1 and self.goldButtonFree2 then
		self.goldButtonFree1:setVisible(false)
		self.goldButtonFree2:setVisible(false)
	end
end

function HomeScene:showJiFenEntry( ... )
	if self.goldButtonFree1 and self.goldButtonFree2 then
		self.goldButtonFree1:setVisible(true)
		self.goldButtonFree2:setVisible(true)
	end
end

function HomeScene:buildJiFenEntry( ... )
	if self.goldButtonFree1 and self.goldButtonFree2 then return end
	if SupperAppManager:checkEntry() == false then return end

	--init 积分墙sdk
	local function callback( ... )
		SpriteUtil:addSpriteFramesWithFile("flash/supperapp_banner.plist", "flash/supperapp_banner.png")
		local free = Sprite:createWithSpriteFrameName("supperapp_free_icon instance 10000")
		free:setPositionX(80)
		self.goldButton:addChild(free)

		self.goldButtonFree1 = free

		local free = Sprite:createWithSpriteFrameName("supperapp_free_icon instance 10000")
		free:setPositionX(30)
		free:setPositionY(40)
		self.marketButton:addChild(free)

		self.goldButtonFree2 = free
	end
	
	SupperAppManager:initSDK(callback)
end

function HomeScene:checkJiFenView( ... )
	local enbaleEntry = SupperAppManager:checkEntry()
	if enbaleEntry == true then
		DcUtil:UserTrack({ category='activity', sub_category='push_1_1'})
	end
	if self.hadEntryGoldPanel == true then return 1, enbaleEntry end

	if enbaleEntry== true then 
		self.hadEntryGoldPanel = true
		return MarketManager:sharedInstance():getHappyCoinPageIndex(), false
	end
	return 1, enbaleEntry
end

function HomeScene:showButtonGroup(endCallback)
	self.hideAndShowBtn:setVisible(false)
	local btnBarEvt = ButtonsBarEventDispatcher.new()
	btnBarEvt:addEventListener(ButtonsBarEvents.kClose, function ()
		self.hideAndShowBtn:setVisible(true)
		self.buttonGroupBar = nil
	end)
	self.buttonGroupBar = HomeSceneButtonsBar:create(btnBarEvt)
	self.buttonGroupBar:popout(endCallback)
end

function HomeScene:showSettingButton(endCallback)
	DcUtil:iconClick("click_left_bill_icon")
	self.settingButton:setVisible(false)
	local btnBarEvt = HomeSceneSettingButtonEventDispatcher.new()
	btnBarEvt:addEventListener(HomeSceneSettingButtonEvents.kClose, function ()
		self.settingButton:setVisible(true)
		self.settingButtonUI = nil
	end)
	local position = ccp(self.settingButton.ui:getPositionX(), self.settingButton.ui:getPositionY())
	self.settingButtonUI = HomeSceneSettingButton:create(btnBarEvt)
	self.settingButtonUI:popout(endCallback, position)
end

function HomeScene:onSyncFinished()
	local function updateHomeScene()
		self:checkDataChange()
		if self.starButton then self.starButton:updateView() end
		if self.energyButton then self.energyButton:updateView() end
		if self.coinButton then self.coinButton:updateView() end
		if self.goldButton then self.goldButton:updateView() end

		self:updateHomeSceneButtonsWhileSyncFinish()
		self:tryToShowFunsClub()
	end
	setTimeOut(updateHomeScene, 2/60)
end

function HomeScene:updateHomeSceneButtonsWhileSyncFinish()
	local userTopLevel = UserManager:getInstance():getUserRef():getTopLevelId()

	if not SeasonWeeklyRaceManager:getInstance():isLevelReached(userTopLevel) and self.summerWeeklyButton then
		self.leftRegionLayoutBar:removeItem(self.summerWeeklyButton, true)
		self.summerWeeklyButton = nil
	end

	if UserManager.getInstance().user:getTopLevelId() < MissionLogic:getMissionUserNeedLevel() and self.missionBtn then
		self.leftRegionLayoutBar:removeItem(self.missionBtn, true)
		self.missionBtn = nil
	end

	if userTopLevel < 16 then
		HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kTree, false)
		if self.fruitTreeBtn then
			self.fruitTreeBtn:removeFromParentAndCleanup(true)
			self.fruitTreeBtn = nil
		end
		local function showFruitTreeButton(evt, noTutor)
			local user = UserManager:getInstance():getUserRef()
			if user and user:getTopLevelId() >= 16 then
				self:removeEventListener(HomeSceneEvents.USERMANAGER_TOP_LEVEL_ID_CHANGE, showFruitTreeButton)

				if HomeSceneButtonsManager.getInstance():getFruitTreeButtonShowState() then
					HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kTree, true)
					if not noTutor then 
						HomeSceneButtonsManager.getInstance():showFruitTreeAppearTutor()
					end
				else
					self:createFruiteTreeButtonInHomeScene()
					if not noTutor then
						HomeSceneButtonsManager.getInstance():showFruitTreeAppearTutor(true)
					end
				end
			end
		end
		self:addEventListener(HomeSceneEvents.USERMANAGER_TOP_LEVEL_ID_CHANGE, showFruitTreeButton)
	end

	if userTopLevel < 7 then
		HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMark, false)
		if self.markButton then
			self.rightRegionLayoutBar:removeItem(self.markButton, true)
			self.markButton = nil
		end
	end

	if __IOS then
		if not IosPayGuide:isInOneYuanShopPromotion() and self.oneYuanShopButton then
			self.leftRegionLayoutBar:removeItem(self.oneYuanShopButton)
	        self.oneYuanShopButton = nil
		end
	end

	if not NewVersionUtil:hasNewVersion() and self.updateVersionButton then
		self.updateVersionButton:removeFromParentAndCleanup(true)
		self.updateVersionButton = nil
	end

	self:buildActivityButton()
end

function HomeScene:onUserLogin()
	local function showFunsClub()
		self:tryToShowFunsClub()
	end
	setTimeOut(showFunsClub, 2/60)
end

function HomeScene:tryToShowFunsClub()
	if LoginExceptionManager:getInstance():getShouldShowFunsClub() then 
		LoginExceptionManager:getInstance():setShouldShowFunsClub(false)
		LoginExceptionManager:getInstance():showFunsClub()
	end
end

function HomeScene:popoutWdjRewardPanelIfNecessary()
    print('thisdebug popoutWdjRewardPanelIfNecessary')
    local manager = UserManager:getInstance()
    local function _setFlag()
        print('thisdebug _setFlag')
        UserManager:getInstance().userExtend:setEnteredInviteCode(true)
    end

    if __ANDROID and PlatformConfig:isPlatform(PlatformNameEnum.kWDJ)
        and not manager.userExtend:hasEnteredInviteCode() 
        and tonumber(manager:getUserRef():getTopLevelId()) <= 30 
    then -- never entered any invite code yet
        print('wdjHelper')

        local function wdjInviteOnSuccess(inviters)

                print('wdjInviteOnSuccess')
                print('wdj', inviters)
                inviters = luaJavaConvert.list2Table(inviters)

            if inviters and type(inviters) == 'table' and #inviters > 0 then
                local friendOpenids = {}
                for _, v in pairs(inviters) do
                    table.insert(friendOpenids, v.uid)
                end

                local function httpSuccess(event)
                    print('wdjInviteOnSuccess httpSuccess')
                    if event.data.inviterCount then
                        local count = tonumber(event.data.inviterCount)
                        if count > 0 then -- the invitation is valide
                            -- pop out panel ONLY on HomeScene
                            if Director:sharedDirector():getRunningScene() == HomeScene:sharedInstance()
                            and not manager.userExtend:hasEnteredInviteCode()  then
                                local panel = WdjInviteRewardPanel:create()
                                if panel then panel:popout() end
                                _setFlag()
                                self:updateFriends()
                                DcUtil:wdjEnter()
                            end
                        end
                    end
                end
                local function httpFail(data)
                    print('wdjInviteOnSuccess httpFail')
                end
                local http = GetInviteeRewardHttp.new()
                http:ad(Events.kComplete, httpSuccess)
                http:ad(Events.kError, httpFail)
                http:load(friendOpenids)

            end
        end
        local function wdjInviteOnError(err, msg)
            print('wdjInviteOnError')
        end
        local function wdjInviteOnCancel()
            print('wdjInviteOnCancel')
        end

        local callback = luajava.createProxy("com.happyelements.android.InvokeCallback", {
            onSuccess = wdjInviteOnSuccess,
            onCancel = wdjInviteOnCancel,
            onError = wdjInviteOnError
        })
        luajava.bindClass("com.happyelements.android.platform.wandoujia.WandoujiaHelper"):getInviters(callback)
    end
end

function HomeScene:popoutLadyBugPanel(showTip, panelCloseCallback)

	-- Pass In Position
	local ladyBugBtnPos 			= self.ladybugButton:getPosition()
	local ladyBugBtnParent			= self.ladybugButton:getParent()
	local ladyBugBtnPosInWorldSpace		= ladyBugBtnParent:convertToWorldSpace(ccp(ladyBugBtnPos.x, ladyBugBtnPos.y))
	
	local ladyBugPanel = LadyBugPanel:create(ladyBugBtnPosInWorldSpace)
	ladyBugPanel:popout(showTip, panelCloseCallback)

	return ladyBugPanel
end

function HomeScene:removeLadyBugButton(...)
	assert(#{...} == 0)

	if self.ladybugButton then
		self.leftRegionLayoutBar:removeItem(self.ladybugButton)
		self.ladybugButton = nil
	end
end

----------------------------------------------------------------------
----	Observer Design Pattern
----	Check Interest Data Change
--------------------------------------------------------------

function HomeScene:registerInterestData(...)
	assert(#{...} == 0)

	self.oldUsrCoin			= UserManager.getInstance().user:getCoin()
	self.oldUsrCash			= UserManager.getInstance().user:getCash()
	self.oldTotalStarNumber		= UserManager.getInstance().user:getStar() + UserManager.getInstance().user:getHideStar()
	self.oldEnergy 			= UserManager.getInstance().user:getEnergy()
end 

function HomeScene:onLevelPassed(passedLevel, ...)
	assert(type(passedLevel) == "number")
	assert(#{...} == 0)

	if not PrepackageUtil:isPreNoNetWork() then
    	LadyBugMissionManager:sharedInstance():onLevelPassedCallback(passedLevel) 
	end
end

function HomeScene:onTopLevelChange()
	-- self.oldTopLevelId = UserManager.getInstance().user:getTopLevelId()
	-- print("#######################HomeScene:onTopLevelChange")
	if not PrepackageUtil:isPreNoNetWork() then
		-- 上传最高关卡
		local newTopLevelId = UserManager.getInstance().user:getTopLevelId()
		LeaderBoardSubmitUtil.submitPassedLevel(newTopLevelId)
		
	    LadyBugMissionManager:sharedInstance():onTopLevelChange() 
	    -- WeeklyRaceManager:sharedInstance():onTopLevelChange()
	   	-- RabbitWeeklyManager:sharedInstance():onTopLevelChange()
		if self.summerWeeklyButton == nil and SeasonWeeklyRaceManager:getInstance():isLevelReached(newTopLevelId) then
			self:createSummerWeeklyButton()
		end

		MissionPanelLogic:tryToUpdateMissionButton()
		--self:createMissionButton()
		--MissionPanelLogic:checkManga()
		
	end
end

function HomeScene:checkUserCoinChange(...)
	assert(#{...} == 0)

	print("HomeScene:checkUserCoinChange Called !")
	-- Check Coin
	local newUsrCoin = UserManager.getInstance().user:getCoin()
	if self.oldUsrCoin ~= newUsrCoin then
		self.oldUsrCoin = newUsrCoin
		self:dispatchEvent(Event.new(HomeSceneEvents.USERMANAGER_COIN_CHANGE))
	end
end

function HomeScene:checkUserCashChange(...)
	assert(#{...} == 0)

	print("HomeScene:checkUserCashChange Called !")
	-- Check Coin
	local newUsrCash = UserManager.getInstance().user:getCash()
	if self.oldUsrCash ~= newUsrCash then
		self.oldUsrCash = newUsrCash
		self:dispatchEvent(Event.new(HomeSceneEvents.USERMANAGER_CASH_CHANGE))
	end
end

function HomeScene:checkTotalStarNumberChange(...)
	assert(#{...} == 0)

	print("HomeScene:checkTotalStarNumberChange Called !")
	-- Check Total Star
	local newTotalStarNumber = UserManager.getInstance().user:getStar() + UserManager.getInstance().user:getHideStar()

	if self.oldTotalStarNumber ~= newTotalStarNumber then
		self.oldTotalStarNumber = newTotalStarNumber
		self:dispatchEvent(Event.new(HomeSceneEvents.USERMANAGER_TOTAL_STAR_NUMBER_CHANGE))
		-- 上传玩家最大星星数
		LeaderBoardSubmitUtil.submitTotalStars(newTotalStarNumber)
	end
end

function HomeScene:checkDataChange(...)
	assert(#{...} == 0)

	-- Implement The Observer Design Pattern, To Update View When Data Change
	-- But Not The Data Model To Dispatch Event To Update THe View.
	-- The View Checks The Data Change , When Needed.
	--
	-- Things Concerned When Design:
	-- Based On Others Already Design Of Data Model ( Not Dispatch Any Event, When Data Change)
	-- So In This Function, We Check Variable Change That We Are Interested In, And Dispatch Event To
	-- Notify View To Update Their Display.
	---------------------------------------------------------------------
	-- self:checkTopLevelIdChange()
	self:checkUserCoinChange()
	self:checkUserCashChange()
	-- self:checkLevelAreaOpenedIdChange()
	self:checkTotalStarNumberChange()

	self:checkUserEnergyDataChange()
	self:updateButtons()
end

function HomeScene:checkUserEnergyDataChange(...)
	assert(#{...} == 0)

	local newEnergy = UserManager.getInstance().user:getEnergy()

	if self.oldEnergy ~= newEnergy then
		self.oldEnergy = newEnergy

		local event = Event.new(HomeSceneEvents.USERMANAGER_ENERGY_CHANGE)
		self:dispatchEvent(event)
	end
end

local sharedInstance = false
function HomeScene:sharedInstance(...)
	assert(#{...} == 0)

	if not sharedInstance then
		sharedInstance = HomeScene.new()
		sharedInstance:initScene()
	end

	return sharedInstance
end

function HomeScene:hasInited()
	return sharedInstance
end

-- replacing the old function
function HomeScene:createFloatingItemAnim(itemId, ...)
	return self:createFlyToBagAnimation(itemId)
end


-- deprecated function
function HomeScene:createFloatingItemAnim_old(itemId, ...)
	assert(type(itemId) == "number")
	assert(#{...} == 0)

	local itemRes = ResourceManager:sharedInstance():buildItemSprite(itemId)
	itemRes:setAnchorPoint(ccp(0,1))

	itemRes:setVisible(false)
	HomeScene:sharedInstance():addChild(itemRes)

	itemRes.playFlyToAnim = function(self, animFinishCallback)
		assert(self)
		assert(not animFinishCallback or type(animFinishCallback) == "function")

		local actionArray = CCArray:create()

		-- ------------
		-- Init Action
		-- --------------
		local function initActionFunc()
			itemRes:setVisible(true)
		end
		local initAction = CCCallFunc:create(initActionFunc)

		local moveToTime	= 0.6
		--local moveToTime	= 8

		local deltaX		= 0
		local deltaY		= 100

		-- Fade Out
		local fadeOut		= CCFadeOut:create(moveToTime)
		local easeFadeOut	= CCEaseExponentialIn:create(fadeOut) 

		-- Move To 
		local moveBy	= CCMoveBy:create(moveToTime, ccp(deltaX, deltaY))
		-- Spawn
		local spawn		= CCSpawn:createWithTwoActions(easeFadeOut, moveBy)
		local targetSpawn	= CCTargetedAction:create(itemRes.refCocosObj, spawn)

		-- Anim Finish
		local function animFinishCallbackFunc()
			itemRes:removeFromParentAndCleanup(true)

			if animFinishCallback then
				animFinishCallback()
			end
		end
		local animFinishAction = CCCallFunc:create(animFinishCallbackFunc)

		-- Action Array
		local array = CCArray:create()
		array:addObject(initAction)
		array:addObject(targetSpawn)
		array:addObject(animFinishAction)
		-- Seq
		local seq = CCSequence:create(array)

		itemRes:runAction(seq)
	end

	return itemRes
end

function HomeScene:createFlyingRewardAnim(rewardIds, rewardAmounts, ...)
	assert(rewardIds)
	assert(#{...} == 0)

	local anims = {}
	for k,v in pairs(rewardIds) do
		if v == ItemType.ENERGY_LIGHTNING then
			-- Check If Flying Energy 
			local anim = self:createFlyingEnergyAnim()
			table.insert(anims, anim)

		elseif v == ItemType.INFINITE_ENERGY_BOTTLE then
			-- Check If Flying Infinite Energy
			local anim = self:createFlyingEnergyAnim(true)
			table.insert(anims, anim)

		elseif v == ItemType.COIN then
			-- Check If Flying Icon
			local anim = self:createFlyingCoinAnim()
			table.insert(anims, anim)
		elseif v == ItemType.GOLD then
			local anim = self:createFlyingGoldAnim()
			table.insert(anims, anim)
		else
			-- Other Floating Anim
			-- local anim = self:createFloatingItemAnim_old(v)
			local numOfTimes = 1
			if rewardAmounts then 
				numOfTimes = rewardAmounts[k] 
			end

			local anim = self:createFlyToBagAnimation(v, numOfTimes)
			table.insert(anims, anim)

		end
	end

	return anims
end

function HomeScene:createFlyingEnergyAnim(isInfiniteEnergy, ...)
	--assert(type(isInfiniteEnergy) == "boolean")
	assert(#{...} == 0)

	-- Create The UI Resource
	local energyRes = false

	if isInfiniteEnergy then
		energyRes	= ResourceManager:sharedInstance():buildItemGroup(ItemType.INFINITE_ENERGY_BOTTLE)
	else
		energyRes	= ResourceManager:sharedInstance():buildGroup("homeSceneEnergy")
	end

	self:addChild(energyRes)

	-- Get Energy Icon Location
	local energyPosition 	= self.energyButton.energyIcon:getPosition()
	local energyParent	= self.energyButton.energyIcon:getParent()
	-- Convert To World Space
	local energyPosInWorldSpace	= energyParent:convertToWorldSpace(ccp(energyPosition.x, energyPosition.y))
	-- Convert To HomeScene Space
	local energyPosInHomeSceneSpace	= self:convertToNodeSpace(energyPosInWorldSpace)

	energyRes.playFlyToAnim = function(energySelf, animFinishCallback, ...)
		assert(energySelf)
		assert(not animFinishCallback or type(animFinishCallback) == "function")

		local moveToTime	= 0.8

		-- Move To
		local curPos		= energyRes:getPosition()
		local distance		= ccpDistance(ccp(energyPosInHomeSceneSpace.x, energyPosInHomeSceneSpace.y), curPos)
		local bezierTo		= HeBezierTo:create(moveToTime, ccp(energyPosInHomeSceneSpace.x, energyPosInHomeSceneSpace.y), true, distance * 0.15)
		local easeBezier	= CCEaseOut:create(bezierTo, 0.3)
		local targetMoveTo	= CCTargetedAction:create(energyRes.refCocosObj, easeBezier)

		-- Anim Finish
		local function animFinishCallbackFunc()
			energyRes:removeFromParentAndCleanup(true)
			HomeScene:sharedInstance().energyButton:playHighlightAnim()
			HomeScene:sharedInstance().energyButton:playBubbleSkewAnim()
			HomeScene:sharedInstance().energyButton:updateView()

			if animFinishCallback then
				animFinishCallback()
			end
		end
		local animFinishCallbackAction = CCCallFunc:create(animFinishCallbackFunc)

		-- Seq
		local seq = CCSequence:createWithTwoActions(targetMoveTo, animFinishCallbackAction)
		energyRes:runAction(seq)
	end

	return energyRes
end

-- fly the item icon to the bag button
function HomeScene:createFlyToBagAnimation(propsId, numOfTimes, isGoodsId)

	local scene = Director:sharedDirector():getRunningScene()
	if not scene or scene.isDisposed then 
		scene = HomeScene:sharedInstance() 
	end

	local itemIcon = nil


-- tmp fix
	if isGoodsId then
		local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
		itemIcon = iconBuilder:buildGroup('Goods_'..propsId)
		if not itemIcon then
			itemIcon = iconBuilder:buildGroup('Prop_wenhao')
		end
	else 
		itemIcon = ResourceManager:sharedInstance():buildItemSprite(propsId)
	end

-- end of fix
	itemIcon:setVisible(false)
	scene:addChild(itemIcon)

	itemIcon.playFlyToAnim = function (self, callback)

	---------------------------------------------------------------------------
	-- DO NOT MODIFY unless you know what you're doing
	---------------------------------------------------------------------------
		local flyDuration = 0.8 -- total time to fly from start to bag button
		local fadeDelay = 0.55 -- delay some time and then fade
		local fadeDuration = flyDuration - fadeDelay

		local buttonEnterDuration = 0.5 -- the time of the button scale effect
		local buttonWaitDuration = flyDuration - buttonEnterDuration -- the time that the button waits before scaling

		local flyInterval = 0.2 -- interval between each fly
		local receiveAnimeDuration = flyInterval -- the time to play the bag-receiving animation

		local scale = 1.5
		local smallScale = 1

		if not numOfTimes then numOfTimes = 1 end -- by default: play once
	
		if numOfTimes > 10 then numOfTimes = 10 end -- max 10 times
	-----------------------------------------------------------------------------

		local buttonSize = HomeScene:sharedInstance().hideAndShowBtn:getGroupBounds().size
		local buttonPos = HomeScene:sharedInstance().hideAndShowBtn:getPositionInWorldSpace()

		local button = ResourceManager:sharedInstance():buildGroup('bagButtonIcon')

		local wrapper = button:getChildByName('wrapper')
		local icon = wrapper:getChildByName('icon')
		-- button:setAnchorPoint(ccp(0, 1))
		-- wrapper:setAnchorPoint(ccp(0.5, 0.5))
		icon:setAnchorPoint(ccp(0.5, 0.5))
		icon:setScale(smallScale)
		icon:setOpacity(0)

		local waitDelay = CCDelayTime:create(buttonWaitDuration)

		-- enter animation
		local fadeIn = CCFadeIn:create(buttonEnterDuration)
		local scaleIn = CCScaleTo:create(buttonEnterDuration, scale)
		local a_enter = CCArray:create()
		a_enter:addObject(fadeIn)
		a_enter:addObject(scaleIn)
		local inAnimations = CCEaseExponentialInOut:create(CCSpawn:create(a_enter))

		local function playSoundEffect()
			GamePlayMusicPlayer:playEffect(GameMusicType.kGetRewardProp)	
		end

		-- receive item animation
		local scaleFat = CCEaseSineIn:create(CCScaleTo:create(receiveAnimeDuration*0.3, scale*1.25, scale*0.8))
		local playSound = CCCallFunc:create(playSoundEffect)
		local scaleNormal = CCEaseSineOut:create(CCScaleTo:create(receiveAnimeDuration*0.7, scale, scale))
		local a_receive = CCArray:create()
		a_receive:addObject(scaleFat)
		a_receive:addObject(playSound)
		a_receive:addObject(scaleNormal)
		local rep = CCRepeat:create(CCSequence:create(a_receive), numOfTimes)

		-- exit animation
		local fadeOut = CCFadeOut:create(buttonEnterDuration)
		local scaleOut = CCScaleTo:create(buttonEnterDuration, smallScale)
		local a_exit = CCArray:create()
		a_exit:addObject(fadeOut)
		a_exit:addObject(scaleOut)

		local outAnimations = CCEaseExponentialInOut:create(CCSpawn:create(a_exit))

		local a_buttonAnim = CCArray:create()
		a_buttonAnim:addObject(waitDelay)
		a_buttonAnim:addObject(inAnimations)
		a_buttonAnim:addObject(rep)
		a_buttonAnim:addObject(outAnimations)

		local function removeButton()
			if button then 
				button:removeFromParentAndCleanup(true)
				button = nil
			end
		end
		a_buttonAnim:addObject(CCCallFunc:create(removeButton))

		-- fly animation

		local function createFlyAnimation()

			local res = nil
			--tmp fix
			if isGoodsId then
				local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
				res = iconBuilder:buildGroup('Goods_'..propsId)
				if not res then
					res = iconBuilder:buildGroup('Prop_wenhao')
				end
			else 
				res = ResourceManager:sharedInstance():buildItemSprite(propsId)
			end
			-- res:setAnchorPoint(ccp(0, 1))

			scene:addChild(res)
			
			local iconPos = ccp(itemIcon:getPosition().x, itemIcon:getPosition().y)
			res:setPosition(ccp(iconPos.x, iconPos.y))
			res:setScaleX(itemIcon:getScaleX())
			res:setScaleY(itemIcon:getScaleY())

			local a_flyAnim = CCArray:create()
			local fadeDelay = CCDelayTime:create(fadeDelay)
			local fadeOut = CCFadeTo:create(fadeDuration, 55)
			local flyFadeOut = CCSequence:createWithTwoActions(fadeDelay, fadeOut)
			destPos = ccp(buttonPos.x - 45, buttonPos.y + 100)
			-- local move = HeBezierTo:create(buttonEnterDuration, destPos, false, distance * -0.50)
			local move = CCParabolaMoveTo:create(flyDuration, destPos.x, destPos.y, -4000)
			a_flyAnim:addObject(flyFadeOut)
			a_flyAnim:addObject(move)

			local flyAction = CCEaseSineInOut:create(CCSpawn:create(a_flyAnim))
			local function __cleanup()
				if res then 
					print 'cleanup'
					res:removeFromParentAndCleanup(true)
					res = nil
				end
			end
			local callFunc = CCCallFunc:create(__cleanup)
			local action = CCSequence:createWithTwoActions(flyAction, callFunc)
			res:runAction(action)

		end

		local function removeUI()
			if itemIcon then 
				itemIcon:removeFromParentAndCleanup(true)
				itemIcon = nil
			end
			if callback then 
				callback()
			end
		end
		local remove = CCCallFunc:create(removeUI)	

		local delayAction = CCDelayTime:create(flyInterval)
		local flyAction = CCCallFunc:create(createFlyAnimation)
		
		local a_repeat = CCArray:create()
		for i=1, numOfTimes do 

			local oneTime = CCSequence:createWithTwoActions(flyAction, delayAction)
			a_repeat:addObject(oneTime)
		end
		local repeatFly = CCEaseSineIn:create(CCSequence:create(a_repeat))


		scene:addChild(button)
		button:setPosition(ccp(buttonPos.x + buttonSize.width / 2, buttonPos.y - buttonSize.height / 2))
		icon:runAction(CCSequence:create(a_buttonAnim))

		button:runAction(CCSequence:createWithTwoActions(repeatFly, remove))



	end
	return itemIcon
end

function HomeScene:createFlyingCoinAnim(...)
	assert(#{...} == 0)

	-- Create The UI Resource
	local coinStack = ResourceManager:sharedInstance():buildGroup("stackIcon")

	-- --------------
	-- Get Sub Icon
	-- -------------
	self.subIcons = {}
	local subIcons = self.subIcons

	for index = 1,12 do
		local subIcon = coinStack:getChildByName(tostring(index))
		table.insert(self.subIcons, subIcon)
	end

	--------------------
	-- Get Original Pos
	-- -----------------
	self.coinOriginalPos 	= {}
	local coinOriginalPos	= self.coinOriginalPos
	local numberOfSubCoin	= #self.subIcons

	for index = 1,numberOfSubCoin do
		local posX = self.subIcons[index]:getPositionX()
		local posY = self.subIcons[index]:getPositionY()

		table.insert(self.coinOriginalPos, {x = posX, y = posY})
	end

	----------------------------------------------
	-- Create Corresponding Number Of Home Scene Coin
	-- For Later Used
	-- ----------------------------------------------
	
	local stackCoinSize	= self.subIcons[1]:getGroupBounds().size

	local homeSceneCoins	= {}

	for index = 1, numberOfSubCoin do
		local homeSceneCoin 	= ResourceManager:sharedInstance():buildGroup("homeSceneCoin")

		-- Change Size
		local homeSceneCoinSize	= homeSceneCoin:getGroupBounds().size
		local deltaScaleX	= stackCoinSize.width / homeSceneCoinSize.width
		local deltaScaleY	= stackCoinSize.height / homeSceneCoinSize.height
		homeSceneCoin:setScaleX(deltaScaleX)
		homeSceneCoin:setScaleY(deltaScaleY)

		-- Corresponding Small Coin Pos
		local smallCoinPos	= coinOriginalPos[index]
		homeSceneCoin:setPosition(ccp(smallCoinPos.x, smallCoinPos.y))

		homeSceneCoin:setVisible(false)
		coinStack:addChild(homeSceneCoin)

		table.insert(homeSceneCoins, homeSceneCoin)
	end

	-------------------------------
	-- Set All Coin To One Coin's Pos
	-- ------------------------------
	local targetCoin	= self.subIcons[9]
	local targetCoinPos	= targetCoin:getPosition()

	for index,v in pairs(self.subIcons) do
		v:setPosition(ccp(targetCoinPos.x, targetCoinPos.y))
	end
	local scene = Director:sharedDirector():getRunningScene()
	scene:addChild(coinStack)

	---------------------------------
	-- Get Coin Pos In The Home Scene
	-- -------------------------------
	local coinPosition 	= self.coinButton.coinIcon:getPosition()
	local coinParent	= self.coinButton.coinIcon:getParent()
	-- Convert To World Space
	local coinPosInWorldSpace = coinParent:convertToWorldSpace(ccp(coinPosition.x, coinPosition.y))
	-- Convert To Coin Stack Space
	--local homeSceneCoinPosInCoinStackSpace = coinStack:convertToNodeSpace(coinPosInWorldSpace)

	coinStack.playFlyToAnim = function(self, coinReachedCallback, animFinishCallback, ...)
		assert(self)
		assert(not coinReachedCallback or type(coinReachedCallback) == "function")
		assert(not animFinishCallback or type(animFinishCallback) == "function")
		assert(#{...} == 0)
		
		--------------------------
		-- Play Stack Open Anim
		-- ----------------------

		local coinStackOpenTime = 0.1

		local actionArray = CCArray:create()

		GamePlayMusicPlayer:playEffect(GameMusicType.kGetRewardCoin)

		for index = 1, numberOfSubCoin do

			-- Coin To Move
			local coinToMove	= subIcons[index]
			-- Coin's Origianl Pos
			--local coinOriginalPos	= self.coinOriginalPos[index]
			local originalPos	= coinOriginalPos[index]

			local moveTo 		= CCMoveTo:create(coinStackOpenTime, ccp(originalPos.x, originalPos.y))
			local targetMoveTo	= CCTargetedAction:create(coinToMove.refCocosObj, moveTo)
			local easeMoveTo	= CCEaseBackIn:create(targetMoveTo)

			actionArray:addObject(easeMoveTo)
		end

		local coinStackOpenAction = CCSpawn:create(actionArray)
		assert(coinStackOpenAction)

		--------------------------
		-- Delay After Stack Open
		-- -----------------------
		local delayAfterStackOpen	= CCDelayTime:create(0.5)

		---------------------
		-- Coin Flying Anim
		-- -------------------
		local delayTime 	= 0
		local delayPerCoin	= 0.1
		local moveToTime	= 0.3

		-- Action Array
		local actionArray = CCArray:create()

		-- Each Coin Anim
		for index = 1, 12 do

			local eachCoinActionArray = CCArray:create()

			local subCoin = coinStack:getChildByName(tostring(index))

			-- Delay Action
			local delayTimeAction = CCDelayTime:create(delayTime)
			delayTime = delayTime + delayPerCoin
			eachCoinActionArray:addObject(delayTimeAction)

			-- Replace Small Coin With Big Coin
			local function initMoveToAnimFunc()
				subCoin:setVisible(false)
				homeSceneCoins[index]:setVisible(true)
			end
			local initMoveToAnimAction = CCCallFunc:create(initMoveToAnimFunc)
			eachCoinActionArray:addObject(initMoveToAnimAction)

			-- Move To
			local homeSceneCoinPosInCoinStackSpace = coinStack:convertToNodeSpace(coinPosInWorldSpace)
			--local moveTo		= CCMoveTo:create(moveToTime, ccp(homeSceneCoinPosInCoinStackSpace.x, homeSceneCoinPosInCoinStackSpace.y))
			local curPos		= homeSceneCoins[index]:getPosition()
			local distance		= ccpDistance(ccp(homeSceneCoinPosInCoinStackSpace.x, homeSceneCoinPosInCoinStackSpace.y), curPos)
			local bezierTo		= HeBezierTo:create(moveToTime, ccp(homeSceneCoinPosInCoinStackSpace.x, homeSceneCoinPosInCoinStackSpace.y), false, distance * 0.05)
			local targetMoveTo	= CCTargetedAction:create(homeSceneCoins[index].refCocosObj, bezierTo)
			-- ScaleTo
			local scaleTo		= CCScaleTo:create(moveToTime, 1, 1)
			local targetScaleTo	= CCTargetedAction:create(homeSceneCoins[index].refCocosObj, scaleTo)

			local moveToAndScale	= CCSpawn:createWithTwoActions(targetMoveTo, targetScaleTo)
			eachCoinActionArray:addObject(moveToAndScale)

			-- Coin Reached Callback
			local function coinReachedCallbackFunc()
				HomeScene:sharedInstance().coinButton:playHighlightAnim()
				
				homeSceneCoins[index]:setVisible(false)

				if index == 12 then
					HomeScene:sharedInstance().coinButton:playBubbleSkewAnim()
				end

				if coinReachedCallback then
					coinReachedCallback(index)
				end
			end
			local coinReachedCallbackAction = CCCallFunc:create(coinReachedCallbackFunc)
			eachCoinActionArray:addObject(coinReachedCallbackAction)
			
			-- Seq
			local seq = CCSequence:create(eachCoinActionArray)
			
			actionArray:addObject(seq)
		end

		-- Coin Actin
		local coinActionSpawn = CCSpawn:create(actionArray)

		-- ---------------------
		-- Anim Finish Callback
		-- ---------------------
		local function animFinishCallbackFunc()
			self:removeFromParentAndCleanup(true)

			HomeScene:sharedInstance().coinButton:updateView()

			if animFinishCallback then
				animFinishCallback()
			end
		end
		local animFinishAction = CCCallFunc:create(animFinishCallbackFunc)

		-- Seq
		local openWaitAndFlyAcitonArray = CCArray:create()
		openWaitAndFlyAcitonArray:addObject(coinStackOpenAction)
		openWaitAndFlyAcitonArray:addObject(delayAfterStackOpen)
		openWaitAndFlyAcitonArray:addObject(coinActionSpawn)
		openWaitAndFlyAcitonArray:addObject(animFinishAction)
		
		local seq = CCSequence:create(openWaitAndFlyAcitonArray)
		self:runAction(seq)
	end

	return coinStack
end

function HomeScene:createFlyingGoldAnim(...)
	assert(#{...} == 0)

	local layer = CocosObject:create()
	local goldList = {}
	for i = 1, 10 do
		local gold = ResourceManager:sharedInstance():buildGroup("homeSceneGold")
		gold:setScale(0.7)
		gold:setVisible(false)
		layer:addChild(gold)
		table.insert(goldList, gold)
	end
	self:addChild(layer)

	local goldPosition 	= self.goldButton.goldIcon:getPosition()
	local goldParent	= self.goldButton.goldIcon:getParent()
	local worldPos = goldParent:convertToWorldSpace(ccp(goldPosition.x, goldPosition.y))

	layer.playFlyToAnim = function(self, coinReachedCallback, animFinishCallback, ...)
		assert(self)
		assert(not coinReachedCallback or type(coinReachedCallback) == "function")
		assert(not animFinishCallback or type(animFinishCallback) == "function")
		assert(#{...} == 0)

		local dstPos = layer:convertToNodeSpace(worldPos)

		local delayTime 	= 0
		local delayPerCoin	= 0.1
		local moveToTime	= 0.3
		for k, v in ipairs(goldList) do
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(delayPerCoin * (k - 1)))
			array:addObject(CCToggleVisibility:create())
			local curPos = v:getPosition()
			local distance = ccpDistance(ccp(dstPos.x, dstPos.y), curPos)
			array:addObject(HeBezierTo:create(moveToTime, ccp(dstPos.x, dstPos.y), false, distance * 0.05))
			array:addObject(CCToggleVisibility:create())
			local function onReach()
				goldList[1]:removeFromParentAndCleanup(true)
				table.remove(goldList, 1)
				local home = HomeScene:sharedInstance()
				if home.goldButton and not home.goldButton.isDisposed then home.goldButton:playHighlightAnim() end
				if coinReachedCallback then coinReachedCallback() end
				if #goldList <= 0 then
					if home.goldButton and not home.goldButton.isDisposed then home.goldButton:updateView() end
					if animFinishCallback then animFinishCallback() end
				end
			end
			array:addObject(CCCallFunc:create(onReach))
			v:runAction(CCSequence:create(array))
		end
	end

	return layer
end

function HomeScene:create( ...)
	assert(#{...} == 0)
	return self:sharedInstance()
end

function HomeScene:startLadyBug(panelCloseCallback, ...)
	assert(#{...} == 0)

	if not self.ladybugButton then
		self.ladybugButton	= LadybugButton:create()
		self.leftRegionLayoutBar:addItem(self.ladybugButton)
	end
	self.ladybugButton:setVisible(false)

	local placeholderPanel = CocosObject:create()
	placeholderPanel.popoutShowTransition = function ( ... )
		if not self.ladybugButton then 
			PopoutManager.sharedInstance():remove(placeholderPanel)
			return
		end

		-- Color Layer TO Block The Input
		local visibleOrigin 	= CCDirector:sharedDirector():getVisibleOrigin()
		local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
		
		local colorLayerToBlockInput = LayerColor:create()
		colorLayerToBlockInput:setColor(ccc3(255,0,0))
		colorLayerToBlockInput:setOpacity(0)
		colorLayerToBlockInput:changeWidthAndHeight(visibleSize.width, visibleSize.height)
		colorLayerToBlockInput:setTouchEnabled(true, 0, true)
		self:addChild(colorLayerToBlockInput)

		colorLayerToBlockInput:setPosition(ccp(visibleOrigin.x, visibleOrigin.y))


		-- -----------------------------------
		-- Create The Lady Bug Button 
		-- ------------------------------------
		local function onLadyBugBtnTapped()
			print("onLadyBugBtnTapped Called !")
			if PopoutManager:sharedInstance():haveWindowOnScreen() then return end
			self:popoutLadyBugPanel()
		end

		self.ladybugButton.wrapper:addEventListener(DisplayEvents.kTouchTap, onLadyBugBtnTapped)

		-- Get The Lady Bug Anim Button Pos
		-- In World Pos
		local ladybugBtnPos 		= self.ladybugButton:getPosition()
		local ladybugBtnParent 		= self.ladybugButton:getParent()
		local ladybugBtnPosInWorldSpace	= ladybugBtnParent:convertToWorldSpace(ccp(ladybugBtnPos.x, ladybugBtnPos.y))
		local ladybugBtnSize		= self.ladybugButton.wrapper:getGroupBounds().size
		ladybugBtnSize		= {width = ladybugBtnSize.width, height = ladybugBtnSize.height}

		-----------------------------------
		-- Create The lady Bug Flying Animation
		-- ---------------------------------
		self.ladyBugOnScreen = true
		local ladyBugFlyInAnim	= LadybugTaskAnimation:create(true)

		--local function on lady bug fly out callback
		local function onLadyBugFlyOutCallback()

			colorLayerToBlockInput:removeFromParentAndCleanup(true)
			ladyBugFlyInAnim:removeFromParentAndCleanup(true)
			self.ladyBugOnScreen = nil
			self.ladybugButton:setVisible(true)
			local function firstTimePopoutLadyBug()
				local ladyBugPanel = self:popoutLadyBugPanel(true, panelCloseCallback)

				ladyBugPanel:addEventListener(PopoutEvents.kRemoveOnce,function( ... )
					PopoutManager.sharedInstance():remove(placeholderPanel)
				end)
			end
			setTimeOut(firstTimePopoutLadyBug, 1)

		end
		ladyBugFlyInAnim:setFlyOutFinishCallback(onLadyBugFlyOutCallback)
		self:addChild(ladyBugFlyInAnim)

		ladyBugFlyInAnim:setPosition(ccp(ladybugBtnPosInWorldSpace.x + ladybugBtnSize.width/2, ladybugBtnPosInWorldSpace.y - ladybugBtnSize.height/2))
		ladyBugFlyInAnim:flyIn()
	end

	self:runAction(CCCallFunc:create(function( ... )
		PopoutQueue.sharedInstance():push(placeholderPanel, false, true)
	end))
end

local bootSourceCheck = false

-- local enterAnimationPlayed = false

function HomeScene:onEnterHandler(event, ...)
	print('thisdebug onEnterHandler ' .. event)
	assert(event)
	assert(#{...} == 0)


	if event == "enter" then
		--尝试自动打开客服
		self:tryToShowFunsClub()

		if WorldSceneShowManager:getInstance():isInAcitivtyTime() then 
			if not WorldSceneShowManager:getHasPlaySpringMusic() then 
				WorldSceneShowManager:setHasPlaySpringMusic(true)
			else
				GamePlayMusicPlayer:getInstance():playWorldSceneBgMusic()
			end
		else
			GamePlayMusicPlayer:getInstance():playWorldSceneBgMusic()
		end

		if not self.isInited then
			-- 掩藏关领奖
			local rewardBranchId = MetaModel:sharedInstance():getRewardGuideHiddenBranchId()
			if rewardBranchId then
				self.worldScene:scrollToBranch(rewardBranchId)
			else
				local guideBranchId = MetaModel:sharedInstance():getNeedGuideHiddenBranchId()
				if guideBranchId then
					self.worldScene:scrollToBranch(guideBranchId,function( ... )
						local panel = HiddenBranchIntroductionPanel:create("hide_stage_tips5")
						PopoutQueue:sharedInstance():push(panel)
					end)
					DcUtil:UserTrack({ category="hide", sub_category="remind_hide_stage" })
				else
					-- 新版本更新掩藏关
					local newBranchId = MetaModel:sharedInstance():getNewGuideHiddenBranchId()
					if newBranchId then
						self.worldScene:scrollToBranch(newBranchId)
					else
						self.worldScene:playOnEnterCenterUserPosAnim()
					end
				end
			end

			self:popoutWdjRewardPanelIfNecessary()
		end

		-- Beginner Panel
		local user = UserManager:getInstance():getUserRef()
		if user:getTopLevelId() == 1 and UserManager:getInstance().userExtend:getNewUserReward() == 0 then
			local panel = BeginnerPanel:create()
			if panel then
				panel:popout()
			end
		end



		-- 初始化任务系统
		if UserManager:getInstance():getUserRef():getTopLevelId() >= 62 then
			if MaintenanceManager:getInstance():isEnabled("DaliyMission") then
				MissionLogic:getInstance()
			end
		end

		-- 签到按钮
		if not self.markButton and not PrepackageUtil:isPreNoNetWork() and not NewVersionUtil:hasSJReward() then
			self:buildMarkButton() -- markButton may be created
		end
		
		-- --------------------
		-- ---- Fruit Tree Panel Button
		-- --------------------
		if not PrepackageUtil:isPreNoNetWork() then
			self:createAndShowFruitTreeButton()
		end

		if not self.timeLimitButton and (__ANDROID or __WIN32) then
			self:buildTimeLimitButtonIfNecessary()
		end

		self:buildActivityButton()

		if GameGuide then
			GameGuide:sharedInstance():onEnterWorldMap(self)
		end

		-- if RabbitWeeklyManager:sharedInstance():isLevelReached() then
		-- 	if self.rabbitWeeklyButton == nil then
		--  		self:createRabbitWeeklyButton()
		-- 	else
		-- 		self.rabbitWeeklyButton:update()
		-- 	end
		-- end

		if SeasonWeeklyRaceManager:getInstance():isLevelReached() then
			if self.summerWeeklyButton == nil then
 				self:createSummerWeeklyButton()
			else
				self.summerWeeklyButton:update()
			end
		end

		-- --兔子周赛免费次数获得tips
		-- RabbitWeeklyManager:sharedInstance():showGetFreeTimeTip()

		self:updateFriends()

		if not bootSourceCheck then
			-- local sdk = UrlSchemeSDK.new()
			-- local launchURL = sdk:getCurrentURL()
			self:onApplicationHandleOpenURL(_G.launchURL)
			bootSourceCheck = true
		end

		-- 提审IOS计费点用的面板 屏蔽掉入口 如果以后再用可以直接解注释并修改配置
		-- if __IOS and MaintenanceManager:getInstance():isEnabled("AppleVerification") and not self.applePaycodeButton then
		-- 	self.applePaycodeButton = ApplePaycodeButton:create()
		-- 	self.applePaycodeButton.wrapper:addEventListener(DisplayEvents.kTouchTap, function()
		-- 			ApplePaycodePanel:create():popout()
		-- 		end)
		-- 	self.rightRegionLayoutBar:addItem(self.applePaycodeButton)
		-- end

		-- 更新按钮
		self:buildUpdateVersionPanel()
		-- 检查是不是可以弹领取奖励
		-- UpdateSuccessPanel.popoutIfNecessary()

		-- if not self.isInited then
		-- 	self:buildThanksgivingActivityButton()
		-- end

		-- push activity
		-- if not self.isInited then
		-- 	local function onGetList(info)
		-- 		if info then
		-- 			local data = ActivityData.new(info)
		-- 			data:start(false)
		-- 		end
		-- 	end
		-- 	PushActivity:sharedInstance():onComeToFront(onGetList)
		-- end
		PushActivity:sharedInstance():setForeGroundTimeStamp()
		local function onGetList(info)
			if info then
				local data = ActivityData.new(info)
				data:start(false)
			end
		end
		PushActivity:sharedInstance():onEnterHomeScene(onGetList)

		if __IOS then
			IosPayment:showOutSideComplete()
		end

		if (__IOS or __WIN32) and not self.isInited then
			IosPayGuide:init()
		end

		if (__ANDROID or __WIN32) then
			if not self.isInited then 
				AndroidSalesManager.getInstance()
			else
				if AndroidSalesManager.getInstance():shouldTriggerAndroidSales() then 
					local function triggerSucc()
						 AndroidSalesManager.getInstance():showAndroidSalesPromotion()
					end
					AndroidSalesManager.getInstance():triggerSalesPromotion(AndroidSalesPromotionLocation.kNormal, triggerSucc)
				end
			end
		end
		
		if QQLoginReward:shouldGetReward() then
            QQLoginReward:receiveReward()
        end

        if not self.isInited then
        	FreegiftManager:sharedInstance():update(false, nil)
        end

        -- 支付宝免密减免活动
        if not self.isInited and (__ANDROID or __WIN32) then
        	AliQuickPayPromoLogic:initConfig()
        	if AliQuickPayPromoLogic:isEntryEnabled() then
	        	if not self.aliKfPromoButton then
	        		local function removeButton()
				        if self.aliKfPromoButton and not self.aliKfPromoButton.isDisposed then
				            if self.rightRegionLayoutBar:containsItem(self.aliKfPromoButton) then
				                self.rightRegionLayoutBar:removeItem(self.aliKfPromoButton)
				                self.aliKfPromoButton = nil
				            end
				        end
	        		end
	        		if not AliQuickPayPromoLogic:isInPromotion() then
	        			AliQuickPayPromoLogic:startPromotion()
	        		end
		        	self.aliKfPromoButton = AliKfPromoButton:create()
		        	self.rightRegionLayoutBar:addItem(self.aliKfPromoButton)
		        	local function onAliKfPromoButtonTapped(isForcePop)
		        		require 'zoo.panel.AliQuickPayPromoPanel'
		        		local panel = AliQuickPayPromoPanel:create(removeButton)
		        		panel:popout()
		        		if not isForcePop and self.aliKfPromoButton then
		        			self.aliKfPromoButton:stopOnlyIconAnim()
		        		end

		        		if isForcePop then
		        			AliQuickPayPromoLogic:setForcePopValue(true)
		        		end


		        		local t1 = 2
		        		if isForcePop == true then t1 = 1 end
		        		local t2 = 0
		        		local defaultPayment = PaymentManager:getInstance():getDefaultPayment()
					    if defaultPayment == Payments.WECHAT then
					        t2 = 2
					    elseif defaultPayment == Payments.ALIPAY then
					        t2 = 1
					    elseif PaymentManager:checkPaymentTypeIsSms(defaultPayment) then
					        t2 = 0
					    else
					    	t2 = 3
					    end
	        			DcUtil:UserTrack({category = 'alipay_mm_299_event', sub_category = '1fen_panel', t1 = t1, t2 = t2})

		        	end
		        	self.aliKfPromoButton.wrapper:ad(DisplayEvents.kTouchTap, onAliKfPromoButtonTapped)
		        	if AliQuickPayPromoLogic:isForcePopEnabled() then
		        		onAliKfPromoButtonTapped(true)
		        	end
		        end
		    end
        end

		--强弹
		if not self.isInited then 
			self:addChild(kHomeScenePopoutNode)
			self:autoPopoutPanel("enter")
			self:autoPopoutActivity("enter")
		end
		
		-- if (not PlatformConfig:isQQPlatform()) then 
		-- 	self:starButtonLadybugPrompt()
		-- end 

		self.isInited = true

		SupperAppManager:checkData()
	end
end

-- 瓢虫在StarButton的提示动画
function HomeScene:starButtonLadybugPrompt()
	-- 延时一段时间，先让其他动画飞完
	setTimeOut(function() 
		if (self.starButton and (not PopoutManager:sharedInstance():haveWindowOnScreen()) )  then
			local hasReward,rewardElapse,rewardMeta = self.starButton:hasStarReward()
			print("starButtonLadybugPrompt",hasReward,rewardElapse,rewardMeta)

			if (rewardMeta) then
				-- 一个阶段只弹出一回动画
				local hasPlay = CCUserDefault:sharedUserDefault():getBoolForKey("star.reward.ladybug"..rewardMeta.starNum)

				-- 领奖差距在10颗星星以内
				if (not hasReward and rewardElapse < 0 and rewardElapse > -10) then
					if (not hasPlay) then
						self:playLadyBugAnimation(rewardElapse,rewardMeta)

						if (rewardMeta) then 
							CCUserDefault:sharedUserDefault():setBoolForKey("star.reward.ladybug"..rewardMeta.starNum, true)
			  		     	CCUserDefault:sharedUserDefault():flush()
						end
					end
				end 
			end
		end
	end , 0)
end

-- 差额
-- 奖励meta
function HomeScene:playLadyBugAnimation(rewardElapse,rewardMeta)

	local need = math.abs(rewardElapse)

	local scene = HomeScene:sharedInstance()
	local ax,ay = self.starButton:getPositionX()+360,self.starButton:getPositionY()-480

	FrameLoader:loadArmature("skeleton/ladybug_fly_tostar")
	local node = ArmatureNode:create("ladybug")
	node:setPosition(ccp(ax,ay))
	node:playByIndex(0, 1)
	scene:addChild(node)
	
	-- local function animationCallback( ... )

	-- 	local function popoutPanel()
	-- 		local panel = LadybugPromptPanel:create(need,rewardMeta)
	-- 		panel:popout()

	-- 		-- 弹窗关闭后，播放第二段动画
	-- 		local function onTouchEvent( evt )
	-- 			if evt.name == DisplayEvents.kTouchTap then

	-- 				if (node1AnimationCompete) then
	-- 					panel:onCloseBtnTapped()

	-- 					node:removeFromParentAndCleanup()
	-- 					local node2 = ArmatureNode:create("ladybug2")
	-- 					node2:setPosition(ccp(ax,ay))
	-- 					node2:playByIndex(0, 1)
	-- 					scene:addChild(node2)

	-- 					local function animation2Callback(...)
	-- 						node2:removeFromParentAndCleanup()
	-- 						self.starButton:playEntireHighlightAnim()
	-- 					end

	-- 					node2:addEventListener(ArmatureEvents.COMPLETE, animation2Callback)
	-- 				else
	-- 					print("~~~~~~~~~laiya laiya ~~~~~~~~~~")
	-- 				end


	-- 			end
	-- 		end

	-- 		panel.bg:ad(DisplayEvents.kTouchTap, onTouchEvent)
	-- 	end
	-- 	AsyncLoader:getInstance():waitingForLoadComplete(popoutPanel)
	-- end
	
	-- node:addEventListener(ArmatureEvents.COMPLETE, animationCallback)

	-- 在最上层添加遮罩，使全屏幕都不可以点击
	local node1AnimationCompete = false
	local panel = LadybugPromptPanel:create(need,rewardMeta)

	local function nodeAnimationComplete()
		node1AnimationCompete = true
		panel:setVisible(true)
	end

	-- test
	local function popoutPanel()
		panel:popout()
		panel:setVisible(false)

		-- 弹窗关闭后，播放第二段动画
		local function onTouchEvent( evt )
			if evt.name == DisplayEvents.kTouchTap then

				if (node1AnimationCompete) then
					panel:onCloseBtnTapped()

					node:removeFromParentAndCleanup()
					local node2 = ArmatureNode:create("ladybug2")
					node2:setPosition(ccp(ax,ay))
					node2:playByIndex(0, 1)
					scene:addChild(node2)

					local function animation2Callback(...)
						node2:removeFromParentAndCleanup()
						self.starButton:playEntireHighlightAnim()
					end

					node2:addEventListener(ArmatureEvents.COMPLETE, animation2Callback)
				else
					print("~~~~~~~~~ as mask: you ben shi ni dian wo ya  ~~~~~~~~~~")
				end
			end
		end

		panel.bg:ad(DisplayEvents.kTouchTap, onTouchEvent)
	end

	node:addEventListener(ArmatureEvents.COMPLETE, nodeAnimationComplete)
	AsyncLoader:getInstance():waitingForLoadComplete(popoutPanel)
	-- test end
end












function HomeScene:autoPopoutPanel(eventName)

	-- 登录提示
	if not HomeScenePopoutQueue:has(LoginSuccessPopoutAction) then
		HomeScenePopoutQueue:insert(LoginSuccessPopoutAction.new():placeholder():fixed())
	end

	-- 补偿
	HomeScenePopoutQueue:insert(GivebackPopoutAction.new())

	-- 签到
	if self.markButton and RequireNetworkAlert:popout(nil, kRequireNetworkAlertAnimation.kNoAnimation) then
		HomeScenePopoutQueue:insert(MarkPanelPopoutAction.new())
	else
		HomeScenePopoutQueue:insert(MarkPanelPopoutAction.new():placeholder())
	end

	HomeScenePopoutQueue:insert(MissionPanelPopoutAction.new())

	-- 推送召回
	local function popoutCallback()
		self.recallOnce = true
	end
	local recallState = RecallManager.getInstance():getFinalRewardState()
	if self.recallOnce or recallState == RecallRewardType.NO_REWARD then 
		HomeScenePopoutQueue:insert(RecallPopoutAction.new():placeholder())
	else
		HomeScenePopoutQueue:insert(RecallPopoutAction.new(recallState, popoutCallback))
	end

	-- 瓢虫任务
	HomeScenePopoutQueue:insert(LadyBugPanelPopoutAction.new())	

	-- 大包or动更
	if self.updateVersionButton and NewVersionUtil:hasNewVersion() then
		local updateInfo = UserManager.getInstance().updateInfo
		local curTips = updateInfo.tips
		if CCUserDefault:sharedUserDefault():getStringForKey("game.updateInfo.tips") ~= curTips then 
			local function popoutCallback( ... )
				CCUserDefault:sharedUserDefault():setStringForKey("game.updateInfo.tips",curTips)
				NewVersionUtil:cacheUpdateInfo()
				CCUserDefault:sharedUserDefault():flush()
			end

			if NewVersionUtil:hasPackageUpdate() then
				HomeScenePopoutQueue:insert(UpdatePackagePopoutAction.new(self.updateVersionButton,popoutCallback))
			elseif NewVersionUtil:hasDynamicUpdate() then
				HomeScenePopoutQueue:insert(UpdateDynamicPopoutAction.new(self.updateVersionButton,popoutCallback))				
			end
		end
	end
	if not HomeScenePopoutQueue:has(UpdatePackagePopoutAction) then
		HomeScenePopoutQueue:insert(UpdatePackagePopoutAction.new():placeholder())
	end
	if not HomeScenePopoutQueue:has(UpdateDynamicPopoutAction) then
		HomeScenePopoutQueue:insert(UpdateDynamicPopoutAction.new():placeholder())
	end

	-- 更新领奖
	if UpdateSuccessPanel.canPopout() then
		HomeScenePopoutQueue:insert(UpdateSuccessPopoutAction.new())
	else
		HomeScenePopoutQueue:insert(UpdateSuccessPopoutAction.new():placeholder())			
	end
	-- 
	HomeScenePopoutQueue:printQueueLog()

end

function HomeScene:autoPopoutActivity( eventName )
	if (MaintenanceManager:getInstance():isEnabled("Activity") or __WIN32 or __ANDROID) and not _G.disableActivity then
		HomeScenePopoutQueue:insert(ActivityPopoutAction.new())
	else
		HomeScenePopoutQueue:insert(ActivityPopoutAction.new():placeholder())
	end

	HomeScenePopoutQueue:printQueueLog()
end

function HomeScene:autoPopoutUrl( launchURL )
	self.hasCallAutoPopoutUrl = true
	local res = UrlParser:parseUrlScheme(launchURL or "")
	local dcType = nil
	local dcFrom = nil

	if res.method and res.para then
		print(table.tostring(res))

		dcFrom = tonumber(res.para.from)

		if res.method == "open_activity" then
			local actId = tonumber(res.para.actId)
			HomeScenePopoutQueue:remove(OpenActivityPopoutAction)
			HomeScenePopoutQueue:insert(OpenActivityPopoutAction.new(actId))
			dcType="c"
		end

		if res.method == "open_binding" then
			local url = res.para.url
			if url then
				url = HeDisplayUtil:urlDecode(url)
			end
			HomeScenePopoutQueue:remove(OpenBindingPopoutAction)
			HomeScenePopoutQueue:insert(OpenBindingPopoutAction.new(url))
			dcType="d"
		end

		if res.method == "open_level" then
			local levelId = tonumber(res.para.levelId)
			HomeScenePopoutQueue:remove(OpenLevelPopoutAction)
			HomeScenePopoutQueue:insert(OpenLevelPopoutAction.new(levelId))
			dcType="a"
		end

		if res.method == "open_cdkey" then
			HomeScenePopoutQueue:remove(OpenCDKeyPanelPopoutAction)
			HomeScenePopoutQueue:insert(OpenCDKeyPanelPopoutAction.new())
			dcType="b"
		end
	end

	if dcType then 
		DcUtil:UserTrack({ category="panelpopup",sub_category="link_into_game",id=dcFrom,type=dcType })
	end

	if not HomeScenePopoutQueue:has(OpenActivityPopoutAction) then
		HomeScenePopoutQueue:insert(OpenActivityPopoutAction.new():placeholder())
	end
	if not HomeScenePopoutQueue:has(OpenBindingPopoutAction) then
		HomeScenePopoutQueue:insert(OpenBindingPopoutAction.new():placeholder())
	end
	if not HomeScenePopoutQueue:has(OpenLevelPopoutAction) then
		HomeScenePopoutQueue:insert(OpenLevelPopoutAction.new():placeholder())
	end
	if not HomeScenePopoutQueue:has(OpenCDKeyPanelPopoutAction) then
		HomeScenePopoutQueue:insert(OpenCDKeyPanelPopoutAction.new():placeholder())
	end

	HomeScenePopoutQueue:printQueueLog()
end


function HomeScene:updateFriends(...)
	assert(#{...} == 0)

	if not self.updateFriendsCalled then
		self.updateFriendsCalled = true

		DcUtil:up(150)
	end

	local function onSendFriendSuccess()
		self:updateInviteBtnPosition()
		self.worldScene:buildFriendPicture()
		self:dcUserInfo()
	end

	self.worldScene:sendFriendHttp(onSendFriendSuccess)
end

function HomeScene:getPositionByLevel(level)
	local node = self.worldScene.levelToNode[level]
	return node:getPosition()
end

function HomeScene:updateLadyBugBtnTimeLabel(timeString, ...)
	assert(type(timeString) == "string")
	assert(#{...} == 0)
	
	if self.ladybugButton then
		self.ladybugButton:setTimeLabelString(timeString)
	end
end

local function scheduleLocalNotification()
	local enable = CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification")
	local fullEnergyTime = UserService:getInstance():computeFullEnergyTime()
	--print("enable"..tostring(enable)..fullEnergyTime)
	if enable and fullEnergyTime > 0 then
		local body = Localization:getInstance():getText("message.center.notif.goback")
		local action = Localization:getInstance():getText("message.center.notif.back.btn")

		if __IOS then			
			WeChatProxy:scheduleLocalNotification_alertBody_alertAction(fullEnergyTime, body, action)
		end
		if __ANDROID then
			if PrepackageUtil:isPreNoNetWork() then return end
			local notificationUtil = luajava.bindClass("com.happyelements.hellolua.share.NotificationUtil")
			notificationUtil:addLocalNotification(fullEnergyTime, body, tostring(LocalNotificationType.kEnergyFull))
		end
		if __WP8 then
			Wp8Utils:scheduleLocalNotification(fullEnergyTime, action, body)
		end
	end

	RecallManager.getInstance():updateRecallInfo()
	LocalNotificationManager.getInstance():pocessRecallNotification()
	LocalNotificationManager.getInstance():validateNotificationTime()
	LocalNotificationManager.getInstance():pushAllNotifications()
end

function HomeScene:onKeyBackClicked(...)
	assert(#{...} == 0)
	print("HomeScene:onKeyBackClicked Called !")
  
	if __WP8 then
		if self.exitDialog then return end
		self.exitDialog = true
		local function msgCallback(r)
			if r then 
				Director.sharedDirector():exitGame()
			else
				self.exitDialog = false
			end
		end
		Wp8Utils:ShowMessageBox(Localization:getInstance():getText("game.exit.tip"), "", msgCallback)
		return
	end

	local function callPaymentExit(paymentClass)
        if paymentClass then
            local function buildCallback(onExit, onCancel)
                return luajava.createProxy("com.happyelements.android.InvokeCallback", {
                    onSuccess = onExit or function(result) end,
                    onError = onError or function(errCode, msg) end,
                    onCancel = onCancel or function() end
                })
            end
            local exitCallback = buildCallback(
                function(obj)
                    Director.sharedDirector():exitGame()
                end,
                function()
                    self.exitDialog = false
                end
            )
            self.exitDialog = true
            paymentClass:exitGame(exitCallback)
        end
    end

	local pfName = StartupConfig:getInstance():getPlatformName()
	if PlatformConfig:isBaiduPlatform() then
		local dUOKUProxy = luajava.bindClass("com.happyelements.hellolua.duoku.DUOKUProxy"):getInstance()
		if dUOKUProxy then
			dUOKUProxy:detectDKGameExit()
		end
	elseif PlatformConfig:isPlatform(PlatformNameEnum.kCMGame) then
        local cmgamePayment = luajava.bindClass("com.happyelements.android.operatorpayment.cmgame.CMGamePayment")
        callPaymentExit(cmgamePayment)
    elseif PlatformConfig:isPlatform(PlatformNameEnum.k189Store) then
        local telecomPayment = luajava.bindClass("com.happyelements.android.operatorpayment.telecom.TelecomPayment")
        callPaymentExit(telecomPayment)
    else
		if self.exitDialog then return end
		local function buildCallback(onSuccess, onError, onCancel)
		  return luajava.createProxy("com.happyelements.android.InvokeCallback", {
		        onSuccess = onSuccess or function(result) end,
		        onError = onError or function(errCode, msg) end,
		        onCancel = onCancel or function() end
		    })
		end

		local snsCallback = buildCallback(
	  	    function(obj)
	            print("Info - Keypad Callback: sns onSuccess")
	            scheduleLocalNotification()
	            CCDirector:sharedDirector():endToLua()
	        end
	        ,
	        function(errorCode, errExtra)
	            print("Info - Keypad Callback: sns onError")
	            self.exitDialog = false
	            PushActivity:sharedInstance():setPushActivityEnabled(true)
	    	end
	        ,
	        function() 
	            print("Info - Keypad Callback: sns onCancel")
	            self.exitDialog = false
	            PushActivity:sharedInstance():setPushActivityEnabled(true)
	        end
	    )
		local dialogUtil = luajava.bindClass("com.happyelements.android.utils.DialogUtil")
		PushActivity:sharedInstance():setPushActivityEnabled(false)
		self.exitDialog = true
	  	dialogUtil:alertDialog(
	  		Localization:getInstance():getText("game.exit.tip"),
	  		Localization:getInstance():getText("game.exit.yes"),
	  		Localization:getInstance():getText("game.exit.no"),
	  		snsCallback)
	end
end


function HomeScene:tryPopoutMarkPanel(isClick, closeCallback)
	if not self.markButton or self.markButton.isDisposed then
		return nil
	end
	local btnPos 		= self.markButton:getPosition()
	local btnParent		= self.markButton:getParent()
	local btnPosInWorldPos	= btnParent:convertToWorldSpace(ccp(btnPos.x, btnPos.y))

	local btnSize		= self.markButton.wrapper:getGroupBounds().size
	btnPosInWorldPos.x = btnPosInWorldPos.x + btnSize.width / 2
	btnPosInWorldPos.y = btnPosInWorldPos.y - btnSize.height / 2

	local function stopMarkAnim()
		self.markButton:stopHasSignAnimation()
	end

	local function localCloseCallback()
		if self.markButton and self.rightRegionLayoutBar:containsItem(self.markButton)
		and HomeSceneButtonsManager.getInstance():getMarkButtonShowState() then 
			HomeSceneButtonsManager.getInstance():flyToBtnGroupBar(HomeSceneButtonType.kMark, self.markButton, function ()
				if not self.markButton then return end
				self.markButton:setVisible(false)
				self.markButton.wrapper:setTouchEnabled(false)
				self.hideAndShowBtn:setEnable(false)
			end,function ()
				if not self.markButton then 
					HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMark, true)
					return 
				end
				self.hideAndShowBtn:playAni(function ()
					self.hideAndShowBtn:setEnable(true)
					HomeSceneButtonsManager.getInstance():showButtonHideTutor()
				end)
				self.rightRegionLayoutBar:removeItem(self.markButton)
				self.markButton:removeAllEventListeners()
				self.markButton:dispose()
				self.markButton = nil
				HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMark, true)
			end)
		end
		if closeCallback then
			closeCallback()
		end
	end

	local dayTime = 3600 * 24 * 1000
	local curDay = math.floor(Localhost:time() / dayTime)
	self.lastMark = self.lastMark or 0
	if isClick or self.lastMark < curDay then
		local markModel = MarkModel:getInstance()
		markModel:calculateSignInfo()

		if markModel.canSign then
			self.markButton:playHasSignAnimation()
		else 
			self.markButton:stopHasSignAnimation() 
		end

		if isClick or markModel.canSign then
			local panel = MarkPanel:create(btnPosInWorldPos)
			panel:setMarkCallback(stopMarkAnim)
			panel:setCloseCallback(localCloseCallback)
			panel:popout()
			self.lastMark = curDay
			return panel
		end
	end
	return nil
end

function HomeScene:buildMarkButton()
	if UserManager.getInstance().user:getTopLevelId() > 7 then 
		if HomeSceneButtonsManager.getInstance():getMarkButtonShowState() then 
			if self.markButton then 
				if self.rightRegionLayoutBar:containsItem(self.markButton) then 
					self.rightRegionLayoutBar:removeItem(self.markButton)
				end
				self.markButton:removeAllEventListeners()
				self.markButton:dispose()
				self.markButton = nil
			end
			HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMark, true)
		else
			HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kMark, false)

			local function markBtnClick(evt)
				self:tryPopoutMarkPanel(false)
			end
			local function onMarkButtonTapped(evt)
				DcUtil:iconClick("click_sign_icon")
				self:tryPopoutMarkPanel(true)
			end

			if not self.markButton then 
				local markButton = MarkButton:create()
				if not markButton then print("error building mark button!") return end
				markButton:setTipPosition(IconButtonBasePos.LEFT)
				self.rightRegionLayoutBar:addItem(markButton)
				markButton.wrapper:ad(DisplayEvents.kTouchTap, onMarkButtonTapped)
				markButton.click = markBtnClick
				self.markButton = markButton
			end
		end
	end
end

function HomeScene:buildTimeLimitButtonIfNecessary( ... )
	if not TimeLimitData:getInstance():hasIngameBuyItem() and TimeLimitData:getInstance():hasOutgameBuyItem() then 
		TimeLimitData:getInstance():writeLimitTime()
	end

	if TimeLimitData:getInstance():hasIngameBuyItem() or TimeLimitData:getInstance():hasOutgameBuyItem() then

		local leftTime = TimeLimitData:getInstance():getLeftTime()
		if leftTime.hour > 0 or leftTime.min > 0 or leftTime.sec > 0 then
			self:buildTimeLimitButton()
		end

	end
end

function HomeScene:buildTimeLimitButton( ... )
	
	if self.timeLimitButton then 
		return 
	end

	self.timeLimitButton = TimeLimitButton:create()
	self.rightRegionLayoutBar:addItem(self.timeLimitButton)

	self.timeLimitButton.remove = function ( ... )
		self.rightRegionLayoutBar:removeItem(self.timeLimitButton,true)
		self.timeLimitButton = nil
	end

	local function popout( ... )
		local bounds = self.timeLimitButton.wrapper:getGroupBounds()
		local panel = TimeLimitPanel:create(ccp(bounds:getMidX(),bounds:getMidY()))
		panel:popout()
	end

	self.timeLimitButton.wrapper:ad(DisplayEvents.kTouchTap, function( ... )
		popout()
		DcUtil:UserTrack({ category = 'activity', sub_category = 'click_time_to_buy_icon'})
	end)
	if TimeLimitData:getInstance():getNeedAutoPopout() then
		popout()
		DcUtil:UserTrack({ category = 'activity', sub_category = 'click_time_to_buy_icon'})
	end
end

function HomeScene:buildActivityButton()

	if self.activityButton == true then 
		return
	end

	local isSame = true
	if self.activityButton then 
		isSame = #ActivityUtil:getNoticeActivitys() > 0
	else
		isSame = #ActivityUtil:getNoticeActivitys() == 0
	end
	if isSame then 
		local iconActivitys = ActivityUtil:getIconActivitys()
		if self.activityIconButtons and #iconActivitys == #self.activityIconButtons then 
			for k,v in pairs(self.activityIconButtons) do
				if not table.find(iconActivitys,function( a ) return a.source == v.source and a.version == v.version end) then 
					isSame = false
					break
				end
			end
		else
			isSame = false
		end
	end

	if isSame then 
		return
	end

	for _,v in pairs(self.activityIconButtons or {}) do
		v:removeFromUi(self)
	end
	self.activityIconButtons = {}

	if self.activityButton then 
		self.rightRegionLayoutBar:removeItem(self.activityButton,true)
		self.activityButton = nil
	end

	local function buildActivityIconButton(source,version)
		if table.find(ActivityUtil:getActivitys(),function( v ) return v.source == source and v.version == version end) == nil then 
			return
		end 
		local oldIcon =	table.find(self.activityIconButtons,function( v ) return v.source == source end )
		if oldIcon then 
			table.removeValue(self.activityIconButtons,oldIcon)
			self.rightRegionLayoutBar:removeItem(oldIcon,true)
		end

		local config = require("activity/" .. source)
		if config.icon then 
			local activityIconButton = nil
			if type(config.icon) == "string" then
				activityIconButton = ActivityIconButton:create(source,version)
			elseif type(config.icon) == "table" then
				activityIconButton = require("activity/" .. config.icon.startLua):create(source,version)
			end

			if activityIconButton then 
				table.insert(self.activityIconButtons,activityIconButton)
				activityIconButton:addToUi(self)

				local eventNode = CocosObject:create()
				activityIconButton:addChild(eventNode)
				eventNode:addEventListener(Events.kAddToStage,function( ... )
					if not config.isSupport() then
						table.removeValue(self.activityIconButtons,activityIconButton)
						activityIconButton:removeFromUi(self)
					end
				end)
			end
		end
	end

	self.activityButton = true
	ActivityUtil:getActivitys(function(activitys)

		self.activityButton = nil
		if #activitys <= 0 then
			return 
		end
		-- ActivityScene
		if #ActivityUtil:getNoticeActivitys() > 0 then 
			self.activityButton = ActivityButton:create()
			self.rightRegionLayoutBar:addItem(self.activityButton)
		end

		for _,v in pairs(self.activityIconButtons or {}) do
			-- self.rightRegionLayoutBar:removeItem(v,true)
			v:removeFromUi(self)
		end
		self.activityIconButtons = {}
		for _,v in pairs(ActivityUtil:getIconActivitys()) do
			ActivityUtil:loadIconRes(v.source,v.version,function( ... )
				buildActivityIconButton(v.source,v.version)
			end)
		end

		for _,v in pairs(ActivityUtil:getNoticeActivitys()) do
			ActivityUtil:loadNoticeImage(v.source,v.version)
		end

		for _,v in pairs(activitys) do
			local config = require("activity/" .. v.source)
			
			if not ActivityData.new(v):isLoaded() then  
				if v.version == ActivityUtil:getCacheVersion(v.source) then 
					ActivityUtil:executeAutoLua(v.source,v.version)
				end
			end
		end

	end)

end

function HomeScene:buildUpdateVersionPanel()
	-- if NewVersionUtil:hasUpdateReward() then return end ---如果有更新奖励不能弹 更新面板
	local function popoutUpdateVersionPanel(isAutoPopout)
		local function checkUpdate()
			-- 1：大版本更新
			if NewVersionUtil:hasPackageUpdate() then 

				local position = self.updateVersionButton:getPosition()
				local panel = UpdatePageagePanel:create(position)
				if panel then
					local function onClose()
						if not self.updateVersionButton or self.updateVersionButton.isDisposed then return end
						self.updateVersionButton.wrapper:setTouchEnabled(true)
					end
					panel:addEventListener(kPanelEvents.kClose, onClose)
					self.updateVersionButton.wrapper:setTouchEnabled(false)
					if isAutoPopout and panel.autoPopout then
						panel:autoPopout()
					else
						panel:popout()
					end
				end

			-- 2：动态更新
			elseif NewVersionUtil:hasDynamicUpdate() then

				-- local panel = DynamicUpdatePanel:create(function() end, function() end, false)
				-- panel:popout()
				self.updateVersionButton.wrapper:setTouchEnabled(false)
				DynamicUpdatePanel:onCheckDynamicUpdate(isAutoPopout)
			else 
				-- error
			end
		end
		RequireNetworkAlert:callFuncWithLogged(checkUpdate)
	end

	local function buildUpdateVersionButton()
		if not self.updateVersionButton then

			local visibleOrigin = Director:sharedDirector():getVisibleOrigin()
			local visibleSize = Director:sharedDirector():getVisibleSize()

			self.updateVersionButton = UpdateButton:create()
			self.updateVersionButton:setPositionX(visibleOrigin.x + visibleSize.width - 120)
			self.updateVersionButton:setPositionY(visibleOrigin.y + 240)
			
			local index
			if self.marketButton and not self.marketButton.isDisposed then index = self:getChildIndex(self.marketButton)
			elseif self.friendButton and not self.friendButton.isDisposed then index = self:getChildIndex(self.friendButton)
			elseif self.bagButton and not self.bagButton.isDisposed then index = self:getChildIndex(self.bagButton) end
			if index then self:addChildAt(self.updateVersionButton, index)
			else self:addChild(self.updateVersionButton) end

			self.updateVersionButton.wrapper:addEventListener(DisplayEvents.kTouchTap, function() popoutUpdateVersionPanel(false) end )
		
		end
	end

	if not self.updateVersionButton and NewVersionUtil:hasNewVersion() then
		buildUpdateVersionButton()

		if NewVersionUtil:hasPackageUpdate() then
			local version = tostring(UserManager:getInstance().updateInfo.version)
			if UpdatePageagePanel:isApkExist(version) then
				self.updateVersionButton:setText("ready")
			end
		end
	end

	-- -- 判断是否已经弹过这个面板，没有直接弹
	-- if NewVersionUtil:hasNewVersion() then 
		
	-- 	local updateInfo = UserManager.getInstance().updateInfo
	-- 	local curTips = updateInfo.tips
	-- 	if self.updateVersionButton and CCUserDefault:sharedUserDefault():getStringForKey("game.updateInfo.tips") ~= curTips then 
	-- 		CCUserDefault:sharedUserDefault():setStringForKey("game.updateInfo.tips",curTips)
	-- 		NewVersionUtil:cacheUpdateInfo()
	-- 		CCUserDefault:sharedUserDefault():flush()
			
	-- 		popoutUpdateVersionPanel(true)
	-- 	end

	-- end
end

function HomeScene:buildTempActivityBtn()
	local function showActivityPanel()
		local levelId = PublishActUtil:getLevelId()
		local levelType = LevelType:getLevelTypeByLevelId(levelId)
		local startGamePanel = StartGamePanel:create(levelId, levelType)
		startGamePanel:popout(false)
	end

	if not self.tempActivityButton then

		local visibleOrigin = Director:sharedDirector():getVisibleOrigin()
		local visibleSize = Director:sharedDirector():getVisibleSize()

		self.tempActivityButton = TempActivityButton:create()

		local buttonSize = self.tempActivityButton:getGroupBounds().size
		local buttonPosX = visibleOrigin.x + visibleSize.width - buttonSize.width - 45
		local buttonPosY = visibleOrigin.y + buttonSize.height + 280
		self.tempActivityButton:setPositionX(buttonPosX)
		self.tempActivityButton:setPositionY(buttonPosY)

		local mask = self:createMask(0,ccp(buttonPosX+buttonSize.width/2,buttonPosY-buttonSize.height/2))
		local index = self:getNumOfChildren()
	
		self:addChildAt(mask,index)
		self:addChildAt(self.tempActivityButton, index+1)

		self.tempActivityButton.wrapper:addEventListener(DisplayEvents.kTouchTap, showActivityPanel)
	end
end

function HomeScene:createMask(opacity, position, radius, square, width, height, oval)
	local wSize = CCDirector:sharedDirector():getWinSize()
	local mask = LayerColor:create()
	mask:changeWidthAndHeight(wSize.width, wSize.height)
	mask:setColor(ccc3(0, 0, 0))
	mask:setOpacity(opacity)
	mask:setPosition(ccp(0, 0))

	local node
	if square then
		node = LayerColor:create()
		width = width or 50
		height = height or 40
		node:changeWidthAndHeight(width, height)
	elseif oval then
		node = Sprite:createWithSpriteFrameName("circle0000")
		width, height = width or 1, height or 1
		node:setScaleX(width)
		node:setScaleY(height)
	else
		node = Sprite:createWithSpriteFrameName("circle0000")
		radius = radius or 1
		node:setScale(radius)
	end
	node:setPosition(ccp(position.x, position.y))
	local blend = ccBlendFunc()
	blend.src = GL_ZERO
	blend.dst = GL_ONE_MINUS_SRC_ALPHA
	node:setBlendFunc(blend)
	mask:addChild(node)

	local layer = CCRenderTexture:create(wSize.width, wSize.height)
	layer:setPosition(ccp(wSize.width / 2, wSize.height / 2))
	layer:begin()
	mask:visit()
	layer:endToLua()
	if __WP8 then layer:saveToCache() end

	mask:dispose()

	local layerSprite = layer:getSprite()
	local obj = CocosObject.new(layer)
	local trueMaskLayer = Layer:create()
	trueMaskLayer:addChild(obj)
	trueMaskLayer:setTouchEnabled(true, 0, true)
	local function onTouchTap()
		
	end
	trueMaskLayer:ad(DisplayEvents.kTouchTap,onTouchTap)
	trueMaskLayer.layerSprite = layerSprite
	return trueMaskLayer
end

function HomeScene:popoutBagPanel(...)

	local bagButtonPos 				= self.bagButton:getPosition()
	local bagButtonParent			= self.bagButton:getParent()
	local bagButtonPosInWorldSpace	= bagButtonParent:convertToWorldSpace(ccp(bagButtonPos.x, bagButtonPos.y))
	local panel = createBagPanel(bagButtonPosInWorldSpace)
	if panel then 
		panel:popout()
	end

end

function HomeScene:popoutFriendRankingPanel(event)
	
	-- prevent quick clicks
	self.friendButton.wrapper:setTouchEnabled(false)
	local function __reset()
		-- note: this callback maybe delayed, when home scene is runnning again
		-- becasue this panel will push a new scene.
		if self.friendButton then self.friendButton.wrapper:setTouchEnabled(true) end
	end
	self:runAction(CCSequence:createWithTwoActions(
	               CCDelayTime:create(0.2), CCCallFunc:create(__reset)
	               ))

	local panel =  createFriendRankingPanel()
	if panel then 
		panel:popout()
	end
end

function HomeScene:popoutMarketPanelByIndex(defaultIndex, showFree)
	local panel =  createMarketPanel(defaultIndex)
	if showFree ~= nil then panel:setGoldFreeVisible(showFree) end
	if panel then panel:popout() end
end

function HomeScene:popoutMarketPanel(event)
	self:popoutMarketPanelByIndex(1);
end

function HomeScene:onEnterForeGround()
	print("HomeScene:onEnterForeGround")

	if self.exitDialog then
		return
	end

	PushActivity:sharedInstance():setForeGroundTimeStamp()
	--强弹
	HomeScenePopoutQueue:reset("enterForground")
	self:autoPopoutPanel('enterForground')
	--没有点链接的情况 
	self.hasCallAutoPopoutUrl = false
	self:runAction(CCCallFunc:create(function( ... )
		if not self.hasCallAutoPopoutUrl then
			self:autoPopoutUrl(nil)
		end
	end))

	local function onGetRequestNumSuccess(evt)
		UserManager:getInstance().requestNum = evt.data.requestNum
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kMessageCenterUpdate))

		UserManager:getInstance().updateInfo = evt.data.updateInfo
		self:buildUpdateVersionPanel()

		ActivityUtil:setActInfos(evt.data.actInfos)

		if __ANDROID then 
			AndroidPayment.getInstance():changeSMSPaymentDecisionScript(evt.data.smsPay) 

			if AndroidPayment.getInstance():getDefaultSmsPayment() == Payments.CHINA_MOBILE then
				if not self.timeLimitButton then self:buildTimeLimitButtonIfNecessary() end
			else
				if self.timeLimitButton then self.timeLimitButton.remove() end
			end
		end
	end

	if not PrepackageUtil:isPreNoNetWork() then
		local function getRequestNum( ... )
			local http = GetRequestNumHttp.new(false)
			http:ad(Events.kComplete, onGetRequestNumSuccess)
			http:load()
		end
		RequireNetworkAlert:callFuncWithLogged(getRequestNum, nil, kRequireNetworkAlertAnimation.kNoAnimation)
	end

	-- 
	ActivityUtil:reloadActivitys(function( activitys )
		if activitys == nil then
			print("activitys == nil")
			return
		end
		if self.activityButton == true then
			print("self.activityButton == true")
			return
		end

		self:buildActivityButton()
		self:autoPopoutActivity("enterForground")
	end)
	
	self:popoutWdjRewardPanelIfNecessary()
	UserManager:getInstance():checkDateChange()
	
	self:dp(Event.new(SceneEvents.kEnterForeground, nil, self))
end

function HomeScene:updateButtons()
	LadyBugMissionManager:sharedInstance():changeTaskStateWhenTimeChange()
	local topLevelId = UserManager:getInstance().user:getTopLevelId()
	if LadyBugMissionManager:sharedInstance():isMissionStarted() and topLevelId ~= 3 and not self.ladybugButton then

		print("lady bug mission started !")

		-- -----------------------------------
		-- Create The Lady Bug Button 
		-- ------------------------------------
		local function onLadyBugBtnTapped()
			print("onLadyBugBtnTapped Called !")
			self:popoutLadyBugPanel()
		end

		self.ladybugButton	= LadybugButton:create()
		self.leftRegionLayoutBar:addItem(self.ladybugButton)
		local function onTime() LadyBugMissionManager:sharedInstance():changeTaskStateWhenTimeChange() end
		LadyBugMissionManager:sharedInstance():startOneSecondTimer(onTime)
		self.ladybugButton.wrapper:addEventListener(DisplayEvents.kTouchTap, onLadyBugBtnTapped)
	end
end

-- 从游戏外部启动游戏或外力后台切换至前台时进行处理
-- region
function HomeScene:onApplicationHandleOpenURL(launchURL)
	self:autoPopoutUrl(launchURL)

	print("HomeScene:onApplicationHandleOpenURL:"..tostring(launchURL))
	self.activityShareData = nil

	if type(launchURL) == "string" and string.len(launchURL) > 0 then
		local res = UrlParser:parseUrlScheme(launchURL)
		if not res.method then return end
		print(table.tostring(res))
		if type(self["onApplicationHandleOpenURL_"..string.lower(res.method)]) == "function" then
			self:runAction(CCSequence:createWithTwoActions(
				CCDelayTime:create(1/60),
				CCCallFunc:create(function()
					self["onApplicationHandleOpenURL_"..string.lower(res.method)](self, res)
				end)
			))
		end
	end
end

function HomeScene:onApplicationHandleOpenURL_addfriend(res)
	if type(res.para) ~= "table" or not res.para.invitecode or not res.para.uid then return end

	local function onSuccess()
		self:checkDataChange()
		if self.coinButton and not self.coinButton.isDisposed then
			self.coinButton:updateView()
		end

		if res.para.isyyb then
			CommonTip:showTip(Localization:getInstance():getText("add.friend.success.tips"), "positive", nil, 3)
			DcUtil:addFriendQRCode(2)
		else
			CommonTip:showTip(Localization:getInstance():getText("url.scheme.add.friend"), "positive", nil, 3)
		end
	end
	local function onFail(err)
		if res.para.isyyb then
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative", nil, 3)
		end
	end
	local function startInvitedAndRewardLogic()
		local logic = InvitedAndRewardLogic:create(false)
		logic:start(res.para.invitecode, res.para.uid, onSuccess, onFail)
	end
	RequireNetworkAlert:callFuncWithLogged(startInvitedAndRewardLogic, nil, kRequireNetworkAlertAnimation.kNoAnimation)
end

function HomeScene:onApplicationHandleOpenURL_wxshare(res)
	if type(res.para) ~= "table" or not res.para.uid then return end

	if MaintenanceManager:getInstance():isEnabled("wxsharetime") then
		DcUtil:UserTrack({category = "wx_share", sub_category = "push_message_weixin",
			turn_table = res.para.turntable})
		local function createTurnTable()
			local profile = UserManager:getInstance().profile
			if profile.uid ~= tonumber(res.para.uid) then
				if tonumber(res.para.uitype) == 0 then TurnTablePanel:tryCreateTurnTable(res.para.turntable)
				elseif tonumber(res.para.uitype) == 1 then end
			end
		end
		RequireNetworkAlert:callFuncWithLogged(createTurnTable)
	end
end

function HomeScene:onApplicationHandleOpenURL_activity_wxshare(res)
	if type(res.para) ~= "table" then return end

	local paraData = {}
	for k, v in pairs(res.para) do
		paraData[k] = v
	end
	self.activityShareData = paraData
	if paraData.actId then
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(OpenUrlEvents.kActivityShare..tostring(paraData.actId), paraData))
	end
end

function HomeScene:onApplicationHandleOpenURL_webview(res)
	if type(res.para) ~= "table" then return end
	WebviewHandler:handle(res)
end

function HomeScene:onApplicationHandleOpenURL_unlock_area(res)
	if type(res.para) ~= "table" then return end

	local function startLogic()
		UnlockMessageLogic:start(res.para)
	end
	RequireNetworkAlert:callFuncWithLogged(startLogic, nil, kRequireNetworkAlertAnimation.kNoAnimation)
end

function HomeScene:onApplicationHandleOpenURL_week_match(res)
	if type(res.para) ~= "table" or not res.para.action then return end

	local function startLogic()
		SeasonWeeklyMatchHelpLogic:startWithConfig(res.para)
	end
	RequireNetworkAlert:callFuncWithLogged(startLogic, nil, kRequireNetworkAlertAnimation.kNoAnimation)
end
-- endregion

function HomeScene:setEnterFromGamePlay(levelId, showLadybugFlyLevel)
	if not self.worldScene.isDisposed then 
		self.worldScene:setEnterFromGamePlay(levelId)
		if showLadybugFlyLevel then
			self.worldScene:showLadybugFourStarGuid(showLadybugFlyLevel)
		end

		-- exit from main level, then dalybug maybe prompt
		if (not PlatformConfig:isQQPlatform()) then 
			if (tonumber(levelId) < 20000) then 
				self:starButtonLadybugPrompt()
			end
		end 
	end
end

function HomeScene:hideFishButton()
	if self.fishButton and not self.fishButton.isDisposed then
		self.fishButton:setVisible(false)
		self.fishButton.wrapper:setTouchEnabled(false)
		self.rightRegionLayoutBar:removeItem(self.fishButton, true)
		self.fishButton = nil
	end
end

function HomeScene:createStarRewardButton()
	local parentLayer = self.worldScene.friendPictureLayer
	if HomeSceneButtonsManager.getInstance():getStarRewardButtonShowState() then 
		if self.starRewardButton then 
			if parentLayer:contains(self.starRewardButton) then 
				parentLayer:removeChild(self.starRewardButton)
			end
			self.starRewardButton.wrapper:removeAllEventListeners()
			self.starRewardButton:dispose()
			self.starRewardButton = nil
		end
		if not StarRewardModel:getInstance():update().allMissionComplete then
			HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kStarReward, true)
		end
	else
		HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kStarReward, false)
		local function onStarRewardPanelClose()
			if self.starRewardButton and parentLayer:contains(self.starRewardButton) 
				and HomeSceneButtonsManager.getInstance():getStarRewardButtonShowState() then
				if StarRewardModel:getInstance():update().allMissionComplete then
					parentLayer:removeChild(self.starRewardButton)
					self.starRewardButton:removeAllEventListeners()
					self.starRewardButton:dispose()
					self.starRewardButton = nil
				else
					HomeSceneButtonsManager.getInstance():flyToBtnGroupBar(HomeSceneButtonType.kStarReward, self.starRewardButton, function ()
						if not self.starRewardButton then return end
						self.starRewardButton:setVisible(false)
						self.starRewardButton.wrapper:setTouchEnabled(false)
						self.hideAndShowBtn:setEnable(false)
					end,function ()
						if not self.starRewardButton then 
							HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kStarReward, true)
							return 
						end
						self.hideAndShowBtn:playAni(function ()
							self.hideAndShowBtn:setEnable(true)
							HomeSceneButtonsManager.getInstance():showButtonHideTutor()
						end)
						parentLayer:removeChild(self.starRewardButton)
						self.starRewardButton:removeAllEventListeners()
						self.starRewardButton:dispose()
						self.starRewardButton = nil
						
						HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kStarReward, true)
					end)
				end
			elseif self.starRewardButton then
				self.starRewardButton:update()
			end
		end

		local function onStarRewardButtonTapped()
			DcUtil:iconClick("click_stars_seward_icon")

			local starRewardBtnPos = self.starRewardButton:getPosition()
			local starRewardBtnParent = self.starRewardButton:getParent()
			local starRewardBtnPosInWorldSpace = starRewardBtnParent:convertToWorldSpace(ccp(starRewardBtnPos.x, starRewardBtnPos.y))

			local starRewardBtnSize	= self.starRewardButton.wrapper:getGroupBounds().size

			-- starRewardBtnPosInWorldSpace.x = starRewardBtnPosInWorldSpace.x + starRewardBtnSize.width / 2
			starRewardBtnPosInWorldSpace.y = starRewardBtnPosInWorldSpace.y + starRewardBtnSize.height 

			local starRewardPanel	= StarRewardPanel:create(starRewardBtnPosInWorldSpace)
			if starRewardPanel then
				starRewardPanel:registerCloseCallback(onStarRewardPanelClose)
				starRewardPanel:popout()
			end
		end

		if not self.starRewardButton then 
			local starRewardButton = TreeStarRewardButton:create()
			parentLayer:addChild(starRewardButton)
			local btnPos = HomeSceneButtonsManager.getInstance():getStarRewardButtonShowPos()
			if btnPos then 
				starRewardButton:setPosition(ccp(btnPos.x, btnPos.y))
			end
			starRewardButton.wrapper:addEventListener(DisplayEvents.kTouchTap, onStarRewardButtonTapped)
			self.starRewardButton = starRewardButton
		else
			--刷新位置
			self:updateStarRewardBtnPosition()
		end
	end
end

function HomeScene:updateStarRewardBtnPosition()
	if self.starRewardButton then 
		local btnPos = HomeSceneButtonsManager.getInstance():getStarRewardButtonShowPos()
		if btnPos then 
			self.starRewardButton:setPosition(ccp(btnPos.x, btnPos.y))
		end
		self.starRewardButton:update()
	end
end

function HomeScene:createInviteFriendButton()
	if not MaintenanceManager:getInstance():isEnabled("InviteCode") or PlatformConfig:isJJPlatform() then 
		return 
	end
	self.multiClickInviteBtn = false
	if not self.inviteFriendBtn then 
		local parentLayer = self.worldScene.friendPictureLayer
		local inviteFriendBtn	= TreeInviteFriendButton:create()
		local function onInviteFriendBtnTapped(event)
			DcUtil:iconClick("click_invite_icon")

			if self.multiClickInviteBtn then 
				return 
			else
				self.multiClickInviteBtn = true
				setTimeOut(function ()
					self.multiClickInviteBtn = false
				end, 2)
			end

			local btnPos 		= inviteFriendBtn:getPosition()
			local btnParent		= inviteFriendBtn:getParent()
			local btnPosInWorldPos	= btnParent:convertToWorldSpace(ccp(btnPos.x, btnPos.y))

			local btnSize		= inviteFriendBtn.wrapper:getGroupBounds().size
			local btnSize		= inviteFriendBtn.ui:getGroupBounds().size
			-- btnPosInWorldPos.x = btnPosInWorldPos.x + btnSize.width / 2
			btnPosInWorldPos.y = btnPosInWorldPos.y + btnSize.height / 2

			local inviteFriendPanel = InviteFriendRewardPanel:create(btnPosInWorldPos)
			if inviteFriendPanel then inviteFriendPanel:popout() end
		end
		parentLayer:addChild(inviteFriendBtn)
		local btnPos = HomeSceneButtonsManager.getInstance():getInviteButtonShowPos()
		if btnPos then 
			inviteFriendBtn:setPosition(ccp(btnPos.x, btnPos.y))
		end

		inviteFriendBtn.wrapper:addEventListener(DisplayEvents.kTouchTap, onInviteFriendBtnTapped)
		self.inviteFriendBtn = inviteFriendBtn
	else
		--刷新位置
		self:updateInviteBtnPosition()
	end
end

function HomeScene:updateInviteBtnPosition()
	if self.inviteFriendBtn then 
		local btnPos = HomeSceneButtonsManager.getInstance():getInviteButtonShowPos()
		if btnPos then 
			self.inviteFriendBtn:setPosition(ccp(btnPos.x, btnPos.y))
		end	
	end
end

function HomeScene:createMissionButton()
	if UserManager.getInstance().user:getTopLevelId() >= MissionLogic:getInstance():getMissionUserNeedLevel() 
		and not self.missionBtn then 
		self.missionBtn = MissionPanelLogic:getMissionBtn()
		self.leftRegionLayoutBar:addItem(self.missionBtn)
		
	end
end

function HomeScene:createFruiteTreeButtonInHomeScene( ... )
	-- body
	HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kTree, false)
	if self.fruitTreeBtn then return end

	local btn = FruitTreeButton:create()
	self.fruitTreeBtn = btn

	local marketButton = self.marketButton
	if not marketButton then return end
	local pos_m = marketButton:getPosition()
	local z_order = marketButton:getParent():getChildIndex(marketButton)
	local function onFruitTreeBtnTap( ... )
		DcUtil:iconClick("click_fruiter_icon")
		-- body
		local function fruiteSceneClose( evt )
			-- body
			if HomeSceneButtonsManager.getInstance():getFruitTreeButtonShowState() then
				HomeSceneButtonsManager.getInstance():flyToBtnGroupBar(HomeSceneButtonType.kTree, self.fruitTreeBtn, function ()
					if not self.fruitTreeBtn then return end
					self.fruitTreeBtn:setVisible(false)
					self.fruitTreeBtn.wrapper:setTouchEnabled(false)
					self.hideAndShowBtn:setEnable(false)
				end,function ()
					if not self.fruitTreeBtn then 
						HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kTree, true)
						return 
					end
					self.hideAndShowBtn:playAni(function ()
						self.hideAndShowBtn:setEnable(true)
						HomeSceneButtonsManager.getInstance():showButtonHideTutor()
					end)
					self.fruitTreeBtn:removeFromParentAndCleanup(true)
					self.fruitTreeBtn = nil
					HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kTree, true)
				end)
			end
		end

		local function success()
			if self.isDisposed then return end
			local function pushNewScene()
				self.fruitTreeBtn.wrapper:setTouchEnabled(false)
				self:runAction(CCCallFunc:create(function()
					local scene = FruitTreeScene:create()
					scene:addEventListener(kFruitTreeEvents.kExit, fruiteSceneClose)
					Director:sharedDirector():pushScene(scene)
					self.fruitTreeBtn.wrapper:setTouchEnabled(true, 0, true)
					self.fruitTreeBtn:hideNewTag()
				end))
			end
			AsyncLoader:getInstance():waitingForLoadComplete(pushNewScene)
		end
		local function fail(err, skipTip)
			if self.isDisposed then return end
			if not skipTip then CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err))) end
		end
		local function updateInfo()
			FruitTreeSceneLogic:sharedInstance():updateInfo(success, fail)
		end
		local function onLoginFail()
			fail(-2, true)
		end
		RequireNetworkAlert:callFuncWithLogged(updateInfo, onLoginFail)
	end

	btn.wrapper:addEventListener(DisplayEvents.kTouchTap, onFruitTreeBtnTap)
	btn.onClick = onFruitTreeBtnTap
	self:addChildAt(btn, z_order)
	btn:setPosition(ccp(pos_m.x - 120, pos_m.y))
end

function HomeScene:createAndShowFruitTreeButton()
	local function showFruitTreeButton(evt, noTutor)
		local user = UserManager:getInstance():getUserRef()
		if user and user:getTopLevelId() >= 16 then
			self:removeEventListener(HomeSceneEvents.USERMANAGER_TOP_LEVEL_ID_CHANGE, showFruitTreeButton)

			if HomeSceneButtonsManager.getInstance():getFruitTreeButtonShowState() then
				HomeSceneButtonsManager.getInstance():setButtonShowPosState(HomeSceneButtonType.kTree, true)
				if not noTutor then 
					HomeSceneButtonsManager.getInstance():showFruitTreeAppearTutor()
				end
			else
				self:createFruiteTreeButtonInHomeScene()
				if not noTutor then
					HomeSceneButtonsManager.getInstance():showFruitTreeAppearTutor(true)
				end
			end
		end
	end
	local user = UserManager:getInstance():getUserRef()
	if user and user:getTopLevelId() >= 16 then
		showFruitTreeButton(nil, true)
	else
		self:addEventListener(HomeSceneEvents.USERMANAGER_TOP_LEVEL_ID_CHANGE, showFruitTreeButton)
	end
end

function HomeScene:popoutWeeklyRacePanel()

	local levelId = WeeklyRaceManager:sharedInstance():getLevelIdForToday()

	if not PopoutManager:sharedInstance():haveWindowOnScreen() and not HomeScene:sharedInstance().ladyBugOnScreen then
		local startGamePanel = StartGamePanel:create(levelId, GameLevelType.kDigWeekly)
		startGamePanel:popout(false)
	end
end

function HomeScene:onWeeklyRaceBtnTapped()
		local function popout()
			self:popoutWeeklyRacePanel()
		end
		WeeklyRaceManager:sharedInstance():loadData(popout)
		if WeeklyRaceManager:sharedInstance():isPlayDay() then
			DcUtil:weeklyRaceClick(1)
		else
			DcUtil:weeklyRaceClick(2)
		end
	end

function HomeScene:createWeeklyRaceButton()
	if self.weeklyRaceBtn then return end

	
	self.weeklyRaceBtn = WeeklyRaceButton:create()
	self.leftRegionLayoutBar:addItem(self.weeklyRaceBtn)
	self.weeklyRaceBtn.wrapper:addEventListener(DisplayEvents.kTouchTap, function (event) 
		self:onWeeklyRaceBtnTapped() 
		end )

	local tutored = CCUserDefault:sharedUserDefault():getBoolForKey("weeklyRaceBtn.tutored")
	if not tutored then
		self.weeklyRaceBtn:showWeeklyBtnTutor("weeklyRaceBtn.tutored")
	end
end

function HomeScene:updateCoin()
	self:checkDataChange()
	if self.coinButton then
		self.coinButton:updateView()
	end
end

function HomeScene:onSummerWeeklyButtonTapped()
	DcUtil:UserTrack({category = 'weeklyrace', sub_category = 'weeklyrace_summer_2016_click_icon'}, true)
	SeasonWeeklyRaceManager:getInstance():pocessSeasonWeeklyDecision()
end


function HomeScene:createSummerWeeklyButton()
	if self.summerWeeklyButton then return end

	local function onBtnTapped()
		self:onSummerWeeklyButtonTapped()
	end

	local function onMatchDataLoaded()
		if self.summerWeeklyButton then return end
		self.summerWeeklyButton = SummerWeeklyButton:create()
		self.leftRegionLayoutBar:addItem(self.summerWeeklyButton)
		self.summerWeeklyButton.wrapper:addEventListener(DisplayEvents.kTouchTap, onBtnTapped)

		local minLevel = SeasonWeeklyRaceConfig:getInstance().minLevel or 31
		local userLevel = UserManager:getInstance():getUserRef():getTopLevelId()
		if userLevel == minLevel then -- 刚解锁时才出引导
			local tutored = CCUserDefault:sharedUserDefault():getBoolForKey("autumnWeeklyRaceBtn.tutored")
			if not tutored then
				self.summerWeeklyButton:showWeeklyBtnTutor("autumnWeeklyRaceBtn.tutored", "tutorial.game.text230000")
			end
		end
	end
	SeasonWeeklyRaceManager:getInstance():loadData(onMatchDataLoaded, false)
end

function HomeScene:onDefaultPaymentTypeAutoChange()
	if __ANDROID then
		local function callback()
			local currentDefaultPayment = PaymentManager.getInstance():getDefaultPayment()
			local paymentBeforeAutoChange = PaymentManager.getInstance():getPaymentBeforeAutoChange()

			PaymentManager.getInstance():setPaymentAutoChangeFlag(false)
			PaymentManager.getInstance():setPaymentBeforeAutoChange(nil)
			
			if paymentBeforeAutoChange and paymentBeforeAutoChange == currentDefaultPayment then 
				return 
			end
			require "zoo.payment.DefaultPaymentChangePanel"
			local panel = DefaultPaymentChangePanel:create(currentDefaultPayment)
			panel:popout()
		end
		self:runAction(CCCallFunc:create(callback))
	end
end

function HomeScene:showDengchaoEnerygy()
	if self.messageButton and self.messageButton.isDengchaoMode then
		self.messageButton:showDengchao(true)		
	end
end

function HomeScene:playDengchaoEnergyAnim()
	print('HomeScene:playDengchaoEnergyAnim()')
	if self.messageButton and self.messageButton.isDengchaoMode then
		self:runAction(CCCallFunc:create(
			function () 
				if self.messageButton and self.messageButton.isDengchaoMode then
					self.messageButton:playDengchaoAnim() 
				end
			end))		
	end
end

function HomeScene:hideDengchaoEnergyAnim()
	if self.messageButton and self.messageButton.isDengchaoMode then
		self:runAction(CCCallFunc:create(
			function () 
				if self.messageButton.isDengchaoMode then
	                self.messageButton:playDengchaoFadeOutAnim()
	            end
			end))		
	end
end
