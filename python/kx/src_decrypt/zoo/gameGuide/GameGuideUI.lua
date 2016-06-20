
local animalType = {["horse"] = 1, ["frog"] = 2, ["bear"] = 3, ["cat"] = 4, ["fox"] = 5, ["chicken"] = 6, ["color"] = 7}
local specialType = {["normal"] = 1, ["line"] = 7, ["column"] = 6, ["wrap"] = 8}

GameGuideUI = class()

function GameGuideUI:panelS(playUI, action, skipText)
	local panel
	if action.panFlip then
		if action.panType == "down" then
			panel = GameGuideUI:panelSDR(action.text, skipText, action.prefHeight)
		else
			panel = GameGuideUI:panelSUR(action.text, skipText, action.prefHeight)
		end

		

	else
		if action.panType == "down" then
			panel = GameGuideUI:panelSD(action.text, skipText, action.prefHeight)
		else
			panel = GameGuideUI:panelSU(action.text, skipText, action.prefHeight)
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
			if v.rotation then
				sprite:setRotation(v.rotation)
			end
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

	if action.ignoreCharacter then
		local child = panel:getChildByName("animation")
		if child then
			child:removeFromParentAndCleanup(true)
		end
	else
		local target = panel:getChildByName("animation")
		if action.panFlip then
			target = target:getChildByName("animation")
		end
		target:setOpacity(0)
		target:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.panDelay), CCFadeIn:create(action.panFade)))
		-- panel:setOpacity(0)
		-- panel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(action.panDelay), CCFadeIn:create(action.panFade)))
	end

	return panel
end

function GameGuideUI:panelSD(text, skipText, prefHeight)
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
	panel.text:setRichText(str, "000000")
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

function GameGuideUI:panelSU(text, skipText)
	local wSize = Director:sharedDirector():getWinSize()
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelS")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setRichText(str, "000000")
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

function GameGuideUI:panelSDR(text, skipText)
	local wSize = Director:sharedDirector():getWinSize()
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelSR")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setRichText(str, "000000")
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

function GameGuideUI:panelSUR(text, skipText)
	local wSize = Director:sharedDirector():getWinSize()
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelSR")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setRichText(str, "000000")
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

function GameGuideUI:panelL(text, skipText, action)
	local wSize = Director:sharedDirector():getWinSize()
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelL")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setRichText(str, "000000")
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
			if v.rotation then
				sprite:setRotation(v.rotation)
			end
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
	panel.onEnterHandler = function(self) end -- 覆盖原方法
	return panel
end

function GameGuideUI:panelMini(text)
	local panel = BasePanel.new()
	panel.ui = ResourceManager:sharedInstance():buildGroup("guide_info_panelM")
	BasePanel.init(panel, panel.ui)
	panel.text = panel.ui:getChildByName("text")
	local str = Localization:getInstance():getText(text, {n = "\n", s = " "})
	panel.text:setRichText(str, "000000")
	panel.onEnterHandler = function(self) end -- 覆盖原方法
	return panel
end

function GameGuideUI:mask(opacity, touchDelay, position, radius, square, width, height, oval, skipClick)
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

function GameGuideUI:skipButton(skipText, action, notSkipLevel, callback)
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