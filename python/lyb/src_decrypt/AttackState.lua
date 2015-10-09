AttackState = class(AbstractState);
--攻击状态(选择技能攻击目标)
function AttackState:ctor(battleUnit,machineState)
	self.class = AttackState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
	--self.firstUpdateTime = 0;
	require("main.controller.command.battleScene.battle.battlefield.compute.CastSkillCompute")
	self.hasAttack = false
end

function AttackState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function AttackState:dispose()
    self:cleanSelf();
end

function AttackState:getStateEnum()
	return StateEnum.ATTACK;
end

function AttackState:onBegin(now)
	self.attMgr = self.battleUnit:getSelectSkill()
	self:attackBegin(now)
end

function AttackState:beAttackDelay(now)
	self.attMgr:getCDTimeManager():checkBeAttackDelayTime(self.battleUnit,now)
	self.hasBeAttack = nil
end

function AttackState:attackBegin(now)
	self.hasAttack = true
	self.attMgr:updateCDTime(now);
	--self.battleUnit:afterCastSkill(now);
	--通知客户端开始释放技能
	CastSkillCompute:getInstance():castSkill(self.battleUnit, self.battleUnit:getTarget(), self.attMgr);
	self:beAttackDelay(now)
end

function AttackState:onExit()
	self.hasAttack = false
	self.hasBeAttack = false
	self.attMgr:getCDTimeManager():resertBeAttackDelayTime()
end

function AttackState:setData()

end

function AttackState:onUpdate(now)
	if AttackState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end
--如果攻击完成，动作也播放完，就切换到idle状态
function AttackState:inneOnUpdate(now)
	if self.battleUnit.effectManager:hasEffect(BattleConstants.SKILL_EFFECT_ID_35) then--眩晕
		self.machineState:switchState(StateEnum.IDLE);
		return;
	end
	if not self.attMgr:getCDTimeManager():checkAcationArrived(self.battleUnit,now) then
		--被击
		if not self.hasBeAttack and self.attMgr:getCDTimeManager():beAttackDelayTimeArrived(now) then
			self.attMgr:updataAttack();
			self.hasBeAttack = true
			if self.attMgr:getCDTimeManager():isNeedNextDelayTime(true) then
				self:beAttackDelay(now)
			else
				CastSkillCompute:getInstance():triggerSkillAttackActionMove(self.battleUnit,self.attMgr)
			end
		end
		return
	else
		if not self.hasBeAttack then--容错，防被击时间过长
			self.attMgr:updataAttack();
			self.hasBeAttack = true
			CastSkillCompute:getInstance():triggerSkillAttackActionMove(self.battleUnit,self.attMgr)
			return
		end
		if self.hasAttack then
			local standPos = self.battleUnit.standPositionCcp;
			self.battleUnit:getMoveManager():setTargetX(standPos.x);
			self.battleUnit:getMoveManager():setTargetY(standPos.y);
			self.battleUnit:getMoveManager():sendTargetCoordinateXMessage(true);
		end
	end
end
