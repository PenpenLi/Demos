require "hecore.ui.LayoutBuilder"

local simplejson = require("cjson")
local builderCached = {}
local configCached = {}

local kDrawDebugRect = false
local kInterfaceGroupLayoutType = {kImage = 0, kText = 1, kGroup = 2}

InterfaceBuilder = class()
function InterfaceBuilder:ctor( json, filePath )
	self.config = json
	self.filePath = filePath
end

--
-- static ---------------------------------------------------------
--
function InterfaceBuilder:preloadJson(filePath)
	local config = configCached[filePath]
	if not config then
		local path = CCFileUtils:sharedFileUtils():fullPathForFilename(filePath) 
		local t, fsize = lua_read_file(path)   
		config = table.deserialize(t) --simplejson.decode(t)
		if not config then -- 解析失败
			he_log_error("InterfaceBuilder fail, preloadJson: "..filePath)
	     	assert(false)
	     	return nil
	    end
		configCached[filePath] = config
	end
	return config
end
function InterfaceBuilder:removeLoadedJson(filePath)
	if configCached[filePath] ~= nil then 
		configCached[filePath] = nil
	end
end
local releaseIgnoreList = {}
function InterfaceBuilder:addIgnore(filePath)
	table.insert(releaseIgnoreList, filePath)
end

function InterfaceBuilder:preloadAsset( filePath )
	local config = InterfaceBuilder:preloadJson(filePath)
	local fileSeparater = "/"
	local separatedFilePath = filePath:split(fileSeparater)
	local prefix = ""
	for index = 1,#separatedFilePath - 1 do
		prefix = prefix ..separatedFilePath[index] .. fileSeparater
	end

	local plist = prefix .. config.config
	local image = prefix .. config.image
	local realPlistPath, realPngPath = SpriteUtil:addSpriteFramesWithFile(plist, image)
	config.plistPath = plist
	config.realPlistPath = realPlistPath
	config.realPngPath = realPngPath
	return config
end
function InterfaceBuilder:unloadAsset(filePath)
	local config = InterfaceBuilder:preloadJson(filePath)
	local found = table.indexOf(releaseIgnoreList, filePath) ~= nil
	if config and config.realPngPath and not found then
		SpriteUtil:removeLoadedPlist( config.plistPath )
		if not __WP8 then
			CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename(config.realPngPath))
			local realPlistPath = config.realPlistPath
			CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(realPlistPath)
		else
			CCTextureCache:sharedTextureCache():removeUnusedTextures()
		end
		builderCached[filePath] = nil
	end
	
end

function InterfaceBuilder:getRealResourceName(filePath)
	return filePath
end

function InterfaceBuilder:createWithContentsOfFile(filePath)
	filePath = InterfaceBuilder:getRealResourceName(filePath)
	local builder = builderCached[filePath]

	if builder then InterfaceBuilder:preloadAsset(filePath)
	else
		local config = InterfaceBuilder:preloadAsset(filePath)
		builder = InterfaceBuilder.new(config, filePath)
		builderCached[filePath] = builder
	end
	return builder
end

function InterfaceBuilder:create( filePath )
	local builder = builderCached[filePath]
	if not builder then 
		local config = InterfaceBuilder:preloadJson(filePath)
		builder = InterfaceBuilder.new(config, filePath)
		builderCached[filePath] = builder
	end
	return builder
end

function InterfaceBuilder:centerInterfaceInbox( interface, boundingBox, forceScale )
	local scaled = true
	if forceScale ~= nil then scaled = forceScale end

	if interface and interface.refCocosObj then
		local size = interface:getContentSize()

		local height = size.height
		local scale = 1
		if scaled then scale = boundingBox.height/height end
		local width = size.width * scale 
		height = size.height * scale

		interface:setScale(scale)
		local x = boundingBox.x + (boundingBox.width - width) / 2
		local y = boundingBox.y - (boundingBox.height - height) / 2 -- by flash export, Y = -y
		interface:setPosition(ccp(x, y))
	end
end
-- for left aligning text
function InterfaceBuilder:leftAligneInterfaceInbox( interface, boundingBox, forceScale )
	local scaled = true
	if forceScale ~= nil then scaled = forceScale end

	if interface and interface.refCocosObj then
		local size = interface:getContentSize()

		local height = size.height
		local scale = 1
		if scaled then scale = boundingBox.height/height end
		local width = size.width * scale 
		height = size.height * scale

		interface:setScale(scale)
		local x = boundingBox.x
		local y = boundingBox.y - (boundingBox.height - height) / 2 -- by flash export, Y = -y
		interface:setPosition(ccp(x, y))
	end
end
-- for right aligning text
function InterfaceBuilder:rightAligneInterfaceInbox( interface, boundingBox, forceScale )
	local scaled = true
	if forceScale ~= nil then scaled = forceScale end

	if interface and interface.refCocosObj then
		local size = interface:getContentSize()

		local height = size.height
		local scale = 1
		if scaled then scale = boundingBox.height/height end
		local width = size.width * scale 
		height = size.height * scale

		interface:setScale(scale)
		local x = boundingBox.x + boundingBox.width - width
		local y = boundingBox.y - (boundingBox.height - height) / 2 -- by flash export, Y = -y
		interface:setPosition(ccp(x, y))
	end
end

--
-- methods ---------------------------------------------------------
--
local function sortByIndex(a, b) return a.index < b.index end

local function hex2ccc3( color )
	local textColor = tostring(color)
  	if #textColor > 6 then textColor = string.sub(textColor, 2, 7) end
  	local integer = tonumber(textColor, 16)
  	local ret = HeDisplayUtil:ccc3FromUInt(integer)
  	return ret
end
local function getFontFace( designedFont )
	return getGlobalDynamicFontMap(designedFont)
end

local function addDebugBounds( layout, parentLayer )
	if not kDrawDebugRect then return end
	local bounds = layout:getGroupBounds()
	local boundsLayer = LayerColor:create()
	boundsLayer:setColor(ccc3(128,55,144))
	boundsLayer:setOpacity(80)
	boundsLayer:changeWidthAndHeight(bounds.size.width, bounds.size.height)
	boundsLayer:setAnchorPoint(ccp(0,0))
	boundsLayer:setPosition(ccp(bounds.origin.x, bounds.origin.y))
	if parentLayer then parentLayer:addChild(boundsLayer) end
end

local function setCocosRotation( obj, symbol )
	local rotation, skewX, skewY 
	if type(symbol.rotation) == "number" then rotation = symbol.rotation end
	if type(symbol.skewX) == "number" then skewX = symbol.skewX end
	if type(symbol.skewY) == "number" then skewY = symbol.skewY end

	if rotation ~= nil then obj:setRotation(rotation)
	else
		if skewX ~= nil and skewY ~= nil then
			obj:setRotationX(skewX)
			obj:setRotationY(skewY)
		end
	end
end

local function transformObjectByConfig( image, symbol )
	image.name = symbol.id
	image:setPosition(ccp(symbol.x, -symbol.y))
	image:setScaleX(symbol.scaleX)
	image:setScaleY(symbol.scaleY)
	setCocosRotation(image, symbol)
	
	if symbol.type == kInterfaceGroupLayoutType.kImage and symbol.id == kHitAreaObjectName then
    	image:setVisible(false)
  	end
end

--
-- parse images ---------------------------------------

local function parseScale9Sprite( symbol, imageSuffix )
	local image = assert(Scale9SpriteColorAdjust:createWithSpriteFrameName(symbol.image..imageSuffix))
	image.name = symbol.id
	image:setPosition(ccp(symbol.x, -symbol.y))
	image:setPreferredSize(CCSizeMake(symbol.width, symbol.height))
	image:setAnchorPoint(ccp(0, 1))
	setCocosRotation(image, symbol)
	
	return image
end
local function parseNormalSprite( symbol, imageSuffix )
	local image = assert(SpriteColorAdjust:createWithSpriteFrameName(symbol.image..imageSuffix))
	transformObjectByConfig(image, symbol)
	image:setAnchorPoint(ccp(0, 1))
	return image
end
local function parseImageSymbol( symbol, imageSuffix )
	if type(symbol.scalingGrid) == "boolean" and symbol.scalingGrid then return parseScale9Sprite( symbol, imageSuffix )
	else return parseNormalSprite( symbol, imageSuffix ) end
end

--
-- parse texts ---------------------------------------

local function parseStaticText( symbol, hAlignment )
	local text = TextField:create("", nil, symbol.size, CCSizeMake(symbol.width, symbol.height), hAlignment, kCCVerticalTextAlignmentTop)
	text:setColor(hex2ccc3(symbol.fillColor))
	return text
end
local function parseDynamicText( symbol, hAlignment )
	local fnt = getFontFace(symbol.face)
	local text = BitmapText:create("", fnt, -1, hAlignment)
	text.fntFile = fnt
	text.hAlignment = hAlignment
	return text
end
local function parseText( symbol )
	local hAlignment = kCCTextAlignmentLeft
	if symbol.alignment == "center" then hAlignment = kCCTextAlignmentCenter 
	elseif symbol.alignment == "right" then hAlignment = kCCTextAlignmentRight end
	local text = nil
	if symbol.textType == "static" then text = parseStaticText(symbol, hAlignment)
	else text = parseDynamicText(symbol, hAlignment) end

	text.name = symbol.id
	text:setPosition(ccp(symbol.x, -symbol.y))
	text:setAnchorPoint(ccp(0, 1))
	setCocosRotation(text, symbol)

	return text
end

function InterfaceBuilder:buildGroup( groupName, imageSuffix )
	if not self.config then
		-- print("build ui fail. no config:"..groupName)
		return nil
	end
	local group = self.config.groups[groupName]
	if not group then
		-- print("build ui fail. no group:"..groupName)
		return nil
	end
	imageSuffix = imageSuffix or "0000"
	local groupLayer = Layer:create()
	groupLayer.name = groupName
	groupLayer.symbolName = groupName
	table.sort(group, sortByIndex)
	for k,symbol in ipairs(group) do
		if symbol.type == kInterfaceGroupLayoutType.kImage then
			local image = parseImageSymbol(symbol, imageSuffix)
			if image then groupLayer:addChild(image) end
			addDebugBounds(image, groupLayer)
		elseif symbol.type == kInterfaceGroupLayoutType.kText then
			local text = parseText(symbol)
			groupLayer:addChild(text)
			addDebugBounds(text, groupLayer)
		elseif symbol.type == kInterfaceGroupLayoutType.kGroup then
			local layout = self:buildGroup(symbol.image, imageSuffix)
			if layout then
				transformObjectByConfig(layout, symbol)
				groupLayer:addChild(layout)

			end
		end
	end
	addDebugBounds(groupLayer)
	return groupLayer
end

-- For unknown reason common_ui and properties might be released
InterfaceBuilder:addIgnore(PanelConfigFiles.common_ui)
InterfaceBuilder:addIgnore(PanelConfigFiles.properties)