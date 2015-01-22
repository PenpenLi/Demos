
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年11月28日 16:43:12
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com


---------------------------------------------------
-------------- IsLockedCloudCanOpenLogic
---------------------------------------------------

IsLockedCloudCanWaitToOpenLogic = class()


function IsLockedCloudCanWaitToOpenLogic:init(lockedCloudId, ...)
	assert(type(lockedCloudId) == "number")
	assert(#{...} == 0)

	self.lockedCloudId = lockedCloudId
end

function IsLockedCloudCanWaitToOpenLogic:start(...)
	assert(#{...} == 0)

	-- If User's Top Level Is One Level Before Cur Lock Area's Start Level
	-- And User's TOp Level Has Star ( Means User Complete That Level )
	-- Then Is The Time To Show Lock 
	
	-- Get User Top Level
	local topLevelId	= UserManager.getInstance().user:getTopLevelId()
	assert(topLevelId)

	-- Get User Top Level Star
	local topLevelStar	= UserManager.getInstance():getUserScore(topLevelId)

	-- Get Locked Cloud Start Level Id
	local curLevelAreaData	= MetaModel:sharedInstance():getLevelAreaDataById(self.lockedCloudId)
	local curStartNodeId	= tonumber(curLevelAreaData.minLevel)
	assert(curStartNodeId)

	if topLevelId == curStartNodeId - 1 and topLevelStar ~= nil and topLevelStar.star > 0 then
		return true
	end

	return false
		
end

function IsLockedCloudCanWaitToOpenLogic:create(lockedCloudId, ...)
	assert(type(lockedCloudId) == "number")
	assert(#{...} == 0)

	local newIsLockedCloudCanOpenLogic = IsLockedCloudCanWaitToOpenLogic.new()
	newIsLockedCloudCanOpenLogic:init(lockedCloudId)
	return newIsLockedCloudCanOpenLogic
end

