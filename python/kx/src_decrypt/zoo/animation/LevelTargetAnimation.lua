require "hecore.display.Director"
require "zoo.animation.CountDownAnimation"
require "zoo.panel.component.levelTarget.LevelTargetItem"
require "zoo.panel.component.levelTarget.TimeTargetItem"
require "zoo.panel.component.levelTarget.EndlessMayDayTargetItem"
require "zoo.panel.component.levelTarget.SeaOrderTargetItem"
require "zoo.panel.component.levelTarget.EndlessTargetItem"

kLevelTargetType = {drop = "drop", dig_move = "dig_move", time = "time", ice = "ice", move = "move",
					order1 = "order1", order2 = "order2", order3 = "order3", order4 = "order4", order5 = "order5", 
                    dig_move_endless = "dig_move_endless",
                    dig_move_endless_qixi = "dig_move_endless_qixi",
                    dig_move_endless_mayday = "dig_move_endless_mayday",
                    rabbit_weekly = "rabbit_weekly",
                    sea_order = "order6",
                    acorn = "acorn",
                     }
-- order1: normal,   order2: single props,     order3: compose props, order4: others{snow, coin}, order5:{balloon, blackCuteBall}
kLevelTargetTypeTexts = {drop = "level.target.drop.mode", 
						 dig_move = "level.target.dig.step.mode",
						 dig_time = "level.target.dig.time.mode",
						 dig_move_endless = "level.target.dig.endless.mode",
						 time = "level.target.time.mode",
						 ice = "level.target.ice.mode",
						 move = "level.target.step.mode",
						 order1 = "level.target.objective.mode",
						 order2 = "level.target.eliminate.effect.mode",
						 order3 = "level.target.swap.effect.mode",
						 order4 = "level.target.objective.mode",
						 order5 = "level.target.other.mode", 
                         dig_move_endless_qixi =  "level.target.dig.endless.mode.qixi",
                         dig_move_endless_mayday = "level.target.christmas",
                         rabbit_weekly = "level.target.rabbit.weekly.mode",
                         sea_order = "level.target.sea.order.mode",
                         acorn = "level.start.drop.key.mode",
                           }

LevelTargetAnimation = class()

function LevelTargetAnimation:ctor()
	local origin = Director:sharedDirector():getVisibleOrigin()
	local layer = Layer:create()
  	layer.name = "level target"
  	layer:setPosition(ccp(origin.x, origin.y))
  	self.layer = layer
end
function LevelTargetAnimation:dispose()
	for i=1,4 do
		self["c"..i]:rma()
	end
	self.time:rma()
end
function LevelTargetAnimation:create(topX)
	local ret = LevelTargetAnimation.new()
	ret:buildLevelTargets(topX)
	ret:buildLevelPanel()
	return ret
end

function LevelTargetAnimation:createIcon( itemType, id, width, height )
	if itemType == kLevelTargetType.time then
		local label = BitmapText:create("0000", "fnt/target_amount.fnt", -1, kCCTextAlignmentCenter)
		label:setPreferredSize(width, height)
		return label
	else
		local fullname = "target."..itemType
		if itemType == kLevelTargetType.drop 
			or itemType == kLevelTargetType.ice
			or itemType == kLevelTargetType.dig_move
            or itemType == kLevelTargetType.dig_move_endless 
            or itemType == kLevelTargetType.dig_move_endless_qixi
            or itemType == kLevelTargetType.rabbit_weekly
            or itemType == kLevelTargetType.acorn
            then
			-- do nothing.
		else
			fullname = fullname.."_"..id
		end

		local layer = Sprite:createEmpty()
		layer:setCascadeOpacityEnabled(true)
		local sprite = Sprite:createWithSpriteFrameName(fullname.." instance 10000")
		local spriteSize = sprite:getContentSize()
		local scaleFactor = 0.5
		sprite.name = "content"
		sprite:setCascadeOpacityEnabled(true)
		sprite:setScale(scaleFactor)
		sprite:setAnchorPoint(ccp(0,0))
		layer.name = "icon"
		layer:addChild(sprite)
		layer:setContentSize(CCSizeMake(spriteSize.width*scaleFactor, spriteSize.height*scaleFactor))

		layer.clone = function( self, copyParentAndPos )
			local old = self:getChildByName("content")
			local cloned = old:clone(false)
			local result = Sprite:createEmpty()
			local size = self:getContentSize()
			result.name = "icon"
			result:setCascadeOpacityEnabled(true)
			
			cloned.name = "content"
			cloned:setCascadeOpacityEnabled(true)
			cloned:setScale(0.5)
			cloned:setAnchorPoint(ccp(0,0))
			result:addChild(cloned)
			result:setContentSize(CCSizeMake(size.width, size.height))
			if copyParentAndPos then
				local position = self:getPosition()
				local parent = self:getParent()
				if parent then
					local grandParent = parent:getParent()
					if grandParent then 
						local position_parent = parent:getPosition()
						result:setPosition(ccp(position.x + position_parent.x, position.y + position_parent.y))
						grandParent:addChild(result)
					end
				end
			end
			return result
		end
		return layer
	end	
end

function LevelTargetAnimation:setTargets( targets, animationCallbackFunc, flyFinishedCallback )
	self.targets = targets
	self:setNumberOfTargets(#targets, animationCallbackFunc, flyFinishedCallback)
end

function LevelTargetAnimation:getNumberOfTargets(...)
	assert(#{...} == 0)

	return #self.targets
end

function LevelTargetAnimation:getLevelTileByIndex( index )
	if self:isTimeMode() or self:isMoveMode() then return self.time end
	return self["c"..index]
end

function LevelTargetAnimation:getTargetTypeByIndex( index )
	if self.targets then
		local selectedItem = self.targets[index]
		if selectedItem then return selectedItem.type end
	end
	return nil
end

function LevelTargetAnimation:getTargetTypeByTargets()
	if self.targets then
		local selectedItem = self.targets[1]
		if selectedItem then
			print("selectedItem.type", selectedItem.type)
			if selectedItem.type == kLevelTargetType.order2 or selectedItem.type == kLevelTargetType.order3 or selectedItem.type == kLevelTargetType.order5 then
				for k, v in ipairs(self.targets) do
					print("self.targets.type", v.type)
					if v.type ~= selectedItem.type then return kLevelTargetType.order1 end
				end
			end
			if selectedItem.type == kLevelTargetType.drop or
				selectedItem.type == kLevelTargetType.dig_move or
				selectedItem.type == kLevelTargetType.time or
				selectedItem.type == kLevelTargetType.ice or
				selectedItem.type == kLevelTargetType.move or 
                selectedItem.type == kLevelTargetType.dig_move_endless or
               
                selectedItem.type == kLevelTargetType.dig_move_endless_qixi or
                selectedItem.type == kLevelTargetType.dig_move_endless_mayday or
               
                selectedItem.type == kLevelTargetType.rabbit_weekly or 
                selectedItem.type == kLevelTargetType.acorn
                 then
				return selectedItem.type
			else
				return kLevelTargetType.order1
			end
		end
	end
	return nil
end

function LevelTargetAnimation:isMoveMode()
	return self:getTargetTypeByIndex(1) == kLevelTargetType.move
end
function LevelTargetAnimation:isTimeMode()
	return self:getTargetTypeByIndex(1) == kLevelTargetType.time
end
function LevelTargetAnimation:isEndlessMode()
    local isDigMoveEndless = (self:getTargetTypeByIndex(1) == kLevelTargetType.dig_move_endless)
    local isRabbitMatch = (self:getTargetTypeByIndex(1) == kLevelTargetType.rabbit_weekly)
    return isDigMoveEndless or isRabbitMatch
end
function LevelTargetAnimation:isEndLessMayDayMode()
	return self:getTargetTypeByIndex(1) == kLevelTargetType.dig_move_endless_mayday
end
function LevelTargetAnimation:isSeaOrderMode()
	return self:getTargetTypeByIndex(1) == kLevelTargetType.sea_order
end


function LevelTargetAnimation:setTargetNumber( itemType, itemId, itemNum, animate, globalPosition, rotation )
	if self:isTimeMode() then
		self.time:setTargetNumber(itemId, itemNum) -- this mode have no fly animation
	elseif self:isMoveMode() then
		self.time:setTargetNumber(itemId, itemNum) -- this mode have no fly animation
	else
		if itemType == kLevelTargetType.drop then
			self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
		elseif itemType == kLevelTargetType.acorn then 
			self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
		elseif itemType == kLevelTargetType.dig_move then
			self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
        elseif itemType == kLevelTargetType.dig_move_endless then
            self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
        elseif itemType == kLevelTargetType.rabbit_weekly then 
        	self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
        elseif itemType == kLevelTargetType.dig_move_endless_mayday then
        	if itemId == 2 then
        		self.c2:setTargetNumber(itemId, itemNum, animate, globalPosition)
        	else
        		self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
        	end
        	
		else
			for i=1,self.numberOfTargets do
				local item = self["c"..i]
				--print("setTargetNumber", itemType, itemId, itemNum)
				if item and item.itemId == itemId and item.itemType == itemType then
					item:setTargetNumber(itemId, itemNum, animate, globalPosition, rotation)
				end
			end
		end
	end
end

function LevelTargetAnimation:revertTargetNumber( itemType, itemId, itemNum )
	if itemType == kLevelTargetType.drop then
		self.c1:revertTargetNumber(itemId, itemNum)
	elseif itemType == kLevelTargetType.acorn then 
		self.c1:revertTargetNumber(itemId, itemNum)
	elseif itemType == kLevelTargetType.dig_move then
		self.c1:revertTargetNumber(itemId, itemNum)
	elseif itemType == kLevelTargetType.time then
		self.time:revertTargetNumber(itemId, itemNum) -- this mode have no fly animation
	elseif itemType == kLevelTargetType.dig_move_endless_mayday then
		if itemId == 0 then
			self.c1:revertTargetNumber( itemId, itemNum)
		elseif itemId == 2 then 
			self.c2:revertTargetNumber(itemId, itemNum)
		end
    elseif itemType == kLevelTargetType.rabbit_weekly then
        self.c1:revertTargetNumber(itemId, itemNum)
	else
		for i=1,self.numberOfTargets do
			local item = self["c"..i]
			if item and item.itemId == itemId and item.itemType == itemType then
				item:revertTargetNumber(itemId, itemNum)
			end
		end
	end
end

function LevelTargetAnimation:setPosX(posX, ...)
	assert(type(posX))
	assert(#{...} == 0)
	local scale = self.levelTarget:getScale()
	local offsetX = 0 
	if scale ~= 1 then offsetX = 20 end
	self.levelTarget:setPositionX(posX + offsetX)
end

function LevelTargetAnimation:getTopContentSize()
	return self.levelTarget:getContentSize()
end
function LevelTargetAnimation:buildLevelTargets(x)
  	local winSize = CCDirector:sharedDirector():getVisibleSize()
  	local levelTarget = ResourceManager:sharedInstance():buildGroup("ingame_level_targets")

  	local kPropListScaleFactor = 1
  	if __frame_ratio and __frame_ratio < 1.6 then  kPropListScaleFactor = 0.93 end
  	levelTarget:setScale(kPropListScaleFactor)

  	local targetSize = levelTarget:getGroupBounds().size
  	levelTarget:setContentSize(CCSizeMake(targetSize.width, targetSize.height))
  	levelTarget:setPosition(ccp(x, winSize.height))

	self.levelTarget = levelTarget

  	self.layer:addChild(levelTarget)
  	self.layer:setContentSize(CCSizeMake(targetSize.width, targetSize.height))

  	self.levelTarget = levelTarget
  	
  	local c1 = self.levelTarget:getChildByName("c1")
  	local content = c1:getChildByName("content")

  	self.time = self:buildTimeTargetItem()

  	self.flyOffsetY = content:getContentSize().height + c1:getContentSize().height + 7
  	self.flyOffsetX = content:getContentSize().width + c1:getContentSize().width/2

  	local leaf1 = levelTarget:getChildByName("leaf1")
  	local leaf1Pos = leaf1:getPosition()
  	local leaf2 = levelTarget:getChildByName("leaf2")
  	local leaf2Pos = leaf2:getPosition()

  	self.leftLeafPosition = {x=leaf1Pos.x, y=leaf1Pos.y}
  	self.rightLeafPosition = {x=leaf2Pos.x, y=leaf2Pos.y}
  	leaf1:removeFromParentAndCleanup(true)
  	leaf2:removeFromParentAndCleanup(true)

  	self.numberOfTargets = 4
  	self.targets = nil
end

function LevelTargetAnimation:getTargetCellSize(...)
	assert(#{...} == 0)

	assert(self.c1)
	local size = self.c1:getGroupBounds().size
	return size
end

function LevelTargetAnimation:buildLevelPanel()
	local winSize = CCDirector:sharedDirector():getVisibleSize()
  	local panel = ResourceManager:sharedInstance():buildGroup("level_target_panel")
  	local panelSize = panel:getGroupBounds().size
  	panel:setContentSize(CCSizeMake(panelSize.width, panelSize.height))
  	panel:setPosition(ccp((winSize.width - panelSize.width)/2, (winSize.height+panelSize.height)/2))
  	self.layer:addChild(panel)
  	self.panel = panel

  	panel.fadeIn = function ( self, delayBeforeTime )
  		delayBeforeTime = delayBeforeTime or 0
  		local panelChildren = {}
  		self:getVisibleChildrenList(panelChildren, {"icon"})
  		for i,child in ipairs(panelChildren) do
	  		child:setOpacity(0)
	  		child:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayBeforeTime), CCFadeIn:create(0.5)))
	  	end
  	end
  	panel.fadeOut = function ( self )
  		local panelChildren = {}
  		self:getVisibleChildrenList(panelChildren, {"icon"})
  		for i,child in ipairs(panelChildren) do
  			child:stopAllActions()
	  		child:runAction(CCFadeOut:create(0.2))
	  	end
  	end

  	local tip_label = panel:getChildByName("tip_label")
  	local title_label = panel:getChildByName("title_label")
  	local time_label = panel:getChildByName("time_label")

  	title_label.offsetX = title_label:getPosition().x
	title_label:setAlignment(kCCTextAlignmentCenter)

  	--stringKey, {level_number = self.levelId}
  	local tipSize = tip_label:getContentSize()
  	tip_label:setString("")
  	tip_label:setAnchorPoint(ccp(0.5, 0.5))
  	title_label:setString(Localization:getInstance():getText("level.target.title"))

  	time_label.offsetX = time_label:getPosition().x
	time_label:setAlignment(kCCTextAlignmentCenter)
	time_label:setAnchorPoint(ccp(0.5, 0.5))
  	time_label:setString("0")

  	self.time_label = time_label
  	self.tip_label = tip_label

  	local content = panel:getChildByName("content")
  	local contentPos = panel:getPosition()
  	local contentSize = panel:getContentSize()
  	self.panelContent = {x=contentPos.x, y=contentPos.y, width=contentSize.width,height=contentSize.height}
  	content:removeFromParentAndCleanup(true)

  	local timeBg = panel:getChildByName("time_bg")
  	self.timeBg = timeBg

  	for i=1,4 do
  		self["tile"..i] = self:buildPanelTileItem("tile"..i, i)
  	end
end

function LevelTargetAnimation:buildPanelTileItem( targetName, index )
	local sprite = self.panel:getChildByName(targetName)
	local spriteSize = sprite:getGroupBounds().size
	local content = sprite:getChildByName("content")
	local contentPos = content:getPosition()
	local contentSize = content:getContentSize()
	sprite:setContentSize(CCSizeMake(spriteSize.width, spriteSize.height))
	sprite.iconSize = {x = contentPos.x, y = contentPos.y, width=contentSize.width, height=contentSize.height}
	content:removeFromParentAndCleanup(true)

	local context = self
	sprite.setContentIcon = function( self, icon )
		if self.icon then
			self.icon:removeFromParentAndCleanup(true)
		end
		self.icon = icon		
		if self.icon and self.iconSize then
			local iconContentSize = self.iconSize
			local iconScale = self.icon:getScale()
			local iconSize = self.icon:getContentSize()
			local iconWidth = iconSize.width * iconScale
			local iconHeight = iconSize.height * iconScale
			local y = iconContentSize.y  - 42
			local x = iconContentSize.x + 42
			local offsetX, offsetY = 0, -4
			self.icon:setPosition(ccp(x + offsetX, y + offsetY))
			self:addChildAt(icon, 1)
		end
	end
	return sprite
end

function LevelTargetAnimation:buildTimeTargetItem()
	local sprite = self.levelTarget:getChildByName("time")

	return TargetItemFactory.create(TimeTargetItem, sprite, 0, self)
end

function LevelTargetAnimation:buildTargetItem( targetName, index )
	local sprite = self.levelTarget:getChildByName(targetName)

	return TargetItemFactory.create(LevelTargetItem, sprite, index, self)
end

function LevelTargetAnimation:setNumberOfTargets( v, animationCallbackFunc, flyFinishedCallback )
	if self.isInitialized then return end
	self.isInitialized = true

	v = v or 1
	if v < 1 then v = 1 end
	if v > 4 then v = 4 end

	self.numberOfTargets = v
	local delayBeforeTime = 1
	local delayTime = 3

	local isMoveMode = self:isMoveMode()
	local isTimeMode = self:isTimeMode()
    local isEndlessMode = self:isEndlessMode()
    local isEndLessMayDayMode = self:isEndLessMayDayMode()
    local isSeaOrderMode = self:isSeaOrderMode()

    local function createTargets(from, to)
    	for i=from,to do
  			self["c"..i] = self:buildTargetItem("c"..i, i)
  		end
    end

	if isTimeMode or isMoveMode then 
		createTargets(1, 4)
		self:updateTimeTargets()
    elseif isEndlessMode then
    	createTargets(2,4) 
    	self:updateEndlessTargets()
    elseif isEndLessMayDayMode then
    	createTargets(2,4)  
    	self:updateEndlessMayDayTargets()
    elseif isSeaOrderMode then 
    	self:updateSeaOrderTargets()
	else
		createTargets(1,4)
		self:updateNormalTargets() 
	end

	local panel = self.panel
	local winSize = CCDirector:sharedDirector():getVisibleSize()
  	local panelSize = panel:getContentSize()
  	local x = (winSize.width - panelSize.width)/2
  	local y = (winSize.height+panelSize.height)/2
  	panel:setPosition(ccp(x, y + 180))
  	panel:fadeIn(delayBeforeTime)

  	--fadein target
	if isTimeMode or isMoveMode then
		self.time_label:setOpacity(0)
		self.time_label:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayBeforeTime), CCFadeIn:create(0.5)))
	else
		for i=1,self.numberOfTargets do
			local iconSrc = self["tile"..i].icon
			if iconSrc then 
				iconSrc:setOpacity(0)
				iconSrc:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayBeforeTime), CCFadeIn:create(0.5)))
			end
		end
	end	
  	
  	local function onDelayFinished()
  		self.layer:rma()
		self.layer:setTouchEnabled(false)
  		self:flyTarget(animationCallbackFunc, flyFinishedCallback)
  	end 
  	
  	local sequence = CCArray:create()
  	sequence:addObject(CCDelayTime:create(delayBeforeTime))
  	sequence:addObject(CCEaseQuarticBackOut:create(CCMoveTo:create(0.5, ccp(x, y)), 33, -106, 126, -67, 15))
  	sequence:addObject(CCDelayTime:create(delayTime))
  	sequence:addObject(CCCallFunc:create(onDelayFinished))

	panel:stopAllActions()
	panel:runAction(CCSequence:create(sequence))

	local function onTouchLayer( evt )		
		panel:stopAllActions()

		self.layer:rma()
		self.layer:setTouchEnabled(false)
		self:flyTarget(animationCallbackFunc, flyFinishedCallback)
	end

	self.layer:ad(DisplayEvents.kTouchTap, onTouchLayer)
	self.layer:setTouchEnabled(true, -10000, true)
end

function LevelTargetAnimation:flyTarget(animationCallbackFunc, flyFinishedCallback)
	if self.isTargetFly then return end
	self.isTargetFly = true

	local panel = self.panel
	local isTimeMode = self:isTimeMode()
	local isMoveMode = self:isMoveMode()

	local function onAnimationFinished()
		self:dropLeaf() 
  		if self:isTimeMode() then 
  			self.time:fadeIn(0.3)
  		elseif self:isMoveMode() then
  			self.time:fadeIn(0.3)
  			if animationCallbackFunc ~= nil then animationCallbackFunc() end
  			if flyFinishedCallback ~= nil then flyFinishedCallback() end
  		else
  			if animationCallbackFunc ~= nil then animationCallbackFunc() end
  		end
  		self.panel:removeFromParentAndCleanup(true)
  	end

	local sequence = CCArray:create()
	sequence:addObject(CCDelayTime:create(0.4))
	sequence:addObject(CCCallFunc:create(onAnimationFinished))

	panel:stopAllActions()
	panel:fadeOut()
	panel:runAction(CCSequence:create(sequence))

	if isTimeMode or isMoveMode then
		self:flyTimeTarget()
	else
		for i=1,self.numberOfTargets do
			local iconSrc = self["tile"..i].icon
			local iconDst = self["c"..i].icon
			if iconSrc and iconDst then
				self:flyCollectTarget(iconSrc, iconDst, i)
			end
		end
	end	

	if isTimeMode then 
		local function onCountDownAnimationFinished()			
			if self.layer and not self.layer.isDisposed then 
				local winSize = CCDirector:sharedDirector():getVisibleSize()
				local star = FallingStar:create(ccp(winSize.width/2, winSize.height/2), 
							ccp(winSize.width - 100, winSize.height-100), 
							animationCallbackFunc, 
							flyFinishedCallback)
				self.layer:addChild(star) 
			end
		end

		local winSize = CCDirector:sharedDirector():getVisibleSize()
		local countDownAnimation = CountDownAnimation:create(0.1, onCountDownAnimationFinished)
		countDownAnimation:setPosition(ccp(winSize.width/2, winSize.height/2))
		self.layer:addChild(countDownAnimation)
	end
end

function LevelTargetAnimation:flyTimeTarget()
	local size = self.time_label:getContentSize()
	local position = self.time:getPosition()
	position = self.time:getParent():convertToWorldSpace(ccp(position.x, position.y))
	position = self.time_label:getParent():convertToNodeSpace(position)

	local time_position = self.time_label:getPosition()
	local tx, ty = time_position.x, time_position.y
	local function onAnimationFinished()
		self.time_label:setPosition(ccp(tx, ty))
	end 

	local spawn = CCArray:create()
	spawn:addObject(CCScaleTo:create(0.4, 1.1))
	spawn:addObject(CCFadeTo:create(1, 0))
	spawn:addObject(CCEaseBackIn:create(CCMoveTo:create(0.96, position)))

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.02))
	array:addObject(CCScaleTo:create(0.2, 1.65))
	array:addObject(CCSpawn:create(spawn)) 
	array:addObject(CCCallFunc:create(onAnimationFinished))

	self.time_label:stopAllActions()
	self.time_label:runAction(CCSequence:create(array))
end
function LevelTargetAnimation:flyCollectTarget( iconSrc, iconDst, index)
	local position = iconDst:getPosition()
	position = iconDst:getParent():convertToWorldSpace(ccp(position.x, position.y))
	position = iconSrc:getParent():convertToNodeSpace(position)

	local animationTime = 0.5
	local spawn = CCArray:create()
	spawn:addObject(CCEaseSineInOut:create(CCMoveTo:create(animationTime, position)))
	spawn:addObject(CCScaleTo:create(animationTime, 1))

	local sequence = CCArray:create()
	sequence:addObject(CCDelayTime:create(index * 0.1))
	sequence:addObject(CCSpawn:create(spawn))
	sequence:addObject(CCFadeOut:create(0.15))
	iconSrc:runAction(CCSequence:create(sequence))
end

function LevelTargetAnimation:updateEndlessMayDayTargets()
	self.c1 = TargetItemFactory.create(EndlessMayDayTargetItem, self.levelTarget:getChildByName("c1"), 1, self)

    self:updateNormalTargets()
end

--用这个函数来覆盖原有的setTargetNumber
function LevelTargetAnimation:updateSeaOrderTargets()

	for i=1, 4 do
  		self["c"..i] = TargetItemFactory.create(SeaOrderTargetItem, self.levelTarget:getChildByName("c"..i), i, self)
  	end

  	self:updateNormalTargets()
end

function LevelTargetAnimation:updateEndlessTargets()
    -- override 
    self.c1 =  TargetItemFactory.create(EndlessTargetItem, self.levelTarget:getChildByName("c1"), 1, self)
    self:updateNormalTargets()
end

function LevelTargetAnimation:updateTimeTargets()
	for i=1,4 do 
		 self["c"..i]:setVisible(false)
		 self["tile"..i]:setVisible(false)
	end
	local itemNum = self.targets[1].num
	self.time:setVisible(true)
	self.time:setContentIcon(nil, itemNum)
	self.time.itemNum = itemNum

	self.timeBg:setVisible(self:isTimeMode())
	self.time_label:setVisible(true)
	self.time_label:setString(tostring(itemNum or 0))

	local tileArray = CCArray:create()
	tileArray:addObject(CCDelayTime:create(3.6))
	tileArray:addObject(CCScaleTo:create(0.2, 1.6))
	tileArray:addObject(CCScaleTo:create(0.2, 1.27))
	self.time_label:runAction(CCSequence:create(tileArray))

	local itemType = self:getTargetTypeByTargets()
	self.tip_label:setString(Localization:getInstance():getText(kLevelTargetTypeTexts[itemType]))
	
	local tipSize = self.tip_label:getContentSize()
	local tipPos = self.tip_label:getPosition()

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(1.9))
	array:addObject(CCEaseElasticOut:create(CCScaleTo:create(1, 1.4)))
	self.tip_label:setScale(1)
	self.tip_label:stopAllActions()
	self.tip_label:runAction(CCSequence:create(array))
	self.tip_label:setPosition(ccp(tipPos.x + tipSize.width/2, tipPos.y - tipSize.height/2))
end
function LevelTargetAnimation:updateNormalTargets()
	local v = self.numberOfTargets
	for i=1,4 do 
		if i <= v then 
			self["c"..i]:setVisible(true)
			self["tile"..i]:setVisible(true) 
		else 
			self["c"..i]:setVisible(false) 
			self["tile"..i]:setVisible(false) 
		end
		self["c"..i]:reset()
	end
	self.time:setVisible(false)
	self.timeBg:setVisible(false)
	self.time_label:setVisible(false)

	local targetSize = self.levelTarget:getContentSize()
	local itemSize = self.c1:getContentSize()
	local itemPosition = self.c1:getPosition()

	local tileContentSize = self.panelContent
	local tileSize = self.tile1:getContentSize()
	local tilePosition = self.tile1:getPosition()
	
	local gap, totalWidth = 10, itemSize.width
	local tileGap, tileTotalWidth = 2, tileSize.width

	if v == 4 then gap, tileGap = 10, 2
	elseif v == 3 then gap, tileGap = 20, 12
	elseif v == 2 then gap, tileGap = 30, 30 end

	totalWidth = gap * (v - 1) + itemSize.width * v
	tileTotalWidth = tileGap * (v - 1) + tileSize.width * v

	local offsetX = (targetSize.width - totalWidth) / 2
	local tileOffsetX = (tileContentSize.width - tileTotalWidth) / 2 + tileContentSize.x
	if v == 1 then tileOffsetX = tileOffsetX - 40 end

	for i=1,v do
		local itemX = (itemSize.width + gap) * (i - 1) + itemSize.width/2
		local item = self["c"..i]
		local targetContent = nil
		local targetID, targetNum, targetType

		if self.targets then targetContent = self.targets[i] end
		if targetContent then targetID, targetNum, targetType = targetContent.id, targetContent.num, targetContent.type end
		local icon = LevelTargetAnimation:createIcon(targetType, targetID, item.iconSize.width, item.iconSize.height)
		item.itemId = targetID
		item.itemNum = targetNum
		item.itemType = targetType
		item:setContentIcon(icon, targetNum)
		item:setPosition(ccp(offsetX + itemX, itemPosition.y))

		local tileX = (tileSize.width + tileGap) * (i - 1) 
		local tile = self["tile"..i]
		local tileIcon = LevelTargetAnimation:createIcon(targetType, targetID, item.iconSize.width, item.iconSize.height)
		tileIcon:setScale(1.6)
		tile:setContentIcon(tileIcon)
		tile:setPosition(ccp(tileOffsetX + tileX, tilePosition.y))

		local tileArray = CCArray:create()
		tileArray:addObject(CCDelayTime:create(3.3 + i * 0.3))
		tileArray:addObject(CCScaleTo:create(0.3, 2.2))
		tileArray:addObject(CCScaleTo:create(0.3, 1.5))
		tileIcon:runAction(CCSequence:create(tileArray))
	end

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(1.9))
	array:addObject(CCEaseElasticOut:create(CCScaleTo:create(1, 1.4)))
	local itemType = self:getTargetTypeByTargets()
	self.tip_label:setScale(1)
	self.tip_label:setString(Localization:getInstance():getText(kLevelTargetTypeTexts[itemType]))
	self.tip_label:stopAllActions()
	self.tip_label:runAction(CCSequence:create(array))

	local tipSize = self.tip_label:getContentSize()
	local tipPos = self.tip_label:getPosition()
	self.tip_label:setPosition(ccp(tipPos.x + tipSize.width/2, tipPos.y - tipSize.height/2))
end

function LevelTargetAnimation:dropLeaf()
  	self:playLeafAnimation(true)
  	self:playLeafAnimation(false)

  	if self:isTimeMode() or self:isMoveMode() then
  		self.time:shake()
  	else
	  	for i=1,self.numberOfTargets do
	  		self["c"..i]:shake()
	  	end
  	end
end

function LevelTargetAnimation:playLeafAnimation( isLeft )
	local position
	local offsetX, offsetY = 0, -200
	if isLeft then
		position = self.leftLeafPosition
		offsetX = -90
	else
		position = self.rightLeafPosition
		offsetX = 90
	end
	local maxLeaf = 1 + math.floor(math.random()*2)
	for i = 1, 3 do
		local leaf = Sprite:createWithSpriteFrameName("ingame_level_leaf0000")
		leaf:setPosition(ccp(position.x, position.y+20))
		leaf:setScale(0.5+math.random()*0.5)
		leaf:setRotation(math.random()*360)
		local function onLeafFinished( )
			leaf:removeFromParentAndCleanup(true)
		end 
		local fadeOutTime = math.random()*0.8 + 0.7
		local x = offsetX*0.3 + math.random()*offsetX*0.7
		local y = offsetY*0.5 + math.random()*offsetY*0.5
		local moveOut = CCMoveBy:create(fadeOutTime, ccp(x, y))

		local outArray = CCArray:create()
		outArray:addObject(CCFadeOut:create(fadeOutTime))
		outArray:addObject(CCEaseSineOut:create(moveOut))
		outArray:addObject(CCScaleTo:create(fadeOutTime, 0.5))

		local array = CCArray:create()
		array:addObject(CCDelayTime:create(math.random()*0.6 + 0.2))
		array:addObject(CCSpawn:create(outArray))
		array:addObject(CCCallFunc:create(onLeafFinished))
		leaf:runAction(CCSequence:create(array))
		leaf:runAction(CCRepeatForever:create(CCRotateBy:create(0.3, 50)))
		self.levelTarget:addChild(leaf)
	end
end

function LevelTargetAnimation:highlightTarget(itemType, itemId, enable, showRaccoon)
    for i=1,self.numberOfTargets do
        local item = self["c"..i]
        print("setTargetNumber", item.itemId, item.itemType)
        if item and item.itemId == itemId and item.itemType == itemType then
            item:highlight(enable, showRaccoon)
        end
    end
end