
LocalNotificationType = {
	kEnergyFull = 1,
	kWeeklyRaceReward = 2,
	kMarkFinalReward = 3,
	kBeyondFriendAtTopLevel = 6,
	kLeaveForThree = 11,
	kLeaveForFive = 12,
	kLeaveForSeven = 13,
}

LocalNotificationPriority = {
	[1] = 4,
	[2] = 5,
	[3] = 6,
	[6] = 7,
	[11] = 3,
	[12] = 2,
	[13] = 1,
}

local MAX_NUM_PER_DAY = 3
local function getDayStartTimeByTS(ts)
	local utc8TimeOffset = 57600 -- (24 - 8) * 3600
	local oneDaySeconds = 86400 -- 24 * 3600
	return ts - ((ts - utc8TimeOffset) % oneDaySeconds)
end

local LocalNotificationVO = class()

function LocalNotificationVO:ctor()
	self.typeId = nil
	self.timeStamp = nil
	self.body = nil
	self.action = nil
	self.isOpen = false
end

-- return isValid
function LocalNotificationVO:decode(src)
	self.typeId = tonumber(src.typeId)
	self.timeStamp = tonumber(src.timeStamp)
	self.body = tostring(src.body)
	self.action = tostring(src.action)

	if src.typeId and type(src.typeId) == "number"
		and src.timeStamp and type(src.timeStamp) == "number"
		and src.body and type(src.body) == "string"
		and src.action and type(src.action) == "string"
		then

		-- time validate, from 9:00 ~ 22:00 every day
		local dayStartTime = getDayStartTimeByTS(self.timeStamp)
		if self.timeStamp > dayStartTime + 9 * 3600 and self.timeStamp < dayStartTime + 22 * 3600 then
			return true
		end
	end

	return false
end

function LocalNotificationVO:toObject()
	return {typeId = self.typeId, timeStamp = self.timeStamp, body = self.body, action = self.action, isOpen = self.isOpen}
end

LocalNotificationManager = class()

local kStorageFileName = "notification"
local kLocalDataExt = ".ds"
local instance = nil

function LocalNotificationManager.getInstance()
	if not instance then
		instance = LocalNotificationManager.new()
		instance:init()
	end
	return instance
end

function LocalNotificationManager:init()
	self.mapByDay = {}
	
	local path = HeResPathUtils:getUserDataPath() .. "/" .. kStorageFileName .. kLocalDataExt
	local file, err = io.open(path, "r")

	if file and not err then
		local content = file:read("*a")
		io.close(file)

        local fields = nil
        local function decodeContent()
            fields = amf3.decode(content)
        end
        pcall(decodeContent)

		if fields and type(fields) == "table" and #fields > 0 then
			for i, v in ipairs(fields) do
				local vo = LocalNotificationVO.new()	
				if vo:decode(v) then 
					self:_addNotifyVO(vo)
				end
			end
		end
	end
end

function LocalNotificationManager:_addNotifyVO(notifyVO)
	if notifyVO.timeStamp <= os.time() then return end
	local day = getDayStartTimeByTS(notifyVO.timeStamp)
	if not self.mapByDay[day] then
		self.mapByDay[day] = {}
	end

	notifyVO.isOpen = true
	table.insert(self.mapByDay[day], notifyVO)
	-- if #self.mapByDay[day] <= MAX_NUM_PER_DAY then
	-- 	notifyVO.isOpen = true
	-- 	table.insert(self.mapByDay[day], notifyVO)
	-- end
	self:reorderNotify(day)
end

function LocalNotificationManager:reorderNotify(dayKey)
	local function sortFunc(notiVo1, notiVo2)
		local order1 = LocalNotificationPriority[notiVo1.typeId]
		local order2 = LocalNotificationPriority[notiVo2.typeId]
		if order1 and order2 then 
			return order1<order2
		else
			return false
		end
	end
	if #self.mapByDay[dayKey]>MAX_NUM_PER_DAY then 
		local tempTable = table.clone(self.mapByDay[dayKey])
		table.sort(tempTable, sortFunc)
		self.mapByDay[dayKey] = {}
		for i,v in ipairs(tempTable) do
			if i <= MAX_NUM_PER_DAY then 
				self.mapByDay[dayKey][i] = v
			else
				break
			end
		end
	end
end

function LocalNotificationManager:addNotify(typeId, date, body, action)
	local vo = LocalNotificationVO.new()	
	local val = { typeId = typeId, timeStamp = date, body = body, action = action }
	if vo:decode(val) then 
		self:_addNotifyVO(vo)
	end
	self:flushToStorage()
end

function LocalNotificationManager:deleteNotify(notifyVO)
	local dayStartTS = getDayStartTimeByTS(notifyVO.timeStamp)
	local dayList = self.mapByDay[dayStartTS]
	if dayList then
		local newList = {}
		for i, vo in ipairs(dayList) do
			if vo ~= notifyVO then
				table.insert(newList, vo)
			else
				self:cancelSingleAndroidNotification(vo)
			end
		end
		if #newList > 0 then 
			self.mapByDay[dayStartTS] = newList
		else
			self.mapByDay[dayStartTS] = nil
		end
	end
end

function LocalNotificationManager:getNotiListByDay(ts)
	local dayStartTS = getDayStartTimeByTS(ts)
	if self.mapByDay and self.mapByDay[dayStartTS] then
		return self.mapByDay[dayStartTS]
	end
end

function LocalNotificationManager:getNotiByDayAndType(dayStartTS, typeId)
	local tempList = self:getNotiListByDay(dayStartTS)
	if not tempList then return nil end
	for i, vo in ipairs(tempList) do
		if vo.typeId == typeId then
			return vo
		end
	end
end

function LocalNotificationManager:getNotiByType(typeId)
	local sameTypeNoti = {}
	for _, notiList in pairs(self.mapByDay) do
		for i, vo in ipairs(notiList) do
			if vo.typeId == typeId then
				table.insert(sameTypeNoti, vo)
			end
		end
	end
	return sameTypeNoti
end

function LocalNotificationManager:pushAllNotifications()
	print("pushAllNotifications")
	for _, notiList in pairs(self.mapByDay) do
		for i, vo in ipairs(notiList) do
			local timeOffset = vo.timeStamp - os.time()
			print("pushSingleNotification typeId: " .. vo.typeId .. " timeOffset: " .. timeOffset)
			self:pushSingleNotification(timeOffset, vo.action, vo.body, vo.typeId, vo.timeStamp)
		end
	end
end

local notificationUtil = nil
function LocalNotificationManager:pushSingleNotification(timeOffset, action, body, typeId, timeStamp)
	if __ANDROID and not notificationUtil then
		if PrepackageUtil:isPreNoNetWork() then return end
		notificationUtil = luajava.bindClass("com.happyelements.hellolua.share.NotificationUtil")
	end
	if __IOS then			
		WeChatProxy:scheduleLocalNotification_alertBody_alertAction(timeOffset, body, action)
	end
	if __ANDROID then
		-- use alarmId to ensure every piece of alarm will work, otherwise just the last one work
		local function addLocal()
			local alarmId = self:getAndroidAlarmId(typeId, timeStamp)
			notificationUtil:addLocalNotification(timeOffset, body, alarmId)
		end
		pcall(addLocal)
	end
	if __WP8 then
		Wp8Utils:scheduleLocalNotification(timeOffset, action, body)
	end
end

function LocalNotificationManager:getAndroidAlarmId(typeId, timeStamp)
	return typeId .. ":" .. timeStamp
end

function LocalNotificationManager:cancelSingleAndroidNotification(notifyVO)
	if __ANDROID and not notificationUtil then
		if PrepackageUtil:isPreNoNetWork() then return end
		notificationUtil = luajava.bindClass("com.happyelements.hellolua.share.NotificationUtil")
	end
	if __ANDROID then
		local function cancelLocal()
			local alarmId = self:getAndroidAlarmId(notifyVO.typeId, notifyVO.timeStamp)
			notificationUtil:cancelLocalNotification(alarmId)
		end
		pcall(cancelLocal)
	end
end

function LocalNotificationManager:cancelAllAndroidNotification()
	if __ANDROID and not notificationUtil then
		if PrepackageUtil:isPreNoNetWork() then return end
		notificationUtil = luajava.bindClass("com.happyelements.hellolua.share.NotificationUtil")
	end
	if __ANDROID then
		local function cancelLocal()
			notificationUtil:cancelLocalNotification(tostring(LocalNotificationType.kEnergyFull))
		end
		pcall(cancelLocal)
		for _, notiList in pairs(self.mapByDay) do
			for i, vo in ipairs(notiList) do
				self:cancelSingleAndroidNotification(vo)
			end
		end
	end
end

function LocalNotificationManager:validateNotificationTime()
	local now = os.time()
	for day, notiList in pairs(self.mapByDay) do
		local newList = {}
		for i, vo in ipairs(notiList) do
			if vo.timeStamp > now then
				table.insert(newList, vo)
			else
				self:cancelSingleAndroidNotification(vo)
			end
		end
		if #newList > 0 then 
			self.mapByDay[day] = newList
		else
			self.mapByDay[day] = nil
		end
	end
	self:flushToStorage()
end

function LocalNotificationManager:flushToStorage()
	local notiList = {}
	for _, unit in pairs(self.mapByDay) do
		for i, notiVO in ipairs(unit) do
			table.insert(notiList, notiVO:toObject())
		end
	end

	local content = amf3.encode(notiList)
	local filePath = HeResPathUtils:getUserDataPath() .. "/" .. kStorageFileName .. kLocalDataExt
    local file = io.open(filePath, "wb")
    assert(file, "persistent file failure " .. kStorageFileName)
    if not file then return end
	local success = file:write(content)
   
    if success then
        file:flush()
        file:close()
    else
        file:close()
        print("write file failure " .. filePath)
    end
end

function LocalNotificationManager:setMarkRewardNotification(leftDay)
	assert(leftDay == 1 or leftDay == 2)
	local todayTime = getDayStartTimeByTS(os.time())

	if leftDay >= 1 then
		local tomorrowTS = todayTime + 24 * 3600 + 12 * 3600
		print("setMarkRewardNotification leftDay 1 " .. tomorrowTS)
		if not self:getNotiByDayAndType(tomorrowTS, LocalNotificationType.kMarkFinalReward) then
			print("addNotify leftDay 1", tomorrowTS)
			self:addNotify(LocalNotificationType.kMarkFinalReward, tomorrowTS, Localization:getInstance():getText("push.sign.reward.text"), "action")	
		end
	end

	if leftDay >= 2 then
		local dayAfterTomorrowTS = todayTime + 48 * 3600 + 12 * 3600
		print("setMarkRewardNotification leftDay 2 " .. dayAfterTomorrowTS)
		if not self:getNotiByDayAndType(dayAfterTomorrowTS, LocalNotificationType.kMarkFinalReward) then
			print("addNotify leftDay 2", dayAfterTomorrowTS)
			self:addNotify(LocalNotificationType.kMarkFinalReward, dayAfterTomorrowTS, Localization:getInstance():getText("push.sign.reward.text"), "action")	
		end
	end
end

function LocalNotificationManager:cancelMarkNotificationToday()
	local now = os.time()
	local vo = self:getNotiByDayAndType(now, LocalNotificationType.kMarkFinalReward)
	print(table.tostring(self.mapByDay))
	print("cancelMarkNotificationToday")	
	debug.debug()
	if vo then
		self:deleteNotify(vo)
		self:flushToStorage()
		print(table.tostring(self.mapByDay))
		debug.debug()
	end
end

function LocalNotificationManager:setWeeklyRaceRewardNotification()
	local function getWeekDay()
		local wday = tonumber(os.date("%w"))
		if wday == 0 then
			return 7
		end
		return wday
	end
	local now = os.time()
	local weekDay = getWeekDay()
	local startTimeOnToday = getDayStartTimeByTS(now)
	local startTimeOnThisWeek = startTimeOnToday - (weekDay - 1) * 24 * 3600
	local targetTime = startTimeOnThisWeek + 7 * 24 * 3600 + 10 * 3600
	print("setWeeklyRaceRewardNotification " .. targetTime)

	if not self:getNotiByDayAndType(targetTime, LocalNotificationType.kWeeklyRaceReward) then
		self:addNotify(LocalNotificationType.kWeeklyRaceReward, targetTime, Localization:getInstance():getText("push.weekly.race.reward.text"), "action")
	end
end

function LocalNotificationManager:cancelWeeklyRaceRewardNotification()
	local now = os.time()
	local vo = self:getNotiByDayAndType(now, LocalNotificationType.kWeeklyRaceReward)
	if vo then
		self:deleteNotify(vo)
		self:flushToStorage()
	end
end

function LocalNotificationManager:setTestNotification()
	local now = os.time()
	local ts1 = now + 20
	local ts2 = now + 120
	-- self:addNotify(LocalNotificationType.kMarkFinalReward, ts1, "test notification 1", "action")
	--self:addNotify(LocalNotificationType.kWeeklyRaceReward, ts2, "testnotification2", "action")

	-- notificationUtil = luajava.bindClass("com.happyelements.hellolua.share.NotificationUtil")
	-- notificationUtil:addLocalNotification(10,"test","12:1246546456464")

	-- local vo = self:getNotiByDayAndType(ts1, LocalNotificationType.kMarkFinalReward)
	-- self:deleteNotify(vo)

	-- local now = 1416130560
	-- local weekDay = tonumber(os.date("%w"))
	-- local startTimeOnToday = getDayStartTimeByTS(now)
	-- local startTimeOnThisWeek = startTimeOnToday - (weekDay - 1) * 24 * 3600
	-- local targetTime = startTimeOnThisWeek + 7 * 24 * 3600 + 10 * 3600
end

---- server pushNotify
local passLevelCache = {}
function LocalNotificationManager:setPassLevelFlag(levelId, star, score)
	if star < 1 or not LevelType:isMainLevel(levelId) then
		passLevelCache = {}
		return
	end
	passLevelCache.levelId = levelId
	passLevelCache.star = star
	passLevelCache.score = score
end

function LocalNotificationManager:sendBeyondFriendsNotification(levelId, friendRankList)
	local maxNormalLevelId = MetaManager.getInstance():getMaxNormalLevelByLevelArea()
	local friendUserVOList = FriendManager.getInstance().friends
	local selfUId = UserManager:getInstance().user.uid

	local friendRankMap = {}
	local selfRankIndex = nil
	local selfScore = nil
	for rank, user in ipairs(friendRankList) do
		if user.uid == selfUId then 
			selfRankIndex = rank 
			selfScore = user.score
		end
		friendRankMap[user.uid] = rank
	end

	if passLevelCache and (passLevelCache.levelId ~= levelId or passLevelCache.score ~= selfScore) then
		passLevelCache = {}
		return
	end
	passLevelCache = {}
	if not selfRankIndex then return end

	local friendsAtTopLevel = {}
	for uid, vo in pairs(friendUserVOList) do
		if vo:getTopLevelId() == maxNormalLevelId then
			table.insert(friendsAtTopLevel, vo)
		end
	end

	if #friendsAtTopLevel > 0 then
		local result = {}
		for i, v in ipairs(friendsAtTopLevel) do
			local friendRank = friendRankMap[v.uid]
			if friendRank and type(friendRank) == "number" and friendRank > selfRankIndex then
				table.insert(result, v.uid)
			end
		end

		if #result > 0 then
			local msg = Localization:getInstance():getText("push.surpass.text", {num = levelId})
			local now = os.time()
			local dayStartTime = getDayStartTimeByTS(now)
			local targetTime = nil
			if now > dayStartTime + 10 * 3600 then
				targetTime = dayStartTime + 24 * 3600 + 10 * 3600
			else
				targetTime = dayStartTime + 10 * 3600
			end
			local http = PushNotifyHttp.new()
			http:load(result, msg, LocalNotificationType.kBeyondFriendAtTopLevel, targetTime * 1000)
		end
	end
end

function LocalNotificationManager:setLeaveNotification(leaveType)
	if RecallManager.getInstance():getLevelStayState() then 
		local todayTime = getDayStartTimeByTS(os.time())
		local timeDelta = 12 * 3600
		local timeForOneDay = 24 * 3600
		local timeStamp = nil
		local textToShow = nil
		local threeDayTipFlag,sevenDayTipFlag = RecallManager.getInstance():getRecallNotifyTipState()
		local stayForLevel = true
		local currentStayLevel = UserManager:getInstance().user:getTopLevelId()
		if currentStayLevel%15==0 then 
			local scoreOfLevel = UserManager.getInstance():getUserScore(currentStayLevel)
			if scoreOfLevel then
				if scoreOfLevel.star ~= 0 then 
					stayForLevel = false
				end
			end
		end
		if leaveType == LocalNotificationType.kLeaveForThree then
			timeStamp = todayTime + 3 * timeForOneDay + timeDelta
			if threeDayTipFlag then 
				if stayForLevel then 
					textToShow = "notification_recall_checkpoint_day3_1" 
				else
					textToShow = "notification_recall_area_day3_1"
				end
			else
				if stayForLevel then 
					textToShow = "notification_recall_checkpoint_day3_2" 
				else
					textToShow = "notification_recall_area_day3_2"
				end
			end
		elseif leaveType == LocalNotificationType.kLeaveForFive then
			timeStamp = todayTime + 7 * timeForOneDay + timeDelta
			if stayForLevel then 
				textToShow = "notification_recall_checkpoint_day5" 
			else
				textToShow = "notification_recall_area_day5"
			end
		elseif leaveType == LocalNotificationType.kLeaveForSeven then 
			timeStamp = todayTime + 10 * timeForOneDay + timeDelta
			if sevenDayTipFlag then 
				if stayForLevel then 
					textToShow = "notification_recall_checkpoint_day7_1" 
				else
					textToShow = "notification_recall_area_day7_1"
				end
			else
				if stayForLevel then 
					textToShow = "notification_recall_checkpoint_day7_2" 
				else
					textToShow = "notification_recall_area_day7_2"
				end
			end
		end

		if timeStamp then 
			if not self:getNotiByDayAndType(timeStamp, leaveType) then
				he_log_info("LocalNotificationManager*****timeStamp==="..timeStamp.."   leaveType==="..leaveType)
				self:addNotify(leaveType, timeStamp, Localization:getInstance():getText(textToShow), "action")	
			end
		end
	end
end

function LocalNotificationManager:cancelLeaveNotification(leaveType)
	local sameTypeNoti = self:getNotiByType(leaveType)
	if #sameTypeNoti > 0 then
		for i,v in ipairs(sameTypeNoti) do
			self:deleteNotify(v)
		end
		self:flushToStorage()
	end
end

function LocalNotificationManager:setAllLeaveNotification()
	self:cancelAllLeaveNotification()
	self:setLeaveNotification(LocalNotificationType.kLeaveForThree)
	self:setLeaveNotification(LocalNotificationType.kLeaveForFive)
	self:setLeaveNotification(LocalNotificationType.kLeaveForSeven)
end

function LocalNotificationManager:cancelAllLeaveNotification()
	self:cancelLeaveNotification(LocalNotificationType.kLeaveForThree)
	self:cancelLeaveNotification(LocalNotificationType.kLeaveForFive)
	self:cancelLeaveNotification(LocalNotificationType.kLeaveForSeven)
end

function LocalNotificationManager:pocessRecallNotification()
	--这个参数从配置读取
	local needRecallNotify = MaintenanceManager:getInstance():isEnabled("RecallNotify");
	if needRecallNotify then 
		he_log_info("LocalNotificationManager********setAllLeaveNotification()")
		self:setAllLeaveNotification()
	else
		he_log_info("LocalNotificationManager********cancelAllLeaveNotification()")
		self:cancelAllLeaveNotification()
	end
end