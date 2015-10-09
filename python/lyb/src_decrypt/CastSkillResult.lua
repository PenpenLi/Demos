CastSkillResult = class();

function CastSkillResult:ctor(source,target,fskill,targetNum)
	self.battleField = source:getBattleField();--战场
	self.source = source;--攻击发起者
	self.target = target;--被攻击目标
	self.fskill = fskill;--攻击技能
	self.targetNum = targetNum;--作用目标数量
	self.targetCoordinateX = nil--技能触发击退、击飞目标位置
	self.targetSkillEffects = {};--对目标产生的效果
	self.isCrt = nil--是否暴击
	self.hurt = 0;--攻击受到大伤害
	self.hurtXishu = 100000;--攻击效果(伤害系数)
	self.isHit = true;--是否命中
	self.attackResultType = 0;--攻击结果(暴击....)
	self.beAttackResultType = 0;--被攻击结果(闪避，格挡...)
	--self.beAttackMove = false;--被攻击移动
	self.beJidao = nil -- 是否触发被击倒
end

function CastSkillResult:cleanSelf()
	self.class = nil;
end

function CastSkillResult:dispose()
	self.cleanSelf();
end

function CastSkillResult:isBeJidao()
	return self.beJidao;
end

-- function CastSkillResult:isBeAttackMove()
-- 	return self.beAttackMove;
-- end

function CastSkillResult:getFightSkill()
	return self.fskill;
end

function CastSkillResult:getTargetNum()
	return self.targetNum;
end

function CastSkillResult:getSource()
	return self.source;
end

function CastSkillResult:getTarget()
	return self.target;
end

function CastSkillResult:getBattleField()
	return self.battleField;
end

function CastSkillResult:getSkillConfig()
	return self.fskill:getSkillConfig();
end

function CastSkillResult:isCrt()
	return self.isCrt;
end

function CastSkillResult:setCrt(isCrt)
	self.isCrt = isCrt;
end

function CastSkillResult:isHitF()
	return self.isHit;
end

function CastSkillResult:getTargetSkillEffects()
	return self.targetSkillEffects;
end

-- 计算伤害
function CastSkillResult:compute(distance,attackerSkill,source,currTimes)
	BattleUtils:writelog("cutbefore battleUnitId=" .. self.target:getObjectId() .. " hp=" ..self.target:getCurrHp());
	self.hurt = attackerSkill:isNeedHurt() and BattleFormula:computeHurt3(self,currTimes) or 0;
	--self:triggerSkillBeAttackActionMove(distance,attackerBattleUnit);
	-- 效果
	self:triggerSkillEffect();
	if not self.target:isPlayBeAttackAction(attackerSkill,currTimes) then return end
	-- if not source:getCdTimeManager():isNeedNextDelayTime() then
		local coordinateX = self.target:getCoordinateX() + distance
		coordinateX = self.target:getAttackLastX(coordinateX)
		self.target:setCoordinateX(coordinateX);
	-- end
	
end

function CastSkillResult:getKeWuXing()
	return self.keWuXing
end

function CastSkillResult:setKeWuXing(keWuXing)
	self.keWuXing = keWuXing
end

--技能效果
function CastSkillResult:triggerSkillEffect()
	require("main.controller.command.battleScene.battle.battlefield.skilleffect.EffectFactory")
	for semk,semv in pairs(self.fskill:getSkillConfig():getTargetSkillEffects()) do
		local randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
		-- self.source:getBattleField():addRandomValue(randomValue);
		if randomValue <= tonumber(semv.rate) then
			local effectId = semv:getSkillEffectConfig().id
			local skillEffect = EffectFactory:createSkillEffect(self.fskill:getLevel(), effectId, semv, self.target, self.battleField,self.source);
			self.targetSkillEffects[effectId] = skillEffect
		end
	end
end

function CastSkillResult:getHurtEffectArray()
	local hurtEffectArray = {}
	for key,effect in pairs(self.targetSkillEffects) do
		table.insert(hurtEffectArray,{EffectId = key,EffectValue = effect:getEffectValue()})
	end
	return hurtEffectArray;
end

function CastSkillResult:getTargetCoordinateX()
	return self.targetCoordinateX;
end

function CastSkillResult:setTargetCoordinateX(targetCoordinateX)
	self.targetCoordinateX = targetCoordinateX;
end

function CastSkillResult:getHurt()
	--print("bbbbbbbbbbbself.hurt"..self.hurt)
	return self.hurt;
end

function CastSkillResult:getAttackResultType()
	return self.attackResultType;
end

function CastSkillResult:getBeAttackResultType()
	return self.beAttackResultType;
end

function CastSkillResult:setAttackResultType(attackResultType)
	self.attackResultType = attackResultType;
end

function CastSkillResult:calcOver(beAttactTime,isNeedCheckDead)
	self.source:checkEffectByAttack(self);
	if self.target:getCurrHp() <= 0 then
		-- if isNeedCheckDead then
			self.target:onDie(beAttactTime);
		-- end
		self.source:onkillOne(self.target);
	end
	BattleUtils:writelog("cutover battleUnitId=" .. self.target:getObjectId() .. " hp=" .. self.target:getCurrHp().."\n");
end

-- 发生破击
function CastSkillResult:isWreck()
	if self.attackResultType == BattleConstants.BATTLE_ATTACK_RESULT_TYPE_6 then
		return true;
	end
	return false;
end