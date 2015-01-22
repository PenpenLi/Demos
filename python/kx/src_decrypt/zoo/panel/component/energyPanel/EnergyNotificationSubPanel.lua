
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014Äê02ÔÂ 8ÈÕ 16:18:32
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- EnergyNotificationSubPanel
---------------------------------------------------

assert(not EnergyNotificationSubPanel)
EnergyNotificationSubPanel = class(BasePanel)

function EnergyNotificationSubPanel:init(...)
	assert(#{...} == 0)

	---------------------
	-- Check Environment (It's a hack!!)
	---------------------
	local scene = Director:sharedDirector():getRunningScene()
	if not scene then return false end

	---------------------
	-- Get UI Resource
	-- -------------------
	self.ui	= self:buildInterfaceGroup("energyNotificationSubPanel") --ResourceManager:sharedInstance():buildGroup("energyNotificationSubPanel")

	---------------
	-- Init Base
	-- ----------
	BasePanel.init(self, self.ui)

	---------------------
	-- Get UI Resource
	-- -----------------
	self.energyIcon		= self.ui:getChildByName("energyIcon")
	self.energyNumber	= self.ui:getChildByName("energyNumber")
	local energyNumberFS = self.ui:getChildByName("energyNumberFontSize")
	self.closeBtn		= self.ui:getChildByName("closeBtn")
	self.countdownLabel	= self.ui:getChildByName("countdownLabel")
	self.tip1Label		= self.ui:getChildByName("tip1Label")
	self.tip2Label		= self.ui:getChildByName("tip2Label")
	self.notifyBtn		= ButtonIconsetBase:create(self.ui:getChildByName("notifyBtn"))
	self.scale9Bg		= self.ui:getChildByName("scale9Bg")

	self.energyNumber = TextField:createWithUIAdjustment(energyNumberFS, self.energyNumber)
	self.ui:addChild(self.energyNumber)

	-------------
	-- Data
	-- -----------
	self.energyRecoverSecond	= MetaManager.getInstance().global.user_energy_recover_time_unit / 1000

	--------------------
	-- Add Event Listener
	-- --------------------
	local function onCloseBtnTapped()
		self:onCloseBtnTapped()
	end

	self.closeBtn:setTouchEnabled(true,0, false)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)

	---------------------
	-- Update VIew
	-- ------------------
	self.tip1Label:setString(Localization:getInstance():getText("energy.notification.panel.want.notify"))
	self.tip2Label:setString(Localization:getInstance():getText("energy.notification.panel.setting.tip"))


	-- Init Button
	-- ------------

	local function onNotifyBtnTapped()
		self:onNotifyBtnTapped()
	end

	--self.notifyBtn:setTouchEnabled(true, 0, true)
	--self.notifyBtn:setButtonMode(true)
	self.notifyBtn:addEventListener(DisplayEvents.kTouchTap, onNotifyBtnTapped)

	--local label 		= self.notifyBtn:getChildByName("label")
	--local label_fontSize	= self.notifyBtn:getChildByName("label_fontSize")

	--local newLabel	= TextField:createWithUIAdjustment(label_fontSize, label)
	--self.notifyBtn:addChild(newLabel)
	self.notifyBtn:setString(Localization:getInstance():getText("energy.notification.panel.btn.txt", {}))
	self.notifyBtn:setIconByFrameName("clockIcon0000", true)
	self.notifyBtn.icon:setScale(self.notifyBtn.icon:getScale()*1.4)


	local notifyIcon = self.notifyBtn:getIcon()
	local iconPos = notifyIcon:getPosition()
	notifyIcon:setPosition(ccp(iconPos.x + 3, iconPos.y + 8))
	--local btnTxt = Localization:getInstance():getText("energy.notification.panel.btn.txt", {})
	--newLabel:setString(btnTxt)
	--label:setString(btnTxt)


	-- --------------------
	-- Check Energy Change
	-- -----------------

	local delay 	= CCDelayTime:create(0.1)

	local function oneSecondFunc()
		self:checkEnergyChange()
	end
	local oneSecondAction	= CCCallFunc:create(oneSecondFunc)

	-- Forevver Seq
	local seq = CCSequence:createWithTwoActions(delay, oneSecondAction)
	local forever	= CCRepeatForever:create(seq)

	self:runAction(forever)

	---- Manually Call Onec
	--self:checkEnergyChange()
	--local function checkEnergyChange() 
	--	self:checkEnergyChange()
	--end
	--self.checkEnergyChangeFunc = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(checkEnergyChange, 1/60, false)
	return true
end

function EnergyNotificationSubPanel:checkEnergyChange(...)
	assert(#{...} == 0)

	self.curEnergy			= UserEnergyRecoverManager:sharedInstance():getEnergy()
	self.maxEnergy			= UserEnergyRecoverManager:sharedInstance():getMaxEnergy()
	self.countDownSecond		= UserEnergyRecoverManager:sharedInstance():getCountdownSecondRemain()

	self:setEnergy(self.curEnergy, self.maxEnergy)
	self:setLeftSecondToRecover(self.countDownSecond)
end

function EnergyNotificationSubPanel:setLeftSecondToRecover(leftSecond, ...)
	assert(leftSecond)
	assert(type(leftSecond) == "number")
	assert(#{...} == 0)

	if leftSecond == 0 then

		-- Energy Is Full
		local timeToRecoverLabelTxtKey	= "energy.panel.energy.is.full"
		local timeToRecoverLabelTxt	= Localization:getInstance():getText(timeToRecoverLabelTxtKey, {})
		self.countdownLabel:setString(timeToRecoverLabelTxt)
	else
		local minuteFormat = self:convertSecondToMinuteFormat(leftSecond)
		local timeToRecoverLabelTxtKey	= "energy.bubble"
		local timeToRecoverLabelTxt	= Localization:getInstance():getText(timeToRecoverLabelTxtKey, {time = ''})
		self.countdownLabel:setString(minuteFormat..timeToRecoverLabelTxt)
	end
end


function EnergyNotificationSubPanel:getSecondToRecoverToEnergy(toEnergy, ...)
	assert(type(toEnergy) == "number")
	assert(#{...} == 0)

	local deltaEnergy = toEnergy - 1 - self.curEnergy
	local neededSecond = deltaEnergy * self.energyRecoverSecond

	return neededSecond
end

function EnergyNotificationSubPanel:convertSecondToMinuteFormat(second, ...)
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

function EnergyNotificationSubPanel:onNotifyBtnTapped(...)
	assert(#{...} == 0)

	if not self.isOnNotifyBtnTappedCalled then
		self.isOnNotifyBtnTappedCalled = true

		--ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable = true
		--ConfigSavedToFile:sharedInstance():serialize()
		CCUserDefault:sharedUserDefault():setBoolForKey("game.local.notification", true)
		CCUserDefault:sharedUserDefault():flush()
		self:remove()
	end
end

function EnergyNotificationSubPanel:setEnergy(curEnergy, totalEnergy, ...)
	assert(type(curEnergy)	== "number")
	assert(type(totalEnergy) == "number")
	assert(#{...} == 0)

	local separator = "/"
	self.energyNumber:setString(tostring(curEnergy) .. separator .. tostring(totalEnergy))
end

function EnergyNotificationSubPanel:onCloseBtnTapped(...)
	assert(#{...} == 0)

	if not self.isOnCloseBtnTappedCalled then
		self.isOnCloseBtnTappedCalled = true

		self:remove()
	end
end

function EnergyNotificationSubPanel:popout(...)
	assert(#{...} == 0)
	
	PopoutManager:sharedInstance():add(self, true, false)

	-- Center Self
	-- self:setToScreenCenter()
	self:setPositionForPopoutManager()

	-- Update The Last Open Time
	--ConfigSavedToFile:sharedInstance().configTable.addMaxEnergyPanel_lastOpenedTime = Localhost.getInstance():time()
	--ConfigSavedToFile:sharedInstance():serialize()

	CCUserDefault:sharedUserDefault():setDoubleForKey("energyNotificationSubPanel_lastOpenedTime", Localhost.getInstance():time())
	CCUserDefault:sharedUserDefault():flush()
end

function EnergyNotificationSubPanel:remove(...)
	assert(#{...} == 0)

	PopoutManager:sharedInstance():remove(self)
end

function EnergyNotificationSubPanel:create(...)
	assert(#{...} == 0)

	local newEnergyNotificationSubPanel = EnergyNotificationSubPanel.new()
	newEnergyNotificationSubPanel:loadRequiredResource(PanelConfigFiles.panel_game_setting)
	if not newEnergyNotificationSubPanel:init() then newEnergyNotificationSubPanel = nil end
	return newEnergyNotificationSubPanel
end
