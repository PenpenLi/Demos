PassiveSkillTriggerFour = class(AbstractPassiveSkillTrigger);
--攻击触发
function PassiveSkillTriggerFour:ctor()
	self.class = PassiveSkillTriggerFour;
end

function PassiveSkillTriggerFour:cleanSelf()
	self:removeSelf()
end

function PassiveSkillTriggerFour:dispose()
    self:cleanSelf();
end

function PassiveSkillTriggerFour:innerInstallEffect(battleUnit,model)
	EffectFactory:createSkillEffect(1, model:getSkillEffectConfig():getId(), model, battleUnit, battleUnit:getBattleField());
end
