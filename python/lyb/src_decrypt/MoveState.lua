MoveState = class(AbstractState);
--逃跑状态(跑到指定的目标点,后切换为空闲状态)
function MoveState:ctor(battleUnit,machineState)
	self.class = MoveState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
end

function MoveState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function MoveState:dispose()
    self:cleanSelf();
end

function MoveState:getStateEnum()
	return StateEnum.MOVE;
end

function MoveState:onBegin()
end

function MoveState:onExit()
	self.battleUnit:getMoveManager():sendCurrentCoordinateXMessage();
end

function MoveState:onUpdate(now)
	if MoveState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end

function MoveState:inneOnUpdate(now)
	if self.battleUnit:getMoveManager():isArrived(now) then
			self.machineState:switchState(StateEnum.IDLE);
	end
end