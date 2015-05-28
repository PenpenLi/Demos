

require "zoo.panel.AdVideoPanel"
if __IOS then 
	require "zoo.util.YoumiVideoManager"
	require "zoo.util.ChukongVideoManager"
end

AdVideoManager = class()

local PLAY_VIDEO_TIME_INTERVAL = 8 * 60 * 1000
local PLAY_VIDEO_LEVEL = 20
local PLAY_VIDEO_CACHE_FILE = HeResPathUtils:getUserDataPath() .. "/PlayVideoCache" 
local video_list = {
	kYoumi = 1,
	kChukong = 2,
}
local instance = nil 
local ADVIDEO_MANAGER_MAINTENANCE_KEY = "AdVideo"

function AdVideoManager:getInstance()
	if instance then return instance end
	instance = AdVideoManager.new()
	instance:init()
	return instance
end

function AdVideoManager:init( ... )
	-- body
	self.leftPlayTimes = UserManager:getInstance():getDailyData().videoAdRewardLeft
	self.videoAdReward = UserManager:getInstance():getDailyData().videoAdReward

	local videoAdReward = UserManager:getInstance():getDailyData().videoAdCycle
	self.videoAdCycle = {}
	for k = 1, #videoAdReward do 
		local item = videoAdReward[k]
		if item.key == "youmi" then
			self.videoAdCycle[video_list.kYoumi] = tonumber(item.value)
		elseif item.key == "chukong" then
			self.videoAdCycle[video_list.kChukong] = tonumber(item.value)
		end
	end
	self.isNoAdVideo = false
	self.timeInterval = PLAY_VIDEO_TIME_INTERVAL
	self.tryPlayVideoAdTimes = 0
	self.lastPlayVideoType = 0
	self:readCache()
end

function AdVideoManager:getLastPlayTime( ... )
	-- body
	return self.dataCache.lastPlayTime
end

function AdVideoManager:readCache( ... )
	-- body
	local file = io.open(PLAY_VIDEO_CACHE_FILE, "r")
	self.dataCache = {}
	if file then
		local data = file:read("*a") 
		file:close()
		if data then
			self.dataCache = table.deserialize(data) or {}
		end
	end

	self.dataCache.lastPlayTime = self.dataCache.lastPlayTime or 0
	self.dataCache.lastPlayType = self.dataCache.lastPlayType or video_list.kChukong
	local today = math.floor(Localhost:time()/(24 * 60 * 60 * 1000))
	if not self.dataCache.lastPlayDay or self.dataCache.lastPlayDay ~= today then
		self.dataCache.playRecord = {}  
		for k, v in pairs(video_list) do 
			self.dataCache.playRecord[v] = 0
		end
		self.dataCache.lastPlayDay = today

	end
end

function AdVideoManager:writeCache( ... )
	-- body
	local file = io.open(PLAY_VIDEO_CACHE_FILE,"w")
	if file then 
		file:write(table.serialize(self.dataCache))
		file:close()
	end
end

function AdVideoManager:canShowBtn( ... )
	-- body
	if  __IOS and
		MaintenanceManager:getInstance():isEnabled(ADVIDEO_MANAGER_MAINTENANCE_KEY) and 
		self.leftPlayTimes > 0 and 
		UserManager:getInstance().user.topLevelId >= PLAY_VIDEO_LEVEL and
		not self.isNoAdVideo then

		local version = AppController:getSystemVersion() or 5
		if version and version >= 6 then   --ios 6 以下的不支持
			local canPlay = false
			for k, v in pairs(video_list) do 
				if self.dataCache.playRecord[v] < self.videoAdCycle[v] then
					canPlay = true
					break
				end
			end
			return canPlay
		end
	end
	return false 
end

function AdVideoManager:canShowPanel( ... )
	-- body
	local timeCountDown = (self.timeInterval + self:getLastPlayTime() - Localhost:time() )/1000
	return timeCountDown <= 0 
end

function AdVideoManager:showAdVideoPanel( wPos )
	-- body
	local panel = AdVideoPanel:create(wPos, self.videoAdReward)
	panel:popout()
end

function AdVideoManager:getReward( successCallback, failCallback )
	-- body

	local function onSuccess(event)
		if event.data.extra then
			local data = string.split(event.data.extra, ":")
			for k=1,#data do
				data[k] = tonumber(data[k])
			end

			self.leftPlayTimes = data[1]
			self.dataCache.lastPlayTime = Localhost:time();
			self:writeCache()
			UserManager:getInstance():getDailyData().leftPlayTimes = data[1]
			if data[2] and data[3] then
				UserManager:getInstance():addUserPropNumber(data[2], data[3])
				UserService:getInstance():addUserPropNumber(data[2], data[3])
				successCallback(data)
			end
			HomeScene:sharedInstance():updateAdVideoBtn()
		else
			failCallback(false)
		end
		
    end

    local function onFail(event)
       	failCallback(true)
    end
    
    local http = OpNotifyHttp.new()
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    http:load(OpNotifyType.kVideoAdPlay)
end

function AdVideoManager:getCurrentPlayType()
	local currentPlayType = 0
	for k = 1, table.size(video_list) do
		local playType = self.dataCache.lastPlayType % table.size(video_list) + 1
		self.dataCache.lastPlayType = playType
		local today = math.floor( Localhost:time()/(24*60*1000) )
		if today ~= self.dataCache.lastPlayDay then
			self.dataCache.playRecord = {}  
			for k, v in pairs(video_list) do 
				self.dataCache.playRecord[v] = 0
			end
			self.dataCache.lastPlayDay = today
		end
		if self.dataCache.playRecord[playType] < self.videoAdCycle[playType] then
			currentPlayType = playType
			self.dataCache.playRecord[playType] = self.dataCache.playRecord[playType] + 1
			break
		end
	end
	self:writeCache()
	return currentPlayType

end



function AdVideoManager:playVideoAd(successCallback, failedCallback, noVideoCallback)
	local function noAdCallback( )
		-- body
		self:playVideoAd(successCallback, failedCallback, noVideoCallback)
	end

	local function quitCallback( isFinish,resetTryTimes )
		-- body
		if not isFinish then
			failedCallback()
		end

		if resetTryTimes then
			self.tryPlayVideoAdTimes = 0
			self.lastPlayVideoType = 0
		end
	end

	local function checkLegle( isLegle )
		-- body
		if isLegle then
			successCallback()
		else
			CommonTip:showTip(Localization:getInstance():getText("watch_ad_error_1"), "negative",nil, 2)
			failedCallback(true)
		end

		self.tryPlayVideoAdTimes = 0
		self.lastPlayVideoType = 0
	end

	local function localNoAdCallback( ... )
		-- body
		noVideoCallback()
		self.isNoAdVideo = true
		HomeScene:sharedInstance():updateAdVideoBtn()
		self.tryPlayVideoAdTimes = 0
		self.lastPlayVideoType = 0
	end

	if self.tryPlayVideoAdTimes < table.size(video_list) then
		local currentPlayType = self:getCurrentPlayType()
		if self.tryPlayVideoAdTimes > 0 and self.lastPlayVideoType == currentPlayType then
			localNoAdCallback()
		else
			if currentPlayType == video_list.kYoumi then
				self.tryPlayVideoAdTimes = self.tryPlayVideoAdTimes + 1
				self.lastPlayVideoType = currentPlayType
				YoumiVideoManager:videoAdPlay( quitCallback, checkLegle, noAdCallback )
			elseif currentPlayType == video_list.kChukong then
				self.tryPlayVideoAdTimes = self.tryPlayVideoAdTimes + 1
				self.lastPlayVideoType = currentPlayType
				ChukongVideoManager:videoAdPlay(quitCallback, checkLegle, noAdCallback)
			else
				localNoAdCallback()
			end
		end
	else
		localNoAdCallback()
	end
	
end
