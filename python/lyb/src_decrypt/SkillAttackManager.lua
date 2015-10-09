SkillAttackManager = class()
function SkillAttackManager:ctor(caster,skill,isEffctSkill)
	self.caster = caster;
	self.skill = skill;
	self.selectIdArr={};
	self.selectTargetArr = {}
	self.startMoveX = nil
	require("main.controller.command.battleScene.battle.battlefield.compute.SelectTargetImpl")
	self.selectAttackTargetsFun = SelectTargetImpl:getInstance():getSelectTargetFun(skill);
	if skill.typyP==4 then isEffctSkill = true end
	if not isEffctSkill then
		require("main.controller.command.battleScene.battle.battlefield.skillConfig.SkillActionConfig")
		self.actionConfig = SkillActionConfig.new(skill.id);
	end
	require("main.controller.command.battleScene.battle.battlefield.skillConfig.SkillCDTimeManager");
	self.cdTimeManager = SkillCDTimeManager.new();
	require("main.controller.command.battleScene.battle.battlefield.skillConfig.SkillConfig")
	self.skillConfig = SkillConfig.new(self.skill);
	self:fillEffectData();
	self.selectTeam=nil;--卡片技能用
end
function SkillAttackManager:removeSelf()
	self.class = nil;
end

function SkillAttackManager:dispose()
	self.selectTargetFun = nil;
	self.selectIdArr = nil;
	self.updataAttackFun = nil;
	self.selectTargetArr = nil;
	self.cdTimeManager = nil;
	self.selectTeam = nil;
    self:removeSelf();
end
function SkillAttackManager:startCDTime()
	local now  = self.caster:getBattleField():getCurrentTime();
	self.cdTimeManager:initFirstCDTime(self,now,self.skill.FristCD);
end
function SkillAttackManager:updateCDTime(now,addStopSKillTime)
	self.cdTimeManager:updateCDTime(self.caster, self, now, addStopSKillTime);
end
function SkillAttackManager:getCDTimeManager()
	return self.cdTimeManager;
end
function SkillAttackManager:getActionConfig()
	return self.actionConfig;
end
function SkillAttackManager:getSkillConfig()
	return self.skillConfig;
end
function SkillAttackManager:getSkill()
	return self.skill;
end
function SkillAttackManager:isFlySkill()
	if not self.actionConfig then 
		return false 
	else
		return self.actionConfig:isFlySkill();
	end
end
function SkillAttackManager:getSelectTarget()
	return SelectTargetImpl:getInstance():getSelectEnemyTarget(self.caster,self.skill);
end
function SkillAttackManager:getAttackTargets()
	return self.selectAttackTargetsFun(self.caster);
end
function SkillAttackManager:makeFlySkill()
	local battlefield = self.caster:getBattleField();
	battlefield:getFlyUniList():sendBorenMessage(self.skill.id,self.caster,self.caster:getTarget());
end
function SkillAttackManager:updataAttack()
	local targets = self.selectAttackTargetsFun(self.caster);
	local nTargets = {};
	for k,v in pairs(targets) do
		if not v:hasEffectType(BattleConstants.SKILL_EFFECT_TYPE_3006) then
			table.insert(nTargets,v);
		end
	end
	local hitMpm = BattleFormula:stateBeAttack(self.caster,nTargets,self);
	CastSkillCompute:getInstance():castSkillBeAttack(self.caster,self,hitMpm);
end
function SkillAttackManager:getEffect(effectId)
	return self.skillConfig:getTargetSkillEffect(effectId);
end
function SkillAttackManager:fillEffectData()
	require("main.controller.command.battleScene.battle.battlefield.skilleffect.SkillEffectModel")
	local effectList = self.skillConfig:getEffectList();
	local effectPercentList = self.skillConfig:getEffectPercentList();
	if not effectList or effectList[1] == "0" then return;end
	for j = 1,#effectList do
		local id = tonumber(effectList[j]);
		if id > 0 then
			local skillEffect = SkillEffectModel.new(self.skill.level,self.skill.id,id,effectPercentList[j]);
			self.skillConfig:setTargetSkillEffects(skillEffect);
		end
	end
end
function SkillAttackManager:isCDTimeArrived()
	local now  = self.caster:getBattleField():getCurrentTime();
	return self.cdTimeManager:checkCDTimeArrived(now)
end
function SkillAttackManager:canUseSkill(useType)
	if self:getSkill().typyP < 2 
		or self:getSkill().typyP > useType
		or not self:isCDTimeArrived()
		or self:getSkill().xiaoHao > self.caster:getCurrRage() then
		return false;
	else
		return true;
	end
end