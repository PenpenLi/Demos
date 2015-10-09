AbstractState = class();
--战斗单位状态抽像接口实现
function AbstractState:ctor()
	self.class = AbstractState;
	self.battleUnit = nil;
	self.machineState = nil;
end

function AbstractState:removeSelf()
	self.class = nil;
end

function AbstractState:dispose()
    self:cleanSelf();
end

function AbstractState:setData(data1,data2,data3)
	self.data1 = data1;
	self.data2 = data2;
	self.data3 = data3;
end

function AbstractState:getBeAttackMoveDis()
	return 0
end

function AbstractState:onUpdate(now)
	return true
end
