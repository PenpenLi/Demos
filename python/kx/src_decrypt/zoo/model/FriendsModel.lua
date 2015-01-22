
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年08月26日 10:26:56
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com


---------------------------------------------------
-------------- FriendsModel
---------------------------------------------------

FriendsModel = class()

function FriendsModel:ctor()
end

function FriendsModel:init(...)
	assert(#{...} == 0)

	
end
function FriendsModel:getAllFriends()
end
function FriendsModel:getFriendsExcludeSelf()
	-- Not Implemented
	assert(false)
end
function FriendsModel:getAllFriendsIds()
	-- Not Implemented
	assert(false)
end
function FriendsModel:getFriendByUserId(userID)
	-- Not Implemented
	assert(false)
end
function FriendsModel:isAppFriends(userID)
	-- Not Implemented
	assert(false)
end
function FriendsModel:getFriendsByTopLevel(topLevel)
	-- Not Implemented
	assert(false)
end
function FriendsModel:setAllFriends(friends)
	-- Not Implemented
	assert(false)
end
function FriendsModel:getFriendsLowALevel(level)
	-- Not Implemented
	assert(false)
end

function FriendsModel:getGroupCount()
	-- Not Implemented
	assert(false)
end
function FriendsModel:setGroupCount(value)
	-- Not Implemented
	assert(false)
end
function FriendsModel:setGroupMenber(value)
	-- Not Implemented
	assert(false)
end
function FriendsModel:getGroupMenber()
	-- Not Implemented
	assert(false)
end
function FriendsModel:setGroupIDs(value)
	-- Not Implemented
	assert(false)
end
function FriendsModel:getGroupIDs()
	-- Not Implemented
	assert(false)
end

