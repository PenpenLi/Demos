
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年11月13日 11:39:38
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panelBusLogic.AdvanceTopLevelLogic"
require "zoo.panelBusLogic.UpdateLevelScoreLogic"
require "zoo.data.WeeklyRaceManager"

---------------------------------------------------
-------------- PassLevelLogic
---------------------------------------------------

assert(not PassLevelLogic)
PassLevelLogic = class()

function PassLevelLogic:init(levelId, score, star, stageTime, coin, targetCount, opLog, levelType, onSuccessCallback, ...)
	assert(type(levelId)		== "number")
	assert(type(score)		== "number")
	assert(type(star)		== "number")
	assert(type(stageTime)		== "number")
	assert(type(coin)		== "number")
	-- assert(type(onSuccessCallback)	== "function")
	assert(#{...} == 0)

	self.levelId	= levelId
	self.score	= score
	self.star	= star
	self.stageTime	= stageTime
	self.coin	= coin
	self.targetCount = targetCount
	self.opLog = opLog

	self.levelType = levelType

	self.onSuccessCallback	= onSuccessCallback
end

function PassLevelLogic:start(...)
	assert(#{...} == 0)

	local function onSendMsgSuccess(rewardItems)

		-- Record Passed Level
		UserManager:getInstance().lastPassedLevel = self.levelId

		-----------------------
		-- Update Level Score
		-- ---------------------
		local updateLevelScoreLogic = UpdateLevelScoreLogic:create(self.levelId, self.levelType, self.score, self.star)
		updateLevelScoreLogic:start()

		-- ------------------------------------
		-- Check If It's A New Completed Level
		-- ----------------------------------
		local advanceTopLevelLogic = AdvanceTopLevelLogic:create(self.levelId)
		advanceTopLevelLogic:start()

		-----------------------
		-- Add Extra Coin
		-- ---------------
		local extraCoinRatio	= MetaManager.getInstance().global.coin 
		local extraCoin		= self.coin * extraCoinRatio

		-- Add Coin
		local curCoin	= UserManager:getInstance().user:getCoin()
		local newCoin	= curCoin + extraCoin
		UserManager:getInstance().user:setCoin(newCoin)

		if self.levelType == GameLevelType.kDigWeekly and not _isQixiLevel then
			WeeklyRaceManager:sharedInstance():onPassLevel(self.targetCount)
		elseif self.levelType == GameLevelType.kRabbitWeekly then
			RabbitWeeklyManager:sharedInstance():onPassLevel(self.targetCount, self.levelId)
		end

		--------------
		-- Callback 
		-- -----------
		if self.onSuccessCallback then
			self.onSuccessCallback(self.levelId, self.score, rewardItems)
		end
		SyncManager:getInstance():sync()
		
		ShareManager:onPassLevel(self.levelId, self.score, self.levelType)

		LocalNotificationManager.getInstance():setPassLevelFlag(self.levelId, self.star, self.score)
	end

	self:sendPassLevelMessage(onSendMsgSuccess)
end

function PassLevelLogic:sendPassLevelMessage(onSuccessCallback, ...)
	assert(type(onSuccessCallback) == "function")
	assert(#{...} == 0)

	local levelId	= self.levelId
	local score	= self.score
	local star	= self.star
	local stageTime	= self.stageTime
	local coin	= self.coin
	local targetCount = self.targetCount
	local opLog = self.opLog

	local function onPassLevelMsgSuccess(event)
		assert(event)
		assert(event.name == Events.kComplete)
		assert(event.data)
		--重置推送召回活动关卡卡最高关卡状态 这个调用  一定要在onSuccessCallback之前 否则最高关卡会变动 导致流失状态无法重置
		if RecallManager.getInstance():getRecallLevelState(levelId) then
			RecallManager.getInstance():resetRecallRewardState()
		end

		local rewardItems = event.data

		-- Call Callback
		onSuccessCallback(rewardItems)
	end

	local function onPassLevelMsgFailed()
		assert(false)
	end

	local http = PassLevelHttp.new()
	http:addEventListener(Events.kComplete, onPassLevelMsgSuccess)
	http:addEventListener(Events.kError, onPassLevelMsgFailed)
	http:load(levelId, score, star, stageTime, coin, targetCount, opLog, self.levelType)
end

function PassLevelLogic:create(levelId, score, star, stageTime, coin, targetCount, opLog, levelType, onSuccessCallback, ...)
	assert(type(levelId)	== "number")
	assert(type(score)	== "number")
	assert(type(star)	== "number")
	assert(type(stageTime)	== "number")
	assert(type(coin)	== "number")
	-- assert(type(onSuccessCallback)	== "function")
	assert(#{...} == 0)

	local newPassLevelLogic = PassLevelLogic.new()
	newPassLevelLogic:init(levelId, score, star, stageTime, coin, targetCount, opLog, levelType, onSuccessCallback)
	return newPassLevelLogic
end
