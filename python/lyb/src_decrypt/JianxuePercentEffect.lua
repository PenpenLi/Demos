JianxuePercentEffect = class(AbstractSkillEffect);
--减少自己血量当前血量(按百分比)
function JianxuePercentEffect:ctor()
	self.class = JianxuePercentEffect;
end

function JianxuePercentEffect:cleanSelf()
	self:removeSelf()
end

function JianxuePercentEffect:dispose()
    self:cleanSelf();
end

function JianxuePercentEffect:doExecute(now)
	local value = self:innerGetEffectValue();
	self:doHurt(value);
	if value+self.target:getCurrHp()<=0 then
		BattleUtils:sendUpdateHRValue(self.source,0,self.source.killfury);
	end
end

function JianxuePercentEffect:doUnExecute()
end
function JianxuePercentEffect:innerGetEffectValue()
	local basicValue = math.floor(self.target:getCurrHp()*self.effectModel:getPersent()/BattleConstants.HUNDRED_THOUSAND)*self.repeatCount;
	basicValue = self:indescred()*basicValue;
	return basicValue;
end