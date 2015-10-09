BeAttackState = class(AbstractState);
--被攻击状态
function BeAttackState:ctor(battleUnit,machineState)
	self.class = BeAttackState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
	self.hasBeAttack = false
	require("main.controller.command.battleScene.battle.battlefield.skillConfig.SkillCDTimeManager");
	self.cdTimeManager = SkillCDTimeManager.new();
end

function BeAttackState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function BeAttackState:dispose()
    self:cleanSelf();
end

function BeAttackState:getStateEnum()
	return StateEnum.BEATTACKED;
end

function BeAttackState:onBegin(now)
	self.cdTimeManager:checkBeAttackTime(self.battleUnit,now,self.beAttactTime)
end

function BeAttackState:onExit()
	self.hasBeAttack = false
end

function BeAttackState:onUpdate(now)
	if BeAttackState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end

function BeAttackState:setData(beAttactTime,perState)
	self.beAttactTime = beAttactTime;
	self.perState = perState;
end

function BeAttackState:inneOnUpdate(now)
	if self.cdTimeManager:beAttackTimeArrived(now) then
		if self.battleUnit:isDie() then
			self.machineState:switchState(StateEnum.DEAD);

		else
			self.machineState:switchState(self.perState);
		end
	end
end