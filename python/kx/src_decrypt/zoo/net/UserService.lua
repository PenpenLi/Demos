require "zoo.data.UserManager"
require "zoo.util.MemClass"

-------------------------------------------------------------------------
--  Class include: UserService
-------------------------------------------------------------------------

--
-- UserService ---------------------------------------------------------
--
local instance = nil
UserService = class(UserManager)

function UserService:getInstance()
	if not instance then 
		instance = UserService.new() 

		--local storage
		instance.httpData = HttpDataInfo.new()
		if __WP8 then instance.ingameHttpData = HttpDataInfo.new() end
		instance.levelDataInfo = LevelDataInfo.new()
		instance.metals = {}
	end
	return instance
end

local function encodeListDataRef( list )
	local dst = {}
	for i,v in ipairs(list) do dst[i] = v:encode() end
	return dst
end 

function UserService:encode()
	local dst = {}	
	dst.inviteCode = self.inviteCode
	dst.appName = self.appName
	dst.friendIds = self.friendIds
	dst.user = self.user:encode()
	dst.userExtend = self.userExtend:encode()
	dst.profile = self.profile:encode()
	dst.bag = self.bag:encode()
	dst.mark = self.mark:encode()
	dst.dailyData = self.dailyData:encode()

	dst.props = encodeListDataRef(self.props)
	dst.funcs = encodeListDataRef(self.funcs)
	dst.decos = encodeListDataRef(self.decos)
	dst.scores = encodeListDataRef(self.scores)

	dst.achis = encodeListDataRef(self.achis)
	--dst.requestInfos = encodeListDataRef(self.requestInfos) DO not save this as it require online
	dst.unLockFriendInfos = encodeListDataRef(self.unLockFriendInfos)
	dst.ladyBugInfos = encodeListDataRef(self.ladyBugInfos)

	dst.httpData = self.httpData:encode()
	if __WP8 then dst.ingameHttpData = self.ingameHttpData:encode() end
	dst.levelDataInfo = self.levelDataInfo:encode()
	dst.metals = self.metals
	
	dst.openId = self.openId
	dst.weekMatch = self.weekMatch
	dst.userReward = self.userReward
	dst.rabbitWeekly = self.rabbitWeekly

	dst.lastCheckTime = self.lastCheckTime

	dst.dimePlat = self.dimePlat
	dst.dimeProvince = self.dimeProvince
	dst.timeProps = encodeListDataRef(self.timeProps)

	dst.userType = self.userType

	return dst
end

function UserService:onLevelUpdate( win, level, totalScore )
	if 1 == win then self.levelDataInfo:onLevelWin(level, totalScore)
	else self.levelDataInfo:onLevelFail(level, totalScore) end

	if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
	else print("Did not write user data to the device.") end
end

function UserService:decodeLocalStorageData( userData )
	if userData then
		local httpData = userData.httpData
		self.httpData = HttpDataInfo.new()
		self.httpData:fromLua(httpData)

		if __WP8 then
			local ingameHttpData = userData.ingameHttpData
			self.ingameHttpData = HttpDataInfo.new()
			self.ingameHttpData:fromLua(ingameHttpData)
		end

		local levelDataInfo = userData.levelDataInfo
		--print("levelDataInfo"..table.tostring(levelDataInfo))
		self.levelDataInfo = LevelDataInfo.new()
		self.levelDataInfo:fromLua(levelDataInfo)

		local metals = userData.metals
		--print("metals"..table.tostring(metals))
		self.metals = metals or {}
	end
end

function UserService:clearCachedHttp()
	self.httpData = HttpDataInfo.new()
end
function UserService:clearCachedIngameHttp()
	self.ingameHttpData = ingameHttpData.new()
end
local function indexOfHttpData( indexID, httpDataAlreadySent )
	if httpDataAlreadySent and #httpDataAlreadySent > 0 then
		for i,v in ipairs(httpDataAlreadySent) do
			if v.id == indexID then return true end
		end
	end
	return false
end
function UserService:clearUsedHttpCache(httpDataAlreadySent)
	local list = {}
	local httpData = self.httpData:encode()
	for i,element in ipairs(httpData) do 
		if element and not indexOfHttpData(element.id, httpDataAlreadySent) then
			table.insert(list, element) 
		end
	end
	self.httpData = HttpDataInfo.new()
	self.httpData.list = list

	if __WP8 then
		list = {}
		local ingameHttpData = self.ingameHttpData:encode()
		for i,element in ipairs(ingameHttpData) do 
			if element and not indexOfHttpData(element.id, httpDataAlreadySent) then
				table.insert(list, element) 
			end
		end
		self.ingameHttpData = HttpDataInfo.new()
		self.ingameHttpData.list = list
	end

end

function UserService:setCachedHttp(httpData)
	self.httpData = HttpDataInfo.new()
	self.httpData.list = httpData
end

function UserService:setCachedIngameHttp(ingameHttpData)
	self.ingameHttpData = HttpDataInfo.new()
	self.ingameHttpData.list = ingameHttpData
end

function UserService:getCachedHttpData()
	return self.httpData:encode()
end
function UserService:getCachedIngameHttpData()
	return self.ingameHttpData:encode()
end
function UserService:cacheHttp( endpoint, body )
	local serialized = table.serialize(body)
	if __WP8 then
		if endpoint == "ingame" then -- ingame requests
			self.ingameHttpData:add(endpoint, table.deserialize(serialized))
		else -- common requests
			self.httpData:add(endpoint, table.deserialize(serialized))
		end
	else
		self.httpData:add(endpoint, table.deserialize(serialized)) --deep clone object
	end
end

function UserService:initialize()
	UserManager.getInstance():clone(self)
end

function UserService:computeFullEnergyTime()
	local fullEnergyTime = 0
	local max = UserLocalLogic:getUserEnergyMaxCount()
	local updateTime = self.user:getUpdateTime() or Localhost:time()
	local energy = self.user:getEnergy()
	local deltaEnergy = max - energy
	if deltaEnergy > 3 then
		updateTime = tonumber(updateTime)
		print(string.format("computeFullEnergyTime %f %f", updateTime, Localhost:time()))
		local user_energy_recover_time_unit = MetaManager.getInstance().global.user_energy_recover_time_unit or 480000
		fullEnergyTime = 61 + math.floor(deltaEnergy * user_energy_recover_time_unit + updateTime - Localhost:time()) / 1000
	end
	return fullEnergyTime
end

function UserService:setSyncSerial(syncSerial)
	self.syncSerial = syncSerial
end

function UserService:getSyncSerial(syncSerial)
	return self.syncSerial
end

function UserService:syncLocal()
	local requests = {}
	if __WP8 then
		local list = self:getCachedIngameHttpData()
		for k, v in ipairs(list) do table.insert(requests, v) end
	end
	local list = self:getCachedHttpData()
	for k, v in ipairs(list) do table.insert(requests, v) end
	if #requests <= 0 then return end
	local successedIngame, successed = {}, {}
	for i, element in ipairs(requests) do
		local success = true
		local body = element.body
		if element.endpoint == "startlevel" then
			success = Localhost:startLevel(body.levelId, body.gameMode, body.itemList, body.energyBuff, body.activityFlag, body.requestTime)
		elseif element.endpoint == "passLevel" then
			success = Localhost:passLevel(body.levelId, body.score, body.star, body.stageTime, body.coin, body.targetCount, body.opLog, body.activityFlag, body.requestTime)
		elseif element.endpoint == "useProps" then
			success = Localhost:useProps(body.type, body.levelId, body.gameMode, body.param, body.itemList, body.requestTime)
		elseif element.endpoint == "openGiftBlocker" then
			success = Localhost:openGiftBlocker(body.levelId, body.itemList)
		elseif element.endpoint == "ingame" then
			success = Localhost:ingame(body.id, body.orderId, body.channel, body.ingameType, body.detail)
		elseif element.endpoint == "getNewUserRewards" then
			success = Localhost:getNewUserRewards()
		elseif element.endpoint == "unLockLevelArea" then
			success = Localhost:unlockLevelArea(body.type, body.friendUids)
		elseif element.endpoint == "buy" then
			success = Localhost:buy(body.goodsId, body.num, body.moneyType, body.targetId)
		end
		if not success then break end
		if __WP8 and element.endpoint == "ingame" then
			table.insert(successedIngame, element)
		else
			table.insert(successed, element)
		end
	end
	self:setCachedHttp(successed)
	if __WP8 then self:setCachedIngameHttp(successedIngame) end
	local user = self.user
	local scores = self.scores
	local props = self.props
	UserManager:getInstance():updateUserData({user = user, scores = scores, props = props})
end