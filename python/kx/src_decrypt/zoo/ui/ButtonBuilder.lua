-------------------------------------------------------------------------
--  Class include: GroupButtonBase
-------------------------------------------------------------------------

kGroupButtonColorMode = {green=1,orange=2,blue=3,grey=4}
kColorBlueConfig = {0.622222,0,0.021,0.07}
kColorOrangeConfig = {-0.4, 0.3147, 0.1255, 0.3957}
kColorGreyConfig = {0, -1, 0, 0}
kButtonTextAlignment = {center = 1, left = 2, right = 3}
--
-- GroupButtonBase ---------------------------------------------------------
--
GroupButtonBase = class(EventDispatcher)
function GroupButtonBase:ctor( groupNode )
	self.groupNode = groupNode
end
function GroupButtonBase:create( buttonGroup )
	local button = GroupButtonBase.new(buttonGroup)
	button:buildUI()
	return button
end

function GroupButtonBase:getContainer()
	return self.groupNode
end

function GroupButtonBase:getGroupBounds(targetCoordinateSpace)
	if self.groupNode and self.groupNode.refCocosObj then
		return self.groupNode:getGroupBounds(targetCoordinateSpace)
	end
	return nil
end

function GroupButtonBase:removeFromParentAndCleanup( cleanup )
	if self.groupNode and self.groupNode.refCocosObj then
		self.groupNode:removeFromParentAndCleanup(cleanup)
	end
end

function GroupButtonBase:setPositionX( positionX )
	if self.groupNode and self.groupNode.refCocosObj then
		self.groupNode:setPositionX(positionX)
	end
end
function GroupButtonBase:setPositionY( positionY )
	if self.groupNode and self.groupNode.refCocosObj then
		self.groupNode:setPositionY(positionY)
	end
end
function GroupButtonBase:getPositionX()
	if self.groupNode and self.groupNode.refCocosObj then
		return self.groupNode:getPositionX()
	end
end

function GroupButtonBase:getPositionY()
	if self.groupNode and self.groupNode.refCocosObj then
		return self.groupNode:getPositionY()
	end
end

function GroupButtonBase:setPosition( position )
	if self.groupNode and self.groupNode.refCocosObj then
		self.groupNode:setPosition(position)
	end
end
function GroupButtonBase:getPosition()
	if self.groupNode and self.groupNode.refCocosObj then
		return self.groupNode:getPosition()
	end
	return nil
end

function GroupButtonBase:setVisible( v )
	if self.groupNode and self.groupNode.refCocosObj then
		self.groupNode:setVisible(v)
	end
end

function GroupButtonBase:isVisible()
	if self.groupNode and self.groupNode.refCocosObj then
		return self.groupNode:isVisible()
	end
	return true
end

function GroupButtonBase:setString( str )
	local label = self.label
	if label and label.refCocosObj then
		if self.isStaticLabel then label:setString(str)
		else
			label:setText(str)
			InterfaceBuilder:centerInterfaceInbox( label, self.labelRect )
			--self:showDebugBounds()
		end
	end
end

function GroupButtonBase:getString()
	if self.label and self.label.refCocosObj then
		return self.label:getString()
	end
end

function GroupButtonBase:setTextAlignment(label, labelRect, alignment, isStatic)
	if label and labelRect and label.refCocosObj then
		if isStatic then
			if alignment == kButtonTextAlignment.left then
				label:setHorizontalAlignment(kCCTextAlignmentLeft)
			elseif alignment == kButtonTextAlignment.right then
				label:setHorizontalAlignment(kCCTextAlignmentRight)
			else
				label:setHorizontalAlignment(kCCTextAlignmentCenter)
			end
		else
			if alignment == kButtonTextAlignment.left then
				InterfaceBuilder:leftAligneInterfaceInbox(label, labelRect)
			elseif alignment == kButtonTextAlignment.right then
				InterfaceBuilder:rightAligneInterfaceInbox(label, labelRect)
			else
				InterfaceBuilder:centerInterfaceInbox( label, labelRect )
			end
		end
	end
end

function GroupButtonBase:setStringAlignment(alignment)
	self:setTextAlignment(self.label, self.labelRect, alignment, self.isStaticLabel)
end

function GroupButtonBase:setScale( scale )
	if self.groupNode and self.groupNode.refCocosObj then
		self.groupNode:setScale(scale)
		self.groupNode.transformData = nil
		self.groupNode:setButtonMode(true)
	end
end

function GroupButtonBase:getScale()
	if self.groupNode and self.groupNode.refCocosObj then
		return self.groupNode:getScale()
	end
	return 1
end

function GroupButtonBase:setColorMode( colorMode, force )
	if self.colorMode ~= colorMode or force then
		self.colorMode = colorMode
		local background = self.background
		if background and background.refCocosObj then
			if colorMode == kGroupButtonColorMode.green then background:clearAdjustColorShader()
			elseif colorMode == kGroupButtonColorMode.orange then
				--background:setHsv(301.42, 1.2336, 1.4941)
				background:adjustColor(kColorOrangeConfig[1],kColorOrangeConfig[2],kColorOrangeConfig[3],kColorOrangeConfig[4])
				background:applyAdjustColorShader()
			elseif colorMode == kGroupButtonColorMode.blue then
				--background:setHsv(103.968, 0.97315, 1.23361)
				background:adjustColor(kColorBlueConfig[1],kColorBlueConfig[2],kColorBlueConfig[3],kColorBlueConfig[4])
				background:applyAdjustColorShader()
			elseif colorMode == kGroupButtonColorMode.grey then
				background:adjustColor(kColorGreyConfig[1],kColorGreyConfig[2],kColorGreyConfig[3],kColorGreyConfig[4])
				background:applyAdjustColorShader()
			end
		end
	end
end
function GroupButtonBase:getColorMode()
	return self.colorMode
end

function GroupButtonBase:setEnabled( isEnabled, notChangeColor)
	if self.isEnabled ~= isEnabled then
		self.isEnabled = isEnabled

		if self.groupNode and self.groupNode.refCocosObj then
			self.groupNode:setTouchEnabled(isEnabled, 0, true)
			if not notChangeColor then 
				if isEnabled then
					self:setColorMode(self.colorMode, true)
				else
					local background = self.background
					if background and background.refCocosObj then
						background:applyAdjustColorShader()
						background:adjustColor(0,-1, 0, 0)
					end
				end
			end
		end		
	end
end

function GroupButtonBase:getEnabled()
	return self.isEnabled
end

-- 设置成灰色，但是仍可点击
-- 原因：需求中常常要求置灰，但可点击
function GroupButtonBase:setEnabledForColorOnly(enable)
	if self.groupNode and self.groupNode.refCocosObj then
		if enable then
			self:setColorMode(self.colorMode, true)
		else
			local background = self.background
			if background and background.refCocosObj then
				background:applyAdjustColorShader()
				background:adjustColor(0,-1, 0, 0)
			end
		end
	end
end


function GroupButtonBase:getParent()
	if self.groupNode and self.groupNode.refCocosObj then
		return self.groupNode:getParent()
	end
end

function GroupButtonBase:showDebugBounds()
	local label = self.label
	local labelSize = label:getContentSize()
	local labelPosi = label:getPosition()
	local boundsLayer = LayerColor:create()
	boundsLayer:setColor(ccc3(128,55,144))
	boundsLayer:setOpacity(80)
	boundsLayer:changeWidthAndHeight(labelSize.width, labelSize.height)
	boundsLayer:setAnchorPoint(ccp(0,0))
	boundsLayer:setPosition(ccp(labelPosi.x, labelPosi.y-labelSize.height))

	local parentLayer = label:getParent()
	if parentLayer then parentLayer:addChild(boundsLayer) end
end

function GroupButtonBase:useStaticLabel(fontSize, fontName, fontColor)
	self.isStaticLabel = true
	local rect = self.labelRect
	local label = TextField:create("",fontName, fontSize, CCSizeMake(rect.width, rect.height), kCCTextAlignmentCenter, kCCVerticalTextAlignmentCenter)
	label:setString(self:getString())
	label:setPosition(ccp(rect.x, rect.y))
	label:setAnchorPoint(ccp(0, 1))
	if fontColor ~= nil then label:setColor(fontColor) end

	local parent = self.label:getParent()
	if parent then
		self.label:removeFromParentAndCleanup(true)
		parent:addChild(label)
		self.label = label
	end
end

function GroupButtonBase:buildUI()
	if not self.groupNode then return end

	local groupNode = self.groupNode
	local label = groupNode:getChildByName("label")
	local labelSize = groupNode:getChildByName("labelSize")
	local background = groupNode:getChildByName("background")
	local size = labelSize:getContentSize() --labelSize:getGroupBounds() --
	local position = labelSize:getPosition()
	local scaleX = labelSize:getScaleX()
	local scaleY = labelSize:getScaleY()
	self.labelRect = {x=position.x, y=position.y, width=size.width*scaleX, height=size.height*scaleY}
	self.label = label
	self.background = background
	
	self:setColorMode(kGroupButtonColorMode.green)
	self:setEnabled(true)
	groupNode:setButtonMode(true)
	labelSize:removeFromParentAndCleanup(true)

	local function onTouchTap( evt )
		self:dispatchEvent(DisplayEvent.new(DisplayEvents.kTouchTap, self, evt.globalPosition))
		GamePlayMusicPlayer:playEffect(GameMusicType.kClickCommonButton)
	end
	groupNode:addEventListener(DisplayEvents.kTouchTap, onTouchTap)
end

function GroupButtonBase:useBubbleAnimation()
	local startButton = self.groupNode
	local deltaTime = 0.9
	local scaleX = startButton:getScaleX()
	local scaleY = startButton:getScaleY()
	local animations = CCArray:create()
	animations:addObject(CCScaleTo:create(deltaTime, scaleX * 0.98, scaleY * 1.03))
	animations:addObject(CCScaleTo:create(deltaTime, scaleX * 1.01, scaleY * 0.96))
	animations:addObject(CCScaleTo:create(deltaTime, scaleX * 0.98, scaleY * 1.03))
	animations:addObject(CCScaleTo:create(deltaTime, scaleX * 1, scaleY * 1))
	startButton:runAction(CCRepeatForever:create(CCSequence:create(animations)))
	startButton:setButtonMode(false)

	local btnWithoutShadow = self.background
	local function __onButtonTouchBegin( evt )
		if btnWithoutShadow and not btnWithoutShadow.isDisposed then
			btnWithoutShadow:setOpacity(200)
		end
	end
	local function __onButtonTouchEnd( evt )
		if btnWithoutShadow and not btnWithoutShadow.isDisposed then
			btnWithoutShadow:setOpacity(255)
		end
	end
	startButton:addEventListener(DisplayEvents.kTouchBegin, __onButtonTouchBegin)
	startButton:addEventListener(DisplayEvents.kTouchEnd, __onButtonTouchEnd)
end

--
-- ButtonNumberBase ---------------------------------------------------------
--
ButtonNumberBase = class(GroupButtonBase)
function ButtonNumberBase:create( buttonGroup )
	local button = ButtonNumberBase.new(buttonGroup)
	button:buildUI()
	return button
end
function ButtonNumberBase:buildUI()
	if not self.groupNode then return end

	GroupButtonBase.buildUI(self)
	local groupNode = self.groupNode
	local numberSize = groupNode:getChildByName("numberSize")
	local size = numberSize:getContentSize()
	local position = numberSize:getPosition()
	local scaleX = numberSize:getScaleX()
	local scaleY = numberSize:getScaleY()
	self.numberRect = {x=position.x, y=position.y, width=size.width*scaleX, height=size.height*scaleY}
	numberSize:removeFromParentAndCleanup(true)

	self.numberLabel = groupNode:getChildByName("number")
end


function ButtonNumberBase:setNumber( str )
	local numberLabel = self.numberLabel
	if numberLabel and numberLabel.refCocosObj then
		if self.isStaticNumberLabel then numberLabel:setString(str)
		else
			numberLabel:setText(str)
			InterfaceBuilder:centerInterfaceInbox( numberLabel, self.numberRect )
		end
	end
end
function ButtonNumberBase:getNumber()
	if self.numberLabel and self.numberLabel.refCocosObj then
		return self.numberLabel:getString()
	end
end
function ButtonNumberBase:setNumberAlignment(alignment)
	self:setTextAlignment(self.numberLabel, self.numberRect, alignment, self.isStaticNumberLabel)
end
function ButtonNumberBase:useStaticNumberLabel(fontSize, fontName, fontColor)
	self.isStaticNumberLabel = true
	local rect = self.numberRect
	local label = TextField:create("",fontName, fontSize, CCSizeMake(rect.width, rect.height), kCCTextAlignmentCenter, kCCVerticalTextAlignmentCenter)
	label:setString(self:getString())
	label:setPosition(ccp(rect.x, rect.y))
	label:setAnchorPoint(ccp(0, 1))
	if fontColor ~= nil then label:setColor(fontColor) end

	local parent = self.numberLabel:getParent()
	if parent then
		self.numberLabel:removeFromParentAndCleanup(true)
		parent:addChild(label)
		self.numberLabel = label
	end
end

--
-- ButtonIconsetBase ---------------------------------------------------------
--
ButtonIconsetBase = class(GroupButtonBase)
function ButtonIconsetBase:create( buttonGroup )
	local button = ButtonIconsetBase.new(buttonGroup)
	button:buildUI()
	return button
end

function ButtonIconsetBase:setIconByFrameName( frameName, forceScale )
	local image = assert(SpriteColorAdjust:createWithSpriteFrameName(frameName))
	image:setAnchorPoint(ccp(0, 1))
	self:setIcon(image, forceScale)
end

function ButtonIconsetBase:setIcon( icon, forceScale )
	if self.icon ~= icon then
		if self.icon then self.icon:removeFromParentAndCleanup(true) end
		self.icon = icon
		if icon and self.groupNode and self.groupNode.refCocosObj then
			self.groupNode:addChild(icon)
			InterfaceBuilder:centerInterfaceInbox( icon, self.iconRect, forceScale )
		end
	end
end
function ButtonIconsetBase:getIcon()
	return self.icon
end

function ButtonIconsetBase:buildUI()
	if not self.groupNode then return end

	GroupButtonBase.buildUI(self)
	local groupNode = self.groupNode
	local iconSize = groupNode:getChildByName("iconSize")
	if iconSize then
		local size = iconSize:getContentSize()
		local position = iconSize:getPosition()
		local scaleX = iconSize:getScaleX()
		local scaleY = iconSize:getScaleY()
		self.iconRect = {x=position.x, y=position.y, width=size.width*scaleX, height=size.height*scaleY}
		iconSize:removeFromParentAndCleanup(true)
	end
end

function ButtonIconsetBase:setIconEnabled( isEnabled )
	if self.icon and self.icon.refCocosObj then
		if isEnabled then self.icon:clearAdjustColorShader()
		else 
			self.icon:applyAdjustColorShader()
			self.icon:adjustColor(0,-1, 0, 0)
		end
	end
end

function ButtonIconsetBase:setEnabled( isEnabled ,notChangeColor)
	GroupButtonBase.setEnabled(self, isEnabled, notChangeColor)
	if not notChangeColor then 
		self:setIconEnabled(isEnabled)
	end
end

--
-- ButtonIconNumberBase ---------------------------------------------------------
--
ButtonIconNumberBase = class(ButtonIconsetBase)
function ButtonIconNumberBase:create( buttonGroup )
	local button = ButtonIconNumberBase.new(buttonGroup)
	button:buildUI()
	return button
end


function ButtonIconNumberBase:buildUI()
	if not self.groupNode then return end

	ButtonIconsetBase.buildUI(self)
	local groupNode = self.groupNode
	local numberSize = groupNode:getChildByName("numberSize")
	local size = numberSize:getContentSize()
	local position = numberSize:getPosition()
	local scaleX = numberSize:getScaleX()
	local scaleY = numberSize:getScaleY()
	self.numberRect = {x=position.x, y=position.y, width=size.width*scaleX, height=size.height*scaleY}
	numberSize:removeFromParentAndCleanup(true)

	self.numberLabel = groupNode:getChildByName("number")
end


function ButtonIconNumberBase:setNumber( str )
	local numberLabel = self.numberLabel
	if numberLabel and numberLabel.refCocosObj then
		if self.isStaticNumberLabel then numberLabel:setString(str)
		else
			numberLabel:setText(str)
			InterfaceBuilder:centerInterfaceInbox( numberLabel, self.numberRect )
		end
	end
end
function ButtonIconNumberBase:getNumber()
	if self.numberLabel and self.numberLabel.refCocosObj then
		return self.numberLabel:getString()
	end
end
function ButtonIconNumberBase:setNumberAlignment(alignment)
	self:setTextAlignment(self.numberLabel, self.numberRect, alignment, self.isStaticNumberLabel)
end

function ButtonIconNumberBase:useStaticNumberLabel(fontSize, fontName, fontColor)
	self.isStaticNumberLabel = true
	local rect = self.numberRect
	local label = TextField:create("",fontName, fontSize, CCSizeMake(rect.width, rect.height), kCCTextAlignmentCenter, kCCVerticalTextAlignmentCenter)
	label:setString(self:getString())
	label:setPosition(ccp(rect.x, rect.y))
	label:setAnchorPoint(ccp(0, 1))
	if fontColor ~= nil then label:setColor(fontColor) end

	local parent = self.numberLabel:getParent()
	if parent then
		self.numberLabel:removeFromParentAndCleanup(true)
		parent:addChild(label)
		self.numberLabel = label
	end
end



--
-- ButtonStartGame ---------------------------------------------------------
--
ButtonStartGame = class(ButtonIconNumberBase)
function ButtonStartGame:ctor( groupNode )
	self.groupNode = groupNode
	self.isMaxEnergyMode = false
end
function ButtonStartGame:create()
	local builder = InterfaceBuilder:createWithContentsOfFile("ui/common_ui.json")
	local buttonGroup = builder:buildGroup("ui_buttons/ui_start_button")
	local button = ButtonStartGame.new(buttonGroup)
	button:buildUI()
	return button
end
function ButtonStartGame:buildUI()
	if not self.groupNode then return end

	ButtonIconNumberBase.buildUI(self)
	local groupNode = self.groupNode
	self.infiniteEnergyIcon = groupNode:getChildByName("energy_icon")
	self.energyIcon = groupNode:getChildByName("icon")
	
	local labelRect = self.labelRect
	self.labelRectNormal = {x=labelRect.x, y=labelRect.y,width=labelRect.width,height=labelRect.height}
	self.labelRectInfinite = {x=labelRect.x + 60, y=labelRect.y,width=labelRect.width,height=labelRect.height}

	self:enableInfiniteEnergy(false)
end

function ButtonStartGame:enableInfiniteEnergy( enable )
	self.isMaxEnergyMode = enable
	if enable then
		self.infiniteEnergyIcon:setVisible(true)
		self.energyIcon:setVisible(false)
		self.numberLabel:setVisible(false)
		self.labelRect = self.labelRectInfinite
	else
		self.infiniteEnergyIcon:setVisible(false)
		self.labelRect = self.labelRectNormal
	end
	local str = self:getString() or ""
	self:setString(str)
end