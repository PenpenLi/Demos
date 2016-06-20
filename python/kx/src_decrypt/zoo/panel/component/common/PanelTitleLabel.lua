
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ 9ÈÕ 13:05:09
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- PanelTitleLabel
---------------------------------------------------

assert(not PanelTitleLabel)
PanelTitleLabel = class(Layer)

function PanelTitleLabel:init(levelNumber, diguanW, diguanH, levelNumberW, levelNumberH, manualAdjustInter, useSpecialActivityUI, ...)
	assert(#{...} == 0)
	
	-------------
	-- Init Base Class
	-- --------------
	Layer.initLayer(self)

	----------
	-- Data 
	-----------
	self.levelNumber = levelNumber

	local diguanWidth 	= diguanW or 58
	local diguanHeight	= diguanH or 58
	local diguanFntFile	= "fnt/titles.fnt" 
	if useSpecialActivityUI then
		diguanFntFile = "fnt/titles_red.fnt"
	end
	if _G.useTraditionalChineseRes then diguanFntFile = "fnt/zh_tw/titles.fnt" end
	local diguanAlignment	= kCCTextAlignmentCenter

	local levelNumberWidth		= levelNumberW or 205.52
	local levelNumberHeight 	= levelNumberH or 68.5
	local levelNumberFntFile	= "fnt/level_seq_upon_entering.fnt"
	if useSpecialActivityUI then
		levelNumberFntFile	= "fnt/level_seq_upon_entering_red.fnt"
	end
	local levelNumberAlignment	= kCCTextAlignmentCenter

	local manualAdjustInterval	= manualAdjustInter or 0

	---------------------
	-- Create Label Char
	-- -----------------
	local chars = {}
	local diChar = BitmapText:create("", diguanFntFile, -1, diguanAlignment)
	diChar:setPreferredSize(diguanWidth, diguanHeight)

	local diCharKey		= "start.game.panel.title_di"
	local diCharValue 	= Localization:getInstance():getText(diCharKey, {})
	diChar:setString(diCharValue)
	table.insert(chars, diChar)
	self:addChild(diChar)

	local levelNumberLabel = BitmapText:create("", levelNumberFntFile, -1, levelNumberAlignment)
	levelNumberLabel:setPreferredSize(levelNumberWidth, levelNumberHeight)
	levelNumberLabel:setString(tostring(self.levelNumber))
	table.insert(chars, levelNumberLabel)
	self:addChild(levelNumberLabel)
	
	local guanChar = BitmapText:create("", diguanFntFile, -1, diguanAlignment)
	guanChar:setPreferredSize(diguanWidth, diguanHeight)

	local guanCharKey	= "start.game.panel.title_guan"
	local guanCharValue	= Localization:getInstance():getText(guanCharKey, {})
	guanChar:setString(guanCharValue)
	table.insert(chars, guanChar)
	self:addChild(guanChar)

	-------------------
	-- Layout Chars
	-- ---------------
	local diContentWidth			= diChar:getGroupBounds().size.width
	local levelNumberLabelContentWidth	= levelNumberLabel:getGroupBounds().size.width
	local guanContentWidth			= guanChar:getGroupBounds().size.width
	
	-- di Char
	local startX = diContentWidth / 2
	local startY =  diguanHeight / 2

	diChar:setPosition(ccp(startX, startY))
	
	-- Level Number
	startX = startX + diContentWidth/2 + levelNumberLabelContentWidth/2 + manualAdjustInterval
	levelNumberLabel:setPosition(ccp(startX, startY))

	-- Guan Char
	startX = startX + levelNumberLabelContentWidth/2 + guanContentWidth/2 + manualAdjustInterval
	guanChar:setPosition(ccp(startX, startY))

	------------------
	-- Update Content Size
	-- -----------------
	local contentSize = self:getGroupBounds().size

	self:setContentSize(CCSizeMake(contentSize.width, diguanHeight))
end

function PanelTitleLabel:create(levelNumber, diguanWidth, diguanHeight, levelNumberWidth, levelNumberHeight, manualAdjustInterval, useSpecialActivityUI, ...)
	assert(#{...} == 0)

	local newPanelTitleLabel = PanelTitleLabel.new()
	newPanelTitleLabel:init(levelNumber,diguanWidth, diguanHeight, levelNumberWidth, levelNumberHeight, manualAdjustInterval, useSpecialActivityUI)
	return newPanelTitleLabel
end


function PanelTitleLabel:createWithString(string, length)
	local newPanelTitleLabel = PanelTitleLabel.new()
	newPanelTitleLabel:initWithString(string, length)
	return newPanelTitleLabel
end

function PanelTitleLabel:initWithString(text, length)

	-------------
	-- Init Base Class
	-- --------------
	Layer.initLayer(self)

	----------
	-- Data 
	-----------
	self.string = tostring(text)

	local fntFile	= "fnt/titles.fnt" 
	local stringAlignment	= kCCTextAlignmentCenter

	local manualAdjustInterval	= manualAdjustInter or 0

	---------------------
	-- Create Label Char
	-- -----------------

	local charWidth = 58
	local stringLabel = BitmapText:create("", fntFile, -1, stringAlignment)
	stringLabel:setPreferredSize(charWidth*length, charWidth)
	stringLabel:setString(tostring(self.string))
	self:addChild(stringLabel)
	

	-------------------
	-- Layout Chars
	-- ---------------
	local stringLabelContentWidth	= stringLabel:getGroupBounds().size.width
	startX = stringLabelContentWidth/2 + manualAdjustInterval
	stringLabel:setPosition(ccp(startX,  -29))

	------------------
	-- Update Content Size
	-- -----------------

	local contentSize = self:getGroupBounds().size
	self:setContentSize(CCSizeMake(contentSize.width, height))
end