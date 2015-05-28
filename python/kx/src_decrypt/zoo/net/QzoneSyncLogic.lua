
local kUserConnectMapping = {}
kUserConnectMapping["0000"] = 1 -- 全新账号
kUserConnectMapping["1000"] = 2	-- 游客账号绑定新的平台账号
kUserConnectMapping["0001"] = 3	-- 全新账号，pc有数据
kUserConnectMapping["1001"] = 4	-- 游客账号绑定新的平台账号，pc有数据

kUserConnectMapping["0011"] = 5	-- 本地新账号，即将登陆已绑定uid的平台账号
kUserConnectMapping["0010"] = 5	
------------------------------------------------------------------------------------
kUserConnectMapping["1011"] = 6	-- 本地游客账号有数据但未绑定，即将登陆的平台账号已绑定
kUserConnectMapping["1010"] = 6

kUserConnectMapping["0100"] = 7	-- 本地uid已绑定，即将登陆的平台账号未绑定
kUserConnectMapping["1100"] = 7

kUserConnectMapping["0101"] = 8	-- 本地uid已绑定，即将登陆的平台账号未绑定，有pc数据 
kUserConnectMapping["1101"] = 8

kUserConnectMapping["0111"] = 9	-- 本地uid已绑定，即将登陆的平台账号也有绑定uid(两个uid不一定一致)
kUserConnectMapping["1111"] = 9
kUserConnectMapping["1110"] = 9
kUserConnectMapping["0110"] = 9

QzoneSyncLogic = class()

function QzoneSyncLogic:ctor( openId, accessToken )
	self.openId = openId
	self.accessToken = accessToken
	self.timeout = 10
	self.connectStatus = 0
	if NetworkConfig.mockQzoneSk ~= nil then
		self.accessToken = NetworkConfig.mockQzoneSk
	end
end

--static
function QzoneSyncLogic:getMappingUserConnectStatus( connectData )
	if connectData and type(connectData.currentLevel) == "number" then
		local a, b, c, d = 0, 0, 0, 0
		local currentLevel = tonumber(connectData.currentLevel) or 0
		if currentLevel > 1 then a = 1 end
		if connectData.connected then b = 1 end
		if connectData.qqConnected then c = 1 end
		if connectData.qqInPc then d = 1 end
		local key = string.format("%d%d%d%d", a, b, c, d)
		local val = kUserConnectMapping[key]
		if val == nil then val = 0 end
		return val
	end
	return 0
end

--static
function QzoneSyncLogic:preconnect( openId, accessToken, onFinish,isV1Http)
	if openId == nil or accessToken == nil then return onFinish(nil) end

	local isNotTimeout = true
	local timeoutID = nil
	local function stopTimeout()
		if timeoutID ~= nil then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timeoutID) end
		print("stop timeout check")
		timeoutID = nil
	end 
	local function onPreQzoneError( evt )
		evt.target:removeAllEventListeners()
		stopTimeout()
		if isNotTimeout then onFinish(nil)	
		else print("onPreQzoneError callback after timeout") end
	end
	local function onPreQzoneFinish( evt )	
		evt.target:removeAllEventListeners()
		stopTimeout()
		if isNotTimeout then onFinish(evt.data)	
		else print("onPreQzoneFinish callback after timeout") end
	end 

	local http = nil
	if isV1Http then 
		http = PreQQConnectV1Http.new()
	else
		http = PreQQConnectHttp.new()
	end

	http:addEventListener(Events.kComplete, onPreQzoneFinish)
	http:addEventListener(Events.kError, onPreQzoneError)
	http:load(openId, accessToken, self:haveUserSyncData())

	local function onPreQzoneTimeout()
		print("timeout @ onPreQzoneTimeout" .. " time: (s)")
		stopTimeout()
		isNotTimeout = false
		onFinish(nil)	
	end
	timeoutID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onPreQzoneTimeout,10,false)
end

--static
function QzoneSyncLogic:haveUserSyncData()
	local cachedLocalUserData = Localhost.getInstance():readCurrentUserData()
	if cachedLocalUserData and cachedLocalUserData.user and cachedLocalUserData.user.user then
		local httpData = cachedLocalUserData.user.httpData or {}
		return #httpData > 0
	end
	return false
end

--static
function QzoneSyncLogic:formatLevelInfoMessage( topLevelId, updateTime )
	if updateTime == nil or updateTime == 0 then updateTime = os.time() * 1000 end
	updateTime = updateTime / 1000
	-- local dataInfoLabel = {space="", num=topLevelId, data=os.date("%x %H:%M", updateTime)}
	-- if __IOS_FB then dataInfoLabel = {space="", num=topLevelId, data=os.date("%x %H:%M", updateTime)} end
	local dataInfoLabel = {space="", num=topLevelId, data=os.date("%x", updateTime)}
	if __IOS_FB then dataInfoLabel = {space="", num=topLevelId, data=os.date("%x", updateTime)} end
	return Localization:getInstance():getText("exception.panel.top.level", dataInfoLabel)
end

function QzoneSyncLogic:sync(onFinish,onSyncCancel,onSyncError)
	local function onTouchPositiveButton()
		self:connect(onFinish,onSyncError)
	end
	local function onTouchNegativeButton()
		if onSyncCancel ~= nil then onSyncCancel() end
	end
	local function onGetPreConnect( result )
		local platform = PlatformConfig:getPlatformNameLocalization()
		local status = QzoneSyncLogic:getMappingUserConnectStatus( result ) 
		if result and result.refuse then
			local p = QQLoginSuccessPanel:create( 
				Localization:getInstance():getText("loading.tips.start.btn.qq", {platform=platform}),
				Localization:getInstance():getText("loading.tips.weibo.account.cant.move", {platform=platform}))
	   		p:setCloseButtonCallback(onTouchNegativeButton)
	   		p:popout()
			return
		end

		if status > 0 then
			local ignoreGuestData = false
			local message = nil
			if status >= 1 and status <= 5 then
				print("preconnect v2: preconnect with connect")
			elseif status == 6 then 
				if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then -- 米聊版没有游客账号
					ignoreGuestData = true
				else
					local formated = QzoneSyncLogic:formatLevelInfoMessage(result.pcLevel or 1, tonumber(result.pcAccessTime))
					local accMode = Localization:getInstance():getText("loading.tips.preloading.warnning.mode1")
					message = Localization:getInstance():getText("loading.tips.preloading.warnning.3", {user=formated,platform=platform,mode=accMode}) 
				end
			elseif status == 7 or status == 8 or status == 9 then 
				if self:haveUserSyncData() then
					message = Localization:getInstance():getText("loading.tips.preloading.warnning.4", {platform=platform}) 
				else
					print("preconnect v2: preconnect with connect")
				end
			end
			
			if message then
				local qqSyncPanel = QQSyncPanel:create( 
					Localization:getInstance():getText("loading.tips.start.btn.qq", 
					{platform=platform}),
					message, 
					onTouchPositiveButton, 
					onTouchNegativeButton
				)
				qqSyncPanel:popout()
			elseif ignoreGuestData then
				onTouchPositiveButton() 
			else
				self:onSyncQzone(result, onFinish, onSyncError)
			end
		else 
			onTouchPositiveButton() 
		end
	end
	QzoneSyncLogic:preconnect( self.openId, self.accessToken, onGetPreConnect )
end


function QzoneSyncLogic:connect(onFinish,onSyncError)
	self.connectStatus = 0
	local context = self
	local isNotTimeout = true
	local timeoutID = nil
	local function stopTimeout()
		if timeoutID ~= nil then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timeoutID) end
		print("stop timeout check")
		timeoutID = nil
	end 
	local function onSyncQzoneError( evt )
		evt.target:removeAllEventListeners()
		stopTimeout()
		if isNotTimeout then
		  	if onSyncError~=nil then onSyncError() end	 -- context:onLoadingError(onSyncError, evt.data)	
		else print("onSyncQzoneError callback after timeout") end
	end
	local function onSyncQzoneFinish( evt )	
		evt.target:removeAllEventListeners()
		stopTimeout()
		if isNotTimeout then context:onSyncQzone(evt.data, onFinish, onSyncError)
		else print("onSyncQzoneFinish callback after timeout") end
	end 
	
	local http = QQConnectHttp.new()
	http:addEventListener(Events.kComplete, onSyncQzoneFinish)
	http:addEventListener(Events.kError, onSyncQzoneError)
	http:load(self.openId, self.accessToken)

	local function onSyncQzoneTimeout()
		print("timeout @ LoginLogic:login " .. " time: (s)" .. self.timeout)
		stopTimeout()
		isNotTimeout = false
		-- context:onLoadingError(onSyncError, -2)
		if onSyncError~=nil then onSyncError() end
	end
	timeoutID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onSyncQzoneTimeout,self.timeout,false)
end

function QzoneSyncLogic:alertByStatus( )
	local status = self.connectStatus or 0
	print("alertByStatus status:" .. tostring(status))
	local platform = PlatformConfig:getPlatformNameLocalization()
	local message = nil
	if status == 3 or status == 4 or status == 8 then 
		message = Localization:getInstance():getText("loading.tips.login.success.1", {platform=platform})
	elseif status == 6 then 
		if not PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then -- 米聊版没有游客账号
			message = Localization:getInstance():getText("loading.tips.login.success.3", {platform=platform}) 
		end
	elseif status == 5 or status == 9 then 
		message = Localization:getInstance():getText("loading.tips.login.success.2", {platform=platform}) 
	end

	local function popoutAlert()
		if message then 
			local title = Localization:getInstance():getText("loading.tips.start.btn.qq", { platform = platform })
			local qqLoginPanel = QQLoginSuccessPanel:create(title, message)
	   		qqLoginPanel:popout()
		end
	end
	setTimeOut(popoutAlert, 5)
end

function QzoneSyncLogic:onSyncQzone(result, onFinish, onSyncError)
	if result and result.uid and result.uuid then
		self.connectStatus = QzoneSyncLogic:getMappingUserConnectStatus( result ) 

		local serverNewUid = result.uid
		local serverNewUDID = result.uuid
		local localOldUid = UserManager.getInstance().uid
		print(string.format("onSyncQzone: server:%s/%s local:%s/%s with sk: %s", serverNewUid, serverNewUDID, localOldUid, kDeviceID, self.accessToken))
		if serverNewUDID ~= kDeviceID then
			UdidUtil:saveUdid(serverNewUDID)
			kDeviceID = serverNewUDID
		end
	    UserManager.getInstance():reset()
	    UserService.getInstance():reset()
		if tostring(serverNewUid) ~= tostring(localOldUid) then
			--require loginout and login again ingame.
			-- 当前账号是老账号且平台账号没有游戏数据，则后台绑定了一个新账号
			local isNewUser = result.connected and not result.qqConnected
      		self:changeUserID(isNewUser, serverNewUid, localOldUid, onFinish, onSyncError)
		else
			UserManager.getInstance().uid = serverNewUid
			UserManager.getInstance().sessionKey = kDeviceID
			UserManager.getInstance().platform = kDefaultSocialPlatform
			--require load user data again.
			--ConnectionManager:reset( serverNewUid, kDeviceID )
			ConnectionManager:invalidateSessionKey()
			self:refreshUserData(onFinish)
		end
		--update local last login data.
		Localhost.getInstance():setLastLoginUserConfig(UserManager.getInstance().uid, UserManager.getInstance().sessionKey, UserManager.getInstance().platform)
	else 
		if onSyncError~=nil then onSyncError() else print("onSyncQzone data invalid - onSyncError") end
		-- self:onLoadingError(onSyncError, -1) 
	end
end

function QzoneSyncLogic:changeUserID(isNewUser, newUserID, localOldUid, onFinish, onSyncError)
	local function onLoginFinish( evt )
		evt.target:removeAllEventListeners()
		if onFinish ~= nil then onFinish() end
		self:alertByStatus()

      	if localOldUid then Localhost.getInstance():deleteUserDataByUserID(localOldUid) end
      	-- DNU打点
  		if isNewUser then
  			DcUtil:newUser()
  		end
	end 

	local function onLoginError( evt )
		print("!!!!!!changeUserID-onLoginError")
		evt.target:removeAllEventListeners()
		if onSyncError ~= nil then onSyncError() end
	end
  
	local logic = LoginLogic.new()
	logic:addEventListener(Events.kComplete, onLoginFinish)
	logic:addEventListener(Events.kError, onLoginError)
	logic:execute(newUserID, kDeviceID, kDefaultSocialPlatform, 10)
end

function QzoneSyncLogic:refreshUserData( onFinish )
	local context = self
	local isNotTimeout = true
	local timeoutID = nil
	local function stopTimeout()
		if timeoutID ~= nil then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timeoutID) end
		print("stop timeout check")
		timeoutID = nil
	end 

	local function onUserCallback( endpoint, resp, err )
		stopTimeout()
		
		if isNotTimeout then
			if err then 
				he_log_info("onUserCallback fail, err: " .. err)
				context:onLoadingError(onFinish, err)
			else
				print("refresh local data with server data")
			
				UserManager.getInstance():initFromLua(resp) --init data
				UserService.getInstance():initialize()
				
				UserService.getInstance():clearUsedHttpCache(list)
				Localhost.getInstance():flushCurrentUserData()
				
				if __ANDROID then AndroidPayment.getInstance():changeSMSPaymentDecisionScript(resp.smsPay) end
				
				GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kUserLogin))
				
				if onFinish ~= nil then onFinish() end
				self:alertByStatus()
			end
		end	
	end
	
	ConnectionManager:block()
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

	ConnectionManager:sendRequest( "user", userbody, onUserCallback )
	ConnectionManager:flush()
	
	local function onUserInfoTimeout()
		print("timeout @ QzoneSyncLogic:refreshUserData " .. " time: (s)" .. self.timeout)
		stopTimeout()
		isNotTimeout = false
		context:onLoadingError(onFinish, -2)
	end
	timeoutID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onUserInfoTimeout,self.timeout,false)
end

function QzoneSyncLogic:onLoadingError(onFinish, errorCode)
	if onFinish ~= nil then onFinish() end
	errorCode = errorCode or 0
	local errorMsg = tostring(errorCode)
	if errorCode == -1 then errorMsg = " [read error -1]"
	elseif errorCode == -2 then errorMsg = " [timeout -2]" end
	if __ANDROID then 
		local platform = PlatformConfig:getPlatformNameLocalization()
		AlertDialogImpl:alert( Localization:getInstance():getText("loading.tips.start.btn.qq", {platform=platform}), 
				"ERROR! code:".. errorCode, 
				Localization:getInstance():getText("button.ok")) 
	else
		local msg = Localization.getInstance():getText("loading.tips.register.failure."..kLoginErrorType.syncData)
		CommonTip:showTip(msg, "negative")
	end
end