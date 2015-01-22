
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月17日  9:09:34
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panel.basePanel.BasePanel"
require "zoo.panel.component.energyPanel.EnergyItem"
require "zoo.panel.basePanel.panelAnim.PanelExchangeAnim"
require "zoo.config.ui.EnergyPanelConfig"
require "zoo.panelBusLogic.UsePropsLogic"
require "zoo.panelBusLogic.UseEnergyBottleLogic"
require "zoo.panel.component.common.BubbleCloseBtn"
require "zoo.baseUI.BuyAndContinueButton"
require "zoo.panelBusLogic.BuyEnergyLogic"
require "zoo.panelBusLogic.buyGoodsLogic.SyncBuyEnergyLogic"
require "zoo.panel.component.energyPanel.AddMaxEnergyPanel"
require "zoo.panel.component.energyPanel.EnergyNumberCounter"
require "zoo.panel.component.energyPanel.EnergyNotificationSubPanel"
require "zoo.data.FreegiftManager"
require "zoo.panel.AskForEnergyPanel"
require "zoo.panel.component.energyPanel.SocialNetworkFollowPanel"
require "zoo.panel.PushActivityPanel"
require "zoo.panel.RemindAskingEnergyPanel"

local kPanelShowChance = {
	kAddMaxEnergy = 0,
	kWeChat = 25,
	kWeibo = 25,
	kRemindAskingEnergy = 25,
	kNothing = 25,
}

---------------------------------------------------
-------------- EnergyPanel
---------------------------------------------------

assert(not EnergyPanel)
assert(BasePanel)
EnergyPanel = class(BasePanel)

function EnergyPanel:init(continueCallback, ...)
	assert(continueCallback == false or type(continueCallback) == "function")
	assert(#{...} == 0)

	-- -----------------
	-- Get UI Resource
	-- ----------------
	self.resourceManager	= ResourceManager:sharedInstance()
	self.ui 		= self.resourceManager:buildGroup("energyPanel/energyPanel")

	-- ---------
	-- Init Base
	-- ---------
	BasePanel.init(self, self.ui)

	-----------------------------------------
	----  Scale According To Screen Resolution
	----  -------------------------------------
	--self:scaleAccordingToResolutionConfig()

	-- ---------------
	-- Get UI Resource
	-- -------------------
	self.fadeArea		= self.ui:getChildByName("fadeArea")
	self.clippingAreaAbove	= self.ui:getChildByName("clippingAreaAbove")
	self.clippingAreaBelow	= self.ui:getChildByName("clippingAreaBelow")
	assert(self.fadeArea)
	assert(self.clippingAreaAbove)
	assert(self.clippingAreaBelow)


	self.titleLabelPlaceholder	= self.ui:getChildByName("titleLabelPlaceholder")
	-- Fade Area
	self.energyIcon			= self.fadeArea:getChildByName("energyIcon")
	self.energyBrightness		= self.fadeArea:getChildByName("energyBrightness")
	self.energyNumberCounterRes	= self.fadeArea:getChildByName("energyCounter")

	--self.energyNumberLabel		= self.fadeArea:getChildByName("energyNumberLabel")
	self.timeToRecoverLabel		= self.fadeArea:getChildByName("timeToRecoverLabel")

	-- Clipping Area Above
	self.buyAndContinueBtnRes	= self.clippingAreaAbove:getChildByName("buyAndContinueBtn")
	self.continueBtnRes 		= self.clippingAreaAbove:getChildByName("continueBtn")
	self.discountTag			= self.clippingAreaAbove:getChildByName("discount")
	-- Clipping Area Below
	self.item1			= self.clippingAreaBelow:getChildByName("item1")
	self.item2			= self.clippingAreaBelow:getChildByName("item2")
	self.item3			= self.clippingAreaBelow:getChildByName("item3")
	self.buyEnergyTxt		= self.clippingAreaBelow:getChildByName("useEnergyTxt")
	self.askFriendBtn		= self.clippingAreaBelow:getChildByName("askFriendBtn")
	self.buyBtn			= self.clippingAreaBelow:getChildByName("buyBtn")

	local buyBtnBG = self.buyBtn:getChildByName("btnWithoutShadow"):getChildByName("_bg"):getChildByName("bg")
	buyBtnBG:adjustColor(kColorBlueConfig[1],kColorBlueConfig[2],kColorBlueConfig[3],kColorBlueConfig[4])
	buyBtnBG:applyAdjustColorShader()

	-- Close Btn
	self.bg			= self.ui:getChildByName("bg")
	assert(self.bg)
	self.closeBtnRes	= self.ui:getChildByName("close")
	assert(self.closeBtnRes)

	assert(self.titleLabelPlaceholder)
	assert(self.energyIcon)
	assert(self.energyBrightness)
	assert(self.energyNumberCounterRes)

	--assert(self.energyNumberLabel)
	assert(self.timeToRecoverLabel)
	assert(self.item1)
	assert(self.item2)
	assert(self.item3)
	assert(self.buyAndContinueBtnRes)
	assert(self.continueBtnRes)
	assert(self.discountTag)

	assert(self.buyEnergyTxt)
	assert(self.askFriendBtn)
	assert(self.buyBtn)

	---------------------
	-- Get Data About UI
	-- -------------------
	local labelPhPos		= self.titleLabelPlaceholder:getPosition()
	local good = MetaManager:getInstance():getGoodMeta(34)
	local normGood = good.qCash
	local discountGood = good.discountQCash
	local buyed = UserManager:getInstance():getDailyBoughtGoodsNumById(34)
	if buyed > 0 then
		self.discountTag:setVisible(false)
		self.goldPriceToBuyAEnergy = normGood
		self.discount = false
	else
		discount = math.ceil(discountGood / normGood * 10)
		self.discountTag:getChildByName("num"):setString(discount)
		self.discountTag:setVisible(true)
		self.goldPriceToBuyAEnergy = discountGood
		self.discount = true
	end


	------------------------------
	-- Flag To Indicate Tapped Status
	------------------------------
	self.TAPPED_STATE_NONE				= 1
	self.TAPPED_STATE_CLOSE_BTN_TAPPED		= 2
	self.TAPPED_STATE_BUY_AND_CONTINUE_BTN_TAPPED	= 3
	self.TAPPED_STATE_ITEM_TAPPED			= 4
	self.tappedState				= self.TAPPED_STATE_NONE

	--------------------
	-- Init UI Component
	-- -------------------
	-- self.askFriendBtn:setVisible(false)
	self.buyBtn:setVisible(false)
	self.titleLabelPlaceholder:setVisible(false)


	--------------------------
	-- Create UI Componenet
	-- ------------------------
	
	-----------------------------------
	-- Clipping The Energy Brightness
	-- ------------------------------
	
	-- Clipping The self.energyBrightness
	local energyBrightnessParent	= self.energyBrightness:getParent()
	local energyBrightnessPosX	= self.energyBrightness:getPositionX()
	local energyBrightnessPosY	= self.energyBrightness:getPositionY()
	local energyBrightnessSize 	= self.energyBrightness:getGroupBounds().size

	local cppStencil 		= CCLayerColor:create(ccc4(255,0,0,255))
	cppStencil:changeWidthAndHeight(energyBrightnessSize.width, energyBrightnessSize.height)
	cppStencil:setPositionY(-energyBrightnessSize.height)

	local cppClipping		= CCClippingNode:create(cppStencil)
	local luaClipping		= ClippingNode.new(cppClipping)
	luaClipping:setPosition(ccp(energyBrightnessPosX, energyBrightnessPosY))

	-- Add self.energyBrightness To The Clipping
	self.energyBrightness:removeFromParentAndCleanup(false)
	self.energyBrightness:setPosition(ccp(0,0))
	luaClipping:addChild(self.energyBrightness)

	-- Add Clipping
	energyBrightnessParent:addChild(luaClipping)

	self.energyClipping 		= luaClipping
	self.energyClippingHeight	= energyBrightnessSize.height
	self.energyClipping:setVisible(false)


	-- Energy Number Counter
	self.energyNumberCounter = EnergyNumberCounter:create(self.energyNumberCounterRes)

	-------------
	-- Update UI
	-- ------------

	-- Ask friend button
	local label = self.askFriendBtn:getChildByName("Label")
	if label then label:setString(Localization:getInstance():getText("energy.panel.askFriend")) end

	-- Update Buy Btn Label
	local btnWithShadow = self.buyBtn:getChildByName("btnWithoutShadow")
	assert(btnWithShadow)
	local label = btnWithShadow:getChildByName("label")

	local buyBtnLabelkey	= "energy.panel.buyBtn"
	local buyBtnLabelValue	= Localization:getInstance():getText(buyBtnLabelkey, {}) 
	label:setString(buyBtnLabelValue)

	----------------------
	-- Get Data About UI
	-- -------------------
	self.energyIconSize = self.energyIcon:getGroupBounds().size
	
	-- Get Energy Icon Center Pos In Self Space
	local fadeAreaNodeToParentTrans = self.fadeArea:nodeToParentTransform()

	local energyIconPos 		= self.energyIcon:getPosition()
	self.energyIconPos = energyIconPos
	
	local energyIconCenterPos	= ccp(energyIconPos.x + self.energyIconSize.width/2, energyIconPos.y - self.energyIconSize.height/2)

	local energyIconPosInSelf 	= CCPointApplyAffineTransform(ccp(energyIconPos.x, energyIconPos.y), fadeAreaNodeToParentTrans)
	local energyIconCenterPosInSelf	= CCPointApplyAffineTransform(ccp(energyIconCenterPos.x, energyIconCenterPos.y), fadeAreaNodeToParentTrans)
	assert(energyIconPosInSelf)

	-------------------------------------
	-- Create Open / Hide Panel Animation
	-- ----------------------------------
	self.panelExchangeAnim = PanelExchangeAnim:create(self)

	local config = EnergyPanelConfig:create(self)
	local initX = self:getHCenterInScreenX()
	local initY = config:getInitY()

	local manualAdjustPosY	= 50
	
	local selfHeight = self.ui:getGroupBounds().size.height
	self.panelExchangeAnim:setPopHidePos(initX, selfHeight)
	self.panelExchangeAnim:setPopShowPos(initX, initY + manualAdjustPosY)
	
	------------------------
	---- Create UI Component
	------------------------
	self.item1	= EnergyItem:create(self.item1, ItemType.SMALL_ENERGY_BOTTLE, self, energyIconCenterPosInSelf)
	self.item2	= EnergyItem:create(self.item2, ItemType.MIDDLE_ENERGY_BOTTLE, self, energyIconCenterPosInSelf)
	self.item3	= EnergyItem:create(self.item3, ItemType.LARGE_ENERGY_BOTTLE, self, energyIconCenterPosInSelf)
	self.items 	= {self.item1, self.item2, self.item3}

	self.closeBtn		= self.closeBtnRes
	self.buyAndContinueBtn	= BuyAndContinueButton:create(self.buyAndContinueBtnRes)
	self.continueBtn 		= ButtonWithShadow:create(self.continueBtnRes)
	self.continueBtn:createAnimation()
	------------
	---- Data
	------------
	-- When On Enter Register A Timer Check It's Value Each Time
	--self.curEnergy 			= UserManager.getInstance().user:getEnergy()
	self.curEnergy			= UserEnergyRecoverManager:sharedInstance():getEnergy()
	self.maxEnergy			= UserEnergyRecoverManager:sharedInstance():getMaxEnergy()
	self.energyRecoverSecond	= MetaManager.getInstance().global.user_energy_recover_time_unit / 1000

	self.separator = "/"


	-------------------------------------------------------------------------------
	-- This Callback FUnctio Is A Flag TO Indicate From Where This Panel Is Popouted
	-- When Has continueCallback, This Panel Is Called From StartGamePanel.
	-- When Has No continueCallback, This Is Called From EnergyBUtton In HomeScene.
	-- =--------------------------------------------------------------------------
	self.continueCallback = continueCallback	

	-- Data About Sub Panel, Which Contain The Continue Btn
	self.showContinueSubPanelIsPlaying	= false

	-- Data About Show/Hide Panel
	self.SHOW_MODE_POPOUT		= 1
	self.SHOW_MODE_EXCHANGE_CONTENT	= 2
	self.showMode	= false
	self.showed	= false

	--
	-- Flag To Indicate self.buyAndContinueBtn Function
	-- Buy Or Continue
	--
	self.BUY_AND_CONTINUE_BTN_STATE_BUY		= 1
	self.BUY_AND_CONTINUE_BTN_STATE_CONTINUE	= 2
	self.buyAndContinueBtnState			= self.BUY_AND_CONTINUE_BTN_STATE_BUY

	-------------------
	self.BTN_TAPPED_STATE_NONE		= 1
	self.BTN_TAPPED_STATE_CLOSEBTN_TAPPED	= 2	
	self.btnTappedState			= self.BTN_TAPPED_STATE_NONE

	-------------------------------------------------
	-- Local Will Added Point , Wait Server To Foncrim
	-- ----------------------------------------------
	self.energyPointWaitServerToConfirm = 0

	-------------------------
	---- Update View
	-----------------------
	-- ----------
	-- Panel Tile
	-- ----------
	local panelTitleLabelTxtKey	= nil
	local panelTitleLabelTxt = nil
	if self.continueCallback then
		-- Opened In StartGamePanel
		panelTitleLabelTxtKey = "energy.panel.continue.title"
		panelTitleLabelTxt = Localization:getInstance():getText(panelTitleLabelTxtKey)
	else
		-- Not Opend In StartGamePanel
		panelTitleLabelTxtKey = "energy.panel.title"
		panelTitleLabelTxt = Localization:getInstance():getText(panelTitleLabelTxtKey)
	end

	local charWidth 	= 65
	local charHeight	= 65
	local charInterval	= 57
	local fntFile		= "fnt/caption.fnt"
	if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/caption.fnt" end
	-- self.titleLabelPlaceholder:setString(panelTitleLabelTxt)
	self.titleLabel = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self.titleLabel:setAnchorPoint(ccp(0,1))
	self.titleLabel:setString(panelTitleLabelTxt)
	self.titleLabel:setPosition(ccp(labelPhPos.x, labelPhPos.y))
	self:addChild(self.titleLabel)
	--self.titleLabel:setToParentCenterHorizontal()

	local titleLabelSize	= self.titleLabel:getContentSize()
	local selfSize		= self.bg:getGroupBounds().size
	local deltaWidth	= (selfSize.width - titleLabelSize.width)
	self.titleLabel:setPositionX(deltaWidth/2 + self.bg:getPositionX())

	-- ----------------
	-- Set Buy Energy Txt
	-- -----------------
	local buyEnergyTxtKey	= "energy.panel.use.energy.txt"
	local buyEnergyTxtValue	= Localization:getInstance():getText(buyEnergyTxtKey)
	assert(buyEnergyTxtValue)
	self.buyEnergyTxt:setString(buyEnergyTxtValue)


	-- -----------------------------
	-- Set Buy And Continue Btn Label
	-- --------------------------------
	local buyBtnLabelTxtKey	= false
	local buyBtnLabelTxt	= false

	if self.continueCallback then
		-- Opend In Start Level Panel
		buyBtnLabelTxtKey	= "energy.panel.buy.continue.button.label"
	else
		-- Not Opened In Start Level Panel
		buyBtnLabelTxtKey	= "energy.panel.buy.button.label"
	end
	buyBtnLabelTxt		= Localization:getInstance():getText(buyBtnLabelTxtKey)
	self.buyAndContinueBtn:setLabel(buyBtnLabelTxt)

	he_log_warning("hard coded to use 9 windmill to buy energy !")
	self.buyAndContinueBtn:setWindmillNumber(9)

	-- -----------------------------
	-- Set Continue Btn Label
	-- --------------------------------
	local buyBtnLabelTxtKey 	= "energy.panel.continue.button.label"
	local buyBtnLabelTxtValue	= Localization:getInstance():getText(buyBtnLabelTxtKey)
	self.continueBtn:setString(buyBtnLabelTxtValue)

	-- -----------------------------
	-- Set Continue Btn Label
	-- --------------------------------
	self.discountTag:getChildByName("text"):setString(Localization:getInstance():getText("buy.gold.panel.discount"))

	-------------------------------------------------------
	-- Show Or Hide , self.askFriendBtn And self.buyBtn
	-- ---------------------------------------------------

	---- If Small Energy Bottle's Number <= 0 , Then Show Ask Friend Btn
	--if self.item1:getItemNumber() <= 0 then
	--	self.askFriendBtn:setVisible(true)
	--end

	-- If Large Energy Bottle's Number <= 0 , Then Show buyBtn 
	if self.item3:getItemNumber() <= 0 then
		self.buyBtn:setVisible(true)
	end

	----------------------------
	----- Add Event Listener
	--------------------------
	local function onLargeEnergyBottleNumberChange(newNumber, ...)
		assert(type(newNumber) == "number")
		assert(#{...} == 0)

		if newNumber == 0 then
			self.buyBtn:setVisible(true)
		end
	end
	self.item3:registerItemNumberChangeCallback(onLargeEnergyBottleNumberChange)

	local function onAskFriendBtnTapped()
		self:onAskFriendBtnTapped()
		GamePlayMusicPlayer:playEffect(GameMusicType.kClickCommonButton)
	end
	self.askFriendBtn:setTouchEnabled(true)
	self.askFriendBtn:setButtonMode(true)
	self.askFriendBtn:addEventListener(DisplayEvents.kTouchTap, onAskFriendBtnTapped)
	self.askFriendBtn:setVisible(not PrepackageUtil:isPreNoNetWork())

	-- -----------------------
	-- Buy Btn Event Listener
	-- ------------------------
	local function onBuyBtnTapped()
		self:onBuyBtnTapped()
		GamePlayMusicPlayer:playEffect(GameMusicType.kClickCommonButton)
	end

	self.buyBtn:setTouchEnabled(true)
	self.buyBtn:setButtonMode(true)
	self.buyBtn:addEventListener(DisplayEvents.kTouchTap, onBuyBtnTapped)

	-- ------------------------
	-- Close Button Event Listener
	-- -------------------------
	local function onCloseBtnTapped(evnet)
		self:onCloseBtnTapped()
	end
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)

	-- --------------
	-- Item Tap Listener
	-- ----------------
	local function onItemTapped(event)
		self:onItemTapped(event)
		GamePlayMusicPlayer:playEffect(GameMusicType.kClickBubble)
	end

	self.item1:getUI():setTouchEnabled(true)
	self.item2:getUI():setTouchEnabled(true)
	self.item3:getUI():setTouchEnabled(true)
	self.item1:getUI():addEventListener(DisplayEvents.kTouchTap, onItemTapped, self.item1)
	self.item2:getUI():addEventListener(DisplayEvents.kTouchTap, onItemTapped, self.item2)
	self.item3:getUI():addEventListener(DisplayEvents.kTouchTap, onItemTapped, self.item3)

	--------------------------------------
	-- Buy And Continue Btn Event Listener
	-- ------------------------------------
	
	local function onBuyAndContinueBtnTapped(event)
		self:onBuyAndContinueBtnTapped(event)
		GamePlayMusicPlayer:playEffect(GameMusicType.kClickCommonButton)
	end
	
	self.buyAndContinueBtn.ui:addEventListener(DisplayEvents.kTouchTap, onBuyAndContinueBtnTapped)

	local function onContinueBtnTapped(event)
		self:onContinueBtnTapped(event)
		GamePlayMusicPlayer:playEffect(GameMusicType.kClickCommonButton)
	end
	self.continueBtn.ui:addEventListener(DisplayEvents.kTouchTap, onContinueBtnTapped)
	self.continueBtn.ui:setVisible(false)

	---------------------
	-- Close Panel Callback
	-- --------------------
	self.closePanelCallback = false

	---------------------------------------
	--  Scale According To Screen Resolution
	--  -------------------------------------
	self:scaleAccordingToResolutionConfig()
end

function EnergyPanel:onCloseBtnTapped()
	if self.tappedState == self.TAPPED_STATE_NONE then
		self.tappedState = self.TAPPED_STATE_CLOSE_BTN_TAPPED
	else
		return
	end

	self.allowBackKeyTap = false
	local function onRemovePanelFinish()
		if self.closePanelCallback then
			self.closePanelCallback(true)
		end

		-- Check If Can Trigger Energy Notification
		local openIt	= false
		local curTime	= Localhost.getInstance():time()

		-- Get Last Popout Time
		--local lastOpenTime = ConfigSavedToFile:sharedInstance().configTable.addMaxEnergyPanel_lastOpenedTime
		local lastOpenTime	= CCUserDefault:sharedUserDefault():getDoubleForKey("energyNotificationSubPanel_lastOpenedTime")

		--local thresholdTime	= 30*1000
		local thresholdTime	= 7*24*60*60*1000

		if (not lastOpenTime or
			curTime - lastOpenTime > thresholdTime) and 
			self.curEnergy < 5 and
			--ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable == false then
			not CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification") then

		--if ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable == false then
		--if CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification") then
			
			-- Open It
			local notificationPanel = EnergyNotificationSubPanel:create()
			if notificationPanel then notificationPanel:popout() end
		end
	end

	self:remove(onRemovePanelFinish)
end

function EnergyPanel:setOnClosePanelCallback(callback, ...)
	assert(type(callback) == "function")
	assert(#{...} == 0)

	self.closePanelCallback = callback
end

------------------------------------
------	Item Tapped Handler
-------------------------------------

function EnergyPanel:onItemTapped(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchTap)
	assert(event.context)
	assert(#{...} == 0)

	if self.tappedState == self.TAPPED_STATE_NONE then
		-- Do Nothing
	else
		return
	end

	local tappedItem = event.context
	local itemType = tappedItem:getItemType()


	if tappedItem:getItemNumber() == 0 then
		return
	end

	-- If Energy Is Already Full
	--local curEnergy = UserManager.getInstance().user:getEnergy()
	--local maxEnergy = MetaManager.getInstance().global.user_energy_max_count
	local curEnergy = UserEnergyRecoverManager:sharedInstance():getEnergy()
	local maxEnergy	= UserEnergyRecoverManager:sharedInstance():getMaxEnergy()

	if curEnergy == maxEnergy then
		return
	end

	-- If Local Added Energy Point Added Is Enough, Then Return
	if self.energyPointWaitServerToConfirm >= maxEnergy - curEnergy then
		return
	else
	end

	-------------------------------------------------
	-- Local Added Energy Point, Wait Server To Confirm
	--------------------------------------------------
	local tappedEnergyNumber 		= tappedItem:getEnergyPointToAdd()
	self.energyPointWaitServerToConfirm	= self.energyPointWaitServerToConfirm + tappedEnergyNumber

	---------------------------
	--- Send Message To Server
	--- On Success Play Flying Energy Animation,
	--- And Then Add The User Energy
	------------------------------------------
	
	-- Play Flyling Energy Animation
	local function playFlyingEnergyAnimWrapper(finishCallback)

		-- --------------
		-- check If Disposed
		-- ------------------
		if self.isDisposed then
			finishCallback()
			return
		end

		local function animComplete()
			GamePlayMusicPlayer:playEffect(GameMusicType.kAddEnergy)
			finishCallback()
		end

		tappedItem:playFlyingEnergyAnimation(animComplete)
	end
	
	-- Send Server Msg
	local function sendUseEnergyBottleMessageWrapper(successCallback)

		local function onSuccess()

			self.energyPointWaitServerToConfirm = self.energyPointWaitServerToConfirm - tappedEnergyNumber

			HomeScene:sharedInstance():checkDataChange()
			HomeScene:sharedInstance().energyButton:updateView()
			successCallback()
		end

		self:sendUseEnergyBottleMessage(itemType, onSuccess)
	end

	-- Add The Energy
	local function updateItemNumber()

		-- --------------
		-- check If Disposed
		-- ------------------
		if self.isDisposed then return end
		tappedItem:updateItemNumber()
	end

	local chain = CallbackChain:create()
	chain:appendFunc(playFlyingEnergyAnimWrapper)
	chain:appendFunc(sendUseEnergyBottleMessageWrapper)
	chain:appendFunc(updateItemNumber)
	chain:call()
end

function EnergyPanel:sendUseEnergyBottleMessage(itemType, successCallback, ...)
	assert(type(itemType) == "number")
	assert(type(successCallback) == "function")
	assert(#{...} == 0)
	
	local logic = UseEnergyBottleLogic:create(itemType)
	logic:setSuccessCallback(successCallback)
	logic:start(true)
end

--------------------------------------
--- Function About Show / Hide Panel
-----------------------------------------

function EnergyPanel:onBuyAndContinueBtnTapped(event, ...)
	assert(event)
	assert(#{...} == 0)

	local function startBuyLogic()
		--local logic = BuyLogic:create()
		-- Need Energy To Max
		--local maxEnergy 	= self.maxEnergy
		--local newEnergy 	= UserManager.getInstance().user:getEnergy()
		local maxEnergy		= UserEnergyRecoverManager:sharedInstance():getMaxEnergy()
		local newEnergy		= UserEnergyRecoverManager:sharedInstance():getEnergy()

		local neededEnergy	= maxEnergy - newEnergy

		local curCash		= UserManager:getInstance().user:getCash()
		local neededCash	= self.goldPriceToBuyAEnergy * neededEnergy

		if curCash < neededCash then
			-- Not Has Enough Gold
			-- Pop Out The Buy Gold Panel

			local function createGoldPanel()
				local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
				if index ~= 0 then
					local panel = createMarketPanel(index)
					panel:popout()
				end
			end
			local text = {
				tip = Localization:getInstance():getText("buy.prop.panel.tips.no.enough.cash"),
				yes = Localization:getInstance():getText("buy.prop.panel.yes.buy.btn"),
				no = Localization:getInstance():getText("buy.prop.panel.not.buy.btn"),
			}
			CommonTipWithBtn:setShowFreeFCash(true)
			CommonTipWithBtn:showTip(text, "negative", createGoldPanel)
			-- CommonTip:showTip(Localization:getInstance():getText("buy.prop.panel.err.no.gold"), "negative", createGoldPanel)
		else

			local function onBuyEnergySuccessCallback()
				HomeScene:sharedInstance():checkDataChange()
				HomeScene:sharedInstance().energyButton:updateView()
				HomeScene:sharedInstance().goldButton:updateView()
			-- 	if not self.continueCallback then
			-- 		-- local text = Localization:getInstance():getText("energy.panel.buy.button.label")
			-- 		-- self.continueBtn:setString(text)
			-- 		local buyBtnLabelTxtKey 	= "energy.panel.buy.button.label"
			-- 		local buyBtnLabelTxtValue	= Localization:getInstance():getText(buyBtnLabelTxtKey)
			-- 		self.continueBtn:setString(buyBtnLabelTxtValue)
			-- 	else
			-- 		local buyBtnLabelTxtKey 	= "energy.panel.continue.button.label"
			-- 		local buyBtnLabelTxtValue	= Localization:getInstance():getText(buyBtnLabelTxtKey)
			-- 		self.continueBtn:setString(buyBtnLabelTxtValue)
			-- 	end
				if not self.continueCallback then
					self.continueBtn.ui:setButtonMode(false)
				end
				self.continueBtn.ui:setVisible(true)
				self.buyAndContinueBtn.ui:setVisible(false)
				self.discountTag:setVisible(false)
				GamePlayMusicPlayer:playEffect(GameMusicType.kAddEnergy)
			end

			local function onBuyEnergyFailCallback(evt)
				if evt and evt.data then 
					CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
				else 
					local networkType = MetaInfo:getInstance():getNetworkInfo();
					local errorCode = "-2";
					if networkType and networkType==-1 then 
						errorCode = "-6";
					end
					CommonTip:showTip(Localization:getInstance():getText("error.tip."..errorCode), "negative")
				end
			end

			local function onBuyEnergyExceptionCallback(evt)
				CommonTip:showTip(Localization:getInstance():getText("energy.panel.buy.energy.exception"), "negative")
			end

			local logic = BuyEnergyLogic:create(neededEnergy)
			logic:start(true, onBuyEnergySuccessCallback, onBuyEnergyFailCallback)
		end
	end

	if PrepackageUtil:isPreNoNetWork() then
		PrepackageUtil:showInGameDialog()
		return 
	end
	
	if RequireNetworkAlert:popout() then
		startBuyLogic()
	end
end

function EnergyPanel:onContinueBtnTapped(event, ...)
	assert(event)
	assert(#{...} == 0)

	--if self.tappedState == self.TAPPED_STATE_NONE then
	--	self.tappedState = self.TAPPED_STATE_BUY_AND_CONTINUE_BTN_TAPPED
	--else
	--	return
	--end

	if self.continueCallback then

		local function onRemoveAnimFinishCallback()
			self.continueCallback()
		end

		self:remove(onRemoveAnimFinishCallback)
	else
		-- Still Buy ...
		-- print("Buy Energy, Function Not Implemented Yet ... !")
		if self.tappedState == self.TAPPED_STATE_NONE then
			self.tappedState = self.TAPPED_STATE_CLOSE_BTN_TAPPED
		else
			return
		end


		local function onRemovePanelFinish()
			if self.closePanelCallback then
				self.closePanelCallback()
			end
		end
		self:remove(onRemovePanelFinish)
	end
end

-- function EnergyPanel:onBuyAndContinueBtnTapped(event, ...)
-- 	assert(event)
-- 	assert(#{...} == 0)

-- 	if self.buyAndContinueBtnState == self.BUY_AND_CONTINUE_BTN_STATE_BUY then

		


-- 	elseif self.buyAndContinueBtnState == self.BUY_AND_CONTINUE_BTN_STATE_CONTINUE then

		
-- 	else
-- 		assert(false)
-- 	end
-- end

function EnergyPanel:positionEnergyNumberLabel(...)
	assert(#{...} == 0)

	-- Get Energy Label Size
	--local labelSize = self.energyNumberLabel:getContentSize()

	-- Delta Width
	--local deltaWidth 	= self.energyIconSize.width - labelSize.width
	--self.energyNumberLabel:setPositionX(self.energyIconPos.x + deltaWidth/2)
end

function EnergyPanel:setEnergy(newEnergy, ...)
	assert(newEnergy)
	assert(#{...} == 0)

	self.curEnergy = newEnergy
	--self.energyNumberLabel:setString(tostring(self.curEnergy) .. self.separator .. tostring(self.maxEnergy))

	self.energyNumberCounter:setCurEnergy(self.curEnergy)
	self.energyNumberCounter:setTotalEnergy(self.maxEnergy)

	--self.energyNumberCounter:createRollingLabelAnim()
	--self:positionEnergyNumberLabel()
end

function EnergyPanel:setLeftSecondToRecover(leftSecond, ...)
	assert(leftSecond)
	assert(type(leftSecond) == "number")
	assert(#{...} == 0)

	if leftSecond == 0 then

		-- Energy Is Full
		local timeToRecoverLabelTxtKey	= "energy.panel.energy.is.full"
		local timeToRecoverLabelTxt	= Localization:getInstance():getText(timeToRecoverLabelTxtKey, {})
		if self.timeToRecoverLabel and not self.timeToRecoverLabel.isDisposed then
			self.timeToRecoverLabel:setString(timeToRecoverLabelTxt)
		end
	else
		-- Energy Is Not Full
		-- Seconds To Recover

		local needSecond	= false
		local recoverToEnergy	= false

		if self.curEnergy < 5 then
			needSecond = self:getSecondToRecoverToEnergy(5) + leftSecond
			recoverToEnergy	= 5
		else
			needSecond = self:getSecondToRecoverToEnergy(self.maxEnergy) + leftSecond
			recoverToEnergy = self.maxEnergy
		end

		local minuteFormat = self:convertSecondToMinuteFormat(needSecond)
		local timeToRecoverLabelTxtKey	= "energy.panel.time.to.five.energy.txt"
		local timeToRecoverLabelTxt	= Localization:getInstance():getText(timeToRecoverLabelTxtKey, {energy_number = recoverToEnergy})
		if self.timeToRecoverLabel and not self.timeToRecoverLabel.isDisposed then
			self.timeToRecoverLabel:setString(minuteFormat..timeToRecoverLabelTxt)
		end
	end
end

function EnergyPanel:getSecondToRecoverToEnergy(toEnergy, ...)
	assert(type(toEnergy) == "number")
	assert(#{...} == 0)

	local deltaEnergy = toEnergy - 1 - self.curEnergy
	local neededSecond = deltaEnergy * self.energyRecoverSecond

	return neededSecond
end


function EnergyPanel:convertSecondToMinuteFormat(second, ...)
	assert(second)
	assert(type(second) == "number")
	assert(#{...} == 0)

	local separator = ":"

	local minute		= math.floor(second / 60)
	local remainSecond	= second - minute * 60

	local hour		= false

	if minute >= 60 then
		hour = math.floor(minute / 60)
		minute = minute - hour * 60
	end

	local result = false

	if hour then
		-- result = tostring(hour) .. separator .. tostring(minute) .. separator .. tostring(remainSecond)
		result = string.format("%02d:%02d:%02d", hour, minute, remainSecond)
	else
		-- result = tostring(minute) .. separator .. tostring(remainSecond)
		result = string.format("%02d:%02d", minute, remainSecond)
	end

	return result
end

------------------------------------------------
---- Function About Check Energy Change
------------------------------------------------

-- Implementation Concern:
-- 1. Based On Already Design Of Data Model, Data Are Stored In UserManager, MetaManager, etc.
-- 	These Managers Didn't Dispatch Any Event When Their Data Are Changed.
--
-- 2. So, Most Data Change Are Checked In HomeScene:checkDataChange() Function. When A Data Change In UserManager Or MetaManager
-- 	Manually Call This Func, To Change Variable Change That We Are Interested In. This Function Will Dispatch Variable Change Event To All Views To Update.
--
-- 3. This Check Energy Change Method Is An Exception. Energy Will Changed By A Global EnergyRecoveryManager, Each Time The Countdown Is Reached, Will Automatically Add The Energy.
-- 	If Use HomeScene's Method, Then This Panel Should Know The Existence Of HomeScene, This Is Also A Bad Idea.
--	 So Manually Check It's Change Every Frame.
--

function EnergyPanel:checkEnergyChange(...)

	if self.isDisposed then return end -- fix

	assert(#{...} == 0)

	-- Check If Max Energy Change
	local newMaxEnergy = UserEnergyRecoverManager:sharedInstance():getMaxEnergy()

	if newMaxEnergy ~= self.maxEnergy then
		-- Wait To Manual Update, Play The Add Max Energy Anim

	else
		-- Check Energy
		--local newEnergy = UserManager.getInstance().user:getEnergy()
		local newEnergy = UserEnergyRecoverManager:sharedInstance():getEnergy()
		self:setEnergy(newEnergy)

		-- If Have Enough Energy To Play, Show The Continue Sub Panel
		-- he_log_warning("Hard Coded 5 Energy Required To Start A Level !")
		if newEnergy >= 5 then
			if self.continueCallback then

				self.buyAndContinueBtnState = self.BUY_AND_CONTINUE_BTN_STATE_CONTINUE

				-- Update Buy And Continue Btn Label
				self.buyAndContinueBtn.ui:setVisible(false)
				self.continueBtn.ui:setVisible(true)
				self.discountTag:setVisible(false)
			end
		end

		-- Check Energy Recover Time
		-- 如果正在倒计时，说明要根据时间恢复精力
		--if UserEnergyRecoverManager:sharedInstance():isCountingDown() then

		if newEnergy ~= self.maxEnergy then
			-- Energy It Wait To Recover
			local secondToWait = UserEnergyRecoverManager:sharedInstance():getCountdownSecondRemain()
			self:setLeftSecondToRecover(secondToWait)

			-- local need Point TO Max Energy
			-- Update self.buyAndContinueBtn's Coin Numbere
			local neededEnergy	= self.maxEnergy - newEnergy
			local neededGold	= self.goldPriceToBuyAEnergy * neededEnergy

			self.lastNeededGold = self.lastNeededGold or 5000
			if self.lastNeededGold ~= neededGold then
				self.buyAndContinueBtn:setWindmillNumber(neededGold)
				local pos = self.buyAndContinueBtn.label:getPosition()
				print(pos.x, pos.y)
				print("self.buyAndContinueBtn:setWindmillNumber(neededGold)", neededGold)
			end
			self.lastNeededGold = neededGold	
		else
			-- Energy Is Full
			self:setLeftSecondToRecover(0)
			-- self.buyAndContinueBtn:hideWindmill()
			self.buyAndContinueBtn.ui:setVisible(false)
			self.continueBtn.ui:setVisible(true)
			self.discountTag:setVisible(false)
		end
	end
end

function EnergyPanel:registerCheckEnergyChangeFunc(...)
	assert(#{...} == 0)

	assert(not self.checkEnergyChangeFunc)

	local function checkEnergyChange()
		self:checkEnergyChange()
	end

	self.checkEnergyChangeFunc = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(checkEnergyChange, 1/60, false)
end


function EnergyPanel:unregisterCheckEnergyChangeFunc(...)
	assert(#{...} == 0)

	assert(self.checkEnergyChangeFunc)
	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.checkEnergyChangeFunc)
	self.checkEnergyChangeFunc = nil
end

--------------------------------------------------
----	OnEnter And OnExit Handler
-------------------------------------------------

function EnergyPanel:onEnterHandler(event, ...)
	assert(event)
	assert(#{...} == 0)

	BasePanel.onEnterHandler(self, event)

	if event == "enter" then
		print("EnergyPanel:OnEnter Called !")
		self:registerCheckEnergyChangeFunc()

	elseif event == "exit" then
		print("EnergyPanel:OnExit Called !")
		self:unregisterCheckEnergyChangeFunc()
	end
end

-----------------------------------------------------
---- Two Different Method To Show / Hide Panel
------------------------------------------------------

function EnergyPanel:popout(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	assert(self.showed == false)
	self.showMode = self.SHOW_MODE_POPOUT
	self.showed = true

	local function animFinished()

		local function animCallback()
			self.allowBackKeyTap = true
			if animFinishCallback then
				animFinishCallback()
			end
		end

		-- Check If Can PopOut The AddMaxEnergyPanel
		local info
		if UserManager:getInstance():getUserRef():getEnergy() < 10 then
			info = PushActivity:sharedInstance():onEnergyPanel()
		end
		if info then
			local panel = PushActivityPanelEnergy:create(info)
			if panel then
				local popoutPos = self.panelExchangeAnim:getPopShowPos()
				local selfSize = self.ui:getChildByName("hit_area"):getGroupBounds().size
				local energyPanelBottomPosY = popoutPos.y - selfSize.height
				local selfParent = self:getParent()
				local posInWorldSpace = selfParent:convertToWorldSpace(ccp(0, energyPanelBottomPosY))
				posInWorldSpace.y = posInWorldSpace.y - 40
				panel:popout(self, animCallback, posInWorldSpace.y)
				self.bottomBubblePanel = panel
			end
		else
			self:chekPopoutBottomBubbleWindow()
			animCallback()
		end
	end
	self.panelExchangeAnim:popout(animFinished)
end

-- function EnergyPanel:getHCenterInScreenX(...)
-- 	assert(#{...} == 0)

-- 	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
-- 	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
-- 	local selfWidth	= self.bg:getGroupBounds().size.width

-- 	local deltaWidth = visibleSize.width - selfWidth
-- 	local halfDeltaWidth = deltaWidth / 2

-- 	return visibleOrigin.x + halfDeltaWidth
-- end

function EnergyPanel:chekPopoutBottomBubbleWindow(...)
	assert(#{...} == 0)
	if self.curEnergy < 10 then
		-- copy
		local addMaxChance = kPanelShowChance.kAddMaxEnergy
		local wechatChance = kPanelShowChance.kWeChat
		local weiboChance = kPanelShowChance.kWeibo
		local remindChance = kPanelShowChance.kRemindAskingEnergy
		local nothingChance = kPanelShowChance.kNothing
		-- check
		if self.maxEnergy >= 40 then addMaxChance = 0 end
		if not MaintenanceManager:getInstance():isEnabled("CDKeyCode") then wechatChance, weiboChance = 0, 0 end
		local flag = UserManager:getInstance().userExtend.flag or 0
		local bit = require("bit")
		if UserManager:getInstance().userExtend:isFlagBitSet(2) then wechatChance = 0 end
		if UserManager:getInstance().userExtend:isFlagBitSet(3) then weiboChance = 0 end
		if UserManager:getInstance():getDailyData():getReceiveGiftCount() >=
			MetaManager:getInstance():getDailyMaxReceiveGiftCount() or
			#UserManager:getInstance():getWantIds() > 0 or
			self.curEnergy >= 5 then remindChance = 0 end
		-- random
		local up = addMaxChance + wechatChance + weiboChance + nothingChance
		if up == 0 then return end
		local res = math.random(up)
		while true do
			res = res - addMaxChance
			if res < 0 then	self:popoutAddMaxEnergyPanel() break end
			res = res - wechatChance
			if res < 0 then self:popoutSocialNetworkFollowPanel("wechat") break end
			res = res - weiboChance
			if res < 0 then self:popoutSocialNetworkFollowPanel("weibo") break end
			res = res - remindChance
			if res < 0 then self:popoutRemindAskingEnergyPanel() end
			res = res - nothingChance
			if res < 0 then break end
		end
	end
end

function EnergyPanel:popoutSocialNetworkFollowPanel(pnlType)
	if __IOS_FB then return end -- facebook 没有关注官方微博功能
	-- popout position
	local popoutPos = self.panelExchangeAnim:getPopShowPos()
	local selfSize = self.ui:getChildByName("hit_area"):getGroupBounds().size
	local energyPanelBottomPosY = popoutPos.y - selfSize.height
	local selfParent = self:getParent()
	local posInWorldSpace = selfParent:convertToWorldSpace(ccp(0, energyPanelBottomPosY))
	posInWorldSpace.y = posInWorldSpace.y - 40
	-- popout
	if pnlType == "wechat" then
		if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
			self.bottomBubblePanel = SocialNetworkFollowPanel:create(self, kSocialType.kMitalk, posInWorldSpace.y)
		else
			self.bottomBubblePanel = SocialNetworkFollowPanel:create(self, kSocialType.kWeChat, posInWorldSpace.y)
		end
	elseif pnlType == "weibo" then
		self.bottomBubblePanel = SocialNetworkFollowPanel:create(self, kSocialType.kWeibo, posInWorldSpace.y)
	end
	if self.bottomBubblePanel then self.bottomBubblePanel:popout() end
end

function EnergyPanel:popoutRemindAskingEnergyPanel()
	print("EnergyPanel:popoutRemindAskingEnergyPanel")
	local count = FriendManager:getInstance():getFriendCount()
	local popoutPos = self.panelExchangeAnim:getPopShowPos()
	local selfSize = self.ui:getChildByName("hit_area"):getGroupBounds().size
	local energyPanelBottomPosY = popoutPos.y - selfSize.height
	local selfParent = self:getParent()
	local posInWorldSpace = selfParent:convertToWorldSpace(ccp(0, energyPanelBottomPosY))
	posInWorldSpace.y = posInWorldSpace.y - 40
	self.bottomBubblePanel = RemindAskingEnergyPanel:create(self, posInWorldSpace.y)
	if self.bottomBubblePanel then
		if count > 0 then
			local pos = self.askFriendBtn:getPosition()
			pos = {x = pos.x - 30, y = pos.y - 20}
			local rPos = self.askFriendBtn:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
			self.bottomBubblePanel:popout(rPos)	
		else self.bottomBubblePanel:popout() end
	end
end

function EnergyPanel:popoutAddMaxEnergyPanel(...)
	assert(#{...} == 0)
	-- popout position
	local popoutPos			= self.panelExchangeAnim:getPopShowPos()
	local selfSize = self.ui:getChildByName("hit_area"):getGroupBounds().size
	local energyPanelBottomPosY	= popoutPos.y - selfSize.height
	local selfParent 	= self:getParent()
	local posInWorldSpace	= selfParent:convertToWorldSpace(ccp(0, energyPanelBottomPosY))
	-- energy lighting mark position
	local energyIconPos		= self.energyIcon:getPosition()
	local energyIconSize		= self.energyIcon:getGroupBounds().size
	local energyIconCenterPos	= ccp(energyIconPos.x + energyIconSize.width/2, energyIconPos.y - energyIconSize.height/2)
	local energyParent		= self.energyIcon:getParent()
	local energyIconCenterPosInWorldSpace	= energyParent:convertToWorldSpace(ccp(energyIconCenterPos.x, energyIconCenterPos.y))
	-- popout
	self.bottomBubblePanel = AddMaxEnergyPanel:create(self, posInWorldSpace.y, energyIconCenterPosInWorldSpace)
	self.bottomBubblePanel:popout()
end

function EnergyPanel:popoutWithoutBgFadeIn(animFinishCallback, ...)
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)
	
	assert(self.showed == false)
	self.showMode 	= self.SHOW_MODE_POPOUT
	self.showed	= true

	local function animFinished()
		local function animFinishedFunc()
			self.allowBackKeyTap = true
			if animFinishCallback then
				animFinishCallback()
			end
		end

		local info
		if UserManager:getInstance():getUserRef():getEnergy() < 10 then
			info = PushActivity:sharedInstance():onEnergyPanel()
		end
		if info then
			local panel = PushActivityPanelEnergy:create(info)
			if panel then
				local popoutPos = self.panelExchangeAnim:getPopShowPos()
				local selfSize = self.ui:getChildByName("hit_area"):getGroupBounds().size
				local energyPanelBottomPosY = popoutPos.y - selfSize.height
				local selfParent = self:getParent()
				local posInWorldSpace = selfParent:convertToWorldSpace(ccp(0, energyPanelBottomPosY))
				posInWorldSpace.y = posInWorldSpace.y - 40
				panel:popout(self, animCallback, posInWorldSpace.y)
				self.bottomBubblePanel = panel
			end
		else
			self:chekPopoutBottomBubbleWindow()
			animFinishedFunc()
		end
	end

	self.panelExchangeAnim:popoutWithoutBgFadeIn(animFinished)
end

function EnergyPanel:playAddEnergyAnim(animFinishCallback, ...)
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	local cppStencil = self.energyClipping:getStencil()

	-- Init 
	local function initActionFunc()
		self.energyClipping:setVisible(true)
		cppStencil:setPositionY(-self.energyClippingHeight)
	end
	local initAction = CCCallFunc:create(initActionFunc)
	
	-- Move Clipping Up
	local moveTo 		= CCMoveTo:create(0.5, ccp(0,0))
	local targetMoveTo	= CCTargetedAction:create(cppStencil, moveTo)

	-- Anim Finished
	local function animFinishedFunc()
		self.energyClipping:setVisible(false)

		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishedAction = CCCallFunc:create(animFinishedFunc)

	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(initAction)
	actionArray:addObject(targetMoveTo)
	actionArray:addObject(animFinishedAction)

	-- Seq
	local seq = CCSequence:create(actionArray)
	self.energyClipping:runAction(seq)
end

function EnergyPanel:updateAfterMaxEnergyChange(...)
	assert(#{...} == 0)

	local newMaxEnergy = UserEnergyRecoverManager:sharedInstance():getMaxEnergy()

	local function onAnimFinished()
		-- Flag To Indicate Already Update The View After Max Energy Changed
		self.maxEnergy = newMaxEnergy
	end
	self.energyNumberCounter:setCurAndTotalEnergyWithAnim(newMaxEnergy, newMaxEnergy, onAnimFinished)
end

function EnergyPanel:playNewMaxEnergyAnim(animFinishCallback, ...)
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)
end

function EnergyPanel:remove(animFinishCallbck, ...)
	assert(animFinishCallbck == false or type(animFinishCallbck) == "function")
	assert(#{...} == 0)

	assert(self.showed == true)

	local function onAnimFinish()
		if animFinishCallbck then
			print("EnergyPanel:remove onAnimFinished Called !")
			animFinishCallbck()
		end
	end

	self.panelExchangeAnim:remove(onAnimFinish)
	self.showed = false

	if self.bottomBubblePanel then
		self.bottomBubblePanel:remove()
	end
end

function EnergyPanel:onAskFriendBtnTapped()
	print("EnergyPanel:onAskFriendBtnTapped")
	if __IOS_FB and not SnsProxy:isLogin() then 
		CommonTip:showTip(Localization:getInstance():getText("error.tip.facebook.login"),nil,nil,2)
		return
	end
	local level = UserManager:getInstance().user:getTopLevelId()
	local meta = MetaManager:getInstance():getFreegift(level)
	local function onUpdateFriend(result, evt)
		if not self or self.isDisposed then return end
		if result == "success" then
			local function confirmAskFriend(selectedFriendsID)
				if #selectedFriendsID > 0 then
					local todayWants = UserManager:getInstance():getWantIds()
					local todayWantsCount = #todayWants

					local function onRequestSuccess()
						local home = HomeScene:sharedInstance()
						DcUtil:requestEnergy(#selectedFriendsID,level)
						if not self or self.isDisposed then return end
						if not __IOS_FB and home and todayWants and todayWantsCount < 1 then
							local sprite = home:createFlyToBagAnimation(10013, 1)
							local size = self.askFriendBtn:getGroupBounds().size
							local pos = self.askFriendBtn:getPosition()
							-- pos.x = pos.x + size.width / 2
							-- pos.y = pos.y - size.height / 2
							local parent = self.askFriendBtn:getParent()
							pos = parent:convertToWorldSpace(ccp(pos.x, pos.y))
							sprite:setPosition(ccp(pos.x + size.width / 2, pos.y - size.height / 2))
							sprite:playFlyToAnim(false, false)

							self.item1:updateItemNumber()
							self.item2:updateItemNumber()
							self.item3:updateItemNumber()
						end
						CommonTip:showTip(Localization:getInstance():getText("energy.panel.ask.energy.success"), "positive")
					end
					local function onFail(evt)
						if not self or self.isDisposed then return end
						CommonTip:showTip(Localization:getInstance():getText("error.tip."..evt.data), "negative")
					end
					if __IOS_FB then
						if SnsProxy:isShareAvailable() then
							local callback = {
								onSuccess = function(result)
									print("result="..table.tostring(result))
									FreegiftManager:sharedInstance():requestGift(selectedFriendsID, meta.itemId, onRequestSuccess, onFail)
								end,
								onError = function(err)
									print("err="..err)
								end
							}
							-- friendIds
							local profile = UserManager.getInstance().profile
							local userName = ""
							if profile and profile:haveName() then
								userName = profile:getDisplayName()
							end

							local title = Localization:getInstance():getText("facebook.request.asking.freegift.title", {user=userName, item="精力瓶"})
							local message = Localization:getInstance():getText("facebook.request.asking.freegift.message",  {user=userName, item="精力瓶"})

							local snsIds = FriendManager.getInstance():getFriendsSnsIdByUid(selectedFriendsID)
							SnsProxy:sendRequest(snsIds, title, message, false, FBRequestObject.ENERGY, callback)
						end
					else 
						FreegiftManager:sharedInstance():requestGift(selectedFriendsID, meta.itemId, onRequestSuccess, onFail)
					end
				end
			end
			local panel = AskForEnergyPanel:create(confirmAskFriend)
			if panel then panel:popout() end
		else
			local message = ''
			local err_code = tonumber(evt.data)
			if err_code then message = Localization:getInstance():getText("error.tip."..err_code) end
			CommonTip:showTip(message, "negative")
		end
	end
	FreegiftManager:sharedInstance():updateFriendInfos(true, onUpdateFriend)
end

function EnergyPanel:onBuyBtnTapped(...)
	assert(#{...} == 0)
	print("EnergyPanel:onBuyBtnTapped Called !")

	---- If Has No Energy Bottle
	--if tappedItem:getItemNumber() == 0 then
		
		local function enableClick()
			if self.isDisposed then return end
			self.buyBtn:setTouchEnabled(true)
			self.buyBtn:setButtonMode(true)
		end

		local function onBoughtCallback()
			if self.isDisposed then return end
			enableClick()
			self.item3:updateItemNumber()
			HomeScene:sharedInstance().goldButton:updateView()
		end

		if __ANDROID then -- ANDROID
			self.buyBtn:setTouchEnabled(false)
			self.buyBtn:setButtonMode(false)
			local logic = IngamePaymentLogic:create(18)
			logic:buy(onBoughtCallback, enableClick, enableClick)
		else -- else, on IOS and PC we use gold!
			local panel = BuyPropPanel:create(18)
			panel:setBoughtCallback(onBoughtCallback)
			panel:popout()
			return
		end
	--end
end

function EnergyPanel:show(animFinishCallbck, ...)
	assert(animFinishCallbck == false or type(animFinishCallbck) == "function")
	assert(#{...} == 0)

	assert(self.showed == false)
	self.panelExchangeAnim:show(animFinishCallbck)
	self.showed = true
end

function EnergyPanel:hide(animFinishCallbck, ...)
	assert(animFinishCallbck == false or type(animFinishCallbck) == "function")
	assert(#{...} == 0)

	self.panelExchangeAnim:hide(animFinishCallbck)
end

-----------------------------------------------------------------------
-- Note:
-- If Has Parameter continueCallback Indicate EnergyPanel Not Opened In 
-- The Start Game Panel
-- ---------------------------------

function EnergyPanel:create(continueCallback, ...)
	assert(continueCallback == false or type(continueCallback) == "function")
	assert(#{...} == 0)

	local newEnergyPanel = EnergyPanel.new()
	newEnergyPanel:init(continueCallback)
	return newEnergyPanel
end