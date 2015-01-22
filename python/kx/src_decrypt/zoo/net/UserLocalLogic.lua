require "zoo.data.DataRef"
require "zoo.data.WeeklyRaceManager"
require 'zoo.util.QixiUtil'

local NO_DIFF = 0
function table.addAll(self, t)
  for i,v in ipairs(t) do
  	table.insert(self, v)
  end
end

UserLocalLogic = class()

function UserLocalLogic:checkPassLevelConfig( levelId )
	local levelMapMeta = LevelMapManager.getInstance():getMeta(levelId)
	local levelRewardMeta = MetaManager.getInstance():getLevelRewardByLevelId(levelId)
	assert(levelMapMeta, "levelId :" .. levelId .. ", map_config not exist!")
	assert(levelRewardMeta, "levelId :" .. levelId .. ", level reward config not exist!")
	if levelMapMeta == nil or levelRewardMeta == nil then return nil, nil, ZooErrorCode.CONFIG_ERROR end
	return levelMapMeta, levelRewardMeta
end

function UserLocalLogic:isNotConsumeEnergyBuff(time)
	local userExtend = UserService.getInstance().userExtend
	local now = Localhost:time() 
	if type(time) == "number" then now = time end
	--HeConsts.MILLISECONDS_PER_MINUTE
	return userExtend:getNotConsumeEnergyBuff() + 60000 >= now
end

--http://svn.happyelements.net/repos/svndata2/animal/java/trunk/animal-service/src/main/java/com/happyelements/animal/service/impl/ScoreServiceImpl.java
function UserLocalLogic:startLevel( uid, levelId, gameMode, itemIds, energyBuff, requestTime, gameLevelType )
	if gameLevelType == GameLevelType.kQixi then
		return self:startQixiLevel(uid, levelId, gameMode, itemIds, energyBuff, requestTime)
	end

	UserLocalLogic:refreshEnergy()
	local user = UserService.getInstance().user
	local consumeEnergy = true

	if energyBuff and self:isNotConsumeEnergyBuff(requestTime) then
		consumeEnergy = false
	end

	local user_energy_level_consume = MetaManager.getInstance().global.user_energy_level_consume or 5
	-- if levelId > LevelConstans.DIGGER_MATCH_LEVEL_ID_START and DailyDataLocalLogic:isFirstDailyDigg( uid ) then
	-- 	consumeEnergy = false
	-- end

	-- DigMoveEndless mode
	if gameLevelType == GameLevelType.kDigWeekly then
		consumeEnergy = false
		if not WeeklyRaceManager:sharedInstance():isPlayDay() then 
			return false, ZooErrorCode.WEEK_MATCH_ERROR_MATCH_NOT_AVAILABLE
		elseif WeeklyRaceManager:sharedInstance():getRemainingPlayCount() <= 0 then
			return false, ZooErrorCode.WEEK_MATCH_ERROR_DAILY_LIMIT 
		elseif not WeeklyRaceManager:sharedInstance():isLevelReached() then 
			return false, ZooErrorCode.WEEK_MATCH_ERROR_LEVEL_INVALID
		end
	elseif gameLevelType == GameLevelType.kRabbitWeekly then
		consumeEnergy = false
	elseif gameLevelType == GameLevelType.kMayDay then
		consumeEnergy = false
	elseif gameLevelType == GameLevelType.kTaskForRecall then
		consumeEnergy = false
	end
	self:refreshEnergy(requestTime)
	if consumeEnergy and user:getEnergy() < user_energy_level_consume then
		return false, ZooErrorCode.ENERGY_NOT_ENOUGH
	end
	if #itemIds > 0 then

		--前置道具
		local gameModeProps = MetaManager.getInstance():getGameModePropByModeId(gameMode)
		local propConfig = MetaManager.getInstance().prop
		local initPropIds = {}
		if gameModeProps then
			initPropIds = gameModeProps.initProps
		end
		--地推包前置道具特殊处理
		if PublishActUtil:isGroundPublish() then
			initPropIds = PublishActUtil:getTempPropTable()
		end
		--召回功能最高关卡前置道具特殊处理
		if RecallManager.getInstance():getRecallLevelState(levelId) then
			local tempPropIds = table.clone(initPropIds)
			for i,v in ipairs(RecallManager.getInstance():getRecallItems()) do
				local isSame = false
				for m,n in ipairs(initPropIds) do
					if v == n then
						isSame = true
						break
					end
				end
				if not isSame then 
					table.insert(tempPropIds,v)
				end
			end
			initPropIds = tempPropIds
		end

		local totalAmount = 0
		local oriCoin = user:getCoin()
		for i,itemId in ipairs(itemIds) do


			local isFreeItem = false -- qixi
			if QixiUtil:hasCompeleted() then
				local remainingCount = QixiUtil:getRemainingFreeItem(itemId)
				isFreeItem = (remainingCount > 0)
			end
			local propMeta = propConfig[itemId]
			if propMeta and levelId < propMeta.unlock then
				return false, ZooErrorCode.USE_PROP_LEVEL_ERROR
			end
			if #initPropIds > 0 and table.indexOf(initPropIds, itemId) == nil then
				return false, ZooErrorCode.ADD_PROP_MODE_ERROR_START_LEVEL
			end

			if not PublishActUtil:isGroundPublish() then 
				--召回功能最高关卡前置道具特殊处理 召回加的临时道具不是银币买的 不走购买打点
				if RecallManager.getInstance():getRecallLevelState(levelId) then
					if not table.includes(RecallManager.getInstance():getRecallItems(),itemId) then 
						local goodsMeta = MetaManager.getInstance():getGoodMetaByItemID(itemId) 
						if not goodsMeta then
							return false, ZooErrorCode.CONFIG_ERROR
						end

						if not isFreeItem then -- qixi
							totalAmount = totalAmount + goodsMeta.coin
							DcUtil:logBuyItem(goodsMeta.id, goodsMeta.coin, 1, oriCoin - totalAmount , levelId)
						else
							QixiUtil:consumeFreeItem(itemId)
							DcUtil:useQixiFreePreProps(itemId) -- qixi
						end
					end
				else
					local goodsMeta = MetaManager.getInstance():getGoodMetaByItemID(itemId) 
					if not goodsMeta then
						return false, ZooErrorCode.CONFIG_ERROR
					end

					if not isFreeItem then -- qixi
						totalAmount = totalAmount + goodsMeta.coin
						DcUtil:logBuyItem(goodsMeta.id, goodsMeta.coin, 1, oriCoin - totalAmount , levelId)
					else
						QixiUtil:consumeFreeItem(itemId)
						DcUtil:useQixiFreePreProps(itemId) -- qixi
					end
				end
			end
		end

		local consume = ConsumeItem.new(ItemConstans.ITEM_COIN, totalAmount)
		local succeed, err = ItemLocalLogic:hasConsume(uid, consume)
		if succeed then
			succeed, err = ItemLocalLogic:consume(uid, consume)
			if not succeed then return false, err end
		else return false, err end
	end

	if consumeEnergy then
		return UserLocalLogic:subEnergy(uid, user_energy_level_consume, requestTime)
	end
	return true
end

function UserLocalLogic:startQixiLevel(uid, levelId, gameMode, itemIds, energyBuff, requestTime)
	if not QixiManager then return false, ZooErrorCode.INVALID_PARAMS end

	local qixi = QixiManager:sharedInstance()
	local success = true
	local errCode = nil
	return success, errCode
end

--http://svn.happyelements.net/repos/svndata2/animal/java/trunk/animal-service/src/main/java/com/happyelements/animal/service/impl/ScoreServiceImpl.java
function UserLocalLogic:updateScore(levelId, score, flashStar, useItem, stageTime, coinAmount, opLog, requestTime)
	local user = UserService.getInstance().user
	local uid = user.uid
	local result = {}

	local topLevelId = user:getTopLevelId()
	if not PublishActUtil:isGroundPublish() then
		if levelId > topLevelId then
			return nil, false, ZooErrorCode.LEVEL_ID_INVALID
		end
	end
	--LevelMapMeta LevelRewardMeta
	local levelStarMeta, rewardConfig, err = UserLocalLogic:checkPassLevelConfig(levelId)
	if err ~= nil then return nil, false, err end
	
	local star = flashStar
	if star ~= 0 then star = levelStarMeta:getStar(score) end

	local oriStar = 0
	local oriScore = 0
	local animalScore = UserService.getInstance():getUserScore(levelId)
	if animalScore == nil then
		UserLocalLogic:insertNewLevel(uid, levelId, star, score)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end
		
		if star > oriStar then
			if levelId == topLevelId and (not UserLocalLogic:isNewLevelAreaStart(levelId + 1)) then
				local succeed, err = UserLocalLogic:updateTopLevelId(uid, levelId + 1, star - oriStar)
				if err ~= nil then return nil, false, err end
				DcUtil:logLevelUp(levelId + 1)
			else
				local succeed, err = UserLocalLogic:addStar(uid, star - oriStar)
				if err ~= nil then return nil, false, err end
			end
		end
		--refresh global level rank
		if star > 0 then UserLocalLogic:updateLevelScoreRank( levelId, score ) end

		DcUtil:logFirstLevelGame(levelId, math.floor(levelId / 10000), star > 0, useItem, stageTime, 0)
		DcUtil:logBeforeFirstWin(levelId, math.floor(levelId / 10000), star > 0, useItem, stageTime, 0)
	else
		--repeat level
		oriStar = animalScore.star
		oriScore = animalScore.score
		UserLocalLogic:updateRepeatLevel(score, star, animalScore, uid)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelDefaultStarRewards(star > oriStar and oriStar or star, rewardConfig))
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end
		if oriStar == 0 then
			if star > oriStar then
				if levelId == topLevelId and (not UserLocalLogic:isNewLevelAreaStart(levelId + 1)) then
					local succeed, err = UserLocalLogic:updateTopLevelId(uid, levelId + 1, star - oriStar)
					if err ~= nil then return nil, false, err end
				else
					local succeed, err = UserLocalLogic:addStar(uid, star - oriStar)
					if err ~= nil then return nil, false, err end
				end
			end
		else
			if star > oriStar then
				local succeed, err = UserLocalLogic:addStar(uid, star - oriStar)
				if err ~= nil then return nil, false, err end
			end
		end

		if star > 0 and score > oriScore then
			--// refresh the global level rank
			UserLocalLogic:updateLevelScoreRank( levelId, score )
		end

		if oriStar == 0 then
			DcUtil:logBeforeFirstWin(levelId, math.floor(levelId / 10000), star > 0, useItem, stageTime, 0)
		end
	end

	--coin blocker
	if star > 0 and coinAmount > 0 then
		--CoinBlockerMeta
		local coinBlockerMeta = MetaManager.getInstance():getCoinBlockersByLevelId(levelId)
		if coinBlockerMeta and coinAmount < coinBlockerMeta.coin_amount then
			local coinValue = MetaManager.getInstance().global.coin or 5
			local addCoin = coinValue * coinAmount
			local succeed, err = ItemLocalLogic:add(uid, ItemConstans.ITEM_COIN, addCoin)
			if err ~= nil then return nil, false, err end
		end
	end
	local succeed, err = UserLocalLogic:rewardPassLevel(result, user, levelId, requestTime)
	if err ~= nil then return nil, false, err end

	return result, true
end
function UserLocalLogic:insertNewLevel( uid, levelId, star, score )
	local user = UserService.getInstance().user

	local animalScore = ScoreRef.new()
	animalScore.levelId = levelId
	animalScore.uid = user.uid
	animalScore.score = score
	animalScore.star = star
	animalScore.updateTime = Localhost:time()
	--TODO: if (star == 0) animalScore.setScore(0);		
	UserService.getInstance():addUserScore(animalScore)	
end
function UserLocalLogic:updateRepeatLevel( score, star, oldAnimalScore, uid )
	local dataChanged = false
	if score > oldAnimalScore.score and star > 0 then
		oldAnimalScore.score = score
		dataChanged = true
	end
	if star > oldAnimalScore.star then
		oldAnimalScore.star = star
		dataChanged = true
	end
	if dataChanged then
		oldAnimalScore.updateTime = Localhost:time()
	end
end
function UserLocalLogic:rewardPassLevel( rewards, user, levelId, requestTime )
	local mergedRewards = ItemLocalLogic:mergeRewards(rewards)
	if mergedRewards and #mergedRewards > 0 then
		for i,v in ipairs(mergedRewards) do
			if v.itemId == ItemConstans.ITEM_COIN then
				--TODO: logCreateCoin
			end
			local succeed, err = ItemLocalLogic:add(user.uid, v.itemId, v.num, requestTime)
			if err ~= nil then return false, err end
		end
	end
	return true
end

--http://svn.happyelements.net/repos/svndata2/animal/java/trunk/animal-service/src/main/java/com/happyelements/animal/service/impl/ScoreServiceImpl.java
function UserLocalLogic:updateLevelScoreRank( levelId, score )
	
end

function UserLocalLogic:isNewLevelAreaStart( levelId )
	return MetaManager.getInstance():isMinLevelAreaId(levelId)  
end
function UserLocalLogic:updateHideLevelScore(levelId, score, flashStar, useItem, stageTime, coinAmount, opLog, requestTime)
	local isHideAreaUnLocked = ItemLocalLogic:checkHideAreaUnLocked( uid, levelId )
	
	if not isHideAreaUnLocked then
		print("HIDE_AREA_ERROR_AREA_UNLOCK")
		return nil, false, ZooErrorCode.HIDE_AREA_ERROR_AREA_UNLOCK
	end
	local user = UserService.getInstance().user
	local uid = user.uid
	local result = {}

	--LevelMapMeta LevelRewardMeta
	local levelStarMeta, rewardConfig, err = UserLocalLogic:checkPassLevelConfig(levelId)
	if err ~= nil then return nil, false, err end

	local star = flashStar
	if star ~= 0 then star = levelStarMeta:getStar(score) end

	local oriStar = 0
	local oriScore = 0
	local animalScore = UserService.getInstance():getUserScore(levelId)

	if animalScore == nil then
		UserLocalLogic:insertNewLevel(uid, levelId, star, score)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
			--refresh global level rank
			UserLocalLogic:updateLevelScoreRank( levelId, score )
		end
	else
		--repeat level
		oriStar = animalScore.star
		oriScore = animalScore.score
		UserLocalLogic:updateRepeatLevel(score, star, animalScore, uid)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelDefaultStarRewards(star > oriStar and oriStar or star, rewardConfig))
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end

		if star > 0 and score > oriScore then
			--// refresh the global level rank
			UserLocalLogic:updateLevelScoreRank( levelId, score )
		end
	end

	--coin blocker
	if star > 0 and coinAmount > 0 then
		local coinBlockerMeta = MetaManager.getInstance():getCoinBlockersByLevelId(levelId)
		if coinBlockerMeta and coinAmount < coinBlockerMeta.coin_amount then
			local coinValue = MetaManager.getInstance().global.coin or 5
			local addCoin = coinValue * coinAmount
			local succeed, err = ItemLocalLogic:add(uid, ItemConstans.ITEM_COIN, addCoin)
			if err ~= nil then return nil, false, err end
		end
	end
	local succeed, err = UserLocalLogic:rewardPassLevel(result, user, levelId, requestTime)
	if err ~= nil then return nil, false, err end

	if star > oriStar then 
		local succeed, err = UserLocalLogic:addHideStar(uid, star - oriStar) 
		if err ~= nil then return nil, false, err end
	end
	return result, true
end

function UserLocalLogic:updateDiggerMatchLevelScore( levelId, score, flashStar, useItem, stageTime, gemCount, opLog, requestTime )

	local user = UserService.getInstance().user
	local uid = user.uid
	local result = {}

	--LevelMapMeta LevelRewardMeta
	local levelStarMeta, rewardConfig, err = UserLocalLogic:checkPassLevelConfig(levelId)
	if err ~= nil then return nil, false, err end

	local star = flashStar
	if star ~= 0 then star = levelStarMeta:getStar(score) end

	local oriStar = 0
	local animalScore = UserService.getInstance():getUserScore(levelId)
	if animalScore == nil then
		UserLocalLogic:insertNewLevel(uid, levelId, star, score)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end
	else
		--repeat level
		oriStar = animalScore.star
		UserLocalLogic:updateRepeatLevel(score, star, animalScore, uid)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelDefaultStarRewards(star > oriStar and oriStar or star, rewardConfig))
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end
	end

	local succeed, err = UserLocalLogic:rewardPassLevel(result, user, levelId, requestTime)
	if err ~= nil then return nil, false, err end

	UserLocalLogic:recordDailyMaxGemCount(uid, gemCount, levelId)
	UserLocalLogic:recordDailyDigg(uid)
	return result, true
end

function UserLocalLogic:updateMaydayEndlessLevelScore(levelId, score, flashStar, useItem, stageTime, coinAmount, targetCount, opLog, activityFlag, requestTime)
	local user = UserService.getInstance().user
	local uid = user.uid
	local result = {}

	--LevelMapMeta LevelRewardMeta
	local levelStarMeta, rewardConfig, err = UserLocalLogic:checkPassLevelConfig(levelId)
	if err ~= nil then return nil, false, err end

	local star = flashStar
	if star ~= 0 then star = levelStarMeta:getStar(score) end

	local oriStar = 0
	local animalScore = UserService.getInstance():getUserScore(levelId)
	if animalScore == nil then
		-- UserLocalLogic:insertNewLevel(uid, levelId, star, score)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end
	else
		--repeat level
		oriStar = animalScore.star
		UserLocalLogic:updateRepeatLevel(score, star, animalScore, uid)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelDefaultStarRewards(star > oriStar and oriStar or star, rewardConfig))
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end
	end

	local succeed, err = UserLocalLogic:rewardPassLevel(result, user, levelId, requestTime)
	if err ~= nil then return nil, false, err end

	return result, true
end

function UserLocalLogic:updateRabbitWeeklyLevelScore(levelId, score, flashStar, stageTime, coinAmount, targetCount, opLog, activityFlag, requestTime)
	local user = UserService.getInstance().user
	local uid = user.uid
	local result = {}

	--LevelMapMeta LevelRewardMeta
	local levelStarMeta, rewardConfig, err = UserLocalLogic:checkPassLevelConfig(levelId)
	if err ~= nil then return nil, false, err end

	local star = flashStar
	if star ~= 0 then star = levelStarMeta:getStar(score) end

	local oriStar = 0
	-- 不记录分数
	local animalScore = UserService.getInstance():getUserScore(levelId)
	if animalScore == nil then
		UserLocalLogic:insertNewLevel(uid, levelId, star, score)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end
	else
		--repeat level
		oriStar = animalScore.star
		UserLocalLogic:updateRepeatLevel(score, star, animalScore, uid)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelDefaultStarRewards(star > oriStar and oriStar or star, rewardConfig))
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end
	end

	local succeed, err = UserLocalLogic:rewardPassLevel(result, user, levelId, requestTime)
	if err ~= nil then return nil, false, err end

	return result, true	
end

function UserLocalLogic:updateActivityLevelScore(levelId, score, flashStar, useItem, stageTime, coinAmount, targetCount, opLog, activityFlag, requestTime)
	if activityFlag == GameLevelType.kQixi then
		print('UserLocalLogic:updateActivityLevelScore')
		QixiManager:sharedInstance():onPassLevel(targetCount)
		return {}, true
	end
end

function UserLocalLogic:updateRecallTaskLevelScore(levelId, score, flashStar, useItem, stageTime, coinAmount, targetCount, opLog, activityFlag, requestTime)
	local user = UserService.getInstance().user
	local uid = user.uid
	local result = {}

	--LevelMapMeta LevelRewardMeta
	local levelStarMeta, rewardConfig, err = UserLocalLogic:checkPassLevelConfig(levelId)
	if err ~= nil then return nil, false, err end

	local star = flashStar
	if star ~= 0 then star = levelStarMeta:getStar(score) end

	local oriStar = 0
	-- 不记录分数
	local animalScore = UserService.getInstance():getUserScore(levelId)
	if animalScore == nil then
		UserLocalLogic:insertNewLevel(uid, levelId, star, score)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end
	else
		--repeat level
		oriStar = animalScore.star
		UserLocalLogic:updateRepeatLevel(score, star, animalScore, uid)
		if star > 0 then
			table.addAll(result, UserLocalLogic:getLevelDefaultStarRewards(star > oriStar and oriStar or star, rewardConfig))
			table.addAll(result, UserLocalLogic:getLevelNewStarRewards(star, oriStar, rewardConfig))
		end
	end
	return result, true
end


function UserLocalLogic:recordDailyMaxGemCount( uid, gemCount, levelId )
	--TODO: implement it.
end
function UserLocalLogic:recordDailyDigg( uid )
	--TODO: implement it.
end
function UserLocalLogic:getLevelDefaultStarRewards(oriStar, rewardConfig)
	local result = {}
	for i=1,oriStar do
		table.addAll(result, rewardConfig:getDefaultStarRewards(i))
	end
	return result
end
function UserLocalLogic:getLevelNewStarRewards(newStar, oriStar, rewardConfig)
	local result = {}
	for i = oriStar + 1, newStar do
		table.addAll(result, rewardConfig:getNewStarRewards(i))
	end
	return result
end

--http://svn.happyelements.net/repos/svndata2/animal/java/trunk/animal-service/src/main/java/com/happyelements/animal/service/impl/UserServiceImpl.java
function UserLocalLogic:updateTopLevelId( uid, topLevelId, addStar )
	-- AnimalActivity.logUserTopLevelUp(uid, topLevelId);
	return UserLocalLogic:updateUser(uid, NO_DIFF, NO_DIFF, addStar, NO_DIFF, topLevelId, NO_DIFF, NO_DIFF)
end
function UserLocalLogic:addStar( uid, star )
	if star < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return UserLocalLogic:updateUser(uid, NO_DIFF, NO_DIFF, star, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF)
end
function UserLocalLogic:addHideStar( uid, star )
	if star < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return UserLocalLogic:updateUser(uid, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, star)
end
function UserLocalLogic:addCoin( uid, coin )
	if coin < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return UserLocalLogic:updateUser(uid, coin, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF)
end
function UserLocalLogic:subCoin( uid, coin )
	if coin < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return UserLocalLogic:updateUser(uid, -coin, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF)
end
function UserLocalLogic:addCash( uid, cash )
	if cash < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return UserLocalLogic:updateUser(uid, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, cash)
end
function UserLocalLogic:subCash( uid, cash )
	if cash < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return UserLocalLogic:updateUser(uid, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, -cash)
end
function UserLocalLogic:addPoint( uid, point )
	if point < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return UserLocalLogic:updateUser(uid, NO_DIFF, point, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF)
end
function UserLocalLogic:subPoint( uid, point )
	if point < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return UserLocalLogic:updateUser(uid, NO_DIFF, -point, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF)
end
function UserLocalLogic:addEnergy( uid, energy, requestTime )
	if energy < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return UserLocalLogic:updateUser(uid, NO_DIFF, NO_DIFF, NO_DIFF, energy, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, requestTime)
end
function UserLocalLogic:subEnergy( uid, energy, requestTime )
	if energy < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return 	UserLocalLogic:updateUser(uid, NO_DIFF, NO_DIFF, NO_DIFF, -energy, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, requestTime)
end
function UserLocalLogic:updateStar( uid, star )
	if star < 0 then return false, ZooErrorCode.INVALID_PARAMS end
	return UserLocalLogic:updateUser(uid, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, NO_DIFF, star)
end
--http://svn.happyelements.net/repos/svndata2/animal/java/trunk/animal-service/src/main/java/com/happyelements/animal/service/impl/UserServiceImpl.java
function UserLocalLogic:updateUser( uid, addCoin, addPoint, addStar, addEnergy, topLevelId, image, addHideStar, updateStar, addCash, requestTime)
	local user = UserService.getInstance().user
	addCoin = addCoin or 0
	addPoint = addPoint or 0
	addEnergy = addEnergy or 0
	topLevelId = topLevelId or 0
	image = image or 0
	addHideStar = addHideStar or 0
	updateStar = updateStar or 0
	addCash = addCash or NO_DIFF

	assert(user, "USER_RECORD_NOT_FOUND")
	if image ~= NO_DIFF then user.image = image end
	if addCoin ~= NO_DIFF then
		assert((user:getCoin() + addCoin) >= 0, "COIN_NOT_ENOUGH")
		if user:getCoin() + addCoin < 0 then return false, ZooErrorCode.COIN_NOT_ENOUGH end
		user:setCoin(user:getCoin() + addCoin)	
	end
	if addCash ~= NO_DIFF then
		assert((user:getCash() + addCash) >= 0, "CASH_NOT_ENOUGH")
		if user:getCash() + addCash < 0 then return false, ZooErrorCode.CASH_NOT_ENOUGH end
		user:setCash(user:getCash() + addCash)
	end
	if addPoint ~= NO_DIFF then
		assert((user.point + addPoint) >= 0, "POINT_NOT_ENOUGH")
		if user.point + addPoint < 0 then return false, ZooErrorCode.POINT_NOT_ENOUGH end
		user.point = user.point + addPoint
	end
	user:setStar(user:getStar() + addStar)

	if updateStar ~= NO_DIFF then
		user:setStar(updateStar)
	end

	user:setHideStar(user:getHideStar() + addHideStar)
	if addEnergy ~= NO_DIFF then
		local changedEnergy = 0
		if addEnergy < 0 then
			user = UserLocalLogic:refreshEnergy(requestTime)
			assert(user:getEnergy() + addEnergy >= 0, "ENERGY_NOT_ENOUGH")	
			if user:getEnergy() + addEnergy < 0 then return false, ZooErrorCode.ENERGY_NOT_ENOUGH end		
			user:setEnergy(user:getEnergy() + addEnergy)
			changedEnergy = addEnergy
		else
			local now = Localhost:time()
			if type(requestTime) == "number" then now = requestTime end
			local maxEnergy = MetaManager.getInstance().global.user_energy_max_count or 30
			local userExtend = UserService.getInstance().userExtend
			local energyPlusEffectTime = userExtend:getEnergyPlusEffectTime()
			if energyPlusEffectTime > now then
				local propMeta = MetaManager.getInstance():getPropMeta(userExtend.energyPlusId)
				assert(propMeta)
				if propMeta then
					maxEnergy = maxEnergy + propMeta.confidence
				end
			elseif userExtend.energyPlusPermanentId > 0 then
				local propMeta = MetaManager.getInstance():getPropMeta(userExtend.energyPlusPermanentId)
				assert(propMeta)
				if propMeta then
					maxEnergy = maxEnergy + propMeta.confidence
				end
			end

			if user:getEnergy() + addEnergy > maxEnergy then
				user:setEnergy(maxEnergy)
				changedEnergy = maxEnergy - user:getEnergy()
			else
				user:setEnergy(user:getEnergy() + addEnergy)
				changedEnergy = addEnergy
			end
		end
	end

	if topLevelId > NO_DIFF then user:setTopLevelId(topLevelId) end
	return true
end
--http://svn.happyelements.net/repos/svndata2/animal/java/trunk/animal-service/src/main/java/com/happyelements/animal/service/impl/UserServiceImpl.java
function UserLocalLogic:refreshEnergy(time)
	local user = UserService.getInstance().user
	local now = Localhost:time() --long now = timeService.getTime(user.getUid());
	if type(time) == "number" then now = time end
	local maxEnergy = MetaManager.getInstance().global.user_energy_max_count or 30
	local userExtend = UserService.getInstance().userExtend
	local energyPlusEffectTime = userExtend:getEnergyPlusEffectTime()

	if energyPlusEffectTime > now then
		local propMeta = MetaManager.getInstance():getPropMeta(userExtend.energyPlusId)
		if propMeta then
			maxEnergy = maxEnergy + propMeta.confidence
		end
	elseif userExtend.energyPlusPermanentId > 0 then
		local propMeta = MetaManager.getInstance():getPropMeta(userExtend.energyPlusPermanentId)
		if propMeta then
			maxEnergy = maxEnergy + propMeta.confidence
		end
	end

	if user:getEnergy() < maxEnergy then
		local timePast = now - user:getUpdateTime()
		local user_energy_recover_time_unit = MetaManager.getInstance().global.user_energy_recover_time_unit or 480000
		local energyInc = math.floor(timePast / user_energy_recover_time_unit)
		if energyInc >= 1 then
			if user:getEnergy() + energyInc >= maxEnergy then
				user:setEnergy(maxEnergy)
				user:setUpdateTime(now)
			else
				user:setEnergy(user:getEnergy() + energyInc)
				local notUsedTime = timePast % user_energy_recover_time_unit
				user:setUpdateTime(now - notUsedTime)
			end
			print("UserLocalLogic->refreshEnergy, updateTime: ", now, os.date(nil, now/1000), " energy:", user:getEnergy(), " energyInc", energyInc)
		end
	else
		user:setUpdateTime(now)
	end

	return user
end

function UserLocalLogic:getUserEnergyMaxCount(uid)
	local time = Localhost:time()
	local maxEnergy = MetaManager.getInstance().global.user_energy_max_count or 30
	local userExtend = UserService.getInstance().userExtend
	local energyPlusEffectTime = userExtend:getEnergyPlusEffectTime()
	if energyPlusEffectTime > time then
		local propMeta = MetaManager.getInstance():getPropMeta(userExtend.energyPlusId)
		if propMeta then
			maxEnergy = maxEnergy + propMeta.confidence
		end
	elseif userExtend.energyPlusPermanentId > 0 then
		local propMeta = MetaManager.getInstance():getPropMeta(userExtend.energyPlusPermanentId)
		if propMeta then
			maxEnergy = maxEnergy + propMeta.confidence
		end
	end
	return maxEnergy
end

function UserLocalLogic:getNewUserRewards(type)
	local user = UserService.getInstance().user
	local uid = user.uid
	local topLevelId = user:getTopLevelId()

	local rewards = {}
	if topLevelId == 1 then
		rewards = MetaManager.getInstance():getNewUserRewards()
	end

	for i, v in ipairs(rewards) do
		local succeed, err = ItemLocalLogic:add(uid, v.itemId, v.num)
		if err ~= nil then return nil, false, err end
	end

	UserService.getInstance().userExtend:setNewUserReward(1)
	return rewards, true
end