DcUtil = {}

AcType = table.const {
  kInstall = 11,
  kDnu = 1,
  kDau = 2,
  kOnline = 104,
  kUp = 5,
  kReg = 6,
  kActive = 7,
  kPromotion = 13,
  kTutorialStep = 15,
  kTutorialFinish = 3,
  kVirtualGoods = 71,
  kCreateCoin = 72,
  kUseItem = 103,
  kRewardItem = 102,
  kLevelUp = 4,
  kFirstLevel = 98,
  kBeforeWin = 99,
  kIngame = 9,
  kUserTrack = 101,
  kViralSend = 87,
  kViralArrival = 88,
  kViralActivate = 89,
  kFuuu = 100,
  kActivity = 109,
  kUserInfo = 900, --用户画像基础数据点
  kQQUserFri = 909, --用户画像腾讯好友关系链
  kOPLog = 1003, -- oplog打点
  kExposure = 1002, --曝光点
}

local subAcTypes = {AcType.kInstall, AcType.kDnu, AcType.kUp, AcType.kActive, AcType.kReg}

local metaInfo = MetaInfo:getInstance()
local startTime = nil
local viralId = nil
local isNew = 0
local equipment = "nocrack"
local idfa = ""
local serialNumber = metaInfo:getDeviceSerialNumber()
local androidId = metaInfo:getUdid()
local platformName = StartupConfig:getInstance():getPlatformName()
local googleAid = ""
local subPlatform = nil;

local function getServer()
	if StartupConfig:getInstance():getServer() ~= "0" then
		subPlatform = StartupConfig:getInstance():getServer()
	end
end
pcall(getServer)

local function getApkSource()
	if __ANDROID then
		local MainActivityHolder = luajava.bindClass("com.happyelements.android.MainActivityHolder")
		local ApplicationHelper = luajava.bindClass("com.happyelements.android.ApplicationHelper")
		local context = MainActivityHolder.ACTIVITY:getContext()
		if ApplicationHelper.getApkSource then
  			local comment = ApplicationHelper:getApkSource(context)
  			if comment then
  				subPlatform = HeDisplayUtil:urlEncode(comment)
			end
		end
	end
end
if not subPlatform then
	pcall(getApkSource)
end

local function getChinaMobileChannelId()
	if __ANDROID then
		local MainActivityHolder = luajava.bindClass("com.happyelements.android.MainActivityHolder")
		local IAPPayment = luajava.bindClass("com.happyelements.android.operatorpayment.iap.IAPPayment")
		local context = MainActivityHolder.ACTIVITY:getContext()
		if IAPPayment.loadChannelID then
			subPlatform = IAPPayment:loadChannelID(context)
		end
	end
end
if not subPlatform  and platformName == "cmccmm" then
	pcall(getChinaMobileChannelId)
end

if __IOS then 
	idfa = AppController:getAdvertisingIdentifier() or "" 
end
if metaInfo:isJailbreak() then
	equipment = "crack"
end
if metaInfo:isNewInstalled() then
  isNew = 1
end

-- percent: 0到100
local function isSample(percent)
	if isLocalDevelopMode then return true end
	local uuid = MetaInfo:getInstance():getUdid()
	local tail = string.sub(string.lower(uuid), -4)
	local tailInt = tonumber(tail, 16)
	local fullRange = math.pow(16, 4)
	local sampleRange = math.floor(fullRange * (percent / 100))
	if tailInt and type(tailInt) == "number" and tailInt <= sampleRange then
		return true
	else
		return false
	end
end

local function dc_log_send(acType, data)
	if PrepackageUtil:isPreNoNetWork() then return end
	
	data.platform = platformName
	if not table.indexOf(subAcTypes, acType) then
		data.level = UserManager:getInstance().user:getTopLevelId()
		data.star = UserManager:getInstance().user:getStar()
	end

	if subPlatform then
		data.sub_platform = subPlatform
	end

	table.each(data, function (v, k)
	if (type(v) ~= "string") then
		data[k] = tostring(v)
	end
	end)
	HeDCLog:getInstance():send(acType, data)
end

-- doSampling: 是否是概率打点（抽样） 概率10%
local function send(acType, data, doSampling)
	if not doSampling then
		doSampling = false
	end
	if doSampling then
		if isSample(10) then
			if data.sub_category then
				data.sub_category = 'G_'..data.sub_category
			end
			dc_log_send(acType, data)
		else
			return
		end
	else
		dc_log_send(acType, data)
	end
end

function DcUtil:getSubPlatform()
	return subPlatform
end

--激活打点
function DcUtil:install()
	if metaInfo:isNewInstalled() then
		send(AcType.kInstall, {
			equipment = equipment,
			install_key = metaInfo:getInstallKey(),
			category = "first_open",
			idfa = idfa,
			serial_number = serialNumber,
			android_id  = androidId,
			google_aid = googleAid,
			})
		if subPlatform then
			DcUtil:active(subPlatform)
		end
	end
end

--广告激活打点
function DcUtil:active(channel_id)
	send(AcType.kActive, {
		install_key = metaInfo:getInstallKey(),
		idfa = idfa,
		serial_number = serialNumber,
		android_id  = androidId,
		google_aid = googleAid,
		channel_id = channel_id,
		})
end

--广告注册打点
function DcUtil:reg(channel_id)
	send(AcType.kReg, {
		install_key = metaInfo:getInstallKey(),
		idfa = idfa,
		serial_number = serialNumber,
		android_id  = androidId,
		google_aid = googleAid,
		channel_id = channel_id,
		})
end

--新用户打点
function DcUtil:newUser()
	send(AcType.kDnu, {
		equipment = equipment,
		networktype = metaInfo:getNetworkInfo(),
		carrier = metaInfo:getNetOperatorName(),
		install_key = metaInfo:getInstallKey(),
		idfa = idfa,
		serial_number = serialNumber,
		android_id  = androidId,
		google_aid = googleAid,
		md5 = ResourceLoader.getCurVersion(),
		imei = metaInfo:getImei(),
		imsi = metaInfo:getImsi(),
		})
	if subPlatform then
		DcUtil:reg(subPlatform)
	end
end

--登陆打点
function DcUtil:dailyUser()
	local data = {
		equipment = equipment,
		networktype = metaInfo:getNetworkInfo(),
		carrier = metaInfo:getNetOperatorName(),
		install_key = metaInfo:getInstallKey(),
		idfa = idfa,
		serial_number = serialNumber,
		android_id  = androidId,
		google_aid = googleAid,
		md5 = ResourceLoader.getCurVersion(),
		imei = metaInfo:getImei(),
		imsi = metaInfo:getImsi(),
	}

	if _G.sns_token and _G.sns_token.openId then 
		local pfName = PlatformConfig:getPlatformAuthName()
		if pfName then
			data.sns_id = pfName .. "_" .. _G.sns_token.openId
		else
			data.sns_id = _G.sns_token.openId
		end
	end
	
	send(AcType.kDau,data)

end

local function getAchiString()
	local achiConfig = AchievementManager:getConfigs()
	local allAchi = {}
	for id,config in pairs(achiConfig) do
		if config.achievementType ~= AchievementManager.achievementType.SHARE then
			table.insert(allAchi, id)
		end
	end

	table.sort(allAchi)

	local reachedAchis = AchievementManager:getAchievements()

	local str = ""

	for index,id in ipairs(allAchi) do
		local achi = reachedAchis[id]
		local isReached = achi and (achi.level and achi.level > 0)
		str = str .. (isReached and "1" or "0")
	end

	return str
end

--ingame打点
function DcUtil:logInGame()
	send(AcType.kIngame, {
		is_new = isNew,
		happy_coin = UserManager:getInstance().user:getCash(),
		game_coin = UserManager:getInstance().user:getCoin(),
		energy = UserManager:getInstance().user:getEnergy(),
		friend_num = #UserManager:getInstance().friendIds,
		google_aid = googleAid,
		item_id_10011 = UserManager:getInstance():getUserPropNumber(10011),
		item_id_10004 = UserManager:getInstance():getUserPropNumber(10004),
		item_id_10001 = UserManager:getInstance():getUserPropNumber(10001),
		item_id_10010 = UserManager:getInstance():getUserPropNumber(10010),
		item_id_10012 = UserManager:getInstance():getUserPropNumber(10012),
		item_id_10013 = UserManager:getInstance():getUserPropNumber(10013),
		item_id_10014 = UserManager:getInstance():getUserPropNumber(10014),
		item_id_10002 = UserManager:getInstance():getUserPropNumber(10002),
		item_id_10003 = UserManager:getInstance():getUserPropNumber(10003),
		item_id_10005 = UserManager:getInstance():getUserPropNumber(10005),
		item_id_10058 = UserManager:getInstance():getUserTimePropNumber(10058),
		item_id_10059 = UserManager:getInstance():getUserTimePropNumber(10059),
		item_id_10060 = UserManager:getInstance():getUserTimePropNumber(10060),
		item_id_10061 = UserManager:getInstance():getUserTimePropNumber(10061),
		item_id_10062 = UserManager:getInstance():getUserTimePropNumber(10062),
		item_id_10063 = UserManager:getInstance():getUserTimePropNumber(10063),
		itme_id_10064 = UserManager:getInstance():getUserTimePropNumber(10064),
		tree_level = FruitTreePanelModel:sharedInstance():getTreeLevel(),
		level = UserManager:getInstance().user:getTopLevelId(),
		have_skip = #UserManager.getInstance():getJumpLevelInfo() > 0,
		Achievement_anarchy = getAchiString(),
		Achievement_level = AchievementManager:getTotalScore(),
		})
end

--每五分钟调用一次
function DcUtil:online()
	send(AcType.kOnline, {
		equipment = equipment,
		networktype = metaInfo:getNetworkInfo(),
		})
end

--公司游戏内部推广
function DcUtil:promotion(category, channelId)
	send(AcType.kPromotion, {
		category = category,
		channel_id = channelId,
		idfa = idfa,
		})
end

--新手引导第step步完成
function DcUtil:tutorialStep(step)
	send(AcType.kTutorialStep, {
		step = step,
		})
end

--新手引导完成
function DcUtil:tutorialFinish()
	send(AcType.kTutorialFinish, {})
end

--加载转化打点
function DcUtil:up(step)
	if not startTime then
		startTime = os.time()
		viralId = metaInfo:getInstallKey() .. "_" .. startTime
	end
	send(AcType.kUp, {
		viral_id = viralId,
		step = step,
		is_new = isNew,
		interval = (os.time() - startTime) * 1000,
		install_key = metaInfo:getInstallKey(),
		})
end

--用银币购买物品
function DcUtil:logSilverCoinBuy(goodsId, cost, num, coin2, currentStage)
	
	send(AcType.kVirtualGoods, {
		category = 1,
		item_id = goodsId,
		item_name = goodsId,
		cost = cost,
		num = num,
		coin1 = coin2 + cost * num,
		coin2 = coin2,
		currency = "game coins",
		current_stage = currentStage,
		stage_mode = math.floor(currentStage / 10000),
		high_stage = UserManager:getInstance().user:getTopLevelId(),
		})
end

--用风车币购买道具
function DcUtil:logHappyCoinBuy(goodsId, cost, num, coin2, currentStage)
	local data = {
		category = 2,
		item_id = goodsId,
		item_name = goodsId,
		cost = cost,
		num = num,
		coin1 = coin2 + cost * num,
		coin2 = coin2,
		currency = "happy coins",
		current_stage = currentStage,
		stage_mode = math.floor(currentStage / 10000),
		high_stage = UserManager:getInstance().user:getTopLevelId(),
	}

	send(AcType.kVirtualGoods,data)
end

--用rmb买道具或风车币
function DcUtil:logRmbBuy(goodsId, goodsType, cost, num, currentStage)
	local data = {
		category = 2,
		item_id = goodsId,
		item_name = goodsId,
		item_type = goodsType,
		cost = cost,
		num = num,
		currency = "rmb coins",
		current_stage = currentStage,
		stage_mode = math.floor(currentStage / 10000),
		high_stage = UserManager:getInstance().user:getTopLevelId(),
	}

	send(AcType.kVirtualGoods,data)
end

--用户获取银币
function DcUtil:logCreateCoin(module, num, coin, currentStage)
	send(AcType.kCreateCoin, {
		module = module,
		num = num,
		coin1 = coin,
		coin2 = coin + num,
		num = num,
		currency = "game coins",
		current_stage = currentStage,
		stage_mode = math.floor(currentStage / 10000),
		high_stage = UserManager:getInstance().user:getTopLevelId(),
		})
end

--用户获取风车币
function DcUtil:logCreateCash(module, num, cash, currentStage)
	send(AcType.kCreateCoin, {
		module = module,
		num = num,
		coin1 = cash,
		coin2 = cash + num,
		num = num,
		currency = "happy coins",
		current_stage = currentStage,
		stage_mode = math.floor(currentStage / 10000),
		high_stage = UserManager:getInstance().user:getTopLevelId(),
		})
end

--用户使用道具
function DcUtil:logUseItem(itemId, num, currentStage)
	local stageMode = math.floor(currentStage / 10000)
	local missionId = nil
	if MissionManager then
		local missionIds = MissionManager:getInstance():getMissionIdOnLevel(currentStage)

		if missionIds and #missionIds > 0 then
			missionId = missionIds[1]
		end
	end

	send(AcType.kUseItem, {
		category = itemId,
		item_id = itemId,
		item_name = itemId,
		num = num,
		use = stageMode,
		current_stage = currentStage,
		stage_mode = stageMode,
		high_stage = UserManager:getInstance().user:getTopLevelId(),
		mission_id = missionId,--表示该关卡是否为一个任务关，如果mission_id不为nil则表示是任务关
		})
end

--获得物品
function DcUtil:logRewardItem(source, itemId, num, currentStage)
	send(AcType.kRewardItem, {
		category = itemId,
		source = source,
		item_id = itemId,
		num = num,
		current_stage = currentStage,
		stage_mode = math.floor(currentStage / 10000),
		high_stage = UserManager:getInstance().user:getTopLevelId(),
		})
end

--用户升级
function DcUtil:logLevelUp(level)
	send(AcType.kLevelUp, {
		lv1 = level - 1,
		lv2 = level,
		module = "level",
		source = "level",
		})
end

--首次闯关
function DcUtil:logFirstLevelGame(currentStage, stageMode, win, useItem, stageTime, gemCount)
	local result = 0;
	if win then
		result = 1;
	end
	send(AcType.kFirstLevel, {
		stage_first = "stage_first",
		result = result,
		current_stage = currentStage,
		stage_mode = stageMode,
		use_item = useItem,
		stage_time = stageTime,
		gem_count = gemCount,
		high_stage = UserManager:getInstance().user:getTopLevelId(),
		})
end

--首次闯关前每次闯关
function DcUtil:logBeforeFirstWin(currentStage, stageMode, win, useItem, stageTime, gemCount)
	local result = 0;
	if win then
		result = 1;
	end
	send(AcType.kBeforeWin, {
		stage_first = "stage_first",
		result = result,
		current_stage = currentStage,
		stage_mode = stageMode,
		use_item = useItem,
		stage_time = stageTime,
		gem_count = gemCount,
		high_stage = UserManager:getInstance().user:getTopLevelId(),
		})
end

--fb newsfeed
function DcUtil:logSendNewsFeed(type,viral_id,src)
	send(AcType.kViralSend, {
		type = type,
		viral_id = viral_id,
		src = src,
		})
end

--fb sendRequest
function DcUtil:logSendRequest(type,viral_id,src)
	send(AcType.kViralSend, {
		type = type,
		viral_id = viral_id,
		src = src,
		})
end

--launcher from fb
function DcUtil:logViralActivate(type,viral_id,src)
	send(AcType.kViralActivate, {
		type = type,
		viral_id = viral_id,
		src = src,
		})
end

--开始关卡
-- ！！！：概率20%
function DcUtil:logStageStart(currentStage)
	if isSample(20) then
		dc_log_send(AcType.kUserTrack, {
			category = 'stage',
			sub_category = 'stage_start',
			current_stage = currentStage,
			})
	end
end

--结束关卡
function DcUtil:logStageEnd(currentStage, score, star, failReason, stageTime)
	stageTime = stageTime or 0

	local missionId = nil
	if MissionManager then
		local missionIds = MissionManager:getInstance():getMissionIdOnLevel(currentStage)

		if missionIds and #missionIds > 0 then
			missionId = missionIds[1]
		end
	end

	send(AcType.kUserTrack, {
		category = 'stage',
		sub_category = 'stage_end',
		current_stage = currentStage,
		score = score,
		level_star = star,
		fail_reason = failReason,
		stage_time = stageTime,
		mission_id = missionId,
		t1 = currentStage
		})
end

--中途退出关卡
function DcUtil:logStageQuit(currentStage, isRestart, leftMoves)
	send(AcType.kUserTrack, {
		category = 'stage',
		sub_category = 'stage_quit',
		restart_level = isRestart,
		current_stage = currentStage,
		left_moves = leftMoves or 0,
		})
end

function DcUtil:logOpLog(levelId, score, stageTime, targetCount, opLog)
	local dcData = {
			levelId=levelId, 
			score=score, 
			stageTime=stageTime,
			targetCount=targetCount,
			opLog = opLog,
			curMd5 = ResourceLoader.getCurVersion(), 	-- game version
			curConfigMd5 = LevelMapManager.getInstance():getLevelUpdateVersion(), -- level update version
		}
	send(AcType.kOPLog, dcData)
end

--新增记录用户主动退出
function DcUtil:newLogUserStageQuit(dcData)
	send(AcType.kFuuu, dcData)
end

--微信发送邀请码
function DcUtil:sendInvitation(invitecode)
	send(AcType.kUserTrack, {
		category = 'wechat',
		sub_category = 'invite',
		invite_code = invitecode
		})
end

--微信过关分享
function DcUtil:shareFeed(source_item,currentStage,share_feed)
	send(AcType.kUserTrack, {
		category = 'wechat',
		sub_category = 'share',
		source = source_item,
		current_stage = currentStage,
		feed = share_feed,
		})
end

--发送加好友请求
function DcUtil:sendInviteRequest(invitecode)
	send(AcType.kUserTrack, {
		category = 'request',
		sub_category = 'invite',
		invite_code = invitecode,
		})
end


--发送请求向好友索要精力
function DcUtil:requestEnergy(friendId,currentStage)
	send(AcType.kUserTrack, {
		category = 'request',
		sub_category = 'energy_ask',
		friend_Id = friendId,
		current_stage = currentStage,
		}, true)
end

--发送邀请解锁云
function DcUtil:requestUnLockCloud(lockCloudId,friendId)
	send(AcType.kUserTrack, {
		category = 'request',
		sub_category = 'unLockCloud',
		lockCloudId = lockCloudId,
		friend_Id = friendId,
		}, true)
end

--接受加好友的邀请
function DcUtil:confirmInvite(friendId)
	send(AcType.kUserTrack, {
		category = 'messageCenter',
		sub_category = 'inviteConfirm',
		friend_Id = friendId,
		})
end

--接受好友精力请求，给好友精力
function DcUtil:energyGive(friendId,itemId)
	send(AcType.kUserTrack, {
		category = 'messageCenter',
		sub_category = 'energy_give',
		friend_Id = friendId,
		item_Id = itemId,
		}, true)
end

--回赠好友精力
function DcUtil:energySendBack(friendId,itemId)
	send(AcType.kUserTrack, {
		category = 'messageCenter',
		sub_category = 'energy_sendBack',
		friend_Id = friendId,
		item_Id = itemId,
		}, true)
end

--确认接受好友赠送精力
function DcUtil:energy_receive(friendId,itemId)
	send(AcType.kUserTrack, {
		category = 'messageCenter',
		sub_category = 'energy_receive',
		friend_Id = friendId,
		item_Id = itemId,
		}, true)
end

--删除好友
function DcUtil:delete(friendId)
	send(AcType.kUserTrack, {
		category = 'messageCenter',
		sub_category = 'delete',
		friend_Id = friendId,
		})
end

--豌豆荚点击邀请
function DcUtil:wdjClick()
	send(AcType.kUserTrack, {
		category = 'wandoujia',
		sub_category = 'click',
		})
end

--豌豆荚邀请完成
function DcUtil:wdjInvite(inviteCount)
	send(AcType.kUserTrack, {
		category = 'wandoujia',
		sub_category = 'invite',
		invite_count = inviteCount,
		})
end

--通过豌豆荚邀请进入
function DcUtil:wdjEnter()
	send(AcType.kUserTrack, {
		category = 'wandoujia',
		sub_category = 'enter',
		})
end


--查找附近的人
function DcUtil:addFriendSearch(itemNum)
	send(AcType.kUserTrack,{
		category = 'add_friend',
		sub_category = 'search',
		item_num = itemNum,
		}, true)
end

--发送添加好友请求
function DcUtil:addFiendNear()
	send(AcType.kUserTrack,{
		category = 'add_friend',
		sub_category = 'add_near',
		}, true)
end

-- 摇一摇
function DcUtil:addFriendShake(itemNum)
	send(AcType.kUserTrack,{
		category = 'add_friend',
		sub_category = 'shake',
		item_num = itemNum,
		}, true)
end

-- 摇一摇好友的申请
function DcUtil:addFriendShakeNear()
	send(AcType.kUserTrack,{
		category = 'add_friend',
		sub_category = 'add_shake',
		}, true)
end

-- 摇一摇两个人互相加为好友
function DcUtil:addFriendShakeConfirm()
	send(AcType.kUserTrack,{
		category = 'add_friend',
		sub_category = 'confim_shake',
		}, true)
end

-- 摇一摇取消重试
function DcUtil:addFriendShakeCancel()
	send(AcType.kUserTrack,{
		category = 'add_friend',
		sub_category = 'cancel_shake',
		}, true)
end

-- 二维码加好友
function DcUtil:addFriendQRCode(type)
	send(AcType.kUserTrack, {
		category = "add_friend",
		sub_category = "add_friend_qrcode",
		type= type,
		}, true)
end

-- 二维码发送到微信（Mitalk）成功
function DcUtil:qrCodeSendToWechatTapped()
	send(AcType.kUserTrack, {
		category = "add_friend",
		sub_category = "add_friend_qrcode_click_send",
		}, true)
end

-- 点击扫码按钮
function DcUtil:qrCodeClickScan()
	send(AcType.kUserTrack, {
		category = "add_friend",
		sub_category = "add_friend_qrcode_click_scan",
		})
end

-- 活动打点
function DcUtil:UserTrack(data, doSampling)
	send(AcType.kUserTrack,data, doSampling)
end

function DcUtil:openCanonPromoPanel()
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'click_prom_warrior_banner',
		})
end

function DcUtil:clickCanonDownload()
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'click_download_warrior',
		})
end

function DcUtil:getCanonReward(id)
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'get_prom_warrior_reward',
		reward_id = id,
		})
end

function DcUtil:weeklyRaceClick(id)
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'click_weekly_race_icon',
		icon_id = id,
		})
end

function DcUtil:weeklyRaceBegin()
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'click_weekly_race_begin_btn'
		})
end

function DcUtil:weeklyRaceInfo(id)
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'click_weekly_race_info',
		info_id = id,
		})
end

function DcUtil:weeklyRaceExceedReward()
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'get_weekly_race_exceed_reward'
		})
end

function DcUtil:weeklyRaceGemReward()
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'get_weekly_race_gem_reward'
		})
end

function DcUtil:weeklyRaceExchangeBtn(id)
		send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'click_weekly_race_exchange_btn',
		click_place = id
		})
end

function DcUtil:weeklyRaceExchangeReward(id)
		send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'get_weekly_race_exchange_reward',
		exchange_id = id
		})
end

function DcUtil:fruitPick(fruitType, fruitLevel, treeLevel)
	send(AcType.kUserTrack,{
		category = 'fruittree',
		sub_category = 'get_fruit',
		fruit_type = fruitType,
		fruit_level = fruitLevel,
		tree_level = treeLevel
		}, true)
end

function DcUtil:fruitRegenerate(fruitType, fruitLevel, treeLevel)
	send(AcType.kUserTrack,{
		category = 'fruittree',
		sub_category = 'drop_fruit',
		fruit_type = fruitType,
		fruit_level = fruitLevel,
		tree_level = treeLevel
		}, true)
end

function DcUtil:fruitSpeed(count, fruitType, fruitLevel, treeLevel)
	send(AcType.kUserTrack,{
		category = 'fruittree',
		sub_category = 'speed_up',
		fruit_type = fruitType,
		fruit_level = fruitLevel,
		tree_level = treeLevel,
		item_num = count
		}, true)
end

function DcUtil:fruitTreeUpgrade(treeLevel)
	send(AcType.kUserTrack,{
		category = 'fruittree',
		sub_category = 'upgrade_tree',
		tree_level = treeLevel
		}, true)
end

function DcUtil:openMeilukePromoPanel()
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'click_prom_meiluke_banner',
		})
end

function DcUtil:clickMeilukeDownload()
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'click_download_meiluke',
		})
end

function DcUtil:getMeilukeReward(id)
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'get_prom_meiluke_reward',
		reward_id = id,
		})
end

function DcUtil:useQixiFreePreProps(id)
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'use_free_pre_props',
		props_id = id,
		})
end

function DcUtil:getQixiReward(id)
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'get_magpie_festival_reward',
		reward_id = id,
		})
end

function DcUtil:collectQixiBird(count)
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'collect_the_magpie',
		num = count,
		})
end

function DcUtil:beginRabbitMatch(levelId)
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'click_rabbit_begin_btn',
		level_id = levelId,
		})
end

function DcUtil:clickRabbitIcon(type)
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'click_rabbit_icon',
		icon_id = type,
		})
end

function DcUtil:clickRabbitInfo()
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'click_rabbit_info',
		})
end

function DcUtil:receiveExceedReward(num)
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'get_rabbit_exceed_reward',
		num = num
		})
end

function DcUtil:receiveMaxReward(reward_id)
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'get_rabbit_max_reward',
		reward_id = reward_id
		})
end

function DcUtil:receiveRabbitDailyReward(levelId, boxIdx)
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'get_rabbit_daily_reward',
		reward_id = boxIdx,
		})
end

function DcUtil:logWeeklyRaceActivity(subCategory, params)
	assert(type(subCategory) == "string")
	local sendDatas = {category = 'weeklyrace', sub_category = subCategory}
	if type(params) == "table" then
		for k, v in pairs(params) do
			sendDatas[k] = v
		end
	end
	-- print("logWeeklyRaceActivity", table.tostring(sendDatas))
	send(AcType.kUserTrack, sendDatas)
end

function DcUtil:clickExchangePanel(clickPlace)
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'weeklyrace',
		click_place = clickPlace
		})
end

function DcUtil:RabbitWeeklyExchangeReward(exchange_id)
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'get_rabbit_exchange_reward',
		exchange_id = exchange_id
		})
end

function DcUtil:levelRabbitNum(level_id, num)
	send(AcType.kUserTrack,{
		category = 'weeklyrace',
		sub_category = 'rabbit_level_max_num',
		level_id = level_id,
		num = num,
		})
end

function DcUtil:pushActivityClick(index)
	send(AcType.kUserTrack, {
		category = "activity",
		sub_category = "click_qukankan"..tostring(index)})
end

function DcUtil:getCDKeyReward( key )
	send(AcType.kUserTrack, {
		category = "cdKey",
		sub_category = "get_cdkey_reward",
		cdkey_content=key
	})
end

function DcUtil:logBuyGoldItem(index, type, doSampling)
	send(AcType.kUserTrack, {
		category = "buy",
		sub_category = "push_button",
		id = index, 
		type1 = type,
	}, doSampling)
end

--点击广告icon
function DcUtil:clickAdVideoIcon()
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'push_ad_icon'
		})
end

-- 点击"观看广告"按钮
function DcUtil:playAdVideoIcon()
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'push_ad_watch'
		})
end

-- 点击"领取奖励"按钮
function DcUtil:getAdVideoReward()
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'push_ad_award'
		})
end

function DcUtil:requestAdVideo( videoId )
	-- body
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'request_ad',
		video_id = videoId
		})
end

function DcUtil:requestSuccessAdVideo( videoId )
	-- body
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'request_ad_success',
		video_id = videoId
		})
end

function DcUtil:requestFailAdVideo( videoId )
	-- body
	send(AcType.kUserTrack,{
		category = 'activity',
		sub_category = 'request_ad_fail',
		video_id = videoId
		})
end

--推送召回的87号点在玩家退出时打不上 导致数据不准 所以typeId为11 12 13不打87号点
--前端87号点BI无法精确统计 不打了
function DcUtil:sendLocalNotify(typeId, timeStamp, numOfTimes)
	-- if typeId == 11 or typeId == 12 or typeId == 13 then 
	-- 	return
	-- end
	-- local userId = UserManager:getInstance().user.uid
	-- if not userId then
	-- 	userId = "12345" 
	-- end
	-- local finalId = userId.."-"..timeStamp.."-"..typeId
	-- send(AcType.kViralSend, {
	-- 	category = 'noti',
	-- 	sub_category = 'noti_send_local',
	-- 	type = "notification",
	-- 	viral_id = finalId,
	-- 	src = "local",
	-- 	num_of_times = numOfTimes,
	-- 	})
end

function DcUtil:logAddFiveSteps(actType , currentStage , buttonType , popType , userType , propId , lastFuuuLogID)
	send(AcType.kUserTrack,{
		category = 'add_5_steps',
		sub_category = actType,
		current_stage  = currentStage,
		button_type = buttonType,
		pop_type = popType,
		user_type = userType,
		prop_id = propId,
		fuuu_id = lastFuuuLogID,
	})

end

function DcUtil:gameFailedFuuu(fuuuLogID , levelId , gameModeType , result , progress , score)
	send(AcType.kUserTrack,{
		category = "stage",
		sub_category = "game_failed_fuuu",
		id  = fuuuLogID,
		currLevel = levelId,
		game_mode = gameModeType,
		result = result,
		progress = progress,
		score = score,
	})
end

--点击主界面上的星星图标
function DcUtil:starIconClick( ... )
	-- body
	send(AcType.kUserTrack, {
		category = 'ui',
		sub_category = 'click_main_ui_star_button',
		})
end

--点击快速选关界面上“查看四星和隐藏关”的小牌子
function DcUtil:fourStarGuideIconClick( ... )
	-- body
	send(AcType.kUserTrack, {
		category = 'ui',
		sub_category = 'click_see_fourstar_and_hidden',
		})
end

--点击四星引导 “炫耀一下”按钮
function DcUtil:shareAllFourStarClick( ... )
	-- body
	send(AcType.kUserTrack, {
		category = 'ui',
		sub_category = 'click_share_all_fourstar',
		})
end

function DcUtil:ladybugOnMainTrunkClick( ... )
	-- body
	send(AcType.kUserTrack, {
		category = 'ui',
		sub_category = 'click_ladybug_on_vine',
		})
end

--点击所有乱七八糟能点的图标
function DcUtil:iconClick(subCategory)
	if not __IOS then return end
	send(AcType.kUserTrack, {
		category = "Ui",
		sub_category = subCategory,
		}, true)
end

function DcUtil:activity( params )
	-- body
	send(AcType.kActivity, params)
end

-- 任务系统创建新任务
function DcUtil:missionLogicCreateMission(missionType)
	send(AcType.kUserTrack, {
		category = "job",
		sub_category = "get_job",
		t1 = missionType,
		})
end

-- 任务系统任务完成
function DcUtil:missionLogicFinishMission(missionType)
	send(AcType.kUserTrack, {
		category = "job",
		sub_category = "finish_job",
		t1 = missionType,
		})
end

-- 任务系统任务被刷新掉
function DcUtil:missionLogicRefreshMission(missionType)
	send(AcType.kUserTrack, {
		category = "job",
		sub_category = "refresh_job",
		t1 = missionType,
		})
end

-- 任务系统任务生成失败
function DcUtil:missionCreateFail(errType)
	send(AcType.kUserTrack, {
		category = "job",
		sub_category = "fail_job",
		id = errType
		})
end

-- 领取精力成功
function DcUtil:timeMachineGetEnergy()
	send(AcType.kUserTrack, {
		category = "activity",
		sub_category = "Time_Machine_get_energy",
		})
end
--播放送精力动画
function DcUtil:timeMachineShowEnergy()
	send(AcType.kUserTrack, {
		category = "activity",
		sub_category = "Time_Machine_show_energy",
		})
end

-- 点击任务系统icon图标按钮
function DcUtil:timeMachineLook(page)
	send(AcType.kUserTrack, {
		category = "activity",
		sub_category = "Time_Machine_look",
		t1 = page
		})
end

-- 点击任务系统icon图标按钮
function DcUtil:timeMachineClickShare()
	send(AcType.kUserTrack, {
		category = "activity",
		sub_category = "Time_Machine_click_share",
		})
end

-- 点击任务系统icon图标按钮
function DcUtil:timeMachineShareSuccess()
	send(AcType.kUserTrack, {
		category = "activity",
		sub_category = "Time_Machine_suc_share",
		})
end

-- 点击任务系统icon图标按钮
function DcUtil:missionIconTapped()
	send(AcType.kUserTrack, {
		category = "job",
		sub_category = "click_icon",
		})
end

-- 周赛点击“发送到微信群”（Mitalk）
function DcUtil:seasonWeeklyShareTapped()
	send(AcType.kUserTrack, {
		category = "weeklyrace",
		sub_category = "weeklyrace_summer_2016_ask_friend",
		})
end

-- 周赛成功发送信息到微信（Mitalk）
function DcUtil:seasonWeeklyShareSucceed()
	send(AcType.kUserTrack, {
		category = "weeklyrace",
		sub_category = "weeklyrace_summer_2016_ask_success",
		})
end

-- 周赛的次数链接，从链接进入游戏
function DcUtil:seasonWeeklyClickLink()
	send(AcType.kUserTrack, {
		category = "weeklyrace",
		sub_category = "weeklyrace_summer_2016_wx",
		})
end

-- 周赛点击炫耀按钮
function DcUtil:clickShareQrCodeBtn(id)
	send(AcType.kUserTrack, {
		category = "weeklyrace",
		sub_category = "weeklyrace_summer_2016_show_bnt",
		id = id,
		})
end

-- 周赛成功分享炫耀图
function DcUtil:doShareQrCodeSuccess(id)
	send(AcType.kUserTrack, {
		category = "weeklyrace",
		sub_category = "weeklyrace_summer_2016_show_succsse",
		id = id,
		})
end

-- 周赛每周排名炫耀点击炫耀按钮
function DcUtil:clickWeeklyRankShareBtn()
	send(AcType.kUserTrack, {
		category = "weeklyrace",
		sub_category = "weeklyrace_summer_2016_share",
		})
end

-- 周赛每周排名炫耀成功分享炫耀图
function DcUtil:doShareWeeklyRankSuccess()
	send(AcType.kUserTrack, {
		category = "weeklyrace",
		sub_category = "weeklyrace_summer_2016_share_success",
		})
end

-- 周赛通过炫耀图二维码进入游戏
function DcUtil:enterGameViaWeeklyRaceQrCode()
	send(AcType.kUserTrack, {
		category = "weeklyrace",
		sub_category = "weeklyrace_summer_2016_ewm",
		})
end

-- 周赛通过扫码或者链接获得的收集物个数
function DcUtil:sendWeeklyRaceItemNum(itemNum)
	send(AcType.kUserTrack, {
		category = "weeklyrace",
		sub_category = "weeklyrace_summer_2016_ewm_gem",
		num = itemNum
		}, true)
end

function DcUtil:loginException(subCategory)
	send(AcType.kUserTrack, {
		category = "Abnormal",
		sub_category = subCategory,
		})
end

function DcUtil:log(acType, data, doSampling)
	send(acType, data, doSampling)
end

function DcUtil:userInfo( data )
	local moreData = {
		carrier = metaInfo:getNetOperatorName(),
	}

	for k,v in pairs(data) do
		moreData[k] = v
	end

	send(AcType.kUserInfo, moreData)
end

function DcUtil:qqUserFri( data )
	local moreData = {
		carrier = metaInfo:getNetOperatorName(),
	}

	for k,v in pairs(data) do
		moreData[k] = v
	end

	send(AcType.kQQUserFri, moreData)
end

function DcUtil:Exposure( data )
	send(AcType.kExposure, data)
end