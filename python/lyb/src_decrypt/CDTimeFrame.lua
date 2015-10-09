CDTimeFrame = class();
--CD管理器
function CDTimeFrame:ctor(cdKey,startTime,coolingTime)
	self.class = CDTimeFrame;
	--/** cd键值(技能ID或者物品ID) **/
	self.cdKey = cdKey;
	--/** cd开始时间 **/
	self.startTime = startTime;
	--/** cd冷却时间 **/
	-- print("=======coolingTime=============",coolingTime)
	if coolingTime then
		self.coolingTimeFrame = coolingTime/(GameConfig.Game_FreamRate*1000);
	end
end

function CDTimeFrame:removeSelf()
	self.class = nil;
end

function CDTimeFrame:dispose()
    self:removeSelf();
end

function CDTimeFrame:getCdKey()
	return self.cdKey;
end

function CDTimeFrame:setStartTime(startTime)
	self.startTime = startTime;
end

--是否已经冷却
function CDTimeFrame:isArrived(now)
	-- if now == 0 then
	-- 	now = BattleUtils:getOSTime()
	-- end
	-- print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	-- print(self.startTime)
	-- print(self.coolingTime)
	-- print(now - self.startTime)
	-- print((now - self.startTime) >= self.coolingTime)
	self.coolingTimeFrame = self.coolingTimeFrame - 1 
	return self.coolingTimeFrame <= 0;
end

function CDTimeFrame:setCoolingTime(coolingTime)
	-- print("vvvvvvvvvvvvv",coolingTime)
	self.coolingTimeFrame = coolingTime/(GameConfig.Game_FreamRate*1000);
end

function CDTimeFrame:getCoolingTime()
	return self.coolingTime;
end