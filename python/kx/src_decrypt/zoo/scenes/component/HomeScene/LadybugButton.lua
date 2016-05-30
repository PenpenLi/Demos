

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014Äê01ÔÂ11ÈÕ 17:03:01
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- LadybugButton
---------------------------------------------------

assert(not LadybugButton)
LadybugButton = class(IconButtonBase)

function LadybugButton:ctor()
    self.idPre = "LadybugButton"
    self.playTipPriority = 30
end

function LadybugButton:playHasNotificationAnim()
	-- LadybugButton 每秒都会刷新 特殊处理
	if not self.isNotificationAnimPlayed then 
		IconButtonManager:getInstance():addPlayTipNormalIcon(self)
		self.isNotificationAnimPlayed = true
	end
end

function LadybugButton:stopHasNotificationAnim()
    IconButtonManager:getInstance():removePlayTipNormalIcon(self)
    self.isNotificationAnimPlayed = false
end

function LadybugButton:updateIconTipShow(tipState)
	if not tipState then return end
	if tipState ~= self.tipState then 
		self.isNotificationAnimPlayed = false
	end
	self.tipState = tipState
	self.id = self.idPre .. self.tipState

	local tips = self["tip"..self.tipState]
	if tips then 
		self:setTipString(tips)
	 	self:playHasNotificationAnim()
	end
end

function LadybugButton:init()
	self.isNotificationAnimPlayed = false

	self["tip"..IconTipState.kNormal] = Localization:getInstance():getText("有新的瓢虫任务哦~", {}) 
	-- self["tip"..IconTipState.kExtend] = ""
	self["tip"..IconTipState.kReward] = Localization:getInstance():getText("lady.bug.icon.rewards.tips", {})  

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
	local charWidth 	= 32
	local charHeight	= 32
	local charInterval	= 13
	local fntFile		= "fnt/energy_cd.fnt"
	if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/energy_cd.fnt" end
	self.timeLabel = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self:addChild(self.timeLabel)

	self.timeLabel:setPositionY(-115)
end

function LadybugButton:setTimeLabelString(timeString)
	self.timeLabel:setString(timeString)
	self:centerTimeLabel()
end

function LadybugButton:centerTimeLabel()
	-- Time Label Size
	local timeLabelSize	= self.timeLabel:getContentSize()
	local wrapperX		= self.wrapper:getPositionX()
	self.timeLabel:setPositionX(wrapperX - timeLabelSize.width/2)
end

function LadybugButton:create()
	local newLadybugButton = LadybugButton.new()
	newLadybugButton:init()
	return newLadybugButton
end
