--
-- ShareManager ---------------------------------------------------------
--

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

ShareManager = {}

function ShareManager:init( ... )
	--setmetatable(ShareManager, self)
	--share type
	self.PASS_STEP = 1
	self.HIGHEST_LEVEL = 2
	self.LAST_STEP_PASS = 3
	self.N_TIME_PASS = 4
	self.OVER_SELF_RANK = 5
	self.ROCKET = 6
	self.SCORE_OVER_FRIEND = 7
	self.LEVEL_OVER_FRIEND = 8
	self.HIDE_FULL_STAR = 9
	self.FULL_STARS = 10
	self.UNLOCK_HIDEN_LEVEL = 11
	self.EIGHTY_PERCENT_PERSON = 12
	self.FRIST_RANK_FRIEND = 15

	--share data
	self.judgeState = "continuous"
	self.CurSharePanel = nil
	self.HOLDING_TIME_OUT = 0.5 --sec
	self.MAX_SHARE_TIME = 3
	self.data = {}

	self.preLevel = nil
	self.preScore = nil

	--ConditionType
	self.ConditionType = {
		LEFT_STEP = 1, -- 剩餘步數
		PASS_STEP = 2, --过关使用步数
		LOSE_NUM = 3, 	--失败次数
		CONTINUOUS_PASS_LEVEL = 4, --连续通過管卡
		CONTINUOUS_LOSE_NUM = 5, --连续失败次数
		STAR_NUM = 6, --所获得星星数
		HIDEN_STAR_NUM = 7, --隐藏关所获得星星数
		PASS_NUM = 8, --通关人数
		PASS_SCORE = 9, -- 过关分数
		OVER_SELF_RANK = 10, --是否全国排名变化
		FRIEND_NUM = 11, -- 好友数量
		PASS_FRIEND_NUM = 12, --通过本关的好友数量
		LEVEL = 13, --通过管卡数
		ALL_SCORE_RANK = 14,--分数排名
		UNLOCK_HIDEN_LEVEL = 15,--解锁隐藏关
		FRIEND_HIGHEST_LEVEL = 16, -- 好友最高关卡
		FRIEND_RANK_LIST = 17, --好友排名table
		FRIEND_RANK = 18,  --好友中自己排名
		CAN_LINK = 19, --是否可以连接炫耀
		SHARE_ALL_TIME = 20, --一天的所有炫耀次数
		OVER_FRIEND_TABLE = 21, --分数超越好友的所有好友
		LEVEL_OVER_FRIEND_TABLE = 22, --关卡超过好友的所有好友
	}


end

ShareManager:init()

kShareConfig = {} 
kShareConfig[tostring(ShareManager.PASS_STEP)] = {id=1, gamecenter="happyelements_5steps"}--
kShareConfig[tostring(ShareManager.HIGHEST_LEVEL)] = {id=2, gamecenter="happyelements_before1000_high"}
kShareConfig[tostring(ShareManager.LAST_STEP_PASS)] = {id=3, gamecenter="happyelements_last_step_pass"}--
kShareConfig[tostring(ShareManager.N_TIME_PASS)] = {id=4, gamecenter="happyelements_finally_pass"}--
kShareConfig[tostring(ShareManager.OVER_SELF_RANK)] = {id=5, gamecenter="happyelements_before1000_friends"}
kShareConfig[tostring(ShareManager.ROCKET)] = {id=6, gamecenter="happyelements_rocket"}--
kShareConfig[tostring(ShareManager.SCORE_OVER_FRIEND)] = {id=7, gamecenter="happyelements_beyond_friends"}
kShareConfig[tostring(ShareManager.LEVEL_OVER_FRIEND)] = {id=8, gamecenter="happyelements_beyond_friends_checkpoint"}
kShareConfig[tostring(ShareManager.HIDE_FULL_STAR)] = {id=9, gamecenter="happyelements_fourstar"}
kShareConfig[tostring(ShareManager.FULL_STARS)] = {id=10, gamecenter="happyelements_all_star"}--
kShareConfig[tostring(ShareManager.UNLOCK_HIDEN_LEVEL)] = {id=11, gamecenter="happyelements_hidden_checkpoint"}
--kShareConfig[tostring(ShareManager.EIGHTY_PERCENT_PERSON)] = {id=12, gamecenter="happyelements_rocket"}
kShareConfig[tostring(ShareManager.FRIST_RANK_FRIEND)] = {id=15, gamecenter="happyelements_no.1_friends"}

local ConditionOP = {
	EQUAL = 1,							-- ==
	LESS = 2, 							-- min <
	LESS_OR_EQUAL = 3, 					-- min <=
	GREATER = 4, 						-- > max
	GREATER_OR_EQUAL = 5, 				-- >= max
	GREATER_AND_LESS = 6,				-- min < x < max
	GREATER_AND_LESS_EQUAL = 7,			-- min < x <= max
	GREATER_EQUAL_AND_LESS = 8,			-- min <= x < max
	GREATER_EQUAL_AND_LESS_EQUAL = 9	-- min <= x <= max
}

local ShareType = {
	LINK = 1,
	IMAGE = 2,
	NOTIFY = 3
}

PassFriendType = {SCORE = 1,
				  LEVEL = 2,
}

local function judgeCondition( op, condition, min, max )
	print("------condition-----")
	print(op)
	print(condition)
	print(min)
	print(max)
	print("------condition-----")
	if op == ConditionOP.LESS then
		return condition < min
	elseif op == ConditionOP.EQUAL then
		return condition == min
	elseif op == ConditionOP.LESS_OR_EQUAL then
		return condition <= min
	elseif op == ConditionOP.GREATER then
		return condition > min
	elseif op == ConditionOP.GREATER_OR_EQUAL then
		return condition >= min
	elseif op == ConditionOP.GREATER_AND_LESS then
		return condition > min and condition < max
	elseif op == ConditionOP.GREATER_AND_LESS_EQUAL then
		return condition > min and condition <= max
	elseif op == ConditionOP.GREATER_EQUAL_AND_LESS then
		return condition >= min and condition < max
	elseif op == ConditionOP.GREATER_EQUAL_AND_LESS_EQUAL then
		return condition >= min and condition <= max
	end

	return false
end

local function getImgUrl(shareId)
	local timer = os.time()
	local datetime = tostring(os.date("%y%m%d", timer))
	--local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/thumb_main.png")
	local imageURL = nil
	if shareId == ShareManager.HIGHEST_LEVEL then 
		imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_first.jpg?v="..datetime)	
	elseif shareId == ShareManager.OVER_SELF_RANK then
		imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_first.jpg?v="..datetime)	
	elseif shareId == ShareManager.UNLOCK_HIDEN_LEVEL then
		imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_first.jpg?v="..datetime)	
	elseif shareId == ShareManager.HIDE_FULL_STAR then
		imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_first.jpg?v="..datetime)	
	elseif shareId == ShareManager.FRIST_RANK_FRIEND then
		imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_first.jpg?v="..datetime)	
	elseif shareId == ShareManager.FULL_STARS then
		imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_first.jpg?v="..datetime)	
	end
	return imageURL
end

local function getLinkUrl()
	-- local invitecode = tostring(UserManager:getInstance().inviteCode)
	-- local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/wechat_icon.png")
	-- local plarformName = StartupConfig:getInstance():getPlatformName()
	-- 分享的链接地址
	local link = "http://animalmobile.happyelements.cn/link_show.html"
	return link
end

local ShareConfig = {
	[ShareManager.HIGHEST_LEVEL] = {
		op = function ()
				local version_highest_level =  MetaManager.getInstance():getMaxNormalLevelByLevelArea()

				--local condition
				if judgeCondition(ConditionOP.EQUAL, ShareManager.data.level, version_highest_level) == false then
					return false
				end

				--network condition
				local pass_num = ShareManager:getShareData(ShareManager.ConditionType.PASS_NUM)

				if pass_num == nil then
					ShareManager:changeState( "holding" )
					return false
				end

				ShareManager:changeState( "continuous" )

				return judgeCondition(ConditionOP.LESS, pass_num, 1000)	
			end,
		shareType = ShareType.IMAGE,
		priority = 10,
		shareImage = getImgUrl(ShareManager.HIGHEST_LEVEL),
		shareTitle = "show_off_content_10",
	},
	[ShareManager.OVER_SELF_RANK] = {
		op = function ()
				--local condition
				local rankRequest = ShareManager.preScore and ShareManager.preScore < ShareManager.data.totalScore

				if judgeCondition(ConditionOP.GREATER, ShareManager.data.level, 7) == false or
					judgeCondition(ConditionOP.EQUAL, rankRequest, true) == false then
					return false
				end

				--network condition
				local over_self_rank = ShareManager:getShareData(ShareManager.ConditionType.OVER_SELF_RANK)
				local rankPosition = ShareManager:getShareData(ShareManager.ConditionType.ALL_SCORE_RANK)

				if rankPosition == nil or over_self_rank == nil then
					local function onCompleteSuccess( evt )
						local rankPosition = 1
						local share = false

						if evt.data and evt.data.rankPosition then
							rankPosition = evt.data.rankPosition
						end

						if evt.data and evt.data.share then
							share = evt.data.share
						end

						ShareManager:setShareData(ShareManager.ConditionType.OVER_SELF_RANK, share)
						ShareManager:setShareData(ShareManager.ConditionType.ALL_SCORE_RANK, rankPosition)
						ShareManager:shareWithID(ShareManager.OVER_SELF_RANK)
					end

					local shareDataHttp = getShareRankWithPosition.new()
					shareDataHttp:addEventListener(Events.kComplete, onCompleteSuccess)
					shareDataHttp:load(ShareManager.preLevel, ShareManager.preScore)

					ShareManager:changeState( "holding" )
					return false
				end

				ShareManager:changeState( "continuous" )
			
				return judgeCondition(ConditionOP.EQUAL, over_self_rank, true)
			end,
		shareType = ShareType.IMAGE,
		priority = 20,
		shareImage = getImgUrl(ShareManager.OVER_SELF_RANK),
		shareTitle = "show_off_content_20", 
	},
	[ShareManager.UNLOCK_HIDEN_LEVEL] = {
		op = function ()
				local isNewBranchUnlock = ShareManager:getShareData(ShareManager.ConditionType.UNLOCK_HIDEN_LEVEL)

				if isNewBranchUnlock == nil then
					ShareManager:changeState( "holding" )
					return false
				end

				ShareManager:changeState( "continuous" )

				return judgeCondition(ConditionOP.EQUAL, isNewBranchUnlock, true)
			end,
		shareType = ShareType.IMAGE,
		priority = 30,
		shareImage = getImgUrl(ShareManager.UNLOCK_HIDEN_LEVEL),
		shareTitle = "show_off_content_30",
	},
	[ShareManager.HIDE_FULL_STAR] = {
		op = function ()
				local scores = MetaModel:sharedInstance():getLevelTargetScores(ShareManager.data.level)
				local star = 0
				for k, v in ipairs(scores) do
					if ShareManager.data.totalScore > v then star = k end
				end
				return judgeCondition(ConditionOP.GREATER_OR_EQUAL, star, 4)
			end,
		shareType = ShareType.IMAGE,
		priority = 40,
		shareImage = getImgUrl(ShareManager.HIDE_FULL_STAR),
		shareTitle = "show_off_content_40",
	},
	[ShareManager.LAST_STEP_PASS] = {
		op = function ()
				--local condition
				--重复闯关不算
				local top_level = UserManager.getInstance().user:getTopLevelId()

				if judgeCondition(ConditionOP.LESS_OR_EQUAL, top_level - ShareManager.data.level, 1) == false then
					return false
				end

				--network condition
				local left_step = ShareManager:getShareData(ShareManager.ConditionType.LEFT_STEP)
				local can_link = ShareManager:getShareData(ShareManager.ConditionType.CAN_LINK)

				if left_step == nil or can_link == nil then
					ShareManager:changeState( "holding" )
					return false
				end

				ShareManager:changeState( "continuous" )

				return judgeCondition(ConditionOP.EQUAL, left_step, 0) and
						judgeCondition(ConditionOP.EQUAL, can_link, true)
			end,
		shareType = ShareType.LINK,
		priority = 50,
		shareLink = getLinkUrl(),
		shareTitle = "show_off_content_50",
	},
	[ShareManager.ROCKET] = {
		op = function ()
				--local condition
				local levelDataInfo = UserService.getInstance().levelDataInfo

				local top_level = UserManager.getInstance().user:getTopLevelId()
				local maxConbo = levelDataInfo.maxConbo or 0

				local levels = {}
				for level,v in pairs(levelDataInfo.levels) do
					table.insert(levels, tonumber(level)) 
				end

				table.sort(levels)

				--连续
				for i=1,#levels-1 do
					if levels[i + 1] - levels[i] ~= 1 then
						return false
					end
				end

				if judgeCondition(ConditionOP.LESS_OR_EQUAL, top_level - ShareManager.data.level, 1) == false or
					judgeCondition(ConditionOP.EQUAL, maxConbo, 5) == false or
					judgeCondition(ConditionOP.GREATER, ShareManager.data.level, 7) == false then
						return false
				end

				--network condition
				local can_link = ShareManager:getShareData(ShareManager.ConditionType.CAN_LINK)
				if can_link == nil then
					ShareManager:changeState( "holding" )
					return false
				end
				ShareManager:changeState( "continuous" )

				return judgeCondition(ConditionOP.EQUAL, ShareManager:getShareData(ShareManager.ConditionType.CAN_LINK), true)
						
			end,
		shareType = ShareType.LINK,
		priority = 60,
		shareLink = getLinkUrl(),
		shareTitle = "show_off_content_60",
	},
	[ShareManager.N_TIME_PASS] = {
		op = function ()
				--local condition
				local levelDataInfo = UserService.getInstance().levelDataInfo
				local levelInfo = levelDataInfo:getLevelInfo(ShareManager.data.level)
				
				local playTimes = levelInfo.playTimes or 0
				local failTimes = levelInfo.failTimes or 0

				if judgeCondition(ConditionOP.GREATER_OR_EQUAL, failTimes, 10) == false or
					judgeCondition(ConditionOP.EQUAL, playTimes - failTimes, 1) == false then
					return false
				end

				--network condition
				local can_link = ShareManager:getShareData(ShareManager.ConditionType.CAN_LINK)
				if can_link == nil then
					ShareManager:changeState( "holding" )
					return false
				end
				ShareManager:changeState( "continuous" )
				
				return judgeCondition(ConditionOP.EQUAL, can_link, true)
			end,
		shareType = ShareType.LINK,
		priority = 70,
		shareLink = getLinkUrl(),
		shareTitle = "show_off_content_70",
	},
	[ShareManager.PASS_STEP] = {	
		op = function ()
				--local condition
				if judgeCondition(ConditionOP.GREATER, ShareManager.data.level, 7) == false then
					return false
				end
				--network condition
				local pass_step = ShareManager:getShareData(ShareManager.ConditionType.PASS_STEP)
				local can_link = ShareManager:getShareData(ShareManager.ConditionType.CAN_LINK)

				if pass_step == nil or can_link == nil then
					ShareManager:changeState( "holding" )
					return false
				end

				ShareManager:changeState( "continuous" )

				return judgeCondition(ConditionOP.EQUAL, can_link, true) and
						judgeCondition(ConditionOP.LESS_OR_EQUAL, pass_step, 10)
			end, 
		shareType = ShareType.LINK,
		priority = 80,
		shareLink = getLinkUrl(),
		shareTitle = "show_off_content_80",
	},
	[ShareManager.FULL_STARS] = {
		op = function ()
				local maxStar = 15 * 3
				local userStar = 0

				local firstLevel = 1
				local lastLevel = 15
				local currentLevel = ShareManager.data.level
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
				--TODO:current level star >= 3
				local scores = UserManager:getInstance().scores
				for k,v in pairs(scores) do
					if v.levelId > firstLevel and v.levelId <= lastLevel then
						if v.star <= 2 then return false end 
						userStar = userStar + v.star
					end
				end

				return judgeCondition(ConditionOP.GREATER_OR_EQUAL, userStar, maxStar) and
						judgeCondition(ConditionOP.GREATER, ShareManager.data.level, 30)
			end,
		shareType = ShareType.IMAGE,
		priority = 90,
		shareImage = getImgUrl(ShareManager.FULL_STARS),
		shareTitle = "show_off_content_90",
	},
	[ShareManager.FRIST_RANK_FRIEND] = {
		op = function ()
				local friend_rank = ShareManager:getShareData(ShareManager.ConditionType.FRIEND_RANK)
				local pass_friend_num = ShareManager:getShareData(ShareManager.ConditionType.PASS_FRIEND_NUM)

				if friend_rank == nil or pass_friend_num == nil then
					ShareManager:changeState( "holding" )
					return false
				end

				ShareManager:changeState( "continuous" )

				return judgeCondition(ConditionOP.EQUAL, friend_rank, 1) and
						judgeCondition(ConditionOP.GREATER_OR_EQUAL, pass_friend_num, 5)
			end,
		shareType = ShareType.IMAGE,
		priority = 100,
		shareImage = getImgUrl(ShareManager.FRIST_RANK_FRIEND),
		shareTitle = "show_off_content_100",
	},
	[ShareManager.SCORE_OVER_FRIEND] = {
		op = function ()
				--lcoal condition
				if judgeCondition(ConditionOP.GREATER, ShareManager.data.level, 7) == false then
					return false
				end

				--network condition
				local friend_rank_list = ShareManager:getShareData(ShareManager.ConditionType.FRIEND_RANK_LIST)
				local pass_friend_num = ShareManager:getShareData(ShareManager.ConditionType.PASS_FRIEND_NUM)

				if friend_rank_list == nil or pass_friend_num == nil then
					ShareManager:changeState( "holding" )
					return false
				end

				ShareManager:changeState( "continuous" )

				local self_score = ShareManager.data.totalScore
				local isOverFriend = false

				local over_friend_table = {}

				for i,v in ipairs(friend_rank_list) do
					if self_score > v.score then
						isOverFriend = true
						table.insert( over_friend_table, v )
					end
				end

				ShareManager:setShareData(ShareManager.ConditionType.OVER_FRIEND_TABLE, over_friend_table)

				return judgeCondition(ConditionOP.GREATER_OR_EQUAL, pass_friend_num, 5) and
						judgeCondition(ConditionOP.EQUAL, isOverFriend, true)
			end,
		shareType = ShareType.NOTIFY,
		priority = 110,
		shareNotify = "show_off_to_friend_point",
		shareTitle = "show_off_content_110",
	},
	[ShareManager.LEVEL_OVER_FRIEND] = {
		op = function ()
			--local condition
			local friend_num = FriendManager:getInstance():getFriendCount()

			if judgeCondition(ConditionOP.GREATER, ShareManager.data.level, 30) == false or 
				judgeCondition(ConditionOP.GREATER_OR_EQUAL, friend_num, 5) == false then
				return false
			end

			--network condition
			local friend_rank_list = FriendManager:getInstance().friends

			if friend_rank_list == nil then
				return false
			end

			local isOverFriend = false

			local level_over_friend_table = {}

			for uid,friend in pairs(friend_rank_list) do
				local top_level = friend:getTopLevelId()
				if ShareManager.data.level == top_level then
					isOverFriend = true
					table.insert(level_over_friend_table, friend)
				end
			end

			ShareManager:setShareData(ShareManager.ConditionType.LEVEL_OVER_FRIEND_TABLE, level_over_friend_table)

			return judgeCondition(ConditionOP.EQUAL, isOverFriend, true)
		end,
		shareType = ShareType.NOTIFY,
		priority = 120,
		shareNotify = "show_off_to_friend_rank",
		shareTitle = "show_off_content_120",
	}
}

local PriorityConfig = {
	ShareManager.HIGHEST_LEVEL, -- 1
	ShareManager.OVER_SELF_RANK,
	ShareManager.EIGHTY_PERCENT_PERSON,
	ShareManager.UNLOCK_HIDEN_LEVEL,
	ShareManager.HIDE_FULL_STAR,
	ShareManager.LAST_STEP_PASS,
	ShareManager.ROCKET,
	ShareManager.N_TIME_PASS,
	ShareManager.PASS_STEP,
	ShareManager.FULL_STARS,
	ShareManager.FRIST_RANK_FRIEND,
	ShareManager.SCORE_OVER_FRIEND,
	ShareManager.LEVEL_OVER_FRIEND,
}

function ShareManager:judgeShareCondition( shareID )
	local config = ShareConfig[shareID]
	if config == nil then
		--todo
		print("[warning]ShareManager no this config: shareID = ".. shareID)
		return false
	end

	--each day,one share one chance to share
	if config.isShared == true then
		return false
	end

	return config.op()
end

function ShareManager:judgeShare( shareID )
	if self:judgeShareCondition(shareID) == false then
		return nil
	end

	self:showShareUI(shareID)

	--clean data
	self:cleanData()

	return shareID
end

function ShareManager:showShareUI( shareID )
	print("share:-------------------------------------------------------------")
	print("share with ID:"..shareID)
	print("share:-------------------------------------------------------------")
	--记录触发次数
    self:increaseTriggerTime(shareID)
	--show share UI
	local panel = nil
	local config = ShareManager:getShareConfig(shareID)
	if shareID == ShareManager.LAST_STEP_PASS then 			    --id = 3  priority = 50
		panel = ShareLastStepPanel:create(shareID, config.shareType, config.shareLink, config.shareTitle)
	elseif shareID == ShareManager.ROCKET then 					--id = 6  priority = 60
		panel = SharePassFiveLevelPanel:create(shareID, config.shareType, config.shareLink, config.shareTitle)
	elseif shareID == ShareManager.N_TIME_PASS then 			--id = 4  priority = 70
		panel = ShareFinalPassLevelPanel:create(shareID, config.shareType, config.shareLink, config.shareTitle)
	elseif shareID == ShareManager.PASS_STEP then 				--id = 1  priority = 80
		panel = ShareLeftTenStepPanel:create(shareID, config.shareType, config.shareLink, config.shareTitle)

	elseif shareID == ShareManager.HIGHEST_LEVEL then 			--id = 2  priority = 10
		panel = SharePyramidPanel:create(shareID, config.shareType, config.shareImage, config.shareTitle)
	elseif shareID == ShareManager.OVER_SELF_RANK then          --id = 5  priority = 20
		panel = ShareThousandOnePanel:create(shareID, config.shareType, config.shareImage, config.shareTitle)
	elseif shareID == ShareManager.UNLOCK_HIDEN_LEVEL then      --id = 11  priority = 30
		panel = ShareHiddenLevelPanel:create(shareID, config.shareType, config.shareImage, config.shareTitle)	
	elseif shareID == ShareManager.HIDE_FULL_STAR then 			--id = 9  priority = 40
		panel = ShareFourStarPanel:create(shareID, config.shareType, config.shareImage, config.shareTitle)
	elseif shareID == ShareManager.FULL_STARS then  			--id = 10  priority = 90
		panel = ShareTrophyPanel:create(shareID, config.shareType, config.shareImage, config.shareTitle)
	elseif shareID == ShareManager.FRIST_RANK_FRIEND then 		--id = 15  priority = 100
		panel = ShareFirstInFriendsPanel:create(shareID, config.shareType, config.shareImage, config.shareTitle)

	elseif shareID == ShareManager.SCORE_OVER_FRIEND then       --id = 7  priority = 110
		panel = SharePassFriendPanel:create(shareID, config.shareType, config.shareNotify, config.shareTitle, PassFriendType.SCORE)
	elseif shareID == ShareManager.LEVEL_OVER_FRIEND then       --id = 8  priority = 120
		panel = SharePassFriendPanel:create(shareID, config.shareType, config.shareNotify, config.shareTitle, PassFriendType.LEVEL)
	elseif shareID == ShareManager.EIGHTY_PERCENT_PERSON then
		--暂不支持
	end	
	if panel then
		local http = RewardMetalHttp.new()
		http:load(shareID)
		panel:popout()
	end
end

function ShareManager:changeState( state )
	local scheduleScriptFuncID

	if state == "holding" and self.judgeState == "continuous" then
	  	local function onTimeOut()
	    	self.forceOver = true
			print("share:forceOver timeout......")
	    	if scheduleScriptFuncID ~= nil then 
	    		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scheduleScriptFuncID)
	    		scheduleScriptFuncID = nil
	    	end
	  	end
	  	scheduleScriptFuncID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onTimeOut,self.HOLDING_TIME_OUT,false)
	end

	if state == "continuous" and scheduleScriptFuncID ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scheduleScriptFuncID)
	    scheduleScriptFuncID = nil
	end

	print("share:changeState---------------------------------->"..state)

	self.judgeState = state
end

function ShareManager:cleanData( ... )
	print("share:forceOver clear......")
	self.forceOver = true
	self.data = {}
	self.judgeState = "continuous"
	self.curPrioprity = 1
end

function ShareManager:shareWithID( shareID )
	print("share:------------------------------------------------------------")
	print("share id : "..shareID)
	print("share:------------------------------------------------------------")

	if self.data.curShareID ~= nil then
		return
	end

	local priority = nil

	for p,id in pairs(PriorityConfig) do
		if id == shareID then
			priority = p
			break
		end
	end

	if priority == nil then
		return
	end

	if self.curPrioprity then
		if self.curPrioprity ~= priority then
			return
		end
	end

	self:shareWithPriority(priority)
end

function ShareManager:shareWithPriority( priority )
	if priority > #PriorityConfig then
		return false
	end

	print("share:------------------------------------------------------------")
	print("share:judge priority : "..priority.. ", shareID : " .. PriorityConfig[priority])
	print("share:------------------------------------------------------------")

	if self.forceOver == true then
		print("share: forceOver--------------")
		self:cleanData()
		return false
	end

	if self.data.sharedTable == nil then
		print("share:no data...")
		self.forceOver = true
		return false
	end

	--all share must be judged
	if #self.data.sharedTable >= self.MAX_SHARE_TIME then
		print("share:forceOver trigger time greater 3!!!")
		self.forceOver = true
		return false
	end

	self.curPrioprity = priority

	local shareID = PriorityConfig[priority]

	local config = ShareConfig[shareID]
	if config == nil then
		print("[warning]ShareManager no this config: shareID = ".. shareID)
		return self:shareWithPriority(priority + 1)
	end

	self.data.curShareID = self:judgeShare(shareID)
	if self.data.curShareID ~= nil then
		return true
	end

	if self.judgeState == "holding" then
		print("share:error judgeState is holding!!!")
		return false
	end

	return self:shareWithPriority(priority + 1)
end

function ShareManager:setShareData( key, value )
	print("share:------------------------------------------------------")
	print("share:setShareData->key:"..key)
	--he_log_warning(value)
	print(tostring(value))
	print("share:------------------------------------------------------")
	self.data[key] = value
end

function ShareManager:getShareData( key )
	if key == self.ConditionType.CAN_LINK and self.data[key] == nil then
		local function onCompleteSuccess( evt )
			local canSend = false

			if evt.data and evt.data.canSend then
				canSend = evt.data.canSend
			end

			self:setShareData(self.ConditionType.CAN_LINK, canSend)
			self:shareWithPriority(self.curPrioprity)
		end

		local shareDataHttp = CanSendLinkShowOff.new()
		shareDataHttp:addEventListener(Events.kComplete, onCompleteSuccess)
		shareDataHttp:load()
	end

	return self.data[key]
end

function ShareManager:getShareConfig( shareID )
	return ShareConfig[shareID]
end

function ShareManager:initJugeState( ... )
	self:changeState("continuous")
	self.forceOver = false
end

function ShareManager:startShare( ... )
	self:initJugeState()

	UserService.getInstance():onLevelUpdate(1, ShareManager.data.level, ShareManager.data.totalScore)

	--start judge share
	self:shareWithPriority(1)

	local user = UserService.getInstance().user
	if user then
		GameCenterSDK:getInstance():reportScore(user:getStar(), kGameCenterLeaderboards.all_star_leaderboard)
	end
	local rated = CCUserDefault:sharedUserDefault():getBoolForKey("game.local.review")
	if __WP8 and not rated and level % 5 == 3 then
		local _msg = Localization:getInstance():getText("ratings.and.review.body")
		local _title = Localization:getInstance():getText("ratings.and.review.title")
		local function _callback(r)
			if not r then return end
			Wp8Utils:RunRateReview()
			CCUserDefault:sharedUserDefault():setBoolForKey("game.local.review", true)
			CCUserDefault:sharedUserDefault():flush()
		end
		Wp8Utils:ShowMessageBox(_msg, _title, _callback)
	end
	if __IOS and level == 14 and not rated then

		local function onUIAlertViewCallback( alertView, buttonIndex )
			if buttonIndex == 1 then
				local nsURL = NSURL:URLWithString(NetworkConfig.appstoreURL)
				UIApplication:sharedApplication():openURL(nsURL)
			end
		end
		local title = Localization:getInstance():getText("ratings.and.review.title")
		local okLabel = Localization:getInstance():getText("ratings.and.review.cancel")
		local UIAlertViewClass = require "zoo.util.UIAlertViewDelegateImpl"
		local alert = UIAlertViewClass:buildUI(title, Localization:getInstance():getText("ratings.and.review.body"), okLabel, onUIAlertViewCallback)
		alert:addButtonWithTitle(Localization:getInstance():getText("ratings.and.review.confirm"))
		alert:show()

		CCUserDefault:sharedUserDefault():setBoolForKey("game.local.review", true)
		CCUserDefault:sharedUserDefault():flush()
	end
end

function ShareManager:onPassLevel(level, totalScore, levelType)
	print("share:pass level---------------------------------")
	self:checkShareTime()

	if levelType ~= GameLevelType.kMainLevel
		-- or levelType == GameLevelType.kRabbitWeekly
		or level == nil or totalScore == nil or levelType == nil
	then
		self.forceOver = true
		print("share:forceOver not MainLevel......")
		return
	end

	--self:cleanData()

	self.data.level = level
	self.data.totalScore = totalScore
	self.data.levelType = levelType

	--self:shareWithPriority(1)
	self:startShare()
end

local function split( str, sep )
	local t = {}
	for s in string.gmatch(str, "([^"..sep.."]+)") do
    	table.insert(t, tonumber(s))
	end
	return t
end

local runOnce = 0

function ShareManager:checkShareTime( ... )
	--check online data,just run once
	local count = nil

	if runOnce == 0 then
		local dailyData = UserManager:getInstance():getDailyData()
		count = dailyData["dailyShowOffReward"]
		runOnce = 1
	end

	local userDefault = CCUserDefault:sharedUserDefault()
	local shareTime = userDefault:getStringForKey("game.share.all.time")
	local time = Localhost:time() / 1000
	local share_all_time = 0


	--data,time,share...
	if shareTime == nil then
		share_all_time = 0
		self:setShareData(self.ConditionType.SHARE_ALL_TIME, share_all_time)
		return
	end

	local share_data = split(shareTime, ",")
	if #share_data ~= 0 then
   		local pre_day = math.ceil(share_data[1] / 3600)
		local day = math.ceil(time / 3600)
		share_all_time = share_data[2]

		if pre_day ~= day then
			share_all_time = 0
			userDefault:setStringForKey("game.share.all.time", tostring(time .. "," .. share_all_time))
	   		userDefault:flush()
	   		for i,v in ipairs(share_data) do
	   			if i > 2 then
	   				share_data[i] = nil
	   			end
	   		end
		end
	end

    if count ~= nil then
    	share_all_time = tonumber(count)
    end

    self.data.sharedTable = {}

    if #share_data > 2 then
    	for index=3,#share_data do
    		ShareConfig[share_data[index]].isShared = true
    		table.insert(self.data.sharedTable, share_data[index])
    	end
    elseif #share_data == 0 then
    	userDefault:setStringForKey("game.share.all.time", tostring(time .. "," .. share_all_time))
   		userDefault:flush()
    end

    self:setShareData(self.ConditionType.SHARE_ALL_TIME, share_all_time)

    if count ~= nil then
    	local str = ""

		for i,shareid in ipairs(self.data.sharedTable) do
			str = str .. "," .. shareid
		end

		userDefault:setStringForKey("game.share.all.time", tostring(time .. "," .. share_all_time .. str))
	   	userDefault:flush()
    end
end

function ShareManager:increaseTriggerTime( shareID )
	local userDefault = CCUserDefault:sharedUserDefault()
	local shareTime = userDefault:getStringForKey("game.share.all.time")
	local time = Localhost:time() / 1000
	if shareTime == nil then
		userDefault:setStringForKey("game.share.all.time", tostring(time .. "," .. 0))
   		userDefault:flush()
	end

	shareTime = shareTime .. "," .. shareID
	userDefault:setStringForKey("game.share.all.time", tostring(shareTime))
   	userDefault:flush()
end

function ShareManager:increaseShareAllTime()
	self:checkShareTime()
	local share_all_time = self:getShareData(self.ConditionType.SHARE_ALL_TIME)

	if share_all_time == nil then share_all_time = 0 end

	share_all_time = share_all_time + 1
	local time = Localhost:time() / 1000

	local str = ""

	for i,shareid in ipairs(self.data.sharedTable) do
		str = str .. "," .. shareid
	end

	local userDefault = CCUserDefault:sharedUserDefault()
	userDefault:setStringForKey("game.share.all.time", tostring(time .. "," .. share_all_time .. str))
   	userDefault:flush()
end

function ShareManager:getShareReward()
	local shareReward = nil
	self:checkShareTime()
	local share_all_time = self:getShareData(self.ConditionType.SHARE_ALL_TIME)

	if share_all_time == nil then
		return nil
	end

	if share_all_time >= self.MAX_SHARE_TIME then
		return nil
	end

	local id = 2
	local num = (share_all_time+1)*100 
	shareReward = {rewardId = id, rewardNum = num}
	return shareReward
end

function ShareManager:onFailLevel( level, totalScore )
	UserService.getInstance():onLevelUpdate(0, level, totalScore)
end

function ShareManager:openAppBar( sub )
	sub = sub or 2
	local AppbarAgent = luajava.bindClass("com.tencent.open.yyb.AppbarAgent")
	local cat = nil
	if sub == 0 then cat = AppbarAgent.TO_APPBAR_NEWS
	elseif sub == 1 then cat = AppbarAgent.TO_APPBAR_SEND_BLOG
	else cat = AppbarAgent.TO_APPBAR_DETAIL end
	
	local tencentOpenSdk = luajava.bindClass("com.happyelements.android.sns.tencent.TencentOpenSdk"):getInstance()
	tencentOpenSdk:startAppBar(cat)
end

function ShareManager:checkIsLinkShare(shareId)
	return ShareConfig[shareId].shareType == ShareType.LINK
end