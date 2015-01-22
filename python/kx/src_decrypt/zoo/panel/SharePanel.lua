-------------------------------------------------------------------------
--  Class include: SharePanel, DefaultShareButton
-------------------------------------------------------------------------

kShareConfig = {} 
kShareConfig["3"] = {id=3, gamecenter="happyelements_last_step_pass"}
kShareConfig["4"] = {id=3, gamecenter="happyelements_finally_pass"}
kShareConfig["5"] = {id=3, gamecenter="happyelements_5steps"}
kShareConfig["6"] = {id=3, gamecenter="happyelements_rocket"}
kShareConfig["10"] = {id=3, gamecenter="happyelements_all_star"}

--
-- DefaultShareButton ---------------------------------------------------------
--

DefaultShareButton = class(Layer)
function DefaultShareButton:create(label)
  local ret = DefaultShareButton.new()
  ret:initLayer()
  ret:setTouchEnabled(true)
  ret:buildUI(label)
  return ret
end
function DefaultShareButton:dispose()
	Layer.dispose(self)
end

function DefaultShareButton:buildUI(label)
	local background = Scale9Sprite:createWithSpriteFrameName("ui_scale9/ui_button_green_scale90000")
	local contentSize = background:getContentSize()
	background:setScale(1.8189393939394)
	self:addChild(background)	
	--
	local filename = "fnt/green_button.fnt"
	if _G.useTraditionalChineseRes then filename = "fnt/zh_tw/green_button.fnt" end
	local textLabel = BitmapText:create(label, filename)--TextField:create(label, nil, 58)
	textLabel:setPosition(ccp(0, -2))
	textLabel:setScale(1.5)
	self:addChild(textLabel)

--[[
	local iconBg = Sprite:createWithSpriteFrameName("share_coin0000")
	local iconSize = iconBg:getContentSize()
	local iconX = (contentSize.width + iconSize.width)/2 - 6
	local iconY = contentSize.height/2
	iconBg:setPosition(ccp(iconX, iconY))
	self:addChild(iconBg)

	local coinLabel = BitmapText:create("+90", "fnt/energy_cd.fnt")
	coinLabel:setPosition(ccp(iconX, iconY - 28))
	self:addChild(coinLabel)
	]]
end

--
-- SharePanel ---------------------------------------------------------
--
SharePanel = class(LayerColor)
function SharePanel:create(rewardID)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local ret = SharePanel.new()
	ret:initLayer()
	ret:changeWidthAndHeight(winSize.width, winSize.height)
	ret:setColor(ccc3(0,0,0))
	ret:setAlpha(0.7)
	ret:buildUI(rewardID)
	return ret
end

function SharePanel:openAppBar( sub )
	sub = sub or 2
	local AppbarAgent = luajava.bindClass("com.tencent.open.yyb.AppbarAgent")
	local cat = nil
	if sub == 0 then cat = AppbarAgent.TO_APPBAR_NEWS
	elseif sub == 1 then cat = AppbarAgent.TO_APPBAR_SEND_BLOG
	else cat = AppbarAgent.TO_APPBAR_DETAIL end
	
	local tencentOpenSdk = luajava.bindClass("com.happyelements.android.sns.tencent.TencentOpenSdk"):getInstance()
	tencentOpenSdk:startAppBar(cat)
end

local function popoutSharePanelIfMetalReward( shareID )
	if shareID == 10 then 
		-- share of max star
		local http = RewardMetalHttp.new()
		if http:load(shareID) then SharePanel:create(shareID):popout() end
	else
		local http = RewardMetalHttp.new()
		http:load(shareID)
		SharePanel:create(shareID):popout()
	end	
end
function SharePanel:onLastStepPassLevel()
	local user = UserManager.getInstance().user
	if user:getTopLevelId() < 7 then return end

	popoutSharePanelIfMetalReward(3)
end
function SharePanel:onFailLevel( level, totalScore )
	UserService.getInstance():onLevelUpdate(0, level, totalScore)
end
function SharePanel:onPassLevel(level, totalScore, levelType)
	if levelType == GameLevelType.kDigWeekly
		-- or levelType == GameLevelType.kRabbitWeekly
	then
		return
	end

	local levelDataInfo = UserService.getInstance().levelDataInfo
	local levelInfo = levelDataInfo:getLevelInfo(level)
	local alreadyWin = levelInfo.win or 0
	UserService.getInstance():onLevelUpdate(1, level, totalScore)
	levelInfo = levelDataInfo:getLevelInfo(level)

	local maxConbo = levelDataInfo.maxConbo or 0
	if maxConbo >= 15 then popoutSharePanelIfMetalReward(6) end

	local now = os.time()	
	local createTime = levelInfo.createTime or 0
	local failTimes = levelInfo.failTimes or 0
	local deltaTime = now - createTime
	local minDay = 3 * 24 * 60 * 60 * 1000
	if alreadyWin == 0 and deltaTime >= minDay and failTimes >= 10 then
		popoutSharePanelIfMetalReward(4)
	end

	local scores = MetaModel:sharedInstance():getLevelTargetScores(level)
	local star = 0
	for k, v in ipairs(scores) do
		if totalScore > v then star = k end
	end
	if star >= 4 then popoutSharePanelIfMetalReward(7) end

	local maxStar = kMaxLevels * 3
	local user = UserManager:getInstance().user
	local userStar = user:getStar()
	if userStar >= maxStar then
		popoutSharePanelIfMetalReward(10)
	end

	local user = UserService.getInstance().user
	if user then
		GameCenterSDK:getInstance():reportScore(user:getStar(), kGameCenterLeaderboards.all_star_leaderboard)
	end

	local rated = CCUserDefault:sharedUserDefault():getBoolForKey("game.local.review")
	if __WP8 and not rated and level % 5 == 3 then
		local _msg = Localization:getInstance():getText("ratings.and.review.body")
		local _title = Localization:getInstance():getText("ratings.and.review.title")
		local function _callback(r)
			if not r then return end
			Wp8Utils:RunRateReview()
			CCUserDefault:sharedUserDefault():setBoolForKey("game.local.review", true)
			CCUserDefault:sharedUserDefault():flush()
		end
		Wp8Utils:ShowMessageBox(_msg, _title, _callback)
	end
	if __IOS and level == 14 and not rated then

		local function onUIAlertViewCallback( alertView, buttonIndex )
			if buttonIndex == 1 then
				local nsURL = NSURL:URLWithString(NetworkConfig.appstoreURL)
				UIApplication:sharedApplication():openURL(nsURL)
			end
		end
		local title = Localization:getInstance():getText("ratings.and.review.title")
		local okLabel = Localization:getInstance():getText("ratings.and.review.cancel")
		local UIAlertViewClass = require "zoo.util.UIAlertViewDelegateImpl"
		local alert = UIAlertViewClass:buildUI(title, Localization:getInstance():getText("ratings.and.review.body"), okLabel, onUIAlertViewCallback)
		alert:addButtonWithTitle(Localization:getInstance():getText("ratings.and.review.confirm"))
		alert:show()

		CCUserDefault:sharedUserDefault():setBoolForKey("game.local.review", true)
		CCUserDefault:sharedUserDefault():flush()
	end
end

function SharePanel:onPassLevelWithin5Steps()
	local user = UserManager.getInstance().user
	if user:getTopLevelId() < 15 then return end
	popoutSharePanelIfMetalReward(5)
end

function SharePanel:onUnlockHiddenLevel()
	popoutSharePanelIfMetalReward(8)
end

function SharePanel:onFriendRankFirst()
	local user = UserManager.getInstance().user
	if user:getTopLevelId() < 7 then return end
	local count = FriendManager:getInstance():getFriendCount()
	if count >= 3 then
		popoutSharePanelIfMetalReward(15)
	end
end

function SharePanel:onPassAllLevels()
	popoutSharePanelIfMetalReward(9)
end

function SharePanel:onBetterRankInServer()
	local user = UserManager.getInstance().user
	if user:getTopLevelId() < 7 then return end
	popoutSharePanelIfMetalReward(2)
end

local function createLightFan()
	local textureSprite = Sprite:createWithSpriteFrameName("share_light0000")
	local container = SpriteBatchNode:createWithTexture(textureSprite:getTexture())
	for i = 0, 9 do
		local spriteA = Sprite:createWithSpriteFrameName("share_light0000")
		spriteA:setAnchorPoint(ccp(0.5, 0))
		spriteA:setRotation(i * 36)
		spriteA:setScale(2.1)
		container:addChild(spriteA)

		local spriteB = Sprite:createWithSpriteFrameName("share_light0000")
		spriteB:setAnchorPoint(ccp(0.5, 0))
		spriteB:setRotation(i * 36 + 18)
		spriteB:setScale(1.75)
		container:addChild(spriteB)
	end
	textureSprite:dispose()
	container:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 20)))
	return container
end
local kShareStarPosition ={
	{42,137},{46,89},{127,56},{161,56},{301,65},{414,113},{443,142},{431,418},{347,491},{262,518}
}
local function createStarCircle()
	local textureSprite = Sprite:createWithSpriteFrameName("share_star0000")
	local container = SpriteBatchNode:createWithTexture(textureSprite:getTexture())
	for i = 1, #kShareStarPosition do
		local fadeTime = 0.5 + math.random()*1.5
		local position = kShareStarPosition[i]
		local sprite = Sprite:createWithSpriteFrameName("share_star0000")
		sprite:setPosition(ccp(position[1], -position[2]))
		sprite:setScale(0.3 + math.random()*0.7)
		sprite:setAlpha(0)
		sprite:runAction(CCRepeatForever:create(CCRotateBy:create(0.5+math.random()*1.5, 60, 60)))
		sprite:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeIn:create(fadeTime), CCFadeOut:create(fadeTime))))
		container:addChild(sprite)
	end
	textureSprite:dispose()
	return container
end

function SharePanel:buildUI(rewardID)
	self.rewardID = rewardID
	local origin = Director:sharedDirector():getVisibleOrigin()
	local winSize = CCDirector:sharedDirector():getVisibleSize()
	self:setPosition(ccp(origin.x, origin.y))

	local ribbonContainer = CocosObject:create()
	local ribbon_top = FrameLoader:loadPngOnly( "share/ribbon_top.png", true )
	local topSize = ribbon_top:getContentSize()
	local offsetY = 10
	local fan = createLightFan()
	local iconContainer = CocosObject:create()
	local starContainer = createStarCircle()

	local topOffset = 0
	if __frame_ratio and __frame_ratio < 1.6 then  topOffset = 120 end

	ribbon_top:setPosition(ccp(-10, -topSize.height/2 + offsetY + 50))
	ribbon_top:setRotation(45)
	ribbon_top:runAction(CCEaseElasticOut:create(CCRotateTo:create(1.5, 0)))
	ribbon_top:runAction(CCEaseElasticOut:create(CCMoveTo:create(0.5, ccp(0, -topSize.height/2 + offsetY)))) 
	ribbonContainer:setPosition(ccp(winSize.width/2, winSize.height + topOffset))
	self.ribbonContainer = ribbonContainer

	ribbonContainer:addChild(fan)
	ribbonContainer:addChild(ribbon_top)
	ribbonContainer:addChild(iconContainer)
	
	local iconY = 0
	local icon = FrameLoader:loadPngOnly( "share/share_"..rewardID..".png", true)
	if icon then
		iconContainer:addChild(icon)
		iconContainer:addChild(starContainer)
		local iconSize = icon:getContentSize()
		iconY = 20-topSize.height - iconSize.height/2 + offsetY
		iconContainer:setPosition(ccp(-70, iconY+120))
		iconContainer:runAction(CCEaseBackOut:create(CCMoveTo:create(0.5, ccp(0, iconY))))
		starContainer:setPosition(ccp(-iconSize.width/2+15, iconSize.height/2 + 15))

		icon:setAnchorPoint(ccp(0.5, 0.9))
		icon:setPosition(ccp(0, iconSize.height*0.5*0.9 - 15))
		icon:setRotation(60)
		icon:runAction(CCEaseElasticOut:create(CCRotateTo:create(1.5, 0)))
	end
	
	fan:setPosition(ccp(0, iconY))
	self:addChild(ribbonContainer)

	local messageOffset, buttonOffset, buttonScale = 0,0,1
	if __frame_ratio and __frame_ratio < 1.6 then  
		messageOffset = -100 
		buttonOffset = -70
		buttonScale = 0.9
	end
	if __frame_ratio and __frame_ratio < 1.4 then  
		messageOffset = -160 
		buttonOffset = -100
		buttonScale = 0.7
	end

	local function onTouchContent( evt )
		if self.button:hitTestPoint(evt.globalPosition, true) then self:share()
		elseif self.buttonClose:hitTestPoint(evt.globalPosition, true) then  self:removePopout(true) end
	end

	
	local buttonClose = Layer:create()
	local closeIcon = Sprite:createWithSpriteFrameName("ui_buttons/close_yellow/ui_button_close_panel_yellow_shape0000")
	local closeSize = closeIcon:getContentSize()
	closeIcon:setPosition(ccp(30, 30))
	buttonClose:addChild(closeIcon)
	buttonClose:setContentSize(CCSizeMake(closeSize.width*4, closeSize.height*4))
	buttonClose:setPosition(ccp(winSize.width - closeSize.width - 15, winSize.height - closeSize.height - 15))
	self.buttonClose = buttonClose
	
	self:setTouchEnabled(true, -999, true)
	self:addEventListener(DisplayEvents.kTouchTap, onTouchContent)

	local replaceObj = {}
	if rewardID == 10 then replaceObj.num = kMaxLevels * 3 end
	local message = Localization:getInstance():getText("share.feed.text"..rewardID, replaceObj)
	local messageLabel = TextField:create(message, nil, 34, CCSizeMake(winSize.width-200, 100), kCCTextAlignmentCenter)
	messageLabel:setPosition(ccp(winSize.width/2, 380 + messageOffset))
	self:addChild(messageLabel)

	local button = DefaultShareButton:create(Localization:getInstance():getText("share.feed.button.achive"))
	button:setPosition(ccp(winSize.width/2, 200+ buttonOffset))
	button:setScale(buttonScale)
	--button:setButtonMode(true)
	self:addChild(button)
	self.button = button

	FrameLoader:loadImageWithPlist( "materials/gamelogo.plist" )
	local gamelogo = Sprite:createWithSpriteFrameName("gamelogo.png")
	gamelogo:setPosition(ccp(winSize.width/2, 200+ buttonOffset))
	gamelogo:setScale(buttonScale)
	gamelogo:setVisible(false)
	self:addChild(gamelogo)
	self.gamelogo = gamelogo
	FrameLoader:unloadImageWithPlists( {"materials/gamelogo.plist"} )

	self:addChild(buttonClose)
end

function SharePanel:hitTestPoint(worldPosition, useGroupTest)
	return true
end
function SharePanel:share()
	local button = self.button
	button:setVisible(false)
	self.gamelogo:setVisible(true)
	local function onAnimationFinish()
		local replaceObj = {}
		if self.rewardID == 10 then replaceObj.num = kMaxLevels * 3 end
		local message = Localization:getInstance():getText("share.feed.text"..self.rewardID, replaceObj)
		
		if __IOS_FB then
			if SnsProxy:isShareAvailable() then
				local callback = {
					onSuccess = function(result)
						button:setVisible(true)
						self.gamelogo:setVisible(false)
						self:removePopout()
						self:onShareSucceed()
						CommonTip:showTip(Localization:getInstance():getText("share.feed.success.tips"), "positive")
					end,
					onError = function(err)
						button:setVisible(true)
						self.gamelogo:setVisible(false)
						
						self:onShareFailed()
					end
				}
				local shareTitle = Localization:getInstance():getText("share.feed.title"..self.rewardID)
				local shareImage = string.format("http://statictw.animal.he-games.com/mobanimal/fb/achievement/ach%04d.png", self.rewardID) 
				-- HeResPathUtils:getAppAssetsPath() .. "/resource/share/fb/share_" .. self.rewardID .. ".png"
				-- SnsProxy:sendNewFeedsWithLocalImage(FBOGActionType.REACH, FBOGObjectType.ACHIEVEMENT, shareTitle, message, shareImage, link, callback)
				SnsProxy:sendNewFeedsWithParams(FBOGActionType.REACH, FBOGObjectType.ACHIEVEMENT, shareTitle, message, shareImage, link, callback)
			end
		else
			local function onSnapShootFinish()
				button:setVisible(true)
				self.gamelogo:setVisible(false)
				self:removePopout()
			end

			local shareCallback = {
				onSuccess = function(result)
					self:onShareSucceed()
				end,
				onError = function(errCode, errMsg)
					self:onShareFailed()
				end,
				onCancel = function()
					self:onShareFailed()
				end,
			}
			if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
				SnsUtil.shareAchivment( PlatformShareEnum.kMiTalk, self.rewardID, onSnapShootFinish, shareCallback )
			else
				SnsUtil.shareAchivment( PlatformShareEnum.kWechat, self.rewardID, onSnapShootFinish, shareCallback )
			end
		end	
	end
	button:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.01), CCCallFunc:create(onAnimationFinish)))
end

function SharePanel:onShareSucceed()
	-- CommonTip:showTip(Localization:getInstance():getText("share.feed.success.tips"), "positive")
end

function SharePanel:onShareFailed()
	local scene = Director:sharedDirector():getRunningScene()
	if scene then
		local item = RequireNetworkAlert.new(CCNode:create())
		local shareFailedLocalKey = "share.feed.faild.tips"
		if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
	 		shareFailedLocalKey = "share.feed.faild.tips.mitalk" 
	 	end
		item:buildUI(Localization:getInstance():getText(shareFailedLocalKey))
		scene:addChild(item)  
	end
end

function SharePanel:removePopout()
	self:removeFromParentAndCleanup(true)
end
function SharePanel:popout()
	local scene = Director:sharedDirector():getRunningScene()
	if scene then 
		scene:addChild(self) 
	end
end