PassiveSkillTriggerZero = class(AbstractPassiveSkillTrigger);
--永久buff类,会影响战力
function PassiveSkillTriggerZero:ctor()
	self.class = PassiveSkillTriggerZero;
end

function PassiveSkillTriggerZero:cleanSelf()
	self:removeSelf()
end

function PassiveSkillTriggerZero:dispose()
    self:cleanSelf();
end

function PassiveSkillTriggerZero:calcPropertyAddition()
	local map = {};
	for k1,model in pairs(self.skillConfig:getSkillEffects()) then
		local propertyType = model:getSkillEffectConfig():getProperty();
		if propertyType > 0 then
			map[propertyType] = model:getValue();
		end
	end
	return map;
end

function PassiveSkillTriggerZero:innerInstallEffect()
end
