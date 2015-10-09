PassiveSkillTriggerFive = class(AbstractPassiveSkillTrigger);
--被击触发
function PassiveSkillTriggerFive:ctor()
	self.class = PassiveSkillTriggerFive;
end

function PassiveSkillTriggerFive:cleanSelf()
	self:removeSelf()
end

function PassiveSkillTriggerFive:dispose()
    self:cleanSelf();
end

function PassiveSkillTriggerFive:addBuffer(battleUnit)
	EffectFactory:createSkillEffect(1, model:getSkillEffectConfig():getId(), model, battleUnit, battleUnit:getBattleField());
end
