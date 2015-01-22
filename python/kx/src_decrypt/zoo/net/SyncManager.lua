require "zoo.data.UserManager"

-------------------------------------------------------------------------
--  Class include: ReachabilityUtil
-------------------------------------------------------------------------

--
-- SyncManager ---------------------------------------------------------
--
local kMinDisplayTime = 3
local instance = nil
SyncManager = {}

function SyncManager.getInstance()
	if not instance then 
		instance = SyncManager 
	end
	return instance
end

function SyncManager:sync(onCurrentSyncFinish, onCurrentSyncError, showAnim)
	if RequireNetworkAlert:popout(onUserLogin, kRequireNetworkAlertAnimation.kSync) then
		self:flush(onCurrentSyncFinish, onCurrentSyncError, showAnim)
	else
		if onCurrentSyncError then onCurrentSyncError() end
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished))
	end
end

local function onCachedHttpDataResponse(endpoint, resp, err)
	if err then he_log_warning("onCachedHttpDataResponse data fail, err: " .. err)
	else he_log_warning("onCachedHttpDataResponse data success") end
end

function SyncManager:flush(onCurrentSyncFinish, onCurrentSyncError, showAnim)
	if type(showAnim) ~= "boolean" then showAnim = true end
	if __IOS and not ReachabilityUtil.getInstance():isNetworkAvailable() then
		print("Network disabled on iOS? ignore sync this time.")
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished))
		if onCurrentSyncError ~= nil then onCurrentSyncError() end
		return
	end
	if not NetworkConfig.useLocalServer then 
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished))
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
	local ingameList
	if __WP8 then ingameList = UserService.getInstance():getCachedIngameHttpData() end
	if list and #list > 0 or ingameList and #ingameList > 0 then
		--animation
		local beginTime = os.clock()
		local container
		if showAnim then
			container = CountDownAnimation:createSyncAnimation()
			if self.container then self.container:removeFromParentAndCleanup(true) end
			self.container = container
		end
		--print(table.tostring(list))
		--http 
		ConnectionManager:block()
		if __WP8 then
			for i,element in ipairs(ingameList) do
				ConnectionManager:sendRequest( element.endpoint, element.body, onCachedHttpDataResponse )
			end
		end
		for i,element in ipairs(list) do
			ConnectionManager:sendRequest( element.endpoint, element.body, onCachedHttpDataResponse )
		end
		
		local function onSyncCallback( endpoint, resp, err )
			--hide animation
		    local delayTime = 0
			local deltaTime = os.clock() - beginTime
			if deltaTime < kMinDisplayTime then delayTime = kMinDisplayTime - deltaTime end
			if type(container) ~= "nil" then
				container:hide(delayTime)
				self.container = nil
			end

			if err then 
				he_log_warning("sync data fail, err: " .. err)
				local errorCode = tonumber(err) or -1
				local function onUseLocalFunc() 
					print("player choose local data (wrong data)") 
					if onCurrentSyncError ~= nil then onCurrentSyncError() end
				end
				local function onUseServerFunc()
					print("player clear local data")
					-- UserService.getInstance():clearUsedHttpCache(list)
					UserService:getInstance():clearCachedHttp()
					Localhost.getInstance():flushCurrentUserData()
					self:syncAgain(onCurrentSyncFinish, onCurrentSyncError)
				end
				if errorCode > 10 then
					ConnectionManager:syncFlush()
					ExceptionPanel:create(onUseLocalFunc, onUseServerFunc):popout()
				else 
					-- local err
					if onCurrentSyncError ~= nil then onCurrentSyncError() end
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

				GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished))
				ConnectionManager:syncFlush()
			end
		end
		ConnectionManager:sendRequest( "syncEnd", {}, onSyncCallback )
		ConnectionManager:flush()
		ConnectionManager:syncBlock()
		if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
		else print("Did not write user data to the device.") end
	else 
		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished)) 
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
	local ingameList
	if __WP8 then ingameList = UserService.getInstance():getCachedIngameHttpData() end
	if list and #list > 0 or ingameList and #ingameList > 0 then
		if __WP8 then
			for i,element in ipairs(ingameList) do
				local function ingameSyncCallback( endpoint, resp, err )
					if err then 
						he_log_warning("sync data fail, err: " .. err)
						local errorCode = tonumber(err) or -1
						local function onUseLocalFunc() end
						local function onUseServerFunc()
							UserService:getInstance():clearCachedHttp()
							Localhost.getInstance():flushCurrentUserData()
							self:syncAgain()
						end
						if errorCode > kErrorCodeRange then
							ExceptionPanel:create(onUseLocalFunc, onUseServerFunc):popout()
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
		for i,element in ipairs(list) do
			local function syncCallback( endpoint, resp, err )
				if err then 
					he_log_warning("sync data fail, err: " .. err)
					local errorCode = tonumber(err) or -1
					local function onUseLocalFunc() end
					local function onUseServerFunc()
						UserService:getInstance():clearCachedHttp()
						Localhost.getInstance():flushCurrentUserData()
						self:syncAgain()
					end
					if errorCode > kErrorCodeRange then
						ExceptionPanel:create(onUseLocalFunc, onUseServerFunc):popout()
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
		if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
		else print("Did not write user data to the device.") end
	end
end

function SyncManager:syncAgain(onCurrentSyncFinish, onCurrentSyncError)
	local beginTime = os.clock()
	local container = CountDownAnimation:createSyncAnimation()
	if self.container then self.container:removeFromParentAndCleanup(true) end
	self.container = container

	local function onSyncCallback( endpoint, resp, err )
	 	local delayTime = 0
		local deltaTime = os.clock() - beginTime
		if deltaTime < kMinDisplayTime then delayTime = kMinDisplayTime - deltaTime end
		container:hide(delayTime)
		self.container = nil

		if err then 
			he_log_warning("sync data fail again, err: " .. err)
			local errorCode = tonumber(err) or -1
			local function onUseLocalFunc() 
				print("player choose local data again(wrong data)") 
				if onCurrentSyncError ~= nil then onCurrentSyncError() end
			end
			local function onUseServerFunc()
				print("player clear local data again")
				UserService:getInstance():clearCachedHttp()
				Localhost.getInstance():flushCurrentUserData()
				self:syncAgain(onCurrentSyncFinish, onCurrentSyncError)
			end
			if errorCode > 10 then ExceptionPanel:create(onUseLocalFunc, onUseServerFunc):popout()
			else 
				-- local err
				if onCurrentSyncError ~= nil then onCurrentSyncError() end
			end
	    else 
	    	he_log_info("sync data success after player choose server data")
			UserManager.getInstance():updateUserData(resp)
			UserService.getInstance():updateUserData(resp)
			UserService:getInstance():clearCachedHttp()

			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			if onCurrentSyncFinish ~= nil then onCurrentSyncFinish() end

			GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kSyncFinished))
		end
	end
	ConnectionManager:sendRequest( "syncData", {}, onSyncCallback )
end