
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013��12��24�� 21:09:23
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- GetStarRewardsLogic
---------------------------------------------------

assert(not GetStarRewardsLogic)
GetStarRewardsLogic = class()

function GetStarRewardsLogic:init(rewardId, ...)
	assert(type(rewardId) == "number")
	assert(#{...} == 0)

	self.rewardId	= rewardId

	self.successCallback = false
	self.failCallback = false
end

function GetStarRewardsLogic:setSuccessCallback(callback, ...)
	assert(type(callback) == "function")
	assert(#{...} == 0)

	self.successCallback = callback
end

function GetStarRewardsLogic:setFailCallback(callback, ...)
	assert(type(callback) == "function")
	assert(#{...} == 0)

	self.failCallback = callback
end

function GetStarRewardsLogic:setCancelCallback(callback)
	self.cancelCallback = callback
end

function GetStarRewardsLogic:start(load, ...)
	assert(#{...} == 0)

	local function onSendSuccessCallback(event)

		-- Set Received Flag 
		local userExtend = UserManager:getInstance().userExtend
		assert(userExtend)

		userExtend:setRewardLevelReceived(self.rewardId)

		if self.successCallback then
			self.successCallback(event)
		end
	end
	local function onSendFailCallback(event)
		if self.failCallback then
			self.failCallback(event)
		end
	end
	local function onSendCancel(event)
		if self.cancelCallback then
			self.cancelCallback(event)
		end
	end

	self:sendGetRewardMsg(onSendSuccessCallback, onSendFailCallback, onSendCancel, load)
end

function GetStarRewardsLogic:sendGetRewardMsg(onSuccessCallback, onFailCallback, onCancelCallback, load, ...)
	assert(false == onSuccessCallback or type(onSuccessCallback) == "function")
	assert(false == onFailCallback or type(onFailCallback) == "function")
	assert(#{...} == 0)

	local function onSuccess(event)

		print("onGetRewardLabelTapped, onSuccess Called !")

		if onSuccessCallback then
			onSuccessCallback(event)
		end
	end

	local function onFailed(evt)
		assert(evt)
		assert(evt.data)

		print("onGetRewardLabelTapped, onFailed Called !")

		local assertFalseMsg = "GetStarRewardsHttp Failed ! \n"
		assertFalseMsg = assertFalseMsg .. "error code: " .. evt.data
		if onFailCallback then
			onFailCallback(evt)
		end
	end

	local function onCancel(evt)
		if onCancelCallback then
			onCancelCallback(evt)
		end
	end

	--local rewardLevel = self.rewardLevelToPushMeta.id
	local rewardLevel	= self.rewardId

	print(type(rewardLevel))
	print("rewardLevel : " .. rewardLevel)
	--debug.debug()

	if load == nil then load = true end
	local http = GetStarRewardsHttp.new(load)
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFailed)
	http:addEventListener(Events.kCancel, onCancel)
	http:syncLoad(rewardLevel)
end

function GetStarRewardsLogic:create(rewardId, ...)
	assert(type(rewardId) == "number")
	assert(#{...} == 0)

	local newGetStarRewardsLogic = GetStarRewardsLogic.new()
	newGetStarRewardsLogic:init(rewardId)
	return newGetStarRewardsLogic
end

