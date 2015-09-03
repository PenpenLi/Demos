require "zoo.net.Http" 
-------------------------------------------------------------------------
--  Class include: StartLevelHttp, PassLevelHttp, UsePropsHttp, OpenGiftBlockerHttp
-------------------------------------------------------------------------

--
-- StartLevelHttp ---------------------------------------------------------
--
StartLevelHttp = class(HttpBase) --å¼€å§‹æŸä¸ªå…³å¡

--  <request>
--	  <property code="levelId" type="int" desc="å…³å¡id" />
--    <list code="itemList" ref="int" desc="ä½¿ç”¨é“å…·" />
--	  <property code="energyBuff" type="boolean" desc="æ˜¯å¦ä½¿ç”¨æ— é™ç²¾åŠ›buff" />
--	  <property code="requestTime" type="long" desc="请求时间" />
--  </request>
function StartLevelHttp:load(levelId, itemList, energyBuff, gameLevelType)
	assert(levelId ~= nil, "levelId must not a nil")
	assert(type(itemList) == "table", "itemList not a table")

	local context = self
	local gameMode = LevelMapManager.getInstance():getLevelGameMode(levelId)
	assert(gameMode ~= nil, "gameMode id not found")

	if energyBuff == nil then energyBuff = false end
	
	local body = {levelId=levelId, gameMode=gameMode, itemList=itemList, energyBuff=energyBuff, activityFlag = gameLevelType}
	--推送召回相关 activityFlag  1为七夕关卡  2为推送召回卡关最高关卡 有特殊临时道具可用
	if RecallManager.getInstance():getRecallLevelState(levelId) then
		body = {levelId=levelId, gameMode=gameMode, itemList=itemList, energyBuff=energyBuff, activityFlag = 101}
	end

	body.requestTime = Localhost:time()

	if NetworkConfig.useLocalServer then
		print(" [ useLocalServer for StartLevelHttp ]", levelId, gameMode, itemList, energyBuff, gameLevelType)
		local success, err = Localhost.getInstance():startLevel(levelId, gameMode, itemList, energyBuff, gameLevelType)
		if success then
			if levelId == UserService.getInstance().user:getTopLevelId() then
				UserManager:getInstance().userExtend:incrTopLevelFailCount(1)
				UserService:getInstance().userExtend:incrTopLevelFailCount(1)
			end
			UserService.getInstance():cacheHttp(kHttpEndPoints.startLevel, body)
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end

			context:onLoadingComplete()
		else
			he_log_info("start level fail, err: " .. err)
			context:onLoadingError(err)
		end
		return
	end

	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("start level fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("start level success")
	    	context:onLoadingComplete()
	    end
	end
	self.transponder:call(kHttpEndPoints.startLevel, body, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- PassLevelHttp ---------------------------------------------------------
--
PassLevelHttp = class(HttpBase) --è¿‡å…³

-- dispatched event.data = response.rewardItems é€šè¿‡å…³å¡èŽ·å¾—å¥–åŠ±

--  <request>
--	  <property code="levelId" type="int" desc="å…³å¡id" />
--	  <property code="score" type="int" desc="å…³å¡å¾—åˆ†" />
--    <property code="star" type="int" desc="å…³å¡æ˜Ÿçº§" />	
--    <property code="stageTime" type="int" desc="å…³å¡æ‰€ç”¨æ—¶é—´" />
--    <property code="coin" type="int" desc="å…³å¡å†…æŽ‰è½é“¶å¸æ•°é‡" />	
--	  <property code="targetCount" type="int" desc="å…³å¡å†…æ”¶é›†çš„ç›®æ ‡æ•°é‡"/>	
--	  <property code="opLog" type="string" desc="å½“æ¬¡è¿‡å…³çš„opertaion log"/>
--	  <property code="requestTime" type="long" desc="请求时间" />
--  </request>
--  <response>
--		<list code="rewardItems" ref="Reward" desc="é€šè¿‡å…³å¡èŽ·å¾—å¥–åŠ±"/>
--	</response>
function PassLevelHttp:load(levelId, score, star, stageTime, coin, targetCount, opLog, gameLevelType)
	assert(levelId ~= nil, "levelId must not a nil")
	assert(score ~= nil, "gameMode must not a nil")
	assert(star ~= nil, "star must not a nil")
	assert(stageTime ~= nil, "stageTime must not a nil")
	assert(coin ~= nil, "coin must not a nil")

	local context = self
	print('passLevel', levelId, score, star, stageTime, coin, targetCount, opLog, gameLevelType)

	if gameLevelType == GameLevelType.kQixi and star < 1 then -- attention
		targetCount = 0
	end

	local actFlag = gameLevelType
	--召回功能最高关卡临时道具特殊处理 
	if RecallManager.getInstance():getRecallLevelState(levelId) then
		actFlag = 101
	end

	if NetworkConfig.useLocalServer then
		local cacheHttp = 
		{
			levelId=levelId, 
			score=score, 
			star=star,
			stageTime=stageTime,
			coin=coin,
			targetCount=targetCount,
			requestTime=Localhost:time(), 
			activityFlag = actFlag
		}
		
		local topLevelId = UserService:getInstance().user:getTopLevelId()
		local result, success, err = Localhost.getInstance():passLevel(levelId, score, star, stageTime, coin, targetCount, opLog, gameLevelType)
		if err ~= nil then 
			context:onLoadingError(err)
			print("PassLevelHttp fail " .. tostring(err))
		else 
			if levelId == topLevelId and star > 0 then
				UserManager:getInstance().userExtend:resetTopLevelFailCount()
				UserService:getInstance().userExtend:resetTopLevelFailCount()
			end
			UserService.getInstance():cacheHttp(kHttpEndPoints.passLevel, cacheHttp)
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end

			print("pass level success !")
			print("use local server !!")

			print(table.tostring(result).."success:"..tostring(success))
			for k,v in pairs(result) do

				if v.itemId == ItemType.COIN then		-- Coin

					-- Add Coin
					local curCoin	= UserManager:getInstance().user:getCoin()
					local newCoin	= curCoin + v.num
					UserManager:getInstance().user:setCoin(newCoin)

					DcUtil:logCreateCoin("pass_level", v.num, curCoin, levelId)

				elseif v.itemId == ItemType.ENERGY_LIGHTNING then

					-- Add Energy
					UserEnergyRecoverManager:sharedInstance():addEnergy(v.num)
				else
					-- Add Other Item
					UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
					DcUtil:logRewardItem("pass_level", v.itemId, v.num, levelId)
				end
			end
			
			context:onLoadingComplete(result) 
		end
		return
	end

	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("pass level fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("pass level success")

		
			print(table.tostring(data.rewardItems))

			for k,v in pairs(data.rewardItems) do

				if v.itemId == ItemType.COIN then		-- Coin

					-- Add Coin
					local curCoin	= UserManager:getInstance().user:getCoin()
					local newCoin	= curCoin + v.num
					UserManager:getInstance().user:setCoin(newCoin)
					DcUtil:logCreateCoin("pass_level", v.num, curCoin, levelId)

				elseif v.itemId == ItemType.ENERGY_LIGHTNING then

					-- Add Energy
					UserEnergyRecoverManager:sharedInstance():addEnergy(v.num)
				else
					-- Add Other Item
					UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
					DcUtil:logRewardItem("pass_level", v.itemId, v.num, levelId)
				end
			end
	    	context:onLoadingComplete(data.rewardItems)
	    end
	end
	
	self.transponder:call(kHttpEndPoints.passLevel, 
		{levelId=levelId, score=score, star=star,stageTime=stageTime,coin=coin,targetCount=targetCount, opLog=opLog, requestTime=Localhost:time()}, 
		loadCallback, rpc.SendingPriority.kHigh, false)
	
end

--
-- UsePropsHttp ---------------------------------------------------------
--
UsePropsHttp = class(HttpBase) --ä½¿ç”¨é“å…·

--  <request>
--	  <property code="type" type="int" desc="1:ä¸´æ—¶é“å…·,2:èƒŒåŒ…é“å…·" />
--	  <property code="levelId" type="int" desc="å½“å‰å…³å¡" />
--    <property code="gameMode" type="int" desc="æ¸¸æˆåœºæ™¯" />
--	  <property code="param" type="int" desc="param" />
--	  <list code="itemList" ref="int" desc="ä½¿ç”¨é“å…·" />
--  </request>
function UsePropsHttp:load(itemType, levelId, param, itemList)
	assert(itemType ~= nil, "itemType must not a nil")
	assert(levelId ~= nil, "levelId must not a nil")

	assert(type(itemList) == "table", "itemList not a table")

	local context = self
	local gameMode = LevelMapManager.getInstance():getLevelGameMode(levelId)
	gameMode = gameMode or 0
	param = param or 0

	local body = {type=itemType, levelId=levelId, gameMode=gameMode, param=param, itemList=itemList, requestTime=Localhost:time()}

	if NetworkConfig.useLocalServer then
		local success, err = Localhost.getInstance():useProps(itemType, levelId, gameMode, param, itemList)
		if err ~= nil then context:onLoadingError(err)
			print("UsePropsHttp fail", tostring(err), tostring(itemList))
		else 
			UserService.getInstance():cacheHttp(kHttpEndPoints.useProps, body)
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			table.each(itemList, function (v)
				DcUtil:logUseItem(v, 1, levelId)
				end)
			context:onLoadingComplete() 
		end
		return
	end

	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("useProps fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("useProps success")
	    	context:onLoadingComplete()
	    end
	end
	
	self.transponder:call(kHttpEndPoints.useProps, body, loadCallback, rpc.SendingPriority.kHigh, false)
end


--
-- OpenGiftBlockerHttp ---------------------------------------------------------
--
OpenGiftBlockerHttp = class(HttpBase) --é“å…·æŽ‰è½

--  <request>
--	  <property code="levelId" type="int" desc="å½“å‰å…³å¡" />
--	  <list code="itemList" ref="int" desc="æŽ‰è½é“å…·åˆ—è¡¨" />
--  </request>
function OpenGiftBlockerHttp:load(levelId, itemList)
	assert(levelId ~= nil, "itemID must not a nil")
	assert(type(itemList) == "table", "itemList not a table")

	local context = self
	local body = {levelId=levelId, itemList=itemList}

	if NetworkConfig.useLocalServer then
		print(" [ useLocalServer for OpenGiftBlockerHttp ]", levelId, itemList)
		Localhost.getInstance():openGiftBlocker(levelId, itemList)
		UserService.getInstance():cacheHttp(kHttpEndPoints.openGiftBlocker, body)
		if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
		else print("Did not write user data to the device.") end
		table.each(itemList, function (v)
			DcUtil:logRewardItem("gift_blocker", v, 1, levelId)
			end)
		context:onLoadingComplete()
		return
	end

	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("openGiftBlocker fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("openGiftBlocker success")
	    	context:onLoadingComplete()
	    end
	end
	
	self.transponder:call(kHttpEndPoints.openGiftBlocker, body, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetPropsInGameHttp = class(HttpBase)
function GetPropsInGameHttp:load(levelId, itemIds, actId)
	assert(type(levelId) == "number")
	assert(type(itemIds) == "table", "itemIds not a list")

	actId = actId or 0
	local context = self
	local body = {actId=actId, levelId=levelId, itemIds=itemIds}

	if NetworkConfig.useLocalServer then
		print(" [ useLocalServer for GetPropsInGameHttp ]", actId, levelId, itemIds)
		if Localhost.getInstance():getPropsInGame(actId, levelId, itemIds) then
			UserService.getInstance():cacheHttp(kHttpEndPoints.getPropsInGame, body)
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			-- table.each(itemIds, function (v)
			-- 	DcUtil:logRewardItem("gift_blocker", v, 1, levelId)
			-- 	end)
			context:onLoadingComplete()
		else
			print("getPropsInGame failed.")
			context:onLoadingError()
		end
		return
	end

	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("GetPropsInGameHttp fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("GetPropsInGameHttp success")
	    	context:onLoadingComplete()
	    end
	end
	
	self.transponder:call(kHttpEndPoints.getPropsInGame, body, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- IngameHttp ---------------------------------------------------------
--
IngameHttp = class(HttpBase)
-- <request>
-- 	<property code="id" type="int" desc="当type=1时代表goodsId，type=2时代表充值id" />	
-- 	<property code="orderId" type="String" desc="订单id" />
-- 	<property code="channel" type="String" desc="短代渠道" />
-- 	<property code="ingameType" type="int" desc="短代支付类型，1：商品购买，2：充值" />
-- </request>
function IngameHttp:load(id, orderId, channel, ingameType, detail, tradeId)
	assert(id ~= nil, "id must not a nil")
	assert(orderId ~= nil, "orderId must not a nil")
	assert(channel ~= nil, "channel must not a nil")
	assert(ingameType ~= nil, "ingameType must not a nil")

	local context = self
	local body = {id = id, orderId = orderId, channel = channel, ingameType = ingameType, detail = detail, tradeId=tradeId, requestTime=Localhost:time(),
		imsi = MetaInfo:getInstance():getImsi(),
		udid = MetaInfo:getInstance():getUdid(),
	}

	if NetworkConfig.useLocalServer then
		print(" [ useLocalServer for IngameHttp ]", id, orderId, channel, ingameType, detail)
		local success, err = Localhost.getInstance():ingame( id, orderId, channel, ingameType, detail)
		if err ~= nil then context:onLoadingError(err)
			print("IngameHttp fail", tostring(err))
		else
			UserService.getInstance():cacheHttp(kHttpEndPoints.ingame, body)
				
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end

			context:onLoadingComplete() 
		end
		return
	end

	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("ingame payment confirm fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("confirm ingame payment success")
	    	Localhost:ingame( id, orderId, channel, ingameType )
	    	
	    	if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end

	    	context:onLoadingComplete()
	    end
	end
	self.transponder:call(kHttpEndPoints.ingame, body, loadCallback, rpc.SendingPriority.kHigh, false)
end

GetNewUserRewardsHttp = class(HttpBase)
-- <request>
-- 	<property code="type" type="int" desc="0:normal_new_user_reward, 1:baidu or 91iOS" />
-- </request>
-- <response>
-- 	<list code="rewardItems" ref="Reward" desc="rewards"/>
-- </response>

function GetNewUserRewardsHttp:load(rewardType)
	local context = self

	if NetworkConfig.useLocalServer then
		local cacheHttp = { requestTime = Localhost:time()}
		
		local result, success, err = Localhost.getInstance():getNewUserRewards()
		if err ~= nil then context:onLoadingError(err)
			print("GetNewUserRewardsHttp fail", tostring(err))
		else 
			UserService.getInstance():cacheHttp(kHttpEndPoints.getNewUserRewards, cacheHttp)
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end

			print("getNewUserRewards success !")
			print("use local server !!")

			for k, v in pairs(result) do
				if v.itemId == ItemType.COIN then		-- Coin
					local curCoin	= UserManager:getInstance().user:getCoin()
					local newCoin	= curCoin + v.num
					UserManager:getInstance().user:setCoin(newCoin)
				else
					UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
				end
			end

			context:onLoadingComplete(result) 
		end
		return
	end

	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("getNewUserRewards, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("getNewUserRewards success")
			for k, v in pairs(data.rewardItems) do
				if v.itemId == ItemType.COIN then		-- Coin
					local curCoin	= UserManager:getInstance().user:getCoin()
					local newCoin	= curCoin + v.num
					UserManager:getInstance().user:setCoin(newCoin)
				else
					UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
				end
			end
	    	context:onLoadingComplete(data.rewardItems)
	    end
	end
	
	self.transponder:call(kHttpEndPoints.getNewUserRewards, 
		{ requestTime = Localhost:time() },
		loadCallback, rpc.SendingPriority.kHigh, false)
end

SettingHttp = class(HttpBase)
function SettingHttp:load(settingFlag)
	actId = actId or 0
	local context = self
	local body = {setting=settingFlag}

	if NetworkConfig.useLocalServer then
		UserService.getInstance():cacheHttp(kHttpEndPoints.setting, body)
		if NetworkConfig.writeLocalDataStorage then 
			Localhost:getInstance():flushCurrentUserData()
		else 
			print("Did not write user data to the device.") 
		end
		context:onLoadingComplete()
		return
	end

	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("SettingHttp fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("SettingHttp success")
	    	context:onLoadingComplete()
	    end
	end
	
	self.transponder:call(kHttpEndPoints.setting, body, loadCallback, rpc.SendingPriority.kHigh, false)
end