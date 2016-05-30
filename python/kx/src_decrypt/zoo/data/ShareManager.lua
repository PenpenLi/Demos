--
-- ShareManager ---------------------------------------------------------
--
require "zoo.PersonalCenter.AchievementManager"

ShareManager = {}


function ShareManager:showShareUI( shareIdTab )
	local shareId
	for _,id in ipairs(shareIdTab) do
		if not self:isTrigger(id) then
			shareId = id
			break
		end
	end

	if shareId == nil then return end

	print("share with ID:"..shareId)

	--记录触发次数
    self:increaseTriggerTime(shareId)
	--show share UI
	local config = AchievementManager:getConfig(shareId)
	if not config then return end
	local panel = config.sharePanel and config.sharePanel:create(shareId) or nil
	if panel then
		local http = RewardMetalHttp.new()
		http:load(shareId)
		panel:popout()
	end
end


function ShareManager:evaluateAndGameCenter()
	local level = self.level or 0

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

function ShareManager:onPassLevel(level, totalScore, levelType, star)
	self:checkShareTime()
	self.level = level
	self.totalScore = totalScore
	self.levelType = levelType

	UserService.getInstance():onLevelUpdate(1, level, totalScore)

	AchievementManager:initData(self, level, totalScore, levelType, star)

	self:evaluateAndGameCenter()
end

local function split( str, sep )
	local t = {}
	for s in string.gmatch(str, "([^"..sep.."]+)") do
    	table.insert(t, tonumber(s))
	end
	return t
end

local runOnce = 0

function ShareManager:isTrigger( shareId )
	print(table.tostring(self.shareData))
	self:checkShareTime()
	if #self.shareData >= self.MAX_SHARE_TIME then
		return true
	end

	for _,id in ipairs(self.shareData) do
		if id == shareId then
			return true
		end
	end

	return false
end

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
	self.shareData = {}

	--data,time,share...
	if shareTime == nil then
		share_all_time = 0
		self.share_all_time = share_all_time
		return
	end

	local share_data = split(shareTime, ",")
	if #share_data ~= 0 then
   		local pre_day = math.ceil((share_data[1] + 28800) / 86400)
		local day = math.ceil((time + 28800) / 86400)
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

    if #share_data > 2 then
    	for index=3,#share_data do
    		table.insert(self.shareData, share_data[index])
    	end
    elseif #share_data == 0 then
    	userDefault:setStringForKey("game.share.all.time", tostring(time .. "," .. share_all_time))
   		userDefault:flush()
    end

  	self.share_all_time = share_all_time

    if count ~= nil then
    	local str = ""

		for i,shareid in ipairs(self.shareData) do
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

	table.insert(self.shareData, shareID)

	shareTime = shareTime .. "," .. shareID
	userDefault:setStringForKey("game.share.all.time", tostring(shareTime))
   	userDefault:flush()
end

function ShareManager:increaseShareAllTime()
	self:checkShareTime()
	local share_all_time = self.share_all_time

	if share_all_time == nil then share_all_time = 0 end

	share_all_time = share_all_time + 1
	local time = Localhost:time() / 1000

	local str = ""

	for i,shareid in ipairs(self.shareData) do
		str = str .. "," .. shareid
	end

	local userDefault = CCUserDefault:sharedUserDefault()
	userDefault:setStringForKey("game.share.all.time", tostring(time .. "," .. share_all_time .. str))
   	userDefault:flush()
end

function ShareManager:getShareReward()
	-- 需求，去掉所有分享中的分享奖励（包括推送消息奖励）
	do return nil end
	
	local shareReward = nil
	self:checkShareTime()
	local share_all_time = self.share_all_time

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

function ShareManager:init()
	self.MAX_SHARE_TIME = 5
	self.shareData = {}

	AchievementManager:registerAchievementNotify( AchievementManager.notifyEvent.SHARE, self, self.showShareUI )
end

ShareManager:init()