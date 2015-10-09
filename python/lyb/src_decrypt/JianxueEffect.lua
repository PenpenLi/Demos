JianxueEffect = class(AbstractSkillEffect);
--减少自己血量当前血量(按数值)
function JianxueEffect:ctor()
	self.class = JianxueEffect;
end

function JianxueEffect:cleanSelf()
	self:removeSelf()
end

function JianxueEffect:dispose()
    self:cleanSelf();
end

function JianxueEffect:doExecute()
	BattleUtils:sendUpdateHRValue(self.target,self:innerGetEffectValue(),0);
end

function JianxueEffect:doUnExecute() 

end
function JianxueEffect:innerGetEffectValue()
	local basicValue = self:indescred()*self:getEffectValue()*self.repeatCount;
	return basicValue;
end