

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014Äê01ÔÂ11ÈÕ 17:03:01
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- LadybugButton
---------------------------------------------------

assert(not LadybugButton)
LadybugButton = class(IconButtonBase)

function LadybugButton:ctor( ... )
    self.id = "LadybugButton"
    self.playTipPriority = 20
end
function LadybugButton:playHasNotificationAnim(...)
	-- LadybugButton 每秒都会刷新 特殊处理
	if not self.isNotificationAnimPlayed then 
		IconButtonManager:getInstance():addPlayTipIcon(self)
		self.isNotificationAnimPlayed = true
	end
end

function LadybugButton:stopHasNotificationAnim(...)
    IconButtonManager:getInstance():removePlayTipIcon(self)
    self.isNotificationAnimPlayed = false
end


function LadybugButton:init(...)
	assert(#{...} == 0)

	self.isNotificationAnimPlayed = false

	-- ----------------
	-- Get UI Resource
	-- ---------------
	self.ui = ResourceManager:sharedInstance():buildGroup("ladybugButton")

	------------------
	-- Init Base Class
	-- --------------
	IconButtonBase.init(self, self.ui)

	-------------------
	-- Init UI Resource
	-- ------------------
	local ladybugRewardTipKey	= "lady.bug.icon.rewards.tips"
	local ladybugRewardTipValue	= Localization:getInstance():getText(ladybugRewardTipKey, {})
	self:setTipString(ladybugRewardTipValue)

	---------------------
	-- Create Time Label
	-- --------------------
	local charWidth 	= 35
	local charHeight	= 35
	local charInterval	= 13
	local fntFile		= "fnt/energy_cd.fnt"
	if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/energy_cd.fnt" end
	self.timeLabel = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self:addChild(self.timeLabel)

	self.timeLabel:setPositionY(-115)
end

function LadybugButton:setTimeLabelString(timeString, ...)
	assert(#{...} == 0)

	self.timeLabel:setString(timeString)
	self:centerTimeLabel()
end

function LadybugButton:centerTimeLabel(...)
	assert(#{...} == 0)

	-- Time Label Size
	local timeLabelSize	= self.timeLabel:getContentSize()
	local wrapperX		= self.wrapper:getPositionX()
	self.timeLabel:setPositionX(wrapperX - timeLabelSize.width/2)
end

function LadybugButton:create(...)
	assert(#{...} == 0)

	local newLadybugButton = LadybugButton.new()
	newLadybugButton:init()
	return newLadybugButton
end
