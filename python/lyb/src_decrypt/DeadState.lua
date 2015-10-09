DeadState = class(AbstractState);
--死亡状态(死亡后处理尸体)
function DeadState:ctor(battleUnit,machineState)
	self.class = DeadState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
end

function DeadState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function DeadState:dispose()
    self:cleanSelf();
end

function DeadState:getStateEnum()
	return StateEnum.DEAD;
end

function DeadState:setData()
end

function DeadState:onBegin(now)
	self.battleUnit.myTeam:removeDeadBattleUnit(self.battleUnit);
end

function DeadState:onExit()
end

function DeadState:onUpdate(now)
	if DeadState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end


function DeadState:inneOnUpdate(now)
end