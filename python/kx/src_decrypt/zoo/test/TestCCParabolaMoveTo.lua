


-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年11月 6日 17:46:14
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com


---------------------------------------------------
-------------- TestScene
---------------------------------------------------


require "hecore.display.Director"
require "hecore.display.TextField"

assert(not TestScene)
assert(Scene)
TestScene = class(Scene)

function TestScene:ctor()
end

function TestScene:init(...)
	assert(#{...} == 0)

	Scene.initScene(self)

	local stageSize = Director:sharedDirector():getVisibleSize()
	local bg = LayerColor:create()
	bg:setColor(ccc3(255, 255, 255))
	bg:changeWidthAndHeight(stageSize.width, stageSize.height)
	self:addChild(bg)

	local colorObj = LayerColor:create()
	colorObj:setColor(ccc3(255, 0, 0))
	colorObj:changeWidthAndHeight(10, 10)

	-- 720 * 1280
	colorObj:setPosition(ccp(0, 400))
	self:addChild(colorObj)
	--local parabolaMoveto = CCParabolaMoveTo:create(2.0, 0, 0, -400)
	--colorObj:runAction(parabolaMoveto)

	-- Test Label
	local startLabel = TextField:create("Start" , Helvetica, 40)
	local labelWrapper = Layer:create()
	labelWrapper:addChild(startLabel)

	labelWrapper:setPosition(ccp(100, 500))
	self:addChild(labelWrapper)
	labelWrapper:setTouchEnabled(true)

	local function onLabelTapped()

		colorObj:setPosition(ccp(0, 400))
		-- time = 1, moveToX = 400, moveToY = 0, acceleration of gravity = -4000
		local parabolaMoveto = CCParabolaMoveTo:create(1, 400, 0, -4000)
		
		-- Parabola Action Callback 
		local function parabolaCallback(newX, newY, vXInitial, vYInitial, vX, vY, duration, actionPercent)

			print("========================================")
			print("===== parabolaCallback Called ==========")
			print("========================================")

			print("newX: " .. newX)
			print("newY: " .. newY)
			print("vXInitial: " .. vXInitial)
			print("vYInitial: " .. vYInitial)
			print("vX: " .. vX)
			print("vY: " .. vY)
			print("duration: " .. duration)
			print("actionPercent: " .. actionPercent)
		end

		parabolaMoveto:registerScriptHandler(parabolaCallback)

		colorObj:runAction(parabolaMoveto)
	end

	local function testHeBezierTo()
		-- print(colorObj:getPosition().x, colorObj:getPosition().y)
		-- colorObj:setPosition(ccp(100, 700))
		-- local testAction = HeBezierTo:create(0.8, ccp(600, 700), true, 200)

		-- colorObj:runAction(CCEaseSineInOut:create(testAction))
		local stageSize = Director:sharedDirector():getVisibleSize()
		local crystalItem = Sprite:createWithSpriteFrameName("CrystalBall01.png")
		-- local texParams = ccTexParams()
		-- texParams.minFilter = GL_LINEAR
		-- texParams.magFilter = GL_LINEAR
		-- texParams.wrapS = GL_CLAMP_TO_EDGE
		-- texParams.wrapT = GL_CLAMP_TO_EDGE
		-- crystalItem:getTexture():setTexParameters(texParams)
		-- crystalItem:getTexture():setAliasTexParameters()
		-- crystalItem:getTexture():setAntiAliasTexParameters()
		crystalItem:setScale(1.5)
		crystalItem:setPosition(ccp(stageSize.width * math.random(), stageSize.height * math.random()))
		self:addChild(crystalItem)
	end

	-- labelWrapper:addEventListener(DisplayEvents.kTouchTap, onLabelTapped)
	labelWrapper:addEventListener(DisplayEvents.kTouchTap, testHeBezierTo)

	local redOne = LayerColor:create()
	local blueOne = LayerColor:create()
	local greenOne = LayerColor:create()

	local function onRedTouchBegan(event)
		print("onRedTouchBegan")
	end
	local function onBlueTouchBegan(event)
		print("onBlueTouchBegan")
	end
	local function onGreenTouchBegan(event)
		print("onGreenTouchBegan")
	end

	redOne:setColor(ccc3(255, 0, 0))
	redOne:changeWidthAndHeight(300, 300)
	redOne:setPosition(ccp(100, 100))
	redOne:setTouchEnabled(true, 10, false)
	redOne:addEventListener(DisplayEvents.kTouchBegin, onRedTouchBegan)
	self:addChild(redOne)

	blueOne:setColor(ccc3(0, 0, 255))
	blueOne:changeWidthAndHeight(200, 200)
	blueOne:setPosition(ccp(120, 120))
	blueOne:setTouchEnabled(true, 1, false)
	blueOne:addEventListener(DisplayEvents.kTouchBegin, onBlueTouchBegan)
	self:addChild(blueOne)

	greenOne:setColor(ccc3(0, 255, 0))
	greenOne:changeWidthAndHeight(100, 100)
	greenOne:setPosition(ccp(150, 150))
	greenOne:setTouchEnabled(true, 10, false)
	greenOne:addEventListener(DisplayEvents.kTouchBegin, onGreenTouchBegan)
	self:addChild(greenOne)

	for i=1,3 do
		local testFlower = Sprite:createWithSpriteFrameName("hiddenFlowerAnim" .. i .. "0000")
		testFlower:setPosition(ccp(200 + i * 100, 600))
		self:addChild(testFlower)
	end
end

function TestScene:create(...)
	assert(#{...} == 0)

	local newTestScene = TestScene.new()
	newTestScene:init()
	return newTestScene
end

local testScene = TestScene:create()
Director:sharedDirector():pushScene(testScene)
