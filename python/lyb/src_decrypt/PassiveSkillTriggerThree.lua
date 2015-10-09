PassiveSkillTriggerThree = class(AbstractPassiveSkillTrigger);
--战场时间触发
function PassiveSkillTriggerThree:ctor()
	self.class = PassiveSkillTriggerThree;
end

function PassiveSkillTriggerThree:cleanSelf()
	self:removeSelf()
end

function PassiveSkillTriggerThree:dispose()
    self:cleanSelf();
end

function PassiveSkillTriggerThree:innerInstallEffect(battleUnit,model)
end
