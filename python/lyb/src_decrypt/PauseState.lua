PauseState = class(AbstractState);
--暂停状态
function PauseState:ctor(battleUnit,machineState)
	self.class = PauseState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
end

function PauseState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function PauseState:dispose()
    self:cleanSelf();
end

function PauseState:getStateEnum()
	return StateEnum.PAUSE;
end

function PauseState:onBegin()
end

function PauseState:onUpdate(now)
	if PauseState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end

function PauseState:onExit()
end

function PauseState:inneOnUpdate(now)
end