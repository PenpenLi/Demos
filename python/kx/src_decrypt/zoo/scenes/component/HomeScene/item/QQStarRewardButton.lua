require "zoo.common.FlashAnimBuilder"
require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"
require "zoo.scenes.component.HomeScene.StarRewardButton"

assert(not QQStarRewardButton)
assert(IconButtonBase)

QQStarRewardButton = class(IconButtonBase)

QQStarRewardButtonFlyingTimerId = nil

function QQStarRewardButton:create(homeScene , needShowGuide)

	FrameLoader:loadArmature( "skeleton/qq_star_reward_animation" )

	--[[
	CCTextureCache:sharedTextureCache():removeTextureForKey(
		CCFileUtils:sharedFileUtils():fullPathForFilename("skeleton/qq_star_reward_animation/texture.png")
		)
	--]]

	local newStarRewardButton = QQStarRewardButton.new()
	newStarRewardButton.isFirstTimeStopFly = true
	newStarRewardButton.isLocked = false
	newStarRewardButton.needShowGuide = needShowGuide
	newStarRewardButton.isScrollerTouchMoveStart = false
	newStarRewardButton.isFlying = false
	newStarRewardButton.isGameInited = false

	newStarRewardButton:init()

	newStarRewardButton.lastMaskedLayerPositionX = 0
	newStarRewardButton.lastMaskedLayerPositionY = 0
	newStarRewardButton.lastSelfPositionY = 0
	newStarRewardButton.homeScene = homeScene

	local function onMoveStart(event, ...)
		if not newStarRewardButton.isLocked then
			newStarRewardButton:onScrollerTouchMoveStart()
		end
	end

	local function onMoveStop(event, ...)
		if not newStarRewardButton.isLocked then
			newStarRewardButton:onScrollerTouchMoveStop()
		end
	end

	local function onStarRewardButtonTapped(event , ...)
		if not newStarRewardButton.isLocked then
			newStarRewardButton:onStarRewardButtonTapped()
		end
	end

	local function onGameInit(event , ...)
		newStarRewardButton:onGameInit()
	end
	
	newStarRewardButton.homeScene.worldScene:addEventListener(
		WorldSceneScrollerEvents.MOVING_STARTED, onMoveStart, newStarRewardButton.homeScene.worldScene)
	newStarRewardButton.homeScene.worldScene:addEventListener(
		WorldSceneScrollerEvents.MOVING_STOPPED, onMoveStop, newStarRewardButton.homeScene.worldScene)

	newStarRewardButton.homeScene.worldScene:addEventListener(
		WorldSceneScrollerEvents.BRANCH_MOVING_STARTED, onMoveStart, newStarRewardButton.homeScene.worldScene)

	newStarRewardButton.homeScene.worldScene:addEventListener(
		WorldSceneScrollerEvents.GAME_INIT_ANIME_FIN, onGameInit, newStarRewardButton.homeScene.worldScene)
	

	--以下三条相当于BRANCH_MOVING_STOTED事件了-。-前期设计就是如此。。。。。。
	newStarRewardButton.homeScene.worldScene:addEventListener(
		WorldSceneScrollerEvents.SCROLLED_TO_RIGHT, onMoveStop, newStarRewardButton.homeScene.worldScene)
	newStarRewardButton.homeScene.worldScene:addEventListener(
		WorldSceneScrollerEvents.SCROLLED_TO_LEFT, onMoveStop, newStarRewardButton.homeScene.worldScene)
	newStarRewardButton.homeScene.worldScene:addEventListener(
		WorldSceneScrollerEvents.SCROLLED_TO_ORIGIN, onMoveStop, newStarRewardButton.homeScene.worldScene)

	newStarRewardButton.wrapper:addEventListener(DisplayEvents.kTouchTap, onStarRewardButtonTapped)

	newStarRewardButton.initTimerID = TimerUtil.addAlarm(
		function() 
			newStarRewardButton.initTimerID = nil
			if not newStarRewardButton.isGameInited and not newStarRewardButton.isScrollerTouchMoveStart then
				newStarRewardButton:onGameInit()
			end
		end, 3 , 1)

	return newStarRewardButton
end

function QQStarRewardButton:onGameInit(...)
	if not self.isGameInited then
		self.isGameInited = true
		self:startFly()
	end
end

function QQStarRewardButton:init(...)
	assert(#{...} == 0)

	-- Get UI Resoruce
	self.ui	= ResourceManager:sharedInstance():buildGroup("QQStarRewardIconMC")

	IconButtonBase.init(self, self.ui)

	self.qqRect			= self.wrapper:getChildByName("qqRect")
	local qqPosition = self.qqRect:getPosition()
	local qqSize = self.qqRect:getContentSize()
	self.qqRect:removeFromParentAndCleanup(true)
	self.qqRect = nil

	local starRewardTipKey 		= "lady.bug.icon.rewards.tips"
	local starRewardTipValue	= Localization:getInstance():getText(starRewardTipKey, {})
	--self:setTipString(starRewardTipValue)

	local container = CocosObject:create()
	local node = ArmatureNode:create("qq_star_reward_qqicon_anime")
	node:playByIndex(0)
	--node:setAnimationScale(1)
	container:addChild(node)

	self.wrapper:addChildAt(container , 1)
	container:setPosition(ccp( qqPosition.x -10 , qqPosition.y + 10 ))

	self.tipUI	= ResourceManager:sharedInstance():buildGroup("QQStartRewardIconTipMC")
	self.tipUI.tipText = self.tipUI:getChildByName("tipText")
	self.tipUI.tipBG = self.tipUI:getChildByName("tipBG")
	self.tipUI:setPosition(ccp( -320 , -50 ))
	self:addChild(self.tipUI)

	self:hideTipAnime()
end

function QQStarRewardButton:showTipAnime(tiptype)
	local aotutime = 10
	if tiptype == 1 then
		--"HI~为了鼓励大家解救村长，积累一定数量星星可来我这里领奖！"
		self.tipUI.tipText:setString(  Localization:getInstance():getText("yingyongbao.tip4") )
		aotutime = 10
	elseif tiptype == 2 then
		--"来领奖！不来弄死你！"
		self.tipUI.tipText:setString(  Localization:getInstance():getText("yingyongbao.tip3") )
		aotutime = 20
	elseif tiptype == 3 then
		--"老子闪了！自个儿玩儿蛋去吧！"
		self.tipUI.tipText:setString(  Localization:getInstance():getText("yingyongbao.tip5") )
		aotutime = 20
	end	
	
	self.tipTimerID = TimerUtil.addAlarm(
		function() 
			self.tipTimerID = nil
			self:hideTipAnime() 
			self:playIconAnim()
		end, aotutime , 1)

	--self.tipUI:setVisible(true)

	self.tipUI.tipBG:stopAllActions()
	self.tipUI.tipText:stopAllActions()

	local anim1 = CCArray:create()
	anim1:addObject( CCFadeTo:create(0.5, 255) )
	--anim1:addObject( CCCallFunc:create(action2Callback) )

	local anim2 = CCArray:create()
	anim2:addObject( CCFadeTo:create(0.5, 255) )

	self.tipUI.tipBG:runAction( CCSequence:create(anim1) )
	self.tipUI.tipText:runAction( CCSequence:create(anim2) )
	
end

function QQStarRewardButton:hideTipAnime(...)

	if self.tipTimerID then
		TimerUtil.removeAlarm(self.tipTimerID)
	end

	--self.tipUI:setVisible(false)

	self.tipUI.tipBG:stopAllActions()
	self.tipUI.tipText:stopAllActions()

	local anim1 = CCArray:create()
	anim1:addObject( CCFadeTo:create(0.5, 0) )
	--anim1:addObject( CCCallFunc:create(action2Callback) )

	local anim2 = CCArray:create()
	anim2:addObject( CCFadeTo:create(0.5, 0) )

	self.tipUI.tipBG:runAction( CCSequence:create(anim1) )
	self.tipUI.tipText:runAction( CCSequence:create(anim2) )
end

function QQStarRewardButton:onPlayFalseButtonAnime(...)
	if not self.isLocked then
		self.isLocked = true

		local callback = function()
			self.isLocked = false
			self:showTipAnime(1)
		end

		self:stopIconAnim()
		QQStarRewardLogic:getInstance():playFalseButtonFlyAnime(callback)
	end
end

function QQStarRewardButton:playIconAnim( ... )

	if not self.isIconAnimPlaying then
		self.isIconAnimPlaying = true
		local anim = CCArray:create()
		----[[
		anim:addObject( CCMoveBy:create(0.25, ccp(0,15)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,10)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,5)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,1.5)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,-1.5)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,-5)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,-10)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,-15)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,-10)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,-5)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,-1.5)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,1.5)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,5)) )
		anim:addObject( CCMoveBy:create(0.25, ccp(0,10)) )
		--]]

		--anim:addObject(CCDelayTime:create(0.3))
		local repeatForever	= CCRepeatForever:create(CCSequence:create(anim))
		self.wrapper:stopAllActions()
		self.wrapper:runAction(repeatForever)
	end
end

function QQStarRewardButton:stopIconAnim( ... )
	--IconButtonBase.stopOnlyIconAnim(self)
	if self.isIconAnimPlaying then
		self.isIconAnimPlaying = false
		self.wrapper:stopAllActions()
		--self.wrapper:setOpacity(0)
		self.wrapper:setPosition(ccp(0,0))
	end
end

function QQStarRewardButton:playDisappearAnime( ... )
	--self:setVisible(false)
	self:stopIconAnim()
	self:showTipAnime(3)

	local ontimer = function()
		local anim = CCArray:create()
		anim:addObject( CCMoveTo:create(2, ccp(self:getPositionX(),2048)) )
		anim:addObject( CCCallFunc:create( function() 
			self:setVisible(false)
			end ) )
		self:runAction( CCSequence:create(anim) )
		self:hideTipAnime()
	end

	setTimeOut(ontimer , 4)

	self.isLocked = true
end


function QQStarRewardButton:onStarRewardButtonTapped()

	local function onStarRewardPanelClose()
		--[[
		starRewardButton:update()
		if StarRewardModel:getInstance():update().allMissionComplete then
			leftRegionLayoutBar:removeItem(starRewardButton)
			starRewardButton:removeAllEventListeners()
			starRewardButton:dispose()
		end
		]]
		if StarRewardModel:getInstance():update().allMissionComplete then
			self:playDisappearAnime()
		end
	end

	-- Pass In Position
	local starRewardBtnPos 			= self:getPosition()
	local starRewardBtnParent		= self:getParent()
	local starRewardBtnPosInWorldSpace	=starRewardBtnParent:convertToWorldSpace(ccp(starRewardBtnPos.x, starRewardBtnPos.y))

	local starRewardBtnSize	= self.wrapper:getGroupBounds().size

	starRewardBtnPosInWorldSpace.x = starRewardBtnPosInWorldSpace.x + starRewardBtnSize.width / 2
	starRewardBtnPosInWorldSpace.y = starRewardBtnPosInWorldSpace.y - starRewardBtnSize.height / 2

	local starRewardPanel	= QQStarRewardPanel:create(starRewardBtnPosInWorldSpace)
	if starRewardPanel then
		starRewardPanel:registerCloseCallback(onStarRewardPanelClose)
		starRewardPanel:popout()
	end

	self:hideTipAnime()
	self:playIconAnim()
end

function QQStarRewardButton:onFlyingTimer()
	local positon = self:getPosition()
	local diff = self.courcePositionY - positon.y
	--print("RRR  QQStarRewardButton:onFlyingTimer   self.courcePosition ================= " , self.courcePositionY , diff , math.abs(diff) , math.abs(diff) <= 0.5)
	if math.abs(diff) <= 0.5 then
		self:stopFly()
		if self.isFirstTimeStopFly then
			self.isFirstTimeStopFly = false
			if self.needShowGuide then
				if QQStarRewardLogic:getInstance():isOldUser() then
					self:onPlayFalseButtonAnime()
				else
					self:showTipAnime(1)
				end
				self.needShowGuide = false
			end
		end
	else
		local cy = positon.y + ( (self.courcePositionY - positon.y) / 32 )

		self:setPosition( ccp( positon.x , cy) )
		self.lastSelfPositionY = cy
	end
end

function QQStarRewardButton:startFly()
	if self.isFlying then
		return
	end
	self.isFlying = true
	local scheduler = CCDirector:sharedDirector():getScheduler()
	local function onTimer()
		self:onFlyingTimer()
	end
	QQStarRewardButtonFlyingTimerId = scheduler:scheduleScriptFunc(onTimer, 0.016 , false)
	--debug.debug()
end

function QQStarRewardButton:stopFly()

	local scheduler = CCDirector:sharedDirector():getScheduler()
	if QQStarRewardButtonFlyingTimerId then
		scheduler:unscheduleScriptEntry(QQStarRewardButtonFlyingTimerId)
		--QQStarRewardButtonFlyingTimerId = nil
	end
	self.isFlying = false
end

function QQStarRewardButton:autoRollTimer()
	if self.homeScene then

		local cx = self.homeScene.worldScene.maskedLayer:getPositionX()
		local cy = self.homeScene.worldScene.maskedLayer:getPositionY()
		local diffX = 0
		local diffY = 0
		local newX = 0
		local newY = 0

		if  cx ~= self.lastMaskedLayerPositionX then
			diffX = cx - self.lastMaskedLayerPositionX
			--print("PPPPPPPPPPPPPPPPPPP   " , cx , self.lastMaskedLayerPositionX , self.lastSelfPositionX)
			newX = self.lastSelfPositionX + diffX
		else
			newX = self.lastSelfPositionX
		end

		if  cy ~= self.lastMaskedLayerPositionY then
			diffY = cy - self.lastMaskedLayerPositionY
			newY = self.lastSelfPositionY + diffY
		else
			newY = self.lastSelfPositionY
		end

		if diffX ~= 0 or diffY ~= 0 then
			self:setPosition( ccp( newX , newY) )
			
			self.lastSelfPositionX = newX
			self.lastSelfPositionY = newY

			self.lastMaskedLayerPositionX = cx
			self.lastMaskedLayerPositionY = cy
		end
		
	end
end

function QQStarRewardButton:onScrollerTouchMoveStart()
	self.isScrollerTouchMoveStart = true
	self:stopFly()
	local scheduler = CCDirector:sharedDirector():getScheduler()

	local autoScrollTimerInterval = UIConfigManager:sharedInstance():getConfig().worldSceneScroller_autoScrollTimerInterval

	local function autoRollTimer()
		self:autoRollTimer()
	end
	

	local cx = self.homeScene.worldScene.maskedLayer:getPositionX()
	local cy = self.homeScene.worldScene.maskedLayer:getPositionY()
	self.lastMaskedLayerPositionX = cx
	self.lastMaskedLayerPositionY = cy

	self.autoRollTimerId = scheduler:scheduleScriptFunc(autoRollTimer, 0.016 , false)
end

function QQStarRewardButton:onScrollerTouchMoveStop()
	self.isScrollerTouchMoveStart = false
	local scheduler = CCDirector:sharedDirector():getScheduler()
	if self.autoRollTimerId then
		scheduler:unscheduleScriptEntry(self.autoRollTimerId)
		self.autoRollTimerId = nil
	end
	self:startFly()
end

function QQStarRewardButton:onInitPosition()
	--self.homeScene = homeScene
	self.lastMaskedLayerPositionX = self.homeScene.worldScene.maskedLayer:getPositionX()
	self.lastMaskedLayerPositionY = self.homeScene.worldScene.maskedLayer:getPositionY()

	local positon = self:getPosition()

	self.courcePositionX = positon.x
	self.lastSelfPositionX = positon.x

	self.courcePositionY = positon.y
	self.lastSelfPositionY = -800

	self:setPosition(ccp(self.lastSelfPositionX,self.lastSelfPositionY))
end

function QQStarRewardButton:updateRewardState(...)
	if self.isDisposed or self.isLocked then return end
	local rewardLevelToPushMeta = StarRewardModel:getInstance():update().currentPromptReward
	if rewardLevelToPushMeta then
		local curTotalStar = UserManager:getInstance().user:getTotalStar()
		if curTotalStar >= rewardLevelToPushMeta.starNum then
			--self:setVisible(true)
			self.hasNewReward = true
			self:stopIconAnim()
			if not self.needShowGuide then
				self:showTipAnime(2)
			end
		else
			--self:setVisible(false)
			self.hasNewReward = false
			self:hideTipAnime()
			self:playIconAnim()
		end
	else
		--self:setVisible(false)
		self.hasNewReward = false
		self:hideTipAnime()
		self:playIconAnim()
	end
end

function QQStarRewardButton:checkShowGudie(...)
	if self.needShowGuide then
		self:stopIconAnim()
		if QQStarRewardLogic:getInstance():isOldUser() then
			--self:onPlayFalseButtonAnime()
		else
			self:showTipAnime(1)
			self.needShowGuide = false
		end
	else
		self:playIconAnim()
	end
end

