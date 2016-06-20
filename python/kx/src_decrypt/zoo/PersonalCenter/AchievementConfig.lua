require "zoo.panel.share.ShareFinalPassLevelPanel"
require "zoo.panel.share.ShareFirstInFriendsPanel"
require "zoo.panel.share.ShareFourStarPanel"
require "zoo.panel.share.ShareHiddenLevelPanel"
require "zoo.panel.share.ShareLastStepPanel"
require "zoo.panel.share.ShareLeftTenStepPanel"
require "zoo.panel.share.SharePassFiveLevelPanel"
require "zoo.panel.share.SharePassFriendPanel"
require "zoo.panel.share.SharePyramidPanel"
require "zoo.panel.share.ShareThousandOnePanel"
require "zoo.panel.share.ShareTrophyPanel"
require "zoo.panel.share.ShareChestPanel"
require "zoo.panel.share.ShareEggsPanel"
require "zoo.panel.share.ShareUnlockNewObstaclePanel"
require "zoo.panel.share.Share5Time4StarPanel"
require "zoo.panel.share.ShareNStarRewardPanel"

local manager = AchievementManager
local id = manager.shareId
local ShareType = manager.shareType
local Priority = manager.priority

local AchievementType = manager.achievementType

kShareConfig = {} 
kShareConfig[tostring(manager.PASS_STEP_LESS_10)] = {id=1, gamecenter="happyelements_5steps"}--
kShareConfig[tostring(manager.PASS_HIGHEST_LEVEL)] = {id=2, gamecenter="happyelements_before1000_high"}
kShareConfig[tostring(manager.LAST_STEP_PASS)] = {id=3, gamecenter="happyelements_last_step_pass"}--
kShareConfig[tostring(manager.N_TIME_PASS)] = {id=4, gamecenter="happyelements_finally_pass"}--
kShareConfig[tostring(manager.OVER_SELF_RANK)] = {id=5, gamecenter="happyelements_before1000_friends"}
kShareConfig[tostring(manager.CONTINUE_PASS_5_LEVEL)] = {id=6, gamecenter="happyelements_rocket"}--
kShareConfig[tostring(manager.SCORE_OVER_FRIEND)] = {id=7, gamecenter="happyelements_beyond_friends"}
kShareConfig[tostring(manager.LEVEL_OVER_FRIEND)] = {id=8, gamecenter="happyelements_beyond_friends_checkpoint"}
kShareConfig[tostring(manager.HIDE_FULL_STAR)] = {id=9, gamecenter="happyelements_fourstar"}
kShareConfig[tostring(manager.ALL_THREE_STARS)] = {id=10, gamecenter="happyelements_all_star"}--
--kShareConfig[tostring(manager.UNLOCK_HIDEN_LEVEL)] = {id=11, gamecenter="happyelements_hidden_checkpoint"}
--kShareConfig[tostring(manager.EIGHTY_PERCENT_PERSON)] = {id=12, gamecenter="happyelements_rocket"}
kShareConfig[tostring(manager.FRIST_RANK_FRIEND)] = {id=15, gamecenter="happyelements_no.1_friends"}
--kShareConfig[tostring(manager.HIGHEST_LEVEL_TWO)] = {id=16, gamecenter="happyelements_the_highest_level"}
kShareConfig[tostring(manager.MARK_FINAL_CHEST)] = {id=18, gamecenter="happyelements_sign_get_treasure"}

--关卡数大于7
local function LevelGreater7()
	local top_level = UserManager.getInstance().user:getTopLevelId()
	return top_level > 7
end
--关卡数大于15
local function LevelGreater15()
	local top_level = UserManager.getInstance().user:getTopLevelId()
	return top_level > 15
end

--关卡数大于30
local function LevelGreater30()
	local top_level = UserManager.getInstance().user:getTopLevelId()
	local score = UserManager.getInstance():getUserScore(top_level)
	if score then
		top_level = top_level + 1
	end
	return top_level > 30
end

--通关好友数大于4
local function PassFriNumG4()
	return manager:getData(manager.PASS_FRIEND_NUM) > 4
end

--好友数大于4
local function FriendNumG4()
	local friend_num = FriendManager:getInstance():getFriendCount()
	return friend_num > 4
end

--连续失败n次后过关
local function FailNumG5()
	local levelDataInfo = UserService.getInstance().levelDataInfo
	local levelInfo = levelDataInfo:getLevelInfo(manager:getData(manager.LEVEL))

	local playTimes = levelInfo.playTimes or 0
	local failTimes = levelInfo.failTimes or 0

	return playTimes > 5 and (playTimes - failTimes) == 1
end
--是否不是重复闯关
local function IsNotRepeatLevel()
	local score = manager:getData(manager.PRE_SCORE)
	if score then
		return false
	else
		return true
	end
end
--是否是当前版本最高关卡
local function IsCurHighestLevel()
	local version_highest_level =  MetaManager.getInstance():getMaxNormalLevelByLevelArea()
	return version_highest_level == manager:getData(manager.LEVEL)
end
--好友排行榜第一
local function IsFirstFriendRank()
	local rank = manager:getData(manager.FRIEND_RANK)
	return rank == 1
end

--分数进入该关卡前1000名
-- local function ScorePassThousand()
-- 	local score = manager:getData(manager.TOTAL_SCORE)
-- 	local minRankScore = manager:getData(manager.MIN_RANK_SCORE)
-- 	return score >= minRankScore
-- end

--是否超越自己的排名
local function IsOverSelfRank()
	return manager:getData(manager.OVER_SELF_RANK) == true
end


--全部区域3星
local function IsFullThreeStars()
	local maxStar = 15 * 3
	local userStar = 0

	local firstLevel = 1
	local lastLevel = 15
	local currentLevel = manager:getData(manager.LEVEL)
	if currentLevel then 
		if currentLevel%15 == 0 then
			firstLevel = currentLevel - 15
			lastLevel = currentLevel
		else
			firstLevel = currentLevel - (currentLevel%15)
			lastLevel = firstLevel + 15
		end
		if firstLevel<1 then 
			firstLevel = 1
		end
	end

	local preScore = manager:getData(manager.PRE_SCORE)
	local passLevelStar = manager:getData(manager.PASS_LEVEL_STAR)
	if preScore == nil then
		userStar = userStar + passLevelStar
		if passLevelStar <= 2 then return false end 
	else
		local score = UserManager:getInstance():getUserScore(currentLevel)
		if preScore.star >= 3 then return false end
		if score.star < 3 then return false end 
		userStar = userStar + score.star
	end

	firstLevel = firstLevel + 1
	if firstLevel == 2 then firstLevel = 1 end
	--TODO:current level star >= 3
	local scores = UserManager:getInstance().scores
	for k,v in pairs(scores) do
		if v.levelId >= firstLevel and v.levelId <= lastLevel and v.levelId ~= currentLevel then
			if v.star <= 2 then return false end 
			userStar = userStar + v.star
		end
	end

	return userStar >= maxStar
end

--是否获得隐藏的4颗星
local function IsFourStar()
	local level = manager:getData(manager.LEVEL)
	local totalScore = manager:getData(manager.TOTAL_SCORE)
	local scores = MetaModel:sharedInstance():getLevelTargetScores(level)
	local star = 0
	for k, v in ipairs(scores) do
		if totalScore > v then star = k end
	end

	return star == 4
end

--分数是否超越好友
local function IsScoreOverFriend()
	local friend_rank_list = manager:getData(manager.FRIEND_RANK_LIST)
	local self_score = manager:getData(manager.TOTAL_SCORE)
	local isOverFriend = false

	local over_friend_table = {}

	for i,v in ipairs(friend_rank_list) do
		if self_score > v.score then
			isOverFriend = true
			table.insert( over_friend_table, v )
		end
	end

	manager:setData(manager.SCORE_OVER_FRIEND_TABLE, over_friend_table)

	return isOverFriend
end

--进度是否超越好友
local function IsLevelOverFriend()
	local friend_rank_list = FriendManager:getInstance().friends

	if friend_rank_list == nil then
		return false
	end

	local isOverFriend = false

	local level_over_friend_table = {}
	local level = manager:getData(manager.LEVEL)

	for uid,friend in pairs(friend_rank_list) do
		local top_level = friend:getTopLevelId()
		if level == top_level then
			isOverFriend = true
			table.insert(level_over_friend_table, friend)
		end
	end

	manager:setData(manager.LEVEL_OVER_FRIEND_TABLE, level_over_friend_table)

	return isOverFriend
end

--是否签到领取最后一个宝箱
local function IsMarkFinalChest()
	local isFinal = manager:getData(manager.GET_MARK_FINAL_CHEST)
	return isFinal == true
end

-- 收集61儿童节所有的彩蛋
local function IsColletAll61Eggs()
	local isAll = manager:getData(manager.COLLECT_ALL_61_EGGS)
	return isAll == true
end

--是否连续通过5关以上
local function IsPassFiveLevel()
	local levelDataInfo = UserService.getInstance().levelDataInfo

	local top_level = UserManager.getInstance().user:getTopLevelId()
	local maxConbo = levelDataInfo.maxConbo or 0

	local levels = {}
	for level,v in pairs(levelDataInfo.levels) do
		if LevelType:isMainLevel(tonumber(level)) then
			table.insert(levels, tonumber(level))
		end
	end

	table.sort(levels)

	if #levels < 5 then
		return false
	end

	--连续
	for i = #levels - 4, #levels-1 do
		if levels[i + 1] - levels[i] ~= 1 then
			return false
		end
	end

	return maxConbo >= 5
end

--是否是最后一步过关
local function IsLastStepPass()
	return manager:getData(manager.LEFT_STEP) == 0
end

--通关步数小等于10
local function PassStepLE10()
	return manager:getData(manager.PASS_STEP) <= 10
end

--解锁新障碍的关卡
local function UnlockNewObstacle()
	local firstNewObstacleLevels = MetaManager:getInstance().global.firstNewObstacleLevels
	local level = manager:getData(manager.LEVEL)

	table.sort(firstNewObstacleLevels)

	for _,o_level in ipairs(firstNewObstacleLevels) do
		if level == o_level then
			return true
		end

		if level < o_level then
			return false
		end
	end

	return false
end
--计算解锁新障碍的关卡的成就等级
local function CalUnLocalNewObstacleAchiLevel()
	local firstNewObstacleLevels = MetaManager:getInstance().global.firstNewObstacleLevels
	local level = manager:getData(manager.LEVEL)

	table.sort(firstNewObstacleLevels)

	local score = 0
	local achiLevel = 0

	for index, o_level in ipairs(firstNewObstacleLevels) do
		if level <= o_level then
			achiLevel = index
			if level > 400 then
				score = score + 50
			else
				score = score + 20
			end
		else
			break
		end
	end

	return achiLevel, score
end

--通过n个区域的全部隐藏关
local function PassAllAreaHideLevel()
	local level = manager:getData(manager.LEVEL)
	local isHideLevel = LevelType:isHideLevel(level)

	if isHideLevel then
		local hideAreaLevelIds = {}
		local HIDE_LEVEL_ID_START = 10000
		local hideArea = MetaManager.getInstance():getHideAreaByHideLevelId(level)

		if hideArea == nil then return false end

		local hideLevels = hideArea.hideLevelRange
		for i,v in ipairs(hideLevels) do
			table.insert(hideAreaLevelIds, HIDE_LEVEL_ID_START + v)
		end

		table.sort( hideAreaLevelIds )

		if hideAreaLevelIds[#hideAreaLevelIds] == level then
			return true
		end
	end

	return false
end

--计算通过n个区域的全部隐藏关的成就等级
local function CalPassAllAreaHideLevelAchiLevel()
	local hide_area = MetaManager.getInstance().hide_area
	local HIDE_LEVEL_ID_START = 10000

	local achiLevel = 0

	for k,hideArea in pairs(hide_area) do
		local hideLevels = hideArea.hideLevelRange

		local isPassAll = true

		for i,v in ipairs(hideLevels) do
			local level = HIDE_LEVEL_ID_START + v
			local score = UserManager.getInstance():getUserScore(level)
			if score == nil or score.star < 1 then 
				isPassAll = false
				break
			end
		end

		if isPassAll == true then
			achiLevel = achiLevel + 1
		end
	end

	return achiLevel
end

--有5*n关卡达到4星
local function Is5TimesLevelTo4star()
	local level = manager:getData(manager.LEVEL)
	local scores = UserManager.getInstance():getScoreRef()
	local levelCount = 0
	local thisFourStar = false
	for i,score in ipairs(scores) do
		if score.star == 4 then
			levelCount = levelCount + 1
		end

		if score.levelId == level and score.star == 4 then
			thisFourStar = true
		end
	end

	manager:setData(manager.FIVE_TIMES_4_STAR_COUNT, levelCount)

	return levelCount % 5 == 0 and thisFourStar
end

--计算有5*n关卡达到4星成就等级
local function Cal5TimesLevelTo4starAchiLevel()
	local level = manager:getData(manager.LEVEL)
	local scores = UserManager.getInstance():getScoreRef()
	local levelCount = 0

	for i,score in ipairs(scores) do
		if score.star == 4 then
			levelCount = levelCount + 1
		end
	end

	return math.floor(levelCount / 5)
end

--获得n星星（n=星星奖励可领取数值）
local function IsGetStarReward()
	local curTotalStar 	= UserManager:getInstance().user:getTotalStar()
	local starReward = MetaManager.getInstance().star_reward
	for _,reward in ipairs(starReward) do
		if curTotalStar == reward.starNum and curTotalStar > manager.preTotalStar then
			return true
		end
	end

	return false
end

--计算获得n星星（n=星星奖励可领取数值）成就等级
local function CalGetStarRewardAchiLevel()
	local curTotalStar 	= UserManager:getInstance().user:getTotalStar()
	local starReward = MetaManager.getInstance().star_reward
	local achiLevel = 0

	for _,reward in ipairs(starReward) do
		if curTotalStar <= reward.starNum then
			achiLevel = achiLevel + 1
		end
	end

	return achiLevel
end

local function GetImgUrl(shareId)
	local timer = os.time()
	local datetime = tostring(os.date("%y%m%d", timer))
	local imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_first.jpg?v="..datetime)	
	return imageURL
end

local function GetKeyName( id )
	return "achievement_name_"..id
end

local function GetKeyDesc( id )
	return "achievement_desc_"..id
end

local function GetShareTitle( id )
	return "show_off_desc_"..id
end

local function GenLevelType( ... )
	local p = {...}
	local ret = 0
	for i,v in ipairs(p) do
		local tmp = bit.lshift(1, v - 1)
		ret = bit.bor(ret, tmp)
	end

	return ret
end

local config = {
	[id.SCORE_PASS_THOUSAND] = {
		judge = function ()
			return LevelGreater7() and IsOverSelfRank()
		end,
		unlockCondition = LevelGreater7,
		priority = table.indexOf(Priority, id.SCORE_PASS_THOUSAND),
		keyName = GetKeyName(id.SCORE_PASS_THOUSAND),
		keyDesc = GetKeyDesc(id.SCORE_PASS_THOUSAND),
		achievementType = AchievementType.TRIGGER,
		achievementImage = true,
		autoCalScore = false,
		score = 100,
		levelType = GenLevelType(GameLevelType.kMainLevel, GameLevelType.kHiddenLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.SCORE_PASS_THOUSAND),
		shareImage = GetImgUrl(id.SCORE_PASS_THOUSAND),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
			manager.TOTAL_SCORE,
			manager.OVER_SELF_RANK,
			manager.ALL_SCORE_RANK
		},
		sharePanel = ShareThousandOnePanel,
	},

	[id.PASS_HIGHEST_LEVEL] = {
		judge = function ()
			return IsCurHighestLevel() and IsNotRepeatLevel()
		end,
		priority = table.indexOf(Priority, id.PASS_HIGHEST_LEVEL),
		keyName = GetKeyName(id.PASS_HIGHEST_LEVEL),
		keyDesc = GetKeyDesc(id.PASS_HIGHEST_LEVEL),
		achievementType = AchievementType.SHARE,
		achievementImage = false,
		autoCalScore = false,
		score = 0,
		levelType = GenLevelType(GameLevelType.kMainLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.PASS_HIGHEST_LEVEL).."_1",
		shareImage = GetImgUrl(id.PASS_HIGHEST_LEVEL),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
		},
		sharePanel = SharePyramidPanel,
	},

	[id.FRIST_RANK_FRIEND] = {
		judge = function ()
			return IsFirstFriendRank() and PassFriNumG4()
		end,
		priority = table.indexOf(Priority, id.FRIST_RANK_FRIEND),
		keyName = GetKeyName(id.FRIST_RANK_FRIEND),
		keyDesc = GetKeyDesc(id.FRIST_RANK_FRIEND),
		achievementType = AchievementType.SHARE,
		achievementImage = false,
		autoCalScore = false,
		score = 0,
		levelType = GenLevelType(GameLevelType.kMainLevel, GameLevelType.kHiddenLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.FRIST_RANK_FRIEND),
		shareImage = GetImgUrl(id.FRIST_RANK_FRIEND),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.FRIEND_RANK,
			manager.PASS_FRIEND_NUM,
		},
		sharePanel = ShareFirstInFriendsPanel,
	},

	[id.ALL_THREE_STARS] = {
		judge = function ()
			return IsFullThreeStars()
		end,
		priority = table.indexOf(Priority, id.ALL_THREE_STARS),
		keyName = GetKeyName(id.ALL_THREE_STARS),
		keyDesc = GetKeyDesc(id.ALL_THREE_STARS),
		achievementType = AchievementType.SHARE,
		achievementImage = false,
		autoCalScore = false,
		score = 0,
		levelType = GenLevelType(GameLevelType.kMainLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.ALL_THREE_STARS),
		shareTitle1 = "show_off_desc_40_1",
		shareImage = GetImgUrl(id.ALL_THREE_STARS),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
			manager.UNLOCK_HIDEN_LEVEL,
		},
		sharePanel = ShareTrophyPanel,
	},

	[id.UNLOCK_NEW_OBSTACLE] = {
		judge = function ()
			return UnlockNewObstacle() and IsNotRepeatLevel()
		end,
		priority = table.indexOf(Priority, id.UNLOCK_NEW_OBSTACLE),
		keyName = GetKeyName(id.UNLOCK_NEW_OBSTACLE),
		keyDesc = GetKeyDesc(id.UNLOCK_NEW_OBSTACLE),
		achievementType = AchievementType.PROGRESS,
		achievementImage = true,
		autoCalScore = true,
		score = 20,
		scoreAndAchiLevel = CalUnLocalNewObstacleAchiLevel,
		levelType = GenLevelType(GameLevelType.kMainLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.UNLOCK_NEW_OBSTACLE),
		shareImage = GetImgUrl(id.UNLOCK_NEW_OBSTACLE),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
		},
		sharePanel = ShareUnlockNewObstaclePanel,
	},

	[id.PASS_N_HIDEN_LEVEL] = {
		judge = function ()
			return PassAllAreaHideLevel() and IsNotRepeatLevel()
		end,
		unlockCondition = LevelGreater30,
		priority = table.indexOf(Priority, id.PASS_N_HIDEN_LEVEL),
		keyName = GetKeyName(id.PASS_N_HIDEN_LEVEL),
		keyDesc = GetKeyDesc(id.PASS_N_HIDEN_LEVEL),
		keyDesc1 = GetKeyDesc(id.PASS_N_HIDEN_LEVEL).."_2",--进度型列表显示字符串
		achievementType = AchievementType.PROGRESS,
		achievementImage = true,
		autoCalScore = true,
		score = 20,
		achiLevel = CalPassAllAreaHideLevelAchiLevel,
		levelType = GenLevelType(GameLevelType.kHiddenLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.PASS_N_HIDEN_LEVEL),
		shareImage = GetImgUrl(id.PASS_N_HIDEN_LEVEL),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
		},
		sharePanel = ShareHiddenLevelPanel,
	},

	[id.FIVE_TIMES_FOUR_STAR] = {
		judge = function ()
			return Is5TimesLevelTo4star()
		end,
		priority = table.indexOf(Priority, id.FIVE_TIMES_FOUR_STAR),
		keyName = GetKeyName(id.FIVE_TIMES_FOUR_STAR),
		keyDesc = GetKeyDesc(id.FIVE_TIMES_FOUR_STAR),
		achievementType = AchievementType.PROGRESS,
		achievementImage = true,
		autoCalScore = true,
		score = 20,
		achiLevel = Cal5TimesLevelTo4starAchiLevel,
		levelType = GenLevelType(GameLevelType.kMainLevel, GameLevelType.kHiddenLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.FIVE_TIMES_FOUR_STAR),
		shareImage = GetImgUrl(id.FIVE_TIMES_FOUR_STAR),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
		},
		sharePanel = Share5Time4StarPanel,
	},

	[id.HIDE_FULL_STAR] = {
		judge = function ()
			return IsFourStar()
		end,
		priority = table.indexOf(Priority, id.HIDE_FULL_STAR),
		keyName = GetKeyName(id.HIDE_FULL_STAR),
		keyDesc = GetKeyDesc(id.HIDE_FULL_STAR),
		achievementType = AchievementType.SHARE,
		achievementImage = false,
		autoCalScore = false,
		score = 0,
		levelType = GenLevelType(GameLevelType.kMainLevel, GameLevelType.kHiddenLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.HIDE_FULL_STAR),
		shareImage = GetImgUrl(id.HIDE_FULL_STAR),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
			manager.TOTAL_SCORE,
		},
		sharePanel = ShareFourStarPanel,
	},

	[id.N_STAR_REWARD] = {
		judge = function ()
			return IsGetStarReward()
		end,
		priority = table.indexOf(Priority, id.N_STAR_REWARD),
		keyName = GetKeyName(id.N_STAR_REWARD),
		keyDesc = GetKeyDesc(id.N_STAR_REWARD),
		achievementType = AchievementType.PROGRESS,
		achievementImage = true,
		autoCalScore = true,
		score = 20,
		levelType = GenLevelType(GameLevelType.kMainLevel, GameLevelType.kHiddenLevel),
		achiLevel = CalGetStarRewardAchiLevel,
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.N_STAR_REWARD),
		shareImage = GetImgUrl(id.N_STAR_REWARD),
		sharePanel = ShareNStarRewardPanel,
	},

	[id.WEEKLY_FIRST_FRI_RANK] = {
		judge = function ()
			--周赛的成就不在这里判断
			return false
		end,
		priority = table.indexOf(Priority, id.WEEKLY_FIRST_FRI_RANK),
		keyName = GetKeyName(id.WEEKLY_FIRST_FRI_RANK),
		keyDesc = GetKeyDesc(id.WEEKLY_FIRST_FRI_RANK),
		achievementType = AchievementType.TRIGGER,
		achievementImage = true,
		autoCalScore = false,
		score = 100,
		levelType = GenLevelType(GameLevelType.kSummerWeekly),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.WEEKLY_FIRST_FRI_RANK),
		shareImage = GetImgUrl(id.WEEKLY_FIRST_FRI_RANK),
	},

	[id.SCORE_OVER_FRIEND] = {
		judge = function ()
			return LevelGreater7() and PassFriNumG4() and IsScoreOverFriend()
		end,
		priority = table.indexOf(Priority, id.SCORE_OVER_FRIEND),
		keyName = GetKeyName(id.SCORE_OVER_FRIEND),
		keyDesc = GetKeyDesc(id.SCORE_OVER_FRIEND),
		achievementType = AchievementType.SHARE,
		achievementImage = false,
		autoCalScore = false,
		score = 0,
		levelType = GenLevelType(GameLevelType.kMainLevel, GameLevelType.kHiddenLevel),
		shareType = ShareType.NOTIFY,
		notifyMessage = "show_off_to_friend_point",
		shareTitle = GetShareTitle(id.SCORE_OVER_FRIEND),
		shareImage = GetImgUrl(id.SCORE_OVER_FRIEND),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
			manager.PASS_FRIEND_NUM,
			manager.FRIEND_RANK_LIST,
			manager.TOTAL_SCORE,
		},
		sharePanel = SharePassFriendPanel,
	},

	[id.LEVEL_OVER_FRIEND] = {
		judge = function ()
			return FriendNumG4() and LevelGreater30() and IsLevelOverFriend()
		end,
		priority = table.indexOf(Priority, id.LEVEL_OVER_FRIEND),
		keyName = GetKeyName(id.LEVEL_OVER_FRIEND),
		keyDesc = GetKeyDesc(id.LEVEL_OVER_FRIEND),
		achievementType = AchievementType.SHARE,
		achievementImage = false,
		autoCalScore = false,
		score = 0,
		levelType = GenLevelType(GameLevelType.kMainLevel),
		shareType = ShareType.NOTIFY,
		notifyMessage = "show_off_to_friend_rank",
		shareTitle = GetShareTitle(id.LEVEL_OVER_FRIEND),
		shareImage = GetImgUrl(id.LEVEL_OVER_FRIEND),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
		},
		sharePanel = SharePassFriendPanel,
	},

	[id.WEEKLY_GEM_OVER_FRIEND] = {
		judge = function ()
			--周赛相关不在这判断
			return false
		end,
		priority = table.indexOf(Priority, id.WEEKLY_GEM_OVER_FRIEND),
		keyName = GetKeyName(id.WEEKLY_GEM_OVER_FRIEND),
		keyDesc = GetKeyDesc(id.WEEKLY_GEM_OVER_FRIEND),
		achievementType = AchievementType.SHARE,
		achievementImage = false,
		autoCalScore = false,
		score = 0,
		levelType = GenLevelType(GameLevelType.kSummerWeekly),
		shareType = ShareType.NOTIFY,
		shareTitle = GetShareTitle(id.WEEKLY_GEM_OVER_FRIEND),
		shareImage = GetImgUrl(id.WEEKLY_GEM_OVER_FRIEND),
	},

	[id.MARK_FINAL_CHEST] = {
		judge = function ()
			return IsMarkFinalChest()
		end,
		priority = table.indexOf(Priority, id.MARK_FINAL_CHEST),
		keyName = GetKeyName(id.MARK_FINAL_CHEST),
		keyDesc = GetKeyDesc(id.MARK_FINAL_CHEST),
		achievementType = AchievementType.TRIGGER,
		achievementImage = true,
		autoCalScore = false,
		score = 100,
		levelType = nil, --不是过关炫耀
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.MARK_FINAL_CHEST),
		shareImage = GetImgUrl(id.MARK_FINAL_CHEST),
		outLevelJudge = true,
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.GET_MARK_FINAL_CHEST,
		},
		sharePanel = ShareChestPanel,
	},

	[id.CONTINUE_PASS_5_LEVEL] = {
		judge = function ()
			return LevelGreater7() and IsNotRepeatLevel() and IsPassFiveLevel()
		end,
		unlockCondition = LevelGreater7,
		priority = table.indexOf(Priority, id.CONTINUE_PASS_5_LEVEL),
		keyName = GetKeyName(id.CONTINUE_PASS_5_LEVEL),
		keyDesc = GetKeyDesc(id.CONTINUE_PASS_5_LEVEL),
		achievementType = AchievementType.TRIGGER,
		achievementImage = true,
		autoCalScore = false,
		score = 50,
		levelType = GenLevelType(GameLevelType.kMainLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.CONTINUE_PASS_5_LEVEL),
		shareImage = GetImgUrl(id.CONTINUE_PASS_5_LEVEL),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
		},
		sharePanel = SharePassFiveLevelPanel,
	},

	[id.N_TIME_PASS] = {
		judge = function ()
			return FailNumG5()
		end,
		priority = table.indexOf(Priority, id.N_TIME_PASS),
		keyName = GetKeyName(id.N_TIME_PASS),
		keyDesc = GetKeyDesc(id.N_TIME_PASS),
		achievementType = AchievementType.TRIGGER,
		achievementImage = true,
		autoCalScore = false,
		score = 50,
		levelType = GenLevelType(GameLevelType.kMainLevel, GameLevelType.kHiddenLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.N_TIME_PASS),
		shareImage = GetImgUrl(id.N_TIME_PASS),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
		},
		sharePanel = ShareFinalPassLevelPanel,
	},

	[id.LAST_STEP_PASS] = {
		judge = function ()
			return IsNotRepeatLevel() and IsLastStepPass()
		end,
		priority = table.indexOf(Priority, id.LAST_STEP_PASS),
		keyName = GetKeyName(id.LAST_STEP_PASS),
		keyDesc = GetKeyDesc(id.LAST_STEP_PASS),
		achievementType = AchievementType.TRIGGER,
		achievementImage = true,
		autoCalScore = false,
		score = 50,
		levelType = GenLevelType(GameLevelType.kMainLevel, GameLevelType.kHiddenLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.LAST_STEP_PASS),
		shareImage = GetImgUrl(id.LAST_STEP_PASS),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
			manager.LEFT_STEP,
		},
		sharePanel = ShareLastStepPanel,
	},

	[id.PASS_STEP_LESS_10] = {
		judge = function ()
			return LevelGreater7() and PassStepLE10()
		end,
		unlockCondition = LevelGreater7,
		priority = table.indexOf(Priority, id.PASS_STEP_LESS_10),
		keyName = GetKeyName(id.PASS_STEP_LESS_10),
		keyDesc = GetKeyDesc(id.PASS_STEP_LESS_10),
		achievementType = AchievementType.TRIGGER,
		achievementImage = true,
		autoCalScore = false,
		score = 50,
		levelType = GenLevelType(GameLevelType.kMainLevel, GameLevelType.kHiddenLevel),
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.PASS_STEP_LESS_10),
		shareImage = GetImgUrl(id.PASS_STEP_LESS_10),
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.LEVEL,
			manager.PASS_STEP,
		},
		sharePanel = ShareLeftTenStepPanel,
	},

	[id.COLLECT_ALL_61_EGGS] = {
		judge = function ()
			return IsColletAll61Eggs()
		end,
		priority = table.indexOf(Priority, id.COLLECT_ALL_61_EGGS),
		keyName = GetKeyName(id.COLLECT_ALL_61_EGGS),
		keyDesc = GetKeyDesc(id.COLLECT_ALL_61_EGGS),
		achievementType = AchievementType.TRIGGER,
		achievementImage = true,
		autoCalScore = false,
		score = 100,
		levelType = nil, --不是过关炫耀
		shareType = ShareType.IMAGE,
		shareTitle = GetShareTitle(id.COLLECT_ALL_61_EGGS),
		shareImage = GetImgUrl(id.COLLECT_ALL_61_EGGS),
		outLevelJudge = true,
		dataKeyTable = { --使用到的网络数据，或必须在另外地方取到的本地数据
			manager.COLLECT_ALL_61_EGGS,
		},
		sharePanel = ShareEggsPanel,
	},

}

return config