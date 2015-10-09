IdleState = class(AbstractState);
--空闲状态(寻找可以攻击的目标)
function IdleState:ctor(battleUnit,machineState)
	self.class = IdleState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
end

function IdleState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function IdleState:dispose()
    self:cleanSelf();
end

function IdleState:getStateEnum()
	return StateEnum.IDLE;
end

function IdleState:onBegin(now)
	self.attackQueueManager = self.battleUnit:getBattleField().attackQueueManager
	if self.battleUnit:hasEffectType(BattleConstants.SKILL_EFFECT_TYPE_3002) then
		self.machineState:switchState(StateEnum.FROZEN);
	end
end

function IdleState:onExit()
	
end

function IdleState:onUpdate(now)
	if IdleState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end

function IdleState:inneOnUpdate(now)
	-- if self.attackQueueManager:canAttack(self.battleUnit:getObjectId()) then
	-- 	local skill = self.battleUnit:chooseSkill(now);
	-- 	local target = SelectTargetImpl:getInstance():getSelectEnemyTarget(self.battleUnit,skill:getSkillConfig());
	-- 	if target then
	-- 		self.battleUnit:setTarget(target);
	-- 		self.machineState:switchState(StateEnum.PURSUE);
	-- 	end
	-- end
end