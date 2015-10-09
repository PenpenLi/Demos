JXMaxPerEffect = class(AbstractSkillEffect);
--减少自己血量当前血量(按百分比)
function JXMaxPerEffect:ctor()
	self.class = JXMaxPerEffect;
end

function JXMaxPerEffect:cleanSelf()
	self:removeSelf()
end

function JXMaxPerEffect:dispose()
    self:cleanSelf();
end

function JXMaxPerEffect:doExecute(now)
	local value = self:innerGetEffectValue();
	self:doHurt(value);
	if value+self.target:getCurrHp()<=0 then
		BattleUtils:sendUpdateHRValue(self.source,0,self.source.killfury);
	end
end

function JXMaxPerEffect:doUnExecute()
end
--计算伤害数值
function JXMaxPerEffect:innerGetEffectValue()
	local basicValue = math.floor(self.target:getMaxHP()*self.effectModel:getPersent()/BattleConstants.HUNDRED_THOUSAND);
	basicValue = basicValue*self:indescred()*self.repeatCount;
	return basicValue;
end