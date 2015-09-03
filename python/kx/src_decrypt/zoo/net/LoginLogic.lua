require "hecore.EventDispatcher"

require "zoo.data.UserManager"
require "zoo.net.Http"
require "zoo.net.OnlineSetterHttp"
require "zoo.net.OnlineGetterHttp"
require "zoo.net.OfflineHttp"
require "zoo.net.Localhost"
require "zoo.net.UserService"

assert(not LoginLogic)

LoginLogic = class(EventDispatcher)
kUserDataStatus = {kOnlineServerData=1, kOnlineLocalData=2, kOfflineOldData=3, kOfflineNewData=4}
function LoginLogic:execute(userId, sessionKey, platform, timeout)
	self.timeout = timeout or 10 --todo: change default timeout.
	if userId == nil then self:onLoadingError()
	else self:connect(userId, sessionKey, platform) end
end

function LoginLogic:logout()
	UserManager.getInstance().uid = nil
	UserManager.getInstance().sessionKey = nil
	Localhost.getInstance():setLastLoginUserConfig(0, nil, UserManager.getInstance().platform) 
end

function LoginLogic:connect(userId, sessionKey, platform)
	print("starting login: userId:", userId, sessionKey, platform)

	UserManager.getInstance().uid = userId
	UserManager.getInstance().sessionKey = sessionKey
	UserManager.getInstance().platform = platform

	if __IOS then
		GspEnvironment:getInstance():setGameUserId(tostring(userId))
	elseif __ANDROID then 
		GspProxy:setGameUserId(tostring(userId)) 
	end
	HeGameDefault:setUserId(tostring(userId))

	Localhost.getInstance():setLastLoginUserConfig(userId, sessionKey, platform)
	ConnectionManager:reset(userId, sessionKey)
	--login to our game server
	self:login()
end

--about login:
--IF LOGIN to server suceed, which means online, then get new user information from server, override the low level data.
--ELSE if failed, whick means offline or server down, just enter the offline mode.

--WHEN IT IS OFFLINE mode, if there is no local cached user data, create a new user.
--ELSE use the cached local data.
function LoginLogic:login()
	local context = self
	local isNotTimeout = true
	local timeoutID = nil
	local function stopTimeout()
		if timeoutID ~= nil then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timeoutID) end
		print("stop timeout check")
		timeoutID = nil
	end 
	local function onLoginError( evt )
		evt.target:removeAllEventListeners()
		stopTimeout()
		if isNotTimeout then context:onLoadingError()			
		else print("onLoginError callback after timeout") end
	end
	local function onLoginFinish( evt )
		DcUtil:up(140)
		_G.kUserLogin = true
		if type(evt.data) == "table" and type(evt.data.lastSeq) == "number" then
			UserService:getInstance():setSyncSerial(evt.data.lastSeq)
		end
		evt.target:removeAllEventListeners()
		stopTimeout()
		if isNotTimeout then context:getUserInfo() 
		else print("onLoginFinish callback after timeout") end
	end 

	local timeConfig = Localhost:getDefaultConfig()
  	_G.__g_utcDiffSeconds = timeConfig.td or 0
	
	local http = LoginHttp.new()
	http:addEventListener(Events.kComplete, onLoginFinish)
	http:addEventListener(Events.kError, onLoginError)
	http:load()

	local function onLoginTimeout()
		print("timeout @ LoginLogic:login " .. " time: (s)" .. self.timeout)
		stopTimeout()
		isNotTimeout = false
		context:onLoadingError()
	end
	timeoutID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onLoginTimeout,self.timeout,false)
end

--sync 
local function onCachedHttpDataResponse(endpoint, resp, err)
	if err then he_log_warning("onCachedHttpDataResponse data fail, err: " .. err)
	else he_log_warning("onCachedHttpDataResponse data success") end
end

function LoginLogic:readUserSyncDataFromLocal()
	-- cached data from local file is always update data as UserService saved, it's slower, but have the same effect as UserService did.
	-- thus we have a common way to deal with Login and Post Login logic.
	local list = {}
	local cachedLocalUserData = Localhost.getInstance():readCurrentUserData()
	if (cachedLocalUserData and cachedLocalUserData.user == nil) or cachedLocalUserData == nil then
		--as user registered, we have their real user id now, so delete the data use device id as user id 
		cachedLocalUserData = Localhost.getInstance():readUserDataByUserID(_G.kDeviceID)
		if cachedLocalUserData and cachedLocalUserData.user then 
			cachedLocalUserData.user.user.uid = UserManager.getInstance().uid
			Localhost.getInstance():deleteUserDataByUserID(_G.kDeviceID) 
		end
	end
	if cachedLocalUserData and cachedLocalUserData.user and cachedLocalUserData.user.user then
		local httpData = cachedLocalUserData.user.httpData or {}
		local ingameHttpData = cachedLocalUserData.user.ingameHttpData or {}
		local syncSerial = UserService:getInstance():getSyncSerial()
		if __WP8 then
			for i, element in ipairs(ingameHttpData) do
				if element then table.insert(list, element) end
			end
		end
		for i,element in ipairs(httpData) do
			if element then
				if type(element.body) == "table" then
					local ss = element.body.seq
					if type(ss) == "number" then
						if type(syncSerial) ~= "number" then
							syncSerial = ss
						elseif element.body.seq > syncSerial then syncSerial = element.body.seq end
					else
						if type(syncSerial) == "number" then
							syncSerial = syncSerial + 1
							element.body.seq = syncSerial
						end
					end
				end
				UserService:getInstance():setSyncSerial(syncSerial)
				table.insert(list, element)
			end
		end
		Localhost:flushSelectedUserData( cachedLocalUserData )
	else print("sync: new user, no local data found") end
	return cachedLocalUserData, list
end

function LoginLogic:sync()
	local context = self
	local isNotTimeout = true
	local timeoutID = nil
	local function stopTimeout()
		if timeoutID ~= nil then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timeoutID) end
		print("stop timeout check")
		timeoutID = nil
	end 

	local cachedLocalUserData, list = LoginLogic:readUserSyncDataFromLocal()
	local function onUserCallback( endpoint, resp, err )
		stopTimeout()

		--print("onUserCallback", table.tostring(resp))
		if err then he_log_info("onUserCallback fail, err: " .. err)
	    else he_log_info("onUserCallback success") end
		
		if isNotTimeout then
			if err then 
				print("sync err"..tostring(err))
				local errorCode = tonumber(err) or -1
				local function onUseLocalFunc()
					print("player choose local data (wrong data)")
					context:onLoadingError()
				end
				local function onUseServerFunc()
					print("player clear local data and retry")
					UserService.getInstance():clearUsedHttpCache(list)
					-- UserService:getInstance():syncLocal()
					Localhost.getInstance():flushCurrentUserData()

					context:sync()
				end
				
				if errorCode > 10 then ExceptionPanel:create(onUseLocalFunc, onUseServerFunc):popout()
				else context:onLoadingError() end
			else
				print("override local data with server data")
				local status = kUserDataStatus.kOnlineServerData
				UserManager.getInstance():initFromLua(resp) --init data
				UserService.getInstance():initialize()
				
				UserService.getInstance():clearUsedHttpCache(list)
				-- UserService:getInstance():syncLocal()
				Localhost.getInstance():flushCurrentUserData()

				if __ANDROID then AndroidPayment.getInstance():changeSMSPaymentDecisionScript(resp.smsPay) end
				
				--finish login logic
				context:dispatchEvent(Event.new(Events.kComplete, status, context))
				GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kUserLogin))

				local userId = UserManager:getInstance().user.uid
				if __IOS then
					GspEnvironment:getInstance():setGameUserId(tostring(userId))
				elseif __ANDROID then 
					GspProxy:setGameUserId(tostring(userId)) 
				end
				HeGameDefault:setUserId(tostring(userId))
				DcUtil:dailyUser()
				DcUtil:logInGame()
			end
		end	
	end
	ConnectionManager:block()
	for i,element in ipairs(list) do ConnectionManager:sendRequest( element.endpoint, element.body, onCachedHttpDataResponse ) end
	local userbody = {
		curMd5 = ResourceLoader.getCurVersion(),
		pName = _G.packageName 
	}
	if StartupConfig:getInstance():getSmallRes() then 
		userbody.mini = 1
	else
		userbody.mini = 0
	end
	userbody.deviceOS = "unknown"
	if __IOS then
		userbody.deviceOS = "ios"
	elseif __ANDROID then
		userbody.deviceOS = "android"
	elseif __WP8 then
		userbody.deviceOS = "wp"
	end

	--IOS后端推送所需 在AppController.mm里获取然后写入
	userbody.deviceToken = ""
	if __IOS then
		userbody.deviceToken = CCUserDefault:sharedUserDefault():getStringForKey("animal_ios_deviceToken") or ""
	end

	--推送召回 前端向后端发送流失状态
	userbody.lostType = RecallManager.getInstance():getRecallRewardState()
	-- 
	userbody.snsPlatform = PlatformConfig:getLastPlatformAuthName()

	ConnectionManager:sendRequest( "user", userbody, onUserCallback )
	ConnectionManager:flush()
	--as user data may changed, flush cached data
	if cachedLocalUserData then Localhost:flushSelectedUserData( cachedLocalUserData ) end

	local function onUserInfoTimeout()
		print("timeout @ LoginLogic:sync " .. " time: (s)" .. self.timeout)
		stopTimeout()
		isNotTimeout = false
		context:onLoadingError()
	end
	timeoutID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onUserInfoTimeout,self.timeout,false)
end

function LoginLogic:getUserInfo()
	self:sync()
end

function LoginLogic:onLoadingError(err)
	print("net err, error code: ", tostring(err), "; enter local host mode")
	_G.kUserLogin = false
	--if we can not login or get user data from server, enter local server mode.
	--load data from device
	local status = 0
	local cachedLocalUserData = Localhost.getInstance():readLastLoginUserData()
  	if cachedLocalUserData then
  		local timeConfig = Localhost:getDefaultConfig()
  		_G.__g_utcDiffSeconds = timeConfig.td or 0

  		UserManager.getInstance():decode(cachedLocalUserData.user)

  		local user = UserManager.getInstance().user
  		local savedConfig = Localhost.getInstance():getLastLoginUserConfig()
  		if tostring(savedConfig.uid) == tostring(user.uid) then
	  		UserManager.getInstance().uid = tostring(savedConfig.uid)
			UserManager.getInstance().sessionKey = _G.kDeviceID
			UserManager.getInstance().platform = savedConfig.p
		else 
			print("savedConfig uid is different from local saved uid") 
		end
  		
  		print("read last login user data: ", user.uid, " ", user:getTopLevelId(), " ", user:getCoin(), " td:"..__g_utcDiffSeconds)
  		status = kUserDataStatus.kOfflineOldData
  		UserService.getInstance():decodeLocalStorageData(cachedLocalUserData.user)
  	else
	  	_G.__g_utcDiffSeconds = 0
  		print("old user data not found, create a temp new user by local service.", " td:"..__g_utcDiffSeconds)
  		UserManager.getInstance():createNewUser()
  		status = kUserDataStatus.kOfflineNewData
		
  		Localhost.getInstance():setLastLoginUserConfig(UserManager.getInstance().uid, UserManager.getInstance().sessionKey, UserManager.getInstance().platform)
  	end

  	--start local host. copy data from UserManager.
	UserService.getInstance():initialize()

	--refresh data. after some time, when player come back to game, we need to refresh energy, etc.
	local refreshedUserData = LoginLocalLogic:refresh()
	if refreshedUserData then
		UserManager.getInstance():syncUserData(refreshedUserData)
		if NetworkConfig.writeLocalDataStorage then Localhost.getInstance():flushCurrentUserData()
		else print("Did not write user data to the device.") end
	end
	
	--updateinfo
	NewVersionUtil:readCacheUpdateInfo()
	local userId = UserManager:getInstance().user.uid
	if __IOS then
		GspEnvironment:getInstance():setGameUserId(tostring(userId))
	elseif __ANDROID then 
		GspProxy:setGameUserId(tostring(userId)) 
	end
	HeGameDefault:setUserId(tostring(userId))
	DcUtil:dailyUser()
	DcUtil:logInGame()

	self:dispatchEvent(Event.new(Events.kError, nil, self))
end
