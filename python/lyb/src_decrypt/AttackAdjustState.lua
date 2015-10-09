AttackAdjustState = class(AbstractState);
--空闲状态(寻找可以攻击的目标)
function AttackAdjustState:ctor(battleUnit,machineState)
	self.class = AttackAdjustState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
	require("main.controller.command.battleScene.battle.battlefield.compute.SelectTargetImpl")
end

function AttackAdjustState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function AttackAdjustState:dispose()
    self:cleanSelf();
end

function AttackAdjustState:getStateEnum()
	return StateEnum.ADJUST;
end

function AttackAdjustState:onBegin()
end

function AttackAdjustState:onExit()
	
end

function AttackAdjustState:onUpdate(now)
	if AttackAdjustState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end

function AttackAdjustState:inneOnUpdate(now)
	self.machineState:switchState(StateEnum.IDLE);
end