JiaXuePercentEffect = class(AbstractSkillEffect);
--百分比加血
function JiaXuePercentEffect:ctor()
	self.class = JiaXuePercentEffect;
end

function JiaXuePercentEffect:cleanSelf()
	self:removeSelf()
end

function JiaXuePercentEffect:dispose()
    self:cleanSelf();
end

function JiaXuePercentEffect:doExecute(now)
	local propertyManager = self.target.propertyManager;
	local maxHp = self.target:getMaxHP();
	local addHp = math.floor(maxHp * self:getEffectValue() / BattleConstants.HUNDRED_THOUSAND)*self:indescred()*self.repeatCount;
	BattleUtils:sendUpdateHRValue(self.target,addHp,0);
end

function JiaXuePercentEffect:doUnExecute()
end
