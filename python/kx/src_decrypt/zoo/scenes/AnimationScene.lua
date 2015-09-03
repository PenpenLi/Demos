require "hecore.display.Director"
require "hecore.display.TextField"
require "hecore.display.ArmatureNode"
require "hecore.ui.ControlButton"

require "zoo.animation.TileCharacter"
require "zoo.animation.TileBird"
require "zoo.animation.GamePropsAnimation"
require "zoo.animation.LinkedItemAnimation"
require "zoo.animation.TileCuteBall"
require "zoo.animation.CommonEffect"
require "zoo.animation.Flowers"
require "zoo.animation.Clouds"
require "zoo.animation.HiddenBranchAnimation"
require "zoo.animation.LadybugAnimation"
require "zoo.animation.PropListAnimation"
require "zoo.animation.LevelTargetAnimation"
require "zoo.animation.PrefixPropAnimation"
require "zoo.animation.WinAnimation"
require "zoo.animation.LadybugTaskAnimation"
require "zoo.animation.MaxEnergyAnimation"

require "zoo.data.ShareManager"
require "zoo.panel.ChooseFriendPanel"
require "zoo.panel.RequireNetworkAlert"
require "zoo.panel.DynamicUpdatePanel"
require "zoo.panel.ExceptionPanel"
require "zoo.scenes.MessageCenterScene"

require "zoo.net.Http"
require "zoo.util.HeadImageLoader"

AnimationScene = class(Scene)
function AnimationScene:ctor()
	self.backButton = nil
end
function AnimationScene:dispose()
	if self.backButton then self.backButton:removeAllEventListeners() end
	self.backButton = nil
	
	Scene.dispose(self)
end

function AnimationScene:create()
	local s = AnimationScene.new()
	s:initScene()
	return s
end

function AnimationScene:onInit()
	local winSize = CCDirector:sharedDirector():getWinSize()
	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(winSize.width, winSize.height)
	colorLayer:setColor(ccc3(255, 255, 255))
	colorLayer:setOpacity(100)
	self:addChild(colorLayer)

	local function onTouchBackLabel(evt)
		--Director:sharedDirector():popScene()
		--self:testAnimation()
		self:testJuice()
	end

	local function buildLabelButton( label, x, y, func )
		local width = 250
		local height = 80
		local labelLayer = LayerColor:create()
		labelLayer:changeWidthAndHeight(width, height)
		labelLayer:setColor(ccc3(255, 0, 0))
		labelLayer:setPosition(ccp(x - width / 2, y - height / 2))
		labelLayer:setTouchEnabled(true, p, true)
		labelLayer:addEventListener(DisplayEvents.kTouchTap, func)
		self:addChild(labelLayer)

		local textLabel = TextField:create(label, nil, 32)
		textLabel:setPosition(ccp(width/2, height/2))
		textLabel:setAnchorPoint(ccp(0,0))
		labelLayer:addChild(textLabel)

		return labelLayer
	end 
	
	local layer = Layer:create()
  	self:addChild(layer)
  	self.layer = layer

  	--self:testShaderSprite9()
  	--self:testGroup()
  	--self:testShader()
  	--self:testScale9Sprite()
  	--self:testScale9Sprite2()
  	--self:testChoosePanel()
  	--self:testSharePanel()
  	--self:testMaxEnergyAnimation()
  	--self:testLadyBugTask()
  	--self:testArmature()
  	--self:testLoadFriends()
  	--self:testPrefixAnimation()
  	--self:testPropsList()
  	--self:testPath()
  	--self:testLevelTarget()
  	--self:testQuaiticBackOut()
  	--self:testFlowers()
  	--self:testClouds()
  	--self:testBranch()

	--self:testCommonEffect()
	--self:testFrosting()
	--self:testGameProps()
	--self:testCureBall()
	--self:testCharacters()
	--self:testBird()

	--self:testAnimation()

	self.backButton = buildLabelButton("Back", 0, winSize.height-100, onTouchBackLabel)
end

local function createJuiceBottleByStep2(step)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local builder = InterfaceBuilder:createWithContentsOfFile("flash/animation/juice/juice_bottle.json")
	local bottle0 = builder:buildGroup("bottle"..step)

	return bottle0
end

local PositionYOffsetAndScaleX = {{-32, 0.833}, {-22, 1.0},{-32, 1.0},{-32, 1.0} } 

local function createJuiceBottleByStep(step)
	local bottle_glow = Sprite:createWithSpriteFrameName("BottleGlow instance 10000")
	local bottle = Layer:create()
	bottle:changeWidthAndHeight(bottle_glow:getGroupBounds().size.width, bottle_glow:getGroupBounds().size.height)

	local juice_shake = Sprite:createWithSpriteFrameName("juice_shake_0000.png")
	if step == 0 then
		bottle_empty = Sprite:createWithSpriteFrameName("bottle instance 10000")
		bottle:addChild(bottle_empty)
		
		bottle_glow:setPositionXY(0, 4)
		bottle:addChild(bottle_glow)
	else
		local bottle_front = Sprite:createWithSpriteFrameName("bottle_front instance 10000")
		local bottle_back = Sprite:createWithSpriteFrameName("bottle_back"..step.." instance 10000")
		bottle:addChild(bottle_back)

		juice_shake:setPosition(ccp(8, PositionYOffsetAndScaleX[step][1]))
		juice_shake:setScaleX(PositionYOffsetAndScaleX[step][2])
		bottle:addChild(juice_shake)

		bottle_front:setPositionXY(0,8)
		bottle:addChild(bottle_front)

		bottle_glow:setPositionXY(0, 4)
		--bottle:addChild(bottle_glow)
	end

	return bottle, bottle_glow, juice_shake
end

function AnimationScene:juiceChangeAnimation(from, to)
	local winSize = CCDirector:sharedDirector():getWinSize()
	
	local bottleStart = createJuiceBottleByStep2(from)
	bottleStart:setPosition(ccp(winSize.width/2, bottleStart:getGroupBounds().size.height))
	self.layer:addChild(bottleStart)

	local juice_shake_start = bottleStart:getChildByName("juice_shake")
	if juice_shake_start then
		juice_shake_start:setVisible(false)
	end

	local glow_start = bottleStart:getChildByName("glow")
	glow_start:setAlpha(0.2)
	glow_start:runAction(CCFadeTo:create(8/30, 255))

	local bottleEnd = createJuiceBottleByStep2(to)
	local glow_end = bottleEnd:getChildByName("glow")

	local actions = CCArray:create()
	actions:addObject(CCScaleTo:create(4/30, 1.13, 0.84))
	if juice_shake_start then
		actions:addObject(CCCallFunc:create(function() 
				local juice_surface_start = bottleStart:getChildByName("surface")
				if juice_surface_start then
					juice_surface_start:setVisible(false)
					juice_shake_start:setVisible(true)

					local juice_frames = SpriteUtil:buildFrames("juice_shake_%04d.png", 0, 27)
					local juice_animate = SpriteUtil:buildAnimate(juice_frames, 1/25)
					juice_shake_start:play(juice_animate, 0, 1, nil, false)
				end
			end))
	end
	actions:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(4/30, 1, 1.10), CCMoveBy:create(4/30, ccp(0,8))))
	actions:addObject(CCCallFunc:create(function() 

		bottleEnd:setPositionXY(bottleStart:getPositionX(), bottleStart:getPositionY())
		bottleEnd:setScaleX(bottleStart:getScaleX())
		bottleEnd:setScaleY(1.2)
		self.layer:addChild(bottleEnd)
		bottleStart:setVisible(false)

		local juice_surface = bottleEnd:getChildByName("surface")
		juice_surface:setVisible(false)

		local newJuice_shake = bottleEnd:getChildByName("juice_shake")
		newJuice_shake:setVisible(true)

		local juice_frames = SpriteUtil:buildFrames("juice_shake_%04d.png", 0, 27)
		local juice_animate = SpriteUtil:buildAnimate(juice_frames, 1/25)
		newJuice_shake:play(juice_animate, 0, 1, function()
				juice_surface:setVisible(true)
			end, true)

		local juice_splash = Sprite:createWithSpriteFrameName("juice_splash_0000.png")
		juice_splash:setPositionXY(bottleEnd:getPositionX(), bottleEnd:getPositionY() + juice_splash:getContentSize().height/2)
		self.layer:addChild(juice_splash)

		local splash_frames = SpriteUtil:buildFrames("juice_splash_%04d.png", 0, 8)
		local splash_animate = SpriteUtil:buildAnimate(splash_frames, 1/30)
		juice_splash:play(splash_animate, 0, 1, nil, true)

		local bubble =  Sprite:createWithSpriteFrameName("juice_bubble_0000.png")
		bubble:setPositionXY(bottleEnd:getPositionX(), bottleEnd:getPositionY() + bubble:getContentSize().height/2)

		local bubble_frames = SpriteUtil:buildFrames("juice_bubble_%04d.png", 0, 10)
		local bubble_animate = SpriteUtil:buildAnimate(bubble_frames, 1/20)
		bubble:play(bubble_animate, 0, 2, nil, true)
		self.layer:addChild(bubble)

		local actions2 = CCArray:create()
		actions2:addObject(CCScaleTo:create(3/30, 1,1))
		actions2:addObject(CCMoveBy:create(5/30, ccp(0, -8)))
		actions2:addObject(
			CCCallFunc:create(function()
					bottleEnd:removeFromParentAndCleanup(false)
					
					local bottle_wrapper = Layer:create()
	 				bottle_wrapper:changeWidthAndHeight(bottleEnd:getGroupBounds().size.width, bottleEnd:getGroupBounds().size.height)
	 				bottle_wrapper:addChild(bottleEnd)
	 				bottle_wrapper:setAnchorPoint(ccp(0, 0.3))
	 				bottle_wrapper:setPositionXY(bottleEnd:getPositionX(), bottleEnd:getPositionY())
	 				bottleEnd:setPositionXY(0, 0)

	 				local rotate =  CCRepeat:create(CCSequence:createWithTwoActions(CCRotateTo:create(8/15, 30), CCRotateTo:create(8/15, -30)), 6)
					bottle_wrapper:runAction(CCSequence:createWithTwoActions(rotate, CCRotateTo:create(4/15, 0)))
					self.layer:addChild(bottle_wrapper)
				end))
		bottleEnd:runAction(CCSequence:create(actions2))

		if to == 5 then
			glow_end:runAction(CCRepeat:create(
				 CCSequence:createWithTwoActions(CCFadeTo:create(8/15, 255), CCFadeTo:create(8/15, 255 * 0.2)),
				 6))
		else
			glow_end:runAction(  CCFadeTo:create(8/30, 255 * 0.2))
		end
	end))

	bottleStart:runAction(CCSequence:create(actions))

	return bottleStart, bottleEnd
end


local bottleStart, bottleEnd

local function clearBottle()

	if bottleStart then
		bottleStart:removeFromParentAndCleanup(true)
	end

	if bottleEnd then
		bottleEnd:removeFromParentAndCleanup(true)
	end
end

function AnimationScene:testJuice()
	local winSize = CCDirector:sharedDirector():getVisibleSize()

	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("flash/animation/juice/juice_animation.plist")
	--CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("flash/animation/juice/juice_bottle.plist")

	clearBottle()
	bottleStart, bottleEnd = self:juiceChangeAnimation(4, 5)

	 local bottle0 = createJuiceBottleByStep2(0)
	 print("bounds height: ", bottle0:getGroupBounds().size.height)
	 --bottle0:setPosition(ccp(winSize.width/2 - bottle0:getGroupBounds().size.width, bottle0:getGroupBounds().size.height))

	 --[[local bottle1 = createJuiceBottleByStep2(1)
	 bottle1:setScaleY(2)
	 bottle1:setPosition(ccp(winSize.width/2, bottle0:getGroupBounds().size.height))

	 local bottle_wrapper = Layer:create()
	 bottle_wrapper:changeWidthAndHeight(bottle0:getGroupBounds().size.width, bottle0:getGroupBounds().size.height)
	 bottle_wrapper:addChild(bottle0)
	 bottle_wrapper:setAnchorPoint(ccp(0, 0.3))
	 bottle_wrapper:setPositionXY(winSize.width/2, bottle0:getGroupBounds().size.height)

	 local action =  CCSequence:createWithTwoActions(
	 		CCRepeat:create(CCSequence:createWithTwoActions(CCRotateTo:create(8/15, 30), CCRotateTo:create(8/15, -30)), 6),
	 		CCRotateTo:create(4/15, 0))
	 bottle_wrapper:runAction(action)]]--

	-- local bottle2 = createJuiceBottleByStep2(2)
	-- bottle2:setPosition(ccp(winSize.width/2, bottle0:getGroupBounds().size.height*3))

	-- local bottle3 = createJuiceBottleByStep2(3)
	-- bottle3:setPosition(ccp(winSize.width/2, bottle0:getGroupBounds().size.height*4))

	-- local bottle4 = createJuiceBottleByStep2(4)
	-- bottle4:setPosition(ccp(winSize.width/2, bottle0:getGroupBounds().size.height*5))

	 --self.layer:addChild(bottle_wrapper)
	 --self.layer:addChild(bottle1)
	--self.layer:addChild(bottle2)
	--self.layer:addChild(bottle3)
	--self.layer:addChild(bottle4)
end


function AnimationScene:testAnimation()


	local winSize = CCDirector:sharedDirector():getWinSize()

	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("flash/animation/elephant/boss_elephant_use.plist")
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("flash/animation/water_splash.plist")

	print("added!!!!!!!!!!!!!!!!")
	local boss = Sprite:createWithSpriteFrameName("boss_elephant_use_0000.png")
	boss:setScale(0.1)
	boss:setPosition(ccp(winSize.width/2, winSize.height /2 - boss:getContentSize().height/2))
	self.layer:addChild(boss)

	local function playCloudAnimation()
		local cloud = Sprite:createWithSpriteFrameName("boss_elephant_cloud_0000.png")
		cloud:setScale(10/7)
		cloud:setPositionXY(boss:getPositionX(), boss:getPositionY())
		self.layer:addChild(cloud)

		local cloud_frames = SpriteUtil:buildFrames("boss_elephant_cloud_%04d.png", 0, 13)
		local cloud_animate = SpriteUtil:buildAnimate(cloud_frames, 1/30)
		cloud:play(cloud_animate, 0, 1, nil, true)
	end

	-- local juice = Sprite:createWithSpriteFrameName("juice.png")
	-- juice:setScale(10/7)
	-- juice:setPosition(ccp(winSize.width/2-5, juice:getContentSize().height + 10))
	-- self.layer:addChild(juice)

	local function createWaterSplash()
			local water_splash = Sprite:createWithSpriteFrameName("water_splash_0000.png")
			water_splash:setScale(3.2)
			water_splash:setPosition(ccp(winSize.width/2, (winSize.height) /2))
			self.layer:addChild(water_splash)

			local water_frames = SpriteUtil:buildFrames("water_splash_%04d.png", 0, 7)
			local water_animate = SpriteUtil:buildAnimate(water_frames, 1/30)
			water_splash:play(water_animate, 0, 1, function() 
					water_splash:removeFromParentAndCleanup(true)
				end)
	end

	local function playWaterAnimation()
		local water = Sprite:createWithSpriteFrameName("waterSplash.png")
		water:setPosition(ccp(winSize.width/2, winSize.height/2))
		water:setScale(0.1 * 1.25)
		self.layer:addChild(water)

		local scale = CCScaleTo:create(3/30, 1.25, 1.25)
		local complete = CCCallFunc:create(function()
				createWaterSplash()

				water:setScale(2*1.25)
				water:runAction(CCCallFunc:create(
					function()
						water:setScale(1.6 * 1.25)
						water:runAction(CCSequence:createWithTwoActions(
							CCFadeOut:create(12/30),
							CCCallFunc:create(function() water:removeFromParentAndCleanup(true) end)
						))
					end
					))
			end)

		water:runAction(CCSequence:createWithTwoActions(scale, complete))
	end

	local function animateComplete()
		--boss:removeFromParentAndCleanup(true)
	end

	local delay = CCDelayTime:create(60/30)
	boss:setAnchorPoint(ccp(0.5, 0.1))
	
	local actions = CCArray:create()
	actions:addObject(CCScaleTo:create(5/30, 10/6, 10/6))
	actions:addObject(	
		CCCallFunc:create(
			function()
				local frames = SpriteUtil:buildFrames("boss_elephant_use_%04d.png", 0, 76)
				local animate = SpriteUtil:buildAnimate(frames, 1/30)
				boss:play(animate, 0, 1, animateComplete, true)
			end
		))
	actions:addObject(delay)
	actions:addObject(CCCallFunc:create(function() playWaterAnimation() end ))
	boss:runAction(CCSequence:create(actions))
	playCloudAnimation()

	self.layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(78/30), CCCallFunc:create(
			function()
				playCloudAnimation()
			end
		)))

	--playWaterAnimation()

	-- local action_delay = CCDelayTime:create(10/30)
	-- local height = boss:getPositionY() - juice:getPositionY() - juice:getContentSize().height - 37
	-- local action_move = CCMoveBy:create(7/30, ccp(0, height))

	-- local callbackAction = CCCallFunc:create(function() 
	-- 		juice:removeFromParentAndCleanup(true)
	-- end)

	-- local arrAction = CCArray:create()
	-- arrAction:addObject(action_delay)
	-- arrAction:addObject(action_move)
	-- arrAction:addObject(callbackAction)

	--juice:runAction(CCSequence:create(arrAction))
end

function AnimationScene:testShaderSprite9()
	local winSize = CCDirector:sharedDirector():getWinSize()
	local origin = CCDirector:sharedDirector():getVisibleOrigin()

	local sp = CocosObject.new(HEScale9Sprite:createWithSpriteFrameName("ui_scale9/ui_button_green_scale90000", CCRectMake(0,0,0,0))) 
	sp:setPosition(ccp(winSize.width/2, origin.y + winSize.height - sp:getContentSize().height - 150))
	self.layer:addChild(sp)

	local h, s, v = 80, 1, 1
	sp.refCocosObj:setHsv(h, s, v)
	sp.refCocosObj:applyAdjustColorShader()
	
end

function AnimationScene:testGroup()
	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(800, 1100)
	colorLayer:setColor(ccc3(255, 255, 255))
	colorLayer:setPosition(ccp(0, 0))
	self.layer:addChild(colorLayer)

	local winSize = CCDirector:sharedDirector():getWinSize()
	local origin = CCDirector:sharedDirector():getVisibleOrigin()
	local builder = InterfaceBuilder:createWithContentsOfFile("ui/common_ui.json")
	
	local function buildButton( x, y )
		local ui_button_label = builder:buildGroup("ui_buttons/ui_button_label")
		ui_button_label:setPosition(ccp(x, y))
		self.layer:addChild(ui_button_label)

		return GroupButtonBase:create(ui_button_label)
	end
	local button1 = buildButton(100, winSize.height/2)
	button1:setString(Localization:getInstance():getText("button.ok"))
	
	local button2 = buildButton(360, winSize.height/2)
	button2:setString(Localization:getInstance():getText("button.ok"))
	button2:setColorMode(kGroupButtonColorMode.blue)

	local button3 = buildButton(620, winSize.height/2)
	button3:setString(Localization:getInstance():getText("button.ok"))
	button3:setColorMode(kGroupButtonColorMode.orange)

	local button1 = buildButton(100, winSize.height/2 + 100)
	button1:setString(Localization:getInstance():getText("button.cancel"))
	button1:setScale(0.6)
	
	local button2 = buildButton(260, winSize.height/2 + 100)
	button2:setString(Localization:getInstance():getText("button.cancel"))
	button2:setColorMode(kGroupButtonColorMode.blue)
	button2:setScale(0.6)

	local enabledButton1
	local function onTouchButton3_0( evt )
		if enabledButton1 then enabledButton1:setEnabled(true) end
		print(table.tostring(evt))
	end
	local function onTouchButton4_0( evt )
		if enabledButton1 then enabledButton1:setEnabled(false) end
		print(table.tostring(evt))
	end

	local button3 = buildButton(420, winSize.height/2 + 100)
	button3:setString(Localization:getInstance():getText("button.cancel"))
	button3:setColorMode(kGroupButtonColorMode.orange)
	button3:setScale(0.6)
	button3:addEventListener(DisplayEvents.kTouchTap, onTouchButton3_0)
	
	local button4 = buildButton(580, winSize.height/2 + 100)
	button4:setString(Localization:getInstance():getText("button.cancel"))
	button4:setColorMode(kGroupButtonColorMode.orange)
	button4:setScale(0.6)
	button4:setEnabled(false)
	button4:addEventListener(DisplayEvents.kTouchTap, onTouchButton4_0)
	enabledButton1 = button4

	local function buildIconButton( x, y )
		local ui_button_label = builder:buildGroup("ui_buttons/ui_button_right_icon")
		ui_button_label:setPosition(ccp(x, y))
		self.layer:addChild(ui_button_label)

		local button = ButtonIconsetBase:create(ui_button_label)
		button:setString(Localization:getInstance():getText("button.ok"))
		button:setIconByFrameName("ui_images/ui_image_coin_icon_small0000", false)
		return button
	end

	local enabledButton2
	local function onTouchButton3_1( evt )
		if enabledButton2 then enabledButton2:setEnabled(true) end
		print(table.tostring(evt))
	end
	local function onTouchButton4_1( evt )
		if enabledButton2 then enabledButton2:setEnabled(false) end
		print(table.tostring(evt))
	end

	local button1 = buildIconButton(100, winSize.height/2 + 200)

	local button2 = buildIconButton(320, winSize.height/2 + 200)
	button2:setColorMode(kGroupButtonColorMode.blue)
	button2:setScale(0.6)

	local button3 = buildIconButton(480, winSize.height/2 + 200)
	button3:setColorMode(kGroupButtonColorMode.orange)
	button3:setScale(0.6)
	button3:addEventListener(DisplayEvents.kTouchTap, onTouchButton3_1)

	local button4 = buildIconButton(640, winSize.height/2 + 200)
	button4:setColorMode(kGroupButtonColorMode.orange)
	button4:setScale(0.6)
	button4:setEnabled(false)
	button4:addEventListener(DisplayEvents.kTouchTap, onTouchButton4_1)
	enabledButton2 = button4

	local function buildIconButtonLeft( x, y )
		local ui_button_label = builder:buildGroup("ui_buttons/ui_button_left_icon")
		ui_button_label:setPosition(ccp(x, y))
		self.layer:addChild(ui_button_label)

		local button = ButtonIconsetBase:create(ui_button_label)
		button:setString(Localization:getInstance():getText("button.cancel"))
		button:setIconByFrameName("ui_images/ui_image_coin_icon_small0000", false)
		return button
	end
	local button1 = buildIconButtonLeft(100, winSize.height/2 + 300)

	local button2 = buildIconButtonLeft(320, winSize.height/2 + 300)
	button2:setColorMode(kGroupButtonColorMode.blue)
	button2:setScale(0.6)

	local button3 = buildIconButtonLeft(480, winSize.height/2 + 300)
	button3:setColorMode(kGroupButtonColorMode.orange)
	button3:setScale(0.6)

	local button4 = buildIconButtonLeft(640, winSize.height/2 + 300)
	button4:setColorMode(kGroupButtonColorMode.orange)
	button4:setScale(0.6)
	button4:setEnabled(false)

	local function buildButtonIconNumberBase( x, y )
		local ui_button_label = builder:buildGroup("ui_buttons/ui_coin_button")
		ui_button_label:setPosition(ccp(x, y))
		self.layer:addChild(ui_button_label)

		local label = Localization:getInstance():getText("button.ok")..Localization:getInstance():getText("button.cancel")
		local button = ButtonIconNumberBase:create(ui_button_label)
		button:setString(label)
		button:setIconByFrameName("ui_images/ui_image_coin_icon_small0000", false)
		button:setNumber(10)
		return button
	end
	
	local enabledButton3
	local function onTouchButton3_2( evt )
		if enabledButton3 then enabledButton3:setEnabled(true) end
		print(table.tostring(evt))
	end
	local function onTouchButton4_2( evt )
		if enabledButton3 then enabledButton3:setEnabled(false) end
		print(table.tostring(evt))
	end
	local button1 = buildButtonIconNumberBase(200, winSize.height/2 + 400)

	local button3 = buildButtonIconNumberBase(480, winSize.height/2 + 400)
	button3:setColorMode(kGroupButtonColorMode.blue)
	button3:setScale(0.4)
	button3:addEventListener(DisplayEvents.kTouchTap, onTouchButton3_2)

	local button4 = buildButtonIconNumberBase(640, winSize.height/2 + 400)
	button4:setColorMode(kGroupButtonColorMode.orange)
	button4:setScale(0.4)
	button4:setEnabled(false)
	button4:addEventListener(DisplayEvents.kTouchTap, onTouchButton4_2)
	enabledButton3 = button4

	local startGame1 = ButtonStartGame:create()
	startGame1:setPosition(ccp(winSize.width/2, 200))
	startGame1:setString(Localization:getInstance():getText("button.cancel"))
	startGame1:setNumber(8)
	self.layer:addChild(startGame1:getContainer())

	local startGame2 = ButtonStartGame:create()
	startGame2:setPosition(ccp(winSize.width/2, 360))
	startGame2:setString(Localization:getInstance():getText("button.cancel"))
	startGame2:setNumber(8)
	startGame2:enableInfiniteEnergy(true)
	self.layer:addChild(startGame2:getContainer())

	local ui_button_label = builder:buildGroup("ui_buttons/ui_number_button")
	ui_button_label:setPosition(ccp(winSize.width/2, 500))
	self.layer:addChild(ui_button_label)
	local numberButton = ButtonNumberBase:create(ui_button_label)
	numberButton:setString(Localization:getInstance():getText("button.cancel"))
	numberButton:setNumber(Localization:getInstance():getText("button.ok").."8")
end

function AnimationScene:createHsvSlider(min, max, def, prefix, callback, index)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local origin = CCDirector:sharedDirector():getVisibleOrigin()

	local positionY = origin.y + 300 + 120 * index
	local textLabel = TextField:create(label, nil, 32)
	textLabel:setPosition(ccp(winSize.width/2, positionY - 40))
	textLabel:setAnchorPoint(ccp(0.5,0.5))
	textLabel:setString(prefix..def)
	self.layer:addChild(textLabel)

	local slider = ControlSlider:create()
	local function onControlEventValueChanged( evt )
		local val = slider:getValue()
		if callback ~= nil then callback(val) end
		textLabel:setString(prefix..tostring(val))
	end
	
	slider:addEventListener("ControlEventValueChanged", onControlEventValueChanged)
	slider:setPosition(ccp(winSize.width/2, positionY))
	slider:setValue(def)
	slider:setAnchorPoint(ccp(0.5, 0.5))
	slider:setMinimumValue(min)
	slider:setMaximumValue(max)
	self.layer:addChild(slider)
end

function AnimationScene:testShader()
	local winSize = CCDirector:sharedDirector():getWinSize()
	local origin = CCDirector:sharedDirector():getVisibleOrigin()

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(800, 400)
	colorLayer:setColor(ccc3(255, 255, 255))
	colorLayer:setPosition(ccp(0, 800))
	self.layer:addChild(colorLayer)

	self.builder = InterfaceBuilder:createWithContentsOfFile(PanelConfigFiles.panel_register)

	--local sp = CocosObject.new(HESpriteColorAdjust:createWithSpriteFrameName("ui_scale9/ui_button_green_scale90000"))
	local sp = CocosObject.new(HESpriteColorAdjust:createWithSpriteFrameName("phone/ButtonBg0000")) 
	sp:setPosition(ccp(winSize.width/2, origin.y + winSize.height - sp:getContentSize().height - 150))
	self.layer:addChild(sp)

	local useHSV = false
	local h, s, v = 0, 1, 1
	local function updateHue( val )
		h = tonumber(val)
		if useHSV then sp.refCocosObj:setHsv(h, s, v)
		else sp.refCocosObj:adjustHue(h) end
	end
	local function updateSaturation( val )
		s = tonumber(val)
		if useHSV then sp.refCocosObj:setHsv(h, s, v) 
		else sp.refCocosObj:adjustSaturation(s) end
	end
	local function updateBrightness( val )
		v = tonumber(val)
		if useHSV then sp.refCocosObj:setHsv(h, s, v)
		else sp.refCocosObj:adjustBrightness(v) end
	end
	local function updateContrast( val )
		v = tonumber(val)
		if useHSV then print("not support")
		else sp.refCocosObj:adjustContrast(v) end
	end

	if useHSV then
		sp.refCocosObj:setHsv(h, s, v)
		self:createHsvSlider(0, 360, 0, "H:", updateHue, 0)
		self:createHsvSlider(0, 2, 1, "S:", updateSaturation, 1)
		self:createHsvSlider(0, 2, 1, "V:", updateBrightness, 2)
	else
		self:createHsvSlider(-1, 1, 0, "Hue:", updateHue, 0)
		self:createHsvSlider(-1, 1, 0, "Saturation:", updateSaturation, 1)
		self:createHsvSlider(-1, 1, 0, "Brightness:", updateBrightness, 2)
		self:createHsvSlider(-1, 1, 0, "Contrast:", updateContrast, 3)
	end

	local button = ControlButton:create("Use", nil, 42)
  	button.name = "use shader"
  	button:setPosition(ccp(winSize.width/2, origin.y + 50))
  	local isUseShader = false
  	local function onButtonEvent( evt )
  		if isUseShader then
  			isUseShader = false
  			sp.refCocosObj:clearAdjustColorShader()
  		else
  			isUseShader = true
  			sp.refCocosObj:applyAdjustColorShader()
  		end
    end
 	button:ad(kControlEvent.kControlEventTouchUpInside, onButtonEvent)
 	self.layer:addChild(button)
end

function AnimationScene:testScale9Sprite()
	print("testScale9Sprite")
	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(100, 100)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setPosition(ccp(0, 0))
	self.layer:addChild(colorLayer)

	local root = Layer:create()
	root:setPosition(ccp(0, 100))
	root:setScale(0.5)
	self.layer:addChild(root)
	local function testClipp( x, y )
		local colorLayer = LayerColor:create()
		colorLayer:changeWidthAndHeight(100, 100)
		colorLayer:setColor(ccc3(255, 0, 0))
		colorLayer:setOpacity(30)
		colorLayer:setPosition(ccp(x, y))
		root:addChild(colorLayer)

		local clip = SimpleClippingNode:create()
		clip:setContentSize(CCSizeMake(70, 70))
		clip:setPosition(ccp(x,y))
		root:addChild(clip)

		local sp = Sprite:create("materials/game_bg.png")
		sp:setAnchorPoint(ccp(0,0))
		clip:addChild(sp)

		local sp = Sprite:create("materials/head_images.png")
		sp:setAnchorPoint(ccp(0,0))
		sp:setScale(0.5)
		sp:setRotation(45)
		sp:setPosition(ccp(50,20))
		sp:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 100)))

		local ls = Layer:create()
		ls:addChild(sp)
		clip:addChild(ls)
	end
	testClipp(0,300)
	testClipp(100,300)
	testClipp(200,300)
	testClipp(300,300)
	testClipp(400,300)
	testClipp(500,300)
end
function AnimationScene:testScale9Sprite2()
	print("testScale9Sprite2")
	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 200)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setPosition(ccp(400, 200))
	self.layer:addChild(colorLayer)

	local clip = ClippingNode:create(CCRectMake(0,0,40,40))
	--clip:setContentSize(CCSizeMake(100, 100))
	clip:setPosition(ccp(400,200))
	self.layer:addChild(clip)

	local sp = Sprite:create("materials/game_bg.png")
	sp:setAnchorPoint(ccp(0,0))
	clip:addChild(sp)

	local sp = Sprite:create("materials/head_images.png")
	sp:setAnchorPoint(ccp(0,0))
	sp:setScale(0.5)
	sp:setRotation(45)
	sp:setPosition(ccp(50,20))
	sp:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 100)))

	local ls = Layer:create()
	ls:addChild(sp)
	clip:addChild(ls)
end

function AnimationScene:testScale9Sprite_()
	
	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 200)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setPosition(ccp(0, 0))
	self.layer:addChild(colorLayer)

	local profile = UserManager.getInstance().profile

	local spriteA = HeadImageLoader:create(profile.uid, profile.headUrl)
	spriteA:setPosition(ccp(200,200))
	self.layer:addChild(spriteA)
end

function AnimationScene:testChoosePanel()
	local function onTouchTap( evt )
		

		local panel = ExceptionPanel:create() --ChooseFriendPanel:create() --DynamicUpdatePanel:create()
		panel:popout()
		--local panel = RequestMessagePanel:create()--RequestMessagePanel:create()--ChooseFriendPanel:create()
		--panel:popout()

		--Director:sharedDirector():pushScene(MessageCenterScene:create())
	end

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 100)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:setPosition(ccp(0, 400))
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
	self.layer:addChild(colorLayer)
end

function AnimationScene:createLineStar(width, height)
	local textureSprite = Sprite:createWithSpriteFrameName("win_star_shine0000")
	local container = SpriteBatchNode:createWithTexture(textureSprite:getTexture())
	for i = 1, 15 do
		local sprite = Sprite:createWithSpriteFrameName("win_star_shine0000")
		sprite:setPosition(ccp(width*math.random(), height*math.random()))
		sprite:setOpacity(0)
		sprite:setScale(0)
		sprite:runAction(CCRepeatForever:create(CCRotateBy:create(0.1 + math.random()*0.3, 150)))
		local scaleTo = 0.3 + math.random() * 0.8
		local fadeInTime, fadeOutTime = 0.4, 0.4
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(math.random()*0.5))
		array:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(fadeInTime), CCScaleTo:create(fadeInTime, scaleTo)))
		array:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(fadeOutTime), CCScaleTo:create(fadeOutTime, 0)))
		sprite:runAction(CCSequence:create(array))
		container:addChild(sprite)
	end
	local function onAnimationFinished() container:removeFromParentAndCleanup(true) end
	container:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.3), CCCallFunc:create(onAnimationFinished)))
	textureSprite:dispose()
	return container
end

function AnimationScene:testSharePanel( )
	-- local panel = SharePanel:create(10)
	-- self.layer:addChild(panel)
end
function AnimationScene:testMaxEnergyAnimation( )
	--local animation = CommonSkeletonAnimation:createFailAnimation()--MaxEnergyAnimation:create()
	--MaxEnergyAnimation:create()
	local animation = CommonSkeletonAnimation:creatTutorialAnimation(10001)
	animation:playAnimation()
	animation:stopAnimation()
	--animation:setPosition(ccp(200, 500))
	animation:setPosition(ccp(350,500))
	self.layer:addChild(animation)

	local flag = 1
	local function onTouchTap( evt )
		--SyncAnimation:getInstance():show()
		if flag == 1 then
			animation:playAnimation()
			flag = 0
		else
			animation:stopAnimation()
			flag = 1
		end
	end

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 100)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:setPosition(ccp(0, 400))
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
	self.layer:addChild(colorLayer)

end
function AnimationScene:testLadyBugTask()
	local container = Layer:create()
	self.layer:addChild(container)
	local function onTouchTap( evt )
		container:removeChildren()
		local icon = LadybugTaskAnimation:create(true)
		container:addChild(icon)
		icon:setPosition(ccp(200, 500))
		icon:flyIn()
	end

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 100)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:setPosition(ccp(0, 400))
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
	self.layer:addChild(colorLayer)
end
function AnimationScene:testBird( )

	
	local layer = self.layer

	local function createBirdEffect()
		local bird = TileBird:create()

		local function onAnimationFinish()
			bird:stop2BirdDestroyAnimation()
		end
		bird:setPosition(ccp(200,290))
		bird:play2BirdDestroyAnimation({ccp(200, 400), ccp(300, 700), ccp(480, 800)})
		--bird:stop2BirdDestroyAnimation()
		bird:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2), CCCallFunc:create(onAnimationFinish)))
		layer:addChild(bird)
	end
	local function onTouchTap( evt )
		--createBirdEffect()
		local winSize = CCDirector:sharedDirector():getWinSize()
		local panel = CommonEffect:buildRequireSwipePanel()
		panel:setPosition(ccp(winSize.width/2, winSize.height/2))
		layer:addChild(panel)
	end

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 100)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:setPosition(ccp(0, 400))
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
	self.layer:addChild(colorLayer)
end

function AnimationScene:testArmature()
	local winSize = CCDirector:sharedDirector():getWinSize()
  	
  	local function onAnimationFinish( )
  		print("onAnimationFinish")
  	end 
  	
  	local function onTouchTap( evt )
		local animation = self:createLineStar(200, 40) --CommonSkeletonAnimation:createTutorialMoveIn()--CommonSkeletonAnimation:createTutorialNormal() --AddEnergyAnimation:create()
		--animation:setPosition(ccp(250, 400))
		animation:setPosition(ccp(winSize.width/2, 400))
		self.layer:addChild(animation)
	end

	

  	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(winSize.width/2, 400)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:setPosition(ccp(0, 0))
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
	self.layer:addChild(colorLayer)
end

function AnimationScene:testLoadFriends()
	local number = 1
	local function onItemLoad(userId, imageURL)
		print(userId, imageURL)
		local sprite = Sprite:create(imageURL)
		sprite:setPosition(ccp(300, number * 300))
		sprite:setAnchorPoint(ccp(0,0))
		self.layer:addChild(sprite)
		number = number + 1
	end
	local loader = HeadImageLoader.new()
	loader.itemLoadCompleteCallback = onItemLoad
	loader:add(101, "http://www.bhcode.net/png/images/png-1558.png")
	loader:add(102, "http://www.baidu.com/img/shouye_b5486898c692066bd2cbaeda86d74448.gif") -- gif image will ignored.
	loader:add(103, "http://hdn.xnimg.cn/photos/hdn421/20100828/1650/h_tiny_RilU_19750000138a2f74.jpg") --not exist.
	loader:add(104, "http://himg.bdimg.com/sys/portrait/item/aecfe4b8bbe68c81e78ebae892995f37.jpg")
	loader:load()
end

function AnimationScene:testPrefixAnimation()
	local animation

	local function flyFinishedCallback()
		print("TODO: change move on UI!")
	end
	local function onAnimationFinish()
		print("onAnimationFinish")
	end 
		
	local index = 0
	local function onTouchTap( evt )
		if index == 0 then
			local icon = PropListAnimation:createIcon( 10018 )
			animation = PrefixPropAnimation:createAddMoveAnimation(icon, 0, flyFinishedCallback, onAnimationFinish)
			self.layer:addChild(animation)
		elseif index == 1 then
			local icon = PropListAnimation:createIcon( 10007 )
			local positionA = ccp(100, 200)
			local positionB = ccp(500, 300)
			animation = PrefixPropAnimation:createChangePropAnimation(icon, 0, positionA, positionB, flyFinishedCallback, onAnimationFinish)
			self.layer:addChild(animation)
		end
		
		index = index + 1
		if index > 1 then index = 0 end
	end

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 200)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:setPosition(ccp(0, 0))
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
	self.layer:addChild(colorLayer)
end

function AnimationScene:testPropsList()
	local index = 1
	local items = {
		{
			{itemId=10001, itemNum=1, temporary=0},
			{itemId=10005, itemNum=1, temporary=0},
			{itemId=10010, itemNum=3, temporary=0},
			{itemId=10003, itemNum=22, temporary=0},
			{itemId=10004, itemNum=1, temporary=0},
			{itemId=10002, itemNum=10, temporary=0},
			--{itemId=10007, itemNum=0, temporary=0}
		},
		{
			{itemId=10001, itemNum=22, temporary=0},
			{itemId=10004, itemNum=22, temporary=2},
			{itemId=10005, itemNum=101, temporary=0}
		},
		{
			{itemId=10001, itemNum=22, temporary=0},
			{itemId=10005, itemNum=101, temporary=0}
		},
		{
			{itemId=10001, itemNum=1, temporary=0},
			{itemId=10004, itemNum=1, temporary=1},
			{itemId=10031, itemNum=2, temporary=0},
			{itemId=10032, itemNum=1, temporary=0},
			{itemId=10033, itemNum=2, temporary=0},
			{itemId=10005, itemNum=2, temporary=0},
			{itemId=10010, itemNum=3, temporary=0},
			{itemId=10003, itemNum=22, temporary=0},
			{itemId=10002, itemNum=10, temporary=0},
			{itemId=10007, itemNum=0, temporary=0}
		},
		{
			{itemId=10001, itemNum=1, temporary=0},
			{itemId=10004, itemNum=1, temporary=0},
			{itemId=10031, itemNum=2, temporary=0},
			{itemId=10032, itemNum=1, temporary=0},
			{itemId=10033, itemNum=2, temporary=0},
			{itemId=10005, itemNum=2, temporary=0},
			{itemId=10010, itemNum=3, temporary=0},
			{itemId=10003, itemNum=22, temporary=0},
			{itemId=10002, itemNum=10, temporary=0},
			{itemId=10007, itemNum=0, temporary=0}
		}
	}
	local listView = PropListAnimation:create()
	local function onTouchTap( evt )	
		listView:show(items[index])	
		index = index + 1
		if index > #items then index = 1 end
	end
	local function onDownTouch( evt )
		listView:showAddStepItem()
		listView:addTemporaryItem(10015, 1, ccp(math.random()*500, math.random()*700 + 200))
	end 

	local function onConfirmTouch( evt )
		listView:confirm()
	end 

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 200)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:setPosition(ccp(0, 402))
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
	self.layer:addChild(colorLayer)

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 200)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:setPosition(ccp(0, 200))
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onDownTouch)
	self.layer:addChild(colorLayer)

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 200)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:setPosition(ccp(0, 600))
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onConfirmTouch)
	self.layer:addChild(colorLayer)

	self.layer:addChild(listView.layer)	

	
end

function AnimationScene:testLevelTarget( )
	local index = 1
	local testTargets = { {{type="move", id=0, num=12345}},  
						  {{type="time", id=0, num=12345}},  
						  --{{type="drop", id=0, num=30}}, 
						  {{type="order1", id=1, num=30}, {type="order1", id=2, num=30},{type="order1", id=3, num=30},{type="order1", id=4, num=30}},
						  --{{type="order2", id=1, num=30}, {type="order2", id=2, num=30},{type="order2", id=3, num=30}},
						  --{{type="order3", id=1, num=30}, {type="order3", id=2, num=30},{type="order3", id=3, num=30}},
						  --{{type="order3", id=1, num=30}, {type="order4", id=2, num=30}},
						  {{type="order4", id=1, num=30}},
						  {{type="ice", id=1, num=30}}
						}
	local positionX = 200
	local leveltarget = LevelTargetAnimation:create(positionX)
	local debugLayer = Layer:create()
	local function onTimeModeStart()
		print("Time Mode Game Start")
	end 
	local function createDebugRect( position )
		local rect = LayerColor:create()
		rect:changeWidthAndHeight(100, 100)
		rect:setColor(ccc3(255, 0, 250))
		rect:setOpacity(100)
		rect:setPosition(ccp(position.x, position.y))
		print("createDebugRect", position.x,"/" , position.y)
		debugLayer:addChild(rect)
	end
	local function onTouchTap( evt )		
		print("onTouchTap", evt and evt.name or "nil")
		leveltarget:setTargets(testTargets[index], onTimeModeStart)
		debugLayer:removeChildren()
		local item = leveltarget:getLevelTileByIndex(1)
		local size = item:getGroupBounds().size
		local position = item:getPosition()
		local position = item:getParent():convertToWorldSpace(ccp(position.x, position.y-size.height))
		createDebugRect(position)

		index = index + 1
		if index > #testTargets then index = 1 end
	end
	self.layer:addChild(leveltarget.layer)	
	self.layer:addChild(debugLayer)

	onTouchTap(nil)

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 800)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
	self.layer:addChild(colorLayer)

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 200)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	self.layer:addChild(colorLayer)

	
end
function AnimationScene:testPath()
	

	local ladybug = nil
	local function onTouchTap( evt )
		ladybug:reset()
		ladybug:moveTo(0)
		ladybug:animateTo(1, 2)

		ladybug:addScoreStar(evt.globalPosition)
--[[
		local star = LadybugAnimation:createFinishStarAnimation(evt.globalPosition)
		self.layer:addChild(star)

		local explode = LadybugAnimation:createFinsihExplodeStar(ccp(evt.globalPosition.x + 100, evt.globalPosition.y))
		self.layer:addChild(explode)

		local overlay = LadybugAnimation:createFinsihShineStar(ccp(evt.globalPosition.x + 300, evt.globalPosition.y))
		self.layer:addChild(overlay)
		]]
	end
	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 800)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
	self.layer:addChild(colorLayer)

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 200)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	self.layer:addChild(colorLayer)

	ladybug = LadybugAnimation:create()
	ladybug:setPosition(ccp(100,800))
	ladybug:setStarsPosition(0, 0.5, 1)
	self.layer:addChild(ladybug.layer)	
end

function AnimationScene:testBranch( )
	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 800)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	self.layer:addChild(colorLayer)

	local branch = nil

	local function onTouchTap( evt )
		if branch then
			branch:removeFromParentAndCleanup(true)
		end
		branch = HiddenBranchAnimation:create()
		branch:setPosition(ccp(200, 800))
		self.layer:addChild(branch)

		print("onTouchTap", evt)
	end
	
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
end
function AnimationScene:testQuaiticBackOut( )
	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(100, 100)
	colorLayer:setColor(ccc3(255, 250, 0))
	colorLayer:setOpacity(90)
	colorLayer:setPosition(ccp(100, 500))
	self.layer:addChild(colorLayer)

	local moveIn = CCEaseQuarticBackOut:create(CCMoveBy:create(1, ccp(300, 0)), 3, -7.4475, 10.095, -10.195, 5.5475)
	local moveOut = CCEaseQuarticBackOut:create(CCMoveBy:create(1, ccp(-300, 0)),3, -7.4475, 10.095, -10.195, 5.5475)
	
	colorLayer:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(moveIn, moveOut)))
end

function AnimationScene:testClouds()
	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 600)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	self.layer:addChild(colorLayer)

	local winSize = CCDirector:sharedDirector():getWinSize()

	local lock = Clouds:buildLock()

	local wait = Clouds:buildWait()
	wait:setPosition(ccp(winSize.width/2, 600))
	wait:addChild(lock)
	self.layer:addChild(wait)

	local isFadeOut = false
	local function onTouchTap( evt )
		local target = evt.target
		if isFadeOut then
			isFadeOut = false
			target:wait()
			lock:wait()
		else 
			isFadeOut = true
			target:fadeOut() 
			lock:fadeOut()
		end
	end

	wait:addEventListener(DisplayEvents.kTouchTap, onTouchTap)

end
function AnimationScene:testFlowers()
	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 400)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	self.layer:addChild(colorLayer)

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 200)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	self.layer:addChild(colorLayer)

	local function onGlowAnimationFinsih( evt )
		print("onGlowAnimationFinsih")
	end 

	local open = nil
	local function onOpenAnimationFinish( evt )
		if open then
			open:removeAllEventListeners()
			open:removeFromParentAndCleanup(true)
		end
		open = nil
	end
	local function onTouchTap( evt )
		local target = evt.target
		target:bloom()

		if open then
			open:removeAllEventListeners()
			open:removeFromParentAndCleanup(true)
		end

		open = Flowers:buildOpenEffect(math.random() > 0.5)
		open:setPosition(ccp(500, 400))
		open:addEventListener(Events.kComplete, onOpenAnimationFinish)
		self.layer:addChild(open)
	end 

	for i=0,4 do
		local glow = Flowers:buildGlowEffect(kFlowers["flowerStar"..i])
		glow:setPosition(ccp(200 + 80*i, 200))
		glow:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
		glow:addEventListener(Events.kComplete, onGlowAnimationFinsih)
		self.layer:addChild(glow)
		if i > 0 then
			local glow = Flowers:buildGlowEffect(kFlowers["hiddenFlower"..i])
			glow:setPosition(ccp(200 + 80*i, 280))
			glow:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
			glow:addEventListener(Events.kComplete, onGlowAnimationFinsih)
			self.layer:addChild(glow)
		end
	end
	
end

function AnimationScene:testCommonEffect()
	local layer = self.layer

	local function onTouchTap( evt )
	    --local effect = CommonEffect:buildBonusEffect()
		--effect:setPosition(ccp(0, 200))
		--layer:addChild(CommonEffect:buildSpecialEffectTitle())
		layer:addChild(CommonEffect:buildBonusEffect())
	end

	local colorLayer = LayerColor:create()
	colorLayer:changeWidthAndHeight(200, 100)
	colorLayer:setColor(ccc3(255, 0, 0))
	colorLayer:setOpacity(30)
	colorLayer:setTouchEnabled(true)
	colorLayer:setPosition(ccp(0, 400))
	colorLayer:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
	self.layer:addChild(colorLayer)
end

function AnimationScene:testFrosting()
	local layer = self.layer
	for i=1,3 do
		local item = LinkedItemAnimation:buildFrosting(i, true)
		item:setPosition(ccp(80*i, 120))
		layer:addChild(item)
	end

	for i=4,6 do
		local item = LinkedItemAnimation:buildFrosting(i, true)
		item:setPosition(ccp(80*(i-3), 210))
		layer:addChild(item)
	end
	
	for i=7,8 do
		local item = LinkedItemAnimation:buildFrosting(i, true)
		item:setPosition(ccp(80*(i-6), 300))
		layer:addChild(item)
	end

	local crystal = LinkedItemAnimation:buildCrystal(1)
	crystal:setPosition(ccp(80, 380))
	layer:addChild(crystal)

	local crystal = LinkedItemAnimation:buildCrystal(2, true)
	crystal:setPosition(ccp(170, 380))
	layer:addChild(crystal)

	local crystal = LinkedItemAnimation:buildCrystal(3, true, true)
	crystal:setPosition(ccp(260, 380))
	layer:addChild(crystal)

	local gift = LinkedItemAnimation:buildGift(1)
	gift:setPosition(ccp(80, 25))
	layer:addChild(gift)

	local gift = LinkedItemAnimation:buildGift(2, true)
	gift:setPosition(ccp(170, 25))
	layer:addChild(gift)

	local gift = LinkedItemAnimation:buildGift(3, true, true)
	gift:setPosition(ccp(260, 25))
	layer:addChild(gift)
end

function AnimationScene:testGameProps()
	local layer = self.layer
	local function onAnimationFinish(evt)
		local target = evt.target
	  	if target then 
	  		target:rma() 
	  		target:removeFromParentAndCleanup()
	  	end
  		print("on GamePropsAnimation finish")
	end 

	local hammer = GamePropsAnimation:buildHammer()
	hammer:setPosition(ccp(100, 200))
	layer:addChild(hammer)
	hammer:ad(Events.kComplete, onAnimationFinish)

	local magic = GamePropsAnimation:buildMagicWind()
	magic:setPosition(ccp(100, 350))
	layer:addChild(magic)
	magic:ad(Events.kComplete, onAnimationFinish)

	local enter = LinkedItemAnimation:buildPortalEnter()
	enter:setPosition(ccp(250, 200))
	layer:addChild(enter)

	local exit = LinkedItemAnimation:buildPortalExit()
	exit:setPosition(ccp(250, 250))
	layer:addChild(exit)

	local coinBomb = LinkedItemAnimation:buildCoinBomb()
	coinBomb:setPosition(ccp(250, 250))
	layer:addChild(coinBomb)

	local item = LinkedItemAnimation:buildWall(0)
	item:setPosition(ccp(50, 80))
	layer:addChild(item)

	item = LinkedItemAnimation:buildWall(1)
	item:setPosition(ccp(100, 80))
	layer:addChild(item)

	item = LinkedItemAnimation:buildCherry()
	item:setPosition(ccp(170, 80))
	layer:addChild(item)

	item = LinkedItemAnimation:buildRock()
	item:setPosition(ccp(250, 80))
	layer:addChild(item)

	item = LinkedItemAnimation:buildLocker()
	item:setPosition(ccp(50, 380))
	layer:addChild(item)

	item = LinkedItemAnimation:buildCoin()
	item:setPosition(ccp(50, 200))
	layer:addChild(item)
end

function AnimationScene:testCureBall(  )
	local layer = self.layer
  	layer:removeChildren()
	for i=1,3 do
		local sprite = TileCuteBall:create()
		self.layer:addChild(sprite)
		sprite:setPosition(ccp(70*i, 100))
		sprite:play(i)
	end
	for i=1,2 do
		local sprite = TileCuteBall:create()
		self.layer:addChild(sprite)
		sprite:setPosition(ccp(100*i, 300))
		sprite:play(i+3)
	end

	local sprite = TileCuteBall:create()
	self.layer:addChild(sprite)
	sprite:setPosition(ccp(240, 240))
	sprite:play(6)
end


function AnimationScene:testCharacters()
	self:buildCharacter("bear")

	local items = {"bear","fox", "horse", "frog", "cat", "chicken"}
	
	for i,v in ipairs(items) do
		local preloadSprite = TileCharacter:create(v)
	end

  	local button = ControlButton:create("next", nil, 42)
  	button.name = "next"
  	button:setPosition(ccp(200, 50))
  	local current = 1
  	local function onButtonEvent( evt )
    current = current + 1
    if current > #items then current = 1 end
  		self:buildCharacter(items[current])
  	end
 	button:ad(kControlEvent.kControlEventTouchUpInside, onButtonEvent)
 	self:addChild(button)
end

function AnimationScene:buildCharacter( characterName )
  local layer = self.layer
  layer:removeChildren()
  for i=2,5 do
  	  local sprite = TileCharacter:create(characterName)
	  layer:addChild(sprite)
	  sprite:setPosition(ccp(70*(i-1), 240))
	  sprite:play(i)
  end

  local sprite = TileCharacter:create(characterName)
  layer:addChild(sprite)
  sprite:setPosition(ccp(120, 320))
  sprite:play(kTileCharacterAnimation.kLineColumn)

  sprite = TileCharacter:create(characterName)
  layer:addChild(sprite)
  sprite:setPosition(ccp(50, 320))
  sprite:play(kTileCharacterAnimation.kLineRow)

  sprite = TileCharacter:create(characterName)
  layer:addChild(sprite)
  sprite:setPosition(ccp(190, 320))
  sprite:play(kTileCharacterAnimation.kWrap)

  sprite = TileCharacter:create(characterName)
  layer:addChild(sprite)
  sprite:setPosition(ccp(260, 320))
  sprite:play(kTileCharacterAnimation.kSelect)

  local function onTileCharacterDestroy( evt )
  	local target = evt.target
  	if target then target:rma() end
  	print("CharacterAnimationFinished")
  end

  sprite = TileCharacter:create(characterName)
  layer:addChild(sprite)
  sprite:setPosition(ccp(200, 400))
  sprite:play(kTileCharacterAnimation.kDestroy)
  sprite:ad(Events.kComplete, onTileCharacterDestroy)

  self:buildBird()
end

function AnimationScene:buildBird()
   local layer = self.layer

   local bird = TileBird:create()
   bird:setPosition(ccp(120, 120))
   bird:play(1)
   layer:addChild(bird)

   bird = TileBird:create()
   bird:setPosition(ccp(250, 120))
   bird:play(2)
   layer:addChild(bird)

   local function onTileBirdDestroy( evt )
  	local target = evt.target
  	if target then 
  		target:rma() 
  		target:removeFromParentAndCleanup()
  	end
  	print("BirdAnimationFinished")
  end
  bird = TileBird:create()
  bird:setPosition(ccp(200,290))
  bird:play(kTileBirdAnimation.kDestroy)
  bird:ad(Events.kComplete, onTileBirdDestroy)
  layer:addChild(bird)

  bird:buildAndRunDestroyAction(layer)
end
