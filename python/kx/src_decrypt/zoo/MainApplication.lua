require "hecore.display.Director"
require "hecore.display.ArmatureNode"

require "zoo.util.BigInt"
require "zoo.util.UrlSchemeSDK"
require "zoo.util.ReachabilityUtil"
require "zoo.config.ResourceConfig"
require "zoo.config.NetworkConfig"
require "zoo.util.SignatureUtil"
require "zoo.util.AlertDialogImpl"
require "zoo.data.RecallManager"
require "zoo.data.LocalNotificationManager"
require "zoo.data.WorldSceneShowManager"
require "zoo.gamePlay.GamePlayMusicPlayer"

kWindowFrameRatio = table.const{
	iPhone5 = {name="iPhone5", r=1136/640}, --1.775
	Note2 = {name="Note2", r=1280 / 800}, --1.6
	iPhone4 = {name="iPhone4", r=960/640}, --1.5
	iPad = {name="iPad", r=1024/768}, --1.333333333
}

kGlobalEvents = table.const{
	kSyncFinished = "global.event.sync.done",
	kUserLogin = "global.event.login.done",
	kProfileUpdate = "global.event.profile.change",
	kAcceptFriends = "global.event.messagecenter.friends.accept",
	kMessageCenterUpdate = "global.event.messagecenter.update",
	kGamecenterLogin = "global.event.gc.login",
	kMaintenanceChange = "global.event.maintenance",
	kConsumeComplete = "global.event.consume.complete",
	kDefaultPaymentTypeAutoChange = "global.event.defaultpayment.auto.change",
	kEnterForeground = "global.event.enter.foreground",
	kActivityLevelShare = "global.event.activity.level.share",
	kShowReplayRecordPreview = "global.event.replay.preview.show",
	kAliSignAndPayReturn = 'global.event.ali.sign.pay.return',
	kWechatSignReturn = 'global.event.wechat.sign.return',
}

local function scheduleLocalNotification()
	local enable = CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification")
	local fullEnergyTime = UserService:getInstance():computeFullEnergyTime()
	--print("enable"..tostring(enable)..fullEnergyTime)
	if enable and fullEnergyTime > 0 then
		local body = Localization:getInstance():getText("message.center.notif.goback")
		local action = Localization:getInstance():getText("message.center.notif.back.btn")

		if __IOS then			
			WeChatProxy:scheduleLocalNotification_alertBody_alertAction(fullEnergyTime, body, action)
		end
		if __ANDROID then
			if PrepackageUtil:isPreNoNetWork() then return end
			local notificationUtil = luajava.bindClass("com.happyelements.hellolua.share.NotificationUtil")
			notificationUtil:addLocalNotification(fullEnergyTime, body, tostring(LocalNotificationType.kEnergyFull))
		end
		if __WP8 then
			Wp8Utils:scheduleLocalNotification(fullEnergyTime, action, body)
		end
	end

	RecallManager.getInstance():updateRecallInfo()
	LocalNotificationManager.getInstance():pocessRecallNotification()
	LocalNotificationManager.getInstance():validateNotificationTime()
	LocalNotificationManager.getInstance():pushAllNotifications()
end

_G.inBackgroundElapsedSeconds = 0
local enterBackgruondStartTime = 0
local function onApplicationDidEnterBackground()
	print("onApplicationDidEnterBackground")
	local scene = Director:sharedDirector():getRunningScene()
	if scene and scene.onEnterBackground then
		scene:onEnterBackground()
	end

	if _G.kResourceLoadComplete then
		GamePlayMusicPlayer:getInstance():enterBackground()
	end

	--微信sdk没登录的情况下返回没回调
	if _G.WeChatSDK then
		WeChatSDK:removeLoading()
	end
	enterBackgruondStartTime = os.time()
	pcall(scheduleLocalNotification)
end


local function onApplicationWillEnterForeground()
	print("wenkan onApplicationWillEnterForeground")
	local scene = Director:sharedDirector():getRunningScene()

	if scene then 
		local popoutPanel = PopoutManager:sharedInstance():getLastPopoutPanel()
		if popoutPanel and type(popoutPanel.onEnterForeGround) == "function" then
			popoutPanel:onEnterForeGround()
		end
	end

	if scene and scene.onEnterForeGround then
		print("scene:onEnterForeGround()")
		scene:onEnterForeGround()
	end

	if _G.kResourceLoadComplete then
		GamePlayMusicPlayer:getInstance():enterForeground()
	end

	if _G.kUserLogin then
		DcUtil:dailyUser()
		DcUtil:logInGame()
	end

	LocalNotificationManager.getInstance():cancelAllAndroidNotification()
	LocalNotificationManager.getInstance():validateNotificationTime()
	_G.inBackgroundElapsedSeconds = os.time() - enterBackgruondStartTime

	GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kEnterForeground))

	SupperAppManager:checkData()

	-- 1秒之内收不到openUrl事件，才认为支付取消
	local function onAppPaymentReturn()
		if __ANDROID and AliAppSignAndPayLogic then
			if AliAppSignAndPayLogic:getInstance():isWaitingAliApp() then
				GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kAliSignAndPayReturn, {url = 'happyanimal3://aliapp_return/redirect'}))
			end
		end
		if __ANDROID and WechatQuickPayLogic then
			if WechatQuickPayLogic:getInstance():isWaitingWechatApp() then
				GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kWechatSignReturn))
			end
		end
	end
	setTimeOut(onAppPaymentReturn, 1)

	print("onApplicationWillEnterForeground: "..tostring(inBackgroundElapsedSeconds))
end

_G.launchURL = UrlSchemeSDK.new():getCurrentURL()
local function onApplicationHandleOpenURL()
	local sdk = UrlSchemeSDK.new()
	local launchURL = sdk:getCurrentURL()
	print("onApplicationHandleOpenURL:"..tostring(launchURL))
	if launchURL and string.starts(launchURL, 'happyanimal3://aliapp_return/redirect') then
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kAliSignAndPayReturn, {url = launchURL}))
		return
	end

	-- 周赛链接不再传递，直接处理
	if launchURL and string.starts(launchURL, 'happyanimal3://week_match/redirect') then
		local scene = Director:sharedDirector():getRunningScene()
		local PreloadingScene = require("zoo.loader.PreloadingScene")
		if scene and not scene:is(GamePlaySceneUI) and not scene:is(PreloadingScene) then
			local res = UrlParser:parseUrlScheme(launchURL)
			if res and res.para and type(res.para) == "table" and res.para.action then 
				local function startLogic()
					local function onTimeout()
						require "zoo.panelBusLogic.SeasonWeeklyMatchHelpLogic"
						SeasonWeeklyMatchHelpLogic:startWithConfig(res.para)
					end
					scene:runAction(CCCallFunc:create(onTimeout))
				end
				RequireNetworkAlert:callFuncWithLogged(startLogic, nil, kRequireNetworkAlertAnimation.kNoAnimation)
				return
			end
		end
	end
	local scene = Director:sharedDirector():getRunningScene()
	if scene and scene.onApplicationHandleOpenURL then
		print("scene:onApplicationHandleOpenURL()")
		scene:onApplicationHandleOpenURL(launchURL)
	end
end

local function onApplicationHandleFBOpenURL()
	local dict = AppController:getOpenURLDict()
	if dict and dict.type and dict.fb_action_ids and dict.fb_action_types then 
		DcUtil:logViralActivate(dict.type,dict.fb_action_ids,dict.fb_action_types)
	else 
		print("onApplicationHandleFBOpenURL false") 
	end
end

local function onUserLogin( event )
	local profile = UserManager.getInstance().profile

	local displayName = CCUserDefault:sharedUserDefault():getStringForKey("game.devicename.userinput")
	if profile and displayName and displayName ~= "" and not profile:haveName() then
		local http = UpdateProfileHttp.new()
		profile:setDisplayName(displayName)

        local snsPlatform = nil
        local snsName = nil
        local authorizeType = SnsProxy:getAuthorizeType()
        if _G.sns_token then
            snsPlatform = PlatformConfig:getPlatformAuthName(authorizeType)
            if authorizeType ~= PlatformAuthEnum.kPhone then
                snsName = profile:getDisplayName()
            else
                snsName = Localhost:getLastLoginPhoneNumber()
            end

           	profile:setSnsInfo(authorizeType,snsName,profile:getDisplayName(),profile.headUrl)
        end

		http:load(profile.name, profile.headUrl,snsPlatform,HeDisplayUtil:urlEncode(snsName))
	end
end

local function calculateFrameRatio()
	local frame = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	local currentRatio = frame.height/frame.width
	local selectedRatio = 1.6
	local selectedRatioKey = "Note2"
	for k,v in pairs(kWindowFrameRatio) do
		local curDiff = math.abs(v.r - currentRatio)
		local selDiff = math.abs(v.r - selectedRatio)
		if curDiff < selDiff then 
			selectedRatio = v.r
			selectedRatioKey = v.name
		end
	end
	_G.__frame_ratio = selectedRatio
	_G.__frame_key = selectedRatioKey
	print("Frame Ratio: "..tostring(_G.__frame_key).." small res:"..tostring(_G.__use_small_res))
end

local function popoutInvalidSignatrueAlert()
	local function onTouchRedirectButton()
		luajava.bindClass("com.happyelements.android.utils.HttpUtil"):openUri("http://xxl.happyelements.com/")
		Director.sharedDirector():exitGame()
	end
	AlertDialogImpl:alert( "ERROR!", Localization:getInstance():getText("update.panel.unsigned.apk"), 
		Localization:getInstance():getText("button.ok"), nil, onTouchRedirectButton, nil, onTouchRedirectButton)
end

local function onAppResume()
	print("onAppResume")
	
	if _G.kResourceLoadComplete then
		GamePlayMusicPlayer:getInstance():appResume()
		SupperAppManager:checkData()
	end
end

local function onAppPause()
	print("onAppPause")
	
	if _G.kResourceLoadComplete then
		GamePlayMusicPlayer:getInstance():appPause()
	end
end

local function registerNotificationHandler()
	local function handleNotificationCenter( eventType )
		if eventType == "APP_ENTER_BACKGROUND" then onApplicationDidEnterBackground()
		elseif eventType == "APP_ENTER_FOREGROUND" then onApplicationWillEnterForeground()
		elseif eventType == "APP_OPEN_URL" then onApplicationHandleOpenURL()
		elseif eventType == "FB_OPEN_URL" then onApplicationHandleFBOpenURL()
		elseif eventType == "APP_RESUMED" then onAppResume()
		elseif eventType == "APP_PAUSE" then onAppPause()
		else
			print("Warning: Unhandled Notification, event type:", eventType)
		end
	end
	CCNotificationCenter:sharedNotificationCenter():registerScriptObserver(handleNotificationCenter)
end

__IS_TOTAY_FIRST_LOGIN = false;

local function runGame()
	print("runGame()")
	math.randomseed( os.time() )
	
	_G.kDeviceID = UdidUtil:getUdid()
	
	calculateFrameRatio()
	if __ANDROID then
		GspProxy:init()
	end
	local PreloadingScene = require("zoo.loader.PreloadingScene")
	Director:sharedDirector():replaceScene(PreloadingScene:create()) 
	
	registerNotificationHandler()
	
	GlobalEventDispatcher:getInstance():addEventListener(kGlobalEvents.kUserLogin, onUserLogin)

	if __IOS then
		require "zoo.util.IosPayment"
		IosPayment:registerCallback();
	end

	local function dcOnline()
		DcUtil:online()
	end
	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(dcOnline, 300, false)

	local date = os.date('*t', Localhost:time() / 1000)
    local dateKey = string.format('%d.%d.%d', date.year, date.month, date.day)
    __IS_TOTAY_FIRST_LOGIN = not CCUserDefault:sharedUserDefault():getBoolForKey(dateKey);
    if __IS_TOTAY_FIRST_LOGIN then
    	CCUserDefault:sharedUserDefault():setBoolForKey(dateKey, true)
    	CCUserDefault:sharedUserDefault():flush();
    end
    print("__IS_TOTAY_FIRST_LOGIN: ", __IS_TOTAY_FIRST_LOGIN);
end

runGame()

if __WP8 then 
  Wp8Utils:AskForLockScreenSet(1)
  Wp8Utils:TryCreateHomeLink(2)
end

if __ANDROID then 
    local function startGcnAlarm()
        local MainActivity = luajava.bindClass("com.happyelements.hellolua.MainActivity")
        MainActivity:startGcnAlarm()
    end
    if not PrepackageUtil:isPreNoNetWork() then
        pcall(startGcnAlarm)
    end

    --防破解
    if HeGame:getValid() == false then
    	LocalhostDirector:showPanel()
    end
end
return true