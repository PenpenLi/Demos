GameGuideRunner = {}

local released = true -- 标志是否已经被调用释放函数，和瓢虫动画共同引起的栈溢出找出具体原因之前使用此方法暴力解决

function GameGuideRunner:runClickFlower(level, action)
	local scene = HomeScene:sharedInstance()
	local pos = scene:getPositionByLevel(level)
	local hand = GameGuideRunner:createHandClickAnim(action.handDelay, action.handFade)
	hand:setAnchorPoint(ccp(0, 1))
	hand:setPosition(ccp(pos.x + 10, pos.y - 80))
	if scene.worldScene.guideLayer then
		HomeScene:sharedInstance().worldScene.guideLayer:addChild(hand)
		released = false
	end
end

function GameGuideRunner:removeClickFlower()
	if released then return false, false end
	local scene = HomeScene:sharedInstance()
	released = true
	if scene.worldScene.guideLayer then
		scene.worldScene.guideLayer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runClickStart(startPanel, guide, action)
	local hand = GameGuideRunner:createHandClickAnim(action.handDelay, action.handFade)
	hand:setAnchorPoint(ccp(0, 1))
	local pos = startPanel.levelInfoPanel.startButton:getPositionInScreen()
	local size = startPanel.levelInfoPanel.startButton:getGroupBounds().size
	if startPanel.levelInfoPanel.userGuideLayer then
		pos = startPanel.levelInfoPanel.userGuideLayer:convertToNodeSpace(pos)
		hand:setPosition(ccp(pos.x + 65, pos.y - 10))
		startPanel.levelInfoPanel.userGuideLayer:addChild(hand)
		guide.layer = startPanel.levelInfoPanel.userGuideLayer
		released = false
	end
end

function GameGuideRunner:removeClickStart(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runSwap(caller, action)
	action.maskDelay = action.maskDelay or 0.4
	action.maskFade = action.maskFade or 0.4
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local trueMask = playUI:gameGuideMask(action.opacity, action.array, action.allow, false)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(playUI, action)
	local from, to = playUI:getPositionFromTo(action.from, action.to)
	local hand = GameGuideRunner:createSlidingHand(from, to, action.handDelay, action.handFade)
	local text = GameGuideRunner:createSkipButton(Localization:getInstance():getText("tutorial.skip.step"), action)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		layer:addChild(hand)
		layer:addChild(text)
		caller.layer = layer
		released = false
	end
end

function GameGuideRunner:removeSwap(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runShowObj(caller, action)
	action.maskDelay = action.maskDelay or 0.3
	action.maskFade = action.maskFade or 0.3
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local wPos
	if action.index == math.floor(action.index) then
		local tile = playUI.levelTargetPanel:getLevelTileByIndex(action.index)
		local pos = tile:getPosition()
		local size = tile:getGroupBounds().size
		wPos = tile:getParent():convertToWorldSpace(ccp(pos.x, pos.y - size.height + 50))
	else
		local tile1 = playUI.levelTargetPanel:getLevelTileByIndex(math.floor(action.index))
		local tile2 = playUI.levelTargetPanel:getLevelTileByIndex(math.floor(action.index) + 1)
		pos = ccp(tile1:getPositionX() + (tile2:getPositionX() - tile1:getPositionX()) * (action.index - math.floor(action.index)),
			tile1:getPositionY() + (tile2:getPositionY() - tile1:getPositionY()) * (action.index - math.floor(action.index)))
		local size = tile1:getGroupBounds().size
		wPos = tile1:getParent():convertToWorldSpace(ccp(pos.x, pos.y - size.height + 50))
	end
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, ccp(wPos.x, wPos.y),
		nil, false, action.width or 1, action.height or 1, true)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(playUI, action, true)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		caller.layer = layer
		released = false
	end
end

function GameGuideRunner:removeShowObj(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runHint(caller, action)
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer

	action.animPosY = action.animPosY or 800
	action.animScale = action.animScale or 1
	action.animRotate = action.animRotate or 0
	action.animDelay = action.animDelay or 0
	action.panOrigin = action.panOrigin or ccp(-450, 600)
	action.panFinal = action.panFinal or ccp(150, 600)
	action.panDelay = action.panDelay or 0.5
	action.text = action.text or ""

	local anim = CommonSkeletonAnimation:createTutorialMoveIn()
	local sprite = Sprite:createEmpty()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()

	sprite:setScale(action.animScale)
	sprite:setRotation(action.animRotate)
	if action.reverse then
		sprite:setScaleX(-action.animScale)
		sprite:setPositionX(180 * action.animScale)
	else
		sprite:setPositionX(vSize.width - 180 * action.animScale)
	end

	if type(action.animMatrixR) == "number" then
		sprite:setPositionY(playUI:getRowPosY(action.animMatrixR))
	else
		sprite:setPositionY(vOrigin.y + vSize.height - action.animPosY)
	end
	local function animPlay() sprite:addChild(anim) end
	sprite:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.animDelay), CCCallFunc:create(animPlay)))
	local panel = GameGuideRunner:createPanelMini(action.text)
	if type(action.panMatrixOriginR) == "number" then
		panel:setPosition(ccp(action.panOrigin.x, playUI:getRowPosY(action.panMatrixOriginR)))
	else
		panel:setPosition(ccp(action.panOrigin.x, vOrigin.y + vSize.height - action.panOrigin.y))
	end
	local function onComplete() GameGuide:sharedInstance():onGuideComplete() end
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(action.panDelay))
	if type(action.panMatrixFinalR) == "number" then
		array:addObject(CCEaseBackOut:create(CCMoveTo:create(0.2, ccp(action.panFinal.x, playUI:getRowPosY(action.panMatrixFinalR)))))
	else
		array:addObject(CCEaseBackOut:create(CCMoveTo:create(0.2, ccp(action.panFinal.x, vOrigin.y + vSize.height - action.panFinal.y))))
	end
	array:addObject(CCDelayTime:create(2.5))
	local function panFadeOut()
		if panel and not panel.isDisposed then
			local childrenList = {}
			panel:getVisibleChildrenList(childrenList)
			for __, v in pairs(childrenList) do
				v:runAction(CCFadeOut:create(0.5))
			end
		end
	end
	array:addObject(CCCallFunc:create(panFadeOut))
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(CCCallFunc:create(onComplete))
	panel:runAction(CCSequence:create(array))

	if layer then
		layer:addChild(sprite)
		layer:addChild(panel)
		caller.layer = layer
		released = false
	end
end

function GameGuideRunner:removeHint(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runEliminate(caller, action)
	action.r = action.r or 5
	action.c = action.c or 5
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer

	local anim = CommonSkeletonAnimation:createTutorialMoveIn2()
	anim.name = "animation"

	if layer then
		local pos = playUI:getGlobalPositionUnit(action.r, action.c)
		anim:setPosition(ccp(pos.x + 100, pos.y + 105))
		layer:addChild(anim)
		caller.layer = layer
		released = false
	end
end

function GameGuideRunner:removeEliminate(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		local anim = layer:getChildByName("animation")
		anim:stopAllActions()
		local function removeAll() layer:removeChildren(true) end
		anim:runAction(CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(300, 0)), CCCallFunc:create(removeAll)))
	end
	return true, true
end

function GameGuideRunner:runInfo(caller, action)
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.touchDelay = action.touchDelay or 0
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local wSize = Director:sharedDirector():getWinSize()
	local trueMask = LayerColor:create()
	trueMask:changeWidthAndHeight(wSize.width, wSize.height)
	trueMask:setTouchEnabled(true, 0, true)
	trueMask:setOpacity(0)
	trueMask:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.maskDelay), CCFadeTo:create(action.maskFade, action.opacity)))
	local function onTouch() GameGuide:sharedInstance():onGuideComplete() end
	local function onDelayOver() trueMask:ad(DisplayEvents.kTouchTap, onTouch) end
	trueMask:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.touchDelay), CCCallFunc:create(onDelayOver)))
	local panel = GameGuideRunner:createPanelL(action.text, true, action)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		caller.layer = layer
		released = false
	end
end

function GameGuideRunner:removeInfo(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runTile(caller, action)
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.touchDelay = action.touchDelay or 0
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local trueMask = playUI:gameGuideMask(action.opacity, action.array, {action.array[1]})
	trueMask:removeAllEventListeners()
	local function onTouch() GameGuide:sharedInstance():onGuideComplete() end
	local function beginTouch() trueMask:ad(DisplayEvents.kTouchTap, onTouch) end
	trueMask:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.touchDelay), CCCallFunc:create(beginTouch)))
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(playUI, action, true)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		caller.layer = layer
		released = false
	end
end

function GameGuideRunner:removeTile(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runShowUFO(caller, action)
	action.maskDelay = action.maskDelay or 0.3
	action.maskFade = action.maskFade or 0.3
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local pos = playUI:getPositionFromTo(action.position, action.position)
	action.deltaY = action.deltaY or 70
	pos.y = pos.y + action.deltaY
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, ccp(pos.x, pos.y), 1, false, action.width, action.height, action.oval)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(playUI, action, true)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		caller.layer = layer
		released = false
	end
end

function GameGuideRunner:removeShowUFO(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runMoveCount(caller, action)
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	-- local trueMask = playUI:gameGuideMask(action.opacity, action.array, {action.array[1]})
	action.opacity = action.opacity or 0xCC
	local pos = playUI:getMoveCountPos()
	action.posAdd = action.posAdd or ccp(0, 0)
	pos.x, pos.y = pos.x + action.posAdd.x, pos.y + action.posAdd.y
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, pos, nil, true, action.width, action.height)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(playUI, action, true)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		caller.layer = layer
		released = false
	end
end

function GameGuideRunner:removeMoveCount(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runContinue()
	GameGuide:sharedInstance():onGuideComplete()
end

function GameGuideRunner:removeContinue()
end

function GameGuideRunner:runPreProp(startPanel, caller, action)
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.maskPos = action.maskPos or ccp(0, 0)
	action.opacity = action.opacity or 0xCC
	action.radius = action.radius or 80
	action.index = action.index or 1
	action.multRadius = action.multRadius or 1
	local scene = HomeScene:sharedInstance()
	local target = startPanel.levelInfoPanel.preGameTools[action.index]
	local pos1 = startPanel.levelInfoPanel:getPrePropPositionByIndex(action.index)
	local pos2 = startPanel.levelInfoPanel:getPosition()
	local width = startPanel.levelInfoPanel.ui:getGroupBounds().size.width
	local wSize = Director:sharedDirector():getWinSize()
	local scale = startPanel:getScale()
	local posAdd = (wSize.width - width - pos2.x) / 2
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, ccp(pos1.x + posAdd, pos1.y), action.multRadius * scale)
	local function onTouchTap(evt)
		local dx, dy = evt.globalPosition.x - pos1.x - posAdd, evt.globalPosition.y - pos1.y
		if dx * dx + dy * dy < (action.radius * scale) * (action.radius * scale) then
			local event = {name = DisplayEvents.kTouchTap, context = action.index}
			startPanel.levelInfoPanel:onPreGameItemTapped(event)
		end
	end
	trueMask:ad(DisplayEvents.kTouchTap, onTouchTap)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(nil, action, true)
	local layer = Layer:create()
	caller.layer = layer
	layer:addChild(trueMask)
	layer:addChild(panel)
	if scene then
		scene:addChild(layer)
		released = false
	end
end

function GameGuideRunner:removePreProp(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:runStartInfo(startPanel, caller, action)
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.multRadius = action.multRadius or 1
	local scene = HomeScene:sharedInstance()
	local pos1 = startPanel.levelInfoPanel:getLevelTargetPosition()
	local pos2 = startPanel.levelInfoPanel:getPosition()
	local width = startPanel.levelInfoPanel.ui:getGroupBounds().size.width
	local wSize = Director:sharedDirector():getWinSize()
	local scale = startPanel:getScale()
	local posAdd = (wSize.width - width - pos2.x) / 2
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, ccp(pos1.x + posAdd, pos1.y), action.multRadius * scale)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(nil, action, true)
	local layer = Layer:create()
	caller.layer = layer
	layer:addChild(trueMask)
	layer:addChild(panel)
	if scene then
		scene:addChild(layer)
		released = false
	end
end

function GameGuideRunner:removeStartInfo(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:runTempProp(caller, action, skipClick)
	action.maskDelay = action.maskDelay or 0
	action.index = action.index or 1
	action.maskFade = action.maskFade or 0.3
	action.multRadius = action.multRadius or 1
	action.posAdd = action.posAdd or ccp(0, 0)

	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local pos = playUI:getPositionByIndex(action.index)
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, ccp(pos.x + action.posAdd.x, pos.y + action.posAdd.y), action.multRadius, nil, nil, nil, nil, skipClick)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(nil, action, not skipClick)
	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		caller.layer = layer
		released = false
	end
end

function GameGuideRunner:removeTempProp(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:runBeginnerPanel()
	local function onGet()
		GameGuide:sharedInstance():onGuideComplete()
	end
	if UserManager:getInstance().userExtend:getNewUserReward() == 0 then
		local panel = BeginnerPanel:create()
		if panel then
			panel:popout()
			released = false
		end
	else
		onGet()
	end
end

function GameGuideRunner:removeBeginnerPanel()
	-- 什么也不做
	if released then return true, false end
	released = true
	return true, true
end

function GameGuideRunner:runFruitTreeButton(caller, action)
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.maskPos = action.maskPos or ccp(0, 0)
	action.opacity = action.opacity or 0xCC
	action.radius = action.radius or 80
	action.index = action.index or 1
	local scene = HomeScene:sharedInstance()
	local button = scene.fruitTreeButton
	if not button then return end
	local pos = button:getPosition()
	local size = button:getGroupBounds().size
	pos = ccp(pos.x - size.width / 2 - 10, pos.y - size.height / 2 - 10)
	local layer = Layer:create()
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, pos, nil, true, size.width + 20, size.height + 20, false, true)
	local function onTouchTap(evt)
		layer.clicked = true
		local dx, dy = evt.globalPosition.x, evt.globalPosition.y
		if dx > pos.x and dy > pos.y and dx < pos.x + size.width and dy < pos.y + size.height then
			layer.success = true
			local event = {name = DisplayEvents.kTouchTap}
			button.wrapper:dispatchEvent(event)
		end
	end
	trueMask:removeAllEventListeners()
	trueMask:ad(DisplayEvents.kTouchTap, onTouchTap)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(nil, action)
	caller.layer = layer
	layer.success = false
	local position = trueMask:getPosition()
	local function onClicked() layer.clicked = true end
	local skip = self:createSkipButton(Localization:getInstance():getText("tutorial.skip.step"), action, true, onClicked)
	layer:addChild(trueMask)
	layer:addChild(skip)
	layer:addChild(panel)
	if scene.guideLayer then
		scene.guideLayer:addChild(layer)
		released = false
	end
end

function GameGuideRunner:removeFruitTreeButton(layer, key, value)
	if released then return false, false end
	released = true
	local buttonFail = true
	if key == "fruitTreeButton" then
		buttonFail = value
	end
	if layer and not layer.isDisposed then
		local clicked = layer.clicked
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
		return clicked, layer.success and buttonFail
	end
	return false, false
end

function GameGuideRunner:runWeeklyRaceButton(caller, action)
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.maskPos = action.maskPos or ccp(0, 0)
	action.opacity = action.opacity or 0xCC
	action.radius = action.radius or 80
	action.index = action.index or 1
	local scene = HomeScene:sharedInstance()
	local button = scene.weeklyRaceBtn
	if not button then return end
	local pos = button:getPosition()
	pos = button:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
	local size = button:getGroupBounds().size
	pos = ccp(pos.x - 10, pos.y - size.height - 10)
	local layer = Layer:create()
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, pos, nil, true, size.width + 20, size.height + 20, false)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(nil, action, true)
	caller.layer = layer
	layer.success = false
	local position = trueMask:getPosition()
	local function onClicked() layer.clicked = true end
	trueMask:addEventListener(DisplayEvents.kTouchTap, onClicked)
	layer:addChild(trueMask)
	layer:addChild(panel)
	if scene.guideLayer then
		scene.guideLayer:addChild(layer)
		released = false
	end
end

function GameGuideRunner:runRabbitWeeklyButton(caller, action)
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.maskPos = action.maskPos or ccp(0, 0)
	action.opacity = action.opacity or 0xCC
	action.radius = action.radius or 80
	action.index = action.index or 1
	local scene = HomeScene:sharedInstance()
	local button = scene.rabbitWeeklyButton
	if not button then return end
	local pos = button:getPosition()
	pos = button:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
	local size = button:getGroupBounds().size
	pos = ccp(pos.x - 10, pos.y - size.height - 20)
	local layer = Layer:create()
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, pos, nil, true, size.width + 20, size.height + 20, false)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(nil, action, true)
	caller.layer = layer
	layer.success = false
	local position = trueMask:getPosition()
	local function onClicked() layer.clicked = true end
	trueMask:addEventListener(DisplayEvents.kTouchTap, onClicked)
	layer:addChild(trueMask)
	layer:addChild(panel)
	if scene.guideLayer then
		scene.guideLayer:addChild(layer)
		released = false
	end
end

function GameGuideRunner:removeWeeklyRaceButton(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
		return layer.clicked, layer.clicked
	end
	return true, true
end

function GameGuideRunner:removeRabbitWeeklyButton(layer)
	if released then return false, false end
	released = true
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
		return layer.clicked, layer.clicked
	end
	return true, true
end

function GameGuideRunner:runClickFruit(caller, action)
	action.limitGrowCount = action.limitGrowCount or 5
	action.index = action.index or 4
	local scene = Director:sharedDirector():getRunningScene()
	local info = {}
	if scene and scene.tree and not scene.tree.isDisposed then
		info = scene.tree:getGuideInfo()
	end
	if #info < action.index then
		GameGuide:sharedInstance():onGuideComplete()
		return
	end
	for k, v in pairs(info) do
		if v.growCount < action.limitGrowCount then
			GameGuide:sharedInstance():onGuideComplete()
			return
		end
	end
	local scene = Director:sharedDirector():getRunningScene()
	local hand = GameGuideRunner:createHandClickAnim(action.handDelay, action.handFade)
	local pos = info[action.index].position
	hand:setAnchorPoint(ccp(0, 1))
	hand:setPosition(ccp(pos.x, pos.y + 20))
	if scene.guideLayer then
		scene.guideLayer:addChild(hand)
		released = false
	end
end

function GameGuideRunner:removeClickFruit(disappear)
	if released then return true, false end
	local scene = Director:sharedDirector():getRunningScene()
	released = true
	if scene and scene.guideLayer then
		scene.guideLayer:removeChildren(true)
	end
	local index = 4
	for k, v in ipairs(disappear) do
		if v.type == "fruitClicked" then index = v.index break end
	end
	return true, GameGuide:sharedInstance():getFruitClicked() == index
end

function GameGuideRunner:runFruitButton(caller, action)
	local scene = Director:sharedDirector():getRunningScene()
	if not scene then return end
	local layer = Layer:create()
	caller.layer = layer
	local panel = GameGuideRunner:createPanelS(nil, action)
	local skip = self:createSkipButton(Localization:getInstance():getText("tutorial.skip.step"), action, true)
	layer:addChild(skip)
	layer:addChild(panel)
	if scene.guideLayer then
		scene.guideLayer:addChild(layer)
		released = false
	end
end

function GameGuideRunner:removeFruitButton()
	if released then return false, false end
	local scene = Director:sharedDirector():getRunningScene()
	released = true
	if scene.guideLayer then
		if scene.tree and not scene.tree.isDisposed then
			scene.tree:endFruitTreeGuide()
		end
		scene.guideLayer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:createTurnTableSlide(panel, disk, caller, action)
	action.delay = action.delay or 0.4
	local position = disk:getDiskPosition()
	local radius = disk:getDiskRadius()
	local diskRes = disk:getDiskRes()
	local from = {x = 0, y = radius / 2}
	local to = {x = 0, y = -radius / 2}
	print(from.x, from.y, to.x, to.y)
	local distance = radius / 2
	
	local scene = Director:sharedDirector():getRunningScene()
	local wSize = Director:sharedDirector():getWinSize()
	local layer = Layer:create()
	local hand = GameGuideRunner:createCurveSlidingHand(from, to, distance, action.delay)
	layer:addChild(hand)
	layer:setPositionXY(position.x, position.y)
	local function onTouch(evt)
		diskRes:removeEventListener(DisplayEvents.kTouchBegin, onTouch)
		GameGuide:sharedInstance():onGuideComplete()
	end
	diskRes:addEventListener(DisplayEvents.kTouchBegin, onTouch)
	if panel.userGuideLayer then
		panel.userGuideLayer:addChild(layer)
		caller.layer = layer
		released = false
	else layer:dispose() end
end

function GameGuideRunner:removeTurnTableSlide(layer)
	if released then return false, false end
	if layer and not layer.isDisposed then layer:removeFromParentAndCleanup(true) end
	return true, true
end

function GameGuideRunner:createHandClickAnim(delay, fade)
	delay = delay or 1.8
	fade = fade or 0.1
	local anim = Sprite:createEmpty()
	local hand1 = Sprite:createWithSpriteFrameName("guide_hand_up0000")
	local hand2 = Sprite:createWithSpriteFrameName("guide_hand_down0000")
	local ring = Sprite:createWithSpriteFrameName("guide_hand_ring0000")
	hand1:setAnchorPoint(ccp(1, 0))
	hand2:setAnchorPoint(ccp(1, 0))
	ring:setAnchorPoint(ccp(0.5, 0.5))
	hand1:setPosition(ccp(150, -120))
	hand2:setPosition(ccp(150, -120))
	hand1:runAction(CCMoveBy:create(0, ccp(40, -80)))
	hand1:setOpacity(0)
	hand2:setOpacity(0)
	ring:setOpacity(0)

	local function onDelayOver()
		local actions1 = CCArray:create()
		actions1:addObject(CCFadeIn:create(fade))
		actions1:addObject(CCDelayTime:create(0.2))
		actions1:addObject(CCMoveBy:create(0.2, ccp(-40, 80)))
		actions1:addObject(CCRotateBy:create(0.2, 20))
		actions1:addObject(CCDelayTime:create(0.1))
		actions1:addObject(CCFadeOut:create(0))
		actions1:addObject(CCDelayTime:create(0.2))
		actions1:addObject(CCRotateBy:create(0, -20))
		actions1:addObject(CCDelayTime:create(fade + 2))
		actions1:addObject(CCMoveBy:create(0, ccp(40, -80)))
		hand1:runAction(CCRepeatForever:create(CCSequence:create(actions1)))
		local actions2 = CCArray:create()
		actions2:addObject(CCDelayTime:create(0.7 + fade))
		actions2:addObject(CCFadeIn:create(0))
		actions2:addObject(CCDelayTime:create(0.2))
		actions2:addObject(CCFadeOut:create(fade))
		actions2:addObject(CCDelayTime:create(2))
		hand2:runAction(CCRepeatForever:create(CCSequence:create(actions2)))
		local action3 = CCArray:create()
		action3:addObject(CCDelayTime:create(0.7 + fade))
		action3:addObject(CCScaleTo:create(0, 0.1))
		action3:addObject(CCFadeIn:create(0))
		action3:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.2 + fade, 1.3), CCFadeOut:create(0.2 + fade)))
		action3:addObject(CCDelayTime:create(2))
		ring:runAction(CCRepeatForever:create(CCSequence:create(action3)))
	end

	anim:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delay), CCCallFunc:create(onDelayOver)))

	anim:addChild(hand1)
	anim:addChild(hand2)
	anim:addChildAt(ring, 0)
	return anim
end

function GameGuideRunner:createSlidingHand(from, to, delay, fade)
	delay = delay or 0.9
	fade = fade or 0.1
	local anim = Sprite:createEmpty()
	local hand1 = Sprite:createWithSpriteFrameName("guide_hand_up0000")
	local hand2 = Sprite:createWithSpriteFrameName("guide_hand_down0000")
	local ring = Sprite:createWithSpriteFrameName("guide_hand_ring0000")
	hand1:setAnchorPoint(ccp(1, 0))
	hand2:setAnchorPoint(ccp(1, 0))
	ring:setAnchorPoint(ccp(0.5, 0.5))
	hand1:setPosition(ccp(150, -120))
	hand2:setPosition(ccp(150, -120))
	hand1:setOpacity(0)
	hand2:setOpacity(0)
	ring:setOpacity(0)
	anim:addChild(hand1)
	anim:addChild(hand2)
	anim:addChildAt(ring, 0)
	anim:setPosition(ccp(from.x, from.y))

	local function onDelayOver()
		local actions1 = CCArray:create()
		actions1:addObject(CCFadeIn:create(fade))
		actions1:addObject(CCDelayTime:create(0.2))
		actions1:addObject(CCRotateBy:create(0.1, 20))
		actions1:addObject(CCRotateBy:create(0.1, -20))
		actions1:addObject(CCFadeOut:create(0))
		actions1:addObject(CCDelayTime:create(2.8 + fade))
		hand1:runAction(CCRepeatForever:create(CCSequence:create(actions1)))
		local actions2 = CCArray:create()
		actions2:addObject(CCDelayTime:create(0.4 + fade))
		actions2:addObject(CCFadeIn:create(0))
		actions2:addObject(CCDelayTime:create(0.8))
		actions2:addObject(CCFadeOut:create(fade))
		actions2:addObject(CCDelayTime:create(2))
		hand2:runAction(CCRepeatForever:create(CCSequence:create(actions2)))
		local actions3 = CCArray:create()
		actions3:addObject(CCDelayTime:create(0.4 + fade))
		actions3:addObject(CCScaleTo:create(0, 0.1))
		actions3:addObject(CCFadeIn:create(0))
		actions3:addObject(CCScaleTo:create(0.1, 1.3))
		actions3:addObject(CCScaleTo:create(0.1, 1))
		actions3:addObject(CCDelayTime:create(0.6))
		actions3:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(fade, 1.3), CCFadeOut:create(fade)))
		actions3:addObject(CCDelayTime:create(2))
		ring:runAction(CCRepeatForever:create(CCSequence:create(actions3)))
		local action = CCArray:create()
		action:addObject(CCMoveTo:create(0, ccp(from.x, from.y)))
		action:addObject(CCDelayTime:create(0.7 + fade))
		action:addObject(CCMoveTo:create(0.5, ccp(to.x, to.y)))
		action:addObject(CCDelayTime:create(fade + 2))
		anim:runAction(CCRepeatForever:create(CCSequence:create(action)))
	end

	anim:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delay), CCCallFunc:create(onDelayOver)))

	return anim
end

function GameGuideRunner:createCurveSlidingHand(from, to, distance, delay)
	delay = delay or 0.9
	fade = fade or 0.1
	local anim = Sprite:createEmpty()
	local hand1 = Sprite:createWithSpriteFrameName("guide_hand_up0000")
	local hand2 = Sprite:createWithSpriteFrameName("guide_hand_down0000")
	local ring = Sprite:createWithSpriteFrameName("guide_hand_ring0000")
	hand1:setAnchorPoint(ccp(1, 0))
	hand2:setAnchorPoint(ccp(1, 0))
	ring:setAnchorPoint(ccp(0.5, 0.5))
	hand1:setPosition(ccp(150, -120))
	hand2:setPosition(ccp(150, -120))
	hand1:setOpacity(0)
	hand2:setOpacity(0)
	ring:setOpacity(0)
	anim:addChild(hand1)
	anim:addChild(hand2)
	anim:addChildAt(ring, 0)
	anim:setPosition(ccp(from.x, from.y))
	print(from.x, from.y)

	local function onDelayOver()
		local actions1 = CCArray:create()
		actions1:addObject(CCFadeIn:create(fade))
		actions1:addObject(CCDelayTime:create(0.2))
		actions1:addObject(CCRotateBy:create(0.1, 20))
		actions1:addObject(CCRotateBy:create(0.1, -20))
		actions1:addObject(CCFadeOut:create(0))
		actions1:addObject(CCDelayTime:create(3.3 + fade))
		hand1:runAction(CCRepeatForever:create(CCSequence:create(actions1)))
		local actions2 = CCArray:create()
		actions2:addObject(CCDelayTime:create(0.4 + fade))
		actions2:addObject(CCFadeIn:create(0))
		actions2:addObject(CCDelayTime:create(1.3))
		actions2:addObject(CCFadeOut:create(fade))
		actions2:addObject(CCDelayTime:create(2))
		hand2:runAction(CCRepeatForever:create(CCSequence:create(actions2)))
		local actions3 = CCArray:create()
		actions3:addObject(CCDelayTime:create(0.4 + fade))
		actions3:addObject(CCScaleTo:create(0, 0.1))
		actions3:addObject(CCFadeIn:create(0))
		actions3:addObject(CCScaleTo:create(0.1, 1.3))
		actions3:addObject(CCScaleTo:create(0.1, 1))
		actions3:addObject(CCDelayTime:create(1.1))
		actions3:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(fade, 1.3), CCFadeOut:create(fade)))
		actions3:addObject(CCDelayTime:create(2))
		ring:runAction(CCRepeatForever:create(CCSequence:create(actions3)))
		local action = CCArray:create()
		action:addObject(CCMoveTo:create(0, ccp(from.x, from.y)))
		action:addObject(CCDelayTime:create(0.7 + fade))
		local function bezier()
			anim:runAction(HeBezierTo:create(1, ccp(to.x, to.y), distance > 0, math.abs(distance)))
		end
		action:addObject(CCCallFunc:create(bezier))
		action:addObject(CCDelayTime:create(1))
		action:addObject(CCDelayTime:create(fade + 2))
		anim:runAction(CCRepeatForever:create(CCSequence:create(action)))
	end

	anim:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delay), CCCallFunc:create(onDelayOver)))

	return anim
end

local animalType = {["horse"] = 1, ["frog"] = 2, ["bear"] = 3, ["cat"] = 4, ["fox"] = 5, ["chicken"] = 6, ["color"] = 7}
local specialType = {["normal"] = 1, ["line"] = 7, ["column"] = 6, ["wrap"] = 8}

-----------------------------------------------------------
-- L = Large
-- S = Small
-- D = Down 浣熊位置
-- U = Up
-- R = Right

function GameGuideRunner:createPanelS(playUI, action, skipText)
	local panel
	if action.panFlip then
		if action.panType == "down" then
			panel = GameGuideRunner:createPanelSDR(action.text, skipText, action.prefHeight)
		else
			panel = GameGuideRunner:createPanelSUR(action.text, skipText, action.prefHeight)
		end
	else
		if action.panType == "down" then
			panel = GameGuideRunner:createPanelSD(action.text, skipText, action.prefHeight)
		else
			panel = GameGuideRunner:createPanelSU(action.text, skipText, action.prefHeight)
		end
	end
	panel.onEnterHandler = function(self) end -- 覆盖原方法

	if action.panImage then
		for __, v in ipairs(action.panImage) do
			local sprite = Sprite:createWithSpriteFrameName(v.image)
			v.scale = v.scale or ccp(1, 1)
			sprite:setScaleX(v.scale.x)
			sprite:setScaleY(v.scale.y)
			v.x = v.x or 0
			v.y = v.y or 0
			sprite:setPosition(ccp(v.x, v.y))
			panel:addChild(sprite)
		end
	end

	local anim = {}
	if action.panAnimal then
		for __, v in ipairs(action.panAnimal) do
			local sprite = nil
			if v.animal == "color" then
				sprite = TileBird:create()
  				sprite:play(1)
  				table.insert(anim, sprite)
  			elseif specialType[v.special] > 1 then
  				sprite = TileCharacter:create(v.animal)
  				sprite:play(specialType[v.special])
  				table.insert(anim, sprite)
  			else
  				local key = string.format("StaticItem%02d.png", animalType[v.animal])
				sprite = Sprite:createWithSpriteFrameName(key);
  			end
  			v.scale = v.scale or ccp(1, 1)
			sprite:setScaleX(v.scale.x)
			sprite:setScaleY(v.scale.y)
			v.x = v.x or 0
			v.y = v.y or 0
			sprite:setPosition(ccp(v.x, v.y))
			panel:addChild(sprite)
		end
	end
	
	if action.panAlign == "matrixU" and playUI then
		local pos = playUI:getRowPosY(action.panPosY)
		panel:setPosition(ccp(panel:getPosition().x, pos + panel.ui:getGroupBounds().size.height))
	elseif action.panAlign == "matrixD" and playUI then
		local pos = playUI:getRowPosY(action.panPosY)
		panel:setPosition(ccp(panel:getPosition().x, pos))
	elseif action.panAlign == "winY" then
		panel:setPosition(ccp(panel:getPosition().x, action.panPosY))
	elseif action.panAlign == "viewY" then
		panel:setPosition(ccp(panel:getPosition().x, action.panPosY + Director:sharedDirector():getVisibleOrigin().y))
	end

	action.panDelay = action.panDelay or 0.8
	action.panFade = action.panFade or 0.2
	local childrenList = {}
	panel:getVisibleChildrenList(childrenList)
	for __, v in pairs(childrenList) do
		v:setOpacity(0)
		v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.panDelay), CCFadeIn:create(action.panFade)))
	end
	for __, v in ipairs(anim) do
		local list = nil
		if v.name == "TileBird" then
			list = v:getChildrenList()
		else
			list = v:getChildByName("tileEffect"):getChildrenList()
			table.insert(list, v.mainSprite)
		end
		for __, v2 in pairs(list) do
			v2:setOpacity(0)
			v2:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.panDelay), CCFadeIn:create(action.panFade)))
		end

		-- local list = v:getChildrenList()
		-- for __, v2 in pairs(list) do
		-- 	print(v2.name)
		-- 	if v2.name ~= kHitAreaObjectName then
		-- 		v2:setOpacity(0)
		-- 		v2:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.panDelay), CCFadeIn:create(action.panFade)))
		-- 	end
		-- end
	end
	local target = panel:getChildByName("animation")
	if action.panFlip then
		target = target:getChildByName("animation")
	end
	target:setOpacity(0)
	target:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.panDelay), CCFadeIn:create(action.panFade)))
	-- panel:setOpacity(0)
	-- panel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.panDelay), CCFadeIn:create(action.panFade)))

	return panel
end

function GameGuideRunner:createPanelSD(text, skipText, prefHeight)
	local wSize = Director:sharedDirector():getWinSize()
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelS")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	prefHeight = prefHeight or 0
	if prefHeight ~= 0 then
		local background = panel.ui:getChildByName("bg")
		
	end
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setString(str)
	if skipText then
		panel.ui:getChildByName("skiptext"):setString(Localization:getInstance():getText("game.guide.panel.skip.text"))
	else
		panel.ui:getChildByName("skiptext"):setVisible(false)
		panel.ui:getChildByName("skipicon"):setVisible(false)
	end
	local size = panel:getGroupBounds().size
	-- panel:setPosition(ccp((wSize.width - size.width) / 2, wSize.height / 2))
	panel:setPosition(ccp(panel:getHCenterInScreenX(), panel:getVCenterInScreenY()))
	local animation = CommonSkeletonAnimation:createTutorialDown()
	animation.name = "animation"
	animation:setPosition(ccp(390, 36))
	panel:addChild(animation)
	return panel
end

function GameGuideRunner:createPanelSU(text, skipText)
	local wSize = Director:sharedDirector():getWinSize()
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelS")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setString(str)
	if skipText then
		panel.ui:getChildByName("skiptext"):setString(Localization:getInstance():getText("game.guide.panel.skip.text"))
	else
		panel.ui:getChildByName("skiptext"):setVisible(false)
		panel.ui:getChildByName("skipicon"):setVisible(false)
	end
	local size = panel:getGroupBounds().size
	-- panel:setPosition(ccp((wSize.width - size.width) / 2, wSize.height / 2))
	panel:setPosition(ccp(panel:getHCenterInScreenX(), panel:getVCenterInScreenY()))
	local animation = CommonSkeletonAnimation:createTutorialUp()
	animation.name = "animation"
	animation:setPosition(ccp(433, 27))
	panel:addChild(animation)
	return panel
end

function GameGuideRunner:createPanelSDR(text, skipText)
	local wSize = Director:sharedDirector():getWinSize()
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelSR")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setString(str)
	if skipText then
		panel.ui:getChildByName("skiptext"):setString(Localization:getInstance():getText("game.guide.panel.skip.text"))
	else
		panel.ui:getChildByName("skiptext"):setVisible(false)
		panel.ui:getChildByName("skipicon"):setVisible(false)
	end
	local size = panel:getGroupBounds().size
	-- panel:setPosition(ccp((wSize.width - size.width) / 2, wSize.height / 2))
	panel:setPosition(ccp(panel:getHCenterInScreenX() + 20, panel:getVCenterInScreenY()))
	local animation = CommonSkeletonAnimation:createTutorialDown()
	animation.name = "animation"
	local sprite = CocosObject:create()
	sprite:addChild(animation)
	sprite:setScaleX(-1)
	sprite:setPosition(ccp(270, 38))
	sprite.name = "animation"
	panel:addChild(sprite)
	return panel
end

function GameGuideRunner:createPanelSUR(text, skipText)
	local wSize = Director:sharedDirector():getWinSize()
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelSR")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setString(str)
	if skipText then
		panel.ui:getChildByName("skiptext"):setString(Localization:getInstance():getText("game.guide.panel.skip.text"))
	else
		panel.ui:getChildByName("skiptext"):setVisible(false)
		panel.ui:getChildByName("skipicon"):setVisible(false)
	end
	local size = panel:getGroupBounds().size
	-- panel:setPosition(ccp((wSize.width - size.width) / 2, wSize.height / 2))
	panel:setPosition(ccp(panel:getHCenterInScreenX() + 20, panel:getVCenterInScreenY()))
	local animation = CommonSkeletonAnimation:createTutorialUp()
	animation.name = "animation"
	local sprite = CocosObject:create()
	sprite:addChild(animation)
	sprite:setScaleX(-1)
	sprite:setPosition(ccp(230, 27))
	sprite.name = "animation"
	panel:addChild(sprite)
	return panel
end

function GameGuideRunner:createPanelL(text, skipText, action)
	local wSize = Director:sharedDirector():getWinSize()
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelL")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setString(str)
	if skipText then
		panel.ui:getChildByName("skiptext"):setString(Localization:getInstance():getText("game.guide.panel.skip.text"))
	else
		panel.ui:getChildByName("skiptext"):setVisible(false)
		panel.ui:getChildByName("skipicon"):setVisible(false)
	end

	if action.panImage then
		for __, v in ipairs(action.panImage) do
			local sprite = Sprite:createWithSpriteFrameName(v.image)
			sprite:setScaleX(v.scale.x)
			sprite:setScaleY(v.scale.y)
			sprite:setPosition(ccp(v.x, v.y))
			panel:addChild(sprite)
		end
	end

	local anim = {}
	if action.panAnimal then
		for __, v in ipairs(action.panAnimal) do
			local sprite = nil
			if v.animal == "color" then
				sprite = TileBird:create()
  				sprite:play(1)
  				table.insert(anim, sprite)
  			elseif specialType[v.special] > 1 then
  				sprite = TileCharacter:create(v.animal)
  				sprite:play(specialType[v.special], action.panDelay)
  				table.insert(anim, sprite)
  			else
  				local key = string.format("StaticItem%02d.png", animalType[v.animal])
				sprite = Sprite:createWithSpriteFrameName(key);
  			end
  			v.scale = v.scale or ccp(1, 1)
			sprite:setScaleX(v.scale.x)
			sprite:setScaleY(v.scale.y)
			v.x = v.x or 0
			v.y = v.y or 0
			sprite:setPosition(ccp(v.x, v.y))
			panel:addChild(sprite)
		end
	end

	-- panel:setPosition(ccp((wSize.width - size.width) / 2, wSize.height / 2))
	panel:setPosition(ccp(panel:getHCenterInScreenX(), panel:getVCenterInScreenY()))
	local animation = CommonSkeletonAnimation:createTutorialNormal()
	animation.name = "animation"
	animation:setPosition(ccp(450, -530))

	action.panDelay = action.panDelay or 0.3
	action.panFade = action.panFade or 0.2

	for __, v in ipairs(anim) do
		local list = nil
		if v.name == "TileBird" then
			list = v:getChildrenList()
		else
			list = v:getChildByName("tileEffect"):getChildrenList()
			table.insert(list, v.mainSprite)
		end
		for __, v2 in pairs(list) do
			v2:setOpacity(0)
			v2:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.panDelay), CCFadeIn:create(action.panFade)))
		end

		-- local list = v:getChildrenList()
		-- for __, v2 in pairs(list) do
		-- 	print(v2.name)
		-- 	if v2.name ~= kHitAreaObjectName then
		-- 		v2:setOpacity(0)
		-- 		v2:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.panDelay), CCFadeIn:create(action.panFade)))
		-- 	end
		-- end
	end
	panel:addChild(animation)
	local childrenList = {}
	panel:getVisibleChildrenList(childrenList)
	for __, v in pairs(childrenList) do
		v:setOpacity(0)
		v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.panDelay), CCFadeIn:create(action.panFade)))
	end
	return panel
end

function GameGuideRunner:createPanelMini(text)
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelM")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setString(str)
	return panel
end

function GameGuideRunner:createMask(opacity, touchDelay, position, radius, square, width, height, oval, skipClick)
	touchDelay = touchDelay or 0
	local wSize = CCDirector:sharedDirector():getWinSize()
	local mask = LayerColor:create()
	mask:changeWidthAndHeight(wSize.width, wSize.height)
	mask:setColor(ccc3(0, 0, 0))
	mask:setOpacity(opacity)
	mask:setPosition(ccp(0, 0))

	local node
	if square then
		node = LayerColor:create()
		width = width or 50
		height = height or 40
		node:changeWidthAndHeight(width, height)
	elseif oval then
		node = Sprite:createWithSpriteFrameName("circle0000")
		width, height = width or 1, height or 1
		node:setScaleX(width)
		node:setScaleY(height)
	else
		node = Sprite:createWithSpriteFrameName("circle0000")
		radius = radius or 1
		node:setScale(radius)
	end
	node:setPosition(ccp(position.x, position.y))
	local blend = ccBlendFunc()
	blend.src = GL_ZERO
	blend.dst = GL_ONE_MINUS_SRC_ALPHA
	node:setBlendFunc(blend)
	mask:addChild(node)

	local layer = CCRenderTexture:create(wSize.width, wSize.height)
	layer:setPosition(ccp(wSize.width / 2, wSize.height / 2))
	layer:begin()
	mask:visit()
	layer:endToLua()
	if __WP8 then layer:saveToCache() end

	mask:dispose()

	local layerSprite = layer:getSprite()
	local obj = CocosObject.new(layer)
	local trueMaskLayer = Layer:create()
	trueMaskLayer:addChild(obj)
	trueMaskLayer:setTouchEnabled(true, 0, true)
	local function onTouch() GameGuide:sharedInstance():onGuideComplete() end
	local function beginSetTouch() trueMaskLayer:ad(DisplayEvents.kTouchTap, onTouch) end
	local arr = CCArray:create()
	print("skipClick", skipClick)
	if not skipClick then
		trueMaskLayer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(touchDelay), CCCallFunc:create(beginSetTouch)))
	end
	trueMaskLayer.setFadeIn = function(maskDelay, maskFade)
		layerSprite:setOpacity(0)
		layerSprite:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(maskDelay), CCFadeIn:create(maskFade)))
	end	
	trueMaskLayer.layerSprite = layerSprite
	return trueMaskLayer
end

function GameGuideRunner:createSkipButton(skipText, action, notSkipLevel, callback)
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local layer = LayerColor:create()
	layer:setOpacity(0)
	layer:changeWidthAndHeight(200, 80)
	layer:setPosition(ccp(0, vOrigin.y + vSize.height - 50))
	local function onTouch()
		if callback then callback() end
		GameGuide:sharedInstance():onGuideComplete(not notSkipLevel)
	end
	layer:setTouchEnabled(true, 0, true)
	layer:ad(DisplayEvents.kTouchTap, onTouch)
	layer:setOpacity(0)

	local text = TextField:create(skipText, nil, 32)
	text:setPosition(ccp(50, 25))
	text:setColor(ccc3(136, 255, 136))
	text:setOpacity(0)
	text:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.maskDelay), CCFadeIn:create(action.maskFade)))
	layer:addChild(text)

	return layer
end

function GameGuideRunner:runGiveProp(caller, action)
	print('**************** GameGuideRunner:runGiveProp')
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.maskPos = action.maskPos or ccp(0, 0)
	action.opacity = action.opacity or 0xCC
	action.radius = action.radius or 80
	action.index = action.index or 1
	local playUI = Director:sharedDirector():getRunningScene()

	local itemId = action.propId

	local item = playUI.propList:findItemByItemID(itemId).item
	local itemPos = item:getParent():convertToWorldSpace(item:getPosition())

	local size = playUI.propList:findItemByItemID(itemId).item:getGroupBounds().size
	local pos = ccp(itemPos.x - 50 + size.width / 2, itemPos.y - 20 + size.height / 2)
	local layer = Layer:create()
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, pos, 1.5, false, nil, nil, false)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(nil, action, true)
	caller.layer = layer
	layer.success = false
	local position = trueMask:getPosition()
	layer:addChild(trueMask)
	layer:addChild(panel)
	layer.panel = panel

	if playUI.guideLayer then
		playUI.guideLayer:addChild(layer)
		released = false
	end
end

function GameGuideRunner:removeGiveProp(caller)
	print('**************** GameGuideRunner:removeGiveProp')
	if released then return false, false end
	released = true
	local layer = caller.layer
	local action = caller.currentGuide.action[caller.guideIndex]
	local playUI = Director:sharedDirector():getRunningScene()
	local propId = action.tempPropId
	local num = action.count
	local pos = caller.layer.panel:convertToWorldSpace(ccp(action.panImage[1].x, action.panImage[1].y))

	playUI:addTemporaryItem(propId, num, pos)
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:runShowProp(caller, action)
	print('**************** GameGuideRunner:runShowProp')
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.maskPos = action.maskPos or ccp(0, 0)
	action.opacity = action.opacity or 0xCC
	action.radius = action.radius or 80
	action.index = action.index or 1

	local offsetX = action.offsetX or 0
	local offsetY = action.offsetY or 0

	local playUI = Director:sharedDirector():getRunningScene()

	local itemId = action.propId

	local item = nil
	if itemId == 9999 then
		item = playUI.propList:findSpringItem()
	else
		item = playUI.propList:findItemByItemID(itemId).item
	end

	if not item then return end

	local itemPos = item:getParent():convertToWorldSpace(item:getPosition())

	local size = item:getGroupBounds().size
	local pos = ccp(itemPos.x - 50 + size.width / 2 + offsetX, itemPos.y - 20 + size.height / 2 + offsetY)
	local layer = Layer:create()
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, pos, 1.5, false, nil, nil, false)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(nil, action, true)
	caller.layer = layer
	layer.success = false
	local position = trueMask:getPosition()
	layer:addChild(trueMask)
	layer:addChild(panel)

	if playUI.guideLayer then
		playUI.guideLayer:addChild(layer)
		released = false
	end
end

function GameGuideRunner:runShowCustomizeArea(caller, action)
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.maskPos = action.maskPos or ccp(0, 0)
	action.opacity = action.opacity or 0xCC
	action.radius = action.radius or 80
	action.index = action.index or 1
	local playUI = Director:sharedDirector():getRunningScene()

	local offsetX = action.offsetX
	local offsetY = action.offsetY

	local pos = ccp(action.position.x + offsetX, action.position.y + offsetY)
	local layer = Layer:create()
	local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, pos, nil, true, action.width, action.height, false)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideRunner:createPanelS(playUI, action, true)
	caller.layer = layer
	layer.success = false
	local position = trueMask:getPosition()
	layer:addChild(trueMask)
	layer:addChild(panel)

	if playUI.guideLayer then
		playUI.guideLayer:addChild(layer)
		released = false
	end
end

function GameGuideRunner:removeShowCustomizeArea(caller)
	print('**************** GameGuideRunner:removeShowCustomizeArea')
	if released then return false, false end
	released = true
	local layer = caller.layer
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:removeShowProp(caller)
	print('**************** GameGuideRunner:removeShowProp')
	if released then return false, false end
	released = true
	local layer = caller.layer
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:runShowUnlock(caller, action)
	print('*************** GameGuideRunner:runShowUnlock')
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.maskPos = action.maskPos or ccp(0, 0)
	action.opacity = action.opacity or 0xCC
	action.radius = action.radius or 80
	action.index = action.index or 1
	local playUI = Director:sharedDirector():getRunningScene()
	local vo = Director:sharedDirector():getVisibleOrigin()
	local vs = Director:sharedDirector():getVisibleSize()

	local worldScene = HomeScene:sharedInstance().worldScene

	if worldScene.maskedLayer.moving then return end

	local cloudId = action.cloudId

	local layer = Layer:create()
	caller.layer = layer
	if playUI.guideLayer then
		playUI.guideLayer:addChild(layer)
		released = false
	end

	worldScene:setTouchEnabled(false)
	layer.clicked = false
	layer.success = false

	local function callback()
		worldScene:setTouchEnabled(true)
		if not layer or layer.isDisposed then
			return
		end

		local cloud
		for k, v in pairs(worldScene.lockedClouds) do
			if v.id == cloudId then
				cloud = v
				break
			end
		end
		local cloudPos = cloud:getParent():convertToWorldSpace(cloud:getPosition())

		local lock = cloud.lock
		local pos
		if lock and not lock.isDisposed and lock:getParent() then
			local lockPos = lock:getParent():convertToWorldSpace(lock:getPosition())
			pos = ccp(lockPos.x, lockPos.y)
		else
			pos = ccp(vo.x + vs.width / 2, cloudPos.y - cloud:getGroupBounds().size.height/2)
		end
		local trueMask = GameGuideRunner:createMask(action.opacity, action.touchDelay, pos, 2, false, 5, 2, false, true)

		local function onTouchTap(evt)
			local dx, dy = evt.globalPosition.x, evt.globalPosition.y
			layer.clicked = true
			layer.success = true
			if math.abs(ccpDistance(ccp(dx, dy), pos)) <= 128 then -- 128是遮罩圆形的半径				
				local event = {name = DisplayEvents.kTouchTap}
				cloud:dispatchEvent(event)
			end
			GameGuide:sharedInstance():onGuideComplete()
		end
		trueMask:removeAllEventListeners()
		trueMask:ad(DisplayEvents.kTouchTap, onTouchTap)

		trueMask.setFadeIn(action.maskDelay, action.maskFade)
		local panel = GameGuideRunner:createPanelS(nil, action, true)
		local position = trueMask:getPosition()
		layer:addChild(trueMask)
		layer:addChild(panel)

		local hand = GameGuideRunner:createHandClickAnim(0.5, 0.3)
        hand:setAnchorPoint(ccp(0, 1))
        hand:setPosition(pos)
        layer:addChild(hand)
	end

	worldScene:moveCloudLockToCenter(cloudId, callback)

	
end

function GameGuideRunner:removeShowUnlock(caller)
	print('**************** GameGuideRunner:removeShowUnlock')
	if released then return false, false end
	released = true
	local layer = caller.layer
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return layer.clicked, layer.success
end