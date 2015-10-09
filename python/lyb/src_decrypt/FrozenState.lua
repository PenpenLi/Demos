FrozenState = class(AbstractState);
--空闲状态(寻找可以攻击的目标)
function FrozenState:ctor(battleUnit,machineState)
	self.class = FrozenState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
end

function FrozenState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function FrozenState:dispose()
    self:cleanSelf();
end

function FrozenState:getStateEnum()
	return StateEnum.FROZEN;
end

function FrozenState:onBegin(now)
	self.battleUnit:onFrozen();
end

function FrozenState:onExit()
	
end

function FrozenState:onUpdate(now)
	if FrozenState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end

function FrozenState:inneOnUpdate(now)

end