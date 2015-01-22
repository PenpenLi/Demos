require "zoo.net.LevelType"

require "zoo.data.UserManager"
require "zoo.data.FriendManager"

require "zoo.net.UserLocalLogic"
require "zoo.net.UserExtendsLocalLogic"
require "zoo.net.StageInfoLocalLogic"
require "zoo.net.GoodsLocalLogic"
require "zoo.net.LevelAreaLocalLogic"

local kLocalDataExt = ".ds"
local kLastLoginUserConfigName = "login"..kLocalDataExt
local kDefaultConfigName = "conf"..kLocalDataExt
-- local kOpenIdConfigName = "openId" .. kLocalDataExt
local kUpdatedConfigName = "updatedConfig" .. kLocalDataExt
local kFriendsCacheDataName = "friendsCache" .. kLocalDataExt
local kLocalExtraDataName = "localExtraData" .. kLocalDataExt
local fullPathOfLocalData = HeResPathUtils:getUserDataPath()

local instance = nil
Localhost = {}

function Localhost.getInstance()
	if not instance then instance = Localhost end
	return instance
end

function Localhost:requireLogin()
	local notLogin = not _G.kUserLogin
	local notRegistered = not Localhost:isUserRegistered()
	if NetworkConfig.useLocalServer and notLogin and notRegistered then return true
	else return false end
end
function Localhost:isUserRegistered()
	local uid = UserManager.getInstance().uid
	local sk = UserManager.getInstance().sessionKey
	if uid and sk and uid ~= sk then return true
	else return false end
end

--time
function Localhost:time()
	local time = __g_utcDiffSeconds or 0
	return (os.time() + time) * 1000
end
function Localhost:getDefaultConfig()
	local config = self:readFromStorage(kDefaultConfigName)
	if not config then config = {td=0, pl=0, gc=1} end
	if config.pl == nil then config.pl = 0 end --play CG by default.
	if config.gc == nil then config.gc = 1 end --enable game center by default.
	return config
end
function Localhost:saveTimeDiff( timeDiff )
	local timeDiff = timeDiff or 0
	print("saveTimeDiff:", timeDiff)
	local config = Localhost:getDefaultConfig() 
	config.td = timeDiff
	self:writeToStorage(config, kDefaultConfigName)
end
function Localhost:saveCgPlayed( played )
	local isPlayed = 0
	if played ~= nil then isPlayed = played end
	local config = Localhost:getDefaultConfig() 
	config.pl = played
	self:writeToStorage(config, kDefaultConfigName)
end
function Localhost:saveGmeCenterEnable( v )
	local enabled = 1
	if v ~= nil then enabled = v end
	local config = Localhost:getDefaultConfig() 
	config.gc = enabled
	self:writeToStorage(config, kDefaultConfigName)
end

-- open Id
function Localhost:setCurrentUserOpenId( openId )
	local uid = UserManager.getInstance().uid
	if uid then
		print("setCurrentUserOpenId:uid="..tostring(uid)..",openId="..tostring(openId))
		local fileName = self:getUserLocalKeyByUserID(uid)
		local userData = self:readFromStorage(fileName) or {}
		userData.openId = openId
		userData.authorType = SnsProxy:getAuthorizeType()
		--print(table.tostring(userData))
		self:writeToStorage(userData, fileName)
	else print("setCurrentUserOpenId fail, userid is nil") end
end

-- updated config
function Localhost:saveUpdatedGlobalConfig( cfg )
	if cfg and type(cfg) == "table" then
		self:writeToStorage(cfg, kUpdatedConfigName)
	end
end

function Localhost:getUpdatedGlobalConfig()
	local config = self:readFromStorage(kUpdatedConfigName)
	if not config then config = {} end
	return config
end

--login
function Localhost:getLastLoginUserConfig()
	local config = self:readFromStorage(kLastLoginUserConfigName)
	if not config then
		config = {uid=0}
	end
	print("getLastLoginUserConfig", config.uid, config.sk, config.time)
	return config
end
function Localhost:setLastLoginUserConfig(uid, sessionKey, platform)
	if uid == nil then uid = 0 end
	local time = Localhost:time()
	local config = {uid = uid, sk = sessionKey, time=time, p=platform}
	local defaultUdid = MetaInfo:getInstance():getUdid()
	if defaultUdid == sessionKey then
		print("last login udid is the same as default")
	end
	print("lua setLastLoginUserConfig", tostring(uid), tostring(sessionKey))
	self:writeToStorage(config, kLastLoginUserConfigName)
end

--user info
function Localhost:getUserLocalKeyByUserID(uid)
	assert(uid, "userid should not nil")
	local platform = UserManager.getInstance().platform
	local key = tostring(platform) .. "_u_".. tostring(uid) .. kLocalDataExt
	return key
end
function Localhost:readCurrentUserData()
	local currUuid = kDeviceID
	local fileName = self:getUserLocalKeyByUserID(UserManager.getInstance().uid)
	local readData = self:readFromStorage(fileName)
	if readData then
		local readUuid = readData.uuid
		if currUuid == readUuid then return readData		
		else
			print("Waining:Verify user data fail. invalid UUID!")
			return nil
		end
	else 
		print("Waining:Local user data not found!")
		return nil
	end
end
function Localhost:readUserDataByUserID( uid )
	local currUuid = kDeviceID
	local fileName = self:getUserLocalKeyByUserID(uid)
	local readData = self:readFromStorage(fileName)
	if readData then
		print("flushCurrentUserData:"..table.tostring(readData.openId))
		local readUuid = readData.uuid
		if currUuid == readUuid then return readData		
		else
			print("Waining:Verify user data fail. invalid UUID!")
			return nil
		end
	else 
		print("Waining:Local user data not found!")
		return nil
	end
end

function Localhost:flushCurrentUserData()
	local uid = UserManager.getInstance().uid
	if uid then
		local fileName = self:getUserLocalKeyByUserID(uid)
		local userData = self:readFromStorage(fileName) or {}
		userData.user = UserService.getInstance():encode()
		userData.uuid = kDeviceID

		print("flushCurrentUserData:"..table.tostring(userData.openId))
		print(table.tostring(userData.user.lastCheckTime))
		self:writeToStorage(userData, fileName)
	else print("flushCurrentUserData fail, userid is nil") end
end
function Localhost:flushSelectedUserData( userData )
	local fileName = self:getUserLocalKeyByUserID(UserManager.getInstance().uid)
	self:writeToStorage(userData, fileName)
end

function Localhost:readLastLoginUserData()
	local savedConfig = Localhost.getInstance():getLastLoginUserConfig()
	if savedConfig.uid ~= 0 then
		local uid = tostring(savedConfig.uid)
		local sessionKey = tostring(savedConfig.sk)
		local platform = tostring(savedConfig.p)
		local fileName = platform .. "_u_" .. uid .. kLocalDataExt
		return self:readFromStorage(fileName)
	end
	return nil
end

--friends
function Localhost:flushCurrentFriendsData()
	local fileName = self:getUserLocalKeyByUserID(UserManager.getInstance().uid)
	local userData = self:readFromStorage(fileName) or {}

	if not userData.user then
		print("What? user data not found?")
		userData.user = UserService.getInstance():encode()
	end

	userData.friends = FriendManager.getInstance():encode()
	self:writeToStorage(userData, fileName)
end

--将string中的内容以二进制的方式写入文件,
--	此方法先创建临时文件，将内容写入临时文件，
--	最后把临时文件move成正式文件
--	注意： **此方法仅限于文件内容较少，并且一次性写入的调用
function Localhost:writeToStorage(data, fileName)
	assert(data and fileName, "data and fileName should not be nil")
    if data and fileName then
    	local filePath = fullPathOfLocalData.."/"..fileName
        local am3data = amf3.encode(data)
        --TODO: encypt data
        self:safeWriteStringToFile(am3data, filePath)
    end
end

function Localhost:deleteLastLoginUserConfig()
	local filePath = fullPathOfLocalData.."/"..kLastLoginUserConfigName
	print("delete local last login data")
   	os.remove(filePath)
end
function Localhost:deleteUserDataByUserID( uid )
	local fileName = self:getUserLocalKeyByUserID(uid)
	local filePath = fullPathOfLocalData.."/"..fileName
	print("delete local user data, uid:"..tostring(uid))
   	os.remove(filePath)
end
function Localhost:deleteGuideRecord()
	local filePath = fullPathOfLocalData.."/guiderec"
	print("delete local guide data")
   	os.remove(filePath)
end
function Localhost:deletePushRecord()
	local filePath = fullPathOfLocalData.."/pushrec"
	print("delete local push data")
   	os.remove(filePath)
end
function Localhost:deleteMarkPriseRecord()
	local filePath = fullPathOfLocalData.."/markprise"
	print("delete local guide data")
   	os.remove(filePath)
end
function Localhost:flushLocalExtraData(data)
	if data == nil then return end
	self:writeToStorage(data, kLocalExtraDataName)
end
function Localhost:readLocalExtraData()
	return self:readFromStorage(kLocalExtraDataName)
end
function Localhost:deleteLocalExtraData()
	print("delete LocalExtraData")
   	os.remove(kLocalExtraDataName)
end
function Localhost:safeWriteStringToFile(data, filePath)
    local tmpName = filePath .. "." .. os.time()
    local file = io.open(tmpName, "wb")
    assert(file, "persistent file failure " .. tmpName)
    if not file then return end

    local success = file:write(data)
   
    if success then
        file:flush()
        file:close()
        os.remove(filePath)
        os.rename(tmpName, filePath)
    else
        file:close()
        os.remove(tmpName)
        print("write file failure " .. tmpName)
    end        
end

function Localhost:readFromStorage( fileName )
	assert(fileName, "fileName should not be nil")
	if fileName then
		local filePath = fullPathOfLocalData.."/"..fileName
		local file = io.open(filePath, "rb")
		if file then
			local data = file:read("*a") 
			file:close()

			if data then
				local result = nil 
				local function decodeAmf3() result = amf3.decode(data) end
				--TODO: decypt data
				pcall(decodeAmf3)
				return result
				--return amf3.decode(data)
			end
		end
	end
	return nil
end

--
-- local service interface ---------------------------------------------------------
--

function Localhost:setImage(image)
	UserService.getInstance().user.image = image

	if NetworkConfig.writeLocalDataStorage then self:flushCurrentUserData()
	else print("Did not write user data to the device.") end
	return true
end

--http://svn.happyelements.net/repos/svndata2/animal/java/trunk/animal-service/src/main/java/com/happyelements/animal/delegate/impl/LevelDelegateImpl.java
function Localhost:startLevel(levelId, gameMode, itemList, energyBuff, gameLevelType, requestTime) -- qixi
	itemList = itemList or {}
	local user = UserService.getInstance().user
	local uid = user.uid

	local updateTime = user:getUpdateTime()
	local now = Localhost:time()
	if type(requestTime) ~= "number" then requestTime = now end
	if requestTime < updateTime or requestTime > now then
		return false, ZooErrorCode.LEVEL_INVALID_REQUEST_TIME
	end

	--not hide level
	gameLevelType = gameLevelType or LevelType:getLevelTypeByLevelId(levelId)
	if gameLevelType == GameLevelType.kMainLevel then
		local topLevelId = user:getTopLevelId()
		if not PublishActUtil:isGroundPublish() then 
			if levelId > topLevelId then
				return false, ZooErrorCode.LEVEL_ID_INVALID_START_LEVEL
			end
		end
	end

	--TODO: implements Rabbt mode.
	--On local server mode, we don not verify Stage Info.
	StageInfoLocalLogic:initStageInfo(uid, levelId, itemList)

	local success,err = UserLocalLogic:startLevel( uid, levelId, gameMode, itemList, energyBuff, requestTime, gameLevelType)

	-- if activityEntry then
	-- 	success,err = UserLocalLogic:startActivityLevel( uid, levelId, gameMode, itemList, energyBuff, requestTime, activityEntry) -- qixi
	-- else
	-- 	success,err = UserLocalLogic:startLevel( uid, levelId, gameMode, itemList, energyBuff, requestTime, activityEntry)
	-- end
	return success,err
end

function Localhost:passLevel(levelId, score, flashStar, stageTime, coinAmount, targetCount, opLog, gameLevelType, requestTime)
	--todo: check if user used item.
	local useItem = 0
	local user = UserService.getInstance().user
	local uid = user.uid

	local updateTime = user:getUpdateTime()
	local now = Localhost:time()
	if type(requestTime) ~= "number" then requestTime = now end
	if requestTime < updateTime or requestTime > now then
		return {}, false, ZooErrorCode.LEVEL_INVALID_REQUEST_TIME
	end

	local stageInfo = StageInfoLocalLogic:clearStageInfo(uid)
	if stageInfo and not stageInfo:isEmpty() then useItem = 1 end

	local rewardItems, success, err

	gameLevelType = gameLevelType or LevelType:getLevelTypeByLevelId(levelId)
	print("passLevel : gameLevelType", gameLevelType)
	if gameLevelType == GameLevelType.kQixi then
		rewardItems, success, err = UserLocalLogic:updateActivityLevelScore(levelId, score, flashStar, useItem, stageTime, coinAmount, targetCount, opLog, gameLevelType, requestTime)
	elseif gameLevelType == GameLevelType.kMainLevel then
		rewardItems, success, err = UserLocalLogic:updateScore(levelId, score, flashStar, useItem, stageTime, coinAmount, opLog, requestTime)
	elseif gameLevelType == GameLevelType.kHiddenLevel then
		rewardItems, success, err = UserLocalLogic:updateHideLevelScore(levelId, score, flashStar, useItem, stageTime, coinAmount, opLog, requestTime)
	elseif gameLevelType == GameLevelType.kDigWeekly then
		rewardItems, success, err = UserLocalLogic:updateDiggerMatchLevelScore(levelId, score, flashStar, useItem, stageTime, targetCount, opLog, requestTime)
	elseif gameLevelType == GameLevelType.kMayDay then
		rewardItems, success, err = UserLocalLogic:updateMaydayEndlessLevelScore(levelId, score, flashStar, useItem, stageTime, targetCount, opLog, requestTime)
	elseif gameLevelType == GameLevelType.kRabbitWeekly then
		rewardItems, success, err = UserLocalLogic:updateRabbitWeeklyLevelScore(levelId, score, flashStar, stageTime, coinAmount, targetCount, opLog, gameLevelType, requestTime)
	elseif gameLevelType == GameLevelType.kTaskForRecall then 
		rewardItems, success, err = UserLocalLogic:updateRecallTaskLevelScore(levelId, score, flashStar, useItem, stageTime, targetCount, opLog, requestTime)
	else
		assert(false, 'level type not supported')
	end

	return rewardItems, success, err
end

function Localhost:useProps( itemType, levelId, gameMode, param, itemList, requestTime )
	local user = UserService.getInstance().user
	local uid = user.uid
	
	local updateTime = user:getUpdateTime()
	local now = Localhost:time()
	if type(requestTime) ~= "number" then requestTime = now end
	if requestTime < updateTime or requestTime > now then
		return false, ZooErrorCode.LEVEL_INVALID_REQUEST_TIME
	end

	if itemList and #itemList < 1 then return true end
	for i,itemId in ipairs(itemList) do
		local propMeta = MetaManager.getInstance():getPropMeta(itemId)
		local unlock = propMeta and propMeta.unlock or 1
		if levelId > 0 and levelId < unlock then
			return false, ZooErrorCode.USE_PROP_LEVEL_ERROR
		end
	end

	if itemType == 1 then
		StageInfoLocalLogic:subTempProps( uid, itemList )
	end
	
	if itemType == 2 then
		local consumes = {}
		for i,itemId in ipairs(itemList) do
			local consume = ConsumeItem.new(itemId, 1)
			table.insert(consumes, consume)
		end

		local succeed, err = ItemLocalLogic:hasConsumes(uid, consumes)
		if succeed then
			succeed, err = ItemLocalLogic:consumes(uid, consumes)
			if not succeed then return false, err end
		else return false, err end

		local rewards = {}
		local accelerateOnce = false
		for i,itemId in ipairs(itemList) do
			local propMeta = MetaManager.getInstance():getPropMeta(itemId)
			local metareward = propMeta and propMeta.reward or 0
			local propValue = propMeta and propMeta.value or 0

			if metareward == PropRewardType.PROP_REWARD_TYPE_COIN then
				table.insert(rewards, RewardItemRef.new(ItemConstans.ITEM_COIN, propValue))
			elseif metareward == PropRewardType.PROP_REWARD_TYPE_ENERGY then
				table.insert(rewards, RewardItemRef.new(ItemConstans.ITEM_ENERGY, propValue))
			elseif metareward == PropRewardType.PROP_REWARD_TYPE_MOVE then
				StageInfoLocalLogic:addBuyMove(uid, propValue)
			elseif metareward == PropRewardType.PROP_REWARD_TYPE_GOLD_BEAN then
				local bean = ItemConstans.ITEM_TYPE_PROP * ItemConstans.ITEM_TYPE_RANGE + ItemConstans.PROP_GOLD_BEAN
				table.insert(rewards, RewardItemRef.new(bean, propValue))
			elseif metareward == PropRewardType.PROP_REWARD_TYPE_ACCELERATE_FURIT then
				print("TODO: implements fruits service")
			elseif metareward == PropRewardType.PROP_REWARD_TYPE_ENERGY_PLUS then
				UserExtendsLocalLogic:extraEenrgy(uid, propMeta)
			elseif metareward == PropRewardType.PROP_REWARD_TYPE_NOT_CONSUME_ENERGY then
				UserExtendsLocalLogic:notConsumeEnergyBuff(uid, propValue)
			end
		end
		ItemLocalLogic:rewards( uid, rewards, requestTime )
	end
	return true
end

function Localhost:openGiftBlocker( levelId, itemList )
	local user = UserService.getInstance().user
	local uid = user.uid
	StageInfoLocalLogic:openGiftBlocker(uid, levelId, itemList)
	return true
end

--
-- sync service data ---------------------------------------------------------
--
function Localhost:sellProps( itemID, num )
	local user = UserService.getInstance().user
	local uid = user.uid
	local propMeta = MetaManager.getInstance():getPropMeta(itemId)
	if not propMeta then return false end
	local sellPrice = propMeta.sell or 0
	if sellPrice < 1 then return false end
	consume = ConsumeItem.new(itemID, num)
	local succeed, err = ItemLocalLogic:hasConsume(uid, consume)
	if succeed then succeed, err = ItemLocalLogic:consume(uid, consume) end
	local rewardItem = RewardItemRef.new(ItemConstans.ITEM_COIN, sellPrice * num)
	return ItemLocalLogic:rewards( uid, {rewardItem} )
end


function Localhost:mark()
	local uid = UserService.getInstance().user.uid
	local markNum = UserManager.getInstance().mark.markNum
	UserService.getInstance().mark.markNum = markNum
	UserService.getInstance().mark.markTime = UserManager.getInstance().mark.markTime

	local markMeta = MetaManager.getInstance():getMarkByNum(markNum)
	if markMeta then ItemLocalLogic:rewards(uid, markMeta.rewards) end --reward coin, etc.

	if NetworkConfig.writeLocalDataStorage then self:flushCurrentUserData()
	else print("Did not write user data to the device.") end

	return true
end
function Localhost:buy(goodsId , num , moneyType , targetId)
	local uid = UserService.getInstance().user.uid
	local goodsMeta = MetaManager.getInstance():getGoodMeta(goodsId)
	if not goodsMeta then return false, ZooErrorCode.CONFIG_ERROR end

	if moneyType == 1 then
		local propId = goodsMeta.items[1].itemId
		local consume = ConsumeItem.new(ItemConstans.ITEM_COIN, goodsMeta.coin * num)
		local succeed, err = ItemLocalLogic:hasConsume(uid, consume)
		if succeed then
			succeed, err = ItemLocalLogic:consume(uid, consume)
			if not succeed then return false, err end
		else return false, err end
		StageInfoLocalLogic:addTempProps(uid, propId)
		return true
	elseif moneyType == 2 then
		local price = GoodsLocalLogic:getCash( uid, goodsMeta )
		local consume = ConsumeItem.new(ItemConstans.ITEM_CASH, price * num)
		local succeed, err = ItemLocalLogic:hasConsume(uid, consume)
		if succeed then
			succeed, err = ItemLocalLogic:consume(uid, consume)
			if not succeed then return false, err end
		else return false, err end
		GoodsLocalLogic:deliverGoods(uid, goodsMeta, num, targetId)
		return true
	end
end
function Localhost:ingame( id, orderId, channel, ingameType, detail )
	return GoodsLocalLogic:ingame( id, orderId, channel, ingameType, detail )
end

function Localhost:getNewUserRewards()
	return UserLocalLogic:getNewUserRewards()
end

function Localhost:unlockLevelArea(unlockType, friendUids)
	print("Localhost:unlockLevelArea", unlockType, friendUids)
	local user = UserService:getInstance().user
	local topLevelId = user:getTopLevelId()
	local levelIds = {}
	for i = 1, topLevelId do
		levelIds[i] = UserService:getInstance():getUserScore(i)
	end
	local checkFailed = false
	if #levelIds < topLevelId then print("length not enough", #levelIds) checkFailed = true end
	if not checkFailed then
		for k, v in pairs(levelIds) do
			if v.star < 1 then
				print("star less than one", k)
				checkFailed = true
				break
			end
		end
	end

	if checkFailed then return false, ZooErrorCode.UNLOCK_AREA_ERROR_NOT_ALL_NEED_LEVEL_PASSED end

	if unlockType == 1 then -- star
		LevelAreaLocalLogic:unlcokLevelAreaByStar()
	elseif unlockType == 2 then -- gold
		LevelAreaLocalLogic:unlcokLevelAreaByGold()
	elseif unlockType == 3 then -- request friend
		LevelAreaLocalLogic:unlcokLevelAreaBySendRequest(friendUids)
	elseif unlockType == 4 then -- by friend
		LevelAreaLocalLogic:unlcokLevelAreaByFriendUids(friendUids)
	elseif unlockType == 6 then -- by animalfriends
		LevelAreaLocalLogic:unlcokLevelAreaByAnimals()
	elseif unlockType == 7 then -- by tasklevel
		LevelAreaLocalLogic:unlcokLevelAreaByTaskLevel()
	end
	return true
end