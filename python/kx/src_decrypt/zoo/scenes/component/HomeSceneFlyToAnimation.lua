require "zoo.animation.FlyToAnimation"
require "zoo.util.ChanceUtils"

HomeSceneFlyToAnimation = class()

local instance = nil
function HomeSceneFlyToAnimation:sharedInstance()
	if not instance then instance = HomeSceneFlyToAnimation.new() end
	return instance
end

-- config = {
-- 	energyButton,
-- 	starButton,
-- 	coinButton,
-- 	bagButton,
-- }
function HomeSceneFlyToAnimation:init(config)
	self.energyButton = config.energyButton
	self.starButton = config.starButton
	self.coinButton = config.coinButton
	self.bagButton = config.bagButton
	self.goldButton = config.goldButton
end

-- config = {
--	flyDuration,
--	delayTime,
-- 	updateButton,
-- 	startCallback(coinSprite), -- may be nil
-- 	reachCallback(coinSprite), -- may be nil
-- 	finishCallback,
-- }
-- CAUTION: return nil while something wrong
-- CAUTION: add to parent before call play
function HomeSceneFlyToAnimation:coinStackAnimation(config)
	if not self.coinButton or self.coinButton.isDisposed then return end
	config.flyDuration, config.delayTime = config.flyDuration or 0.3, config.delayTime or 0.1
	local stack = ResourceManager:sharedInstance():buildGroup("stackIcon")
	local coinsInStack, counter = {}, 1
	local flyingCoins = {}
	while true do
		local coin = stack:getChildByName(tostring(counter))
		if coin then
			table.insert(coinsInStack, coin)
			local flyCoin = Sprite:createWithSpriteFrameName("homeSceneCoinIcon0000")
			local pos = coin:getPosition()
			local size = coin:getGroupBounds().size
			flyCoin:setPosition(ccp(pos.x + size.width / 2, pos.y - size.height / 2))
			flyCoin:setVisible(false)
			stack:addChild(flyCoin)
			table.insert(flyingCoins, flyCoin)
		else break end
		counter = counter + 1
	end
	local started = 2
	local function onStart(target)
		if coinsInStack[started] and not coinsInStack[started].isDisposed then coinsInStack[started]:setVisible(false) end
		if target and not target.isDisposed then target:setVisible(true) end
		if config.startCallback then config.startCallback(target) end
		started = started + 1
	end
	local function onReach(target)
		if target and not target.isDisposed then target:setVisible(false) end
		if self.coinButton and not self.coinButton.isDisposed then self.coinButton:playHighlightAnim() end
		if config.reachCallback then config.reachCallback(target) end
	end
	local function onFinish()
		stack:removeFromParentAndCleanup(true)
		for k, v in ipairs(flyingCoins) do
			flyingCoins[1]:removeFromParentAndCleanup(true)
			table.remove(flyingCoins, 1)
		end
		if config.updateButton and not self.coinButton.isDisposed then self.coinButton:updateView() end
		if config.finishCallback then config.finishCallback() end
	end
	local flyToConfig = {
		duration = config.flyDuration,
		sprites = flyingCoins,
		dstPosition = self.coinButton:getFlyToPosition(),
		dstSize = self.coinButton:getFlyToSize(),
		direction = true,
		delayTime = config.delayTime,
		startCallback = onStart,
		reachCallback = onReach,
		finishCallback = onFinish,
	}
	local ret = {}
	ret.sprites = stack
	ret.sprites.setPosition = function(self, pos)
		Layer.setPosition(self, ccp(pos.x - 59, pos.y + 77))
	end
	ret.sprites:setPosition(ccp(0, 0))
	ret.play = function(self)
		if not self.coinButton or self.coinButton.isDisposed or self.played then return false end
		self.played = true
		if coinsInStack[1] and not coinsInStack[1].isDisposed then coinsInStack[1]:setVisible(false) end
		if flyingCoins[1] and not flyingCoins[1].isDisposed then flyingCoins[1]:setVisible(true) end
		BezierFlyToAnimation:create(flyToConfig)
		return true
	end
	ret.coinButton = self.coinButton
	return ret
end

-- config = {
-- 	number,
--	flyDuration,
--	delayTime,
-- 	updateButton,
-- 	startCallback(coinSprite), -- may be nil
-- 	reachCallback(coinSprite), -- may be nil
-- 	finishCallback,
-- }
-- RETURN: a table containing all elements
-- CAUTION: return nil while something wrong
-- CAUTION: add to parent before call play
function HomeSceneFlyToAnimation:energyFlyToAnimation(config)
	if not self.energyButton or self.energyButton.isDisposed then return end
	config.number = config.number or 1
	config.flyDuration, config.delayTime = config.flyDuration or 0.3, config.delayTime or 0.1
	local energies = {}
	for i = 1, config.number do
		local energy = Sprite:createWithSpriteFrameName("homeSceneEner_j34i0000")
		energy:setVisible(false)
		table.insert(energies, energy)
	end
	energies[1]:setVisible(true)
	local function onStart(target)
		for k, v in ipairs(energies) do
			if v == target and energies[k + 1] and not energies[k + 1].isDisposed then
				energies[k + 1]:setVisible(true)
			end
		end
		if config.startCallback then config.startCallback(target) end
	end
	local function onReach(target)
		if target and not target.isDisposed then target:setVisible(false) end
		if self.energyButton and not self.energyButton.isDisposed then self.energyButton:playHighlightAnim() end
		if config.reachCallback then config.reachCallback(target) end
	end
	local function onFinish()
		for i = 1, #energies do
			energies[1]:removeFromParentAndCleanup(true)
			table.remove(energies, 1)
		end
		if config.updateButton and not self.coinButton.isDisposed then self.energyButton:updateView() end
		if config.finishCallback then config.finishCallback() end
	end
	local flyToConfig = {
		duration = config.flyDuration,
		sprites = energies,
		dstPosition = self.energyButton:getFlyToPosition(),
		dstSize = self.energyButton:getFlyToSize(),
		direction = false,
		delayTime = config.delayTime,
		startCallback = onStart,
		reachCallback = onReach,
		finishCallback = onFinish,
	}
	local ret = {}
	ret.sprites = energies
	ret.play = function(self)
		if not self.energyButton or self.energyButton.isDisposed or self.played then return false end
		self.played = true
		BezierFlyToAnimation:create(flyToConfig)
		return true
	end
	ret.energyButton = self.energyButton
	return ret
end

-- config = {
-- 	number,
--	flyDuration,
--	delayTime,
-- 	updateButton,
-- 	startCallback(coinSprite), -- may be nil
-- 	reachCallback(coinSprite), -- may be nil
-- 	finishCallback,
-- }
-- RETURN: a table containing all elements
-- CAUTION: return nil while something wrong
-- CAUTION: add to parent before call play
function HomeSceneFlyToAnimation:goldFlyToAnimation(config)
	if not self.goldButton or self.goldButton.isDisposed then return end
	config.number = config.number or 1
	config.flyDuration, config.delayTime = config.flyDuration or 0.3, config.delayTime or 0.1
	local golds = {}
	for i = 1, config.number do
		local gold = Sprite:createWithSpriteFrameName("wheel0000")
		gold:setAnchorPoint(ccp(0, 1))
		gold:setVisible(false)
		table.insert(golds, gold)
	end
	golds[1]:setVisible(true)
	local function onStart(target)
		for k, v in ipairs(golds) do
			if v == target and golds[k + 1] and not golds[k + 1].isDisposed then
				golds[k + 1]:setVisible(true)
			end
		end
		if config.startCallback then config.startCallback(target) end
	end
	local function onReach(target)
		if target and not target.isDisposed then target:setVisible(false) end
		if self.goldButton and not self.goldButton.isDisposed then self.goldButton:playHighlightAnim() end
		if config.reachCallback then config.reachCallback(target) end
	end
	local function onFinish()
		for i = 1, #golds do
			golds[1]:removeFromParentAndCleanup(true)
			table.remove(golds, 1)
		end
		if config.updateButton and not self.coinButton.isDisposed then self.goldButton:updateView() end
		if config.finishCallback then config.finishCallback() end
	end
	local flyToConfig = {
		duration = config.flyDuration,
		sprites = golds,
		dstPosition = self.goldButton:getFlyToPosition(),
		dstSize = self.goldButton:getFlyToSize(),
		direction = true,
		delayTime = config.delayTime,
		startCallback = onStart,
		reachCallback = onReach,
		finishCallback = onFinish,
	}
	local ret = {}
	ret.sprites = golds
	ret.play = function(self)
		if not self.goldButton or self.goldButton.isDisposed or self.played then return false end
		self.played = true
		BezierFlyToAnimation:create(flyToConfig)
		return true
	end
	ret.goldButton = self.goldButton
	return ret
end

-- config = {
-- 	goodsId,
-- 	propId,
-- 	number,
--	flyDuration,
--	delayTime,
-- 	startCallback(coinSprite), -- may be nil
-- 	reachCallback(coinSprite), -- may be nil
-- 	finishCallback,
-- }
-- RETURN: a table containing all elements
-- CAUTION: if there is propId, goodsId will be ignored
-- CAUTION: return nil while something wrong
-- CAUTION: add to parent before call play
function HomeSceneFlyToAnimation:jumpToBagAnimation(config)
	if not self.bagButton or self.bagButton.isDisposed then return end
	config.number = config.number or 1
	config.flyDuration, config.delayTime = config.flyDuration or 0.8, config.delayTime or 0.3
	local props = {}
	for i = 1, config.number do
		local prop
		if config.propId then prop = ResourceManager:sharedInstance():buildItemSprite(config.propId)
		elseif config.goodsId then prop = ResourceManager:sharedInstance():getItemResNameFromGoodsId(config.goodsId)
		else return end
		prop:setVisible(false)
		table.insert(props, prop)
	end
	props[1]:setVisible(true)
	local function onStart(target)
		for k, v in ipairs(props) do
			if v == target and props[k + 1] and not props[k + 1].isDisposed then
				props[k + 1]:setVisible(true)
			end
		end
		if config.startCallback then config.startCallback(target) end
	end
	local function onReach(target)
		if target and not target.isDisposed then target:setVisible(false) end
		if self.bagButton and not self.bagButton.isDisposed then self.bagButton:playHighlightAnim() end
		if config.reachCallback then config.reachCallback(target) end
	end
	local function onFinish()
		for i = 1, #props do
			props[1]:removeFromParentAndCleanup(true)
			table.remove(props, 1)
		end
		if config.finishCallback then config.finishCallback() end
	end
	local jumpToConfig = {
		duration = config.flyDuration,
		sprites = props,
		dstPosition = self.bagButton:getFlyToPosition(),
		dstSize = self.bagButton:getFlyToSize(),
		easeIn = true,
		delayTime = config.delayTime,
		startCallback = onStart,
		reachCallback = onReach,
		finishCallback = onFinish,
	}
	local ret = {}
	ret.sprites = props
	ret.play = function(self)
		if not self.bagButton or self.bagButton.isDisposed or self.played then return false end
		self.played = true
		jumpToConfig.extendAction = CCSequence:createWithTwoActions(CCDelayTime:create(config.flyDuration - 0.1), CCFadeOut:create(0.1))
		JumpFlyToAnimation:create(jumpToConfig)
		return true
	end
	ret.bagButton = self.bagButton
	return ret
end

local coinConfigs = {
	{scale = 1, dPosition = ccp(28, 5),},
	{scale = 1, dPosition = ccp(8, 10),},
	{scale = 1, dPosition = ccp(13, -5),},
	{scale = 1, dPosition = ccp(-2, 0),},
	{scale = 1, dPosition = ccp(13, -25),},
}
function HomeSceneFlyToAnimation:levelNodeCoinAnimation(position, finishCallback, parent)
	if not self.coinButton or self.coinButton.isDisposed then return false end
	if not position then return false end
	parent = parent or HomeScene:sharedInstance()
	if not parent or parent.isDisposed then return false end
	local coins = {}
	for k, v in ipairs(coinConfigs) do
		local coin = Sprite:createWithSpriteFrameName("homeSceneCoinIcon0000")
		if coin then
			coin:setAnchorPoint(ccp(0.5, 0.5))
			coin:setScale(v.scale)
			coin:setPosition(ccp(position.x + v.dPosition.x, position.y + v.dPosition.y))
			coin:setOpacity(0)
			table.insert(coins, coin)
		end
	end
	local counter = 1
	local function onReach()
		if coins[counter] and not coins[counter].isDisposed then
			coins[counter]:setVisible(false)
			counter = counter + 1
		end
		if not self.coinButton.isDisposed and self.coinButton.playHighlightAnim then
			self.coinButton:playHighlightAnim()
		end
	end
	local function onFinish()
		for i = 1, #coins do
			coins[1]:removeFromParentAndCleanup(true)
			table.remove(coins, 1)
		end
		if finishCallback then finishCallback() end
	end
	local config = {
		duration = 0.3,
		sprites = coins,
		dstPosition = self.coinButton:getFlyToPosition(),
		dstSize = self.coinButton:getFlyToSize(),
		direction = true,
		delayTime = 0.1,
		reachCallback = onReach,
		finishCallback = onFinish,
	}
	for k, v in ipairs(coins) do
		local sequence = CCArray:create()
		sequence:addObject(CCDelayTime:create((k - 1) * config.delayTime))
		sequence:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(0.2), CCEaseBackOut:create(CCMoveBy:create(0.4, ccp(0, -30)))))
		if k == 1 then
			local function playFlyToAnim() BezierFlyToAnimation:create(config) end
			sequence:addObject(CCCallFunc:create(playFlyToAnim))
		end

		v:runAction(CCSequence:create(sequence))
		parent:addChild(v)
	end

	GamePlayMusicPlayer:playEffect(GameMusicType.kGetRewardCoin)

	return true
end

function HomeSceneFlyToAnimation:levelNodeStarAnimation()
	if not self.starButton or self.starButton.isDisposed then return end
end

function HomeSceneFlyToAnimation:levelNodeEnergyAnimation(position, finishCallback, parent)
	if not self.energyButton or self.energyButton.isDisposed then return false end
	if not position then return false end
	parent = parent or HomeScene:sharedInstance()
	if not parent or parent.isDisposed then return false end
	local coins = {}
	local energy = Sprite:createWithSpriteFrameName("homeSceneEner_j34i0000")
	if not energy then return end
	energy:setAnchorPoint(ccp(0.5, 0.5))
	energy:setPosition(ccp(position.x, position.y))
	local function onFinish()
		energy:removeFromParentAndCleanup(true)
		energy = nil
		if not self.energyButton.isDisposed and self.energyButton.playHighlightAnim then
			self.energyButton:playHighlightAnim()
		end
		if finishCallback then finishCallback() end
		GamePlayMusicPlayer:playEffect(GameMusicType.kAddEnergy)
	end
	local config = {
		duration = 0.3,
		sprites = {energy},
		dstPosition = self.energyButton:getFlyToPosition(),
		dstSize = self.energyButton:getFlyToSize(),
		direction = false,
		delayTime = 0.1,
		finishCallback = onFinish,
	}
	local sequence = CCArray:create()
	sequence:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(0.2), CCEaseBackOut:create(CCMoveBy:create(0.4, ccp(0, -30)))))
	local function playFlyToAnim() 
		BezierFlyToAnimation:create(config) 
	end
	sequence:addObject(CCCallFunc:create(playFlyToAnim))
	energy:runAction(CCSequence:create(sequence))
	parent:addChild(energy)

	return true
end

local propConfigs = {
	{scale = 1, position = ccp(0, 0),},
	{scale = 1, position = ccp(0, 0),},
	{scale = 1, position = ccp(0, 0),},
}
-- props = {propId, ...}
function HomeSceneFlyToAnimation:levelNodeJumpToBagAnimation(props, position, finishCallback, parent)
	if not props or not position then return false end
	if #props <= 0 then -- nothing played, finish next frame
		local function onFinish() if finishCallback then finishCallback() end end
		setTimeOut(onFinish, 1 / 60)
		return true
	end
	if not self.bagButton or self.bagButton.isDisposed then return false end
	parent = parent or HomeScene:sharedInstance()
	if not parent or parent.isDisposed then return false end
	local icons = {}
	for k, v in ipairs(props) do
		local prop = ResourceManager:sharedInstance():buildItemSprite(v)
		if prop then
			local index = k
			if k > #propConfigs then index = k % #propConfigs end
			prop:setAnchorPoint(ccp(0.5, 0.5))
			prop:setScale(propConfigs[index].scale)
			prop:setPosition(ccp(position.x + propConfigs[index].position.x, position.y + propConfigs[index].position.y))
			prop:setOpacity(0)
			table.insert(icons, prop)
		end
	end
	local counter = 1
	local function onReach()
		if icons[counter] and not icons[counter].isDisposed then
			icons[counter]:setVisible(false)
			counter = counter + 1
		end
		if not self.bagButton.isDisposed and self.bagButton.playHighlightAnim then
			self.bagButton:playHighlightAnim()
		end
		GamePlayMusicPlayer:playEffect(GameMusicType.kGetRewardProp)	
	end
	local function onFinish()
		for i = 1, #icons do
			icons[1]:removeFromParentAndCleanup(true)
			table.remove(icons, 1)
		end
		if finishCallback then finishCallback() end
	end
	local config = {
		duration = 0.8,
		sprites = icons,
		dstPosition = self.bagButton:getFlyToPosition(),
		dstSize = self.bagButton:getFlyToSize(),
		easeIn = true,
		delayTime = 0.1,
		height = 100,
		reachCallback = onReach,
		finishCallback = onFinish,
	}
	for k, v in ipairs(icons) do
		local sequence = CCArray:create()
		sequence:addObject(CCDelayTime:create((k - 1) * config.delayTime))
		sequence:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(0.2), CCEaseBackOut:create(CCMoveBy:create(0.3, ccp(0, -30)))))
		if k == 1 then
			local function playFlyToAnim()
				config.extendAction = CCSequence:createWithTwoActions(CCDelayTime:create(0.7), CCFadeOut:create(0.1))
				JumpFlyToAnimation:create(config)
			end
			sequence:addObject(CCCallFunc:create(playFlyToAnim))
		end
		v:runAction(CCSequence:create(sequence))
		parent:addChild(v)
	end

	return true
end

-- RETURN: layer
-- CAUTION: return nil while something wrong
-- CAUTION: add to parent before call play
local coinNumber = 0
local chanceToFall = {2, 2, 3, 4, 4, 5, 6, 6, 6, 5, 4, 4, 3, 2, 2}
for k, v in ipairs(chanceToFall) do coinNumber = coinNumber + v end
function HomeSceneFlyToAnimation:createCoinRain(finishCallback)
	local randomTable = {}
	local function createFallingCoinAnim(index, fakeCoin, isEnergy)
		local wSize = Director:sharedDirector():getWinSize()
		local vSize = Director:sharedDirector():getVisibleSize()
		local vOrigin = Director:sharedDirector():getVisibleOrigin()

		local flyingCoin
		if isEnergy then flyingCoin = Sprite:createWithSpriteFrameName("homeSceneEner_j34i0000")
		else flyingCoin = Sprite:createWithSpriteFrameName("homeSceneCoinIcon0000") end
		local stackCoin = Sprite:createWithSpriteFrameName("asset/lying_coin0000")
		if not flyingCoin or not stackCoin then return end
		local size = stackCoin:getContentSize()
		randomTable[index] = randomTable[index] or 0
		local baseX = index * wSize.width / #chanceToFall - size.width / 2
		local randomX = math.random() * size.width / 2 - size.width / 5
		local baseY = randomTable[index] * size.height / 2 + size.height
		local randomY = math.random() * size.height / 3 - size.height / 3
		flyingCoin:setPositionX(baseX + randomX)
		flyingCoin:setPositionY(baseY + randomY + wSize.height)
		stackCoin:setPositionX(baseX + randomX)
		stackCoin:setPositionY(baseY + randomY)
		stackCoin:setVisible(false)
		local function afterFall()
			if flyingCoin or not flyingCoin.isDisposed then flyingCoin:setVisible(false) end
			if stackCoin and not stackCoin.isDisposed then
				stackCoin:setVisible(true)
				stackCoin:setAnchorPointWhileStayOriginalPosition(ccp(1, 0.5))
				stackCoin:runAction(CCSequence:createWithTwoActions(CCRotateTo:create(0.05, 10), CCRotateTo:create(0.05, 0)))
			end
		end
		local arr = CCArray:create()
		arr:addObject(CCEaseSineIn:create(CCMoveBy:create(0.6, ccp(0, -wSize.height))))
		arr:addObject(CCCallFunc:create(afterFall))
		if fakeCoin then
			stackCoin:dispose()
			stackCoin = nil
		else randomTable[index] = randomTable[index] + 1 end
		flyingCoin:runAction(CCSequence:create(arr))
		return flyingCoin, stackCoin
	end
	local counter = 1
	local layer = Layer:create()
	local lChanceToFall = {}
	for k, v in ipairs(chanceToFall) do lChanceToFall[k] = v end
	local state = 1
	local function generateCoin()
		local index = ChanceUtils:randomSelectByChance(lChanceToFall)
		local flyingCoin, stackCoin = createFallingCoinAnim(index, state % 3 ~= 1, state % 5 == 1)
		if not layer or layer.isDisposed or not flyingCoin then return end
		layer:addChild(flyingCoin)
		if state % 3 == 1 then
			if stackCoin then layer:addChild(stackCoin) end
			lChanceToFall[index] = lChanceToFall[index] - 1
			counter = counter + 1
		end
		state = state + 1
		if counter > coinNumber then
			layer:stopAllActions()
			if finishCallback then finishCallback() end
		end
	end
	math.randomseed(os.time())
	layer:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCCallFunc:create(generateCoin), CCDelayTime:create(0.03))))
	GamePlayMusicPlayer:getInstance():playEffect(GameMusicType.kCoinTick, 100)
	return layer
end

-- RETURN: layer
-- CAUTION: return nil while something wrong
-- CAUTION: add to parent before call play
function HomeSceneFlyToAnimation:createGoldRain(finishCallback)
	local randomTable = {}
	local function createFallingCoinAnim(index, fakeCoin)
		local wSize = Director:sharedDirector():getWinSize()
		local vSize = Director:sharedDirector():getVisibleSize()
		local vOrigin = Director:sharedDirector():getVisibleOrigin()

		local flyingCoin = Sprite:createWithSpriteFrameName("ui_images/ui_image_coin_icon_small0000")
		local stackCoin = Sprite:createWithSpriteFrameName("lyingWheel_img0000")
		if not flyingCoin or not stackCoin then return end
		flyingCoin:setScale(1.3)
		local size = stackCoin:getContentSize()
		randomTable[index] = randomTable[index] or 0
		local baseX = index * wSize.width / #chanceToFall - size.width / 2
		local randomX = math.random() * size.width / 2 - size.width / 5
		local baseY = randomTable[index] * size.height / 2 + size.height
		local randomY = math.random() * size.height / 3 - size.height / 3
		flyingCoin:setPositionX(baseX + randomX)
		flyingCoin:setPositionY(baseY + randomY + wSize.height)
		stackCoin:setPositionX(baseX + randomX)
		stackCoin:setPositionY(baseY + randomY)
		stackCoin:setVisible(false)
		local function afterFall()
			if flyingCoin or not flyingCoin.isDisposed then flyingCoin:setVisible(false) end
			if stackCoin and not stackCoin.isDisposed then
				stackCoin:setVisible(true)
				stackCoin:setAnchorPointWhileStayOriginalPosition(ccp(1, 0.5))
				stackCoin:runAction(CCSequence:createWithTwoActions(CCRotateTo:create(0.05, 10), CCRotateTo:create(0.05, 0)))
			end
		end
		local arr = CCArray:create()
		arr:addObject(CCEaseSineIn:create(CCMoveBy:create(0.6, ccp(0, -wSize.height))))
		arr:addObject(CCCallFunc:create(afterFall))
		if fakeCoin then
			stackCoin:dispose()
			stackCoin = nil
		else randomTable[index] = randomTable[index] + 1 end
		flyingCoin:runAction(CCSequence:create(arr))
		return flyingCoin, stackCoin
	end
	local counter = 1
	local layer = Layer:create()
	local lChanceToFall = {}
	for k, v in ipairs(chanceToFall) do lChanceToFall[k] = v end
	local state = 1
	local function generateCoin()
		local index = ChanceUtils:randomSelectByChance(lChanceToFall)
		local flyingCoin, stackCoin = createFallingCoinAnim(index, state % 3 ~= 1)
		if not layer or layer.isDisposed or not flyingCoin then return end
		layer:addChild(flyingCoin)
		if state % 3 == 1 then
			if stackCoin then layer:addChild(stackCoin) end
			lChanceToFall[index] = lChanceToFall[index] - 1
			counter = counter + 1
		end
		state = state + 1
		if counter > coinNumber then
			layer:stopAllActions()
			if finishCallback then finishCallback() end
		end
	end
	math.randomseed(os.time())
	layer:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCCallFunc:create(generateCoin), CCDelayTime:create(0.03))))
	GamePlayMusicPlayer:getInstance():playEffect(GameMusicType.kCoinTick, 100)
	return layer
end