require "zoo.net.Http" 
-------------------------------------------------------------------------
--  Class include: GetStarRewardsHttp, UnLockLevelAreaHttp, MarkHttp, SellPropsHttp, BuyHttp, 
--		GetLadyBugRewards, GetInviteFriendsReward, UpdateUserGuideStep, ConfirmInvite
-------------------------------------------------------------------------

--
-- GetStarRewardsHttp ---------------------------------------------------------
--
GetStarRewardsHttp = class(HttpBase)
function GetStarRewardsHttp:load(rewardId, ...)
	assert(type(rewardId) == "number")
	assert(#{...} == 0)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endPoint, data, err)
		if err then
			he_log_info("get reward fail, err: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("get reward success")
			if type(data) == "table" and type(data.rewardItems) == "table" then
				for k1,v1 in pairs(data.rewardItems) do
					local itemId 		= v1.itemId
					local itemNumber	= v1.num
					UserManager:getInstance():addUserPropNumber(itemId, itemNumber)
					DcUtil:logRewardItem("star", itemId, itemNumber, -1)
					UserService:getInstance():addUserPropNumber(itemId, itemNumber) -- sync data to local server
					if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
					else print("Did not write user data to the device.") end
				end
			end
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getStarRewards, {starRewardId = rewardId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- StartLadyBugTask ---------------------------------------------------------
--
StartLadyBugTask = class(HttpBase)
function StartLadyBugTask:load(...)
	assert(#{...} == 0)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("start lady bug task error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("start lady bug task success !")
			UserService:getInstance().ladyBugInfos = {}
			for k,v in ipairs(data.ladyBugInfos) do
				local info = LadyBugInfoRef.new()
				info:fromLua(v)
				UserService:getInstance().ladyBugInfos[k] = info
			end
			UserManager:getInstance().ladyBugInfos = {}
			for k,v in ipairs(data.ladyBugInfos) do
				local info = LadyBugInfoRef.new()
				info:fromLua(v)
				UserManager:getInstance().ladyBugInfos[k] = info
			end
			-- context:onLoadingComplete(data.metaClient)
			-- fix
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.startLadyBugTask, nil, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- UnLockLevelAreaHttp ---------------------------------------------------------
--
UnLockLevelAreaHttp = class(HttpBase) 

--  <request>
--	  <property code="type" type="type" desc="è§£é”ç±»åž‹,1: æ˜Ÿæ˜Ÿï¼Œ2ï¼šé‡‘è±†ï¼Œ3: å¥½å‹è¯·æ±‚, 4:å·²æœ‰è¶³å¤Ÿå¥½å‹å¸®åŠ©ï¼ŒçŽ©å®¶è§£é”" />
--	  <list code="friendUids" ref="long" desc="å¥½å‹è¯·æ±‚çš„ å¥½å‹id" />
--  </request>
function UnLockLevelAreaHttp:load(unlockType, friendUids)
	assert(unlockType ~= nil, "unlockType must not a nil")
	assert(type(friendUids) == "table", "friendUids not a table")
	
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("unLockLevelArea fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("unLockLevelArea success")
	    	if data and data.user then
	    		local topLevelID = data.user.topLevelId --only sync top level. we need to sync other data by sync htt[]
	    		UserManager.getInstance().user:setTopLevelId(topLevelID) --local 
	    		UserService.getInstance().user:setTopLevelId(topLevelID) --server
	    		DcUtil:logLevelUp(topLevelID)

	    		--UserManager.getInstance():syncUserFromLua(data.user)
	    		if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
				else print("Did not write user data to the device.") end
	    	end
	    	context:onLoadingComplete()
	    end
	end

	local selfUser = UserService:getInstance():getUserRef()
	local meta = MetaManager:getInstance():getNextLevelAreaRefByLevelId(selfUser:getTopLevelId())
	if--[[ selfUser:getTopLevelId() == 15 and]] unlockType == 1 then
		local star = selfUser:getTotalStar()
		if meta and meta.star and star >= meta.star then
			local level = UserService:getInstance().user:getTopLevelId()
			loadCallback(kHttpEndPoints.unLockLevelArea, {user = {topLevelId = level + 1}})
			UserService.getInstance():cacheHttp(kHttpEndPoints.unLockLevelArea, {type=unlockType, friendUids=friendUids, areaId=meta.id})
			if NetworkConfig.writeLocalDataStorage then 
				Localhost:getInstance():flushCurrentUserData()
			else 
				print("Did not write user data to the device.") 
			end
		else
			loadCallback(kHttpEndPoints.unLockLevelArea, {}, 0)
		end
	elseif unlockType == 6 then     --推送召回活动 任务关卡解锁
		local level = UserService:getInstance().user:getTopLevelId()
		loadCallback(kHttpEndPoints.unLockLevelArea, {user = {topLevelId = level + 1}})
		UserService.getInstance():cacheHttp(kHttpEndPoints.unLockLevelArea, {type=unlockType, friendUids=friendUids, areaId=meta.id})
		if NetworkConfig.writeLocalDataStorage then 
			Localhost:getInstance():flushCurrentUserData()
		else 
			print("Did not write user data to the device.") 
		end
	else
		if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
		local areaId = 0
		if meta then areaId = meta.id end
		self.transponder:call(kHttpEndPoints.unLockLevelArea, {type=unlockType, friendUids=friendUids, areaId=areaId}, loadCallback, rpc.SendingPriority.kHigh, false)
	end
end

--
-- MarkHttp ---------------------------------------------------------
--
MarkHttp = class(HttpBase)
function MarkHttp:load()
	local context = self
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local function updateUserMark()
		local markNum = UserManager.getInstance().mark.markNum or 0
		UserManager.getInstance().mark.markNum = markNum + 1
		UserManager.getInstance().mark.markTime = Localhost:time()

		Localhost:mark() --sync online data
	end 	
	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("mark fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("mark success")
	    	updateUserMark()
	    	context:onLoadingComplete()
	    end
	end
	self.transponder:call(kHttpEndPoints.mark, nil, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- SellPropsHttp ---------------------------------------------------------
--
SellPropsHttp = class(HttpBase) --å–å‡ºé“å…·

--  <request>
--	  <property code="itemID" type="int" desc="é“å…·id" />
--	  <property code="num" type="int" desc="é“å…·æ•°é‡" />
--  </request>
function SellPropsHttp:load(itemID, num)
	assert(itemID ~= nil, "itemID must not a nil")
	assert(num ~= nil, "num must not a nil")
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("sellProps fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("sellProps success")
	    	context:onLoadingComplete()
	    	Localhost:sellProps(itemID, num) --used only for sync data
	    	if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
	    end
	end

	self.transponder:call(kHttpEndPoints.sellProps, {itemID=itemID, num=num}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- BuyHttp ---------------------------------------------------------
--
BuyHttp = class(HttpBase)
function BuyHttp:load(goodsId , num , moneyType, targetId)
	assert(goodsId ~= nil, "goodsId type is int")
	assert(num ~= nil, "num type is int")
    assert(moneyType ~= nil, "moneyType type is int")
    assert(targetId ~= nil, "targetId type is int")
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("buy goods fail, err: " .. err)
	    	context:onLoadingError(err)
	    	return true
	    else
	    	he_log_info("buy goods success")
	    	Localhost.getInstance():buy(goodsId , num , moneyType , targetId) --sync local server
	    	local meta = MetaManager:getInstance():getGoodMeta(goodsId)
	    	if meta and meta.limit > 0 then
	    		UserService.getInstance():addBuyedGoods(goodsId, num)
	    	end
	    	context:onLoadingComplete()
	    	
	    	if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
	    end
	end

	if moneyType == 1 then -- silver
		local user = UserService:getInstance().user
		local meta = MetaManager:getInstance():getGoodMeta(goodsId)
		if user and meta then
			if user:getCoin() > meta.coin then
				UserService.getInstance():cacheHttp(kHttpEndPoints.buy, {goodsId=goodsId , num=num , moneyType=moneyType , targetId=targetId})
				if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
				else print("Did not write user data to the device.") end
				loadCallback(kHttpEndPoints.buy, {})
			else
				loadCallback(kHttpEndPoints.buy, {}, 730321)
			end
		else
			loadCallback(kHttpEndPoints.buy, {}, 211)
		end
	else
		if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
		self.transponder:call(kHttpEndPoints.buy, {goodsId=goodsId , num=num , moneyType=moneyType , targetId=targetId}, loadCallback, rpc.SendingPriority.kHigh, false)
	end
end
--
-- GetLadyBugRewards ---------------------------------------------------------
--
GetLadyBugRewards = class(HttpBase)
function GetLadyBugRewards:load(taskId, ...)
	assert(type(taskId) == "number")
	assert(#{...} == 0)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)

		if err then
			he_log_info("get lady bug reward taskId:" .. taskId .. " error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("getlady bug reward taskId:" .. taskId .. " success !")
			print(table.tostring(data))
			
			for k,v in pairs(data.rewardItems) do
				local itemId	= v.itemId
				local num	= v.num

				-- Add Coin
				if itemId == ItemType.COIN then
					print("add Coin : " .. num)
					local curCoin = UserManager.getInstance().user:getCoin()
					local newCoin = curCoin + num
					UserManager.getInstance().user:setCoin(newCoin)

					DcUtil:logCreateCoin("bug", num, curCoin, -1)

					curCoin = UserService.getInstance().user:getCoin()
					newCoin = curCoin + num
					UserService.getInstance().user:setCoin(newCoin)
				else
					-- Other Reawrd
					UserManager:getInstance():addUserPropNumber(itemId, num)
					DcUtil:logRewardItem("bug", itemId, num, -1)
					UserService:getInstance():addUserPropNumber(itemId, num)
					if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
					else print("Did not write user data to the device.") end
				end


			end
			context:onLoadingComplete(data.metaClient)
		end
	end

	self.transponder:call(kHttpEndPoints.getLadyBugRewards, {id = taskId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- GetInviteFriendsReward ---------------------------------------------------------
--
GetInviteFriendsReward = class(HttpBase)
function GetInviteFriendsReward:load(friendId, rewardId, ...)
	assert(type(friendId) == "string")
	assert(type(rewardId) == "number")
	assert(#{...} == 0)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("get invite friends reward error: " .. err)
			context:onLoadingError(err)
		else

			local rewardMeta = MetaManager.getInstance():inviteReward_getInviteRewardMetaById(rewardId)


			print("GetInviteFriendsReward Success Called !")
			print(table.tostring(rewardMeta.rewards))

			for k,v in pairs(rewardMeta.rewards) do

				-- Add Icon
				if v.itemId == ItemType.COIN then

					local curCoin = UserService.getInstance().user:getCoin()
					local newCoin = curCoin + v.num
					UserService.getInstance().user:setCoin(newCoin)

					print("UserService curCoin: " .. curCoin)
					print("newCoin: " .. newCoin)

					local curCoin = UserManager.getInstance().user:getCoin()
					local newCoin = curCoin + v.num
					UserManager.getInstance().user:setCoin(newCoin)
					DcUtil:logCreateCoin("invte", v.num, curCoin, -1)

					print("UserManager curCoin : " .. curCoin)
					print("newCoin: " .. newCoin)
				else
					-- Other Reward
					UserService:getInstance():addUserPropNumber(v.itemId, v.num)
					UserManager:getInstance():addUserPropNumber(v.itemId, v.num)

					DcUtil:logRewardItem("invte", v.itemId, v.num, -1)
				end
			end
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end

			he_log_info("get invite friends reward success !")
			context:onLoadingComplete()
		end
	end

	self.transponder:call(kHttpEndPoints.getInviteFriendsReward, {friendUid = friendId, rewardId = rewardId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- GetUserGuideStep		这个暂时不再使用了
-- 
UpdateUserGuideStep = class(HttpBase)
function UpdateUserGuideStep:load(guideType, guideStep, ...)
	assert(type(guideType) == "number")
	assert(type(guideStep) == "number")
	assert(#{...} == 0)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("" .. err)
			context:onLoadingError(err)
		else
			he_log_info("")
			if guideType == 0 then
				UserManager:getInstance().userExtend.tutorialStep = guideStep
				UserService:getInstance().userExtend.tutorialStep = guideStep

				print("HTTP", UserManager:getInstance().userExtend.tutorialStep)
				print("HTTP", UserService:getInstance().userExtend.tutorialStep)
				context:onLoadingComplete()
			elseif guideType == 1 then
				UserManager:getInstance().userExtend.playStep = guideStep
				UserService:getInstance().userExtend.playStep = guideStep
				context:onLoadingComplete()
			end
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write userExtend data to the device.") end
			print(UserService:getInstance().userExtend.tutorialStep, UserService:getInstance().userExtend.playStep)
			print("write to file complete")
		end
	end

	self.transponder:call(kHttpEndPoints.updateUserGuideStep, {type = guideType, step = guideStep}, loadCallback, rpc.SendingPriority.kHigh, false)
end


--
-- RewardMetalHttp ---------------------------------------------------------
--
RewardMetalHttp = class(HttpBase)

function RewardMetalHttp:load( shareID )
	local result = false
	local metals = UserService.getInstance().metals
	if metals then
		local shareKey = tostring(shareID)
		if metals[shareKey] == nil then
			metals[shareKey] = 1
			result = true
		end
	end
	
	local gamecenterID = kShareConfig[tostring(shareID)]
	print("gamecenterID:", gamecenterID)
	if gamecenterID then GameCenterSDK:getInstance():submitAchievement(gamecenterID.gamecenter, 100) end
	--todo: add server implements
	if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
	else print("Did not write user data to the device.") end
	return result
end

-- 
-- UpdateProfileHttp
-- 
UpdateProfileHttp = class(HttpBase)
function UpdateProfileHttp:load(name, headUrl)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("UpdateProfileHttp err" .. err)
			context:onLoadingError(err)
		else
			he_log_info("UpdateProfileHttp ok")
		end
	end
	UserService:getInstance().profile.name = UserManager:getInstance().profile.name
	UserService:getInstance().profile.headUrl = UserManager:getInstance().profile.name
	print("profile change", UserService:getInstance().profile.name)

	if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
	else print("Did not write data to the device.") end
	
	GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kProfileUpdate))
	self.transponder:call(kHttpEndPoints.updateProfile, {name = name, headUrl = headUrl}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- ConfirmInvite
-- 
ConfirmInvite = class(HttpBase)
function ConfirmInvite:load(inviteCode, ...)
	assert(type(inviteCode) == "number")
	assert(#{...} == 0)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("confirm invite fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	he_log_info("confirm invite success")
		    local meta = MetaManager:getInstance():getEnterInviteCodeReward()
		    local service = UserService:getInstance()
		    local user = service.user
		    for i = 1, 2 do
		    	if meta[i].itemId == 2 then
		    		local money = user:getCoin()
					money = money + meta[i].num
					user:setCoin(money)
		    	else
		    		service:addUserPropNumber(meta[i].itemId, meta[i].num)
		    	end
		    end
		    if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			
			context:onLoadingComplete()
	    end
	end

	self.transponder:call(kHttpEndPoints.confirmInvite, {inviteCode = inviteCode}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- GetInviteeReward for WanDouJia platform ---------------------------------------------------------
-- 
GetInviteeRewardHttp = class(HttpBase)
function GetInviteeRewardHttp:load(inviters)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	if not inviters or type(inviters) ~= 'table' then 
		return
	end

	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetInviteeReward error: " .. err)
			self:onLoadingError(err)
		else  
			he_log_info("GetInviteeReward success !")
			self:onLoadingComplete(data)
		end
	end
	local params = {inviters = inviters}
	if __ANDROID then
		params.snsPlatform = PlatformConfig:getPlatformAuthName()
	end
	self.transponder:call(kHttpEndPoints.getInviteeReward, params, loadCallback, rpc.SendingPriority.kHigh, false)

end

-- 
-- InviteFriendsHttp ---------------------------------------------------------
-- 
InviteFriendsHttp = class(HttpBase)
function InviteFriendsHttp:load(uids)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	if not uids or type(uids) ~= 'table' then 
		return
	end

	print("InviteFriendsHttp:uids="..table.tostring(uids))

	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("InviteFriends error: " .. err)
			self:onLoadingError(err)
		else  
			he_log_info("InviteFriends success !")
			-- TODO, record sended today, and filter them
			self:onLoadingComplete(data)
		end
	end
	local params = {}
	if __IOS_FB then -- snsIds<string>
		params.snsIds = uids
	else
		params.friendUids = uids
	end
	self.transponder:call(kHttpEndPoints.inviteFriends, params, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- SendFreegift ---------------------------------------------------------
-- 
SendFreegiftHttp = class(HttpBase)
function SendFreegiftHttp:load(sendType, targetUids, itemId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("SendFreegiftHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("SendFreegiftHttp success !")
			if sendType == 2 and not __IOS_FB then -- facebook不送免费礼物
				local tab = UserManager:getInstance():getWantIds()
				if #tab < 1 then
					UserManager:getInstance():addUserPropNumber(10013, 1)
					UserService:getInstance():addUserPropNumber(10013, 1)
				end
			end
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end

			context:onLoadingComplete(data)
		end
	end
	local sendee = {receiverUids = targetUids, itemId = itemId}
	sendee.type = sendType
	self.transponder:call(kHttpEndPoints.sendFreegift, sendee, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- AcceptFreegift
-- 
AcceptFreegiftHttp = class(HttpBase)
function AcceptFreegiftHttp:load(messageId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self

	local loadCallback = function(endpoint, data, err)
		if err then
	    	he_log_info("accept freegift fail, err: " .. err)
	    	context:onLoadingError(err)
	    else
	    	local message = FreegiftManager:sharedInstance():getMessageById(messageId)
	    	UserService:getInstance():addUserPropNumber(message.itemId, message.itemNum)
		    if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			
			context:onLoadingComplete(data)
	    end
	end
	self.transponder:call(kHttpEndPoints.acceptFreegift, {id = messageId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- GetExchangeCodeReward---------------------------------------------------------
-- 
GetExchangeCodeRewardHttp = class(HttpBase)
function GetExchangeCodeRewardHttp:load(code)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("IgnoreFreegiftHttp error: " .. err)
			context:onLoadingError(err)
		else
			local rewardItems = data.rewardItems
			local user = UserManager:getInstance().user
			for i,v in ipairs(rewardItems) do
				if tonumber(v.itemId) ~= 2 then
					UserManager:getInstance():addUserPropNumber(tonumber(v.itemId), tonumber(v.num))
					UserService:getInstance():addUserPropNumber(tonumber(v.itemId), tonumber(v.num))

					DcUtil:logRewardItem("exchange_code", v.itemId, v.num, -1)
				else
					user:setCoin(tonumber(v.num)+user:getCoin())
					UserService:getInstance().user:setCoin(tonumber(v.num)+UserService:getInstance().user:getCoin())
				end
			end
			
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end

			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getExchangeCodeReward, {exchangeCode = code}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- DeleteFriendHttp ---------------------------------------------------------
-- 
DeleteFriendHttp = class(HttpBase)
function DeleteFriendHttp:load(friendUids)
	if not friendUids or type(friendUids) ~= 'table' or #friendUids == 0 then 
		return
	end
 	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end

	local mgr = FriendManager:getInstance()

	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_warning("IgnoreFreegiftHttp error: " .. err)
			self:onLoadingError(err)
		else
			for key, id in pairs(friendUids) do 
				mgr:removeFriend(id)
			end
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end

			self:onLoadingComplete(data)
		end
	end

	-- loadCallback()

	self.transponder:call(kHttpEndPoints.deleteFriend, {friendUids = friendUids}, loadCallback, rpc.SendingPriority.kHigh, false)
end

--
-- PickFruitHttp ---------------------------------------------------------
--
PickFruitHttp = class(HttpBase)
function PickFruitHttp:load(id, mType)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("PickFruitHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("PickFruitHttp success !")
			if type(data.reward) == "table" then
				local userv = UserService:getInstance()
				if data.reward.itemId == 2 then
					userv:getUserRef():setCoin(userv:getUserRef():getCoin() + data.reward.num)
				elseif data.reward.itemId == 4 then
					local _, __, maxEnergy = userv:refreshEnergy()
					local energy = userv:getUserRef():getEnergy()
					energy = energy + data.reward.num
					if energy > maxEnergy then energy = maxEnergy end
					userv:getUserRef():setEnergy(energy)
				else
					userv:addUserPropNumber(data.reward.itemId, data.reward.num)
				end
			end
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.pickFruit, {id = id, type = mType}, loadCallback, rpc.SendingPriority.kHigh, false)
end

-- 
-- GetCompenRewardHttp ----------------------------------------------------
-- 
GetCompenRewardHttp = class(HttpBase)
function GetCompenRewardHttp:load(index)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetCompenRewardHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetCompenRewardHttp success !")
			if UserManager:getInstance().compenList then
				local reward = UserManager:getInstance().compenList[index]
				if type(reward) == "table" and type(reward.rewards) == "table" then
					for k, v in ipairs(reward.rewards) do
						if v.itemId == 2 then
							local user = UserService:getInstance().user
							if user then
								user:setCoin(user:getCoin() + v.num)
							end
						elseif v.itemId == 14 then
							local user = UserService:getInstance().user
							if user then
								user:setCash(user:getCash() + v.num)
							end
						else
							UserService:getInstance():addUserPropNumber(v.itemId, v.num)
						end
					end
				end
			end
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			context:onLoadingComplete(data)
		end
	end
	local device = "unknown"
	if __IOS then
		device = "ios"
	elseif __ANDROID then
		device = "android"
	elseif __WP8 then
		device = "wp"
	end
	self.transponder:call(kHttpEndPoints.getCompenReward, {compenId = index, deviceOS = device}, loadCallback, rpc.SendingPriority.kHigh, false)
	-- loadCallback(kHttpEndPoints.getCompenReward, nil, nil) -- success directly
end

DoOrderHttp = class(HttpBase)
function DoOrderHttp:load(tradeId, goodsId, goodsType, num)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("DoOrderHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("DoOrderHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.doPaymentOrder, {tradeId=tradeId, goodsId=goodsId, goodsType=goodsType, num=num}, loadCallback, rpc.SendingPriority.kHigh, false)
end

DoWXOrderHttp = class(HttpBase)
function DoWXOrderHttp:load(platform, tradeId, goodsId, goodsType, amount, goodsName, totalFee, ip)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("DoWXOrderHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("DoWXOrderHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.doWXPaymentOrder, {platform=platform, tradeId=tradeId, goodsId=goodsId, 
															goodsType=goodsType, num=amount, goodsName=goodsName,
															totalFee=totalFee, ip=ip}, 
															loadCallback, rpc.SendingPriority.kHigh, false)
end

DoAliOrderHttp = class(HttpBase)
function DoAliOrderHttp:load(platform, tradeId, goodsId, goodsType, amount, goodsName, totalFee)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("DoAliOrderHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("DoAliOrderHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.doAliPaymentOrder, {platform=platform, tradeId=tradeId, goodsId=goodsId, 
															goodsType=goodsType, num=amount, goodsName=goodsName,
															totalFee=totalFee}, 
															loadCallback, rpc.SendingPriority.kHigh, false)
end

GetRewardsHttp = class(HttpBase)
function GetRewardsHttp:load(rewardId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("GetRewardsHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("GetRewardsHttp success !")
			print(table.tostring(data))
			local ret = {}
			if type(data.rewardItems) == "table" then
				for k, v in ipairs(data.rewardItems) do
					if type(v.itemId) == "number" and type(v.num) == "number" then
						if v.itemId == 2 then
							local user = UserService:getInstance():getUserRef()
							user:setCoin(user:getCoin() + v.num)
						elseif v.itemId == 14 then
							local user = UserService:getInstance():getUserRef()
							user:setCash(user:getCash() + v.num)
						else
							UserService:getInstance():addUserPropNumber(v.itemId, v.num)
						end
						table.insert(ret, v)
					end
				end
			end
			data.rewardItems = ret
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.getRewards, {rewardId = rewardId}, loadCallback, rpc.SendingPriority.kHigh, false)
end

WXShareHttp = class(HttpBase)
function WXShareHttp:load(uiType, turntableIndex)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("WXShareHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("WXShareHttp success !")
			local ret = {}
			if type(data.reward) == "table" and type(data.reward.itemId) == "number" and
				type(data.reward.num) == "number" then
				if data.reward.itemId == 2 then
					local user = UserService:getInstance():getUserRef()
					user:setCoin(user:getCoin() + data.reward.num)
				elseif data.reward.itemId == 14 then
					local user = UserService:getInstance():getUserRef()
					user:setCash(user:getCash() + data.reward.num)
				else
					UserService:getInstance():addUserPropNumber(data.reward.itemId, data.reward.num)
				end
			end
			if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
			else print("Did not write user data to the device.") end
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.wxShare, {uitype = uiType, turntable = turntableIndex},
		loadCallback, rpc.SendingPriority.kHigh, false)
end

TurnTableHttp = class(HttpBase)
function TurnTableHttp:load(pTableId)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("TurnTableHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("TurnTableHttp success !")
			local ret = {}
			if type(data.reward) == "table" and type(data.reward.itemId) == "number" and
				type(data.reward.num) == "number" then
				if data.reward.itemId == 2 then
					local user = UserService:getInstance():getUserRef()
					user:setCoin(user:getCoin() + data.reward.num)
				elseif data.reward.itemId == 14 then
					local user = UserService:getInstance():getUserRef()
					user:setCash(user:getCash() + data.reward.num)
				else
					UserService:getInstance():addUserPropNumber(data.reward.itemId, data.reward.num)
				end
			end
			if NetworkConfig.writeLocalDataStorage then 
				Localhost:getInstance():flushCurrentUserData()
			else 
				print("Did not write user data to the device.") 
			end
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.turnTable, {tableId = pTableId},
		loadCallback, rpc.SendingPriority.kHigh, false)
end

PushNotifyHttp = class(HttpBase)
function PushNotifyHttp:load(uidList, msg, typeId, targetTime)
	if not kUserLogin then return self:onLoadingError(ZooErrorCode.kNotLoginError) end
	local context = self
	local loadCallback = function(endpoint, data, err)
		if err then
			he_log_info("PushNotifyHttp error: " .. err)
			context:onLoadingError(err)
		else
			he_log_info("PushNotifyHttp success !")
			context:onLoadingComplete(data)
		end
	end
	self.transponder:call(kHttpEndPoints.pushNotify, {uids = uidList, msg = msg, typeId = typeId, targetTime = targetTime},
		loadCallback, rpc.SendingPriority.kHigh, false)
end