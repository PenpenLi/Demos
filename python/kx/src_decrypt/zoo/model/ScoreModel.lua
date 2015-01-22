
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年08月27日 11:22:25
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- ScoreModel
---------------------------------------------------

ScoreModel = class()

function ScoreModel:ctor()

	self.userModel		= UserModel.sharedInstance()
	self.selfScoreList	= {}
end

function ScoreModel:init(data, ...)
	assert(data)
	assert(#{...} == 0)

	for k,v in pairs(data) do
		local scoreVO = ScoreVO.new()

		scoreVO.uid 		= v.uid
		scoreVO.levelId		= v.levelId
		scoreVO.score		= v.score
		scoreVO.star		= v.star
		scoreVO.updateTime	= v.updateTime

		self.selfScoreList[#self.selfScoreList] = scoreVO
	end
end

function ScoreModel:addLevelScores(levelId, scores, ...)
	assert(levelId)
	assert(scores)
	assert(#{...} == 0)

	local scoreVOs	= {}

	for k,v in pairs(scores) do

		local scoreVO		= ScoreVO.new()
		scoreVO.uid		= v.uid
		scoreVO.levelId		= v.levelId
		scoreVO.score		= v.score
		scoreVO.star		= v.star
		scoreVO.updateTime	= v.updateTime
		
		scoreVOs[#scoreVOs + 1]	= scoreVO
	end
end

function ScoreModel:sharedInstance(...)
	assert(#{...} == 0)

	if not scoreModelSharedInstance then

		scoreModelSharedInstance = ScoreModel.new()
		scoreModelSharedInstance:init()
	end

	return scoreModelSharedInstance
end

function ScoreModel:getScoreByLevel(levelId, ...)
	assert(levelId)
	assert(#{...} == 0)

	-- Not Implemented
	assert(false, "ScoreModel:getScoreByLevel Not Implemented Yet ! :)")
end

function ScoreModel:getUserScoreByLevel(levelId, ...)
	assert(levelId)
	assert(#{...} == 0)

	assert(false, "ScoreModel:getUserScoreByLevel Not Implemented Yet ! :)")
end
