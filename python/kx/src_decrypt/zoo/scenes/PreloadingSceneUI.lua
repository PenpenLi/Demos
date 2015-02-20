require "zoo.scenes.AnimationScene"
require "zoo.scenes.PanelsScene"
require "zoo.scenes.GameChoiceScene"
require "zoo.scenes.ReplayChoiceScene"
require "zoo.util.AdvertiseSDK"
require "zoo.panel.component.common.VerticalScrollable"

local showAntiAddict = true

PreloadingSceneUI = class()

local function addSpriteFramesWithFile( plistFilename, textureFileName )
	local prefix = string.split(plistFilename, ".")[1]
	local realPlistPath = plistFilename
  	local realPngPath = textureFileName
  	if __use_small_res then  
	    realPlistPath = prefix .. "@2x.plist"
	    realPngPath = prefix .. "@2x.png"
  	end
  	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(realPlistPath, realPngPath)
  	return realPngPath, realPlistPath
end

local function showUserAgreement()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local scene = Director:sharedDirector():getRunningScene()
	if not scene or scene.isDisposed then return end
	local layer = LayerColor:create()
	layer:changeWidthAndHeight(vSize.width, vSize.height)
	layer:setColor(ccc3(255, 255, 255))
	layer:setPositionXY(vOrigin.x, vOrigin.y - vSize.height)
	layer:setTouchEnabled(true, 0, true)
	local title = TextField:create(Localization:getInstance():getText("loading.agreement.layer.title"), nil, 36)
	title:setColor(ccc3(0, 0, 0))
	title:setPositionXY(vSize.width / 2, vSize.height - 60)
	layer:addChild(title)
	local scrollable = VerticalScrollable:create(vSize.width - 120, vSize.height - 260)
	local layout = VerticalTileLayout:create(vSize.width - 120)
	local platform = "win32"
	if __ANDROID then platform = "android"
	elseif __IOS then platform = "ios" end
	local counter = 1
	local function onTimeOut()
		local key = "loading.agreement.layer.text."..platform..tostring(counter)
		local value = Localization:getInstance():getText(key, {n = '\n', s = '　'})
		if key == value or layer.isDisposed then return end
		local text = TextField:create(nil, nil, 28)
		text:setColor(ccc3(0, 0, 0))
		text:setDimensions(CCSizeMake(vSize.width - 120, 0))
		text:setString(value)
		text:setAnchorPoint(ccp(0, 1))
		local item = ItemInClippingNode:create()
		item:setParentView(scrollable)
		item:setContent(text)
		item:setHeight(text:getContentSize().height)
		layout:addItem(item)
		layout:__layout()
		scrollable:updateScrollableHeight()
		counter = counter + 1
		setTimeOut(onTimeOut, 1 / 120)
	end
	setTimeOut(onTimeOut, 1 / 120)
	scrollable:setContent(layout)
	scrollable:updateScrollableHeight()
	scrollable:setIgnoreHorizontalMove(true)
	scrollable:setPositionXY(60, vSize.height - 120)
	local scrollBounding = scrollable:getGroupBounds()
	layer:addChild(scrollable)
	local button = Layer:create()
	local buttonImg = Sprite:createWithSpriteFrameName("preloadingscene_greenbuttonline0000")
	local buttonImgSize = buttonImg:getContentSize()
	button:addChild(buttonImg)
	local buttonText = TextField:create(Localization:getInstance():getText("loading.agreement.layer.button"), nil, 40)
	buttonText:setColor(ccc3(37, 184, 82))
	button:addChild(buttonText)
	button:setPositionXY(vSize.width / 2, 70)
	layer:addChild(button)
	local function onButton()
		layer:dispatchEvent(Event.new(Events.kComplete, nil, layer))
		layer:removeFromParentAndCleanup(true)
	end
	button:setTouchEnabled(true)
	button:setButtonMode(true)
	button:addEventListener(DisplayEvents.kTouchTap, onButton)
	scene:addChild(layer)
	layer:runAction(CCMoveTo:create(0.2, ccp(vOrigin.x, vOrigin.y)))

	return layer
end

local function userAgreementTexts()
	local checked = CCUserDefault:sharedUserDefault():getBoolForKey("game.user.agreement.checked")
	if checked then return end
	local userAgreementLayer = Layer:create()
	local box = Sprite:createWithSpriteFrameName("preloadingscene_box0000")
	box:setAnchorPoint(ccp(0, 1))
	local check = Sprite:createWithSpriteFrameName("preloadingscene_check0000")
	check:setAnchorPoint(ccp(0, 0))
	local userAgreementText = TextField:create(Localization:getInstance():getText("loading.agreement.box.text"), nil, 28)
	userAgreementText:setAnchorPoint(ccp(0, 1))
	userAgreementText:setColor(ccc3(255, 255, 255))
	userAgreementText:enableShadow(CCSizeMake(2, -2), 1, 1)
	local userAgreementLink = TextField:create(Localization:getInstance():getText("loading.agreement.box.link"), nil, 28)
	userAgreementLink:setAnchorPoint(ccp(0, 1))
	userAgreementLink:setColor(ccc3(4, 170, 255))
	local userAgreementLinkShadow = TextField:create(Localization:getInstance():getText("loading.agreement.box.link"), nil, 28)
	userAgreementLinkShadow:setAnchorPoint(ccp(0, 1))
	userAgreementLinkShadow:setColor(ccc3(255, 255, 255))
	local userAgreementUnderLine = LayerColor:create()
	local userAgreementLinkSize = userAgreementLink:getContentSize()
	userAgreementUnderLine:changeWidthAndHeight(userAgreementLinkSize.width - 16, 2)
	userAgreementUnderLine:setColor(ccc3(4, 170, 255))
	userAgreementLayer:addChild(box)
	local boxSize = box:getContentSize()
	userAgreementText:setPositionXY(boxSize.width + 10, -2)
	userAgreementLayer:addChild(userAgreementText)
	local textSize = userAgreementText:getContentSize()
	userAgreementLink:setPositionXY(userAgreementText:getPositionX() + textSize.width + 5, -2)
	userAgreementLinkShadow:setPositionXY(userAgreementLink:getPositionX() + 1, userAgreementLink:getPositionY() - 1)
	userAgreementUnderLine:setPositionXY(userAgreementLink:getPositionX() + 8,
		userAgreementLink:getPositionY() - userAgreementLinkSize.height - 2)
	userAgreementLayer:addChild(userAgreementLinkShadow)
	userAgreementLayer:addChild(userAgreementLink)
	userAgreementLayer:addChild(userAgreementUnderLine)
	local bounding = userAgreementLayer:getGroupBounds().size
	userAgreementLayer:setContentSize(CCSizeMake(bounding.width, bounding.height))
	check:setPositionXY(box:getPositionX(), box:getPositionY() - boxSize.height + 3)
	userAgreementLayer:addChild(check)
	userAgreementLayer.checked = true
	local boxTouchLayer = LayerColor:create()
	boxTouchLayer:changeWidthAndHeight(boxSize.width + 20, boxSize.height + 20)
	boxTouchLayer:setPositionX(box:getPositionX() - 10)
	boxTouchLayer:setPositionY(box:getPositionY() - boxSize.height - 10)
	boxTouchLayer:setOpacity(0)
	local function onBoxTapped()
		check:setVisible(not check:isVisible())
		userAgreementLayer.checked = check:isVisible()
	end
	boxTouchLayer:setTouchEnabled(true)
	boxTouchLayer:addEventListener(DisplayEvents.kTouchTap, onBoxTapped)
	userAgreementLayer:addChild(boxTouchLayer)
	userAgreementLayer.touchLayer = boxTouchLayer
	local agreementTouchLayer = LayerColor:create()
	agreementTouchLayer:changeWidthAndHeight(userAgreementLinkSize.width + 20, userAgreementLinkSize.height + 20)
	agreementTouchLayer:setPositionX(userAgreementLink:getPositionX() - 10)
	agreementTouchLayer:setPositionY(userAgreementLink:getPositionY() - userAgreementLinkSize.height - 10)
	agreementTouchLayer:setOpacity(0)
	local function onLinkTapped()
		local function onClose()
			setTimeOut(function()
				if not agreementTouchLayer.isDisposed then agreementTouchLayer:setTouchEnabled(true) end
			end, 0.1)
		end
		agreementTouchLayer:setTouchEnabled(false)
		local layer = showUserAgreement()
		layer:addEventListener(Events.kComplete, onClose)
	end
	agreementTouchLayer:setTouchEnabled(true)
	agreementTouchLayer:addEventListener(DisplayEvents.kTouchTap, onLinkTapped)
	userAgreementLayer:addChild(agreementTouchLayer)

	local copyrightLayer = Layer:create()
	local copyright = TextField:create(Localization:getInstance():getText("loading.agreement.copyright", {s = ' '}), nil, 20)
	copyright:setAnchorPoint(ccp(0, 1))
	copyright:setColor(ccc3(255, 255, 255))
	copyright:enableShadow(CCSizeMake(2, -2), 1, 1)
	local copyrightSize = copyright:getContentSize()
	copyrightLayer:addChild(copyright)
	copyrightLayer:setContentSize(CCSizeMake(copyrightSize.width, copyrightSize.height))

	return userAgreementLayer, copyrightLayer
end

local function antiAddictionText()
	local text = TextField:create("", nil, 18, nil, kCCTextAlignmentCenter)
	text:setString(Localization:getInstance():getText("loading.agreement.antiaddiction", {n = '\n'}))
	text:setColor(ccc3(255, 255, 255))
	text:enableShadow(CCSizeMake(2, -2), 1, 1)
	text:setVisible(showAntiAddict)
	return text
end

local function createStartButton( label )
	local button = Layer:create()
	button:ignoreAnchorPointForPosition(false)
	button:setAnchorPoint(ccp(0.5, 0.5))
	
	local background = Sprite:createWithSpriteFrameName("loading_button0000")
	local contentSize = background:getContentSize()
	local filename = "fnt/loading_button.fnt"
	if _G.useTraditionalChineseRes then filename = "fnt/zh_tw/loading_button.fnt" end
	local textLabel = BitmapText:create(label, filename)--TextField:create(label, nil, 58)
	if __use_small_res then textLabel:setPosition(ccp(contentSize.width / 2, contentSize.height / 2 - 2))
	else textLabel:setPosition(ccp(contentSize.width / 2, contentSize.height / 2)) end

	background:setPosition(ccp(contentSize.width / 2, contentSize.height / 2))

	background.name = "background"
	button.textLabel = textLabel
	button:addChild(background)
	button:addChild(textLabel)
	button:setTouchEnabled(true)
	button:setButtonMode(true)
	button:setContentSize(CCSizeMake(contentSize.width, contentSize.height))
	button.setString = function ( self, str )
		self.textLabel:setText(str)
	end
	
	return button
end

function PreloadingSceneUI:setFBIconVisible(scene,visible)
	scene.startButton.fbIcon:setVisible(visible)
	if visible then 
		scene.startButton.textLabel:setPositionX(30)
	else
		scene.startButton.textLabel:setPositionX(0)
	end
end

function PreloadingSceneUI:addForCuccwo(parent)
	if StartupConfig:getInstance():getPlatformName() == "cuccwo" then 
		self.cuccwoPng = addSpriteFramesWithFile( "materials/cuccwo.plist", "materials/cuccwo.png" )
		local cuccwo = Sprite:createWithSpriteFrameName("cuccwo10000")
		cuccwo:setPosition(ccp(720,920))
		parent:addChild(cuccwo)
	end
end

function PreloadingSceneUI:removeForCuccwo()
	if StartupConfig:getInstance():getPlatformName() == "cuccwo" then
		if self.cuccwoPng then 
			CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename(self.cuccwoPng))
		end
	end
end

function PreloadingSceneUI:initUI( scene )
	local winSize = CCDirector:sharedDirector():getVisibleSize()
	local origin = CCDirector:sharedDirector():getVisibleOrigin()

	local logoPng = addSpriteFramesWithFile( "materials/logo.plist", "materials/logo.png" )
	if _G.useTraditionalChineseRes then logoPng = addSpriteFramesWithFile( "materials/logo_zh_tw.plist", "materials/logo_zh_tw.png" ) end
	local loadingPng = addSpriteFramesWithFile( "flash/loading.plist", "flash/loading.png" )

	local logo = Sprite:createWithSpriteFrameName("logo.png")
	self:addForCuccwo(logo)
	if _G.useTraditionalChineseRes then logo = Sprite:createWithSpriteFrameName("logo_zh_tw0000") end
	local logoSize = logo:getContentSize()
	local scale = winSize.height/logoSize.height
	logo:setScale(scale)
	logo:setPosition(ccp(winSize.width/2, winSize.height/2 + origin.y))
	scene:addChild(logo)

	local progressContainer = CocosObject:create()
	local background = Sprite:createWithSpriteFrameName("loading_progress_background0000")
	local bar = Sprite:createWithSpriteFrameName("loading_progress_bar0000")
	local progressBar = ProgressBar:create(bar)
	local contentSize = bar:getContentSize()
	bar:setAnchorPoint(ccp(0, 0))
	bar:setPosition(ccp((-contentSize.width)/2, (-contentSize.height)/2))
	progressBar:setPercentage(0)
	background:setPosition(ccp(1, 0))

	local textureStar = Sprite:createWithSpriteFrameName("loading_star_icon0000")
	local starLayer = SpriteBatchNode:createWithTexture(textureStar:getTexture())
	starLayer:setPosition(ccp(0, -20))

	for i=0,4 do
		local staticStar = Sprite:createWithSpriteFrameName("loading_star_icon0000")
		staticStar:setPosition(ccp(math.random()*10, 10 * i))
		staticStar:setScale(1 + math.random()*0.6)
		staticStar:runAction(CCRepeatForever:create(CCRotateBy:create(0.3, math.floor(120 + math.random()*40))))
		starLayer:addChild(staticStar)
	end
	local function onCreateStarEmitter()
		local hideTime = 1 + math.random() * 0.5
		local staticStar = Sprite:createWithSpriteFrameName("loading_star_icon0000")
		staticStar:setPosition(ccp(math.random()*10, math.random()*50))
		staticStar:setScale(0.25 + math.random()*0.2)
		staticStar:runAction(CCSpawn:createWithTwoActions(CCMoveBy:create(hideTime, ccp(-140 - math.random()*30, 0)), CCFadeOut:create(hideTime)))
		starLayer:addChild(staticStar)
	end
	starLayer:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(onCreateStarEmitter))))

	textureStar:dispose()

	local progressOffsetY = 0
	if __frame_ratio and __frame_ratio < 1.6 then  progressOffsetY = -70 end
	if __frame_ratio and __frame_ratio < 1.5 then  progressOffsetY = -100 end

	progressContainer.contentSize = {width=contentSize.width, height=contentSize.height}
	progressContainer.starLayer = starLayer
	progressContainer.progressBar = progressBar
	progressContainer:setPosition(ccp(winSize.width/2, origin.y + 270 + progressOffsetY))
	progressContainer:addChild(background)
	progressContainer:addChild(progressBar.display)
	progressContainer:addChild(starLayer)
	progressContainer.setPercentage = function ( scene, value ) 
		if value > 1 then value = 1 end
		if value < 0 then value = 0 end
		local contentSize = scene.contentSize
		local transformedWidth = contentSize.width * value
		scene.progressBar:setPercentage(value * 100) 
		scene.starLayer:setPositionX(-contentSize.width/2 + transformedWidth)
	end
	scene:addChild(progressContainer)
	scene.progressBar = progressContainer

	local statusLabelShadow = TextField:create("", "Helvetica", 26, CCSizeMake(winSize.width - 50, 120), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
	statusLabelShadow:setPosition(ccp(winSize.width/2, origin.y + 169 + progressOffsetY))
	statusLabelShadow:setColor(ccc3(46, 76, 38))
	scene:addChild(statusLabelShadow)
	scene.statusLabelShadow = statusLabelShadow

	local statusLabel = TextField:create("", "Helvetica", 26, CCSizeMake(winSize.width - 50, 120), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
	statusLabel:setPosition(ccp(winSize.width/2, origin.y + 170 + progressOffsetY))
	scene:addChild(statusLabel)
	scene.statusLabel = statusLabel

	--防沉迷临时加
	-- local preventWallowShadow = TextField:create("", "Helvetica", 26, CCSizeMake(winSize.width - 50, 120), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
	-- preventWallowShadow:setPosition(ccp(winSize.width/2, origin.y + 119 + progressOffsetY))
	-- preventWallowShadow:setColor(ccc3(46, 76, 38))
	-- scene:addChild(preventWallowShadow)
	-- scene.preventWallowShadow = preventWallowShadow

	-- local preventWallowLabel = TextField:create("抵制不良游戏  拒绝盗版游戏  注意自我保护  谨防上当受骗\n适度游戏益脑  沉迷游戏伤身  合理安排时间  享受健康生活", "Helvetica", 24, CCSizeMake(winSize.width - 50, 120), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
	local preventWallowLabel = TextField:create("", "Helvetica", 24, CCSizeMake(winSize.width - 50, 120), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
	preventWallowLabel:setPosition(ccp(winSize.width/2, origin.y + 3 + progressOffsetY))
	preventWallowLabel:setColor(ccc3(0,0,255));
	scene:addChild(preventWallowLabel)
	scene.preventWallowLabel = preventWallowLabel

	if not showAntiAddict then
		local loginTipsLabel = TextField:create(Localization:getInstance():getText("loading.tips.signup"), "Helvetica", 26, CCSizeMake(winSize.width - 100, 40), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
		loginTipsLabel:setColor(ccc3(255, 255, 255))
		loginTipsLabel:setPosition(ccp(winSize.width/2, 110))
		loginTipsLabel:enableShadow(CCSizeMake(2, -2), 1, 1)
		scene:addChild(loginTipsLabel)
		scene.loginTipsLabel = loginTipsLabel
		scene.loginTipsLabel:setVisible(false) -- default hide
	end

if not __WP8 then
	CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename(logoPng))
	CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename(loadingPng))
	self:removeForCuccwo()
end
  
	local warning = ""
	if __use_small_res and __IOS and not showAntiAddict then warning = "  "..Localization:getInstance():getText("loading.tips.low.ram") end
	local md5 = ""..warning --"."..tostring(ResourceLoader.getCurVersion())
	-- local versionLabel = TextField:create("V"..tostring(_G.bundleVersion) .. md5, "Helvetica", 24, CCSizeMake(0,0), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
	local versionLabel = TextField:create(md5, "Helvetica", 24, CCSizeMake(0,0), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
	versionLabel:setPosition(ccp(winSize.width/2, origin.y + 30))
	scene:addChild(versionLabel)
	scene.versionLabel = versionLabel
	versionLabel:setVisible(CCUserDefault:sharedUserDefault():getBoolForKey("game.user.agreement.checked"))

	progressContainer:setPercentage(0)
end

function PreloadingSceneUI:buildGuestLoginButton(scene, onTouchCallback)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local origin = CCDirector:sharedDirector():getVisibleOrigin()
	local startButton = createStartButton(Localization:getInstance():getText("button.start.game.loading"))

	local agreement, copyright = userAgreementTexts()
	local function onTouchConnectButton( evt )
		if agreement and not agreement.isDisposed then
			if not agreement.checked then
				CommonTip:showTip(Localization:getInstance():getText("loading.agreement.button.reject"))
			else
				if agreement.touchLayer and not agreement.touchLayer.isDisposed then
					agreement.touchLayer:setTouchEnabled(false)
				end
				if onTouchCallback ~= nil then onTouchCallback() end
				CCUserDefault:sharedUserDefault():setBoolForKey("game.user.agreement.checked", agreement.checked)
			end 
		else
			if onTouchCallback ~= nil then onTouchCallback() end
		end
	end 

	local progressOffsetY = 0
	if __frame_ratio and __frame_ratio < 1.6 then  progressOffsetY = -50 end
	if __frame_ratio and __frame_ratio < 1.5 then  progressOffsetY = -90 end

	local buttonY = origin.y + 300 + progressOffsetY

	startButton:setPosition(ccp(winSize.width/2, buttonY))
	startButton:setTouchEnabled(true)
	startButton:addEventListener(DisplayEvents.kTouchTap, onTouchConnectButton)
	scene:addChild(startButton)
	scene.startButton = startButton
	self:createAnimation(startButton)
	local text = antiAddictionText()
	text:setPositionXY(winSize.width / 2, startButton:getPositionY() - startButton:getContentSize().height)
	scene:addChild(text)
	scene.antiAddictionText = text

	if agreement and copyright then
		startButton:setPositionY(startButton:getPositionY() + 50)
		text:setPositionY(text:getPositionY() + 90)
		agreement:setPositionXY((winSize.width - agreement:getContentSize().width) / 2, origin.y + (300 + progressOffsetY) / 2)
		scene:addChild(agreement)
		copyright:setPositionXY((winSize.width - copyright:getContentSize().width) / 2, origin.y + (300 + progressOffsetY) / 4)
		scene:addChild(copyright)
	end
end

function PreloadingSceneUI:buildOAuthLoginButtons(scene)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local origin = CCDirector:sharedDirector():getVisibleOrigin()
	local startButton = createStartButton(Localization:getInstance():getText("button.start.game.loading"))

	local progressOffsetY = 0
	if __frame_ratio and __frame_ratio < 1.6 then  progressOffsetY = -50 end
	if __frame_ratio and __frame_ratio < 1.5 then  progressOffsetY = -90 end

	local buttonY = origin.y + 320 + progressOffsetY

	startButton:setScale(CCDirector:sharedDirector():getVisibleSize().height / 1280)
	startButton:setPosition(ccp(winSize.width/2, buttonY))
	startButton:setTouchEnabled(true)
	scene:addChild(startButton)
	self:createAnimation(startButton)

	local buttonBlue = Layer:create()
	local background = Sprite:createWithSpriteFrameName("loading_button_blue0000")
	local contentSize = background:getContentSize()
	local filename = "fnt/green_button.fnt"
	if _G.useTraditionalChineseRes then filename = "fnt/zh_tw/green_button.fnt" end
	local textLabel = BitmapText:create("0123", filename)
	textLabel:setPosition(ccp(2, 4))
	background.name = "background"
	buttonBlue.textLabel = textLabel
	buttonBlue:addChild(background)
	buttonBlue:addChild(textLabel)
	buttonBlue:setScale(CCDirector:sharedDirector():getVisibleSize().height / 1280)
	buttonBlue:setTouchEnabled(true)
	buttonBlue:setButtonMode(true)
	local text = antiAddictionText()
	local margin = (buttonY - startButton:getContentSize().height / 2 * startButton:getScale() - origin.y -
			background:getContentSize().height * buttonBlue:getScale() - text:getFontSize() * 2) / 3
	buttonBlue:setPosition(ccp(winSize.width/2, startButton:getPositionY() - startButton:getContentSize().height * startButton:getScale() / 2 -
			background:getContentSize().height * buttonBlue:getScale() / 2 - margin))
	buttonBlue.setString = function ( self, str )
		self.textLabel:setText(str)
	end
	scene:addChild(buttonBlue)
	self:createAnimation(buttonBlue)
	text:setPositionXY(winSize.width / 2, buttonBlue:getPositionY() - background:getContentSize().height * buttonBlue:getScale() / 2 -
			text:getFontSize() - margin)
	scene:addChild(text)
	scene.antiAddictionText = text

	local agreement, copyright = userAgreementTexts()
	if agreement and copyright then
		local buttonY = origin.y + 370 + progressOffsetY
		startButton:setPosition(ccp(winSize.width/2, buttonY))
		local margin = (buttonY - startButton:getContentSize().height / 2 * startButton:getScale() - origin.y - 90 -
			background:getContentSize().height * buttonBlue:getScale() - text:getFontSize() * 2) / 3
		buttonBlue:setPositionXY(winSize.width / 2, startButton:getPositionY() - startButton:getContentSize().height * startButton:getScale() / 2 -
			background:getContentSize().height * buttonBlue:getScale() / 2 - margin)
		text:setPositionXY(winSize.width / 2, buttonBlue:getPositionY() - background:getContentSize().height * buttonBlue:getScale() / 2 -
			text:getFontSize() - margin)
		agreement:setPositionXY((winSize.width - agreement:getContentSize().width) / 2, origin.y + 80)
		scene:addChild(agreement)
		copyright:setPositionXY((winSize.width - copyright:getContentSize().width) / 2, origin.y + 30)
		scene:addChild(copyright)
	end

	startButton.agreement = agreement
	buttonBlue.agreement = agreement

	return startButton, buttonBlue
end

function PreloadingSceneUI:createAnimation(startButton)
	startButton:setButtonMode(false)
	local deltaTime = 0.9
	local animations = CCArray:create()
	local originScale = startButton:getScale()
	animations:addObject(CCScaleTo:create(deltaTime, originScale * 0.98, originScale * 1.03))
	animations:addObject(CCScaleTo:create(deltaTime, originScale * 1.01, originScale * 0.96))
	animations:addObject(CCScaleTo:create(deltaTime, originScale * 0.98, originScale * 1.03))
	animations:addObject(CCScaleTo:create(deltaTime, originScale,originScale))
	startButton:runAction(CCRepeatForever:create(CCSequence:create(animations)))

	local btnWithoutShadow = startButton:getChildByName("background")
	local function __onButtonTouchBegin( evt )
		if btnWithoutShadow and not btnWithoutShadow.isDisposed then
			btnWithoutShadow:setOpacity(220)
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

function PreloadingSceneUI:buildDebugButton(scene, onTouchStartGame)
	local origin = Director:sharedDirector():getVisibleOrigin()
	local size = Director:sharedDirector():getVisibleSize()

	local buttonLayer = Layer:create()
	buttonLayer:setPosition(ccp(origin.x, origin.y))
	scene:addChild(buttonLayer)

	local function buildLabelButton( label, x, y, func, width, height, fontSize)
		width = width or 250
		height = height or 80
		local labelLayer = LayerColor:create()
		labelLayer:changeWidthAndHeight(width, height)
		labelLayer:setColor(ccc3(255, 0, 0))
		labelLayer:setPosition(ccp(x - width / 2, y - height / 2))
		labelLayer:setTouchEnabled(true, p, true)
		labelLayer:addEventListener(DisplayEvents.kTouchTap, func)
		buttonLayer:addChild(labelLayer)
		local textLabel = TextField:create(label, nil, fontSize or 32)
		textLabel:setPosition(ccp(width/2, height/2))
		labelLayer:addChild(textLabel)
		return labelLayer
	end 

	local function onTouchFcLabel(evt) Director:sharedDirector():pushScene(AnimationScene:create()) end
	local function onTouchReplayLabel(evt) Director:sharedDirector():pushScene(ReplayChoiceScene:create()) end
	local function onTouchGamePlayLabel(evt) Director:sharedDirector():pushScene(GameChoiceScene:create()) end
	local function onTouchUserInterfaceLabel( evt ) onTouchStartGame() end
	local function onTouchAnimationLabel(evt)
		--ProFi:stop()
		--ProFi:writeReport( 'MyProfilingReport.txt' )
		--local sdk = WeChatSDK.new() --AdvertiseSDK.new()
		--sdk:sendLevelMessage(10)
		--sdk:presentLimeiListOfferWall()
		--sdk:presentDomobListOfferWall()
		
		-- Director:sharedDirector():pushScene(PanelsScene:create())
		require("zoo/test/TestCCParabolaMoveTo")
	end

	local fcButton = buildLabelButton("客服工具", size.width/2, origin.x + 700, onTouchFcLabel)
	local animalButton = buildLabelButton("Play Animation", size.width/2, origin.x + 550, onTouchAnimationLabel)
	local gamePlayButton = buildLabelButton("Play Demo", size.width/2, origin.x + 400, onTouchGamePlayLabel)
	local userInterfaceButton = buildLabelButton("Home", size.width/2, origin.x + 250, onTouchUserInterfaceLabel)
	local replayButton = buildLabelButton("Replay", size.width/2, origin.x + 100, onTouchReplayLabel)
end