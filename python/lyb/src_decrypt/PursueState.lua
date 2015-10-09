PursueState = class(AbstractState);
--追击状态(靠近目标发起攻击)
function PursueState:ctor(battleUnit,machineState)
	self.class = PursueState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
end

function PursueState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function PursueState:dispose()
    self:cleanSelf();
end

function PursueState:getStateEnum()
	return StateEnum.PURSUE;
end

function PursueState:onBegin()
	local newTargetX,newTargetY = BattleFormula:getTargetXYBybtlUnit(self.battleUnit, self.battleUnit:getTarget());
	self.battleUnit:getMoveManager():setTargetX(newTargetX);
	self.battleUnit:getMoveManager():setTargetY(newTargetY-1);--减一可以让深度排序正常
	self.battleUnit:getMoveManager():sendTargetCoordinateXMessage(false);
end

function PursueState:onExit()
	self.battleUnit:getMoveManager():sendCurrentCoordinateXMessage();
end

function PursueState:onUpdate(now)
	if PursueState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end

function PursueState:inneOnUpdate(now)
	if self.battleUnit:getMoveManager():isArrived(now) then
		local target = self.battleUnit:getTarget();
		if not target or target:isDie() then
			if self.battleUnit:reSelectAndAttack() then return end
			local standPos = self.battleUnit.standPositionCcp;
			self.battleUnit:getMoveManager():setTargetX(standPos.x);
			self.battleUnit:getMoveManager():setTargetY(standPos.y);
			self.battleUnit:getMoveManager():sendTargetCoordinateXMessage(true);
		else
			self.machineState:switchState(StateEnum.ATTACK);
		end
	end
end