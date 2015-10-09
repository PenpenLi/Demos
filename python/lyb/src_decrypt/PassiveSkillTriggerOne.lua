PassiveSkillTriggerOne = class(AbstractPassiveSkillTrigger);
--进入战场前的buff
function PassiveSkillTriggerOne:ctor()
	self.class = PassiveSkillTriggerOne;
end

function PassiveSkillTriggerOne:cleanSelf()
	self:removeSelf()
end

function PassiveSkillTriggerOne:dispose()
    self:cleanSelf();
end

function PassiveSkillTriggerOne:addBuffer(battleUnit)
	for k1,model in pairs(self.skillConfig:getSkillEffects()) then
		local propertyType = model:getSkillEffectConfig():getProperty();
		if propertyType > 0 {
			battleUnit:getPropertyManager():addIntValue(propertyType, model:getValue());
		end
	end
end

function PassiveSkillTriggerOne:innerInstallEffect()
end

