
require "hecore.display.Director"
require "hecore.display.MultiLineTextField"


kPopoutDir = {kFromTopToTop = 1}

kDarkOpacity = 150

PopoutManager = {}
PopoutManager.popouts = {}

local instance = nil
function PopoutManager:sharedInstance()
	if not instance then
		instance = PopoutManager
	end
	return instance
end

--dark: optional, false by default.
--parent: optional, running scene by default.
--enableTouchBehind: optional, false by default.
function PopoutManager:add(child, dark, enableTouchBehind, ...)
	assert(child)
	assert(type(dark) == "boolean")
	assert(type(enableTouchBehind) == "boolean")
	assert(#{...} == 0)

	local winSize = CCDirector:sharedDirector():getWinSize()
	local scene = Director:mgr():run()
	if not scene then return end
	assert(scene)

	-- -----------------------------
	-- Check If Scene Has A Popout Layer
	-- ------------------------------
	local popoutLayer	= scene.rootLayer:getChildByName("_pop_out_layer_")
	local colorLayer	= false
	local popoutList	= false
	
	-- Create The Pop Out Layer In Current Scene
	if not popoutLayer then
		-- Create Pop Out Layer
		popoutLayer 		= Layer:create()
		popoutLayer.name	= "_pop_out_layer_"

		-- Create Color Layer
		colorLayer = LayerColor:create()
		colorLayer.name = "_color_layer_"

		colorLayer:changeWidthAndHeight(winSize.width, winSize.height)
		colorLayer:setAnchorPoint(ccp(0,0))
		popoutLayer.colorLayer = colorLayer
		popoutLayer:addChild(colorLayer)

		if dark then 
			colorLayer:setOpacity(kDarkOpacity)
		else 
			colorLayer:setOpacity(0) 
		end

		-- Create Pop Out List
		popoutLayer.popoutList	= {}
		popoutList = popoutLayer.popoutList

		scene.rootLayer:addChild(popoutLayer)
	else
		--colorLayer = popoutLayer:getChildByName("_color_layer_")
		colorLayer = popoutLayer.colorLayer
		assert(colorLayer)

		popoutList = popoutLayer.popoutList
		assert(popoutList)
	end
	
	--check if child is already inserted.
	if self:indexOf(popoutList, child) ~= -1 then 
		assert(false)
		return false 
	end

	local touchBehindEnabled = false
	if enableTouchBehind ~= nil then touchBehindEnabled = enableTouchBehind end

	--------------------------------
	-- Create Each Popout's Container
	-- ----------------------------

	-- Container
	local container = Layer:create()
	container.name = "popout container"
	container:setContentSize(CCSizeMake(winSize.width, winSize.height))

	-- Swallow Touch Layer
	local swallowTouchLayer = LayerColor:create()
	swallowTouchLayer.name	= "swallow touch"
	swallowTouchLayer:changeWidthAndHeight(winSize.width, winSize.height)
	swallowTouchLayer:setOpacity(0)
	swallowTouchLayer:setColor(ccc3(255,0,0))

	if not touchBehindEnabled then
		swallowTouchLayer:setTouchEnabled(true, 0, true)
	end
	swallowTouchLayer:setPosition(ccp(0, 0))
	container:addChild(swallowTouchLayer)

	-- Child Container , Contain The Child , Positioned At Top Left Win Cornor
	local childContainer = CocosObject:create()

	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()

	--childContainer:setPosition(ccp(visibleOrigin.x, winSize.height))
	childContainer:setPosition(ccp(visibleOrigin.x, visibleOrigin.y + visibleSize.height))
	childContainer.name = "_child_container_"
	childContainer:addChild(child)
	container:addChild(childContainer)
	
	popoutLayer:addChild(container)

	table.insert(popoutList, {child, container})

	return popoutLayer, colorLayer, container
end

function PopoutManager:addWithBgFadeIn(child, dark, enableTouchBehind, fadeInAnimFinishedCallback, duration, ...)
	assert(child)
	assert(type(dark) == "boolean")
	assert(type(enableTouchBehind) == "boolean")
	assert(fadeInAnimFinishedCallback == false or type(fadeInAnimFinishedCallback) == "function")
	assert(#{...} == 0)

	self:add(child, dark, enableTouchBehind)

	local scene		= Director:mgr():run()
	local popoutLayer	= scene.rootLayer:getChildByName("_pop_out_layer_")
	local colorLayer	= popoutLayer.colorLayer
	local popoutList	= popoutLayer.popoutList

	if dark then
		if 1 == self:getNumberOfPopouts(popoutList) then
			-------------
			-- Fade To
			-- -----------
			if type(duration) ~= "number" or duration < 0 then duration = 0.25 end
			colorLayer:setOpacity(0)
			local fadeTo = CCFadeTo:create(duration, kDarkOpacity)
			
			-- -------------------------
			-- Fade In Anim Finish Callback
			-- -------------------------
			local function callbackFunc()
				if fadeInAnimFinishedCallback then
					fadeInAnimFinishedCallback()
				end
			end
			local callbackAction = CCCallFunc:create(callbackFunc)

			-- ----
			-- Seq
			-- ---
			local seq = CCSequence:createWithTwoActions(fadeTo, callbackAction)

			colorLayer:runAction(seq)
		else
			if fadeInAnimFinishedCallback then
				fadeInAnimFinishedCallback()
			end
		end
	else 
		colorLayer:setOpacity(0) 
		if fadeInAnimFinishedCallback then
			fadeInAnimFinishedCallback()
		end
	end
end

function PopoutManager:indexOf(table, child, ...) 
	assert(type(table) == "table")
	assert(child)
	assert(#{...} == 0)
	
	for i,v in ipairs(table) do
		if v[1] == child then return i end
	end
	return -1
end

function PopoutManager:getNumberOfPopouts(table, ...)
	assert(type(table) == "table")
	assert(#{...} == 0)

	local length = 0

	for k,v in pairs(table) do
		length = length + 1
	end

	return length
end

function PopoutManager:removeWhileKeepBackground(child, ...)
	assert(child)

	local scene		= Director:mgr():run()
	local popoutLayer	= scene.rootLayer:getChildByName("_pop_out_layer_")
	local colorLayer	= popoutLayer.colorLayer
	local popoutList	= popoutLayer.popoutList

	local idx = self:indexOf(popoutList, child)
	if idx ~= -1 then
		local map = popoutList[idx]
		if map then
			local container = map[2]
			if container then container:rma() end
			if container and container:getParent() then 

				-- Remove
				container:getParent():removeChild(container, true) 
				table.remove(popoutList, idx)

				-- Re Become Top Panel Callback
				if popoutList[idx - 1] then
					local previousPopout = popoutList[idx - 1][1] -- Child
					if previousPopout and previousPopout.reBecomeTopPanel then
						previousPopout:reBecomeTopPanel()
					end
				end
			end
		end
	else
		assert(false)
	end
	
end

function PopoutManager:getContainer(child, ...)
	assert(child)
	assert(#{...} == 0)

	local scene		= Director:mgr():run()
	local popoutLayer	= scene.rootLayer:getChildByName("_pop_out_layer_")
	local colorLayer	= popoutLayer.colorLayer
	local popoutList	= popoutLayer.popoutList


	local index = self:indexOf(popoutList, child)
	if index ~= -1 then
		local map	= popoutList[index]
		local container = map[2]

		assert(container)
		return container
	else
		assert(false)
	end
end

function PopoutManager:getChildContainer(child, ...)
	assert(child)
	assert(#{...} == 0)

	local container		= self:getContainer(child)
	local childContainer	= container:getChildByName("_child_container_")

	assert(childContainer)
	return childContainer
end

function PopoutManager:getPopoutLayer(...)
	assert(#{...} == 0)

	--local scene = 
	local scene = Director:sharedDirector():getRunningScene()

	if scene then
		local popoutLayer = scene.rootLayer:getChildByName("_pop_out_layer_")
		return popoutLayer
	end
	return nil
end

function PopoutManager:remove(child, cleanup, ...)
	assert(child)
	if cleanup == nil then cleanup = true end

	-- local scene		= Director:mgr():run()
	-- local popoutLayer	= scene.rootLayer:getChildByName("_pop_out_layer_")
	local popoutLayer = self:getPopoutLayer()

	if not popoutLayer then return end

	local colorLayer	= popoutLayer.colorLayer
	local popoutList	= popoutLayer.popoutList


	local idx = self:indexOf(popoutList, child)
	if idx ~= -1 then
		local map = popoutList[idx]
		if map then
			local container = map[2]
			if container then container:rma() end
			if container and container:getParent() then 

				child:dp(Event.new(PopoutEvents.kRemoveOnce, nil, child))

				-- Remove
				if not cleanup then child:removeFromParentAndCleanup(false) end
				container:getParent():removeChild(container, true) 
				table.remove(popoutList, idx)

				-- Last Popout ? Remove The Bg
				local numberOfPanel = self:getNumberOfPopouts(popoutList)
				if 0 == numberOfPanel then
					-- Remove The Back Ground
					colorLayer:removeFromParentAndCleanup(true)
					popoutLayer:removeFromParentAndCleanup(true)
				end

				-- Re Become Top Panel Callback
				if popoutList[idx - 1] then
					local previousPopout = popoutList[idx - 1][1] -- Child
					if previousPopout and previousPopout.reBecomeTopPanel then
						previousPopout:reBecomeTopPanel()
					end
				end
			end
		end
	else
		assert(false)
	end
end

function PopoutManager:removeAll()
	local popoutLayer = self:getPopoutLayer()

	if not popoutLayer then return end

	local colorLayer	= popoutLayer.colorLayer
	local popoutList	= popoutLayer.popoutList

	while #popoutList > 0 do
		self:remove(popoutList[1][1], true)
	end
end

function PopoutManager:removeWithBgFadeOut(child, animFinishCallback, notUsedParameter, duration, ...)
	assert(child)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	local scene		= Director:mgr():run()
	local popoutLayer	= scene.rootLayer:getChildByName("_pop_out_layer_")
	
	if not popoutLayer then return end

	local colorLayer	= popoutLayer.colorLayer
	local popoutList	= popoutLayer.popoutList

	local idx = self:indexOf(popoutList, child)
	if idx ~= -1 then
		local map = popoutList[idx]
		if map then
			local container = map[2]
			if container then container:rma() end
			if container and container:getParent() then 

				-- ------------------------------------------------------------
				-- Check If This Is The Last Popout Panel
				-- If This Is The Last Popout Panel, Then Remove The Background
				-- ------------------------------------------------------------

				local actionArray = CCArray:create()

				-- FadeOut The Background Action
				local numberOfPanel = self:getNumberOfPopouts(popoutList)
				if 1 == numberOfPanel then

					-- Fade Out
					if type(duration) ~= "number" or duration < 0 then duration = 0.25 end
					local fadeout		= CCFadeTo:create(duration, 0)
					local targetFadeout	= CCTargetedAction:create(colorLayer.refCocosObj, fadeout)

					actionArray:addObject(targetFadeout)
				end	

				-- Remove Anim Finish Callback Action
				local function callbackFunc()

					-- Remove
					--container:getParent():removeChild(container, true) 
					child:dp(Event.new(PopoutEvents.kRemoveOnce, nil, child))
					container:removeFromParentAndCleanup(true)
					table.remove(popoutList, idx)

					-- Remove The Bg
					local numberOfPanel = self:getNumberOfPopouts(popoutList)
					if 0 == numberOfPanel then
						colorLayer:removeFromParentAndCleanup(true)
						popoutLayer:removeFromParentAndCleanup(true)
					end

					if animFinishCallback then
						animFinishCallback()
					end

					-- Re Become Top Panel Callback
					if popoutList[idx - 1] then
						local previousPopout = popoutList[idx - 1][1] -- Child
						if previousPopout and previousPopout.reBecomeTopPanel then
							previousPopout:reBecomeTopPanel()
						end
					end
				end
				local callbackAction = CCCallFunc:create(callbackFunc)
				actionArray:addObject(callbackAction)

				-- Seq
				local seq = CCSequence:create(actionArray)
				colorLayer:runAction(seq)
			end
		end
	else
		assert(false)
	end
end

--function PopoutManager:clear()
--	for i,v in ipairs(self.popouts) do
--		self:remove(v[1])
--	end
--	self.popouts = {}
--end

--function PopoutManager:bringToFront( child )
--	if not child then return end
--	local idx = self:indexOf(child)
--	local map = self.popouts[idx]
--	if map then
--		local container = map[2]
--		if container then 
--			local parent = container:getParent()
--			parent:setChildIndex(container, parent:getNumOfChildren()-1)
--		end
--	end
--end
--
--function PopoutManager:bringAllToFront( parent )
--	local scene = Director:mgr():run()
--	if not parent then parent = scene end
--	if not scene or not parent then return end
--
--	local list = {}
--	for i,v in ipairs(self.popouts) do
--		local child = v[1]
--		if child and child:getParent() == parent then
--			table.insert(list, child)
--		end
--	end
--	for i,v in ipairs(list) do
--		self:bringToFront(v)
--	end
--end

-- function PopoutManager:addChildWithBackground(child, bgColor, opacity)
-- 	assert(child)
-- 	bgColor = bgColor or ccc3(0,0,0)
-- 	opacity = opacity or 255 * 0.7
-- 	local vSize = CCDirector:sharedDirector():getVisibleSize()
--     local vOrigin = CCDirector:sharedDirector():getVisibleOrigin()
-- 	-- 在可视区域内添加面板
-- 	local childContainer = CocosObject:create()
--     childContainer:setPosition(ccp(0, -vSize.height))
--     childContainer.name = "_child_container_"
--     -- 创建蒙版，大小为可视区域
--     local colorLayer = LayerColor:create()
--     colorLayer:changeWidthAndHeight(vSize.width, vSize.height)
--     colorLayer:setColor(bgColor)
--     colorLayer:setPosition(ccp(0, 0))
--     colorLayer:setOpacity(opacity)
--     colorLayer:setTouchEnabled(false, 0, true)
--     -- 设置添加的面板位置
--     local panelSize = child:getGroupBounds().size
--     -- print(panelSize.width, ",", panelSize.height)
--     local posX = (vSize.width - panelSize.width) / 2
--     local posY = (vSize.height + panelSize.height) / 2
--     print(vOrigin.x, ",", vOrigin.y)
--     print(posX,",",posY)
--     child:setPosition(ccp(posX, posY))

--     childContainer:addChild(colorLayer)
--     childContainer:addChild(child)

--     child.__bgCoverLayer = childContainer
--    	self:add(child, false, false)
-- end

function PopoutManager:addChildWithBackground(child, bgColor, opacity)
	assert(child)
	if not child.__bgCoverLayer then
		bgColor = bgColor or ccc3(0,0,0)
		opacity = opacity or 255 * 0.7
		local vSize = CCDirector:sharedDirector():getVisibleSize()
	    local vOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	    -- 创建蒙版，大小为可视区域
	     -- 设置添加的面板位置
	    local panelSize = child:getGroupBounds().size
	    -- print(vSize.width, ",", vSize.height)

	    local posX = 0 - (vSize.width - panelSize.width) / 2
	    local posY = 0 - (vSize.height + panelSize.height) / 2
	   	local childPosY = 0 - (vSize.height - panelSize.height) / 2

	    -- print(posX,",",posY,",", childPosY)

	    local colorLayer = LayerColor:create()
	    colorLayer:setPosition(ccp(posX, posY))
	    colorLayer:changeWidthAndHeight(vSize.width, vSize.height)
	    colorLayer:setColor(bgColor)
	    colorLayer:setOpacity(opacity)
	    colorLayer:setTouchEnabled(false, 0, true)
	    child:addChildAt(colorLayer, -99)

	    child.__bgCoverLayer = colorLayer
	    child:setPosition(ccp(-posX, childPosY))
	end

   	self:add(child, false, false)
end

function PopoutManager:haveWindowOnScreen()
	local scene		= Director:mgr():run()
	local popoutLayer	= scene.rootLayer:getChildByName("_pop_out_layer_")
	return popoutLayer and popoutLayer.popoutList and #popoutLayer.popoutList > 0
end

PopoutEvents = {
	kRemoveOnce = "removeOnce"
}

PopoutQueue = class()

local instance = nil
function PopoutQueue:sharedInstance()
	if not instance then
		instance = PopoutQueue.new()
		instance:init()
	end
	return instance
end

function PopoutQueue:init()
	self.queue = {}
end

function PopoutQueue:push(child, dark)
	if dark == nil then dark = true end
	local childInfo = {childPanel = child,
					   isDark = dark}
	table.insert(self.queue, childInfo)

	if #self.queue == 1 or not PopoutManager:sharedInstance():haveWindowOnScreen() then 
		self:add()
	end
	
	-- if not PopoutManager:sharedInstance():haveWindowOnScreen() then
	-- 	self:add()
	-- end
end

function PopoutQueue:add()
	local function removeOnceComplete(event)
		table.remove(self.queue, 1)

		self:add()	
	end
	if #self.queue > 0 then
		local childInfo = self.queue[1]
		if childInfo then 
			local childPanel = childInfo.childPanel
			if childPanel then 
				childPanel:ad(PopoutEvents.kRemoveOnce, removeOnceComplete)
				-- table.remove(self.queue, 1)
				PopoutManager.sharedInstance():add(childPanel, childInfo.isDark, false)
				if childPanel.popoutShowTransition and type(childPanel.popoutShowTransition) then
					childPanel:popoutShowTransition()
				end
			end
		end
	end	
end