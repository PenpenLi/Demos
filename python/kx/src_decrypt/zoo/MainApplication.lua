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

local function onApplicationDidEnterBackground()
	print("onApplicationDidEnterBackground")
	local scene = Director:sharedDirector():getRunningScene()
	if scene and scene.onEnterBackground then
		scene:onEnterBackground()
	end

	GamePlayMusicPlayer:getInstance():enterBackground()

	pcall(scheduleLocalNotification)
end

local function onApplicationWillEnterForeground()
	print("onApplicationWillEnterForeground")
	local scene = Director:sharedDirector():getRunningScene()
	if scene and scene.onEnterForeGround then
		print("scene:onEnterForeGround()")
		scene:onEnterForeGround()
	end

	GamePlayMusicPlayer:getInstance():enterForeground()
	
	if _G.kUserLogin then
		DcUtil:dailyUser()
		DcUtil:logInGame()
	end

	LocalNotificationManager.getInstance():cancelAllAndroidNotification()
	LocalNotificationManager.getInstance():validateNotificationTime()
end

_G.launchURL = UrlSchemeSDK.new():getCurrentURL()
local function onApplicationHandleOpenURL()
	local sdk = UrlSchemeSDK.new()
	local launchURL = sdk:getCurrentURL()
	print("onApplicationHandleOpenURL:"..tostring(launchURL))
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
		http:load(profile.name, profile.headUrl)
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

local function isValidPackage()
	local startGameMode = true
	if __ANDROID and not _G.signatured then
		startGameMode = false
	end
	return startGameMode
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
	
	GamePlayMusicPlayer:getInstance():appResume()
end

local function onAppPause()
	print("onAppPause")
	
	GamePlayMusicPlayer:getInstance():appPause()
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
	if isValidPackage() then 
		local PreloadingScene = require("zoo.loader.PreloadingScene")
		Director:sharedDirector():replaceScene(PreloadingScene:create()) 
	else
		popoutInvalidSignatrueAlert()
		return
	end
	
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

return true