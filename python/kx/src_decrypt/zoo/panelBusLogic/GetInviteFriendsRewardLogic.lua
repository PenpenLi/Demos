
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014Äê01ÔÂ 2ÈÕ 22:49:09
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- GetInviteFriendsRewardLogic
---------------------------------------------------

assert(not GetInviteFriendsRewardLogic)
GetInviteFriendsRewardLogic = class()


function GetInviteFriendsRewardLogic:init(friendId, rewardId, ...)
	assert(type(friendId) == "string")
	assert(type(rewardId) == "number")
	assert(#{...} == 0)

	self.friendId 	= friendId
	self.rewardId	= rewardId
end 

function GetInviteFriendsRewardLogic:start(successCallback, ...)
	assert(type(successCallback) == "function" or false == successCallback)
	assert(#{...} == 0)

	local function onSendMsgSuccessCallback()

		print("GetInviteFriendsRewardLogic:start Success Called !")

		-- Add The Reward
		local rewardMeta 	= MetaManager.getInstance():inviteReward_getInviteRewardMetaById(self.rewardId)
		--local reward 		= rewardMeta.rewards

		for k,v in pairs(rewardMeta.rewards) do
			-- 
			--print("k: " .. k ..  "v: " .. tostring(v))
			--for k1, v1 in pairs(v) do
			--	print("\tk1: " .. k1 .. " v1: " .. tostring(v1))
			--end
			--v.itemId
			--v.num
			--UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
		end
	end

	self:sendGetInviteFriendsRewardMsg(onSendMsgSuccessCallback)
end

function GetInviteFriendsRewardLogic:sendGetInviteFriendsRewardMsg(onSuccessCallback, ...)
	assert(type(onSuccessCallback) == "function")
	assert(#{...} == 0)

	local function onSuccess(event)
		assert(event)
		assert(event.name == Events.kComplete)

		onSuccessCallback()
	end

	local function onFail()
		assert(false)
	end

	local http = GetInviteFriendsReward.new()
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFail)
	http:load(self.friendId, self.rewardId)
end

function GetInviteFriendsRewardLogic:create(friendId, rewardId, ...)
	assert(type(friendId) == "string")
	assert(type(rewardId) == "number")
	assert(#{...} == 0)

	local newGetInviteFriendsRewardLogic = GetInviteFriendsRewardLogic.new()
	newGetInviteFriendsRewardLogic:init(friendId, rewardId)
	return newGetInviteFriendsRewardLogic
end

