require "zoo.scenes.component.fruitTreeScene.Fruit"

kFruitTreeEvents = {
	kUpdate = "kFruitTreeEvents.kUpdate",
	kUpdateData = "kFruitTreeEvents.kUpdateData",
	kFruitClicked = "kFruitTreeEvents.kFruitClicked",
	kFruitReleased = "kFruitTreeEvents.kFruitReleased",
	kExit = "kFruitTreeEvents.kExit",
}

FruitTree = class(CocosObject)

function FruitTree:create(data)
	local tree = FruitTree.new()
	if not tree:_init(data) then tree = nil end
	return tree
end

function FruitTree:ctor()
	self:setRefCocosObj(CCNode:create())
end

function FruitTree:dispose()
	CocosObject.dispose(self)
	InterfaceBuilder:unloadAsset(PanelConfigFiles.fruitTreeScene)
end

function FruitTree:_init(data)
	-- data
	FruitTreeModel:sharedInstance():setFruitInfo(data)
	self.absoluteBlock = false

	-- get & create controls
	local builder = InterfaceBuilder:createWithContentsOfFile(PanelConfigFiles.fruitTreeScene)
	self.ui = builder:buildGroup("fruitTree")
	self.fruitPos, counter = {}, 1
	while true do
		local fruit = self.ui:getChildByName("fruit"..tostring(counter))
		if not fruit then break end
		local pos = fruit:getPosition()
		table.insert(self.fruitPos, {x = pos.x, y = pos.y})
		fruit:removeFromParentAndCleanup(true)
		counter = counter + 1
	end
	self:addChild(self.ui)

	-- for game guide
	local function onEnterHandler(evt) self:_onEnterHandler(evt) end
	self:registerScriptHandler(onEnterHandler)

	self:refresh("init")

	return true
end

function FruitTree:_onFruitClicked(target)
	if self.guided then return end
	local fruit = target
	local wSize = Director:sharedDirector():getWinSize()
	local scene = Director:sharedDirector():getRunningScene()
	if self.clickedFruit then
		return
	end
	if fruit:getId() == 4 then
		if self.tutorHand then
			self.tutorHand:removeFromParentAndCleanup(true)
			self.tutorHand = nil
			CCUserDefault:sharedUserDefault():setIntegerForKey("fruit.tree.tutorial", 1)
			CCUserDefault:sharedUserDefault():flush()
			self:_clickTutor()
			self.guided = true
		end
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("fruit.tree.tutorial", 2)
		CCUserDefault:sharedUserDefault():flush()
	end

	if not self.absoluteBlock and not self.clickedFruit then
		local clickedFruit = fruit:createClickedFruit(self.guided, 0.1)
		if not self.maskLayer then
			self.maskLayer = LayerColor:create()
			self.maskLayer:changeWidthAndHeight(wSize.width, wSize.height)
			self.maskLayer:setColor(ccc3(0, 0, 0))
			self.maskLayer:setOpacity(0)
			self.maskLayer:runAction(CCFadeTo:create(0.1, 125))
			self.maskLayer:setPosition(ccp(0, 0))
			self.maskLayer:setTouchEnabled(true, 0, true)
			if scene.guideLayer then scene:addChildAt(self.maskLayer, scene:getChildIndex(scene.guideLayer))
			else scene:addChild(self.maskLayer) end
		end
		if not self.maskLayer:isVisible() then self.maskLayer:setVisible(true) end
		self.clickedFruit = fruit
		self.maskLayer:addChild(clickedFruit)
		self:dispatchEvent(Event.new(kFruitTreeEvents.kFruitClicked, target:getId(), self))
	else
		self.clickedFruit = nil
	end
end

function FruitTree:endFruitTreeGuide()
	if self.tutorHand then
		self.tutorHand:removeFromParentAndCleanup(true)
		self.tutorHand = nil
		CCUserDefault:sharedUserDefault():setIntegerForKey("fruit.tree.tutorial", 2)
		CCUserDefault:sharedUserDefault():flush()
	elseif self.tutorLayer then
		self.tutorLayer:removeFromParentAndCleanup(true)
		self.tutorLayer = nil
		CCUserDefault:sharedUserDefault():setIntegerForKey("fruit.tree.tutorial", 2)
		CCUserDefault:sharedUserDefault():flush()
	end
	if self.clickedFruit then
		self:_onFruitCanceled(self.clickedFruit)
	end
	self.guided = false
end

function FruitTree:_onFruitCanceled(target)
	local fruit = target
	if self.clickedFruit and self.clickedFruit == fruit then
		self.clickedFruit:removeClickedFruit(0.1)
		local function onAnimFinish()
			self.clickedFruit = nil
			if self.maskLayer.isDisposed then return end
			self.maskLayer:removeFromParentAndCleanup(true)
			self.maskLayer = nil
			self:dispatchEvent(Event.new(kFruitTreeEvents.kFruitReleased, nil, self))
		end
		self.maskLayer:runAction(CCSequence:createWithTwoActions(CCFadeTo:create(0.1, 0), CCCallFunc:create(onAnimFinish)))
	end
end

function FruitTree:_onFruitUpdate(target)
	local function onSuccess()
		self:refresh("update", target)
		self:dispatchEvent(Event.new(kFruitTreeEvents.kUpdate, nil, self))
	end
	local function onFail(err)
		local function exit() self:dispatchEvent(Event.new(kFruitTreeEvents.kExit, nil, self)) end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative", exit)
	end
	local logic = FruitTreeLogic:create()
	logic:updateTreeInfo(onSuccess, onFail)
end

function FruitTree:refresh(source, target)
	self.fruits = self.fruits or {}
	for k, v in pairs(FruitTreeModel:sharedInstance():getFruitInfo()) do
		if not self.fruits[v.id] then
			local fruit = Fruit:create(v.id, v)
			local position = self.fruitPos[v.id]
			fruit:setPosition(ccp(position.x, position.y))
			self.ui:addChild(fruit)
			self.fruits[v.id] = fruit
			local function onFruitClicked(evt)
				self:_onFruitClicked(evt.target)
			end
			fruit:addEventListener(kFruitEvents.kNormClicked, onFruitClicked)
			local function onClickedFruitCanceled(evt)
				self:_onFruitCanceled(evt.target)
			end
			fruit:addEventListener(kFruitEvents.kSelectedCancel, onClickedFruitCanceled)
			local function onPick(evt)
				self:endFruitTreeGuide()
				self:dispatchEvent(Event.new(kFruitTreeEvents.kUpdateData, nil, self))
			end
			fruit:addEventListener(kFruitEvents.kPick, onPick)
			local function onRegenerate(evt)
				self:endFruitTreeGuide()
				self:dispatchEvent(Event.new(kFruitTreeEvents.kUpdateData, nil, self))
			end
			fruit:addEventListener(kFruitEvents.kRegenerate, onRegenerate)
			local function onUpdate(evt)
				self:_onFruitUpdate(evt.target)
			end
			fruit:addEventListener(kFruitEvents.kUpdate, onUpdate)
		else
			if self.fruits[v.id] == target then
				self.fruits[v.id]:refresh(v, source)
			else
				self.fruits[v.id]:refresh(v, "still")
			end
		end
	end
end

function FruitTree:addFruitRelease()
	if self.clickedFruit and not self.clickedFruit.isDisposed then
		self.clickedFruit:setClickedFruitReleaseEnabled(true)
	end
end

function FruitTree:onKeyBackClicked()
	if self.guided then return end
	self:_onFruitCanceled(self.clickedFruit)
end

function FruitTree:isBlockClick()
	return self.absoluteBlock
end

function FruitTree:blockClick(isBlock)
	self.absoluteBlock = isBlock
end

function FruitTree:getGuideInfo()
	print("**********FruitTree:getGuideInfo")
	local info = FruitTreeModel:sharedInstance():getGuideInfo()
	for k, v in pairs(info) do
		local position = self.fruits[k]:getPosition()
		local wPosition = self.ui:convertToWorldSpace(ccp(position.x, position.y))
		v.position = {x = wPosition.x, y = wPosition.y}
	end
	return info
end

function FruitTree:_onEnterHandler(evt)
	if evt == "enterTransitionFinish" then
		local index = CCUserDefault:sharedUserDefault():getIntegerForKey("fruit.tree.tutorial")
		if index < 1 then self:_enterTutor() end
	end
end

function FruitTree:_enterTutor()
	local info = FruitTreeModel:sharedInstance():getFruitInfo()[4]
	if not info or info.growCount < 5 then
		CCUserDefault:sharedUserDefault():setIntegerForKey("fruit.tree.tutorial", 2)
		CCUserDefault:sharedUserDefault():flush()
		return
	end

	local hand = GameGuideAnims:handclickAnim(0.5)
	local position = self.fruits[4]:getPosition()
	hand:setAnchorPoint(ccp(0, 1))
	hand:setPosition(ccp(position.x, position.y + 20))
	self:addChild(hand)
	self.tutorHand = hand
end

function FruitTree:_clickTutor()
	local scene = Director:sharedDirector():getRunningScene()
	if not scene then return end
	local layer = Layer:create()
	local action = {type = "fruitButton", text = "tutorial.game.text1601",
		panType = "up", panAlign = "viewY", panPosY = 400, maskDelay = 0.3,
		maskFade = 0.4, panDelay = 0.5, touchDelay = 1.1}
	local panel = GameGuideUI:panelS(nil, action)
	local skip = GameGuideUI:skipButton(Localization:getInstance():getText("tutorial.skip.step"), action, true)
	skip:removeAllEventListeners()
	local function onTouch()
		self:endFruitTreeGuide()
	end
	skip:ad(DisplayEvents.kTouchTap, onTouch)
	layer:addChild(skip)
	layer:addChild(panel)
	if scene.guideLayer then
		scene.guideLayer:addChild(layer)
		released = false
		self.tutorLayer = layer
	else
		layer:dispose()
	end
end

FruitTreeLogic = class()

function FruitTreeLogic:create()
	local logic = FruitTreeLogic.new()
	return logic
end

function FruitTreeLogic:updateTreeInfo(successCallback, failCallback)
	local function onSuccess(evt)
		if evt.data and evt.data.fruitInfos then
			self.info = evt.data.fruitInfos
			FruitTreeModel:sharedInstance():setFruitInfo(evt.data.fruitInfos)
			if successCallback then successCallback() end
		else
			if failCallback then failCallback(-2) end
		end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt.data) end
	end
	local http = GetFruitsInfoHttp.new(true)
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFail)
	http:syncLoad()
end

FruitTreeModel = class()

local instance = nil
function FruitTreeModel:sharedInstance()
	if not instance then
		instance = FruitTreeModel.new()
		instance:_init()
	end
	return instance
end

function FruitTreeModel:_init()
	self.upgradeInfo = {}
	local meta = MetaManager:getInstance().fruits_upgrade
	for k, v in ipairs(meta) do
		self.upgradeInfo[v.level] = {lock = v.lock, pickCount = v.pickCount,
		plus = v.plus, upgradeCondition = v.upgradeCondition}
	end
	self.pickedFruitCount = UserManager:getInstance():getDailyData().pickFruitCount
	self.fruitTreeLevel = UserManager:getInstance().userExtend.fruitTreeLevel
end

function FruitTreeModel:getFruitCount()
	if not self.upgradeInfo or not self.fruitTreeLevel or
		not self.upgradeInfo[self.fruitTreeLevel] then return 0 end
	return self.upgradeInfo[self.fruitTreeLevel].pickCount
end

function FruitTreeModel:getFruitInfo()
	self.fruitInfo = self.fruitInfo or {}
	return self.fruitInfo
end

function FruitTreeModel:setFruitInfo(data)
	self.fruitInfo = self.fruitInfo or {}
	for k, v in ipairs(data) do
		if v.id >= 1 and v.id <= 4 then
			self.fruitInfo[v.id] = {id = v.id, growCount = v.growCount, level = v.level,
			updateTime = v.updateTime, type = v.type}
		end
	end
end

function FruitTreeModel:getGuideInfo()
	local res = {}
	for k, v in pairs(self.fruitInfo) do
		res[k] = {growCount = v.growCount, level = v.level, type = v.type}
	end
	return res
end