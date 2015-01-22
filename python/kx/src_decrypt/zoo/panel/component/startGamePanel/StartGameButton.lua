
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年12月11日 21:21:31
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- StartGameButton
---------------------------------------------------

assert(not StartGameButton)
StartGameButton = class(BaseUI)

function StartGameButton:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	self.ui = ui

	-----------------
	-- Init Base Class
	--------------------
	BaseUI.init(self, ui)

	----------------
	-- Get UI Component
	-- -----------------
	self.energyIcon 	= self.ui:getChildByName("energyIcon")
	self.btnWithoutShadow	= self.ui:getChildByName("btnWithoutShadow")
	
	self.label		= self.btnWithoutShadow:getChildByName("label")
	self.negative5Label	= self.btnWithoutShadow:getChildByName("negative5Label")
	self.infiniteEnergy	= self.btnWithoutShadow:getChildByName("infiniteEnergy")

	assert(self.energyIcon)
	assert(self.label)
	assert(self.negative5Label)
	assert(self.infiniteEnergy)

	assert(self.btnWithoutShadow)
	
	------------
	-- Init UI
	-- ----------
	self.ui:setButtonMode(true)
	self.infiniteEnergy:setVisible(false)

	self.BUTTON_ENERGY_STATE_INFINITE 	= 1
	self.BUTTON_ENERGY_STATE_USE_ENERGY	= 2
	self.buttonEnergyState			= self.BUTTON_ENERGY_STATE_USE_ENERGY

	---------------
	-- Update View
	-- -----------
	-- Update Start Button Label
	local stringKey		= "start.game.panel.start.btn.txt"
	local stringValue	= Localization:getInstance():getText(stringKey, {})
	self.label:setString(stringValue)
	--self.label:setToParentCenterVertical()

	self.labelUseEnergyPosX	= self.label:getPositionX()
	self.labelUseEnergyPosY = self.label:getPositionY()


	self.negative5Label:setString("-5")
	--self.negative5Label:setToParentCenterVertical()

	local manualAdjustPosX	= 0
	local manualAdjustPosY	= -5
	
	-- Cur Pos 
	local curLabelPos 		= self.label:getPosition()
	local curNegative5LabelPos	= self.negative5Label:getPosition()

	--self.label:setPositionY(curLabelPos.y + manualAdjustPosY)
	--self.negative5Label:setPositionY(curNegative5LabelPos.y + manualAdjustPosY)

	--self.ui:setButtonMode(true)
	self:createAnimation()

	-- Update Button Energy State
	self:perFrameCheckEnergyChange()

	-- ----------------------
	-- Add OnEnter Handler
	-- ----------------------
	local function onEnterHandler(event, ...)
		assert(event)
		assert(#{...} == 0)

		self:onEnterHandler(event)
	end

	self:registerScriptHandler(onEnterHandler)
end


function StartGameButton:createAnimation()
	local startButton = self.ui --:getChildByName("btnWithoutShadow")
	local deltaTime = 0.9
	local animations = CCArray:create()
	animations:addObject(CCScaleTo:create(deltaTime, 0.98, 1.03))
	animations:addObject(CCScaleTo:create(deltaTime, 1.01, 0.96))
	animations:addObject(CCScaleTo:create(deltaTime, 0.98,1.03))
	animations:addObject(CCScaleTo:create(deltaTime, 1,1))
	startButton:runAction(CCRepeatForever:create(CCSequence:create(animations)))

	local btnWithoutShadow = startButton:getChildByName("btnWithoutShadow"):getChildByName("bg")
	local function __onButtonTouchBegin( evt )
		if btnWithoutShadow and not btnWithoutShadow.isDisposed then
			btnWithoutShadow:setOpacity(200)
		end
	end
	local function __onButtonTouchEnd( evt )
		if btnWithoutShadow and not btnWithoutShadow.isDisposed then
			btnWithoutShadow:setOpacity(255)
		end
	end
	startButton:addEventListener(DisplayEvents.kTouchBegin, __onButtonTouchBegin)
	startButton:addEventListener(DisplayEvents.kTouchEnd, __onButtonTouchEnd)
end

function StartGameButton:onEnterHandler(event, ...)
	assert(#{...} == 0)

	-----------------
	-- Callback Func
	-- -----------------
	local function perFrameCallback()
		self:perFrameCheckEnergyChange()
	end

	if event == "enter" then
		----------------------------------
		-- Add Scheduler To Check Energy Change
		-- -------------------------------------
		self.scheduledFuncEntryId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(perFrameCallback, 1/30, false)

	elseif event == "exit" then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.scheduledFuncEntryId)
	end
end

function StartGameButton:perFrameCheckEnergyChange(...)
	assert(#{...} == 0)

	local energyState = UserEnergyRecoverManager:sharedInstance():getEnergyState()

	if energyState == UserEnergyState.INFINITE then
		self:changeToEnergyInfiniteState()
	elseif energyState == UserEnergyState.COUNT_DOWN_TO_RECOVER then
		self:changeToEnergyCountdownState()
	else
		assert(false)
	end
end


function StartGameButton:changeToEnergyInfiniteState(...)
	assert(#{...} == 0)

	if self.buttonEnergyState ~= self.BUTTON_ENERGY_STATE_INFINITE then
		self.buttonEnergyState = self.BUTTON_ENERGY_STATE_INFINITE
		
		self.infiniteEnergy:setVisible(true)

		self.negative5Label:setVisible(false)
		self.energyIcon:setVisible(false)

		self.label:setToParentCenterHorizontal()

		local manualAdjustLabelPosX	= 34
		local manualAdjustLabelPosY	= 0
		local curPos	= self.label:getPosition()
		self.label:setPosition(ccp(curPos.x + manualAdjustLabelPosX, curPos.y + manualAdjustLabelPosY))
	end
end

function StartGameButton:changeToEnergyCountdownState(...)
	assert(#{...} == 0)

	if self.buttonEnergyState ~= self.BUTTON_ENERGY_STATE_USE_ENERGY then
		self.buttonEnergyState = self.BUTTON_ENERGY_STATE_USE_ENERGY

		self.infiniteEnergy:setVisible(false)
		self.negative5Label:setVisible(true)
		self.energyIcon:setVisible(true)

		self.label:setPosition(ccp(self.labelUseEnergyPosX, self.labelUseEnergyPosY))
	end
end

function StartGameButton:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newStartGameButton = StartGameButton.new()
	newStartGameButton:init(ui)
	return newStartGameButton
end
