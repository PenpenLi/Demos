local kHasFocusEvent = false
if __ANDROID then
	kHasFocusEvent = true
end

local DeviceType = {
	iPad3 = false,
	iPhone6 = false,
}
if __IOS then
	local deviceType = MetaInfo:getInstance():getMachineType() or ""
	for k,v in pairs(DeviceType) do
		DeviceType[k] = string.find(deviceType, k) ~= nil
	end
end


local Input = class(CocosObject)

function Input:validatePhone()
	local codeMatch = string.find(self:getText(),"^[1][3-8][0-9]%d%d%d%d%d%d%d%d$")
	if not codeMatch or codeMatch~=1 then
		CommonTip:showTip("请输入正确的手机号码！", "negative",function() self.input:openKeyBoard() end,2)
		return false	
	end
	return true
end

function Input:create(labelPlaceholder,panel)
	local input = Input.new(CCNode:create())
	input:init(labelPlaceholder,panel)
	return input
end

function Input:init( labelPlaceholder,panel)

	local labelSize = labelPlaceholder:getDimensions()
	local labelPosX = labelPlaceholder:getPositionX()
	local labelPosY = labelPlaceholder:getPositionY()

	self:setAnchorPoint(ccp(0,1))
	self:setPositionX(labelPosX)
	self:setPositionY(labelPosY)
	self:setContentSize(labelSize)

	
	local inputSize = labelSize
	local inputBg = Scale9Sprite.new(CCScale9Sprite:create())
	if __ANDROID then
		self.input = require("hecore.ui.AndroidEditText"):create(inputSize,inputBg)
		self.input:showClearButton()
	else
		self.input = TextInput:create(inputSize,inputBg)
		self.input.refCocosObj:setZoomOnTouchDown(false)
		self.input.refCocosObj:showClearButton()
	end

	self:setFontColor(labelPlaceholder:getColor())
	
	local inputPosition = ccp(labelSize.width/2,labelSize.height/2)
	
	if __IOS then
		if DeviceType.iPhone6 then
			inputPosition.x = inputPosition.x - 10
		else
			inputPosition.x = inputPosition.x - 5
		end

		if DeviceType.iPad3 then
			inputPosition.y = inputPosition.y - 5
		else
			inputPosition.y = inputPosition.y + 5
		end

		if DeviceType.iPad3 then
			self.input.refCocosObj:setClearButtonOffset(ccp(0,-10))
		end
	end

	self.input:setPosition(inputPosition)	
	self.input.originalPos = inputPosition
	self.input:runAction(CCCallFunc:create(function( ... )
		self.input:setPosition(inputPosition)	
	end))
	self:addChild(self.input)

	for _,v in pairs({
		-- "setVisible",
		"openKeyBoard",
		"closeKeyBoard",
		-- "setText",
		-- "getText",
		-- "setFontColor",
		-- "setPlaceHolder",
		-- "setPlaceholderFontColor",
		"setMaxLength",
		-- "setInputMode",
		-- "setInputFlag",

		"hasEventListener",
		"hasEventListenerByName",
		"addEventListener",
		"removeEventListener",
		"removeEventListenerByName",
		"removeAllEventListeners",
		"dp", 
		"he", 
		"hn", 
		"ad", 
		"rm", 
		"rma",
	}) do
		self[v] = function ( ... )
			local params = { ... } 
			params[1] = self.input
			return self.input[v](unpack(params))
		end
	end

	if panel then
		panel:addEventListener(PopoutEvents.kBecomeSecondPanel,function( ... )
			self:onBecomeSecondPanel()
		end)
		panel:addEventListener(PopoutEvents.kReBecomeTopPanel,function( ... )
			self:onReBecomeTopPanel()
		end)
	end

	if kHasFocusEvent and panel then
		if not panel.__inputs then
			panel.__inputs = {}
		end
		table.insert(panel.__inputs,self)
		self.input:addEventListener(kTextInputEvents.kGotFocus,function( ... )
			self:onGotFocus(panel)
		end)
		self.input:addEventListener(kTextInputEvents.kLostFocus,function( ... )
			self:onLostFocus(panel)
		end)
	end

	self.input:addEventListener(kTextInputEvents.kBegan,function( ... )
			self.inputBegan = true
	end)

	self.input:addEventListener(kTextInputEvents.kEnded,function( ... )
			self.inputBegan = false
	end)

	--default font colors
	self:setFontColor(ccc3(180,94,16))
	self:setPlaceholderFontColor(ccc3(241, 208, 165))
end

function Input:getText( ... )
	return self.input:getText() or ""
end

function Input:setText( text )
	self.input:setText(text)

	if self.placeHolderLabel then
		self.placeHolderLabel:setVisible(string.isEmpty(self:getText()))
	end
end
function Input:setFontColor( color )
	self.fontColor = color
	self.input:setFontColor(color)
end
function Input:getFontColor( ... )
	return self.fontColor or ccc3(0,0,0)
end
function Input:setPlaceHolder( text )
	self.placeHolderText = text

	if not self.placeHolderLabel then 
		local height = self:getContentSize().height
		local size = height - 12
		if __ANDROID then 
			size = height - 20 + 0.5			
		end

		if __IOS then
			size = (height + 10)/2 + 0.5
		end

		self.placeHolderLabel = TextField.new(CCLabelTTF:create("","",size))
		if __ANDROID then 
			self.placeHolderLabel:setAnchorPoint(ccp(0,0.5))
			self.placeHolderLabel:setPosition(ccp(0,self:getContentSize().height/2 + 3))
		elseif __IOS then
			self.placeHolderLabel:setAnchorPoint(ccp(0,0.5))
			self.placeHolderLabel:setPosition(ccp(0,self:getContentSize().height/2))
		else
			self.placeHolderLabel:setAnchorPoint(ccp(0,0.5))
			self.placeHolderLabel:setPosition(ccp(0,self:getContentSize().height/2))
		end
		self:addChild(self.placeHolderLabel)

		self.input:addEventListener(kTextInputEvents.kChanged,function( ... )
			self.placeHolderLabel:setVisible(string.isEmpty(self:getText()))
		end)
	end
	self.placeHolderLabel:setColor(self:getPlaceholderFontColor())
	self.placeHolderLabel:setString(text)
	self.placeHolderLabel:setVisible(string.isEmpty(self:getText()))
end
function Input:getPlaceHolder( ... )
	return self.placeHolderText or ""
end
function Input:setPlaceholderFontColor( color )
	self.placeholderFontColor = color
	self.input:setPlaceholderFontColor(color)

	if self.placeHolderLabel then
		self.placeHolderLabel:setColor(color)
	end
end
function Input:setInputMode( inputMode )
	self.inputMode = inputMode
	self.input:setInputMode(inputMode)
end

function Input:getInputMode( ... )
	return self.inputMode or -1
end

function Input:setInputFlag( inputFlag )
	self.inputFlag = inputFlag
	self.input:setInputFlag(inputFlag)
end

function Input:getInputFlag( ... )
	return self.inputFlag or -1
end

function Input:getPlaceholderFontColor( ... )
	return self.placeholderFontColor or ccc3(166,166,166)
end

function Input:onBecomeSecondPanel( ... )
	self.input:setPositionX(-100000)

	if not self.label then
		local height = self:getContentSize().height

		local size = height - 12
		if __ANDROID then 
			size = height - 20 + 0.5			
		end

		if __IOS then
			size = (height + 10)/2 + 0.5
		end

		self.label = TextField.new(CCLabelTTF:create("","",size))
		
		if __ANDROID then 
			self.label:setAnchorPoint(ccp(0,0.5))
			self.label:setPosition(ccp(0,self:getContentSize().height/2 + 3))
		elseif __IOS then
			self.label:setAnchorPoint(ccp(0,0.5))
			self.label:setPosition(ccp(0,self:getContentSize().height/2))
		else
			self.label:setAnchorPoint(ccp(0,0.5))
			self.label:setPosition(ccp(0,self:getContentSize().height/2))
		end

		self.label:setVisible(false)
		self:addChild(self.label)
	end

	if not string.isEmpty(self:getText()) then
		if self:getInputFlag() == kEditBoxInputFlagPassword then
			self.label:setString(string.rep("●",#self:getText()))
		else
			self.label:setString(self:getText())
		end

		--[[setTimeOut( function(...) 
			if  not self.isDisposed then
				self.label:setColor(self:getFontColor())
				self.label:setVisible(true)
			end
		end, 1/30 )]]--

		self:runAction(CCCallFunc:create(function( ... )
			self.label:setColor(self:getFontColor())
			self.label:setVisible(true)
		end))
	end
end

function Input:onReBecomeTopPanel( ... )
	self:runAction(CCCallFunc:create(function( ... )
		self.input:setPositionX(self.input.originalPos.x)
	end))

	if self.label then
		self.label:setVisible(false)
	end

end

function Input:onGotFocus( panel )

	local visibleSize = Director.sharedDirector():getVisibleSize()
	local bounds = panel.ui:getChildByName("bg"):getGroupBounds()

	visibleSize.height = math.max(visibleSize.height * 0.6,bounds.size.height)

	panel.__panelMovePos = ccp(
		visibleSize.width/2 - bounds.size.width/2,
		-visibleSize.height/2 + bounds.size.height/2
	)

	self:runAction(CCSequence:createWithTwoActions(
		CCDelayTime:create(0.1),
		CCCallFunc:create(function( ... )
			panel:setPosition(panel.__panelMovePos)

			for _,v in pairs(panel.__inputs) do
				v.input:setPosition(ccp(v.input:getPositionX(),v.input:getPositionY()))
			end
		end)
	))

end

function Input:onLostFocus( panel )

	local visibleSize = Director.sharedDirector():getVisibleSize()
	local bounds = panel.ui:getChildByName("bg"):getGroupBounds()

	panel.__panelMovePos = ccp(
		visibleSize.width/2 - bounds.size.width/2,
		-visibleSize.height/2 + bounds.size.height/2
	)

	self:runAction(CCSequence:createWithTwoActions(
		CCDelayTime:create(0.1),
		CCCallFunc:create(function( ... )
			panel:setPosition(panel.__panelMovePos)

			for _,v in pairs(panel.__inputs) do
				v.input:setPosition(ccp(v.input:getPositionX(),v.input:getPositionY()))
			end
		end)
	))

end

return Input