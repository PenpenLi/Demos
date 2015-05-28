
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年11月22日 12:10:42
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.baseUI.ButtonWithShadow"
require "zoo.panel.component.quitPanel.QuitPanelButton"

QuitPanelMode	= {
	QUIT_LEVEL	= 1,
	QUIT_GAME	= 2,
	NO_REPLAY	= 3,
}

local function checkQuitPanelMode(mode)
	assert(mode == QuitPanelMode.QUIT_LEVEL or
		mode == QuitPanelMode.QUIT_GAME or mode == QuitPanelMode.NO_REPLAY)
end

---------------------------------------------------
-------------- QuitPanel
---------------------------------------------------

assert(not QuitPanel)
assert(BasePanel)
QuitPanel = class(BasePanel)
function QuitPanel:init(mode, ...)
	checkQuitPanelMode(mode)
	assert(#{...} == 0)
	------------------
	-- Get UI Resource
	-- ---------------
	--self.ui = ResourceManager:sharedInstance():buildGroup("quitPanel")
	self.ui	= self:buildInterfaceGroup("finalQuitPanel") --ResourceManager:sharedInstance():buildGroup("finalQuitPanel")

	----------------
	-- Init Base UI
	-- -------------
	BasePanel.init(self, self.ui)

	-------------------
	-- Data
	-- ---------------
	self.mode = mode
	self.onReplayBtnTappedCallback		= false
	self.onQuitGameBtnTappedCallback	= false
	self.onClosePanelBtnTappedCallback	= false

	self.panelChildren = {}
	self.ui:getVisibleChildrenList(self.panelChildren)

	------------------------
	-- Variable To Indicate 
	-- ----------------------
	self.BTN_TAPPED_STATE_NONE		= 1
	self.BTN_TAPPED_STATE_BTN1_TAPPED	= 2
	self.BTN_TAPPED_STATE_BTN2_TAPPED	= 3
	self.BTN_TAPPED_STATE_BTN3_TAPPED	= 4
	self.btnTappedState			= self.BTN_TAPPED_STATE_NONE

	-----------------
	-- Get UI Resource
	-- --------------
	self.musicBtn		= self.ui:getChildByName("musicBtn")
	self.soundBtn		= self.ui:getChildByName("soundBtn")

	self.notificationBtn		= self.ui:getChildByName("notificationBtn")
	self.notificationPauseIcon	= self.ui:getChildByName("notificationPauseIcon")

	self.musicPauseIcon	= self.ui:getChildByName("musicPauseIcon")
	self.soundPauseIcon	= self.ui:getChildByName("soundPauseIcon")

	--self.pauseLabel		= self.ui:getChildByName("pauseLabel")
	self.panelTitle		= self.ui:getChildByName("panelTitle")

	self.btn1Res		= self.ui:getChildByName("button1")
	self.btn2Res		= self.ui:getChildByName("button2")
	self.closeBtn		= self.ui:getChildByName("closeBtn")


	self.soundBtnTip	= self.ui:getChildByName("soundBtnTip")
	self.musicBtnTip	= self.ui:getChildByName("musicBtnTip")
	self.notificationBtnTip	= self.ui:getChildByName("notificationBtnTip")
	self.tips	= {self.soundBtnTip, self.musicBtnTip, self.notificationBtnTip}
	self.bg = self.ui:getChildByName("_newBg")

	----------------------------------
	-- When Opened In GamePlaySceneUI
	--
	-- Quit Level:
	-- btn1:	Replay Btn
	-- btn2:	Quit Level
	--------------------------------
	
	------------------------------
	-- When Opened In HomeScene
	--
	--	Quit Game:
	--  btn1:	Hlep
	--  btn2:	Quit Game
	--  ------------------------

	assert(self.musicBtn)
	assert(self.soundBtn)
	assert(self.musicPauseIcon)
	assert(self.soundPauseIcon)

	assert(self.panelTitle)

	assert(self.btn1Res)
	assert(self.btn2Res)
	assert(self.closeBtn)

	-----------------------
	-- Create UI Component
	-- -------------------
	self.btn1	= ButtonIconsetBase:create(self.btn1Res)--QuitPanelButton:create(self.btn1Res)
	self.btn2	= ButtonIconsetBase:create(self.btn2Res)--QuitPanelButton:create(self.btn2Res)

	self.btn1:setColorMode(kGroupButtonColorMode.blue)
	self.btn2:setColorMode(kGroupButtonColorMode.orange)
	self.btn1:useBubbleAnimation()
	self.btn2:useBubbleAnimation()

	--------------
	-- Init UI
	-- -----------
	self.panelTitle:setText("")
	
	-----------------
	-- Update View
	-- ---------------
	
	-- Set Music / Effect Pause Icon 
	if GamePlayMusicPlayer:getInstance().IsMusicOpen then
		self.soundPauseIcon:setVisible(false)
	end

	if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then
		self.musicPauseIcon:setVisible(false)
	end

	--if ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable then 
	if CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification") then
		self.notificationPauseIcon:setVisible(false) 
	end

	if self.mode == QuitPanelMode.QUIT_LEVEL then
		-- btn1:	Replay Btn
		-- btn2:	Quit Level

		local pauseLabelKey	= "quit.panel.pause"
		local pauseLabelValue	= Localization:getInstance():getText(pauseLabelKey)
		self.panelTitle:setText(pauseLabelValue)
		
		local btn1LabelKey 	= "quit.panel.replay"
		local btn1LabelValue 	= Localization:getInstance():getText(btn1LabelKey)
		self.btn1:setString(btn1LabelValue)
		self.btn1:setIconByFrameName("gamesetting_replay0000")
		--self.btn1.replayIcon:setVisible(true)

		local btn2LabelKey 	= "quit.panel.quit.level"
		local btn2LabelValue	= Localization:getInstance():getText(btn2LabelKey)
		self.btn2:setString(btn2LabelValue)
		self.btn2:setIconByFrameName("gamesetting_quit0000")
		--self.btn2.quitIcon:setVisible(true)

	elseif self.mode == QuitPanelMode.QUIT_GAME then --never used
		--  btn1:	Hlep
		--  btn2:	Quit Game

		local btn1LabelKey	= "quit.panel.help"
		local btn1LabelValue	= Localization:getInstance():getText(btn1LabelKey)
		self.btn1:setString(btn1LabelValue)
		--self.btn1.helpIcon:setVisible(true)

		local btn2LabelKey	= "quit.panel.quit.game"
		local btn2LabelValue	= Localization:getInstance():getText(btn2LabelKey)
		self.btn2:setString(btn2LabelValue)
		--self.btn2.quitIcon:setVisible(true)
	elseif self.mode == QuitPanelMode.NO_REPLAY then
		local pauseLabelKey	= "quit.panel.pause"
		local pauseLabelValue	= Localization:getInstance():getText(pauseLabelKey)
		self.panelTitle:setText(pauseLabelValue)
		self.btn1:setVisible(false)
		self.btn1:setEnabled(false)
		local btn2LabelKey 	= "quit.panel.quit.level"
		local btn2LabelValue	= Localization:getInstance():getText(btn2LabelKey)
		self.btn2:setString(btn2LabelValue)
		self.btn2:setIconByFrameName("gamesetting_quit0000", true)
		self.btn2:setPositionX(self.bg:getGroupBounds().size.width / 2 + 10)

	else
		assert(false)
	end
	local size = self.panelTitle:getContentSize()
	local scale = 65 / size.height
	self.panelTitle:setScale(scale)
	self.panelTitle:setPositionX((self.bg:getGroupBounds().size.width - size.width * scale) / 2)

	-------------------
	-- Add Event Listener
	-- ----------------
	local function onClosePanelBtnTapped(event)
		self:onCloseBtnTapped(event)
	end

	local function onMusicBtnTapped()
		self:onMusicBtnTapped()
	end

	local function onNotificationBtnTapped()
		self:onNotificationBtnTapped()
	end

	self.musicBtn:setButtonMode(true)
	self.musicBtn:setTouchEnabled(true)
	self.musicBtn:addEventListener(DisplayEvents.kTouchTap, onMusicBtnTapped)

	local function onSoundBtnTapped()
		self:onSoundBtnTapped()
	end
	self.soundBtn:setButtonMode(true)
	self.soundBtn:setTouchEnabled(true)
	self.soundBtn:addEventListener(DisplayEvents.kTouchTap, onSoundBtnTapped)

	self.notificationBtn:setButtonMode(true)
	self.notificationBtn:setTouchEnabled(true)
	self.notificationBtn:addEventListener(DisplayEvents.kTouchTap, onNotificationBtnTapped)

	-- Btn1 Tapped
	local function onBtn1Tapped(event)
		self:onBtn1Tapped(event)
	end
	self.btn1:addEventListener(DisplayEvents.kTouchTap, onBtn1Tapped)

	-- Btn2 Tapped
	local function onBtn2Tapped(event)
		self:onBtn2Tapped(event)
	end
	self.btn2:addEventListener(DisplayEvents.kTouchTap, onBtn2Tapped)

	-- CLose Btn
	local function onCloseBtnTapped(event)
		self:onCloseBtnTapped(event)
	end

	self.closeBtn:setTouchEnabled(true, 0, true)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)
end

function QuitPanel:onBtn1Tapped(event, ...)
	assert(#{...} == 0)

	if self.mode == QuitPanelMode.QUIT_LEVEL then

		if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
			self.btnTappedState = self.BTN_TAPPED_STATE_BTN1_TAPPED
		else
			return
		end

		self:onReplayBtnTapped(event)

	elseif self.mode == QuitPanelMode.QUIT_GAME then
		-- Help , Do Nothing
	else
		assert(false)
	end
end

function QuitPanel:onBtn2Tapped(event, ...)
	assert(#{...} == 0)

	if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
		self.btnTappedState = self.BTN_TAPPED_STATE_BTN2_TAPPED
	else
		return
	end

	if self.mode == QuitPanelMode.QUIT_LEVEL or self.mode == QuitPanelMode.NO_REPLAY then

		self:onQuitGameBtnTapped()

	elseif self.mode == QuitPanelMode.QUIT_GAME then

		CCDirector:sharedDirector():endToLua()
		--self:onQuitGameBtnTapped()
	else
		assert(false)
	end
end

function QuitPanel:onMusicBtnTapped(...)	

	if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then
		GamePlayMusicPlayer:getInstance():pauseBackgroundMusic()
		self.musicPauseIcon:setVisible(true)

		self.musicBtnTip:setString(Localization:getInstance():getText("game.setting.panel.music.close.tip"))
	else
		GamePlayMusicPlayer:getInstance():resumeBackgroundMusic()
		self.musicPauseIcon:setVisible(false)

		self.musicBtnTip:setString(Localization:getInstance():getText("game.setting.panel.music.open.tip"))
	end

	self:playShowHideLabelAnim(self.musicBtnTip)
end


function QuitPanel:onSoundBtnTapped(...)
	if GamePlayMusicPlayer:getInstance().IsMusicOpen then
		GamePlayMusicPlayer:getInstance():pauseSoundEffects()
		self.soundPauseIcon:setVisible(true)

		self.soundBtnTip:setString(Localization:getInstance():getText("game.setting.panel.sound.close.tip"))
	else
		GamePlayMusicPlayer:getInstance():resumeSoundEffects()
		self.soundPauseIcon:setVisible(false)

		self.soundBtnTip:setString(Localization:getInstance():getText("game.setting.panel.sound.open.tip"))
	end

	self:playShowHideLabelAnim(self.soundBtnTip)
end

function QuitPanel:onNotificationBtnTapped(...)

	print("GameSettingPanel:onNotificationBtnTapped Called !")
	--if ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable then
	if not CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification") then

		--ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable = false
		CCUserDefault:sharedUserDefault():setBoolForKey("game.local.notification", true)

		self.notificationBtnTip:setString(Localization:getInstance():getText("game.setting.panel.notification.open.tip"))
		self.notificationPauseIcon:setVisible(false)
	else
		--ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable = true
		CCUserDefault:sharedUserDefault():setBoolForKey("game.local.notification", false)

		self.notificationBtnTip:setString(Localization:getInstance():getText("game.setting.panel.notification.close.tip"))
		self.notificationPauseIcon:setVisible(true)
	end

	self:playShowHideLabelAnim(self.notificationBtnTip)
	--ConfigSavedToFile:sharedInstance():serialize()
	CCUserDefault:sharedUserDefault():flush()
end


function QuitPanel:playShowHideLabelAnim(labelToControl, ...)

	local delayTime	= 3

	labelToControl:stopAllActions()

	local function showFunc()
		-- Hide All Tip
		for k,v in pairs(self.tips) do
			v:setVisible(false)
		end

		labelToControl:setVisible(true)
	end
	local showAction = CCCallFunc:create(showFunc)


	local delay	= CCDelayTime:create(delayTime)


	local function hideFunc()
		labelToControl:setVisible(false)
	end
	local hideAction = CCCallFunc:create(hideFunc)

	local actionArray = CCArray:create()
	actionArray:addObject(showAction)
	actionArray:addObject(delay)
	actionArray:addObject(hideAction)

	local seq = CCSequence:create(actionArray)
	--return seq
	
	labelToControl:runAction(seq)
end

function QuitPanel:onCloseBtnTapped(event, ...)
	assert(#{...} == 0)

	he_log_warning("this kind of panel pop remove anim can reused.")
	he_log_warning("reform needed !")

	AdvertiseSDK:dismissDomobAD()

	local function animFinished()
		self.allowBackKeyTap = false
		PopoutManager:sharedInstance():remove(self, true)

		if self.onClosePanelBtnTappedCallback then
			self.onClosePanelBtnTappedCallback()
		end
	end

	self:playHideAnim(animFinished)
end

function QuitPanel:onReplayBtnTapped(event, ...)
	assert(#{...} == 0)

	local function hideAnimCallback()
		PopoutManager:sharedInstance():remove(self, true)

		if self.onReplayBtnTappedCallback then
			self.onReplayBtnTappedCallback()
		end
	end

	AdvertiseSDK:dismissDomobAD()

	self:playHideAnim(hideAnimCallback)
end

function QuitPanel:onQuitGameBtnTapped(event, ...)
	assert(#{...} == 0)

	AdvertiseSDK:dismissDomobAD()
	
	PopoutManager:sharedInstance():remove(self, true)
	
	if self.onQuitGameBtnTappedCallback then
		self.onQuitGameBtnTappedCallback()
	end
	he_log_info("auto_test_tap_quit_level")
end

function QuitPanel:onEnterHandler(event, ...)
	assert(#{...} == 0)
	if event == "enter" then
		self.allowBackKeyTap = true
		self:playShowAnim(false)
	end
end

function QuitPanel:createShowAnim(...)
	assert(#{...} == 0)

	he_log_warning("this show Anim is common to a type of panel !!!")
	he_log_warning("reform needed !")


	local centerPosX 	= self:getHCenterInParentX()
	local centerPosY	= self:getVCenterInParentY()

	---- Fade In Anim
	--for k,child in ipairs(self.panelChildren) do
	--	local fadeIn 		= CCFadeIn:create(0.5)
	--	local targetedAction 	= CCTargetedAction:create(child.refCocosObj, fadeIn)
	--	actionArray:addObject(targetedAction)
	--end


	local function initActionFunc()

		local initPosX	= centerPosX
		local initPosY	= centerPosY + 100
		self:setPosition(ccp(initPosX, initPosY))
	end
	local initAction = CCCallFunc:create(initActionFunc)

	-- Move To Center Anim
	local moveToCenter		= CCMoveTo:create(0.5, ccp(centerPosX, centerPosY))
	local backOut 			= CCEaseQuarticBackOut:create(moveToCenter, 33, -106, 126, -67, 15)
	local targetedMoveToCenter	= CCTargetedAction:create(self.refCocosObj, backOut)

	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(initAction)
	actionArray:addObject(targetedMoveToCenter)

	-- Seq
	local seq = CCSequence:create(actionArray)
	return seq

	--local spawn = CCSpawn:create(actionArray)
	--return spawn
end

--function QuitPanel:createHideAnim(...)
--	assert(#{...} == 0)
--
--	local actionArray = CCArray:create()
--
--	local centerPosX = self:getHCenterInParentX()
--	local centerPosY = self:getVCenterInParentY()
--
--	-- Fade Out Anim
--	for k,child in ipairs(self.panelChildren) do
--		local fadeOut		= CCFadeOut:create(0.5)
--		local targetedAction	= CCTargetedAction:create(child.refCocosObj, fadeOut)
--		actionArray:addObject(targetedAction)
--	end
--	
--	local curPosX 		= self:getPositionX()
--	local curPosY 		= self:getPositionY()
--	local newPosY		= curPosY
--	local moveDown 		= CCMoveTo:create(0.2, ccp(curPosX, newPosY))
--	local targetedMoveDown	= CCTargetedAction:create(self.refCocosObj, moveDown)
--	actionArray:addObject(targetedMoveDown)
--
--	local spawn = CCSpawn:create(actionArray)
--	return spawn
--end

function QuitPanel:playShowAnim(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	local showAnim 	= self:createShowAnim()

	local function finishCallback()
		if animFinishCallback then
			animFinishCallback()
		end
		he_log_info("auto_test_quit_panel_open")
	end
	local callbackAction = CCCallFunc:create(finishCallback)

	local seq = CCSequence:createWithTwoActions(showAnim, callbackAction)
	self:runAction(seq)
end

function QuitPanel:playHideAnim(animFinishCallback, ...)
	assert(type(animFinishCallback) == "function")
	assert(#{...} == 0)

	--local hideAnim = self:createHideAnim()
	--local callbackAction = CCCallFunc:create(animFinishCallback)

	--local seq = CCSequence:createWithTwoActions(hideAnim, callbackAction)
	--self:runAction(seq)
	
	animFinishCallback()
end

function QuitPanel:setOnReplayBtnTappedCallback(onReplayBtnTappedCallback, ...)
	assert(type(onReplayBtnTappedCallback) == "function")
	assert(#{...} == 0)

	self.onReplayBtnTappedCallback = onReplayBtnTappedCallback
end

function QuitPanel:setOnClosePanelBtnTapped(onClosePanelBtnTappedCallback, ...)
	assert(type(onClosePanelBtnTappedCallback) == "function")
	assert(#{...} == 0)

	self.onClosePanelBtnTappedCallback = onClosePanelBtnTappedCallback
end

function QuitPanel:setOnQuitGameBtnTappedCallback(onQuitGameBtnTappedCallback, ...)
	assert(type(onQuitGameBtnTappedCallback) == "function")
	assert(#{...} == 0)

	self.onQuitGameBtnTappedCallback = onQuitGameBtnTappedCallback
end

function QuitPanel:setOnPassLevelTappedCallback(callback)
	local width = 80
	local height = 40
	local labelLayer = LayerColor:create()
	labelLayer:changeWidthAndHeight(width, height)
	labelLayer:setColor(ccc3(0, 0, 255))
	labelLayer:setPosition(ccp(120, -60))
	labelLayer:setTouchEnabled(true)
	labelLayer:addEventListener(DisplayEvents.kTouchTap, function(event)
		callback()
	end)
	self:addChild(labelLayer)
end

-- --si xing test
function QuitPanel:setAddScoreTappedCallback(callback)
	local width = 80
	local height = 40
	local labelLayer = LayerColor:create()
	labelLayer:changeWidthAndHeight(width, height)
	labelLayer:setColor(ccc3(0, 0, 255))
	labelLayer:setPosition(ccp(400, -60))
	labelLayer:setTouchEnabled(true)
	labelLayer:addEventListener(DisplayEvents.kTouchTap, function(event)
		callback()
	end)
	self:addChild(labelLayer)
end

function QuitPanel:create(quitPanelMode, ...)
	checkQuitPanelMode(quitPanelMode)
	assert(#{...} == 0)

	local newQuitPanel = QuitPanel.new()
	newQuitPanel:loadRequiredResource(PanelConfigFiles.panel_game_setting)
	newQuitPanel:init(quitPanelMode)
	return newQuitPanel
end
