CDTime = class();
--CD管理器
function CDTime:ctor(cdKey,startTime,coolingTime)
	self.class = CDTime;
	--/** cd键值(技能ID或者物品ID) **/
	self.cdKey = cdKey;
	--/** cd开始时间 **/
	self.startTime = startTime;
	--/** cd冷却时间 **/
	-- print("=======coolingTime=============",coolingTime)
	self.coolingTime = coolingTime;
end

function CDTime:removeSelf()
	self.class = nil;
end

function CDTime:dispose()
    self:removeSelf();
end

function CDTime:getCdKey()
	return self.cdKey;
end

function CDTime:setStartTime(startTime)
	self.startTime = startTime;
end

--是否已经冷却
function CDTime:isArrived(now)
	-- if now == 0 then
	-- 	now = BattleUtils:getOSTime()
	-- end
	-- print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	-- print(self.startTime)
	-- print(self.coolingTime)
	-- print(now - self.startTime)
	-- print((now - self.startTime) >= self.coolingTime)
	return (now - self.startTime) >= self.coolingTime;
end

function CDTime:setCoolingTime(coolingTime)
	-- print("vvvvvvvvvvvvv",coolingTime)
	self.coolingTime = coolingTime;
end

function CDTime:getCoolingTime()
	return self.coolingTime;
end