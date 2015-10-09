CDTimeManager = class();
--cd时间
function CDTimeManager:ctor()
	self.class = CDTimeManager;
	self.cdTimeMap = {}
	self.groupCDTimeMap = {}
end

function CDTimeManager:removeSelf()
	self.class = nil;
end

function CDTimeManager:dispose()
    self:removeSelf();
end

function CDTimeManager:addCDTime(cdKey,now,coolingTime)
	local cdTime = self.cdTimeMap[cdKey];
	if cdTime == nil then
		cdTime = CDTime.new(cdKey, now, coolingTime);
		self.cdTimeMap[cdTime.getCdKey()] = cdTime;
		return;
	}
	cdTime.setStartTime(now);
end

function CDTimeManager:checkCDTimeArrived(cdKey,now)
	local cdTime = self.cdTimeMap[cdKey];
	if cdTime ~= nil then
		return cdTime:isArrived(now);
	end
	return true;
end
