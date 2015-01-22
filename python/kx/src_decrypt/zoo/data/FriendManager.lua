require "hecore.class"
require "zoo.data.DataRef"

local debugFriendData = false

local instance = nil
FriendManager = {
	friends = {},
	invitedFriends = {},
	appFriends = {}, -- app好友
	noneAppFriends = {}, -- 非app好友
	snsFriendIds = {},
}

function FriendManager.getInstance()
	if not instance then instance = FriendManager end
	return instance
end

local function debugMessage( msg )
	if debugFriendData then print("[FriendManager]", ""..msg) end
end 

function FriendManager:encode()
	local dst = {}
	for uid,v in pairs(self.friends) do
		dst[uid] = v:encode()
	end
	return dst
end
function FriendManager:decode(src)
	self:initFromLua(src)
end

function FriendManager:syncFromLua( src, profiles, snsFriendIds )
	self.snsFriendIds = {}
	self.friends = {}
	
	if snsFriendIds then
		for _,v in pairs(snsFriendIds) do
			self.snsFriendIds[tostring(v)] = true
		end
	end

	local list = {}
	if profiles ~= nil then
		for i, v in ipairs(profiles) do
			if v then list[v.uid] = ProfileRef.new(v) end
		end
	end

	for i,v in ipairs(src) do
		local f = UserRef.new()
		f:fromLua(v)
		local profile = list[f.uid]
		if profile then 
			f.name = HeDisplayUtil:urlDecode(profile.name or "")
			f.headUrl = profile.headUrl
			f.snsId = profile.snsId
			-- print("FriendManager syncFromLua:"..tostring(f.name)..","..tostring(f.headUrl)..","..tostring(f.snsId))
		end
		self.friends[f.uid] = f
	end	
	-- print("user friendIds = "..table.tostring(friendIds))
	if __IOS_FB then -- facebook以平台好友为准
		local friendIds = {}
		for k,_ in pairs(self.friends) do
			table.insert(friendIds, k)
		end
		UserManager:getInstance().friendIds = friendIds
	end
end

function FriendManager:isSnsFriend( friendUid )
	return self.snsFriendIds[tostring(friendUid)] == true
end

function FriendManager:syncFromLuaForInvitedFriends(src, profiles)
	local list = {}
	if not self.invitedFriends then
		self.invitedFriends = {}
	end
	if profiles ~= nil then
		for i, v in ipairs(profiles) do
			if v then list[v.uid] = ProfileRef.new(v) end
		end
	end

	for i,v in ipairs(src) do
		local f = UserRef.new()
		f:fromLua(v)
		local profile = list[f.uid]
		if profile then 
			f.name = HeDisplayUtil:urlDecode(profile.name or "")
			f.headUrl = profile.headUrl
			f.snsId = profile.snsId
			--print("FriendManager syncFromLua", f.name, f.headUrl)
		end
		self.invitedFriends[f.uid] = f

	end	
	-- print('FriendManager:syncFromLuaForInvitedFriends', table.tostring(self.invitedFriends))
end

function FriendManager:getFriendInfo( uid )
	return self.friends[uid]
end

-- uid is a string!
function FriendManager:removeFriend(friendUid)
	friendUid = tostring(friendUid)
	if self.friends[friendUid] ~= nil then
		self.friends[friendUid] = nil
		
		for k, v in pairs(UserManager:getInstance().friendIds) do 
			if tostring(friendUid) == tostring(v) then
				table.remove(UserManager:getInstance().friendIds, k)
			end
		end
	end
end

function FriendManager:addFriend(friend)
	if friend.uid then 
		self.friends[friend.uid] = friend
	end
end

function FriendManager:getFriendsSnsIdByUid(friendUids)
	local openIds = {}
	if not friendUids or not self.friends then return openIds end

	for i, v in ipairs(friendUids) do 
		local friend = self.friends[tostring(v)]
		if friend and friend.snsId then
			table.insert(openIds, friend.snsId)
		end
	end

	-- print("gameIds:"..table.tostring(friendUids))
	-- print("openIds:"..table.tostring(openIds))
	return openIds
end

function FriendManager:getAppFriendSnsIds(limit)
	local snsIds = {}
	if not self.friends then return snsIds end

	-- print("self.friends="..table.tostring(self.friends))
	local counter = 1
	for uid,v in pairs(self.friends) do
		if limit and counter > limit then
			return snsIds
		elseif v.snsId then
			counter = counter + 1
			table.insert(snsIds, v.snsId)
		end
	end
	return snsIds
end

function FriendManager:getNoneAppFriendSnsIds(limit)
	local snsIds = {}
	for i,v in ipairs(self.noneAppFriends) do
		if limit and i > limit then
			return snsIds
		else
			table.insert(snsIds, v.id)
		end
	end
	return snsIds
end

function FriendManager:getFriendCount()
	local count = 0
	for k, v in pairs(self.friends) do count = count + 1 end
	return count
end
