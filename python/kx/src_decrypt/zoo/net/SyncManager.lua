require "zoo.data.UserManager"

-------------------------------------------------------------------------
--  Class include: ReachabilityUtil
-------------------------------------------------------------------------

--
-- SyncManager ---------------------------------------------------------
--
local kMinDisplayTime = 3
local instance = nil

SyncFinishReason = {
	kSuccess = 1,
	kLoginError = 2,
	kNoNetwork = 3,
	kRestoreData = 4,
	kNoLocalServer = 5,
	kNoDataToUpload = 6,
}

SyncManager = {}

function SyncManager.getInstance()
	if not instance then 
		instance = SyncManager 
	end
	return instance
end

function SyncManager:sync(onCurrentSyncFinish, onCurrentSyncError, animationType)
	local function onUserLogin()
		self:flush(onCurrentSyncFinish, onCurrentSyncError, animationType)
	end
	local function onUserNotLogin()
		if onCurrentSyncError then onCurrentSyncError() end
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished, SyncFinishReason.kLoginError))
	end

	animationType = animationType or kRequireNetworkAlertAnimation.kSync
	RequireNetworkAlert:callFuncWithLogged(onUserLogin, onUserNotLogin, animationType)
end

local function onCachedHttpDataResponse(endpoint, resp, err)
	if err then 
		if not table.exist(ExceptionErrorCodeIgnore, err) then 
			LoginExceptionManager:getInstance():setErrorCodeCache(err)
		end
		he_log_warning("SyncManager::onCachedHttpDataResponse data fail, err: " .. err)
	else 
		he_log_warning("SyncManager::onCachedHttpDataResponse data success") 
	end
end

function SyncManager:flush(onCurrentSyncFinish, onCurrentSyncError, animationType)
	
	if __IOS and not ReachabilityUtil.getInstance():isNetworkAvailable() then
		print("Network disabled on iOS? ignore sync this time.")
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished, SyncFinishReason.kNoNetwork))
		if onCurrentSyncError ~= nil then onCurrentSyncError() end
		return
	end
	if not NetworkConfig.useLocalServer then 
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished, SyncFinishReason.kNoLocalServer))
		if onCurrentSyncFinish ~= nil then onCurrentSyncFinish() end
		return 
	end

	local originList = UserService.getInstance():getCachedHttpData()
	local list = {}
	local syncSerial = UserService:getInstance():getSyncSerial()
	for k, v in ipairs(originList) do
		if type(v.body) == "table" then
			local ss = v.body.seq
			if type(ss) == "number" then
				if type(syncSerial) ~= "number" then
					syncSerial = ss
				elseif v.body.seq > syncSerial then syncSerial = v.body.seq end
			else
				if type(syncSerial) == "number" then
					syncSerial = syncSerial + 1
					v.body.seq = syncSerial
				end
			end
		end
		UserService:getInstance():setSyncSerial(syncSerial)
		table.insert(list, v)
	end
	if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
	else print("Did not write user data to the device.") end
	if list and #list > 0 then
		--animation
		local beginTime = os.clock()
		local syncCanceled = false
		local container
		if animationType ~= kRequireNetworkAlertAnimation.kNoAnimation then
			if animationType == kRequireNetworkAlertAnimation.kSync then
				container = CountDownAnimation:createSyncAnimation()
			else
				container = CountDownAnimation:createNetworkAnimation(
									Director:sharedDirector():getRunningScene(),
									function() 
										syncCanceled = true
										container:removeFromParentAndCleanup(true)
									end,
									localize("loading.upload.data")
							)
			end

			if self.container then self.container:removeFromParentAndCleanup(true) end
			self.container = container
		end
		--print(table.tostring(list))
		--http 
		ConnectionManager:block()
		for i,element in ipairs(list) do
			ConnectionManager:sendRequest( element.endpoint, element.body, onCachedHttpDataResponse )
		end
		
		local function onSyncCallback( endpoint, resp, err )
			if syncCanceled then
				return
			end

			--hide animation
		    local delayTime = 0
			local deltaTime = os.clock() - beginTime
			if deltaTime < kMinDisplayTime then delayTime = kMinDisplayTime - deltaTime end
			if type(container) ~= "nil" then
				if container.hide then
					container:hide(delayTime)
				else
					container:removeFromParentAndCleanup(true)
				end
				self.container = nil
			end

			if err then 
				he_log_warning("sync data fail, err: " .. err)
				local errorCode = tonumber(err) or -1
				local function onUseLocalFunc() 
					print("player choose local data (wrong data)") 
					if errorCode == 109 then
						CCDirector:sharedDirector():endToLua()
						return
					end
					if onCurrentSyncError ~= nil then onCurrentSyncError(errorCode) end
				end
				local function onUseServerFunc()
					print("player clear local data")
					UserService:getInstance():clearCachedHttp()
					Localhost.getInstance():flushCurrentUserData()
					self:syncAgain(onCurrentSyncFinish, onCurrentSyncError, animationType)
				end
				if errorCode > 10 then
					ConnectionManager:syncFlush()
					local panel = ExceptionPanel:create(errorCode, onUseLocalFunc, onUseServerFunc)
					if panel then panel:popout() end 
				else 
					-- local err
					if onCurrentSyncError ~= nil then onCurrentSyncError(errorCode) end
					ConnectionManager:syncFlush()
				end
		    else 
		    	he_log_info("sync data success")
				-- UserManager.getInstance():updateUserData(resp)
				-- UserService.getInstance():updateUserData(resp)
				UserService.getInstance():clearUsedHttpCache(list)
				-- UserService:getInstance():syncLocal()

				if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
				else print("Did not write user data to the device.") end
				if onCurrentSyncFinish ~= nil then onCurrentSyncFinish() end

				GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished, SyncFinishReason.kSuccess))
				ConnectionManager:syncFlush()
			end
		end
		ConnectionManager:sendRequest( "syncEnd", {}, onSyncCallback )
		ConnectionManager:flush()
		ConnectionManager:syncBlock()
	else 
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished, SyncFinishReason.kNoDataToUpload)) 
		if onCurrentSyncFinish ~= nil then onCurrentSyncFinish() end
	end
end

function SyncManager:flushCachedHttp()
	local originList = UserService.getInstance():getCachedHttpData()
	local list = {}
	local syncSerial = UserService:getInstance():getSyncSerial()
	for k, v in ipairs(originList) do
		if type(v.body) == "table" then
			local ss = v.body.seq
			if type(ss) == "number" then
				if type(syncSerial) ~= "number" then
					syncSerial = ss
				elseif v.body.seq > syncSerial then syncSerial = v.body.seq end
			else
				if type(syncSerial) == "number" then
					syncSerial = syncSerial + 1
					v.body.seq = syncSerial
				end
			end
		end
		UserService:getInstance():setSyncSerial(syncSerial)
		table.insert(list, v)
	end
	if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
	else print("Did not write user data to the device.") end
	if list and #list > 0 then
		for i,element in ipairs(list) do
			local function syncCallback( endpoint, resp, err )
				if err then 
					he_log_warning("sync data fail, err: " .. err)
					local errorCode = tonumber(err) or -1
					local function onUseLocalFunc()
						if errorCode == 109 then
							CCDirector:sharedDirector():endToLua()
							return
						end
					end
					local function onUseServerFunc()
						UserService:getInstance():clearCachedHttp()
						Localhost.getInstance():flushCurrentUserData()
						self:syncAgain()
					end
					if errorCode > kErrorCodeRange then
						local panel = ExceptionPanel:create(errorCode, onUseLocalFunc, onUseServerFunc)
						if panel then panel:popout() end 
					else he_log_warning("onCachedHttpDataResponse data fail, err: " .. err) end
			    else 
			    	he_log_info("onCachedHttpDataResponse data success")
					UserService.getInstance():clearUsedHttpCache({element})
					if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
					else print("Did not write user data to the device.") end
					if onCurrentSyncFinish ~= nil then onCurrentSyncFinish() end
				end
			end
			ConnectionManager:sendRequest( element.endpoint, element.body, syncCallback )
		end
	end
end

function SyncManager:syncAgain(onCurrentSyncFinish, onCurrentSyncError, animationType)
	local container
	local syncCanceled = false

	if animationType ~= kRequireNetworkAlertAnimation.kNoAnimation then
		if animationType == kRequireNetworkAlertAnimation.kSync then
			container = CountDownAnimation:createSyncAnimation()
		else
			container = CountDownAnimation:createNetworkAnimation(
								Director:sharedDirector():getRunningScene(),
								function() 
									syncCanceled = true
									container:removeFromParentAndCleanup(true)
								end,
								"正在为您同步关卡数据，请稍候"
						)
		end

		if self.container then self.container:removeFromParentAndCleanup(true) end
		self.container = container
	end

	local beginTime = os.clock()

	local function onSyncCallback( endpoint, resp, err )
		if syncCanceled then
			return
		end

	 	local delayTime = 0
		local deltaTime = os.clock() - beginTime
		if deltaTime < kMinDisplayTime then delayTime = kMinDisplayTime - deltaTime end
		if container then
			if container.hide then
				container:hide(delayTime)
			else
				container:removeFromParentAndCleanup(true)
			end
		end
		self.container = nil

		if err then 
			he_log_warning("sync data fail again, err: " .. err)
			local errorCode = tonumber(err) or -1
			local function onUseLocalFunc() 
				print("player choose local data again(wrong data)") 
				if errorCode == 109 then
					CCDirector:sharedDirector():endToLua()
					return
				end
				if onCurrentSyncError ~= nil then onCurrentSyncError(errorCode) end
			end
			local function onUseServerFunc()
				print("player clear local data again")
				UserService:getInstance():clearCachedHttp()
				Localhost.getInstance():flushCurrentUserData()
				self:syncAgain(onCurrentSyncFinish, onCurrentSyncError)
			end
			if errorCode > 10 then 
				local panel = ExceptionPanel:create(errorCode, onUseLocalFunc, onUseServerFunc)
				if panel then panel:popout() end 
			else 
				-- local err
				if onCurrentSyncError ~= nil then onCurrentSyncError(errorCode) end
			end
	    else 
	    	he_log_info("sync data success after player choose server data")
			UserManager.getInstance():updateUserData(resp)
			UserService.getInstance():updateUserData(resp)
			UserService:getInstance():clearCachedHttp()

			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			if onCurrentSyncFinish ~= nil then onCurrentSyncFinish() end

			GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished, SyncFinishReason.kRestoreData))
		end
	end
	ConnectionManager:sendRequest( "syncData", {}, onSyncCallback )
end