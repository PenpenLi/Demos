require "zoo.panel.QRCodePanel"

AchievementManager = {}

local index = 0
local function nextIndex()
	index = index + 1
	return index
end

-- local print = oldPrint

function AchievementManager:waitForData( dataKey, id)
	local scheduler = CCDirector:sharedDirector():getScheduler()

	local function onTimeOut()
    	if self.scheduleTable[dataKey] ~= nil then 
    		scheduler:unscheduleScriptEntry(self.scheduleTable[dataKey])
    		self.scheduleTable[dataKey] = nil
    	end
    	self.scheduleTable[dataKey] = false
    	self.states[id] = {self.achievementState.TIME_OUT, false}
    	self:judgeWithId(id, true)
	end

	if self.scheduleTable[dataKey] == nil then
		self.scheduleTable[dataKey] = scheduler:scheduleScriptFunc(onTimeOut,self.HOLDING_TIME_OUT,false)
	end

	return false, self.achievementState.WAIT_DATA
end

function AchievementManager:registerNode( id, judgeFunc, dataKeyTable )
	local nodes = self.judgeNodes
	local node = {data = dataKeyTable, id = id}

	node.op = function ()
		--检测数据是否准备好
		for _,dataKey in ipairs(dataKeyTable) do
			if self:getData(dataKey) == nil then
				return self:waitForData(dataKey, id)
			end
		end
		--具体判断逻辑
		return judgeFunc(), self.achievementState.FINISHED
	end
	nodes[id] = node
	
	for _,dataKey in ipairs(dataKeyTable) do
		local dataToNode = self.dataToNode[dataKey]
		if dataToNode ~= nil and dataToNode.id ~= nil then
			local t = {}
			table.insert(t, self.dataToNode[dataKey])
			table.insert(t, node)
			self.dataToNode[dataKey] = t
		elseif dataToNode ~= nil and dataToNode.id == nil then
			table.insert(self.dataToNode[dataKey], node)
		else
			self.dataToNode[dataKey] = node
		end
	end
end

function AchievementManager:init()
	self.data = {}
	self.judgeNodes = {}
	self.dataToNode = {}
	self.scheduleTable = {}

	self.HOLDING_TIME_OUT = 0.5

	--data index
	self.LEVEL 						= 1 --过关级数
	self.TOTAL_SCORE 				= 2 --过关总分数
	self.LEVEL_TYPE 				= 3 --关卡类型
	self.OVER_SELF_RANK				= 5 --是否超越自身排名
	self.PASS_FRIEND_NUM			= 6 --过关的好友数
	self.FRIEND_RANK				= 7 --在好友中排名
	self.FRIEND_RANK_LIST			= 8 --好友排行榜数据
	self.LEVEL_OVER_FRIEND_TABLE 	= 9 --进度超越好友数的好友数据
	self.GET_MARK_FINAL_CHEST		= 10 --是否领到最后一个宝箱
	self.LEFT_STEP					= 11 --过关后剩余步数
	self.PASS_STEP 					= 12 --通关使用的步数
	self.SCORE_OVER_FRIEND_TABLE 	= 13 --分数超越好友的好友数据
	self.ALL_SCORE_RANK				= 14 --全国分数排名
	self.UNLOCK_HIDEN_LEVEL			= 15 --是否解锁隐藏关
	self.PRE_SCORE					= 16 --以前的关卡分数信息
	self.PASS_LEVEL_STAR			= 17 --通过本关的星星数
	self.FIVE_TIMES_4_STAR_COUNT	= 18 --多少个5的倍数4星
	self.COLLECT_ALL_61_EGGS 		= 19

	self.shareId = {
		SCORE_PASS_THOUSAND 	= 10, --过关时，分数进入该关卡全国前1000（含）名；首次过关后，重新闯关，超越之前的排名时，会再次触发改成就。
		PASS_HIGHEST_LEVEL		= 20, --通过当前版本最高关卡
		FRIST_RANK_FRIEND		= 30, --过关时，分数在好友中排名第一
		ALL_THREE_STARS			= 40, --过关时，当前区域满三星（解锁新隐藏区域
		UNLOCK_NEW_OBSTACLE		= 50, --解锁新障碍（通过有该障碍的首关触发）
		PASS_N_HIDEN_LEVEL		= 60, --通过n个区域的全部隐藏关
		FIVE_TIMES_FOUR_STAR	= 70, --有5*n关卡达到4星
		HIDE_FULL_STAR			= 80, --过关时，获得四星
		N_STAR_REWARD			= 90, --获得n星星（n=星星奖励可领取数值）
		WEEKLY_FIRST_FRI_RANK	= 100,--过关时，周赛好友排行榜夺冠
		SCORE_OVER_FRIEND		= 110,--过关时，本关分数超越好友
		LEVEL_OVER_FRIEND		= 120,--过关时，本关进度超越好友
		WEEKLY_GEM_OVER_FRIEND	= 130,--过关时，周赛累计宝石数超越好友
		MARK_FINAL_CHEST		= 140,--签到领取最后一个宝箱 
		CONTINUE_PASS_5_LEVEL	= 150,--一天之内通过连续的5个关卡（当日玩家最高关卡+4，中间可以失败）
		N_TIME_PASS				= 160,--连续失败n次后过关
		LAST_STEP_PASS			= 170,--最后一步过关（包含玩家使用加5步）
		PASS_STEP_LESS_10		= 180,--成功过关所用步数≤10
		COLLECT_ALL_61_EGGS 	= 190,--收集61儿童节所有的彩蛋
	}

	local id = self.shareId
	self.priority = {
		id.SCORE_PASS_THOUSAND,
		id.PASS_HIGHEST_LEVEL,
		id.FRIST_RANK_FRIEND,
		id.ALL_THREE_STARS,
		id.UNLOCK_NEW_OBSTACLE,
		id.PASS_N_HIDEN_LEVEL,
		id.FIVE_TIMES_FOUR_STAR,
		id.HIDE_FULL_STAR,
		id.N_STAR_REWARD,
		id.WEEKLY_FIRST_FRI_RANK,
		id.SCORE_OVER_FRIEND,
		id.LEVEL_OVER_FRIEND,
		id.WEEKLY_GEM_OVER_FRIEND,
		id.MARK_FINAL_CHEST, 
		id.CONTINUE_PASS_5_LEVEL,
		id.N_TIME_PASS,
		id.LAST_STEP_PASS,
		id.PASS_STEP_LESS_10,
		id.COLLECT_ALL_61_EGGS,
	}

	self.shareType = {
		LINK = 1,
		IMAGE = 2,
		NOTIFY = 3,
	}

	self.achievementType = {
		TRIGGER = 0, --触发型
		PROGRESS = 1,--进度型
		SHARE = 2, --炫耀型
	}
	--不在这里做判断的成就
	self.ignoreTable = {
		id.WEEKLY_FIRST_FRI_RANK,
		id.WEEKLY_GEM_OVER_FRIEND
	}

	self.achievementState = {
		WAIT_DATA = 1,	--等待数据
		TIME_OUT = 2,	--超时
		FINISHED = 3,	--完成判断
		INVALID = 4,	--无效
	}

	self.notifyEvent = {
		ACHIEVEMENT = 1, --成就事件
		SHARE 		= 2, --炫耀事件
	}

	self.medalType = {
		None = 1,
		Gold = 2,
		Silver = 3,
		Copper = 4
	}

	self.notifyFunc = {}

	self.achievementTable = {} --达成成就的数据{id = {level, score}...}

	self.states = {}

	self.configs = require "zoo.PersonalCenter.AchievementConfig"

	for id,config in pairs(self.configs) do
		config.id = id
		local dataKeyTable = config.dataKeyTable or {}
		self:registerNode( id, config.judge, dataKeyTable )
	end
end

function AchievementManager:judge( id )
	local nodes = self.judgeNodes
	if nodes and nodes[id] then
		return nodes[id].op()
	elseif id then
		print("[error] Achievement not support ".. id)
	end

	return  false, self.achievementState.INVALID
end

function AchievementManager:cleanData()
	self.data = {}
	self.states = {}
	for key,scheduleID in pairs(self.scheduleTable) do
		if scheduleID ~= nil then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scheduleID)
			self.scheduleTable[key] = nil
		end
	end

	self.preTotalStar = UserManager:getInstance().user:getTotalStar()
end

function AchievementManager:calculationLevelAndScore( id )
	local achievement = self.achievementTable[id]
	local config = self:getConfig(id)

	if config.achievementType == self.achievementType.PROGRESS then
		if achievement == nil then achievement = {} end
		local achiLevel = 0
		local score = 0

		if config.scoreAndAchiLevel then
			achiLevel, score = config.scoreAndAchiLevel()
		else
			achiLevel = config.achiLevel()
			score = achiLevel * config.score
		end

		achievement.achiLevel = achiLevel
		achievement.score = score
	elseif config.achievementType == self.achievementType.TRIGGER then
		--type=0的成就，可多次触发，首次触发时记一次成就积分，功能上线时不自动计算积分。
		if achievement ~= nil then return nil end
		achievement = {achiLevel = 1, score = config.score}
	elseif config.achievementType == self.achievementType.SHARE then
		--type=2只炫耀，无图鉴
		return nil
	end

	achievement.id = id
	achievement.achievementType = config.achievementType

	return achievement
end

function AchievementManager:finishedJudge()
	local achievementTable = {}
	local anyAchi = false
	local shareIdTab = {}
	for priority,id in ipairs(self.priority) do
		local state = self.states[id]
		if state and
			state[1] == self.achievementState.FINISHED and
			state[2] == true
		then
			table.insert(shareIdTab, id)

			local achi = self:calculationLevelAndScore(id)

			if achi then
				achievementTable[id] = achi
				anyAchi = true
			end
		end

		if state then
			print("[achievement] id: "..id.."  state:"..state[1].." result :"..(state[2] and "true" or "false"))
		else
			print("[achievement] id:"..id.." state not judge...")
		end
	end

	if #shareIdTab > 0 then
		self:notify(self.notifyEvent.SHARE, shareIdTab)
	end

	if anyAchi then
		self:notify(self.notifyEvent.ACHIEVEMENT, achievementTable)
	end

	for id,achi in pairs(achievementTable) do
		self.achievementTable[id] = self:updateAchiData(achi)

		local level = self.achievementTable[id].level
		local score = self:getTotalScore()
		local medalLevel = self:getFriendAchiLevel(score)
		local achiType = self.achievementTable[id].achievementType
		if self.achievementType.PROGRESS == achiType then
			DcUtil:UserTrack(
				{
					category='achievement', 
					sub_category="my_achievement",
					achievement_id=id,
					achievement_level=level+1,
					achievement_score=score,
					achievement_title=medalLevel
				}, true)
		else
			DcUtil:UserTrack(
				{
					category='achievement', 
					sub_category="my_achievement",
					achievement_id=id,
					achievement_score=score,
					achievement_title=medalLevel
				}, true)
		end
	end

	self:cleanData()

	self.isJudging = false

	print("[achievement] finishedJudge >>>>>")
end

function AchievementManager:matchLevel(levelType)
	if levelType == nil then return true end
	local curLevelType = self:getData(self.LEVEL_TYPE)
	if curLevelType == nil then return false end
	local c = bit.lshift(1, curLevelType - 1)
	local ret = bit.band(levelType, c)
	return ret ~= 0
end

function AchievementManager:judgeWithId( id, notJudgeAll )
	local config = self.configs[id]
	if self.isJudging == false and not config.outLevelJudge then return end
	local state = self.states[id]
	if state == nil or (state and state[1] ~= self.achievementState.TIME_OUT) then
		if self:matchLevel(config.levelType) then
			local result, achievementState = self:judge(id)
			self.states[id] = {achievementState, result}
			print("[achievement]judgeWithId  >>>> "..id..
				"state >>> "..achievementState..
				"result >>> "..(result and "true" or "false"))
		else
			print("[achievement] not support >>> "..id)
		end
	end

	--是否完成所有的成就判断
	if notJudgeAll then
		local isFinished = true
		for id,state in pairs(self.states) do
			if state[1] == self.achievementState.WAIT_DATA then
				isFinished = false
				break
			end
		end

		if isFinished then
			self:finishedJudge()
		end
	end
end

function AchievementManager:startJudge()
	self.isJudging = true
	for priority,id in ipairs(self.priority) do
		self:judgeWithId(id, false)
	end
end

function AchievementManager:requireData()
	local rankRequest = false

	local totalScore = self:getData(self.TOTAL_SCORE)
	if self.preScore then 
		if self.preScore < totalScore then
			rankRequest = true
		end
	else
		self.preScore = 0
		rankRequest = true
	end

	if rankRequest then
		local function onCompleteSuccess( evt )
			local rankPosition = 1
			local share = false
			if evt.data and evt.data.rankPosition then
				rankPosition = evt.data.rankPosition
			end

			if evt.data and evt.data.share then
				share = evt.data.share
			end

			self:onDataUpdate(self.OVER_SELF_RANK, share)
			self:onDataUpdate(self.ALL_SCORE_RANK, rankPosition)
		end

		local shareDataHttp = GetShareRankWithPosition.new()
		shareDataHttp:addEventListener(Events.kComplete, onCompleteSuccess)
		shareDataHttp:load(self.preLevel, self.preScore)
	else
		self:setData(self.OVER_SELF_RANK, false)
		self:setData(self.ALL_SCORE_RANK, 0)
	end
end

--关卡结束后需要使用的参数
function AchievementManager:initData(shareManager, level, totalScore, levelType, star )
	self:setData(self.LEVEL, level)
	self:setData(self.TOTAL_SCORE, totalScore)
	self:setData(self.LEVEL_TYPE, levelType)
	self:setData(self.PASS_LEVEL_STAR, star)

	self.shareManager = shareManager

	self:requireData()

	self:startJudge()
end

function AchievementManager:setData( key, value )
	self.data[key] = value
end

function AchievementManager:getData( key )
	return self.data[key]
end

function AchievementManager:getAchievementsWithType(achiType)
	if achiType == self.achievementType.PROGRESS then
		self:calculationProgressAchi()
	end

	local achis = {}
	for id,achi in pairs(self.achievementTable) do
		local config = self:getConfig(id)
		if config.achievementType == achiType then
			achis[id] = achi
		end
	end

	return achis
end

function AchievementManager:getAchievementWithId(id)
	--self:calculationProgressAchi()
	if id == self.shareId.UNLOCK_NEW_OBSTACLE then
		self:calUnlockNewObstacle()
	elseif id == self.shareId.PASS_N_HIDEN_LEVEL then
		self:calPassNhidenLevel()
	elseif id == self.shareId.FIVE_TIMES_FOUR_STAR then
		self:cal5TimesLevelTo4star()
	elseif id == self.shareId.N_STAR_REWARD then
		self:calNstarReward()
	end

	return self.achievementTable[id]
end

function AchievementManager:getTotalScore(friend)
	if friend then
		return self:calFriendTotalScore(friend)
	else
		local score = 0
		for id,achi in pairs(self:getAchievements()) do
			score = score + achi.score
		end
		return score
	end
end

function AchievementManager:mergeNetworkAchi()
	local pcManager = PersonalCenterManager
	local achis = pcManager:getData(pcManager.ACHIEVEMENTS) or {}
	for _,achi in ipairs(achis) do
		local config = self:getConfig(achi.id)
		if config then
			achi.achiLevel = achi.level
			achi.score = config.score * achi.achiLevel
			self.achievementTable[achi.id] = achi
		end
	end
end

function AchievementManager:getAchievements()
	self:mergeNetworkAchi()
	self:calculationProgressAchi()
	return self.achievementTable
end

function AchievementManager:getConfigs()
	return self.configs
end

function AchievementManager:getConfig( id )
	local config = self.configs[id]
	if config == nil and type(id) == "number" then
		config = {
		id = "q",
		isNotSupport = true,--this version not support 
		priority = #self.priority + 1,
		keyName = "achievement_name_unknown",
		keyDesc = "achievement_desc_unknown",
		shareTitle = 'achievement_desc_unknown',
		achievementType = self.achievementType.TRIGGER,
		achievementImage = true,
		autoCalScore = false,
		score = 0,
	}
	end
	return config
end

function AchievementManager:getConfigWithType( achiType )
	local configs = {}
	for id,config in pairs(self.configs) do
		if config.achievementType == achiType then
			table.insert(configs, config)
		end
	end

	local function less( p, n )
		return p.id < n.id
	end

	table.sort( configs, less )

	return configs
end

function AchievementManager:getPriority( id )
	return self.priority[id]
end

function AchievementManager:onDataUpdate( key, value )
	if key == nil or value == nil then return end

	print("[achievement] onDataUpdate key >>> ", key, " value >>> ", tostring(value))

	self:setData(key, value)

	if self.scheduleTable[key] == false then
		--超时不再判断
		return
	elseif self.scheduleTable[key] ~= nil then 
    	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.scheduleTable[key])
    	self.scheduleTable[key] = nil
    end
	
	local nodes = self.dataToNode[key]

	if nodes and nodes.id == nil then
		for _,node in ipairs(nodes) do
			self:judgeWithId(node.id, true)
		end
	elseif nodes then
		self:judgeWithId(nodes.id, true)
	end
end
--不在这里判断的成就
function AchievementManager:onShareSuccess(id, data)
	local achi = self:calculationLevelAndScore(id)
	if achi then
		if achi.achievementType == self.achievementType.TRIGGER then
			self:notify(self.notifyEvent.ACHIEVEMENT, {id = achi})
		end

		self.achievementTable[id] = achi
	end
end

function AchievementManager:registerAchievementNotify( event, target, func )
	if event == nil or func == nil then return end

	if self.notifyFunc[event] == nil then
		self.notifyFunc[event] = {}
	end

	local eventFunc = {
		target = target or 1,
		func = func,
	}

	table.insert(self.notifyFunc[event], eventFunc)
end

function AchievementManager:unregisterAchievementNotify( event, target)
	if target == nil then
		self.notifyFunc[event] = nil
		return
	end

	if self.notifyFunc[event] ~= nil then
		for index,v in ipairs(self.notifyFunc[event]) do
			if v.target == target then
				self.notifyFunc[event][index] = nil
				break
			end
		end
	end
end

function AchievementManager:notify( event, ... )
	if self.notifyFunc[event] ~= nil then
		for _,eventFunc in ipairs(self.notifyFunc[event]) do
			if eventFunc.target == 1 then
				eventFunc.func(...)
			else
				eventFunc.func(eventFunc.target,...)
			end
		end
	end
end

function AchievementManager:updateAchiData( achievement )
	local pcManager = PersonalCenterManager
	local achis = pcManager:getData(pcManager.ACHIEVEMENTS)
	for _,achi in ipairs(achis) do
		if achi.id == achievement.id then
			for k,v in pairs(achievement) do
				achi[k] = v
			end
			return achi
		end
	end

	achievement.level = achievement.achiLevel
	table.insert(achis, achievement)
	return achievement
end

--UNLOCK_NEW_OBSTACLE
function AchievementManager:calUnlockNewObstacle()
	local firstNewObstacleLevels = MetaManager:getInstance().global.firstNewObstacleLevels
	local topLevel = UserManager:getInstance().user:getTopLevelId()
	local highestLevel = MetaManager.getInstance():getMaxNormalLevelByLevelArea()

	topLevel = topLevel < highestLevel and topLevel or highestLevel
	local score = UserManager:getInstance():getUserScore( topLevel )
	if score == nil and not JumpLevelManager:getInstance():hasJumpedLevel( topLevel ) then
		topLevel = topLevel - 1
	end

	table.sort(firstNewObstacleLevels)

	local maxLevel = 0
	local achiLevel = 0
	local score = 0
	for _,o_level in ipairs(firstNewObstacleLevels) do
		if o_level <= topLevel then
			maxLevel = o_level
			achiLevel = achiLevel + 1
			if o_level < 400 then
				score = score + 20
			else
				score = score + 50
			end
		end
	end

	local isMaxLevel = false
	local nextLevel = firstNewObstacleLevels[achiLevel + 1]
	if not nextLevel or topLevel == highestLevel then
		isMaxLevel = true
	end
	if nextLevel and nextLevel > highestLevel then
		isMaxLevel = true
	end

	local achi = {
		id = self.shareId.UNLOCK_NEW_OBSTACLE,
		achievementType = self.achievementType.PROGRESS,
		score = score,
		num = nextLevel or -1, --解锁障碍的最高关卡的下一障碍关
		totalNum = #firstNewObstacleLevels, --总障碍关卡数
		curNum = 0,
		achiLevel = achiLevel, --成就等级
		isMaxLevel = isMaxLevel 
	}

	self.achievementTable[self.shareId.UNLOCK_NEW_OBSTACLE] = self:updateAchiData(achi)
end
--PASS_N_HIDEN_LEVEL
function AchievementManager:calPassNhidenLevel()
	local hide_areas = MetaManager.getInstance().hide_area
	local topLevel = UserManager:getInstance().user:getTopLevelId()
	local topLevelScore = UserManager.getInstance():getUserScore(topLevel)
	if topLevelScore == nil then
		topLevel = topLevel - 1
	end

	local highestLevel =  MetaManager.getInstance():getMaxNormalLevelByLevelArea()

	topLevel = topLevel < highestLevel and topLevel or highestLevel

	if topLevel < 31 then topLevel = 31 end

	local HIDE_LEVEL_ID_START = 10000

	local achiLevel = 0

	local totalPassCount = 0
	local maxCount = 0

	for k,hideArea in pairs(hide_areas) do
		local continueLevels = hideArea.continueLevels
		if continueLevels[#continueLevels] <= topLevel then
			local hideLevels = hideArea.hideLevelRange
			local isPassAll = true
			for i,v in ipairs(hideLevels) do
				local _level = HIDE_LEVEL_ID_START + v
				local score = UserManager.getInstance():getUserScore(_level)
				if score == nil or score.star < 1 then 
					isPassAll = false
				end
			end

			if isPassAll == true then
				achiLevel = achiLevel + 1
				totalPassCount = totalPassCount + 1
			end

			maxCount = maxCount + 1
		elseif continueLevels[#continueLevels] <= highestLevel then
			maxCount = maxCount + 1
		end
	end

	local isMaxLevel = maxCount == achiLevel

	local achi = {
		id = self.shareId.PASS_N_HIDEN_LEVEL,
		achievementType = self.achievementType.PROGRESS,
		score = achiLevel * 20,
		num = totalPassCount, --玩家当前已通关的隐藏关区域
		totalNum = isMaxLevel and achiLevel or (achiLevel + 1), --下一级成就所需的区域数
		curNum = 1,
		achiLevel = achiLevel, --成就等级
		isMaxLevel = isMaxLevel
	}

	self.achievementTable[self.shareId.PASS_N_HIDEN_LEVEL] = self:updateAchiData(achi)
end
--FIVE_TIMES_FOUR_STAR
function AchievementManager:cal5TimesLevelTo4star()
	local topLevel = UserManager:getInstance().user:getTopLevelId()
	local topLevelScore = UserManager.getInstance():getUserScore(topLevel)
	if topLevelScore == nil then
		topLevel = topLevel - 1
	end

	local highestLevel = MetaManager.getInstance():getMaxNormalLevelByLevelArea()

	topLevel = topLevel < highestLevel and topLevel or highestLevel

	local scores = UserManager.getInstance():getScoreRef()
	local levelCount = 0

	for i,score in ipairs(scores) do
		if score.star == 4 and score.levelId <= topLevel then
			levelCount = levelCount + 1
		end
	end

	local achiLevel = math.floor(levelCount / 5)

	local list = FourStarManager:getInstance():getAllFourStarLevels()
	local maxCount = 0
	for _,data in ipairs(list) do
		if data.level <= highestLevel then
			maxCount = maxCount + 1
		end
	end

	local isMaxLevel = false
	local nextCount = (achiLevel + 1) * 5
	if nextCount > maxCount then
		nextCount = math.floor(maxCount / 5) * 5
		levelCount = nextCount
		isMaxLevel = true
	end

	local achi = {
		id = self.shareId.FIVE_TIMES_FOUR_STAR,
		achievementType = self.achievementType.PROGRESS,
		score = achiLevel * 20,
		num = levelCount, --玩家已达4星的关卡数
		totalNum = nextCount, --获得下一级成就所需获取四星的关卡数
		curNum = (achiLevel == 0 and 1 or achiLevel) * 5,
		achiLevel = achiLevel, --成就等级
		isMaxLevel = isMaxLevel
	}

	self.achievementTable[self.shareId.FIVE_TIMES_FOUR_STAR] = self:updateAchiData(achi)
end
--N_STAR_REWARD
function AchievementManager:calNstarReward()
	local curTotalStar 	= UserManager:getInstance().user:getTotalStar()
	local starReward = MetaManager.getInstance().star_reward
	local achiLevel = 0

	local nextNum = 0
	local maxStar
	local curNum = 0
	for _,reward in ipairs(starReward) do
		maxStar = reward.starNum
		if curTotalStar >= reward.starNum then
			achiLevel = achiLevel + 1
			curNum = reward.starNum
		end
	end

	local reward = starReward[achiLevel + 1]
	local totalNum = 1
	local isMaxLevel = false
	if reward then
		totalNum = reward.starNum
	else
		curTotalStar = maxStar
		totalNum = maxStar
		isMaxLevel = true
	end

	local achi = {
		id = self.shareId.N_STAR_REWARD,
		achievementType = self.achievementType.PROGRESS,
		score = achiLevel * 20,
		num = curTotalStar, --领取下一档星星奖励所需达到的星星数值
		totalNum = totalNum or curTotalStar, --总星星数
		curNum = curNum,
		achiLevel = achiLevel, --成就等级
		isMaxLevel = isMaxLevel,
	}
	self.achievementTable[self.shareId.N_STAR_REWARD] = self:updateAchiData(achi)
end

function AchievementManager:calculationProgressAchi()
	self:calUnlockNewObstacle()
	self:calPassNhidenLevel()
	self:cal5TimesLevelTo4star()
	self:calNstarReward()
end


--计算朋友 “解锁新关卡”成就 取得的分数
function AchievementManager:calculateFriendUnlockNewObstacleScore(friend)
	local firstNewObstacleLevels = MetaManager:getInstance().global.firstNewObstacleLevels
	local level = friend:getTopLevelId()
	table.sort(firstNewObstacleLevels)
	local maxLevel = 0
	local achiLevel = 0
	local score = 0
	for _,o_level in ipairs(firstNewObstacleLevels) do
		if o_level < level then
			maxLevel = o_level
			achiLevel = achiLevel + 1
			if o_level < 400 then
				score = score + 20
			else
				score = score + 50
			end
		end
	end
	return score
end

--计算成就的总分，参数格式{{id=10, levvel=10}, {id=20, level=2}, ...}
function AchievementManager:calFriendTotalScore(friend)
	local achievements = friend.achievement and friend.achievement.achievements or {}
	achievements = achievements or {}
	local score = 0
	for k, v in pairs(achievements) do
		local id = v.id
		local level = v.level
		local config = self:getConfig(id)
		if id == self.shareId.UNLOCK_NEW_OBSTACLE then
			score = score + self:calculateFriendUnlockNewObstacleScore(friend)
		elseif config then
			score = score + level * config.score
		end
	end
	return score
end

--成就总分 转换成 总成就等级
function AchievementManager:getFriendAchiLevel(score)
	local config = PersonalCenterManager.medalConfig
	for k, v in pairs(config) do
		if score < v.score then
			return v.id - 1
		end
	end
	return #config
end

function AchievementManager:getMedalType(level)
	if level <= 0 then
		return self.medalType.None
	elseif level <= 5 then
		return self.medalType.Copper
	elseif level <= 10 then
		return self.medalType.Silver
	else
		return self.medalType.Gold
	end
end

AchievementManager:init()