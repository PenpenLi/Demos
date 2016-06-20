ScoreProgress = class()
local kStarFactor = 24 * 3.1415926 / 180
local kMaskBeginWidth = 17
local kMaskEndWidth = 50
require "zoo.scenes.component.gameplayScene.ScoreProgressAnimation"
function ScoreProgress:create( parent,starScoreList, pos )
	-- body
	local sp = ScoreProgress.new()
	sp:init(parent, starScoreList, pos)
	return sp
end

function ScoreProgress:ctor( ... )
	-- body
end

function ScoreProgress:init( parent, starScoreList, pos )
	-- body
	self.parent = parent
	self.starScoreList = starScoreList
	
	self.ladyBugAnimation = ScoreProgressAnimation:create(self, pos)
	local kPropListScaleFactor = 1
  	if __frame_ratio and __frame_ratio < 1.6 then  kPropListScaleFactor = 0.92 end
	local config = UIConfigManager:sharedInstance():getConfig()
	local scoreTxtLabel_manualAdjustX 	= pos.x + (config.scoreProgressBar_scoreTxtLabel_manualAdjustX + 5) * kPropListScaleFactor
	local scoreTxtLabel_manualAdjustY 	= pos.y + (config.scoreProgressBar_scoreTxtLabel_manualAdjustY - 165) * kPropListScaleFactor
	local scoreLabel_manualAdjustX		= pos.x + (config.scoreProgressBar_scoreLabel_manualAdjustX) * kPropListScaleFactor
	local scoreLabel_manualAdjustY		= pos.y + (config.scoreProgressBar_scoreLabel_manualAdjustY - 192) * kPropListScaleFactor
	
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
	self.scoreTxtLabel = LabelBMMonospaceFont:create(40, 40, 20, filename)
	self.scoreTxtLabel:setPosition(ccp(scoreTxtLabel_manualAdjustX, scoreTxtLabel_manualAdjustY))
	self.parent.displayLayer[GamePlaySceneTopAreaType.kEffect]:addChild(self.scoreTxtLabel)

	-- Create Score Label
	local fontSize		= 23
	local dimension		= CCSizeMake(200, 28)
	local hAlignment	= kCCTextAlignmentLeft
	local positionX		= 15 + scoreLabel_manualAdjustX
	local positionY		= -155 + scoreLabel_manualAdjustY
	self.scoreLabel = LabelBMMonospaceFont:create(42, 42, 12, filename)
	self.scoreLabel:setPosition(ccp(scoreLabel_manualAdjustX, scoreLabel_manualAdjustY))
	self.parent.displayLayer[GamePlaySceneTopAreaType.kEffect]:addChild(self.scoreLabel)
	---------------------
	-- Data
	-- -------------------
	self.maxPercentage = 0.88
	self.score = 0

	self.star1Score = starScoreList[1]
	self.star2Score = starScoreList[2]
	self.star3Score = starScoreList[3]
	self.star4Score = starScoreList[4]

	self.star1PosPer = false
	self.star2PosPer = false
	self.star3PosPer = false

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
	self.ladyBugAnimation:setStarsScore(self.star1Score, self.star2Score, self.star3Score)

	local scoreTxtLabelKey		= "score.progress.bar.score.txt"
	local scoreTxtLabelValue	= Localization:getInstance():getText(scoreTxtLabelKey, {})
	self.scoreTxtLabel:setString(scoreTxtLabelValue)
	
	self.scoreTxtLabel:setOpacity(0)
	self.scoreTxtLabel:delayFadeIn(2.5, 0.4)

	self.scoreLabel:setString(tostring(self.score))
	self.scoreLabel:setOpacity(0)
	self.scoreLabel:delayFadeIn(2.5, 0.4)
end

function ScoreProgress:dispose( ... )
	-- body
	if self.ladyBugAnimation then 
		self.ladyBugAnimation:dispose()
		self.ladyBugAnimation = nil
	end

end

function ScoreProgress:setScore( newScore, globalPos, ... )
	-- body
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

	if self.onScoreChangeCallback then
		self.onScoreChangeCallback(newScore)
	end
end

function ScoreProgress:setOnScoreChangeCallback( callback, ... )
	-- body
	assert(type(callback) == "function")
	assert(#{...} == 0)

	self.onScoreChangeCallback = callback
end

function ScoreProgress:revertScoreTo( newScore, ... )
	-- body
	assert(type(newScore) == "number")
	assert(#{...} == 0)

	self.score = newScore
	self.scoreLabel:setString(tostring(self.score))

	-- Update Scroll Bar
	local percentage	= false
	local percentage = newScore /  self.star3Score * self.maxPercentage

	self.ladyBugAnimation:revertTo(percentage)
end

function ScoreProgress:addScore( deltaScore, globalPos, ... )
	-- body
	assert(deltaScore)
	assert(globalPos == false or type(globalPos) == "userdata")
	assert(#{...} == 0)

	local curScore = self:getScore()
	local newScore = curScore + deltaScore

	self:setScore(newScore, globalPos)
end

function ScoreProgress:getScore( ... )
	-- body
	assert(#{...} == 0)

	return self.score
end

function ScoreProgress:getBigStarPosInWorldSpace(...)
	assert(#{...} == 0)

	return self.ladyBugAnimation:getBigStarPosInWorldSpace()
end

function ScoreProgress:getBigStarSize( ... )
	-- body
	assert(#{...} == 0)

	return self.ladyBugAnimation:getBigStarSize()
end

function ScoreProgress:setBigStarVisible( starIndex, visible, ... )
	-- body
	assert(type(starIndex) == "number")
	assert(type(visible) == "boolean")
	assert(#{...} == 0)

	self.ladyBugAnimation:setBigStarVisible(starIndex, visible)
end