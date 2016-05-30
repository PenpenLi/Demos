
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
require "zoo.panelBusLogic.IapBuyPropLogic"
require "zoo.panel.component.energyPanel.IapBuyMiddleEnergyPanel"
require "zoo.panel.ConfirmBuyFullEnergyPanel"
require "zoo.panel.TwoYearsGiftEnegy"
require "zoo.panel.TwoYearsEnergyPanel"
require "zoo.panel.component.energyPanel.WeeklyRacePromotionPanel"


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

	self.suspendUpdateEnergy = false

	self.energyQueue = {}
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
	self.energyIcon			    = self.fadeArea:getChildByName("energyIcon")
	self.energyBrightness		= self.fadeArea:getChildByName("energyBrightness")
	self.energyNumberCounterRes	= self.fadeArea:getChildByName("energyCounter")
	self.energyHighlight	    = self.fadeArea:getChildByName("highlight")

	self.energyHighlight:setVisible(false)
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
	self.buyEnergyTxt	= self.clippingAreaBelow:getChildByName("useEnergyTxt")
	self.askFriendBtn	= self.clippingAreaBelow:getChildByName("askFriendBtn")
	self.buyBtn			= self.clippingAreaBelow:getChildByName("buyBtn")
	self.goldBuyMidBtn	= GroupButtonBase:create(self.clippingAreaBelow:getChildByName("goldBuyMidBtn"))


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
	self.askFriendBtn = GroupButtonBase:create(self.askFriendBtn)
	self.buyBtn = GroupButtonBase:create(self.buyBtn)
	self.buyBtn:setColorMode(kGroupButtonColorMode.blue)
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
	self.askFriendBtn:setString(Localization:getInstance():getText("energy.panel.askFriend"))

	local buyBtnLabelkey	= "energy.panel.buyBtn"
	local buyBtnLabelValue	= Localization:getInstance():getText(buyBtnLabelkey, {}) 
	self.buyBtn:setString(buyBtnLabelValue)

	----------------------
	-- Get Data About UI
	-- -------------------
	local rectSize = self.energyIcon:getGroupBounds().size
	self.energyIconSize = {width = rectSize.width, height = rectSize.height}
	
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
	self.askFriendBtn:addEventListener(DisplayEvents.kTouchTap, onAskFriendBtnTapped)
	self.askFriendBtn:setVisible(not PrepackageUtil:isPreNoNetWork())

	-- -----------------------
	-- Buy Btn Event Listener
	-- ------------------------
	local function onBuyBtnTapped()
		self:onBuyBtnTapped()
		GamePlayMusicPlayer:playEffect(GameMusicType.kClickCommonButton)
	end

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

	------------------------------
	-- Buy middle energy on iOS
	------------------------------
	if __IOS then
		local userExtend = UserManager:getInstance().userExtend
		self.goldBuyMidBtn:setColorMode(kGroupButtonColorMode.blue)
		self.goldBuyMidBtn:setString(Localization:getInstance():getText("buy.prop.panel.btn.buy.txt"))

		local function onBoughtCallback()
			if self.isDisposed then return end
			self.item2:updateItemNumber()
			HomeScene:sharedInstance().goldButton:updateView()
		end
		local function onGoldButton()
			local panel = PayPanelWindMill:create(17, onBoughtCallback)
			if panel then panel:popout() end
		end
		self.goldBuyMidBtn:addEventListener(DisplayEvents.kTouchTap, onGoldButton)

	 	self.goldBuyMidBtn:setVisible(self.item2:getItemNumber() <= 0)

		local function onChange(num)
 			self.goldBuyMidBtn:setVisible(self.item2:getItemNumber() <= 0)
 			if self.rmbBuyMidEnergyPanel and self.item2:getItemNumber() > 0 then
 				self.rmbBuyMidEnergyPanel:remove()
 				self.rmbBuyMidEnergyPanel = nil
 				self.bottomBubblePanel = nil
 			end
		end
		self.item2:registerItemNumberChangeCallback(onChange)
	else
		self.goldBuyMidBtn:setVisible(false)
	end
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
		if event.context == self.item1 then
			self:onAskFriendBtnTapped()
		elseif event.context == self.item2 then
			if __IOS then
				local function onBoughtCallback()
					if self.isDisposed then return end
					self.item2:updateItemNumber()
					HomeScene:sharedInstance().goldButton:updateView()
				end
				local panel = PayPanelWindMill:create(17, onBoughtCallback)
				if panel then panel:popout() end
			end
		elseif event.context == self.item3 then
			self:onBuyBtnTapped()
		end
		return
	end

	-- If Energy Is Already Full
	--local curEnergy = UserManager.getInstance().user:getEnergy()
	--local maxEnergy = MetaManager.getInstance().global.user_energy_max_count
	local curEnergy = UserEnergyRecoverManager:sharedInstance():getEnergy()
	local maxEnergy	= UserEnergyRecoverManager:sharedInstance():getMaxEnergy()

	if curEnergy == maxEnergy then
		CommonTip:showTip(Localization:getInstance():getText("energy.panel.full.tip"), "positive")
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

		-- 飞完了 再改 界面上 显示 的 精力数字
		self.suspendUpdateEnergy = true

		local function animComplete()
			GamePlayMusicPlayer:playEffect(GameMusicType.kAddEnergy)
			finishCallback()
		end

		local function flyComplete()
			self:playHighligthAnim()
			setTimeOut(
				function()
					if self.isDisposed==false then
						self:showEnergyAddedText(tappedEnergyNumber)
					end
				end,
				6/24
			)
			setTimeOut(
				function()
					if self.isDisposed==false and #self.energyQueue > 0 then
						self:setEnergy(table.remove(self.energyQueue, 1))
					end
					self.suspendUpdateEnergy = false
				end,
				6/24
			)
		end

		tappedItem:playFlyingEnergyAnimation(animComplete, flyComplete)
	end
	
	-- Send Server Msg
	local function sendUseEnergyBottleMessageWrapper(successCallback)

		local function onSuccess()

			table.insert(self.energyQueue, UserEnergyRecoverManager:sharedInstance():getEnergy())
			self.energyPointWaitServerToConfirm = self.energyPointWaitServerToConfirm - tappedEnergyNumber

			HomeScene:sharedInstance():checkDataChange()
			HomeScene:sharedInstance().energyButton:updateView()
			successCallback()
		end

		local function onFail(evt)
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
			self.energyPointWaitServerToConfirm	= self.energyPointWaitServerToConfirm - tappedEnergyNumber
		end

		self:sendUseEnergyBottleMessage(itemType, onSuccess, onFail)
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
	chain:appendFunc(sendUseEnergyBottleMessageWrapper)
	chain:appendFunc(playFlyingEnergyAnimWrapper)
	chain:appendFunc(updateItemNumber)
	chain:call()
end

function EnergyPanel:sendUseEnergyBottleMessage(itemType, successCallback, failCallback, ...)
	assert(type(itemType) == "number")
	assert(type(successCallback) == "function")
	assert(#{...} == 0)
	
	local logic = UseEnergyBottleLogic:create(itemType)
	logic:setSuccessCallback(successCallback)
	logic:setFailCallback(failCallback)
	logic:start(true)
end

--------------------------------------
--- Function About Show / Hide Panel
-----------------------------------------

function EnergyPanel:onBuyAndContinueBtnTapped(event, ...)
	assert(event)
	assert(#{...} == 0)

	local function startBuyLogic()
		local panel = ConfirmBuyFullEnergyPanel:create(self.continueCallback ~= false)
		panel:addEventListener(kPanelEvents.kClose, function(evt)
				if evt.data == true then
					self:onCloseBtnTapped()
				else
					self.energyRecoverTutorialLayer = self:checkDoEnergyBottleTutorial()
				end
			end)
		panel:popout()
	end

	if PrepackageUtil:isPreNoNetWork() then
		PrepackageUtil:showInGameDialog()
		return 
	end
	
	startBuyLogic()
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

-- function EnergyPanel:playTextFloatAnim()
-- 	local delay = CCDelayTime:create(6/24)

-- 	local function __showEnergyAddedText()
-- 		self:showEnergyAddedText()
-- 	end
-- 	local showText = CCCallFunc:create(__showEnergyAddedText)

-- 	local seq = CCSequence:createWithTwoActions(delay, showText)

-- 	self.energyIcon:runAction(seq)
-- end	

function EnergyPanel:showEnergyAddedText(energyAdded)
	local text = '+'..energyAdded
	local fntFile = "fnt/star_entrance.fnt"
	local label = BitmapText:create('', fntFile)
	label:setPreferredSize(100, 100)
	local parent = self.energyNumberCounter:getParent()
	local pos = self.energyNumberCounter:getPosition()
	local size = self.energyNumberCounter:getGroupBounds().size
	label:setString(text)
	parent:addChild(label)

	label:setAnchorPoint(ccp(0.5, 0.5))
	label:setPositionY(pos.y - 20)
	label:setPositionX(pos.x + 45)
	label:setScale(2)

	local moveBy = CCMoveBy:create(16/24, ccp(0, 50))
	local delay = CCDelayTime:create(10/24)
	local fadeOut = CCFadeOut:create(6/24)

	local seq = CCSequence:createWithTwoActions(delay, fadeOut)
	local spawn = CCSpawn:createWithTwoActions(seq, moveBy)

	local function __finish()
		label:removeFromParentAndCleanup(true)
	end

	local finish = CCCallFunc:create(__finish)

	local action = CCSequence:createWithTwoActions(spawn, finish)
	label:runAction(action)

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

		if self.suspendUpdateEnergy == false then
			self:setEnergy(newEnergy)
		end

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
local popoutSequence;

function EnergyPanel:addPopoutSub(func, index)
	index = index or #popoutSequence + 1
	if index <= 0 then index = 1 end
	if index > #popoutSequence then index = #popoutSequence end
	table.insert(popoutSequence, index, func)
end

function EnergyPanel:removePopoutSub(index)
	if index <= 0 then index = 1 end
	if index > #popoutSequence then index = #popoutSequence end
	table.remove(popoutSequence, index)
end

function EnergyPanel:indexPopoutSub(func)
	return table.indexOf(popoutSequence, func)
end

function EnergyPanel:popout(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	assert(self.showed == false)
	self.showMode = self.SHOW_MODE_POPOUT
	self.showed = true

	local function animFinished()
		for k, v in ipairs(popoutSequence) do
			if v(self) then break end
		end

		self.allowBackKeyTap = true
		if animFinishCallback then
			animFinishCallback()
		end
	end
	self.panelExchangeAnim:popout(animFinished)
end

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
		if up == 0 then return false end
		local res = math.random(up)
		while true do

			res = res - addMaxChance
			if res < 0 then
				self:popoutAddMaxEnergyPanel()
				return true
			end

			res = res - wechatChance
			if res < 0 then
				self:popoutSocialNetworkFollowPanel("wechat")
				return true
			end

			res = res - weiboChance
			if res < 0 then
				self:popoutSocialNetworkFollowPanel("weibo")
				return true
			end

			res = res - remindChance
			if res < 0 then
				self:popoutRemindAskingEnergyPanel()
				return true
			end

			res = res - nothingChance
			if res < 0 then
				return true
			end
		end
	end
	return false
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

function EnergyPanel:popoutTwoYearsEnergyPanel( onGetRewardTapped , toPos )
	print("EnergyPanel:popoutRemindAskingEnergyPanel")
	local count = FriendManager:getInstance():getFriendCount()
	local popoutPos = self.panelExchangeAnim:getPopShowPos()
	local selfSize = self.ui:getChildByName("hit_area"):getGroupBounds().size
	local energyPanelBottomPosY = popoutPos.y - selfSize.height
	local selfParent = self:getParent()
	local posInWorldSpace = selfParent:convertToWorldSpace(ccp(0, energyPanelBottomPosY))
	posInWorldSpace.y = posInWorldSpace.y - 40
	self.bottomBubblePanel = TwoYearsEnergyPanel:create(self, posInWorldSpace.y , onGetRewardTapped , toPos)
	if self.bottomBubblePanel then
		self.bottomBubblePanel:popout()
	end
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

local popoutWithoutBgFadeInSequence;

function EnergyPanel:addPopoutWithoutBgFadeInSub(func, index)
	local index = index or #popoutWithoutBgFadeInSequence + 1
	if index <= 0 then index = 1 end
	if index > #popoutWithoutBgFadeInSequence then index = #popoutWithoutBgFadeInSequence end
	table.insert(popoutWithoutBgFadeInSequence, index, func)
end

function EnergyPanel:removePopoutWithoutBgFadeInSub(index)
	if index <= 0 then index = 1 end
	if index > #popoutWithoutBgFadeInSequence then index = #popoutWithoutBgFadeInSequence end
	table.remove(popoutWithoutBgFadeInSequence, index)
end

function EnergyPanel:indexPopoutWithoutBgFadeInSub(func)
	return table.indexOf(popoutWithoutBgFadeInSequence, func)
end

function EnergyPanel:popoutWithoutBgFadeIn(animFinishCallback, ...)
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)
	
	assert(self.showed == false)
	self.showMode 	= self.SHOW_MODE_POPOUT
	self.showed	= true

	local function animFinished()
		for k, v in ipairs(popoutWithoutBgFadeInSequence) do
			if v(self) then break end
		end

		self.allowBackKeyTap = true
		if animFinishCallback then
			animFinishCallback()
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

function EnergyPanel:playHighligthAnim(animFinishCallback)
	local highlight = self.energyHighlight

	-- Init 
	local function initActionFunc()
		highlight:setVisible(true)
	end
	local initAction = CCCallFunc:create(initActionFunc)
	
	-- Move Clipping Up
	local fadeIn 		= CCFadeIn:create(4/24)
	local fadeOut 		= CCFadeOut:create(4/24)

	-- Anim Finished
	local function animFinishedFunc()
		highlight:setVisible(false)

		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishedAction = CCCallFunc:create(animFinishedFunc)

	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(initAction)
	actionArray:addObject(fadeIn)
	actionArray:addObject(fadeOut)
	actionArray:addObject(animFinishedAction)

	-- Seq
	local seq = CCSequence:create(actionArray)
	highlight:runAction(seq)
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

	if __ANDROID then 
		PaymentManager.getInstance():setCurrentEnergyPanel(nil)
	end

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

	if self.energyRecoverTutorialLayer then
		self.energyRecoverTutorialLayer:removeFromParentAndCleanup(true)
		self.energyRecoverTutorialLayer = nil
	end
end

function EnergyPanel:onAskFriendBtnTapped()
	print("EnergyPanel:onAskFriendBtnTapped")
	if __IOS_FB and not SnsProxy:isLogin() then 
		CommonTip:showTip(Localization:getInstance():getText("error.tip.facebook.login"),nil,nil,2)
		return
	end

	local todayWants = UserManager:getInstance():getWantIds()
	local todayWantsCount = #todayWants
	local function onRequestSuccess()
		if not self or self.isDisposed then return end
		self.item1:updateItemNumber()
		self.item2:updateItemNumber()
		self.item3:updateItemNumber()
	end
	AskForEnergyPanel:popoutPanel(onRequestSuccess)
end

function EnergyPanel:onBuyBtnTapped(...)
	assert(#{...} == 0)
	print("EnergyPanel:onBuyBtnTapped Called !")

	---- If Has No Energy Bottle
	--if tappedItem:getItemNumber() == 0 then
		local function onBoughtCallback()
			if self.isDisposed then return end
			self.item3:updateItemNumber()
			HomeScene:sharedInstance().goldButton:updateView()
		end

		local function onFailCallback(errCode, errMsg)
			if errCode == 730241 or errCode == 730247 then
				CommonTip:showTip(errMsg, "negative")
			else
				CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
			end
		end

		local function onCancelCallback()
		end


		if __ANDROID then -- ANDROID
			PaymentManager.getInstance():setCurrentEnergyPanel(self)
			local logic = IngamePaymentLogic:create(18)
			logic:buy(onBoughtCallback, onFailCallback, onCancelCallback)
		else -- else, on IOS and PC we use gold!
			local panel = PayPanelWindMill:create(18, onBoughtCallback)
			if panel then panel:popout() end
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

function EnergyPanel:tryPopoutWeeklyRacePushPanel()
	local user = UserManager:getInstance():getUserRef()
	local energyUnit = MetaManager:getInstance().global.user_energy_level_consume or 5
	local now = Localhost:time()
	local create = UserManager:getInstance().mark.createTime
	local todayStart = math.floor((now - create) / 86400000) * 86400000 + create
	
	if SeasonWeeklyRaceManager:getInstance():isLevelReached(user:getTopLevelId()) and
		user:getEnergy() < energyUnit and SeasonWeeklyRaceManager:getInstance():getUpdateTime() < todayStart and
		SeasonWeeklyRaceManager:getInstance():getLeftPlay() > 0 then
		local popoutPos = self.panelExchangeAnim:getPopShowPos()
		local selfSize = self.ui:getChildByName("hit_area"):getGroupBounds().size
		local energyPanelBottomPosY = popoutPos.y - selfSize.height
		local panel = WeeklyRacePromotionPanel:create(function()
				self:remove(function()
						SeasonWeeklyRaceManager:getInstance():pocessSeasonWeeklyDecision()
					end)
			end)
		panel:popout(self, energyPanelBottomPosY)
		self.bottomBubblePanel = panel
		return true
	end

	return false
end

function EnergyPanel:tryPopoutIapBuyMidEnergy()
	if __IOS then
		local userExtend = UserManager:getInstance().userExtend
		if MaintenanceManager:getInstance():isEnabled("Cny1Feature") or self.item2:getItemNumber() <= 0 and
			type(userExtend.payUser) == "boolean" and not userExtend.payUser then
			local function boughtCallback()
				self.item2:updateItemNumber()
			end
			local popoutPos = self.panelExchangeAnim:getPopShowPos()
			local selfSize = self.ui:getChildByName("hit_area"):getGroupBounds().size
			local energyPanelBottomPosY = popoutPos.y - selfSize.height
			local selfParent = self:getParent()
			local posInWorldSpace = selfParent:convertToWorldSpace(ccp(0, energyPanelBottomPosY))
			posInWorldSpace.y = posInWorldSpace.y - 40
			local panel = IapBuyMiddleEnergyPanel:create(self, boughtCallback, posInWorldSpace.y)
			if panel then
				self.rmbBuyMidEnergyPanel = panel
				self.bottomBubblePanel = panel
				panel:popout()
				return true
			end
		end
	end
	return false
end

function EnergyPanel:checkDoEnergyBottleTutorial()
	local _, __, maxEnergy = UserManager:getInstance():refreshEnergy()
	local energy = UserManager:getInstance():getUserRef():getEnergy()
	local consume = MetaManager:getInstance().global.user_energy_level_consume

	if energy == maxEnergy or self.continueCallback and energy >= consume then return end
	if self.item1:getItemNumber() == 0 and self.item2:getItemNumber() == 0 and self.item3:getItemNumber() == 0 then
		return
	end
	if CCUserDefault:sharedUserDefault():getBoolForKey("energy.full.energy.recoever.tutorial") then return end
	if self.bottomBubblePanel then return end

	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local layer = LayerColor:create()
	layer:setOpacity(150)
	layer:setContentSize(CCSizeMake(vSize.width / self:getScale(), vSize.height / self:getScale()))
	layer:ignoreAnchorPointForPosition(false)
	layer:setAnchorPoint(ccp(0, 1))
	layer:setPosition(ccp(-self:getPositionX() / self:getScale(), -self:getPositionY() / self:getScale()))
	layer:setTouchEnabled(true, 0, true)
	self:addChild(layer)

	local items = {}
	for i = 1, 3 do
		if self["item"..tostring(i)]:getItemNumber() > 0 then
			local item = EnergyItem:create(self.resourceManager:buildGroup("common/bubbleItem"),
				self["item"..tostring(i)].itemType, layer, ccp(0, 0))
			local position = self["item"..tostring(i)]:getPosition()
			local parent = self["item"..tostring(i)]:getParent()
			local size = item:getGroupBounds().size
			item:setScale(self["item"..tostring(i)]:getGroupBounds(self).size.width / size.width)
			item:setPosition(layer:convertToNodeSpace(parent:convertToWorldSpace(position)))
			item:setPositionX(item:getPositionX() - 4)
			item:setPositionY(item:getPositionY() + 5)
			layer:addChild(item)
			table.insert(items, item)
		end
	end

	local panel = GameGuideUI:panelMini()
	local label = TextField:create(Localization:getInstance():getText("tutorial.refill.energy.text1", {n = '\n'}), nil, 36)
	label:setColor(ccc3(0, 0, 0))
	local size = label:getContentSize()
	local pSize = panel:getGroupBounds().size
	label:setAnchorPoint(ccp(0, 1))
	label:setScale(math.min((pSize.width - 50) / size.width, (pSize.height - 50) / size.height))
	-- 注意：这里属于已知文案之后的硬编码对齐
	label:setPositionXY((pSize.width - size.width * label:getScale()) / 2 + size.width / 44, -(pSize.height - size.height * label:getScale()) / 2)
	panel:addChild(label)
	panel.text:removeFromParentAndCleanup()
	panel.text = label
	layer:addChild(panel)

	local animation = CommonSkeletonAnimation:createTutorialMoveIn2()
	local animFromLeft = true
	if self.item1:getItemNumber() == 0 and self.item3:getItemNumber() > 0 then
		animFromLeft = false
	end
	if animFromLeft then
		animation:setScaleX(-1)
		animation:setPositionX(math.min(-self:getPositionX() / self:getScale() + 220, items[1]:getPositionX()))
		panel:setPositionXY(math.min(-self:getPositionX() / self:getScale() + 260, items[1]:getPositionX()), items[1]:getPositionY() - 200)
		panel:setPositionX(panel:getPositionX() - 1000)
		panel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCEaseBackOut:create(CCMoveBy:create(0.2, ccp(1000, 0)))))
	else
		animation:setPositionX(math.max(-self:getPositionX() / self:getScale() + vSize.width / self:getScale() - 190, items[#items]:getPositionX() + 130))
		local size = panel:getGroupBounds(layer).size
		panel:setPositionXY(math.max(-self:getPositionX() / self:getScale() + vSize.width / self:getScale() - 170 - size.width), items[1]:getPositionY() - 200)
		panel:setPositionX(panel:getPositionX() + 1000)
		panel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCEaseBackOut:create(CCMoveBy:create(0.2, ccp(-1000, 0)))))
	end
	animation:update(0.01)
	animation:stop()
	animation:setVisible(false)
	animation:setPositionY(items[1]:getPositionY())
	local arr = CCArray:create()
	arr:addObject(CCDelayTime:create(0.5))
	arr:addObject(CCCallFunc:create(function()
			if layer.isDisposed then return end
			animation:setVisible(true)
			animation:playByIndex(0)
		end))
	arr:addObject(CCDelayTime:create(1.5))
	arr:addObject(CCCallFunc:create(function()
			if layer.isDisposed then return end
			animation:stop()
			layer:addEventListener(DisplayEvents.kTouchTap, function()
				layer:removeFromParentAndCleanup(true)
				CCUserDefault:sharedUserDefault():setBoolForKey("energy.full.energy.recoever.tutorial", true)
				CCUserDefault:sharedUserDefault():flush()
			end)
		end))
	arr:addObject(CCDelayTime:create(2))
	arr:addObject(CCCallFunc:create(function()
			if layer.isDisposed then return end
			layer:removeFromParentAndCleanup(true)
			CCUserDefault:sharedUserDefault():setBoolForKey("energy.full.energy.recoever.tutorial", true)
			CCUserDefault:sharedUserDefault():flush()
		end))
	animation:runAction(CCSequence:create(arr))
	layer:addChild(animation)

	return layer
end

function EnergyPanel:tryPopPushActivityPanel()
	local info
	if UserManager:getInstance():getUserRef():getEnergy() < 10 then
		info = PushActivity:sharedInstance():onEnergyPanel()
	end
	if info then
		local panel = PushActivityPanelEnergy:create(self, info)
		if panel then
			local popoutPos = self.panelExchangeAnim:getPopShowPos()
			local selfSize = self.ui:getChildByName("hit_area"):getGroupBounds().size
			local energyPanelBottomPosY = popoutPos.y - selfSize.height
			local selfParent = self:getParent()
			local posInWorldSpace = selfParent:convertToWorldSpace(ccp(0, energyPanelBottomPosY))
			posInWorldSpace.y = posInWorldSpace.y - 40
			panel:popout(self, animCallback, posInWorldSpace.y)
			self.bottomBubblePanel = panel
			return true
		end
	end
	return false
end

function EnergyPanel:onEnterForeGround( ... )
	-- body
	if self.isDisposed then return end
	if self.onEnterForeGroundCallback and type(self.onEnterForeGroundCallback) == "function" then 
		self.onEnterForeGroundCallback()
	end
end

popoutSequence = {
	EnergyPanel.tryPopoutIapBuyMidEnergy,
	EnergyPanel.tryPopPushActivityPanel,
	EnergyPanel.tryPopoutWeeklyRacePushPanel,
	EnergyPanel.chekPopoutBottomBubbleWindow,
}

popoutWithoutBgFadeInSequence = {
	EnergyPanel.tryPopoutIapBuyMidEnergy,
	EnergyPanel.tryPopPushActivityPanel,
	EnergyPanel.chekPopoutBottomBubbleWindow,
}