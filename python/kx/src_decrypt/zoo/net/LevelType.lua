LevelConstans = table.const{
	MAIN_LEVEL_ID_START = 0,
	MAIN_LEVEL_ID_END = 9999,
	HIDE_LEVEL_ID_START = 10000,
	HIDE_LEVEL_ID_END = 19999,
	DIGGER_MATCH_LEVEL_ID_START = 20000,
	DIGGER_MATCH_LEVEL_ID_END = 29999,
	-- RABBIT_MATCH_LEVEL_ID_START = 30000,
	-- RABBIT_MATCH_LEVEL_ID_END = 39999,
	RABBIT_MATCH_LEVEL_ID_START = 160000,
	RABBIT_MATCH_LEVEL_ID_END = 169999,
	MAYDAY_ENDLESS_LEVEL_ID_START = 150000,
	MAYDAY_ENDLESS_LEVEL_ID_END = 151000,
	RECALL_TASK_LEVEL_ID_START = 170000,
	RECALL_TASK_LEVEL_ID_END = 179999,
}

StageModeConstans = table.const{
	STAGE_MODE_NORMAL = 0,
	STAGE_MODE_PVP = 1,
	STAGE_MODE_HIDE_AREA = 2,
	STAGE_MODE_DIGGER_MATCH = 3,
	STAGE_MODE_RABBIT_MATCH = 4
}

GameLevelType = {
	kQixi 			= 1,
	kMainLevel 		= 2,
	kHiddenLevel 	= 3,
	kDigWeekly		= 4,
	kMayDay			= 5,
	kRabbitWeekly	= 6,
	kTaskForRecall  = 8,
}

LevelType = class()

function LevelType:isMainLevel( levelId )
	if levelId > LevelConstans.MAIN_LEVEL_ID_START and levelId <= LevelConstans.MAIN_LEVEL_ID_END then return true
	else return false end
end

function LevelType:isHideLevel( levelId )
	if levelId > LevelConstans.HIDE_LEVEL_ID_START and levelId <= LevelConstans.HIDE_LEVEL_ID_END then return true
	else return false end
end

function LevelType:isDiggerMatchLevel( levelId )
	if levelId > LevelConstans.DIGGER_MATCH_LEVEL_ID_START and levelId <= LevelConstans.DIGGER_MATCH_LEVEL_ID_END then return true
	else return false end
end

function LevelType:isRabbtiMatchLevel( levelId )
	if levelId > LevelConstans.RABBIT_MATCH_LEVEL_ID_START and levelId <= LevelConstans.RABBIT_MATCH_LEVEL_ID_END then return true
	else return false end
end

function LevelType:isMaydayEndlessLevel( levelId )
	if levelId > LevelConstans.MAYDAY_ENDLESS_LEVEL_ID_START and levelId <= LevelConstans.MAYDAY_ENDLESS_LEVEL_ID_END then return true
	else return false end
end

function LevelType:isRecallTaskLevel( levelId )
	if levelId > LevelConstans.RECALL_TASK_LEVEL_ID_START and levelId <= LevelConstans.RECALL_TASK_LEVEL_ID_END then return true
	else return false end
end

function LevelType:getLevelTypeByLevelId( levelId )
	if LevelType:isMainLevel(levelId) then
		return GameLevelType.kMainLevel
	elseif LevelType:isHideLevel(levelId) then
		return GameLevelType.kHiddenLevel
	elseif LevelType:isDiggerMatchLevel(levelId) then
		return GameLevelType.kDigWeekly
	elseif LevelType:isMaydayEndlessLevel(levelId) then 
		return GameLevelType.kMayDay
	elseif LevelType:isRabbtiMatchLevel(levelId) then
		return GameLevelType.kRabbitWeekly
	elseif LevelType:isRecallTaskLevel(levelId) then
		return GameLevelType.kTaskForRecall
	else
		assert(false, 'unknown level type:levelId='..tostring(levelId))
	end
end

function LevelType.isShowRankList( levelType )
	if _isQixiLevel then return false end
	if levelType == GameLevelType.kMayDay or levelType == GameLevelType.kTaskForRecall then
		return false
	end
	return true
end

function LevelType.isShareEnable( levelType )
	return levelType == GameLevelType.kMainLevel
		or levelType == GameLevelType.kHiddenLevel
end
