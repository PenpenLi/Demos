-------------------------------------------------------------------------
--  Class include: TextField, BitmapText, TextInput
-------------------------------------------------------------------------

require "hecore.display.CocosObject"
require "hecore.display.Layer"

-- TextField -> CCLabelTTF
-- BitmapText -> CCLabelBMFont

kVerticalTextAlignment = {kCCVerticalTextAlignmentTop, kCCVerticalTextAlignmentCenter, kCCVerticalTextAlignmentBottom}
kTextAlignment = {kCCTextAlignmentLeft, kCCTextAlignmentCenter, kCCTextAlignmentRight}



--
-- TextField ---------------------------------------------------------
--

TextField = class(CocosObject);

function TextField:toString()
	return string.format("TextField [%s]", self.name and self.name or "nil");
end
function TextField:getVisibleChildrenList(dst, excluce)
  local name = self.name
  local valid = self:isVisible()
  if valid and excluce and #excluce > 0 then
    for i,v in ipairs(excluce) do
      if name and v == name then 
        valid = false
        break
      end
    end
  end
  if valid then table.insert(dst, self) end
end

--
-- public props ---------------------------------------------------------
--
function TextField:getString() return self.refCocosObj:getString() end
function TextField:setString(v) self.refCocosObj:setString(v) end	

--ccColor3B
function TextField:getColor() return self.refCocosObj:getColor() end
function TextField:setColor(v) 
  self.refCocosObj:setColor(v) 
  --HeDisplayUtil:setFontFillColor(self.refCocosObj, v)
end

function TextField:getHorizontalAlignment() return self.refCocosObj:getHorizontalAlignment() end
function TextField:setHorizontalAlignment(v) self.refCocosObj:setHorizontalAlignment(v) end

function TextField:getVerticalAlignment() return self.refCocosObj:getVerticalAlignment() end
function TextField:setVerticalAlignment(v) self.refCocosObj:setVerticalAlignment(v) end

function TextField:getDimensions() return self.refCocosObj:getDimensions() end
function TextField:setDimensions(v) self.refCocosObj:setDimensions(v) end

function TextField:getFontSize() return self.refCocosObj:getFontSize() end
function TextField:setFontSize(v) self.refCocosObj:setFontSize(v) end

function TextField:getFontName() return self.refCocosObj:getFontName() end
function TextField:setFontName(v) self.refCocosObj:setFontName(v) end

--CCSize &shadowOffset, float shadowOpacity, float shadowBlur, bool mustUpdateTexture
function TextField:enableShadow(shadowOffset, shadowOpacity, shadowBlur, mustUpdateTexture) 
  if mustUpdateTexture == nil then mustUpdateTexture = true end
  HeDisplayUtil:enableShadow(self.refCocosObj, shadowOffset, shadowOpacity, shadowBlur, mustUpdateTexture) 
end
function TextField:disableShadow(mustUpdateTexture) 
  if mustUpdateTexture == nil then mustUpdateTexture = true end
  HeDisplayUtil:disableShadow(self.refCocosObj, mustUpdateTexture)
end

--ccColor3B &strokeColor, float strokeSize, bool mustUpdateTexture
--[[
function TextField:enableStroke(strokeColor, strokeSize, mustUpdateTexture) 
  if mustUpdateTexture == nil then mustUpdateTexture = true end
  HeDisplayUtil:enableStroke(self.refCocosObj, strokeColor, strokeSize, mustUpdateTexture) 
end
function TextField:disableStroke(mustUpdateTexture) 
  if mustUpdateTexture == nil then mustUpdateTexture = true end
  HeDisplayUtil:disableStroke(self.refCocosObj, mustUpdateTexture)
end
]]
function TextField:setFontFillColor(tintColor, mustUpdateTexture) 
  if mustUpdateTexture == nil then mustUpdateTexture = true end
  HeDisplayUtil:setFontFillColor(self.refCocosObj, tintColor, mustUpdateTexture)
end

function TextField:addStroke( strokeColor, strokeSize, opacity, degree )
  degree = degree or 36
  opacity = opacity or 255
  local stroke = CocosObject.new(HeDisplayUtil:createStroke(self.refCocosObj, strokeSize, strokeColor, opacity, degree))
  local parent = self:getParent()
  if parent then
    local index = parent:getChildIndex(self)
    parent:addChildAt(stroke, index)
    local position = self:getPosition()
    local size = self:getContentSize()
    stroke:setPositionXY(position.x+size.width/2, position.y - size.height/2)
  end
  return stroke
end

--static creation function
function TextField:create(str, fontName, fontSize, dimensions, hAlignment, vAlignment)
  str = str or ""
  fontName = fontName or "Helvetica"
  fontSize = fontSize or 12
  dimensions = dimensions or CCSizeMake(0,0)
  hAlignment = hAlignment or kCCTextAlignmentLeft
  vAlignment = vAlignment or kCCVerticalTextAlignmentTop
  local label = CCLabelTTF:create(str, fontName, fontSize, dimensions, hAlignment, vAlignment)
  return TextField.new(label)
end

function TextField:createCopy(label)
  local copy =  TextField:create(label:getString(), 
                                 label:getFontName(), 
                                 label:getFontSize(), 
                                 label:getDimensions(),
                                 label:getHorizontalAlignment(),
                                 label:getVerticalAlignment())
  copy:setAnchorPoint(ccp(label:getAnchorPoint().x, label:getAnchorPoint().y))
  copy:setPosition(ccp(label:getPosition().x, label:getPosition().y))
  copy:setColor(ccc3(label:getColor().r, label:getColor().g, label:getColor().b))
  copy:setOpacity(label:getOpacity())
  return copy
end

--added interfaces by jet.zhao<<

 TextRollEvents = {
  kRollProcess = "RollProcess",
  kRollFinished = "RollFinished"
}

function TextField:createWithUIAdjustment(adjustRect, placeholderLabel, ...)
	assert(#{...} == 0)

	placeholderLabel:removeFromParentAndCleanup(false)

	local uiAdjustData = {}

	-- -------------------------
	-- Get Info From adjustRect
	-- ------------------------
	if adjustRect then

		local adjustRectParent	= adjustRect:getParent()
		local adjustRectSize	= adjustRect:getGroupBounds(adjustRectParent).size
		local adjustRectPos	= adjustRect:getPosition()

		 uiAdjustData.rectSize	= {width = adjustRectSize.width, height = adjustRectSize.height}
		 uiAdjustData.rectPos	= {x = adjustRectPos.x, y = adjustRectPos.y}
	 end

	--
	-- Get Info From placeholderLabel
	---
	local fntFile 		= placeholderLabel.fntFile
	local hAlignment	= placeholderLabel.hAlignment

	uiAdjustData.hAlignment = hAlignment

	
	--------------------------
	-- Check If It's A Dynamic Label
	-- -----------------------------
	local newLabel	= false

	if fntFile then
		-- It's A Dynamic Label

		newLabel	= BitmapText:create("", fntFile, -1, kCCTextAlignmentLeft)
		newLabel:ignoreAnchorPointForPosition(false)
		newLabel:setAnchorPoint(ccp(0,1))

		placeholderLabel:dispose()

	else
		-- It's A Static Label
		--newLabel	= TextField:create("")
		return placeholderLabel
	end

	newLabel.labelType = "for_ui_adjustment"
	newLabel.uiAdjustData = uiAdjustData

	-----------------------
	-- If Set Rect Visible
	-- ---------------------
	local config = UIConfigManager:sharedInstance():getConfig()
	local showUIAdjustRect	= config.textField_showUIAdjustRect

	if not showUIAdjustRect then
		if adjustRect then
			adjustRect:setVisible(false)
		end
	end
	
	return newLabel
end

function TextField:beginRollText( fromNum, toNum, format )
  format = format or "%d"
  local currentNum
  local function updateText( dt )
    if currentNum >= toNum then
      self:endRollText()
      return
    end
    currentNum = currentNum + 1
    self:setString(string.format(format, currentNum))
    self:dispatchEvent(Event.new(TextRollEvents.kRollProcess, 1, self))
  end
  currentNum = fromNum
  self.updateTextEntry = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateText, 0, false)
end

function TextField:endRollText(  )
  if self.updateTextEntry then
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.updateTextEntry)
    self.updateTextEntry = nil
    self:dispatchEvent(Event.new(TextRollEvents.kRollFinished, nil, self))
  end
end

function TextField:setPreferredSize(width, height, ...)
	assert(type(width) == "number")
	assert(type(height) == "number")
	assert(#{...} == 0)

	self.preferredWidth	= width
	self.preferredHeight	= height
end

function TextField:getPreferredSize(...)
	assert(#{...} == 0)

	local size = CCSizeMake(self.preferredWidth, self.preferredHeight)
	return size
end

--added interfaces by jet.zhao>>


--
-- BitmapText ---------------------------------------------------------
--


BitmapText = class(CocosObject);

function BitmapText:toString()
	return string.format("TextField [%s]", self.name and self.name or "nil");
end
function BitmapText:getVisibleChildrenList(dst, excluce)
  local name = self.name
  local valid = self:isVisible()
  if valid and excluce and #excluce > 0 then
    for i,v in ipairs(excluce) do
      if name and v == name then 
        valid = false
        break
      end
    end
  end
  if valid then table.insert(dst, self) end
end
--
-- public props ---------------------------------------------------------
--
function BitmapText:setText( v )
  self.refCocosObj:setString(v) 
end
function BitmapText:getString() return self.refCocosObj:getString() end
function BitmapText:setString(v) 

	self:setScale(1)
	self.refCocosObj:setString(v) 

	if self.labelType == "for_ui_adjustment" then

		local selfParent	= self:getParent()

		local rectSize		= self.uiAdjustData.rectSize
		local rectPos		= self.uiAdjustData.rectPos
		local hAlignment	= self.uiAdjustData.hAlignment

		if rectSize then
			-- Scale Size
			local selfSize		= self:getContentSize()
			local deltaScaleY	= rectSize.height / selfSize.height
			self:setScale(deltaScaleY)

			-- Alignment
			--local newSize	= self:getGroupBounds(selfParent).size
			local newSize = {} 
			newSize.width 	= selfSize.width * deltaScaleY
			newSize.height	= selfSize.height * deltaScaleY

			if hAlignment == kCCTextAlignmentLeft then
				self:setPosition(ccp(rectPos.x, rectPos.y))

			elseif hAlignment == kCCTextAlignmentRight then
				self:setPosition(ccp(rectPos.x + rectSize.width - newSize.width, rectPos.y))

			elseif hAlignment == kCCTextAlignmentCenter then
				 local deltaWidth 	= rectSize.width - newSize.width
				 local halfDeltaWidth	= deltaWidth / 2
				 self:setPosition(ccp(rectPos.x + halfDeltaWidth, rectPos.y))
			else
				assert(false)
			end
		else
			self:setAlpha(0.5)
		end
	else
		-- Adjust The Width And Height To Preferred Size
		assert(self.preferredWidth)
		assert(self.preferredHeight)

		local contentSize = self:getContentSize() 
		local neededScaleY = self.preferredHeight / contentSize.height
		local neededScaleX = self.preferredWidth / contentSize.width

		-- Get The Smallest Scale Need To Apply
		local smallestScale = false
		
		if neededScaleX < neededScaleY then
			smallestScale = neededScaleX
		else
			smallestScale = neededScaleY
		end

		self:setScaleX(smallestScale)
		self:setScaleY(smallestScale)

	  local position = self:getPosition()
	  local offsetX = self.offsetX or 0
	  
	  if self.alignment == kCCTextAlignmentRight then
	    self:setPositionXY(self.preferredWidth - contentSize.width + offsetX, position.y)
	  elseif self.alignment == kCCTextAlignmentCenter then  
	    local anchor = self:getAnchorPoint()
	    local x = (self.preferredWidth - contentSize.width)/2 + offsetX
	    if self.offsetY == nil then self.offsetY = position.y end
	    local y = self.offsetY
	    self:setPositionXY(x + contentSize.width * anchor.x, y - contentSize.height * (1-anchor.y))
	  end
	end
end	

function BitmapText:setAlignment(alignment) 
  self.alignment = alignment
  self.refCocosObj:setAlignment(alignment) 
end
function BitmapText:setLineBreakWithoutSpace(breakWithoutSpace) self.refCocosObj:setLineBreakWithoutSpace(breakWithoutSpace) end

function BitmapText:getFntFile() return self.refCocosObj:getFntFile() end --string
function BitmapText:setFntFile(v) self.refCocosObj:setFntFile(v) end

--ccColor3B
function BitmapText:getColor() return self.refCocosObj:getColor() end
function BitmapText:setColor(v) self.refCocosObj:setColor(v) end

function BitmapText:getOpacity() return self.refCocosObj:getOpacity() end
function BitmapText:setOpacity(v) self.refCocosObj:setOpacity(v) end

function BitmapText:isOpacityModifyRGB() return self.refCocosObj:isOpacityModifyRGB() end
function BitmapText:setOpacityModifyRGB(v) self.refCocosObj:setOpacityModifyRGB(v) end

function BitmapText:setWidth( v )
  self.refCocosObj:setWidth(v)
end
function BitmapText:create(str, fntFile, width, alignment, imageOffset)
  if not fntFile then 
    print("create bitmap font fail. nill of fnt file")
    return nil 
  end

  if ResourceFntPixelFormat[fntFile] ~= nil then
    CCTexture2D:setDefaultAlphaPixelFormat(ResourceFntPixelFormat[fntFile])
  end

  local prefix = string.split(fntFile, ".")[1]
  local realFntFile = fntFile
  if __use_small_res then  
    realFntFile = prefix .. "@2x.fnt"
  end

  str = str or ""
  width = width or -1
  alignment = alignment or kCCTextAlignmentLeft
  imageOffset = imageOffset or CCPointMake(0,0)
  local label = CCLabelBMFont:create(str, realFntFile, width, alignment, imageOffset)
  label.alignment = alignment

  CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888)
  return BitmapText.new(label)
end

function BitmapText:setPreferredSize(width, height, ...)
	assert(type(width) == "number")
	assert(type(height) == "number")
	assert(#{...} == 0)

	self.preferredWidth	= width
	self.preferredHeight	= height
end

function BitmapText:getPreferredSize(...)
	assert(#{...} == 0)
	
	local size = CCSizeMake(self.preferredWidth, self.preferredHeight)
	return size
end

--
-- TextInput ---------------------------------------------------------
--



kEditBoxInputMode = {
    kEditBoxInputModeAny,
    kEditBoxInputModeEmailAddr,
    kEditBoxInputModeNumeric,
    kEditBoxInputModePhoneNumber,
    kEditBoxInputModeUrl,
    kEditBoxInputModeDecimal,
    kEditBoxInputModeSingleLine
}
kEditBoxInputFlag = {
    kEditBoxInputFlagPassword,
    kEditBoxInputFlagSensitive,
    kEditBoxInputFlagInitialCapsWord,
    kEditBoxInputFlagInitialCapsSentence,
    kEditBoxInputFlagInitialCapsAllCharacters
}
kKeyboardReturnType = {
    kKeyboardReturnTypeDefault,
    kKeyboardReturnTypeDone,
    kKeyboardReturnTypeSend,
    kKeyboardReturnTypeSearch,
    kKeyboardReturnTypeGo
}

kTextInputEvents = {
  kBegan = "began", kEnded = "ended", kChanged = "changed", kReturn = "return"
} 

TextInput = class(CocosObject);

function TextInput:toString()
  return string.format("TextInput [%s]", self.name and self.name or "nil");
end

--
-- public props ---------------------------------------------------------
--
function TextInput:getText() return self.refCocosObj:getText() end
function TextInput:setText(v) self.refCocosObj:setText(v) end

--ccColor3B
function TextInput:setFontColor(v) self.refCocosObj:setFontColor(v) end
function TextInput:setPlaceholderFontColor(v) self.refCocosObj:setPlaceholderFontColor(v) end

function TextInput:getPlaceHolder() return self.refCocosObj:getPlaceHolder() end
function TextInput:setPlaceHolder(v) return self.refCocosObj:setPlaceHolder(v) end


function TextInput:getMaxLength() return self.refCocosObj:getMaxLength() end
function TextInput:setMaxLength(v) self.refCocosObj:setMaxLength(v) end

--EditBoxInputMode
function TextInput:setInputMode(v) self.refCocosObj:setInputMode(v) end
--EditBoxInputFlag
function TextInput:setInputFlag(v) self.refCocosObj:setInputFlag(v) end
--KeyboardReturnType
function TextInput:setReturnType(v) self.refCocosObj:setReturnType(v) end

function TextInput:setAnchorPoint(v)
  --setAnchorPoint is not supported. by default, anchor point is set to the center.
end
--
--
-- static create function ---------------------------------------------------------
--
local function getRefCocosObject( wrapper, shouldDispose )
  print(type(wrapper, "wrapper"))
  local ret = nil
  if type(wrapper) == "userdata" then
    ret = wrapper
  elseif type(wrapper) == "table" and type(wrapper.is) == "function" then
    ret = wrapper.refCocosObj
    if shouldDispose and type(wrapper.dispose) == "function" then 
      if wrapper.parent then wrapper:removeFromParentAndCleanup(true)
      else wrapper:dispose() end
    end
  end
  return ret
end

function TextInput:create(size, pNormal9SpriteBg, pPressed9SpriteBg, pDisabled9SpriteBg, releaseScale9Sprite)
  local shouldDispose = true
  if releaseScale9Sprite ~= nil then shouldDispose = releaseScale9Sprite end

  local pressed9SpriteBg = getRefCocosObject(pPressed9SpriteBg, shouldDispose)
  local disabled9SpriteBg = getRefCocosObject(pDisabled9SpriteBg, shouldDispose)
  local normal9SpriteBg = getRefCocosObject(pNormal9SpriteBg, shouldDispose)

  if not size or not normal9SpriteBg then
    print("create text input fail. invalid params.")
  end

  local textInput = nil
  local function editBoxEventHandler( event )
    local evt = Event.new(event, nil, textInput)
    if textInput and textInput:hasEventListenerByName(event) then textInput:dispatchEvent(evt) end
  end

  local text = CCEditBox:create(size, normal9SpriteBg, pressed9SpriteBg, disabled9SpriteBg)
  text:registerScriptEditBoxHandler(editBoxEventHandler)

  textInput = TextInput.new(text)
  return textInput
end



---------------------------------------------------
-------------- LabelBMFontBatch
---------------------------------------------------

assert(not BMFontLabelBatch)
BMFontLabelBatch = class(CocosObject)

function BMFontLabelBatch:createLabel(str, ...)
	assert(type(str) == "string")
	assert(#{...} == 0)

	local cppSprite = self.refCocosObj:createLabel(str)
	assert(cppSprite)
	local luaSprite = Sprite.new(cppSprite)
	assert(luaSprite.refCocosObj)

	return luaSprite
end

function BMFontLabelBatch:create(imageFile, fontFile, capacity, ...)
	assert(type(imageFile) == "string")
	assert(type(fontFile) == "string")
	assert(type(capacity) == "number")
	assert(#{...} == 0)

	  local prefix = string.split(fontFile, ".")[1]
	  local imagePrefix = string.split(imageFile, ".")[1]

	  local realFntFile = fontFile
	  local realImageFile = imageFile

	  if __use_small_res then  
	    realFntFile = prefix .. "@2x.fnt"
	    realImageFile = imagePrefix .. "@2x.png"
	  end
	  
	local batch = LabelBMFontBatch:create(realImageFile, realFntFile, capacity)
	assert(batch)

	local newLabelBMFontBatch = BMFontLabelBatch.new(batch)
	return newLabelBMFontBatch
end

---------------------------------------------------
-------------- LabelBMMonospaceFont
---------------------------------------------------

assert(not LabelBMMonospaceFont)
LabelBMMonospaceFont = class(Layer)
function LabelBMMonospaceFont:ctor()
  self.isInitializedLabel = false
end
function LabelBMMonospaceFont:init(charWidth, charHeight, charInterval, fntFile, ...)
	assert(type(charWidth) == "number")
	assert(type(charHeight) == "number")
	assert(type(charInterval) == "number")
	assert(type(fntFile) == "string")
	assert(#{...} == 0)

	-----------------
	-- Init Base UI
	-- --------------
	--Layer.initLayer(self)
	Layer.initLayer(self)

	self:ignoreAnchorPointForPosition(false)

	-----------
	-- Data
	-- ---------
	self.charWidth		= charWidth
	self.charHeight		= charHeight
	self.charInterval	= charInterval
	self.fntFile		= fntFile

	self:setContentSize(CCSizeMake(self.charWidth, self.charHeight))
end


--
-- Return The Char Length Of A UTF-8 String
--
function LabelBMMonospaceFont:charSize(utf8InitialChar, ...)
	assert(utf8InitialChar)
	assert(#{...} == 0)

	-- UTF-8 Reference:
	-- 0xxxxxxx - 1 byte UTF-8 codepoint (ASCII character)
	-- 110yyyxx - First byte of a 2 byte UTF-8 codepoint
	-- 1110yyyy - First byte of a 3 byte UTF-8 codepoint
	-- 11110zzz - First byte of a 4 byte UTF-8 codepoint
	-- 10xxxxxx - Inner byte of a multi-byte UTF-8 codepoint
	
	if not utf8InitialChar then
		return 0
	elseif utf8InitialChar > 240 then
		return 4
	elseif utf8InitialChar > 225 then
		return 3
	elseif utf8InitialChar > 192 then
		return 2
	else
		return 1
	end
end

function LabelBMMonospaceFont:iterateString(str, ...)
	assert(type(str) == "string")
	assert(#{...} == 0)

	local individualUTF8Chars =  {}

	local byteLength = string.len(str)

	--for index = 1, byteLength do
	--	local initialChar = 
	--end

	local byteIndex = 1
	
	while byteIndex <= byteLength do

		local initialByte = string.byte(str, byteIndex)
		local utfCharLength	= self:charSize(initialByte)
		local individualChar	= string.sub(str, byteIndex, byteIndex + utfCharLength - 1)
		table.insert(individualUTF8Chars, individualChar)

		byteIndex = byteIndex + utfCharLength
	end

	return individualUTF8Chars
end

function LabelBMMonospaceFont:setCascadeOpacityEnabled( v )
  self.refCocosObj:setCascadeOpacityEnabled(v)
end
function LabelBMMonospaceFont:getString()
  return self.string
end
function LabelBMMonospaceFont:setString(str, ...)
	assert(#{...} == 0)

  if type(str) ~= "string" then str = tostring(str) end
  if self.string == str then return end
	self.string = str

	-- -----------------
	-- Remove Previous 
	-- ----------------
	--self:removeChildren(true)

	-----------------------------
	-- Create The Individual Char
	-- ------------------------
  if self.charsLabel and #self.charsLabel > 0 then
    for k,v in pairs(self.charsLabel) do
      if v and v.refCocosObj then
        if v:getParent() then v:removeFromParentAndCleanup(true) 
        else v:dispose() end 
      end
    end
  end
	self.charsLabel = {}
  self:removeChildren(true)

	local stringChars = self:iterateString(str)
	--print("number of chars: " .. #stringChars)

	--local strLength = string.len(str)
	local strLength = #stringChars

	for index = 1, strLength do

		--local char = string.sub(str, index, index)
		local char = stringChars[index]
		local charLabel = BitmapText:create("", self.fntFile, -1, kCCTextAlignmentCenter)

		charLabel:setPreferredSize(self.charWidth, self.charHeight)
		charLabel:setString(char)
		self.charsLabel[index] = charLabel
	end

	--------------------
	-- Position Each Char
	-- ----------------
	local startX = self.charWidth / 2
	local startY = self.charHeight / 2

	for index = 1, strLength do
		self.charsLabel[index]:setPosition(ccp(startX, startY))
		startX = startX + self.charInterval
		self:addChild(self.charsLabel[index])
	end

	-------------------
	-- Set Self Content Size
	-- ----------------------
	if strLength == 0 then
		self:setContentSize(CCSizeMake(self.charWidth, self.charHeight))
	else
		local contentHeight = self.charHeight
		local contentWidth = (strLength - 1) * self.charInterval + self.charWidth
		self:setContentSize(CCSizeMake(contentWidth, contentHeight))
	end
end

function LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile, ...)
	assert(type(charWidth) == "number")
	assert(type(charHeight) == "number")
	assert(type(charInterval) == "number")
	assert(type(fntFile) == "string")
	assert(#{...} == 0)

	local newLabelBMMonospaceFont = LabelBMMonospaceFont.new()
	newLabelBMMonospaceFont:init(charWidth, charHeight, charInterval, fntFile)
	return newLabelBMMonospaceFont
end

function LabelBMMonospaceFont:copyToCenterLayer()
  local position = self:getPosition()
  local size = self:getContentSize()
  local anchor = self:getAnchorPoint()
  local string = self:getString()
  local newLabelBMMonospaceFont = LabelBMMonospaceFont.new()
  newLabelBMMonospaceFont.name = "label"
  newLabelBMMonospaceFont:init(self.charWidth, self.charHeight, self.charInterval, self.fntFile)
  if string then newLabelBMMonospaceFont:setString(string) end  
  newLabelBMMonospaceFont:setAnchorPoint(ccp(anchor.x, anchor.y))
  newLabelBMMonospaceFont:setPosition(ccp(-size.width/2, size.height/2))

  local layer = CocosObject:create()
  layer:setPosition(ccp(position.x+size.width/2, position.y-size.height/2))
  layer:addChild(newLabelBMMonospaceFont)
  return layer
end

function LabelBMMonospaceFont:setOpacity(alpha)
  assert(type(alpha) == "number")
  for k, v in ipairs(self.charsLabel) do
    v:setOpacity(alpha)
  end
end

function LabelBMMonospaceFont:delayFadeIn(time1, time2)
  for k, v in ipairs(self.charsLabel) do
    v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(time1), CCFadeIn:create(time2)))
  end
end

function LabelBMMonospaceFont:delayFadeOut(time1, time2)
  for k, v in ipairs(self.charsLabel) do
    v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(time1), CCFadeOut:create(time2)))
  end
end