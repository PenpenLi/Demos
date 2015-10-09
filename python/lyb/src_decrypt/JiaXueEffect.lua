JiaXueEffect = class(AbstractSkillEffect);
--加血（增加当前血量数值，加完之后不会进行卸载）
function JiaXueEffect:ctor()
	self.class = JiaXueEffect;
end

function JiaXueEffect:cleanSelf()
	self:removeSelf()
end

function JiaXueEffect:dispose()
    self:cleanSelf();
end

function JiaXueEffect:doExecute(now)
	BattleUtils:sendUpdateHRValue(self.target,self:innerGetEffectValue(),0);
end

function JiaXueEffect:doUnExecute()

end
function JiaXueEffect:innerGetEffectValue()
	local basicValue = self:getEffectValue();
	local sourceAdd = self.source:getPropertyValue(PropertyType.ZHILIAOZHI);
	local targetAdd = self.target:getPropertyValue(PropertyType.ZHILIAOZHI)/analysis("Xishuhuizong_Gongshicanshubiao", 10,"number");
	print("JiaXueEffect",basicValue,sourceAdd,targetAdd,self.repeatCount,(basicValue+sourceAdd+targetAdd)*self.repeatCount)
	basicValue = basicValue+sourceAdd+targetAdd;
	basicValue = self:indescred()*basicValue*self.repeatCount;
	return math.floor(basicValue);
end