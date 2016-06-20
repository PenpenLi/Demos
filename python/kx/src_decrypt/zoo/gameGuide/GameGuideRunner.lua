require "zoo.gameGuide.GameGuideAnims"
require "zoo.gameGuide.GameGuideUI"

GameGuideRunner = {}

local released = true -- 标志是否已经被调用释放函数，和瓢虫动画共同引起的栈溢出找出具体原因之前使用此方法暴力解决

function GameGuideRunner:runGuide(paras)
	local action = GameGuideData:sharedInstance():getRunningAction()
	local funcName = "run" .. string.upper(string.sub(action.type, 1, 1)) .. string.sub(action.type, 2)
	if type(self[funcName]) == "function" then
		self[funcName](self, paras)
	else
		assert(false, "Invalid game guide action type: "..tostring(action.type))
	end
end

function GameGuideRunner:removeGuide(paras)
	local action = GameGuideData:sharedInstance():getRunningAction()
	local funcName = "remove" .. string.upper(string.sub(action.type, 1, 1)) .. string.sub(action.type, 2)
	if type(self[funcName]) == "function" then
		return self[funcName](self, paras)
	else
		assert(false, "Invalid game guide action type: "..tostring(action.type))
		return false, false
	end
end

function GameGuideRunner:runClickFlower()
	local action = GameGuideData:sharedInstance():getRunningAction()
	local scene = HomeScene:sharedInstance()
	local pos = scene:getPositionByLevel(action.para)
	local hand = GameGuideAnims:handclickAnim(action.handDelay, action.handFade)
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

function GameGuideRunner:runStartPanel(paras)
	if not paras or type(paras) ~= "table" then return end
	local action = GameGuideData:sharedInstance():getRunningAction()
	local hand = GameGuideAnims:handclickAnim(action.handDelay, action.handFade)
	hand:setAnchorPoint(ccp(0, 1))
	local startPanel = paras.actWin
	local pos = startPanel.levelInfoPanel.startButton:getPositionInScreen()
	local size = startPanel.levelInfoPanel.startButton:getGroupBounds().size
	if startPanel.levelInfoPanel.userGuideLayer then
		pos = startPanel.levelInfoPanel.userGuideLayer:convertToNodeSpace(pos)
		hand:setPosition(ccp(pos.x + 65, pos.y - 10))
		startPanel.levelInfoPanel.userGuideLayer:addChild(hand)
		GameGuideData:sharedInstance():setLayer(startPanel.levelInfoPanel.userGuideLayer)
		released = false
	end
end

function GameGuideRunner:removeStartPanel()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runGameSwap()
	local action = GameGuideData:sharedInstance():getRunningAction()
	action.maskDelay = action.maskDelay or 0.4
	action.maskFade = action.maskFade or 0.4
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local trueMask = playUI:gameGuideMask(action.opacity, action.array, action.allow, false)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(playUI, action)
	local from, to = playUI:getPositionFromTo(action.from, action.to)
	local hand = GameGuideAnims:handslideAnim(from, to, action.handDelay, action.handFade)
	local text = GameGuideUI:skipButton(Localization:getInstance():getText("tutorial.skip.step"), action)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		layer:addChild(hand)
		layer:addChild(text)
		GameGuideData:sharedInstance():setLayer(layer)
		released = false
	end
end

function GameGuideRunner:removeGameSwap()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runShowObj()
	local action = GameGuideData:sharedInstance():getRunningAction()
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
	local trueMask = GameGuideUI:mask(action.opacity, action.touchDelay, ccp(wPos.x, wPos.y),
		nil, false, action.width or 1, action.height or 1, true)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(playUI, action, true)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		GameGuideData:sharedInstance():setLayer(layer)
		released = false
	end
end

function GameGuideRunner:removeShowObj()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runShowHint()
	local action = GameGuideData:sharedInstance():getRunningAction()
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
	local panel = GameGuideUI:panelMini(action.text)
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
		GameGuideData:sharedInstance():setLayer(layer)
		released = false
	end
end

function GameGuideRunner:removeShowHint()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runShowEliminate()
	local action = GameGuideData:sharedInstance():getRunningAction()
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
		GameGuideData:sharedInstance():setLayer(layer)
		released = false
	end
end

function GameGuideRunner:removeShowEliminate()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		local anim = layer:getChildByName("animation")
		anim:stopAllActions()
		local function removeAll() layer:removeChildren(true) end
		anim:runAction(CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(300, 0)), CCCallFunc:create(removeAll)))
	end
	return true, true
end

function GameGuideRunner:runShowInfo()
	local action = GameGuideData:sharedInstance():getRunningAction()
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
	local panel = GameGuideUI:panelL(action.text, true, action)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		GameGuideData:sharedInstance():setLayer(layer)
		released = false
	end
end

function GameGuideRunner:removeShowInfo()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runClickTile( paras )
	-- body
	local action = GameGuideData:sharedInstance():getRunningAction()
	if paras and type(paras) == "table" and paras.r and paras.c then
		action.array[1].r = paras.r 
		action.array[1].c = paras.c 
	end

	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.touchDelay = action.touchDelay or 0

	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local trueMask = playUI:gameGuideMask(action.opacity, action.array, action.array[1], 1.5)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(playUI, action)
	local hand = GameGuideAnims:handclickAnim(0.5, 0.3)
	local pos = playUI:getPositionFromTo(ccp(action.array[1].r, action.array[1].c), ccp(action.array[1].r, action.array[1].c))
    hand:setAnchorPoint(ccp(0, 1))
    hand:setPosition(pos)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		layer:addChild(hand)
		GameGuideData:sharedInstance():setLayer(layer)
		released = false
	end
end

function GameGuideRunner:removeClickTile( paras )
	-- body
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runShowTile(paras)
	local action = GameGuideData:sharedInstance():getRunningAction()
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.touchDelay = action.touchDelay or 0
	if paras and type(paras) == "table" and paras.wukongGuide == true then
		if type(paras.pos) == "table" and #paras.pos > 0 then
			action.array = {}
			local item = nil
			for ik, iv in pairs(paras.pos) do
				item = {}
				if iv.r then item.r = iv.r end
				if iv.c then item.c = iv.c end
				if iv.countR then item.countR = iv.countR else item.countR = 1 end
				if iv.countC then item.countC = iv.countC else item.countC = 1 end
				table.insert( action.array , item )
			end
		end
	end



	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local trueMask = playUI:gameGuideMask(action.opacity, action.array, {action.array[1]})
	trueMask:removeAllEventListeners()
	local function onTouch() GameGuide:sharedInstance():onGuideComplete() end
	local function beginTouch() trueMask:ad(DisplayEvents.kTouchTap, onTouch) end
	trueMask:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.touchDelay), CCCallFunc:create(beginTouch)))
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(playUI, action, true)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		GameGuideData:sharedInstance():setLayer(layer)
		released = false
	end
end

function GameGuideRunner:removeShowTile()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runShowUFO()
	local action = GameGuideData:sharedInstance():getRunningAction()
	action.maskDelay = action.maskDelay or 0.3
	action.maskFade = action.maskFade or 0.3
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local pos = playUI:getPositionFromTo(action.position, action.position)
	action.deltaY = action.deltaY or 70
	pos.y = pos.y + action.deltaY
	local trueMask = GameGuideUI:mask(action.opacity, action.touchDelay, ccp(pos.x, pos.y), 1, false, action.width, action.height, action.oval)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(playUI, action, true)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		GameGuideData:sharedInstance():setLayer(layer)
		released = false
	end
end

function GameGuideRunner:removeShowUFO()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
	end
	return true, true
end

function GameGuideRunner:runMoveCount()
	local action = GameGuideData:sharedInstance():getRunningAction()
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	-- local trueMask = playUI:gameGuideMask(action.opacity, action.array, {action.array[1]})
	action.opacity = action.opacity or 0xCC
	local pos = playUI:getMoveCountPos()
	action.posAdd = action.posAdd or ccp(0, 0)
	pos.x, pos.y = pos.x + action.posAdd.x, pos.y + action.posAdd.y
	local trueMask = GameGuideUI:mask(action.opacity, action.touchDelay, pos, nil, true, action.width, action.height)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(playUI, action, true)

	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		GameGuideData:sharedInstance():setLayer(layer)
		released = false
	end
end

function GameGuideRunner:removeMoveCount()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
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

function GameGuideRunner:runShowPreProp(paras)

	if not paras or type(paras) ~= "table" then return end
	local action = GameGuideData:sharedInstance():getRunningAction()
	local startPanel = paras.actWin
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
	local trueMask = GameGuideUI:mask(action.opacity, action.touchDelay, ccp(pos1.x + posAdd, pos1.y), action.multRadius * scale)
	local function onTouchTap(evt)
		local dx, dy = evt.globalPosition.x - pos1.x - posAdd, evt.globalPosition.y - pos1.y
		if dx * dx + dy * dy < (action.radius * scale) * (action.radius * scale) then
			local event = {name = DisplayEvents.kTouchTap, context = action.index}
			startPanel.levelInfoPanel:onPreGameItemTapped(event)
		end
	end
	trueMask:ad(DisplayEvents.kTouchTap, onTouchTap)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(nil, action, true)
	local layer = Layer:create()
	GameGuideData:sharedInstance():setLayer(layer)
	layer:addChild(trueMask)
	layer:addChild(panel)
	if scene then
		scene:addChild(layer)
		released = false
	end
end

function GameGuideRunner:removeShowPreProp()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:runStartInfo(paras)
	if not paras or type(paras) ~= "table" then return end
	local action = GameGuideData:sharedInstance():getRunningAction()
	local startPanel = paras.actWin
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
	local trueMask = GameGuideUI:mask(action.opacity, action.touchDelay, ccp(pos1.x + posAdd, pos1.y), action.multRadius * scale)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(nil, action, true)
	local layer = Layer:create()
	GameGuideData:sharedInstance():setLayer(layer)
	layer:addChild(trueMask)
	layer:addChild(panel)
	if scene then
		scene:addChild(layer)
		released = false
	end
end

function GameGuideRunner:removeStartInfo()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:runTempProp()
	local action = GameGuideData:sharedInstance():getRunningAction()
	action.maskDelay = action.maskDelay or 0
	action.index = action.index or 1
	action.maskFade = action.maskFade or 0.3
	action.multRadius = action.multRadius or 1
	action.posAdd = action.posAdd or ccp(0, 0)

	local playUI = Director:sharedDirector():getRunningScene()
	local layer = playUI.guideLayer
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local pos = playUI:getPositionByIndex(action.index)
	local trueMask = GameGuideUI:mask(action.opacity, action.touchDelay, ccp(pos.x + action.posAdd.x, pos.y + action.posAdd.y), action.multRadius)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(nil, action, true)
	if layer then
		layer:addChild(trueMask)
		layer:addChild(panel)
		GameGuideData:sharedInstance():setLayer(layer)
		released = false
	end
end

function GameGuideRunner:removeTempProp()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:runGiveProp()
	local action = GameGuideData:sharedInstance():getRunningAction()
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
	local trueMask = GameGuideUI:mask(action.opacity, action.touchDelay, pos, 1.5, false, nil, nil, false)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(nil, action, true)
	GameGuideData:sharedInstance():setLayer(layer)
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

function GameGuideRunner:removeGiveProp()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	local action = GameGuideData:sharedInstance():getRunningAction()
	local playUI = Director:sharedDirector():getRunningScene()
	local propId = action.tempPropId
	local num = action.count
	local pos = layer.panel:convertToWorldSpace(ccp(action.panImage[1].x, action.panImage[1].y))

	playUI:addTemporaryItem(propId, num, pos)
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:runShowProp()
	local action = GameGuideData:sharedInstance():getRunningAction()
	action.maskDelay = action.maskDelay or 0
	action.maskFade = action.maskFade or 0.3
	action.maskPos = action.maskPos or ccp(0, 0)
	action.opacity = action.opacity or 0xCC
	action.radius = action.radius or 80
	action.index = action.index or 1
	
	local playUI = Director:sharedDirector():getRunningScene()
	local offsetX = action.offsetX or 0
	local offsetY = action.offsetY or 0

	local itemId = action.propId

	local itemCenterPos = playUI.propList:getItemCenterPositionById(itemId)
	if not itemCenterPos then return end

	local pos = ccp(itemCenterPos.x + offsetX , itemCenterPos.y + offsetY)
	local layer = Layer:create()
	local trueMask = GameGuideUI:mask(action.opacity, action.touchDelay, pos, 1.5, false, nil, nil, false)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(nil, action, true)
	GameGuideData:sharedInstance():setLayer(layer)
	layer.success = false
	local position = trueMask:getPosition()
	layer:addChild(trueMask)
	layer:addChild(panel)

	if playUI.guideLayer then
		playUI.guideLayer:addChild(layer)
		released = false
	end
end

function GameGuideRunner:runShowCustomizeArea()
	local action = GameGuideData:sharedInstance():getRunningAction()
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
	local trueMask = GameGuideUI:mask(action.opacity, action.touchDelay, pos, nil, true, action.width, action.height, false)
	trueMask.setFadeIn(action.maskDelay, action.maskFade)
	local panel = GameGuideUI:panelS(playUI, action, true)
	GameGuideData:sharedInstance():setLayer(layer)
	layer.success = false
	local position = trueMask:getPosition()
	layer:addChild(trueMask)
	layer:addChild(panel)

	if playUI.guideLayer then
		playUI.guideLayer:addChild(layer)
		released = false
	end
end

function GameGuideRunner:removeShowCustomizeArea()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:removeShowProp()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return true, true
end

function GameGuideRunner:runShowUnlock()
	local action = GameGuideData:sharedInstance():getRunningAction()
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

	local cloudId = action.cloudId

	local layer = Layer:create()
	GameGuideData:sharedInstance():setLayer(layer)
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
		local trueMask = GameGuideUI:mask(action.opacity, action.touchDelay, pos, 2, false, 5, 2, false, true)

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
		local panel = GameGuideUI:panelS(nil, action, true)
		local position = trueMask:getPosition()
		layer:addChild(trueMask)
		layer:addChild(panel)

		local hand = GameGuideAnims:handclickAnim(0.5, 0.3)
        hand:setAnchorPoint(ccp(0, 1))
        hand:setPosition(pos)
        layer:addChild(hand)
	end

	worldScene:moveCloudLockToCenter(cloudId, callback)
end

function GameGuideRunner:removeShowUnlock()
	if released then return false, false end
	released = true
	local layer = GameGuideData:sharedInstance():getLayer()
	if layer and not layer.isDisposed then
		layer:removeChildren(true)
		layer:removeFromParentAndCleanup(true)
	end
	return layer.clicked, layer.success
end