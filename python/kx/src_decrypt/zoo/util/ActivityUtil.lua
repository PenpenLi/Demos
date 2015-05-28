require "zoo.config.NetworkConfig"
require "zoo.animation.CountDownAnimation"

ActivityUtil = {}

ActivityUtil.onActivityStatusChangeCallbacks = {}


local _rootUrl = nil
local _activitys = nil
local _loadFromNetwork = false
local _lastRequestTime = 0

local function unrequire(m)
	package.loaded[m] = nil
	_G[m] = nil
	print("unrequire:"..m)

	local m1 = m:gsub(".lua","")
	package.loaded[m1] = nil
	_G[m1] = nil
	print("unrequire:"..m1)

	local m2 = m1:gsub("/",".")
	package.loaded[m2] = nil
	_G[m2] = nil
	print("unrequire:"..m2)

	local m3 = m:gsub("activity/","activity.")
	package.loaded[m3] = nil
	_G[m3] = nil
	print("unrequire:"..m3)
end


local function loadActivityRes(source,version,srcFiles,resourceFiles,onSuccess,onError,onProcess)
	local metaLua = source:gsub(".lua","_meta.lua")

	-- print(source)
	-- print(table.serialize(srcFiles))
	-- print(table.serialize(resourceFiles))

	local function loadMetaSuccess( )
		
		local meta = {}
		if not __WIN32 and not pcall(function() meta = require("activity/"..metaLua) end) then
			onError()
			return
		end

		local md5s = {}
		for _,v in pairs(srcFiles or {}) do
			if meta[v] then 
				md5s[v] = meta[v].md5
			end
		end
		for _,v in pairs(resourceFiles or {}) do
			if meta[v] then 
				md5s[v] = meta[v].md5
			end
		end		

		-- print(table.serialize(md5s))

		if onProcess then 
			local sizeMap = {}
			for _,v in pairs(srcFiles or {}) do
				sizeMap[v] = tostring((meta[v] or {size=1}).size)
			end
			for _,v in pairs(resourceFiles or {}) do
				sizeMap[v] = tostring((meta[v] or {size=1}).size)
			end

			ResManager:getInstance():loadActivityRes(
				_rootUrl,
				md5s,
				srcFiles,
				resourceFiles,
				onSuccess,
				onError,
				onProcess,
				sizeMap
			)
		else		
			ResManager:getInstance():loadActivityRes(
				_rootUrl,
				md5s,
				srcFiles,
				resourceFiles,
				onSuccess,
				onError
			)
		end
	end

	if __WIN32 then
		loadMetaSuccess()
	else
		ResManager:getInstance():loadActivityRes(
			_rootUrl,
			{ [metaLua]=version },
			{ metaLua },
			{},
			function ( ... )
				loadMetaSuccess()
			end,
			function( ... )
				print("error .. " .. version .. " " ..metaLua)
				onError()
			end
		)
	end
end

local configPath = HeResPathUtils:getUserDataPath() .. "/cache_activity_config"
local function readCacheConfig( ... )
	local file = io.open(configPath, "r")
	if file then
		local xml = file:read("*a") 
		file:close()
		return xml
	end
	return nil
end
local function writeCacheConfig( xml )
	local file = io.open(configPath,"w")
	if file then 
		file:write(xml)
		file:close()
	end
end

-- 请求活动配置文件
local function requestConfig(onSuccess,onError,tryCount,isReload)
	tryCount = tryCount or 1

	local function parseConfig(message)
		local activitysXML = nil
		pcall(function( ... ) 
			local activityXML = xml.eval(message)
			activitysXML = xml.find(activityXML, "activitys")
		end)

		if not activitysXML then
			return {},""
		end

		local ret = {}
		for k,v in pairs(activitysXML) do
			if type(v) == "table" then
				table.insert(ret,{ source = v.source, version = v.version or "1" })
				for k2,v2 in pairs(v) do
					ret[#ret][k2] = v2
				end
			end
		end
		return ret,activitysXML.url_root or ""
	end

	local function loadConfigs(activitys,cb)
		assert(type(cb) == "function")

		local ret = {}
		local count = 0
		if count >= #activitys then 
			cb(ret)
			return
		end

		if isReload then 
			print("CCFileUtils purgeCachedEntries")
			CCFileUtils:sharedFileUtils():purgeCachedEntries()	
		end

		local function loadError(idx)
			count = count + 1
			if count >= #activitys then 
				cb(ret)
			end
		end

		local function loadSuccess(idx)

			local source = activitys[idx].source

			if __WIN32 then
				require("activity/" .. source)
				table.insert(ret,activitys[idx])				
			elseif pcall(function() require("activity/" .. source) end) then
				table.insert(ret,activitys[idx])
			else
				print("require activity/" .. source .. " error")
				loadError(idx)
				return
			end

			count = count + 1
			if count >= #activitys then 
				cb(ret)
			end
		end

		for i,v in ipairs(activitys) do
			if isReload then 
				local metaLua = v.source:gsub(".lua","_meta.lua")
				unrequire("activity/"..metaLua)
			end

			loadActivityRes(
				v.source,
				v.version,
				{ v.source },
				{},
				function() 
					if isReload then 
						unrequire("activity/" .. v.source)
					end
					loadSuccess(i) 
				end,
				function() loadError(i) end
			)

		end
	end

	if __WIN32 then
		-- url = "http://127.0.0.1:81/activity_config.xml"
		local xmlPath = HeResPathUtils:getResCachePath() .. "/../activity/activity_config.xml"

		print(xmlPath)

		local file = io.open(xmlPath,"r")
		if not file then
			onError()
		else
			local xmlContent = file:read("*all")
			file:close()

			local activitys = nil
			activitys,_rootUrl = parseConfig(xmlContent)
			
			if activitys then
				loadConfigs(activitys,onSuccess)
				_loadFromNetwork = true
			else
				print("parse activity config error")
				onError()
			end
		end
	else

	    local function onCallback(response)
	    	local activitys = nil
			if response.httpCode ~= 200 then 
				print("get activity config error code:" .. response.body)

				tryCount = tryCount - 1
				if tryCount > 0 then 
					requestConfig(onSuccess,onError,tryCount,isReload)	
					return
				else
					if isReload then 	
						onError()
						return
					else
						_loadFromNetwork = false
						local cache = readCacheConfig()
						if cache then
							activitys,_rootUrl = parseConfig(cache)
						end
					end
				end
			else
				_loadFromNetwork = true
				_lastRequestTime = Localhost:time()
				writeCacheConfig(response.body)

				activitys,_rootUrl = parseConfig(response.body)
			end

			if activitys then
				loadConfigs(activitys,onSuccess)
			else
				print("parse activity config error")
				onError()
			end
	  	end

		local url = NetworkConfig.maintenanceURL
		local uid = UserManager.getInstance().uid
		local params = string.format("?name=activity_config&uid=%s&_v=%s", uid, _G.bundleVersion)
		url = url .. params

	  	print("ActivityUtil:", url)
		local request = HttpRequest:createGet(url)
	    request:setConnectionTimeoutMs(1 * 1000)
	    request:setTimeoutMs(30 * 1000)


	    if not PrepackageUtil:isPreNoNetWork() then 
	    	if _lastRequestTime + 30 * 60 * 1000 < Localhost:time() then 
	    		-- HttpClient:getInstance():sendRequest(onCallback, request)
	    		if ResManager:getInstance().requestActivityConfig then 
	    			ResManager:getInstance():requestActivityConfig(onCallback, request)
	    		end
	    	else
	    		onSuccess(_activitys)	    		
	    	end
	    else
	    	print("ActivityUtil================no network prepackage")
	    end
	end
end

local function isInWhiteList( activityConfig )

	local actInfo = table.find(UserManager:getInstance().actInfos or {},function(v)
		return v.actId == activityConfig.actId
	end)

	-- 联网活动在线
	if actInfo then
		return actInfo.see
	end

	-- 没actInfo以本地为准,前提isSupport return true
	local whiteList = activityConfig.whiteList
	if not whiteList then
		return true
	end

	if whiteList == "" then
		return true
	end

	return table.includes(whiteList:split(","),tostring(UserManager:getInstance().uid))
end


local function filter( activitys )

	local ret = {}
	for k,v in pairs(activitys) do
		local config = require("activity/" .. v.source)
			
		local result = false
		if config.isSupport and pcall(function( ... ) result = config.isSupport() end) then
			-- 白名单判断
			if result then 
				if type(config.isInWhiteList) == "function" then
					result = config.isInWhiteList(v)
				else
					result = isInWhiteList(v)
				end
			end
		end

		if result then
			ret[#ret + 1] = v
		end
	end
	return ret
end 


-- getRootUrl
function ActivityUtil:getRootUrl()
	return _rootUrl
end


-- 获取对应的活动配置
local callbacks = {}
function ActivityUtil:getActivitys(callback)
	if callback == nil then 
		return filter(_activitys or {}),_loadFromNetwork
	end

	if _activitys then
		callback(filter(_activitys),_loadFromNetwork)
		return
	end

	callbacks[#callbacks + 1] = callback
	if #callbacks > 1 then
		return
	end
	callback = function( ... ) 
		for _,v in pairs(callbacks) do v(...) end  
		callbacks = {}
	end

	local function requestSuccess(activitys)
		_activitys = activitys
		callback(filter(_activitys),_loadFromNetwork)
	end

	local function requestError()
		_activitys = {}
		callback({})
	end

	requestConfig(requestSuccess,requestError,1,false)
end

function ActivityUtil:getNetworkActivitys(callback)
	if callback == nil then
		local activitys,loadFromNetwork = ActivityUtil:getActivitys()
		if not loadFromNetwork then 
			activitys = {}
		end
		return activitys
	end

	ActivityUtil:getActivitys(function(activitys,loadFromNetwork)
		if not loadFromNetwork then 
			activitys = {}
		end
		callback(activitys)
	end)
end


-- 重新加载活动配置
function ActivityUtil:reloadActivitys(callback)
	if not _activitys then 
		callback(nil)
		return 
	end

	local oldConfigs = {}
	local oldActivitys = _activitys
	for _,v in pairs(oldActivitys) do
		oldConfigs[v.source] = require("activity/" .. v.source)

		local source = v.source
		local metaLua = source:gsub(".lua","_meta.lua")

		-- for _,s in pairs({source,metaLua}) do
		-- 	ResManager:getInstance():removeResourcesMap("src/activity/" .. s)
		-- 	unrequire("activity/" .. s)
		-- end
	end

	local function requestSuccess(activitys)
		for _,v in pairs(oldActivitys) do
			local newActivity = table.find(activitys,function(a) return v.source == a.source end)
			-- 下线或者有更新
			local config = oldConfigs[v.source]
			if config and (newActivity == nil or newActivity.version ~= v.version or __WIN32) then
				
				if config.notice and type(config.notice) == "string" then
					CCTextureCache:sharedTextureCache():removeTextureForKey(
						CCFileUtils:sharedFileUtils():fullPathForFilename("activity/" .. config.notice)
					)
				end
				if config.icon then
					if type(config.icon) == "string" then 
						CCTextureCache:sharedTextureCache():removeTextureForKey(
							CCFileUtils:sharedFileUtils():fullPathForFilename("activity/" .. config.icon)
						)
					elseif type(config.icon) == "table" then
						for _,v in pairs(config.icon.resource or {}) do
							if string.ends(v,".json") then 
								InterfaceBuilder:removeLoadedJson("activity/" .. v)
							end
						end
						for _,v in pairs(config.icon.src or {}) do
							ResManager:getInstance():removeResourcesMap("src/activity/" .. v)
							unrequire("activity/" .. v)
						end
					end
				end

				for _,v in pairs(config.resource or {}) do
					if string.ends(v,".strings") then
						Localization:getInstance():removeFile("activity/" .. v)
					elseif string.ends(v,".json") then 
						InterfaceBuilder:removeLoadedJson("activity/" .. v)
					end
				end
				for _,v in pairs(config.src or {}) do
					ResManager:getInstance():removeResourcesMap("src/activity/" .. v)
					unrequire("activity/" .. v)
				end
				for _,v in pairs(config.resource or {}) do
					ResManager:getInstance():removeResourcesMap("activity/" .. v)
				end
			end
		end

		CCFileUtils:sharedFileUtils():purgeCachedEntries()

		_activitys = activitys
		callback(filter(_activitys))
	end

	local function requestError()		
		callback(filter(_activitys))
	end

	requestConfig(requestSuccess,requestError,1,true)

end

-- 下载对应活动的资源
function ActivityUtil:loadRes(source,version,onSuccess,onError,onProcess)
	assert(_rootUrl)
	assert(type(source) == "string")
	assert(type(version) == "string")

	local animation = nil
	if onProcess == nil then
		animation = CountDownAnimation:createActivityAnimation(
			Director.sharedDirector():getRunningScene(),
			function( ... )
				onSuccess = nil
				onError = nil
				animation:removeFromParentAndCleanup(true)
				animation = nil
			end
		)
		onProcess = function( data )

			print("onProcess:" .. table.serialize(data))
		end
	end


	local function loadError()
		if animation then 
			animation:removeFromParentAndCleanup(true)
		end
		if onError then onError() end 
	end

	local function loadFileSuccess(config)

		-- 加载文案
		for k,v in pairs(config.resource) do
			if string.ends(v,".strings") then
				Localization:getInstance():loadFile("activity/" .. v)
			end
		end

		-- 替换关卡花
		if config.autoLua and config.autoLua ~= "" then
			if __WIN32 then
				require("activity/" .. config.autoLua)
			else
				pcall(function() require("activity/" .. config.autoLua) end)
			end
		end

		local key = "activity." .. source:gsub("/",".")	
		CCUserDefault:sharedUserDefault():setStringForKey(key, version)
		CCUserDefault:sharedUserDefault():flush()
		-- if type(self.onActivityButtonStatusChange) == "function" then
		-- 	self.onActivityButtonStatusChange()
		-- end
		for k,v in pairs(self.onActivityStatusChangeCallbacks) do
			v.func(v.obj,source)
		end



		if animation then
			animation:removeFromParentAndCleanup(true)
		end
		if onSuccess then onSuccess() end		
	end


	local function loadConfigSuccess()
		local config = require("activity/" .. source)

		loadActivityRes(
			source,
			version,
			config.src,
			config.resource,
			function( ... )loadFileSuccess(config)end,
			loadError,
			onProcess
		)

	end

	loadActivityRes(source,version,{source},{},loadConfigSuccess,loadError)
	
end

-- 获取缓存活动对应的版本
function ActivityUtil:getCacheVersion(source)
	local key = "activity." .. source:gsub("/",".")
	return CCUserDefault:sharedUserDefault():getStringForKey(key, "")
end

-- 下载宣传图
function ActivityUtil:loadNoticeImage(source,version,onSuccess,onError)
	assert(_rootUrl)
	assert(type(source) == "string")
	assert(type(version) == "string")


	local function loadError()
		if onError then onError() end
	end
	local function loadNoticeSuccess()
		if onSuccess then onSuccess() end
	end

	local function loadConfigSuccess()
		local config = require("activity/" .. source)

		if not config or not config.notice then 
			loadError()
		else
			loadActivityRes(source,version,{},{config.notice},loadNoticeSuccess,loadError)
		end
	end

	loadActivityRes(source,version,{source},{},loadConfigSuccess,loadError)	

end

function ActivityUtil:loadIconRes(source,version,onSuccess,onError)

	local function loadError()
		if onError then onError() end
	end
	local function loadIconSuccess()
		if onSuccess then onSuccess() end
	end

	local function loadConfigSuccess()
		local config = require("activity/" .. source)

		if not config or not config.icon then 
			loadError()
		else
			if type(config.icon) == "string" then
				loadActivityRes(source,version,{},{config.icon},loadIconSuccess,loadError)
			elseif type(config.icon) == "table" then
				loadActivityRes(source,version,config.icon.src,config.icon.resource,loadIconSuccess,loadError)
			else
				loadError()				
			end
		end
	end

	loadActivityRes(source,version,{source},{},loadConfigSuccess,loadError)
end

-- 执行关卡树等逻辑替换操作
function ActivityUtil:executeAutoLua(source,version)

	if not pcall(function() require("activity/" .. source) end) then
		return
	end

	local config = require("activity/" .. source)
	if config.autoLua and config.autoLua ~= "" then 
		local function onSuccess()
			if __WIN32 then
				require("activity/" .. config.autoLua)
			else
				pcall(function() require("activity/" .. config.autoLua)  end)
			end
		end
		local function onError()
		end
		ActivityUtil:loadRes(source,version,onSuccess,onError)
	end
end

function ActivityUtil:isNoMarkActivity(actId)
	if actId == 15 then return true end
	return false
end

function ActivityUtil:getMsgNum( source )
	if not pcall(function() require("activity/" .. source) end) then
		return 0
	end

	if not _activitys or not table.find(filter(_activitys),function(v) return v.source == source end) then
		return 0
	end

	local config = require("activity/" .. source)

	if not config.actId or self:isNoMarkActivity(config.actId) then
		return 0
	end

	local actInfos = UserManager:getInstance().actInfos
	if not actInfos then 
		return 0
	end

	for k,v in pairs(actInfos) do
		if v.actId == config.actId then
			return v.msgNum
			-- return 1
		end
	end

	return 0
end

--[[
	>1.9 
]]
function ActivityUtil:setMsgNum( source, num )
	
	local config = require("activity/" .. source)
	if not config.actId or self:isNoMarkActivity(config.actId) then
		return
	end

	local actInfos = UserManager:getInstance().actInfos
	if not actInfos then 
		return
	end

	for k,v in pairs(actInfos) do
		if v.actId == config.actId then
			v.msgNum = num
		end
	end

	-- if type(self.onActivityButtonMsgNumChange) == "function" then 
	-- 	self.onActivityButtonMsgNumChange(source)
	-- end

	-- if type(self.onActivitySceneMsgNumChange) == "function" then
	-- 	self.onActivitySceneMsgNumChange(source)
	-- end

	for k,v in pairs(self.onActivityStatusChangeCallbacks) do
		v.func(v.obj,source)
	end

end

--[[
	>1.9
]]
function ActivityUtil:refresh()
	local curScene = Director.sharedDirector():getRunningScene()
	if curScene and curScene:is(ActivityScene) then 
		curScene:refresh(ActivityUtil:getNoticeActivitys())
	end
end

--[[
	>1.12
]]
-- function ActivityUtil:getManualResourceSize( ... )
-- 	return 300 * 1024
-- end
function ActivityUtil:getSize( source )

	if __WIN32 then 
		return 1
	end

	local metaLua = source:gsub(".lua","_meta.lua")
	local meta = {}
	pcall(function( ... ) meta = require("activity/" .. metaLua) end)

	local config = require("activity/" .. source) 
	local totalSize = 0
	for k,v in pairs(config.src or {}) do
		if meta[v] then 
			totalSize = totalSize + (meta[v].size or 1)
		end
	end	
	for k,v in pairs(config.resource or {}) do
		if meta[v] then 
			totalSize = totalSize + (meta[v].size or 1)
		end
	end	

	return totalSize

end

-- function ActivityUtil:hasNewActivity( ... )
	
-- 	for k,v in pairs(filter(_activitys)) do
-- 		if self:getCacheVersion(v.source) == "" then 
-- 			return true	
-- 		end
-- 	end

-- 	return false
-- end
function ActivityUtil:hasRewardMark( source )
	
	local config = require("activity/" .. source)
	if not config.actId or self:isNoMarkActivity(config.actId) then
		return false
	end

	if not _activitys or not table.find(filter(_activitys),function(v) return v.source == source end) then
		return false
	end

	local actInfos = UserManager:getInstance().actInfos
	if not actInfos then 
		return false
	end

	for k,v in pairs(actInfos) do
		if v.actId == config.actId then
			return v.reward or false
		end
	end

	return false
end

function ActivityUtil:clearRewardMark( source )
	local config = require("activity/" .. source)
	if not config.actId or self:isNoMarkActivity(config.actId) then
		return 
	end

	local actInfos = UserManager:getInstance().actInfos
	if not actInfos then 
		return 
	end

	for k,v in pairs(actInfos) do
		if v.actId == config.actId then
			v.reward = false
		end
	end

	-- if type(self.onActivityButtonMsgNumChange) == "function" then 
	-- 	self.onActivityButtonMsgNumChange(source)
	-- end

	-- if type(self.onActivitySceneMsgNumChange) == "function" then
	-- 	self.onActivitySceneMsgNumChange(source)
	-- end

	for k,v in pairs(self.onActivityStatusChangeCallbacks) do
		v.func(v.obj,source)
	end
end

function ActivityUtil:getBeginTime( source )
	local config = require("activity/" .. source)
	if not config.actId then
		return -1
	end

	local actInfos = UserManager:getInstance().actInfos
	if not actInfos then 
		return -1
	end

	for k,v in pairs(actInfos) do
		if v.actId == config.actId then
			return v.beginTime or -1
		end
	end

	return -1
end

function ActivityUtil:isSrcLoaded( files,version )
	if type(files) == "string" then
		files = {files}
	end

	for _,v in pairs(files) do
		local virtualPath = "src/activity/" .. v

		if ResManager:getInstance():getFileSize(virtualPath) <= 0 then 
			return false
		end
	end

	return true
end
function ActivityUtil:isResourceLoaded( files,version )
	if type(files) == "string" then 
		files = {files}
	end

	for _,v in pairs(files) do
		local virtualPath = "activity/" .. v

		if ResManager:getInstance():getFileSize(virtualPath) <= 0 then 
			return false
		end
	end

	return true
end

function ActivityUtil:getNoticeActivitys( ... )
	local activitys = {}
	for _,v in pairs(ActivityUtil:getActivitys()) do
		local config = require("activity/" .. v.source)
		if config.notice then 
			table.insert(activitys,v)
		end
	end
	return activitys
end

function ActivityUtil:getIconActivitys( ... )
	local activitys = {}
	for _,v in pairs(ActivityUtil:getActivitys()) do
		local config = require("activity/" .. v.source)
		if config.icon then 
			table.insert(activitys,v)
		end
	end
	return activitys
end