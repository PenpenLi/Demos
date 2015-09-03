PostLoginLogic = class(EventDispatcher)

PostLoginLogicEvents = table.const {
	kComplete  	= "PostLoginLogic.complete",
	kError		= "PostLoginLogic.error",
	kException	= "PostLoginLogic.exception",
}

function PostLoginLogic:ctor()
	self.syncTimes = 0
end
function PostLoginLogic:onError(err)
	_G.kUserLogin = false
	self:dispatchEvent(Event.new(PostLoginLogicEvents.kError, err, self))
end
function PostLoginLogic:onFinish()
	_G.kUserLogin = true
	self:dispatchEvent(Event.new(PostLoginLogicEvents.kComplete, nil, self))
	GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kUserLogin))
end
function PostLoginLogic:onException()
	self:dispatchEvent(Event.new(PostLoginLogicEvents.kException, nil, self))
end
function PostLoginLogic:stopTimeout()
	if self.timeoutID ~= nil then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeoutID) end
	print("PostLoginLogic:: stop timeout check")
end

function PostLoginLogic:load(timeout)
	timeout = timeout or 10
	local function onTimeout()
		self.isNotTimeout = false
		self:stopTimeout()
		self:onError(-2)
		-- print("timeout @ PostLoginLogic")
	end
	self.isNotTimeout = true
	self.timeoutID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, timeout,false)

    local localUserConfig = Localhost.getInstance():getLastLoginUserConfig()
    if localUserConfig and localUserConfig.uid ~= 0 and localUserConfig.uid ~= localUserConfig.sk then
		local platform = kDefaultSocialPlatform
    	self:login(localUserConfig.uid, localUserConfig.sk, platform)
    else
    	self:registerAndLogin()
    end
end

function PostLoginLogic:registerAndLogin()
	local function onRegisterError( evt )
		if evt then evt.target:removeAllEventListeners() end
		print("register error")
		if self.isNotTimeout then self:onError(evt.data) end
	end
	local function onRegisterFinish( evt )
		evt.target:removeAllEventListeners()
		if self.isNotTimeout and kTransformedUserID ~= nil and kDeviceID ~= nil then
			local userId = kTransformedUserID
			local sessionKey = kDeviceID
			local platform = kDefaultSocialPlatform
			self:login(userId, sessionKey, platform)
		else self:onError(-2) end
	end 
	--begin with register
	local register = RegisterHTTP.new()
	register:addEventListener(Events.kComplete, onRegisterFinish)
	register:addEventListener(Events.kError, onRegisterError)
	register:load()
end

function PostLoginLogic:setUserDefault( userId )
	if __IOS then
		GspEnvironment:getInstance():setGameUserId(tostring(userId))
	elseif __ANDROID then 
		GspProxy:setGameUserId(tostring(userId)) 
	end
	HeGameDefault:setUserId(tostring(userId))
	DcUtil:dailyUser()
end

function PostLoginLogic:login( userId, sessionKey, platform )
	PostLoginLogic:setUserDefault( userId )
	UserManager.getInstance().uid = userId
	UserManager.getInstance().sessionKey = sessionKey
	UserManager.getInstance().platform = platform
	Localhost.getInstance():setLastLoginUserConfig(userId, sessionKey, platform)
	ConnectionManager:reset(userId, sessionKey)
	
	local function onLoginError( evt )
		evt.target:removeAllEventListeners()
		_G.kUserLogin = false
		if self.isNotTimeout then self:onError(evt.data) end
	end
	local function onLoginFinish( evt )
		evt.target:removeAllEventListeners()
		if self.isNotTimeout then
			_G.kUserLogin = true
			if type(evt.data) == "table" and type(evt.data.lastSeq) == "number" then
				UserService:getInstance():setSyncSerial(evt.data.lastSeq)
			end
			self:sync()
		end
	end 
	local http = LoginHttp.new()
	http:addEventListener(Events.kComplete, onLoginFinish)
	http:addEventListener(Events.kError, onLoginError)
	http:load()
end

function PostLoginLogic:sync()
	local cachedLocalUserData, list = LoginLogic:readUserSyncDataFromLocal()

	local function onUserCallback( endpoint, resp, err )
		self:stopTimeout()

		if err then he_log_warning("post onUserCallback fail, err: " .. err)
	    else he_log_info("post onUserCallback success") end
		
		if self.isNotTimeout then
			if err then 
				print("sync err"..tostring(err))
				local errorCode = tonumber(err) or -1
				local function onUseLocalFunc()
					print("player choose local data (wrong data)")
					self:onError(err)
				end
				local function onUseServerFunc()
					print("player clear local data and retry")
					UserService.getInstance():clearUsedHttpCache(list)
					UserService:getInstance():syncLocal()
					Localhost.getInstance():flushCurrentUserData()
					self:sync()
				end
				
				if errorCode > 10 then 
					self:onException()
					ExceptionPanel:create(onUseLocalFunc, onUseServerFunc):popout()
				else self:onError(err) end
			else
				print("override local data with server data")
				UserManager.getInstance():initFromLua(resp) --init data
				UserService.getInstance():initialize()
				
				UserService.getInstance():clearUsedHttpCache(list)
				UserService:getInstance():syncLocal()
				Localhost.getInstance():flushCurrentUserData()
				
				if __ANDROID then AndroidPayment.getInstance():changeSMSPaymentDecisionScript(resp.smsPay) end

				GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished))
				
				--finish login logic
				self:onFinish()
			end
		end
	end

	_G.skipHttpSpeedLitmit = true
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
	_G.skipHttpSpeedLitmit = nil
	--as user data meight changed, flush cached data
	if cachedLocalUserData then Localhost:flushSelectedUserData( cachedLocalUserData ) end
end