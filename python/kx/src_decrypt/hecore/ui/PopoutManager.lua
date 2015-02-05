
local kDarkOpacity = 150
local visibleOrigin = Director:sharedDirector():getVisibleOrigin()
local visibleSize =  Director:sharedDirector():getVisibleSize()
PopoutEvents = {
	kRemoveOnce = "removeOnce"
}

PopoutManager = {}

function PopoutManager:sharedInstance()
	return PopoutManager
end


local function getPopoutList( )
	local scene = Director:sharedDirector():getRunningScene()
	if not scene then 
		return nil
	end
	if not scene.__popoutList then
		local popoutList = {}

		function popoutList:refreshDark( ... )
			for i=1,#self do
				if self[i].darkLayer and self[i].darkLayer.refCocosObj then
					self[i].darkLayer:setVisible(false)
					self[i].darkLayer:setOpacity(kDarkOpacity)
				end
			end
			for i=#self,1,-1 do
				if self[i].darkLayer and self[i].darkLayer.refCocosObj then
					self[i].darkLayer:setVisible(true)
					break
				end	
			end
		end

		function popoutList:getPreviousDarkContainer()
			for i=#self,1,-1 do
				if self[i].darkLayer and not self[i].darkLayer:isVisible() then 
					return self[i]
				end
			end
			return nil
		end

		function popoutList:add( container )
			table.insert(self,container)
			self:refreshDark()
		end

		function popoutList:remove( container )
			table.removeValue(self,container)
			self:refreshDark()
		end

		scene.__popoutList = popoutList
	end

	return scene.__popoutList
end

local function getPopoutQueue()
	local scene = Director:sharedDirector():getRunningScene()
	if not scene then
		return nil
	end
	if not scene.__popoutQueue then
		scene.__popoutQueue = {}
	end

	return scene.__popoutQueue
end

local function addContainerToScene( child, dark, enableTouchBehind )
	--test
	-- enableTouchBehind = true

	print("addContainerToScene ".. tostring(dark))

	local popoutList = getPopoutList()
	if not popoutList then 
		return 
	end
	local curScene = Director:sharedDirector():getRunningScene()

	local container = Layer:create()
	container:setPosition(visibleOrigin)
	container:setContentSize(visibleSize)

	if dark then 
		local darkLayer = LayerColor:create()
		darkLayer:setOpacity(kDarkOpacity)
		darkLayer:setContentSize(visibleSize)
		container:addChild(darkLayer)

		container.darkLayer = darkLayer
	end

	if not enableTouchBehind then 
		local swallowLayer = Layer:create()
		swallowLayer:setTouchEnabled(true, 0, true)
		swallowLayer:setContentSize(visibleSize)
		container:addChild(swallowLayer)
	end

	local childContainer = CocosObject:create()
	childContainer:setPositionX(0)
	childContainer:setPositionY(visibleSize.height)

	childContainer:addChild(child)
	container:addChild(childContainer)
	
	container.child = child

	curScene:addChild(container)

	popoutList:add(container)
	function container:remove( cleanup )
		popoutList:remove(self)
		self:removeFromParentAndCleanup(cleanup)
	end
	function container:getPopoutList( ... )
		return popoutList
	end

	return container
end

function PopoutManager:add(child, dark, enableTouchBehind)
	addContainerToScene(child, dark, enableTouchBehind)
end
function PopoutManager:remove(child, cleanup)
	if child.isDisposed or not child:getParent() or not child:getParent():getParent() then
		-- warn
		return
	end

	local container = child:getParent():getParent()
	container:remove(false)

	child:dispatchEvent(Event.new(PopoutEvents.kRemoveOnce, nil, child))
	
	child:removeFromParentAndCleanup(cleanup)
	container:dispose()

	local popoutList = container:getPopoutList()
	local lastPopoutPanel = nil
	if #popoutList > 0 then
		lastPopoutPanel = table.last(popoutList).child
	end
	if lastPopoutPanel and lastPopoutPanel.reBecomeTopPanel then
		lastPopoutPanel:reBecomeTopPanel()
	end
end

function PopoutManager:addWithBgFadeIn(child, dark, enableTouchBehind, fadeInAnimFinishedCallback, duration)
	local container = addContainerToScene(child, true, enableTouchBehind)
	
	local popoutList = getPopoutList()
	local fadeOutContainer = nil
	if popoutList then
		fadeOutContainer = popoutList:getPreviousDarkContainer()
	end

	local arr = CCArray:create()
	if fadeOutContainer then 
		arr:addObject(CCCallFunc:create(function( ... )
			fadeOutContainer.darkLayer:setVisible(true)
			container.darkLayer:setOpacity(0)
		end))
		arr:addObject(CCSpawn:createWithTwoActions(
			CCFadeTo:create(duration or 0.25, kDarkOpacity),
			CCTargetedAction:create(
				fadeOutContainer.darkLayer.refCocosObj,
				CCFadeTo:create(duration or 0.25,0)
			)
		))
		arr:addObject(CCCallFunc:create(function( ... )
			if fadeOutContainer.darkLayer.refCocosObj then
				fadeOutContainer.darkLayer:setVisible(false)
				fadeOutContainer.darkLayer:setOpacity(kDarkOpacity)
			end
		end))
	else
		arr:addObject(CCCallFunc:create(function( ... )
			container.darkLayer:setOpacity(0)
		end))
		arr:addObject(CCFadeTo:create(duration or 0.25, kDarkOpacity))
	end
	
	arr:addObject(CCCallFunc:create(function( ... )
		if type(fadeInAnimFinishedCallback) == "function" then
			fadeInAnimFinishedCallback()
		end
	end))

	container.darkLayer:runAction(CCSequence:create(arr))
end

function PopoutManager:removeWithBgFadeOut(child, animFinishCallback, notUsedParameter, duraiton )
	if child.isDisposed or not child:getParent() or not child:getParent():getParent() then
		-- warn
		return
	end

	local container = child:getParent():getParent()

	if container.darkLayer and container.darkLayer:isVisible() then
		local popoutList = container:getPopoutList()
		local fadeInContainer = nil
		if popoutList then
			fadeInContainer = popoutList:getPreviousDarkContainer()
		end

		local arr = CCArray:create()
		if not fadeInContainer then
			arr:addObject(CCFadeTo:create(duration or 0.25, 0))
		else
			arr:addObject(CCCallFunc:create(function( ... )
				if fadeInContainer.darkLayer.refCocosObj then
					fadeInContainer.darkLayer:setOpacity(0)
					fadeInContainer.darkLayer:setVisible(true)
				end
			end))
			arr:addObject(CCSpawn:createWithTwoActions(
				CCFadeTo:create(duration or 0.25, 0),
				CCTargetedAction:create(
					fadeInContainer.darkLayer.refCocosObj,
					CCFadeTo:create(duration or 0.25,kDarkOpacity)
				)
			))
		end
		arr:addObject(CCCallFunc:create(function( ... )
			self:remove(child,true)

			if type(animFinishCallback) == "function" then
				animFinishCallback()
			end
		end))
		container.darkLayer:runAction(CCSequence:create(arr))
	else
		self:remove(child,true)
		if type(animFinishCallback) == "function" then
			animFinishCallback()
		end
	end
end

function PopoutManager:removeAll( ... )
	local popoutList = getPopoutList() or {}
	while #popoutList > 0 do
		self:remove(popoutList[1].child,true)
	end
end
function PopoutManager:haveWindowOnScreen( ... )
	local popoutList = getPopoutList()

	return popoutList and #popoutList > 0
end

function PopoutManager:getLastPopoutPanel( ... )
	if self:haveWindowOnScreen() then
		local popoutList = getPopoutList()
		return table.last(popoutList).child
	else
		return nil
	end
end

function PopoutManager:getChildContainer( child )
	return child:getParent()
end

function PopoutManager:removeWhileKeepBackground(child)
	self:remove(child)
end

function PopoutManager:addChildWithBackground(child, bgColor, opacity)
	self:add(child,true,false)

	local panelSize = child:getGroupBounds().size

	local posX = 0 - (visibleSize.width - panelSize.width) / 2
	local posY = 0 - (visibleSize.height + panelSize.height) / 2
	local childPosY = 0 - (visibleSize.height - panelSize.height) / 2

	child:setPosition(ccp(-posX, childPosY))
end


-- 
PopoutQueue = {}
function PopoutQueue:sharedInstance()
	return PopoutQueue
end

function PopoutQueue:push(child,dark,enableTouchBehind,fadeInAnimFinishedCallback, duration)
	local popoutQueue = getPopoutQueue()
	if not popoutQueue then 
		return 
	end

	if dark == nil then 
		dark = true 
	end
	if enableTouchBehind == nil then
		enableTouchBehind = false
	end

	table.insert(popoutQueue,{
		childPanel = child,
		isDark = dark,
		enableTouchBehind = enableTouchBehind,
		fadeInAnimFinishedCallback = fadeInAnimFinishedCallback,
		duration = duration,
	})

	if #popoutQueue == 1 then
		self:add(popoutQueue)
	end
end

function PopoutQueue:add(popoutQueue)
	local function removeOnceComplete(evt)
		-- evt.target:removeEventListener(PopoutEvents.kRemoveOnce,removeOnceComplete)
		-- evt.target:removeEventListener(Events.kDispose,removeOnceComplete)

		table.remove(popoutQueue, 1)

		self:add(popoutQueue)	
	end
	
	print("PopoutQueue:add")
	if #popoutQueue <= 0 then
		return
	end

	local childInfo = popoutQueue[1]
	print("PopoutQueue:add isDark:" .. tostring(childInfo.isDark) .. " duration:" .. tostring(childInfo.duration))

	local childPanel = childInfo.childPanel

	childPanel:addEventListener(PopoutEvents.kRemoveOnce, removeOnceComplete)
	-- childPanel:addEventListener(Events.kDispose,removeOnceComplete)

	if not childInfo.fadeInAnimFinishedCallback and not childInfo.duration then
		PopoutManager.sharedInstance():add(childPanel, childInfo.isDark, childInfo.enableTouchBehind)
	else
		PopoutManager.sharedInstance():addWithBgFadeIn(childPanel, childInfo.isDark, childInfo.enableTouchBehind,function( ... )
			if type(childInfo.fadeInAnimFinishedCallback) == "function" then
				childInfo.fadeInAnimFinishedCallback()
			end
		end,childInfo.duration)
	end

	if type(childPanel.popoutShowTransition) == "function" then
		childPanel:popoutShowTransition()
	end
end