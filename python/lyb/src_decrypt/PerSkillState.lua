PerSkillState = class(AbstractState);
--空闲状态(寻找可以攻击的目标)
function PerSkillState:ctor(battleUnit,machineState)
	self.class = PerSkillState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
end

function PerSkillState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function PerSkillState:dispose()
    self:cleanSelf();
end

function PerSkillState:getStateEnum()
	return StateEnum.PERSKILL;
end

function PerSkillState:onBegin()
end

function PerSkillState:onExit()
	
end

function PerSkillState:onUpdate(now)
	if PerSkillState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end

function PerSkillState:inneOnUpdate(now)

end