require "zoo.data.UserManager"

RequestType = {
	kNeedUpdate = 0,
	kReceiveFreeGift = 1,
	kSendFreeGift = 2,
    kUnlockLevelArea = 3,
    kAddFriend = 5,
}

local getMessageLimit = {
	kAll = 100,
	kNeedUpdate = 10,
	kReceiveFreeGift = 20,
	kSendFreeGift = 30,
    kUnlockLevelArea = 20,
    kAddFriend = 30,
}

FreegiftManager = class()

local freegiftManager = nil
function FreegiftManager:sharedInstance()
	if not freegiftManager then
		freegiftManager = FreegiftManager.new()
		freegiftManager:init()
	end
	return freegiftManager;
end

function FreegiftManager:init()
	self.requestInfos = {}
	self.leftFreegiftInfos = {}
	self.lockedSendIds = {}
	self.lockedReceiveCount = 0
end

function FreegiftManager:update(load, callback)

	local function onSuccess(evt)
		if evt.data.requestInfos then
			self.requestInfos = evt.data.requestInfos
			UserManager:getInstance().requestNum = #self.requestInfos
		end
		for k, v in ipairs(self.requestInfos) do
			if (v.type == RequestType.kSendFreeGift or v.type == RequestType.kReceiveFreeGift) and
				not BagManager:getInstance():isValideItemId(v.itemId) then
					v.originType = v.type
					v.type = 0
			else
				local found = false
				for i, j in pairs(RequestType) do
					if v.type == j then
						found = true
						break
					end
				end
				if not found then
					v.originType = 0
					v.type = 0
				else
					v.originType = v.type
				end
			end
			if evt.data.inviteProfiles then
				for i, j in ipairs(evt.data.inviteProfiles) do
					if j.uid == v.senderUid then
						if j.name then v.name = HeDisplayUtil:urlDecode(j.name) end
						if j.headUrl then v.headUrl = j.headUrl end
					end
				end
			end
		end
		local limit = {}
		for k, v in pairs(getMessageLimit) do limit[k] = v end
		local tmpList = {}
		for k, v in ipairs(self.requestInfos) do
			if v.type == RequestType.kSendFreeGift and limit.kSendFreeGift > 0 then
				table.insert(tmpList, v)
				limit.kSendFreeGift = limit.kSendFreeGift - 1
				limit.kAll = limit.kAll - 1
			elseif v.type == RequestType.kReceiveFreeGift and limit.kReceiveFreeGift > 0 then
				table.insert(tmpList, v)
				limit.kReceiveFreeGift = limit.kReceiveFreeGift - 1
				limit.kAll = limit.kAll - 1
			elseif v.type == RequestType.kUnlockLevelArea and limit.kUnlockLevelArea > 0 then
				table.insert(tmpList, v)
				limit.kUnlockLevelArea = limit.kUnlockLevelArea - 1
				limit.kAll = limit.kAll - 1
			elseif v.type == RequestType.kAddFriend and limit.kAddFriend > 0 then
				table.insert(tmpList, v)
				limit.kAddFriend = limit.kAddFriend - 1
				limit.kAll = limit.kAll - 1
			elseif v.type == RequestType.kNeedUpdate and limit.kNeedUpdate > 0 then
				table.insert(tmpList, v)
				limit.kNeedUpdate = limit.kNeedUpdate - 1
				limit.kAll = limit.kAll - 1
			end
			if limit.kAll <= 0 then break end
		end
		self.requestInfos = tmpList
		if callback then callback("success", evt) end
	end

	local function onFail(evt)
		if callback then callback("fail", evt) end
	end

	if load == nil then load = false end
	local http = GetRequestInfoHttp.new(load)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load()
end

function FreegiftManager:updateFriendInfos(load, callback)
	local function onSuccess(evt)
		if evt.data.leftFreegiftInfos then
			self.leftFreegiftInfos = evt.data.leftFreegiftInfos
		end
		if callback then callback("success", evt) end
	end
	local function onFail(evt)
		if callback then callback("fail", evt) end
	end
	if load == nil then load = true end
	local http = GetLeftAskInfoHttp.new(load)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load()
end

function FreegiftManager:getMessageNumByType(msgType)
	if type(msgType) ~= "table" then return #self.requestInfos end
	local res = 0
	for k, v in ipairs(self.requestInfos) do
		for k2, v2 in ipairs(msgType) do
			if v.type == v2 then
				res = res + 1
				break
			end
		end
	end
	return res
end

function FreegiftManager:getMessages(msgType)
	if type(msgType) ~= "table" then return self.requestInfos end
	local res = {}
	for k, v in ipairs(self.requestInfos) do
		for k2, v2 in ipairs(msgType) do
			if v.type == v2 then
				table.insert(res, v)
				break
			end
		end
	end
	return res
end

function FreegiftManager:getMessageById(id)
	for k, v in pairs(self.requestInfos) do
		if v.id == id then
			return v
		end
	end
	return nil, 0
end

function FreegiftManager:removeMessageById(id)
	for k, v in pairs(self.requestInfos) do
		if v.id == id then
			table.remove(self.requestInfos, k)
			return
		end
	end
end

function FreegiftManager:getFriends()
	return self.leftFreegiftInfos
end

function FreegiftManager:getCanGiveFriends()
	local wantIds = UserManager:getInstance():getWantIds()

	local res = {}
	local function findId(target)
		for k, v in ipairs(wantIds) do
			if tonumber(v) == target then return true end
		end
		return false
	end
	for k, v in ipairs(self.leftFreegiftInfos) do
		if v.dailyLeftFreeGiftCount > 0 and not findId(tonumber(v.friendUid)) then
			table.insert(res, v)
		end
	end
	return res
end

function FreegiftManager:requestGift(uids, itemId, successCallback, failCallback)
	local function onSuccess(data)
		UserManager:getInstance():addWantIds(uids)
		if successCallback then successCallback(data) end
	end

	local function onFail(err)
		if failCallback then failCallback(err) end
	end

	local http = SendFreegiftHttp.new(false)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load(2, uids, itemId)
end

-- local ___i = 1
function FreegiftManager:sendGiftTo(receiverUid, successCallback, failCallback)
	
	local function onFail(err)

		UserManager:getInstance():removeSendId(receiverUid)
		if failCallback then failCallback(err) end
	end

	local function onSuccess(data)
		-- if ___i == 4 or ___i == 5 then 
		-- 	onFail()
		-- end
		-- ___i = ___i+1
		if successCallback then successCallback(data) end
	end
	UserManager:getInstance():addSendId(receiverUid)

	-- HomeScene:sharedInstance():runAction(CCSequence:createWithTwoActions(CCDelayTime:create(4), CCCallFunc:create(onSuccess)))

	local http = SendFreegiftHttp.new(false)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load(1, {receiverUid}, 10012)
end

function FreegiftManager:sendGift(id, successCallback, failCallback)
	local message = self:getMessageById(id)
	if not message then
		if failCallback then failCallback() end
		return
	end

	local function onSuccess(data)
		local function onIgnoreSuccess(data)
			UserManager:getInstance():addSendId(message.senderUid)
			for k, v in ipairs(self.lockedSendIds) do
				if v == message.senderUid then
					table.remove(self.lockedSendIds, k)
					break
				end
			end
			if successCallback then successCallback(data) end
		end
		local function onIgnoreFail(err)
			for k, v in ipairs(self.lockedSendIds) do
				if v == message.senderUid then
					table.remove(self.lockedSendIds, k)
					break
				end
			end
			if failCallback then failCallback(err) end
		end
		self:ignoreFreegift(id, onIgnoreSuccess, onIgnoreFail)
	end

	local function onFail(err)

		-- UserManager:getInstance():removeSendId(message.senderUid)
		for k, v in ipairs(self.lockedSendIds) do
			if v == message.senderUid then
				table.remove(self.lockedSendIds, k)
				break
			end
		end
		if failCallback then failCallback(err) end
	end

	-- UserManager:getInstance():addSendId(message.senderUid)
	table.insert(self.lockedSendIds, message.senderUid)
	local http = SendFreegiftHttp.new(false)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load(1, {message.senderUid}, message.itemId)
end

function FreegiftManager:ignoreFreegift(id, successCallback, failCallback)
	local message = self:getMessageById(id)
	if not message then
		if failCallback then failCallback() end
		return
	end

	local function onSuccess(data)
		self:removeMessageById(id)
		UserManager:getInstance().requestNum = UserManager:getInstance().requestNum - 1
		if successCallback then successCallback(data) end
	end

	local function onFail(err)
		if failCallback then failCallback(err) end
	end

	local http = IgnoreFreegiftHttp.new(false)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load(id)
end

function FreegiftManager:acceptFreegift(id, successCallback, failCallback)
	local message = self:getMessageById(id)
	if not message then
		if failCallback then failCallback() end
		return
	end

	local function onSuccess(data)
		UserManager:getInstance():incReceiveGiftCount()
		self.lockedReceiveCount = self.lockedReceiveCount - 1
		UserManager:getInstance():addUserPropNumber(message.itemId, message.itemNum)
		UserManager:getInstance().requestNum = UserManager:getInstance().requestNum - 1
		if successCallback then successCallback(data) end
	end

	local function onFail(err)
		-- UserManager:getInstance():decReceiveGiftCount()
		self.lockedReceiveCount = self.lockedReceiveCount - 1
		if failCallback then failCallback(err) end
	end

	-- UserManager:getInstance():incReceiveGiftCount()
	self.lockedReceiveCount = self.lockedReceiveCount + 1
	local http = AcceptFreegiftHttp.new(false)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load(id)
	-- onSuccess()
end

function FreegiftManager:getReceivedNum()
	local maxCount = MetaManager:getDailyMaxReceiveGiftCount()
	local receivedCount = UserManager:getInstance():receiveGiftCount()
	return maxCount - receivedCount
end

function FreegiftManager:getSentNum()
	local max = MetaManager:getInstance():getDailyMaxSendGiftCount()
	local sendIds = UserManager:getInstance():getSendIds()
	local sentCount = #sendIds
	return max - sentCount
end

function FreegiftManager:canSendMore()
	local max = MetaManager:getInstance():getDailyMaxSendGiftCount()
	local sendIds = UserManager:getInstance():getSendIds()
	local sentCount = #sendIds
	-- max = 5
	local newestCfg = Localhost.getInstance():getUpdatedGlobalConfig()
	if newestCfg and newestCfg.dailyMaxSendGiftCount then
		max = newestCfg.dailyMaxSendGiftCount
	end

	local remain = max - sentCount - #self.lockedSendIds
	if remain < 0 then remain = 0 end
	return (sentCount + #self.lockedSendIds) < max, remain

end

function FreegiftManager:canSendBackTo(receiverUid)
	local sendIds = UserManager:getInstance():getSendIds()
	local hasSentTo = false
	for k, v in pairs(sendIds) do
		if tonumber(v) == tonumber(receiverUid) then
			hasSentTo = true
			break
		end

	end
	for k, v in ipairs(self.lockedSendIds) do
		if receiverUid == v then
			hasSentTo = true
			break
		end
	end
	local canSendMore = self:canSendMore()
	return canSendMore and not hasSentTo
end

function FreegiftManager:canSendTo(receiverUid)
	return self:canSendBackTo(receiverUid)
end	

function FreegiftManager:canReceiveMore()
	local receivedCount = UserManager:getInstance():receiveGiftCount()
	local maxCount = MetaManager:getDailyMaxReceiveGiftCount()
	
	local newestCfg = Localhost.getInstance():getUpdatedGlobalConfig()
	if newestCfg and newestCfg.dailyMaxReceiveGiftCount then
		maxCount = newestCfg.dailyMaxReceiveGiftCount
	end

	local canReceive = (receivedCount + self.lockedReceiveCount) < maxCount
	local remain = maxCount - receivedCount - self.lockedReceiveCount
	if remain < 0 then remain = 0 end
	return canReceive, remain
end

function FreegiftManager:canReceiveFrom(senderUid)
	self:canReceiveMore()
end

function FreegiftManager:dispose()
	self.requestInfos = nil
	self.leftFreegiftInfos = nil
end