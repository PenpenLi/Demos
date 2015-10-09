MachineStateImpl = class();
--状态机管理器抽象实现
function MachineStateImpl:ctor()
	self.class = MachineStateImpl;
	self.battleUnit = nil
	self.stateMap = {}
	--当前状态(当前状态永远不能为空)
	self.currentState = nil;
end

function MachineStateImpl:removeSelf()
	self.class = nil;
	self.stateMap = nil
	self.currentState = nil;
	self.battleUnit = nil
end

function MachineStateImpl:dispose()
    self:cleanSelf();
end

function MachineStateImpl:getBattleUnit()
	return self.battleUnit;
end

function MachineStateImpl:update(now)
	self.currentState:onUpdate(now);
end


function MachineStateImpl:switchState(stateEnumState,data1,data2,data3)
	self:_switchState(stateEnumState,data1,data2,data3);
end

function MachineStateImpl:_switchState(stateEnumState,data1,data2,data3)
	if self.battleUnit:isDie() and self.currentState:getStateEnum() ~= StateEnum.BEATTACKED then
		stateEnumState = StateEnum.DEAD;
	end
	local newState = self.stateMap[stateEnumState];
	if not newState then
		return;
	end
	--如果已经处于死亡状态
	if self.currentState:getStateEnum() == StateEnum.DEAD then
		return;
	end

	self.currentState:onExit();--当前状态退出
	newState:setData(data1,data2,data3);
	newState:onBegin(self.battleUnit:getBattleField():getCurrentFrameTime());--新状态开始
	
	self.currentState = newState;--把新状态设置为当前状态
end

function MachineStateImpl:getCurrentState()
	return self.currentState;
end

function MachineStateImpl:setCurrentState(currentState)
	self.currentState = currentState;
	self.currentState:onBegin(self.battleUnit:getBattleField():getCurrentFrameTime());
end