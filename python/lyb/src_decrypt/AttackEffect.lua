AttackEffect = class(AbstractSkillEffect);
--增加属性值(持续状态，到时间后会卸载所加的属性)
function AttackEffect:ctor()
	self.class = AttackEffect;
end
function AttackEffect:setAttackCount(targetCnt)
	self.targetCnt = targetCnt or 1;
end

function AttackEffect:cleanSelf()
	self:removeSelf()
end

function AttackEffect:dispose()
    self:cleanSelf();
end

function AttackEffect:doExecute()
	local hurt = self.hurtValue*self.repeatCount;
	self:doHurt(hurt);
	if self.target:getCurrHp()<=0 then
		BattleUtils:sendUpdateHRValue(self.source,0,self.source.killfury);
	end
	if self.isSanBi then
		self.isOverFlg = true;
	end
end

function AttackEffect:doUnExecute()
	
end
--计算伤害数值
function AttackEffect:initData()
	if (self.effectModel:isDamType(BattleConstants.SKILL_EFFECT_DAM_TYPE_1)) then
		self.isSanBi,self.hurtValue,self.isBaoJi,self.isZhuDang = BattleFormula:computeWaigongHurt(self.source,self.target,self.effectModel,self:isContinued());
		--print("innerGetEffectValue  1  ",self:getEffectId(),self.isSanBi,self.hurtValue)
		self.hurtValue = self:indescred()*self.hurtValue;
	elseif (self.effectModel:isDamType(BattleConstants.SKILL_EFFECT_DAM_TYPE_2)) then
		self.isSanBi,self.hurtValue,self.isBaoJi,self.isZhuDang = BattleFormula:computeNeigongHurt(self.source,self.target,self.effectModel, self.targetCnt,self:isContinued());
		--print("innerGetEffectValue  2  ",self:getEffectId(),self.isSanBi,self.hurtValue)
		self.hurtValue = self:indescred()*self.hurtValue;
	else
		self.isSanBi,self.hurtValue = false,0;
	end
end

