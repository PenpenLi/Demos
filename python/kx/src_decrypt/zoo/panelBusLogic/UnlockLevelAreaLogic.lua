
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年11月13日 15:08:41
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.model.MetaModel"

---------------------------------------------------
-------------- UnlockLevelAreaLogic
---------------------------------------------------

assert(not UnlockLevelAreaLogic)
UnlockLevelAreaLogic = class()


UnlockLevelAreaLogicUnlockType = {

	USE_STAR		= 1,
	USE_WINDMILL_COIN	= 2,
	REQUEST_FRIEND_TO_HELP	= 3,
	USE_FRIEND		= 4,
	USE_DOWN_NEW_APK = 5,
	USE_TASK_LEVEL = 6,
	USE_ANIMAL_FRIEND = 7,
	USE_UNLOCK_AREA_LEVEL = 8,
}

local function checkUnlockType(unlockType)

	assert(unlockType == UnlockLevelAreaLogicUnlockType.USE_STAR or
		unlockType == UnlockLevelAreaLogicUnlockType.USE_WINDMILL_COIN or
		unlockType == UnlockLevelAreaLogicUnlockType.REQUEST_FRIEND_TO_HELP or
		unlockType == UnlockLevelAreaLogicUnlockType.USE_FRIEND or 
		unlockType == UnlockLevelAreaLogicUnlockType.USE_DOWN_NEW_APK or 
		unlockType == UnlockLevelAreaLogicUnlockType.USE_ANIMAL_FRIEND or 
		unlockType == UnlockLevelAreaLogicUnlockType.USE_TASK_LEVEL or 
		unlockType == UnlockLevelAreaLogicUnlockType.USE_UNLOCK_AREA_LEVEL)
end

function UnlockLevelAreaLogic:init(lockedCloudId, ...)
	assert(type(lockedCloudId) == "number")
	assert(#{...} == 0)

	self.lockedCloudId = lockedCloudId

	--print("UnlockLevelAreaLogic:init Called !")
	--print("self.lockedCloudId: " .. self.lockedCloudId)
	--debug.debug()
	self.itemIdToGoodsIdMap	= {}
	self.itemIdToGoodsIdMap[40001] = 19
	self.itemIdToGoodsIdMap[40002] = 20
	self.itemIdToGoodsIdMap[40003] = 21
	self.itemIdToGoodsIdMap[40004] = 22
	self.itemIdToGoodsIdMap[40005] = 26
	self.itemIdToGoodsIdMap[40006] = 27
	self.itemIdToGoodsIdMap[40007] = 32
	self.itemIdToGoodsIdMap[40008] = 41
	self.itemIdToGoodsIdMap[40009] = 42
	self.itemIdToGoodsIdMap[40010] = 44
	self.itemIdToGoodsIdMap[40011] = 54
	self.itemIdToGoodsIdMap[40012] = 56
	self.itemIdToGoodsIdMap[40013] = 64
	self.itemIdToGoodsIdMap[40014] = 69
	self.itemIdToGoodsIdMap[40015] = 73
	self.itemIdToGoodsIdMap[40016] = 74
	self.itemIdToGoodsIdMap[40017] = 82
	self.itemIdToGoodsIdMap[40018] = 89
	self.itemIdToGoodsIdMap[40019] = 90
	self.itemIdToGoodsIdMap[40020] = 97
	self.itemIdToGoodsIdMap[40021] = 107
	self.itemIdToGoodsIdMap[40022] = 108
	self.itemIdToGoodsIdMap[40023] = 109
	self.itemIdToGoodsIdMap[40024] = 110
	self.itemIdToGoodsIdMap[40025] = 111
	self.itemIdToGoodsIdMap[40026] = 112
	self.itemIdToGoodsIdMap[40027] = 113
	self.itemIdToGoodsIdMap[40028] = 114
	self.itemIdToGoodsIdMap[40029] = 115
	self.itemIdToGoodsIdMap[40030] = 116
	self.itemIdToGoodsIdMap[40031] = 117
	self.itemIdToGoodsIdMap[40032] = 118
	self.itemIdToGoodsIdMap[40033] = 119
	self.itemIdToGoodsIdMap[40034] = 120
	self.itemIdToGoodsIdMap[40035] = 121
	self.itemIdToGoodsIdMap[40036] = 122
	self.itemIdToGoodsIdMap[40037] = 123
	self.itemIdToGoodsIdMap[40038] = 124
	self.itemIdToGoodsIdMap[40039] = 125
	self.itemIdToGoodsIdMap[40040] = 126
	self.itemIdToGoodsIdMap[40041] = 193
	self.itemIdToGoodsIdMap[40042] = 194
	self.itemIdToGoodsIdMap[40043] = 195
	self.itemIdToGoodsIdMap[40044] = 196
	self.itemIdToGoodsIdMap[40045] = 197
	self.itemIdToGoodsIdMap[40046] = 198
	self.itemIdToGoodsIdMap[40047] = 199
	self.itemIdToGoodsIdMap[40048] = 200
	self.itemIdToGoodsIdMap[40049] = 201
	self.itemIdToGoodsIdMap[40050] = 202
	self.itemIdToGoodsIdMap[40051] = 203
	self.itemIdToGoodsIdMap[40052] = 204
	self.itemIdToGoodsIdMap[40053] = 205
	self.itemIdToGoodsIdMap[40054] = 206
	self.itemIdToGoodsIdMap[40055] = 207
	self.itemIdToGoodsIdMap[40056] = 208
	self.itemIdToGoodsIdMap[40057] = 209
	self.itemIdToGoodsIdMap[40058] = 210
	self.itemIdToGoodsIdMap[40059] = 211
	self.itemIdToGoodsIdMap[40060] = 212


	self.onSuccessCallback		= false
	self.onFailCallback		= false
	self.onHasNotEnoughStarCallback	= false

	self.minLevel = MetaManager.getInstance():getLevelAreaById(self.lockedCloudId).minLevel
end

--------------------------------
---- Set Event Callback
-------------------------------

function UnlockLevelAreaLogic:setOnSuccessCallback(onSuccessCallback, ...)
	assert(type(onSuccessCallback) == "function")
	assert(#{...} == 0)

	self.onSuccessCallback = onSuccessCallback
end

function UnlockLevelAreaLogic:setOnFailCallback(onFailCallback, ...)
	assert(type(onFailCallback) == "function")
	assert(#{...} == 0)

	self.onFailCallback	= onFailCallback
end

function UnlockLevelAreaLogic:setOnCancelCallback(onCancelCallback, ...)
	assert(type(onCancelCallback) == "function")
	assert(#{...} == 0)

	self.onCancelCallback = onCancelCallback
end

function UnlockLevelAreaLogic:setOnHasNotEnoughStarCallback(onHasNotEnoughStarCallback, ...)
	assert(type(onHasNotEnoughStarCallback) == "function")
	assert(#{...} == 0)

	self.onHasNotEnoughStarCallback = onHasNotEnoughStarCallback
end

function UnlockLevelAreaLogic:start(unlockType, friendIds, ...)
	checkUnlockType(unlockType)
	assert(type(friendIds) == "table")
	assert(#{...} == 0)

	-- ----------------
	-- Success Callback
	-- ------------------
	local function onSendUnlockLevelAreaSuccess()

		print("send unlock area success !")
		-----------------------------------------------
		-- Advance Top Level
		-- Need Manually Advance THe Top Level Id
		-- Because: in Use Qcash TO Unlock The CLoud, New Top Leve Id Is Not Returned From Server
		-- -------------------------------------------------------
		if unlockType ~= UnlockLevelAreaLogicUnlockType.REQUEST_FRIEND_TO_HELP then
			local logic = AdvanceTopLevelLogic:create(self.minLevel - 1)
			logic:startWithoutCheckLockedCloud()
		end

		if self.onSuccessCallback then
			self.onSuccessCallback()
		end

		if MissionManager then
			local triggerContext = TriggerContext:create(TriggerContextPlace.UNLOACK_AREA)
			triggerContext:addValue( "unLockLevelAreaData" , {unlockType=unlockType,friendIds=friendIds} )
			MissionManager:getInstance():checkAll(triggerContext)
		end
	end

	-- ------------------
	-- Failed Callback
	-- ----------------
	local function onSendUnlockLevelAreaFailed(errorCode)
		if self.onFailCallback then
			self.onFailCallback(errorCode)
		end
	end

	local function onSendUnlockLevelAreaCanceled()
		if self.onCancelCallback then
			self.onCancelCallback()
		end
	end
	---------------
	-- Use Star
	-- -----------
	if unlockType == UnlockLevelAreaLogicUnlockType.USE_STAR then
		local function onHasNotEnoughStarCallback(userTotalStar, neededStar)
			if self.onHasNotEnoughStarCallback then
				self.onHasNotEnoughStarCallback(userTotalStar, neededStar)
			end
		end

		-- Check If Has Enough Start
		if self:ifHasEnoughStar() then
			self:sendUnlockLevelAreaMessage(unlockType, {}, onSendUnlockLevelAreaSuccess, onSendUnlockLevelAreaFailed)
		else
			-- Not Has Enough Star
			local userTotalStar 	= UserManager:getInstance().user:getTotalStar()
			local neededStar	= self:getNeededStar()
			onHasNotEnoughStarCallback(userTotalStar, neededStar)
		end
	---------------------
	-- Use Windmill Coin
	-- -------------------
	elseif unlockType == UnlockLevelAreaLogicUnlockType.USE_WINDMILL_COIN then

		-- CHeck If Has Enough Qcash
		-- Buy THe rop
		-- Send The Buy The Prop
		local itemId	= self.lockedCloudId
		local num	= 1
		local moneyType	= 2 -- Cash

		print("UnlockLevelAreaLogicUnlockType.USE_WINDMILL_COIN")
		print(itemId, self.itemIdToGoodsIdMap[itemId])
		if __ANDROID then -- ANDROID
			if PaymentManager.getInstance():checkCanWindMillPay(self.itemIdToGoodsIdMap[itemId]) then
				self.dcAndroidInfo = DCWindmillObject:create()
	            self.dcAndroidInfo:setGoodsId(self.itemIdToGoodsIdMap[itemId])
	            PaymentDCUtil.getInstance():sendAndroidWindMillPayStart(self.dcAndroidInfo)

	   			local logic = WMBBuyItemLogic:create()
	            local buyLogic = BuyLogic:create(self.itemIdToGoodsIdMap[itemId], 2)
	            buyLogic:getPrice()
	            logic:buy(self.itemIdToGoodsIdMap[itemId], 1, self.dcAndroidInfo, buyLogic, onSendUnlockLevelAreaSuccess, onSendUnlockLevelAreaFailed, onSendUnlockLevelAreaCanceled, onSendUnlockLevelAreaCanceled)
			else
				local logic = IngamePaymentLogic:create(self.itemIdToGoodsIdMap[itemId])
				logic:ignoreSecondConfirm(true)
				logic:buy(onSendUnlockLevelAreaSuccess, onSendUnlockLevelAreaFailed, onSendUnlockLevelAreaCanceled)
			end
		else -- else, on IOS and PC we use gold!
			local logic = BuyLogic:create(self.itemIdToGoodsIdMap[itemId], moneyType)
			logic:getPrice()
			logic:start(num, onSendUnlockLevelAreaSuccess, onSendUnlockLevelAreaFailed, true)
		end

	-- Request Friend To Help
	elseif unlockType == UnlockLevelAreaLogicUnlockType.REQUEST_FRIEND_TO_HELP or
		   unlockType == UnlockLevelAreaLogicUnlockType.USE_FRIEND or
		   unlockType == UnlockLevelAreaLogicUnlockType.USE_ANIMAL_FRIEND or
		   unlockType == UnlockLevelAreaLogicUnlockType.USE_TASK_LEVEL then
		self:sendUnlockLevelAreaMessage(unlockType, friendIds, onSendUnlockLevelAreaSuccess, onSendUnlockLevelAreaFailed, onSendUnlockLevelAreaCanceled)
	elseif unlockType == UnlockLevelAreaLogicUnlockType.USE_DOWN_NEW_APK or 
		   unlockType == UnlockLevelAreaLogicUnlockType.USE_UNLOCK_AREA_LEVEL then
		onSendUnlockLevelAreaSuccess()
	else
		assert(false)
	end
end

function UnlockLevelAreaLogic:sendUnlockLevelAreaMessage(unlockType, friendIds, onSuccessCallback, onFailCallback, onCancelCallback, ...)
	checkUnlockType(unlockType)
	assert(type(friendIds) == "table")
	assert(type(onSuccessCallback) == "function")
	assert(type(onFailCallback) == "function")
	assert(#{...} == 0)

	assert(unlockType ~= UnlockLevelAreaLogicUnlockType.USE_WINDMILL_COIN)

	-- 1	: use star to unlock
	-- 3	: ask friend to help
	-- 4	: use friend to unlock

	local function onSuccess(event)
		onSuccessCallback(event.data)
	end

	local function onFailed(event)
		onFailCallback(event.data)
	end

	local function onCancel()
		if onCancelCallback then onCancelCallback() end
	end

	local http = UnLockLevelAreaHttp.new(true)
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFailed)
	http:setCancelCallback(onCancel)
	if unlockType == UnlockLevelAreaLogicUnlockType.USE_STAR or unlockType == UnlockLevelAreaLogicUnlockType.USE_TASK_LEVEL then 
		http:load(unlockType, friendIds)
	else 
		http:syncLoad(unlockType, friendIds) 
	end
end

function UnlockLevelAreaLogic:getNeededStar(...)
	assert(#{...} == 0)

	-- Get Needed Star
	local metaModel		= MetaModel:sharedInstance()
	local curLevelAreaData	= metaModel:getLevelAreaDataById(self.lockedCloudId)
	local neededStar	= tonumber(curLevelAreaData.star)
	assert(neededStar)

	return neededStar
end

function UnlockLevelAreaLogic:ifHasEnoughStar(...)
	assert(#{...} == 0)

	-- Get Needed Star
	local neededStar = self:getNeededStar()

	-- Get User Cur Total Star
	local userTotalStar 	= UserManager:getInstance().user:getTotalStar()

	if userTotalStar >= neededStar then
		return true
	end

	return false
end

function UnlockLevelAreaLogic:create(lockedCloudId, ...)
	assert(type(lockedCloudId) == "number")
	assert(#{...} == 0)

	local newUnlockLevelAreaLogic = UnlockLevelAreaLogic.new()
	newUnlockLevelAreaLogic:init(lockedCloudId)
	return newUnlockLevelAreaLogic
end
