-------------------------------------------------------------------------
--  Class include: CountDownAnimation
-------------------------------------------------------------------------

require "hecore.display.Director"

--
-- CountDownAnimation ---------------------------------------------------------
--
CountDownAnimation = class()

local function buildTimeCountDownAnimation( sprite, delay )
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(delay))
	array:addObject(CCSpawn:createWithTwoActions(CCEaseElasticOut:create(CCScaleTo:create(1, 1.3)), CCFadeIn:create(1)))
	array:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(0.5), CCScaleTo:create(0.5, 1.6)))
	
	sprite:setOpacity(0)
	sprite:setScale(2.2)
	sprite:runAction(CCSequence:create(array))
end 

function CountDownAnimation:create(delay, animationCallbackFunc)
	delay = delay or 0
	local batch = SpriteBatchNode:createWithTexture(CCSprite:createWithSpriteFrameName("countdown_10000"):getTexture())
	batch.name = "CountDownAnimation"

	local items = {"3", "2", "1"}
	for i,v in ipairs(items) do
		local sprite = Sprite:createWithSpriteFrameName("countdown_"..v.."0000")		
		batch:addChild(sprite)
		buildTimeCountDownAnimation(sprite, delay + (i-1) * 1)
	end

	local sprite = Sprite:createWithSpriteFrameName("countdown_go0000")
	sprite:setOpacity(0)
	sprite:setScale(4)
	batch:addChild(sprite)

	local function onAnimationFinished()
		batch:removeFromParentAndCleanup(true)
	end 
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(delay + 3))
	array:addObject(CCSpawn:createWithTwoActions(CCEaseElasticOut:create(CCScaleTo:create(1, 1.5)), CCFadeIn:create(1)))
	
	if animationCallbackFunc ~= nil then array:addObject(CCCallFunc:create(animationCallbackFunc)) end

	array:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(0.3), CCScaleTo:create(0.3, 1.7)))
	array:addObject(CCCallFunc:create(onAnimationFinished))
	sprite:runAction(CCSequence:create(array))
  	
	return batch
end

function CountDownAnimation:createLoadingAnimation(labelText)
	local container	= Layer:create()
	local back = Scale9Sprite:createWithSpriteFrameName("loading_ico_rect instance 10000")
	back:setPreferredSize(CCSizeMake(500, 170))
	container:addChild(back)
	local batch = SpriteBatchNode:createWithTexture(CCSprite:createWithSpriteFrameName("loading_ico_1 instance 10000"):getTexture())
	container:addChild(batch)

	local currentPosition = 0
	for i = 1, 6 do
		local animal = Sprite:createWithSpriteFrameName("loading_ico_"..i.." instance 10000")
		local contentSize = animal:getContentSize()
		animal:setPosition(ccp(currentPosition, 8))
		animal.oriX = currentPosition
		animal.oriY	= 8
		animal.move = function( self, delay )
			self:stopAllActions()
			self:setPosition(ccp(self.oriX, self.oriY))
			self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delay), CCSequence:createWithTwoActions(CCMoveTo:create(0.25, ccp(self.oriX, self.oriY + 25)), CCMoveTo:create(0.25, ccp(self.oriX, self.oriY)))))
		end
		currentPosition = currentPosition + contentSize.width + 5
		batch:addChild(animal)
		if i == 6 then currentPosition = currentPosition - contentSize.width - 5 end
	end
	local function onStartAnimation()
		for i = 0, 5 do
			local animal = batch:getChildAt(i)
			if animal then animal:move(i * 0.2) end
		end
	end
	batch:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCCallFunc:create(onStartAnimation), CCDelayTime:create(1.5))))
	batch:setPositionX(-currentPosition/2)

	labelText = labelText or Localization:getInstance():getText("dis.connect.connecting.date.tips")
	local label = TextField:create(labelText, nil, 24)
	label:setPositionY(-44)
	container:addChild(label)
	return container
end

function CountDownAnimation:_createNetworkAnimationLayer(scene, onCloseButtonTap, labelText)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local origin = Director:sharedDirector():getVisibleOrigin()

	local layer = LayerColor:create()
	layer:changeWidthAndHeight(winSize.width, winSize.height)
	layer:setColor(ccc3(0, 0, 0))
	layer:setPosition(ccp(origin.x, origin.y))
	layer:setTouchEnabled(true, 0, true)
	layer:setOpacity(255*0.35)
	layer.hitTestPoint = function(self, worldPosition, useGroupTest)
		return true
	end

	local loadingAnimation = CountDownAnimation:createLoadingAnimation(labelText)
	local size = loadingAnimation:getGroupBounds().size
	loadingAnimation:setPosition(ccp(visibleSize.width/2,visibleSize.height/2))
	layer:addChild(loadingAnimation)

	if onCloseButtonTap then 
		local closeButtonSprite = Sprite:createWithSpriteFrameName("commonloadingclose instance 10000")
		local closeButton = Layer:create()
		closeButton:addChild(closeButtonSprite)
		closeButton:setPosition(ccp(size.width / 2 - 20, size.height / 2 - 20))
		closeButton:setTouchEnabled(true)
		closeButton:setButtonMode(true)
		closeButton:addEventListener(DisplayEvents.kTouchTap, onCloseButtonTap)
		closeButton.name = "close"
		loadingAnimation:addChild(closeButton)
	end

	return layer
end

function CountDownAnimation:createNetworkAnimationInHttp(scene, onCloseButtonTap)
	local layer = CountDownAnimation:_createNetworkAnimationLayer(scene, onCloseButtonTap)
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local origin = Director:sharedDirector():getVisibleOrigin()
	layer:setPositionY(layer:getPositionY() - visibleSize.height - origin.y)
	PopoutManager:sharedInstance():add(layer, false, false)

	return layer
end

function CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap, labelText)
	local layer = CountDownAnimation:_createNetworkAnimationLayer(scene, onCloseButtonTap, labelText)
	scene:addChild(layer)

	return layer
end

function CountDownAnimation:createBindAnimation(scene, onCloseButtonTap)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local origin = Director:sharedDirector():getVisibleOrigin()

	local layer = LayerColor:create()
	layer:changeWidthAndHeight(winSize.width, winSize.height)
	layer:setColor(ccc3(0, 0, 0))
	layer:setPosition(ccp(origin.x, origin.y))
	layer:setTouchEnabled(true, 0, true)
	layer:setOpacity(255*0.35)
	layer.hitTestPoint = function(self, worldPosition, useGroupTest)
		return true
	end
	scene:addChild(layer)

	local loadingAnimation = CountDownAnimation:createLoadingAnimation(Localization:getInstance():getText("loading.tips.binding.account"))
	local size = loadingAnimation:getGroupBounds().size
	loadingAnimation:setPosition(ccp(visibleSize.width/2,visibleSize.height/2))
	layer:addChild(loadingAnimation)

	local closeButtonSprite = Sprite:createWithSpriteFrameName("commonloadingclose instance 10000")
	local closeButton = Layer:create()
	closeButton:addChild(closeButtonSprite)
	closeButton:setPosition(ccp(size.width / 2 - 20, size.height / 2 - 20))
	closeButton:setTouchEnabled(true)
	closeButton:setButtonMode(true)
	closeButton:addEventListener(DisplayEvents.kTouchTap, onCloseButtonTap)
	closeButton.name = "close"
	loadingAnimation:addChild(closeButton)

	return layer
end

function CountDownAnimation:createSyncAnimation(parent)
	local winSize = CCDirector:sharedDirector():getVisibleSize()
	local winOrigin = CCDirector:sharedDirector():getVisibleOrigin()

	local container = Sprite:createEmpty()
	local back = Sprite:createWithSpriteFrameName("loading_ico_circle instance 10000")	
	local icon = Sprite:createWithSpriteFrameName("loading_ico_turn instance 10000")

	container:setCascadeOpacityEnabled(true)
	back:setCascadeOpacityEnabled(true)
	icon:setCascadeOpacityEnabled(true)

	container:setOpacity(0)
	container:addChild(back)
	container:addChild(icon)
	
	local contentSize = back:getContentSize()
	local x = winSize.width - contentSize.width
	local y = winOrigin.y + contentSize.height
	container:setPosition(ccp(x, y))

	local addedTo = parent
	if addedTo == nil then addedTo = Director:sharedDirector():getRunningScene() end
	if addedTo then
		container:runAction(CCFadeIn:create(0.2))
		icon:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 180)))
		addedTo:addChild(container)
	end

	container.hide = function( self, delayTime )
		local function onSyncAnimationFinished()  
			if self and not self.isDisposed then self:removeFromParentAndCleanup(true)  end
		end
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(delayTime))
		array:addObject(CCFadeOut:create(0.1))
		array:addObject(CCCallFunc:create(onSyncAnimationFinished))
		if self and not self.isDisposed then self:runAction(CCSequence:create(array)) end
	end

	return container
end

function CountDownAnimation:createShareProcessingAnimation(scene)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local origin = Director:sharedDirector():getVisibleOrigin()

	local layer = LayerColor:create()
	layer:changeWidthAndHeight(winSize.width, winSize.height)
	layer:setColor(ccc3(0, 0, 0))
	layer:setPosition(ccp(origin.x, origin.y))
	layer:setTouchEnabled(true, 0, true)
	layer:setOpacity(255*0.35)
	layer.hitTestPoint = function(self, worldPosition, useGroupTest)
		return true
	end
	scene:addChild(layer)

	local loadingAnimation = CountDownAnimation:createLoadingAnimation(Localization:getInstance():getText("share.feed.sending.tips"))
	local size = loadingAnimation:getGroupBounds().size
	loadingAnimation:setPosition(ccp(visibleSize.width/2,visibleSize.height/2))
	layer:addChild(loadingAnimation)

	return layer
end

function CountDownAnimation:createActivityAnimation(scene,onCloseButtonTap)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local origin = Director:sharedDirector():getVisibleOrigin()

	local loadingAnimation = CountDownAnimation:createLoadingAnimation(
		Localization:getInstance():getText("activity.center.loading.tip") --"精彩内容加载中，请稍候~"
	)
	local size = loadingAnimation:getGroupBounds().size
	-- loadingAnimation:setPosition(ccp(visibleSize.width/2,visibleSize.height/2))
	-- layer:addChild(loadingAnimation)

	if onCloseButtonTap then
		local closeButtonSprite = Sprite:createWithSpriteFrameName("commonloadingclose instance 10000")
		local closeButton = Layer:create()
		closeButton:addChild(closeButtonSprite)
		closeButton:setPosition(ccp(size.width / 2 - 20, size.height / 2 - 20))
		closeButton:setTouchEnabled(true)
		closeButton:setButtonMode(true)
		closeButton:addEventListener(DisplayEvents.kTouchTap, onCloseButtonTap)
		closeButton.name = "close"
		loadingAnimation:addChild(closeButton)
	end

	if not scene then 
		loadingAnimation:dispose()
		-- layer:dispose()
	else
		loadingAnimation:setPosition(ccp(visibleSize.width/2,-visibleSize.height/2))
		PopoutManager:sharedInstance():add(loadingAnimation,true,false)

		local oldRemoveFromParentAndCleanup = loadingAnimation.removeFromParentAndCleanup
		loadingAnimation.removeFromParentAndCleanup = function(s,cleanup)
			loadingAnimation.removeFromParentAndCleanup = oldRemoveFromParentAndCleanup
			PopoutManager:sharedInstance():remove(loadingAnimation,cleanup)
		end
	end

	return loadingAnimation
end