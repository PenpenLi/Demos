FlyAttackState = class(AbstractState);
--攻击状态(选择技能攻击目标)
function FlyAttackState:ctor(battleUnit,machineState)
	self.class = FlyAttackState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
	--self.firstUpdateTime = 0;
	require("main.controller.command.battleScene.battle.battlefield.compute.CastSkillCompute")
	self.hasAttack = false
end

function FlyAttackState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function FlyAttackState:dispose()
    self:cleanSelf();
end

function FlyAttackState:getStateEnum()
	return StateEnum.FLYATTACK;
end

function FlyAttackState:onBegin(now)
	self.attMgr = self.battleUnit:getSelectSkill()
	self:attackBegin(now)
end

function FlyAttackState:beAttackDelay(now)
	self.attMgr:getCDTimeManager():checkBeAttackDelayTime(self.battleUnit,now)
	self.hasBeAttack = nil
end

function FlyAttackState:attackBegin(now)
	self.hasAttack = true
	self.attMgr:updateCDTime(now);
	CastSkillCompute:getInstance():castSkill(self.battleUnit, self.battleUnit:getTarget(), self.attMgr);
	self:beAttackDelay(now)
end

function FlyAttackState:onExit()
	self.hasAttack = false
	self.hasBeAttack = false
	self.attMgr:getCDTimeManager():resertBeAttackDelayTime()
end

function FlyAttackState:setData()

end

function FlyAttackState:onUpdate(now)
	if FlyAttackState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end
--如果攻击完成，动作也播放完，就切换到idle状态
function FlyAttackState:inneOnUpdate(now)
	if not self.attMgr:getCDTimeManager():checkAcationArrived(self.battleUnit,now) then
		if not self.hasBeAttack and self.attMgr:getCDTimeManager():beAttackDelayTimeArrived(now) then --被击
			self.attMgr:makeFlySkill();
			self.hasBeAttack = true
			CastSkillCompute:getInstance():triggerSkillAttackActionMove(self.battleUnit,self.attMgr)
		end
	else
		if self.hasAttack then
			self.machineState:switchState(StateEnum.IDLE);
		end
	end
end
