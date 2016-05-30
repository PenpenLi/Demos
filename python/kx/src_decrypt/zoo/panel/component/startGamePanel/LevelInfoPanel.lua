
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月13日 16:46:49
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panel.component.startGamePanel.PreGameToolItem"
require "zoo.scenes.GamePlaySceneUI"
require "zoo.panel.basePanel.PanelWithContentAnim"
require "zoo.panel.basePanel.PanelShowHideProtocol"
require "zoo.panelBusLogic.StartLevelLogic"
require "zoo.panel.component.startGamePanel.LevelTarget"
require "zoo.panel.component.common.PanelTitleLabel"
require "zoo.panel.component.startGamePanel.StartGameButton"

require "zoo.panel.component.common.BubbleCloseBtn"
require "zoo.util.QixiUtil"
require "zoo.panel.jumpLevel.JumpLevelIcon"

---------------------------------------------------
-------------- LevelInfoPanel
---------------------------------------------------

assert(not LevelInfoPanel)
assert(BasePanel)
LevelInfoPanel = class(BasePanel)

function LevelInfoPanel:init(parentPanel, levelId, levelType, useSpecialActivityUI, ...)
	assert(parentPanel)
	assert(type(levelId) 			== "number")
	assert(#{...} == 0)

	-- Get UI Resource
	self.resourceManager	= ResourceManager:sharedInstance()
	
	local function setUIProperty(ui)
		--ui:setCascadeOpacityEnabled(true)
	end
	
	self.useSpecialActivityUI = useSpecialActivityUI
	if self.useSpecialActivityUI then
		self:loadRequiredResource(PanelConfigFiles.panel_game_start_activity)
		self.ui = self:buildInterfaceGroup("Spring2016UI/levelInfoPanel")
	else
		self.ui	= ResourceManager:sharedInstance():buildGroupWithCustomProperty("startGamePanel/levelInfoPanel", nil, setUIProperty)
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
	
	-- -----------------
	-- Init Base Class
	-- -------------------
	BasePanel.init(self, self.ui)

	---------------------
	-- Additional Layer To Play User Guide
	-- -----------------------------------
	self.userGuideLayer	= Layer:create()
	self:addChild(self.userGuideLayer)

	-- ------------------
	-- Get UI Resource
	-- ------------------
	self.fadeArea		= self.ui:getChildByName("fadeArea")
	self.clippingAreaAbove	= self.ui:getChildByName("clippingAreaAbove")
	self.clippingAreaBelow	= self.ui:getChildByName("clippingAreaBelow")
	assert(self.fadeArea)
	assert(self.clippingAreaAbove)
	assert(self.clippingAreaBelow)

	self.levelLabelPlaceholder		= self.ui:getChildByName("levelLabelPlaceholder")

	-- In Fade Area
	self.targetDesLabel			= self.fadeArea:getChildByName("targetDesLabel")
	self.targetIconPlaceholder		= self.fadeArea:getChildByName("targetIconPlaceholder")

	-- In Clipping Area Above
	self.chooseItemLabel			= self.clippingAreaAbove:getChildByName("chooseItemLabel")
	self.preGameTool1Resource		= self.clippingAreaAbove:getChildByName("preGameTool1")
	self.preGameTool2Resource		= self.clippingAreaAbove:getChildByName("preGameTool2")
	self.preGameTool3Resource		= self.clippingAreaAbove:getChildByName("preGameTool3")

	-- In Clipping Area Below
	self.startButton			= self.clippingAreaBelow:getChildByName("startButton")

	self.helpIcon			= self.ui:getChildByName("helpIcon")

	-- Get Close Button
	self.bg				= self.ui:getChildByName("bg")
	assert(self.bg)
	self.closeBtnRes		= self.bg:getChildByName("closeBtn")
	assert(self.closeBtnRes)

	assert(self.levelLabelPlaceholder)
	assert(self.targetDesLabel)

	assert(self.chooseItemLabel)

	assert(self.targetIconPlaceholder)
	assert(self.preGameTool1Resource)
	assert(self.preGameTool2Resource)
	assert(self.preGameTool3Resource)
	assert(self.startButton)

	assert(self.helpIcon)


	self.preGameToolResource = {}
	self.preGameToolResource[1] = self.preGameTool1Resource
	self.preGameToolResource[2] = self.preGameTool2Resource
	self.preGameToolResource[3] = self.preGameTool3Resource

	-- Init Resource InVisible
	for index = 1, #self.preGameToolResource do
		self.preGameToolResource[index]:setVisible(false)
	end

	-----------------------
	-- Init UI Component
	-- --------------------
	self.targetIconPlaceholder:setVisible(false)
	self.levelLabelPlaceholder:setVisible(false)

	-------------------------
	--- Get Data About UI
	-------------------------
	local targetIconPlaceholderPos	= self.targetIconPlaceholder:getPosition()
	local levelLabelPlaceholderPosY	= self.levelLabelPlaceholder:getPositionY()

	--------------------
	----- Data
	---------------------
	self.parentPanel 		= parentPanel
	self.levelId 			= levelId
	self.totalSubtractedCoin 	= 0
	self.levelType 			= levelType

	-- If Playing Flying Selected Item Anim
	self.isPlayingFlyingSelectedItemAnim	= true

	-- Flag To Indicate Tapped State
	self.TAPPED_STATE_START_BTN_TAPPED	= 1
	self.TAPPED_STATE_CLOSE_BTN_TAPPED	= 2
	self.TAPPED_STATE_NONE			= 3
	self.tappedState			= self.TAPPED_STATE_NONE


	---- Get Current Level Data
	self.metaModel = MetaModel:sharedInstance()
	self.metaManager = MetaManager.getInstance()

	-- Current Level Mode Id
	self.levelModeTypeId = self.metaModel:getLevelModeTypeId(self.levelId)
	assert(self.levelModeTypeId)
	
	-- Pre Game Tool
	local initialProps = self.metaManager.gamemode_prop[self.levelModeTypeId].initProps
	assert(initialProps)

	-- -----------------------
	-- Level Mode And Target
	-- ------------------------
	local levelGameData	= LevelMapManager.getInstance():getMeta(self.levelId).gameData
	assert(levelGameData)

	local gameModeName = levelGameData.gameModeName
	assert(gameModeName)

	local orderList		= levelGameData.orderList

	--------------------------
	--- Create UI Component 
	---------------------------
	-- Start Button
	self.startButton	= StartGameButton:create(self.startButton, self.useSpecialActivityUI)
	self.closeBtn		= BubbleCloseBtn:create(self.closeBtnRes)

	--- Panel Title
	local levelDisplayName
	local panelTitle

	if PublishActUtil:isGroundPublish() then
		panelTitle = BitmapText:create("精彩活动关", "fnt/titles.fnt", -1, kCCTextAlignmentCenter)
	else
		-- compatible with weekly race mode
		if self.levelType == GameLevelType.kDigWeekly then
			levelDisplayName = Localization:getInstance():getText('weekly.race.panel.start.title')
			local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
			panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)
		elseif self.levelType == GameLevelType.kTaskForUnlockArea then 
			levelDisplayName = Localization:getInstance():getText("recall_text_5")
			local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
			panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)
		else
			levelDisplayName = LevelMapManager.getInstance():getLevelDisplayName(self.levelId)
			-- panelTitle = PanelTitleLabel:create(levelDisplayName)
			panelTitle = PanelTitleLabel:create(levelDisplayName, nil, nil, nil, nil, nil, self.useSpecialActivityUI)
		end
	end

	local contentSize = panelTitle:getContentSize()
	self:addChild(panelTitle)
	panelTitle:ignoreAnchorPointForPosition(false)
	panelTitle:setAnchorPoint(ccp(0,1))
	panelTitle:setPositionY(levelLabelPlaceholderPosY)
	panelTitle:setToParentCenterHorizontal()

	-- Pre Game Tools
	self.preGameTools = {}
	for index = 1, #initialProps do
		self.preGameToolResource[index]:setVisible(true)
		if PublishActUtil:isGroundPublish() then 
			self.preGameTools[index] = PreGameToolItem:create(self.preGameToolResource[index], initialProps[index], 400)
			self.preGameTools[index]:setSelected(true)
		else
			self.preGameTools[index] = PreGameToolItem:create(self.preGameToolResource[index], initialProps[index], self.levelId)
		end	
		-------------- qixi ----------------------
		local isFreeItem = false -- qixi
		if QixiUtil:hasCompeleted() then
			local remainingCount = QixiUtil:getRemainingFreeItem(initialProps[index])
			print('-------', initialProps[index], remainingCount)
			isFreeItem = (remainingCount > 0)
		end

		if isFreeItem then 
			self.preGameTools[index]:setFreePrice()
			self.preGameTools[index]:updatePriceColor()
		end
		---------------- end qixi ----------------

	end

	-- Level Target
	local levelTarget		= LevelTarget:create(gameModeName, orderList)
	local levelTargetSize		= levelTarget:getGroupBounds().size
	local targetIconPlaceholderSize = self.targetIconPlaceholder:getGroupBounds().size

	local deltaWidth	= targetIconPlaceholderSize.width - levelTargetSize.width
	local deltaHeight	= targetIconPlaceholderSize.height - levelTargetSize.height
	local halfDeltaWidth	= deltaWidth / 2
	local halfDeltaHeight	= deltaHeight / 2

	local posX = targetIconPlaceholderPos.x + halfDeltaWidth
	local posY = targetIconPlaceholderPos.y - halfDeltaHeight

	levelTarget:setPosition(ccp(posX, posY))
	self.fadeArea:addChild(levelTarget)
	self.levelTarget = levelTarget

	-------------------------
	---- Add Event Listener
	-------------------------

	local function onPreGameItemMoveOut(event, ...)
		self:onPreGameItemMoveOut(event)
	end

	local function onPreGameItemMoveIn(event, ...)
		self:onPreGameItemMoveIn(event)
	end

	local function onPreGameItemTouchBegin(event, ...)
		self:onPreGameItemTouchBegin(event)
	end

	local function onPreGameItemTapped(event, ...)
		self:onPreGameItemTapped(event)
	end

	for index = 1, #initialProps do
		local ui = self.preGameTools[index]:getUI()
		if PublishActUtil:isGroundPublish() then 
			ui:setTouchEnabledWithMoveInOut(false, 0, false)
		else
			ui:setTouchEnabledWithMoveInOut(true, 0, false)
		end

		ui:addEventListener(DisplayEvents.kTouchMoveIn, onPreGameItemMoveIn, index)
		ui:addEventListener(DisplayEvents.kTouchMoveOut, onPreGameItemMoveOut, index)
		ui:addEventListener(DisplayEvents.kTouchBegin, onPreGameItemTouchBegin, index)
		ui:addEventListener(DisplayEvents.kTouchTap, onPreGameItemTapped, index)
	end

	-- ----------------------------
	-- Start Btn Event Listener
	-- -----------------------
	local function onStartButtonTapped(event)
		self:onStartButtonTapped(event)
		GamePlayMusicPlayer:playEffect(GameMusicType.kClickCommonButton)
	end
	self.startButton.ui:setTouchEnabled(true)
	self.startButton.ui:addEventListener(DisplayEvents.kTouchTap, onStartButtonTapped)

	local function onCloseBtnTapped(event)
		self:onCloseBtnTapped(event)
	end
	self.closeBtn.ui:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)

	-- Property Info Btn Event Listener
	local function onHelpIconTapped(event)

		local function onPropInfoPanelClosed()
			self.parentPanel:setRankListPanelTouchEnable()
		end

		self.parentPanel:setRankListPanelTouchDisable()

		local panel = PropInfoPanel:create(1, self.levelId)
		panel:setExitCallback(onPropInfoPanelClosed)

	    if panel then panel:popout() end		
	end
	self.helpIcon:setTouchEnabled(true)
	self.helpIcon:setButtonMode(true)
	self.helpIcon:setAnchorPointCenterWhileStayOrigianlPosition()
	self.helpIcon:ad(DisplayEvents.kTouchTap, onHelpIconTapped)
	
	-- ---------------
	-- Update View
	-- -------------
	
	-- Choose Item
	local stringKey		= "start.game.panel.choose.item.title"
	local chooseItemLabelTxt= Localization:getInstance():getText(stringKey, {})
	assert(chooseItemLabelTxt)
	self.chooseItemLabel:setString(chooseItemLabelTxt)

	-- Get self.targetDesLabel Text
	local stringKey	= false

	if self.levelModeTypeId == GameModeTypeId.CLASSIC_MOVES_ID then
		stringKey	= "level.start.step.mode"
	elseif self.levelModeTypeId == GameModeTypeId.CLASSIC_ID then
		stringKey	= "level.start.time.mode"
	elseif self.levelModeTypeId == GameModeTypeId.DROP_DOWN_ID then
		stringKey	= "level.start.drop.mode"
	elseif self.levelModeTypeId == GameModeTypeId.LIGHT_UP_ID then
		stringKey	= "level.start.ice.mode"
	elseif self.levelModeTypeId == GameModeTypeId.DIG_TIME_ID then
		stringKey	= "level.start.dig.time.mode"
	elseif self.levelModeTypeId == GameModeTypeId.DIG_MOVE_ID then
		stringKey	= "level.start.dig.step.mode"
	elseif self.levelModeTypeId == GameModeTypeId.ORDER_ID or self.levelModeTypeId == GameModeTypeId.SEA_ORDER_ID then
		local function getOrderType(str) return string.sub(str, 1, string.find(str, '_') - 1) end
		if levelGameData.orderList and #levelGameData.orderList > 0 then
			local orderType, isMatch = tonumber(getOrderType(levelGameData.orderList[1].k)), true
			if orderType == 2 or orderType == 3 then
				for k, v in ipairs(levelGameData.orderList) do
					if tonumber(getOrderType(v.k)) ~= orderType then
						stringKey = "level.start.objective.mode"
						isMatch = false
						break
					end
				end
				if isMatch then
					if orderType == 2 then stringKey = "level.start.eliminate.effect.mode"
					elseif orderType == 3 then stringKey = "level.start.swap.effect.mode" end
				end
			else stringKey = "level.start.objective.mode" end
		else stringKey = "level.start.objective.mode" end
	elseif self.levelModeTypeId == GameModeTypeId.DIG_MOVE_ENDLESS_ID then
		stringKey	= "level.start.dig.endless.mode"
	elseif self.levelModeTypeId == GameModeTypeId.TASK_UNLOCK_DROP_DOWN then 
		stringKey = "unlock.cloud.panel.play.desc"
	elseif self.levelModeTypeId == GameModeTypeId.LOTUS_ID then
		stringKey = "level.start.meadow.mode"
	else 
		print("levelModeTypeId: " .. self.levelModeTypeId)
		assert(false)
	end

	local targetDesLabelTxt = Localization:getInstance():getText(stringKey)
	assert(targetDesLabelTxt)
	self.targetDesLabel:setString(targetDesLabelTxt)

	self:initJumpLevelArea()

	if JumpLevelManager:getInstance():hasJumpedLevel(self.levelId) then
		self.ui:getChildByName('jumpLevelMark'):getChildByName('text'):setText(localize('skipLevel.tips3', {n = '\n', s = ' ', replace1 = JumpLevelManager:getLevelPawnNum(self.levelId)}))
		self.clippingAreaAbove:getChildByName('chooseItemLabel'):setVisible(false)
		self.clippingAreaAbove:getChildByName('_dotLineLeft'):setVisible(false)
		self.clippingAreaAbove:getChildByName('_dotLineRight'):setVisible(false)
	else
		self.ui:getChildByName('jumpLevelMark'):setVisible(false)
	end
end

he_log_warning("Debug Item Scale 9 Bg Group Bounds !")

function LevelInfoPanel:onCloseBtnTapped(event, ...)
	assert(#{...} == 0)

	if self.tappedState == self.TAPPED_STATE_NONE then

		local runningScene = Director:sharedDirector():getRunningScene()
		print("runningScene.name", runningScene.name)
		if GameGuide then
			local name = GameGuide:sharedInstance():currentGuideType()
			print("GameGuide:sharedInstance():currentGuideType()", name)
			if name then print("name", name)
				if name == "startInfo" or name == "showPreProp" then
					print("should return")
					return
				end
			end
		end

		self.tappedState = self.TAPPED_STATE_CLOSE_BTN_TAPPED
	else
		return
	end
	
	local function onRemoveAnimFinished()
		self:backTheCoinUsedInPreGameItem()

		if self.parentPanel.onClosePanelCallback then
			self.parentPanel:onClosePanelCallback()
		end
	end

	self.parentPanel:remove(onRemoveAnimFinished)
	self:removeGuide()
end

function LevelInfoPanel:backTheCoinUsedInPreGameItem(...)
	assert(#{...} == 0)

	if QixiUtil:hasCompeleted() then
		print('here')

		for k, v in pairs(self.preGameTools) do
			-------------- qixi ----------------------
			if v:isFreeItem() then -- qixi
				if v:isSelected() then
					-- QixiUtil:unConsumeFreeItem(v.itemId)
				end
			end
		end
	end
	--------------- end qixi --------------------

	if self.totalSubtractedCoin > 0 then
		-- Close Panel, Means Cancel To Play Game
		-- Add The Subtracted Coin Back To User
		local curCoin = UserManager.getInstance().user:getCoin()
		assert(curCoin)

		local newCoin = curCoin + self.totalSubtractedCoin
		UserManager.getInstance().user:setCoin(newCoin)

		--local runningScene = Director:sharedDirector():getRunningScene()
		local homeScene = HomeScene:sharedInstance()
		homeScene:checkDataChange()
		homeScene.coinButton:updateView()

	elseif self.totalSubtractedCoin == 0 then
		-- Do Nothing
	else 
		assert(false)
	end
end

function LevelInfoPanel:onPreGameItemMoveIn(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchMoveIn)
	assert(event.context)
	assert(#{...} == 0)

	if self.tappedState ~= self.TAPPED_STATE_NONE then
		return
	end

	local index 		= event.context
	local tappedPreGameItem	= self.preGameTools[index]
	assert(tappedPreGameItem)

	if tappedPreGameItem:isLocked() then
		tappedPreGameItem:playShakeLockAndLabelAnim(false)
		return
	end

	-- Play Bubble Touched Anim One Time, Then
	-- Play Bubble Normal Anim
	if not tappedPreGameItem:isSelected() then
		local function onBubbleTouchedAnimFinish()
			tappedPreGameItem:playBubbleNormalAnim(true)
		end
		tappedPreGameItem:playBubbleTouchedAnim(false, onBubbleTouchedAnimFinish)
	end
end

function LevelInfoPanel:onPreGameItemMoveOut(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchMoveOut)
	assert(event.context)
	assert(#{...} == 0)


end

function LevelInfoPanel:onPreGameItemTouchBegin(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchBegin)
	assert(event.context)
	assert(#{...} == 0)

	if self.tappedState ~= self.TAPPED_STATE_NONE then
		return
	end

	local index = event.context
	local tappedPreGameItem = self.preGameTools[index]
	assert(tappedPreGameItem)

	if tappedPreGameItem:isLocked() then
		tappedPreGameItem:playShakeLockAndLabelAnim(false)
		return
	end


	if tappedPreGameItem:isSelected() then
		return 
	end

	-- Play Bubble Touched Anim One Time, Then
	-- Play Bubble Normal Anim
	local function onBubbleTouchedAnimFinish()
		tappedPreGameItem:playBubbleNormalAnim(true)
	end
	tappedPreGameItem:playBubbleTouchedAnim(false, onBubbleTouchedAnimFinish)
end

function LevelInfoPanel:onPreGameItemTapped(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchTap)
	assert(event.context) -- Which Item Tapped
	assert(#{...} == 0)

	if self.tappedState ~= self.TAPPED_STATE_NONE then
		return
	end

	local index = event.context

	local tappedPreGameItem = self.preGameTools[index]
	assert(tappedPreGameItem)

	if tappedPreGameItem:isLocked() then
		--tappedPreGameItem:playShakeLockAnim(false)
		return
	end

	local itemId = tappedPreGameItem.itemId
	

	-------------- qixi ----------------------
	if tappedPreGameItem:isFreeItem() then -- qixi
		if tappedPreGameItem:isSelected() then
			tappedPreGameItem:setSelected(false)
			-- QixiUtil:unConsumeFreeItem(itemId)
		else
			tappedPreGameItem:setSelected(true)
			-- QixiUtil:consumeFreeItem(itemId)
		end
	else
	--------------- end qixi --------------------

		if tappedPreGameItem:isSelected() then

			-- Unselect
			tappedPreGameItem:setSelected(false)

			-- Add The Price Back To User
			local curCoin = UserManager.getInstance().user:getCoin()
			assert(curCoin)
			local newCoin = curCoin + tappedPreGameItem:getPrice()
			UserManager.getInstance().user:setCoin(newCoin)

			local homeScene = HomeScene:sharedInstance()
			homeScene:checkDataChange()
			homeScene.coinButton:updateView()

			self.totalSubtractedCoin = self.totalSubtractedCoin - tappedPreGameItem:getPrice()
			self:updateEachPreGameItemPriceColor()
		else
			-- Compare Usr Cur Coin With This Item's Price
			local curCoin = UserManager.getInstance().user:getCoin()
			assert(curCoin)

			if curCoin >= tappedPreGameItem:getPrice() then
				-- Can Buy
				tappedPreGameItem:setSelected(true)

				GamePlayMusicPlayer:playEffect(GameMusicType.kClickBubble)

				-- Subtract The Price
				local newCoin = curCoin - tappedPreGameItem:getPrice()
				UserManager.getInstance().user:setCoin(newCoin)
				local homeScene = HomeScene:sharedInstance()
				homeScene:checkDataChange()
				homeScene.coinButton:updateView()
				
				self.totalSubtractedCoin = self.totalSubtractedCoin + tappedPreGameItem:getPrice()
			else
				-- Can't Buy
				CommonTip:showTip(Localization:getInstance():getText("start.panel.net.enough.coin"), "negative")
			end

			self:updateEachPreGameItemPriceColor()
		end


	end
end

function LevelInfoPanel:updateEachPreGameItemPriceColor(...)
	assert(#{...} == 0)

	for k,v in pairs(self.preGameTools) do
		v:updatePriceColor()
	end
end

function LevelInfoPanel:onStartButtonTapped(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchTap)
	assert(#{...} == 0)

	if self.tappedState == self.TAPPED_STATE_NONE then
		--self.tappedState = self.TAPPED_STATE_START_BTN_TAPPED
	else
		return
	end

	self:removeGuide()
	self:startGame()
end

function LevelInfoPanel:createFlyingEnergyAction(...)
	assert(#{...} == 0)

	local actionArray = CCArray:create()

	local newEnergyRes	= ResourceManager:sharedInstance():buildGroup("homeSceneEnergyItem")

	-- --------------------------------------------------
	-- Get The Energy Button's Energy Icon In The HomeScene
	-- ----------------------------------------------------
	-- local runningScene = Director:sharedDirector():getRunningScene()
	-- if runningScene.name == "GamePlaySceneUI" then
		
	-- 	local emptyAction = CCDelayTime:create(0)
	-- 	return emptyAction
	-- end

	local energyButton = HomeScene:sharedInstance().energyButton
	assert(energyButton)
	local energyBtnIcon = energyButton:getEnergyRes()
	assert(energyBtnIcon)
	
	-- Get Button's Energy Icon's Pos, In Self Space
	local startPosInSelfSpace	= self:getNodePosInSelfSpace(energyBtnIcon)
	assert(startPosInSelfSpace)

	-----------------------------------------
	-- Get Energy Icon In Self Start Button
	-- ---------------------------------------
	local energyIconInStartBtn = self.startButton.energyIcon
	assert(energyIconInStartBtn)
	
	-- Get Energy Pos
	
	local manualAdjustDestPosX = -5
	local manualAdjustDestPosY = 5
	local destPosInSelfSpace	= self:getNodePosInSelfSpace(energyIconInStartBtn)
	assert(destPosInSelfSpace)

	destPosInSelfSpace.x = destPosInSelfSpace.x + manualAdjustDestPosX
	destPosInSelfSpace.y = destPosInSelfSpace.y + manualAdjustDestPosY

	-------------------
	-- Init Anim Action
	-- -----------------
	local function initAnimFunc()
		self:addChild(newEnergyRes)
		newEnergyRes:setPosition(ccp(startPosInSelfSpace.x, startPosInSelfSpace.y))
	end
	local initAnimAction = CCCallFunc:create(initAnimFunc)

	actionArray:addObject(initAnimAction)

	------------------
	-- Move To Action
	-- -------------
	local moveTo 	= CCMoveTo:create(0.5, ccp(destPosInSelfSpace.x, destPosInSelfSpace.y))
	local ease	= CCEaseSineOut:create(moveTo)
	moveTo = ease

	actionArray:addObject(moveTo)

	local function playSoundEffect()
		GamePlayMusicPlayer:playEffect(GameMusicType.kUseEnergy)
	end
	local playSoundAction = CCCallFunc:create(playSoundEffect)
	actionArray:addObject(playSoundAction)
	actionArray:addObject(CCDelayTime:create(0.2))

	------------------
	-- Anim Finish Clean Up Action
	-- --------------------------
	
	local function animFinishCleanUpFunc()
		-- For Test Purpose

	end
	local animFinishCleanUpAction = CCCallFunc:create(animFinishCleanUpFunc)

	actionArray:addObject(animFinishCleanUpAction)

	-------------
	-- Seq
	-- ----------
	local seq = CCSequence:create(actionArray)
	local target = CCTargetedAction:create(newEnergyRes.refCocosObj, seq)

	--return seq
	return target
end

function LevelInfoPanel:playFlyingEnergyAnimation(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)


	local flyingEnergyAction = self:createFlyingEnergyAction()

	-- Anim Finish Callback
	local function animFinishCallbackFunc()
		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishCallbackAction = CCCallFunc:create(animFinishCallbackFunc)

	-- Seq
	local seq = CCSequence:createWithTwoActions(flyingEnergyAction, animFinishCallbackAction)


	self:runAction(seq)
end

function LevelInfoPanel:playFlyingEnergyAndSelectedItemAnim(selectedItemsData, animFinishCallback, ...)
	assert(selectedItemsData)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	HomeScene:sharedInstance():checkDataChange()
	HomeScene:sharedInstance().energyButton:updateView()

	-- Flying Energy
	local flyingEnergyAction = self:createFlyingEnergyAction()

	-- Flying Selected Item
	local selectedItemAction = self:createSelectedItemFlyingAction(selectedItemsData)

	-- Anim Finish Callback
	local function animFinishCallbackFunc()
		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishCallbackAction = CCCallFunc:create(animFinishCallbackFunc)

	local actionArray = CCArray:create()
	actionArray:addObject(flyingEnergyAction)
	actionArray:addObject(selectedItemAction)
	actionArray:addObject(animFinishCallbackAction)

	-- Seq
	local seq = CCSequence:create(actionArray)
	self:runAction(seq)
end

--function LevelInfoPanel:getSelectedItemPosInWorldPos(selectedItemsData, ...)
function LevelInfoPanel:setSelectedItemAnimDestPos(selectedItemsData, ...)
	assert(type(selectedItemsData) == "table")
	assert(#{...} == 0)

	for k,data in pairs(selectedItemsData) do

		local preGameToolItem = data.node
		assert(PreGameToolItem)

		local itemRes = preGameToolItem:getItemRes()
		assert(itemRes)

		--local nodeSpacePos = self:getNodePosInSelfSpace(itemRes)

		local itemResParent = itemRes:getParent()
		assert(itemResParent)

		local itemResPos		= itemRes:getPosition()
		local itemResPosInWorldSpace = itemResParent:convertToWorldSpace(ccp(itemResPos.x, itemResPos.y))

		data.destXInWorldSpace = itemResPosInWorldSpace.x
		data.destYInWorldSpace = itemResPosInWorldSpace.y --+ 150
	end
end


function LevelInfoPanel:createSelectedItemFlyingAction(selectedItemsData, ...)
	
	local actionArray = CCArray:create()
	for k,data in pairs(selectedItemsData) do
		local preGameToolItem = data.node
		if preGameToolItem then
			local itemRes = preGameToolItem:getItemRes()
			local nodeSpacePos = self:getNodePosInSelfSpace(itemRes)
			itemRes:removeFromParentAndCleanup(false)
			
			local container = PrefixPropAnimation:createShineAnimation()
			container:setPosition(nodeSpacePos)
			itemRes:setPositionX(0)
			itemRes:setPositionY(0)
			container:addChild(itemRes)

			self:addChild(container)

			actionArray:addObject(CCDelayTime:create(0.2))
		end
	end
	-- Empty Action
	local emptyAction = CCDelayTime:create(0)
	actionArray:addObject(emptyAction)

	local spawn = CCSpawn:create(actionArray)
	return spawn
end

function LevelInfoPanel:playSelectedItemFlyingAnim(selectedItemsData, animFinishCallback, ...)
	assert(type(selectedItemsData) == "table")
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	local selectedItemsAction = self:createSelectedItemFlyingAction(selectedItemsData)

	-- Callback Function
	local function animFinishCallbackFunc()
		
		for k, data in pairs(selectedItemsData) do
			data.width 	= data.itemRes:getGroupBounds().width
			data.height	= data.itemRes:getGroupBounds().height
		end

		if animFinishCallback then
			animFinishCallback()
		end
	end
	local callbackAction = CCCallFunc:create(animFinishCallbackFunc)

	-- Seq 
	local seq = CCSequence:createWithTwoActions(selectedItemsAction, callbackAction)
	
	if self.isPlayingFlyingSelectedItemAnim then
		self:runAction(seq)
	else
		animFinishCallbackFunc()
	end
end

function LevelInfoPanel:startGame(...)
	assert(#{...} == 0)

	-- Get Data About Selected Item
	-- Set Anim Pos About Selected Item
	
	local selectedItemsData = self:getSelectedItemsData()

	if PublishActUtil:isGroundPublish() then 
		selectedItemsData = PublishActUtil:getTempSelectedPropTable()
	end

	if not PublishActUtil:isGroundPublish() then 
		self:setSelectedItemAnimDestPos(selectedItemsData)
	end

	self.selectedItemsData = selectedItemsData
	self.startFromEnergyPanel = false

	-- -------------------------------------
	-- Run The Start Level Bussiness Logic
	-- --------------------------------------
	local startLevelLogic = StartLevelLogic:create(self, self.levelId, self.levelType, selectedItemsData, false)
	startLevelLogic:start(true)
end

function LevelInfoPanel:onStartLevelLogicSuccess()
	-- Block Tapped
	self.tappedState = self.TAPPED_STATE_START_BTN_TAPPED

	if self.levelType == GameLevelType.kMainLevel 
			or self.levelType == GameLevelType.kHiddenLevel then
		-- RabbitWeeklyManager:sharedInstance():onStartMainLevel()
		SeasonWeeklyRaceManager:getInstance():onPlayMainLevel()
	end
end

function LevelInfoPanel:onStartLevelLogicFailed(err)
	local onStartLevelFailedKey 	= "error.tip."..err
	local onStartLevelFailedValue	= Localization:getInstance():getText(onStartLevelFailedKey, {})
	CommonTip:showTip(onStartLevelFailedValue, "negative")
end

function LevelInfoPanel:startGameForEnergyPanel( ... )
	self.startFromEnergyPanel = true

	local startLevelLogic = StartLevelLogic:create(self, self.levelId, self.levelType, self.selectedItemsData, false)
	startLevelLogic:start(true)
end

function LevelInfoPanel:onEnergyNotEnough()
	self.isPlayingFlyingSelectedItemAnim = false

	if self.startFromEnergyPanel then
		assert(false, "not possible !")
		return
	end

	if self.energyPanelPoped then return end
	self.energyPanelPoped = true

	local function startGameForEnergyPanel()
		self:startGameForEnergyPanel()
	end

	local function onEnergyPanelCloseBackTheCoin()
		self:backTheCoinUsedInPreGameItem()
	end
	self.parentPanel:changeToEnergyNotEnoughPanel(startGameForEnergyPanel, onEnergyPanelCloseBackTheCoin)
end

function LevelInfoPanel:onWillEnterPlayScene( ... )
	-- Update The Energy Button
	HomeScene:sharedInstance():checkDataChange()
	HomeScene:sharedInstance().energyButton:updateView()

	--fix
	-- disable WorldScene touch events,
	-- prevent touch before entering GamePlaySceneUI
	local worldScene = HomeScene:sharedInstance().worldScene
	if worldScene then
		worldScene:setIsTouched(true)
	end

	if self.parentPanel and not self.parentPanel.isDisposed then
		print("onWillEnterPlaySceneCallback remove parentPanel")
		PopoutManager:sharedInstance():remove(self.parentPanel, true)
		self:removeGuide()
	end
	--end fix
end

function LevelInfoPanel:playEnergyAnim(onAnimFinish, selectedItemsData)
	if self.startFromEnergyPanel then
		if onAnimFinish then onAnimFinish() end
		return
	end
	-- When Anim Finished 
	-- Truely Start The Game
	local function onFlyingItemAnimFinished()
		-- notPlayStartGamePanelAnimAndStartTheGame()
		if onAnimFinish then onAnimFinish() end
	end

 	selectedItemsData = selectedItemsData or {}
	-- Play The Anim
	self:playFlyingEnergyAndSelectedItemAnim(selectedItemsData, onFlyingItemAnimFinished)
end

function LevelInfoPanel:getSelectedItemsData(...)
	assert(#{...} == 0)

	local result = {}

	for index = 1, #self.preGameTools do

		local curItem = self.preGameTools[index]

		if curItem:isSelected() then

			local itemData 		= {}
			itemData.id 		= curItem:getItemId()
			--itemData.xInWorldSpace	= 0
			--itemData.yInWorldSpace	= 0
			itemData.node		= curItem
			-- itemData.itemRes	= curItem:getItemRes()
			table.insert(result, itemData)
		end
	end

	return result
end

function LevelInfoPanel:create(parentPanel, levelId, levelType, useSpecialActivityUI, ...)
	assert(parentPanel)
	assert(type(levelId) 			== "number")
	assert(#{...} == 0)
	local newPanel = LevelInfoPanel.new()
	print("RRR    LevelInfoPanel:create   " , parentPanel, levelId, levelType, useSpecialActivityUI)
	newPanel:init(parentPanel, levelId, levelType, useSpecialActivityUI)
	return newPanel
end

function LevelInfoPanel:getPrePropPositionByIndex(index)
	local item = self.preGameToolResource[index]
	local pos1 = item:getPosition()
	pos1 = item:getParent():convertToWorldSpace(ccp(pos1.x, pos1.y))
	local size = item:getGroupBounds().size
	return ccp(pos1.x + size.width / 2, pos1.y)
end

function LevelInfoPanel:getLevelTargetPosition()
	local item = self.levelTarget
	local pos1 = item:getPosition()
	pos1 = item:getParent():convertToWorldSpace(ccp(pos1.x, pos1.y))
	local pos2 = self.ui:getPosition()
	local size = item:getGroupBounds().size
	return ccp(pos1.x + pos2.x + size.width / 2, pos1.y + size.height / 3)
end

function LevelInfoPanel:afterPopout()
	print('LevelInfoPanel:afterPopout')
	if QixiUtil:hasCompeleted() then
		local itemPos = {}
		for k, v in pairs(self.preGameTools) do
			local pos = v.priceLabel:getParent():convertToWorldSpace(v.priceLabel:getPosition())
			table.insert(itemPos, pos)
		end
		QixiUtil:playMagpieAnimation(ccp(-100, 750), ccp(820, 750), itemPos)
	end
	if self.isDisposed then return end
	for i = 1, 3 do
		local tappedPreGameItem	= self.preGameTools[i]
		local function playBubbleAnim()
			if tappedPreGameItem and not tappedPreGameItem.isDisposed and not tappedPreGameItem:isLocked() and not tappedPreGameItem:isSelected() then
				local function onBubbleTouchedAnimFinish()
					if not tappedPreGameItem or tappedPreGameItem.isDisposed then return end
					tappedPreGameItem:playBubbleNormalAnim(true)
				end
				tappedPreGameItem:playBubbleTouchedAnim(false, onBubbleTouchedAnimFinish)
			end
		end
		if tappedPreGameItem and not tappedPreGameItem.isDisposed then
			tappedPreGameItem:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(-0.15 + 0.15 * i), CCCallFunc:create(playBubbleAnim)))
		end
	end

	local gameModeName = LevelMapManager.getInstance():getMeta(self.levelId).gameData.gameModeName
	if gameModeName == 'Drop down' then
		self:tryIngredientGuide(self.levelId)
	end

	if self.jumpLevelIconArmature then
		self.jumpLevelIconArmature:playByIndex(0, 1)
	end
end

function LevelInfoPanel:initJumpLevelArea( ... )
	-- body
	local area = self.ui:getChildByName("jump_level_area")
	local pos = area:getPosition()

	-- isFakeIcon31-39关可见跳关按钮，但并走真正的逻辑
	-- 只是弹出tip提示xx关开启跳关功能
	local isFakeIcon = JumpLevelManager:shouldShowFakeIcon(self.levelId)
	if JumpLevelManager:getInstance():shouldShowJumpLevelIcon(self.levelId) then
		FrameLoader:loadArmature('skeleton/jump_level_btn_animation', 'jump_level_btn_animation')
		local armature = nil
		if not isFakeIcon then
			armature = ArmatureNode:create('skip')
		else
			armature = ArmatureNode:create('skip2')
		end
		-- armature:setAnimationScale(0.7)
		armature:playByIndex(0, 1)
		armature:update(0.001)
		armature:stop()
		self.jumpLevelIconArmature = armature
		local layer = Layer:create()
		layer:addChild(armature)
		area:getParent():addChildAt(layer, area:getZOrder())
		layer:setPosition(ccp(pos.x, pos.y))
		self.jumpLevelArea = JumpLevelIcon:create(layer, self.levelId, self.levelType, self, isFakeIcon)
		area:setVisible(false)
	else
		area:setVisible(false)
	end
end


function LevelInfoPanel:tryIngredientGuide(levelId)
	if levelId == 13 then return end -- 13关有前置道具引导，金豆荚引导不在13关弹出

	local uid = UserManager:getInstance().user.uid or "12345"
	local key = 'jump.level.ingredient.guide'
	if not CCUserDefault:sharedUserDefault():getBoolForKey(key, false) then
		if self.isGuideOnScreen then return end
	    self.isGuideOnScreen = true
	    local pos = self.fadeArea:getParent():convertToWorldSpace(self.fadeArea:getPosition())
	    local size = self.fadeArea:getGroupBounds().size
	    pos = ccp(pos.x - 56, pos.y - size.height + 5)
		local action = 
	    {
	        opacity = 0xCC, 
	        text = "tutorial.props.ingredient.1",
	        panType = "up", panAlign = "viewY", panPosY = pos.y - 300, panFlip = true,
	        maskDelay = 0.3,maskFade = 0.4 ,panDelay = 0.3, touchDelay = 1
	    }
	    local panel = GameGuideUI:panelS(nil, action, false)
	    local mask = GameGuideUI:mask(
	        action.opacity, 
	        action.touchDelay, 
	        pos,
	        1.5, 
	        true, 
	        size.width, 
	        size.height, 
	        false,
	        true)
	    mask.setFadeIn(action.maskDelay, action.maskFade)
	    self.guidePanel = panel
	    self.guideMask = mask
	    local function newOnTouch(evt)
	        self.isGuideOnScreen = false
	        if panel and not panel.isDisposed then
	            panel:removeFromParentAndCleanup(true)
	        end
	        if mask and not mask.isDisposed then
	            mask:removeFromParentAndCleanup(true)
	        end
	        CCUserDefault:sharedUserDefault():setBoolForKey(key, true)
	    end
	    mask:removeEventListenerByName(DisplayEvents.kTouchTap)
	    mask:ad(DisplayEvents.kTouchTap, newOnTouch)
	    local scene = Director:sharedDirector():getRunningScene()
	    if scene then
	        scene:addChild(mask)
	        scene:addChild(panel)
	    end
	end
end

function LevelInfoPanel:removeGuide()
	if self.guidePanel and not self.guidePanel.isDisposed then
		self.guidePanel:removeFromParentAndCleanup(true)
		self.guidePanel = nil
	end
	if self.guideMask and not self.guideMask.isDisposed then
		self.guideMask:removeFromParentAndCleanup(true)
		self.guideMask = nil
	end
end
