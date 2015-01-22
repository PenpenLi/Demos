
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月 6日 17:57:29
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.animation.LadybugAnimation"

---------------------------------------------------
-------------- ScoreProgressBar
---------------------------------------------------

assert(not ScoreProgressBar)
assert(BaseUI)
ScoreProgressBar = class(BaseUI)

function ScoreProgressBar:init(star1Score, star2Score, star3Score, star4Score, ...)
	assert(type(star1Score) == "number")
	assert(type(star2Score) == "number")
	assert(type(star3Score) == "number")
	assert(#{...} == 0)

	-- -------------
	-- Get UI Resource
	-- ------------------
	self.ladyBugAnimation	= LadybugAnimation:create()
	self.ui			= self.ladyBugAnimation.layer

	-- ---------------
	-- Init Base Class
	-- -----------------
	BaseUI.init(self, self.ui)

	-------------------------------------
	-- Get The Config From UIConfigManager
	-- -----------------------------------
	local kPropListScaleFactor = 1
  	if __frame_ratio and __frame_ratio < 1.6 then  kPropListScaleFactor = 0.92 end
	local config = UIConfigManager:sharedInstance():getConfig()
	local scoreTxtLabel_manualAdjustX 	= (config.scoreProgressBar_scoreTxtLabel_manualAdjustX + 5) * kPropListScaleFactor
	local scoreTxtLabel_manualAdjustY 	= (config.scoreProgressBar_scoreTxtLabel_manualAdjustY - 165) * kPropListScaleFactor
	local scoreLabel_manualAdjustX		= config.scoreProgressBar_scoreLabel_manualAdjustX * kPropListScaleFactor
	local scoreLabel_manualAdjustY		= (config.scoreProgressBar_scoreLabel_manualAdjustY - 192) * kPropListScaleFactor

	-- Create Score Txt Label
	local designFontName	= "Berlin Sans FB"
	local fontName		= LayoutBuilder:getGlobalFontFace(designFontName)

	local fontSize		= 23
	local dimension		= CCSizeMake(80, 24)
	local hAlignment	= kCCTextAlignmentLeft
	local vAlignment	= kCCVerticalTextAlignmentCenter
	local color			= ccc3(0xDE, 0xCF, 0x63)

	local filename = "fnt/game_scores.fnt"
	if _G.useTraditionalChineseRes then filename = "fnt/zh_tw/game_scores.fnt" end
	-- self.scoreTxtLabel	= TextField:create("scoreTxt:", fontName, fontSize, dimension, hAlignment, vAlignment)
	-- self.scoreTxtLabel:setColor(color)
	-- self.scoreTxtLabel:setAnchorPoint(ccp(0,1))
	-- self.scoreTxtLabel:setPosition(ccp(positionX, positionY))
	-- self:addChild(self.scoreTxtLabel)
	self.scoreTxtLabel = LabelBMMonospaceFont:create(40, 40, 20, filename)
	self.scoreTxtLabel:setPosition(ccp(scoreTxtLabel_manualAdjustX, scoreTxtLabel_manualAdjustY))
	self:addChild(self.scoreTxtLabel)

	-- Create Score Label
	local fontSize		= 23
	local dimension		= CCSizeMake(200, 28)
	local hAlignment	= kCCTextAlignmentLeft
	local positionX		= 15 + scoreLabel_manualAdjustX
	local positionY		= -155 + scoreLabel_manualAdjustY

	-- self.scoreLabel		= TextField:create("score", fontName, fontSize, dimension, hAlignment, vAlignment)
	-- self.scoreLabel:setColor(color)
	-- self.scoreLabel:setAnchorPoint(ccp(0,1))
	-- self.scoreLabel:setPosition(ccp(positionX, positionY))
	-- self:addChild(self.scoreLabel)
	self.scoreLabel = LabelBMMonospaceFont:create(42, 42, 12, filename)
	self.scoreLabel:setPosition(ccp(scoreLabel_manualAdjustX, scoreLabel_manualAdjustY))
	self:addChild(self.scoreLabel)

	---------------------
	-- Data
	-- -------------------
	self.maxPercentage = 0.88
	self.score = 0

	self.star1Score = star1Score
	self.star2Score = star2Score
	self.star3Score = star3Score
	self.star4Score = star4Score

	self.star1PosPer = false
	self.star2PosPer = false
	self.star3PosPer = false

	--------------
	-- Calblack
	-- ------------
	
	self.onScoreChangeCallback	= false

	-- Set Initial Star Position
	local star1PosPer = self.star1Score / self.star3Score * self.maxPercentage
	local star2PosPer = self.star2Score / self.star3Score * self.maxPercentage
	local star3PosPer = self.maxPercentage
	self.star1PosPer = star1PosPer
	self.star2PosPer = star2PosPer
	self.star3PosPer = star3PosPer

	-----------------
	-- Update View
	-- --------------
	self.ladyBugAnimation:reset()
	self.ladyBugAnimation:setStarsPosition(star1PosPer, star2PosPer, star3PosPer)
	self.ladyBugAnimation:setStarsScore(star1Score, star2Score, star3Score)

	-- Set Score Txt Label
	local scoreTxtLabelKey		= "score.progress.bar.score.txt"
	local scoreTxtLabelValue	= Localization:getInstance():getText(scoreTxtLabelKey, {})
	assert(scoreTxtLabelValue)
	self.scoreTxtLabel:setString(scoreTxtLabelValue)
	print("self.scoreTxtLabel.setOpacity", self.scoreTxtLabel.setOpacity)
	print("self.scoreTxtLabel.refCocosObj", self.scoreTxtLabel.refCocosObj)
	print("self.scoreTxtLabel.refCocosObj.setOpacity", self.scoreTxtLabel.refCocosObj.setOpacity)
	self.scoreTxtLabel:setOpacity(0)
	self.scoreTxtLabel:delayFadeIn(2.5, 0.4)
	-- self.scoreTxtLabel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2.5), CCFadeIn:create(0.4)))

	self.scoreLabel:setString(tostring(self.score))
	self.scoreLabel:setOpacity(0)
	self.scoreLabel:delayFadeIn(2.5, 0.4)
	-- self.scoreLabel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2.5), CCFadeIn:create(0.4)))


end

function ScoreProgressBar:create(star1Score, star2Score, star3Score, star4Score, ...)
	assert(type(star1Score) == "number")
	assert(type(star2Score) == "number")
	assert(type(star3Score) == "number")
	-- assert(#{...} == 0)

	local newScoreProgressBar = ScoreProgressBar.new()
	newScoreProgressBar:init(star1Score, star2Score, star3Score, star4Score, ...)
	return newScoreProgressBar
end

function ScoreProgressBar:dispose()
	self.ladyBugAnimation:dispose()
	self.ladyBugAnimation = nil
	BaseUI.dispose(self)
end

function ScoreProgressBar:setScore(newScore, globalPos, ...)
	assert(type(newScore) == "number")
	assert(globalPos == false or type(globalPos) == "userdata")
	assert(#{...} == 0)

	self.score = newScore
	self.scoreLabel:setString(tostring(self.score))

	-- Update Scroll Bar
	local percentage	= false
	local percentage = newScore /  self.star3Score * self.maxPercentage

	if self.star4Score and newScore > self.star4Score and not self._hasReachedFourStar then
		self._hasReachedFourStar = true
		self.ladyBugAnimation:playFourStarAnimation()
	else
		self.ladyBugAnimation:animateTo(percentage, 0.2)
	end

	if globalPos then
		self.ladyBugAnimation:addScoreStar(globalPos)
	end

	if self.onScoreChangeCallback then
		self.onScoreChangeCallback(newScore)
	end
end

function ScoreProgressBar:setOnScoreChangeCallback(callback, ...)
	assert(type(callback) == "function")
	assert(#{...} == 0)

	self.onScoreChangeCallback = callback
end

function ScoreProgressBar:revertScoreTo(newScore, ...)
	assert(type(newScore) == "number")
	assert(#{...} == 0)

	self.score = newScore
	self.scoreLabel:setString(tostring(self.score))

	-- Update Scroll Bar
	local percentage	= false
	local percentage = newScore /  self.star3Score * self.maxPercentage

	self.ladyBugAnimation:revertTo(percentage)
end

function ScoreProgressBar:addScore(deltaScore, globalPos, ...)
	assert(deltaScore)
	assert(globalPos == false or type(globalPos) == "userdata")
	assert(#{...} == 0)

	local curScore = self:getScore()
	local newScore = curScore + deltaScore

	self:setScore(newScore, globalPos)
end

function ScoreProgressBar:getScore(...)
	assert(#{...} == 0)

	return self.score
end

function ScoreProgressBar:getBigStarPosInWorldSpace(...)
	assert(#{...} == 0)

	return self.ladyBugAnimation:getBigStarPosInWorldSpace()
end

function ScoreProgressBar:getBigStarSize(...)
	assert(#{...} == 0)

	return self.ladyBugAnimation:getBigStarSize()
end

function ScoreProgressBar:setBigStarVisible(starIndex, visible, ...)
	assert(type(starIndex) == "number")
	assert(type(visible) == "boolean")
	assert(#{...} == 0)

	self.ladyBugAnimation:setBigStarVisible(starIndex, visible)
end
